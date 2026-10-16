# FUN_004f93ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f93ec
# extent:       0x004f93ec-0x004f94cb (223 code bytes)
# span:         0x004f93ec-0x004f94cb (code 223, tables 0, padding 0)
# sha256:       51783ac353f363fe108c8b741745a80e1be4decf9acb6b4eadf2e0967aa80dbe
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f93ec
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_40, field_29b, field_3ca, field_3d2; [ecx + n] field_29b, field_2d7, field_3ca, field_3ce; [edx + n] field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_40, 0x40  # offset +0x40
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f93ec - 0x401000
.globl FUN_004f93ec
FUN_004f93ec:
    # block 0x004f93ec: entry, 15 instruction(s), ends with je to 0x004f94c3 (forward)
    push ebp                                     # 004f93ec
    {load} mov ebp, esp                          # 004f93ed
    sub esp, 0x8                                 # 004f93ef
    mov dword ptr [ebp - local_8], ecx           # 004f93f2
    mov eax, dword ptr [ebp + arg_8]             # 004f93f5
    imul eax, eax, 0x5bb                         # 004f93f8
    mov ecx, dword ptr [ebp - local_8]           # 004f93fe
    mov edx, dword ptr [ecx + field_3ce]         # 004f9401
    {load} add edx, eax                          # 004f9407
    mov dword ptr [ebp - local_4], edx           # 004f9409
    mov eax, dword ptr [ebp - local_8]           # 004f940c
    mov dword ptr [eax + field_3ca], 0x0         # 004f940f
    mov ecx, dword ptr [ebp - local_4]           # 004f9419
    cmp dword ptr [ecx + field_29b], 0x0         # 004f941c
    je.d32 L_004f94c3                            # 004f9423
    # block 0x004f9429: entered by fall-through of je at 0x004f9423, 3 instruction(s), ends with je to 0x004f943c (forward)
    {load} xor edx, edx                          # 004f9429
    test edx, edx                                # 004f942b
    je.d8 L_004f943c                             # 004f942d
    # block 0x004f942f: entered by fall-through of je at 0x004f942d, 2 instruction(s), falls into the block at 0x004f943c
    mov eax, dword ptr [ebp - local_8]           # 004f942f
    mov dword ptr [eax + field_3d2], 0x1         # 004f9432
L_004f943c:
    # block 0x004f943c: entered by je at 0x004f942d, 18 instruction(s), calls indirect dword ptr [eax + 0x40], ends with jne to 0x004f94bf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f943c
    mov edx, dword ptr [ebp + arg_c]             # 004f943f
    mov dword ptr [ecx + field_2d7], edx         # 004f9442
    push 0x0                                     # 004f9448
    mov eax, dword ptr [ebp + arg_c]             # 004f944a
    push eax                                     # 004f944d
    mov ecx, dword ptr [ebp - local_4]           # 004f944e
    mov edx, dword ptr [ecx + field_29b]         # 004f9451
    mov eax, dword ptr [ebp - local_4]           # 004f9457
    mov ecx, dword ptr [eax + field_29b]         # 004f945a
    mov eax, dword ptr [ecx]                     # 004f9460
    push edx                                     # 004f9462
    call dword ptr [eax + field_40]              # 004f9463
    mov ecx, dword ptr [ebp - local_8]           # 004f9466
    mov dword ptr [ecx + field_3ca], eax         # 004f9469
    mov edx, dword ptr [ebp - local_8]           # 004f946f
    cmp dword ptr [edx + field_3ca], 0x0         # 004f9472
    jne.d8 L_004f94bf                            # 004f9479
    # block 0x004f947b: entered by fall-through of jne at 0x004f9479, 3 instruction(s), ends with je to 0x004f94b8 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f947b
    test eax, eax                                # 004f9482
    je.d8 L_004f94b8                             # 004f9484
    # block 0x004f9486: entered by fall-through of je at 0x004f9484, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f94b8
    mov ecx, dword ptr [ebp - local_4]           # 004f9486
    fld dword ptr [ecx + field_2d7]              # 004f9489
    sub esp, 0x8                                 # 004f948f
    fstp qword ptr [esp]                         # 004f9492
    mov edx, dword ptr [ebp + arg_8]             # 004f9495
    push edx                                     # 004f9498
    push 0x55f1bc                                # 004f9499
    push 0x63888b                                # 004f949e
    call FUN_0050ca3e                            # 004f94a3
    add esp, 0x14                                # 004f94a8
    push 0x63888b                                # 004f94ab
    call FUN_0044a2b7                            # 004f94b0
    add esp, 0x4                                 # 004f94b5
L_004f94b8:
    # block 0x004f94b8: entered by je at 0x004f9484, 2 instruction(s), ends with forward jump to 0x004f94c5
    mov eax, 0x1                                 # 004f94b8
    jmp.d8 L_004f94c5                            # 004f94bd
L_004f94bf:
    # block 0x004f94bf: entered by jne at 0x004f9479, 2 instruction(s), ends with forward jump to 0x004f94c5
    {load} xor eax, eax                          # 004f94bf
    jmp.d8 L_004f94c5                            # 004f94c1
L_004f94c3:
    # block 0x004f94c3: entered by je at 0x004f9423, 1 instruction(s), falls into the block at 0x004f94c5
    {load} xor eax, eax                          # 004f94c3
L_004f94c5:
    # block 0x004f94c5: entered by jmp at 0x004f94bd; jmp at 0x004f94c1, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f94c5
    pop ebp                                      # 004f94c7
    ret 0x8                                      # 004f94c8

