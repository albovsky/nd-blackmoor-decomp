# FUN_00528b40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528b40
# extent:       0x00528b40-0x00528b4a (10 code bytes)
# span:         0x00528b40-0x00528b4c (code 10, tables 0, padding 2)
# sha256:       86271807e17db2384e8b95545d37bd2dd4e1d5486fbff7bb08e8738370cc6d79
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528b27 (+0x19)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528b40
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

.org 0x00528b40 - 0x401000
.globl FUN_00528b40
FUN_00528b40:
    # block 0x00528b40: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x5338a8                            # 00528b40
    jmp.d32 FUN_0050c6c6                         # 00528b45

# --- data items (not part of the function) -------------------------
.org 0x00528b4a - 0x401000
PAD_00528b4a:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

