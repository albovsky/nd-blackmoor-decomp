# FUN_0051e446
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e446
# extent:       0x0051e446-0x0051e44e (8 code bytes)
# span:         0x0051e446-0x0051e44e (code 8, tables 0, padding 0)
# sha256:       c620b4016ad9d19af30042ff889ceb1a92f7601f5de95e7e23ecb27dc1dcbc23
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e446
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e2a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051e2a0, .text + (0x0051e2a0 - 0x401000)

.org 0x0051e446 - 0x401000
.globl FUN_0051e446
FUN_0051e446:
    # block 0x0051e446: entry, 3 instruction(s), calls FUN_0051e2a0, ends with ret
    push 0x2                                     # 0051e446
    call FUN_0051e2a0                            # 0051e448
    ret                                          # 0051e44d

