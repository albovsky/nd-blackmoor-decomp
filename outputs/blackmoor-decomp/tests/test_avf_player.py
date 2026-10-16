#!/usr/bin/env python3
"""Fixture tests for the AVF playback kernel (src/avf_player.[ch]).

Builds the library with scripts/build_avf_player.sh (or uses
AVF_PLAYER_LIBRARY) and checks the API contract: argument and callback
validation, handshake/stop ordering, generation tokens, gate false branches,
host and decoder failures, buffer ownership and clock wrap. Original-code
equivalence is in avf_player_original_oracle.py.

    python3 outputs/blackmoor-decomp/tests/test_avf_player.py
"""

from __future__ import annotations

import ctypes as c
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import avf_player_original_oracle as po  # noqa: E402
import test_avf_decoder as fx  # noqa: E402

PROJECT = Path(__file__).resolve().parents[1]
LIBRARY = Path(os.environ.get("AVF_PLAYER_LIBRARY", PROJECT / "build/libavfplayer.dylib"))
OK, ARGUMENT, STATE, STALE, UNSUPPORTED, DECODER, HOST = range(7)
RANDOM, MOVIE, PARTNER, SECONDARY = range(4)


def build() -> c.CDLL:
    if "AVF_PLAYER_LIBRARY" not in os.environ:
        subprocess.run(["sh", str(PROJECT / "scripts/build_avf_player.sh")], check=True,
                       capture_output=True)
    return po.bind_player(LIBRARY)


def config(kind, mode=1, first=0, last=3, direction=1, surface=16, **kw) -> po.Config:
    cfg = po.Config(kind, mode, first, last, direction, surface, 0, 0, 1, last, last, 0, last, 2)
    for k, v in kw.items():
        setattr(cfg, k, v)
    return cfg


class Session(po.NativeSession):
    def start(self, cfg: po.Config) -> int:
        slots = self.slot_buffers
        return self.lib.avf_player_start(c.byref(self.player), c.byref(cfg), c.byref(self.stream),
                                         slots[0] if slots else None, slots[1] if slots else None,
                                         self.slot_bytes if slots else 0, c.byref(self.host))

    def poll(self) -> int:
        return self.lib.avf_player_worker_poll(c.byref(self.player), None)

    def tick(self, now: int, records=(1,), **gate) -> int:
        self.now = now
        g, keep = po.gate_struct(list(records), **gate)
        return self.lib.avf_player_tick(c.byref(self.player), c.byref(g))

    def ack(self, generation=None):
        blitted = c.c_int(-1)
        gen = self.player.generation if generation is None else generation
        status = self.lib.avf_player_render_ack(c.byref(self.player), gen, c.byref(blitted))
        return status, blitted.value

    def stop(self) -> int:
        return self.lib.avf_player_stop(c.byref(self.player))


KEY = po.make_avf(2, 2, 4)


class AvfPlayerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.lib = build()

    def session(self, data=KEY, mode=1, slots=False) -> Session:
        return Session(self.lib, data, mode, 8, slots=slots)

    # -- start validation ----------------------------------------------------------
    def test_start_requires_callbacks_before_any_change(self) -> None:
        for missing in ("clock", "present", "frame_event"):
            with self.subTest(missing=missing):
                s = self.session()
                setattr(s.host, missing, getattr(po, {"clock": "CLOCK", "present": "PRESENT",
                                                      "frame_event": "FRAME_EVENT"}[missing])())
                s.player.generation = 41
                self.assertEqual(s.start(config(RANDOM, surface=8)), UNSUPPORTED)
                self.assertEqual((s.player.generation, s.player.running), (41, 0))
                self.assertEqual(s.trace, [])

    def test_start_rejects_bad_configs(self) -> None:
        s = self.session()
        self.assertEqual(s.start(config(RANDOM, mode=2, surface=8)), UNSUPPORTED)
        self.assertEqual(s.start(config(RANDOM, surface=9)), ARGUMENT)    # > frame buffer
        self.assertEqual(s.start(config(RANDOM, surface=0)), ARGUMENT)
        self.assertEqual(s.start(config(7)), ARGUMENT)
        single = self.session(mode=0)
        self.assertEqual(single.start(config(MOVIE, mode=1)), ARGUMENT)    # no second buffer
        sec = self.session(slots=True)
        self.assertEqual(sec.start(config(SECONDARY, start_mode=3)), UNSUPPORTED)
        sec.slot_bytes -= 1
        self.assertEqual(sec.start(config(SECONDARY)), ARGUMENT)
        sec.slot_bytes += 1
        sec.slot_buffers[1] = sec.slot_buffers[0]
        self.assertEqual(sec.start(config(SECONDARY)), ARGUMENT)
        self.assertEqual(self.lib.avf_player_start(None, None, None, None, None, 0, None),
                         ARGUMENT)

    # -- handshake, lifecycle, generations -------------------------------------------
    def test_handshake_and_stop_order(self) -> None:
        """Covers release (0x44c4ab)."""
        s = self.session()
        self.assertEqual(s.start(config(RANDOM, surface=8)), OK)
        self.assertEqual(s.trace, [("resume",)])
        s.trace.clear()
        self.assertEqual(s.poll(), OK)
        self.assertEqual(s.trace, [("acquire",), ("release",)])
        self.assertEqual((s.player.ready, s.player.handshake), (1, 0))
        s.trace.clear()
        self.assertEqual(s.poll(), OK)                  # R set: idle iteration
        self.assertEqual(s.trace, [])
        self.assertEqual(s.stop(), OK)
        self.assertEqual(s.trace, [("acquire",), ("halt",), ("kill",), ("release",), ("idle",)])
        self.assertEqual((s.player.handshake, s.player.exit_flag, s.player.running), (0, 1, 0))
        self.assertEqual(s.poll(), STATE)
        self.assertEqual(s.tick(1000), STATE)
        self.assertEqual(s.stop(), STATE)

    def test_movie_step_index_clamps_to_last_in_both_directions(self) -> None:
        """movie_step_index (0x4c09fe): the index never passes config.last."""
        for direction in (1, 2):
            with self.subTest(direction=direction):
                s = self.session(mode=1)
                self.assertEqual(s.start(config(MOVIE, mode=1, first=1, last=1, direction=direction)), OK)
                s.poll()
                s.tick(1000)
                self.assertEqual(s.player.index, 1)
                self.assertEqual(s.player.presented, 1)

    def test_random_step_runs_to_done_then_finishes(self) -> None:
        """random_step (0x4ce602): the last frame sets done; the next due tick finishes."""
        for mode in (0, 1):
            with self.subTest(mode=mode):
                s = self.session(mode=mode)
                self.assertEqual(s.start(config(RANDOM, mode=mode, first=0, last=1, surface=8)), OK)
                s.poll()
                s.tick(1000)
                p = s.player
                self.assertEqual((p.presented, p.index, p.ready, p.substate, p.done), (0, 1, 0, 4, 0))
                s.poll()
                s.tick(p.deadline)
                self.assertEqual((p.presented, p.index, p.ready, p.done, p.finished), (1, 1, 1, 1, 0))
                s.tick(p.deadline)
                self.assertEqual(p.finished, 1)

    def test_generation_tokens(self) -> None:
        s = self.session()
        self.assertEqual(s.start(config(MOVIE)), OK)
        gen = s.player.generation
        s.poll()
        s.tick(1000)
        self.assertEqual(s.ack(gen + 1), (STALE, 0))
        self.assertEqual(s.player.ready, 1)              # stale ack changed nothing
        self.assertEqual(s.ack(gen), (OK, 1))
        self.assertEqual(s.player.ready, 0)
        self.assertEqual(s.stop(), OK)
        self.assertEqual(s.ack(gen), (STALE, 0))         # generation advanced at stop
        self.assertEqual(s.ack(s.player.generation)[0], STATE)
        self.assertEqual(s.start(config(MOVIE)), OK)
        self.assertGreater(s.player.generation, gen + 1)

    def test_presentations_carry_generation(self) -> None:
        s = self.session()
        seen = []

        def present(_ctx, ptr):
            p = po.Presentation.from_address(ptr)
            seen.append((p.generation, p.kind, p.slot, p.frame_index, p.bytes))
            return 0
        s.host.present = po.PRESENT(present)
        self.assertEqual(s.start(config(MOVIE)), OK)
        s.poll()
        s.tick(1000)
        self.assertEqual(seen, [(s.player.generation, 2, 1, 0, 8)])

    def test_render_ack_only_for_movie(self) -> None:
        s = self.session()
        s.start(config(RANDOM, surface=8))
        self.assertEqual(s.ack()[0], UNSUPPORTED)

    # -- gate false branches -----------------------------------------------------------
    def test_random_hidden_keeps_deadline_running(self) -> None:
        s = self.session()
        s.start(config(RANDOM, surface=8))
        s.poll()
        self.assertEqual(s.tick(1000, records=()), OK)    # hidden: nothing presented
        self.assertEqual((s.player.visible, s.player.record, s.player.substate), (0, -1, 0))
        self.assertEqual(s.clock_used, 0)
        s.tick(1000)
        deadline = s.player.deadline
        s.poll()
        self.assertEqual(s.tick(deadline + 500, records=()), OK)
        self.assertEqual(s.player.index, 1)               # no advance while hidden
        s.tick(deadline + 500)                            # visible again: advances at once
        self.assertEqual((s.player.presented, s.player.index), (1, 2))

    def test_movie_hidden_and_multiple_matches(self) -> None:
        """movie_step (0x4c0205): hidden ticks do not step; with several matches the first record steps (select, triggers, rect)."""
        s = self.session()
        s.start(config(MOVIE))
        s.poll()
        s.tick(1000, records=())
        self.assertEqual((s.player.shown, s.player.visible, s.player.matched), (3, 0, 0))
        s.trace.clear()
        s.tick(1000, records=(0, 2))
        self.assertEqual((s.player.visible, s.player.matched, s.player.record), (1, 1, 2))
        # select, triggers, rect for record 0; record 2's call finds the deadline pending
        self.assertEqual(s.trace, [("present", 1), ("triggers", 0), ("rect", 0)])
        s.tick(1000 + 66, records=())                    # hidden tick clears dirty
        self.assertEqual((s.player.dirty, s.player.shown), (0, 3))
        self.assertEqual(s.ack(), (OK, 0))               # nothing to consume: R stays set
        self.assertEqual(s.player.ready, 1)

    def test_partner_sound_gate_and_skip(self) -> None:
        """partner_step (0x4dcdd3): the finish waits for the last frame and for sound_busy to drop."""
        s = self.session(mode=0)
        cfg = config(PARTNER, mode=0, sound=1, sound_id=5)
        self.assertEqual(s.start(cfg), OK)
        self.assertEqual(s.clock_used, 1)                # logo timer sample
        for t in range(1000, 1000 + 66 * 6, 66):
            s.poll()
            s.tick(t, sound_busy=1)
        self.assertEqual(s.player.finished, 0)           # last frame repeats while sound plays
        s.tick(1000 + 66 * 7, sound_busy=0)
        self.assertEqual(s.player.finished, 1)
        s2 = self.session(mode=0)
        s2.start(config(PARTNER, mode=0))
        s2.poll()
        s2.tick(1000, skip=1)
        self.assertEqual(s2.player.finished, 1)

    # -- failures ------------------------------------------------------------------------
    def test_host_failure_keeps_committed_effects(self) -> None:
        s = self.session()
        s.start(config(MOVIE))
        s.poll()
        s.fail_on = "rect"
        self.assertEqual(s.tick(1000), HOST)
        # Selected, triggers and dirty happened before the failing rect call.
        self.assertEqual((s.player.presented, s.player.dirty, s.player.substate), (0, 1, 0))
        s.fail_on = None
        # Failures are terminal: nothing is replayed; only stop is accepted.
        self.assertEqual(s.tick(1066), STATE)
        self.assertEqual(s.poll(), STATE)
        self.assertEqual(s.ack(), (STATE, 0))
        self.assertEqual(s.player.presented, 0)
        self.assertEqual(s.stop(), OK)
        s2 = self.session()
        s2.start(config(RANDOM, surface=8))
        s2.poll()
        s2.fail_on = "present"
        self.assertEqual(s2.tick(1000), HOST)
        self.assertEqual((s2.player.presented, s2.player.substate, s2.player.ready), (-1, 0, 1))

    def test_start_contract(self) -> None:
        s = self.session(mode=0)
        s.fail_on = "present"                            # single-buffer select at start fails
        self.assertEqual(s.start(config(MOVIE, mode=0)), HOST)
        self.assertEqual(s.player.running, 0)
        self.assertEqual(s.tick(1000), STATE)
        s.fail_on = None
        self.assertEqual(s.start(config(MOVIE, mode=0)), OK)
        self.assertEqual(s.start(config(MOVIE, mode=0)), STATE)   # running: stop first
        p = self.session()
        self.assertEqual(p.start(config(PARTNER, mode=1)), UNSUPPORTED)  # 0x4dc182 forces 0
        r = self.session()
        cfg = config(RANDOM, surface=8)
        r.start(cfg)
        r.stop()
        self.assertEqual(self.lib.avf_player_restart(c.byref(r.player),
                                                     c.byref(config(RANDOM, mode=0, surface=8))),
                         ARGUMENT)                       # +0x17a only set by state 0
        r.start(cfg)
        self.assertEqual(r.tick(1000, records=(-1,)), ARGUMENT)

    def test_decoder_failure(self) -> None:
        data = fx.build_avf(2, 2, [(0, fx.frame_pixels(2, 2, 0), None),
                                   (2, fx.cmd_fill(1, 0, 1), None),
                                   (2, fx.cmd_fill(2, 0, 1), None)])
        s = self.session(data)
        s.start(config(RANDOM, first=2, last=2, surface=8))   # delta without predecessor
        self.assertEqual(s.poll(), DECODER)
        self.assertEqual((s.player.ready, s.player.handshake, s.player.decoder_status),
                         (0, 0, fx.SEQUENCE))
        self.assertEqual(s.trace[-2:], [("acquire",), ("release",)])
        self.assertEqual(s.poll(), STATE)                # terminal, like the original quit
        empty = fx.build_avf(2, 2, [(0, fx.frame_pixels(2, 2, 0), None), (2, None, None)])
        sec = self.session(empty, slots=True)
        sec.start(config(SECONDARY, first=1, last=1, loop_last=1))
        self.assertEqual(sec.poll(), DECODER)            # sequence check precedes the empty rule
        self.assertEqual(sec.player.decoder_status, fx.SEQUENCE)

    def test_secondary_empty_record_and_slot_ownership(self) -> None:
        data = fx.build_avf(2, 2, [(0, fx.frame_pixels(2, 2, 0), None), (2, None, None)])
        s = self.session(data, slots=True)
        s.start(config(SECONDARY, last=1, loop_last=1))
        self.assertEqual(s.poll(), OK)
        slot1 = c.addressof(s.slot_buffers[1])
        self.assertEqual(s.player.slot_result[1], slot1)  # toggle 0 refills slot 1
        s.tick(1000)
        self.assertEqual((s.player.slot_toggle, s.selected[0]), (1, slot1))
        self.assertEqual(s.poll(), UNSUPPORTED)           # empty record would alias the shown chunk
        self.assertEqual(s.player.handshake, 0)
        before = bytes(s.slot_buffers[1])
        self.assertEqual(s.stop(), OK)
        self.assertEqual(bytes(s.slot_buffers[1]), before)    # stop keeps the shown chunk
        self.assertEqual(s.selected[0], slot1)

    def test_secondary_slot_ownership_with_variable_chunk_sizes(self) -> None:
        # Key chunks of 8, 4 and 8 bytes: the refill only writes the slot that
        # is not shown, the presentation size is the chunk size (not the
        # buffer size) and a poll never touches the shown slot.
        pix = [fx.frame_pixels(2, 2, 1), fx.frame_pixels(2, 1, 2), fx.frame_pixels(2, 2, 3)]
        data = fx.build_avf(2, 2, [(0, p, None) for p in pix])
        s = self.session(data, slots=True)
        self.assertEqual(s.start(config(SECONDARY, last=2, loop_last=2)), OK)
        addresses = [c.addressof(b) for b in s.slot_buffers]
        now = 1000
        self.assertEqual(s.poll(), OK)                       # chunk 0 -> slot 1
        self.assertEqual(s.tick(now), OK)                    # first advance shows it
        for k in range(3):
            slot = s.player.slot_toggle
            self.assertEqual(slot, (1 + k) % 2)
            self.assertEqual(s.selected, (addresses[slot], len(pix[k])))
            self.assertEqual(bytes(s.slot_buffers[slot])[:len(pix[k])], pix[k])
            if k == 2:
                break
            held = bytes(s.slot_buffers[slot])
            self.assertEqual(s.poll(), OK)                   # refills the other slot only
            self.assertEqual(bytes(s.slot_buffers[slot]), held)
            self.assertEqual(s.player.slot_result[1 - slot], addresses[1 - slot])
            self.assertEqual(s.player.slot_result_bytes[1 - slot], len(pix[k + 1]))
            self.assertEqual(s.tick(now + 65), OK)           # deadline pending: still shown
            self.assertEqual(s.selected, (addresses[slot], len(pix[k])))
            now += 66
            self.assertEqual(s.tick(now), OK)                # due: flip to the refilled slot

    def test_clock_wrap_matches_original_u32_arithmetic(self) -> None:
        s = self.session()
        s.start(config(RANDOM, surface=8))
        s.poll()
        s.tick(0xFFFFFFF0)
        self.assertEqual(s.player.deadline, (0xFFFFFFF0 + 66) & 0xFFFFFFFF)
        s.poll()
        s.tick(0xFFFFFFF1)                               # wrapped deadline is already due
        self.assertEqual(s.player.presented, 1)

    def test_restart_keeps_toggle(self) -> None:
        s = self.session()
        cfg = config(RANDOM, surface=8)
        s.start(cfg)
        s.poll()
        self.assertEqual(s.stream.toggle, 1)
        self.assertEqual(self.lib.avf_player_restart(c.byref(s.player), c.byref(cfg)), STATE)
        s.stop()
        self.assertEqual(self.lib.avf_player_restart(c.byref(s.player), c.byref(cfg)), OK)
        self.assertEqual((s.stream.toggle, s.stream.last_index, s.player.index), (1, -1, 0))

    def test_secondary_mode_setter(self) -> None:
        s = self.session(slots=True)
        s.start(config(SECONDARY))
        self.assertEqual(self.lib.avf_player_set_secondary_mode(c.byref(s.player), 1), OK)
        self.assertEqual(s.player.secondary_mode, 1)
        r = self.session()
        r.start(config(RANDOM, surface=8))
        self.assertEqual(self.lib.avf_player_set_secondary_mode(c.byref(r.player), 1),
                         UNSUPPORTED)

    def test_status_names(self) -> None:
        names = [self.lib.avf_player_status_name(k).decode() for k in range(7)]
        self.assertEqual(names, ["OK", "ARGUMENT", "STATE", "STALE", "UNSUPPORTED", "DECODER",
                                 "HOST"])


