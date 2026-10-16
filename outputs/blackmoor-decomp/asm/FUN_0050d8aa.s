# FUN_0050d8aa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d8aa
# extent:       0x0050d8aa-0x0050d8b3 (9 code bytes)
# span:         0x0050d8aa-0x0050d8b3 (code 9, tables 0, padding 0)
# sha256:       ab3c623893561e8306f38a446b1495076ece40c33f6761660086f8b5bd33704c
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d8aa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00512c18
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)

.org 0x0050d8aa - 0x401000
.globl FUN_0050d8aa
FUN_0050d8aa:
    # block 0x0050d8aa: entry, 4 instruction(s), calls FUN_00512c18, ends with ret
    push 0xd                                     # 0050d8aa
    call FUN_00512c18                            # 0050d8ac
    pop ecx                                      # 0050d8b1
    ret                                          # 0050d8b2

