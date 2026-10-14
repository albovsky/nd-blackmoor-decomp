"""Public playable evidence parsing: no original game or native build needed."""

import copy
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

OUT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("record_playable_status", OUT / "scripts/record_playable_status.py")
RECORD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RECORD)
P = RECORD.PLAYABLE

PATH = [0, 5900, 5907, *range(5901, 5907)]


def transition_log():
    return "\n".join(f"scene_transition_applied source={a} target={b} generation={i}"
                     for i, (a, b) in enumerate(zip(PATH, PATH[1:]), 2))


def end(scene=5906, status=0, provider="none", action=0, code="0x00"):
    return (f"live_session_end scene={scene} ticks=674 status={status} provider={provider} "
            f"stage=0 action={action} type={code} detail=0 applied=0")


class LogTests(unittest.TestCase):
    def test_duplicate_keys_fail_closed_in_each_recognized_event(self):
        with tempfile.TemporaryDirectory() as d:
            log_path = Path(d) / "session.log"
            cases = [
                ("scene_transition_applied source=0 target=5900 target=5901\n" + end(scene=5901)),
                ("scene_transition_error source=0 target=5900 detail=target-load-failed detail=session-replace\n" + end(scene=0)),
                ("scene_session_blocked provider=caption provider=action-sound action=31 type=0x9f\n" +
                 end(scene=0, status=2, provider="action-sound", action=31, code="0x9f")),
                end(scene=0) + " scene=0",
                end(scene=0) + " payload=a payload=b",
            ]
            for log in cases:
                with self.subTest(log=log):
                    log_path.write_text(log)
                    with self.assertRaisesRegex(P.PlayableError, "duplicate key"):
                        RECORD.parse_log(log_path.read_text())

    def test_failed_target_is_not_reached_and_stale_end_does_not_hide_blocker(self):
        # The app has loaded S4700 before executor replacement rejects its row.
        # Its final tick result still describes the previous transition.
        log = (transition_log() + "\nscene_transition_error source=5906 target=4700 "
               "detail=session-replace status=5 provider=scene-resource action=3 type=0x35 detail_status=6\n" +
               end(scene=4700, status=1))
        result = RECORD.parse_log(log)
        self.assertEqual(result["reached_scenes"], [f"S{s}" for s in PATH])
        self.assertNotIn("S4700", result["reached_scenes"])
        self.assertEqual(result["stop"], {
            "kind": "scene_transition_error", "scene": "S5906", "target_scene": "S4700",
            "row": 3, "action_type": "0x35", "provider": "scene-resource", "reason": "session-replace"})

    def test_provider_block_without_transitions(self):
        log = "scene_session_blocked stage=3 provider=action-sound action=31 type=0x9f detail=7\n"
        result = RECORD.parse_log(log + end(scene=0, status=2, provider="action-sound", action=31, code="0x9f"))
        self.assertEqual(result["reached_scenes"], ["S0"])
        self.assertEqual(result["stop"]["provider"], "action-sound")
        self.assertEqual(result["stop"]["row"], 31)

    def test_final_block_fields_can_be_taken_from_end(self):
        result = RECORD.parse_log(end(scene=0, status=2, provider="caption", action=8, code="0x51"))
        self.assertEqual(result["stop"]["kind"], "scene_session_blocked")
        self.assertEqual(result["stop"]["action_type"], "0x51")

    def test_successful_transition_clears_prior_provider_block(self):
        log = ("scene_session_blocked provider=action-sound action=31 type=0x9f\n"
               "scene_transition_applied source=0 target=5900 generation=2\n" + end(scene=5900))
        self.assertEqual(RECORD.parse_log(log)["stop"]["kind"], "tick_limit")

    def test_transient_provider_recovery_at_same_scene(self):
        log = "scene_session_blocked provider=caption action=1 type=0x51\n" + end(scene=0)
        self.assertEqual(RECORD.parse_log(log)["stop"]["kind"], "tick_limit")

    def test_revisits_count_unique_scenes_and_keep_current_stop(self):
        log = ("scene_transition_applied source=0 target=5900 generation=2\n"
               "scene_transition_applied source=5900 target=0 generation=3\n" + end(scene=0))
        result = RECORD.parse_log(log)
        self.assertEqual(result["reached_scenes"], ["S0", "S5900"])
        self.assertEqual(result["stop"]["scene"], "S0")

    def test_error_before_first_transition_counts_source(self):
        result = RECORD.parse_log("scene_transition_error source=0 target=5900 detail=target-load-failed\n" + end(scene=0))
        self.assertEqual(result["reached_scenes"], ["S0"])
        self.assertIsNone(result["stop"]["action_type"])

    def test_missing_action_sentinel_is_not_a_huge_row(self):
        result = RECORD.parse_log(end(scene=0, status=2, provider="world-clock", action=2**64 - 1))
        self.assertIsNone(result["stop"]["row"])
        self.assertIsNone(result["stop"]["action_type"])

    def test_resource_and_unrecognized_fields_are_discarded(self):
        private = "PRIVATE_RESOURCE_PAYLOAD_12345"
        log = (f"resource_dump payload={private}\nscene_transition_applied source=0 target=5900 generation=2 payload={private}\n" +
               end(scene=5900) + f" payload={private}")
        result = RECORD.parse_log(log)
        self.assertNotIn(private, json.dumps(result))
        self.assertNotIn("payload", json.dumps(result))

    def test_incomplete_or_contradictory_run_is_rejected(self):
        cases = [
            (transition_log(), "missing live_session_end"),
            ("scene_transition_applied source=0 target=5900\nscene_transition_applied source=5 target=6\n" + end(), "discontinuous"),
            (transition_log() + "\n" + end(scene=4700), "no successful transition"),
            (end(scene=0) + "\n" + end(scene=0), "event after"),
            ("scene_session_blocked provider=resource-bytes action=1 type=0x35\n" + end(scene=0), "unknown provider"),
            ("scene_transition_error source=0 target=1 detail=private-resource-text\n" + end(scene=0), "unknown transition"),
            (end(scene=0, status=5), "unclassified"),
        ]
        for log, message in cases:
            with self.subTest(message=message), self.assertRaisesRegex(P.PlayableError, message):
                RECORD.parse_log(log)


