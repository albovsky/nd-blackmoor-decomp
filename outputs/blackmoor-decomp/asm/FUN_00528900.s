# FUN_00528900
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528900
# extent:       0x00528900-0x0052890f (15 code bytes)
# span:         0x00528900-0x0052890f (code 15, tables 0, padding 0)
# sha256:       11fd1ceffae7d025e1108083a09d262e94ba89adc15f91691ba56b4021cacf49
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528900
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e1c83
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)

.org 0x00528900 - 0x401000
.globl FUN_00528900
FUN_00528900:
    # block 0x00528900: entry, 4 instruction(s), calls FUN_004e1c83, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528900
    add ecx, 0x3ef                               # 00528903
    call FUN_004e1c83                            # 00528909
    ret                                          # 0052890e

