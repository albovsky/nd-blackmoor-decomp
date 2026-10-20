# FUN_005285b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005285b0
# extent:       0x005285b0-0x005285ba (10 code bytes)
# span:         0x005285b0-0x005285ba (code 10, tables 0, padding 0)
# sha256:       482bc006ea18c5df89039a037cb73a69b66fa6c6af118c9ceb36ecfbb070bf3e
# evidence:     ev_ae635b4fd276b6b5af385d914372d11115281daf9983e2ed88208809835d41c6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005285b0
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005285ba
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x005285b0 - 0x401000
.globl FUN_005285b0
FUN_005285b0:
    # block 0x005285b0: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 005285b0
    push eax                                     # 005285b3
    call FUN_00401c90                            # 005285b4
    ret                                          # 005285b9

