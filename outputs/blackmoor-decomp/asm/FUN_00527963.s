# FUN_00527963
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527963
# extent:       0x00527963-0x00527972 (15 code bytes)
# span:         0x00527963-0x00527972 (code 15, tables 0, padding 0)
# sha256:       72e8315c0a54bd8f95e14a195fba4b87b40d2c1d4141596651fb3675f75bb6d8
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527963
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004db27f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004db27f, .text + (0x004db27f - 0x401000)

.org 0x00527963 - 0x401000
.globl FUN_00527963
FUN_00527963:
    # block 0x00527963: entry, 4 instruction(s), calls FUN_004db27f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527963
    add ecx, 0x12d46                             # 00527966
    call FUN_004db27f                            # 0052796c
    ret                                          # 00527971

