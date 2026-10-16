# FUN_0051fc70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fc70
# extent:       0x0051fc70-0x0051fcc6 (86 code bytes)
# span:         0x0051fc70-0x0051fcc6 (code 86, tables 0, padding 0)
# sha256:       92aefee5a609c98533f6413e28a748b93b48b60ab2a92c6aba29616a0a723672
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fc70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_2; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0051fc70 - 0x401000
.globl FUN_0051fc70
FUN_0051fc70:
    # block 0x0051fc70: entry, 3 instruction(s), ends with jne to 0x0051fc81 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051fc70
    .insn 0x6681/7, dword ptr [eax + field_2], -1{:s16} # 0051fc74
    jne.d8 L_0051fc81                            # 0051fc7a
    # block 0x0051fc7c: entered by fall-through of jne at 0x0051fc7a, 2 instruction(s), ends with forward jump to 0x0051fc84
    add eax, 0x1a                                # 0051fc7c
    jmp.d8 L_0051fc84                            # 0051fc7f
L_0051fc81:
    # block 0x0051fc81: entered by jne at 0x0051fc7a, 1 instruction(s), falls into the block at 0x0051fc84
    add eax, 0x12                                # 0051fc81
L_0051fc84:
    # block 0x0051fc84: entered by jmp at 0x0051fc7f, 5 instruction(s), ends with jne to 0x0051fca3 (forward)
    mov cx, word ptr [eax]                       # 0051fc84
    push 0x2                                     # 0051fc87
    .insn 0x6681/7, ecx, -1{:s16}                # 0051fc89
    pop edx                                      # 0051fc8e
    jne.d8 L_0051fca3                            # 0051fc8f
    # block 0x0051fc91: entered by fall-through of jne at 0x0051fc8f, 1 instruction(s), falls into the block at 0x0051fc94
    add eax, 0x4                                 # 0051fc91
L_0051fc94:
    # block 0x0051fc94: entered by je at 0x0051fca8, 3 instruction(s), ends with jne to 0x0051fcaf (forward)
    mov cx, word ptr [eax]                       # 0051fc94
    .insn 0x6681/7, ecx, -1{:s16}                # 0051fc97
    jne.d8 L_0051fcaf                            # 0051fc9c
    # block 0x0051fc9e: entered by fall-through of jne at 0x0051fc9c, 2 instruction(s), ends with forward jump to 0x0051fcbb
    add eax, 0x4                                 # 0051fc9e
    jmp.d8 L_0051fcbb                            # 0051fca1
L_0051fca3:
    # block 0x0051fca3: entered by jne at 0x0051fc8f; jmp at 0x0051fcad, 3 instruction(s), ends with je to 0x0051fc94 (backward)
    {load} add eax, edx                          # 0051fca3
    test cx, cx                                  # 0051fca5
    je.d8 L_0051fc94                             # 0051fca8
    # block 0x0051fcaa: entered by fall-through of je at 0x0051fca8, 2 instruction(s), ends with backward jump to 0x0051fca3
    mov cx, word ptr [eax]                       # 0051fcaa
    jmp.d8 L_0051fca3                            # 0051fcad
L_0051fcaf:
    # block 0x0051fcaf: entered by jne at 0x0051fc9c; jmp at 0x0051fcb9, 3 instruction(s), ends with je to 0x0051fcbb (forward)
    {load} add eax, edx                          # 0051fcaf
    test cx, cx                                  # 0051fcb1
    je.d8 L_0051fcbb                             # 0051fcb4
    # block 0x0051fcb6: entered by fall-through of je at 0x0051fcb4, 2 instruction(s), ends with backward jump to 0x0051fcaf
    mov cx, word ptr [eax]                       # 0051fcb6
    jmp.d8 L_0051fcaf                            # 0051fcb9
L_0051fcbb:
    # block 0x0051fcbb: entered by jmp at 0x0051fca1; je at 0x0051fcb4; jne at 0x0051fcc3, 4 instruction(s), ends with jne to 0x0051fcbb (backward)
    mov cx, word ptr [eax]                       # 0051fcbb
    {load} add eax, edx                          # 0051fcbe
    test cx, cx                                  # 0051fcc0
    jne.d8 L_0051fcbb                            # 0051fcc3
    # block 0x0051fcc5: entered by fall-through of jne at 0x0051fcc3, 1 instruction(s), ends with ret
    ret                                          # 0051fcc5

