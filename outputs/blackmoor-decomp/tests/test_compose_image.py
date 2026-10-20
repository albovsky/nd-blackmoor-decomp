"""Tests for the M02 whole-file image composer.

Tests that need the owner's local ``GAME.EXE`` (and the pinned assembler) skip
when those are absent; the rest run from the committed descriptions alone.
Original bytes are only ever held in memory and compared, never written.
"""

import contextlib
import copy
import hashlib
import importlib.util
import io
import json
import re
import shutil
import struct
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SCRIPTS = PROJECT / "scripts"


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    import sys

    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


compose_image = load("compose_image")
report_image_coverage = load("report_image_coverage")

IMAGE_DIR = compose_image.DEFAULT_IMAGE_DIR
ORIGINAL = compose_image.DEFAULT_ORIGINAL
ASSEMBLER = compose_image.DEFAULT_ASSEMBLER
HAVE_ORIGINAL = ORIGINAL.is_file()
HAVE_ASSEMBLER = ASSEMBLER.is_file()
# The Rich key is the Rich-header checksum the M0 census recomputed from the original.
RICH_KEY = 0xE8CD8247

needs_original = unittest.skipUnless(HAVE_ORIGINAL, "local original GAME.EXE not present")
needs_toolchain = unittest.skipUnless(HAVE_ORIGINAL and HAVE_ASSEMBLER, "original GAME.EXE or pinned GNU as not present")


def load_descriptions(image_dir=IMAGE_DIR):
    return compose_image.load_descriptions(image_dir)


class OriginalMixin:
    @classmethod
    def setUpClass(cls):
        cls.original = ORIGINAL.read_bytes() if HAVE_ORIGINAL else b""
        cls.tmp = tempfile.TemporaryDirectory()
        cls.build_dir = Path(cls.tmp.name) / "build"

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()


# --------------------------------------------------------------------------
# hermetic tests (committed descriptions only)
# --------------------------------------------------------------------------


class HeaderGenerationTests(unittest.TestCase):
    def test_rich_checksum_is_recomputed_not_stored(self):
        desc = load_descriptions()
        raw = desc["layout"]
        text = json.dumps(raw)
        self.assertNotIn("e8cd8247", text.lower())
        dos = compose_image.build_dos_region(raw)
        rich, key = compose_image.build_rich_region(raw, dos)
        self.assertEqual(key, RICH_KEY)
        self.assertEqual(struct.unpack_from("<I", rich, 0)[0] ^ key, 0x536E6144)  # "DanS"
        tuples = len(raw["rich"]["tuples"])
        self.assertEqual(rich[16 + 8 * tuples : 20 + 8 * tuples], b"Rich")
        self.assertEqual(struct.unpack_from("<I", rich, 20 + 8 * tuples)[0], key)
        self.assertEqual(sum(count for _, _, count in raw["rich"]["tuples"]), 870)

    def test_rich_key_changes_when_a_header_field_changes(self):
        raw = copy.deepcopy(load_descriptions()["layout"])
        _, key = compose_image.build_rich_region(raw, compose_image.build_dos_region(raw))
        raw["dos_header"]["e_sp"] = "0xb9"
        _, mutated = compose_image.build_rich_region(raw, compose_image.build_dos_region(raw))
        self.assertNotEqual(key, mutated)

    def test_pe_header_fields_match_the_documented_facts(self):
        raw = load_descriptions()["layout"]
        optional = raw["pe"]["optional_header"]
        self.assertEqual(int(raw["pe"]["file_header"]["Machine"], 16), 0x14C)
        self.assertEqual(int(raw["pe"]["file_header"]["TimeDateStamp"], 16), 1178138140)
        self.assertEqual(int(optional["CheckSum"], 16), 0)
        self.assertEqual((int(optional["MajorLinkerVersion"], 16), int(optional["MinorLinkerVersion"], 16)), (6, 0))
        self.assertEqual(int(optional["ImageBase"], 16), 0x400000)
        self.assertEqual(int(optional["AddressOfEntryPoint"], 16), 0x10E7E5)
        self.assertEqual(int(optional["SizeOfImage"], 16), 0x246000)
        self.assertEqual(int(optional["Subsystem"], 16), 2)
        names = [s["name"] for s in raw["sections"]]
        self.assertEqual(names, [".text", ".rdata", ".data", ".rsrc"])
        self.assertEqual(raw["data_directories"]["1"], ["0x134910", "0x118"])
        self.assertEqual(raw["data_directories"]["12"], ["0x12a000", "0x54c"])
        self.assertEqual(raw["data_directories"]["2"], ["0x23f000", "0x66e0"])
        self.assertNotIn("5", raw["data_directories"])  # no relocations
        self.assertNotIn("6", raw["data_directories"])  # no debug directory

    def test_header_groups_tile_the_header_page(self):
        layout = compose_image.Layout(load_descriptions()["layout"])
        items = compose_image.gen_header_groups(layout)
        cursor = 0
        for item in items:
            self.assertEqual(item.offset, cursor)
            self.assertEqual(len(item.data), item.length)
            cursor = item.end
        self.assertEqual(cursor, 0x1000)
        self.assertEqual([i.group for i in items], ["dos_header", "rich_header", "pe_headers", "section_table", "header_padding"])


class StructuredGeneratorTests(unittest.TestCase):
    def test_import_tables_are_internally_consistent(self):
        imports = load_descriptions()["imports"]
        layout = compose_image.Layout(load_descriptions()["layout"])
        iat = compose_image.gen_iat(layout, imports)
        self.assertEqual(sum(i.length for i in iat), 0x54C)
        # every thunk points at a generated hint/name entry or carries an ordinal flag
        entries = {i.offset for i in compose_image.gen_import_directory(layout, imports) if i.name.startswith("hint/name")}
        for item in iat:
            for (value,) in struct.iter_unpack("<I", item.data):
                if value and not value & 0x80000000:
                    self.assertIn(layout.rva_to_offset(value), entries)
        self.assertEqual(len(imports["dlls"]), 13)
        self.assertEqual(sum(len(d["symbols"]) for d in imports["dlls"]), 326)

    def test_resource_tree_offsets_are_gapless(self):
        resources = load_descriptions()["resources"]
        layout = compose_image.Layout(load_descriptions()["layout"])
        items = sorted(compose_image.gen_resource_tree(layout, resources), key=lambda i: i.offset)
        cursor = items[0].offset
        for item in items:
            self.assertEqual(item.offset, cursor)
            cursor = item.end
        self.assertEqual(cursor - items[0].offset, int(resources["tree_size"], 16))
        self.assertEqual(len(resources["data_entries"]), 38)

    def test_jump_table_and_padding_placement(self):
        desc = load_descriptions()
        layout = compose_image.Layout(desc["layout"])
        tables = compose_image.gen_jump_tables(layout, desc["text_data"])
        padding = compose_image.gen_int3_padding(layout, desc["text_data"])
        self.assertEqual(len([t for t in desc["text_data"]["jump_tables"] if t["kind"] == "dword"]), 172)
        self.assertEqual(sum(i.length for i in padding), 2214)
        for item in tables + padding:
            self.assertEqual(item.section, ".text")
            self.assertTrue(0x1000 <= item.offset and item.end <= 0x1000 + 0x12825A)
        for item in padding:
            self.assertEqual(item.data, b"\xcc" * item.length)
        for table in desc["text_data"]["jump_tables"]:
            if table["kind"] == "dword":
                for entry in table["entries"]:
                    self.assertTrue(0x401000 <= int(entry, 16) < 0x401000 + 0x12825A)
        # tables and padding never overlap each other
        combined = sorted(tables + padding, key=lambda i: i.offset)
        for a, b in zip(combined, combined[1:]):
            self.assertLessEqual(a.end, b.offset, (a.name, b.name))

    def test_synthetic_jump_table_bytes(self):
        layout = compose_image.Layout(load_descriptions()["layout"])
        text_data = {
            "jump_tables": [
                {"offset": "0x2000", "kind": "dword", "entries": ["0x402010", "0x402020"]},
            ],
            "int3_padding": [{"offset": "0x200c", "length": 3}],
        }
        tables = compose_image.gen_jump_tables(layout, text_data)
        self.assertEqual(tables[0].data, struct.pack("<II", 0x402010, 0x402020))
        self.assertEqual(len(tables), 1)
        self.assertEqual(compose_image.gen_int3_padding(layout, text_data)[0].data, b"\xcc\xcc\xcc")


