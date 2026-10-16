# FUN_0051c618
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c618
# extent:       0x0051c618-0x0051c700 (232 code bytes)
# span:         0x0051c618-0x0051c700 (code 232, tables 0, padding 0)
# sha256:       bd81c4fea66e68fa0ba968ac3fe207e3ceb044975e93dba6a7cc8c7bf0129d7a
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c618
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_8
# callees:      calls FUN_0051d862, FUN_0051ba27
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051c700
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051ba27, .text + (0x0051ba27 - 0x401000)
.set FUN_0051d862, .text + (0x0051d862 - 0x401000)

.org 0x0051c618 - 0x401000
.globl FUN_0051c618
FUN_0051c618:
    # block 0x0051c618: entry, 8 instruction(s), ends with ja to 0x0051c697 (forward)
    push ebp                                     # 0051c618
    {load} mov ebp, esp                          # 0051c619
    sub esp, 0xc                                 # 0051c61b
    mov eax, dword ptr [ebp + arg_8]             # 0051c61e
    mov edx, 0x111                               # 0051c621
    {load} cmp eax, edx                          # 0051c626
    push esi                                     # 0051c628
    ja.d8 L_0051c697                             # 0051c629
    # block 0x0051c62b: entered by fall-through of ja at 0x0051c629, 1 instruction(s), ends with je to 0x0051c66f (forward)
    je.d8 L_0051c66f                             # 0051c62b
    # block 0x0051c62d: entered by fall-through of je at 0x0051c62b, 2 instruction(s), ends with jb to 0x0051c6c2 (forward)
    cmp eax, 0x2b                                # 0051c62d
    jb.d32 L_0051c6c2                            # 0051c630
    # block 0x0051c636: entered by fall-through of jb at 0x0051c630, 2 instruction(s), ends with jbe to 0x0051c6ac (forward)
    cmp eax, 0x2f                                # 0051c636
    jbe.d8 L_0051c6ac                            # 0051c639
    # block 0x0051c63b: entered by fall-through of jbe at 0x0051c639, 2 instruction(s), ends with je to 0x0051c6ac (forward)
    cmp eax, 0x39                                # 0051c63b
    je.d8 L_0051c6ac                             # 0051c63e
    # block 0x0051c640: entered by fall-through of je at 0x0051c63e, 2 instruction(s), ends with jne to 0x0051c6c2 (forward)
    cmp eax, 0x4e                                # 0051c640
    jne.d8 L_0051c6c2                            # 0051c643
    # block 0x0051c645: entered by fall-through of jne at 0x0051c643, 15 instruction(s), calls FUN_0051d862, ends with forward jump to 0x0051c6fb
    mov eax, dword ptr [ebp + arg_10]            # 0051c645
    mov esi, dword ptr [ebp + arg_14]            # 0051c648
    mov dword ptr [ebp - local_8], esi           # 0051c64b
    mov dword ptr [ebp - local_4], eax           # 0051c64e
    mov edx, dword ptr [eax + field_8]           # 0051c651
    {load} xor esi, esi                          # 0051c654
    lea eax, [ebp - local_8]                     # 0051c656
    push esi                                     # 0051c659
    push eax                                     # 0051c65a
    movzx eax, dx                                # 0051c65b
    or eax, 0xbc4e0000                           # 0051c65e
    push eax                                     # 0051c663
    push esi                                     # 0051c664
    call FUN_0051d862                            # 0051c665
    jmp.d32 L_0051c6fb                           # 0051c66a
L_0051c66f:
    # block 0x0051c66f: entered by je at 0x0051c62b, 11 instruction(s), calls FUN_0051d862, ends with je to 0x0051c6f9 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 0051c66f
    {load} xor esi, esi                          # 0051c672
    shr eax, 0x10                                # 0051c674
    push esi                                     # 0051c677
    or eax, 0xbd110000                           # 0051c678
    push esi                                     # 0051c67d
    push eax                                     # 0051c67e
    push esi                                     # 0051c67f
    call FUN_0051d862                            # 0051c680
    test eax, eax                                # 0051c685
    je.d8 L_0051c6f9                             # 0051c687
    # block 0x0051c689: entered by fall-through of je at 0x0051c687, 5 instruction(s), ends with je to 0x0051c6fb (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 0051c689
    push 0x1                                     # 0051c68c
    {load} cmp ecx, esi                          # 0051c68e
    pop eax                                      # 0051c690
    je.d8 L_0051c6fb                             # 0051c691
    # block 0x0051c693: entered by fall-through of je at 0x0051c691, 2 instruction(s), ends with forward jump to 0x0051c6fb
    mov dword ptr [ecx], eax                     # 0051c693
    jmp.d8 L_0051c6fb                            # 0051c695
