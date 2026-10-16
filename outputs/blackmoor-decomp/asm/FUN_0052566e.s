# FUN_0052566e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052566e
# extent:       0x0052566e-0x0052567a (12 code bytes)
# span:         0x0052566e-0x0052567a (code 12, tables 0, padding 0)
# sha256:       45afd183ef306fdafa46f0c0a9eed68614a32c155f776c50c2cfb5450b24d3f3
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052566e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052567a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0052566e - 0x401000
.globl FUN_0052566e
FUN_0052566e:
    # block 0x0052566e: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x52567a                                # 0052566e
    call FUN_0050d775                            # 00525673
    pop ecx                                      # 00525678
    ret                                          # 00525679

