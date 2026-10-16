# FUN_0051fcc6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fcc6
# extent:       0x0051fcc6-0x0051fd7e (184 code bytes)
# span:         0x0051fcc6-0x0051fd7e (code 184, tables 0, padding 0)
# sha256:       f3f87b042c3cf7c05801de2d89f5ffbb5bcc6aa1788fe3ee2a7881f2dbf4e330
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fcc6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_2; [ebx + n] field_2, field_8, field_c, field_10; [edi + n] field_2; [esp + n] stk_8
# callees:      calls FUN_0051fc70, FUN_0050fdc5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050fdc5, .text + (0x0050fdc5 - 0x401000)
.set FUN_0051fc70, .text + (0x0051fc70 - 0x401000)

.org 0x0051fcc6 - 0x401000
.globl FUN_0051fcc6
FUN_0051fcc6:
    # block 0x0051fcc6: entry, 12 instruction(s), calls FUN_0051fc70, ends with jne to 0x0051fced (forward)
    push ebx                                     # 0051fcc6
    mov ebx, dword ptr [esp + stk_8]             # 0051fcc7
    {load} xor eax, eax                          # 0051fccb
    push esi                                     # 0051fccd
    .insn 0x6681/7, dword ptr [ebx + field_2], -1{:s16} # 0051fcce
    push ebx                                     # 0051fcd4
    sete al                                      # 0051fcd5
    {load} mov esi, eax                          # 0051fcd8
    call FUN_0051fc70                            # 0051fcda
    .insn 0x6681/7, dword ptr [ebx + field_2], -1{:s16} # 0051fcdf
    pop ecx                                      # 0051fce5
    jne.d8 L_0051fced                            # 0051fce6
    # block 0x0051fce8: entered by fall-through of jne at 0x0051fce6, 2 instruction(s), ends with forward jump to 0x0051fcef
    mov ecx, dword ptr [ebx + field_c]           # 0051fce8
    jmp.d8 L_0051fcef                            # 0051fceb
L_0051fced:
    # block 0x0051fced: entered by jne at 0x0051fce6, 1 instruction(s), falls into the block at 0x0051fcef
    mov ecx, dword ptr [ebx]                     # 0051fced
L_0051fcef:
    # block 0x0051fcef: entered by jmp at 0x0051fceb, 2 instruction(s), ends with je to 0x0051fd0e (forward)
    test cl, 0x40                                # 0051fcef
    je.d8 L_0051fd0e                             # 0051fcf2
    # block 0x0051fcf4: entered by fall-through of je at 0x0051fcf2, 12 instruction(s), calls FUN_0050fdc5, falls into the block at 0x0051fd0e
    {load} mov ecx, esi                          # 0051fcf4
    push edi                                     # 0051fcf6
    neg ecx                                      # 0051fcf7
    {load} sbb ecx, ecx                          # 0051fcf9
    and ecx, 0x2                                 # 0051fcfb
    inc ecx                                      # 0051fcfe
    lea edi, [eax + 2*ecx]                       # 0051fcff
    push edi                                     # 0051fd02
    call FUN_0050fdc5                            # 0051fd03
    pop ecx                                      # 0051fd08
    lea eax, [edi + 2*eax + field_2]             # 0051fd09
    pop edi                                      # 0051fd0d
L_0051fd0e:
    # block 0x0051fd0e: entered by je at 0x0051fcf2, 2 instruction(s), ends with je to 0x0051fd18 (forward)
    test esi, esi                                # 0051fd0e
    je.d8 L_0051fd18                             # 0051fd10
    # block 0x0051fd12: entered by fall-through of je at 0x0051fd10, 2 instruction(s), ends with forward jump to 0x0051fd1c
    mov cx, word ptr [ebx + field_10]            # 0051fd12
    jmp.d8 L_0051fd1c                            # 0051fd16
L_0051fd18:
    # block 0x0051fd18: entered by je at 0x0051fd10, 1 instruction(s), falls into the block at 0x0051fd1c
    mov cx, word ptr [ebx + field_8]             # 0051fd18
