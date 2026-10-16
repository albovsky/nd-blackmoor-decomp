# FUN_0051e5ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5ad
# extent:       0x0051e5ad-0x0051e5b9 (12 code bytes)
# span:         0x0051e5ad-0x0051e5b9 (code 12, tables 0, padding 0)
# sha256:       f85c397b3705433bacbed78ff05670c8f04797413b936264cd78538706a207a9
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5ad
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e5b9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0051e5ad - 0x401000
.globl FUN_0051e5ad
FUN_0051e5ad:
    # block 0x0051e5ad: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x51e5b9                                # 0051e5ad
    call FUN_0050d775                            # 0051e5b2
    pop ecx                                      # 0051e5b7
    ret                                          # 0051e5b8

