# FUN_0052737d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052737d
# extent:       0x0052737d-0x0052738c (15 code bytes)
# span:         0x0052737d-0x0052738c (code 15, tables 0, padding 0)
# sha256:       3ec7f2f74057e0da48278de6e33cc05655bbd818c07cf96b3983023ea6fb787a
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@0052737d
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004230d1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052738c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004230d1, .text + (0x004230d1 - 0x401000)

.org 0x0052737d - 0x401000
.globl FUN_0052737d
FUN_0052737d:
    # block 0x0052737d: entry, 4 instruction(s), calls FUN_004230d1, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052737d
    add ecx, 0xfd1                               # 00527380
    call FUN_004230d1                            # 00527386
    ret                                          # 0052738b

