# FUN_0052769e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052769e
# extent:       0x0052769e-0x005276ad (15 code bytes)
# span:         0x0052769e-0x005276ad (code 15, tables 0, padding 0)
# sha256:       396e326ddcb0e2a59b39545ff87d62b0afb7c28255b77726d451c82c13fceaf6
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052769e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00457f5e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00457f5e, .text + (0x00457f5e - 0x401000)

.org 0x0052769e - 0x401000
.globl FUN_0052769e
FUN_0052769e:
    # block 0x0052769e: entry, 4 instruction(s), calls FUN_00457f5e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052769e
    add ecx, 0xae9f3                             # 005276a1
    call FUN_00457f5e                            # 005276a7
    ret                                          # 005276ac

