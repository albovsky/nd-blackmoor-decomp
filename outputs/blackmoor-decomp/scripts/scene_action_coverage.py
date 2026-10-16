#!/usr/bin/env python3
"""Scene-level action coverage: which scenes have a live handler for every row.

Counts come from the production scene parser run over the decoded scene resources
(work/analysis/hiff-resources, local only) and from the registrations the progress map
already derives from the sources. Output is derived counts only, never resource bytes.

    python3 scripts/scene_action_coverage.py            # print the ranking
    python3 scripts/scene_action_coverage.py --write    # refresh scene-action-coverage.json
"""
import argparse
import collections
import json
import subprocess
import sys
import tempfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
OUTPUT = PROJECT / "scene-action-coverage.json"
sys.path.insert(0, str(PROJECT / "decomp-progress"))
import playable  # noqa: E402


def scene_rows(resources: Path):
    index = json.loads((resources.parent / "hiff-resources.json").read_text())["resources"]
    names = {Path(r["path"]).name: r["name"] for r in index}
    with tempfile.TemporaryDirectory() as tmp:
        exe = Path(tmp) / "dump"
        subprocess.run(["cc", "-std=c11", "-O1", "-I", str(PROJECT / "src"),
                        str(PROJECT / "tests/scene_action_dump.c"), str(PROJECT / "src/scene_resource.c"),
                        str(PROJECT / "src/hiff.c"), "-o", str(exe)], check=True)
        files = sorted(resources.glob("*.bin"))
        out = subprocess.run([str(exe), *map(str, files)], check=True, capture_output=True, text=True).stdout
    scenes = {}
    for line in out.splitlines():
        parts = line.split()
        scenes[names.get(Path(parts[0]).name, Path(parts[0]).name)] = [int(t, 16) for t in parts[2:]]
    return scenes


def analyse(scenes, handled):
    missing = {s: set(t) - handled for s, t in scenes.items()}
    per_type = collections.OrderedDict()
    for ty in sorted({x for m in missing.values() for x in m}):
        in_scenes = [s for s, m in missing.items() if ty in m]
        per_type[ty] = {
            "scenes": len(in_scenes),
            "records": sum(scenes[s].count(ty) for s in in_scenes),
            "sole_blocker_scenes": sum(1 for s in in_scenes if missing[s] == {ty}),
        }
    cur, order, rest = set(handled), [], set(per_type)
    base = sum(1 for t in scenes.values() if set(t) <= cur)
    while rest:
        gains = {ty: sum(1 for t in scenes.values() if set(t) <= cur | {ty}) - base for ty in rest}
        ty = max(sorted(rest), key=lambda k: (gains[k], per_type[k]["scenes"]))
        base += gains[ty]
        cur.add(ty)
        rest.discard(ty)
        order.append({"type": f"0x{ty:02x}", "scenes_unblocked": gains[ty], "scenes_complete": base})
    ranked = sorted(per_type.items(), key=lambda kv: (-kv[1]["scenes"], kv[0]))
    return {
        "schema": "blackmoor-scene-action-coverage/1",
        "scenes": len(scenes),
        "scenes_all_rows_handled": sum(1 for m in missing.values() if not m),
        "handled_types": [f"0x{t:02x}" for t in sorted(handled)],
        "missing_types": [{"type": f"0x{ty:02x}", **v} for ty, v in ranked],
        "greedy_order": order,
        "note": "Static: a scene counts when every row type has a registered live handler. A handler can still "
                "refuse a branch at run time, so this is an upper bound, not a played-through count.",
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--resources", type=Path, default=ROOT / "work/analysis/hiff-resources")
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()
    handled = {int(t, 16) for t in playable.derive_actions(PROJECT)["handled"]["types"]}
    result = analyse(scene_rows(args.resources), handled)
    text = json.dumps(result, indent=2) + "\n"
    if args.write:
        OUTPUT.write_text(text)
    print(f"scenes {result['scenes']}, every row handled {result['scenes_all_rows_handled']}")
    for row in result["missing_types"][:12]:
        print(f"  {row['type']}: {row['scenes']} scenes, {row['records']} records, sole blocker in {row['sole_blocker_scenes']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
