# FUN_0052846d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052846d
# extent:       0x0052846d-0x00528477 (10 code bytes)
# span:         0x0052846d-0x00528480 (code 10, tables 0, padding 9)
# sha256:       9c978a9bbc94bd0cc0b2d898d8b6c5dfa67fbe64892480ddc94b21f344866043
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528464 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052846d
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

.org 0x0052846d - 0x401000
.globl FUN_0052846d
FUN_0052846d:
    # block 0x0052846d: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x532e98                            # 0052846d
    jmp.d32 FUN_0050c6c6                         # 00528472

# --- data items (not part of the function) -------------------------
.org 0x00528477 - 0x401000
PAD_00528477:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

