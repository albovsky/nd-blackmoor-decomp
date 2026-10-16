# FUN_00527972
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527972
# extent:       0x00527972-0x00527981 (15 code bytes)
# span:         0x00527972-0x00527981 (code 15, tables 0, padding 0)
# sha256:       723c09f8bab1f6ac5ab345d2b8d0d92260d1f2a1842e741f70ef49d896bcaa08
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527972
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004f001f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004f001f, .text + (0x004f001f - 0x401000)

.org 0x00527972 - 0x401000
.globl FUN_00527972
FUN_00527972:
    # block 0x00527972: entry, 4 instruction(s), calls FUN_004f001f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527972
    add ecx, 0x12dfa                             # 00527975
    call FUN_004f001f                            # 0052797b
    ret                                          # 00527980

