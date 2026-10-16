# FUN_005290f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005290f4
# extent:       0x005290f4-0x005290fe (10 code bytes)
# span:         0x005290f4-0x00529100 (code 10, tables 0, padding 2)
# sha256:       5e2694c91c3c4c2f0ff0682ef99efb514e99d9db48f747e670e814d5621218b1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005290ec (+0x8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005290f4
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

.org 0x005290f4 - 0x401000
.globl FUN_005290f4
FUN_005290f4:
    # block 0x005290f4: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x534650                            # 005290f4
    jmp.d32 FUN_0050c6c6                         # 005290f9

# --- data items (not part of the function) -------------------------
.org 0x005290fe - 0x401000
PAD_005290fe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

