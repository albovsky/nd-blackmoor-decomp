# FUN_004f84a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f84a6
# extent:       0x004f84a6-0x004f8562 (188 code bytes)
# span:         0x004f84a6-0x004f8562 (code 188, tables 0, padding 0)
# sha256:       035a1fea04b3fbff038ca4f24b4ba30b0197c76bf90660f342b22c30e980e0d3
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f84a6
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_30, field_19c, field_3ca, field_3d2; [ecx + n] field_19c, field_278, field_3ca; [edx + n] field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_30, 0x30  # offset +0x30
.equ field_19c, 0x19c  # offset +0x19c
.equ field_278, 0x278  # offset +0x278
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f84a6 - 0x401000
.globl FUN_004f84a6
FUN_004f84a6:
    # block 0x004f84a6: entry, 9 instruction(s), ends with je to 0x004f855a (forward)
    push ebp                                     # 004f84a6
    {load} mov ebp, esp                          # 004f84a7
    push ecx                                     # 004f84a9
    mov dword ptr [ebp - local_4], ecx           # 004f84aa
    mov eax, dword ptr [ebp - local_4]           # 004f84ad
    mov dword ptr [eax + field_3ca], 0x0         # 004f84b0
    mov ecx, dword ptr [ebp - local_4]           # 004f84ba
    cmp dword ptr [ecx + field_19c], 0x0         # 004f84bd
    je.d32 L_004f855a                            # 004f84c4
    # block 0x004f84ca: entered by fall-through of je at 0x004f84c4, 3 instruction(s), ends with je to 0x004f84dd (forward)
    {load} xor edx, edx                          # 004f84ca
    test edx, edx                                # 004f84cc
    je.d8 L_004f84dd                             # 004f84ce
    # block 0x004f84d0: entered by fall-through of je at 0x004f84ce, 2 instruction(s), falls into the block at 0x004f84dd
    mov eax, dword ptr [ebp - local_4]           # 004f84d0
    mov dword ptr [eax + field_3d2], 0x1         # 004f84d3
L_004f84dd:
    # block 0x004f84dd: entered by je at 0x004f84ce, 18 instruction(s), calls indirect dword ptr [eax + 0x30], ends with jne to 0x004f8556 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f84dd
    mov edx, dword ptr [ebp + arg_8]             # 004f84e0
    mov dword ptr [ecx + field_278], edx         # 004f84e3
    push 0x0                                     # 004f84e9
    mov eax, dword ptr [ebp + arg_8]             # 004f84eb
    push eax                                     # 004f84ee
    mov ecx, dword ptr [ebp - local_4]           # 004f84ef
    mov edx, dword ptr [ecx + field_19c]         # 004f84f2
    mov eax, dword ptr [ebp - local_4]           # 004f84f8
    mov ecx, dword ptr [eax + field_19c]         # 004f84fb
    mov eax, dword ptr [ecx]                     # 004f8501
    push edx                                     # 004f8503
    call dword ptr [eax + field_30]              # 004f8504
    mov ecx, dword ptr [ebp - local_4]           # 004f8507
    mov dword ptr [ecx + field_3ca], eax         # 004f850a
    mov edx, dword ptr [ebp - local_4]           # 004f8510
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8513
    jne.d8 L_004f8556                            # 004f851a
    # block 0x004f851c: entered by fall-through of jne at 0x004f851a, 3 instruction(s), ends with je to 0x004f854f (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f851c
    test eax, eax                                # 004f8523
    je.d8 L_004f854f                             # 004f8525
    # block 0x004f8527: entered by fall-through of je at 0x004f8525, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f854f
    fld dword ptr [ebp + arg_8]                  # 004f8527
    sub esp, 0x8                                 # 004f852a
    fstp qword ptr [esp]                         # 004f852d
    push 0x55ee2c                                # 004f8530
    push 0x63888b                                # 004f8535
    call FUN_0050ca3e                            # 004f853a
    add esp, 0x10                                # 004f853f
    push 0x63888b                                # 004f8542
    call FUN_0044a2b7                            # 004f8547
    add esp, 0x4                                 # 004f854c
L_004f854f:
    # block 0x004f854f: entered by je at 0x004f8525, 2 instruction(s), ends with forward jump to 0x004f855c
    mov eax, 0x1                                 # 004f854f
    jmp.d8 L_004f855c                            # 004f8554
L_004f8556:
    # block 0x004f8556: entered by jne at 0x004f851a, 2 instruction(s), ends with forward jump to 0x004f855c
    {load} xor eax, eax                          # 004f8556
    jmp.d8 L_004f855c                            # 004f8558
L_004f855a:
    # block 0x004f855a: entered by je at 0x004f84c4, 1 instruction(s), falls into the block at 0x004f855c
    {load} xor eax, eax                          # 004f855a
L_004f855c:
    # block 0x004f855c: entered by jmp at 0x004f8554; jmp at 0x004f8558, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f855c
    pop ebp                                      # 004f855e
    ret 0x4                                      # 004f855f

