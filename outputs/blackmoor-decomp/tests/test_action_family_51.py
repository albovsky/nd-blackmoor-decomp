import ctypes as c
from pathlib import Path
import struct
import unittest


PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
LIBRARY = PROJECT / "build/libactionfamily51.dylib"
SCENE_LIBRARY = PROJECT / "build/libsceneresource.dylib"
AUTOTEXT_LIBRARY = PROJECT / "build/libautotext.dylib"
RESOURCES = ROOT / "work/analysis/hiff-resources"
AUTOTEXT_RESOURCE = RESOURCES / "0001.bin"

OK, ERR_ARGUMENT, ERR_BODY, ERR_LIMIT, ERR_UNSUPPORTED, ERR_BACKEND = range(6)
SOURCE_INLINE, SOURCE_AUTO_TEXT, SOURCE_MISSING = range(3)
LOOKUP_FOUND, LOOKUP_NOT_FOUND, LOOKUP_ERROR = range(3)
BACKEND_OK, BACKEND_ERROR = range(2)
MISSING_FORMAT = b"Game Error (please contact Tech Support) missing auto text: %s<n>"


class Decoded(c.Structure):
    _fields_ = [
        ("source", c.c_int),
        ("selector", c.c_int16),
        ("renderer", c.c_int16),
        ("wait", c.c_int16),
        ("sound_channel", c.c_int16),
        ("wait_milliseconds", c.c_uint32),
        ("body_length", c.c_size_t),
        ("payload_length", c.c_size_t),
        ("text_length", c.c_uint16),
        ("auto_text_key", c.c_char * 34),
    ]


class World(c.Structure):
    _fields_ = [
        ("timer_deadline", c.c_uint32),
        ("frame_text_flag", c.c_int32),
        ("caption_finish_flag", c.c_int32),
    ]


LOOKUP = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t,
                     c.POINTER(c.POINTER(c.c_uint8)), c.POINTER(c.c_size_t))
MEASURE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t,
                      c.POINTER(c.c_int16))
WRITE = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t)
OPEN = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int32, c.POINTER(c.c_uint8),
                   c.c_size_t)
CLOSE = c.CFUNCTYPE(c.c_int, c.c_void_p)
PLAYING = c.CFUNCTYPE(c.c_int, c.c_void_p, c.c_int16, c.POINTER(c.c_int))
TICK = c.CFUNCTYPE(c.c_int, c.c_void_p, c.POINTER(c.c_uint32))


class Backend(c.Structure):
    _fields_ = [
        ("context", c.c_void_p),
        ("measure_caption_lines", MEASURE),
        ("write_caption", WRITE),
        ("open_frame_text", OPEN),
        ("close_frame_text", CLOSE),
        ("is_channel_playing", PLAYING),
        ("tick_count", TICK),
    ]


class Input(c.Structure):
    _fields_ = [
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("eligible", c.c_uint8),
        ("completed_before", c.c_uint8),
        ("phase_before", c.c_uint32),
        ("payload", c.POINTER(c.c_uint8)),
        ("payload_length", c.c_size_t),
    ]


class Result(c.Structure):
    _fields_ = [
        ("recognized", c.c_uint8),
        ("applied", c.c_uint8),
        ("completion_called", c.c_uint8),
        ("completed", c.c_uint8),
        ("reset_dependencies", c.c_uint8),
        ("renderer_selected", c.c_uint8),
        ("reserved", c.c_uint8 * 2),
        ("phase", c.c_uint32),
    ]


def bind(path=LIBRARY):
    library = c.CDLL(str(path))
    library.action_family_51_body_length.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(c.c_size_t)]
    library.action_family_51_body_length.restype = c.c_int
    library.action_family_51_decode.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, LOOKUP, c.c_void_p,
        c.POINTER(c.c_uint8), c.c_size_t, c.POINTER(Decoded)]
    library.action_family_51_decode.restype = c.c_int
    library.action_family_51_step.argtypes = [
        c.POINTER(Input), c.POINTER(World), c.POINTER(Backend), c.POINTER(Result)]
    library.action_family_51_step.restype = c.c_int
    library.action_family_51_status_string.argtypes = [c.c_int]
    library.action_family_51_status_string.restype = c.c_char_p
    return library


