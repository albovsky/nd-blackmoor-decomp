"""Derive what each scripts/build_*.sh writes and reads (QA-1).

The build scripts are ordinary shell: `$project_dir`, `${VAR:-default}`,
`set --` argument rewriting, loops, arrays, functions, multi-line commands,
mode arguments and nested builder calls. Re-implementing that in a regex parser
would silently misread some of them, so the shell does the expansion: each
script is executed, unmodified apart from the `/usr/bin/<tool>` prefix being
dropped, in a throw-away copy of the project tree where the toolchain
(xcrun, clang, clang++, the pinned i686 assembler, python3, ditto, codesign, ...)
is replaced by shims that only record their argument vector (and create the
file named by `-o`, so globs and `-x` tests behave). Nothing is compiled, no
real build/ file is touched, and the scripts' own `rm -rf`, `mkdir` and
`mktemp` act on the sandbox.

The recorded command lines are then interpreted:

* clang driver: outputs (`-o`, or the implied object for `-c`), source files
  by extension, `.o` inputs resolved to the step that produced them, and the
  project headers reached through `#include`/`#import` (and `.include`)
  using the includer's directory plus `-iquote/-I/-isystem` directories;
* `ditto SRC DEST`: DEST is an artifact depending on whatever the sandbox
  produced under SRC;
* assembler, `python3`, `codesign`: assembler outputs as for the compiler;
  the others write nothing the freshness check follows (their invocations are
  kept in `ScriptResult.python_steps` for the report).

A script is *derivable* only if it ran to completion, every recorded command
was understood, every `.o` input has a producer, every quoted include was
found, and it wrote nothing the shims did not declare. Anything else is
reported in `ScriptResult.error`; callers must surface it.

Link-time library dependencies (`-lfoo` resolved through `-L`) are
deliberately not freshness inputs: builders such as build_live_audio.sh rebuild
their dependencies themselves, and build_all_native_checks.sh runs the
builders in alphabetical order, so a dependent library may legitimately be
older than a library another builder refreshed later.
"""

from __future__ import annotations

import os
import re
import shutil
import stat
import subprocess
import tempfile
from dataclasses import dataclass, field
from functools import lru_cache
from pathlib import Path
from typing import Dict, FrozenSet, Iterable, List, Optional, Sequence, Set, Tuple

SHIMMED_TOOLS = (
    "xcrun", "clang", "clang++", "cc", "c++", "gcc", "g++", "ld", "ar", "ranlib",
    "libtool", "lipo", "strip", "dsymutil", "install_name_tool", "python3", "python",
    "ditto", "codesign",
)
ASSEMBLER_RELATIVE = "work/tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
DRIVERS = {"clang", "clang++", "cc", "c++", "gcc", "g++"}
NO_OUTPUT_TOOLS = {"codesign", "dsymutil", "python3", "python", "strip", "install_name_tool"}
GAME_ARGUMENT = "work/original/GAME.EXE"

# build_all_native_checks.sh runs every builder without arguments (the four
# matching builders get GAME.EXE). Builders also have modes whose artifacts
# tests rebuild on demand; derive those too so their products are checked.
EXTRA_INVOCATIONS: Dict[str, List[List[str]]] = {
    "build_native_app.sh": [["--test-hooks"]],
    "build_live_audio.sh": [["lib"], ["sanitize"]],
    "build_session_conditions.sh": [["fixture"]],
    "build_action_family_35_runtime.sh": [["--test-driver"], ["--sanitize"]],
    "build_scene_executor.sh": [["--test-hooks"]],
    "build_scene_session.sh": [["--test-hooks"]],
}

