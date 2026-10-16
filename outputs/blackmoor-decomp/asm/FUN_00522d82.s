# FUN_00522d82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522d82
# extent:       0x00522d82-0x00522e1a (152 code bytes)
# span:         0x00522d82-0x00522e1a (code 152, tables 0, padding 0)
# sha256:       0278484a329c23fac037997e29fbbe2b0bd3ee1921d6485c4ca85d24aa0f659a
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522d82
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [edi + n] field_24; [esp + n] stk_8, stk_10, stk_18
# callees:      calls USER32.dll!GetDesktopWindow, FUN_0051ac0b, FUN_00522bd7, USER32.dll!GetWindowLongA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_00522bd7, .text + (0x00522bd7 - 0x401000)

.org 0x00522d82 - 0x401000
.globl FUN_00522d82
FUN_00522d82:
    # block 0x00522d82: entry, 12 instruction(s), calls USER32.dll!GetDesktopWindow, indirect ebp, ends with je to 0x00522e14 (forward)
    push ecx                                     # 00522d82
    push ebp                                     # 00522d83
    push esi                                     # 00522d84
    mov dword ptr [esp + stk_8], ecx             # 00522d85
    push 0x5                                     # 00522d89
    call dword ptr [0x52a384]                    # 00522d8b
    mov ebp, dword ptr [0x52a450]                # 00522d91
    push eax                                     # 00522d97
    call ebp                                     # 00522d98
    {load} mov esi, eax                          # 00522d9a
    test esi, esi                                # 00522d9c
    je.d8 L_00522e14                             # 00522d9e
    # block 0x00522da0: entered by fall-through of je at 0x00522d9e, 3 instruction(s), falls into the block at 0x00522da8
    push ebx                                     # 00522da0
    mov ebx, dword ptr [0x52a32c]                # 00522da1
    push edi                                     # 00522da7
L_00522da8:
    # block 0x00522da8: entered by jne at 0x00522e10, 5 instruction(s), calls FUN_0051ac0b, ends with je to 0x00522e07 (forward)
    push esi                                     # 00522da8
    call FUN_0051ac0b                            # 00522da9
    {load} mov edi, eax                          # 00522dae
    test edi, edi                                # 00522db0
    je.d8 L_00522e07                             # 00522db2
    # block 0x00522db4: entered by fall-through of je at 0x00522db2, 4 instruction(s), ends with je to 0x00522e07 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00522db4
    mov eax, dword ptr [eax + field_1c]          # 00522db8
    {load} cmp eax, esi                          # 00522dbb
    je.d8 L_00522e07                             # 00522dbd
    # block 0x00522dbf: entered by fall-through of je at 0x00522dbd, 5 instruction(s), calls FUN_00522bd7, ends with je to 0x00522e07 (forward)
    push esi                                     # 00522dbf
    push eax                                     # 00522dc0
    call FUN_00522bd7                            # 00522dc1
    test eax, eax                                # 00522dc6
    je.d8 L_00522e07                             # 00522dc8
    # block 0x00522dca: entered by fall-through of je at 0x00522dc8, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with jne to 0x00522df1 (forward)
    push -0x10                                   # 00522dca
    push esi                                     # 00522dcc
    call dword ptr [0x52a454]                    # 00522dcd
    cmp dword ptr [esp + stk_18], 0x0            # 00522dd3
    jne.d8 L_00522df1                            # 00522dd8
    # block 0x00522dda: entered by fall-through of jne at 0x00522dd8, 3 instruction(s), ends with jne to 0x00522e07 (forward)
    and eax, 0x18000000                          # 00522dda
    cmp eax, 0x10000000                          # 00522ddf
    jne.d8 L_00522e07                            # 00522de4
    # block 0x00522de6: entered by fall-through of jne at 0x00522de4, 5 instruction(s), calls indirect ebx, ends with forward jump to 0x00522e07
    push 0x0                                     # 00522de6
    push esi                                     # 00522de8
    call ebx                                     # 00522de9
    or dword ptr [edi + field_24], 0x2           # 00522deb
    jmp.d8 L_00522e07                            # 00522def
L_00522df1:
    # block 0x00522df1: entered by jne at 0x00522dd8, 2 instruction(s), ends with jne to 0x00522e07 (forward)
    test eax, 0x18000000                         # 00522df1
    jne.d8 L_00522e07                            # 00522df6
    # block 0x00522df8: entered by fall-through of jne at 0x00522df6, 2 instruction(s), ends with je to 0x00522e07 (forward)
    test byte ptr [edi + field_24], 0x2          # 00522df8
    je.d8 L_00522e07                             # 00522dfc
    # block 0x00522dfe: entered by fall-through of je at 0x00522dfc, 4 instruction(s), calls indirect ebx, falls into the block at 0x00522e07
    push 0x4                                     # 00522dfe
    push esi                                     # 00522e00
    call ebx                                     # 00522e01
    and dword ptr [edi + field_24], -0x3         # 00522e03
L_00522e07:
    # block 0x00522e07: entered by je at 0x00522db2; je at 0x00522dbd; je at 0x00522dc8; jne at 0x00522de4; more, 6 instruction(s), calls indirect ebp, ends with jne to 0x00522da8 (backward)
    push 0x2                                     # 00522e07
    push esi                                     # 00522e09
    call ebp                                     # 00522e0a
    {load} mov esi, eax                          # 00522e0c
    test esi, esi                                # 00522e0e
    jne.d8 L_00522da8                            # 00522e10
    # block 0x00522e12: entered by fall-through of jne at 0x00522e10, 2 instruction(s), falls into the block at 0x00522e14
    pop edi                                      # 00522e12
    pop ebx                                      # 00522e13
L_00522e14:
    # block 0x00522e14: entered by je at 0x00522d9e, 4 instruction(s), ends with ret 0x4
    pop esi                                      # 00522e14
    pop ebp                                      # 00522e15
    pop ecx                                      # 00522e16
    ret 0x4                                      # 00522e17

