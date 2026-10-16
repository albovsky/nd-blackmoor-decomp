# FUN_00524945
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524945
# extent:       0x00524945-0x00524951 (12 code bytes)
# span:         0x00524945-0x00524951 (code 12, tables 0, padding 0)
# sha256:       4f0b492c5bc51d886395e1c48b52152277562ff21ab5f3c16a1df35c61bbdaa4
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524945
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524951
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00524945 - 0x401000
.globl FUN_00524945
FUN_00524945:
    # block 0x00524945: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x524951                                # 00524945
    call FUN_0050d775                            # 0052494a
    pop ecx                                      # 0052494f
    ret                                          # 00524950

