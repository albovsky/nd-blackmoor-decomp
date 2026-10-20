# FUN_00527455
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527455
# extent:       0x00527455-0x00527464 (15 code bytes)
# span:         0x00527455-0x00527464 (code 15, tables 0, padding 0)
# sha256:       b6ba144d759d3627e020cd10dfee476ca2caf697ec7d35444aee7ecb4814d70a
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527455
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004eb8fe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004eb8fe, .text + (0x004eb8fe - 0x401000)

.org 0x00527455 - 0x401000
.globl FUN_00527455
FUN_00527455:
    # block 0x00527455: entry, 4 instruction(s), calls FUN_004eb8fe, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527455
    add ecx, 0xf9ac                              # 00527458
    call FUN_004eb8fe                            # 0052745e
    ret                                          # 00527463

