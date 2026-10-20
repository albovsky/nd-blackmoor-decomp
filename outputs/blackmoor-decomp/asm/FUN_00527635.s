# FUN_00527635
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527635
# extent:       0x00527635-0x00527644 (15 code bytes)
# span:         0x00527635-0x00527644 (code 15, tables 0, padding 0)
# sha256:       6f5c78b01ca626c57b1d1d20933ead2a0d855b1325e9c1d24d1c140a7365b9b5
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527635
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0046180b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0046180b, .text + (0x0046180b - 0x401000)

.org 0x00527635 - 0x401000
.globl FUN_00527635
FUN_00527635:
    # block 0x00527635: entry, 4 instruction(s), calls FUN_0046180b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527635
    add ecx, 0xad3f1                             # 00527638
    call FUN_0046180b                            # 0052763e
    ret                                          # 00527643

