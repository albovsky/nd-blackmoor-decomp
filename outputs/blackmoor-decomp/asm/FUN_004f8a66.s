# FUN_004f8a66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8a66
# extent:       0x004f8a66-0x004f8b22 (188 code bytes)
# span:         0x004f8a66-0x004f8b22 (code 188, tables 0, padding 0)
# sha256:       cac42aad06dbda53c182912d2076423799d83bf2bd278b4c780bc854529b6461
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8a66
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_3c, field_19c, field_3ca, field_3d2; [ecx + n] field_19c, field_274, field_3ca; [edx + n] field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_3c, 0x3c  # offset +0x3c
.equ field_19c, 0x19c  # offset +0x19c
.equ field_274, 0x274  # offset +0x274
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f8a66 - 0x401000
.globl FUN_004f8a66
FUN_004f8a66:
    # block 0x004f8a66: entry, 9 instruction(s), ends with je to 0x004f8b1a (forward)
    push ebp                                     # 004f8a66
    {load} mov ebp, esp                          # 004f8a67
    push ecx                                     # 004f8a69
    mov dword ptr [ebp - local_4], ecx           # 004f8a6a
    mov eax, dword ptr [ebp - local_4]           # 004f8a6d
    mov dword ptr [eax + field_3ca], 0x0         # 004f8a70
    mov ecx, dword ptr [ebp - local_4]           # 004f8a7a
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8a7d
    je.d32 L_004f8b1a                            # 004f8a84
    # block 0x004f8a8a: entered by fall-through of je at 0x004f8a84, 3 instruction(s), ends with je to 0x004f8a9d (forward)
    {load} xor edx, edx                          # 004f8a8a
    test edx, edx                                # 004f8a8c
    je.d8 L_004f8a9d                             # 004f8a8e
    # block 0x004f8a90: entered by fall-through of je at 0x004f8a8e, 2 instruction(s), falls into the block at 0x004f8a9d
    mov eax, dword ptr [ebp - local_4]           # 004f8a90
    mov dword ptr [eax + field_3d2], 0x1         # 004f8a93
L_004f8a9d:
    # block 0x004f8a9d: entered by je at 0x004f8a8e, 18 instruction(s), calls indirect dword ptr [eax + 0x3c], ends with jne to 0x004f8b16 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8a9d
    mov edx, dword ptr [ebp + arg_8]             # 004f8aa0
    mov dword ptr [ecx + field_274], edx         # 004f8aa3
    push 0x0                                     # 004f8aa9
    mov eax, dword ptr [ebp + arg_8]             # 004f8aab
    push eax                                     # 004f8aae
    mov ecx, dword ptr [ebp - local_4]           # 004f8aaf
    mov edx, dword ptr [ecx + field_19c]         # 004f8ab2
    mov eax, dword ptr [ebp - local_4]           # 004f8ab8
    mov ecx, dword ptr [eax + field_19c]         # 004f8abb
    mov eax, dword ptr [ecx]                     # 004f8ac1
    push edx                                     # 004f8ac3
    call dword ptr [eax + field_3c]              # 004f8ac4
    mov ecx, dword ptr [ebp - local_4]           # 004f8ac7
    mov dword ptr [ecx + field_3ca], eax         # 004f8aca
    mov edx, dword ptr [ebp - local_4]           # 004f8ad0
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8ad3
    jne.d8 L_004f8b16                            # 004f8ada
    # block 0x004f8adc: entered by fall-through of jne at 0x004f8ada, 3 instruction(s), ends with je to 0x004f8b0f (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f8adc
    test eax, eax                                # 004f8ae3
    je.d8 L_004f8b0f                             # 004f8ae5
    # block 0x004f8ae7: entered by fall-through of je at 0x004f8ae5, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f8b0f
    fld dword ptr [ebp + arg_8]                  # 004f8ae7
    sub esp, 0x8                                 # 004f8aea
    fstp qword ptr [esp]                         # 004f8aed
    push 0x55efa4                                # 004f8af0
    push 0x63888b                                # 004f8af5
    call FUN_0050ca3e                            # 004f8afa
    add esp, 0x10                                # 004f8aff
    push 0x63888b                                # 004f8b02
    call FUN_0044a2b7                            # 004f8b07
    add esp, 0x4                                 # 004f8b0c
L_004f8b0f:
    # block 0x004f8b0f: entered by je at 0x004f8ae5, 2 instruction(s), ends with forward jump to 0x004f8b1c
    mov eax, 0x1                                 # 004f8b0f
    jmp.d8 L_004f8b1c                            # 004f8b14
L_004f8b16:
    # block 0x004f8b16: entered by jne at 0x004f8ada, 2 instruction(s), ends with forward jump to 0x004f8b1c
    {load} xor eax, eax                          # 004f8b16
    jmp.d8 L_004f8b1c                            # 004f8b18
L_004f8b1a:
    # block 0x004f8b1a: entered by je at 0x004f8a84, 1 instruction(s), falls into the block at 0x004f8b1c
    {load} xor eax, eax                          # 004f8b1a
L_004f8b1c:
    # block 0x004f8b1c: entered by jmp at 0x004f8b14; jmp at 0x004f8b18, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f8b1c
    pop ebp                                      # 004f8b1e
    ret 0x4                                      # 004f8b1f

