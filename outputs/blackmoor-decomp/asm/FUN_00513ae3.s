# FUN_00513ae3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513ae3
# extent:       0x00513ae3-0x00513aed (10 code bytes)
# span:         0x00513ae3-0x00513aed (code 10, tables 0, padding 0)
# sha256:       cc2d8f274cc3c1fb7e3989d9139da8a3d095efb586b7d89d23468eefa2f6b13e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x8c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513ae3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls LOC_00513ba9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513aed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set LOC_00513ba9, .text + (0x00513ba9 - 0x401000)

.org 0x00513ae3 - 0x401000
.globl FUN_00513ae3
FUN_00513ae3:
    # block 0x00513ae3: entry, 4 instruction(s), calls LOC_00513ba9, ends with ret
    call LOC_00513ba9                            # 00513ae3
    fxch st(1)                                   # 00513ae8
    fstp st(0)                                   # 00513aea
    ret                                          # 00513aec

