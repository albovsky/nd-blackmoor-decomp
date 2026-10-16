# FUN_0051a6cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a6cb
# extent:       0x0051a6cb-0x0051a6d5 (10 code bytes)
# span:         0x0051a6cb-0x0051a6d5 (code 10, tables 0, padding 0)
# sha256:       2387dee89b24e8e643377d7e53821095edfe793da05cc40ace0900aa5f7e3b76
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a643 (+0x88)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a6cb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051a6d5, tail jump FUN_0051a6e2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051a6d5, .text + (0x0051a6d5 - 0x401000)
.set FUN_0051a6e2, .text + (0x0051a6e2 - 0x401000)

.org 0x0051a6cb - 0x401000
.globl FUN_0051a6cb
FUN_0051a6cb:
    # block 0x0051a6cb: entry, 2 instruction(s), calls FUN_0051a6d5, ends with forward jump to 0x0051a6e2
    call FUN_0051a6d5                            # 0051a6cb
    jmp.d32 FUN_0051a6e2                         # 0051a6d0

