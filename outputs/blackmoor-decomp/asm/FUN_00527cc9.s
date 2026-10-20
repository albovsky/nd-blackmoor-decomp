# FUN_00527cc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527cc9
# extent:       0x00527cc9-0x00527cd8 (15 code bytes)
# span:         0x00527cc9-0x00527cd8 (code 15, tables 0, padding 0)
# sha256:       98c8134f4078050415b62e0f21a0443451ee59ab5b2a1b50970dc796121112ca
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527cc9
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048e26e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048e26e, .text + (0x0048e26e - 0x401000)

.org 0x00527cc9 - 0x401000
.globl FUN_00527cc9
FUN_00527cc9:
    # block 0x00527cc9: entry, 4 instruction(s), calls FUN_0048e26e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527cc9
    add ecx, 0xb4a41                             # 00527ccc
    call FUN_0048e26e                            # 00527cd2
    ret                                          # 00527cd7

