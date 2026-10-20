# FUN_005273d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005273d0
# extent:       0x005273d0-0x005273db (11 code bytes)
# span:         0x005273d0-0x005273db (code 11, tables 0, padding 0)
# sha256:       887b087f497b4503a22d6be2706ab53ff325acda7fb35468c0ea7f73d4bf4006
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005273d0
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x005273db
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x005273d0 - 0x401000
.globl FUN_005273d0
FUN_005273d0:
    # block 0x005273d0: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_1c]    # 005273d0
    push eax                                     # 005273d3
    call FUN_0051dc6c                            # 005273d4
    pop ecx                                      # 005273d9
    ret                                          # 005273da

