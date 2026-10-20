# FUN_00529008
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529008
# extent:       0x00529008-0x00529012 (10 code bytes)
# span:         0x00529008-0x00529012 (code 10, tables 0, padding 0)
# sha256:       9a9ecb5fbf08613448a87e9a663aa1ddda02f369d0ba7ea5c258b6bb904307bd
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00529008
# naming:       Ghidra name from function-index.json (not re-derived here); summary is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# summary:      Compiler-generated unwind funclet: its address appears only as an unwind-map action of a FuncInfo (magic 0x19930520) that an __ehhandler stub names, and the stub is referenced by exactly one parent function. The funclet runs only while its parent unwinds a C++ exception; it has no behaviour of its own.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00529012
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00529008 - 0x401000
.globl FUN_00529008
FUN_00529008:
    # block 0x00529008: entry, 4 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp + field_8]               # 00529008
    call FUN_0051dc6c                            # 0052900b
    pop ecx                                      # 00529010
    ret                                          # 00529011

