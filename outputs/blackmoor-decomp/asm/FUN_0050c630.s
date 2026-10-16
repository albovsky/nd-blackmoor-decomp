# FUN_0050c630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c630
# extent:       0x0050c630-0x0050c635 (5 code bytes)
# span:         0x0050c630-0x0050c635 (code 5, tables 0, padding 0)
# sha256:       d8704193aff8fe7650207999e3045391b78cfff2361d1735b0ed69fccd352e3c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c604 (+0x2c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c630
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)

.org 0x0050c630 - 0x401000
.globl FUN_0050c630
FUN_0050c630:
    # block 0x0050c630: entry, 1 instruction(s), ends with forward jump to 0x0051de13
    jmp.d32 FUN_0051de13                         # 0050c630

