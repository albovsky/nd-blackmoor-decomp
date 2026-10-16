# FUN_00527134
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527134
# extent:       0x00527134-0x00527143 (15 code bytes)
# span:         0x00527134-0x00527143 (code 15, tables 0, padding 0)
# sha256:       865764510705d5dec6f4e6a8bf528ef747ea47fe0f60331a79b3ec62eaed42e9
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527134
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

.org 0x00527134 - 0x401000
.globl FUN_00527134
FUN_00527134:
    # block 0x00527134: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527134
    add ecx, 0x5cc                               # 00527137
    call FUN_00401032                            # 0052713d
    ret                                          # 00527142

