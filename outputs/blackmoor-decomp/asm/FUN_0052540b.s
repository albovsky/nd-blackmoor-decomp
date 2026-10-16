# FUN_0052540b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052540b
# extent:       0x0052540b-0x00525426 (27 code bytes)
# span:         0x0052540b-0x00525426 (code 27, tables 0, padding 0)
# sha256:       ebf0dfea72ee6eedbb8676b44e14d3b5857cc427cc0af2138f0d8fc9bdfb1513
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052540b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525426, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00525426
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00525426, .text + (0x00525426 - 0x401000)
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x0052540b - 0x401000
.globl FUN_0052540b
FUN_0052540b:
    # block 0x0052540b: entry, 5 instruction(s), calls FUN_00525426, ends with je to 0x00525420 (forward)
    push esi                                     # 0052540b
    {load} mov esi, ecx                          # 0052540c
    call FUN_00525426                            # 0052540e
    test byte ptr [esp + stk_8], 0x1             # 00525413
    je.d8 L_00525420                             # 00525418
    # block 0x0052541a: entered by fall-through of je at 0x00525418, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x00525420
    push esi                                     # 0052541a
    call FUN_005256fb                            # 0052541b
L_00525420:
    # block 0x00525420: entered by je at 0x00525418, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00525420
    pop esi                                      # 00525422
    ret 0x4                                      # 00525423

