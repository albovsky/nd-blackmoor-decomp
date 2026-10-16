# FUN_0051e5b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5b9
# extent:       0x0051e5b9-0x0051e5c3 (10 code bytes)
# span:         0x0051e5b9-0x0051e5c3 (code 10, tables 0, padding 0)
# sha256:       490623d5c769156a5ce85fd8c97abb628d8bb7c4aa540334fc5c22fbc8bc6cc7
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e5ad (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5b9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051e5c3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x0051e5b9 - 0x401000
.globl FUN_0051e5b9
FUN_0051e5b9:
    # block 0x0051e5b9: entry, 2 instruction(s), ends with backward jump to 0x0050c539
    mov ecx, 0x63c3c8                            # 0051e5b9
    jmp.d32 FUN_0050c539                         # 0051e5be

