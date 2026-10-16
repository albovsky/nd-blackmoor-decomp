# FUN_0051c700
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c700
# extent:       0x0051c700-0x0051c72d (45 code bytes)
# span:         0x0051c700-0x0051c72d (code 45, tables 0, padding 0)
# sha256:       124c8bc589ed0da6ba67f4dacc81e888f24b3535d1ee7363a68e143fb7e4848d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051c618 (+0xe8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c700
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_10
# callees:      calls FUN_0051c519, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051c72d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)

.org 0x0051c700 - 0x401000
.globl FUN_0051c700
FUN_0051c700:
    # block 0x0051c700: entry, 4 instruction(s), ends with je to 0x0051c713 (forward)
    cmp word ptr [esp + stk_4], 0x1              # 0051c700
    push esi                                     # 0051c706
    {load} mov esi, ecx                          # 0051c707
    je.d8 L_0051c713                             # 0051c709
    # block 0x0051c70b: entered by fall-through of je at 0x0051c709, 2 instruction(s), ends with jne to 0x0051c722 (forward)
    cmp word ptr [esp + stk_8], 0x2              # 0051c70b
    jne.d8 L_0051c722                            # 0051c711
L_0051c713:
    # block 0x0051c713: entered by je at 0x0051c709; fall-through of jne at 0x0051c711, 5 instruction(s), calls FUN_0051c519, ends with jne to 0x0051c729 (forward)
    push 0x0                                     # 0051c713
    push dword ptr [esp + stk_10]                # 0051c715
    call FUN_0051c519                            # 0051c719
    test eax, eax                                # 0051c71e
    jne.d8 L_0051c729                            # 0051c720
L_0051c722:
    # block 0x0051c722: entered by jne at 0x0051c711; fall-through of jne at 0x0051c720, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051c729
    {load} mov ecx, esi                          # 0051c722
    call FUN_0051ab4b                            # 0051c724
L_0051c729:
    # block 0x0051c729: entered by jne at 0x0051c720, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051c729
    ret 0x8                                      # 0051c72a

