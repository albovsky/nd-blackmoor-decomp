# FUN_00526d4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526d4a
# extent:       0x00526d4a-0x00526d54 (10 code bytes)
# span:         0x00526d4a-0x00526d54 (code 10, tables 0, padding 0)
# sha256:       c989475040b90a79cb1b734f341688250b3159895e58ef519889fee6e3016e43
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00526d40 (+0xa)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526d4a
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

.org 0x00526d4a - 0x401000
.globl FUN_00526d4a
FUN_00526d4a:
    # block 0x00526d4a: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x531908                            # 00526d4a
    jmp.d32 FUN_0050c6c6                         # 00526d4f

