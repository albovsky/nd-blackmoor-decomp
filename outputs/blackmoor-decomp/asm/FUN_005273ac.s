# FUN_005273ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005273ac
# extent:       0x005273ac-0x005273b7 (11 code bytes)
# span:         0x005273ac-0x005273b7 (code 11, tables 0, padding 0)
# sha256:       ae7c2a7745e9993e5d36cdb2bcd547480991a57fc75b67446be056126a1b839f
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005273ac
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_28
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x005273b7
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_28, 0x28  # offset -0x28

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x005273ac - 0x401000
.globl FUN_005273ac
FUN_005273ac:
    # block 0x005273ac: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_28]    # 005273ac
    push eax                                     # 005273af
    call FUN_0051dc6c                            # 005273b0
    pop ecx                                      # 005273b5
    ret                                          # 005273b6

