# FUN_0050cc9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cc9c
# extent:       0x0050cc9c-0x0050ccb3 (23 code bytes)
# span:         0x0050cc9c-0x0050ccb3 (code 23, tables 0, padding 0)
# sha256:       8d4c50898a1d81ef3c6f08af2380fc1c84690c65acf2b9ce83464dd6f51b1fb5
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cc9c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ccb4, FUN_00511a58, FUN_00511a08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050ccb4, .text + (0x0050ccb4 - 0x401000)
.set FUN_00511a08, .text + (0x00511a08 - 0x401000)
.set FUN_00511a58, .text + (0x00511a58 - 0x401000)

.org 0x0050cc9c - 0x401000
.globl FUN_0050cc9c
FUN_0050cc9c:
    # block 0x0050cc9c: entry, 6 instruction(s), calls FUN_0050ccb4, FUN_00511a58, FUN_00511a08, ends with ret
    call FUN_0050ccb4                            # 0050cc9c
    call FUN_00511a58                            # 0050cca1
    mov dword ptr [0x63ca08], eax                # 0050cca6
    call FUN_00511a08                            # 0050ccab
    fnclex                                       # 0050ccb0
    ret                                          # 0050ccb2

