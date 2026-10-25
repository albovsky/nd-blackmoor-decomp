# FUN_00527e5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e5a
# extent:       0x00527e5a-0x00527e66 (12 code bytes)
# span:         0x00527e5a-0x00527e66 (code 12, tables 0, padding 0)
# sha256:       41a6eb24d132f394d50ea5495a3bc17fd54227fc56f50be095d9a9bc6e94e156
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527e5a
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_6290
# callees:      calls FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00527e66
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_6290, 0x6290  # offset -0x6290

# --- external targets -----------------------------------------------
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)

.org 0x00527e5a - 0x401000
.globl FUN_00527e5a
FUN_00527e5a:
    # block 0x00527e5a: entry, 3 instruction(s), calls FUN_00433e63, ends with ret
    lea ecx, [ebp - field_minus_6290]            # 00527e5a
    call FUN_00433e63                            # 00527e60
    ret                                          # 00527e65

