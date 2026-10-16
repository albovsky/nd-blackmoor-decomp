# FUN_00513030
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513030
# extent:       0x00513030-0x005130ec (188 code bytes)
# span:         0x00513030-0x005130f0 (code 188, tables 0, padding 4)
# sha256:       6979c6178f67a389b905ed0e7c5328630a49bc83d5660fb2758fd6de07864049
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513030
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_1, field_minus_2, field_minus_3, field_minus_4; [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_3, 0x3  # offset -0x3
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00513020, .text + (0x00513020 - 0x401000)

.org 0x00513030 - 0x401000
.globl FUN_00513030
FUN_00513030:
    # block 0x00513030: entry, 8 instruction(s), ends with je to 0x0051305b (forward)
    {load} xor eax, eax                          # 00513030
    mov al, byte ptr [esp + stk_8]               # 00513032
    push ebx                                     # 00513036
    {load} mov ebx, eax                          # 00513037
    shl eax, 0x8                                 # 00513039
    mov edx, dword ptr [esp + stk_8]             # 0051303c
    test edx, 0x3                                # 00513040
    je.d8 L_0051305b                             # 00513046
L_00513048:
    # block 0x00513048: entered by jne at 0x00513059; fall-through of je at 0x00513046, 4 instruction(s), ends with je to 0x00513020 (backward)
    mov cl, byte ptr [edx]                       # 00513048
    inc edx                                      # 0051304a
    {store} cmp cl, bl                           # 0051304b
    je.d8 . + (-45)  # -> FUN_00513020           # 0051304d
    # block 0x0051304f: entered by fall-through of je at 0x0051304d, 2 instruction(s), ends with je to 0x005130a4 (forward)
    test cl, cl                                  # 0051304f
    je.d8 L_005130a4                             # 00513051
    # block 0x00513053: entered by fall-through of je at 0x00513051, 2 instruction(s), ends with jne to 0x00513048 (backward)
    test edx, 0x3                                # 00513053
    jne.d8 L_00513048                            # 00513059
L_0051305b:
    # block 0x0051305b: entered by je at 0x00513046; fall-through of jne at 0x00513059, 6 instruction(s), falls into the block at 0x00513066
    {load} or ebx, eax                           # 0051305b
    push edi                                     # 0051305d
    {load} mov eax, ebx                          # 0051305e
    shl ebx, 0x10                                # 00513060
    push esi                                     # 00513063
    {load} or ebx, eax                           # 00513064
L_00513066:
    # block 0x00513066: entered by je at 0x00513091; jne at 0x005130a0; jmp at 0x005130ce, 14 instruction(s), ends with jne to 0x005130a8 (forward)
    mov ecx, dword ptr [edx]                     # 00513066
    mov edi, 0x7efefeff                          # 00513068
    {load} mov eax, ecx                          # 0051306d
    {load} mov esi, edi                          # 0051306f
    {load} xor ecx, ebx                          # 00513071
    {load} add esi, eax                          # 00513073
    {load} add edi, ecx                          # 00513075
    xor ecx, -0x1                                # 00513077
    xor eax, -0x1                                # 0051307a
    {load} xor ecx, edi                          # 0051307d
    {load} xor eax, esi                          # 0051307f
    add edx, 0x4                                 # 00513081
    and ecx, 0x81010100                          # 00513084
    jne.d8 L_005130a8                            # 0051308a
    # block 0x0051308c: entered by fall-through of jne at 0x0051308a, 2 instruction(s), ends with je to 0x00513066 (backward)
    and eax, 0x81010100                          # 0051308c
    je.d8 L_00513066                             # 00513091
    # block 0x00513093: entered by fall-through of je at 0x00513091, 2 instruction(s), ends with jne to 0x005130a2 (forward)
    and eax, 0x1010100                           # 00513093
    jne.d8 L_005130a2                            # 00513098
    # block 0x0051309a: entered by fall-through of jne at 0x00513098, 2 instruction(s), ends with jne to 0x00513066 (backward)
    and esi, 0x80000000                          # 0051309a
    jne.d8 L_00513066                            # 005130a0
L_005130a2:
    # block 0x005130a2: entered by jne at 0x00513098; je at 0x005130b1; je at 0x005130b9; je at 0x005130c4; more, 2 instruction(s), falls into the block at 0x005130a4
    pop esi                                      # 005130a2
    pop edi                                      # 005130a3
L_005130a4:
    # block 0x005130a4: entered by je at 0x00513051, 3 instruction(s), ends with ret
    pop ebx                                      # 005130a4
    {load} xor eax, eax                          # 005130a5
    ret                                          # 005130a7
L_005130a8:
    # block 0x005130a8: entered by jne at 0x0051308a, 3 instruction(s), ends with je to 0x005130e5 (forward)
    mov eax, dword ptr [edx - field_minus_4]     # 005130a8
    {store} cmp al, bl                           # 005130ab
    je.d8 L_005130e5                             # 005130ad
    # block 0x005130af: entered by fall-through of je at 0x005130ad, 2 instruction(s), ends with je to 0x005130a2 (backward)
    test al, al                                  # 005130af
    je.d8 L_005130a2                             # 005130b1
    # block 0x005130b3: entered by fall-through of je at 0x005130b1, 2 instruction(s), ends with je to 0x005130de (forward)
    {store} cmp ah, bl                           # 005130b3
    je.d8 L_005130de                             # 005130b5
    # block 0x005130b7: entered by fall-through of je at 0x005130b5, 2 instruction(s), ends with je to 0x005130a2 (backward)
    test ah, ah                                  # 005130b7
    je.d8 L_005130a2                             # 005130b9
    # block 0x005130bb: entered by fall-through of je at 0x005130b9, 3 instruction(s), ends with je to 0x005130d7 (forward)
    shr eax, 0x10                                # 005130bb
    {store} cmp al, bl                           # 005130be
    je.d8 L_005130d7                             # 005130c0
    # block 0x005130c2: entered by fall-through of je at 0x005130c0, 2 instruction(s), ends with je to 0x005130a2 (backward)
    test al, al                                  # 005130c2
    je.d8 L_005130a2                             # 005130c4
    # block 0x005130c6: entered by fall-through of je at 0x005130c4, 2 instruction(s), ends with je to 0x005130d0 (forward)
    {store} cmp ah, bl                           # 005130c6
    je.d8 L_005130d0                             # 005130c8
    # block 0x005130ca: entered by fall-through of je at 0x005130c8, 2 instruction(s), ends with je to 0x005130a2 (backward)
    test ah, ah                                  # 005130ca
    je.d8 L_005130a2                             # 005130cc
    # block 0x005130ce: entered by fall-through of je at 0x005130cc, 1 instruction(s), ends with backward jump to 0x00513066
    jmp.d8 L_00513066                            # 005130ce
L_005130d0:
    # block 0x005130d0: entered by je at 0x005130c8, 5 instruction(s), ends with ret
    pop esi                                      # 005130d0
    pop edi                                      # 005130d1
    lea eax, [edx - field_minus_1]               # 005130d2
    pop ebx                                      # 005130d5
    ret                                          # 005130d6
L_005130d7:
    # block 0x005130d7: entered by je at 0x005130c0, 5 instruction(s), ends with ret
    lea eax, [edx - field_minus_2]               # 005130d7
    pop esi                                      # 005130da
    pop edi                                      # 005130db
    pop ebx                                      # 005130dc
    ret                                          # 005130dd
L_005130de:
    # block 0x005130de: entered by je at 0x005130b5, 5 instruction(s), ends with ret
    lea eax, [edx - field_minus_3]               # 005130de
    pop esi                                      # 005130e1
    pop edi                                      # 005130e2
    pop ebx                                      # 005130e3
    ret                                          # 005130e4
L_005130e5:
    # block 0x005130e5: entered by je at 0x005130ad, 5 instruction(s), ends with ret
    lea eax, [edx - field_minus_4]               # 005130e5
    pop esi                                      # 005130e8
    pop edi                                      # 005130e9
    pop ebx                                      # 005130ea
    ret                                          # 005130eb

# --- data items (not part of the function) -------------------------
.org 0x005130ec - 0x401000
PAD_005130ec:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

