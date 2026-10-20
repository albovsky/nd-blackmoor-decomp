# FUN_0052736e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052736e
# extent:       0x0052736e-0x0052737d (15 code bytes)
# span:         0x0052736e-0x0052737d (code 15, tables 0, padding 0)
# sha256:       c14cf46c95e4bebd1dda50ddbdcc15fec4eb92e1dba6c73b3bb754fa863fccaf
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@0052736e
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0052736e - 0x401000
.globl FUN_0052736e
FUN_0052736e:
    # block 0x0052736e: entry, 4 instruction(s), calls FUN_0051e7ba, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052736e
    add ecx, 0xf1d                               # 00527371
    call FUN_0051e7ba                            # 00527377
    ret                                          # 0052737c

