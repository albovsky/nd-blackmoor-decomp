# FUN_00525545
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525545
# extent:       0x00525545-0x00525565 (32 code bytes)
# span:         0x00525545-0x00525565 (code 32, tables 0, padding 0)
# sha256:       532271a34da27e344b78e8408b46c13485506baf4789af53163ba31500d9881f
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525545
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525565, FUN_0050c604
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)
.set FUN_00525565, .text + (0x00525565 - 0x401000)

.org 0x00525545 - 0x401000
.globl FUN_00525545
FUN_00525545:
    # block 0x00525545: entry, 5 instruction(s), calls FUN_00525565, ends with je to 0x0052555f (forward)
    push esi                                     # 00525545
    {load} mov esi, ecx                          # 00525546
    call FUN_00525565                            # 00525548
    test byte ptr [esp + stk_8], 0x1             # 0052554d
    je.d8 L_0052555f                             # 00525552
    # block 0x00525554: entered by fall-through of je at 0x00525552, 3 instruction(s), calls FUN_0050c604, falls into the block at 0x0052555f
    push esi                                     # 00525554
    mov ecx, 0x63c580                            # 00525555
    call FUN_0050c604                            # 0052555a
L_0052555f:
    # block 0x0052555f: entered by je at 0x00525552, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0052555f
    pop esi                                      # 00525561
    ret 0x4                                      # 00525562

