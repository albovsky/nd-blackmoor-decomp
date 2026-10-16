# FUN_00525d5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525d5c
# extent:       0x00525d5c-0x00525d66 (10 code bytes)
# span:         0x00525d5c-0x00525d66 (code 10, tables 0, padding 0)
# sha256:       d6cb8d7f5c2c2860fdc71627ae590a69de41fd6891d1c440085a02d5a243ba36
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525d5c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_00525dce
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525dce, .text + (0x00525dce - 0x401000)

.org 0x00525d5c - 0x401000
.globl FUN_00525d5c
FUN_00525d5c:
    # block 0x00525d5c: entry, 2 instruction(s), ends with forward jump to 0x00525dce
    mov ecx, 0x63c748                            # 00525d5c
    jmp.d32 FUN_00525dce                         # 00525d61

