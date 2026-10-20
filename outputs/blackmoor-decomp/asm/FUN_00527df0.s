# FUN_00527df0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527df0
# extent:       0x00527df0-0x00527dfb (11 code bytes)
# span:         0x00527df0-0x00527dfb (code 11, tables 0, padding 0)
# sha256:       d0370829ac0d2cb6ab2dddd3ae2c621d342c60644ba3ec30b104c962af2d677b
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527df0
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_3c
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00527dfb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_3c, 0x3c  # offset -0x3c

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00527df0 - 0x401000
.globl FUN_00527df0
FUN_00527df0:
    # block 0x00527df0: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_3c]    # 00527df0
    push eax                                     # 00527df3
    call FUN_0051dc6c                            # 00527df4
    pop ecx                                      # 00527df9
    ret                                          # 00527dfa

