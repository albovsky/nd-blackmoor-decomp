# S08-3: original input latch methods and exact x86 source

Owner: GPT-6 Luna Max worker. Baseline main `bc6f05bc76de492e1e0e0428259e9e40d35abc42`. Boot retains shared input/app wiring; root reviews and collects.

## Outcome

Recover the original input object's move/down/up methods into a bounded native C kernel and complete x86 source extents. This delivers real source-backed state transitions needed by the native input path and advances complete-function byte matching. Keep semantic C behaviour, explicit mnemonic assembly matching, original compiler provenance and whole-file rebuild evidence separate.

Read AGENTS.md, PROJECT-SPEC.md, REA skill, S08-2 matching/auditor source and private I01-1-session-progress-luna6-2026-10-13 receipt. Create an isolated worktree from the baseline, link canonical work/, check claims and claim S08-3. Own only new src/input_latch.[ch], src/matching_s08_3_x86.s, matches_s08_3_x86.json, scripts/build_input_latch.sh, scripts/build_matching_s08_3_x86.sh, scripts/audit_matching_s08_3_x86.py, tests/test_input_latch.py, tests/input_latch_original_oracle.py, tests/test_matching_s08_3_x86.py, tests/matching_s08_3_x86_oracle.py, this packet and unique private S08-3.* evidence. Shared app/executor/conditions and previous matching files are read-only. Supply a header/integration proposal to Boot.

## Original anchors and questions

- 0x4daf9f..0x4dafc3 (36 bytes): move ignores the first stack DWORD and reads two DWORDs through the second stack DWORD (a point pointer), storing them to this+0x18/+0x1c in instruction order; ret 8.
- 0x4dafc3..0x4db000 (61 bytes): down clears +0/+8/+0x10; changes +0x0c from 0 to 1 only.
- 0x4db000..0x4db04f (79 bytes): up gates on +8; neutral global 0x5c39e5 != -1 and +0 == 0 govern +0=1; +0x0c==1 becomes2; +0x10 clear has its own source branch.

These are Boot's preliminary byte trace, not a finished specification. Recover the exact skip paths, stores, argument widths, return/calling convention, flags and all side effects from original instructions. The global -1 sentinel has no approved semantic name. MFC wrappers 0x43ec4a/0x43ec85/0x43ed71 set ECX=0x5830a6 and invoke these helpers plus 0x51ab4b; wrapper and upstream coordinate transforms stay with Boot. Do not add clamp/viewport/scroll/hotpoint transforms to the pure move store. Down/up do not replace the last move coordinates.

## Acceptance and evidence

Define a borrowed original-layout state view or equivalent checked API, with no process-global duplicate and exact 32-bit values. Send the header/source-state proposal to root before implementation. Cover every branch using original x86 execution, signed/extreme coordinates, noncanonical latch values, sentinel/non-sentinel guard, repeated events and realistic interleavings. Compare all touched and untouched bytes, preserve valid original effects, and reject short state buffers safely. Exercise meaningful ABI canaries/stack cleanup and deliberate wrong-store/guard mutation detection. Run ASan/UBSan on native boundary cases.

Try credible original-generation C/thiscall compiler settings and record byte comparison results without calling a semantic C match an exact match. Explicitly authored mnemonic x86 assembly is allowed after the source/ABI recovery; machine-byte arrays, incbin, patching and automatic disassembly copying are outside this source contract. Use the pinned private GNU as from S08-2. Target all three complete method extents (176 bytes), including terminal returns and every branch.

Audit the actual supplied object and bound manifest; fresh reassembly must bind it to the exact reviewed source hash before granting reconstructed-source classification. Alternate objects, stale/unreviewed equivalent sources, assembly failure and malformed extents must remain neutral/rejected rather than inherit a source claim. Preserve the S08-2 auditor's distinction between current reproducibility and historical provenance. Reports contain hashes/offsets, not proprietary byte dumps. Do not modify the central builder; give Boot an explicit routing proposal.

Freeze and commit owned files with original/code-window/source/object/native/oracle hashes, build/unit/oracle commands and per-branch results. Require zero unexplained native state differences and byte-exact complete extents before claiming these methods matched. Document compiler/C mismatch evidence, unknown wrapper/input semantics and whole-file limitations. Request independent review, fix material findings, and return S08-3.handoff.json plus integration proposal. Parent S08 and the full game remain open. GUI waits for explicit unlock.

## Reviewed kernel handoff

Worker snapshot `08d00c3c76ebce27a7d271443130fe371e2f569c` passed independent review with no material findings. The three complete input methods total 176 byte-exact bytes from explicit mnemonic assembly. Fresh review reproduced 421 original/native and 421 original/candidate x86 calls, including 4,096 state bytes, alias order, ABI/flags/canaries and mutation detection. Native and matching tests, including sanitizers, passed. Credible Clang thiscall compiler variants remained mismatches; original compiler provenance and whole-file matching are open.

The public API is input_latch.h. The ignored first method argument is a raw DWORD; move reads through a bounded two-DWORD point view in original instruction order. Down/up preserve the original noncanonical values and skip branches. Boot owns wrapper/OS/client-coordinate transforms, candidate production and latch consumption. Private S08-3-handoff.json pins original/source/object/native/oracle hashes and coverage. Root collects the reviewed implementation; integration remains a separate gate.
