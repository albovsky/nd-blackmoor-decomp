# FUN_00527b8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527b8e
# extent:       0x00527b8e-0x00527b9d (15 code bytes)
# span:         0x00527b8e-0x00527b9d (code 15, tables 0, padding 0)
# sha256:       8a2207c7fe4123515a91407106dd2b5d30dac2008640023e0ce52eed00d6eaaa
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527b8e
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00457f5e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00457f5e, .text + (0x00457f5e - 0x401000)

.org 0x00527b8e - 0x401000
.globl FUN_00527b8e
FUN_00527b8e:
    # block 0x00527b8e: entry, 4 instruction(s), calls FUN_00457f5e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527b8e
    add ecx, 0xae9f3                             # 00527b91
    call FUN_00457f5e                            # 00527b97
    ret                                          # 00527b9c

