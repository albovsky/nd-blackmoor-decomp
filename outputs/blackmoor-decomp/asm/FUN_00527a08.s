# FUN_00527a08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a08
# extent:       0x00527a08-0x00527a17 (15 code bytes)
# span:         0x00527a08-0x00527a17 (code 15, tables 0, padding 0)
# sha256:       17891a7b71b9d5d5cf343bdf87d5e993122546baefa6102bc6254146d217c8bf
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527a08
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004d58cf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004d58cf, .text + (0x004d58cf - 0x401000)

.org 0x00527a08 - 0x401000
.globl FUN_00527a08
FUN_00527a08:
    # block 0x00527a08: entry, 4 instruction(s), calls FUN_004d58cf, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a08
    add ecx, 0x72ae8                             # 00527a0b
    call FUN_004d58cf                            # 00527a11
    ret                                          # 00527a16

