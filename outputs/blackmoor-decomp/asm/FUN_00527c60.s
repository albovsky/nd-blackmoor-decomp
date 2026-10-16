# FUN_00527c60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527c60
# extent:       0x00527c60-0x00527c6f (15 code bytes)
# span:         0x00527c60-0x00527c6f (code 15, tables 0, padding 0)
# sha256:       ba561a45798e836bf48607195da95e4c74ed6ae83042f5fe20ef4f23c25b46bb
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527c60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0044e74b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044e74b, .text + (0x0044e74b - 0x401000)

.org 0x00527c60 - 0x401000
.globl FUN_00527c60
FUN_00527c60:
    # block 0x00527c60: entry, 4 instruction(s), calls FUN_0044e74b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527c60
    add ecx, 0xb45a9                             # 00527c63
    call FUN_0044e74b                            # 00527c69
    ret                                          # 00527c6e

