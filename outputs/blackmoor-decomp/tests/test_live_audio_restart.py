#!/usr/bin/env python3
"""RT-11.1: completed-channel restart in the live audio path.

Runs tests/live_audio_restart_test.c (substitute host, recovered 0x4f55d5 /
0x4f7207 / stream-class rules, opcode-17 adapter), the same binary under
ASan + UBSan, and deliberately broken copies of the provider and adapter that
the tests must notice. The original-x86 comparison lives in
tests/test_live_audio_restart_oracle.py.
"""
from __future__ import annotations

import os
import pathlib
import re
import shutil
import subprocess
import tempfile
import unittest

import test_live_audio as live

PROJECT = pathlib.Path(__file__).resolve().parents[1]
SCRIPT = PROJECT / "scripts/build_live_audio_restart.sh"
PROVIDER = PROJECT / "src/live_audio.c"
ADAPTER = PROJECT / "src/session_bindings_conditions_audio.c"

EXPECTED = [
    "armed_repeat_then_explicit_stop_never_fires",
    "control_zero_nonstream_restarts_after_completion",
    "control_one_never_restarts",
    "other_control_words_never_restart",
    "control_zero_stream_loops_on_the_host_and_never_completes",
    "control_one_stream_plays_once_and_is_not_restarted",
    "stream_threshold_is_0x56220_signed_greater_than",
    "explicit_stop_and_unload_are_not_restarted",
    "completion_latched_by_a_poll_is_still_serviced",
    "reload_resets_flags_gate_and_pending_state",
    "ascending_channel_order",
    "restart_host_failure_is_reported_and_state_neutral",
    "flag_one_and_0x100_choose_the_host_loop",
    "flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick",
    "flag_0x10_tick_wrap_uses_the_unsigned_compare",
    "flag_0x10_without_a_random_source_is_refused_state_neutral",
    "flag_0x20_fade_is_refused",
    "flag_matrix_decision_table",
    "argument_checks",
    "adapter_reports_the_looping_clock_as_playing_forever",
    "adapter_answers_a_completed_restartable_channel_without_refusing",
    "adapter_control_one_and_unloaded_are_unchanged",
    "adapter_reports_an_armed_repeat_as_busy",
    "adapter_still_refuses_what_it_cannot_prove",
]


