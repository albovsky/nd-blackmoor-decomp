# FUN_004be4c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be4c7
# extent:       0x004be4c7-0x004be504 (61 code bytes)
# span:         0x004be4c7-0x004be504 (code 61, tables 0, padding 0)
# sha256:       809b02543414ed0a294874d94ec5ca3a0075b487850ba455797570714ea1fd0d
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be4c7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_432
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_432, 0x432  # offset +0x432

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004be4c7 - 0x401000
.globl FUN_004be4c7
FUN_004be4c7:
    # block 0x004be4c7: entry, 13 instruction(s), ends with je to 0x004be4fe (forward)
    push ebp                                     # 004be4c7
    {load} mov ebp, esp                          # 004be4c8
    push ecx                                     # 004be4ca
    push esi                                     # 004be4cb
    push edi                                     # 004be4cc
    mov dword ptr [ebp - local_4], ecx           # 004be4cd
    mov edi, 0x55217c                            # 004be4d0
    mov esi, dword ptr [ebp - local_4]           # 004be4d5
    add esi, 0x411                               # 004be4d8
    mov ecx, 0x9                                 # 004be4de
    {load} xor eax, eax                          # 004be4e3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004be4e5
    je.d8 L_004be4fe                             # 004be4e7
    # block 0x004be4e9: entered by fall-through of je at 0x004be4e7, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004be4fe
    mov ecx, dword ptr [ebp - local_4]           # 004be4e9
    mov dx, word ptr [ecx + field_432]           # 004be4ec
    push edx                                     # 004be4f3
    mov ecx, 0x5c3a67                            # 004be4f4
    call FUN_004fb2e3                            # 004be4f9
L_004be4fe:
    # block 0x004be4fe: entered by je at 0x004be4e7, 5 instruction(s), ends with ret
    pop edi                                      # 004be4fe
    pop esi                                      # 004be4ff
    {load} mov esp, ebp                          # 004be500
    pop ebp                                      # 004be502
    ret                                          # 004be503

