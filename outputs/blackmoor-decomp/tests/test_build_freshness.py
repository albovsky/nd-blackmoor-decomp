"""QA-1: detect stale ignored build artifacts before they masquerade as test failures.

build/ is ignored, so a checkout that pulled new sources keeps old libraries
until somebody reruns the builders; the tests then fail against the old binary
with no hint why. For every scripts/build_*.sh this module derives the
artifacts the script writes and the sources/headers it compiles (see
build_graph.py: the script is executed in a sandbox with logging shims in place
of the toolchain, so shell variables, loops, functions and multi-line commands
are expanded by the shell itself), and fails per artifact when an existing
artifact is older than one of its inputs or than the script itself.

Missing artifacts are not this test's concern; the owning tests skip.
"""

from __future__ import annotations

import fnmatch
import os
import stat
import tempfile
import textwrap
import unittest
from pathlib import Path

import build_graph as bg

PROJECT = Path(__file__).resolve().parents[1]

# Scripts whose artifacts the freshness check cannot follow. Every entry needs
# a reason; a script that derives nothing and is not listed here is a failure,
# never a silent pass.
NO_ARTIFACT_ALLOWLIST = {
    "build_matching_s08_2.sh":
        "the script only runs scripts/audit_matching_s08_2.py, which itself compiles "
        "13 objects into build/matching_s08_2/*.obj; those python-written outputs are "
        "not derivable from the shell (see KNOWN_UNTRACKED_OUTPUTS)",
}

