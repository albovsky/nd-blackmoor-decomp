# FUN_005284f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005284f4
# extent:       0x005284f4-0x005284fd (9 code bytes)
# span:         0x005284f4-0x005284fd (code 9, tables 0, padding 0)
# sha256:       3b2deb41996c5171ce0ebff22eb187e679fa008c2614a5c06912b3b376d1f6dd
# evidence:     ev_ae635b4fd276b6b5af385d914372d11115281daf9983e2ed88208809835d41c6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005284f4
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005284fd
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x005284f4 - 0x401000
.globl FUN_005284f4
FUN_005284f4:
    # block 0x005284f4: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005284f4
    call FUN_0051d730                            # 005284f7
    ret                                          # 005284fc

