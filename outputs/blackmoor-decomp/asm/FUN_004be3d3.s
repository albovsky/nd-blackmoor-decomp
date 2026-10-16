# FUN_004be3d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be3d3
# extent:       0x004be3d3-0x004be410 (61 code bytes)
# span:         0x004be3d3-0x004be410 (code 61, tables 0, padding 0)
# sha256:       14aa569d60c71ba130eab81c8d0d7bcc11bbf04c5ee2d351ec82d206fdb00ca5
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be3d3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_33d
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_33d, 0x33d  # offset +0x33d

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004be3d3 - 0x401000
.globl FUN_004be3d3
FUN_004be3d3:
    # block 0x004be3d3: entry, 13 instruction(s), ends with je to 0x004be40a (forward)
    push ebp                                     # 004be3d3
    {load} mov ebp, esp                          # 004be3d4
    push ecx                                     # 004be3d6
    push esi                                     # 004be3d7
    push edi                                     # 004be3d8
    mov dword ptr [ebp - local_4], ecx           # 004be3d9
    mov edi, 0x55214c                            # 004be3dc
    mov esi, dword ptr [ebp - local_4]           # 004be3e1
    add esi, 0x31c                               # 004be3e4
    mov ecx, 0x9                                 # 004be3ea
    {load} xor eax, eax                          # 004be3ef
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004be3f1
    je.d8 L_004be40a                             # 004be3f3
    # block 0x004be3f5: entered by fall-through of je at 0x004be3f3, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004be40a
    mov ecx, dword ptr [ebp - local_4]           # 004be3f5
    mov dx, word ptr [ecx + field_33d]           # 004be3f8
    push edx                                     # 004be3ff
    mov ecx, 0x5c3a67                            # 004be400
    call FUN_004fb2e3                            # 004be405
L_004be40a:
    # block 0x004be40a: entered by je at 0x004be3f3, 5 instruction(s), ends with ret
    pop edi                                      # 004be40a
    pop esi                                      # 004be40b
    {load} mov esp, ebp                          # 004be40c
    pop ebp                                      # 004be40e
    ret                                          # 004be40f

