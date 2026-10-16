# FUN_0051ebc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ebc8
# extent:       0x0051ebc8-0x0051ebf2 (42 code bytes)
# span:         0x0051ebc8-0x0051ebf2 (code 42, tables 0, padding 0)
# sha256:       e98a3b29e5ef76427485c23cb1e24be7546060c6e9812c797b3a40ea1d9ddd6b
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ebc8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10, field_18; [ebp + n] field_8, field_minus_50
# callees:      calls FUN_0051ac62, KERNEL32.dll!SetEvent, FUN_0051ec84
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051ebf2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_50, 0x50  # offset -0x50
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0051ac62, .text + (0x0051ac62 - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x0051ebc8 - 0x401000
.globl FUN_0051ebc8
FUN_0051ebc8:
    # block 0x0051ebc8: entry, 11 instruction(s), calls FUN_0051ac62, KERNEL32.dll!SetEvent, FUN_0051ec84, ends with ret
    lea ecx, [ebp - field_minus_50]              # 0051ebc8
    call FUN_0051ac62                            # 0051ebcb
    mov eax, dword ptr [ebp + field_8]           # 0051ebd0
    push dword ptr [eax + field_10]              # 0051ebd3
    mov dword ptr [eax + field_18], 0x1          # 0051ebd6
    call dword ptr [0x52a1e8]                    # 0051ebdd
    push 0x0                                     # 0051ebe3
    push -0x1                                    # 0051ebe5
    call FUN_0051ec84                            # 0051ebe7
    mov eax, 0x51ebf2                            # 0051ebec
    ret                                          # 0051ebf1

