# FUN_00527b9d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527b9d
# extent:       0x00527b9d-0x00527bac (15 code bytes)
# span:         0x00527b9d-0x00527bac (code 15, tables 0, padding 0)
# sha256:       83455e802cf11d3eb7e3e8935c10892f9f8a9a4e950c16cc721718bf0ec36418
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527b9d
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004b7f1f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b7f1f, .text + (0x004b7f1f - 0x401000)

.org 0x00527b9d - 0x401000
.globl FUN_00527b9d
FUN_00527b9d:
    # block 0x00527b9d: entry, 4 instruction(s), calls FUN_004b7f1f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527b9d
    add ecx, 0xaeae6                             # 00527ba0
    call FUN_004b7f1f                            # 00527ba6
    ret                                          # 00527bab

