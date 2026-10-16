# FUN_005276ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005276ad
# extent:       0x005276ad-0x005276bc (15 code bytes)
# span:         0x005276ad-0x005276bc (code 15, tables 0, padding 0)
# sha256:       8aba692ce15cb7bb985c3000995f02a4328f17194140185812b04777ad574f25
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005276ad
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004b7f1f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b7f1f, .text + (0x004b7f1f - 0x401000)

.org 0x005276ad - 0x401000
.globl FUN_005276ad
FUN_005276ad:
    # block 0x005276ad: entry, 4 instruction(s), calls FUN_004b7f1f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005276ad
    add ecx, 0xaeae6                             # 005276b0
    call FUN_004b7f1f                            # 005276b6
    ret                                          # 005276bb

