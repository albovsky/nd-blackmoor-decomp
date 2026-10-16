# FUN_0051f067
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f067
# extent:       0x0051f067-0x0051f0e2 (123 code bytes)
# span:         0x0051f067-0x0051f0e2 (code 123, tables 0, padding 0)
# sha256:       d10d1167aa192eb6b4b9856ac09d4549e7a2acf96247784e4787b0cfd147fcf0
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f067
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10, field_14, field_28; [ebx + n] field_4, field_8, field_c; [esi + n] field_4; [esp + n] stk_10, stk_14, stk_18
# callees:      calls FUN_0051b9a3; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0051b9a3, .text + (0x0051b9a3 - 0x401000)

.org 0x0051f067 - 0x401000
.globl FUN_0051f067
FUN_0051f067:
    # block 0x0051f067: entry, 12 instruction(s), calls indirect dword ptr [eax + 0x28], ends with je to 0x0051f0d8 (forward)
    push ecx                                     # 0051f067
    mov eax, dword ptr [ecx]                     # 0051f068
    push ebx                                     # 0051f06a
    push ebp                                     # 0051f06b
    push esi                                     # 0051f06c
    push edi                                     # 0051f06d
    mov dword ptr [esp + stk_10], ecx            # 0051f06e
    call dword ptr [eax + field_28]              # 0051f072
    {load} mov esi, eax                          # 0051f075
    {load} xor ebp, ebp                          # 0051f077
    {load} cmp esi, ebp                          # 0051f079
    je.d8 L_0051f0d8                             # 0051f07b
    # block 0x0051f07d: entered by fall-through of je at 0x0051f07b, 2 instruction(s), falls into the block at 0x0051f086
    mov ebx, dword ptr [esp + stk_18]            # 0051f07d
    mov edi, 0xc000                              # 0051f081
L_0051f086:
    # block 0x0051f086: entered by jne at 0x0051f0a0, 3 instruction(s), ends with jae to 0x0051f0a4 (forward)
    mov eax, dword ptr [ebx + field_4]           # 0051f086
    {load} cmp eax, edi                          # 0051f089
    jae.d8 L_0051f0a4                            # 0051f08b
    # block 0x0051f08d: entered by fall-through of jae at 0x0051f08b, 7 instruction(s), calls FUN_0051b9a3, ends with jne to 0x0051f0c6 (forward)
    push ebp                                     # 0051f08d
    push ebp                                     # 0051f08e
    push eax                                     # 0051f08f
    push dword ptr [esi + field_4]               # 0051f090
    call FUN_0051b9a3                            # 0051f093
    {load} cmp eax, ebp                          # 0051f098
    jne.d8 L_0051f0c6                            # 0051f09a
L_0051f09c:
    # block 0x0051f09c: entered by je at 0x0051f0b2; fall-through of jne at 0x0051f09a, 3 instruction(s), ends with jne to 0x0051f086 (backward)
    mov esi, dword ptr [esi]                     # 0051f09c
    {load} cmp esi, ebp                          # 0051f09e
    jne.d8 L_0051f086                            # 0051f0a0
    # block 0x0051f0a2: entered by fall-through of jne at 0x0051f0a0, 1 instruction(s), ends with forward jump to 0x0051f0d8
    jmp.d8 L_0051f0d8                            # 0051f0a2
L_0051f0a4:
    # block 0x0051f0a4: entered by jae at 0x0051f08b, 4 instruction(s), falls into the block at 0x0051f0aa
    mov eax, dword ptr [esi + field_4]           # 0051f0a4
    push ebp                                     # 0051f0a7
    push ebp                                     # 0051f0a8
    push edi                                     # 0051f0a9
L_0051f0aa:
    # block 0x0051f0aa: entered by jmp at 0x0051f0c4, 4 instruction(s), calls FUN_0051b9a3, ends with je to 0x0051f09c (backward)
    push eax                                     # 0051f0aa
    call FUN_0051b9a3                            # 0051f0ab
    {load} cmp eax, ebp                          # 0051f0b0
    je.d8 L_0051f09c                             # 0051f0b2
    # block 0x0051f0b4: entered by fall-through of je at 0x0051f0b2, 4 instruction(s), ends with je to 0x0051f0c6 (forward)
    mov ecx, dword ptr [eax + field_10]          # 0051f0b4
    mov ecx, dword ptr [ecx]                     # 0051f0b7
    cmp ecx, dword ptr [ebx + field_4]           # 0051f0b9
    je.d8 L_0051f0c6                             # 0051f0bc
    # block 0x0051f0be: entered by fall-through of je at 0x0051f0bc, 5 instruction(s), ends with backward jump to 0x0051f0aa
    push ebp                                     # 0051f0be
    push ebp                                     # 0051f0bf
    push edi                                     # 0051f0c0
    add eax, 0x18                                # 0051f0c1
    jmp.d8 L_0051f0aa                            # 0051f0c4
L_0051f0c6:
    # block 0x0051f0c6: entered by jne at 0x0051f09a; je at 0x0051f0bc, 7 instruction(s), calls indirect dword ptr [eax + 0x14], ends with forward jump to 0x0051f0da
    push dword ptr [ebx + field_c]               # 0051f0c6
    mov ecx, dword ptr [esp + stk_14]            # 0051f0c9
    push dword ptr [ebx + field_8]               # 0051f0cd
    call dword ptr [eax + field_14]              # 0051f0d0
    push 0x1                                     # 0051f0d3
    pop eax                                      # 0051f0d5
    jmp.d8 L_0051f0da                            # 0051f0d6
L_0051f0d8:
    # block 0x0051f0d8: entered by je at 0x0051f07b; jmp at 0x0051f0a2, 1 instruction(s), falls into the block at 0x0051f0da
    {load} xor eax, eax                          # 0051f0d8
L_0051f0da:
    # block 0x0051f0da: entered by jmp at 0x0051f0d6, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 0051f0da
    pop esi                                      # 0051f0db
    pop ebp                                      # 0051f0dc
    pop ebx                                      # 0051f0dd
    pop ecx                                      # 0051f0de
    ret 0x4                                      # 0051f0df

