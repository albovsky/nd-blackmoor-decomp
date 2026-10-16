#!/usr/bin/env python3
"""RT-1 live audio channel provider: fixtures, sanitizers, mutation check.

The checks themselves live in tests/live_audio_fixture.c (a C executable so
the same code runs under ASan/UBSan and against a substitute host). This
module builds it, generates a synthetic CDSound tree, runs every fixture,
requires each expected fixture to report, and proves the fixtures notice
deliberately broken provider rules. No resource bytes are printed or
committed; the one end-to-end case reads the owner's install in place.
"""

from __future__ import annotations

import json
import os
import pathlib
import re
import shutil
import struct
import subprocess
import tempfile
import unittest


PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
SCRIPT = PROJECT / "scripts/build_live_audio.sh"
SOURCE = PROJECT / "src/live_audio.c"

EXPECTED_TESTS = [
    "match_names", "lookup_and_status_mapping", "ambiguous_directory",
    "missing_sound_directory", "channel_bounds", "play_before_load",
    "reload_replaces", "gain_composition", "is_playing_lifecycle_fake",
    "stop_and_unload_mid_play", "stale_completion", "destroy_frees_everything",
    "bind_backend", "config_and_modes", "advance_offline_splits_and_counts",
    "main_thread_only", "malformed_header_sweep", "real_offline_lifecycle", "real_offline_gain_composition",
    "real_offline_stop_and_unload", "real_offline_stale_completion_after_reload",
    "end_to_end_nsht01",
]


def his_bytes(channels: int, rate: int, bits: int, payload: bytes, *,
              version: int = 2, decoded: int | None = None) -> bytes:
    block = channels * bits // 8
    return b"HIS\0" + struct.pack(
        "<IHHIIHHIH", version, 1, channels, rate, rate * block, block, bits,
        len(payload) if decoded is None else decoded, 1) + payload


