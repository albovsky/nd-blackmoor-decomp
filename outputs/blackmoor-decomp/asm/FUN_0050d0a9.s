# FUN_0050d0a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d0a9
# extent:       0x0050d0a9-0x0050d0bc (19 code bytes)
# span:         0x0050d0a9-0x0050d0bc (code 19, tables 0, padding 0)
# sha256:       009e28bec388b5a3a6c6dd7d876ea8e0b3273502f59125715f63c1dd258be5b6
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d0a9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0050d078
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050d078, .text + (0x0050d078 - 0x401000)

.org 0x0050d0a9 - 0x401000
.globl FUN_0050d0a9
FUN_0050d0a9:
    # block 0x0050d0a9: entry, 6 instruction(s), calls FUN_0050d078, ends with ret
    push 0x40                                    # 0050d0a9
    push dword ptr [esp + stk_c]                 # 0050d0ab
    push dword ptr [esp + stk_c]                 # 0050d0af
    call FUN_0050d078                            # 0050d0b3
    add esp, 0xc                                 # 0050d0b8
    ret                                          # 0050d0bb

