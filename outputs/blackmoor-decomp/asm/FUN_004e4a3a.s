# FUN_004e4a3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e4a3a
# extent:       0x004e4a3a-0x004e4bc4 (394 code bytes)
# span:         0x004e4a3a-0x004e4bc4 (code 394, tables 0, padding 0)
# sha256:       64ffca37eb4ffa55fb0b65f6e0571337c56447dee6609b48aec69db468e87e3f
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e4a3a
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4530, field_4d89; [ecx + n] field_53bd, field_65d6; [edx + n] field_1473, field_4d7d, field_4d81, field_4d85, field_65d6
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 100 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_1473, 0x1473  # offset +0x1473
.equ field_4530, 0x4530  # offset +0x4530
.equ field_4d7d, 0x4d7d  # offset +0x4d7d
.equ field_4d81, 0x4d81  # offset +0x4d81
.equ field_4d85, 0x4d85  # offset +0x4d85
.equ field_4d89, 0x4d89  # offset +0x4d89
.equ field_53bd, 0x53bd  # offset +0x53bd
.equ field_65d6, 0x65d6  # offset +0x65d6

# --- external targets -----------------------------------------------

.org 0x004e4a3a - 0x401000
.globl FUN_004e4a3a
FUN_004e4a3a:
    # block 0x004e4a3a: entry, 15 instruction(s), ends with je to 0x004e4a8a (forward)
    push ebp                                     # 004e4a3a
    {load} mov ebp, esp                          # 004e4a3b
    sub esp, 0x18                                # 004e4a3d
    mov dword ptr [ebp - local_14], ecx          # 004e4a40
    mov ax, word ptr [ebp + arg_10]              # 004e4a43
    mov word ptr [ebp - local_10], ax            # 004e4a47
    mov ecx, dword ptr [ebp - local_14]          # 004e4a4b
    mov word ptr [ecx + field_53bd], 0x0         # 004e4a4e
    mov edx, dword ptr [ebp - local_14]          # 004e4a57
    mov word ptr [edx + field_65d6], 0x0         # 004e4a5a
    mov eax, dword ptr [ebp - local_14]          # 004e4a63
    mov ecx, dword ptr [eax + field_4530]        # 004e4a66
    mov dword ptr [ebp - local_18], ecx          # 004e4a6c
    cmp dword ptr [ebp - local_18], 0x9          # 004e4a6f
    je.d8 L_004e4a8a                             # 004e4a73
    # block 0x004e4a75: entered by fall-through of je at 0x004e4a73, 2 instruction(s), ends with je to 0x004e4b0e (forward)
    cmp dword ptr [ebp - local_18], 0xd          # 004e4a75
    je.d32 L_004e4b0e                            # 004e4a79
    # block 0x004e4a7f: entered by fall-through of je at 0x004e4a79, 2 instruction(s), ends with je to 0x004e4a9a (forward)
    cmp dword ptr [ebp - local_18], 0xe          # 004e4a7f
    je.d8 L_004e4a9a                             # 004e4a83
    # block 0x004e4a85: entered by fall-through of je at 0x004e4a83, 1 instruction(s), ends with forward jump to 0x004e4b19
    jmp.d32 L_004e4b19                           # 004e4a85
L_004e4a8a:
    # block 0x004e4a8a: entered by je at 0x004e4a73, 4 instruction(s), ends with forward jump to 0x004e4b19
    mov edx, dword ptr [ebp - local_14]          # 004e4a8a
    mov ax, word ptr [edx + field_1473]          # 004e4a8d
    mov word ptr [ebp - local_4], ax             # 004e4a94
    jmp.d8 L_004e4b19                            # 004e4a98
L_004e4a9a:
    # block 0x004e4a9a: entered by je at 0x004e4a83, 4 instruction(s), ends with je to 0x004e4b0c (forward)
    mov cx, word ptr [0x5a1e5e]                  # 004e4a9a
    mov word ptr [ebp - local_4], cx             # 004e4aa1
    cmp dword ptr [0x5a1e58], 0x0                # 004e4aa5
    je.d8 L_004e4b0c                             # 004e4aac
    # block 0x004e4aae: entered by fall-through of je at 0x004e4aac, 4 instruction(s), ends with forward jump to 0x004e4aca
    mov dx, word ptr [ebp - local_4]             # 004e4aae
    mov word ptr [ebp - local_c], dx             # 004e4ab2
    mov word ptr [ebp - local_8], 0x0            # 004e4ab6
    jmp.d8 L_004e4aca                            # 004e4abc
L_004e4abe:
    # block 0x004e4abe: entered by jmp at 0x004e4b0a, 3 instruction(s), falls into the block at 0x004e4aca
    mov ax, word ptr [ebp - local_8]             # 004e4abe
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e4ac2
    mov word ptr [ebp - local_8], ax             # 004e4ac6
