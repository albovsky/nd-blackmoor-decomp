# FUN_00524fcb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524fcb
# extent:       0x00524fcb-0x00524fcc (1 code bytes)
# span:         0x00524fcb-0x00524fcc (code 1, tables 0, padding 0)
# sha256:       ae3f4619b0413d70d3004b9131c3752153074e45725be13b9a148978895e359e
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524fcb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00524fcb - 0x401000
.globl FUN_00524fcb
FUN_00524fcb:
    # block 0x00524fcb: entry, 1 instruction(s), ends with ret
    ret                                          # 00524fcb

