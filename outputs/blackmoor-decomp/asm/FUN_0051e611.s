# FUN_0051e611
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e611
# extent:       0x0051e611-0x0051e61d (12 code bytes)
# span:         0x0051e611-0x0051e61d (code 12, tables 0, padding 0)
# sha256:       f9298ef548b4deba1efb141f6323fee4134fbcbd2902f1743e47ab12c9cb38b9
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e611
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e61d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0051e611 - 0x401000
.globl FUN_0051e611
FUN_0051e611:
    # block 0x0051e611: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x51e61d                                # 0051e611
    call FUN_0050d775                            # 0051e616
    pop ecx                                      # 0051e61b
    ret                                          # 0051e61c

