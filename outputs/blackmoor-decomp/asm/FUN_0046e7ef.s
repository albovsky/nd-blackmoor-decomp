# FUN_0046e7ef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e7ef
# extent:       0x0046e7ef-0x0046e823 (52 code bytes)
# span:         0x0046e7ef-0x0046e823 (code 52, tables 0, padding 0)
# sha256:       bb96f3b6868f8eea64692bebd7fc6ecfc46cd0f5ebfe8912d341d59438f1500f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46e7ef_guard_set_table_flag
# naming:       native port src/original_methods_fl38a.c:m46e7ef_guard_set_table_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores dword 1 at 0x5d15a5+0x4a*int16[this+0x1c] when dword [this+0x46] is set and the word is not -1; returns this. 18/18 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_46; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m46e7ef_guard_set_table_flag (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_46, 0x46  # offset +0x46

# --- external targets -----------------------------------------------

.org 0x0046e7ef - 0x401000
.globl FUN_0046e7ef
FUN_0046e7ef:
    # block 0x0046e7ef: entry, 7 instruction(s), ends with je to 0x0046e81f (forward)
    push ebp                                     # 0046e7ef
    {load} mov ebp, esp                          # 0046e7f0
    push ecx                                     # 0046e7f2
    mov dword ptr [ebp - local_4], ecx           # 0046e7f3
    mov eax, dword ptr [ebp - local_4]           # 0046e7f6
    cmp dword ptr [eax + field_46], 0x0          # 0046e7f9
    je.d8 L_0046e81f                             # 0046e7fd
    # block 0x0046e7ff: entered by fall-through of je at 0x0046e7fd, 4 instruction(s), ends with je to 0x0046e81f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046e7ff
    movsx edx, word ptr [ecx + field_1c]         # 0046e802
    cmp edx, -0x1                                # 0046e806
    je.d8 L_0046e81f                             # 0046e809
    # block 0x0046e80b: entered by fall-through of je at 0x0046e809, 4 instruction(s), falls into the block at 0x0046e81f
    mov eax, dword ptr [ebp - local_4]           # 0046e80b
    movsx ecx, word ptr [eax + field_1c]         # 0046e80e
    imul ecx, ecx, 0x4a                          # 0046e812
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0046e815
L_0046e81f:
    # block 0x0046e81f: entered by je at 0x0046e7fd; je at 0x0046e809, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046e81f
    pop ebp                                      # 0046e821
    ret                                          # 0046e822

