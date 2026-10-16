# FUN_00527b52
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527b52
# extent:       0x00527b52-0x00527b61 (15 code bytes)
# span:         0x00527b52-0x00527b61 (code 15, tables 0, padding 0)
# sha256:       3d68019131b40eeed5712f18560efb73c0f2707ca5c28ebc1fb2163b6d041b9c
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527b52
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004b9e1f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b9e1f, .text + (0x004b9e1f - 0x401000)

.org 0x00527b52 - 0x401000
.globl FUN_00527b52
FUN_00527b52:
    # block 0x00527b52: entry, 4 instruction(s), calls FUN_004b9e1f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527b52
    add ecx, 0xadbce                             # 00527b55
    call FUN_004b9e1f                            # 00527b5b
    ret                                          # 00527b60

