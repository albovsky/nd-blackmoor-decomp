# FUN_0051b6a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b6a8
# extent:       0x0051b6a8-0x0051b720 (120 code bytes)
# span:         0x0051b6a8-0x0051b720 (code 120, tables 0, padding 0)
# sha256:       90cc4e9b597a6af97c1f18fd3369120e2675195fa7a4b2f8facd757f511b6432
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b61a (+0x8e)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b6a8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50, field_54; [edi + n] field_1c; [edx + n] field_10; [esi + n] field_4, field_8; [esp + n] stk_c
# callees:      calls FUN_00525b0f, USER32.dll!GetMenu, FUN_0051fa37, FUN_0051b645, FUN_0051c1b5, FUN_0051c4ec, FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051b645, .text + (0x0051b645 - 0x401000)
.set FUN_0051c1b5, .text + (0x0051c1b5 - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)
.set FUN_0051fa37, .text + (0x0051fa37 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051b6a8 - 0x401000
.globl FUN_0051b6a8
FUN_0051b6a8:
    # block 0x0051b6a8: entry, 6 instruction(s), ends with jne to 0x0051b6f5 (forward)
    push esi                                     # 0051b6a8
    mov esi, dword ptr [esp + stk_c]             # 0051b6a9
    push edi                                     # 0051b6ad
    {load} mov edi, ecx                          # 0051b6ae
    cmp dword ptr [esi], 0x1                     # 0051b6b0
    jne.d8 L_0051b6f5                            # 0051b6b3
    # block 0x0051b6b5: entered by fall-through of jne at 0x0051b6b3, 6 instruction(s), calls FUN_00525b0f, ends with jne to 0x0051b6d1 (forward)
    push 0x52496c                                # 0051b6b5
    mov ecx, 0x63c444                            # 0051b6ba
    call FUN_00525b0f                            # 0051b6bf
    mov ecx, dword ptr [edi + field_1c]          # 0051b6c4
    cmp dword ptr [eax + field_50], ecx          # 0051b6c7
    jne.d8 L_0051b6d1                            # 0051b6ca
    # block 0x0051b6cc: entered by fall-through of jne at 0x0051b6ca, 2 instruction(s), ends with forward jump to 0x0051b6d9
    push dword ptr [eax + field_54]              # 0051b6cc
    jmp.d8 L_0051b6d9                            # 0051b6cf
L_0051b6d1:
    # block 0x0051b6d1: entered by jne at 0x0051b6ca, 3 instruction(s), calls USER32.dll!GetMenu, falls into the block at 0x0051b6d9
    push ecx                                     # 0051b6d1
    call dword ptr [0x52a3f4]                    # 0051b6d2
    push eax                                     # 0051b6d8
L_0051b6d9:
    # block 0x0051b6d9: entered by jmp at 0x0051b6cf, 6 instruction(s), calls FUN_0051fa37, FUN_0051b645, ends with je to 0x0051b714 (forward)
    call FUN_0051fa37                            # 0051b6d9
    push dword ptr [esi + field_8]               # 0051b6de
    push eax                                     # 0051b6e1
    call FUN_0051b645                            # 0051b6e2
    test eax, eax                                # 0051b6e7
    je.d8 L_0051b714                             # 0051b6e9
    # block 0x0051b6eb: entered by fall-through of je at 0x0051b6e9, 5 instruction(s), calls indirect dword ptr [edx + 0x10], ends with forward jump to 0x0051b714
    mov edx, dword ptr [eax]                     # 0051b6eb
    push esi                                     # 0051b6ed
    {load} mov ecx, eax                          # 0051b6ee
    call dword ptr [edx + field_10]              # 0051b6f0
    jmp.d8 L_0051b714                            # 0051b6f3
L_0051b6f5:
    # block 0x0051b6f5: entered by jne at 0x0051b6b3, 7 instruction(s), calls FUN_0051c1b5, ends with je to 0x0051b714 (forward)
    mov esi, dword ptr [esi + field_4]           # 0051b6f5
    push 0x1                                     # 0051b6f8
    push esi                                     # 0051b6fa
    push dword ptr [edi + field_1c]              # 0051b6fb
    call FUN_0051c1b5                            # 0051b6fe
    test eax, eax                                # 0051b703
    je.d8 L_0051b714                             # 0051b705
    # block 0x0051b707: entered by fall-through of je at 0x0051b705, 5 instruction(s), calls FUN_0051c4ec, ends with jne to 0x0051b71b (forward)
    push 0x0                                     # 0051b707
    {load} mov ecx, eax                          # 0051b709
    call FUN_0051c4ec                            # 0051b70b
    test eax, eax                                # 0051b710
    jne.d8 L_0051b71b                            # 0051b712
L_0051b714:
    # block 0x0051b714: entered by je at 0x0051b6e9; jmp at 0x0051b6f3; je at 0x0051b705; fall-through of jne at 0x0051b712, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051b71b
    {load} mov ecx, edi                          # 0051b714
    call FUN_0051ab4b                            # 0051b716
L_0051b71b:
    # block 0x0051b71b: entered by jne at 0x0051b712, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0051b71b
    pop esi                                      # 0051b71c
    ret 0x8                                      # 0051b71d

