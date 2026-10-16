# FUN_0051d5e1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d5e1
# extent:       0x0051d5e1-0x0051d630 (79 code bytes)
# span:         0x0051d5e1-0x0051d630 (code 79, tables 0, padding 0)
# sha256:       f02437f24f6360ff45175b0126d9dcf05ba6ae5dd5bc8951065d6393d5ee2701
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d5e1
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1c; [ecx + n] field_1c, field_38; [edx + n] field_9c
# callees:      calls USER32.dll!SetWindowPos; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_9c, 0x9c  # offset +0x9c

# --- external targets -----------------------------------------------

.org 0x0051d5e1 - 0x401000
.globl FUN_0051d5e1
FUN_0051d5e1:
    # block 0x0051d5e1: entry, 5 instruction(s), ends with jne to 0x0051d610 (forward)
    push ebp                                     # 0051d5e1
    {load} mov ebp, esp                          # 0051d5e2
    mov eax, dword ptr [ecx + field_38]          # 0051d5e4
    test eax, eax                                # 0051d5e7
    jne.d8 L_0051d610                            # 0051d5e9
    # block 0x0051d5eb: entered by fall-through of jne at 0x0051d5e9, 3 instruction(s), ends with je to 0x0051d5f5 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051d5eb
    test eax, eax                                # 0051d5ee
    je.d8 L_0051d5f5                             # 0051d5f0
    # block 0x0051d5f2: entered by fall-through of je at 0x0051d5f0, 1 instruction(s), falls into the block at 0x0051d5f5
    mov eax, dword ptr [eax + field_1c]          # 0051d5f2
L_0051d5f5:
    # block 0x0051d5f5: entered by je at 0x0051d5f0, 9 instruction(s), calls USER32.dll!SetWindowPos, ends with forward jump to 0x0051d62c
    push dword ptr [ebp + arg_1c]                # 0051d5f5
    push dword ptr [ebp + arg_18]                # 0051d5f8
    push dword ptr [ebp + arg_14]                # 0051d5fb
    push dword ptr [ebp + arg_10]                # 0051d5fe
    push dword ptr [ebp + arg_c]                 # 0051d601
    push eax                                     # 0051d604
    push dword ptr [ecx + field_1c]              # 0051d605
    call dword ptr [0x52a45c]                    # 0051d608
    jmp.d8 L_0051d62c                            # 0051d60e
L_0051d610:
    # block 0x0051d610: entered by jne at 0x0051d5e9, 9 instruction(s), calls indirect dword ptr [edx + 0x9c], falls into the block at 0x0051d62c
    push dword ptr [ebp + arg_1c]                # 0051d610
    mov edx, dword ptr [eax]                     # 0051d613
    {load} mov ecx, eax                          # 0051d615
    push dword ptr [ebp + arg_18]                # 0051d617
    push dword ptr [ebp + arg_14]                # 0051d61a
    push dword ptr [ebp + arg_10]                # 0051d61d
    push dword ptr [ebp + arg_c]                 # 0051d620
    push dword ptr [ebp + arg_8]                 # 0051d623
    call dword ptr [edx + field_9c]              # 0051d626
L_0051d62c:
    # block 0x0051d62c: entered by jmp at 0x0051d60e, 2 instruction(s), ends with ret 0x18
    pop ebp                                      # 0051d62c
    ret 0x18                                     # 0051d62d

