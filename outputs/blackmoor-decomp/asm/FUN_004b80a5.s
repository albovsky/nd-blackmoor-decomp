# FUN_004b80a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b80a5
# extent:       0x004b80a5-0x004b80d9 (52 code bytes)
# span:         0x004b80a5-0x004b80d9 (code 52, tables 0, padding 0)
# sha256:       bbeb1eb20f3be6a1227dc927f3d80fb49f7397322643bc23de4a98a25333fc43
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         tqz_invalidate
# naming:       native port src/action_family_f5_runtime.c:tqz_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with tqz_invalidate (active +0x14 != 0 and slot +4 != -1, then redraw dword := 1). The store is the host mark_dirty callback, called once with the slot; TQZ_OK/TQZ_ERR_HOST where the original is void.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_14; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:tqz_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x004b80a5 - 0x401000
.globl FUN_004b80a5
FUN_004b80a5:
    # block 0x004b80a5: entry, 7 instruction(s), ends with je to 0x004b80d5 (forward)
    push ebp                                     # 004b80a5
    {load} mov ebp, esp                          # 004b80a6
    push ecx                                     # 004b80a8
    mov dword ptr [ebp - local_4], ecx           # 004b80a9
    mov eax, dword ptr [ebp - local_4]           # 004b80ac
    cmp dword ptr [eax + field_14], 0x0          # 004b80af
    je.d8 L_004b80d5                             # 004b80b3
    # block 0x004b80b5: entered by fall-through of je at 0x004b80b3, 4 instruction(s), ends with je to 0x004b80d5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b80b5
    movsx edx, word ptr [ecx + field_4]          # 004b80b8
    cmp edx, -0x1                                # 004b80bc
    je.d8 L_004b80d5                             # 004b80bf
    # block 0x004b80c1: entered by fall-through of je at 0x004b80bf, 4 instruction(s), falls into the block at 0x004b80d5
    mov eax, dword ptr [ebp - local_4]           # 004b80c1
    movsx ecx, word ptr [eax + field_4]          # 004b80c4
    imul ecx, ecx, 0x4a                          # 004b80c8
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004b80cb
L_004b80d5:
    # block 0x004b80d5: entered by je at 0x004b80b3; je at 0x004b80bf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b80d5
    pop ebp                                      # 004b80d7
    ret                                          # 004b80d8

