# FUN_00525093
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525093
# extent:       0x00525093-0x00525099 (6 code bytes)
# span:         0x00525093-0x00525099 (code 6, tables 0, padding 0)
# sha256:       46d32168fa1f7028354262c1f246cea97084cde0cea02a6ddafce28ad114e69b
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052505e (+0x35)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525093
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
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

.org 0x00525093 - 0x401000
.globl FUN_00525093
FUN_00525093:
    # block 0x00525093: entry, 2 instruction(s), ends with ret
    mov eax, 0x52f5b0                            # 00525093
    ret                                          # 00525098

