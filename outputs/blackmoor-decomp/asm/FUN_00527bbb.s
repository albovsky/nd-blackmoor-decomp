# FUN_00527bbb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527bbb
# extent:       0x00527bbb-0x00527bca (15 code bytes)
# span:         0x00527bbb-0x00527bca (code 15, tables 0, padding 0)
# sha256:       47e6f951dbbed583e646f4fe2729b010066774428e998845d93a9386d49a6944
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527bbb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044bea7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044bea7, .text + (0x0044bea7 - 0x401000)

.org 0x00527bbb - 0x401000
.globl FUN_00527bbb
FUN_00527bbb:
    # block 0x00527bbb: entry, 4 instruction(s), calls FUN_0044bea7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527bbb
    add ecx, 0xaf4d8                             # 00527bbe
    call FUN_0044bea7                            # 00527bc4
    ret                                          # 00527bc9

