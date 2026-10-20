# FUN_00527716
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527716
# extent:       0x00527716-0x00527725 (15 code bytes)
# span:         0x00527716-0x00527725 (code 15, tables 0, padding 0)
# sha256:       2f929f9cd6fd65ace37d6fb71293f820d778a816e376f866e2ba7b920e44baf5
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527716
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004757be
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004757be, .text + (0x004757be - 0x401000)

.org 0x00527716 - 0x401000
.globl FUN_00527716
FUN_00527716:
    # block 0x00527716: entry, 4 instruction(s), calls FUN_004757be, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527716
    add ecx, 0xb2c1a                             # 00527719
    call FUN_004757be                            # 0052771f
    ret                                          # 00527724

