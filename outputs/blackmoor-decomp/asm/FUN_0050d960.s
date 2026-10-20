# FUN_0050d960
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d960
# extent:       0x0050d960-0x0050da5e (254 code bytes)
# span:         0x0050d960-0x0050da60 (code 254, tables 0, padding 2)
# sha256:       0318574df8288c6fc0e543c779d4c1098344731f9acf2a7c790c2176ab7bdf4c
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         _strncpy
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (host_libc_standard_contract, function-ledger-overrides.json not_needed_entries)
# name-note:    copies up to count bytes, pads remainder with NULs, returns dest; word-optimised
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_10, stk_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 109 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0050d960 - 0x401000
.globl FUN_0050d960
FUN_0050d960:
    # block 0x0050d960: entry, 4 instruction(s), ends with je to 0x0050d9e3 (forward)
    mov ecx, dword ptr [esp + stk_c]             # 0050d960
    push edi                                     # 0050d964
    test ecx, ecx                                # 0050d965
    je.d8 L_0050d9e3                             # 0050d967
    # block 0x0050d969: entered by fall-through of je at 0x0050d967, 7 instruction(s), ends with jne to 0x0050d984 (forward)
    push esi                                     # 0050d969
    push ebx                                     # 0050d96a
    {load} mov ebx, ecx                          # 0050d96b
    mov esi, dword ptr [esp + stk_14]            # 0050d96d
    test esi, 0x3                                # 0050d971
    mov edi, dword ptr [esp + stk_10]            # 0050d977
    jne.d8 L_0050d984                            # 0050d97b
    # block 0x0050d97d: entered by fall-through of jne at 0x0050d97b, 2 instruction(s), ends with jne to 0x0050d9f1 (forward)
    shr ecx, 0x2                                 # 0050d97d
    jne.d8 L_0050d9f1                            # 0050d980
    # block 0x0050d982: entered by fall-through of jne at 0x0050d980, 1 instruction(s), ends with forward jump to 0x0050d9a5
    jmp.d8 L_0050d9a5                            # 0050d982
L_0050d984:
    # block 0x0050d984: entered by jne at 0x0050d97b; jne at 0x0050d997, 6 instruction(s), ends with je to 0x0050d9b2 (forward)
    mov al, byte ptr [esi]                       # 0050d984
    inc esi                                      # 0050d986
    mov byte ptr [edi], al                       # 0050d987
    inc edi                                      # 0050d989
    dec ecx                                      # 0050d98a
    je.d8 L_0050d9b2                             # 0050d98b
    # block 0x0050d98d: entered by fall-through of je at 0x0050d98b, 2 instruction(s), ends with je to 0x0050d9ba (forward)
    test al, al                                  # 0050d98d
    je.d8 L_0050d9ba                             # 0050d98f
    # block 0x0050d991: entered by fall-through of je at 0x0050d98f, 2 instruction(s), ends with jne to 0x0050d984 (backward)
    test esi, 0x3                                # 0050d991
    jne.d8 L_0050d984                            # 0050d997
    # block 0x0050d999: entered by fall-through of jne at 0x0050d997, 3 instruction(s), ends with jne to 0x0050d9f1 (forward)
    {load} mov ebx, ecx                          # 0050d999
    shr ecx, 0x2                                 # 0050d99b
    jne.d8 L_0050d9f1                            # 0050d99e
L_0050d9a0:
    # block 0x0050d9a0: entered by je at 0x0050d9ef; fall-through of jne at 0x0050d99e, 2 instruction(s), ends with je to 0x0050d9b2 (forward)
    and ebx, 0x3                                 # 0050d9a0
    je.d8 L_0050d9b2                             # 0050d9a3
L_0050d9a5:
    # block 0x0050d9a5: entered by jmp at 0x0050d982; jne at 0x0050d9b0; fall-through of je at 0x0050d9a3, 6 instruction(s), ends with je to 0x0050d9de (forward)
    mov al, byte ptr [esi]                       # 0050d9a5
    inc esi                                      # 0050d9a7
    mov byte ptr [edi], al                       # 0050d9a8
    inc edi                                      # 0050d9aa
    test al, al                                  # 0050d9ab
    je.d8 L_0050d9de                             # 0050d9ad
    # block 0x0050d9af: entered by fall-through of je at 0x0050d9ad, 2 instruction(s), ends with jne to 0x0050d9a5 (backward)
    dec ebx                                      # 0050d9af
    jne.d8 L_0050d9a5                            # 0050d9b0
