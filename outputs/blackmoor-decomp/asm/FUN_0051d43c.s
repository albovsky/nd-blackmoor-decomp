# FUN_0051d43c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d43c
# extent:       0x0051d43c-0x0051d44b (15 code bytes)
# span:         0x0051d43c-0x0051d44b (code 15, tables 0, padding 0)
# sha256:       253ba1a442ddcd45dab3810ba785b47fc6d0c1d551839302a2738aa211ce0c13
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d43c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050c604
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051d44b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)

.org 0x0051d43c - 0x401000
.globl FUN_0051d43c
FUN_0051d43c:
    # block 0x0051d43c: entry, 4 instruction(s), calls FUN_0050c604, ends with ret
    push dword ptr [esp + stk_4]                 # 0051d43c
    mov ecx, 0x63c230                            # 0051d440
    call FUN_0050c604                            # 0051d445
    ret                                          # 0051d44a