class RangeDescriptionTests(unittest.TestCase):
    def test_referenced_ranges_do_not_overlap_structured_items_or_each_other(self):
        desc = load_descriptions()
        layout = compose_image.Layout(desc["layout"])
        grouped = compose_image.structured_items(layout, desc)
        structured = [i for items in grouped.values() for i in items]
        referenced = [
            compose_image.Item(int(r[0]), int(r[1]), "referenced", "referenced", data=b"") for r in desc["ranges"]["ranges"]
        ]
        self.assertGreaterEqual(len(desc["reconstructed"]["bindings"]), 4)
        self.assertEqual(len(desc["reconstructed"]["asm_batches"]), 10)
        self.assertEqual(len(desc["reconstructed"]["data_batches"]), 5)
        # only the reconstructed bytes (baseline plus audited asm batches) may be absent; any overlap would raise "overlap" first
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.check_coverage(structured + referenced, compose_image.ORIGINAL_SIZE)
        message = str(ctx.exception)
        self.assertIn("missing bytes", message)
        self.assertNotIn("overlap", message)
        self.assertIn("gap(s)", message)  # the reconstructed ranges merge into gaps

    def test_no_long_hex_blobs_in_committed_descriptions(self):
        """No byte dump may hide in the descriptions: only 64-hex hashes and the standard DOS stub."""
        for path in sorted(IMAGE_DIR.glob("*.json")):
            text = path.read_text(encoding="utf-8")
            for run in re.findall(r"[0-9a-fA-F]{24,}", text):
                if len(run) == 64:
                    continue
                self.assertEqual((path.name, run), ("layout.json", "0e1fba0e00b409cd21b8014ccd21"))

    def test_descriptions_carry_no_original_hash_of_payloads_other_than_ranges(self):
        raw = load_descriptions()["ranges"]
        self.assertEqual(raw["original_sha256"], compose_image.ORIGINAL_SHA256)
        self.assertEqual(raw["columns"], ["offset", "length", "sha256", "kind", "region", "name"])


class SupersedeStructuredTests(unittest.TestCase):
    """A bound ``structures`` data range replaces the structured items inside it (and only whole items)."""

    def item(self, offset, length, group="iat", **extra):
        return compose_image.Item(offset, length, "structured", group, data=bytes(length), **extra)

    def bound(self, offset, length, replaces=True):
        return compose_image.Item(offset, length, "reconstructed", "reconstructed", data=bytes(length), replaces_structured=replaces)

    def test_items_inside_a_structures_range_are_dropped_and_counted(self):
        items = [self.item(0, 8), self.item(8, 8), self.item(40, 8, "jump_tables")]
        kept, replaced = compose_image.supersede_structured(items, [self.bound(0, 16)])
        self.assertEqual([i.group for i in kept], ["jump_tables"])
        self.assertEqual(replaced, {"items": 2, "bytes": 16})

    def test_an_item_straddling_the_edge_of_a_structures_range_is_an_error(self):
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.supersede_structured([self.item(8, 16)], [self.bound(0, 16)])
        self.assertIn("straddles", str(ctx.exception))

    def test_items_must_tile_the_bound_range(self):
        # an item lost from a structured description would otherwise be filled silently by the batch
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.supersede_structured([self.item(0, 8)], [self.bound(0, 16)])
        self.assertIn("cover 8 of the 16", str(ctx.exception))

    def test_adjacent_structures_ranges_are_one_span(self):
        kept, replaced = compose_image.supersede_structured([self.item(0, 8), self.item(8, 16)], [self.bound(0, 12), self.bound(12, 12)])
        self.assertEqual((kept, replaced), ([], {"items": 2, "bytes": 24}))

    def test_a_payload_batch_replaces_nothing(self):
        items = [self.item(0, 8)]
        kept, replaced = compose_image.supersede_structured(items, [self.bound(0, 16, replaces=False)])
        self.assertEqual(kept, items)
        self.assertEqual(replaced, {"items": 0, "bytes": 0})


class CoverageRejectionTests(unittest.TestCase):
    def item(self, offset, length, cls="structured"):
        return compose_image.Item(offset, length, cls, "g", data=bytes(length))

    def test_overlap_is_rejected(self):
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.check_coverage([self.item(0, 8), self.item(4, 8)], 12)
        self.assertIn("overlap", str(ctx.exception))

    def test_a_function_and_a_data_item_cannot_claim_the_same_byte(self):
        function = compose_image.Item(0x10, 0x20, "referenced", "referenced", "FUN_x", kind="code", data=bytes(0x20))
        table = compose_image.Item(0x28, 0x8, "structured", "jump_tables", "switch", kind="data", data=bytes(8))
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.check_coverage([self.item(0, 0x10), function, table, self.item(0x30, 0x10)], 0x40)
        self.assertIn("overlap", str(ctx.exception))

    def test_missing_bytes_are_rejected(self):
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.check_coverage([self.item(0, 4), self.item(8, 4)], 12)
        self.assertIn("missing bytes", str(ctx.exception))
        self.assertIn("0x4+4", str(ctx.exception))

    def test_trailing_gap_is_rejected(self):
        with self.assertRaises(compose_image.ComposeError):
            compose_image.check_coverage([self.item(0, 4)], 12)

    def test_exact_tiling_is_accepted(self):
        ordered = compose_image.check_coverage([self.item(4, 4), self.item(0, 4), self.item(8, 4)], 12)
        self.assertEqual([i.offset for i in ordered], [0, 4, 8])

    def test_referenced_range_with_a_wrong_hash_is_rejected(self):
        layout = compose_image.Layout(load_descriptions()["layout"])
        original = bytes(range(256)) * 16
        good = hashlib.sha256(original[0:16]).hexdigest()
        ranges = {"columns": ["offset", "length", "sha256", "kind", "region", "name"], "ranges": [[0, 16, good, "data", "", "ok"]]}
        items = compose_image.referenced_items(layout, ranges, original)
        self.assertEqual(items[0].data, original[0:16])
        ranges["ranges"][0][2] = "0" * 64
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.referenced_items(layout, ranges, original)
        self.assertIn("does not match", str(ctx.exception))

    def test_referenced_range_outside_the_file_is_rejected(self):
        layout = compose_image.Layout(load_descriptions()["layout"])
        ranges = {"columns": ["offset", "length", "sha256", "kind", "region", "name"], "ranges": [[10, 20, "0" * 64, "data", "", "bad"]]}
        with self.assertRaises(compose_image.ComposeError):
            compose_image.referenced_items(layout, ranges, bytes(16))


