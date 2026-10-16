# FUN_00525d66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525d66
# extent:       0x00525d66-0x00525d72 (12 code bytes)
# span:         0x00525d66-0x00525d72 (code 12, tables 0, padding 0)
# sha256:       76bb1650fcf87062a60580f6cc26be9070c28b749966264e19bc1229d60de8ee
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525d66
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525d72
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00525d66 - 0x401000
.globl FUN_00525d66
FUN_00525d66:
    # block 0x00525d66: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x525d72                                # 00525d66
    call FUN_0050d775                            # 00525d6b
    pop ecx                                      # 00525d70
    ret                                          # 00525d71

