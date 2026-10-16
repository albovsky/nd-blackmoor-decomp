# FUN_00527b16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527b16
# extent:       0x00527b16-0x00527b25 (15 code bytes)
# span:         0x00527b16-0x00527b25 (code 15, tables 0, padding 0)
# sha256:       9a4100abe5e7e46a8a4a3b7c28cd03ddd2eb30eaec85fd64a5b0891c0ddd15c4
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527b16
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00465aeb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00465aeb, .text + (0x00465aeb - 0x401000)

.org 0x00527b16 - 0x401000
.globl FUN_00527b16
FUN_00527b16:
    # block 0x00527b16: entry, 4 instruction(s), calls FUN_00465aeb, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527b16
    add ecx, 0xad39b                             # 00527b19
    call FUN_00465aeb                            # 00527b1f
    ret                                          # 00527b24

