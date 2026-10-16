# FUN_005255ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005255ad
# extent:       0x005255ad-0x005255b9 (12 code bytes)
# span:         0x005255ad-0x005255b9 (code 12, tables 0, padding 0)
# sha256:       e7457a1ae9363157d1538bdd8a367e727ec2f0cc5c706471e8739f5aa676efd4
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005255ad
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005255b9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x005255ad - 0x401000
.globl FUN_005255ad
FUN_005255ad:
    # block 0x005255ad: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x5255b9                                # 005255ad
    call FUN_0050d775                            # 005255b2
    pop ecx                                      # 005255b7
    ret                                          # 005255b8