def square_wave_16(frames: int, channels: int, amplitude: int) -> bytes:
    out = bytearray()
    for index in range(frames):
        value = amplitude if (index // 50) % 2 == 0 else -amplitude
        out += struct.pack("<h", value) * channels
    return bytes(out)


def build_fixture_tree(root: pathlib.Path, *, case_variants: bool = False) -> None:
    sounds = root / "CDSound"
    sounds.mkdir(parents=True)
    tone = his_bytes(2, 48000, 16, square_wave_16(20000, 2, 16384))
    (sounds / "Tone.HIS").write_bytes(tone)
    (sounds / "Long.his").write_bytes(his_bytes(2, 48000, 16, square_wave_16(60000, 2, 16384)))
    (sounds / "MONO.HIS").write_bytes(his_bytes(1, 22050, 16, square_wave_16(5000, 1, 8192)))
    (sounds / "BadMagic.HIS").write_bytes(b"XIS\0" + tone[4:])
    (sounds / "Truncated.HIS").write_bytes(tone[:29])
    (sounds / "ZeroBytes.HIS").write_bytes(his_bytes(2, 48000, 16, b""))
    (sounds / "HugeDecl.HIS").write_bytes(his_bytes(2, 48000, 16, tone[30:34], decoded=0xFFFFFFFE))
    (sounds / "AllFF.HIS").write_bytes(b"\xff" * 4096)
    (sounds / "BadVersion.HIS").write_bytes(his_bytes(2, 48000, 16, tone[30:], version=3))
    (sounds / "DirNamed.his").mkdir()
    (sounds / "notes.txt").write_text("not audio\n")
    if case_variants:
        (sounds / "TWIN.HIS").write_bytes(tone)
        (sounds / "twin.his").write_bytes(tone)


def owner_game_dir() -> pathlib.Path | None:
    try:
        source = json.loads((REPOSITORY / "work/analysis/game-source.json").read_text())
        path = pathlib.Path(source["game_dir"])
    except (OSError, KeyError, ValueError):
        return None
    return path if (path / "CDSound").is_dir() else None


def run_fixture(binary: pathlib.Path, fixture_dir: pathlib.Path, game_dir: pathlib.Path | None,
                *names: str, env: dict[str, str] | None = None,
                timeout: int = 240) -> tuple[int, dict[str, tuple[str, str]], str]:
    result = subprocess.run(
        [str(binary), str(fixture_dir), str(game_dir) if game_dir else "-", *names],
        capture_output=True, text=True, timeout=timeout,
        env={**os.environ, **(env or {})},
    )
    outcomes: dict[str, tuple[str, str]] = {}
    for line in result.stdout.splitlines():
        match = re.match(r"TEST (\S+) (PASS|FAIL|SKIP) ?(.*)", line)
        if match:
            outcomes[match.group(1)] = (match.group(2), match.group(3))
    return result.returncode, outcomes, result.stderr[-2000:]


def build(target: str, *, build_dir: pathlib.Path | None = None,
          source: pathlib.Path | None = None) -> subprocess.CompletedProcess:
    env = dict(os.environ)
    if build_dir is not None:
        env["LIVE_AUDIO_BUILD_DIR"] = str(build_dir)
    if source is not None:
        env["LIVE_AUDIO_SOURCE"] = str(source)
    return subprocess.run([str(SCRIPT), target], capture_output=True, text=True, env=env)


class LiveAudioTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = pathlib.Path(tempfile.mkdtemp(prefix="rt1-live-audio-"))
        cls.fixture_dir = cls.tmp / "game"
        build_fixture_tree(cls.fixture_dir)
        cls.game_dir = owner_game_dir()
        result = build("fixture")
        if result.returncode != 0:
            raise RuntimeError("build failed:\n" + result.stdout[-2000:] + result.stderr[-4000:])
        cls.binary = PROJECT / "build/live_audio_fixture"

    @classmethod
    def tearDownClass(cls) -> None:
        shutil.rmtree(cls.tmp, ignore_errors=True)

    def assert_all_pass(self, outcomes: dict[str, tuple[str, str]], code: int, stderr: str) -> None:
        for name in EXPECTED_TESTS:
            with self.subTest(fixture=name):
                self.assertIn(name, outcomes, "fixture did not report: " + stderr)
                status, detail = outcomes[name]
                if status == "SKIP":
                    self.skipTest(detail)
                self.assertEqual(status, "PASS", detail)
        self.assertEqual(code, 0, stderr)

    def test_fixtures_against_real_and_substitute_hosts(self) -> None:
        code, outcomes, stderr = run_fixture(self.binary, self.fixture_dir, self.game_dir)
        self.assert_all_pass(outcomes, code, stderr)

    def test_ambiguous_names_on_case_sensitive_volume(self) -> None:
        image = self.tmp / "cs.sparseimage"
        mount = self.tmp / "cs-mount"
        mount.mkdir()
        created = subprocess.run(
            ["hdiutil", "create", "-size", "16m", "-fs", "Case-sensitive APFS",
             "-volname", "RT1CS", "-type", "SPARSE", str(image)],
            capture_output=True, text=True)
        if created.returncode != 0:
            self.skipTest("cannot create a case-sensitive volume: " + created.stderr.strip()[:200])
        attached = subprocess.run(
            ["hdiutil", "attach", "-nobrowse", "-mountpoint", str(mount), str(image)],
            capture_output=True, text=True)
        if attached.returncode != 0:
            self.skipTest("cannot attach a case-sensitive volume: " + attached.stderr.strip()[:200])
        try:
            tree = mount / "game"
            build_fixture_tree(tree, case_variants=True)
            code, outcomes, stderr = run_fixture(self.binary, tree, None, "ambiguous_directory",
                                                 "lookup_and_status_mapping")
            self.assertEqual(outcomes.get("ambiguous_directory", ("MISSING", ""))[0], "PASS", outcomes)
            self.assertEqual(code, 0, stderr)
        finally:
            subprocess.run(["hdiutil", "detach", "-force", str(mount)], capture_output=True)

    def test_sanitizers(self) -> None:
        result = build("sanitize")
        self.assertEqual(result.returncode, 0, result.stdout[-1000:] + result.stderr[-4000:])
        binary = PROJECT / "build/sanitize/live_audio_fixture"
        code, outcomes, stderr = run_fixture(
            binary, self.fixture_dir, self.game_dir,
            env={"ASAN_OPTIONS": "abort_on_error=0:halt_on_error=1:detect_stack_use_after_return=1",
                 "UBSAN_OPTIONS": "print_stacktrace=1:halt_on_error=1"})
        self.assertNotIn("AddressSanitizer", stderr)
        self.assertNotIn("runtime error", stderr)
        self.assert_all_pass(outcomes, code, stderr)

    def test_no_leaks_on_destroy(self) -> None:
        if shutil.which("leaks") is None:
            self.skipTest("leaks(1) unavailable")
        env = {**os.environ, "MallocStackLogging": "1"}
        result = subprocess.run(
            ["leaks", "--atExit", "--", str(self.binary), str(self.fixture_dir), "-",
             "reload_replaces", "destroy_frees_everything", "play_before_load",
             "lookup_and_status_mapping", "stale_completion"],
            capture_output=True, text=True, env=env, timeout=240)
        text = result.stdout + result.stderr
        if "Process" not in text or "leaks for" not in text:
            self.skipTest("leaks could not inspect the fixture: " + text[-300:])
        match = re.search(r"(\d+) leaks for (\d+) total leaked bytes", text)
        self.assertIsNotNone(match, text[-500:])
        self.assertEqual(match.group(1), "0", text[-2000:])

    def test_output_mode_smoke(self) -> None:
        """Opt-in: opens the real output route for ~300 ms (LIVE_AUDIO_OUTPUT_SMOKE=1)."""
        if os.environ.get("LIVE_AUDIO_OUTPUT_SMOKE") != "1" or self.game_dir is None:
            self.skipTest("set LIVE_AUDIO_OUTPUT_SMOKE=1 with the owner install present")
        # the first argument is the directory that holds CDSound: the owner's install
        result = subprocess.run([str(self.binary), str(self.game_dir), "-", "smoke"],
                                capture_output=True, text=True, timeout=60)
        print("\n" + result.stdout)
        self.assertIn("SMOKE PASS", result.stdout, result.stdout + result.stderr)

    def test_mutations_are_detected(self) -> None:
        for name, old, new, must_fail in MUTATIONS:
            with self.subTest(mutation=name):
                text = SOURCE.read_text()
                self.assertIn(old, text, "mutation target missing: " + name)
                mutant_dir = self.tmp / ("mutant-" + name)
                mutant_dir.mkdir()
                source = mutant_dir / "live_audio.c"
                source.write_text(text.replace(old, new, 1))
                result = build("fixture", build_dir=mutant_dir, source=source)
                self.assertEqual(result.returncode, 0, "mutant did not build: " + result.stderr[-1500:])
                code, outcomes, stderr = run_fixture(mutant_dir / "live_audio_fixture", self.fixture_dir,
                                                     self.game_dir, *must_fail)
                failing = [t for t in must_fail if outcomes.get(t, ("MISSING", ""))[0] == "FAIL"]
                self.assertTrue(failing, f"mutation {name} survived: {outcomes} {stderr}")
                self.assertNotEqual(code, 0)
                print(f"\nmutation {name}: detected by {failing}")


MUTATIONS: list[tuple[str, str, str, list[str]]] = [
    ("shared_host_slot_for_replacement",
     "return (uint32_t)channel + LIVE_AUDIO_CHANNEL_COUNT * (uint32_t)(load_serial % HOST_SLOTS_PER_CHANNEL);",
     "return (uint32_t)channel + 0u * (uint32_t)load_serial;",
     ["stale_completion", "reload_replaces", "channel_bounds"]),
    ("ignore_second_gain",
     "volatile float product = first * second;",
     "volatile float product = first + 0.0f * second;",
     ["gain_composition", "real_offline_gain_composition"]),
    ("ignore_category_scalar",
     "volatile float final_gain = product * category_scalar;",
     "volatile float final_gain = product + 0.0f * category_scalar;",
     ["gain_composition", "real_offline_gain_composition"]),
    ("missing_asset_is_error_not_no_resource",
     "        return ACTION_SOUND_BACKEND_NO_RESOURCE;\n    }\n    if (resolved == RESOLVE_AMBIGUOUS)",
     "        return ACTION_SOUND_BACKEND_ERROR;\n    }\n    if (resolved == RESOLVE_AMBIGUOUS)",
     ["lookup_and_status_mapping", "missing_sound_directory"]),
    ("case_sensitive_lookup",
     "fold((unsigned char)name[index]) != fold((unsigned char)stem[index])",
     "name[index] != stem[index]",
     ["match_names", "lookup_and_status_mapping"]),
    ("ambiguity_accepted",
     "if (matches > 1u) return LIVE_AUDIO_MATCH_AMBIGUOUS;",
     "",
     ["match_names"]),
    ("overlong_stem_accepted",
     "for (index = 0u; index <= LIVE_AUDIO_MAX_STEM_CHARS; ++index)",
     "for (index = 0u; index <= LIVE_AUDIO_MAX_STEM_CHARS + 1u; ++index)",
     ["match_names", "lookup_and_status_mapping"]),
    ("play_before_load_reaches_host",
     "    if (!channel->loaded) {\n        logf_line(audio, \"live_audio play_rejected reason=channel-not-loaded channel=%u\", index);\n        return ACTION_SOUND_BACKEND_ERROR;\n    }\n    return play_channel(audio, index, 0u, NULL);",
     "    (void)channel;\n    return start_host(audio, index, 0);",
     ["play_before_load"]),
    ("completion_not_latched",
     "if (!channel->loaded || !channel->started || channel->finished) return ACTION_SOUND_BACKEND_OK;",
     "if (!channel->loaded || !channel->started) return ACTION_SOUND_BACKEND_OK;",
     ["is_playing_lifecycle_fake"]),
    ("unload_does_not_stop_host",
     "if (channel->started) {\n        status = audio->ops.stop(audio->host, channel->host_slot, error, sizeof(error));",
     "if (0) {\n        status = audio->ops.stop(audio->host, channel->host_slot, error, sizeof(error));",
     ["stop_and_unload_mid_play", "reload_replaces", "destroy_frees_everything",
      "real_offline_stop_and_unload"]),
    ("reload_keeps_previous_sound",
     "(void)release_channel(audio, command->channel);\n\n    if (stem_length == 0u)",
     "\n    if (stem_length == 0u)",
     ["reload_replaces", "play_before_load"]),
    ("is_playing_unbounded_channel",
     "index >= LIVE_AUDIO_CHANNEL_COUNT)\n        return ACTION_SOUND_BACKEND_ERROR;\n    channel = &audio->channels[index];\n    if (!channel->loaded || !channel->started",
     "0)\n        return ACTION_SOUND_BACKEND_ERROR;\n    channel = &audio->channels[index];\n    if (!channel->loaded || !channel->started",
     ["channel_bounds"]),
]


if __name__ == "__main__":
    unittest.main(verbosity=2)
