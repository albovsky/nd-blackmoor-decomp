# FUN_00528d07
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528d07
# extent:       0x00528d07-0x00528d12 (11 code bytes)
# span:         0x00528d07-0x00528d12 (code 11, tables 0, padding 0)
# sha256:       a3a72d06ccceebd85df915310137807448f649bd50dbea1e5caf94364d3daebe
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528d07
# naming:       Ghidra name from function-index.json (not re-derived here); summary is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# summary:      Compiler-generated unwind funclet: its address appears only as an unwind-map action of a FuncInfo (magic 0x19930520) that an __ehhandler stub names, and the stub is referenced by exactly one parent function. The funclet runs only while its parent unwinds a C++ exception; it has no behaviour of its own.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528d12
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528d07 - 0x401000
.globl FUN_00528d07
FUN_00528d07:
    # block 0x00528d07: entry, 3 instruction(s), ends with backward jump to 0x0051e7ba
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528d07
    add ecx, 0x78                                # 00528d0a
    jmp.d32 FUN_0051e7ba                         # 00528d0d

