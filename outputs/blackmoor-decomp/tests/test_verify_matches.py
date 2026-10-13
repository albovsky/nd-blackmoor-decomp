import contextlib
import hashlib
import importlib.util
import io
import json
import struct
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "verify_matches.py"
SPEC = importlib.util.spec_from_file_location("verify_matches", SCRIPT)
assert SPEC and SPEC.loader
verify_matches = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_matches)


def make_pe(
    payload: bytes,
    virtual_size: int | None = None,
    raw_size: int = 0x200,
    base_reloc_words: list[int] | None = None,
) -> bytes:
    """Build the smallest PE32 image accepted by the verifier."""

    pe_offset = 0x80
    raw_pointer = 0x200
    optional_size = 0xE0
    reloc_offset = 0x20
    reloc_words = [] if base_reloc_words is None else base_reloc_words
    reloc_size = 8 + len(reloc_words) * 2 if reloc_words else 0
    minimum_virtual_size = reloc_offset + reloc_size
    virtual_size = max(len(payload), minimum_virtual_size) if virtual_size is None else virtual_size

    image = bytearray(raw_pointer)
    image[:2] = b"MZ"
    struct.pack_into("<I", image, 0x3C, pe_offset)
    image[pe_offset : pe_offset + 4] = b"PE\0\0"
    struct.pack_into(
        "<HHIIIHH",
        image,
        pe_offset + 4,
        0x014C,
        1,
        0,
        0,
        0,
        optional_size,
        0x010F,
    )

    optional_offset = pe_offset + 4 + 20
    optional = bytearray(optional_size)
    struct.pack_into("<H", optional, 0, 0x010B)
    struct.pack_into("<I", optional, 28, 0x00400000)
    struct.pack_into("<I", optional, 32, 0x1000)
    struct.pack_into("<I", optional, 36, 0x200)
    struct.pack_into("<I", optional, 56, 0x2000)
    struct.pack_into("<I", optional, 60, raw_pointer)
    struct.pack_into("<I", optional, 92, 16)
    if reloc_size:
        struct.pack_into("<II", optional, 96 + 5 * 8, 0x1000 + reloc_offset, reloc_size)
    image[optional_offset : optional_offset + optional_size] = optional

    section_offset = optional_offset + optional_size
    section = bytearray(40)
    section[:8] = b".text\0\0\0"
    struct.pack_into(
        "<IIIIIIHHI",
        section,
        8,
        virtual_size,
        0x1000,
        raw_size,
        raw_pointer,
        0,
        0,
        0,
        0,
        0x60000020,
    )
    image[section_offset : section_offset + 40] = section
    image.extend(payload)
    image.extend(b"\0" * (raw_size - len(payload)))
    if reloc_size:
        relocation_data = struct.pack("<II", 0x1000, reloc_size)
        relocation_data += b"".join(struct.pack("<H", word) for word in reloc_words)
        image[raw_pointer + reloc_offset : raw_pointer + reloc_offset + reloc_size] = relocation_data
    return bytes(image)


def make_coff(
    payload: bytes,
    symbol: str,
    symbol_value: int = 0,
    machine: int = 0x014C,
    relocation_offset: int | None = None,
) -> bytes:
    """Build a one-section i386 COFF object with one named symbol."""

    section_offset = 20
    raw_pointer = section_offset + 40
    relocation_count = 1 if relocation_offset is not None else 0
    relocation_pointer = raw_pointer + len(payload)
    symbol_pointer = relocation_pointer + relocation_count * 10

    if len(symbol.encode("latin-1")) <= 8:
        symbol_field = symbol.encode("latin-1").ljust(8, b"\0")
        string_table = struct.pack("<I", 4)
    else:
        symbol_field = b"\0\0\0\0" + struct.pack("<I", 4)
        string_data = symbol.encode("latin-1") + b"\0"
        string_table = struct.pack("<I", 4 + len(string_data)) + string_data

    output = bytearray(symbol_pointer + 18 + len(string_table))
    struct.pack_into(
        "<HHIIIHH",
        output,
        0,
        machine,
        1,
        0,
        symbol_pointer,
        1,
        0,
        0,
    )
    section = bytearray(40)
    section[:8] = b".text\0\0\0"
    struct.pack_into(
        "<IIIIIIHHI",
        section,
        8,
        0,
        0,
        len(payload),
        raw_pointer,
        relocation_pointer,
        0,
        relocation_count,
        0,
        0x60500020,
    )
    output[section_offset : section_offset + 40] = section
    output[raw_pointer : raw_pointer + len(payload)] = payload
    if relocation_offset is not None:
        struct.pack_into("<IIH", output, relocation_pointer, relocation_offset, 0, 0x0006)

    symbol_offset = symbol_pointer
    output[symbol_offset : symbol_offset + 8] = symbol_field
    struct.pack_into("<IhHBB", output, symbol_offset + 8, symbol_value, 1, 0x20, 2, 0)
    output[symbol_pointer + 18 : symbol_pointer + 18 + len(string_table)] = string_table
    return bytes(output)