def buffer(data):
    return (c.c_uint8 * max(1, len(data))).from_buffer_copy(data or b"\0")


def header(renderer=1, wait=0, channel=0, milliseconds=0, selector=-1):
    return struct.pack("<hhhIh", renderer, wait, channel, milliseconds, selector)


def auto_text_body(key, **fields):
    return header(selector=-1, **fields) + key.ljust(33, b"\0")


def inline_body(text, **fields):
    return header(selector=len(text), **fields) + text


class DictionaryLookup:
    """Lookup callback over a Python mapping; values follow C-string rules."""

    def __init__(self, entries, error=False):
        self.entries = entries
        self.error = error
        self.calls = []
        self._held = None
        self.callback = LOOKUP(self._lookup)

    def _lookup(self, _context, key, key_length, text, text_length):
        name = bytes(key[:key_length])
        self.calls.append(name)
        if self.error:
            return LOOKUP_ERROR
        # The original compares keys ASCII case-insensitively.
        matches = [value for entry, value in self.entries.items()
                   if entry.upper() == name.upper()]
        if not matches:
            return LOOKUP_NOT_FOUND
        value = matches[0]
        self._held = buffer(value)
        text[0] = c.cast(self._held, c.POINTER(c.c_uint8))
        text_length[0] = len(value)
        return LOOKUP_FOUND


class RecordingBackend:
    """Typed backend that records every host boundary call in order."""

    def __init__(self, lines=1, playing=0, ticks=(), fail=None):
        self.lines = lines
        self.playing = playing
        self.ticks = list(ticks)
        self.fail = fail
        self.calls = []
        self.struct = Backend(
            None,
            MEASURE(self._measure),
            WRITE(self._write),
            OPEN(self._open),
            CLOSE(self._close),
            PLAYING(self._playing),
            TICK(self._tick),
        )

    def _status(self, name):
        return BACKEND_ERROR if self.fail == name else BACKEND_OK

    def _measure(self, _context, text, length, lines):
        self.calls.append(("measure", bytes(text[:length])))
        lines[0] = self.lines
        return self._status("measure")

    def _write(self, _context, text, length):
        self.calls.append(("write_caption", bytes(text[:length])))
        return self._status("write_caption")

    def _open(self, _context, mode, text, length):
        self.calls.append(("open_frame_text", mode, bytes(text[:length])))
        return self._status("open_frame_text")

    def _close(self, _context):
        self.calls.append(("close_frame_text",))
        return self._status("close_frame_text")

    def _playing(self, _context, channel, playing):
        self.calls.append(("is_channel_playing", channel))
        playing[0] = self.playing
        return self._status("is_channel_playing")

    def _tick(self, _context, now):
        value = self.ticks.pop(0) if self.ticks else 0
        self.calls.append(("tick_count", value))
        now[0] = value
        return self._status("tick_count")


def decode(library, body, lookup=None):
    lookup = lookup or DictionaryLookup({})
    decoded = Decoded()
    data = buffer(body)
    status = library.action_family_51_decode(
        data, len(body), lookup.callback, None, None, 0, c.byref(decoded))
    if status != OK:
        return status, None, decoded
    # Pattern-fill (distinct from the oracle's 0xa5 arena) so every byte of
    # the record must come from the decoder.
    payload = (c.c_uint8 * decoded.payload_length)(*([0x5A] * decoded.payload_length))
    status = library.action_family_51_decode(
        data, len(body), lookup.callback, None, payload, len(payload),
        c.byref(decoded))
    return status, payload, decoded


def step(library, payload, *, phase=0, subtype=1, eligible=1, completed=0,
         world=None, backend=None, action_type=0x51):
    world = world or World()
    backend = backend or RecordingBackend()
    action = Input(action_type, subtype, eligible, completed, phase,
                   c.cast(payload, c.POINTER(c.c_uint8)) if payload is not None else None,
                   len(payload) if payload is not None else 0)
    result = Result()
    status = library.action_family_51_step(
        c.byref(action), c.byref(world), c.byref(backend.struct), c.byref(result))
    return status, result, world, backend


