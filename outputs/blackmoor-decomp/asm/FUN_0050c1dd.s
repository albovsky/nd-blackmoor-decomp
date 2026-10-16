# FUN_0050c1dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1dd
# extent:       0x0050c1dd-0x0050c1de (1 code bytes)
# span:         0x0050c1dd-0x0050c1de (code 1, tables 0, padding 0)
# sha256:       ae3f4619b0413d70d3004b9131c3752153074e45725be13b9a148978895e359e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c1b4 (+0x29)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1dd
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

.org 0x0050c1dd - 0x401000
.globl FUN_0050c1dd
FUN_0050c1dd:
    # block 0x0050c1dd: entry, 1 instruction(s), ends with ret
    ret                                          # 0050c1dd

