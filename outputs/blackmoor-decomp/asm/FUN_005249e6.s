# FUN_005249e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005249e6
# extent:       0x005249e6-0x00524a01 (27 code bytes)
# span:         0x005249e6-0x00524a01 (code 27, tables 0, padding 0)
# sha256:       45bdc15db5245f34331578af17e306647ab02208c18a70a453eaa1ccf8f40e74
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005249e6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525c99, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)
.set FUN_00525c99, .text + (0x00525c99 - 0x401000)

.org 0x005249e6 - 0x401000
.globl FUN_005249e6
FUN_005249e6:
    # block 0x005249e6: entry, 5 instruction(s), calls FUN_00525c99, ends with je to 0x005249fb (forward)
    push esi                                     # 005249e6
    {load} mov esi, ecx                          # 005249e7
    call FUN_00525c99                            # 005249e9
    test byte ptr [esp + stk_8], 0x1             # 005249ee
    je.d8 L_005249fb                             # 005249f3
    # block 0x005249f5: entered by fall-through of je at 0x005249f3, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x005249fb
    push esi                                     # 005249f5
    call FUN_005256fb                            # 005249f6
L_005249fb:
    # block 0x005249fb: entered by je at 0x005249f3, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 005249fb
    pop esi                                      # 005249fd
    ret 0x4                                      # 005249fe