class ActionFamily51BodyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            raise unittest.SkipTest("Build with scripts/build_action_family_51.sh first")
        cls.lib = bind()

    def body_length(self, raw):
        length = c.c_size_t(0)
        status = self.lib.action_family_51_body_length(buffer(raw), len(raw), c.byref(length))
        return status, length.value

    def test_auto_text_body_is_45_bytes_before_dependencies(self):
        raw = auto_text_body(b"MDM57") + bytes(32)
        self.assertEqual(self.body_length(raw), (OK, 45))

    def test_inline_body_is_header_plus_selector(self):
        raw = inline_body(b"abc\0") + bytes(16)
        self.assertEqual(self.body_length(raw), (OK, 16))
        self.assertEqual(self.body_length(inline_body(b"")), (OK, 12))

    def test_inline_selector_limit_and_negative_values_fail(self):
        for selector in (10000, 32767, -2, -12, -32768):
            raw = header(selector=selector) + bytes(64)
            self.assertEqual(self.body_length(raw)[0], ERR_BODY, selector)
        self.assertEqual(self.body_length(header(selector=9999) + bytes(9999)),
                         (OK, 10011))

    def test_truncated_bodies_fail(self):
        self.assertEqual(self.body_length(header()[:11])[0], ERR_BODY)
        self.assertEqual(self.body_length(auto_text_body(b"K")[:44])[0], ERR_BODY)
        self.assertEqual(self.body_length(inline_body(b"abcd")[:15])[0], ERR_BODY)


