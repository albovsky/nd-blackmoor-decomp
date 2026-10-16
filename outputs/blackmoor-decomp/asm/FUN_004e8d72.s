# FUN_004e8d72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8d72
# extent:       0x004e8d72-0x004e8d96 (36 code bytes)
# span:         0x004e8d72-0x004e8d96 (code 36, tables 0, padding 0)
# sha256:       8b5b31d62019c3415df050721d384ff56df2bef12ec168b9c534090b716ec876
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e8d72
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6b1c; [ecx + n] field_6b1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6b1c, 0x6b1c  # offset +0x6b1c

# --- external targets -----------------------------------------------

.org 0x004e8d72 - 0x401000
.globl FUN_004e8d72
FUN_004e8d72:
    # block 0x004e8d72: entry, 7 instruction(s), ends with je to 0x004e8d92 (forward)
    push ebp                                     # 004e8d72
    {load} mov ebp, esp                          # 004e8d73
    push ecx                                     # 004e8d75
    mov dword ptr [ebp - local_4], ecx           # 004e8d76
    mov eax, dword ptr [ebp - local_4]           # 004e8d79
    cmp dword ptr [eax + field_6b1c], -0x1       # 004e8d7c
    je.d8 L_004e8d92                             # 004e8d83
    # block 0x004e8d85: entered by fall-through of je at 0x004e8d83, 2 instruction(s), falls into the block at 0x004e8d92
    mov ecx, dword ptr [ebp - local_4]           # 004e8d85
    mov dword ptr [ecx + field_6b1c], 0xffffffff # 004e8d88
L_004e8d92:
    # block 0x004e8d92: entered by je at 0x004e8d83, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e8d92
    pop ebp                                      # 004e8d94
    ret                                          # 004e8d95

