# FUN_005279db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005279db
# extent:       0x005279db-0x005279ea (15 code bytes)
# span:         0x005279db-0x005279ea (code 15, tables 0, padding 0)
# sha256:       e9cae3ffa852c94e5b1c189b03d82384239c34951c55f885fe81098bbb8866b7
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005279db
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0043ef27
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)

.org 0x005279db - 0x401000
.globl FUN_005279db
FUN_005279db:
    # block 0x005279db: entry, 4 instruction(s), calls FUN_0043ef27, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005279db
    add ecx, 0x62ba5                             # 005279de
    call FUN_0043ef27                            # 005279e4
    ret                                          # 005279e9

