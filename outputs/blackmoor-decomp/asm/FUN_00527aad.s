# FUN_00527aad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527aad
# extent:       0x00527aad-0x00527abc (15 code bytes)
# span:         0x00527aad-0x00527abc (code 15, tables 0, padding 0)
# sha256:       8349379574b1727f5368b51ec2bc63f4e7767efb8130c54ef10d6aa69169b7d0
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527aad
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004a376e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a376e, .text + (0x004a376e - 0x401000)

.org 0x00527aad - 0x401000
.globl FUN_00527aad
FUN_00527aad:
    # block 0x00527aad: entry, 4 instruction(s), calls FUN_004a376e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527aad
    add ecx, 0xac547                             # 00527ab0
    call FUN_004a376e                            # 00527ab6
    ret                                          # 00527abb