class ActionFamily51DecodeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            raise unittest.SkipTest("Build with scripts/build_action_family_51.sh first")
        cls.lib = bind()

    def test_inline_record_appends_marker_without_terminator(self):
        body = inline_body(b"Hi\0\0", renderer=0, wait=2, channel=0, milliseconds=9999)
        status, payload, decoded = decode(self.lib, body)
        self.assertEqual(status, OK)
        self.assertEqual(decoded.source, SOURCE_INLINE)
        self.assertEqual(decoded.body_length, 16)
        self.assertEqual(decoded.payload_length, 19)
        self.assertEqual(decoded.text_length, 7)
        self.assertEqual(bytes(payload), body[:10] + struct.pack("<H", 7) + b"Hi\0\0<e>")
        self.assertEqual((decoded.renderer, decoded.wait, decoded.wait_milliseconds), (0, 2, 9999))

    def test_auto_text_record_stores_caption_marker_and_nul(self):
        lookup = DictionaryLookup({b"MDM57": b"Hello<n>there"})
        body = auto_text_body(b"MDM57", renderer=1, channel=12, milliseconds=10000)
        status, payload, decoded = decode(self.lib, body, lookup)
        self.assertEqual(status, OK)
        self.assertEqual(decoded.source, SOURCE_AUTO_TEXT)
        self.assertEqual(decoded.auto_text_key, b"MDM57")
        self.assertEqual(decoded.payload_length, 13 + 16)
        self.assertEqual(bytes(payload),
                         body[:10] + struct.pack("<H", 16) + b"Hello<n>there<e>\0")
        self.assertEqual(lookup.calls, [b"MDM57", b"MDM57"])

    def test_caption_value_stops_at_embedded_nul(self):
        lookup = DictionaryLookup({b"K": b"ab\0cd"})
        status, payload, decoded = decode(self.lib, auto_text_body(b"K"), lookup)
        self.assertEqual(status, OK)
        self.assertEqual(bytes(payload)[12:], b"ab<e>\0")
        self.assertEqual(decoded.text_length, 5)

    def test_missing_auto_text_uses_original_message(self):
        status, payload, decoded = decode(self.lib, auto_text_body(b"NOPE"))
        expected = MISSING_FORMAT.replace(b"%s", b"NOPE")
        self.assertEqual(status, OK)
        self.assertEqual(decoded.source, SOURCE_MISSING)
        self.assertEqual(bytes(payload)[12:], expected + b"<e>\0")
        self.assertEqual(decoded.text_length, len(expected) + 3)

    def test_empty_key_is_still_looked_up(self):
        lookup = DictionaryLookup({b"OTHER": b"text"})
        status, payload, _decoded = decode(self.lib, auto_text_body(b""), lookup)
        self.assertEqual(status, OK)
        self.assertEqual(bytes(payload)[12:], MISSING_FORMAT.replace(b"%s", b"") + b"<e>\0")
        self.assertEqual(lookup.calls, [b"", b""])

    def test_lookup_is_case_insensitive_through_callback(self):
        lookup = DictionaryLookup({b"MDM57A": b"x"})
        status, payload, decoded = decode(self.lib, auto_text_body(b"mdm57a"), lookup)
        self.assertEqual((status, decoded.source), (OK, SOURCE_AUTO_TEXT))

    def test_unterminated_key_fails_before_lookup(self):
        lookup = DictionaryLookup({})
        body = header(selector=-1) + b"K" * 33
        self.assertEqual(decode(self.lib, body, lookup)[0], ERR_BODY)
        self.assertEqual(lookup.calls, [])

    def test_lookup_error_and_size_limits(self):
        self.assertEqual(decode(self.lib, auto_text_body(b"K"),
                                DictionaryLookup({}, error=True))[0], ERR_BACKEND)
        self.assertEqual(decode(self.lib, auto_text_body(b"K"),
                                DictionaryLookup({b"K": b"x" * 40001}))[0], ERR_LIMIT)
        self.assertEqual(decode(self.lib, auto_text_body(b"K"),
                                DictionaryLookup({b"K": b"x" * 32752}))[0], ERR_LIMIT)
        status, _payload, decoded = decode(self.lib, auto_text_body(b"K"),
                                           DictionaryLookup({b"K": b"x" * 32751}))
        self.assertEqual((status, decoded.payload_length), (OK, 32767))

    def test_small_capacity_writes_nothing(self):
        body = inline_body(b"abcd")
        payload = (c.c_uint8 * 18)(*([0xAA] * 18))
        decoded = Decoded()
        status = self.lib.action_family_51_decode(
            buffer(body), len(body), DictionaryLookup({}).callback, None,
            payload, len(payload), c.byref(decoded))
        self.assertEqual(status, ERR_LIMIT)
        self.assertEqual(bytes(payload), b"\xaa" * 18)

    def test_invalid_arguments(self):
        decoded = Decoded()
        self.assertEqual(self.lib.action_family_51_decode(
            None, 0, DictionaryLookup({}).callback, None, None, 0, c.byref(decoded)),
            ERR_ARGUMENT)
        body = inline_body(b"a")
        self.assertEqual(self.lib.action_family_51_decode(
            buffer(body), len(body), DictionaryLookup({}).callback, None, None, 4,
            c.byref(decoded)), ERR_ARGUMENT)


