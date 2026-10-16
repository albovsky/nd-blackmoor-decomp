# FUN_005280cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005280cd
# extent:       0x005280cd-0x005280d7 (10 code bytes)
# span:         0x005280cd-0x005280e0 (code 10, tables 0, padding 9)
# sha256:       1edce41bebc39caed9a17b605d7c2ca8b18e44a6bd1eccbf4f429a95b600425f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005280c4 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005280cd
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

.org 0x005280cd - 0x401000
.globl FUN_005280cd
FUN_005280cd:
    # block 0x005280cd: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x532898                            # 005280cd
    jmp.d32 FUN_0050c6c6                         # 005280d2

# --- data items (not part of the function) -------------------------
.org 0x005280d7 - 0x401000
PAD_005280d7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

