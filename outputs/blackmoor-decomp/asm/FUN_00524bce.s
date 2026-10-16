# FUN_00524bce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524bce
# extent:       0x00524bce-0x00524bd4 (6 code bytes)
# span:         0x00524bce-0x00524bd4 (code 6, tables 0, padding 0)
# sha256:       1b8c9e7dbb54e0f17cb3385e89cdd8be8bb38e03b184fb98ee97986e2457bf27
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524b9c (+0x32)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524bce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524bd4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00524bce - 0x401000
.globl FUN_00524bce
FUN_00524bce:
    # block 0x00524bce: entry, 2 instruction(s), ends with ret
    mov eax, 0x52f398                            # 00524bce
    ret                                          # 00524bd3

