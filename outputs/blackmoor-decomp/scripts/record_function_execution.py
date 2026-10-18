#!/usr/bin/env python3
"""FL-8: record which original GAME.EXE functions the oracles actually execute.

  run      run every original-x86 oracle script (and optional unittest modules)
           under the executed-range recorder (scripts/exec_trace/sitecustomize.py)
           and write raw traces plus a runs table to a private trace directory
  collect  merge the traces of passing runs into function-execution.json
           (committed: addresses, counts, script hashes; no original bytes)
  collect without --write compares function-execution.json with the private traces (the check)

The raw traces stay under work/ (gitignored).  Run the oracles from a scratch
copy of the checkout (--root) when you do not want them to rewrite the private
slice receipts under work/analysis/slices.

Examples (from the repository root):
  python3 outputs/blackmoor-decomp/scripts/record_function_execution.py run \
      --root /scratch/copy --trace-dir work/analysis/FL-8/traces
  python3 outputs/blackmoor-decomp/scripts/record_function_execution.py collect --write
"""

from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parents[1]
TRACE_SHIM = PROJECT / "scripts/exec_trace"
OUTPUT = PROJECT / "function-execution.json"
XREFS = PROJECT / "function-xrefs.json"
INDEX = PROJECT / "function-index.json"
SCHEMA = "blackmoor-function-execution/1"
DEFAULT_TRACE_DIR = WORKSPACE / "work/analysis/FL-8/traces"
TEXT_BEGIN, TEXT_END = 0x401000, 0x52925A
# matching_* are the Track M x86 oracles (reassembled asm against the original); the extractor does not read them
EXCLUDED = ("mutation", "oracle_support", "tail_oracle_common", "tail_oracle_prescan", "matching_")
# Oracles whose command line is not empty.  {project} = outputs/blackmoor-decomp, {exe} = work/original/GAME.EXE,
# {scratch} = a per-run scratch directory for the report the script insists on writing.
ORACLE_ARGS = {
    "action_family_f6_original_oracle.py": ["--native-library", "{project}/build/libactionfamilyf6.dylib"],
    "cif_original_oracle.py": ["self-test"],
    "conditions_original_oracle.py": ["--native-library", "{project}/build/libsceneconditions.dylib",
                                      "--report", "{scratch}/report.json"],
    "dependency_original_oracle.py": ["--exe", "{exe}", "--native-library",
                                      "{project}/build/libscenedependencies.dylib", "--report", "{scratch}/report.json"],
    "hiff_original_oracle.py": ["fixture", "--native-library", "{project}/build/libhiff.dylib"],
}


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def discover(root: Path) -> list[str]:
    tests = root / "outputs/blackmoor-decomp/tests"
    names = []
    for path in sorted(tests.glob("*oracle*.py")):
        if path.name.startswith("test_") or any(word in path.name for word in EXCLUDED):
            continue
        names.append(f"outputs/blackmoor-decomp/tests/{path.name}")
    return names


def run_one(root: Path, trace_dir: Path, script: str, timeout: int, extra_path: str) -> dict:
    environment = dict(os.environ)
    own_dir = trace_dir / Path(script).stem          # one directory per script, cleared before each run
    shutil.rmtree(own_dir, ignore_errors=True)
    environment["BLACKMOOR_EXEC_TRACE_DIR"] = str(own_dir)
    environment["PYTHONPATH"] = os.pathsep.join(
        [str(root / "outputs/blackmoor-decomp/scripts/exec_trace")] +
        ([os.environ["PYTHONPATH"]] if os.environ.get("PYTHONPATH") else []))
    if extra_path:
        environment["PATH"] = extra_path + os.pathsep + environment["PATH"]
    started = time.time()
    with tempfile.TemporaryDirectory(prefix="fl8-") as scratch:
        extras = [a.format(project=root / "outputs/blackmoor-decomp", exe=root / "work/original/GAME.EXE",
                           scratch=scratch) for a in ORACLE_ARGS.get(Path(script).name, [])]
        return _run(root, script, extras, environment, timeout, started)


def _run(root, script, extras, environment, timeout, started) -> dict:
    try:
        done = subprocess.run([sys.executable, str(root / script), *extras], cwd=root / "outputs/blackmoor-decomp",
                              env=environment, capture_output=True, text=True, timeout=timeout)
        status, tail = done.returncode, (done.stdout + done.stderr)[-400:]
    except subprocess.TimeoutExpired:
        status, tail = "timeout", ""
    return {"script": script, "exit": status, "seconds": round(time.time() - started, 1),
            "tail": tail.strip().splitlines()[-1][:200] if tail.strip() else ""}


