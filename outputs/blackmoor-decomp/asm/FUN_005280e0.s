# FUN_005280e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005280e0
# extent:       0x005280e0-0x005280ea (10 code bytes)
# span:         0x005280e0-0x005280ea (code 10, tables 0, padding 0)
# sha256:       83fc44f18a7d6c3b8963f1507ccde86dadd3c92c06676b80abc671c57665603d
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005280e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005280ea
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x005280e0 - 0x401000
.globl FUN_005280e0
FUN_005280e0:
    # block 0x005280e0: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 005280e0
    push eax                                     # 005280e3
    call FUN_00401c90                            # 005280e4
    ret                                          # 005280e9

