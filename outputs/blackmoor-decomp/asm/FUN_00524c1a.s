# FUN_00524c1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524c1a
# extent:       0x00524c1a-0x00524c35 (27 code bytes)
# span:         0x00524c1a-0x00524c35 (code 27, tables 0, padding 0)
# sha256:       9ac383ab25eca51a5bde3f306569da6bea7ac0a9906232d1e2f62456a8720562
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524c1a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525cda, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)
.set FUN_00525cda, .text + (0x00525cda - 0x401000)

.org 0x00524c1a - 0x401000
.globl FUN_00524c1a
FUN_00524c1a:
    # block 0x00524c1a: entry, 5 instruction(s), calls FUN_00525cda, ends with je to 0x00524c2f (forward)
    push esi                                     # 00524c1a
    {load} mov esi, ecx                          # 00524c1b
    call FUN_00525cda                            # 00524c1d
    test byte ptr [esp + stk_8], 0x1             # 00524c22
    je.d8 L_00524c2f                             # 00524c27
    # block 0x00524c29: entered by fall-through of je at 0x00524c27, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x00524c2f
    push esi                                     # 00524c29
    call FUN_005256fb                            # 00524c2a
L_00524c2f:
    # block 0x00524c2f: entered by je at 0x00524c27, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00524c2f
    pop esi                                      # 00524c31
    ret 0x4                                      # 00524c32