def command_run(args) -> int:
    root = Path(args.root).resolve()
    trace_dir = Path(args.trace_dir).resolve()
    trace_dir.mkdir(parents=True, exist_ok=True)
    scripts = [s for s in discover(root) if not args.only or any(o in s for o in args.only)]
    previous = {}
    runs_file = trace_dir / "runs.json"
    if runs_file.exists() and args.only:       # a partial rerun keeps the earlier rows of the other scripts
        previous = {r["script"]: r for r in json.loads(runs_file.read_text())}
    runs = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futures = [pool.submit(run_one, root, trace_dir, s, args.timeout, args.extra_path) for s in scripts]
        for future in futures:
            row = future.result()
            runs.append(row)
            print(f"{row['exit']!s:>8} {row['seconds']:>7}s {row['script']}", flush=True)
    merged = {**previous, **{r["script"]: r for r in runs}}
    runs_file.write_text(json.dumps(sorted(merged.values(), key=lambda r: r["script"]), indent=1) + "\n")
    return 0


def load_traces(trace_dir: Path):
    """Return {key: {address: [size, hits]}} and the per-key outcomes."""
    merged: dict[str, dict[int, list[int]]] = {}
    outcomes: dict[str, str] = {}
    for path in sorted(trace_dir.glob("**/*-*.json")):
        payload = json.loads(path.read_text())
        outcomes.update(payload.get("outcomes", {}))
        for key, rows in payload["traces"].items():
            table = merged.setdefault(key, {})
            for address, size, hits in rows:
                cell = table.setdefault(address, [size, 0])
                cell[1] += hits
    return merged, outcomes


def canonical_key(key: str) -> str:
    """Spell an absolute trace key with its directory symlinks resolved (the file name is kept).

    The recorder keys a run by os.path.abspath(sys.argv[0]), which keeps symlinks (macOS temporary
    directories live under the symlink /var -> /private/var, and the worktrees reach work/ through
    one), while derive() matches keys against a resolved workspace root.  Keys that are not absolute
    (unittest ids, labels) are returned unchanged and so never match the workspace prefix."""
    if not os.path.isabs(key):
        return key
    head, tail = os.path.split(key)
    return os.path.join(os.path.realpath(head), tail)


def merge_spellings(merged: dict) -> dict:
    """Merge the tables of keys that name the same script through different spellings (sizes from
    either, hits summed), so one script stays one run."""
    result: dict[str, dict[int, list[int]]] = {}
    for key, table in merged.items():
        target = result.setdefault(canonical_key(key), {})
        for address, (size, hits) in table.items():
            cell = target.setdefault(address, [size, 0])
            cell[1] += hits
    return result


def canonical_trace_hash(table: dict[int, list[int]]) -> str:
    digest = hashlib.sha256()
    for address in sorted(table):
        size, hits = table[address]
        digest.update(f"{address:x}:{size}:{hits}\n".encode())
    return digest.hexdigest()


def load_function_table():
    """(starts, rows): sorted function starts and their xrefs entry rows."""
    xrefs = json.loads(XREFS.read_text())
    rows = {int(e["va"], 16): e for e in xrefs["entries"]}
    return sorted(rows), rows


def derive(trace_dir: Path, root: Path) -> dict:
    import bisect

    starts, rows = load_function_table()
    runs_file = trace_dir / "runs.json"
    runs_table = {r["script"]: r for r in json.loads(runs_file.read_text())} if runs_file.exists() else {}
    merged, _ = load_traces(trace_dir)
    merged = merge_spellings(merged)
    prefix = str(root.resolve()) + os.sep
    runs, per_function = [], {}
    for key in sorted(merged):
        if not key.startswith(prefix):
            continue
        rel = key[len(prefix):]
        if any(word in Path(rel).name for word in EXCLUDED):
            continue
        row = runs_table.get(rel)
        if row is None or row["exit"] != 0:
            continue  # only a run that exited cleanly is evidence
        script = root / rel
        table = merged[key]
        run_index = len(runs)
        counted = 0
        for address, (size, hits) in table.items():
            if not TEXT_BEGIN <= address < TEXT_END:
                continue
            slot = bisect.bisect_right(starts, address) - 1
            if slot < 0:
                continue
            start = starts[slot]
            code_size = rows[start].get("code_size")
            if code_size is not None and address >= start + code_size:
                continue                    # a thunk, EH stub or unlisted chunk inside the span, not function code
            cell = per_function.setdefault(start, {}).setdefault(run_index, [0, 0, 0])
            if address == start:
                cell[0] += hits
            cell[1] += size
            cell[2] += hits
            counted += hits
        runs.append({"script": rel, "script_sha256": sha256_file(script), "exit": 0,
                     "instructions": len(table), "hits": counted, "trace_sha256": canonical_trace_hash(table)})
    functions = {}
    for start in sorted(per_function):
        entry = rows[start]
        code = entry.get("code_size")
        cells = []
        for run_index in sorted(per_function[start]):
            entry_hits, executed_bytes, hits = per_function[start][run_index]
            cells.append([run_index, entry_hits, min(executed_bytes, entry["span"]), hits])
        functions[f"0x{start:06x}"] = [code, *cells]
    return {
        "schema": SCHEMA,
        "original_sha256": json.loads(XREFS.read_text())["original_sha256"],
        "inputs": {"function_xrefs_sha256": sha256_file(XREFS)},
        "method": ("Unicorn UC_HOOK_CODE after the oracle's own hooks; an instruction counts only when EIP still "
                   "equals its address (instructions replaced by a Python seam are not recorded); a run counts "
                   "only if its script exited 0; a function row is [code_size, [run, entry_hits, executed_bytes, "
                   "hits], ...] where executed_bytes sums the distinct executed instruction sizes"),
        "runs": runs,
        "functions": functions,
        "counts": {"runs": len(runs), "functions_executed": len(functions),
                   "functions_entered": sum(1 for rec in functions.values() if any(c[1] for c in rec[1:]))},
    }


