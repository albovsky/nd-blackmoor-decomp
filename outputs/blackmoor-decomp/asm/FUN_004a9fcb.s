# FUN_004a9fcb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9fcb
# extent:       0x004a9fcb-0x004aa002 (55 code bytes)
# span:         0x004a9fcb-0x004aa002 (code 55, tables 0, padding 0)
# sha256:       36245cb786411c15bbf61b831ec4ba02d3812c52aa6bf1686d0d7bddc772bc0c
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9fcb_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4a9fcb_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when byte [self+0x45] is 0 or the signed word [self+0x29] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_45; [ecx + n] field_29; [edx + n] field_29
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4a9fcb_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_29, 0x29  # offset +0x29
.equ field_45, 0x45  # offset +0x45

# --- external targets -----------------------------------------------

.org 0x004a9fcb - 0x401000
.globl FUN_004a9fcb
FUN_004a9fcb:
    # block 0x004a9fcb: entry, 9 instruction(s), ends with je to 0x004a9ffe (forward)
    push ebp                                     # 004a9fcb
    {load} mov ebp, esp                          # 004a9fcc
    push ecx                                     # 004a9fce
    mov dword ptr [ebp - local_4], ecx           # 004a9fcf
    mov eax, dword ptr [ebp - local_4]           # 004a9fd2
    {load} xor ecx, ecx                          # 004a9fd5
    mov cl, byte ptr [eax + field_45]            # 004a9fd7
    test ecx, ecx                                # 004a9fda
    je.d8 L_004a9ffe                             # 004a9fdc
    # block 0x004a9fde: entered by fall-through of je at 0x004a9fdc, 4 instruction(s), ends with je to 0x004a9ffe (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a9fde
    movsx eax, word ptr [edx + field_29]         # 004a9fe1
    cmp eax, -0x1                                # 004a9fe5
    je.d8 L_004a9ffe                             # 004a9fe8
    # block 0x004a9fea: entered by fall-through of je at 0x004a9fe8, 4 instruction(s), falls into the block at 0x004a9ffe
    mov ecx, dword ptr [ebp - local_4]           # 004a9fea
    movsx edx, word ptr [ecx + field_29]         # 004a9fed
    imul edx, edx, 0x4a                          # 004a9ff1
    mov dword ptr [edx + 0x5d15a5], 0x1          # 004a9ff4
L_004a9ffe:
    # block 0x004a9ffe: entered by je at 0x004a9fdc; je at 0x004a9fe8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a9ffe
    pop ebp                                      # 004aa000
    ret                                          # 004aa001

