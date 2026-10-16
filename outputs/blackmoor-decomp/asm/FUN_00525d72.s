# FUN_00525d72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525d72
# extent:       0x00525d72-0x00525d7c (10 code bytes)
# span:         0x00525d72-0x00525d7c (code 10, tables 0, padding 0)
# sha256:       de86b21212619708cd506c46a3b32e9d066dfe004678c208d557d1f1558470a3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525d66 (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525d72
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0052699b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0052699b, .text + (0x0052699b - 0x401000)

.org 0x00525d72 - 0x401000
.globl FUN_00525d72
FUN_00525d72:
    # block 0x00525d72: entry, 2 instruction(s), ends with forward jump to 0x0052699b
    mov ecx, 0x63c748                            # 00525d72
    jmp.d32 FUN_0052699b                         # 00525d77