L_0051fd1c:
    # block 0x0051fd1c: entered by jmp at 0x0051fd16, 2 instruction(s), ends with jbe to 0x0051fd79 (forward)
    test cx, cx                                  # 0051fd1c
    jbe.d8 L_0051fd79                            # 0051fd1f
    # block 0x0051fd21: entered by fall-through of jbe at 0x0051fd1f, 5 instruction(s), falls into the block at 0x0051fd2e
    neg esi                                      # 0051fd21
    {load} sbb esi, esi                          # 0051fd23
    and esi, 0x6                                 # 0051fd25
    add esi, 0x12                                # 0051fd28
    movzx edx, cx                                # 0051fd2b
L_0051fd2e:
    # block 0x0051fd2e: entered by jne at 0x0051fd77, 6 instruction(s), ends with jne to 0x0051fd51 (forward)
    add eax, 0x3                                 # 0051fd2e
    and al, -0x4                                 # 0051fd31
    {load} add eax, esi                          # 0051fd33
    mov cx, word ptr [eax]                       # 0051fd35
    .insn 0x6681/7, ecx, -1{:s16}                # 0051fd38
    jne.d8 L_0051fd51                            # 0051fd3d
    # block 0x0051fd3f: entered by fall-through of jne at 0x0051fd3d, 1 instruction(s), falls into the block at 0x0051fd42
    add eax, 0x4                                 # 0051fd3f
L_0051fd42:
    # block 0x0051fd42: entered by je at 0x0051fd57, 3 instruction(s), ends with jne to 0x0051fd60 (forward)
    mov cx, word ptr [eax]                       # 0051fd42
    .insn 0x6681/7, ecx, -1{:s16}                # 0051fd45
    jne.d8 L_0051fd60                            # 0051fd4a
    # block 0x0051fd4c: entered by fall-through of jne at 0x0051fd4a, 2 instruction(s), ends with forward jump to 0x0051fd6f
    add eax, 0x4                                 # 0051fd4c
    jmp.d8 L_0051fd6f                            # 0051fd4f
L_0051fd51:
    # block 0x0051fd51: entered by jne at 0x0051fd3d, 1 instruction(s), falls into the block at 0x0051fd54
    add eax, 0x2                                 # 0051fd51
L_0051fd54:
    # block 0x0051fd54: entered by jmp at 0x0051fd5e, 2 instruction(s), ends with je to 0x0051fd42 (backward)
    test cx, cx                                  # 0051fd54
    je.d8 L_0051fd42                             # 0051fd57
    # block 0x0051fd59: entered by fall-through of je at 0x0051fd57, 4 instruction(s), ends with backward jump to 0x0051fd54
    mov cx, word ptr [eax]                       # 0051fd59
    inc eax                                      # 0051fd5c
    inc eax                                      # 0051fd5d
    jmp.d8 L_0051fd54                            # 0051fd5e
L_0051fd60:
    # block 0x0051fd60: entered by jne at 0x0051fd4a, 1 instruction(s), falls into the block at 0x0051fd63
    add eax, 0x2                                 # 0051fd60
L_0051fd63:
    # block 0x0051fd63: entered by jmp at 0x0051fd6d, 2 instruction(s), ends with je to 0x0051fd6f (forward)
    test cx, cx                                  # 0051fd63
    je.d8 L_0051fd6f                             # 0051fd66
    # block 0x0051fd68: entered by fall-through of je at 0x0051fd66, 4 instruction(s), ends with backward jump to 0x0051fd63
    mov cx, word ptr [eax]                       # 0051fd68
    inc eax                                      # 0051fd6b
    inc eax                                      # 0051fd6c
    jmp.d8 L_0051fd63                            # 0051fd6d
L_0051fd6f:
    # block 0x0051fd6f: entered by jmp at 0x0051fd4f; je at 0x0051fd66, 4 instruction(s), ends with jne to 0x0051fd2e (backward)
    movzx ecx, word ptr [eax]                    # 0051fd6f
    dec edx                                      # 0051fd72
    lea eax, [eax + ecx + field_2]               # 0051fd73
    jne.d8 L_0051fd2e                            # 0051fd77
L_0051fd79:
    # block 0x0051fd79: entered by jbe at 0x0051fd1f; fall-through of jne at 0x0051fd77, 4 instruction(s), ends with ret
    {load} sub eax, ebx                          # 0051fd79
    pop esi                                      # 0051fd7b
    pop ebx                                      # 0051fd7c
    ret                                          # 0051fd7d

