# FUN_0051e4ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e4ca
# extent:       0x0051e4ca-0x0051e4de (20 code bytes)
# span:         0x0051e4ca-0x0051e4de (code 20, tables 0, padding 0)
# sha256:       5bd31736a256452ba749a962fc0dd1d3f23136fbaa8bfccfcafc5984769ee7b4
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e4ca
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0051c9d3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051c9d3, .text + (0x0051c9d3 - 0x401000)

.org 0x0051e4ca - 0x401000
.globl FUN_0051e4ca
FUN_0051e4ca:
    # block 0x0051e4ca: entry, 5 instruction(s), calls FUN_0051c9d3, ends with ret 0xc
    push dword ptr [esp + stk_c]                 # 0051e4ca
    push dword ptr [esp + stk_c]                 # 0051e4ce
    push dword ptr [esp + stk_c]                 # 0051e4d2
    call FUN_0051c9d3                            # 0051e4d6
    ret 0xc                                      # 0051e4db

