# FUN_0051cffc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cffc
# extent:       0x0051cffc-0x0051d001 (5 code bytes)
# span:         0x0051cffc-0x0051d001 (code 5, tables 0, padding 0)
# sha256:       5fed5afb29946811bf02359627a94bc01d08d31b779528feaadde3866af9c855
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051cfd1 (+0x2b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cffc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
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

.org 0x0051cffc - 0x401000
.globl FUN_0051cffc
FUN_0051cffc:
    # block 0x0051cffc: entry, 2 instruction(s), ends with ret 0x4
    {load} xor eax, eax                          # 0051cffc
    ret 0x4                                      # 0051cffe

