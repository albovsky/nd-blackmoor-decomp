# FUN_00528880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528880
# extent:       0x00528880-0x0052888a (10 code bytes)
# span:         0x00528880-0x0052888a (code 10, tables 0, padding 0)
# sha256:       f0896af87a0cc47336f1dd4827976758098c840931dbe751db11745ee98db4e6
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528880
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052888a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00528880 - 0x401000
.globl FUN_00528880
FUN_00528880:
    # block 0x00528880: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00528880
    push eax                                     # 00528883
    call FUN_00401c90                            # 00528884
    ret                                          # 00528889

