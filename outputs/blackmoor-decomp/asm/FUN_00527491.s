# FUN_00527491
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527491
# extent:       0x00527491-0x005274a0 (15 code bytes)
# span:         0x00527491-0x005274a0 (code 15, tables 0, padding 0)
# sha256:       90aad15dc1e59839c2ef9d5d9ceeaec715e8b8b2e2f44db9913e461511ba25b1
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527491
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00447d2f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00447d2f, .text + (0x00447d2f - 0x401000)

.org 0x00527491 - 0x401000
.globl FUN_00527491
FUN_00527491:
    # block 0x00527491: entry, 4 instruction(s), calls FUN_00447d2f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527491
    add ecx, 0x12e78                             # 00527494
    call FUN_00447d2f                            # 0052749a
    ret                                          # 0052749f

