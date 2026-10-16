# FUN_0051e5df
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5df
# extent:       0x0051e5df-0x0051e5eb (12 code bytes)
# span:         0x0051e5df-0x0051e5eb (code 12, tables 0, padding 0)
# sha256:       84cde93ced7906d8c712536e21626e624f1248b77b874ef8e12b3c31699531c8
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5df
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e5eb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0051e5df - 0x401000
.globl FUN_0051e5df
FUN_0051e5df:
    # block 0x0051e5df: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x51e5eb                                # 0051e5df
    call FUN_0050d775                            # 0051e5e4
    pop ecx                                      # 0051e5e9
    ret                                          # 0051e5ea

