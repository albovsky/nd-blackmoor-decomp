# FUN_00527bf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527bf7
# extent:       0x00527bf7-0x00527c06 (15 code bytes)
# span:         0x00527bf7-0x00527c06 (code 15, tables 0, padding 0)
# sha256:       241053c38cb690a3f95ef1ec2c68b1c82cff59719abc22f290d0570497771584
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527bf7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004781de
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004781de, .text + (0x004781de - 0x401000)

.org 0x00527bf7 - 0x401000
.globl FUN_00527bf7
FUN_00527bf7:
    # block 0x00527bf7: entry, 4 instruction(s), calls FUN_004781de, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527bf7
    add ecx, 0xb167a                             # 00527bfa
    call FUN_004781de                            # 00527c00
    ret                                          # 00527c05