class ActionFamily51StepTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LIBRARY.is_file():
            raise unittest.SkipTest("Build with scripts/build_action_family_51.sh first")
        cls.lib = bind()

    def record(self, text=b"Text", **fields):
        status, payload, _ = decode(self.lib, auto_text_body(b"K", **fields),
                                    DictionaryLookup({b"K": text}))
        self.assertEqual(status, OK)
        return payload

    def test_false_gate_changes_nothing_even_for_subtype_two(self):
        payload = self.record(renderer=0)
        before = bytes(payload)
        status, result, world, backend = step(self.lib, payload, eligible=0,
                                              subtype=2, completed=1, phase=1)
        self.assertEqual(status, OK)
        self.assertEqual((result.recognized, result.applied, result.phase,
                          result.completed), (1, 0, 1, 1))
        self.assertEqual(bytes(payload), before)
        self.assertEqual(backend.calls, [])

    def test_auto_renderer_selects_by_measured_lines_and_persists(self):
        for lines, renderer, call in ((2, 2, "write_caption"), (3, 1, "open_frame_text")):
            payload = self.record(renderer=0)
            backend = RecordingBackend(lines=lines)
            status, result, world, _ = step(self.lib, payload, backend=backend,
                                            world=World(0, 7, 0))
            self.assertEqual(status, OK)
            self.assertEqual(struct.unpack_from("<h", bytes(payload))[0], renderer)
            self.assertEqual(result.renderer_selected, 1)
            self.assertEqual(result.phase, 1)
            self.assertEqual(backend.calls[0], ("measure", b"Text<e>"))
            self.assertEqual(backend.calls[1][0], call)
            self.assertEqual(world.frame_text_flag, 0 if renderer == 1 else 7)

    def test_frame_text_opens_with_mode_two(self):
        payload = self.record(renderer=1)
        status, result, _world, backend = step(self.lib, payload)
        self.assertEqual(status, OK)
        self.assertEqual(backend.calls, [("open_frame_text", 2, b"Text<e>")])
        self.assertEqual(result.phase, 1)

    def test_other_renderer_values_render_nothing(self):
        payload = self.record(renderer=3)
        status, result, _world, backend = step(self.lib, payload)
        self.assertEqual((status, result.phase, backend.calls), (OK, 1, []))

    def test_sound_wait_checks_channel_in_start_visit(self):
        payload = self.record(renderer=2, wait=1, channel=12)
        status, result, _world, backend = step(self.lib, payload,
                                               backend=RecordingBackend(playing=0))
        self.assertEqual((status, result.phase), (OK, 2))
        self.assertEqual(backend.calls[-1], ("is_channel_playing", 12))
        status, result, _world, _backend = step(self.lib, payload, phase=1,
                                                backend=RecordingBackend(playing=1))
        self.assertEqual((status, result.phase), (OK, 1))

    def test_timer_sets_shared_deadline_and_compares_unsigned(self):
        payload = self.record(renderer=2, wait=2, milliseconds=100)
        # The deadline wraps, so the original unsigned compare finishes in the
        # same visit that started the timer.
        backend = RecordingBackend(ticks=(0xFFFFFFF0, 0xFFFFFFF0))
        status, result, world, _ = step(self.lib, payload, backend=backend)
        self.assertEqual((status, result.phase, world.timer_deadline), (OK, 2, 0x54))
        self.assertEqual([call[0] for call in backend.calls],
                         ["write_caption", "tick_count", "tick_count"])
        for now, phase in ((0x54, 1), (0x55, 2)):
            status, result, _, _ = step(self.lib, payload, phase=1, world=World(0x54),
                                        backend=RecordingBackend(ticks=(now,)))
            self.assertEqual((status, result.phase), (OK, phase))

    def test_no_wait_mode_never_finishes(self):
        payload = self.record(renderer=2, wait=0)
        status, result, _world, backend = step(self.lib, payload, phase=1)
        self.assertEqual((status, result.phase, backend.calls), (OK, 1, []))

    def test_finish_closes_renderer_and_completes_by_subtype(self):
        for renderer, subtype, calls, flag, completed, reset in (
            (1, 1, [("close_frame_text",)], 0, 1, 0),
            (2, 2, [], 1, 0, 1),
            (3, 0, [], 0, 1, 0),
        ):
            payload = self.record(renderer=renderer)
            status, result, world, backend = step(self.lib, payload, phase=2,
                                                  subtype=subtype, completed=1)
            self.assertEqual(status, OK)
            self.assertEqual(backend.calls, calls)
            self.assertEqual(world.caption_finish_flag, flag)
            self.assertEqual((result.completion_called, result.phase, result.completed,
                              result.reset_dependencies), (1, 0, completed, reset))

    def test_out_of_range_phase_is_ignored(self):
        payload = self.record()
        status, result, _world, backend = step(self.lib, payload, phase=3)
        self.assertEqual((status, result.applied, result.phase, backend.calls), (OK, 0, 3, []))

    def test_backend_failure_keeps_state_committed_in_original_order(self):
        # (failing call, record fields) -> (renderer word, deadline, frame flag, phase)
        for fail, fields, expected in (
            ("measure", dict(renderer=0, wait=2), (0, 5, 9, 0)),
            ("open_frame_text", dict(renderer=0, wait=2), (1, 5, 9, 0)),
            ("tick_count", dict(renderer=0, wait=2), (1, 5, 0, 0)),
            ("is_channel_playing", dict(renderer=0, wait=1), (1, 5, 0, 1)),
        ):
            payload = self.record(**fields)
            status, result, world, _ = step(self.lib, payload, world=World(5, 9, 0),
                                            backend=RecordingBackend(lines=3, fail=fail))
            self.assertEqual(status, ERR_BACKEND, fail)
            renderer = struct.unpack_from("<h", bytes(payload))[0]
            self.assertEqual((renderer, world.timer_deadline, world.frame_text_flag,
                              result.phase), expected, fail)
            self.assertEqual(result.renderer_selected, int(fail != "measure"), fail)

    def test_missing_callbacks_fail_before_any_call(self):
        for fields, missing in ((dict(renderer=1, wait=2), "tick_count"),
                                (dict(renderer=2, wait=1), "is_channel_playing"),
                                (dict(renderer=0), "write_caption")):
            payload = self.record(**fields)
            before = bytes(payload)
            backend = RecordingBackend()
            setattr(backend.struct, missing, type(getattr(backend.struct, missing))())
            status, result, world, _ = step(self.lib, payload, backend=backend,
                                            world=World(5, 9, 0))
            self.assertEqual((status, result.applied), (ERR_UNSUPPORTED, 0), missing)
            self.assertEqual(backend.calls, [], missing)
            self.assertEqual(bytes(payload), before, missing)
            self.assertEqual((world.timer_deadline, world.frame_text_flag), (5, 9))

    def test_world_flags_written_by_backend_are_kept(self):
        payload = self.record(renderer=2)
        world = World(0, 0, 1)
        backend = RecordingBackend()
        # A faithful caption draw clears 0x5b1602 inside 0x448d11.
        def draw(_context, text, length):
            world.caption_finish_flag = 0
            return BACKEND_OK
        backend.struct.write_caption = WRITE(draw)
        status, _result, world, _ = step(self.lib, payload, world=world, backend=backend)
        self.assertEqual((status, world.caption_finish_flag), (OK, 0))

    def test_invalid_records_fail_before_backend(self):
        backend = RecordingBackend()
        self.assertEqual(step(self.lib, buffer(bytes(11)), backend=backend)[0], ERR_BODY)
        unterminated = header(renderer=2, selector=7) + b"abcd<e>"
        self.assertEqual(step(self.lib, buffer(unterminated), backend=backend)[0], ERR_BODY)
        self.assertEqual(backend.calls, [])
        # Paths that never read the text accept it, as the original does.
        no_render = header(renderer=3, selector=7) + b"abcd<e>"
        status, result, _, _ = step(self.lib, buffer(no_render))
        self.assertEqual((status, result.phase), (OK, 1))
        # The stored length at +10 is not consulted by the executor.
        stale = bytearray(self.record(renderer=2))
        stale[10:12] = struct.pack("<H", 200)
        self.assertEqual(step(self.lib, buffer(bytes(stale)))[0], OK)
        status, result, _, _ = step(self.lib, self.record(), action_type=0x50)
        self.assertEqual((status, result.recognized), (ERR_UNSUPPORTED, 0))

    def test_status_strings(self):
        self.assertEqual(self.lib.action_family_51_status_string(ERR_BODY),
                         b"invalid action 0x51 body")


