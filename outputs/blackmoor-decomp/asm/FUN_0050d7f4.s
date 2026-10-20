# FUN_0050d7f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d7f4
# extent:       0x0050d7f4-0x0050d805 (17 code bytes)
# span:         0x0050d7f4-0x0050d805 (code 17, tables 0, padding 0)
# sha256:       31edc6767b84a1158fd0fefb34a560e6e471692367a9dccb231a54eb79bd2b49
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __exit
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0050d805
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050d805, .text + (0x0050d805 - 0x401000)

.org 0x0050d7f4 - 0x401000
.globl FUN_0050d7f4
FUN_0050d7f4:
    # block 0x0050d7f4: entry, 6 instruction(s), calls FUN_0050d805, ends with ret
    push 0x0                                     # 0050d7f4
    push 0x1                                     # 0050d7f6
    push dword ptr [esp + stk_c]                 # 0050d7f8
    call FUN_0050d805                            # 0050d7fc
    add esp, 0xc                                 # 0050d801
    ret                                          # 0050d804

