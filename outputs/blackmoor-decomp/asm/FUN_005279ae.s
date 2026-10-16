# FUN_005279ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005279ae
# extent:       0x005279ae-0x005279bd (15 code bytes)
# span:         0x005279ae-0x005279bd (code 15, tables 0, padding 0)
# sha256:       0487631d2bb70539790bddd7848d312e23a012ef06ecb5f9855d8c48591cb882
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005279ae
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00426346
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00426346, .text + (0x00426346 - 0x401000)

.org 0x005279ae - 0x401000
.globl FUN_005279ae
FUN_005279ae:
    # block 0x005279ae: entry, 4 instruction(s), calls FUN_00426346, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005279ae
    add ecx, 0x135f1                             # 005279b1
    call FUN_00426346                            # 005279b7
    ret                                          # 005279bc

