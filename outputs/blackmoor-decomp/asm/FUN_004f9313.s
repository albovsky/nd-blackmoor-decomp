# FUN_004f9313
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9313
# extent:       0x004f9313-0x004f93ec (217 code bytes)
# span:         0x004f9313-0x004f93ec (code 217, tables 0, padding 0)
# sha256:       37d9e3f119c86d64dee102458aa79c1e3bb9578552b532c47746cdbd7cc4b48a
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f9313
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_29b, field_3ca, field_3d2; [ecx + n] field_29b, field_2d3, field_3ca, field_3ce; [edx + n] field_44, field_29b, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_44, 0x44  # offset +0x44
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f9313 - 0x401000
.globl FUN_004f9313
FUN_004f9313:
    # block 0x004f9313: entry, 15 instruction(s), ends with je to 0x004f93e4 (forward)
    push ebp                                     # 004f9313
    {load} mov ebp, esp                          # 004f9314
    sub esp, 0x8                                 # 004f9316
    mov dword ptr [ebp - local_8], ecx           # 004f9319
    mov eax, dword ptr [ebp + arg_8]             # 004f931c
    imul eax, eax, 0x5bb                         # 004f931f
    mov ecx, dword ptr [ebp - local_8]           # 004f9325
    mov edx, dword ptr [ecx + field_3ce]         # 004f9328
    {load} add edx, eax                          # 004f932e
    mov dword ptr [ebp - local_4], edx           # 004f9330
    mov eax, dword ptr [ebp - local_8]           # 004f9333
    mov dword ptr [eax + field_3ca], 0x0         # 004f9336
    mov ecx, dword ptr [ebp - local_4]           # 004f9340
    cmp dword ptr [ecx + field_29b], 0x0         # 004f9343
    je.d32 L_004f93e4                            # 004f934a
    # block 0x004f9350: entered by fall-through of je at 0x004f934a, 3 instruction(s), ends with je to 0x004f9363 (forward)
    {load} xor edx, edx                          # 004f9350
    test edx, edx                                # 004f9352
    je.d8 L_004f9363                             # 004f9354
    # block 0x004f9356: entered by fall-through of je at 0x004f9354, 2 instruction(s), falls into the block at 0x004f9363
    mov eax, dword ptr [ebp - local_8]           # 004f9356
    mov dword ptr [eax + field_3d2], 0x1         # 004f9359
L_004f9363:
    # block 0x004f9363: entered by je at 0x004f9354, 16 instruction(s), calls indirect dword ptr [edx + 0x44], ends with jne to 0x004f93e0 (forward)
    push 0x0                                     # 004f9363
    mov ecx, dword ptr [ebp - local_4]           # 004f9365
    mov edx, dword ptr [ecx + field_2d3]         # 004f9368
    push edx                                     # 004f936e
    mov eax, dword ptr [ebp - local_4]           # 004f936f
    mov ecx, dword ptr [eax + field_29b]         # 004f9372
    mov edx, dword ptr [ebp - local_4]           # 004f9378
    mov eax, dword ptr [edx + field_29b]         # 004f937b
    mov edx, dword ptr [eax]                     # 004f9381
    push ecx                                     # 004f9383
    call dword ptr [edx + field_44]              # 004f9384
    mov ecx, dword ptr [ebp - local_8]           # 004f9387
    mov dword ptr [ecx + field_3ca], eax         # 004f938a
    mov edx, dword ptr [ebp - local_8]           # 004f9390
    cmp dword ptr [edx + field_3ca], 0x0         # 004f9393
    jne.d8 L_004f93e0                            # 004f939a
    # block 0x004f939c: entered by fall-through of jne at 0x004f939a, 3 instruction(s), ends with je to 0x004f93d9 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f939c
    test eax, eax                                # 004f93a3
    je.d8 L_004f93d9                             # 004f93a5
    # block 0x004f93a7: entered by fall-through of je at 0x004f93a5, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f93d9
    mov ecx, dword ptr [ebp - local_4]           # 004f93a7
    fld dword ptr [ecx + field_2d3]              # 004f93aa
    sub esp, 0x8                                 # 004f93b0
    fstp qword ptr [esp]                         # 004f93b3
    mov edx, dword ptr [ebp + arg_8]             # 004f93b6
    push edx                                     # 004f93b9
    push 0x55f170                                # 004f93ba
    push 0x63888b                                # 004f93bf
    call FUN_0050ca3e                            # 004f93c4
    add esp, 0x14                                # 004f93c9
    push 0x63888b                                # 004f93cc
    call FUN_0044a2b7                            # 004f93d1
    add esp, 0x4                                 # 004f93d6
L_004f93d9:
    # block 0x004f93d9: entered by je at 0x004f93a5, 2 instruction(s), ends with forward jump to 0x004f93e6
    mov eax, 0x1                                 # 004f93d9
    jmp.d8 L_004f93e6                            # 004f93de
L_004f93e0:
    # block 0x004f93e0: entered by jne at 0x004f939a, 2 instruction(s), ends with forward jump to 0x004f93e6
    {load} xor eax, eax                          # 004f93e0
    jmp.d8 L_004f93e6                            # 004f93e2
L_004f93e4:
    # block 0x004f93e4: entered by je at 0x004f934a, 1 instruction(s), falls into the block at 0x004f93e6
    {load} xor eax, eax                          # 004f93e4
L_004f93e6:
    # block 0x004f93e6: entered by jmp at 0x004f93de; jmp at 0x004f93e2, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f93e6
    pop ebp                                      # 004f93e8
    ret 0x4                                      # 004f93e9