class ReportConsistencyTests(unittest.TestCase):
    def synthetic_report(self):
        return {
            "progress": {"total_bytes": 10},
            "by_class": {
                "structured": {"bytes": 4, "ranges": 1},
                "reconstructed": {"bytes": 2, "ranges": 1},
                "referenced": {"bytes": 4, "ranges": 1},
                "missing": {"bytes": 0, "ranges": 0},
            },
            "by_section": {".text": {"structured": 4, "reconstructed": 2, "referenced": 4, "missing": 0}},
            "referenced_ranges": {"count": 1, "bytes": 4, "list": [{"length": 4}]},
            "stage_referenced_bytes": 0,
            "whole_file_hash_match": False,
            "composed_sha256": "a",
            "original_sha256": "b",
        }

    def test_consistent_report_has_no_problems(self):
        self.assertEqual(report_image_coverage.check_report(self.synthetic_report()), [])

    def test_published_report_without_the_range_list_is_accepted(self):
        report = self.synthetic_report()
        report["referenced_ranges"] = {"count": 1, "bytes": 4, "list_source": "image/ranges.json"}
        self.assertEqual(report_image_coverage.check_report(report), [])

    def test_committed_published_report_can_be_reprinted(self):
        path = IMAGE_DIR / "coverage-report.json"
        with contextlib.redirect_stdout(io.StringIO()) as out:
            code = report_image_coverage.main(["--from-report", str(path)])
        self.assertEqual(code, 0)
        self.assertIn("NOT matched", out.getvalue())

    def test_missing_bytes_are_flagged(self):
        report = self.synthetic_report()
        report["by_class"]["missing"]["bytes"] = 1
        report["by_class"]["referenced"]["bytes"] = 3
        self.assertTrue(any("missing" in p for p in report_image_coverage.check_report(report)))

    def test_referenced_bytes_are_not_counted_as_generated(self):
        text = report_image_coverage.format_text(
            {
                "composed_sha256": "x",
                "whole_file_hash_match": True,
                "progress": {
                    "total_bytes": 10,
                    "generated_bytes": 6,
                    "generated_fraction": 0.6,
                    "referenced_bytes": 4,
                    "code_bytes": 8,
                    "code_bytes_reconstructed": 2,
                    "code_bytes_referenced": 6,
                },
                "by_class": {c: {"bytes": 1, "ranges": 1} for c in ("structured", "reconstructed", "referenced", "missing")},
                "by_code_region": {"game": {"reconstructed": 2, "referenced": 6}},
                "by_section": {".text": {"structured": 1, "reconstructed": 1, "referenced": 1}},
            }
        )
        self.assertIn("NOT matched", text)


# --------------------------------------------------------------------------
# tests against the owner's local original
# --------------------------------------------------------------------------


@needs_original
class StructuredGroupsMatchOriginalTests(OriginalMixin, unittest.TestCase):
    def setUp(self):
        self.desc = load_descriptions()
        self.layout = compose_image.Layout(self.desc["layout"])

    def assert_items_equal_original(self, items):
        self.assertTrue(items)
        for item in items:
            self.assertEqual(item.data, self.original[item.offset : item.end], f"{item.group}/{item.name} at {item.offset:#x}")

    def test_dos_rich_pe_and_section_table_regenerate_exactly(self):
        items = compose_image.gen_header_groups(self.layout)
        self.assert_items_equal_original(items)
        self.assertEqual(b"".join(i.data for i in items), self.original[:0x1000])

    def test_section_table_matches(self):
        items = [i for i in compose_image.gen_header_groups(self.layout) if i.group == "section_table"]
        self.assertEqual(len(items), 1)
        self.assertEqual(items[0].data, self.original[items[0].offset : items[0].end])
        self.assertEqual(items[0].length, 4 * 40)

    def test_import_directory_and_iat_byte_equality(self):
        iat = compose_image.gen_iat(self.layout, self.desc["imports"])
        directory = compose_image.gen_import_directory(self.layout, self.desc["imports"])
        self.assert_items_equal_original(iat)
        self.assert_items_equal_original(directory)
        self.assertEqual(sum(i.length for i in iat), 0x54C)
        self.assertEqual(directory[0].length, 0x118)
        self.assertEqual(directory[0].offset, 0x134910)
        # the generated import region has no byte the descriptions do not account for
        covered = sorted((i.offset, i.end) for i in directory)
        for a, b in zip(covered, covered[1:]):
            self.assertEqual(a[1], b[0])

    def test_resource_tree_and_padding_match(self):
        tree = compose_image.gen_resource_tree(self.layout, self.desc["resources"])
        padding = compose_image.gen_resource_padding(self.layout, self.desc["resources"])
        self.assert_items_equal_original(tree)
        self.assert_items_equal_original(padding)
        for entry in self.desc["resources"]["data_entries"]:
            offset = self.layout.rva_to_offset(int(entry["rva"], 16))
            self.assertLessEqual(offset + entry["size"], len(self.original))

    def test_jump_tables_int3_padding_and_zero_fill_match(self):
        self.assert_items_equal_original(compose_image.gen_jump_tables(self.layout, self.desc["text_data"]))
        self.assert_items_equal_original(compose_image.gen_int3_padding(self.layout, self.desc["text_data"]))
        self.assert_items_equal_original(compose_image.gen_section_padding(self.layout, self.desc["layout"]["section_padding"]))

    def test_jump_table_entries_point_at_instruction_aligned_code_inside_their_function(self):
        spans_index = json.loads((PROJECT / "function-index.json").read_text())
        starts = sorted(int(f["address"], 16) for f in spans_index["functions"])
        end = 0x401000 + 0x12825A
        import bisect

        for table in self.desc["text_data"]["jump_tables"]:
            if table["kind"] != "dword":
                continue
            site = int(table["offset"], 16) + 0x400000
            k = bisect.bisect_right(starts, site) - 1
            lo, hi = starts[k], (starts[k + 1] if k + 1 < len(starts) else end)
            for entry in table["entries"]:
                self.assertTrue(lo <= int(entry, 16) < hi, (table["offset"], entry))

    def test_every_group_is_nonempty_and_generated(self):
        grouped = compose_image.structured_items(self.layout, self.desc)
        for group in compose_image.GROUPS:
            self.assertTrue(grouped[group], group)
            self.assertTrue(all(i.cls == "structured" and i.data is not None for i in grouped[group]))


