# FUN_00528d12
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528d12
# extent:       0x00528d12-0x00528d1c (10 code bytes)
# span:         0x00528d12-0x00528d1c (code 10, tables 0, padding 0)
# sha256:       b3871106e96394a2e8169d379a9fc477e268e12b8453eee622fade9aa3ea2daf
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528d07 (+0xb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528d12
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

.org 0x00528d12 - 0x401000
.globl FUN_00528d12
FUN_00528d12:
    # block 0x00528d12: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x533d08                            # 00528d12
    jmp.d32 FUN_0050c6c6                         # 00528d17

