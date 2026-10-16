# FUN_0050eb20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050eb20
# extent:       0x0050eb20-0x0050ebca (170 code bytes)
# span:         0x0050eb20-0x0050ebca (code 170, tables 0, padding 0)
# sha256:       8964dcf0d769cb61dd4354feac00491ae8c1b34eb9627a4c5ec2d4350243d395
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050eb20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14, stk_18, stk_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 70 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x0050eb20 - 0x401000
.globl FUN_0050eb20
FUN_0050eb20:
    # block 0x0050eb20: entry, 7 instruction(s), ends with jge to 0x0050eb41 (forward)
    push edi                                     # 0050eb20
    push esi                                     # 0050eb21
    push ebx                                     # 0050eb22
    {load} xor edi, edi                          # 0050eb23
    mov eax, dword ptr [esp + stk_14]            # 0050eb25
    {load} or eax, eax                           # 0050eb29
    jge.d8 L_0050eb41                            # 0050eb2b
    # block 0x0050eb2d: entered by fall-through of jge at 0x0050eb2b, 7 instruction(s), falls into the block at 0x0050eb41
    inc edi                                      # 0050eb2d
    mov edx, dword ptr [esp + stk_10]            # 0050eb2e
    neg eax                                      # 0050eb32
    neg edx                                      # 0050eb34
    sbb eax, 0x0                                 # 0050eb36
    mov dword ptr [esp + stk_14], eax            # 0050eb39
    mov dword ptr [esp + stk_10], edx            # 0050eb3d
L_0050eb41:
    # block 0x0050eb41: entered by jge at 0x0050eb2b, 3 instruction(s), ends with jge to 0x0050eb5d (forward)
    mov eax, dword ptr [esp + stk_1c]            # 0050eb41
    {load} or eax, eax                           # 0050eb45
    jge.d8 L_0050eb5d                            # 0050eb47
    # block 0x0050eb49: entered by fall-through of jge at 0x0050eb47, 7 instruction(s), falls into the block at 0x0050eb5d
    inc edi                                      # 0050eb49
    mov edx, dword ptr [esp + stk_18]            # 0050eb4a
    neg eax                                      # 0050eb4e
    neg edx                                      # 0050eb50
    sbb eax, 0x0                                 # 0050eb52
    mov dword ptr [esp + stk_1c], eax            # 0050eb55
    mov dword ptr [esp + stk_18], edx            # 0050eb59
L_0050eb5d:
    # block 0x0050eb5d: entered by jge at 0x0050eb47, 2 instruction(s), ends with jne to 0x0050eb79 (forward)
    {load} or eax, eax                           # 0050eb5d
    jne.d8 L_0050eb79                            # 0050eb5f
    # block 0x0050eb61: entered by fall-through of jne at 0x0050eb5f, 9 instruction(s), ends with forward jump to 0x0050ebba
    mov ecx, dword ptr [esp + stk_18]            # 0050eb61
    mov eax, dword ptr [esp + stk_14]            # 0050eb65
    {load} xor edx, edx                          # 0050eb69
    div ecx                                      # 0050eb6b
    {load} mov ebx, eax                          # 0050eb6d
    mov eax, dword ptr [esp + stk_10]            # 0050eb6f
    div ecx                                      # 0050eb73
    {load} mov edx, ebx                          # 0050eb75
    jmp.d8 L_0050ebba                            # 0050eb77
L_0050eb79:
    # block 0x0050eb79: entered by jne at 0x0050eb5f, 4 instruction(s), falls into the block at 0x0050eb87
    {load} mov ebx, eax                          # 0050eb79
    mov ecx, dword ptr [esp + stk_18]            # 0050eb7b
    mov edx, dword ptr [esp + stk_14]            # 0050eb7f
    mov eax, dword ptr [esp + stk_10]            # 0050eb83
L_0050eb87:
    # block 0x0050eb87: entered by jne at 0x0050eb91, 6 instruction(s), ends with jne to 0x0050eb87 (backward)
    shr ebx                                      # 0050eb87
    rcr ecx                                      # 0050eb89
    shr edx                                      # 0050eb8b
    rcr eax                                      # 0050eb8d
    {load} or ebx, ebx                           # 0050eb8f
    jne.d8 L_0050eb87                            # 0050eb91
    # block 0x0050eb93: entered by fall-through of jne at 0x0050eb91, 8 instruction(s), ends with jb to 0x0050ebb5 (forward)
    div ecx                                      # 0050eb93
    {load} mov esi, eax                          # 0050eb95
    mul dword ptr [esp + stk_1c]                 # 0050eb97
    {load} mov ecx, eax                          # 0050eb9b
    mov eax, dword ptr [esp + stk_18]            # 0050eb9d
    mul esi                                      # 0050eba1
    {load} add edx, ecx                          # 0050eba3
    jb.d8 L_0050ebb5                             # 0050eba5
    # block 0x0050eba7: entered by fall-through of jb at 0x0050eba5, 2 instruction(s), ends with ja to 0x0050ebb5 (forward)
    cmp edx, dword ptr [esp + stk_14]            # 0050eba7
    ja.d8 L_0050ebb5                             # 0050ebab
    # block 0x0050ebad: entered by fall-through of ja at 0x0050ebab, 1 instruction(s), ends with jb to 0x0050ebb6 (forward)
    jb.d8 L_0050ebb6                             # 0050ebad
    # block 0x0050ebaf: entered by fall-through of jb at 0x0050ebad, 2 instruction(s), ends with jbe to 0x0050ebb6 (forward)
    cmp eax, dword ptr [esp + stk_10]            # 0050ebaf
    jbe.d8 L_0050ebb6                            # 0050ebb3
L_0050ebb5:
    # block 0x0050ebb5: entered by jb at 0x0050eba5; ja at 0x0050ebab; fall-through of jbe at 0x0050ebb3, 1 instruction(s), falls into the block at 0x0050ebb6
    dec esi                                      # 0050ebb5
L_0050ebb6:
    # block 0x0050ebb6: entered by jb at 0x0050ebad; jbe at 0x0050ebb3, 2 instruction(s), falls into the block at 0x0050ebba
    {load} xor edx, edx                          # 0050ebb6
    {load} mov eax, esi                          # 0050ebb8
L_0050ebba:
    # block 0x0050ebba: entered by jmp at 0x0050eb77, 2 instruction(s), ends with jne to 0x0050ebc4 (forward)
    dec edi                                      # 0050ebba
    jne.d8 L_0050ebc4                            # 0050ebbb
    # block 0x0050ebbd: entered by fall-through of jne at 0x0050ebbb, 3 instruction(s), falls into the block at 0x0050ebc4
    neg edx                                      # 0050ebbd
    neg eax                                      # 0050ebbf
    sbb edx, 0x0                                 # 0050ebc1
L_0050ebc4:
    # block 0x0050ebc4: entered by jne at 0x0050ebbb, 4 instruction(s), ends with ret 0x10
    pop ebx                                      # 0050ebc4
    pop esi                                      # 0050ebc5
    pop edi                                      # 0050ebc6
    ret 0x10                                     # 0050ebc7

