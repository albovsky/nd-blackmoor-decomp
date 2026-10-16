# FUN_00527170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527170
# extent:       0x00527170-0x0052717f (15 code bytes)
# span:         0x00527170-0x0052717f (code 15, tables 0, padding 0)
# sha256:       a3fdd5ebabf238fc84b668cb6a02fdb2a3d7eb30d09e22aafa5ed445559b2986
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527170
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

.org 0x00527170 - 0x401000
.globl FUN_00527170
FUN_00527170:
    # block 0x00527170: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527170
    add ecx, 0x6cc                               # 00527173
    call FUN_00401032                            # 00527179
    ret                                          # 0052717e

