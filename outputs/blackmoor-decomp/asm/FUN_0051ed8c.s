# FUN_0051ed8c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ed8c
# extent:       0x0051ed8c-0x0051ee6e (226 code bytes)
# span:         0x0051ed8c-0x0051ee6e (code 226, tables 0, padding 0)
# sha256:       e852f163f17b796c7147ef059a4a41ad95b4ecd188e20d32ed24d5f9de676d9a
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ed8c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_14, local_18, local_1c
# fields:       [esi + n] field_28, field_2c
# callees:      calls FUN_0050f920, FUN_0052513f, FUN_0050fe79, KERNEL32.dll!ResumeThread, KERNEL32.dll!WaitForSingleObject, KERNEL32.dll!SuspendThread, KERNEL32.dll!SetEvent; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 88 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051ee6e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0050fe79, .text + (0x0050fe79 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x0051ed8c - 0x401000
.globl FUN_0051ed8c
FUN_0051ed8c:
    # block 0x0051ed8c: entry, 35 instruction(s), calls FUN_0050f920, FUN_0052513f, indirect edi, ends with je to 0x0051ee5b (forward)
    push ebp                                     # 0051ed8c
    {load} mov ebp, esp                          # 0051ed8d
    sub esp, 0x1c                                # 0051ed8f
    push ebx                                     # 0051ed92
    push esi                                     # 0051ed93
    push edi                                     # 0051ed94
    {load} xor ebx, ebx                          # 0051ed95
    push 0x1c                                    # 0051ed97
    lea eax, [ebp - local_1c]                    # 0051ed99
    push ebx                                     # 0051ed9c
    {load} mov esi, ecx                          # 0051ed9d
    push eax                                     # 0051ed9f
    call FUN_0050f920                            # 0051eda0
    add esp, 0xc                                 # 0051eda5
    call FUN_0052513f                            # 0051eda8
    mov edi, dword ptr [0x52a254]                # 0051edad
    push ebx                                     # 0051edb3
    push ebx                                     # 0051edb4
    push 0x1                                     # 0051edb5
    push ebx                                     # 0051edb7
    mov dword ptr [ebp - local_1c], eax          # 0051edb8
    mov dword ptr [ebp - local_18], esi          # 0051edbb
    call edi                                     # 0051edbe
    push ebx                                     # 0051edc0
    push ebx                                     # 0051edc1
    push 0x1                                     # 0051edc2
    push ebx                                     # 0051edc4
    mov dword ptr [ebp - local_c], eax           # 0051edc5
    call edi                                     # 0051edc8
    cmp dword ptr [ebp - local_c], ebx           # 0051edca
    mov edi, dword ptr [0x52a2b8]                # 0051edcd
    mov dword ptr [ebp - local_8], eax           # 0051edd3
    mov eax, dword ptr [ebp + arg_8]             # 0051edd6
    mov dword ptr [ebp - local_14], eax          # 0051edd9
    je.d8 L_0051ee5b                             # 0051eddc
    # block 0x0051edde: entered by fall-through of je at 0x0051eddc, 2 instruction(s), ends with je to 0x0051ee56 (forward)
    cmp dword ptr [ebp - local_8], ebx           # 0051edde
    je.d8 L_0051ee56                             # 0051ede1
    # block 0x0051ede3: entered by fall-through of je at 0x0051ede1, 14 instruction(s), calls FUN_0050fe79, ends with je to 0x0051ee65 (forward)
    lea ecx, [esi + field_2c]                    # 0051ede3
    or al, 0x4                                   # 0051ede6
    push ecx                                     # 0051ede8
    push eax                                     # 0051ede9
    lea eax, [ebp - local_1c]                    # 0051edea
    push eax                                     # 0051eded
    push 0x51eb41                                # 0051edee
    push dword ptr [ebp + arg_c]                 # 0051edf3
    push dword ptr [ebp + arg_10]                # 0051edf6
    call FUN_0050fe79                            # 0051edf9
    add esp, 0x18                                # 0051edfe
    {load} cmp eax, ebx                          # 0051ee01
    mov dword ptr [esi + field_28], eax          # 0051ee03
    je.d8 L_0051ee65                             # 0051ee06
    # block 0x0051ee08: entered by fall-through of je at 0x0051ee06, 9 instruction(s), calls KERNEL32.dll!ResumeThread, KERNEL32.dll!WaitForSingleObject, indirect edi, ends with je to 0x0051ee2e (forward)
    push eax                                     # 0051ee08
    call dword ptr [0x52a284]                    # 0051ee09
    push -0x1                                    # 0051ee0f
    push dword ptr [ebp - local_c]               # 0051ee11
    call dword ptr [0x52a1ec]                    # 0051ee14
    push dword ptr [ebp - local_c]               # 0051ee1a
    call edi                                     # 0051ee1d
    test byte ptr [ebp + arg_8], 0x4             # 0051ee1f
    je.d8 L_0051ee2e                             # 0051ee23
    # block 0x0051ee25: entered by fall-through of je at 0x0051ee23, 2 instruction(s), calls KERNEL32.dll!SuspendThread, falls into the block at 0x0051ee2e
    push dword ptr [esi + field_28]              # 0051ee25
    call dword ptr [0x52a27c]                    # 0051ee28