def write_manifest(
    directory: Path,
    original: Path,
    object_path: Path,
    *,
    rva: int = 0x1000,
    size: int = 4,
    symbol: str = "_blackmoor",
    source: str = "independently compiled i386 COFF candidate",
    functions: list[dict[str, object]] | None = None,
) -> Path:
    if functions is None:
        functions = [
            {
                "rva": rva,
                "size": size,
                "symbol": symbol,
                "object": object_path.name,
            }
        ]
    manifest = {
        "description": "Strict byte match manifest for recovered functions",
        "source": source,
        "original_sha256": hashlib.sha256(original.read_bytes()).hexdigest(),
        "functions": functions,
    }
    path = directory / "matches.json"
    path.write_text(json.dumps(manifest), encoding="utf-8")
    return path


class VerifyMatchesTests(unittest.TestCase):
    def test_exact_match_uses_string_table_and_counts_only_matching_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "recovered.obj"
            payload = b"\x55\x8b\xec\xc3"
            original.write_bytes(make_pe(payload))
            candidate.write_bytes(make_coff(payload, "long_recovered_function"))
            manifest = write_manifest(
                directory,
                original,
                candidate,
                symbol="long_recovered_function",
            )

            report = verify_matches.verify(original, manifest)

            self.assertTrue(report["all_byte_ranges_exact"])
            self.assertEqual(report["function_completeness"], "unverified")
            self.assertEqual(report["exact_byte_range_count"], 1)
            self.assertEqual(report["exact_byte_range_bytes"], len(payload))
            self.assertEqual(report["difference_count"], 0)
            self.assertEqual(report["functions"][0]["status"], "exact-byte-range")
            self.assertEqual(report["functions"][0]["match_scope"], "manifest-selected-byte-range")
            self.assertEqual(report["functions"][0]["function_completeness"], "unverified")

    def test_prefix_match_is_explicitly_incomplete(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "prefix.obj"
            original.write_bytes(make_pe(b"ABCD"))
            candidate.write_bytes(make_coff(b"AB", "_blackmoor"))
            manifest = write_manifest(directory, original, candidate, size=2)

            report = verify_matches.verify(original, manifest)

            self.assertTrue(report["all_byte_ranges_exact"])
            self.assertEqual(report["exact_byte_range_bytes"], 2)
            self.assertEqual(report["function_completeness"], "unverified")
            self.assertEqual(report["functions"][0]["status"], "exact-byte-range")
            self.assertEqual(report["functions"][0]["size"], 2)

    def test_mismatch_reports_byte_differences_and_does_not_count_bytes_as_matches(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "recovered.obj"
            original.write_bytes(make_pe(b"ABCD"))
            candidate.write_bytes(make_coff(b"ABXD", "_blackmoor"))
            manifest = write_manifest(directory, original, candidate)

            report = verify_matches.verify(original, manifest)

            function = report["functions"][0]
            self.assertFalse(report["all_byte_ranges_exact"])
            self.assertEqual(report["exact_byte_range_count"], 0)
            self.assertEqual(report["exact_byte_range_bytes"], 0)
            self.assertEqual(report["mismatch_count"], 1)
            self.assertEqual(report["mismatch_bytes"], 4)
            self.assertEqual(report["difference_count"], 1)
            self.assertEqual(function["status"], "byte-range-mismatch")
            self.assertEqual(function["differences"], [{"offset": 2, "expected": "43", "actual": "58"}])

    def test_relocation_overlapping_candidate_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "relocated.obj"
            original.write_bytes(make_pe(b"ABCD"))
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor", relocation_offset=2))
            manifest = write_manifest(directory, original, candidate)

            report = verify_matches.verify(original, manifest)

            self.assertEqual(report["rejected_count"], 1)
            self.assertEqual(report["functions"][0]["status"], "rejected")
            self.assertIn("relocation overlaps", report["functions"][0]["error"])
            self.assertEqual(report["exact_byte_range_bytes"], 0)

    def test_original_high_low_and_highadj_relocations_are_rejected(self) -> None:
        cases = (
            ("HIGH", [0x1000], 0x1000, b"AB"),
            ("LOW", [0x2002], 0x1002, b"CD"),
            ("HIGHADJ", [0x4000, 0x1234], 0x1000, b"AB"),
        )
        for name, words, rva, candidate_bytes in cases:
            with self.subTest(name=name), tempfile.TemporaryDirectory() as temporary:
                directory = Path(temporary)
                original = directory / "GAME.EXE"
                candidate = directory / "candidate.obj"
                original.write_bytes(make_pe(b"ABCD", base_reloc_words=words))
                candidate.write_bytes(make_coff(candidate_bytes, "_blackmoor"))
                manifest = write_manifest(directory, original, candidate, rva=rva, size=2)

                report = verify_matches.verify(original, manifest)

                self.assertEqual(report["rejected_count"], 1)
                self.assertIn("relocation overlaps", report["functions"][0]["error"])

    def test_malformed_highadj_and_unsupported_base_relocations_are_rejected(self) -> None:
        for words, expected_error in (([0x4000], "HIGHADJ"), ([0x5000], "unsupported")):
            with self.subTest(words=words), tempfile.TemporaryDirectory() as temporary:
                directory = Path(temporary)
                original = directory / "GAME.EXE"
                candidate = directory / "candidate.obj"
                original.write_bytes(make_pe(b"ABCD", base_reloc_words=words))
                candidate.write_bytes(make_coff(b"ABCD", "_blackmoor"))
                manifest = write_manifest(directory, original, candidate)

                report = verify_matches.verify(original, manifest)

                self.assertIn(expected_error, report["error"])

    def test_duplicate_original_rva_entries_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "candidate.obj"
            original.write_bytes(make_pe(b"ABCDEFGH"))
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor"))
            manifest = write_manifest(
                directory,
                original,
                candidate,
                functions=[
                    {"rva": 0x1000, "size": 4, "symbol": "_blackmoor", "object": candidate.name},
                    {"rva": 0x1000, "size": 4, "symbol": "_blackmoor", "object": candidate.name},
                ],
            )

            report = verify_matches.verify(original, manifest)

            self.assertIn("overlaps", report["error"])
            self.assertEqual(report["function_count"], 0)

    def test_partially_overlapping_original_rva_entries_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            first = directory / "first.obj"
            second = directory / "second.obj"
            original.write_bytes(make_pe(b"ABCDEFGH"))
            first.write_bytes(make_coff(b"ABCD", "_first"))
            second.write_bytes(make_coff(b"CDEF", "_second"))
            manifest = write_manifest(
                directory,
                original,
                first,
                functions=[
                    {"rva": 0x1000, "size": 4, "symbol": "_first", "object": first.name},
                    {"rva": 0x1002, "size": 4, "symbol": "_second", "object": second.name},
                ],
            )

            report = verify_matches.verify(original, manifest)

            self.assertIn("overlaps", report["error"])
            self.assertEqual(report["function_count"], 0)

    def test_truncated_original_is_a_global_parse_error(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "truncated.exe"
            candidate = directory / "candidate.obj"
            original.write_bytes(b"MZ")
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor"))
            manifest = write_manifest(directory, original, candidate)

            report = verify_matches.verify(original, manifest)

            self.assertFalse(report["all_byte_ranges_exact"])
            self.assertIn("truncated PE header offset", report["error"])
            self.assertEqual(report["function_count"], 0)

    def test_virtual_only_rva_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "candidate.obj"
            original.write_bytes(make_pe(b"ABCD", virtual_size=0x100, raw_size=4))
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor"))
            manifest = write_manifest(directory, original, candidate, rva=0x1004, size=1)

            report = verify_matches.verify(original, manifest)

            self.assertEqual(report["rejected_count"], 1)
            self.assertIn("virtual-only", report["functions"][0]["error"])

    def test_wrong_candidate_architecture_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "x64.obj"
            original.write_bytes(make_pe(b"ABCD"))
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor", machine=0x8664))
            manifest = write_manifest(directory, original, candidate)

            report = verify_matches.verify(original, manifest)

            self.assertEqual(report["rejected_count"], 1)
            self.assertIn("wrong architecture", report["functions"][0]["error"])

    def test_cli_writes_json_report(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "GAME.EXE"
            candidate = directory / "candidate.obj"
            report_path = directory / "reports" / "matches.json"
            original.write_bytes(make_pe(b"ABCD"))
            candidate.write_bytes(make_coff(b"ABCD", "_blackmoor"))
            manifest = write_manifest(directory, original, candidate)

            stdout = io.StringIO()
            with contextlib.redirect_stdout(stdout):
                exit_code = verify_matches.main(
                    [str(original), str(manifest), "--report", str(report_path)]
                )

            self.assertEqual(exit_code, 0)
            self.assertEqual(json.loads(stdout.getvalue())["exact_byte_range_count"], 1)
            self.assertEqual(
                json.loads(report_path.read_text(encoding="utf-8"))["all_byte_ranges_exact"], True
            )


if __name__ == "__main__":
    unittest.main()
