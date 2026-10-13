# S05 review repairs: writer and lifecycle

Owner: /root/sound_control_luna6 (GPT-6 Luna Max), assigned by root. This assignment follows the finished S04-2 recovery and takes priority because accepted caption rendering is needed by the persistent S0 session. Claude is assigned S03-1 AVF in a separate checkout; leave that work untouched.

## Outcome and ownership

Repair the three independent writer findings and two lifecycle findings, preserve original valid-input behavior and callback order, and obtain narrow independent re-review. Start a new isolated branch/worktree from Claude's frozen lifecycle commit bf1c094ff8286f4de47ad1622cf3a58df3278a02 (which includes writer db638f3). Link canonical work/. Record a unique S05-review-repairs claim. Preserve the original Claude checkouts and receipts.

Own only existing outputs/blackmoor-decomp/src/caption_layout.[ch], src/caption_lifecycle.[ch], their corresponding test_caption_layout.py/test_caption_lifecycle.py and original-oracle scripts/build scripts when the fix requires them, plus this child packet and uniquely named private S05-review-repairs.* evidence. Root collects; Boot owns shared app/parser/executor/platform/runtime wiring. A-51 and other action/codec/resource sources are read-only. Propose any public callback signature change with lifetime and integration consequences before implementing it.

Read AGENTS.md, PROJECT-SPEC.md, S05 and S05-2 handoff/recovery/integration-proposal files, and the prior CLAUDE-S05-1-REVIEW-FIXES.md. The original GOG executable/assets remain immutable. All work is automated/offscreen; original-x86 JIT comparisons use scoped escalation, never a VM runtime.

## Findings to repair

1. Writer P1: restore_caption_box executes around caption_layout.c:959 before staged pixels reach the caller's target around1099. The callback sees old pixels. Define source-ordered presentation and shared-state ownership so callbacks observe the intended rendered surface/state and callback flag mutations survive. Add callback-time pixel and flag assertions, including failure/partial-effect behavior. The old oracle merely recorded a restore event and missed this issue; do not claim its event list proves callback-time pixels.
2. Writer P2: release_font around419 discards a sheet handle if release_font_sheet is absent. Require a valid release/ownership contract before loading; cover successful, failed and pre-held sheet cleanup without leaks or duplicate release.
3. Writer P2: FONT/TBOX/glyph/colour geometry arithmetic can overflow signed C integers before validation. ASan/UBSan boundary probes must exercise INT_MIN/INT_MAX and intermediate arithmetic. Use source-backed explicit modulo-32-bit operations or checked wider arithmetic with clear safety rejection; valid shipped behavior must retain parity.
4. Lifecycle P1: slider_draw around508 indexes four rectangles with unchecked SLD_VISUAL; only4 is excluded. SLD_INIT_VISUAL comes directly from SCTB. Validate 0..3 and preserve4 as hidden before indexing. Cover -1,5,INT_MAX, including corrupted live state and malformed initial config, and assert callback/state prefix behavior.
5. Lifecycle P2: scene_reset around1046 overflows on TBOX bottom=INT_MAX/top=INT_MIN; related slider init/drag and popup hover arithmetic has the same risk. Cover the complete affected arithmetic surface, with defined original wrapping or checked rejection and meaningful bounds tests. Keep intentional malformed-input divergences explicit.

## Acceptance

Add regressions reproducing each finding before fixing it. Show that callbacks see current pixels/state, retain their shared flag writes, and release sheets exactly once on the tested paths. Check all invalid slider selectors before reads/callbacks. Run focused native tests and ASan/UBSan extreme geometry/state cases; preserve source-order partial effects instead of inventing rollback.

Rerun the relevant pinned original comparisons: writer full corpus (3,828 classified cases in old report), lifecycle19sequences333steps, and additional valid boundary/callback cases where needed. Separate original unsafe/error outcomes from successful native/original comparisons. Save unique report paths so original Claude evidence is preserved. Pin source/native/oracle/code-window hashes and enumerate hooks/blind spots.

Freeze the repair commit/snapshot for independent review. Resolve material findings, rerun affected checks and return the commit, source/contract changes, sanitizer evidence and exact unresolved acceptance items. Root will collect the original writer/lifecycle commits with this repair, then run combined checks. Pixel composition remains a separate outstanding S05 requirement; do not close parent S05 or claim live gameplay from state/command comparisons.
