# FUN_004e3a64
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3a64
# extent:       0x004e3a64-0x004e3ade (122 code bytes)
# span:         0x004e3a64-0x004e3ade (code 122, tables 0, padding 0)
# sha256:       cbf5f4df9d2f67fb082daa11a6ceca645e27a806ce0ba4e4d068935905e59a77
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e3a64
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6b8, field_6be, field_6c6; [ecx + n] field_6bc, field_6c6; [edx + n] field_6ba, field_6c2
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6b8, 0x6b8  # offset +0x6b8
.equ field_6ba, 0x6ba  # offset +0x6ba
.equ field_6bc, 0x6bc  # offset +0x6bc
.equ field_6be, 0x6be  # offset +0x6be
.equ field_6c2, 0x6c2  # offset +0x6c2
.equ field_6c6, 0x6c6  # offset +0x6c6

# --- external targets -----------------------------------------------

.org 0x004e3a64 - 0x401000
.globl FUN_004e3a64
FUN_004e3a64:
    # block 0x004e3a64: entry, 28 instruction(s), ends with ret
    push ebp                                     # 004e3a64
    {load} mov ebp, esp                          # 004e3a65
    push ecx                                     # 004e3a67
    mov dword ptr [ebp - local_4], ecx           # 004e3a68
    mov eax, dword ptr [ebp - local_4]           # 004e3a6b
    mov cx, word ptr [0x5bb57b]                  # 004e3a6e
    mov word ptr [eax + field_6b8], cx           # 004e3a75
    mov edx, dword ptr [ebp - local_4]           # 004e3a7c
    mov ax, word ptr [0x5bb57f]                  # 004e3a7f
    mov word ptr [edx + field_6ba], ax           # 004e3a85
    mov ecx, dword ptr [ebp - local_4]           # 004e3a8c
    mov dx, word ptr [0x5bb50b]                  # 004e3a8f
    mov word ptr [ecx + field_6bc], dx           # 004e3a96
    mov eax, dword ptr [ebp - local_4]           # 004e3a9d
    mov cx, word ptr [0x5bb593]                  # 004e3aa0
    mov word ptr [eax + field_6be], cx           # 004e3aa7
    mov edx, dword ptr [ebp - local_4]           # 004e3aae
    mov eax, dword ptr [0x5bb5a7]                # 004e3ab1
    mov dword ptr [edx + field_6c2], eax         # 004e3ab6
    mov ecx, dword ptr [ebp - local_4]           # 004e3abc
    mov edx, dword ptr [0x5bb5ab]                # 004e3abf
    mov dword ptr [ecx + field_6c6], edx         # 004e3ac5
    mov eax, dword ptr [ebp - local_4]           # 004e3acb
    mov ecx, dword ptr [0x5bb5af]                # 004e3ace
    mov dword ptr [eax + field_6c6], ecx         # 004e3ad4
    {load} mov esp, ebp                          # 004e3ada
    pop ebp                                      # 004e3adc
    ret                                          # 004e3add

