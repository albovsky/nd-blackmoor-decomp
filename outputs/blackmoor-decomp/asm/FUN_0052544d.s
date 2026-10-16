# FUN_0052544d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052544d
# extent:       0x0052544d-0x00525459 (12 code bytes)
# span:         0x0052544d-0x00525459 (code 12, tables 0, padding 0)
# sha256:       414d623f2c682284ff228c133fc0b349b4fc54955f93012f51b5ad4c02972731
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052544d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525459
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0052544d - 0x401000
.globl FUN_0052544d
FUN_0052544d:
    # block 0x0052544d: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x525459                                # 0052544d
    call FUN_0050d775                            # 00525452
    pop ecx                                      # 00525457
    ret                                          # 00525458