def render(model: dict) -> str:
    lines = ["{"]
    keys = ["schema", "original_sha256", "inputs", "method", "counts"]
    for key in keys:
        lines.append(f"{json.dumps(key)}: {json.dumps(model[key], sort_keys=True)},")
    lines.append('"runs": [')
    lines.append(",\n".join(json.dumps(r, sort_keys=True) for r in model["runs"]))
    lines.append('],')
    lines.append('"functions": {')
    lines.append(",\n".join(f"{json.dumps(k)}: {json.dumps(v)}" for k, v in model["functions"].items()))
    lines.append("}")
    lines.append("}")
    return "\n".join(lines) + "\n"


def merge_runs(existing: dict, fresh: dict) -> dict:
    """Add the runs of ``fresh`` to ``existing`` (the committed file).  A script already recorded with the same
    script hash keeps its committed row; a script recorded with another hash is replaced.  Used when the traces
    of the earlier runs are not at hand (another machine recorded them), so a partial trace directory extends
    function-execution.json instead of replacing it."""
    held = {r["script"]: r for r in existing["runs"]}
    drop = {i for i, r in enumerate(existing["runs"])
            if r["script"] in {f["script"] for f in fresh["runs"] if f["script_sha256"] != r["script_sha256"]}}
    keep = [i for i in range(len(existing["runs"])) if i not in drop]
    remap = {old: new for new, old in enumerate(keep)}
    runs = [existing["runs"][i] for i in keep]
    functions = {}
    for key, record in existing["functions"].items():
        cells = [[remap[c[0]], *c[1:]] for c in record[1:] if c[0] in remap]
        if cells:
            functions[key] = [record[0], *cells]
    added = {}
    for index, run in enumerate(fresh["runs"]):
        if run["script"] in held and held[run["script"]]["script_sha256"] == run["script_sha256"]:
            continue
        added[index] = len(runs)
        runs.append(run)
    for key, record in fresh["functions"].items():
        cells = [[added[c[0]], *c[1:]] for c in record[1:] if c[0] in added]
        if cells:
            functions.setdefault(key, [record[0]]).extend(cells)
    functions = {k: functions[k] for k in sorted(functions)}
    return {**existing, "runs": runs, "functions": functions,
            "counts": {"runs": len(runs), "functions_executed": len(functions),
                       "functions_entered": sum(1 for rec in functions.values() if any(c[1] for c in rec[1:]))}}


def command_collect(args) -> int:
    model = derive(Path(args.trace_dir).resolve(), Path(args.root).resolve())
    if args.merge:
        if not args.write:
            print("--merge needs --write", file=sys.stderr)
            return 2
        model = merge_runs(json.loads(OUTPUT.read_text()), model)
    text = render(model)
    if args.write:
        OUTPUT.write_text(text)
        print(f"wrote {OUTPUT.name}: {model['counts']}")
        return 0
    if not OUTPUT.exists() or OUTPUT.read_text() != text:
        print("function-execution.json differs from the private traces; rerun collect --write", file=sys.stderr)
        return 1
    print(f"function-execution.json matches the private traces: {model['counts']}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    run = sub.add_parser("run")
    run.add_argument("--root", default=str(WORKSPACE))
    run.add_argument("--trace-dir", default=str(DEFAULT_TRACE_DIR))
    run.add_argument("--only", action="append")
    run.add_argument("--jobs", type=int, default=4)
    run.add_argument("--timeout", type=int, default=900)
    run.add_argument("--extra-path", default="")
    run.set_defaults(func=command_run)
    for name in ("collect",):
        sp = sub.add_parser(name)
        sp.add_argument("--root", default=str(WORKSPACE))
        sp.add_argument("--trace-dir", default=str(DEFAULT_TRACE_DIR))
        sp.add_argument("--write", action="store_true")
        sp.add_argument("--merge", action="store_true",
                        help="extend the committed file with the runs in the trace directory (needs --write)")
        sp.set_defaults(func=command_collect)
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
