#!/usr/bin/env python3
"""Record a sanitized scripted live run and committed test totals.

Build with scripts/build_native_app.sh first. Raw logs remain in work/;
playable-status.json contains no resource strings or raw log lines.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

OUT = Path(__file__).resolve().parents[1]
REPO = OUT.parents[1]
SPEC = importlib.util.spec_from_file_location("blackmoor_playable", OUT / "decomp-progress/playable.py")
PLAYABLE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(PLAYABLE)
PlayableError = PLAYABLE.PlayableError

EVENTS = {"scene_transition_applied", "live_session_end", "scene_session_blocked", "scene_transition_error"}
TRANSITION_REASONS = {
    "negative-scene", "audio-unload-failed", "scene-clear", "caption-clear",
    "target-load-failed", "session-replace", "binding-scene-load", "exit-handler",
    "load-state-without-pending-transition",
}


def parse_log(text: str) -> dict:
    """Only successful transitions add scenes; a failed target is never reached.

    live_session_end can name the loaded target even though session replacement
    failed. Preserve the error's source, row, type and provider in that case.
    """
    reached, current, stop, end = [], None, None, None

    def number(fields, key):
        if key not in fields or not re.fullmatch(r"[0-9]+", fields[key]):
            raise PlayableError(f"live log: missing or invalid {key}")
        return int(fields[key])

    def scene(fields, key):
        n = number(fields, key)
        if n > 99999:
            raise PlayableError("live log: invalid scene id")
        return f"S{n}"

    def visit(s):
        if s not in reached:
            reached.append(s)

    def action(fields):
        row = number(fields, "action") if "action" in fields else None
        # SIZE_MAX is the native sentinel for failures without an action row.
        row = row if row is None or row < 2**32 else None
        code = fields.get("type") if row is not None else None
        if code is not None and not re.fullmatch(r"0x[0-9a-fA-F]{2}", code):
            raise PlayableError("live log: invalid action type")
        provider = fields.get("provider")
        if provider is not None and provider not in PLAYABLE.PROVIDERS:
            raise PlayableError("live log: unknown provider")
        return {"row": row, "action_type": code.lower() if code else None, "provider": provider}

    for line in text.splitlines():
        event, _, rest = line.partition(" ")
        if event not in EVENTS:
            continue
        if end is not None:
            raise PlayableError("live log: event after live_session_end")
        # Values not explicitly selected below (including resource fields) are
        # discarded. Never copy a full line or an arbitrary error description.
        fields = {}
        for key, value in re.findall(r"\b([a-z_]+)=([^\s]+)", rest):
            if key in fields:
                raise PlayableError(f"live log: duplicate key {key}")
            fields[key] = value
        if event == "scene_transition_applied":
            source, target = scene(fields, "source"), scene(fields, "target")
            if current is not None and source != current:
                raise PlayableError("live log: discontinuous scene transitions")
            visit(source)
            visit(target)
            current, stop = target, None
        elif event == "scene_transition_error":
            source = scene(fields, "source") if "source" in fields else current
            if source is not None and current is not None and source != current:
                raise PlayableError("live log: transition error source mismatch")
            reason = fields.get("detail")
            if reason not in TRANSITION_REASONS:
                raise PlayableError("live log: unknown transition error reason")
            current = source
            if source is not None:
                visit(source)
            stop = {"kind": event, "scene": source,
                    "target_scene": scene(fields, "target") if "target" in fields else None,
                    **action(fields), "reason": reason}
        elif event == "scene_session_blocked":
            stop = {"kind": event, "scene": current, "target_scene": None,
                    **action(fields), "reason": "provider-blocked"}
        else:
            end = fields
    if end is None:
        raise PlayableError("live log: missing live_session_end; evidence not replaced")
    end_scene = scene(end, "scene")
    ticks = number(end, "ticks")
    status = number(end, "status")
    if current is None:
        current = end_scene
        visit(current)
    if stop and stop["kind"] == "scene_transition_error":
        if end_scene not in {current, stop["target_scene"]}:
            raise PlayableError("live log: end scene does not agree with transition failure")
    elif end_scene != current:
        raise PlayableError("live log: end scene has no successful transition")
    if stop and stop["kind"] == "scene_session_blocked" and status != 2:
        stop = None  # A transient provider block recovered before the final tick.
    if stop is None:
        if status == 2:
            stop = {"kind": "scene_session_blocked", "scene": current,
                    "target_scene": None, **action(end), "reason": "provider-blocked"}
        elif status in {0, 1}:
            stop = {"kind": "tick_limit", "scene": current, "target_scene": None,
                    "row": None, "action_type": None, "provider": None, "reason": "tick-limit"}
        else:
            raise PlayableError("live log: unclassified final session error")
    stop["scene"] = current
    return {"reached_scenes": reached, "stop": stop, "ticks": ticks}


def next_blocker(stop, actions):
    location = stop["target_scene"] or stop["scene"]
    if stop["kind"] == "tick_limit":
        return f"{location}: scripted tick limit reached; further gameplay remains unverified."
    if stop["action_type"] is not None:
        code = stop["action_type"]
        state = "opaque action" if code in actions["opaque"]["types"] else "action"
        scope = " load" if stop["target_scene"] else ""
        return f"{location}{scope}: {state} {code} at row {stop['row']} ({stop['provider'] or 'provider unavailable'})."
    return f"{location}: {stop['reason']} ({stop['provider'] or 'provider unavailable'})."


def seed(status, actions):
    integration = status.get("current_integration", {})
    session = integration.get("persistent_session", {})
    reached = session.get("observed_scenes")
    expected = ["S0", "S5900", "S5907", *[f"S{i}" for i in range(5901, 5907)], "S4700"]
    if reached != expected:
        raise PlayableError("seed requires the packet's committed integration scene path")
    source = re.match(r"[0-9a-f]{40}", integration.get("source_ref", ""))
    if source is None:
        raise PlayableError("seed has no committed source ref")
    return {
        "evidence": {"kind": "seeded_committed_integration", "source_ref": source[0],
                     "native_sha256": None, "command": PLAYABLE.LIVE_ARGS,
                     "registration_sources": actions["sources"]},
        "reached_scenes": reached, "ticks": 0,
        "stop": {"kind": "scene_session_blocked", "scene": "S4700", "target_scene": None,
                 "row": 3, "action_type": "0x35", "provider": "action-kernel", "reason": "provider-blocked"},
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--app", type=Path, default=OUT / "Blackmoor Reconstruction.app/Contents/MacOS/BlackmoorNative")
    ap.add_argument("--game-dir", type=Path, help="owner's read-only game directory; otherwise use the native app default")
    ap.add_argument("--output", type=Path, default=OUT / "playable-status.json")
    ap.add_argument("--private-dir", type=Path, default=REPO / "work/analysis/slices", help="private raw-log directory")
    ap.add_argument("--seed", action="store_true", help="seed from committed integration evidence without a live run")
    args = ap.parse_args(argv)
    try:
        def clean_source_ref():
            dirty = subprocess.check_output(
                ["git", "status", "--porcelain", "--untracked-files=all", "--",
                 "outputs/blackmoor-decomp/src", "outputs/blackmoor-decomp/scripts"],
                cwd=REPO, text=True)
            if dirty.strip():
                raise PlayableError("native source or scripts are dirty; commit changes before recording")
            return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip()

        ref = clean_source_ref()
        status = PLAYABLE.read_json(OUT / "status.json")
        actions = PLAYABLE.derive_actions(OUT)
        if args.seed:
            result = seed(status, actions)
        else:
            if not args.app.is_file():
                raise PlayableError("native app unavailable; run scripts/build_native_app.sh, or use --seed")
            if args.game_dir and not (args.game_dir / "Game.ini").is_file():
                raise PlayableError("game files unavailable; use --seed to retain committed evidence")
            native_hash = hashlib.sha256(args.app.read_bytes()).hexdigest()
            args.private_dir.mkdir(parents=True, exist_ok=True)
            private = Path(tempfile.mkdtemp(prefix="PROG-1-live-", dir=args.private_dir))
            log = private / "session.log"
            command = [str(args.app.resolve()), *PLAYABLE.LIVE_ARGS, "--log", str(log.resolve())]
            if args.game_dir:
                command += ["--game-dir", str(args.game_dir.resolve())]
            with (private / "process.log").open("w") as capture:
                run = subprocess.run(command, stdout=capture, stderr=capture, timeout=180)
            if not log.is_file():
                raise PlayableError(f"native run did not produce a log; private evidence: {private}")
            result = parse_log(log.read_text(encoding="utf-8"))
            if run.returncode and result["stop"]["kind"] == "tick_limit":
                raise PlayableError("native run failed without a classified blocker")
            if hashlib.sha256(args.app.read_bytes()).hexdigest() != native_hash:
                raise PlayableError("native executable changed during the run")
            result["evidence"] = {"kind": "scripted_live_session", "source_ref": ref,
                                  "native_sha256": native_hash, "command": PLAYABLE.LIVE_ARGS,
                                  "registration_sources": actions["sources"]}
            print(f"Private live evidence: {private}")
        if clean_source_ref() != ref or PLAYABLE.derive_actions(OUT)["sources"] != actions["sources"]:
            raise PlayableError("native source changed during recording; evidence not replaced")
        result.update(schema=PLAYABLE.SCHEMA, tests=PLAYABLE.test_totals(status),
                      next_blocker=next_blocker(result["stop"], actions))
        PLAYABLE.validate_status(result)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        # Parse and validate before replacing any prior public evidence.
        staged = None
        try:
            with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=args.output.parent,
                                             prefix=".playable-status-", delete=False) as f:
                staged = Path(f.name)
                json.dump(result, f, indent=2)
                f.write("\n")
            staged.replace(args.output)
        finally:
            if staged is not None:
                staged.unlink(missing_ok=True)
        print(f"Recorded {len(result['reached_scenes'])} scenes; {result['next_blocker']}")
        return 0
    except (PlayableError, OSError, subprocess.SubprocessError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
