# FUN_00528830
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528830
# extent:       0x00528830-0x0052883e (14 code bytes)
# span:         0x00528830-0x0052883e (code 14, tables 0, padding 0)
# sha256:       0609c735381e21e98aa6190b89d9fe194e88a9b06208daee901793c37a8fe43e
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528830
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_11c
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052883e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_11c, 0x11c  # offset -0x11c

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00528830 - 0x401000
.globl FUN_00528830
FUN_00528830:
    # block 0x00528830: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_11c]   # 00528830
    push eax                                     # 00528836
    call FUN_0051dc6c                            # 00528837
    pop ecx                                      # 0052883c
    ret                                          # 0052883d

