# FUN_004b5c11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5c11
# extent:       0x004b5c11-0x004b5c48 (55 code bytes)
# span:         0x004b5c11-0x004b5c48 (code 55, tables 0, padding 0)
# sha256:       5a68c808cd2bff8a32a6f4b4ce48766d38c60b4a1fde722802702275f02fa056
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         d1_invalidate
# naming:       native port src/action_family_d1_runtime.c:d1_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with d1_invalidate (active +0x225 != 0 and slot +0x1c != -1, then redraw dword := 1). The store is the host mark_dirty callback. Native-only: NULL args -> D1_ERR_ARGUMENT, host error -> D1_ERR_HOST.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_225; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d1_runtime.c:d1_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_225, 0x225  # offset +0x225

# --- external targets -----------------------------------------------

.org 0x004b5c11 - 0x401000
.globl FUN_004b5c11
FUN_004b5c11:
    # block 0x004b5c11: entry, 7 instruction(s), ends with je to 0x004b5c44 (forward)
    push ebp                                     # 004b5c11
    {load} mov ebp, esp                          # 004b5c12
    push ecx                                     # 004b5c14
    mov dword ptr [ebp - local_4], ecx           # 004b5c15
    mov eax, dword ptr [ebp - local_4]           # 004b5c18
    cmp dword ptr [eax + field_225], 0x0         # 004b5c1b
    je.d8 L_004b5c44                             # 004b5c22
    # block 0x004b5c24: entered by fall-through of je at 0x004b5c22, 4 instruction(s), ends with je to 0x004b5c44 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b5c24
    movsx edx, word ptr [ecx + field_1c]         # 004b5c27
    cmp edx, -0x1                                # 004b5c2b
    je.d8 L_004b5c44                             # 004b5c2e
    # block 0x004b5c30: entered by fall-through of je at 0x004b5c2e, 4 instruction(s), falls into the block at 0x004b5c44
    mov eax, dword ptr [ebp - local_4]           # 004b5c30
    movsx ecx, word ptr [eax + field_1c]         # 004b5c33
    imul ecx, ecx, 0x4a                          # 004b5c37
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004b5c3a
L_004b5c44:
    # block 0x004b5c44: entered by je at 0x004b5c22; je at 0x004b5c2e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b5c44
    pop ebp                                      # 004b5c46
    ret                                          # 004b5c47

