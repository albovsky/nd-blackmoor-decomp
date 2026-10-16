# FUN_0051e5eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5eb
# extent:       0x0051e5eb-0x0051e5f5 (10 code bytes)
# span:         0x0051e5eb-0x0051e5f5 (code 10, tables 0, padding 0)
# sha256:       ef50c28b4c6d4043b6e90200154b192e9848c54364a29f37de368e5e8c296b6e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e5df (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5eb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e5f5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x0051e5eb - 0x401000
.globl FUN_0051e5eb
FUN_0051e5eb:
    # block 0x0051e5eb: entry, 2 instruction(s), ends with backward jump to 0x0050c539
    mov ecx, 0x63c3a0                            # 0051e5eb
    jmp.d32 FUN_0050c539                         # 0051e5f0

