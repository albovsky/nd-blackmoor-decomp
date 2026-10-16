# FUN_004f5f69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f5f69
# extent:       0x004f5f69-0x004f6059 (240 code bytes)
# span:         0x004f5f69-0x004f6059 (code 240, tables 0, padding 0)
# sha256:       6baa90e35da9fc2f0c28c9545c919fc56afc8c7791360f480202f1b3dfd4e0c5
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f5f69
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_194, field_228, field_3ca; [ecx + n] field_218, field_220, field_3ca; [edx + n] field_4, field_8, field_c, field_194, field_21c, field_3ca
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 70 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_194, 0x194  # offset +0x194
.equ field_218, 0x218  # offset +0x218
.equ field_21c, 0x21c  # offset +0x21c
.equ field_220, 0x220  # offset +0x220
.equ field_228, 0x228  # offset +0x228
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------

.org 0x004f5f69 - 0x401000
.globl FUN_004f5f69
FUN_004f5f69:
    # block 0x004f5f69: entry, 36 instruction(s), ends with je to 0x004f600c (forward)
    push ebp                                     # 004f5f69
    {load} mov ebp, esp                          # 004f5f6a
    push ecx                                     # 004f5f6c
    push edi                                     # 004f5f6d
    mov dword ptr [ebp - local_4], ecx           # 004f5f6e
    mov eax, dword ptr [ebp - local_4]           # 004f5f71
    mov dword ptr [eax + field_3ca], 0x0         # 004f5f74
    mov ecx, 0x9                                 # 004f5f7e
    {load} xor eax, eax                          # 004f5f83
    mov edi, dword ptr [ebp - local_4]           # 004f5f85
    add edi, 0x218                               # 004f5f88
    rep stosd dword ptr es:[edi], eax            # 004f5f8e
    mov ecx, dword ptr [ebp - local_4]           # 004f5f90
    mov dword ptr [ecx + field_218], 0x24        # 004f5f93
    mov edx, dword ptr [ebp - local_4]           # 004f5f9d
    mov eax, dword ptr [ebp + arg_10]            # 004f5fa0
    mov dword ptr [edx + field_21c], eax         # 004f5fa3
    mov ecx, dword ptr [ebp - local_4]           # 004f5fa9
    mov edx, dword ptr [ebp + arg_c]             # 004f5fac
    mov dword ptr [ecx + field_220], edx         # 004f5faf
    mov eax, dword ptr [ebp - local_4]           # 004f5fb5
    mov ecx, dword ptr [ebp + arg_14]            # 004f5fb8
    mov dword ptr [eax + field_228], ecx         # 004f5fbb
    mov edx, dword ptr [ebp - local_4]           # 004f5fc1
    add edx, 0x22c                               # 004f5fc4
    mov eax, dword ptr [0x52e51c]                # 004f5fca
    mov dword ptr [edx], eax                     # 004f5fcf
    mov ecx, dword ptr [0x52e520]                # 004f5fd1
    mov dword ptr [edx + field_4], ecx           # 004f5fd7
    mov eax, dword ptr [0x52e524]                # 004f5fda
    mov dword ptr [edx + field_8], eax           # 004f5fdf
    mov ecx, dword ptr [0x52e528]                # 004f5fe2
    mov dword ptr [edx + field_c], ecx           # 004f5fe8
    mov edx, dword ptr [ebp + arg_8]             # 004f5feb
    cmp dword ptr [edx], 0x0                     # 004f5fee
    je.d8 L_004f600c                             # 004f5ff1
    # block 0x004f5ff3: entered by fall-through of je at 0x004f5ff1, 9 instruction(s), calls indirect dword ptr [edx + 0x8], falls into the block at 0x004f600c
    mov eax, dword ptr [ebp + arg_8]             # 004f5ff3
    mov ecx, dword ptr [eax]                     # 004f5ff6
    mov edx, dword ptr [ebp + arg_8]             # 004f5ff8
    mov eax, dword ptr [edx]                     # 004f5ffb
    mov edx, dword ptr [eax]                     # 004f5ffd
    push ecx                                     # 004f5fff
    call dword ptr [edx + field_8]               # 004f6000
    mov eax, dword ptr [ebp + arg_8]             # 004f6003
    mov dword ptr [eax], 0x0                     # 004f6006
L_004f600c:
    # block 0x004f600c: entered by je at 0x004f5ff1, 18 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x004f604d (forward)
    push 0x0                                     # 004f600c
    mov ecx, dword ptr [ebp + arg_8]             # 004f600e
    push ecx                                     # 004f6011
    mov edx, dword ptr [ebp - local_4]           # 004f6012
    add edx, 0x218                               # 004f6015
    push edx                                     # 004f601b
    mov eax, dword ptr [ebp - local_4]           # 004f601c
    mov ecx, dword ptr [eax + field_194]         # 004f601f
    mov edx, dword ptr [ebp - local_4]           # 004f6025
    mov eax, dword ptr [edx + field_194]         # 004f6028
    mov edx, dword ptr [eax]                     # 004f602e
    push ecx                                     # 004f6030
    call dword ptr [edx + field_c]               # 004f6031
    mov ecx, dword ptr [ebp - local_4]           # 004f6034
    mov dword ptr [ecx + field_3ca], eax         # 004f6037
    mov edx, dword ptr [ebp - local_4]           # 004f603d
    cmp dword ptr [edx + field_3ca], 0x0         # 004f6040
    je.d8 L_004f604d                             # 004f6047
    # block 0x004f6049: entered by fall-through of je at 0x004f6047, 2 instruction(s), ends with forward jump to 0x004f6052
    {load} xor eax, eax                          # 004f6049
    jmp.d8 L_004f6052                            # 004f604b
L_004f604d:
    # block 0x004f604d: entered by je at 0x004f6047, 1 instruction(s), falls into the block at 0x004f6052
    mov eax, 0x1                                 # 004f604d
L_004f6052:
    # block 0x004f6052: entered by jmp at 0x004f604b, 4 instruction(s), ends with ret 0x10
    pop edi                                      # 004f6052
    {load} mov esp, ebp                          # 004f6053
    pop ebp                                      # 004f6055
    ret 0x10                                     # 004f6056