SOURCE_SUFFIXES = {".c", ".cc", ".cpp", ".cxx", ".m", ".mm"}
ASM_SUFFIXES = {".s", ".S"}
OBJECT_SUFFIXES = {".o", ".obj"}
LIBRARY_SUFFIXES = {".a", ".dylib", ".tbd", ".framework"}
SEPARATE_ARGUMENT = {
    "-o", "-I", "-iquote", "-isystem", "-idirafter", "-include", "-imacros", "-L",
    "-F", "-arch", "-target", "-isysroot", "-framework", "-x", "-MF", "-MT", "-MQ",
    "-Xlinker", "-Xclang", "-Xpreprocessor", "-Xassembler", "-rpath", "-install_name",
    "-current_version", "-compatibility_version", "-D", "-U", "-l", "-mllvm",
    "-resource-dir", "-working-directory", "--sysroot", "-isysroot",
}
INCLUDE_RE = re.compile(r'^[ \t]*#[ \t]*(?:include|import)[ \t]*(?:"([^"\n]+)"|<([^>\n]+)>)', re.M)
ASM_INCLUDE_RE = re.compile(r'^[ \t]*\.(?:include|incbin)[ \t]+"([^"\n]+)"', re.M)


class Underivable(Exception):
    """A script (or one of its commands) cannot be turned into inputs/outputs."""


@dataclass(frozen=True)
class Artifact:
    path: Path
    script: Path
    inputs: FrozenSet[Path]
    kind: str = "file"  # "file" or "dir" (an .app bundle copied with ditto)
    # Produced only by a non-default mode (see EXTRA_INVOCATIONS) that the
    # canonical rebuild does not run and that the owning tests rebuild
    # themselves; reported but not enforced by stale_messages().
    on_demand: bool = False


@dataclass
class ScriptResult:
    name: str
    ok: bool = True
    error: str = ""
    artifacts: Tuple[Artifact, ...] = ()
    invocations: Tuple[Tuple[str, ...], ...] = ()
    python_steps: Tuple[Tuple[str, ...], ...] = ()


@dataclass
class BuildGraph:
    project: Path
    scripts: Dict[str, ScriptResult] = field(default_factory=dict)


# ---------------------------------------------------------------------------
# Sandbox


_SHIM = """#!/bin/sh
# Logging shim for {tool}. See build_graph.py.
tool="${{0##*/}}"
log="${{BM_LOGDIR:?}}"
n=$(cat "$log/.n" 2>/dev/null || echo 0)
n=$((n + 1))
echo "$n" > "$log/.n"
rec="$log/$(printf '%06d' "$n")"
printf '%s\\0' "$tool" "${{BM_SCRIPT_STACK##*:}}" "$PWD" "$@" > "$rec"
case "$tool" in
    ditto)
        for last; do :; done
        case "$last" in
            *.zip) mkdir -p "$(dirname "$last")"; : > "$last" ;;
            *) mkdir -p "$last" ;;
        esac ;;
    codesign|dsymutil|python3|python|strip|install_name_tool) : ;;
    *)
        prev=
        for a; do
            if [ "$prev" = "-o" ]; then
                mkdir -p "$(dirname "$a")" 2>/dev/null
                : > "$a"
            fi
            prev="$a"
        done ;;
esac
exit 0
"""

_WRAPPER = """#!/bin/sh
BM_SCRIPT_STACK="${{BM_SCRIPT_STACK:-}}:{name}"
export BM_SCRIPT_STACK
exec "$(dirname "$0")/{name}.orig" "$@"
"""


