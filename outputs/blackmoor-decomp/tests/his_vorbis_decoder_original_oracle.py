#!/usr/bin/env python3
"""FL-9: compare the original Ogg/Vorbis decoder with the native HIS adapter.

GAME.EXE statically links libvorbisfile/libvorbis.  This oracle runs that code
unmodified under Unicorn on the Ogg payload of real CDSound ``.HIS`` files,
the way the game's HIS loader does:

* ``0x4fcff0``  ov_open_callbacks(file, vf, 0, 0, read, seek, close, tell)
* ``0x4fe2d0``  ov_read(vf, buf, len, bigendian=0, word, sgned, &bitstream),
                called until the header's decoded byte count is filled
                (``0x4f5b50``), word/sgned from the HIS sample depth.

Only the C-runtime allocator (malloc ``0x50ea90``, calloc ``0x50e97e``,
realloc ``0x50ebca``, free ``0x50e936``) and the four stdio-style file
callbacks are host-side stubs; every decoder, windowing, MDCT, residue and
float-to-PCM routine executes from the hash-verified GAME.EXE image.  The
file callbacks emulate a C ``FILE`` that the game left positioned after the
30-byte HIS header.

The native side is ``his_audio_decode_memory`` (FFmpeg adapter) followed by
``his_pcm_quantize_planar`` (the native twin of ``0x4fe2d0``'s float to PCM
path), producing the same 8/16-bit little-endian bytes the original returns.
Comparison is byte equality of the first ``decoded_bytes`` bytes.

Run (the script re-executes itself under work/tools/oracle-python, which has
Unicorn):

    python3 outputs/blackmoor-decomp/tests/his_vorbis_decoder_original_oracle.py \
        --sample 24 --jobs 6 --report work/analysis/FL-9/sample.json

No output device, GUI or game file modification: CDSound files are read in
place, read-only.
"""

from __future__ import annotations

import argparse
import array
import ctypes
import hashlib
import json
import os
import struct
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "outputs/blackmoor-decomp"
ORACLE_PYTHON = ROOT / "work/tools/oracle-python/bin/python"
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
GAME_SOURCE = ROOT / "work/analysis/game-source.json"
HIS_AUDIO_LIB = PROJECT / "build/libhis_audio.dylib"
QUANTIZE_LIB = PROJECT / "build/libhis_pcm_quantize.dylib"
EXPECTED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"

# Original code entry points (GAME.EXE virtual addresses).
OV_OPEN_CALLBACKS_VA = 0x004FCFF0
OV_READ_VA = 0x004FE2D0
MALLOC_VA = 0x0050EA90
CALLOC_VA = 0x0050E97E
REALLOC_VA = 0x0050EBCA
FREE_VA = 0x0050E936
ERRNO_VA = 0x0050EA7E
DOSERRNO_VA = 0x0050EA87

HEADER_BYTES = 30
PAGE = 0x1000
STACK_BASE = 0x10000000
STACK_SIZE = 0x100000
HEAP_BASE = 0x40000000
HEAP_SIZE = 0x30000000
STUB_BASE = 0x31000000
SENTINEL = STUB_BASE + 0x800
STUB_READ = STUB_BASE + 0x00
STUB_SEEK = STUB_BASE + 0x10
STUB_CLOSE = STUB_BASE + 0x20
STUB_TELL = STUB_BASE + 0x30
FILE_HANDLE = 0x00700001
VF_SIZE = 0x400
X87_CW_DEFAULT = 0x027F  # MSVC/Win32 process default: 53-bit precision, nearest-even


class OracleError(RuntimeError):
    pass


def _ensure_oracle_python() -> None:
    try:
        import unicorn  # noqa: F401
        return
    except ImportError:
        pass
    if os.environ.get("HIS_ORACLE_REEXEC") == "1" or not ORACLE_PYTHON.is_file():
        raise OracleError("Unicorn 2.x is required (work/tools/oracle-python)")
    os.environ["HIS_ORACLE_REEXEC"] = "1"
    os.execv(str(ORACLE_PYTHON), [str(ORACLE_PYTHON), *sys.argv])


def align_up(value: int, alignment: int = PAGE) -> int:
    return (value + alignment - 1) & ~(alignment - 1)