@needs_toolchain
class WholeFileCompositionTests(OriginalMixin, unittest.TestCase):
    def test_all_groups_reproduce_the_whole_file_hash(self):
        comp = compose_image.compose(IMAGE_DIR, ORIGINAL, self.build_dir)
        self.assertTrue(comp.size_match)
        self.assertTrue(comp.hash_match)
        self.assertEqual(comp.sha256, compose_image.ORIGINAL_SHA256)
        self.assertEqual(comp.structured_mismatches, [])
        self.assertEqual(comp.data, self.original)

    def test_each_group_enabled_alone_keeps_the_hash(self):
        enabled = []
        for group in compose_image.GROUPS:
            enabled.append(group)
            comp = compose_image.compose(IMAGE_DIR, ORIGINAL, self.build_dir, tuple(enabled))
            self.assertTrue(comp.hash_match, group)

    def test_structured_groups_are_generated_not_referenced(self):
        comp = compose_image.compose(IMAGE_DIR, ORIGINAL, self.build_dir)
        report = compose_image.coverage_report(comp)
        self.assertEqual(report["stage_referenced_bytes"], 0)
        # every group is generated and checked against the original, but none of its items is placed: the bytes come from
        # the audited function sources (switch tables, int 3 padding) and data batches 003 to 005
        self.assertEqual({i.group for i in comp.items if i.cls == "structured"}, set())
        self.assertEqual(report["structured_replaced_by_audited_sources"], {"items": 1039, "bytes": 23430 + 5856 + 2214})
        for item in comp.items:
            if item.cls == "referenced":
                self.assertEqual(item.group, "referenced")
                self.assertNotEqual(item.section, "<headers>")
        # nothing structured lives in the referenced list
        listed = {(r["offset"], r["length"]) for r in report["referenced_ranges"]["list"]}
        for item in comp.items:
            if item.cls == "structured":
                self.assertNotIn((item.offset, item.length), listed)

    def test_report_states_referenced_bytes_separately_and_claims_no_match_for_them(self):
        comp = compose_image.compose(IMAGE_DIR, ORIGINAL, self.build_dir)
        report = compose_image.coverage_report(comp)
        self.assertEqual(report_image_coverage.check_report(report), [])
        progress = report["progress"]
        self.assertEqual(progress["generated_bytes"] + progress["referenced_bytes"], progress["total_bytes"])
        self.assertEqual(progress["missing_bytes"], 0)
        # 398 baseline bytes plus 4,773 audited tool-assisted functions (1,201,090 bytes: 4,163 indexed functions in
        # batches 001-008, 554 derived entries in batch 009 and the 56 fragment entries of batch 010); the 13 functions
        # that overlap the baseline (11 S08 assembly functions, 2 incomplete C ranges) are counted once, in the
        # baseline.  The audited data items that no structured group generates are bound in classes of their own and
        # are not code.
        by_provenance = report["reconstructed_by_provenance"]
        self.assertEqual(by_provenance["tool_assisted_reconstructed_assembly"], {"ranges": 4773, "bytes": 1201090})
        self.assertEqual(by_provenance["explicit_reconstructed_assembly_source"]["bytes"], 384)
        self.assertEqual(by_provenance["tool_assisted_reconstructed_index_table"], {"ranges": 19, "bytes": 1934})
        self.assertEqual(by_provenance["tool_assisted_reconstructed_padding"], {"ranges": 616, "bytes": 3740})  # 2,214 of them int 3 padding
        # 158 switch tables of audited functions plus the 12 table ranges of the two CRT block copies (data batch 005)
        self.assertEqual(by_provenance["tool_assisted_reconstructed_jump_table"], {"ranges": 170, "bytes": 5856})
        # .rdata, .data and the resource payloads (274,976 bytes) are bound as labeled data directives (owner ruling of
        # 2026-10-19), a class of their own: no function and no code byte; batches 003 and 004 add the 23,430 bytes of
        # PE headers, import tables, resource directory tree and section fill (27 ranges)
        self.assertEqual(by_provenance["tool_assisted_reconstructed_data"], {"ranges": 51, "bytes": 298406})
        self.assertEqual(sum(entry["bytes"] for entry in by_provenance.values()), 1511424)
        self.assertEqual(report["by_class"]["reconstructed"]["bytes"], 1511424)
        self.assertEqual(report["by_class"]["structured"]["bytes"], 0)  # the composer places no structured byte
        self.assertEqual(report["structured_replaced_by_audited_sources"]["bytes"], 23430 + 5856 + 2214)
        self.assertEqual(progress["reconstructed_data_bytes"], 298406)
        self.assertEqual(progress["referenced_bytes"], 0)
        self.assertEqual(progress["code_bytes_reconstructed"], 1201488)
        self.assertEqual(progress["reconstructed_functions"], 4786)
        self.assertEqual(progress["reconstructed_index_table_bytes"], 1934)
        self.assertEqual(progress["reconstructed_padding_bytes"], 3740)
        self.assertEqual(progress["reconstructed_jump_table_bytes"], 5856)
        # every code byte is reconstructed: the last 22 fragments (1,619 bytes) are bound by batch 010
        self.assertEqual(progress["code_bytes_referenced"], 0)
        self.assertEqual(progress["code_bytes_reconstructed_fraction"], 1.0)
        self.assertIn("NOT counted as matched", report["claim"])
        self.assertEqual(sum(r["length"] for r in report["referenced_ranges"]["list"]), progress["referenced_bytes"])
        for region in ("game", "vorbis", "crt_mfc"):
            self.assertIn(region, report["by_code_region"])
        for section in (".text", ".rdata", ".data", ".rsrc"):
            self.assertIn(section, report["by_section"])
        markdown = compose_image.render_markdown(report)
        self.assertIn("not matched", markdown)

    def test_reconstructed_bindings_are_the_baseline_and_the_audited_asm_batches(self):
        comp = compose_image.compose(IMAGE_DIR, ORIGINAL, self.build_dir)
        baseline = [
            r for r in comp.reconstructed_records
            if "functions" not in r and r["status"] == "bound" and r["provenance_class"] != "tool_assisted_reconstructed_data"
        ]
        data_batches = [r for r in comp.reconstructed_records if r["provenance_class"] == "tool_assisted_reconstructed_data"]
        self.assertEqual([r["batch"] for r in data_batches], ["001", "002", "003", "004", "005"])
        self.assertEqual([r["profile"] for r in data_batches], ["payloads", "payloads", "structures", "structures", "jump_tables"])
        self.assertEqual(sum(r["length"] for r in data_batches), 298406 + 240)
        self.assertEqual(sum(r["length"] for r in baseline), 398)
        assembly = [r for r in baseline if r["provenance_class"] == "explicit_reconstructed_assembly_source"]
        self.assertEqual(sum(r["length"] for r in assembly), 384)
        self.assertEqual(len(assembly), 11)
        for record in baseline:
            offset = record["offset"]
            self.assertEqual(hashlib.sha256(self.original[offset : offset + record["length"]]).hexdigest(), record["range_sha256"])
        batches = {r["batch"]: r for r in comp.reconstructed_records if "functions" in r}
        self.assertEqual(sorted(batches), ["001", "002", "003", "004", "005", "006", "007", "008", "009", "010"])
        self.assertEqual(sum(r["functions"] for r in batches.values()), 4773)
        self.assertEqual(sum(r["length"] for r in batches.values()), 1201090)
        self.assertEqual(sum(r["index_table_bytes"] for r in batches.values()), 1934)
        self.assertEqual(sum(r["padding_bytes"] for r in batches.values()), 3740)
        self.assertEqual(sum(r["jump_tables"] for r in batches.values()), 158)
        self.assertEqual(sum(r["jump_table_bytes"] for r in batches.values()), 5616)
        # the baseline keeps its own class: 11 S08 functions in batch 001 and 2 incomplete C ranges in batch 007
        self.assertEqual(batches["001"]["superseded"], 11)
        self.assertEqual(batches["007"]["superseded"], 2)
        self.assertEqual(sum(r["superseded"] for r in batches.values()), 13)
        # every reconstructed range, whichever class, is byte-identical to the original: the match claim
        for item in comp.items:
            if item.cls == "reconstructed":
                self.assertEqual(item.data, self.original[item.offset : item.end], item.name)
                self.assertTrue(item.provenance)

    def test_cli_build_succeeds_and_writes_reports(self):
        out = Path(self.tmp.name) / "cli"
        with contextlib.redirect_stdout(io.StringIO()):
            code = compose_image.main(["build", "--build-dir", str(out)])
        self.assertEqual(code, 0)
        self.assertEqual(hashlib.sha256((out / "GAME.composed.exe").read_bytes()).hexdigest(), compose_image.ORIGINAL_SHA256)
        report = json.loads((out / "coverage-report.json").read_text())
        self.assertTrue(report["whole_file_hash_match"])
        self.assertTrue((out / "coverage-report.md").is_file())


