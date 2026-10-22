# FUN_004afdc7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afdc7
# extent:       0x004afdc7-0x004afdfe (55 code bytes)
# span:         0x004afdc7-0x004afdfe (code 55, tables 0, padding 0)
# sha256:       6387cbcfaf4d4a13e6aced267127db8efeadcc298e9bfc85a530b9d9851266e6
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4afdc7_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4afdc7_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0x1515] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_1515; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4afdc7_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1515, 0x1515  # offset +0x1515

# --- external targets -----------------------------------------------

.org 0x004afdc7 - 0x401000
.globl FUN_004afdc7
FUN_004afdc7:
    # block 0x004afdc7: entry, 7 instruction(s), ends with je to 0x004afdfa (forward)
    push ebp                                     # 004afdc7
    {load} mov ebp, esp                          # 004afdc8
    push ecx                                     # 004afdca
    mov dword ptr [ebp - local_4], ecx           # 004afdcb
    mov eax, dword ptr [ebp - local_4]           # 004afdce
    cmp dword ptr [eax + field_1515], 0x0        # 004afdd1
    je.d8 L_004afdfa                             # 004afdd8
    # block 0x004afdda: entered by fall-through of je at 0x004afdd8, 4 instruction(s), ends with je to 0x004afdfa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004afdda
    movsx edx, word ptr [ecx + field_1c]         # 004afddd
    cmp edx, -0x1                                # 004afde1
    je.d8 L_004afdfa                             # 004afde4
    # block 0x004afde6: entered by fall-through of je at 0x004afde4, 4 instruction(s), falls into the block at 0x004afdfa
    mov eax, dword ptr [ebp - local_4]           # 004afde6
    movsx ecx, word ptr [eax + field_1c]         # 004afde9
    imul ecx, ecx, 0x4a                          # 004afded
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004afdf0
L_004afdfa:
    # block 0x004afdfa: entered by je at 0x004afdd8; je at 0x004afde4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004afdfa
    pop ebp                                      # 004afdfc
    ret                                          # 004afdfd

