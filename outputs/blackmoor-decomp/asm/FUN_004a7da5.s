# FUN_004a7da5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7da5
# extent:       0x004a7da5-0x004a7ddc (55 code bytes)
# span:         0x004a7da5-0x004a7ddc (code 55, tables 0, padding 0)
# sha256:       1100ce9806e0de1eb3a79159086793fcca575e06ad901450a746c5645feef599
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a7da5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_e72; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_e72, 0xe72  # offset +0xe72

# --- external targets -----------------------------------------------

.org 0x004a7da5 - 0x401000
.globl FUN_004a7da5
FUN_004a7da5:
    # block 0x004a7da5: entry, 7 instruction(s), ends with je to 0x004a7dd8 (forward)
    push ebp                                     # 004a7da5
    {load} mov ebp, esp                          # 004a7da6
    push ecx                                     # 004a7da8
    mov dword ptr [ebp - local_4], ecx           # 004a7da9
    mov eax, dword ptr [ebp - local_4]           # 004a7dac
    cmp dword ptr [eax + field_e72], 0x0         # 004a7daf
    je.d8 L_004a7dd8                             # 004a7db6
    # block 0x004a7db8: entered by fall-through of je at 0x004a7db6, 4 instruction(s), ends with je to 0x004a7dd8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a7db8
    movsx edx, word ptr [ecx + field_1c]         # 004a7dbb
    cmp edx, -0x1                                # 004a7dbf
    je.d8 L_004a7dd8                             # 004a7dc2
    # block 0x004a7dc4: entered by fall-through of je at 0x004a7dc2, 4 instruction(s), falls into the block at 0x004a7dd8
    mov eax, dword ptr [ebp - local_4]           # 004a7dc4
    movsx ecx, word ptr [eax + field_1c]         # 004a7dc7
    imul ecx, ecx, 0x4a                          # 004a7dcb
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a7dce
L_004a7dd8:
    # block 0x004a7dd8: entered by je at 0x004a7db6; je at 0x004a7dc2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a7dd8
    pop ebp                                      # 004a7dda
    ret                                          # 004a7ddb

