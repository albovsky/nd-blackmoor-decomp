# FUN_00522bf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522bf7
# extent:       0x00522bf7-0x00522d13 (284 code bytes)
# span:         0x00522bf7-0x00522d13 (code 284, tables 0, padding 0)
# sha256:       a2602d8e59ab43921843e86e5a982ce76d21d05da86ed9f570e6024ab41ac2c6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522bd7 (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522bf7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ebx + n] field_a0, field_a4; [esp + n] stk_10, stk_14; [scaled index + n] field_4
# callees:      calls FUN_0051c14c, USER32.dll!GetDesktopWindow, USER32.dll!IsWindowEnabled, FUN_0051ac0b, FUN_00522bd7, USER32.dll!SendMessageA, FUN_0051dc43, USER32.dll!EnableWindow; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 102 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_00522bd7, .text + (0x00522bd7 - 0x401000)

.org 0x00522bf7 - 0x401000
.globl FUN_00522bf7
FUN_00522bf7:
    # block 0x00522bf7: entry, 10 instruction(s), ends with ja to 0x00522d0d (forward)
    push ecx                                     # 00522bf7
    push ebx                                     # 00522bf8
    {load} mov ebx, ecx                          # 00522bf9
    push ebp                                     # 00522bfb
    push esi                                     # 00522bfc
    inc dword ptr [ebx + field_a0]               # 00522bfd
    cmp dword ptr [ebx + field_a0], 0x1          # 00522c03
    lea eax, [ebx + field_a0]                    # 00522c0a
    push edi                                     # 00522c10
    ja.d32 L_00522d0d                            # 00522c11
    # block 0x00522c17: entered by fall-through of ja at 0x00522c11, 11 instruction(s), calls FUN_0051c14c, USER32.dll!GetDesktopWindow, indirect edi, ends with je to 0x00522d0d (forward)
    call FUN_0051c14c                            # 00522c17
    push 0x5                                     # 00522c1c
    mov dword ptr [esp + stk_14], eax            # 00522c1e
    {load} xor ebp, ebp                          # 00522c22
    call dword ptr [0x52a384]                    # 00522c24
    mov edi, dword ptr [0x52a450]                # 00522c2a
    push eax                                     # 00522c30
    call edi                                     # 00522c31
    {load} mov esi, eax                          # 00522c33
    test esi, esi                                # 00522c35
    je.d32 L_00522d0d                            # 00522c37
L_00522c3d:
    # block 0x00522c3d: entered by jne at 0x00522c81; fall-through of je at 0x00522c37, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x00522c78 (forward)
    push esi                                     # 00522c3d
    call dword ptr [0x52a330]                    # 00522c3e
    test eax, eax                                # 00522c44
    je.d8 L_00522c78                             # 00522c46
    # block 0x00522c48: entered by fall-through of je at 0x00522c46, 4 instruction(s), calls FUN_0051ac0b, ends with je to 0x00522c78 (forward)
    push esi                                     # 00522c48
    call FUN_0051ac0b                            # 00522c49
    test eax, eax                                # 00522c4e
    je.d8 L_00522c78                             # 00522c50
    # block 0x00522c52: entered by fall-through of je at 0x00522c50, 6 instruction(s), calls FUN_00522bd7, ends with je to 0x00522c78 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00522c52
    push esi                                     # 00522c56
    push dword ptr [eax + field_1c]              # 00522c57
    call FUN_00522bd7                            # 00522c5a
    test eax, eax                                # 00522c5f
    je.d8 L_00522c78                             # 00522c61
    # block 0x00522c63: entered by fall-through of je at 0x00522c61, 7 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x00522c78 (forward)
    push 0x0                                     # 00522c63
    push 0x0                                     # 00522c65
    push 0x36c                                   # 00522c67
    push esi                                     # 00522c6c
    call dword ptr [0x52a4c8]                    # 00522c6d
    test eax, eax                                # 00522c73
    jne.d8 L_00522c78                            # 00522c75
    # block 0x00522c77: entered by fall-through of jne at 0x00522c75, 1 instruction(s), falls into the block at 0x00522c78
    inc ebp                                      # 00522c77
