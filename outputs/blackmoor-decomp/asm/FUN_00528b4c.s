# FUN_00528b4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528b4c
# extent:       0x00528b4c-0x00528b56 (10 code bytes)
# span:         0x00528b4c-0x00528b56 (code 10, tables 0, padding 0)
# sha256:       8547e53eb752bed8b9d7515bbb9226bbf3cc2185aa94929536b901963dbea003
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528b4c
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# name-note:    Compiler-generated unwind funclet: its address appears only as an unwind-map action of a FuncInfo (magic 0x19930520) that an __ehhandler stub names, and the stub is referenced by exactly one parent function. The funclet runs only while its parent unwinds a C++ exception; it has no behaviour of its own.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528b56
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00528b4c - 0x401000
.globl FUN_00528b4c
FUN_00528b4c:
    # block 0x00528b4c: entry, 4 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp + field_8]               # 00528b4c
    call FUN_0051dc6c                            # 00528b4f
    pop ecx                                      # 00528b54
    ret                                          # 00528b55

