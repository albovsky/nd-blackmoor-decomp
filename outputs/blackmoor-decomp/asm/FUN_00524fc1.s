# FUN_00524fc1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524fc1
# extent:       0x00524fc1-0x00524fcb (10 code bytes)
# span:         0x00524fc1-0x00524fcb (code 10, tables 0, padding 0)
# sha256:       7ddb2c2d5f1f7942b7942f2ea788a65c2c3c5ce8f1b88b83a671b395e99fa87d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524f85 (+0x3c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524fc1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00524fcb, tail jump FUN_00524fcc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00524fcb, .text + (0x00524fcb - 0x401000)
.set FUN_00524fcc, .text + (0x00524fcc - 0x401000)

.org 0x00524fc1 - 0x401000
.globl FUN_00524fc1
FUN_00524fc1:
    # block 0x00524fc1: entry, 2 instruction(s), calls FUN_00524fcb, ends with forward jump to 0x00524fcc
    call FUN_00524fcb                            # 00524fc1
    jmp.d32 FUN_00524fcc                         # 00524fc6

