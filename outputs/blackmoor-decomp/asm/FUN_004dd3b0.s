# FUN_004dd3b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd3b0
# extent:       0x004dd3b0-0x004dd3cf (31 code bytes)
# span:         0x004dd3b0-0x004dd3cf (code 31, tables 0, padding 0)
# sha256:       f2b4beb24b5befbd6d16140d493616c440eeb130dd09559320e0b88d95d8e9f0
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dd3b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dd3eb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004dd3eb, .text + (0x004dd3eb - 0x401000)

.org 0x004dd3b0 - 0x401000
.globl FUN_004dd3b0
FUN_004dd3b0:
    # block 0x004dd3b0: entry, 12 instruction(s), calls FUN_004dd3eb, ends with ret
    push ebp                                     # 004dd3b0
    {load} mov ebp, esp                          # 004dd3b1
    push ecx                                     # 004dd3b3
    mov dword ptr [ebp - local_4], ecx           # 004dd3b4
    mov eax, dword ptr [ebp - local_4]           # 004dd3b7
    mov dword ptr [eax], 0x52e4c8                # 004dd3ba
    mov ecx, dword ptr [ebp - local_4]           # 004dd3c0
    call FUN_004dd3eb                            # 004dd3c3
    mov eax, dword ptr [ebp - local_4]           # 004dd3c8
    {load} mov esp, ebp                          # 004dd3cb
    pop ebp                                      # 004dd3cd
    ret                                          # 004dd3ce

