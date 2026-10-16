# FUN_005271ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005271ca
# extent:       0x005271ca-0x005271d9 (15 code bytes)
# span:         0x005271ca-0x005271d9 (code 15, tables 0, padding 0)
# sha256:       137010cbd12ea898c8b0dc021a1661a99a97bd6783a685953c3c1bf59b415d63
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005271ca
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x005271ca - 0x401000
.globl FUN_005271ca
FUN_005271ca:
    # block 0x005271ca: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005271ca
    add ecx, 0x84c                               # 005271cd
    call FUN_00401032                            # 005271d3
    ret                                          # 005271d8

