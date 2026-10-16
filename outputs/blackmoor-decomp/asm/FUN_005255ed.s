# FUN_005255ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005255ed
# extent:       0x005255ed-0x005255f9 (12 code bytes)
# span:         0x005255ed-0x005255f9 (code 12, tables 0, padding 0)
# sha256:       de79922e5a4351d1bec5487a2ebba8da3162440f3b66806025e4ffe4e31ce40e
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005255ed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005255f9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x005255ed - 0x401000
.globl FUN_005255ed
FUN_005255ed:
    # block 0x005255ed: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x5255f9                                # 005255ed
    call FUN_0050d775                            # 005255f2
    pop ecx                                      # 005255f7
    ret                                          # 005255f8

