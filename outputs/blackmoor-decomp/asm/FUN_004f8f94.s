# FUN_004f8f94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8f94
# extent:       0x004f8f94-0x004f9040 (172 code bytes)
# span:         0x004f8f94-0x004f9040 (code 172, tables 0, padding 0)
# sha256:       890fb5d1379259f3debf3b5d0b5ef3e4ddc276aa82ae9def9d460474484339e0
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8f94
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4c, field_29b, field_2a7, field_3ca, field_3d2; [ecx + n] field_29b, field_2ab, field_3ca, field_3ce; [edx + n] field_2a3, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_4c, 0x4c  # offset +0x4c
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f8f94 - 0x401000
.globl FUN_004f8f94
FUN_004f8f94:
    # block 0x004f8f94: entry, 15 instruction(s), ends with je to 0x004f9038 (forward)
    push ebp                                     # 004f8f94
    {load} mov ebp, esp                          # 004f8f95
    sub esp, 0x8                                 # 004f8f97
    mov dword ptr [ebp - local_8], ecx           # 004f8f9a
    mov eax, dword ptr [ebp + arg_8]             # 004f8f9d
    imul eax, eax, 0x5bb                         # 004f8fa0
    mov ecx, dword ptr [ebp - local_8]           # 004f8fa6
    mov edx, dword ptr [ecx + field_3ce]         # 004f8fa9
    {load} add edx, eax                          # 004f8faf
    mov dword ptr [ebp - local_4], edx           # 004f8fb1
    mov eax, dword ptr [ebp - local_8]           # 004f8fb4
    mov dword ptr [eax + field_3ca], 0x0         # 004f8fb7
    mov ecx, dword ptr [ebp - local_4]           # 004f8fc1
    cmp dword ptr [ecx + field_29b], 0x0         # 004f8fc4
    je.d8 L_004f9038                             # 004f8fcb
    # block 0x004f8fcd: entered by fall-through of je at 0x004f8fcb, 3 instruction(s), ends with je to 0x004f8fe0 (forward)
    {load} xor edx, edx                          # 004f8fcd
    test edx, edx                                # 004f8fcf
    je.d8 L_004f8fe0                             # 004f8fd1
    # block 0x004f8fd3: entered by fall-through of je at 0x004f8fd1, 2 instruction(s), falls into the block at 0x004f8fe0
    mov eax, dword ptr [ebp - local_8]           # 004f8fd3
    mov dword ptr [eax + field_3d2], 0x1         # 004f8fd6
L_004f8fe0:
    # block 0x004f8fe0: entered by je at 0x004f8fd1, 22 instruction(s), calls indirect dword ptr [eax + 0x4c], ends with jne to 0x004f9034 (forward)
    push 0x0                                     # 004f8fe0
    mov ecx, dword ptr [ebp - local_4]           # 004f8fe2
    mov edx, dword ptr [ecx + field_2ab]         # 004f8fe5
    push edx                                     # 004f8feb
    mov eax, dword ptr [ebp - local_4]           # 004f8fec
    mov ecx, dword ptr [eax + field_2a7]         # 004f8fef
    push ecx                                     # 004f8ff5
    mov edx, dword ptr [ebp - local_4]           # 004f8ff6
    mov eax, dword ptr [edx + field_2a3]         # 004f8ff9
    push eax                                     # 004f8fff
    mov ecx, dword ptr [ebp - local_4]           # 004f9000
    mov edx, dword ptr [ecx + field_29b]         # 004f9003
    mov eax, dword ptr [ebp - local_4]           # 004f9009
    mov ecx, dword ptr [eax + field_29b]         # 004f900c
    mov eax, dword ptr [ecx]                     # 004f9012
    push edx                                     # 004f9014
    call dword ptr [eax + field_4c]              # 004f9015
    mov ecx, dword ptr [ebp - local_8]           # 004f9018
    mov dword ptr [ecx + field_3ca], eax         # 004f901b
    mov edx, dword ptr [ebp - local_8]           # 004f9021
    cmp dword ptr [edx + field_3ca], 0x0         # 004f9024
    jne.d8 L_004f9034                            # 004f902b
    # block 0x004f902d: entered by fall-through of jne at 0x004f902b, 2 instruction(s), ends with forward jump to 0x004f903a
    mov eax, 0x1                                 # 004f902d
    jmp.d8 L_004f903a                            # 004f9032
L_004f9034:
    # block 0x004f9034: entered by jne at 0x004f902b, 2 instruction(s), ends with forward jump to 0x004f903a
    {load} xor eax, eax                          # 004f9034
    jmp.d8 L_004f903a                            # 004f9036
L_004f9038:
    # block 0x004f9038: entered by je at 0x004f8fcb, 1 instruction(s), falls into the block at 0x004f903a
    {load} xor eax, eax                          # 004f9038
L_004f903a:
    # block 0x004f903a: entered by jmp at 0x004f9032; jmp at 0x004f9036, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f903a
    pop ebp                                      # 004f903c
    ret 0x4                                      # 004f903d

