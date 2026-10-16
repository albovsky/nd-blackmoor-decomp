# FUN_00528a82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a82
# extent:       0x00528a82-0x00528a8c (10 code bytes)
# span:         0x00528a82-0x00528a90 (code 10, tables 0, padding 4)
# sha256:       e6946499c9d68d896930f812c77c43c9e2b0f25a2441490e696f972df09784c3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528a67 (+0x1b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528a82
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

.org 0x00528a82 - 0x401000
.globl FUN_00528a82
FUN_00528a82:
    # block 0x00528a82: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x5337b8                            # 00528a82
    jmp.d32 FUN_0050c6c6                         # 00528a87

# --- data items (not part of the function) -------------------------
.org 0x00528a8c - 0x401000
PAD_00528a8c:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

