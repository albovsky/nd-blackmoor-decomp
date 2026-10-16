# FUN_0051d971
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d971
# extent:       0x0051d971-0x0051d977 (6 code bytes)
# span:         0x0051d971-0x0051d977 (code 6, tables 0, padding 0)
# sha256:       6680a7985057c32df26735b7fd8cca363f3fa700fdc70f58c694a8ecbb7ae28f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051d862 (+0x10f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d971
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051d977
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051d971 - 0x401000
.globl FUN_0051d971
FUN_0051d971:
    # block 0x0051d971: entry, 3 instruction(s), ends with ret 0x4
    push 0x1                                     # 0051d971
    pop eax                                      # 0051d973
    ret 0x4                                      # 0051d974

