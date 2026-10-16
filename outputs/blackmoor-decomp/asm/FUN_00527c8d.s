# FUN_00527c8d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527c8d
# extent:       0x00527c8d-0x00527c9c (15 code bytes)
# span:         0x00527c8d-0x00527c9c (code 15, tables 0, padding 0)
# sha256:       50b924c246a0034ec4698c142109822e9d9f82da789843de1c0af0e35aaf697a
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527c8d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00463ffe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00463ffe, .text + (0x00463ffe - 0x401000)

.org 0x00527c8d - 0x401000
.globl FUN_00527c8d
FUN_00527c8d:
    # block 0x00527c8d: entry, 4 instruction(s), calls FUN_00463ffe, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527c8d
    add ecx, 0xb47c8                             # 00527c90
    call FUN_00463ffe                            # 00527c96
    ret                                          # 00527c9b