class PE:
    def __init__(self, path: Path) -> None:
        data = path.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        if digest != EXPECTED_EXE_SHA256:
            raise OracleError(f"GAME.EXE SHA-256 mismatch: {digest}")
        self.sha256 = digest
        pe = struct.unpack_from("<I", data, 0x3C)[0]
        if data[pe:pe + 4] != b"PE\0\0":
            raise OracleError("bad PE signature")
        sections, = struct.unpack_from("<H", data, pe + 6)
        opt_size, = struct.unpack_from("<H", data, pe + 20)
        opt = pe + 24
        self.image_base, = struct.unpack_from("<I", data, opt + 28)
        self.size_of_image, = struct.unpack_from("<I", data, opt + 56)
        headers, = struct.unpack_from("<I", data, opt + 60)
        image = bytearray(self.size_of_image)
        image[:headers] = data[:headers]
        table = opt + opt_size
        for index in range(sections):
            record = data[table + index * 40:table + (index + 1) * 40]
            vsize, vaddr, rsize, roff = struct.unpack_from("<IIII", record, 8)
            if rsize:
                image[vaddr:vaddr + rsize] = data[roff:roff + rsize]
        self.image = bytes(image)
        self.imports = self._import_names(opt)

    def _import_names(self, opt: int) -> dict[int, str]:
        """Map an unbound IAT value (hint/name RVA) to 'dll!function'."""
        names: dict[int, str] = {}
        directory, = struct.unpack_from("<I", self.image, opt + 104)
        position = directory
        while True:
            original, _stamp, _forward, name_rva, first = struct.unpack_from(
                "<IIIII", self.image, position)
            if not name_rva:
                break
            dll = self.image[name_rva:self.image.index(b"\0", name_rva)].decode("ascii")
            cursor = original or first
            while True:
                value, = struct.unpack_from("<I", self.image, cursor)
                if not value:
                    break
                if not value & 0x80000000:
                    start = value + 2
                    names[value] = dll + "!" + self.image[
                        start:self.image.index(b"\0", start)].decode("ascii")
                cursor += 4
            position += 20
        return names


_PE_CACHE: dict[str, PE] = {}


def load_pe(path: Path) -> PE:
    key = str(path)
    if key not in _PE_CACHE:
        _PE_CACHE[key] = PE(path)
    return _PE_CACHE[key]


