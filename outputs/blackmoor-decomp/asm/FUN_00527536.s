# FUN_00527536
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527536
# extent:       0x00527536-0x00527545 (15 code bytes)
# span:         0x00527536-0x00527545 (code 15, tables 0, padding 0)
# sha256:       a7799fe773392fe556ff0febae0b96385b1d50aa66acc6802447a103a706349a
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527536
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00468e3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00468e3e, .text + (0x00468e3e - 0x401000)

.org 0x00527536 - 0x401000
.globl FUN_00527536
FUN_00527536:
    # block 0x00527536: entry, 4 instruction(s), calls FUN_00468e3e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527536
    add ecx, 0xa672a                             # 00527539
    call FUN_00468e3e                            # 0052753f
    ret                                          # 00527544