# Files under build/ that no build_*.sh derivation accounts for. Patterns are
# fnmatch patterns relative to build/. test_no_unaccounted_build_outputs fails
# on any other file, so a new unknown output cannot go unnoticed.
KNOWN_UNTRACKED_OUTPUTS = {
    "matching_s08_2/*.obj":
        "13 compiler-variant objects compiled by scripts/audit_matching_s08_2.py (run by build_matching_s08_2.sh)",
    "matching_s08_3_x86-report.json":
        "report written by scripts/audit_matching_s08_3_x86.py (python3 step of build_matching_s08_3_x86.sh)",
    "matching_s08_4_x86-report.json":
        "report written by scripts/audit_matching_s08_4_x86.py (python3 step of build_matching_s08_4_x86.sh)",
    "matching_s08_3_x86-oracle.json":
        "report written by tests/test_matching_s08_3_x86.py through the original-x86 oracle",
    "matching_s08_4_x86-oracle.json":
        "report written by tests/test_matching_s08_4_x86.py through the original-x86 oracle",
    "input_consume_original_oracle.json":
        "report written by tests/test_input_consume.py through the original-x86 oracle",
    "libactionfamily28_x87_division_fixture.dylib":
        "compiled directly by tests/test_action_family_28_sequence.py, no build script",
    "live_audio_movie_test":
        "compiled directly by tests/test_session_bindings_a35_bink.py, no build script",
    "action_family_79_runtime_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_79_runtime_sanitizers.sh:12 "
        "(a sanitizer test script, not a build_*.sh), invoked from tests/test_action_family_79_runtime_oracle.py:52",
    "action_family_79_runtime_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_79_runtime_sanitize",
    "action_family_79_binding_stub_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_79_runtime_sanitizers.sh:22 "
        "(stub-scene variant), invoked from tests/test_action_family_79_runtime_oracle.py:52",
    "action_family_79_binding_stub_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_79_binding_stub_sanitize",
    "session_bindings_a0b_stub_scene_plain":
        "stub-scene check binary compiled directly by tests/test_action_family_0b_runtime.py:646 "
        "(StubSceneTests), no build script",
    "session_bindings_a0b_stub_scene_plain.dSYM/*":
        "debug-symbol bundle of session_bindings_a0b_stub_scene_plain",
    "live_audio_movie_test.dSYM/*":
        "debug-symbol bundle of live_audio_movie_test (clang -g link)",
    "libactionfamily28_x87_division_fixture.dylib.dSYM/*":
        "debug-symbol bundle of the directly compiled division fixture",
    "action_family_0c_runtime_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_0c_runtime_sanitizers.sh:12 "
        "(a sanitizer test script, not a build_*.sh), invoked from tests/test_action_family_0c_runtime_oracle.py:58",
    "action_family_0c_runtime_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_0c_runtime_sanitize",
    "session_bindings_a0c_stub_scene":
        "ASan/UBSan stub-scene binary compiled and run by scripts/test_action_family_0c_runtime_sanitizers.sh:20, "
        "invoked from tests/test_action_family_0c_runtime_oracle.py:58",
    "session_bindings_a0c_stub_scene.dSYM/*":
        "debug-symbol bundle of session_bindings_a0c_stub_scene",
    "session_bindings_a0c_stub_scene_plain":
        "stub-scene check binary compiled directly by tests/test_action_family_0c_runtime.py:794 "
        "(output path at :789; StubSceneTests), no build script",
    "session_bindings_a0c_stub_scene_plain.dSYM/*":
        "debug-symbol bundle of session_bindings_a0c_stub_scene_plain",
    "action_family_37_runtime_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_37_runtime_sanitizers.sh:14 "
        "(a sanitizer test script, not a build_*.sh), invoked from tests/test_action_family_37_runtime.py:415-416",
    "action_family_37_runtime_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_37_runtime_sanitize",
    "action_family_78_runtime_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_78_runtime_sanitizers.sh:12 "
        "(a sanitizer test script, not a build_*.sh), invoked from tests/test_action_family_78_runtime_oracle.py:66",
    "action_family_78_runtime_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_78_runtime_sanitize",
    "action_family_78_binding_stub_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_78_runtime_sanitizers.sh:22 "
        "(stub-scene variant), invoked from tests/test_action_family_78_runtime_oracle.py:66",
    "action_family_78_binding_stub_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_78_binding_stub_sanitize",
    "action_family_a1_runtime_sanitize":
        "ASan/UBSan binary compiled and run by scripts/test_action_family_a1_runtime_sanitizers.sh:14 "
        "(a sanitizer test script, not a build_*.sh), invoked from tests/test_action_family_a1_runtime_oracle.py:60",
    "action_family_a1_runtime_sanitize.dSYM/*":
        "debug-symbol bundle of action_family_a1_runtime_sanitize",
    "image/GAME.composed.exe":
        "image composed by scripts/compose_image.py:1521 (DEFAULT_BUILD_DIR = build/image, set at :60) "
        "when run by hand; no build_*.sh writes it and test_compose_image.py composes into a temporary directory",
    "image/coverage-report.json":
        "composer coverage report written by scripts/compose_image.py:1522 and, with its own build dir, "
        "scripts/report_image_coverage.py:125; run by hand, not by a build script or the suite",
    "image/coverage-report.md":
        "markdown form of the coverage report, written by scripts/compose_image.py:1523 and "
        "scripts/report_image_coverage.py:126; run by hand",
    "image/stage-report.json":
        "per-stage report written by `scripts/compose_image.py stages` at :1563; run by hand",
    "image/objects/*.obj":
        "matching objects staged by scripts/compose_image.py:561 into build/image/objects, a directory the "
        "composer owns; the set grows with every matching slice bound into the image, so it is a pattern",
    "image/objects/*.manifest.json":
        "match manifests staged by scripts/compose_image.py:615 into build/image/objects (composer-owned "
        "directory; one per bound matching slice, so the set grows), hence a pattern",
}


def write_script(directory: Path, name: str, body: str) -> Path:
    path = directory / "scripts" / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(body, encoding="utf-8")
    path.chmod(path.stat().st_mode | stat.S_IXUSR)
    return path


def write_source(directory: Path, relative: str, text: str = "int x;\n") -> Path:
    path = directory / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    return path


