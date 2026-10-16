# FUN_00527f10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527f10
# extent:       0x00527f10-0x00527f1a (10 code bytes)
# span:         0x00527f10-0x00527f1a (code 10, tables 0, padding 0)
# sha256:       4e30edf16ddb679252371f832e53903922b6bab2d97c359e36346dccb6a1c635
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527f10
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_78
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00527f1a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_78, 0x78  # offset -0x78

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00527f10 - 0x401000
.globl FUN_00527f10
FUN_00527f10:
    # block 0x00527f10: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_78]    # 00527f10
    push eax                                     # 00527f13
    call FUN_00401c90                            # 00527f14
    ret                                          # 00527f19

