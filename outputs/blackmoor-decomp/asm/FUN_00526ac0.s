# FUN_00526ac0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526ac0
# extent:       0x00526ac0-0x00526aca (10 code bytes)
# span:         0x00526ac0-0x00526aca (code 10, tables 0, padding 0)
# sha256:       dcbbb45d307f80d614644577c398750f3c93ba14cdc7d34f3415ce0dd624e891
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526ac0
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00526aca
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00526ac0 - 0x401000
.globl FUN_00526ac0
FUN_00526ac0:
    # block 0x00526ac0: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00526ac0
    push eax                                     # 00526ac3
    call FUN_00401c90                            # 00526ac4
    ret                                          # 00526ac9

