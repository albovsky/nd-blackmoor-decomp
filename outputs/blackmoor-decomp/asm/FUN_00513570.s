# FUN_00513570
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513570
# extent:       0x00513570-0x005135e8 (120 code bytes)
# span:         0x00513570-0x005135e8 (code 120, tables 0, padding 0)
# sha256:       475d1ad536bdac170f5cfa5db95d5c76790a88f3e753e72b393adb61d08a164c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x2a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513570
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_9f
# callees:      calls FUN_005136ce, FUN_00518261, tail jump LOC_00513ae8, FUN_00513711, tail jump FUN_00513afb, tail jump FUN_00513b96
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x00513581
# note:         unreachable_code_entry:0x005135de
# note:         further_unindexed_code_at:0x005135e8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_9f, 0x9f  # offset -0x9f

# --- external targets -----------------------------------------------
.set FUN_005136ce, .text + (0x005136ce - 0x401000)
.set FUN_00513711, .text + (0x00513711 - 0x401000)
.set LOC_00513ae8, .text + (0x00513ae8 - 0x401000)
.set FUN_00513afb, .text + (0x00513afb - 0x401000)
.set FUN_00513b96, .text + (0x00513b96 - 0x401000)
.set FUN_00518261, .text + (0x00518261 - 0x401000)

.org 0x00513570 - 0x401000
.globl FUN_00513570
FUN_00513570:
    # block 0x00513570: entry, 3 instruction(s), ends with jne to 0x005135c6 (forward)
    mov byte ptr [ebp - field_minus_90], -0x2    # 00513570
    {load} or ch, ch                             # 00513577
    jne.d8 L_005135c6                            # 00513579
    # block 0x0051357b: entered by fall-through of jne at 0x00513579, 1 instruction(s), falls into the block at 0x0051357d
    fxch st(1)                                   # 0051357b
L_0051357d:
    # block 0x0051357d: entered by jmp at 0x005135dc, 2 instruction(s), ends with forward jump to 0x0051358e
    fyl2x                                        # 0051357d
    jmp.d8 L_0051358e                            # 0051357f
    # block 0x00513581: entered by follows jmp at 0x0051357f, 4 instruction(s), falls into the block at 0x0051358e
    mov byte ptr [ebp - field_minus_90], -0x2    # 00513581
    {load} xor ch, ch                            # 00513588
    fldl2e                                       # 0051358a
    fmulp st(1), st                              # 0051358c
L_0051358e:
    # block 0x0051358e: entered by jmp at 0x0051357f, 5 instruction(s), calls FUN_005136ce, ends with je to 0x005135b4 (forward)
    call FUN_005136ce                            # 0051358e
    fld1                                         # 00513593
    faddp st(1), st                              # 00513595
    test byte ptr [ebp - field_minus_9f], 0x1    # 00513597
    je.d8 L_005135b4                             # 0051359e
    # block 0x005135a0: entered by fall-through of je at 0x0051359e, 3 instruction(s), ends with je to 0x005135af (forward)
    fld1                                         # 005135a0
    cmp dword ptr [0x63ca08], 0x1                # 005135a2
    je.d8 L_005135af                             # 005135a9
    # block 0x005135ab: entered by fall-through of je at 0x005135a9, 2 instruction(s), ends with forward jump to 0x005135b4
    fdivrp st(1), st                             # 005135ab
    jmp.d8 L_005135b4                            # 005135ad
L_005135af:
    # block 0x005135af: entered by je at 0x005135a9, 1 instruction(s), calls FUN_00518261, falls into the block at 0x005135b4
    call FUN_00518261                            # 005135af
L_005135b4:
    # block 0x005135b4: entered by je at 0x0051359e; jmp at 0x005135ad, 2 instruction(s), ends with jne to 0x005135bb (forward)
    test dl, 0x40                                # 005135b4
    jne.d8 L_005135bb                            # 005135b7
    # block 0x005135b9: entered by fall-through of jne at 0x005135b7, 1 instruction(s), falls into the block at 0x005135bb
    fscale                                       # 005135b9
L_005135bb:
    # block 0x005135bb: entered by jne at 0x005135b7, 2 instruction(s), ends with je to 0x005135c1 (forward)
    {load} or ch, ch                             # 005135bb
    je.d8 L_005135c1                             # 005135bd
    # block 0x005135bf: entered by fall-through of je at 0x005135bd, 1 instruction(s), falls into the block at 0x005135c1
    fchs                                         # 005135bf
L_005135c1:
    # block 0x005135c1: entered by je at 0x005135bd, 1 instruction(s), ends with forward jump to 0x00513ae8
    jmp.d32 LOC_00513ae8                         # 005135c1
L_005135c6:
    # block 0x005135c6: entered by jne at 0x00513579, 3 instruction(s), calls FUN_00513711, ends with je to 0x005135e3 (forward)
    call FUN_00513711                            # 005135c6
    {load} or eax, eax                           # 005135cb
    je.d8 L_005135e3                             # 005135cd
    # block 0x005135cf: entered by fall-through of je at 0x005135cd, 3 instruction(s), ends with je to 0x005135d8 (forward)
    {load} xor ch, ch                            # 005135cf
    cmp eax, 0x2                                 # 005135d1
    je.d8 L_005135d8                             # 005135d4
    # block 0x005135d6: entered by fall-through of je at 0x005135d4, 1 instruction(s), falls into the block at 0x005135d8
    not ch                                       # 005135d6
L_005135d8:
    # block 0x005135d8: entered by je at 0x005135d4, 3 instruction(s), ends with backward jump to 0x0051357d
    fxch st(1)                                   # 005135d8
    fabs                                         # 005135da
    jmp.d8 L_0051357d                            # 005135dc
    # block 0x005135de: entered by follows jmp at 0x005135dc, 1 instruction(s), ends with forward jump to 0x00513afb
    jmp.d32 FUN_00513afb                         # 005135de
L_005135e3:
    # block 0x005135e3: entered by je at 0x005135cd, 1 instruction(s), ends with forward jump to 0x00513b96
    jmp.d32 FUN_00513b96                         # 005135e3

