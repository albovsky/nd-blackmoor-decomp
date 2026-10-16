# FUN_00527a71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a71
# extent:       0x00527a71-0x00527a80 (15 code bytes)
# span:         0x00527a71-0x00527a80 (code 15, tables 0, padding 0)
# sha256:       4e11d9c88111c27386668f5c06692d0cfa61b7af547c5385e35d24a364098f70
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a71
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044883f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044883f, .text + (0x0044883f - 0x401000)

.org 0x00527a71 - 0x401000
.globl FUN_00527a71
FUN_00527a71:
    # block 0x00527a71: entry, 4 instruction(s), calls FUN_0044883f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a71
    add ecx, 0xa967d                             # 00527a74
    call FUN_0044883f                            # 00527a7a
    ret                                          # 00527a7f

