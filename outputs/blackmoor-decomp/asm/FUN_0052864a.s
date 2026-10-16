# FUN_0052864a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052864a
# extent:       0x0052864a-0x00528654 (10 code bytes)
# span:         0x0052864a-0x00528654 (code 10, tables 0, padding 0)
# sha256:       c7b22cbe3a5da4df75651f5107a4dae02290925716cfbb6bc1b11a5c6e0677c7
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528640 (+0xa)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052864a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x0052864a - 0x401000
.globl FUN_0052864a
FUN_0052864a:
    # block 0x0052864a: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x5331b8                            # 0052864a
    jmp.d32 FUN_0050c6c6                         # 0052864f

