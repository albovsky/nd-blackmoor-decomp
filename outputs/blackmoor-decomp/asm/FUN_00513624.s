# FUN_00513624
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513624
# extent:       0x00513624-0x00513680 (92 code bytes)
# span:         0x00513624-0x00513680 (code 92, tables 0, padding 0)
# sha256:       c971f4fbf81db0d40f7c365c28b16e68fd95a3b1ca5df0419bca88ef2936e267
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0xde)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513624
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90
# callees:      calls tail jump FUN_00513afb, FUN_00513711, tail jump LOC_00513af6, tail jump LOC_00513b98
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x00513629
# note:         unreachable_code_entry:0x0051362d
# note:         unreachable_code_entry:0x00513638
# note:         unreachable_code_entry:0x0051363d
# note:         unreachable_code_entry:0x00513672
# note:         unreachable_code_entry:0x00513679
# note:         further_unindexed_code_at:0x00513680
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------
.set LOC_005135e3, .text + (0x005135e3 - 0x401000)
.set FUN_00513711, .text + (0x00513711 - 0x401000)
.set LOC_00513af6, .text + (0x00513af6 - 0x401000)
.set FUN_00513afb, .text + (0x00513afb - 0x401000)
.set LOC_00513b98, .text + (0x00513b98 - 0x401000)

.org 0x00513624 - 0x401000
.globl FUN_00513624
FUN_00513624:
    # block 0x00513624: entry, 2 instruction(s), ends with jne to 0x0051367b (forward)
    {load} or cl, cl                             # 00513624
    jne.d8 L_0051367b                            # 00513626
    # block 0x00513628: entered by fall-through of jne at 0x00513626, 1 instruction(s), ends with ret
    ret                                          # 00513628
    # block 0x00513629: entered by follows ret at 0x00513628, 2 instruction(s), ends with forward jump to 0x0051362f
    fldlg2                                       # 00513629
    jmp.d8 L_0051362f                            # 0051362b
    # block 0x0051362d: entered by follows jmp at 0x0051362b, 1 instruction(s), falls into the block at 0x0051362f
    fldln2                                       # 0051362d
L_0051362f:
    # block 0x0051362f: entered by jmp at 0x0051362b, 3 instruction(s), ends with jne to 0x005135e3 (backward)
    fxch st(1)                                   # 0051362f
    {load} or cl, cl                             # 00513631
    jne.d8 . + (-80)  # -> LOC_005135e3          # 00513633
    # block 0x00513635: entered by fall-through of jne at 0x00513633, 2 instruction(s), ends with ret
    fyl2x                                        # 00513635
    ret                                          # 00513637
    # block 0x00513638: entered by follows ret at 0x00513637, 1 instruction(s), ends with forward jump to 0x00513afb
    jmp.d32 FUN_00513afb                         # 00513638
    # block 0x0051363d: entered by follows jmp at 0x00513638, 5 instruction(s), calls FUN_00513711, ends with jne to 0x00513658 (forward)
    call FUN_00513711                            # 0051363d
    fstp st(0)                                   # 00513642
    fstp st(0)                                   # 00513644
    {load} or cl, cl                             # 00513646
    jne.d8 L_00513658                            # 00513648
    # block 0x0051364a: entered by fall-through of jne at 0x00513648, 3 instruction(s), ends with jne to 0x00513657 (forward)
    fldz                                         # 0051364a
    cmp eax, 0x1                                 # 0051364c
    jne.d8 L_00513657                            # 0051364f
    # block 0x00513651: entered by fall-through of jne at 0x0051364f, 2 instruction(s), ends with je to 0x00513657 (forward)
    {load} or ch, ch                             # 00513651
    je.d8 L_00513657                             # 00513653
    # block 0x00513655: entered by fall-through of je at 0x00513653, 1 instruction(s), falls into the block at 0x00513657
    fchs                                         # 00513655
L_00513657:
    # block 0x00513657: entered by jne at 0x0051364f; je at 0x00513653; jne at 0x00513668; je at 0x0051366c; more, 1 instruction(s), ends with ret
    ret                                          # 00513657
L_00513658:
    # block 0x00513658: entered by jne at 0x00513648, 4 instruction(s), ends with jne to 0x00513657 (backward)
    mov byte ptr [ebp - field_minus_90], 0x2     # 00513658
    fld tbyte ptr [0x5688b0]                     # 0051365f
    cmp eax, 0x1                                 # 00513665
    jne.d8 L_00513657                            # 00513668
    # block 0x0051366a: entered by fall-through of jne at 0x00513668, 2 instruction(s), ends with je to 0x00513657 (backward)
    {load} or ch, ch                             # 0051366a
    je.d8 L_00513657                             # 0051366c
    # block 0x0051366e: entered by fall-through of je at 0x0051366c, 2 instruction(s), ends with backward jump to 0x00513657
    fchs                                         # 0051366e
    jmp.d8 L_00513657                            # 00513670
    # block 0x00513672: entered by follows jmp at 0x00513670, 2 instruction(s), ends with forward jump to 0x00513af6
    fstp st(0)                                   # 00513672
    jmp.d32 LOC_00513af6                         # 00513674
    # block 0x00513679: entered by follows jmp at 0x00513674, 1 instruction(s), falls into the block at 0x0051367b
    fstp st(0)                                   # 00513679
L_0051367b:
    # block 0x0051367b: entered by jne at 0x00513626, 1 instruction(s), ends with forward jump to 0x00513b98
    jmp.d32 LOC_00513b98                         # 0051367b

