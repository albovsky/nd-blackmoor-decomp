# FUN_00520ace
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ace
# extent:       0x00520ace-0x00520ae3 (21 code bytes)
# span:         0x00520ace-0x00520ae3 (code 21, tables 0, padding 0)
# sha256:       b0d32283bb77585ecebcb178d49b44d464c8bb8f315b344da98a56ac92506975
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ace
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00520a5c, FUN_0051f805
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051f805, .text + (0x0051f805 - 0x401000)
.set FUN_00520a5c, .text + (0x00520a5c - 0x401000)

.org 0x00520ace - 0x401000
.globl FUN_00520ace
FUN_00520ace:
    # block 0x00520ace: entry, 6 instruction(s), calls FUN_00520a5c, FUN_0051f805, ends with ret 0x4
    push 0x1                                     # 00520ace
    call FUN_00520a5c                            # 00520ad0
    {load} mov ecx, eax                          # 00520ad5
    push dword ptr [esp + stk_4]                 # 00520ad7
    call FUN_0051f805                            # 00520adb
    ret 0x4                                      # 00520ae0

