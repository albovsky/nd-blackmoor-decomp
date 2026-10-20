# FUN_005274dc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274dc
# extent:       0x005274dc-0x005274eb (15 code bytes)
# span:         0x005274dc-0x005274eb (code 15, tables 0, padding 0)
# sha256:       1210186433ff11e2d0aa68ce8f78073f5d92f00a5a8d31a10c6534ddb2d11851
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005274dc
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004c139a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004c139a, .text + (0x004c139a - 0x401000)

.org 0x005274dc - 0x401000
.globl FUN_005274dc
FUN_005274dc:
    # block 0x005274dc: entry, 4 instruction(s), calls FUN_004c139a, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274dc
    add ecx, 0x5f2d1                             # 005274df
    call FUN_004c139a                            # 005274e5
    ret                                          # 005274ea

