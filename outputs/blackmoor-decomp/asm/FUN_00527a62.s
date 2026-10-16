# FUN_00527a62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a62
# extent:       0x00527a62-0x00527a71 (15 code bytes)
# span:         0x00527a62-0x00527a71 (code 15, tables 0, padding 0)
# sha256:       250c68d97726bb4a5f5db446aa0c138d6d5479a642cfcfdc9ce03538a797e7ae
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a62
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00488d89
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00488d89, .text + (0x00488d89 - 0x401000)

.org 0x00527a62 - 0x401000
.globl FUN_00527a62
FUN_00527a62:
    # block 0x00527a62: entry, 4 instruction(s), calls FUN_00488d89, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a62
    add ecx, 0xa95ad                             # 00527a65
    call FUN_00488d89                            # 00527a6b
    ret                                          # 00527a70

