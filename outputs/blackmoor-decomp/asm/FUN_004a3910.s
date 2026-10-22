# FUN_004a3910
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3910
# extent:       0x004a3910-0x004a3947 (55 code bytes)
# span:         0x004a3910-0x004a3947 (code 55, tables 0, padding 0)
# sha256:       60f06db31e8d1754313f1464280088d0e069d97f016e0f8dad0daff6226e3dc4
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a3910_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4a3910_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0x26e] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_26e; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4a3910_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_26e, 0x26e  # offset +0x26e

# --- external targets -----------------------------------------------

.org 0x004a3910 - 0x401000
.globl FUN_004a3910
FUN_004a3910:
    # block 0x004a3910: entry, 7 instruction(s), ends with je to 0x004a3943 (forward)
    push ebp                                     # 004a3910
    {load} mov ebp, esp                          # 004a3911
    push ecx                                     # 004a3913
    mov dword ptr [ebp - local_4], ecx           # 004a3914
    mov eax, dword ptr [ebp - local_4]           # 004a3917
    cmp dword ptr [eax + field_26e], 0x0         # 004a391a
    je.d8 L_004a3943                             # 004a3921
    # block 0x004a3923: entered by fall-through of je at 0x004a3921, 4 instruction(s), ends with je to 0x004a3943 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a3923
    movsx edx, word ptr [ecx + field_1c]         # 004a3926
    cmp edx, -0x1                                # 004a392a
    je.d8 L_004a3943                             # 004a392d
    # block 0x004a392f: entered by fall-through of je at 0x004a392d, 4 instruction(s), falls into the block at 0x004a3943
    mov eax, dword ptr [ebp - local_4]           # 004a392f
    movsx ecx, word ptr [eax + field_1c]         # 004a3932
    imul ecx, ecx, 0x4a                          # 004a3936
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a3939
L_004a3943:
    # block 0x004a3943: entered by je at 0x004a3921; je at 0x004a392d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a3943
    pop ebp                                      # 004a3945
    ret                                          # 004a3946

