# FUN_00526095
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526095
# extent:       0x00526095-0x00526096 (1 code bytes)
# span:         0x00526095-0x00526096 (code 1, tables 0, padding 0)
# sha256:       ae3f4619b0413d70d3004b9131c3752153074e45725be13b9a148978895e359e
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526095
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00526095 - 0x401000
.globl FUN_00526095
FUN_00526095:
    # block 0x00526095: entry, 1 instruction(s), ends with ret
    ret                                          # 00526095

