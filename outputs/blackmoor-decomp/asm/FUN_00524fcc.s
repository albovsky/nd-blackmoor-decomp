# FUN_00524fcc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524fcc
# extent:       0x00524fcc-0x00524fd8 (12 code bytes)
# span:         0x00524fcc-0x00524fd8 (code 12, tables 0, padding 0)
# sha256:       3762e6a7f14ceb7e8e85bf6fac78661eee43d714123c8172a17ac7632e618727
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524fcc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524fd8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00524fcc - 0x401000
.globl FUN_00524fcc
FUN_00524fcc:
    # block 0x00524fcc: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x524fd8                                # 00524fcc
    call FUN_0050d775                            # 00524fd1
    pop ecx                                      # 00524fd6
    ret                                          # 00524fd7

