# FUN_0051caab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051caab
# extent:       0x0051caab-0x0051cab3 (8 code bytes)
# span:         0x0051caab-0x0051cab3 (code 8, tables 0, padding 0)
# sha256:       29712a6350ed6848f984404071ba380b76d9887f59198964a5e70abf0a5a1831
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051ca36 (+0x75)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051caab
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051caab - 0x401000
.globl FUN_0051caab
FUN_0051caab:
    # block 0x0051caab: entry, 2 instruction(s), ends with ret 0x8
    mov eax, 0xffff                              # 0051caab
    ret 0x8                                      # 0051cab0

