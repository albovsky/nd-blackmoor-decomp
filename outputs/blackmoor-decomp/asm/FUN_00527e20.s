# FUN_00527e20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e20
# extent:       0x00527e20-0x00527e29 (9 code bytes)
# span:         0x00527e20-0x00527e29 (code 9, tables 0, padding 0)
# sha256:       2be2998acfc3e24a33f2964fa3e606aadcf1a7db9753967c70218e303cad0531
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527e20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00527e20 - 0x401000
.globl FUN_00527e20
FUN_00527e20:
    # block 0x00527e20: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp - field_minus_14]              # 00527e20
    call FUN_0051e7ba                            # 00527e23
    ret                                          # 00527e28