L_0051ee2e:
    # block 0x0051ee2e: entered by je at 0x0051ee23, 2 instruction(s), ends with je to 0x0051ee48 (forward)
    cmp dword ptr [ebp - local_4], ebx           # 0051ee2e
    je.d8 L_0051ee48                             # 0051ee31
    # block 0x0051ee33: entered by fall-through of je at 0x0051ee31, 7 instruction(s), calls KERNEL32.dll!WaitForSingleObject, indirect edi, ends with forward jump to 0x0051ee60
    push -0x1                                    # 0051ee33
    push dword ptr [esi + field_28]              # 0051ee35
    call dword ptr [0x52a1ec]                    # 0051ee38
    push dword ptr [esi + field_28]              # 0051ee3e
    call edi                                     # 0051ee41
    mov dword ptr [esi + field_28], ebx          # 0051ee43
    jmp.d8 L_0051ee60                            # 0051ee46
L_0051ee48:
    # block 0x0051ee48: entered by je at 0x0051ee31, 5 instruction(s), calls KERNEL32.dll!SetEvent, ends with forward jump to 0x0051ee67
    push dword ptr [ebp - local_8]               # 0051ee48
    call dword ptr [0x52a1e8]                    # 0051ee4b
    push 0x1                                     # 0051ee51
    pop eax                                      # 0051ee53
    jmp.d8 L_0051ee67                            # 0051ee54
L_0051ee56:
    # block 0x0051ee56: entered by je at 0x0051ede1, 2 instruction(s), calls indirect edi, falls into the block at 0x0051ee5b
    push dword ptr [ebp - local_c]               # 0051ee56
    call edi                                     # 0051ee59
L_0051ee5b:
    # block 0x0051ee5b: entered by je at 0x0051eddc, 2 instruction(s), ends with je to 0x0051ee65 (forward)
    cmp dword ptr [ebp - local_8], ebx           # 0051ee5b
    je.d8 L_0051ee65                             # 0051ee5e
L_0051ee60:
    # block 0x0051ee60: entered by jmp at 0x0051ee46; fall-through of je at 0x0051ee5e, 2 instruction(s), calls indirect edi, falls into the block at 0x0051ee65
    push dword ptr [ebp - local_8]               # 0051ee60
    call edi                                     # 0051ee63
L_0051ee65:
    # block 0x0051ee65: entered by je at 0x0051ee06; je at 0x0051ee5e, 1 instruction(s), falls into the block at 0x0051ee67
    {load} xor eax, eax                          # 0051ee65
L_0051ee67:
    # block 0x0051ee67: entered by jmp at 0x0051ee54, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0051ee67
    pop esi                                      # 0051ee68
    pop ebx                                      # 0051ee69
    leave                                        # 0051ee6a
    ret 0xc                                      # 0051ee6b