def build_tree(root: pathlib.Path) -> None:
    """The RT-1 synthetic CDSound tree plus the stream-threshold assets."""
    live.build_fixture_tree(root)
    sounds = root / "CDSound"
    # decoded_bytes = frames * 4 (stereo 16-bit): the original's stream class
    # is decoded_bytes > 0x56220 (352,800).
    for name, frames in (("Edge.HIS", 0x56220 // 4), ("EdgePlus.HIS", 0x56220 // 4 + 1),
                         ("Big.HIS", 100000)):
        (sounds / name).write_bytes(live.his_bytes(2, 44100, 16, live.square_wave_16(frames, 2, 8000)))


def build(target: str, *, build_dir: pathlib.Path | None = None,
          provider: pathlib.Path | None = None,
          adapter: pathlib.Path | None = None) -> subprocess.CompletedProcess:
    env = dict(os.environ)
    if build_dir is not None:
        env["LIVE_AUDIO_RESTART_BUILD_DIR"] = str(build_dir)
    if provider is not None:
        env["LIVE_AUDIO_SOURCE"] = str(provider)
    if adapter is not None:
        env["LIVE_AUDIO_ADAPTER_SOURCE"] = str(adapter)
    return subprocess.run(["/bin/sh", str(SCRIPT), target], capture_output=True, text=True, env=env)


def run(binary: pathlib.Path, tree: pathlib.Path, *names: str, env: dict[str, str] | None = None):
    result = subprocess.run([str(binary), str(tree), *names], capture_output=True, text=True,
                            timeout=240, env={**os.environ, **(env or {})})
    outcomes = {}
    for line in result.stdout.splitlines():
        match = re.match(r"TEST (\S+) (PASS|FAIL) ?(.*)", line)
        if match:
            outcomes[match.group(1)] = (match.group(2), match.group(3))
    return result.returncode, outcomes, result.stderr[-2000:]


class RestartTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = pathlib.Path(tempfile.mkdtemp(prefix="rt111-restart-"))
        cls.tree = cls.tmp / "game"
        build_tree(cls.tree)
        result = build("fixture")
        if result.returncode != 0:
            raise RuntimeError("build failed:\n" + result.stdout[-2000:] + result.stderr[-4000:])
        cls.binary = PROJECT / "build/live_audio_restart_test"

    @classmethod
    def tearDownClass(cls) -> None:
        shutil.rmtree(cls.tmp, ignore_errors=True)

    def assert_all_pass(self, outcomes, code, stderr) -> None:
        for name in EXPECTED:
            with self.subTest(test=name):
                self.assertIn(name, outcomes, "test did not report: " + stderr)
                self.assertEqual(outcomes[name][0], "PASS", outcomes[name][1])
        self.assertEqual(code, 0, stderr)

    def test_restart_rules(self) -> None:
        code, outcomes, stderr = run(self.binary, self.tree)
        self.assert_all_pass(outcomes, code, stderr)

    def test_sanitizers(self) -> None:
        result = build("sanitize")
        self.assertEqual(result.returncode, 0, result.stdout[-1000:] + result.stderr[-4000:])
        binary = PROJECT / "build/sanitize-restart/live_audio_restart_test"
        code, outcomes, stderr = run(
            binary, self.tree,
            env={"ASAN_OPTIONS": "abort_on_error=0:halt_on_error=1:detect_stack_use_after_return=1",
                 "UBSAN_OPTIONS": "print_stacktrace=1:halt_on_error=1"})
        self.assertNotIn("AddressSanitizer", stderr)
        self.assertNotIn("runtime error", stderr)
        self.assert_all_pass(outcomes, code, stderr)

    def test_mutations_are_detected(self) -> None:
        for name, target, old, new, must_fail, _oracle_filter in MUTATIONS:
            with self.subTest(mutation=name):
                source = PROVIDER if target == "provider" else ADAPTER
                text = source.read_text()
                self.assertEqual(text.count(old), 1, "mutation anchor must match once: " + name)
                mutant_dir = self.tmp / ("mutant-" + name)
                mutant_dir.mkdir()
                mutant = mutant_dir / source.name
                mutant.write_text(text.replace(old, new, 1))
                result = build("fixture", build_dir=mutant_dir,
                               provider=mutant if target == "provider" else None,
                               adapter=mutant if target == "adapter" else None)
                self.assertEqual(result.returncode, 0, "mutant did not build: " + result.stderr[-1500:])
                code, outcomes, stderr = run(mutant_dir / "live_audio_restart_test", self.tree)
                failing = [t for t in must_fail if outcomes.get(t, ("MISSING", ""))[0] == "FAIL"]
                self.assertTrue(failing, f"mutation {name} survived: {outcomes} {stderr}")
                self.assertNotEqual(code, 0)
                print(f"\nmutation {name}: detected by {failing}")


# (name, target, anchor, replacement, unit tests that must notice,
#  scenario-name filter for the original-x86 oracle or None when the rule is
#  not observable there). Every anchor matches exactly once.
MUTATIONS: list[tuple[str, str, str, str, list[str], str | None]] = [
    ("never_restart", "provider",
     "    status = sound_control_update(&state, index, &host, &result);",
     "    state.channels[index].update_gate_287 = 1u;\n    status = sound_control_update(&state, index, &host, &result);",
     ["control_zero_nonstream_restarts_after_completion", "flag_matrix_decision_table"],
     "Tone-c0x0-f0x0"),
    ("restart_control_one", "provider",
     "    slot->raw_control = channel->control_word;",
     "    slot->raw_control = 0u;",
     ["control_one_never_restarts", "other_control_words_never_restart"],
     "Tone-c0x1-f0x0"),
    ("stream_restarted_as_plain_buffer", "provider",
     "    slot->stream_state = channel->stream_class;",
     "    slot->stream_state = 0u;",
     ["flag_matrix_decision_table"],
     "Big-c0x0-f0x0"),
    ("wrong_flag_word_ignored", "provider",
     "    slot->raw_flags = channel->raw_flags;",
     "    slot->raw_flags = 0u;",
     ["flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick", "flag_matrix_decision_table"],
     "Tone-c0x0-f0x10"),
    ("stream_threshold_off_by_one", "provider",
     "decoded_bytes > STREAM_THRESHOLD_BYTES",
     "decoded_bytes >= STREAM_THRESHOLD_BYTES",
     ["stream_threshold_is_0x56220_signed_greater_than"],
     None),
    ("explicit_stop_not_gated", "provider",
     "    if (channel->loaded) channel->update_gate_287 = 1u;\n",
     "",
     ["explicit_stop_and_unload_are_not_restarted"],
     "stop-gates-update"),
    ("stream_with_nonzero_control_loops", "provider",
     "channel->stream_class != 0u ? channel->control_word == 0u",
     "channel->stream_class != 0u ? 1",
     ["control_one_stream_plays_once_and_is_not_restarted", "flag_matrix_decision_table"],
     "Big-c0x1-f0x0"),
    ("repeat_pass_ignores_the_stop_gate", "provider",
     "    if (!channel->loaded || channel->update_gate_287 != 0u) return;\n    if (channel->repeat_marker == 0u",
     "    if (!channel->loaded) return;\n    if (channel->repeat_marker == 0u",
     ["armed_repeat_then_explicit_stop_never_fires"],
     "armed-repeat-then-stop-gates-repeat"),
    ("repeat_compare_not_strict", "provider",
     "tick <= channel->repeat_due_tick",
     "tick < channel->repeat_due_tick",
     ["flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick"],
     "Tone-c0x0-f0x10-r1233"),
    ("repeat_compare_signed", "provider",
     "tick <= channel->repeat_due_tick",
     "(int32_t)tick <= (int32_t)channel->repeat_due_tick",
     ["flag_0x10_tick_wrap_uses_the_unsigned_compare"],
     "tick-wrap"),
    ("poll_latch_loses_the_stop_notification", "provider",
     "        channel->finished = 1u;\n        channel->stop_event_pending = 1u;\n        return ACTION_SOUND_BACKEND_OK;",
     "        channel->finished = 1u;\n        return ACTION_SOUND_BACKEND_OK;",
     ["completion_latched_by_a_poll_is_still_serviced"],
     None),
    ("adapter_refusal_removed", "adapter",
     "    if (info.update_refused != 0u) {",
     "    if (info.update_refused == 77u) {",
     ["adapter_still_refuses_what_it_cannot_prove"],
     None),
    ("adapter_repeat_marker_dropped", "adapter",
     "    record->repeat_marker_19e = info.repeat_marker;",
     "    record->repeat_marker_19e = 0u;",
     ["adapter_reports_an_armed_repeat_as_busy"],
     None),
]


if __name__ == "__main__":
    unittest.main(verbosity=2)
