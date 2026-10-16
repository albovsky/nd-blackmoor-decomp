# FUN_00527d32
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527d32
# extent:       0x00527d32-0x00527d41 (15 code bytes)
# span:         0x00527d32-0x00527d41 (code 15, tables 0, padding 0)
# sha256:       2c6be04fe1a3e9ffcb3923b4db23d3f885589433f8600bc31c0f7402598fb322
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527d32
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00490547
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00490547, .text + (0x00490547 - 0x401000)

.org 0x00527d32 - 0x401000
.globl FUN_00527d32
FUN_00527d32:
    # block 0x00527d32: entry, 4 instruction(s), calls FUN_00490547, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527d32
    add ecx, 0xc0712                             # 00527d35
    call FUN_00490547                            # 00527d3b
    ret                                          # 00527d40

