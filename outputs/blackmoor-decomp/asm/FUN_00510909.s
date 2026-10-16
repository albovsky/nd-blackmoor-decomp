# FUN_00510909
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510909
# extent:       0x00510909-0x00510984 (123 code bytes)
# span:         0x00510909-0x00510984 (code 123, tables 0, padding 0)
# sha256:       9746ede10e0bda122bb81cde5505a5edcc8df0f542185e17e1ca72e905476433
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510909
# arguments:    10 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [ebx + n] field_c; [edi + n] field_8; [esi + n] field_4
# callees:      calls FUN_00510ac9, FUN_0050c677, FUN_0051086b, FUN_00510984, FUN_0050c635
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0050c635, .text + (0x0050c635 - 0x401000)
.set FUN_0050c677, .text + (0x0050c677 - 0x401000)
.set FUN_0051086b, .text + (0x0051086b - 0x401000)
.set FUN_00510984, .text + (0x00510984 - 0x401000)
.set FUN_00510ac9, .text + (0x00510ac9 - 0x401000)

.org 0x00510909 - 0x401000
.globl FUN_00510909
FUN_00510909:
    # block 0x00510909: entry, 9 instruction(s), ends with je to 0x0051092b (forward)
    push ebp                                     # 00510909
    {load} mov ebp, esp                          # 0051090a
    cmp dword ptr [ebp + arg_20], 0x0            # 0051090c
    push ebx                                     # 00510910
    mov ebx, dword ptr [ebp + arg_1c]            # 00510911
    push esi                                     # 00510914
    push edi                                     # 00510915
    mov edi, dword ptr [ebp + arg_c]             # 00510916
    je.d8 L_0051092b                             # 00510919
    # block 0x0051091b: entered by fall-through of je at 0x00510919, 6 instruction(s), calls FUN_00510ac9, falls into the block at 0x0051092b
    push dword ptr [ebp + arg_20]                # 0051091b
    push ebx                                     # 0051091e
    push edi                                     # 0051091f
    push dword ptr [ebp + arg_8]                 # 00510920
    call FUN_00510ac9                            # 00510923
    add esp, 0x10                                # 00510928
L_0051092b:
    # block 0x0051092b: entered by je at 0x00510919, 3 instruction(s), ends with jne to 0x00510937 (forward)
    cmp dword ptr [ebp + arg_2c], 0x0            # 0051092b
    push dword ptr [ebp + arg_8]                 # 0051092f
    jne.d8 L_00510937                            # 00510932
    # block 0x00510934: entered by fall-through of jne at 0x00510932, 2 instruction(s), ends with forward jump to 0x0051093a
    push edi                                     # 00510934
    jmp.d8 L_0051093a                            # 00510935
L_00510937:
    # block 0x00510937: entered by jne at 0x00510932, 1 instruction(s), falls into the block at 0x0051093a
    push dword ptr [ebp + arg_2c]                # 00510937
L_0051093a:
    # block 0x0051093a: entered by jmp at 0x00510935, 21 instruction(s), calls FUN_0050c677, FUN_0051086b, FUN_00510984, ends with je to 0x0051097f (forward)
    call FUN_0050c677                            # 0051093a
    mov esi, dword ptr [ebp + arg_24]            # 0051093f
    push dword ptr [esi]                         # 00510942
    push dword ptr [ebp + arg_18]                # 00510944
    push dword ptr [ebp + arg_14]                # 00510947
    push edi                                     # 0051094a
    call FUN_0051086b                            # 0051094b
    mov eax, dword ptr [esi + field_4]           # 00510950
    push 0x100                                   # 00510953
    push dword ptr [ebp + arg_28]                # 00510958
    inc eax                                      # 0051095b
    mov dword ptr [edi + field_8], eax           # 0051095c
    push dword ptr [ebx + field_c]               # 0051095f
    push dword ptr [ebp + arg_18]                # 00510962
    push dword ptr [ebp + arg_10]                # 00510965
    push edi                                     # 00510968
    push dword ptr [ebp + arg_8]                 # 00510969
    call FUN_00510984                            # 0051096c
    add esp, 0x2c                                # 00510971
    test eax, eax                                # 00510974
    je.d8 L_0051097f                             # 00510976
    # block 0x00510978: entered by fall-through of je at 0x00510976, 3 instruction(s), calls FUN_0050c635, falls into the block at 0x0051097f
    push edi                                     # 00510978
    push eax                                     # 00510979
    call FUN_0050c635                            # 0051097a
L_0051097f:
    # block 0x0051097f: entered by je at 0x00510976, 5 instruction(s), ends with ret
    pop edi                                      # 0051097f
    pop esi                                      # 00510980
    pop ebx                                      # 00510981
    pop ebp                                      # 00510982
    ret                                          # 00510983

