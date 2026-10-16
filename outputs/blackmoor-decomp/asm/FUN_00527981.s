# FUN_00527981
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527981
# extent:       0x00527981-0x00527990 (15 code bytes)
# span:         0x00527981-0x00527990 (code 15, tables 0, padding 0)
# sha256:       3a16f394675de190862e79a46ebb2c1776ba82a2f811fd2ed67fe178e0606972
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527981
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00447d2f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00447d2f, .text + (0x00447d2f - 0x401000)

.org 0x00527981 - 0x401000
.globl FUN_00527981
FUN_00527981:
    # block 0x00527981: entry, 4 instruction(s), calls FUN_00447d2f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527981
    add ecx, 0x12e78                             # 00527984
    call FUN_00447d2f                            # 0052798a
    ret                                          # 0052798f