class OriginalVorbis:
    """One fresh emulator instance decoding one HIS file with the original code."""

    def __init__(self, exe: Path, file_bytes: bytes, fpcw: int) -> None:
        from unicorn import (Uc, UC_ARCH_X86, UC_HOOK_CODE, UC_MODE_32, UC_PROT_ALL,
                             UC_HOOK_MEM_UNMAPPED)
        from unicorn import x86_const as x
        self.x = x
        self.file = file_bytes
        self.position = HEADER_BYTES
        self.fpcw = fpcw
        self.pe = load_pe(exe)
        self.uc = uc = Uc(UC_ARCH_X86, UC_MODE_32)
        base = self.pe.image_base & ~(PAGE - 1)
        uc.mem_map(base, align_up(self.pe.image_base + self.pe.size_of_image) - base, UC_PROT_ALL)
        uc.mem_write(self.pe.image_base, self.pe.image)
        uc.mem_map(STACK_BASE, STACK_SIZE, UC_PROT_ALL)
        uc.mem_map(HEAP_BASE, HEAP_SIZE, UC_PROT_ALL)
        uc.mem_map(STUB_BASE, PAGE, UC_PROT_ALL)
        # Allocator state (host side).
        self.brk = HEAP_BASE + 0x1000
        self.sizes: dict[int, int] = {}
        self.free_lists: dict[int, list[int]] = {}
        self.calls = {"malloc": 0, "calloc": 0, "realloc": 0, "free": 0, "read": 0, "seek": 0}
        self.fault: str | None = None

        def ret(result: int | None = None) -> None:
            esp = uc.reg_read(x.UC_X86_REG_ESP)
            address = struct.unpack("<I", uc.mem_read(esp, 4))[0]
            if result is not None:
                uc.reg_write(x.UC_X86_REG_EAX, result & 0xFFFFFFFF)
            uc.reg_write(x.UC_X86_REG_ESP, esp + 4)
            uc.reg_write(x.UC_X86_REG_EIP, address)

        def arg(index: int) -> int:
            esp = uc.reg_read(x.UC_X86_REG_ESP)
            return struct.unpack("<I", uc.mem_read(esp + 4 + 4 * index, 4))[0]

        def on_malloc(_uc, _a, _s, _d):
            self.calls["malloc"] += 1
            ret(self.alloc(arg(0), zero=False))

        def on_calloc(_uc, _a, _s, _d):
            self.calls["calloc"] += 1
            ret(self.alloc(arg(0) * arg(1), zero=True))

        def on_realloc(_uc, _a, _s, _d):
            self.calls["realloc"] += 1
            ret(self.realloc(arg(0), arg(1)))

        def on_free(_uc, _a, _s, _d):
            self.calls["free"] += 1
            self.release(arg(0))
            ret(0)

        def on_read(_uc, _a, _s, _d):
            # fread(ptr, size, nmemb, stream)
            self.calls["read"] += 1
            pointer, size, count = arg(0), arg(1), arg(2)
            wanted = size * count
            chunk = self.file[self.position:self.position + wanted]
            if chunk:
                uc.mem_write(pointer, chunk)
            self.position += len(chunk)
            ret(len(chunk) // size if size else 0)

        def on_seek(_uc, _a, _s, _d):
            # seek(stream, offset_lo, offset_hi, whence), 64-bit offset
            self.calls["seek"] += 1
            low, high, whence = arg(1), arg(2), arg(3)
            offset = (high << 32) | low
            if offset & (1 << 63):
                offset -= 1 << 64
            if whence == 0:
                target = offset
            elif whence == 1:
                target = self.position + offset
            elif whence == 2:
                target = len(self.file) + offset
            else:
                ret(0xFFFFFFFF)
                return
            if target < 0:
                ret(0xFFFFFFFF)
                return
            self.position = target
            ret(0)

        self.errno_cell = HEAP_BASE + 0x100
        self.doserrno_cell = HEAP_BASE + 0x104
        self.errno_callers: dict[int, int] = {}

        def on_errno(_uc, _a, _s, _d):
            # _errno(): per-thread data lives behind TLS in the original; one cell here.
            esp = uc.reg_read(x.UC_X86_REG_ESP)
            caller = struct.unpack("<I", uc.mem_read(esp, 4))[0]
            self.errno_callers[caller] = self.errno_callers.get(caller, 0) + 1
            ret(self.errno_cell)

        def on_doserrno(_uc, _a, _s, _d):
            ret(self.doserrno_cell)

        def on_close(_uc, _a, _s, _d):
            ret(0)

        def on_tell(_uc, _a, _s, _d):
            ret(self.position)

        for address, callback in ((MALLOC_VA, on_malloc), (CALLOC_VA, on_calloc),
                                  (REALLOC_VA, on_realloc), (FREE_VA, on_free),
                                  (STUB_READ, on_read), (STUB_SEEK, on_seek),
                                  (STUB_CLOSE, on_close), (STUB_TELL, on_tell),
                                  (ERRNO_VA, on_errno), (DOSERRNO_VA, on_doserrno)):
            uc.hook_add(UC_HOOK_CODE, callback, begin=address, end=address)

        def on_unmapped(_uc, access, address, size, value, _d):
            self.fault = (f"unmapped access type={access} address=0x{address:08x} size={size} "
                          f"eip=0x{uc.reg_read(x.UC_X86_REG_EIP):08x}")
            return False

        uc.hook_add(UC_HOOK_MEM_UNMAPPED, on_unmapped)

    # --- host allocator -------------------------------------------------
    def alloc(self, size: int, zero: bool) -> int:
        size = max(size, 1)
        rounded = (size + 15) & ~15
        bucket = self.free_lists.get(rounded)
        if bucket:
            pointer = bucket.pop()
            if zero:
                self.uc.mem_write(pointer, bytes(rounded))
        else:
            pointer = self.brk
            self.brk += rounded + 16
            if self.brk > HEAP_BASE + HEAP_SIZE:
                raise OracleError("emulated heap exhausted")
        self.sizes[pointer] = rounded
        return pointer

    def release(self, pointer: int) -> None:
        if not pointer:
            return
        rounded = self.sizes.pop(pointer, None)
        if rounded is None:
            raise OracleError(f"free of unknown pointer 0x{pointer:08x}")
        self.free_lists.setdefault(rounded, []).append(pointer)

    def realloc(self, pointer: int, size: int) -> int:
        if not pointer:
            return self.alloc(size, zero=False)
        if size == 0:
            self.release(pointer)
            return 0
        old = self.sizes.get(pointer)
        if old is None:
            raise OracleError(f"realloc of unknown pointer 0x{pointer:08x}")
        if size <= old:
            return pointer
        fresh = self.alloc(size, zero=False)
        self.uc.mem_write(fresh, bytes(self.uc.mem_read(pointer, old)))
        self.release(pointer)
        return fresh

    # --- calling original code -----------------------------------------
    def call(self, address: int, args: list[int], max_instructions: int = 400_000_000) -> int:
        x = self.x
        uc = self.uc
        esp = STACK_BASE + STACK_SIZE - 0x1000
        frame = struct.pack(f"<I{len(args)}I", SENTINEL, *args)
        esp -= len(frame)
        uc.mem_write(esp, frame)
        for name in ("EAX", "EBX", "ECX", "EDX", "ESI", "EDI", "EBP"):
            uc.reg_write(getattr(x, f"UC_X86_REG_{name}"), 0)
        uc.reg_write(x.UC_X86_REG_ESP, esp)
        uc.reg_write(x.UC_X86_REG_EIP, address)
        uc.reg_write(x.UC_X86_REG_EFLAGS, 0x202)
        uc.reg_write(x.UC_X86_REG_FPCW, self.fpcw)
        self.fault = None
        try:
            uc.emu_start(address, SENTINEL, timeout=0, count=max_instructions)
        except Exception as exc:
            eip = uc.reg_read(x.UC_X86_REG_EIP)
            esp_now = uc.reg_read(x.UC_X86_REG_ESP)
            try:
                stack = struct.unpack("<4I", uc.mem_read(esp_now, 16))
            except Exception:
                stack = ()
            imported = self.pe.imports.get(eip - self.pe.image_base) or self.pe.imports.get(eip)
            raise OracleError(
                f"emulation of 0x{address:08x} failed: {exc}; {self.fault or 'no unmapped access'}; "
                f"eip=0x{eip:08x} import={imported} stack={[hex(v) for v in stack]}") from exc
        eip = uc.reg_read(x.UC_X86_REG_EIP)
        if eip != SENTINEL:
            raise OracleError(f"call to 0x{address:08x} stopped at eip=0x{eip:08x} "
                              f"({'instruction limit' if True else ''})")
        return uc.reg_read(x.UC_X86_REG_EAX)

    def decode(self, total_bytes: int, bits: int) -> tuple[bytes, dict]:
        vf = self.alloc(VF_SIZE, zero=True)
        result = self.call(OV_OPEN_CALLBACKS_VA,
                           [FILE_HANDLE, vf, 0, 0, STUB_READ, STUB_SEEK, STUB_CLOSE, STUB_TELL])
        result = result - (1 << 32) if result & 0x80000000 else result
        if result < 0:
            return b"", {"open_result": result, "status": "original_open_failed"}
        buffer = self.alloc(total_bytes + 16, zero=True)
        bitstream = self.alloc(16, zero=True)
        word = 1 if bits == 8 else 2
        sgned = 0 if bits == 8 else 1
        got = 0
        reads = 0
        status = "ok"
        while got < total_bytes:
            count = self.call(OV_READ_VA,
                              [vf, buffer + got, total_bytes - got, 0, word, sgned, bitstream])
            count = count - (1 << 32) if count & 0x80000000 else count
            reads += 1
            if count < 0:
                status = f"original_read_error_{count}"
                break
            if count == 0:
                status = "original_eof_short"
                break
            got += count
        data = bytes(self.uc.mem_read(buffer, got))
        return data, {"open_result": result, "status": status, "ov_read_calls": reads,
                      "allocator": dict(self.calls),
                      "errno_callers": {f"0x{k:08x}": v for k, v in self.errno_callers.items()}}


# --- native side --------------------------------------------------------
class HisAudio(ctypes.Structure):
    _fields_ = [("sample_rate", ctypes.c_uint32), ("channels", ctypes.c_uint32),
                ("frame_count", ctypes.c_uint64),
                ("interleaved_pcm", ctypes.POINTER(ctypes.c_float))]


def load_native():
    audio = ctypes.CDLL(str(HIS_AUDIO_LIB))
    audio.his_audio_decode_memory.argtypes = [
        ctypes.c_char_p, ctypes.c_size_t, ctypes.POINTER(HisAudio),
        ctypes.c_char_p, ctypes.c_size_t]
    audio.his_audio_decode_memory.restype = ctypes.c_int
    audio.his_audio_destroy.argtypes = [ctypes.POINTER(HisAudio)]
    quant = ctypes.CDLL(str(QUANTIZE_LIB))
    quant.his_pcm_quantize_planar.argtypes = [
        ctypes.POINTER(ctypes.POINTER(ctypes.c_float)), ctypes.c_uint32, ctypes.c_uint64,
        ctypes.c_uint32, ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_uint64)]
    quant.his_pcm_quantize_planar.restype = ctypes.c_int
    return audio, quant


