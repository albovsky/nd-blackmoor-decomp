# RECOMP-49: portable private ARM64 macOS package

Authorization: the owner's 2026-11-03 Codex chat requests a local self-contained
package, game-folder chooser, signing/notarization when credentials exist,
independent Sonnet review, and a source-only PR squash-merged by this chat.
Only this authorizing chat publishes repository changes. No game bytes, lifted C,
apps, DMGs, saves or resource dumps may be committed or uploaded publicly.
Apple notarization is authorized when credentials exist. No credentials in logs.

The authorizing user message begins "You are Codex (gpt-6.1-sol, xhigh) finishing
the native Mac port" and says "Work on your own branch and own PR" and
"squash-merge your own PR when clean". This root chat is the publisher. PR #352
is the source-only candidate. The owner's later scope extension below permits
bounded fixes for confirmed baseline suite blockers with independent review.
The green-suite condition remains a merge requirement.

Root owns shared `recomp/build_macos.sh`, `macos_recomp.mm`, game-data modules,
tests, INSTALL/HANDOFF and final integration. Story, ledger and original files
are out of scope. Engine changes are limited to the confirmed baseline blockers
covered by the owner's scope extension below. Preserve explicit scratch overrides and background quiet
behavior; no foreground launches or audible playback. No deletion command, shell
command chains or pipelines. Every variable assignment occupies its own line.

Packaging worker owns only new `script/package_macos.sh`,
`script/build_ffmpeg_macos.sh`, `script/macos_bundle.py` and focused packaging
tests. Use its own worktree. Build pinned official FFmpeg with LGPL-only minimal
Bink decoding, shared ARM64 libraries and macOS 11.0 deployment floor. Record
download SHA256, version, configure command, LGPL text and source availability
inside bundle licenses. Recursively copy non-system dependencies, rewrite load
commands/rpaths and reject unbundled dependencies. Root makes build_macos honor
FFMPEG_PREFIX, MIN_MACOS=11.0, and BLACKMOOR_BUNDLE_PATH. Packaging should use
project pinned Python, choose working Xcode via DEVELOPER_DIR if needed, validate
GAME_EXE hash before any build, create a fresh local output directory, sign nested
binaries inside-out with hardened runtime and no added entitlements. Environment
BLACKMOOR_SIGN_IDENTITY and BLACKMOOR_NOTARY_PROFILE select credentials; absent
credentials produce a clearly labeled ad-hoc DMG, never a trust success. Submit
with notarytool --wait, require Accepted, staple app before DMG and then notarize
and staple DMG, verify codesign/stapler/spctl. No public upload of any artifact.
Print local DMG path, SHA256 and bytes. Include app, Applications link and short
README. Reject bundle contents that include game resources/executable/lifted C.

Acceptance: every bundled Mach-O has only system or bundled load paths and no
Homebrew rpaths; actual quarantined copied app reaches main menu background/mute
with empty Homebrew fallback directory; seed validation covers valid, empty,
missing-file/wrong-game and wrong-version folders; original listing hashes equal
before/after; default saves remain in Application Support. Run full existing suite
and earned-ending headless run. Independent reviewer examines frozen commit,
root resolves findings, merges current main before PR, squash-merges clean PR.

Unverified branches must be recorded, particularly real Developer ID/notary
path when identities are absent, actual macOS 11 execution, interactive picker
UI, second Mac and hardware audio. No new complete-game/ledger claim.

Full-suite baseline repairs (root audit, same authorized PR): the unchanged
baseline reproduces stale A1C AppGlue text anchors, a surviving entry-limit mutant,
and macOS-unsupported unconditional LeakSanitizer settings in the A76/A77 tests.
A separate Sonnet worker may edit only `tests/test_action_family_1c_runtime.py`,
`tests/action_family_1c_runtime_test.c`, `tests/test_action_family_76_runtime.py`
and `tests/test_action_family_77_runtime.py` to repair those harnesses. Preserve
every behavioral assertion and mutant; add a real oversized-count fixture to
detect the existing entry-limit mutant rather than removing it. Probe runtime
LeakSanitizer support, retaining ASan/UBSan cases on macOS. No production engine,
story or ledger edit is authorized. Root installs missing oracle dependencies;
no test gate or skip is added to hide a missing dependency. Other full-suite
failures require separate evidence before scope changes.

Root also confirmed the identical unconditional LeakSanitizer abort in the AA,
D0, D3, DA, E0, E4, EB, EE and F5 unit harnesses. A shared test-only capability
probe supplies their environment while retaining every ASan/UBSan assertion and
mutant. Nine direct sanitizer checks run all existing cases; eight pass and E0
now exposes actual signed overflow at `src/action_family_e0_runtime.c:894`.
Production engine repair is expressly pending the owner's asynchronous scope
answer; the current authorization still forbids it. No new skip or relaxed
assertion is permitted as a workaround.

