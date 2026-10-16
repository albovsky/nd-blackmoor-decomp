# FUN_004f842f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f842f
# extent:       0x004f842f-0x004f84a6 (119 code bytes)
# span:         0x004f842f-0x004f84a6 (code 119, tables 0, padding 0)
# sha256:       908d8dde1c9af99ec8263daaae42720a598a350726da4f70c00069bde735255c
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f842f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_44, field_19c, field_3ca, field_3d2; [ecx + n] field_19c, field_3ca; [edx + n] field_3ca, field_3d2
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_44, 0x44  # offset +0x44
.equ field_19c, 0x19c  # offset +0x19c
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f842f - 0x401000
.globl FUN_004f842f
FUN_004f842f:
    # block 0x004f842f: entry, 9 instruction(s), ends with je to 0x004f84a0 (forward)
    push ebp                                     # 004f842f
    {load} mov ebp, esp                          # 004f8430
    push ecx                                     # 004f8432
    mov dword ptr [ebp - local_4], ecx           # 004f8433
    mov eax, dword ptr [ebp - local_4]           # 004f8436
    mov dword ptr [eax + field_3ca], 0x0         # 004f8439
    mov ecx, dword ptr [ebp - local_4]           # 004f8443
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8446
    je.d8 L_004f84a0                             # 004f844d
    # block 0x004f844f: entered by fall-through of je at 0x004f844d, 3 instruction(s), ends with je to 0x004f84a0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f844f
    cmp dword ptr [edx + field_3d2], 0x0         # 004f8452
    je.d8 L_004f84a0                             # 004f8459
    # block 0x004f845b: entered by fall-through of je at 0x004f8459, 14 instruction(s), calls indirect dword ptr [eax + 0x44], ends with jne to 0x004f849c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f845b
    mov dword ptr [eax + field_3d2], 0x0         # 004f845e
    mov ecx, dword ptr [ebp - local_4]           # 004f8468
    mov edx, dword ptr [ecx + field_19c]         # 004f846b
    mov eax, dword ptr [ebp - local_4]           # 004f8471
    mov ecx, dword ptr [eax + field_19c]         # 004f8474
    mov eax, dword ptr [ecx]                     # 004f847a
    push edx                                     # 004f847c
    call dword ptr [eax + field_44]              # 004f847d
    mov ecx, dword ptr [ebp - local_4]           # 004f8480
    mov dword ptr [ecx + field_3ca], eax         # 004f8483
    mov edx, dword ptr [ebp - local_4]           # 004f8489
    cmp dword ptr [edx + field_3ca], 0x0         # 004f848c
    jne.d8 L_004f849c                            # 004f8493
    # block 0x004f8495: entered by fall-through of jne at 0x004f8493, 2 instruction(s), ends with forward jump to 0x004f84a2
    mov eax, 0x1                                 # 004f8495
    jmp.d8 L_004f84a2                            # 004f849a
L_004f849c:
    # block 0x004f849c: entered by jne at 0x004f8493, 2 instruction(s), ends with forward jump to 0x004f84a2
    {load} xor eax, eax                          # 004f849c
    jmp.d8 L_004f84a2                            # 004f849e
L_004f84a0:
    # block 0x004f84a0: entered by je at 0x004f844d; je at 0x004f8459, 1 instruction(s), falls into the block at 0x004f84a2
    {load} xor eax, eax                          # 004f84a0
L_004f84a2:
    # block 0x004f84a2: entered by jmp at 0x004f849a; jmp at 0x004f849e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f84a2
    pop ebp                                      # 004f84a4
    ret                                          # 004f84a5

