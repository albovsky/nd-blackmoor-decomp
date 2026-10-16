# FUN_005275cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005275cc
# extent:       0x005275cc-0x005275db (15 code bytes)
# span:         0x005275cc-0x005275db (code 15, tables 0, padding 0)
# sha256:       77d3602ee4f9e9188ba5d73b32bb650607478e0f98a6ee427aac2c773fc63549
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005275cc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048a6ee
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048a6ee, .text + (0x0048a6ee - 0x401000)

.org 0x005275cc - 0x401000
.globl FUN_005275cc
FUN_005275cc:
    # block 0x005275cc: entry, 4 instruction(s), calls FUN_0048a6ee, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005275cc
    add ecx, 0xacd87                             # 005275cf
    call FUN_0048a6ee                            # 005275d5
    ret                                          # 005275da

