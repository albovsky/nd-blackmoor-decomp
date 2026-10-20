# FUN_00527644
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527644
# extent:       0x00527644-0x00527653 (15 code bytes)
# span:         0x00527644-0x00527653 (code 15, tables 0, padding 0)
# sha256:       3f6e6498ccd1b26b03c91e4ca55a65d0775f66e886dab1c86e011c0e959c539f
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527644
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00487afe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00487afe, .text + (0x00487afe - 0x401000)

.org 0x00527644 - 0x401000
.globl FUN_00527644
FUN_00527644:
    # block 0x00527644: entry, 4 instruction(s), calls FUN_00487afe, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527644
    add ecx, 0xad450                             # 00527647
    call FUN_00487afe                            # 0052764d
    ret                                          # 00527652

