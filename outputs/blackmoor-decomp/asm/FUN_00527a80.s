# FUN_00527a80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a80
# extent:       0x00527a80-0x00527a8f (15 code bytes)
# span:         0x00527a80-0x00527a8f (code 15, tables 0, padding 0)
# sha256:       a97229d018f74592e0805fd40a100d677735a15545c750ed7e63b1c59b98cffb
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004110d7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004110d7, .text + (0x004110d7 - 0x401000)

.org 0x00527a80 - 0x401000
.globl FUN_00527a80
FUN_00527a80:
    # block 0x00527a80: entry, 4 instruction(s), calls FUN_004110d7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a80
    add ecx, 0xa96b9                             # 00527a83
    call FUN_004110d7                            # 00527a89
    ret                                          # 00527a8e

