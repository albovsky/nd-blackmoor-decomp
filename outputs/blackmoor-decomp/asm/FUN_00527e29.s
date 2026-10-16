# FUN_00527e29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e29
# extent:       0x00527e29-0x00527e32 (9 code bytes)
# span:         0x00527e29-0x00527e32 (code 9, tables 0, padding 0)
# sha256:       48eaead9e809b6999cb622ba8124a90eb6e57e590e3b5d12ea022517ba2ce617
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527e29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00527e29 - 0x401000
.globl FUN_00527e29
FUN_00527e29:
    # block 0x00527e29: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp - field_minus_10]              # 00527e29
    call FUN_0051e7ba                            # 00527e2c
    ret                                          # 00527e31