def native_pcm(audio_lib, quant_lib, file_bytes: bytes, bits: int) -> tuple[bytes | None, str, dict]:
    decoded = HisAudio()
    error = ctypes.create_string_buffer(256)
    status = audio_lib.his_audio_decode_memory(file_bytes, len(file_bytes), ctypes.byref(decoded),
                                               error, len(error))
    if status != 0:
        return None, f"native_decode_error: {error.value.decode('utf-8', 'replace')}", {}
    try:
        frames, channels = decoded.frame_count, decoded.channels
        count = frames * channels
        interleaved = (ctypes.c_float * count).from_address(
            ctypes.addressof(decoded.interleaved_pcm.contents))
        floats = array.array("f")
        floats.frombytes(bytes(interleaved))
        planes = [array.array("f", floats[channel::channels]) for channel in range(channels)]
        pointers = (ctypes.POINTER(ctypes.c_float) * channels)(*(
            ctypes.cast(plane.buffer_info()[0], ctypes.POINTER(ctypes.c_float)) for plane in planes))
        bytes_per_frame = channels * (bits // 8)
        capacity = frames * bytes_per_frame
        out = (ctypes.c_uint8 * capacity)()
        written = ctypes.c_uint64()
        q = quant_lib.his_pcm_quantize_planar(pointers, channels, frames, bits, out, capacity,
                                              ctypes.byref(written))
        if q != 0:
            return None, f"native_quantize_error_{q}", {}
        return bytes(out), "ok", {"sample_rate": decoded.sample_rate, "channels": channels,
                                  "frames": frames}
    finally:
        audio_lib.his_audio_destroy(ctypes.byref(decoded))


def parse_his(data: bytes) -> dict | None:
    if len(data) < HEADER_BYTES or data[:4] != b"HIS\0":
        return None
    version, fmt, channels, rate, avg, align, bits, decoded, kind = struct.unpack_from(
        "<IHHIIHHIH", data, 4)
    return {"version": version, "channels": channels, "sample_rate": rate, "bits": bits,
            "decoded_bytes": decoded, "kind": kind}


def sample_difference(original: bytes, native: bytes, bits: int) -> dict:
    sample_bytes = bits // 8
    count = min(len(original), len(native)) // sample_bytes
    if bits == 16:
        a = array.array("h", original[:count * 2])
        b = array.array("h", native[:count * 2])
    else:
        a = array.array("B", original[:count])
        b = array.array("B", native[:count])
    differing = 0
    max_delta = 0
    first = -1
    histogram: dict[int, int] = {}
    for index in range(count):
        if a[index] != b[index]:
            delta = abs(a[index] - b[index])
            differing += 1
            if first < 0:
                first = index
            if delta > max_delta:
                max_delta = delta
            if delta <= 4:
                histogram[delta] = histogram.get(delta, 0) + 1
    return {"samples": count, "differing_samples": differing, "max_abs_delta_lsb": max_delta,
            "first_difference_sample": first, "delta_histogram_le4": histogram}


def compare_file(task: tuple[str, str, int]) -> dict:
    path_text, exe_text, fpcw = task
    path = Path(path_text)
    started = time.time()
    result: dict = {"file": path.name}
    try:
        data = path.read_bytes()
        header = parse_his(data)
        if header is None:
            result.update(status="not_his")
            return result
        result.update(channels=header["channels"], sample_rate=header["sample_rate"],
                      bits=header["bits"], decoded_bytes=header["decoded_bytes"],
                      kind=header["kind"])
        if header["kind"] != 2 or data[HEADER_BYTES:HEADER_BYTES + 4] != b"OggS":
            result.update(status="not_ogg")
            return result
        audio_lib, quant_lib = load_native()
        native, native_status, native_info = native_pcm(audio_lib, quant_lib, data, header["bits"])
        original_vm = OriginalVorbis(Path(exe_text), data, fpcw)
        original, info = original_vm.decode(header["decoded_bytes"], header["bits"])
        result["original"] = info
        result["original_bytes"] = len(original)
        result["original_sha256"] = hashlib.sha256(original).hexdigest()
        if native is None:
            result.update(status="native_error", native_status=native_status)
        else:
            result["native_bytes"] = len(native)
            result["native_sha256"] = hashlib.sha256(native).hexdigest()
            if info["status"] != "ok":
                result["status"] = "original_failed"
            elif original == native:
                result["status"] = "match"
            else:
                result["status"] = "mismatch"
                result["difference"] = sample_difference(original, native, header["bits"])
    except Exception as exc:  # reported per file, never hidden
        result["status"] = "harness_error"
        result["error"] = f"{type(exc).__name__}: {exc}"
    result["seconds"] = round(time.time() - started, 2)
    return result


def describe(result: dict) -> str:
    line = f"{result['file']}: {result['status']} ({result.get('seconds', 0)}s)"
    if "error" in result:
        line += f" {result['error']}"
    difference = result.get("difference")
    if difference:
        line += (f" differing={difference['differing_samples']}/{difference['samples']}"
                 f" max_delta={difference['max_abs_delta_lsb']}")
    return line


def game_directory() -> Path:
    return Path(json.loads(GAME_SOURCE.read_text())["game_dir"])


def pick_files(directory: Path, names: list[str] | None, sample: int | None,
               limit_bytes: int | None) -> list[Path]:
    files = sorted(p for p in directory.iterdir() if p.suffix.lower() == ".his")
    ogg = []
    for path in files:
        with path.open("rb") as handle:
            head = handle.read(HEADER_BYTES + 4)
        if len(head) >= HEADER_BYTES + 4 and head[:4] == b"HIS\0" \
                and struct.unpack_from("<H", head, 28)[0] == 2 and head[30:34] == b"OggS":
            ogg.append(path)
    if names:
        wanted = {name.lower() for name in names}
        ogg = [p for p in ogg if p.name.lower() in wanted]
    if limit_bytes:
        ogg = [p for p in ogg if p.stat().st_size <= limit_bytes]
    if sample and sample < len(ogg):
        by_size = sorted(ogg, key=lambda p: (p.stat().st_size, p.name))
        step = len(by_size) / sample
        ogg = [by_size[int(step * i + step / 2)] for i in range(sample)]
    return ogg


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--dir", type=Path, default=None, help="CDSound directory")
    parser.add_argument("--names", nargs="*", help="only these .HIS names")
    parser.add_argument("--sample", type=int, help="size-stratified sample of N Ogg files")
    parser.add_argument("--limit-bytes", type=int, help="skip files larger than this")
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--fpcw", type=lambda text: int(text, 0), default=X87_CW_DEFAULT)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()

    _ensure_oracle_python()
    directory = args.dir or game_directory() / "CDSound"
    files = pick_files(directory, args.names, args.sample, args.limit_bytes)
    tasks = [(str(path), str(args.exe), args.fpcw) for path in files]
    started = time.time()
    results = []
    if args.jobs > 1:
        import multiprocessing
        with multiprocessing.get_context("fork").Pool(args.jobs) as pool:
            for result in pool.imap_unordered(compare_file, tasks, chunksize=1):
                results.append(result)
                print(describe(result), flush=True)
    else:
        for task in tasks:
            result = compare_file(task)
            results.append(result)
            print(describe(result), flush=True)
    results.sort(key=lambda item: item["file"].lower())
    counts: dict[str, int] = {}
    for item in results:
        counts[item["status"]] = counts.get(item["status"], 0) + 1
    pe = load_pe(args.exe)
    report = {
        "exe_sha256": pe.sha256,
        "fpcw": f"0x{args.fpcw:04x}",
        "entry_points": {"ov_open_callbacks": f"0x{OV_OPEN_CALLBACKS_VA:08x}",
                         "ov_read": f"0x{OV_READ_VA:08x}"},
        "host_stubs": ["malloc 0x50ea90", "calloc 0x50e97e", "realloc 0x50ebca", "free 0x50e936",
                       "fread/fseek/fclose/ftell file callbacks"],
        "native_libraries": {
            "his_audio": hashlib.sha256(HIS_AUDIO_LIB.read_bytes()).hexdigest(),
            "his_pcm_quantize": hashlib.sha256(QUANTIZE_LIB.read_bytes()).hexdigest()},
        "files": len(results),
        "counts": counts,
        "wall_seconds": round(time.time() - started, 1),
        "results": results,
    }
    summary = {k: v for k, v in report.items() if k != "results"}
    print(json.dumps(summary, indent=2))
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=1) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
