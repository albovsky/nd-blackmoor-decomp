# FUN_00528de8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528de8
# extent:       0x00528de8-0x00528df1 (9 code bytes)
# span:         0x00528de8-0x00528df1 (code 9, tables 0, padding 0)
# sha256:       01e44e1901dbfb07680daab9f22a2ff39be3655d15d20d3ef47698721baadbba
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528de8
# naming:       Ghidra name from function-index.json (not re-derived here); summary is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# summary:      Compiler-generated unwind funclet: its address appears only as an unwind-map action of a FuncInfo (magic 0x19930520) that an __ehhandler stub names, and the stub is referenced by exactly one parent function. The funclet runs only while its parent unwinds a C++ exception; it has no behaviour of its own.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528df1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x00528de8 - 0x401000
.globl FUN_00528de8
FUN_00528de8:
    # block 0x00528de8: entry, 3 instruction(s), calls FUN_005256fb, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528de8
    call FUN_005256fb                            # 00528deb
    ret                                          # 00528df0

