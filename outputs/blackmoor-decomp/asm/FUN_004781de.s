# FUN_004781de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004781de
# extent:       0x004781de-0x004781fa (28 code bytes)
# span:         0x004781de-0x004781fa (code 28, tables 0, padding 0)
# sha256:       9ff09956f226558028f2c0e57833e463ca19310af0d2dfe01e67f02c05fb3c8b
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004781de
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004781de - 0x401000
.globl FUN_004781de
FUN_004781de:
    # block 0x004781de: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004781de
    {load} mov ebp, esp                          # 004781df
    push ecx                                     # 004781e1
    mov dword ptr [ebp - local_4], ecx           # 004781e2
    mov eax, dword ptr [ebp - local_4]           # 004781e5
    mov dword ptr [eax], 0x52d518                # 004781e8
    mov ecx, dword ptr [ebp - local_4]           # 004781ee
    call FUN_0051d730                            # 004781f1
    {load} mov esp, ebp                          # 004781f6
    pop ebp                                      # 004781f8
    ret                                          # 004781f9

