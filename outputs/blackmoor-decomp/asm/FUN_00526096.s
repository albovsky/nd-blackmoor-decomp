# FUN_00526096
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526096
# extent:       0x00526096-0x005260a2 (12 code bytes)
# span:         0x00526096-0x005260a2 (code 12, tables 0, padding 0)
# sha256:       55b183fc022c6f4e01f0b0b36b5c998cd16633c31016d81e4b5f73981e94ba2a
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526096
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005260a2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00526096 - 0x401000
.globl FUN_00526096
FUN_00526096:
    # block 0x00526096: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x5260a2                                # 00526096
    call FUN_0050d775                            # 0052609b
    pop ecx                                      # 005260a0
    ret                                          # 005260a1

