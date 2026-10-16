# QA-3: make the nightly full suite green

Goal: `script/run_test_suite.sh -v` exits 0. Baseline: branch `claude/nightly-suite-green`
(PR 73 head 2388cb0 on main aa6330e). On that baseline the suite ran 2,814 tests with 36
failures and 2 errors, all in the three groups below. The owner ruled on 2026-10-15 that the
full suite runs only nightly; the implementer runs the targeted test files only, and root
runs the full suite once at the end.

No GAME.EXE, `work/original` or resource bytes are touched. No assertion is weakened to get
a pass.

## 1. `test_record_function_execution.RecorderTests` (2 errors, `KeyError: '0x401000'`)

Root cause, established by root:
`scripts/exec_trace/sitecustomize.py` keys a trace by `os.path.abspath(sys.argv[0])`, but
`scripts/record_function_execution.py` `derive()` filters keys with
`str(root.resolve()) + os.sep`. `abspath` keeps symlinks, `resolve()` removes them. On macOS
the temporary directory `/var/folders/...` is a symlink to `/private/var/folders/...`, so the
fixture's keys never start with the resolved prefix, every run is skipped and `functions` is
empty. The same mismatch would drop real runs whenever the workspace or a script is reached
through a symlinked path (the worktrees reach `work/` through one).

Fix in the collector, not the test: in `derive()`, compare absolute keys after
`os.path.realpath` (leave non-absolute keys, such as unittest ids, unmatched exactly as today).
If two spellings of a key resolve to the same script, their tables must be merged (sizes from
either, hits summed) so the script is one run, not two. Add one regression test that uses
an explicitly symlinked workspace root (create the symlink inside a `tempfile` directory) so
the test does not depend on macOS's `/var` layout. Confirm the two existing errors pass and
that the new test fails without the fix.

Check whether the committed FL-8 model (the file `record_function_execution.py` writes by
default) changes when regenerated; it must not, since it was produced from the unsymlinked
main checkout. Do not regenerate or commit it unless it differs, and report either way.

## 2. `test_function_xrefs.DraftOverridesTests.test_draft_is_conservative` (fail)

The test dates from FL-3, when `function-ledger-overrides.json` was a draft with no
acceptances. It asserts `port_acceptances == []` against the live file. Since commit bfbb85c
(and FL-8, 69d5444) that file holds reviewed port acceptances, which are the point of the
ledger. The data is correct; the FL-3 invariant is stale.

Fix: keep every other assertion in that test (schema, `not_needed_entries == []`, rules
unaccepted, predicates, sample hashes, rule ids). Replace the empty-acceptances assertion with
a check that is at least as strong for the live file: every acceptance passes the same
validation the function-ledger tool applies to overrides (find the validator in
`scripts/function_ledger.py` or wherever `test_function_ledger.py` exercises "acceptance bad
class" etc.; call it, don't reimplement it), and each acceptance's `va` is a function start in
the xrefs index. Rename the test if "draft" no longer describes it. Explain in the commit
message why the old assertion was retired.

## 3. `test_build_freshness.ProjectBuildFreshnessTests.test_no_unaccounted_build_outputs` (35 subtests)

These `build/` outputs exist after a full run but no `scripts/build_*.sh` derivation accounts
for them:
`action_family_{0c,37,78,a1}_runtime_sanitize`, `action_family_78_binding_stub_sanitize`,
`session_bindings_a0c_stub_scene`, `session_bindings_a0c_stub_scene_plain`,
`sanitize-restart`, and their `.dSYM/*` bundles (the full list is whatever the test reports).
Some are written by `scripts/test_action_family_*_sanitizers.sh` (invoked by earlier tests),
some directly by tests, and `sanitize-restart` by `scripts/build_live_audio_restart.sh`.

For each output, find the exact writer (file:line, and which test invokes it). Then:
- if a `build_*.sh` writes it, teach `tests/build_graph.py` to derive it (preferred: it then
  gets freshness checking), with a unit test in `test_build_freshness.py` beside the existing
  graph tests;
- otherwise add it to `KNOWN_UNTRACKED_OUTPUTS` with a reason in the established style
  (writer file:line, invoking test).
Do not add broad wildcards (`*_sanitize*`); one pattern per output plus its `.dSYM/*`.

To reproduce without the full suite: run the specific tests/scripts that write these files,
then `test_build_freshness.py`. List any further unaccounted output you see.

## Acceptance

Run with `work/tools/oracle-python/bin/python -m unittest` and `BLACKMOOR_REQUIRE_ORACLE=1`
from the workspace root:
- `test_record_function_execution.py`, `test_function_xrefs.py`, `test_function_ledger.py`,
  `test_build_freshness.py` all pass (the last after the writers above have run);
- the new recorder regression test fails on the baseline collector.

Owned files: `scripts/record_function_execution.py`, `tests/test_record_function_execution.py`,
`tests/test_function_xrefs.py`, `tests/test_build_freshness.py`, `tests/build_graph.py`.
Report exact commands, results, the commit SHA and unverified points.
