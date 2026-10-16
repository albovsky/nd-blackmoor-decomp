# FUN_0051fa37
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fa37
# extent:       0x0051fa37-0x0051fa4c (21 code bytes)
# span:         0x0051fa37-0x0051fa4c (code 21, tables 0, padding 0)
# sha256:       a7812f89a7eae6db216c2e218a8341f62c7dc1b8470874a841b2116bb6fd285a
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fa37
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051f9c5, FUN_0051f805
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051f805, .text + (0x0051f805 - 0x401000)
.set FUN_0051f9c5, .text + (0x0051f9c5 - 0x401000)

.org 0x0051fa37 - 0x401000
.globl FUN_0051fa37
FUN_0051fa37:
    # block 0x0051fa37: entry, 6 instruction(s), calls FUN_0051f9c5, FUN_0051f805, ends with ret 0x4
    push 0x1                                     # 0051fa37
    call FUN_0051f9c5                            # 0051fa39
    {load} mov ecx, eax                          # 0051fa3e
    push dword ptr [esp + stk_4]                 # 0051fa40
    call FUN_0051f805                            # 0051fa44
    ret 0x4                                      # 0051fa49

