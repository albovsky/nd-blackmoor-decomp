# FUN_0051a0e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a0e6
# extent:       0x0051a0e6-0x0051a0ee (8 code bytes)
# span:         0x0051a0e6-0x0051a0ee (code 8, tables 0, padding 0)
# sha256:       b25606655a4d3889fe8ec51513d4699459c0b2d5d31ce20545646e4197747973
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a0ca (+0x1c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a0e6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0051a0e6 - 0x401000
.globl FUN_0051a0e6
FUN_0051a0e6:
    # block 0x0051a0e6: entry, 2 instruction(s), calls FUN_0051ab4b, ends with ret 0x4
    call FUN_0051ab4b                            # 0051a0e6
    ret 0x4                                      # 0051a0eb

