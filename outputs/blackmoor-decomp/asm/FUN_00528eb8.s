# FUN_00528eb8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528eb8
# extent:       0x00528eb8-0x00528ecf (23 code bytes)
# span:         0x00528eb8-0x00528ecf (code 23, tables 0, padding 0)
# sha256:       3eb90c3c8ffa0b78d404be37908e84957f4db28251b2695f27e4fe1a03a82567
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528eb8
# naming:       Ghidra name from function-index.json (not re-derived here); summary is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# summary:      Compiler-generated unwind funclet: its address appears only as an unwind-map action of a FuncInfo (magic 0x19930520) that an __ehhandler stub names, and the stub is referenced by exactly one parent function. The funclet runs only while its parent unwinds a C++ exception; it has no behaviour of its own.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_10
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528eb8 - 0x401000
.globl FUN_00528eb8
FUN_00528eb8:
    # block 0x00528eb8: entry, 4 instruction(s), ends with je to 0x00528ece (forward)
    mov eax, dword ptr [ebp - field_minus_10]    # 00528eb8
    and eax, 0x1                                 # 00528ebb
    test eax, eax                                # 00528ebe
    je.d32 L_00528ece                            # 00528ec0
    # block 0x00528ec6: entered by fall-through of je at 0x00528ec0, 2 instruction(s), ends with backward jump to 0x0051e7ba
    mov ecx, dword ptr [ebp + field_8]           # 00528ec6
    jmp.d32 FUN_0051e7ba                         # 00528ec9
L_00528ece:
    # block 0x00528ece: entered by je at 0x00528ec0, 1 instruction(s), ends with ret
    ret                                          # 00528ece

