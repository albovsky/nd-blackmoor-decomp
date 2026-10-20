# FUN_00527396
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527396
# extent:       0x00527396-0x005273a2 (12 code bytes)
# span:         0x00527396-0x005273a2 (code 12, tables 0, padding 0)
# sha256:       4352552ee4c74f1c98b4e5dfdfe30f1ef4dbd5fc3855ef4279c36acd047e359c
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527396
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_657c
# callees:      calls FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005273a2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_657c, 0x657c  # offset -0x657c

# --- external targets -----------------------------------------------
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)

.org 0x00527396 - 0x401000
.globl FUN_00527396
FUN_00527396:
    # block 0x00527396: entry, 3 instruction(s), calls FUN_00433e63, ends with ret
    lea ecx, [ebp - field_minus_657c]            # 00527396
    call FUN_00433e63                            # 0052739c
    ret                                          # 005273a1

