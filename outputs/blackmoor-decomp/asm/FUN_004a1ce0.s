# FUN_004a1ce0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1ce0
# extent:       0x004a1ce0-0x004a1d14 (52 code bytes)
# span:         0x004a1ce0-0x004a1d14 (code 52, tables 0, padding 0)
# sha256:       740c5119356b845222fcab203915c2b3843ab22fef5bb9a6a0d6e105a07726f7
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1ce0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_60; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------

.org 0x004a1ce0 - 0x401000
.globl FUN_004a1ce0
FUN_004a1ce0:
    # block 0x004a1ce0: entry, 7 instruction(s), ends with je to 0x004a1d10 (forward)
    push ebp                                     # 004a1ce0
    {load} mov ebp, esp                          # 004a1ce1
    push ecx                                     # 004a1ce3
    mov dword ptr [ebp - local_4], ecx           # 004a1ce4
    mov eax, dword ptr [ebp - local_4]           # 004a1ce7
    cmp dword ptr [eax + field_60], 0x0          # 004a1cea
    je.d8 L_004a1d10                             # 004a1cee
    # block 0x004a1cf0: entered by fall-through of je at 0x004a1cee, 4 instruction(s), ends with je to 0x004a1d10 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1cf0
    movsx edx, word ptr [ecx + field_1c]         # 004a1cf3
    cmp edx, -0x1                                # 004a1cf7
    je.d8 L_004a1d10                             # 004a1cfa
    # block 0x004a1cfc: entered by fall-through of je at 0x004a1cfa, 4 instruction(s), falls into the block at 0x004a1d10
    mov eax, dword ptr [ebp - local_4]           # 004a1cfc
    movsx ecx, word ptr [eax + field_1c]         # 004a1cff
    imul ecx, ecx, 0x4a                          # 004a1d03
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a1d06
L_004a1d10:
    # block 0x004a1d10: entered by je at 0x004a1cee; je at 0x004a1cfa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a1d10
    pop ebp                                      # 004a1d12
    ret                                          # 004a1d13