L_0051c697:
    # block 0x0051c697: entered by ja at 0x0051c629, 2 instruction(s), ends with jb to 0x0051c6c2 (forward)
    cmp eax, 0x114                               # 0051c697
    jb.d8 L_0051c6c2                             # 0051c69c
    # block 0x0051c69e: entered by fall-through of jb at 0x0051c69c, 2 instruction(s), ends with jbe to 0x0051c6ac (forward)
    cmp eax, 0x115                               # 0051c69e
    jbe.d8 L_0051c6ac                            # 0051c6a3
    # block 0x0051c6a5: entered by fall-through of jbe at 0x0051c6a3, 2 instruction(s), ends with jne to 0x0051c6c2 (forward)
    cmp eax, 0x210                               # 0051c6a5
    jne.d8 L_0051c6c2                            # 0051c6aa
L_0051c6ac:
    # block 0x0051c6ac: entered by jbe at 0x0051c639; je at 0x0051c63e; jbe at 0x0051c6a3; fall-through of jne at 0x0051c6aa, 7 instruction(s), calls FUN_0051ba27, ends with forward jump to 0x0051c6fb
    push dword ptr [ebp + arg_14]                # 0051c6ac
    add eax, 0xbc00                              # 0051c6af
    push dword ptr [ebp + arg_10]                # 0051c6b4
    push dword ptr [ebp + arg_c]                 # 0051c6b7
    push eax                                     # 0051c6ba
    call FUN_0051ba27                            # 0051c6bb
    jmp.d8 L_0051c6fb                            # 0051c6c0
L_0051c6c2:
    # block 0x0051c6c2: entered by jb at 0x0051c630; jne at 0x0051c643; jb at 0x0051c69c; jne at 0x0051c6aa, 2 instruction(s), ends with jb to 0x0051c6f9 (forward)
    cmp eax, 0x132                               # 0051c6c2
    jb.d8 L_0051c6f9                             # 0051c6c7
    # block 0x0051c6c9: entered by fall-through of jb at 0x0051c6c7, 2 instruction(s), ends with ja to 0x0051c6f9 (forward)
    cmp eax, 0x138                               # 0051c6c9
    ja.d8 L_0051c6f9                             # 0051c6ce
    # block 0x0051c6d0: entered by fall-through of ja at 0x0051c6ce, 16 instruction(s), calls FUN_0051ba27, ends with jne to 0x0051c6fb (forward)
    mov edx, dword ptr [ebp + arg_c]             # 0051c6d0
    add eax, 0xfffffece                          # 0051c6d3
    push edi                                     # 0051c6d8
    mov edi, dword ptr [ebp + arg_14]            # 0051c6d9
    mov dword ptr [ebp - local_4], eax           # 0051c6dc
    lea eax, [ebp - local_c]                     # 0051c6df
    push edi                                     # 0051c6e2
    {load} xor esi, esi                          # 0051c6e3
    push eax                                     # 0051c6e5
    push esi                                     # 0051c6e6
    push 0xbc19                                  # 0051c6e7
    mov dword ptr [ebp - local_8], edx           # 0051c6ec
    call FUN_0051ba27                            # 0051c6ef
    cmp dword ptr [edi], esi                     # 0051c6f4
    pop edi                                      # 0051c6f6
    jne.d8 L_0051c6fb                            # 0051c6f7
L_0051c6f9:
    # block 0x0051c6f9: entered by je at 0x0051c687; jb at 0x0051c6c7; ja at 0x0051c6ce; fall-through of jne at 0x0051c6f7, 1 instruction(s), falls into the block at 0x0051c6fb
    {load} xor eax, eax                          # 0051c6f9
L_0051c6fb:
    # block 0x0051c6fb: entered by jmp at 0x0051c66a; je at 0x0051c691; jmp at 0x0051c695; jmp at 0x0051c6c0; more, 3 instruction(s), ends with ret 0x10
    pop esi                                      # 0051c6fb
    leave                                        # 0051c6fc
    ret 0x10                                     # 0051c6fd

