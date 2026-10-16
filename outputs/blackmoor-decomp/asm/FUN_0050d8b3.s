# FUN_0050d8b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d8b3
# extent:       0x0050d8b3-0x0050d8bc (9 code bytes)
# span:         0x0050d8b3-0x0050d8bc (code 9, tables 0, padding 0)
# sha256:       b020235a04e2f874cb46c2f71e1d2d47bd17dfc1b94bf8b072efd3f13c62f3c4
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d8b3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0050d8b3 - 0x401000
.globl FUN_0050d8b3
FUN_0050d8b3:
    # block 0x0050d8b3: entry, 4 instruction(s), calls FUN_00512c79, ends with ret
    push 0xd                                     # 0050d8b3
    call FUN_00512c79                            # 0050d8b5
    pop ecx                                      # 0050d8ba
    ret                                          # 0050d8bb

