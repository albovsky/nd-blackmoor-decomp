# S08-4: original input-consumption methods and exact x86 source

Root assigns this child to /root/progress_map_luna6 (GPT-6 Luna Max) after the reviewed M01 map handoff. Baseline main58afa1d. Parent S08 and native input integration remain open. Boot is the sole shared writer.

## Outcome and ownership

Recover the two original input read/clear methods needed by frame dispatch, implement their bounded native behavior and reconstruct their complete x86 extents as authored mnemonic assembly. Read AGENTS.md, PROJECT-SPEC.md, WORK-SLICES.md, local REA skill, input_latch.h and the accepted S08-3 native/oracle/matching files. Create an isolated canonical managed worktree, link canonical work/, and claim S08-4 before editing.

Own only new src/input_consume.[ch], src/matching_s08_4_x86.s, matches_s08_4_x86.json, scripts/build_input_consume.sh, scripts/build_matching_s08_4_x86.sh, scripts/audit_matching_s08_4_x86.py, tests/test_input_consume.py, tests/input_consume_original_oracle.py, tests/test_matching_s08_4_x86.py, tests/matching_s08_4_x86_oracle.py and private S08-4.* evidence. Existing input_latch, matching/auditor/map, app/parser/executor/platform and central builder are read-only. Use separate new files and give Boot a typed integration proposal.

## Source boundary and API gate

Original input object is0x5830a6. Preliminary full extents are0x4daf3f..0x4daf6e (47 bytes) and0x4daf6e..0x4daf9f (49 bytes); confirm each start and terminal return against the current function index and immutable bytes. The actual frame path43b199 invokes4daf3f, while43c0d6 invokes4daf6e. These consume different original fields (+0 versus +4). Recover every load/store/skip, actual return width/value and calling convention before assigning semantic names. Determine exactly when +0x0c and other fields clear, including zero/noncanonical input cases. Do not infer behavior solely from decompiler pseudocode or the earlier root shorthand.

Propose a header reusing the borrowed InputLatchStateView, with a native adapter status separate from the original raw return value. Existing state bytes remain authoritative; no duplicate global or independent latch. Result storage must not alias original-layout fields in a way that invents writes. Validate spans/output pointers before mutation, explicitly define alias cases, and preserve source instruction order on valid views. Send the short API/state proposal to root before implementing; source recovery may continue while root reviews it.

## Verification and exact matching

Compare original/native state and return values for both methods across every branch, repeated calls, noncanonical flags, down/up/consume interleavings, two consumers in both orders, extreme32-bit values, aliases and short/null spans. Include complete state-byte/canary and stack/ABI checks; reject malformed native spans without partial writes. Run ASan/UBSan and meaningful deliberate wrong-clear/wrong-result mutations. Actual screen/client/cursor/hotspot transforms remain Boot's separate integration boundary.

Author complete mnemonic x86 assembly after recovery. No machine-byte arrays, incbin, patching or automatic disassembly copying. Use the existing pinned private GNU assembler. Bind supplied object to exact source/manifest/tool hashes with fresh reassembly; preserve the distinction between current source reproducibility and historical original compiler/source provenance. Unreviewed equivalent sources, alternate objects, stale/malformed reports and incomplete extents must not inherit a reconstructed-source claim. Audit both complete47/49-byte extents including terminal returns; give counts for unique exact bytes without double-counting prior S08-3 ranges.

Try credible C/thiscall compiler settings and report byte differences separately; a semantic native match is not a compiler-byte match. Execute both candidate and original x86 methods with matched full register/EFLAGS/stack/canary state across representative paths and detect deliberate machine-source mutants.

Freeze a clean commit containing only owned files, with source/original/code-window/native/object/manifest/assembler/oracle hashes, exact commands/counts/hooks and unverified branches. Request independent review and repair findings. Return S08-4.handoff.json, validation.json and integration-proposal.md. Root reviews and collects; Boot wires consumers later. No GUI or hardware audio while Mac is locked; canonical writes and Unicorn JIT need require_escalated. Passing these methods does not close source reconstruction, original compiler provenance, whole-file matching or native input/gameplay.
