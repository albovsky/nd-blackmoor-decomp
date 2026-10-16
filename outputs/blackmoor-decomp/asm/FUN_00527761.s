# FUN_00527761
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527761
# extent:       0x00527761-0x00527770 (15 code bytes)
# span:         0x00527761-0x00527770 (code 15, tables 0, padding 0)
# sha256:       2e9eb80d766345485187732b70a256a93eab5000c4bceda713e478c6029b1685
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527761
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00456ceb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00456ceb, .text + (0x00456ceb - 0x401000)

.org 0x00527761 - 0x401000
.globl FUN_00527761
FUN_00527761:
    # block 0x00527761: entry, 4 instruction(s), calls FUN_00456ceb, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527761
    add ecx, 0xb4565                             # 00527764
    call FUN_00456ceb                            # 0052776a
    ret                                          # 0052776f

