# FUN_005267ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005267ed
# extent:       0x005267ed-0x005267f2 (5 code bytes)
# span:         0x005267ed-0x005267f2 (code 5, tables 0, padding 0)
# sha256:       b3a4e2575664e476e3402e3653025d238936578d973d044298c53ff2e136b40c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005265e4 (+0x209)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005267ed
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

.org 0x005267ed - 0x401000
.globl FUN_005267ed
FUN_005267ed:
    # block 0x005267ed: entry, 1 instruction(s), ends with backward jump to 0x0051de13
    jmp.d32 FUN_0051de13                         # 005267ed

