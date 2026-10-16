# FUN_00527824
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527824
# extent:       0x00527824-0x00527833 (15 code bytes)
# span:         0x00527824-0x00527833 (code 15, tables 0, padding 0)
# sha256:       7489345770c9afc89655bcf0ef47e61672651b75a206910c6bf1ee0e3c84d6a4
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527824
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004a9f0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a9f0b, .text + (0x004a9f0b - 0x401000)

.org 0x00527824 - 0x401000
.globl FUN_00527824
FUN_00527824:
    # block 0x00527824: entry, 4 instruction(s), calls FUN_004a9f0b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527824
    add ecx, 0xc06ac                             # 00527827
    call FUN_004a9f0b                            # 0052782d
    ret                                          # 00527832

