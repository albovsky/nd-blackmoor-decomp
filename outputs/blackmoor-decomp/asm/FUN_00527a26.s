# FUN_00527a26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a26
# extent:       0x00527a26-0x00527a35 (15 code bytes)
# span:         0x00527a26-0x00527a35 (code 15, tables 0, padding 0)
# sha256:       2f714a666a03c487f186276129b4772ef891b04c5ec4d450d9f63ff4529a041d
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a26
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00468e3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00468e3e, .text + (0x00468e3e - 0x401000)

.org 0x00527a26 - 0x401000
.globl FUN_00527a26
FUN_00527a26:
    # block 0x00527a26: entry, 4 instruction(s), calls FUN_00468e3e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a26
    add ecx, 0xa672a                             # 00527a29
    call FUN_00468e3e                            # 00527a2f
    ret                                          # 00527a34