class ContractTests(unittest.TestCase):
    def setUp(self):
        self.public = P.read_json(OUT / "playable-status.json")

    def test_pinned_schema_and_packet_seed(self):
        self.assertEqual(P.SCHEMA, "blackmoor-playable-status/2")
        self.assertEqual(P.validate_status(self.public), self.public)
        seeded = RECORD.seed(P.read_json(OUT / "status.json"), P.derive_actions(OUT))
        self.assertEqual(seeded["reached_scenes"], [f"S{s}" for s in [*PATH, 4700]])
        self.assertEqual(seeded["evidence"]["kind"], "seeded_committed_integration")
        self.assertIsNone(seeded["evidence"]["native_sha256"])

    def test_latest_committed_totals_override_legacy_totals(self):
        status = {"tests": {"discovered": 499, "passed": 497, "skipped": 2},
                  "current_integration": {"full_suite": {"discovered": 774, "passed": 769, "skipped": 5}}}
        self.assertEqual(P.test_totals(status), {"discovered": 774, "passed": 769, "skipped": 5,
                                               "source_field": "current_integration.full_suite"})
        del status["current_integration"]
        self.assertEqual(P.test_totals(status)["discovered"], 499)
        status["tests"]["passed"] = 999
        with self.assertRaisesRegex(P.PlayableError, "exceed"):
            P.test_totals(status)

    def test_schema_rejects_extra_fields_and_unbounded_log_values(self):
        changes = [
            ((), "schema", "blackmoor-playable-status/1"),
            ((), "payload", "resource-bytes"),
            (("stop",), "log", "resource-bytes"),
            (("stop",), "row", -1),
            (("stop",), "provider", "unknown-resource-name"),
            (("stop",), "provider", []),
            (("evidence",), "kind", {}),
            (("stop",), "action_type", "0x123"),
            (("stop",), "scene", "S99999"),
            (("tests",), "passed", True),
            (("evidence",), "command", ["--inspect-startup"]),
            (("evidence",), "registration_sources", []),
            (("evidence",), "registration_sources", {}),
            (("evidence", "registration_sources", 0), "path", "../original/GAME.EXE"),
            (("evidence", "registration_sources", 0), "sha256", "not-a-hash"),
            (("evidence", "registration_sources", 0), "payload", "private-resource-bytes"),
            ((), "next_blocker", "raw\nlog"),
        ]
        for path, key, value in changes:
            with self.subTest(key=key):
                doc = copy.deepcopy(self.public)
                obj = doc
                for part in path:
                    obj = obj[part]
                obj[key] = value
                with self.assertRaises(P.PlayableError):
                    P.validate_status(doc)

    def test_registration_hash_contract_rejects_missing_and_duplicate_sources(self):
        for change in (
                lambda d: d["evidence"].pop("registration_sources"),
                lambda d: d["evidence"]["registration_sources"][0].pop("sha256"),
                lambda d: d["evidence"]["registration_sources"].append(
                    copy.deepcopy(d["evidence"]["registration_sources"][0]))):
            doc = copy.deepcopy(self.public)
            change(doc)
            with self.assertRaises(P.PlayableError):
                P.validate_status(doc)

    def test_failed_live_run_does_not_replace_committed_evidence(self):
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            output, app = d / "public.json", d / "fake-app"
            output.write_text("keep-prior-evidence")
            app.write_text("fake-native")

            def failed(command, **kwargs):
                self.assertEqual(command[1:6], P.LIVE_ARGS)
                log = Path(command[command.index("--log") + 1])
                log.write_text("host_error=private-resource-text\n")
                return subprocess.CompletedProcess(command, 1)

            with patch.object(RECORD.subprocess, "run", side_effect=failed), patch.object(
                    RECORD.subprocess, "check_output", side_effect=lambda cmd, **kw: "" if cmd[1] == "status" else "a" * 40):
                rc = RECORD.main(["--app", str(app), "--output", str(output), "--private-dir", str(d)])
            self.assertEqual(rc, 2)
            self.assertEqual(output.read_text(), "keep-prior-evidence")

    def test_successful_recorder_runs_pinned_command_and_merges_totals(self):
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            app = d / "fake-app"
            app.write_text("fake-native")
            def successful(command, **kwargs):
                self.assertEqual(command[1:6], P.LIVE_ARGS)
                Path(command[command.index("--log") + 1]).write_text(transition_log() + "\n" + end())
                return subprocess.CompletedProcess(command, 0)
            with patch.object(RECORD.subprocess, "run", side_effect=successful), patch.object(
                    RECORD.subprocess, "check_output", side_effect=lambda cmd, **kw: "" if cmd[1] == "status" else "a" * 40):
                output = d / "public.json"
                self.assertEqual(RECORD.main(["--app", str(app), "--output", str(output),
                                              "--private-dir", str(d)]), 0)
            result = P.validate_status(json.loads(output.read_text()))
            self.assertEqual(result["tests"], P.test_totals(P.read_json(OUT / "status.json")))
            self.assertEqual(result["evidence"]["native_sha256"], RECORD.hashlib.sha256(app.read_bytes()).hexdigest())
            self.assertEqual(result["stop"]["kind"], "tick_limit")


