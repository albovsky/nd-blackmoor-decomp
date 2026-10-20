# FUN_00527860
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527860
# extent:       0x00527860-0x0052786f (15 code bytes)
# span:         0x00527860-0x0052786f (code 15, tables 0, padding 0)
# sha256:       66c0054880f7a63751939c5f42e18fe7e4401fb437700b9655b3793d72aad6a9
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527860
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004ac8be
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004ac8be, .text + (0x004ac8be - 0x401000)

.org 0x00527860 - 0x401000
.globl FUN_00527860
FUN_00527860:
    # block 0x00527860: entry, 4 instruction(s), calls FUN_004ac8be, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527860
    add ecx, 0xc665c                             # 00527863
    call FUN_004ac8be                            # 00527869
    ret                                          # 0052786e

