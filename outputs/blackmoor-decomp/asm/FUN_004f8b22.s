# FUN_004f8b22
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8b22
# extent:       0x004f8b22-0x004f8bdc (186 code bytes)
# span:         0x004f8b22-0x004f8bdc (code 186, tables 0, padding 0)
# sha256:       8f86b23c2833ac0dcff5e7bbca684f738a1fc32ebe5af7ce2094eb03ad08765d
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8b22
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_19c, field_3ca, field_3d2; [ecx + n] field_19c, field_274, field_3ca; [edx + n] field_3c, field_19c, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_3c, 0x3c  # offset +0x3c
.equ field_19c, 0x19c  # offset +0x19c
.equ field_274, 0x274  # offset +0x274
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f8b22 - 0x401000
.globl FUN_004f8b22
FUN_004f8b22:
    # block 0x004f8b22: entry, 9 instruction(s), ends with je to 0x004f8bd6 (forward)
    push ebp                                     # 004f8b22
    {load} mov ebp, esp                          # 004f8b23
    push ecx                                     # 004f8b25
    mov dword ptr [ebp - local_4], ecx           # 004f8b26
    mov eax, dword ptr [ebp - local_4]           # 004f8b29
    mov dword ptr [eax + field_3ca], 0x0         # 004f8b2c
    mov ecx, dword ptr [ebp - local_4]           # 004f8b36
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8b39
    je.d32 L_004f8bd6                            # 004f8b40
    # block 0x004f8b46: entered by fall-through of je at 0x004f8b40, 3 instruction(s), ends with je to 0x004f8b59 (forward)
    {load} xor edx, edx                          # 004f8b46
    test edx, edx                                # 004f8b48
    je.d8 L_004f8b59                             # 004f8b4a
    # block 0x004f8b4c: entered by fall-through of je at 0x004f8b4a, 2 instruction(s), falls into the block at 0x004f8b59
    mov eax, dword ptr [ebp - local_4]           # 004f8b4c
    mov dword ptr [eax + field_3d2], 0x1         # 004f8b4f
L_004f8b59:
    # block 0x004f8b59: entered by je at 0x004f8b4a, 16 instruction(s), calls indirect dword ptr [edx + 0x3c], ends with jne to 0x004f8bd2 (forward)
    push 0x0                                     # 004f8b59
    mov ecx, dword ptr [ebp - local_4]           # 004f8b5b
    mov edx, dword ptr [ecx + field_274]         # 004f8b5e
    push edx                                     # 004f8b64
    mov eax, dword ptr [ebp - local_4]           # 004f8b65
    mov ecx, dword ptr [eax + field_19c]         # 004f8b68
    mov edx, dword ptr [ebp - local_4]           # 004f8b6e
    mov eax, dword ptr [edx + field_19c]         # 004f8b71
    mov edx, dword ptr [eax]                     # 004f8b77
    push ecx                                     # 004f8b79
    call dword ptr [edx + field_3c]              # 004f8b7a
    mov ecx, dword ptr [ebp - local_4]           # 004f8b7d
    mov dword ptr [ecx + field_3ca], eax         # 004f8b80
    mov edx, dword ptr [ebp - local_4]           # 004f8b86
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8b89
    jne.d8 L_004f8bd2                            # 004f8b90
    # block 0x004f8b92: entered by fall-through of jne at 0x004f8b90, 3 instruction(s), ends with je to 0x004f8bcb (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f8b92
    test eax, eax                                # 004f8b99
    je.d8 L_004f8bcb                             # 004f8b9b
    # block 0x004f8b9d: entered by fall-through of je at 0x004f8b9b, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f8bcb
    mov ecx, dword ptr [ebp - local_4]           # 004f8b9d
    fld dword ptr [ecx + field_274]              # 004f8ba0
    sub esp, 0x8                                 # 004f8ba6
    fstp qword ptr [esp]                         # 004f8ba9
    push 0x55efec                                # 004f8bac
    push 0x63888b                                # 004f8bb1
    call FUN_0050ca3e                            # 004f8bb6
    add esp, 0x10                                # 004f8bbb
    push 0x63888b                                # 004f8bbe
    call FUN_0044a2b7                            # 004f8bc3
    add esp, 0x4                                 # 004f8bc8
L_004f8bcb:
    # block 0x004f8bcb: entered by je at 0x004f8b9b, 2 instruction(s), ends with forward jump to 0x004f8bd8
    mov eax, 0x1                                 # 004f8bcb
    jmp.d8 L_004f8bd8                            # 004f8bd0
L_004f8bd2:
    # block 0x004f8bd2: entered by jne at 0x004f8b90, 2 instruction(s), ends with forward jump to 0x004f8bd8
    {load} xor eax, eax                          # 004f8bd2
    jmp.d8 L_004f8bd8                            # 004f8bd4
L_004f8bd6:
    # block 0x004f8bd6: entered by je at 0x004f8b40, 1 instruction(s), falls into the block at 0x004f8bd8
    {load} xor eax, eax                          # 004f8bd6
L_004f8bd8:
    # block 0x004f8bd8: entered by jmp at 0x004f8bd0; jmp at 0x004f8bd4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f8bd8
    pop ebp                                      # 004f8bda
    ret                                          # 004f8bdb

