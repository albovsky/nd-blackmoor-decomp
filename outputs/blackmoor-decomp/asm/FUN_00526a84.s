# FUN_00526a84
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526a84
# extent:       0x00526a84-0x00526a90 (12 code bytes)
# span:         0x00526a84-0x00526a90 (code 12, tables 0, padding 0)
# sha256:       f482fecdf631a50bb606db54ddfea9deed39e05c1cb061547faa39479351ad81
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526a84
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_e4c
# callees:      calls FUN_00403229
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_e4c, 0xe4c  # offset -0xe4c

# --- external targets -----------------------------------------------
.set FUN_00403229, .text + (0x00403229 - 0x401000)

.org 0x00526a84 - 0x401000
.globl FUN_00526a84
FUN_00526a84:
    # block 0x00526a84: entry, 3 instruction(s), calls FUN_00403229, ends with ret
    lea ecx, [ebp - field_minus_e4c]             # 00526a84
    call FUN_00403229                            # 00526a8a
    ret                                          # 00526a8f