L_004e4aca:
    # block 0x004e4aca: entered by jmp at 0x004e4abc, 4 instruction(s), ends with jge to 0x004e4b0c (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e4aca
    movsx edx, word ptr [ebp - local_c]          # 004e4ace
    {load} cmp ecx, edx                          # 004e4ad2
    jge.d8 L_004e4b0c                            # 004e4ad4
    # block 0x004e4ad6: entered by fall-through of jge at 0x004e4ad4, 4 instruction(s), ends with jne to 0x004e4b0a (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e4ad6
    imul eax, eax, 0x4a                          # 004e4ada
    cmp dword ptr [eax + 0x5a26aa], 0x0          # 004e4add
    jne.d8 L_004e4b0a                            # 004e4ae4
    # block 0x004e4ae6: entered by fall-through of jne at 0x004e4ae4, 8 instruction(s), falls into the block at 0x004e4b0a
    mov cx, word ptr [ebp - local_4]             # 004e4ae6
    sub cx, 0x1                                  # 004e4aea
    mov word ptr [ebp - local_4], cx             # 004e4aee
    mov edx, dword ptr [ebp - local_14]          # 004e4af2
    mov ax, word ptr [edx + field_65d6]          # 004e4af5
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e4afc
    mov ecx, dword ptr [ebp - local_14]          # 004e4b00
    mov word ptr [ecx + field_65d6], ax          # 004e4b03
L_004e4b0a:
    # block 0x004e4b0a: entered by jne at 0x004e4ae4, 1 instruction(s), ends with backward jump to 0x004e4abe
    jmp.d8 L_004e4abe                            # 004e4b0a
L_004e4b0c:
    # block 0x004e4b0c: entered by je at 0x004e4aac; jge at 0x004e4ad4, 1 instruction(s), ends with forward jump to 0x004e4b19
    jmp.d8 L_004e4b19                            # 004e4b0c
L_004e4b0e:
    # block 0x004e4b0e: entered by je at 0x004e4a79, 2 instruction(s), falls into the block at 0x004e4b19
    mov dx, word ptr [0x5a1e60]                  # 004e4b0e
    mov word ptr [ebp - local_4], dx             # 004e4b15
L_004e4b19:
    # block 0x004e4b19: entered by jmp at 0x004e4a85; jmp at 0x004e4a98; jmp at 0x004e4b0c, 2 instruction(s), ends with forward jump to 0x004e4b2d
    mov word ptr [ebp - local_8], 0x0            # 004e4b19
    jmp.d8 L_004e4b2d                            # 004e4b1f
L_004e4b21:
    # block 0x004e4b21: entered by jmp at 0x004e4bab, 3 instruction(s), falls into the block at 0x004e4b2d
    mov ax, word ptr [ebp - local_8]             # 004e4b21
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e4b25
    mov word ptr [ebp - local_8], ax             # 004e4b29
L_004e4b2d:
    # block 0x004e4b2d: entered by jmp at 0x004e4b1f, 6 instruction(s), ends with jge to 0x004e4bb0 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004e4b2d
    movsx edx, word ptr [ebp + arg_18]           # 004e4b31
    {load} add ecx, edx                          # 004e4b35
    movsx eax, word ptr [ebp + arg_14]           # 004e4b37
    {load} cmp ecx, eax                          # 004e4b3b
    jge.d8 L_004e4bb0                            # 004e4b3d
    # block 0x004e4b3f: entered by fall-through of jge at 0x004e4b3d, 4 instruction(s), ends with jge to 0x004e4bb0 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e4b3f
    movsx edx, word ptr [ebp - local_4]          # 004e4b43
    {load} cmp ecx, edx                          # 004e4b47
    jge.d8 L_004e4bb0                            # 004e4b49
    # block 0x004e4b4b: entered by fall-through of jge at 0x004e4b49, 24 instruction(s), ends with backward jump to 0x004e4b21
    movsx eax, word ptr [ebp - local_10]         # 004e4b4b
    movsx ecx, word ptr [ebp - local_8]          # 004e4b4f
    shl ecx, 0x4                                 # 004e4b53
    mov edx, dword ptr [ebp - local_14]          # 004e4b56
    mov dword ptr [edx + ecx + field_4d81], eax  # 004e4b59
    movsx eax, word ptr [ebp + arg_8]            # 004e4b60
    movsx ecx, word ptr [ebp - local_8]          # 004e4b64
    shl ecx, 0x4                                 # 004e4b68
    mov edx, dword ptr [ebp - local_14]          # 004e4b6b
    mov dword ptr [edx + ecx + field_4d7d], eax  # 004e4b6e
    movsx eax, word ptr [ebp + arg_c]            # 004e4b75
    movsx ecx, word ptr [ebp - local_8]          # 004e4b79
    shl ecx, 0x4                                 # 004e4b7d
    mov edx, dword ptr [ebp - local_14]          # 004e4b80
    mov dword ptr [edx + ecx + field_4d85], eax  # 004e4b83
    mov ax, word ptr [ebp - local_10]            # 004e4b8a
    add ax, word ptr [ebp + arg_18]              # 004e4b8e
    mov word ptr [ebp - local_10], ax            # 004e4b92
    movsx ecx, word ptr [ebp - local_10]         # 004e4b96
    movsx edx, word ptr [ebp - local_8]          # 004e4b9a
    shl edx, 0x4                                 # 004e4b9e
    mov eax, dword ptr [ebp - local_14]          # 004e4ba1
    mov dword ptr [eax + edx + field_4d89], ecx  # 004e4ba4
    jmp.d32 L_004e4b21                           # 004e4bab
L_004e4bb0:
    # block 0x004e4bb0: entered by jge at 0x004e4b3d; jge at 0x004e4b49, 6 instruction(s), ends with ret 0x14
    mov ecx, dword ptr [ebp - local_14]          # 004e4bb0
    mov dx, word ptr [ebp - local_8]             # 004e4bb3
    mov word ptr [ecx + field_53bd], dx          # 004e4bb7
    {load} mov esp, ebp                          # 004e4bbe
    pop ebp                                      # 004e4bc0
    ret 0x14                                     # 004e4bc1