class AutoTextLibrary:
    """Real AUTOTEXT lookup through the existing native parser."""

    def __init__(self):
        self.library = c.CDLL(str(AUTOTEXT_LIBRARY))
        self.library.autotext_open_memory.argtypes = [
            c.c_void_p, c.c_size_t, c.c_int, c.POINTER(c.c_void_p), c.c_char_p, c.c_size_t]
        self.library.autotext_open_memory.restype = c.c_int
        self.library.autotext_lookup.argtypes = [
            c.c_void_p, c.POINTER(c.c_uint8), c.c_size_t,
            c.POINTER(c.POINTER(c.c_uint8)), c.POINTER(c.c_size_t), c.POINTER(c.c_size_t)]
        self.library.autotext_lookup.restype = c.c_int
        data = AUTOTEXT_RESOURCE.read_bytes()
        self.handle = c.c_void_p()
        error = c.create_string_buffer(256)
        status = self.library.autotext_open_memory(
            data, len(data), 0, c.byref(self.handle), error, len(error))
        if status != 0:
            raise RuntimeError(error.value.decode())
        self.callback = LOOKUP(self._lookup)

    def _lookup(self, _context, key, key_length, text, text_length):
        value = c.POINTER(c.c_uint8)()
        raw_length = c.c_size_t()
        caption_length = c.c_size_t()
        status = self.library.autotext_lookup(
            self.handle, key, key_length, c.byref(value), c.byref(raw_length),
            c.byref(caption_length))
        if status == 6:
            return LOOKUP_NOT_FOUND
        if status != 0:
            return LOOKUP_ERROR
        text[0] = value
        text_length[0] = caption_length.value
        return LOOKUP_FOUND


