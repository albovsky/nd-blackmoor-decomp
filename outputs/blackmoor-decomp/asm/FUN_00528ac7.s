# FUN_00528ac7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528ac7
# extent:       0x00528ac7-0x00528ae2 (27 code bytes)
# span:         0x00528ac7-0x00528ae2 (code 27, tables 0, padding 0)
# sha256:       7144996e01b4cb9ab1265d41e06ba0ee4728505ffce0f66eb69e8038513eee26
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528ac7
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00528ae2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00528ac7 - 0x401000
.globl FUN_00528ac7
FUN_00528ac7:
    # block 0x00528ac7: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 00528ac7
    push 0x2                                     # 00528acc
    push 0x18f                                   # 00528ace
    mov eax, dword ptr [ebp - field_minus_10]    # 00528ad3
    add eax, 0xca8                               # 00528ad6
    push eax                                     # 00528adb
    call FUN_0050cba8                            # 00528adc
    ret                                          # 00528ae1

