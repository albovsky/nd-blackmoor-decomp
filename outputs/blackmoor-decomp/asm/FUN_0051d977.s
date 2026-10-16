# FUN_0051d977
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d977
# extent:       0x0051d977-0x0051d97f (8 code bytes)
# span:         0x0051d977-0x0051d97f (code 8, tables 0, padding 0)
# sha256:       0092ecf3fa7d244b989d99c60a23d3faffdfe7b802c67a5dd49b78469d9ec127
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051d862 (+0x115)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d977
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

.org 0x0051d977 - 0x401000
.globl FUN_0051d977
FUN_0051d977:
    # block 0x0051d977: entry, 2 instruction(s), ends with ret 0x8
    mov eax, 0x80029c4a                          # 0051d977
    ret 0x8                                      # 0051d97c

