# FUN_00525a01
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525a01
# extent:       0x00525a01-0x00525a1c (27 code bytes)
# span:         0x00525a01-0x00525a1c (code 27, tables 0, padding 0)
# sha256:       4ed68751699697413feac7e816691498657cd040b618ded5b04107daf6d93a6b
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525a01
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525a1c, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)
.set FUN_00525a1c, .text + (0x00525a1c - 0x401000)

.org 0x00525a01 - 0x401000
.globl FUN_00525a01
FUN_00525a01:
    # block 0x00525a01: entry, 5 instruction(s), calls FUN_00525a1c, ends with je to 0x00525a16 (forward)
    push esi                                     # 00525a01
    {load} mov esi, ecx                          # 00525a02
    call FUN_00525a1c                            # 00525a04
    test byte ptr [esp + stk_8], 0x1             # 00525a09
    je.d8 L_00525a16                             # 00525a0e
    # block 0x00525a10: entered by fall-through of je at 0x00525a0e, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x00525a16
    push esi                                     # 00525a10
    call FUN_005256fb                            # 00525a11
L_00525a16:
    # block 0x00525a16: entered by je at 0x00525a0e, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00525a16
    pop esi                                      # 00525a18
    ret 0x4                                      # 00525a19