@needs_toolchain
class MutantTests(OriginalMixin, unittest.TestCase):
    """Flipping one byte of any structured item must fail the whole-file hash."""

    def mutated_dir(self, edit):
        directory = Path(self.tmp.name) / f"mutant-{hashlib.sha1(repr(edit).encode()).hexdigest()[:8]}"
        shutil.copytree(IMAGE_DIR, directory, dirs_exist_ok=True)
        edit(directory)
        return directory

    def referenced_dir(self, edit):
        """An image directory where the resource payloads (data batch 002) are referenced again instead of bound."""

        def prepare(directory):
            recon = json.loads((directory / "reconstructed.json").read_text())
            index = next(i for i, b in enumerate(recon["data_batches"]) if b["manifest"].endswith("data-002.json"))
            batch = recon["data_batches"].pop(index)
            manifest = json.loads((PROJECT / batch["manifest"]).read_text())
            rows = [[int(e["offset"], 16), e["length"], e["sha256"], "data", "", f"resource {e['va']}"] for e in manifest["ranges"]]
            (directory / "reconstructed.json").write_text(json.dumps(recon))
            ranges = json.loads((directory / "ranges.json").read_text())
            head = {k: v for k, v in ranges.items() if k != "ranges"}
            compose_image.write_json_rows(directory / "ranges.json", head, "ranges", rows)
            edit(directory)

        return self.mutated_dir(prepare)

    # every group's bytes come from an audited source (function data items, data batches 003 to 005): a mutated
    # description no longer reaches the composed hash, but it is still reported as a mismatch and the CLI still fails
    REPLACED_GROUPS = set(compose_image.GROUPS)

    def assert_mutant_fails(self, edit, group=None):
        directory = self.mutated_dir(edit)
        comp = compose_image.compose(directory, ORIGINAL, self.build_dir)
        if group in self.REPLACED_GROUPS:
            self.assertTrue(comp.hash_match)
        else:
            self.assertFalse(comp.hash_match)
            self.assertNotEqual(comp.sha256, compose_image.ORIGINAL_SHA256)
        self.assertTrue(comp.structured_mismatches, "the diagnostic must name the differing structured item")
        if group:
            self.assertEqual(comp.structured_mismatches[0]["group"], group)
        # the CLI refuses to treat it as a success
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            code = compose_image.main(["build", "--image-dir", str(directory), "--build-dir", str(Path(self.tmp.name) / "mutant-out")])
        self.assertEqual(code, 1)

    def edit_json(self, name, change):
        def edit(directory):
            path = directory / f"{name}.json"
            value = json.loads(path.read_text())
            change(value)
            path.write_text(json.dumps(value))

        return edit

    def test_flip_a_jump_table_entry(self):
        def change(value):
            table = next(t for t in value["jump_tables"] if t["kind"] == "dword")
            table["entries"][0] = hex(int(table["entries"][0], 16) ^ 1)

        self.assert_mutant_fails(self.edit_json("text_data", change), "jump_tables")

    def test_without_data_batch_005_the_crt_tables_would_fall_back_to_structured_bytes(self):
        """The jump_tables group only cross-checks the audited sources: unbound, exactly the 240 CRT table bytes remain structured."""

        def drop(directory):
            path = directory / "reconstructed.json"
            value = json.loads(path.read_text())
            value["data_batches"] = [b for b in value["data_batches"] if not b["manifest"].endswith("data-005.json")]
            path.write_text(json.dumps(value))

        comp = compose_image.compose(self.mutated_dir(drop), ORIGINAL, self.build_dir)
        self.assertTrue(comp.hash_match)
        structured = [i for i in comp.items if i.cls == "structured"]
        self.assertEqual({i.group for i in structured}, {"jump_tables"})
        self.assertEqual(sum(i.length for i in structured), 240)

    def test_index_tables_are_not_generated_from_stored_bytes(self):
        text_data = load_descriptions()["text_data"]
        self.assertTrue(text_data["index_tables"])
        self.assertTrue(all(t["kind"] == "dword" for t in text_data["jump_tables"]))
        self.assertTrue(all("values" not in t for t in text_data["index_tables"]))
        layout = compose_image.Layout(load_descriptions()["layout"])
        with self.assertRaises(compose_image.ComposeError):
            compose_image.gen_jump_tables(layout, {"jump_tables": [{"offset": "0x2000", "kind": "index8", "values": [1]}]})

    def test_change_padding_length(self):
        def change(value):
            value["int3_padding"][0]["length"] -= 1

        directory = self.mutated_dir(self.edit_json("text_data", change))
        with self.assertRaises(compose_image.ComposeError):  # a byte becomes missing
            compose_image.compose(directory, ORIGINAL, self.build_dir)

    def test_flip_an_import_hint(self):
        def change(value):
            symbol = next(s for d in value["dlls"] for s in d["symbols"] if "hint" in s)
            symbol["hint"] ^= 1

        self.assert_mutant_fails(self.edit_json("imports", change), "import_directory")

    def test_flip_a_pe_header_field(self):
        def change(value):
            value["pe"]["optional_header"]["MinorOperatingSystemVersion"] = "0x1"

        self.assert_mutant_fails(self.edit_json("layout", change), "pe_headers")

    def test_change_the_link_timestamp(self):
        def change(value):
            value["pe"]["file_header"]["TimeDateStamp"] = hex(int(value["pe"]["file_header"]["TimeDateStamp"], 16) + 1)

        directory = self.mutated_dir(self.edit_json("layout", change))
        comp = compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertTrue(comp.hash_match)  # the PE headers come from the audited batch data-003
        groups = {m["group"] for m in comp.structured_mismatches}
        self.assertIn("pe_headers", groups)

    def test_flip_a_resource_entry(self):
        def change(value):
            value["data_entries"][0]["size"] ^= 1

        self.assert_mutant_fails(self.edit_json("resources", change), "resource_tree")

    def test_wrong_hash_in_a_referenced_range_is_rejected(self):
        def edit(directory):
            path = directory / "ranges.json"
            lines = path.read_text().splitlines()
            index = next(i for i, line in enumerate(lines) if line.startswith("  ["))
            lines[index] = re.sub(r'"[0-9a-f]{64}"', '"' + "0" * 64 + '"', lines[index], count=1)
            path.write_text("\n".join(lines) + "\n")

        directory = self.referenced_dir(edit)
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn("does not match", str(ctx.exception))

    def test_deleting_a_referenced_range_leaves_missing_bytes(self):
        def edit(directory):
            path = directory / "ranges.json"
            lines = path.read_text().splitlines()
            index = next(i for i, line in enumerate(lines) if line.startswith("  [") and '"data"' in line)
            del lines[index]
            if lines[index - 1].endswith(",") and lines[index].strip() == "]":
                lines[index - 1] = lines[index - 1].rstrip(",")
            path.write_text("\n".join(lines) + "\n")

        directory = self.referenced_dir(edit)
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn("missing bytes", str(ctx.exception))

    def test_overlapping_function_and_data_item_is_rejected(self):
        def edit(directory):
            # claim bytes of the first referenced range again as a jump table
            path = directory / "text_data.json"
            value = json.loads(path.read_text())
            ranges = json.loads((directory / "ranges.json").read_text())
            offset = ranges["ranges"][0][0]
            value["jump_tables"].append({"offset": hex(offset), "kind": "dword", "entries": ["0x401000"]})
            path.write_text(json.dumps(value))

        directory = self.referenced_dir(edit)
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn("overlap", str(ctx.exception))

    def data_batch_dir(self, edit):
        """Copy asm_data/ to a temp dir, apply ``edit(asm_dir)`` and point data_batches at the copy."""
        asm_dir = Path(self.tmp.name) / f"asm_data-{hashlib.sha1(repr(edit).encode()).hexdigest()[:8]}"
        shutil.copytree(PROJECT / "asm_data", asm_dir)
        edit(asm_dir)

        def prepare(directory):
            recon = json.loads((directory / "reconstructed.json").read_text())
            recon["data_batches"] = [
                {"manifest": str(asm_dir / Path(b["manifest"]).name), "report": str(asm_dir / Path(b["report"]).name), "provenance_class": b["provenance_class"]}
                for b in recon["data_batches"]
            ]
            (directory / "reconstructed.json").write_text(json.dumps(recon))

        return self.mutated_dir(prepare)

    def assert_data_batch_rejected(self, edit, fragment):
        directory = self.data_batch_dir(edit)
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn(fragment, str(ctx.exception))

    def rehash(self, asm_dir, name="data-002", source_sha256=None):
        """Make manifest and report agree with an edited layout (or a claimed source hash), as an attacker who controls the files would."""
        layout = asm_dir / f"{name}.layout"
        manifest = json.loads((asm_dir / f"{name}.json").read_text())
        manifest["layout_sha256"] = hashlib.sha256(layout.read_bytes()).hexdigest()
        if source_sha256:
            manifest["source_sha256"] = source_sha256
        (asm_dir / f"{name}.json").write_text(json.dumps(manifest, indent=1))
        report = json.loads((asm_dir / f"{name}-report.json").read_text())
        report["manifest_sha256"] = hashlib.sha256((asm_dir / f"{name}.json").read_bytes()).hexdigest()
        report["source"]["sha256"] = manifest["source_sha256"]
        report["layout"]["sha256"] = manifest["layout_sha256"]
        (asm_dir / f"{name}-report.json").write_text(json.dumps(report, indent=1))

    def test_data_layout_edited_after_the_audit_is_rejected(self):
        self.assert_data_batch_rejected(lambda d: (d / "data-002.layout").write_text((d / "data-002.layout").read_text() + ".fill 4, 1, 0\n"), "differs from the manifest hash")

    def test_full_data_source_is_not_committed(self):
        self.assertEqual(sorted((PROJECT / "asm_data").glob("*.s")), [])

    def test_stale_data_audit_report_is_rejected(self):
        def edit(d):
            manifest = json.loads((d / "data-002.json").read_text())
            manifest["description"] += " (edited)"
            (d / "data-002.json").write_text(json.dumps(manifest, indent=1))

        self.assert_data_batch_rejected(edit, "audit report is stale")

    def test_data_layout_with_a_payload_value_cannot_ride_on_a_rehashed_report(self):
        def edit(d):
            (d / "data-002.layout").write_text((d / "data-002.layout").read_text() + '.asciz "GAME.EXE"\n')
            self.rehash(d)

        self.assert_data_batch_rejected(edit, "unexpected line in the layout")

    def test_data_layout_that_is_not_the_generators_output_is_rejected(self):
        def edit(d):
            text = (d / "data-002.layout").read_text()
            (d / "data-002.layout").write_text(text.replace(".long [4]", ".long [3]", 1))
            self.rehash(d)

        self.assert_data_batch_rejected(edit, "does not have the committed layout")

    def test_data_source_hash_that_the_original_does_not_regenerate_is_rejected(self):
        self.assert_data_batch_rejected(lambda d: self.rehash(d, source_sha256="0" * 64), "regenerated from the original differs")

    def test_a_range_both_bound_and_referenced_is_rejected(self):
        def add_referenced(directory):
            manifest = json.loads((PROJECT / "asm_data" / "data-002.json").read_text())
            e = manifest["ranges"][0]
            ranges = json.loads((directory / "ranges.json").read_text())
            head = {k: v for k, v in ranges.items() if k != "ranges"}
            row = [int(e["offset"], 16), e["length"], e["sha256"], "data", "", "resource duplicate"]
            compose_image.write_json_rows(directory / "ranges.json", head, "ranges", [row])

        directory = self.mutated_dir(add_referenced)
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn("overlap", str(ctx.exception))

    def test_a_reconstructed_byte_mismatch_is_rejected(self):
        """A reconstruction source that no longer reproduces the original bytes cannot be bound."""
        directory = self.mutated_dir(lambda d: None)
        bad = Path(self.tmp.name) / "bad_source.s"
        bad.write_text((PROJECT / "src" / "matching_s08_4_x86.s").read_text().replace("pushl %ebp", "pushl %ebx", 1))
        recon = json.loads((directory / "reconstructed.json").read_text())
        recon["bindings"][0]["source"] = str(bad)  # absolute paths are accepted for out-of-tree sources
        (directory / "reconstructed.json").write_text(json.dumps(recon))
        with self.assertRaises(compose_image.ComposeError) as ctx:
            compose_image.compose(directory, ORIGINAL, self.build_dir)
        self.assertIn("verify_matches", str(ctx.exception))


