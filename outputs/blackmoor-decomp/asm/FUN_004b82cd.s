# FUN_004b82cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b82cd
# extent:       0x004b82cd-0x004b832c (95 code bytes)
# span:         0x004b82cd-0x004b832c (code 95, tables 0, padding 0)
# sha256:       6a3491e8eca7445acdc9a3fc5f2ff2b5eb5a4564a8b302b94fea4938db0a9460
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         tqz_click
# naming:       native port src/action_family_f5_runtime.c:tqz_click (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with tqz_click (active, not finishing, state 0, row phase 1, candidate 0x27eb, then phase := 2). Row phase and candidate are parameters; the phase store is returned via *new_phase; returns 1/0 where the original is void.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6, field_14; [ecx + n] field_20; [edx + n] field_6, field_10
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:tqz_click (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6, 0x6  # offset +0x6
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x004b82cd - 0x401000
.globl FUN_004b82cd
FUN_004b82cd:
    # block 0x004b82cd: entry, 7 instruction(s), ends with je to 0x004b8328 (forward)
    push ebp                                     # 004b82cd
    {load} mov ebp, esp                          # 004b82ce
    push ecx                                     # 004b82d0
    mov dword ptr [ebp - local_4], ecx           # 004b82d1
    mov eax, dword ptr [ebp - local_4]           # 004b82d4
    cmp dword ptr [eax + field_14], 0x0          # 004b82d7
    je.d8 L_004b8328                             # 004b82db
    # block 0x004b82dd: entered by fall-through of je at 0x004b82db, 3 instruction(s), ends with jne to 0x004b8328 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b82dd
    cmp dword ptr [ecx + field_20], 0x0          # 004b82e0
    jne.d8 L_004b8328                            # 004b82e4
    # block 0x004b82e6: entered by fall-through of jne at 0x004b82e4, 3 instruction(s), ends with jne to 0x004b8328 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b82e6
    cmp dword ptr [edx + field_10], 0x0          # 004b82e9
    jne.d8 L_004b8328                            # 004b82ed
    # block 0x004b82ef: entered by fall-through of jne at 0x004b82ed, 5 instruction(s), ends with jne to 0x004b8328 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b82ef
    movsx ecx, word ptr [eax + field_6]          # 004b82f2
    imul ecx, ecx, 0x8d                          # 004b82f6
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004b82fc
    jne.d8 L_004b8328                            # 004b8303
    # block 0x004b8305: entered by fall-through of jne at 0x004b8303, 2 instruction(s), ends with jne to 0x004b8328 (forward)
    cmp dword ptr [0x5c39e5], 0x27eb             # 004b8305
    jne.d8 L_004b8328                            # 004b830f
    # block 0x004b8311: entered by fall-through of jne at 0x004b830f, 4 instruction(s), falls into the block at 0x004b8328
    mov edx, dword ptr [ebp - local_4]           # 004b8311
    movsx eax, word ptr [edx + field_6]          # 004b8314
    imul eax, eax, 0x8d                          # 004b8318
    mov dword ptr [eax + 0x5bb632], 0x2          # 004b831e
L_004b8328:
    # block 0x004b8328: entered by je at 0x004b82db; jne at 0x004b82e4; jne at 0x004b82ed; jne at 0x004b8303; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b8328
    pop ebp                                      # 004b832a
    ret                                          # 004b832b