class BuildGraphDerivationTests(unittest.TestCase):
    """The derivation machinery, on synthetic projects."""

    def setUp(self) -> None:
        self._temp = tempfile.TemporaryDirectory(prefix="build-freshness-")
        self.addCleanup(self._temp.cleanup)
        self.project = Path(self._temp.name).resolve() / "outputs/blackmoor-decomp"
        self.project.mkdir(parents=True)

    def derive(self, **kwargs):
        return bg.derive_graph(self.project, **kwargs)

    def test_shell_variables_and_multiline_commands_are_expanded(self) -> None:
        write_source(self.project, "src/a.c", '#include "a.h"\n')
        write_source(self.project, "src/a.h", '#include "b.h"\n')
        write_source(self.project, "src/b.h")
        write_script(self.project, "build_a.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            source_dir="$project_dir/src"
            build_dir="${BUILD_DIR:-$project_dir/build}"
            mkdir -p "$build_dir"
            xcrun --sdk macosx clang -arch arm64 -std=c11 \\
                -Wall -Werror -O2 -fPIC -dynamiclib \\
                -I"$source_dir" \\
                "$source_dir/a.c" \\
                -o "$build_dir/liba.dylib"
            printf 'done\\n'
            """))
        graph = self.derive()
        result = graph.scripts["build_a.sh"]
        self.assertTrue(result.ok, result.error)
        (artifact,) = result.artifacts
        self.assertEqual(artifact.path, self.project / "build/liba.dylib")
        self.assertEqual(
            artifact.inputs,
            {self.project / "src/a.c", self.project / "src/a.h", self.project / "src/b.h"},
        )

    def test_loop_compiled_objects_objective_cpp_and_link_step(self) -> None:
        for name in ("m1", "m2"):
            write_source(self.project, f"src/{name}.c", f'#include "{name}.h"\n')
            write_source(self.project, f"src/{name}.h")
        write_source(self.project, "src/shell.mm", '#import "m1.h"\n')
        write_script(self.project, "build_app.sh", textwrap.dedent("""\
            #!/bin/bash
            set -euo pipefail
            project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
            build_dir="$project_dir/build/app"
            mkdir -p "$build_dir"
            objects=()
            for module in m1 m2; do
                object="$build_dir/$module.o"
                xcrun --sdk macosx clang -arch arm64 -std=c11 -c \\
                    "$project_dir/src/$module.c" -o "$object"
                objects+=("$object")
            done
            xcrun --sdk macosx clang++ -arch arm64 -std=c++17 -fobjc-arc \\
                "$project_dir/src/shell.mm" "${objects[@]}" -framework AppKit \\
                -o "$build_dir/app"
            """))
        result = self.derive().scripts["build_app.sh"]
        self.assertTrue(result.ok, result.error)
        by_name = {a.path.name: a for a in result.artifacts}
        self.assertEqual(set(by_name), {"m1.o", "m2.o", "app"})
        self.assertEqual(
            by_name["app"].inputs,
            {self.project / "src" / n for n in
             ("shell.mm", "m1.c", "m1.h", "m2.c", "m2.h")},
        )
        self.assertEqual(by_name["m2.o"].inputs,
                         {self.project / "src/m2.c", self.project / "src/m2.h"})

    def test_env_overrides_are_ignored_and_headers_follow_dash_i(self) -> None:
        write_source(self.project, "src/a.c", '#include <extra/x.h>\n#include "local.h"\n')
        write_source(self.project, "src/extra/x.h")
        write_source(self.project, "src/local.h")
        write_source(self.project, "src/unused.h")
        write_script(self.project, "build_env.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            output="${ENV_OUTPUT:-$project_dir/build/libenv.dylib}"
            source_dir="${ENV_SRC:-$project_dir/src}"
            mkdir -p "$(dirname "$output")"
            xcrun --sdk macosx clang -arch arm64 ${ENV_CFLAGS:-} -I "$source_dir" \\
                -I "$source_dir/extra" "$source_dir/a.c" -o "$output"
            """))
        old = os.environ.get("ENV_OUTPUT")
        os.environ["ENV_OUTPUT"] = "/nonexistent/elsewhere.dylib"
        self.addCleanup(lambda: os.environ.pop("ENV_OUTPUT", None) if old is None
                        else os.environ.__setitem__("ENV_OUTPUT", old))
        result = self.derive().scripts["build_env.sh"]
        self.assertTrue(result.ok, result.error)
        (artifact,) = result.artifacts
        self.assertEqual(artifact.path, self.project / "build/libenv.dylib")
        self.assertEqual(
            artifact.inputs,
            {self.project / "src/a.c", self.project / "src/extra/x.h", self.project / "src/local.h"},
        )

    def test_assembler_and_game_argument_scripts(self) -> None:
        write_source(self.project, "src/f.s", ".text\n")
        write_script(self.project, "build_asm.sh", textwrap.dedent("""\
            #!/bin/bash
            set -euo pipefail
            if [[ $# -ne 1 ]]; then echo 'Usage: build_asm.sh GAME.EXE' >&2; exit 2; fi
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            repo_dir="$(cd "$project_dir/../.." && pwd)"
            assembler="$repo_dir/work/tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
            if [[ ! -x "$assembler" ]]; then echo missing >&2; exit 1; fi
            mkdir -p "$project_dir/build"
            "$assembler" --32 -o "$project_dir/build/f.obj" "$project_dir/src/f.s"
            python3 "$project_dir/scripts/audit.py" --original "$1" --object "$project_dir/build/f.obj"
            """))
        result = self.derive().scripts["build_asm.sh"]
        self.assertTrue(result.ok, result.error)
        (artifact,) = result.artifacts
        self.assertEqual(artifact.path, self.project / "build/f.obj")
        self.assertEqual(artifact.inputs, {self.project / "src/f.s"})

    def test_extra_invocations_are_derived(self) -> None:
        write_source(self.project, "src/a.c")
        write_source(self.project, "tests/fixture.c")
        write_script(self.project, "build_mode.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            case "${1:-lib}" in
                lib) xcrun clang -dynamiclib "$project_dir/src/a.c" -o "$project_dir/build/liba.dylib" ;;
                fixture) xcrun clang "$project_dir/tests/fixture.c" -o "$project_dir/build/fixture" ;;
                *) echo usage >&2; exit 2 ;;
            esac
            """))
        plain = self.derive().scripts["build_mode.sh"]
        self.assertEqual({a.path.name for a in plain.artifacts}, {"liba.dylib"})
        extra = self.derive(variants={"build_mode.sh": [["fixture"]]}).scripts["build_mode.sh"]
        self.assertTrue(extra.ok, extra.error)
        self.assertEqual({a.path.name for a in extra.artifacts}, {"liba.dylib", "fixture"})
        self.assertEqual({a.path.name: a.on_demand for a in extra.artifacts},
                         {"liba.dylib": False, "fixture": True})

    def test_extra_mode_that_links_a_glob_of_objects_in_a_subdirectory_is_derived(self) -> None:
        # The shape of build_live_audio_restart.sh sanitize: objects in build/<dir>/, linked as "$dir"/*.o.
        write_source(self.project, "src/a.c", '#include "a.h"\n')
        write_source(self.project, "src/a.h")
        write_source(self.project, "src/b.c")
        write_script(self.project, "build_glob.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            case "${1:-lib}" in
                lib) xcrun clang -dynamiclib "$project_dir/src/a.c" -o "$project_dir/build/liba.dylib" ;;
                sanitize)
                    dir="$project_dir/build/sub"
                    mkdir -p "$dir"
                    xcrun clang -c "$project_dir/src/a.c" -I"$project_dir/src" -o "$dir/a.o"
                    xcrun clang -c "$project_dir/src/b.c" -o "$dir/b.o"
                    xcrun clang "$dir"/*.o -o "$dir/tool" ;;
                *) echo usage >&2; exit 2 ;;
            esac
            """))
        result = self.derive(variants={"build_glob.sh": [["sanitize"]]}).scripts["build_glob.sh"]
        self.assertTrue(result.ok, result.error)
        by_name = {a.path.relative_to(self.project / "build").as_posix(): a for a in result.artifacts}
        self.assertEqual(sorted(by_name), ["liba.dylib", "sub/a.o", "sub/b.o", "sub/tool"])
        self.assertTrue(all(by_name[name].on_demand for name in ("sub/a.o", "sub/b.o", "sub/tool")))
        self.assertEqual(by_name["sub/tool"].inputs,
                         {self.project / "src/a.c", self.project / "src/a.h", self.project / "src/b.c"})

    def test_nested_script_artifacts_belong_to_the_inner_script(self) -> None:
        write_source(self.project, "src/inner.c")
        write_source(self.project, "src/outer.c")
        write_script(self.project, "build_inner.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang -dynamiclib "$project_dir/src/inner.c" -o "$project_dir/build/libinner.dylib"
            """))
        write_script(self.project, "build_outer.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            "$project_dir/scripts/build_inner.sh" >/dev/null
            xcrun clang -dynamiclib "$project_dir/src/outer.c" -L"$project_dir/build" -linner \\
                -o "$project_dir/build/libouter.dylib"
            """))
        graph = self.derive()
        owner = {a.path.name: a.script.name for r in graph.scripts.values() for a in r.artifacts}
        self.assertEqual(owner["libinner.dylib"], "build_inner.sh")
        self.assertEqual(owner["libouter.dylib"], "build_outer.sh")
        outer = {a.path.name: a for a in graph.scripts["build_outer.sh"].artifacts}["libouter.dylib"]
        self.assertEqual(outer.inputs, {self.project / "src/outer.c"})

    def test_bundle_copy_follows_the_staged_binary(self) -> None:
        write_source(self.project, "src/main.c")
        write_script(self.project, "build_bundle.sh", textwrap.dedent("""\
            #!/bin/bash
            set -euo pipefail
            project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
            stage="$(mktemp -d /private/tmp/freshness-stage.XXXXXX)"
            trap 'rm -rf "$stage"' EXIT
            mkdir -p "$stage/B.app/Contents/MacOS"
            xcrun clang "$project_dir/src/main.c" -o "$stage/B.app/Contents/MacOS/B"
            /usr/bin/codesign --force --sign - "$stage/B.app"
            rm -rf "$project_dir/B.app"
            /usr/bin/ditto --noextattr --norsrc "$stage/B.app" "$project_dir/B.app"
            /usr/bin/ditto -c -k --keepParent "$stage/B.app" "$project_dir/B.app.zip"
            """))
        result = self.derive().scripts["build_bundle.sh"]
        self.assertTrue(result.ok, result.error)
        by_name = {a.path.name: a for a in result.artifacts}
        self.assertEqual(set(by_name), {"B.app", "B.app.zip"})
        for artifact in by_name.values():
            self.assertEqual(artifact.inputs, {self.project / "src/main.c"})

    def test_underivable_scripts_are_reported_with_a_reason(self) -> None:
        write_source(self.project, "src/a.c", '#include "missing_header.h"\n')
        write_script(self.project, "build_fail.sh", "#!/bin/sh\nexit 7\n")
        write_script(self.project, "build_include.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang -dynamiclib "$project_dir/src/a.c" -o "$project_dir/build/libx.dylib"
            """))
        write_script(self.project, "build_unmodeled.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            cp /bin/ls "$project_dir/build/copied"
            """))
        write_script(self.project, "build_tool.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            xcrun lipo -create -output "$project_dir/build/fat" a b
            """))
        graph = self.derive()
        for name, fragment in (
            ("build_fail.sh", "exited 7"),
            ("build_include.sh", "missing_header.h"),
            ("build_unmodeled.sh", "copied"),
            ("build_tool.sh", "lipo"),
        ):
            with self.subTest(script=name):
                result = graph.scripts[name]
                self.assertFalse(result.ok)
                self.assertIn(fragment, result.error)

    def test_library_inputs_inside_the_project_are_not_dropped(self) -> None:
        write_source(self.project, "src/main.c")
        write_source(self.project, "vendor/libthing.a", "!<arch>\n")
        write_script(self.project, "build_lib.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang "$project_dir/src/main.c" "$project_dir/vendor/libthing.a" \\
                -o "$project_dir/build/tool"
            """))
        write_script(self.project, "build_syslib.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang "$project_dir/src/main.c" /usr/lib/libz.tbd -o "$project_dir/build/tool2"
            """))
        graph = self.derive()
        inside = graph.scripts["build_lib.sh"]
        self.assertFalse(inside.ok)
        self.assertIn("libthing.a", inside.error)
        outside = graph.scripts["build_syslib.sh"]
        self.assertTrue(outside.ok, outside.error)
        self.assertEqual({a.path.name for a in outside.artifacts}, {"tool2"})

    def test_a_script_with_no_artifacts_is_not_silently_ok(self) -> None:
        write_script(self.project, "build_nothing.sh", "#!/bin/sh\nexit 0\n")
        result = self.derive().scripts["build_nothing.sh"]
        self.assertTrue(result.ok)
        self.assertEqual(result.artifacts, ())


class StaleArtifactDetectionTests(unittest.TestCase):
    """stale_messages() on a synthetic graph with controlled mtimes."""

    def setUp(self) -> None:
        self._temp = tempfile.TemporaryDirectory(prefix="build-freshness-stale-")
        self.addCleanup(self._temp.cleanup)
        self.project = Path(self._temp.name).resolve() / "outputs/blackmoor-decomp"
        write_source(self.project, "src/a.c", '#include "a.h"\n')
        write_source(self.project, "src/a.h")
        self.script = write_script(self.project, "build_a.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang -dynamiclib "$project_dir/src/a.c" -o "$project_dir/build/liba.dylib"
            """))
        self.artifact = self.project / "build/liba.dylib"
        self.graph = bg.derive_graph(self.project)

    def stamp(self, path: Path, seconds: int) -> None:
        os.utime(path, ns=(seconds * 10**9, seconds * 10**9))

    def settle(self, artifact: int, source: int, header: int, script: int) -> None:
        self.artifact.parent.mkdir(exist_ok=True)
        self.artifact.write_bytes(b"x")
        self.stamp(self.artifact, artifact)
        self.stamp(self.project / "src/a.c", source)
        self.stamp(self.project / "src/a.h", header)
        self.stamp(self.script, script)

    def test_fresh_artifact_is_clean(self) -> None:
        self.settle(artifact=100, source=50, header=60, script=70)
        self.assertEqual(bg.stale_messages(self.graph), [])

    def test_missing_artifact_is_not_reported(self) -> None:
        self.assertFalse(self.artifact.exists())
        self.assertEqual(bg.stale_messages(self.graph), [])

    def test_older_than_a_source_is_reported_with_all_names(self) -> None:
        self.settle(artifact=100, source=200, header=60, script=70)
        (message,) = bg.stale_messages(self.graph)
        self.assertIn("build/liba.dylib", message)
        self.assertIn("src/a.c", message)
        self.assertIn("scripts/build_a.sh", message)
        self.assertIn("script/run_test_suite.sh", message)

    def test_older_than_a_header_is_reported_as_the_newest_input(self) -> None:
        self.settle(artifact=100, source=50, header=300, script=70)
        (message,) = bg.stale_messages(self.graph)
        self.assertIn("src/a.h", message)

    def test_older_than_the_build_script_is_reported(self) -> None:
        self.settle(artifact=100, source=50, header=60, script=400)
        (message,) = bg.stale_messages(self.graph)
        self.assertIn("older than the build script", message)

    def test_on_demand_artifacts_are_enforced_only_when_asked(self) -> None:
        graph = bg.derive_graph(self.project)
        for result in graph.scripts.values():
            result.artifacts = tuple(
                bg.Artifact(a.path, a.script, a.inputs, a.kind, on_demand=True)
                for a in result.artifacts)
        self.settle(artifact=100, source=200, header=60, script=70)
        self.assertEqual(bg.stale_messages(graph), [])
        self.assertEqual(len(bg.stale_messages(graph, include_on_demand=True)), 1)

    def test_bundle_is_judged_by_its_executable_not_the_directory(self) -> None:
        bundle = self.project / "B.app"
        executable = bundle / "Contents/MacOS/B"
        executable.parent.mkdir(parents=True)
        executable.write_bytes(b"x")
        graph = bg.BuildGraph(project=self.project, scripts={"build_a.sh": bg.ScriptResult(
            name="build_a.sh", artifacts=(bg.Artifact(
                bundle, self.script, frozenset({self.project / "src/a.c"}), kind="dir"),))})
        self.settle(artifact=100, source=150, header=60, script=70)
        # Directory stamped before the source (copy started early) but the
        # executable inside was produced after it: fresh.
        self.stamp(executable, 200)
        self.stamp(bundle, 100)
        self.assertEqual(bg.stale_messages(graph), [])
        # Directory newer than the source, executable older: stale.
        self.stamp(executable, 100)
        self.stamp(bundle, 300)
        (message,) = bg.stale_messages(graph)
        self.assertIn("B.app", message)

    def test_equal_timestamps_are_not_stale(self) -> None:
        self.settle(artifact=100, source=100, header=100, script=100)
        self.assertEqual(bg.stale_messages(self.graph), [])


