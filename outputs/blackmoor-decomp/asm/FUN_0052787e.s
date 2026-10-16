# FUN_0052787e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052787e
# extent:       0x0052787e-0x0052788d (15 code bytes)
# span:         0x0052787e-0x0052788d (code 15, tables 0, padding 0)
# sha256:       a7c386838cdf6e4156d5ca8b73ca234b7ee183edc0e83e136ceda830301d061c
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052787e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004dbf6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004dbf6e, .text + (0x004dbf6e - 0x401000)

.org 0x0052787e - 0x401000
.globl FUN_0052787e
FUN_0052787e:
    # block 0x0052787e: entry, 4 instruction(s), calls FUN_004dbf6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052787e
    add ecx, 0xc7afd                             # 00527881
    call FUN_004dbf6e                            # 00527887
    ret                                          # 0052788c

