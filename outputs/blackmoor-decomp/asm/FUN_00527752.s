# FUN_00527752
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527752
# extent:       0x00527752-0x00527761 (15 code bytes)
# span:         0x00527752-0x00527761 (code 15, tables 0, padding 0)
# sha256:       bb865f83c6f889f2bf09b122bc9c3ae7c7b261ce1ce57d953d74c423e9f71dab
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527752
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0045b3ce
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0045b3ce, .text + (0x0045b3ce - 0x401000)

.org 0x00527752 - 0x401000
.globl FUN_00527752
FUN_00527752:
    # block 0x00527752: entry, 4 instruction(s), calls FUN_0045b3ce, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527752
    add ecx, 0xb43ac                             # 00527755
    call FUN_0045b3ce                            # 0052775b
    ret                                          # 00527760