def _write_executable(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    path.chmod(0o755)


class _Sandbox:
    def __init__(self, project: Path) -> None:
        self.real_project = project
        self.root = Path(tempfile.mkdtemp(prefix="bm-build-graph-")).resolve()
        self.project = self.root / "outputs/blackmoor-decomp"
        self.logdir = self.root / "log"
        self.shims = self.root / "shims"
        self.cwd = self.root / "cwd"
        for directory in (self.project / "build", self.logdir, self.shims, self.cwd, self.root / "home"):
            directory.mkdir(parents=True, exist_ok=True)
        (self.root / "work/original").mkdir(parents=True)
        (self.root / GAME_ARGUMENT).write_bytes(b"")
        tool_pattern = "|".join(re.escape(tool) for tool in SHIMMED_TOOLS)
        prefix = re.compile(r"(?<![\w./-])/usr/bin/(?=(?:%s)\b)" % tool_pattern)
        for tool in SHIMMED_TOOLS:
            _write_executable(self.shims / tool, _SHIM.format(tool=tool))
        _write_executable(self.root / ASSEMBLER_RELATIVE, _SHIM.format(tool="i686-w64-mingw32-as"))
        for script in sorted((project / "scripts").glob("build_*.sh")):
            text = script.read_text(encoding="utf-8")
            _write_executable(self.project / "scripts" / (script.name + ".orig"), prefix.sub("", text))
            _write_executable(self.project / "scripts" / script.name, _WRAPPER.format(name=script.name))

    def cleanup(self) -> None:
        shutil.rmtree(self.root, ignore_errors=True)

    def environment(self) -> Dict[str, str]:
        return {
            "PATH": f"{self.shims}:/usr/bin:/bin:/usr/sbin:/sbin",
            "HOME": str(self.root / "home"),
            "LC_ALL": "C",
            "BM_LOGDIR": str(self.logdir),
        }

    def files(self) -> Set[Path]:
        found = set()
        for base, directories, names in os.walk(self.project):
            directories[:] = [d for d in directories if d != "scripts"]
            for name in names:
                found.add(Path(base) / name)
        return found

    def run(self, script: str, args: Sequence[str]) -> Tuple[int, str, List[List[str]], Set[Path]]:
        for record in self.logdir.iterdir():
            record.unlink()
        before = self.files()
        completed = subprocess.run(
            [str(self.project / "scripts" / script), *args],
            cwd=self.cwd, env=self.environment(), stdin=subprocess.DEVNULL,
            capture_output=True, text=True, errors="replace", timeout=120, check=False,
        )
        records = []
        for record in sorted(p for p in self.logdir.iterdir() if p.name != ".n"):
            fields = record.read_bytes().decode("utf-8", "surrogateescape").split("\0")
            records.append(fields[:-1])
        return completed.returncode, completed.stderr, records, self.files() - before

    def to_real(self, path: str) -> Path:
        normal = os.path.normpath(path)
        sandbox = str(self.project)
        if normal == sandbox:
            return self.real_project
        if normal.startswith(sandbox + os.sep):
            return self.real_project / normal[len(sandbox) + 1:]
        return Path(normal)


# ---------------------------------------------------------------------------
# Interpreting recorded commands


@dataclass
class _Step:
    script: str
    kind: str  # "compile", "assemble" or "ditto"
    outputs: List[Path]
    sources: List[Path] = field(default_factory=list)
    objects: List[Path] = field(default_factory=list)
    copied_from: Optional[Path] = None
    include_dirs: List[Path] = field(default_factory=list)
    quote_dirs: List[Path] = field(default_factory=list)
    forced: List[Path] = field(default_factory=list)
    on_demand: bool = False


def _absolute(sandbox: _Sandbox, cwd: str, value: str) -> Path:
    joined = value if os.path.isabs(value) else os.path.join(cwd, value)
    return sandbox.to_real(joined)


def _parse_driver(sandbox: _Sandbox, script: str, cwd: str, args: Sequence[str], assembler: bool) -> _Step:
    step = _Step(script=script, kind="assemble" if assembler else "compile", outputs=[])
    compile_only = False
    explicit_output = None
    positional: List[str] = []
    index = 0
    while index < len(args):
        arg = args[index]
        index += 1
        if arg.startswith("@"):
            raise Underivable(f"response file argument {arg} is not supported")
        value = None
        flag = None
        if arg in SEPARATE_ARGUMENT:
            if index >= len(args):
                raise Underivable(f"option {arg} has no argument")
            flag, value = arg, args[index]
            index += 1
        else:
            for prefix in ("-I", "-L", "-F", "-D", "-U", "-iquote", "-isystem", "-l"):
                if arg.startswith(prefix) and len(arg) > len(prefix):
                    flag, value = prefix, arg[len(prefix):]
                    break
        if flag is None:
            if arg == "-c":
                compile_only = True
            if arg.startswith("-") and arg != "-":
                continue
            positional.append(arg)
            continue
        if flag == "-o":
            explicit_output = value
        elif flag in ("-I", "-isystem", "-idirafter"):
            step.include_dirs.append(_absolute(sandbox, cwd, value))
        elif flag == "-iquote":
            step.quote_dirs.append(_absolute(sandbox, cwd, value))
        elif flag in ("-include", "-imacros"):
            step.forced.append(_absolute(sandbox, cwd, value))
    for item in positional:
        suffix = Path(item).suffix
        path = _absolute(sandbox, cwd, item)
        if suffix in SOURCE_SUFFIXES or suffix in ASM_SUFFIXES:
            step.sources.append(path)
        elif suffix in OBJECT_SUFFIXES:
            step.objects.append(path)
        elif suffix in LIBRARY_SUFFIXES:
            continue  # link-time library; see the module docstring
        else:
            raise Underivable(f"unrecognised input {item!r} on a compiler command line")
    if explicit_output is not None:
        step.outputs.append(_absolute(sandbox, cwd, explicit_output))
    elif compile_only or assembler:
        for source in step.sources:
            step.outputs.append(_absolute(sandbox, cwd, source.stem + ".o"))
    else:
        step.outputs.append(_absolute(sandbox, cwd, "a.out"))
    if not (step.sources or step.objects):
        raise Underivable("compiler command line has no input files")
    return step


def _parse_record(sandbox: _Sandbox, fields: List[str]) -> Optional[Tuple[_Step, str]]:
    tool, script, cwd, *args = fields
    if tool == "xcrun":
        index = 0
        while index < len(args) and args[index].startswith("-"):
            index += 2 if args[index] in ("-sdk", "--sdk", "--toolchain", "-toolchain") else 1
        if index >= len(args):
            raise Underivable("xcrun without a tool")
        tool, args = args[index], args[index + 1:]
        if tool not in DRIVERS:
            raise Underivable(f"tool {tool!r} run through xcrun is not modelled")
    if tool in DRIVERS:
        return _parse_driver(sandbox, script, cwd, args, assembler=False), tool
    if tool == "i686-w64-mingw32-as":
        return _parse_driver(sandbox, script, cwd, args, assembler=True), tool
    if tool == "ditto":
        names = [a for a in args if not a.startswith("-")]
        if len(names) != 2:
            raise Underivable(f"ditto with unexpected operands {names}")
        step = _Step(script=script, kind="ditto", outputs=[_absolute(sandbox, cwd, names[1])])
        step.copied_from = _absolute(sandbox, cwd, names[0])
        return step, tool
    if tool in NO_OUTPUT_TOOLS:
        return None
    raise Underivable(f"tool {tool!r} is not modelled")


class _Includes:
    def __init__(self, project: Path) -> None:
        self.project = project
        self.cache: Dict[Path, Tuple[Tuple[str, bool], ...]] = {}

    def scan(self, path: Path) -> Tuple[Tuple[str, bool], ...]:
        """(name, quoted) include directives found in a file."""
        if path not in self.cache:
            try:
                text = path.read_text(encoding="utf-8", errors="replace")
            except OSError as error:
                raise Underivable(f"cannot read {path}: {error}")
            found = []
            if path.suffix in ASM_SUFFIXES:
                found = [(m.group(1), True) for m in ASM_INCLUDE_RE.finditer(text)]
            else:
                for match in INCLUDE_RE.finditer(text):
                    found.append((match.group(1) or match.group(2), match.group(1) is not None))
            self.cache[path] = tuple(found)
        return self.cache[path]

    def closure(self, roots: Iterable[Path], step: _Step) -> Set[Path]:
        inside = lambda p: p == self.project or self.project in p.parents
        seen: Set[Path] = set()
        pending = [p for p in roots]
        missing: List[str] = []
        while pending:
            current = pending.pop()
            if current in seen:
                continue
            if not current.is_file():
                raise Underivable(f"input {current} does not exist")
            seen.add(current)
            for name, quoted in self.scan(current):
                search = list(step.include_dirs)
                if quoted:
                    search = [current.parent, *step.quote_dirs, *search]
                found = next((d / name for d in search if (d / name).is_file()), None)
                if found is None:
                    if quoted:
                        missing.append(f"{current.name}: #include \"{name}\"")
                    continue  # unresolved <system> headers are outside the project
                found = Path(os.path.normpath(found))
                if inside(found):
                    pending.append(found)
        if missing:
            raise Underivable("unresolved quoted include(s): " + "; ".join(sorted(set(missing))))
        return {p for p in seen if inside(p)}


def _derive_script(sandbox: _Sandbox, includes: _Includes, project: Path, name: str,
                   argument_sets: Sequence[Sequence[str]]) -> ScriptResult:
    result = ScriptResult(name=name)
    produced: Dict[Path, _Step] = {}
    steps: List[_Step] = []
    python_steps: List[Tuple[str, ...]] = []
    invocations: List[Tuple[str, ...]] = []
    try:
        for position, args in enumerate(argument_sets):
            returncode, stderr, records, new_files = sandbox.run(name, args)
            if returncode == 2 and "GAME.EXE" in stderr and not args:
                args = [str(sandbox.root / GAME_ARGUMENT)]
                returncode, stderr, records, new_files = sandbox.run(name, args)
            invocations.append(tuple(args))
            if returncode != 0:
                tail = " ".join(stderr.strip().splitlines()[-3:])[:300]
                raise Underivable(f"sandboxed run with {list(args)} exited {returncode}: {tail}")
            declared: Set[Path] = set()
            for fields in records:
                parsed = _parse_record(sandbox, fields)
                if fields[0] in ("python3", "python"):
                    python_steps.append(tuple(fields[3:]))
                if parsed is None:
                    continue
                step, _tool = parsed
                step.on_demand = position > 0
                steps.append(step)
                for output in step.outputs:
                    produced[output] = step
                    declared.add(sandbox.project / output.relative_to(project)
                                 if project in output.parents else output)
            unmodelled = sorted(p for p in new_files if p not in declared)
            if unmodelled:
                shown = ", ".join(str(p.relative_to(sandbox.project)) for p in unmodelled[:5])
                raise Underivable(f"wrote file(s) the toolchain shims did not declare: {shown}")
        memo: Dict[int, Set[Path]] = {}

        def dependencies(step: _Step) -> Set[Path]:
            if id(step) in memo:
                return memo[id(step)]
            memo[id(step)] = set()  # guards against cycles
            found = includes.closure([*step.sources, *step.forced], step)
            for obj in step.objects:
                if obj not in produced:
                    raise Underivable(f"object input {obj} was not produced by the script")
                found |= dependencies(produced[obj])
            if step.copied_from is not None:
                under = [s for out, s in produced.items()
                         if out == step.copied_from or step.copied_from in out.parents]
                if not under:
                    raise Underivable(f"ditto source {step.copied_from} was not produced by the script")
                for other in under:
                    if other is not step:
                        found |= dependencies(other)
            memo[id(step)] = found
            return found

        merged: Dict[Tuple[Path, str], Set[Path]] = {}
        kinds: Dict[Tuple[Path, str], str] = {}
        default_built: Set[Tuple[Path, str]] = set()
        for step in steps:
            for output in step.outputs:
                if project not in output.parents:
                    continue
                relative = output.relative_to(project)
                if relative.parts[0] in ("src", "tests", "scripts"):
                    continue
                key = (output, step.script)
                merged.setdefault(key, set()).update(dependencies(step))
                if not step.on_demand:
                    default_built.add(key)
                if step.kind == "ditto" and output.suffix != ".zip":
                    kinds[key] = "dir"
        result.artifacts = tuple(
            Artifact(path=path, script=project / "scripts" / script, inputs=frozenset(inputs),
                     kind=kinds.get((path, script), "file"),
                     on_demand=(path, script) not in default_built)
            for (path, script), inputs in sorted(merged.items(), key=lambda kv: (str(kv[0][0]), kv[0][1]))
        )
    except Underivable as error:
        result.ok = False
        result.error = str(error)
    except subprocess.TimeoutExpired:
        result.ok = False
        result.error = "sandboxed run timed out after 120 s"
    result.invocations = tuple(invocations)
    result.python_steps = tuple(python_steps)
    return result


def derive_graph(project: Path, variants: Optional[Dict[str, List[List[str]]]] = None) -> BuildGraph:
    """Derive artifacts and inputs for every scripts/build_*.sh under `project`."""
    project = Path(project).resolve()
    graph = BuildGraph(project=project)
    sandbox = _Sandbox(project)
    try:
        includes = _Includes(project)
        for script in sorted((project / "scripts").glob("build_*.sh")):
            argument_sets: List[List[str]] = [[], *(variants or {}).get(script.name, [])]
            graph.scripts[script.name] = _derive_script(sandbox, includes, project, script.name, argument_sets)
    finally:
        sandbox.cleanup()
    return graph


@lru_cache(maxsize=None)
def project_graph(project: Path) -> BuildGraph:
    """The real project's graph, including the documented extra invocations."""
    return derive_graph(project, EXTRA_INVOCATIONS)


# ---------------------------------------------------------------------------
# Staleness


def _relative(project: Path, path: Path) -> str:
    try:
        return str(path.relative_to(project))
    except ValueError:
        return str(path)


def stale_messages(graph: BuildGraph, include_on_demand: bool = False) -> List[str]:
    """One message per existing artifact older than an input or its script.

    On-demand artifacts (non-default builder modes) are skipped unless asked
    for: tests such as test_native_app rebuild them before use, and they are
    not part of the canonical rebuild, so a stale one is not actionable here.
    """
    messages = []
    seen: Set[Tuple[Path, Path]] = set()
    for result in graph.scripts.values():
        for artifact in result.artifacts:
            if (artifact.path, artifact.script) in seen or not artifact.path.exists():
                continue
            if artifact.on_demand and not include_on_demand:
                continue
            seen.add((artifact.path, artifact.script))
            built = artifact.path.stat().st_mtime_ns
            candidates = []
            for path in (*sorted(artifact.inputs), artifact.script):
                try:
                    candidates.append((path.stat().st_mtime_ns, path))
                except OSError:
                    continue  # a deleted input cannot be newer than the artifact
            if not candidates:
                continue
            newest_time, newest = max(candidates, key=lambda item: (item[0], str(item[1])))
            if built >= newest_time:
                continue
            what = "the build script" if newest == artifact.script else "its input"
            messages.append(
                f"{_relative(graph.project, artifact.path)}: STALE BUILD ARTIFACT, older than {what} "
                f"{_relative(graph.project, newest)} by {(newest_time - built) / 1e9:.1f} s; "
                f"rerun {_relative(graph.project, artifact.script)} "
                "(or script/run_test_suite.sh, which rebuilds everything first)"
            )
    return sorted(messages)


def main(argv: Sequence[str]) -> int:
    """Print a bounded summary of the derived graph (developer aid)."""
    project = Path(argv[1] if len(argv) > 1 else Path(__file__).resolve().parents[1]).resolve()
    graph = derive_graph(project, EXTRA_INVOCATIONS)
    problems = 0
    for name, result in graph.scripts.items():
        if not result.ok:
            problems += 1
            print(f"UNDERIVABLE {name}: {result.error}")
        elif not result.artifacts:
            print(f"NO-ARTIFACT  {name}  python_steps={len(result.python_steps)}")
        else:
            enforced = [a for a in result.artifacts if not a.on_demand]
            print(f"ok {name}: {len(enforced)} enforced, "
                  f"{len(result.artifacts) - len(enforced)} on-demand artifact(s); e.g. "
                  + ", ".join(f"{_relative(project, a.path)}({len(a.inputs)})" for a in enforced[:2]))
    print(f"{len(graph.scripts)} scripts, {problems} underivable")
    stale = stale_messages(graph)
    for message in stale:
        print(message)
    return 1 if problems or stale else 0


if __name__ == "__main__":
    import sys

    raise SystemExit(main(sys.argv))
