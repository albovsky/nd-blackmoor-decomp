# FUN_005277ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005277ca
# extent:       0x005277ca-0x005277d9 (15 code bytes)
# span:         0x005277ca-0x005277d9 (code 15, tables 0, padding 0)
# sha256:       30ad3ed3ee96f7d0b4f9fbdc4a6bb255871f9c1069f5bae4816f5078b9fcc732
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005277ca
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048215e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048215e, .text + (0x0048215e - 0x401000)

.org 0x005277ca - 0x401000
.globl FUN_005277ca
FUN_005277ca:
    # block 0x005277ca: entry, 4 instruction(s), calls FUN_0048215e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005277ca
    add ecx, 0xb498a                             # 005277cd
    call FUN_0048215e                            # 005277d3
    ret                                          # 005277d8

