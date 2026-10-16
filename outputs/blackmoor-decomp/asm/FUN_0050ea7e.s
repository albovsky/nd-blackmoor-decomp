# FUN_0050ea7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ea7e
# extent:       0x0050ea7e-0x0050ea87 (9 code bytes)
# span:         0x0050ea7e-0x0050ea87 (code 9, tables 0, padding 0)
# sha256:       45f4085b9f5af22acdc172ccf64fdbe893c7f332ab3fabe68f50aacc25cbe47d
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ea7e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00510dd3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050ea7e - 0x401000
.globl FUN_0050ea7e
FUN_0050ea7e:
    # block 0x0050ea7e: entry, 3 instruction(s), calls FUN_00510dd3, ends with ret
    call FUN_00510dd3                            # 0050ea7e
    add eax, 0x8                                 # 0050ea83
    ret                                          # 0050ea86

