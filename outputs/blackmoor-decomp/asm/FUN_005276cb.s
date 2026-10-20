# FUN_005276cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005276cb
# extent:       0x005276cb-0x005276da (15 code bytes)
# span:         0x005276cb-0x005276da (code 15, tables 0, padding 0)
# sha256:       a0dccfe0b9478eab3fb01e0ef4008f386b8c5019fbd1c18ba2d249e54c747e09
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005276cb
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044bea7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044bea7, .text + (0x0044bea7 - 0x401000)

.org 0x005276cb - 0x401000
.globl FUN_005276cb
FUN_005276cb:
    # block 0x005276cb: entry, 4 instruction(s), calls FUN_0044bea7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005276cb
    add ecx, 0xaf4d8                             # 005276ce
    call FUN_0044bea7                            # 005276d4
    ret                                          # 005276d9