class UnknownBuildOutputTests(unittest.TestCase):
    """unknown_build_outputs() on a synthetic graph."""

    def setUp(self) -> None:
        self._temp = tempfile.TemporaryDirectory(prefix="build-freshness-unknown-")
        self.addCleanup(self._temp.cleanup)
        self.project = Path(self._temp.name).resolve() / "outputs/blackmoor-decomp"
        write_source(self.project, "src/a.c")
        write_script(self.project, "build_a.sh", textwrap.dedent("""\
            #!/bin/sh
            set -eu
            project_dir="$(cd "$(dirname "$0")/.." && pwd)"
            mkdir -p "$project_dir/build"
            xcrun clang -dynamiclib "$project_dir/src/a.c" -o "$project_dir/build/liba.dylib"
            """))
        self.graph = bg.derive_graph(self.project)

    def touch(self, relative: str) -> None:
        write_source(self.project, "build/" + relative, "x")

    def test_derived_dsym_and_listed_files_are_accounted_for(self) -> None:
        self.touch("liba.dylib")
        self.touch("liba.dylib.dSYM/Contents/Resources/DWARF/liba.dylib")
        self.touch("sub/report.json")
        self.assertEqual(bg.unknown_build_outputs(self.graph, ["sub/*.json"]), [])

    def test_new_outputs_are_reported(self) -> None:
        self.touch("liba.dylib")
        self.touch("mystery.bin")
        self.touch("other.dylib.dSYM/Contents/x")
        self.touch("sub/extra.json")
        self.assertEqual(bg.unknown_build_outputs(self.graph, ["sub/report*.json"]),
                         ["mystery.bin", "other.dylib.dSYM/Contents/x", "sub/extra.json"])