class RecorderMutationTests(unittest.TestCase):
    """Exercise the actual CLI and Git checks in an isolated public-source copy."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(dir=OUT.parents[1] / "work/analysis/slices", prefix="PROG-1.1-test-")
        self.repo = Path(self.tmp.name)
        self.out = self.repo / "outputs/blackmoor-decomp"
        self.out.mkdir(parents=True)
        shutil.copytree(OUT / "src", self.out / "src")
        for name in ("status.json", "action-census-current.json"):
            shutil.copy2(OUT / name, self.out)
        for name in ("scripts/record_playable_status.py", "decomp-progress/playable.py"):
            dest = self.out / name
            dest.parent.mkdir(exist_ok=True)
            shutil.copy2(OUT / name, dest)
        self.app = self.repo / "fake-native"
        self.app.write_text("#!/usr/bin/env python3\nimport pathlib,sys\n"
                            "pathlib.Path(sys.argv[sys.argv.index('--log')+1]).write_text(" +
                            repr(end(scene=0)) + ")\n")
        self.app.chmod(0o755)
        self.output = self.out / "playable-status.json"
        self.output.write_text("keep-prior-evidence")
        self.git("init", "-q")
        self.git("add", ".")
        self.git("-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid",
                 "-c", "commit.gpgsign=false", "commit", "-qm", "public source fixture")

    def tearDown(self):
        self.tmp.cleanup()

    def git(self, *args):
        return subprocess.check_output(["git", *args], cwd=self.repo, text=True)

    def record(self, *extra):
        return subprocess.run([sys.executable, str(self.out / "scripts/record_playable_status.py"),
                               "--app", str(self.app), "--output", str(self.output),
                               "--private-dir", str(self.repo / "private"), *extra],
                              capture_output=True, text=True)

    def test_dirty_native_sources_and_scripts_refuse_recording(self):
        for name in ("src/blackmoor_app.mm", "scripts/record_playable_status.py", "src/new-registration.h"):
            path = self.out / name
            original = path.read_bytes() if path.exists() else None
            for seed in (False, True):
                with self.subTest(name=name, seed=seed):
                    path.write_bytes((original or b"") + b"\n")
                    try:
                        run = self.record(*(["--seed"] if seed else []))
                        self.assertEqual(run.returncode, 2, run.stdout + run.stderr)
                        self.assertIn("dirty", run.stderr)
                        self.assertEqual(self.output.read_text(), "keep-prior-evidence")
                    finally:
                        if original is None:
                            path.unlink()
                        else:
                            path.write_bytes(original)
                        self.output.write_text("keep-prior-evidence")

    def test_staged_source_changes_refuse_recording(self):
        path = self.out / "src/blackmoor_app.mm"
        path.write_bytes(path.read_bytes() + b"\n")
        self.git("add", str(path.relative_to(self.repo)))
        run = self.record()
        self.assertEqual(run.returncode, 2, run.stdout + run.stderr)
        self.assertIn("dirty", run.stderr)
        self.assertEqual(self.output.read_text(), "keep-prior-evidence")

    def test_live_and_seeded_evidence_pin_all_registration_inputs(self):
        # Documentation/public-evidence edits must not prevent a native recording.
        (self.repo / "notes.md").write_text("uncommitted documentation")
        for seed in (False, True):
            with self.subTest(seed=seed):
                run = self.record(*(["--seed"] if seed else []))
                self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
                result = P.validate_status(json.loads(self.output.read_text()))
                self.assertEqual(result["schema"], "blackmoor-playable-status/2")
                self.assertEqual(result["evidence"].get("registration_sources"), P.derive_actions(self.out)["sources"])
                if not seed:
                    self.assertEqual(result["evidence"]["source_ref"], self.git("rev-parse", "HEAD").strip())

    def test_failed_json_write_cleans_temporary_file_and_preserves_evidence(self):
        # An interrupted disk write happens after NamedTemporaryFile is created.
        with patch.object(RECORD, "OUT", self.out), patch.object(RECORD, "REPO", self.repo), patch.object(
                RECORD.json, "dump", side_effect=OSError("disk write failed")):
            self.assertEqual(RECORD.main(["--seed", "--output", str(self.output)]), 2)
        self.assertEqual(self.output.read_text(), "keep-prior-evidence")
        self.assertEqual(list(self.out.glob(".playable-status-*")), [])


if __name__ == "__main__":
    unittest.main()
