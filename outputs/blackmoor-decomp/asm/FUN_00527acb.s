# FUN_00527acb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527acb
# extent:       0x00527acb-0x00527ada (15 code bytes)
# span:         0x00527acb-0x00527ada (code 15, tables 0, padding 0)
# sha256:       02a8f25b4f0cf844284578181aa362fc685332d4817c88ca5b453b3d7e4864df
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527acb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004a1c2b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a1c2b, .text + (0x004a1c2b - 0x401000)

.org 0x00527acb - 0x401000
.globl FUN_00527acb
FUN_00527acb:
    # block 0x00527acb: entry, 4 instruction(s), calls FUN_004a1c2b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527acb
    add ecx, 0xacf55                             # 00527ace
    call FUN_004a1c2b                            # 00527ad4
    ret                                          # 00527ad9

