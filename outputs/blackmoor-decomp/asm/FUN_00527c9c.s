# FUN_00527c9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527c9c
# extent:       0x00527c9c-0x00527cab (15 code bytes)
# span:         0x00527c9c-0x00527cab (code 15, tables 0, padding 0)
# sha256:       0e7d49d11dda560d81dfc16251f0b1c74a8651acf270939ff35fa041234419a3
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527c9c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0046e66a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0046e66a, .text + (0x0046e66a - 0x401000)

.org 0x00527c9c - 0x401000
.globl FUN_00527c9c
FUN_00527c9c:
    # block 0x00527c9c: entry, 4 instruction(s), calls FUN_0046e66a, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527c9c
    add ecx, 0xb48a2                             # 00527c9f
    call FUN_0046e66a                            # 00527ca5
    ret                                          # 00527caa

