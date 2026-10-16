# FUN_00525594
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525594
# extent:       0x00525594-0x0052559e (10 code bytes)
# span:         0x00525594-0x0052559e (code 10, tables 0, padding 0)
# sha256:       37b37dc8bc96665482912fe09e1968d41ae7216a511eda9065065f33de090724
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525565 (+0x2f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525594
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052559e, tail jump FUN_005255ad
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0052559e, .text + (0x0052559e - 0x401000)
.set FUN_005255ad, .text + (0x005255ad - 0x401000)

.org 0x00525594 - 0x401000
.globl FUN_00525594
FUN_00525594:
    # block 0x00525594: entry, 2 instruction(s), calls FUN_0052559e, ends with forward jump to 0x005255ad
    call FUN_0052559e                            # 00525594
    jmp.d32 FUN_005255ad                         # 00525599

