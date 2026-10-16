# FUN_00527662
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527662
# extent:       0x00527662-0x00527671 (15 code bytes)
# span:         0x00527662-0x00527671 (code 15, tables 0, padding 0)
# sha256:       03fd6be9592fa4da91475e9d44018ba3da7eddc31213c9d7deb5c0a515d74d3a
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527662
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004b9e1f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b9e1f, .text + (0x004b9e1f - 0x401000)

.org 0x00527662 - 0x401000
.globl FUN_00527662
FUN_00527662:
    # block 0x00527662: entry, 4 instruction(s), calls FUN_004b9e1f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527662
    add ecx, 0xadbce                             # 00527665
    call FUN_004b9e1f                            # 0052766b
    ret                                          # 00527670