L_0050d9b2:
    # block 0x0050d9b2: entered by je at 0x0050d98b; je at 0x0050d9a3; fall-through of jne at 0x0050d9b0, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_10]            # 0050d9b2
    pop ebx                                      # 0050d9b6
    pop esi                                      # 0050d9b7
    pop edi                                      # 0050d9b8
    ret                                          # 0050d9b9
L_0050d9ba:
    # block 0x0050d9ba: entered by je at 0x0050d98f, 2 instruction(s), ends with je to 0x0050d9d4 (forward)
    test edi, 0x3                                # 0050d9ba
    je.d8 L_0050d9d4                             # 0050d9c0
L_0050d9c2:
    # block 0x0050d9c2: entered by jne at 0x0050d9d2; fall-through of je at 0x0050d9c0, 4 instruction(s), ends with je to 0x0050da56 (forward)
    mov byte ptr [edi], al                       # 0050d9c2
    inc edi                                      # 0050d9c4
    dec ecx                                      # 0050d9c5
    je.d32 L_0050da56                            # 0050d9c6
    # block 0x0050d9cc: entered by fall-through of je at 0x0050d9c6, 2 instruction(s), ends with jne to 0x0050d9c2 (backward)
    test edi, 0x3                                # 0050d9cc
    jne.d8 L_0050d9c2                            # 0050d9d2
L_0050d9d4:
    # block 0x0050d9d4: entered by je at 0x0050d9c0; fall-through of jne at 0x0050d9d2, 3 instruction(s), ends with jne to 0x0050da47 (forward)
    {load} mov ebx, ecx                          # 0050d9d4
    shr ecx, 0x2                                 # 0050d9d6
    jne.d8 L_0050da47                            # 0050d9d9
L_0050d9db:
    # block 0x0050d9db: entered by jne at 0x0050d9df; jne at 0x0050da54; fall-through of jne at 0x0050d9d9, 2 instruction(s), falls into the block at 0x0050d9de
    mov byte ptr [edi], al                       # 0050d9db
    inc edi                                      # 0050d9dd
L_0050d9de:
    # block 0x0050d9de: entered by je at 0x0050d9ad, 2 instruction(s), ends with jne to 0x0050d9db (backward)
    dec ebx                                      # 0050d9de
    jne.d8 L_0050d9db                            # 0050d9df
    # block 0x0050d9e1: entered by fall-through of jne at 0x0050d9df, 2 instruction(s), falls into the block at 0x0050d9e3
    pop ebx                                      # 0050d9e1
    pop esi                                      # 0050d9e2
L_0050d9e3:
    # block 0x0050d9e3: entered by je at 0x0050d967, 3 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_8]             # 0050d9e3
    pop edi                                      # 0050d9e7
    ret                                          # 0050d9e8
L_0050d9e9:
    # block 0x0050d9e9: entered by je at 0x0050da09; jne at 0x0050da21, 4 instruction(s), ends with je to 0x0050d9a0 (backward)
    mov dword ptr [edi], edx                     # 0050d9e9
    add edi, 0x4                                 # 0050d9eb
    dec ecx                                      # 0050d9ee
    je.d8 L_0050d9a0                             # 0050d9ef
