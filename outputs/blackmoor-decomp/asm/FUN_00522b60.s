# FUN_00522b60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522b60
# extent:       0x00522b60-0x00522bd7 (119 code bytes)
# span:         0x00522b60-0x00522bd7 (code 119, tables 0, padding 0)
# sha256:       59c136ce29ae7c0103f442961ea7a57efe84456dea43f29938de207ae4c2aa64
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522b60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50; [esi + n] field_1c; [esp + n] stk_10, stk_14
# callees:      calls FUN_0051c174, FUN_0051bfc3; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051bfc3, .text + (0x0051bfc3 - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)

.org 0x00522b60 - 0x401000
.globl FUN_00522b60
FUN_00522b60:
    # block 0x00522b60: entry, 9 instruction(s), calls FUN_0051c174, ends with je to 0x00522bc2 (forward)
    push ebx                                     # 00522b60
    push esi                                     # 00522b61
    push edi                                     # 00522b62
    {load} mov esi, ecx                          # 00522b63
    movzx edi, word ptr [esp + stk_10]           # 00522b65
    call FUN_0051c174                            # 00522b6a
    {load} xor ecx, ecx                          # 00522b6f
    cmp dword ptr [eax + field_50], ecx          # 00522b71
    je.d8 L_00522bc2                             # 00522b74
    # block 0x00522b76: entered by fall-through of je at 0x00522b74, 2 instruction(s), ends with jne to 0x00522bc2 (forward)
    cmp dword ptr [esp + stk_14], ecx            # 00522b76
    jne.d8 L_00522bc2                            # 00522b7a
    # block 0x00522b7c: entered by fall-through of jne at 0x00522b7a, 2 instruction(s), ends with je to 0x00522bc2 (forward)
    cmp edi, 0xe146                              # 00522b7c
    je.d8 L_00522bc2                             # 00522b82
    # block 0x00522b84: entered by fall-through of je at 0x00522b82, 3 instruction(s), ends with je to 0x00522bc2 (forward)
    mov ebx, 0xe147                              # 00522b84
    {load} cmp edi, ebx                          # 00522b89
    je.d8 L_00522bc2                             # 00522b8b
    # block 0x00522b8d: entered by fall-through of je at 0x00522b8b, 2 instruction(s), ends with je to 0x00522bc2 (forward)
    cmp edi, 0xe145                              # 00522b8d
    je.d8 L_00522bc2                             # 00522b93
    # block 0x00522b95: entered by fall-through of je at 0x00522b93, 9 instruction(s), calls indirect edi, ends with jne to 0x00522bbd (forward)
    add edi, 0x10000                             # 00522b95
    push edi                                     # 00522b9b
    mov edi, dword ptr [0x52a4c8]                # 00522b9c
    push ecx                                     # 00522ba2
    push 0x365                                   # 00522ba3
    push dword ptr [esi + field_1c]              # 00522ba8
    call edi                                     # 00522bab
    test eax, eax                                # 00522bad
    jne.d8 L_00522bbd                            # 00522baf
    # block 0x00522bb1: entered by fall-through of jne at 0x00522baf, 5 instruction(s), calls indirect edi, falls into the block at 0x00522bbd
    push eax                                     # 00522bb1
    push ebx                                     # 00522bb2
    push 0x111                                   # 00522bb3
    push dword ptr [esi + field_1c]              # 00522bb8
    call edi                                     # 00522bbb
L_00522bbd:
    # block 0x00522bbd: entered by jne at 0x00522baf, 3 instruction(s), ends with forward jump to 0x00522bd1
    push 0x1                                     # 00522bbd
    pop eax                                      # 00522bbf
    jmp.d8 L_00522bd1                            # 00522bc0
L_00522bc2:
    # block 0x00522bc2: entered by je at 0x00522b74; jne at 0x00522b7a; je at 0x00522b82; je at 0x00522b8b; je at 0x00522b93, 4 instruction(s), calls FUN_0051bfc3, falls into the block at 0x00522bd1
    push dword ptr [esp + stk_14]                # 00522bc2
    {load} mov ecx, esi                          # 00522bc6
    push dword ptr [esp + stk_14]                # 00522bc8
    call FUN_0051bfc3                            # 00522bcc
L_00522bd1:
    # block 0x00522bd1: entered by jmp at 0x00522bc0, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 00522bd1
    pop esi                                      # 00522bd2
    pop ebx                                      # 00522bd3
    ret 0x8                                      # 00522bd4

