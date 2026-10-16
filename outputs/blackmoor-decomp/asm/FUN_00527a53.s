# FUN_00527a53
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a53
# extent:       0x00527a53-0x00527a62 (15 code bytes)
# span:         0x00527a53-0x00527a62 (code 15, tables 0, padding 0)
# sha256:       c26ef6efff3ae19fcc08d5522d099774b07f1d2bbf62c79f3494ebb0d177f276
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a53
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00446faa
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00446faa, .text + (0x00446faa - 0x401000)

.org 0x00527a53 - 0x401000
.globl FUN_00527a53
FUN_00527a53:
    # block 0x00527a53: entry, 4 instruction(s), calls FUN_00446faa, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a53
    add ecx, 0xa954f                             # 00527a56
    call FUN_00446faa                            # 00527a5c
    ret                                          # 00527a61

