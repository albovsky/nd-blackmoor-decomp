# FUN_0050d4f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d4f5
# extent:       0x0050d4f5-0x0050d505 (16 code bytes)
# span:         0x0050d4f5-0x0050d505 (code 16, tables 0, padding 0)
# sha256:       9b6bdc1d22c794ddf022ae0f55d019b6d6cd1843ad7c985d42d127de06207f93
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d4f5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050d4ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d4ba, .text + (0x0050d4ba - 0x401000)

.org 0x0050d4f5 - 0x401000
.globl FUN_0050d4f5
FUN_0050d4f5:
    # block 0x0050d4f5: entry, 6 instruction(s), calls FUN_0050d4ba, ends with ret
    push dword ptr [esp + stk_8]                 # 0050d4f5
    push dword ptr [esp + stk_8]                 # 0050d4f9
    call FUN_0050d4ba                            # 0050d4fd
    pop ecx                                      # 0050d502
    pop ecx                                      # 0050d503
    ret                                          # 0050d504

