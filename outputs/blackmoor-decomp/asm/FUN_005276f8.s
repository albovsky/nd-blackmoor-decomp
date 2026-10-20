# FUN_005276f8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005276f8
# extent:       0x005276f8-0x00527707 (15 code bytes)
# span:         0x005276f8-0x00527707 (code 15, tables 0, padding 0)
# sha256:       8726bfd42ff634bb63af739c47684f73ad1656b992c6255aaf5efe0676d32ad7
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005276f8
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004afd1e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004afd1e, .text + (0x004afd1e - 0x401000)

.org 0x005276f8 - 0x401000
.globl FUN_005276f8
FUN_005276f8:
    # block 0x005276f8: entry, 4 instruction(s), calls FUN_004afd1e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005276f8
    add ecx, 0xb0139                             # 005276fb
    call FUN_004afd1e                            # 00527701
    ret                                          # 00527706

