# FUN_00527d6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527d6e
# extent:       0x00527d6e-0x00527d7d (15 code bytes)
# span:         0x00527d6e-0x00527d7d (code 15, tables 0, padding 0)
# sha256:       0b7e279d05011acbf38bac8a620166c2aea0dc2d021b907346a9ba9fec739801
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527d6e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004dbf6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004dbf6e, .text + (0x004dbf6e - 0x401000)

.org 0x00527d6e - 0x401000
.globl FUN_00527d6e
FUN_00527d6e:
    # block 0x00527d6e: entry, 4 instruction(s), calls FUN_004dbf6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527d6e
    add ecx, 0xc7afd                             # 00527d71
    call FUN_004dbf6e                            # 00527d77
    ret                                          # 00527d7c

