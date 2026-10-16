# FUN_0052535b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052535b
# extent:       0x0052535b-0x00525367 (12 code bytes)
# span:         0x0052535b-0x00525367 (code 12, tables 0, padding 0)
# sha256:       998096e566350f3f25d01b27edad4e278f8f7309330929d56fb69cf01a897f08
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052535b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525367
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0052535b - 0x401000
.globl FUN_0052535b
FUN_0052535b:
    # block 0x0052535b: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x525367                                # 0052535b
    call FUN_0050d775                            # 00525360
    pop ecx                                      # 00525365
    ret                                          # 00525366

