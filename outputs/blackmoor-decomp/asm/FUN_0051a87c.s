# FUN_0051a87c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a87c
# extent:       0x0051a87c-0x0051a896 (26 code bytes)
# span:         0x0051a87c-0x0051a896 (code 26, tables 0, padding 0)
# sha256:       ad6d83ced7f0e14aba8ff7ce1c2c5cc52a83618dc6ac7791c656b9991d1dc348
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a87c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14
# callees:      calls FUN_0051a82d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051a82d, .text + (0x0051a82d - 0x401000)

.org 0x0051a87c - 0x401000
.globl FUN_0051a87c
FUN_0051a87c:
    # block 0x0051a87c: entry, 7 instruction(s), calls FUN_0051a82d, ends with ret 0x10
    push dword ptr [esp + stk_10]                # 0051a87c
    push dword ptr [esp + stk_10]                # 0051a880
    push dword ptr [esp + stk_10]                # 0051a884
    push -0x10                                   # 0051a888
    push dword ptr [esp + stk_14]                # 0051a88a
    call FUN_0051a82d                            # 0051a88e
    ret 0x10                                     # 0051a893

