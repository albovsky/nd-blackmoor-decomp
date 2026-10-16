# FUN_005267f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005267f2
# extent:       0x005267f2-0x005268a7 (181 code bytes)
# span:         0x005267f2-0x005268a7 (code 181, tables 0, padding 0)
# sha256:       b6acba553616e26e5e6f75803f3bbbbbfc89f4cc86bb43b1770a227a8e722cf3
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005267f2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c, field_b8; [edi + n] field_94, field_98; [esi + n] field_5c; [esp + n] stk_14
# callees:      calls FUN_005265e4, FUN_00519a36, FUN_005211ff; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ field_5c, 0x5c  # offset +0x5c
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_00519a36, .text + (0x00519a36 - 0x401000)
.set FUN_005211ff, .text + (0x005211ff - 0x401000)
.set FUN_005265e4, .text + (0x005265e4 - 0x401000)

.org 0x005267f2 - 0x401000
.globl FUN_005267f2
FUN_005267f2:
    # block 0x005267f2: entry, 15 instruction(s), calls FUN_005265e4, falls into the block at 0x0052681c
    push ebx                                     # 005267f2
    push ebp                                     # 005267f3
    push esi                                     # 005267f4
    {load} xor ebp, ebp                          # 005267f5
    push edi                                     # 005267f7
    {load} mov edi, ecx                          # 005267f8
    push ebp                                     # 005267fa
    call FUN_005265e4                            # 005267fb
    mov esi, dword ptr [esp + stk_14]            # 00526800
    mov ecx, dword ptr [edi + field_94]          # 00526804
    mov eax, dword ptr [esi + field_5c]          # 0052680a
    mov dword ptr [eax + field_8], ecx           # 0052680d
    mov eax, dword ptr [esi + field_5c]          # 00526810
    mov ecx, dword ptr [edi + field_98]          # 00526813
    mov dword ptr [eax + field_c], ecx           # 00526819
L_0052681c:
    # block 0x0052681c: entered by je at 0x00526870; jmp at 0x00526884, 6 instruction(s), calls indirect dword ptr [eax + 0xb8], ends with je to 0x00526886 (forward)
    mov eax, dword ptr [esi]                     # 0052681c
    {load} mov ecx, esi                          # 0052681e
    call dword ptr [eax + field_b8]              # 00526820
    {load} mov ebx, eax                          # 00526826
    cmp ebx, 0x1                                 # 00526828
    je.d8 L_00526886                             # 0052682b
    # block 0x0052682d: entered by fall-through of je at 0x0052682b, 2 instruction(s), ends with je to 0x00526886 (forward)
    cmp ebx, 0x2                                 # 0052682d
    je.d8 L_00526886                             # 00526830
    # block 0x00526832: entered by fall-through of je at 0x00526830, 3 instruction(s), calls FUN_00519a36, ends with je to 0x0052684c (forward)
    call FUN_00519a36                            # 00526832
    cmp eax, 0x1009                              # 00526837
    je.d8 L_0052684c                             # 0052683c
    # block 0x0052683e: entered by fall-through of je at 0x0052683c, 2 instruction(s), ends with jbe to 0x0052689e (forward)
    cmp eax, 0x100a                              # 0052683e
    jbe.d8 L_0052689e                            # 00526843
    # block 0x00526845: entered by fall-through of jbe at 0x00526843, 2 instruction(s), ends with ja to 0x0052689e (forward)
    cmp eax, 0x100c                              # 00526845
    ja.d8 L_0052689e                             # 0052684a
L_0052684c:
    # block 0x0052684c: entered by je at 0x0052683c; fall-through of ja at 0x0052684a, 4 instruction(s), ends with je to 0x00526868 (forward)
    mov eax, dword ptr [esi + field_5c]          # 0052684c
    mov eax, dword ptr [eax + field_c]           # 0052684f
    {load} cmp eax, ebp                          # 00526852
    je.d8 L_00526868                             # 00526854
    # block 0x00526856: entered by fall-through of je at 0x00526854, 5 instruction(s), calls FUN_005211ff, falls into the block at 0x00526868
    push eax                                     # 00526856
    call FUN_005211ff                            # 00526857
    mov eax, dword ptr [esi + field_5c]          # 0052685c
    mov dword ptr [eax + field_c], ebp           # 0052685f
    mov dword ptr [edi + field_98], ebp          # 00526862
L_00526868:
    # block 0x00526868: entered by je at 0x00526854, 4 instruction(s), ends with je to 0x0052681c (backward)
    mov eax, dword ptr [esi + field_5c]          # 00526868
    mov eax, dword ptr [eax + field_8]           # 0052686b
    {load} cmp eax, ebp                          # 0052686e
    je.d8 L_0052681c                             # 00526870
    # block 0x00526872: entered by fall-through of je at 0x00526870, 6 instruction(s), calls FUN_005211ff, ends with backward jump to 0x0052681c
    push eax                                     # 00526872
    call FUN_005211ff                            # 00526873
    mov eax, dword ptr [esi + field_5c]          # 00526878
    mov dword ptr [eax + field_8], ebp           # 0052687b
    mov dword ptr [edi + field_94], ebp          # 0052687e
    jmp.d8 L_0052681c                            # 00526884
L_00526886:
    # block 0x00526886: entered by je at 0x0052682b; je at 0x00526830, 6 instruction(s), falls into the block at 0x0052689e
    mov eax, dword ptr [esi + field_5c]          # 00526886
    mov eax, dword ptr [eax + field_8]           # 00526889
    mov dword ptr [edi + field_94], eax          # 0052688c
    mov eax, dword ptr [esi + field_5c]          # 00526892
    mov eax, dword ptr [eax + field_c]           # 00526895
    mov dword ptr [edi + field_98], eax          # 00526898
L_0052689e:
    # block 0x0052689e: entered by jbe at 0x00526843; ja at 0x0052684a, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 0052689e
    pop esi                                      # 0052689f
    {load} mov eax, ebx                          # 005268a0
    pop ebp                                      # 005268a2
    pop ebx                                      # 005268a3
    ret 0x4                                      # 005268a4

