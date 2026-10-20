# FUN_00527563
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527563
# extent:       0x00527563-0x00527572 (15 code bytes)
# span:         0x00527563-0x00527572 (code 15, tables 0, padding 0)
# sha256:       f5a3b4e0f1e6db0a962084243d646ba90671320882f9a3a44c9039225e35fcd1
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527563
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00446faa
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00446faa, .text + (0x00446faa - 0x401000)

.org 0x00527563 - 0x401000
.globl FUN_00527563
FUN_00527563:
    # block 0x00527563: entry, 4 instruction(s), calls FUN_00446faa, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527563
    add ecx, 0xa954f                             # 00527566
    call FUN_00446faa                            # 0052756c
    ret                                          # 00527571