@unittest.skipUnless(HAVE_ASSEMBLER, "pinned GNU as not present")
class AsmBatchBindingTests(unittest.TestCase):
    """bind_asm_batches on a three-function copy of batch 002: every guard must trip."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.layout = compose_image.Layout(load_descriptions()["layout"])

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def make_batch(self, name, edit=None):
        directory = Path(self.tmp.name) / name
        directory.mkdir()
        manifest = json.loads((PROJECT / "asm" / "batch-002.json").read_text())
        report = json.loads((PROJECT / "asm" / "batch-002-report.json").read_text())
        manifest["functions"] = manifest["functions"][:3]
        report["functions"] = report["functions"][:3]
        report["accepted_count"] = 3
        for function in manifest["functions"]:
            shutil.copy(PROJECT / "asm" / function["source"], directory / function["source"])
        if edit:
            edit(directory, manifest, report)
        (directory / "batch.json").write_text(json.dumps(manifest))
        report["manifest_sha256"] = hashlib.sha256((directory / "batch.json").read_bytes()).hexdigest()
        if edit and getattr(edit, "stale_report", False):
            report["manifest_sha256"] = "0" * 64
        (directory / "report.json").write_text(json.dumps(report))
        return [{"manifest": str(directory / "batch.json"), "report": str(directory / "report.json"), "provenance_class": "tool_assisted_reconstructed_assembly"}]

    def bind(self, batches, taken=None, assembler=ASSEMBLER):
        return compose_image.bind_asm_batches(self.layout, batches, Path(self.tmp.name) / "build", assembler, [] if taken is None else taken)

    def test_good_batch_binds_every_function_as_tool_assisted_reconstructed(self):
        items, records = self.bind(self.make_batch("good"))
        self.assertEqual(len(items), 3)
        self.assertEqual({i.provenance for i in items}, {"tool_assisted_reconstructed_assembly"})
        self.assertEqual({i.cls for i in items}, {"reconstructed"})
        self.assertEqual(records[0]["functions"], 3)
        self.assertEqual(records[0]["length"], sum(i.length for i in items))

    def test_overlap_with_an_earlier_binding_is_superseded_not_bound_twice(self):
        batches = self.make_batch("superseded")
        first = self.bind(batches)[0][0]
        items, records = self.bind(batches, taken=[(first.offset, first.end, "earlier")])
        self.assertEqual(len(items), 2)
        self.assertEqual(records[0]["superseded"], 1)

    def test_stale_audit_report_is_rejected(self):
        def edit(directory, manifest, report):
            pass

        edit.stale_report = True
        with self.assertRaisesRegex(compose_image.ComposeError, "stale"):
            self.bind(self.make_batch("stale", edit))

    def test_report_that_does_not_accept_every_function_is_rejected(self):
        def edit(directory, manifest, report):
            report["all_accepted"] = False

        with self.assertRaisesRegex(compose_image.ComposeError, "did not accept"):
            self.bind(self.make_batch("unaccepted", edit))

    def test_source_changed_after_the_audit_is_rejected(self):
        def edit(directory, manifest, report):
            path = directory / manifest["functions"][0]["source"]
            path.write_text(path.read_text() + "# edited after the audit\n")

        with self.assertRaisesRegex(compose_image.ComposeError, "differs from the audited hash"):
            self.bind(self.make_batch("edited", edit))

    def test_source_that_assembles_to_other_bytes_is_rejected_even_with_a_refreshed_hash(self):
        def edit(directory, manifest, report):
            for function in manifest["functions"]:
                path = directory / function["source"]
                text = path.read_text()
                changed = text.replace("\n    push ebp ", "\n    push ebx ", 1)
                if changed != text:
                    path.write_text(changed)
                    function["source_sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
                    report["functions"][manifest["functions"].index(function)]["source"]["sha256"] = function["source_sha256"]
                    return
            self.fail("no push ebp to mutate")

        with self.assertRaisesRegex(compose_image.ComposeError, "differ from the audited original code part"):
            self.bind(self.make_batch("mutant", edit))

    def test_manifest_for_another_original_or_class_is_rejected(self):
        def other_original(directory, manifest, report):
            manifest["original_sha256"] = "0" * 64

        def other_class(directory, manifest, report):
            manifest["class"] = "explicit_reconstructed_assembly_source"

        with self.assertRaisesRegex(compose_image.ComposeError, "different original"):
            self.bind(self.make_batch("other-original", other_original))
        with self.assertRaisesRegex(compose_image.ComposeError, "not a tool_assisted"):
            self.bind(self.make_batch("other-class", other_class))

    def test_function_missing_from_the_accepted_set_is_rejected(self):
        def edit(directory, manifest, report):
            report["functions"][0]["status"] = "rejected"

        with self.assertRaisesRegex(compose_image.ComposeError, "not accepted"):
            self.bind(self.make_batch("not-accepted", edit))

    def test_report_that_disagrees_with_the_manifest_is_rejected(self):
        def code(directory, manifest, report):
            report["functions"][0]["code"] = dict(report["functions"][0]["code"], size=report["functions"][0]["code"]["size"] + 1)

        def source(directory, manifest, report):
            report["functions"][0]["source"] = dict(report["functions"][0]["source"], sha256="0" * 64)

        with self.assertRaisesRegex(compose_image.ComposeError, "differs from the manifest"):
            self.bind(self.make_batch("report-code", code))
        with self.assertRaisesRegex(compose_image.ComposeError, "differs from the manifest"):
            self.bind(self.make_batch("report-source", source))

    def test_duplicate_function_in_a_manifest_is_rejected(self):
        def edit(directory, manifest, report):
            manifest["functions"][1] = manifest["functions"][0]

        with self.assertRaisesRegex(compose_image.ComposeError, "listed twice"):
            self.bind(self.make_batch("duplicate", edit))

    def test_incbin_source_is_rejected_even_with_refreshed_hashes(self):
        def edit(directory, manifest, report):
            function = manifest["functions"][0]
            path = directory / function["source"]
            path.write_text(path.read_text() + '\n.incbin "/dev/null"\n')
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            function["source_sha256"] = digest
            report["functions"][0]["source"]["sha256"] = digest

        with self.assertRaisesRegex(compose_image.ComposeError, "incbin"):
            self.bind(self.make_batch("incbin", edit))

    def test_overlap_inside_one_batch_is_an_error_not_a_supersession(self):
        batches = self.make_batch("same-batch")
        first = self.bind(batches)[0][0]
        with self.assertRaisesRegex(compose_image.ComposeError, "same batch"):
            self.bind(batches, taken=[(first.offset, first.end, batches[0]["manifest"] + ":other")])

    def make_fragment_batch(self, name, vas, edit=None):
        """A copy of the given batch-010 entries (call endings, fall-through fragments) with a matching report."""

        directory = Path(self.tmp.name) / name
        directory.mkdir()
        manifest = json.loads((PROJECT / "asm" / "batch-010.json").read_text())
        report = json.loads((PROJECT / "asm" / "batch-010-report.json").read_text())
        keep = [i for i, f in enumerate(manifest["functions"]) if int(f["va"], 16) in vas]
        manifest["functions"] = [manifest["functions"][i] for i in keep]
        report["functions"] = [report["functions"][i] for i in keep]
        report["accepted_count"] = len(keep)
        for function in manifest["functions"]:
            shutil.copy(PROJECT / "asm" / function["source"], directory / function["source"])
        if edit:
            edit(directory, manifest, report)
        (directory / "batch.json").write_text(json.dumps(manifest))
        report["manifest_sha256"] = hashlib.sha256((directory / "batch.json").read_bytes()).hexdigest()
        (directory / "report.json").write_text(json.dumps(report))
        return [{"manifest": str(directory / "batch.json"), "report": str(directory / "report.json"), "provenance_class": "tool_assisted_reconstructed_assembly"}]

    def test_fall_through_fragment_counts_only_with_its_successor_bound(self):
        """Owner ruling of 2026-10-16: a fragment that falls through is matched only bound together with the range it runs into."""

        batches = self.make_fragment_batch("fall-through", {0x510A4B})
        with self.assertRaisesRegex(compose_image.ComposeError, "not bound as code"):
            self.bind(batches)
        successor = self.layout.rva_to_offset(0x510A51 - 0x400000)
        items, records = self.bind(batches, taken=[(successor, successor + 4, "earlier.json:FUN_00510a51")])
        self.assertEqual(len(items), 1)
        self.assertEqual(records[0]["fall_through_fragments"], 1)
        # padding or a table at the successor address is not code
        with self.assertRaisesRegex(compose_image.ComposeError, "not bound as code"):
            self.bind(batches, taken=[(successor, successor + 4, "earlier.json:PAD_00510a51")])

    def test_call_ending_is_counted_and_its_audited_ending_must_match_the_manifest(self):
        batches = self.make_fragment_batch("call-ending", {0x50E8E2})
        with self.assertRaisesRegex(compose_image.ComposeError, "not bound as code"):
            self.bind(batches)  # a call-end is bound together with the range that follows it, like a fall-through
        following = self.layout.rva_to_offset(0x50E8ED - 0x400000)
        items, records = self.bind(batches, taken=[(following, following + 4, "earlier.json:FUN_0050e8ed")])
        self.assertEqual((len(items), records[0]["call_end_fragments"], records[0]["fall_through_fragments"]), (1, 1, 0))

        def edit(directory, manifest, report):
            del manifest["functions"][0]["ending"]

        with self.assertRaisesRegex(compose_image.ComposeError, "audited ending"):
            self.bind(self.make_fragment_batch("call-ending-dropped", {0x50E8E2}, edit), taken=[(following, following + 4, "earlier.json:FUN_0050e8ed")])

        def unknown(directory, manifest, report):
            manifest["functions"][0]["ending"] = report["functions"][0]["ending"] = "returns-later"

        with self.assertRaisesRegex(compose_image.ComposeError, "unknown ending"):
            self.bind(self.make_fragment_batch("call-ending-unknown", {0x50E8E2}, unknown), taken=[(following, following + 4, "earlier.json:FUN_0050e8ed")])

    def test_a_different_assembler_is_rejected(self):
        fake = Path(self.tmp.name) / "fake-as"
        fake.write_text("#!/bin/sh\necho 'GNU assembler (GNU Binutils) 2.42'\n")
        fake.chmod(0o755)
        with self.assertRaisesRegex(compose_image.ComposeError, "pinned assembler"):
            self.bind(self.make_batch("fake"), assembler=fake)


@unittest.skipUnless(HAVE_ASSEMBLER, "pinned GNU as not present")
class AsmDataItemBindingTests(unittest.TestCase):
    """Switch tables, index tables and padding of an audited function bind as their own classes; the ones a structured group also describes replace its items."""

    TABLE_BATCH = ("batch-003", "FUN_0040b34a")  # switch table, index table, switch table
    PADDING_BATCH = ("batch-009", "FUN_004fcee2")  # derived entry followed by 8 padding bytes

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.layout = compose_image.Layout(load_descriptions()["layout"])

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def make_batch(self, which, name, edit=None):
        batch, function_name = which
        directory = Path(self.tmp.name) / name
        directory.mkdir()
        manifest = json.loads((PROJECT / "asm" / f"{batch}.json").read_text())
        report = json.loads((PROJECT / "asm" / f"{batch}-report.json").read_text())
        manifest["functions"] = [f for f in manifest["functions"] if f["function"] == function_name]
        report["functions"] = [f for f in report["functions"] if f["function"] == function_name]
        report["accepted_count"] = 1
        shutil.copy(PROJECT / "asm" / manifest["functions"][0]["source"], directory / manifest["functions"][0]["source"])
        if edit:
            edit(manifest, report)
        (directory / "batch.json").write_text(json.dumps(manifest))
        report["manifest_sha256"] = hashlib.sha256((directory / "batch.json").read_bytes()).hexdigest()
        (directory / "report.json").write_text(json.dumps(report))
        return [{"manifest": str(directory / "batch.json"), "report": str(directory / "report.json"), "provenance_class": "tool_assisted_reconstructed_assembly"}]

    def structured_for(self, which):
        report = json.loads((PROJECT / "asm" / f"{which[0]}-report.json").read_text())
        function = next(f for f in report["functions"] if f["function"] == which[1])
        return [
            (self.layout.rva_to_offset(d["rva"]), d["size"]) for d in function["data_items"] if d["kind"] == "switch_table"
        ]

    def bind(self, batches, structured):
        return compose_image.bind_asm_batches(self.layout, batches, Path(self.tmp.name) / "build", ASSEMBLER, [], structured)

    def test_tables_bind_as_their_own_classes_and_switch_tables_replace_the_structured_ones(self):
        items, records = self.bind(self.make_batch(self.TABLE_BATCH, "table"), self.structured_for(self.TABLE_BATCH))
        self.assertEqual(sorted(i.kind for i in items), ["code", "data", "data", "data"])
        tables = {i.name: i for i in items if i.kind == "data"}
        index = tables["IDXTAB_00410e9c"]
        self.assertEqual((index.length, index.provenance, index.replaces_structured), (237, compose_image.ASM_INDEX_CLASS, False))
        jumps = [i for i in tables.values() if i.provenance == compose_image.ASM_JUMP_TABLE_CLASS]
        self.assertEqual(sorted((i.name, i.length) for i in jumps), [("SWTAB_00410ca4", 504), ("SWTAB_00410f89", 16)])
        self.assertTrue(all(i.replaces_structured for i in jumps))
        self.assertEqual(records[0]["index_tables"], 1)
        self.assertEqual(records[0]["index_table_bytes"], 237)
        self.assertEqual(records[0]["jump_tables"], 2)
        self.assertEqual(records[0]["jump_table_bytes"], sum(i.length for i in jumps))
        code = next(i for i in items if i.kind == "code")
        self.assertEqual(records[0]["length"], code.length)  # the function length counts code only

    def test_switch_table_that_no_structured_group_generates_is_refused(self):
        with self.assertRaisesRegex(compose_image.ComposeError, "not generated by a structured group"):
            self.bind(self.make_batch(self.TABLE_BATCH, "no-structured"), [])

    def test_index_table_that_differs_from_the_audited_original_is_refused(self):
        def edit(manifest, report):
            for item in report["functions"][0]["data_items"]:
                if item["kind"] == "index_table":
                    item["sha256"] = "0" * 64

        with self.assertRaisesRegex(compose_image.ComposeError, "differs from the audited original index table"):
            self.bind(self.make_batch(self.TABLE_BATCH, "bad-table", edit), self.structured_for(self.TABLE_BATCH))

    def test_data_items_that_disagree_with_the_manifest_are_refused(self):
        def edit(manifest, report):
            report["functions"][0]["data_items"] = report["functions"][0]["data_items"][:-1]

        with self.assertRaisesRegex(compose_image.ComposeError, "audited data items"):
            self.bind(self.make_batch(self.TABLE_BATCH, "short-items", edit), self.structured_for(self.TABLE_BATCH))

    def test_padding_binds_as_its_own_class_unless_a_structured_group_generates_it(self):
        items, records = self.bind(self.make_batch(self.PADDING_BATCH, "padding"), [])
        padding = [i for i in items if i.provenance == compose_image.ASM_PADDING_CLASS]
        self.assertEqual([(i.name, i.length, i.kind) for i in padding], [("PAD_004fcee8", 8, "data")])
        self.assertEqual(records[0]["padding_bytes"], 8)
        offset = padding[0].offset
        items, _ = self.bind(self.make_batch(self.PADDING_BATCH, "padding-structured"), [(offset - 2, 12)])
        # padding inside a structured range (int 3 fill) is bound too and replaces the structured item
        self.assertEqual([(i.kind, i.replaces_structured) for i in items], [("code", False), ("data", True)])
        with self.assertRaisesRegex(compose_image.ComposeError, "partly overlaps"):
            self.bind(self.make_batch(self.PADDING_BATCH, "padding-partial"), [(offset + 4, 8)])


@needs_toolchain
class DeriveReproducibilityTests(OriginalMixin, unittest.TestCase):
    def test_derive_regenerates_the_committed_descriptions(self):
        work = Path(self.tmp.name) / "derive"
        work.mkdir()
        shutil.copy(IMAGE_DIR / "reconstructed.json", work / "reconstructed.json")
        compose_image.derive(ORIGINAL, work, compose_image.DEFAULT_FUNCTION_INDEX, ASSEMBLER, self.build_dir)
        for name in ("layout", "imports", "resources", "text_data", "ranges"):
            self.assertEqual((work / f"{name}.json").read_bytes(), (IMAGE_DIR / f"{name}.json").read_bytes(), name)

    def test_rejects_a_file_that_is_not_the_pinned_original(self):
        fake = Path(self.tmp.name) / "GAME.EXE"
        fake.write_bytes(self.original[:-1] + bytes([self.original[-1] ^ 1]))
        with self.assertRaises(compose_image.ComposeError):
            compose_image.compose(IMAGE_DIR, fake, self.build_dir)


if __name__ == "__main__":
    unittest.main()
