# FUN_00526f6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526f6e
# extent:       0x00526f6e-0x00526f7d (15 code bytes)
# span:         0x00526f6e-0x00526f7d (code 15, tables 0, padding 0)
# sha256:       d071405470360caaa5d5f5aebff5f458bc70849f492e4bcf64fd878410e4a37b
# evidence:     ev_a2e1e77de9fed89c1dc4e9b46441a378acf5d34515bb0884d2eb66c2fc053227
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526f6e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x00526f6e - 0x401000
.globl FUN_00526f6e
FUN_00526f6e:
    # block 0x00526f6e: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526f6e
    add ecx, 0x84c                               # 00526f71
    call FUN_00401032                            # 00526f77
    ret                                          # 00526f7c

