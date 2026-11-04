# RECOMP-49 follow-up: PR 353 startup integration

Authorization: the owner's 2026-11-03 instruction in this Codex chat explicitly
requests merging current main into `codex/recomp-portable-macos`, retaining the
remembered-folder and chooser behavior, checking the final executable with
`blackmoor_check_startup`, preserving both sides' tests, building, rerunning
QA-001–QA-003, independent `slice-reviewer` review, and then merging. Existing
RECOMP-49 publication and full-suite requirements still apply. This chat is the
publisher. No original files or existing QA evidence may change; QA-004 remains
pending original-behavior verification.

Codex is the sole integration owner for this startup merge. Main is frozen at
`179bd478` (PR 353); the branch parent is `436d493a`. Preserve incoming atomic
save and startup validation changes without independently rewriting them.
Resolve only `recomp/macos_recomp.mm` and `tests/test_macos_game_data.py`.
Folder discovery, selection, private-copy preparation and explicit overrides
must finish before the startup gate; the gate receives exactly the executable
subsequently passed to `rc_start`. Startup refusal returns 2 and writes the
`GAME_EXE:` or `SAVE_DIR:` diagnostic to stderr and the requested log.

Acceptance: run `test_recomp_save_files` and `test_macos_game_data`; build via
`script/build_and_run.sh --build-only`; use the frozen candidate-retest launcher
with only in-process path retargeting. Under the short-write fault, the previous
170,770-byte `m0.SAV` must retain SHA-256
`7e4e1bc9ccf78fa7f79d9ddc7856c705397fb248bdfc1d12f1ffc84c3ee1dfd6`.
Read-only saves and a wrong executable must return 2 with their respective
prefixes. Verify ordinary save/reload and the remembered, chooser and override
startup paths to the extent permitted by quiet background execution.

New private build/evidence: `work/qa/2026-11-03/portable-pr353-integration/`.
The pre-existing `candidate-fixes` app is also protected evidence and must not
be overwritten. All game runs use independent scratch game/save directories,
`--mute --background`; no audible output or foreground interaction. Interactive
dialog display requires a hidden fixture or is explicitly reported not run.
The reviewer receives the frozen merge commit and evidence, reviews read-only,
and identifies any remaining unverified branches. Root assesses findings before
collection. No new complete-game or original-behavior claim is authorized.
