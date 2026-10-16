# FUN_00528fc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528fc8
# extent:       0x00528fc8-0x00528fd2 (10 code bytes)
# span:         0x00528fc8-0x00528fd4 (code 10, tables 0, padding 2)
# sha256:       4e8e3717bb5b5c7d6ccf905407d079eb349ed0767a94a9d5bd7b24b477c2e86d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528fc0 (+0x8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528fc8
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

.org 0x00528fc8 - 0x401000
.globl FUN_00528fc8
FUN_00528fc8:
    # block 0x00528fc8: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x534298                            # 00528fc8
    jmp.d32 FUN_0050c6c6                         # 00528fcd

# --- data items (not part of the function) -------------------------
.org 0x00528fd2 - 0x401000
PAD_00528fd2:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