Owner scope extension (reply to the engine-blocker question in this same chat):
"Allow bounded fixes for confirmed baseline suite blockers, with independent
review; keep story and ledger unchanged." This supersedes the pending-engine
restriction above for confirmed blockers only. Root owns the E0 overflow and
pack-mask regression fixture. A separate Sonnet worker owns the sanitizer/leak
harness follow-up: `sanitizer_support.py` and the A1C, A76, A77, D3, E4, EB, EE,
F5 Python test modules only. Retain every mutant, remove hollow forced-LSan
aborts, use the demonstrated macOS `leaks --atExit` fallback for leak-only
mutants, and fail visibly if neither checker works. Do not silently downgrade
unexpected Linux LSan failures. No story/ledger edits; no other production module
is assigned to this worker. Root alone publishes and merges.

The canonical suite then stopped in `m423259_find_by_name` at its checked copy
into a 72-byte frame. A second Sonnet worker owns only `original_methods_fl19a.c`
and narrowly related FL19a fixtures to investigate the allocation against the
original 0x4c-byte frame, reproduce the crash, and make the smallest correction.
Both production fixes require an independent frozen-commit review. No changes
to function evidence, acceptance entries, ledger, story or campaign content.

Final harness review: the nine-file candidate was frozen as `dd6f115e` and
reviewed independently before root's follow-up. Real clean/leaking controls and
D3/A1C leak-only mutants demonstrate the macOS fallback. Root requires an
available checker in every affected sweep and makes tool errors/timeouts fail
visibly after one serialized retry; only a consistent positive leak report may
kill a mutant. No existing mutant, threshold or assertion is removed. E4's
generic mutation generator does not explicitly remove `free`; that inherited
coverage gap remains recorded, without a new complete-leak-coverage claim.
The implementer was stopped after disregarding the no-chained-commands rule.
Its unfinished EB/EE/F5 run is not counted as passing. Root owns the final run.

The later diagnostic found an ARM64 NaN-sign mismatch in `m44b3c8_sum_kinds`.
The original FMUL at 0x44b597 and FADD at 0x44b614 produce 0xffc00000 for
zero times either infinity and opposite infinities in either order. Four
original-only synthetic probes confirm those bits. Root preserves those exact
invalid-operation results while retaining finite arithmetic and all existing
comparisons; 14 direct/differential tests pass, including the original coverage
checks. No story or ledger data is changed. A missing Z3 dependency explained
the older held-row discrepancy; restoring it makes that unchanged check pass.

Owner exception for generated tracking (same authorizing chat): when asked
whether to apply the prepared evidence/ledger refresh while keeping every
function status and all totals unchanged, the owner replied "Apply generated
refresh (Recommended)". Root may regenerate that tracking and independently
review it; no new port acceptance, reclassification or coverage grant is allowed.
The proposed and applied refresh retains all 4,188 `(status, class)` pairs and
every ledger count (2,210 ported, 128 not needed, 1,850 pending).

The x87 reference model explicitly requires Intel `long double` and instructions;
its ARM fallback is not bit-exact. Existing Rosetta runs the unchanged reference
checks with a private modern x86 Python, an explicit x86 compiler and a separate
cache. Two previously failing x87-state comparisons pass there. The canonical
runner routes the FL40-and-later reference/model tests to that process, keeps
native port and gameplay tests on ARM64, preserves every discovered test ID and
duplicate, and propagates failure from either process. This is an isolated
original-x86 oracle check, not an Intel player build. No test body is skipped or
weakened. The obsolete FL59 expectation now pins exactly the two CRT copy rows
that FL78 already translates; its no-port-credit assertion remains unchanged.

Follow-up independent review of `d2e37b22` found no P1 and approved the routing
and generated refresh, subject to the real complete-suite result. Root also
confirmed that the override/acceptance file is byte-identical to main and all
oracle/acceptance claims, excluding source-file checksums, are unchanged. The
apparent coverage-field changes in a positional leaf diff were shifted evidence
list entries, not changed claims. Root strengthened the child receipt to compare
the actual executed IDs (preserving duplicates), reject skips/expected failures,
and require success plus exact count and zero exit. Seven routing/receipt tests
pass; discovery-only options are consumed before forwarding explicit IDs.

The clean full run exposed two additional baseline portability blockers. The
A1C allocation oracle used GNU linker `--wrap` options that Apple's linker
rejects. A test-only macOS call redirection preserves the same three wrappers,
real libc calls, counters and allocation-failure injections; both unchanged
original comparison/refusal tests now pass. No production A1C source is changed.
The A4E original comparison also confirmed the separately noted x87 NaN-sign
mismatch in `action_family_4e_runtime.c`. Root applies the same original FMUL
0x44b597/FADD 0x44b614 negative-indefinite rule there, with all finite arithmetic
and existing mutant anchors retained. Four bit-exact cases fail before this
fix; the full A4E tests and independent frozen review are required afterward.
