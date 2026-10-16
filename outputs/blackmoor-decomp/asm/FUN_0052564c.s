# FUN_0052564c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052564c
# extent:       0x0052564c-0x00525652 (6 code bytes)
# span:         0x0052564c-0x00525652 (code 6, tables 0, padding 0)
# sha256:       e36711e022c710c2b8036812e4329da19d6fc23e6ba5bade3df598b9c0a71f75
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525636 (+0x16)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052564c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525652
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0052564c - 0x401000
.globl FUN_0052564c
FUN_0052564c:
    # block 0x0052564c: entry, 2 instruction(s), ends with ret
    mov eax, 0x52fdc0                            # 0052564c
    ret                                          # 00525651