class ProjectBuildFreshnessTests(unittest.TestCase):
    """The real project: every builder is derivable and nothing is stale."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.graph = bg.project_graph(PROJECT)

    def test_every_build_script_is_derivable(self) -> None:
        scripts = sorted(path.name for path in (PROJECT / "scripts").glob("build_*.sh"))
        self.assertGreater(len(scripts), 50)
        self.assertEqual(sorted(self.graph.scripts), scripts)
        for name in scripts:
            with self.subTest(script=name):
                result = self.graph.scripts[name]
                self.assertTrue(result.ok, f"cannot derive {name}: {result.error}")
                if not result.artifacts and name not in NO_ARTIFACT_ALLOWLIST:
                    self.fail(f"{name} derived no artifacts and is not in "
                              "NO_ARTIFACT_ALLOWLIST (with a reason)")

    def test_allowlist_entries_are_still_needed(self) -> None:
        for name, reason in NO_ARTIFACT_ALLOWLIST.items():
            with self.subTest(script=name):
                self.assertTrue(reason)
                result = self.graph.scripts.get(name)
                self.assertIsNotNone(result, f"{name} no longer exists")
                self.assertEqual(result.artifacts, (), f"{name} now derives artifacts; drop the entry")

    def test_no_unaccounted_build_outputs(self) -> None:
        for relative in bg.unknown_build_outputs(self.graph, KNOWN_UNTRACKED_OUTPUTS):
            with self.subTest(output=relative):
                self.fail(
                    f"build/{relative} is neither derived from a scripts/build_*.sh nor listed in "
                    "KNOWN_UNTRACKED_OUTPUTS (with a reason); find out what writes it")

    def test_live_audio_restart_sanitize_outputs_are_derived(self) -> None:
        # QA-3: build/sanitize-restart/* is written by build_live_audio_restart.sh sanitize, which
        # test_live_audio_restart.py runs; it is derived (on demand) rather than listed as untracked.
        by_path = {a.path: a for r in self.graph.scripts.values() for a in r.artifacts}
        directory = PROJECT / "build/sanitize-restart"
        for name in ("adapter.o", "his_audio.o", "live_audio.o", "macos_audio.o", "sound_control.o",
                     "test.o", "live_audio_restart_test"):
            with self.subTest(output=name):
                artifact = by_path[directory / name]
                self.assertEqual(artifact.script.name, "build_live_audio_restart.sh")
                self.assertTrue(artifact.on_demand)
        self.assertIn(PROJECT / "src/live_audio.c", by_path[directory / "live_audio_restart_test"].inputs)
        self.assertIn(PROJECT / "tests/live_audio_restart_test.c",
                      by_path[directory / "live_audio_restart_test"].inputs)
        self.assertFalse(any(fnmatch.fnmatchcase("sanitize-restart/x.o", p) for p in KNOWN_UNTRACKED_OUTPUTS))

    def test_known_untracked_entries_have_reasons(self) -> None:
        for pattern, reason in KNOWN_UNTRACKED_OUTPUTS.items():
            with self.subTest(pattern=pattern):
                self.assertTrue(reason.strip())

    def test_known_artifacts_are_derived(self) -> None:
        artifacts = {a.path for r in self.graph.scripts.values() for a in r.artifacts}
        scene_conditions = PROJECT / "build/libsceneconditions.dylib"
        self.assertIn(scene_conditions, artifacts)
        owner = next(a for r in self.graph.scripts.values() for a in r.artifacts
                     if a.path == scene_conditions)
        self.assertIn(PROJECT / "src/scene_conditions.c", owner.inputs)
        self.assertIn(PROJECT / "src/scene_conditions.h", owner.inputs)
        self.assertFalse(owner.on_demand)
        by_path = {a.path: a for r in self.graph.scripts.values() for a in r.artifacts}
        self.assertFalse(by_path[PROJECT / "Blackmoor Reconstruction.app"].on_demand)
        self.assertTrue(by_path[PROJECT / "Blackmoor Reconstruction Test.app"].on_demand)

    def test_existing_artifacts_are_not_older_than_their_inputs(self) -> None:
        for message in bg.stale_messages(self.graph):
            with self.subTest(stale=message.split(":", 1)[0]):
                self.fail(message)


if __name__ == "__main__":
    unittest.main()
