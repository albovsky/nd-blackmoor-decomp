# FUN_0052821d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052821d
# extent:       0x0052821d-0x0052822c (15 code bytes)
# span:         0x0052821d-0x0052822c (code 15, tables 0, padding 0)
# sha256:       357be229dbc04a26d42068643f3532fc3877f3291298de378238f94eca333cb7
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052821d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052822c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0052821d - 0x401000
.globl FUN_0052821d
FUN_0052821d:
    # block 0x0052821d: entry, 4 instruction(s), calls FUN_0051e7ba, ends with ret
    mov ecx, dword ptr [ebp - field_minus_14]    # 0052821d
    add ecx, 0x8d                                # 00528220
    call FUN_0051e7ba                            # 00528226
    ret                                          # 0052822b

