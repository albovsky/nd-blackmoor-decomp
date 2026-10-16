# FUN_0052543b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052543b
# extent:       0x0052543b-0x0052544d (18 code bytes)
# span:         0x0052543b-0x0052544d (code 18, tables 0, padding 0)
# sha256:       533dcae9378a403e21822e4316e4b259ef88db49404de9917e98e743da32ae4f
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052543b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c1ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c1ea, .text + (0x0050c1ea - 0x401000)

.org 0x0052543b - 0x401000
.globl FUN_0052543b
FUN_0052543b:
    # block 0x0052543b: entry, 5 instruction(s), calls FUN_0050c1ea, ends with ret
    push 0xf022                                  # 0052543b
    push 0x0                                     # 00525440
    mov ecx, 0x63c4e8                            # 00525442
    call FUN_0050c1ea                            # 00525447
    ret                                          # 0052544c

