# FUN_0050d8e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d8e0
# extent:       0x0050d8e0-0x0050d960 (128 code bytes)
# span:         0x0050d8e0-0x0050d960 (code 128, tables 0, padding 0)
# sha256:       0e57c264402a5e0f775d1750865c32ee2dbe4cba1166bae788432bb49277c7e2
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d8e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1, field_2, field_3; [edi + n] field_minus_1; [esi + n] field_minus_1; [esp + n] stk_8, stk_10, stk_14
# callees:      calls tail jump LOC_00513036
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set LOC_00513036, .text + (0x00513036 - 0x401000)

.org 0x0050d8e0 - 0x401000
.globl FUN_0050d8e0
FUN_0050d8e0:
    # block 0x0050d8e0: entry, 8 instruction(s), ends with je to 0x0050d95a (forward)
    mov ecx, dword ptr [esp + stk_8]             # 0050d8e0
    push edi                                     # 0050d8e4
    push ebx                                     # 0050d8e5
    push esi                                     # 0050d8e6
    mov dl, byte ptr [ecx]                       # 0050d8e7
    mov edi, dword ptr [esp + stk_10]            # 0050d8e9
    test dl, dl                                  # 0050d8ed
    je.d8 L_0050d95a                             # 0050d8ef
    # block 0x0050d8f1: entered by fall-through of je at 0x0050d8ef, 3 instruction(s), ends with je to 0x0050d947 (forward)
    mov dh, byte ptr [ecx + field_1]             # 0050d8f1
    test dh, dh                                  # 0050d8f4
    je.d8 L_0050d947                             # 0050d8f6
L_0050d8f8:
    # block 0x0050d8f8: entered by jne at 0x0050d932; jmp at 0x0050d945; fall-through of je at 0x0050d8f6, 6 instruction(s), ends with je to 0x0050d91a (forward)
    {load} mov esi, edi                          # 0050d8f8
    mov ecx, dword ptr [esp + stk_14]            # 0050d8fa
    mov al, byte ptr [edi]                       # 0050d8fe
    inc esi                                      # 0050d900
    {store} cmp al, dl                           # 0050d901
    je.d8 L_0050d91a                             # 0050d903
    # block 0x0050d905: entered by fall-through of je at 0x0050d903, 2 instruction(s), ends with je to 0x0050d914 (forward)
    test al, al                                  # 0050d905
    je.d8 L_0050d914                             # 0050d907
L_0050d909:
    # block 0x0050d909: entered by jne at 0x0050d912; fall-through of je at 0x0050d907, 2 instruction(s), falls into the block at 0x0050d90c
    mov al, byte ptr [esi]                       # 0050d909
    inc esi                                      # 0050d90b
L_0050d90c:
    # block 0x0050d90c: entered by jne at 0x0050d91f, 2 instruction(s), ends with je to 0x0050d91a (forward)
    {store} cmp al, dl                           # 0050d90c
    je.d8 L_0050d91a                             # 0050d90e
    # block 0x0050d910: entered by fall-through of je at 0x0050d90e, 2 instruction(s), ends with jne to 0x0050d909 (backward)
    test al, al                                  # 0050d910
    jne.d8 L_0050d909                            # 0050d912
L_0050d914:
    # block 0x0050d914: entered by je at 0x0050d907; fall-through of jne at 0x0050d912, 5 instruction(s), ends with ret
    pop esi                                      # 0050d914
    pop ebx                                      # 0050d915
    pop edi                                      # 0050d916
    {load} xor eax, eax                          # 0050d917
    ret                                          # 0050d919
L_0050d91a:
    # block 0x0050d91a: entered by je at 0x0050d903; je at 0x0050d90e, 4 instruction(s), ends with jne to 0x0050d90c (backward)
    mov al, byte ptr [esi]                       # 0050d91a
    inc esi                                      # 0050d91c
    {store} cmp al, dh                           # 0050d91d
    jne.d8 L_0050d90c                            # 0050d91f
    # block 0x0050d921: entered by fall-through of jne at 0x0050d91f, 1 instruction(s), falls into the block at 0x0050d924
    lea edi, [esi - field_minus_1]               # 0050d921
L_0050d924:
    # block 0x0050d924: entered by je at 0x0050d943, 3 instruction(s), ends with je to 0x0050d953 (forward)
    mov ah, byte ptr [ecx + field_2]             # 0050d924
    test ah, ah                                  # 0050d927
    je.d8 L_0050d953                             # 0050d929
    # block 0x0050d92b: entered by fall-through of je at 0x0050d929, 4 instruction(s), ends with jne to 0x0050d8f8 (backward)
    mov al, byte ptr [esi]                       # 0050d92b
    add esi, 0x2                                 # 0050d92d
    {store} cmp al, ah                           # 0050d930
    jne.d8 L_0050d8f8                            # 0050d932
    # block 0x0050d934: entered by fall-through of jne at 0x0050d932, 3 instruction(s), ends with je to 0x0050d953 (forward)
    mov al, byte ptr [ecx + field_3]             # 0050d934
    test al, al                                  # 0050d937
    je.d8 L_0050d953                             # 0050d939
    # block 0x0050d93b: entered by fall-through of je at 0x0050d939, 4 instruction(s), ends with je to 0x0050d924 (backward)
    mov ah, byte ptr [esi - field_minus_1]       # 0050d93b
    add ecx, 0x2                                 # 0050d93e
    {store} cmp al, ah                           # 0050d941
    je.d8 L_0050d924                             # 0050d943
    # block 0x0050d945: entered by fall-through of je at 0x0050d943, 1 instruction(s), ends with backward jump to 0x0050d8f8
    jmp.d8 L_0050d8f8                            # 0050d945
L_0050d947:
    # block 0x0050d947: entered by je at 0x0050d8f6, 6 instruction(s), ends with forward jump to 0x00513036
    {load} xor eax, eax                          # 0050d947
    pop esi                                      # 0050d949
    pop ebx                                      # 0050d94a
    pop edi                                      # 0050d94b
    {load} mov al, dl                            # 0050d94c
    jmp.d32 LOC_00513036                         # 0050d94e
L_0050d953:
    # block 0x0050d953: entered by je at 0x0050d929; je at 0x0050d939, 5 instruction(s), ends with ret
    lea eax, [edi - field_minus_1]               # 0050d953
    pop esi                                      # 0050d956
    pop ebx                                      # 0050d957
    pop edi                                      # 0050d958
    ret                                          # 0050d959
L_0050d95a:
    # block 0x0050d95a: entered by je at 0x0050d8ef, 5 instruction(s), ends with ret
    {load} mov eax, edi                          # 0050d95a
    pop esi                                      # 0050d95c
    pop ebx                                      # 0050d95d
    pop edi                                      # 0050d95e
    ret                                          # 0050d95f

