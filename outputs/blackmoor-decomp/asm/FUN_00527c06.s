# FUN_00527c06
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527c06
# extent:       0x00527c06-0x00527c15 (15 code bytes)
# span:         0x00527c06-0x00527c15 (code 15, tables 0, padding 0)
# sha256:       837e30a83b5ee03f58467318af49d6aa25ae28d70d6abaf37ff461df62bddac9
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527c06
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004757be
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004757be, .text + (0x004757be - 0x401000)

.org 0x00527c06 - 0x401000
.globl FUN_00527c06
FUN_00527c06:
    # block 0x00527c06: entry, 4 instruction(s), calls FUN_004757be, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527c06
    add ecx, 0xb2c1a                             # 00527c09
    call FUN_004757be                            # 00527c0f
    ret                                          # 00527c14

