# FUN_00520d31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520d31
# extent:       0x00520d31-0x00520d7d (76 code bytes)
# span:         0x00520d31-0x00520d7d (code 76, tables 0, padding 0)
# sha256:       35f1122d76e4ae49bfa7aa17c2cd0524d5bb50abafbeaf06f2a7c5b30e6740f0
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520d31
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [esi + n] field_4, field_8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x00520d31 - 0x401000
.globl FUN_00520d31
FUN_00520d31:
    # block 0x00520d31: entry, 11 instruction(s), ends with je to 0x00520d55 (forward)
    push ebp                                     # 00520d31
    {load} mov ebp, esp                          # 00520d32
    push ecx                                     # 00520d34
    push ecx                                     # 00520d35
    push esi                                     # 00520d36
    {load} mov esi, ecx                          # 00520d37
    push edi                                     # 00520d39
    mov edi, dword ptr [0x52a07c]                # 00520d3a
    mov eax, dword ptr [esi + field_4]           # 00520d40
    cmp eax, dword ptr [esi + field_8]           # 00520d43
    je.d8 L_00520d55                             # 00520d46
    # block 0x00520d48: entered by fall-through of je at 0x00520d46, 6 instruction(s), calls indirect edi, falls into the block at 0x00520d55
    lea ecx, [ebp - local_8]                     # 00520d48
    push ecx                                     # 00520d4b
    push dword ptr [ebp + arg_10]                # 00520d4c
    push dword ptr [ebp + arg_c]                 # 00520d4f
    push eax                                     # 00520d52
    call edi                                     # 00520d53
L_00520d55:
    # block 0x00520d55: entered by je at 0x00520d46, 3 instruction(s), ends with je to 0x00520d69 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520d55
    test esi, esi                                # 00520d58
    je.d8 L_00520d69                             # 00520d5a
    # block 0x00520d5c: entered by fall-through of je at 0x00520d5a, 6 instruction(s), calls indirect edi, falls into the block at 0x00520d69
    lea eax, [ebp - local_8]                     # 00520d5c
    push eax                                     # 00520d5f
    push dword ptr [ebp + arg_10]                # 00520d60
    push dword ptr [ebp + arg_c]                 # 00520d63
    push esi                                     # 00520d66
    call edi                                     # 00520d67
L_00520d69:
    # block 0x00520d69: entered by je at 0x00520d5a, 9 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp + arg_8]             # 00520d69
    mov ecx, dword ptr [ebp - local_8]           # 00520d6c
    pop edi                                      # 00520d6f
    pop esi                                      # 00520d70
    mov dword ptr [eax], ecx                     # 00520d71
    mov ecx, dword ptr [ebp - local_4]           # 00520d73
    mov dword ptr [eax + field_4], ecx           # 00520d76
    leave                                        # 00520d79
    ret 0xc                                      # 00520d7a