SANITIZER_DRIVER = r"""
#include "avf_player.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t now_ms;
static int fail_every;
static unsigned calls;
static uint8_t surface[1 << 20];
static uint32_t clock_cb(void *c) { (void)c; return now_ms; }
static int present_cb(void *c, const AvfPresentation *p) {
    (void)c; ++calls;
    if (p->kind == AVF_PRESENT_COPY) memcpy(surface, p->pixels, p->bytes);
    else if (p->pixels && p->bytes) { volatile uint8_t x = p->pixels[p->bytes - 1]; (void)x; }
    return fail_every && calls % (unsigned)fail_every == 0;
}
static int event_cb(void *c, const AvfFrameEvent *e) { (void)c; (void)e; ++calls;
    return fail_every && calls % (unsigned)fail_every == 0; }

static uint8_t *slurp(const char *path, size_t *size) {
    FILE *f = fopen(path, "rb"); long n; uint8_t *d;
    if (!f) return NULL;
    fseek(f, 0, SEEK_END); n = ftell(f); fseek(f, 0, SEEK_SET);
    d = malloc(n ? (size_t)n : 1); *size = fread(d, 1, (size_t)n, f); fclose(f);
    return d;
}

int main(int argc, char **argv) {
    unsigned long ops = 0, ok = 0;
    unsigned seed = 1;
    for (int a = 1; a < argc; ++a) {
        size_t size = 0; uint8_t *data = slurp(argv[a], &size);
        AvfFile file; AvfStream st;
        if (!data) return 2;
        if (avf_open(data, size, &file) != AVF_OK) { free(data); continue; }
        size_t fb = file.frame_bytes, sb = file.max_unpacked ? file.max_unpacked : 1;
        size_t slot = fb > sb ? fb : sb;
        for (int kind = 0; kind < 4; ++kind) for (int mode = 0; mode < 3; ++mode)
        for (int trial = 0; trial < 3; ++trial) {
            uint8_t *b0 = malloc(fb), *b1 = malloc(fb), *sc = malloc(sb);
            uint8_t *s0 = malloc(slot), *s1 = malloc(slot);
            AvfPlayer p; AvfPlayerConfig cfg; AvfPlayerHost host = {0};
            int32_t recs[2] = {1, 0};
            memset(&p, 0, sizeof p); memset(&cfg, 0, sizeof cfg);
            avf_stream_init(&st, &file, b0, b1, fb, sc, sb, NULL, NULL);
            host.clock = clock_cb; host.present = present_cb; host.frame_event = event_cb;
            cfg.kind = (AvfPlayerKind)kind; cfg.mode = mode; cfg.first = (int16_t)(trial == 2 ? -32768 : 0);
            cfg.last = (int16_t)(trial == 2 ? 32767 : file.frame_count - 1);
            cfg.direction = (int16_t)(1 + (trial & 1)); cfg.surface_bytes = fb;
            cfg.sound = trial; cfg.start_mode = (int16_t)(1 + (trial & 1));
            cfg.loop_last = cfg.last; cfg.hold_last = cfg.last; cfg.end_last = cfg.last;
            cfg.hold_start = 0; cfg.present_mode = 2;
            fail_every = trial == 1 ? 7 : 0;
            now_ms = trial == 2 ? 0xFFFFFF00u : 1000u;
            if (avf_player_start(&p, &cfg, &st, s0, s1, slot, &host) == AVF_PLAYER_OK) {
                for (int i = 0; i < 400; ++i) {
                    AvfPlayerGate g = {recs, (size_t)((seed >> 3) % 3), (int32_t)(seed & 1),
                                       (int32_t)((seed >> 5) % 13 == 0), (int32_t)(seed & 2)};
                    int blitted, dec;
                    AvfPlayerStatus r;
                    seed = seed * 1103515245u + 12345u;
                    now_ms += (seed >> 8) % 140;
                    switch ((seed >> 16) % 7) {
                    case 0: case 1: r = avf_player_worker_poll(&p, &dec); break;
                    case 2: case 3: case 4: r = avf_player_tick(&p, &g); break;
                    case 5: r = avf_player_render_ack(&p, p.generation - ((seed >> 20) & 1), &blitted); break;
                    default:
                        if ((seed >> 24) % 9 == 0) { r = avf_player_stop(&p);
                            if (kind == AVF_PLAYER_RANDOM_MOVIE) r = avf_player_restart(&p, &cfg); }
                        else r = avf_player_set_secondary_mode(&p, (int32_t)((seed >> 12) % 5));
                    }
                    ++ops; ok += r == AVF_PLAYER_OK;
                }
                avf_player_stop(&p);
            }
            {   /* argument checks */
                AvfPlayerGate bad = {NULL, 3, 0, 0, 0};
                ops += avf_player_tick(&p, &bad) != AVF_PLAYER_OK;
                ops += avf_player_tick(NULL, &bad) == AVF_PLAYER_ERR_ARGUMENT;
                ops += avf_player_worker_poll(NULL, NULL) == AVF_PLAYER_ERR_ARGUMENT;
            }
            free(b0); free(b1); free(sc); free(s0); free(s1);
        }
        free(data);
    }
    printf("sanitizer-ok ops=%lu ok=%lu\n", ops, ok);
    return 0;
}
"""


