# FUN_0051ca36
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ca36
# extent:       0x0051ca36-0x0051caab (117 code bytes)
# span:         0x0051ca36-0x0051caab (code 117, tables 0, padding 0)
# sha256:       9e06993e27677f6dbaf9d96c4a73144043cbcb7e48c9a915d97b04b75f0025bc
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ca36
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052102d, GDI32.dll!GetObjectA, GDI32.dll!SetBkColor, USER32.dll!GetSysColor, GDI32.dll!SetTextColor
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051caab
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0052102d, .text + (0x0052102d - 0x401000)

.org 0x0051ca36 - 0x401000
.globl FUN_0051ca36
FUN_0051ca36:
    # block 0x0051ca36: entry, 5 instruction(s), ends with je to 0x0051caa5 (forward)
    push ebp                                     # 0051ca36
    {load} mov ebp, esp                          # 0051ca37
    sub esp, 0xc                                 # 0051ca39
    cmp dword ptr [ebp + arg_8], 0x0             # 0051ca3c
    je.d8 L_0051caa5                             # 0051ca40
    # block 0x0051ca42: entered by fall-through of je at 0x0051ca40, 2 instruction(s), ends with je to 0x0051caa5 (forward)
    cmp dword ptr [ebp + arg_14], 0x0            # 0051ca42
    je.d8 L_0051caa5                             # 0051ca46
    # block 0x0051ca48: entered by fall-through of je at 0x0051ca46, 3 instruction(s), ends with je to 0x0051caa5 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 0051ca48
    cmp eax, 0x1                                 # 0051ca4b
    je.d8 L_0051caa5                             # 0051ca4e
    # block 0x0051ca50: entered by fall-through of je at 0x0051ca4e, 2 instruction(s), ends with je to 0x0051caa5 (forward)
    test eax, eax                                # 0051ca50
    je.d8 L_0051caa5                             # 0051ca52
    # block 0x0051ca54: entered by fall-through of je at 0x0051ca52, 2 instruction(s), ends with je to 0x0051caa5 (forward)
    cmp eax, 0x5                                 # 0051ca54
    je.d8 L_0051caa5                             # 0051ca57
    # block 0x0051ca59: entered by fall-through of je at 0x0051ca57, 2 instruction(s), ends with jne to 0x0051ca6b (forward)
    cmp eax, 0x2                                 # 0051ca59
    jne.d8 L_0051ca6b                            # 0051ca5c
    # block 0x0051ca5e: entered by fall-through of jne at 0x0051ca5c, 5 instruction(s), calls FUN_0052102d, ends with je to 0x0051caa5 (forward)
    push eax                                     # 0051ca5e
    push dword ptr [ebp + arg_c]                 # 0051ca5f
    call FUN_0052102d                            # 0051ca62
    test eax, eax                                # 0051ca67
    je.d8 L_0051caa5                             # 0051ca69
L_0051ca6b:
    # block 0x0051ca6b: entered by jne at 0x0051ca5c; fall-through of je at 0x0051ca69, 11 instruction(s), calls GDI32.dll!GetObjectA, GDI32.dll!SetBkColor, ends with jne to 0x0051ca96 (forward)
    lea eax, [ebp - local_c]                     # 0051ca6b
    push eax                                     # 0051ca6e
    push 0xc                                     # 0051ca6f
    push dword ptr [ebp + arg_14]                # 0051ca71
    call dword ptr [0x52a054]                    # 0051ca74
    push dword ptr [ebp - local_8]               # 0051ca7a
    push dword ptr [ebp + arg_8]                 # 0051ca7d
    call dword ptr [0x52a050]                    # 0051ca80
    mov eax, dword ptr [ebp + arg_18]            # 0051ca86
    cmp eax, -0x1                                # 0051ca89
    jne.d8 L_0051ca96                            # 0051ca8c
    # block 0x0051ca8e: entered by fall-through of jne at 0x0051ca8c, 2 instruction(s), calls USER32.dll!GetSysColor, falls into the block at 0x0051ca96
    push 0x8                                     # 0051ca8e
    call dword ptr [0x52a310]                    # 0051ca90
L_0051ca96:
    # block 0x0051ca96: entered by jne at 0x0051ca8c, 6 instruction(s), calls GDI32.dll!SetTextColor, ends with forward jump to 0x0051caa7
    push eax                                     # 0051ca96
    push dword ptr [ebp + arg_8]                 # 0051ca97
    call dword ptr [0x52a04c]                    # 0051ca9a
    push 0x1                                     # 0051caa0
    pop eax                                      # 0051caa2
    jmp.d8 L_0051caa7                            # 0051caa3
L_0051caa5:
    # block 0x0051caa5: entered by je at 0x0051ca40; je at 0x0051ca46; je at 0x0051ca4e; je at 0x0051ca52; more, 1 instruction(s), falls into the block at 0x0051caa7
    {load} xor eax, eax                          # 0051caa5
L_0051caa7:
    # block 0x0051caa7: entered by jmp at 0x0051caa3, 2 instruction(s), ends with ret 0x14
    leave                                        # 0051caa7
    ret 0x14                                     # 0051caa8