L_0050d9f1:
    # block 0x0050d9f1: entered by jne at 0x0050d980; jne at 0x0050d99e; fall-through of je at 0x0050d9ef, 9 instruction(s), ends with je to 0x0050d9e9 (backward)
    mov edx, 0x7efefeff                          # 0050d9f1
    mov eax, dword ptr [esi]                     # 0050d9f6
    {load} add edx, eax                          # 0050d9f8
    xor eax, -0x1                                # 0050d9fa
    {load} xor eax, edx                          # 0050d9fd
    mov edx, dword ptr [esi]                     # 0050d9ff
    add esi, 0x4                                 # 0050da01
    test eax, 0x81010100                         # 0050da04
    je.d8 L_0050d9e9                             # 0050da09
    # block 0x0050da0b: entered by fall-through of je at 0x0050da09, 2 instruction(s), ends with je to 0x0050da3b (forward)
    test dl, dl                                  # 0050da0b
    je.d8 L_0050da3b                             # 0050da0d
    # block 0x0050da0f: entered by fall-through of je at 0x0050da0d, 2 instruction(s), ends with je to 0x0050da31 (forward)
    test dh, dh                                  # 0050da0f
    je.d8 L_0050da31                             # 0050da11
    # block 0x0050da13: entered by fall-through of je at 0x0050da11, 2 instruction(s), ends with je to 0x0050da27 (forward)
    test edx, 0xff0000                           # 0050da13
    je.d8 L_0050da27                             # 0050da19
    # block 0x0050da1b: entered by fall-through of je at 0x0050da19, 2 instruction(s), ends with jne to 0x0050d9e9 (backward)
    test edx, 0xff000000                         # 0050da1b
    jne.d8 L_0050d9e9                            # 0050da21
    # block 0x0050da23: entered by fall-through of jne at 0x0050da21, 2 instruction(s), ends with forward jump to 0x0050da3f
    mov dword ptr [edi], edx                     # 0050da23
    jmp.d8 L_0050da3f                            # 0050da25
L_0050da27:
    # block 0x0050da27: entered by je at 0x0050da19, 3 instruction(s), ends with forward jump to 0x0050da3f
    and edx, 0xffff                              # 0050da27
    mov dword ptr [edi], edx                     # 0050da2d
    jmp.d8 L_0050da3f                            # 0050da2f
L_0050da31:
    # block 0x0050da31: entered by je at 0x0050da11, 3 instruction(s), ends with forward jump to 0x0050da3f
    and edx, 0xff                                # 0050da31
    mov dword ptr [edi], edx                     # 0050da37
    jmp.d8 L_0050da3f                            # 0050da39
L_0050da3b:
    # block 0x0050da3b: entered by je at 0x0050da0d, 2 instruction(s), falls into the block at 0x0050da3f
    {load} xor edx, edx                          # 0050da3b
    mov dword ptr [edi], edx                     # 0050da3d
L_0050da3f:
    # block 0x0050da3f: entered by jmp at 0x0050da25; jmp at 0x0050da2f; jmp at 0x0050da39, 4 instruction(s), ends with je to 0x0050da51 (forward)
    add edi, 0x4                                 # 0050da3f
    {load} xor eax, eax                          # 0050da42
    dec ecx                                      # 0050da44
    je.d8 L_0050da51                             # 0050da45
L_0050da47:
    # block 0x0050da47: entered by jne at 0x0050d9d9; fall-through of je at 0x0050da45, 1 instruction(s), falls into the block at 0x0050da49
    {load} xor eax, eax                          # 0050da47
L_0050da49:
    # block 0x0050da49: entered by jne at 0x0050da4f, 4 instruction(s), ends with jne to 0x0050da49 (backward)
    mov dword ptr [edi], eax                     # 0050da49
    add edi, 0x4                                 # 0050da4b
    dec ecx                                      # 0050da4e
    jne.d8 L_0050da49                            # 0050da4f
L_0050da51:
    # block 0x0050da51: entered by je at 0x0050da45; fall-through of jne at 0x0050da4f, 2 instruction(s), ends with jne to 0x0050d9db (backward)
    and ebx, 0x3                                 # 0050da51
    jne.d8 L_0050d9db                            # 0050da54
L_0050da56:
    # block 0x0050da56: entered by je at 0x0050d9c6; fall-through of jne at 0x0050da54, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_10]            # 0050da56
    pop ebx                                      # 0050da5a
    pop esi                                      # 0050da5b
    pop edi                                      # 0050da5c
    ret                                          # 0050da5d

# --- data items (not part of the function) -------------------------
.org 0x0050da5e - 0x401000
PAD_0050da5e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

