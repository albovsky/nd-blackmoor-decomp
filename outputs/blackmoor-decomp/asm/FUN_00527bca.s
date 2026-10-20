# FUN_00527bca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527bca
# extent:       0x00527bca-0x00527bd9 (15 code bytes)
# span:         0x00527bca-0x00527bd9 (code 15, tables 0, padding 0)
# sha256:       e0cf0c110facada26d8b49a3f1b90d2f78f7265dedc57b3877ac823706a45bed
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527bca
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004de1a4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de1a4, .text + (0x004de1a4 - 0x401000)

.org 0x00527bca - 0x401000
.globl FUN_00527bca
FUN_00527bca:
    # block 0x00527bca: entry, 4 instruction(s), calls FUN_004de1a4, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527bca
    add ecx, 0xaf4dc                             # 00527bcd
    call FUN_004de1a4                            # 00527bd3
    ret                                          # 00527bd8

