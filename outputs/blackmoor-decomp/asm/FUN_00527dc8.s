# FUN_00527dc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527dc8
# extent:       0x00527dc8-0x00527dd7 (15 code bytes)
# span:         0x00527dc8-0x00527dd7 (code 15, tables 0, padding 0)
# sha256:       15256a104c937c26a2c4f7e813c993a182be5bb96d06dab2d8a9f0e5bbe52193
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527dc8
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0041458b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00527dd7
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0041458b, .text + (0x0041458b - 0x401000)

.org 0x00527dc8 - 0x401000
.globl FUN_00527dc8
FUN_00527dc8:
    # block 0x00527dc8: entry, 4 instruction(s), calls FUN_0041458b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527dc8
    add ecx, 0xc8253                             # 00527dcb
    call FUN_0041458b                            # 00527dd1
    ret                                          # 00527dd6