class AvfPlayerSanitizerTests(unittest.TestCase):
    def test_asan_ubsan_driver(self) -> None:
        clang = shutil.which("clang") or "/usr/bin/clang"
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            (tmp_path / "driver.c").write_text(SANITIZER_DRIVER)
            exe = tmp_path / "driver"
            subprocess.run([clang, "-std=c11", "-g", "-O1", "-Wall", "-Wextra", "-Werror",
                            "-fsanitize=address,undefined", "-fno-sanitize-recover=all",
                            "-I", str(PROJECT / "src"), str(tmp_path / "driver.c"),
                            str(PROJECT / "src/avf_player.c"), str(PROJECT / "src/avf_decoder.c"),
                            "-o", str(exe)], check=True, capture_output=True)
            paths = []
            fixtures = {"key": po.make_avf(4, 2, 6), "delta": po.make_avf(4, 2, 7, "delta"),
                        "full": po.make_avf(4, 2, 4, "full"), "chain": po.make_avf(4, 2, 6, "chain")}
            for name, data in {**fixtures, **fx.malformed_corpus()}.items():
                path = tmp_path / f"{name}.avf"
                path.write_bytes(data)
                paths.append(str(path))
            extra = os.environ.get("AVF_SANITIZER_FILES", "")
            paths += [p for p in extra.split(os.pathsep) if p]
            result = subprocess.run([str(exe), *paths], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(result.returncode, 0, result.stderr[-4000:])
            self.assertIn("sanitizer-ok", result.stdout)
            if extra:
                print("\n" + result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
