# FUN_004f8df4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8df4
# extent:       0x004f8df4-0x004f8ec8 (212 code bytes)
# span:         0x004f8df4-0x004f8ec8 (code 212, tables 0, padding 0)
# sha256:       c5274d35bb66fda46918cc408b138b3c8baf5ebc94d19accd51e1ae3c95c9002
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8df4
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4c, field_29b, field_2a7, field_3ca, field_3d2; [ecx + n] field_29b, field_2a3, field_2ab, field_3ca, field_3ce; [edx + n] field_2a3, field_2ab, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_4c, 0x4c  # offset +0x4c
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f8df4 - 0x401000
.globl FUN_004f8df4
FUN_004f8df4:
    # block 0x004f8df4: entry, 15 instruction(s), ends with je to 0x004f8ec0 (forward)
    push ebp                                     # 004f8df4
    {load} mov ebp, esp                          # 004f8df5
    sub esp, 0x8                                 # 004f8df7
    mov dword ptr [ebp - local_8], ecx           # 004f8dfa
    mov eax, dword ptr [ebp + arg_8]             # 004f8dfd
    imul eax, eax, 0x5bb                         # 004f8e00
    mov ecx, dword ptr [ebp - local_8]           # 004f8e06
    mov edx, dword ptr [ecx + field_3ce]         # 004f8e09
    {load} add edx, eax                          # 004f8e0f
    mov dword ptr [ebp - local_4], edx           # 004f8e11
    mov eax, dword ptr [ebp - local_8]           # 004f8e14
    mov dword ptr [eax + field_3ca], 0x0         # 004f8e17
    mov ecx, dword ptr [ebp - local_4]           # 004f8e21
    cmp dword ptr [ecx + field_29b], 0x0         # 004f8e24
    je.d32 L_004f8ec0                            # 004f8e2b
    # block 0x004f8e31: entered by fall-through of je at 0x004f8e2b, 3 instruction(s), ends with je to 0x004f8e44 (forward)
    {load} xor edx, edx                          # 004f8e31
    test edx, edx                                # 004f8e33
    je.d8 L_004f8e44                             # 004f8e35
    # block 0x004f8e37: entered by fall-through of je at 0x004f8e35, 2 instruction(s), falls into the block at 0x004f8e44
    mov eax, dword ptr [ebp - local_8]           # 004f8e37
    mov dword ptr [eax + field_3d2], 0x1         # 004f8e3a
L_004f8e44:
    # block 0x004f8e44: entered by je at 0x004f8e35, 31 instruction(s), calls indirect dword ptr [eax + 0x4c], ends with jne to 0x004f8ebc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8e44
    mov edx, dword ptr [ebp + arg_c]             # 004f8e47
    mov dword ptr [ecx + field_2a3], edx         # 004f8e4a
    mov eax, dword ptr [ebp - local_4]           # 004f8e50
    mov ecx, dword ptr [ebp + arg_10]            # 004f8e53
    mov dword ptr [eax + field_2a7], ecx         # 004f8e56
    mov edx, dword ptr [ebp - local_4]           # 004f8e5c
    mov eax, dword ptr [ebp + arg_14]            # 004f8e5f
    mov dword ptr [edx + field_2ab], eax         # 004f8e62
    push 0x0                                     # 004f8e68
    mov ecx, dword ptr [ebp - local_4]           # 004f8e6a
    mov edx, dword ptr [ecx + field_2ab]         # 004f8e6d
    push edx                                     # 004f8e73
    mov eax, dword ptr [ebp - local_4]           # 004f8e74
    mov ecx, dword ptr [eax + field_2a7]         # 004f8e77
    push ecx                                     # 004f8e7d
    mov edx, dword ptr [ebp - local_4]           # 004f8e7e
    mov eax, dword ptr [edx + field_2a3]         # 004f8e81
    push eax                                     # 004f8e87
    mov ecx, dword ptr [ebp - local_4]           # 004f8e88
    mov edx, dword ptr [ecx + field_29b]         # 004f8e8b
    mov eax, dword ptr [ebp - local_4]           # 004f8e91
    mov ecx, dword ptr [eax + field_29b]         # 004f8e94
    mov eax, dword ptr [ecx]                     # 004f8e9a
    push edx                                     # 004f8e9c
    call dword ptr [eax + field_4c]              # 004f8e9d
    mov ecx, dword ptr [ebp - local_8]           # 004f8ea0
    mov dword ptr [ecx + field_3ca], eax         # 004f8ea3
    mov edx, dword ptr [ebp - local_8]           # 004f8ea9
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8eac
    jne.d8 L_004f8ebc                            # 004f8eb3
    # block 0x004f8eb5: entered by fall-through of jne at 0x004f8eb3, 2 instruction(s), ends with forward jump to 0x004f8ec2
    mov eax, 0x1                                 # 004f8eb5
    jmp.d8 L_004f8ec2                            # 004f8eba
L_004f8ebc:
    # block 0x004f8ebc: entered by jne at 0x004f8eb3, 2 instruction(s), ends with forward jump to 0x004f8ec2
    {load} xor eax, eax                          # 004f8ebc
    jmp.d8 L_004f8ec2                            # 004f8ebe
L_004f8ec0:
    # block 0x004f8ec0: entered by je at 0x004f8e2b, 1 instruction(s), falls into the block at 0x004f8ec2
    {load} xor eax, eax                          # 004f8ec0
L_004f8ec2:
    # block 0x004f8ec2: entered by jmp at 0x004f8eba; jmp at 0x004f8ebe, 3 instruction(s), ends with ret 0x10
    {load} mov esp, ebp                          # 004f8ec2
    pop ebp                                      # 004f8ec4
    ret 0x10                                     # 004f8ec5