def corpus_records():
    """Yield every raw 0x51 action from the decoded SCEN resources."""
    from test_scene_resource import SceneActionInfo

    library = c.CDLL(str(SCENE_LIBRARY))
    library.scene_resource_open_memory.argtypes = [
        c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t]
    library.scene_resource_open_memory.restype = c.c_void_p
    library.scene_resource_close.argtypes = [c.c_void_p]
    library.scene_resource_action_count.argtypes = [c.c_void_p]
    library.scene_resource_action_count.restype = c.c_size_t
    library.scene_resource_action_at.argtypes = [
        c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)]
    library.scene_resource_action_at.restype = c.c_int
    for path in sorted(RESOURCES.glob("*.bin")):
        data = path.read_bytes()
        source = buffer(data)
        error = c.create_string_buffer(256)
        scene = library.scene_resource_open_memory(source, len(data), error, len(error))
        if not scene:
            continue
        try:
            for index in range(library.scene_resource_action_count(scene)):
                info = SceneActionInfo()
                if library.scene_resource_action_at(scene, index, c.byref(info)) != 0:
                    raise AssertionError(f"{path.name} action {index} unreadable")
                if info.type == 0x51:
                    yield (path.name, index, info.subtype,
                           bytes(info.raw_body[:info.raw_body_length]))
        finally:
            library.scene_resource_close(scene)


class ActionFamily51CorpusTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        missing = [path for path in (LIBRARY, SCENE_LIBRARY, AUTOTEXT_LIBRARY,
                                     AUTOTEXT_RESOURCE) if not path.exists()]
        if missing:
            raise unittest.SkipTest(f"corpus inputs unavailable: {missing[0]}")
        cls.lib = bind()
        cls.autotext = AutoTextLibrary()
        cls.records = list(corpus_records())

    def test_every_corpus_record_has_a_proven_boundary(self):
        self.assertEqual(len(self.records), 97)
        sources = {SOURCE_INLINE: 0, SOURCE_AUTO_TEXT: 0, SOURCE_MISSING: 0}
        dependencies = 0
        for name, index, subtype, raw in self.records:
            length = c.c_size_t()
            status = self.lib.action_family_51_body_length(buffer(raw), len(raw),
                                                           c.byref(length))
            self.assertEqual(status, OK, (name, index))
            remainder = len(raw) - length.value
            self.assertEqual(remainder % 16, 0, (name, index))
            dependencies += remainder // 16
            self.assertEqual(subtype, 1, (name, index))
            status, _payload, decoded = decode(self.lib, raw[:length.value], self.autotext)
            self.assertEqual(status, OK, (name, index))
            sources[decoded.source] += 1
        self.assertEqual(sources, {SOURCE_INLINE: 1, SOURCE_AUTO_TEXT: 96, SOURCE_MISSING: 0})
        self.assertGreaterEqual(dependencies, 0)


if __name__ == "__main__":
    unittest.main()
