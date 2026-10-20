# FUN_0052789c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052789c
# extent:       0x0052789c-0x005278ab (15 code bytes)
# span:         0x0052789c-0x005278ab (code 15, tables 0, padding 0)
# sha256:       5cc183e64c15cd32db14ca48ceba23e042f8522fcbaef6b20d37a5950ba8cdb4
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@0052789c
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044afd6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044afd6, .text + (0x0044afd6 - 0x401000)

.org 0x0052789c - 0x401000
.globl FUN_0052789c
FUN_0052789c:
    # block 0x0052789c: entry, 4 instruction(s), calls FUN_0044afd6, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052789c
    add ecx, 0xc7c29                             # 0052789f
    call FUN_0044afd6                            # 005278a5
    ret                                          # 005278aa

