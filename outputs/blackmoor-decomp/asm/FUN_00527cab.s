# FUN_00527cab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527cab
# extent:       0x00527cab-0x00527cba (15 code bytes)
# span:         0x00527cab-0x00527cba (code 15, tables 0, padding 0)
# sha256:       754aad8f78a527da0c1c67e1dfa040407ed14918e2ba138c312524302b1ba7aa
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527cab
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044d0eb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044d0eb, .text + (0x0044d0eb - 0x401000)

.org 0x00527cab - 0x401000
.globl FUN_00527cab
FUN_00527cab:
    # block 0x00527cab: entry, 4 instruction(s), calls FUN_0044d0eb, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527cab
    add ecx, 0xb4937                             # 00527cae
    call FUN_0044d0eb                            # 00527cb4
    ret                                          # 00527cb9

