# FUN_00527e32
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e32
# extent:       0x00527e32-0x00527e3b (9 code bytes)
# span:         0x00527e32-0x00527e3b (code 9, tables 0, padding 0)
# sha256:       9a05ecb079b9ca9231a2d87ebe074423fc89e7e42f934ac10d37c44189776887
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527e32
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00527e32 - 0x401000
.globl FUN_00527e32
FUN_00527e32:
    # block 0x00527e32: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp - field_minus_1c]              # 00527e32
    call FUN_0051e7ba                            # 00527e35
    ret                                          # 00527e3a

