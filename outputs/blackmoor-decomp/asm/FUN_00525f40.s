# FUN_00525f40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525f40
# extent:       0x00525f40-0x00525f4c (12 code bytes)
# span:         0x00525f40-0x00525f4c (code 12, tables 0, padding 0)
# sha256:       e37db511548450f1ed0e7b53ab1273f083746db72dafbcc284a8fb29e2277bfb
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525f40
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525f4c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00525f40 - 0x401000
.globl FUN_00525f40
FUN_00525f40:
    # block 0x00525f40: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x525f4c                                # 00525f40
    call FUN_0050d775                            # 00525f45
    pop ecx                                      # 00525f4a
    ret                                          # 00525f4b

