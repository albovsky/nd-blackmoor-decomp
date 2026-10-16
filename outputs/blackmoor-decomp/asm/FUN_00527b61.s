# FUN_00527b61
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527b61
# extent:       0x00527b61-0x00527b70 (15 code bytes)
# span:         0x00527b61-0x00527b70 (code 15, tables 0, padding 0)
# sha256:       27d1dd49c067f85e199e9bb8903dc16efd8665779ccf3ea88d6aba78c6e31c28
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527b61
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0047b21f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0047b21f, .text + (0x0047b21f - 0x401000)

.org 0x00527b61 - 0x401000
.globl FUN_00527b61
FUN_00527b61:
    # block 0x00527b61: entry, 4 instruction(s), calls FUN_0047b21f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527b61
    add ecx, 0xae010                             # 00527b64
    call FUN_0047b21f                            # 00527b6a
    ret                                          # 00527b6f

