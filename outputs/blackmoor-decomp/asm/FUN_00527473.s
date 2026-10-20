# FUN_00527473
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527473
# extent:       0x00527473-0x00527482 (15 code bytes)
# span:         0x00527473-0x00527482 (code 15, tables 0, padding 0)
# sha256:       0831092e6df8de9002d64bfe797e521c9450a03907c58714a577464b51edb94c
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527473
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004db27f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004db27f, .text + (0x004db27f - 0x401000)

.org 0x00527473 - 0x401000
.globl FUN_00527473
FUN_00527473:
    # block 0x00527473: entry, 4 instruction(s), calls FUN_004db27f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527473
    add ecx, 0x12d46                             # 00527476
    call FUN_004db27f                            # 0052747c
    ret                                          # 00527481