L_00522c78:
    # block 0x00522c78: entered by je at 0x00522c46; je at 0x00522c50; je at 0x00522c61; jne at 0x00522c75, 6 instruction(s), calls indirect edi, ends with jne to 0x00522c3d (backward)
    push 0x2                                     # 00522c78
    push esi                                     # 00522c7a
    call edi                                     # 00522c7b
    {load} mov esi, eax                          # 00522c7d
    test esi, esi                                # 00522c7f
    jne.d8 L_00522c3d                            # 00522c81
    # block 0x00522c83: entered by fall-through of jne at 0x00522c81, 2 instruction(s), ends with je to 0x00522d0d (forward)
    test ebp, ebp                                # 00522c83
    je.d32 L_00522d0d                            # 00522c85
    # block 0x00522c8b: entered by fall-through of je at 0x00522c85, 9 instruction(s), calls FUN_0051dc43, USER32.dll!GetDesktopWindow, falls into the block at 0x00522caa
    lea eax, [4*ebp + field_4]                   # 00522c8b
    push eax                                     # 00522c92
    call FUN_0051dc43                            # 00522c93
    pop ecx                                      # 00522c98
    mov dword ptr [ebx + field_a4], eax          # 00522c99
    push 0x5                                     # 00522c9f
    {load} xor ebp, ebp                          # 00522ca1
    call dword ptr [0x52a384]                    # 00522ca3
    push eax                                     # 00522ca9
L_00522caa:
    # block 0x00522caa: entered by jmp at 0x00522d01, 4 instruction(s), calls indirect edi, ends with je to 0x00522d03 (forward)
    call edi                                     # 00522caa
    {load} mov esi, eax                          # 00522cac
    test esi, esi                                # 00522cae
    je.d8 L_00522d03                             # 00522cb0
    # block 0x00522cb2: entered by fall-through of je at 0x00522cb0, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x00522cfe (forward)
    push esi                                     # 00522cb2
    call dword ptr [0x52a330]                    # 00522cb3
    test eax, eax                                # 00522cb9
    je.d8 L_00522cfe                             # 00522cbb
    # block 0x00522cbd: entered by fall-through of je at 0x00522cbb, 4 instruction(s), calls FUN_0051ac0b, ends with je to 0x00522cfe (forward)
    push esi                                     # 00522cbd
    call FUN_0051ac0b                            # 00522cbe
    test eax, eax                                # 00522cc3
    je.d8 L_00522cfe                             # 00522cc5
    # block 0x00522cc7: entered by fall-through of je at 0x00522cc5, 6 instruction(s), calls FUN_00522bd7, ends with je to 0x00522cfe (forward)
    mov eax, dword ptr [esp + stk_10]            # 00522cc7
    push esi                                     # 00522ccb
    push dword ptr [eax + field_1c]              # 00522ccc
    call FUN_00522bd7                            # 00522ccf
    test eax, eax                                # 00522cd4
    je.d8 L_00522cfe                             # 00522cd6
    # block 0x00522cd8: entered by fall-through of je at 0x00522cd6, 7 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x00522cfe (forward)
    push 0x0                                     # 00522cd8
    push 0x0                                     # 00522cda
    push 0x36c                                   # 00522cdc
    push esi                                     # 00522ce1
    call dword ptr [0x52a4c8]                    # 00522ce2
    test eax, eax                                # 00522ce8
    jne.d8 L_00522cfe                            # 00522cea
    # block 0x00522cec: entered by fall-through of jne at 0x00522cea, 6 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x00522cfe
    push eax                                     # 00522cec
    push esi                                     # 00522ced
    call dword ptr [0x52a4d0]                    # 00522cee
    mov eax, dword ptr [ebx + field_a4]          # 00522cf4
    mov dword ptr [eax + 4*ebp], esi             # 00522cfa
    inc ebp                                      # 00522cfd
L_00522cfe:
    # block 0x00522cfe: entered by je at 0x00522cbb; je at 0x00522cc5; je at 0x00522cd6; jne at 0x00522cea, 3 instruction(s), ends with backward jump to 0x00522caa
    push 0x2                                     # 00522cfe
    push esi                                     # 00522d00
    jmp.d8 L_00522caa                            # 00522d01
L_00522d03:
    # block 0x00522d03: entered by je at 0x00522cb0, 2 instruction(s), falls into the block at 0x00522d0d
    mov eax, dword ptr [ebx + field_a4]          # 00522d03
    and dword ptr [eax + 4*ebp], 0x0             # 00522d09
L_00522d0d:
    # block 0x00522d0d: entered by ja at 0x00522c11; je at 0x00522c37; je at 0x00522c85, 6 instruction(s), ends with ret
    pop edi                                      # 00522d0d
    pop esi                                      # 00522d0e
    pop ebp                                      # 00522d0f
    pop ebx                                      # 00522d10
    pop ecx                                      # 00522d11
    ret                                          # 00522d12

