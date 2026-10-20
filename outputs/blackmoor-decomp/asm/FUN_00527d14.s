# FUN_00527d14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527d14
# extent:       0x00527d14-0x00527d23 (15 code bytes)
# span:         0x00527d14-0x00527d23 (code 15, tables 0, padding 0)
# sha256:       b442d61126dfea3b3e5176f5204b35b55cc8502e211f6d42bb0823e207afa3cb
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527d14
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004a9f0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a9f0b, .text + (0x004a9f0b - 0x401000)

.org 0x00527d14 - 0x401000
.globl FUN_00527d14
FUN_00527d14:
    # block 0x00527d14: entry, 4 instruction(s), calls FUN_004a9f0b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527d14
    add ecx, 0xc06ac                             # 00527d17
    call FUN_004a9f0b                            # 00527d1d
    ret                                          # 00527d22

