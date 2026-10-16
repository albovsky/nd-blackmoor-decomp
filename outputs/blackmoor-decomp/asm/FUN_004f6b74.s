# FUN_004f6b74
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6b74
# extent:       0x004f6b74-0x004f6cdc (360 code bytes)
# span:         0x004f6b74-0x004f6cdc (code 360, tables 0, padding 0)
# sha256:       6740c34c2acedfd4effe2df499d08f6fb62d58e978286cc344deb217e2bb577f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f6b74
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_28f, field_3be, field_3c2, field_3ca, field_3ce; [ecx + n] field_44, field_144, field_28f, field_3be, field_3c2, field_3ca; [edx + n] field_162, field_28f, field_3be, field_3c2, field_3ca
# callees:      calls FUN_004f709c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_44, 0x44  # offset +0x44
.equ field_144, 0x144  # offset +0x144
.equ field_162, 0x162  # offset +0x162
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f6b74 - 0x401000
.globl FUN_004f6b74
FUN_004f6b74:
    # block 0x004f6b74: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f6be2 (forward)
    push ebp                                     # 004f6b74
    {load} mov ebp, esp                          # 004f6b75
    sub esp, 0x10                                # 004f6b77
    mov dword ptr [ebp - local_8], ecx           # 004f6b7a
    mov eax, dword ptr [ebp - local_8]           # 004f6b7d
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6b80
    mov ecx, dword ptr [ebp - local_8]           # 004f6b8a
    mov dword ptr [ecx + field_3ca], 0x0         # 004f6b8d
    mov edx, dword ptr [ebp + arg_8]             # 004f6b97
    imul edx, edx, 0x5bb                         # 004f6b9a
    mov eax, dword ptr [ebp - local_8]           # 004f6ba0
    mov ecx, dword ptr [eax + field_3ce]         # 004f6ba3
    {load} add ecx, edx                          # 004f6ba9
    mov dword ptr [ebp - local_4], ecx           # 004f6bab
    mov ecx, dword ptr [ebp - local_8]           # 004f6bae
    call FUN_004f709c                            # 004f6bb1
    test eax, eax                                # 004f6bb6
    jne.d8 L_004f6be2                            # 004f6bb8
    # block 0x004f6bba: entered by fall-through of jne at 0x004f6bb8, 7 instruction(s), ends with forward jump to 0x004f6cd6
    mov edx, dword ptr [ebp - local_8]           # 004f6bba
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f6bbd
    mov eax, dword ptr [ebp - local_8]           # 004f6bc7
    mov dword ptr [eax + field_3be], 0x0         # 004f6bca
    mov ecx, dword ptr [ebp - local_8]           # 004f6bd4
    mov eax, dword ptr [ecx + field_3be]         # 004f6bd7
    jmp.d32 L_004f6cd6                           # 004f6bdd
L_004f6be2:
    # block 0x004f6be2: entered by jne at 0x004f6bb8, 3 instruction(s), ends with je to 0x004f6bfa (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f6be2
    cmp dword ptr [edx + field_162], 0x0         # 004f6be5
    je.d8 L_004f6bfa                             # 004f6bec
    # block 0x004f6bee: entered by fall-through of je at 0x004f6bec, 3 instruction(s), ends with jne to 0x004f6c22 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f6bee
    cmp dword ptr [eax + field_28f], 0x0         # 004f6bf1
    jne.d8 L_004f6c22                            # 004f6bf8
L_004f6bfa:
    # block 0x004f6bfa: entered by je at 0x004f6bec; fall-through of jne at 0x004f6bf8, 7 instruction(s), ends with forward jump to 0x004f6cd6
    mov ecx, dword ptr [ebp - local_8]           # 004f6bfa
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f6bfd
    mov edx, dword ptr [ebp - local_8]           # 004f6c07
    mov dword ptr [edx + field_3be], 0x0         # 004f6c0a
    mov eax, dword ptr [ebp - local_8]           # 004f6c14
    mov eax, dword ptr [eax + field_3be]         # 004f6c17
    jmp.d32 L_004f6cd6                           # 004f6c1d
L_004f6c22:
    # block 0x004f6c22: entered by jne at 0x004f6bf8, 4 instruction(s), ends with jle to 0x004f6c3c (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004f6c22
    and ecx, 0xffff                              # 004f6c25
    cmp ecx, 0x30d40                             # 004f6c2b
    jle.d8 L_004f6c3c                            # 004f6c31
    # block 0x004f6c33: entered by fall-through of jle at 0x004f6c31, 2 instruction(s), ends with forward jump to 0x004f6c48
    mov dword ptr [ebp - local_c], 0x30d40       # 004f6c33
    jmp.d8 L_004f6c48                            # 004f6c3a
L_004f6c3c:
    # block 0x004f6c3c: entered by jle at 0x004f6c31, 3 instruction(s), falls into the block at 0x004f6c48
    mov edx, dword ptr [ebp + arg_c]             # 004f6c3c
    and edx, 0xffff                              # 004f6c3f
    mov dword ptr [ebp - local_c], edx           # 004f6c45
L_004f6c48:
    # block 0x004f6c48: entered by jmp at 0x004f6c3a, 6 instruction(s), ends with jge to 0x004f6c67 (forward)
    mov ax, word ptr [ebp - local_c]             # 004f6c48
    mov word ptr [ebp + arg_c], ax               # 004f6c4c
    mov ecx, dword ptr [ebp + arg_c]             # 004f6c50
    and ecx, 0xffff                              # 004f6c53
    cmp ecx, 0x64                                # 004f6c59
    jge.d8 L_004f6c67                            # 004f6c5c
    # block 0x004f6c5e: entered by fall-through of jge at 0x004f6c5c, 2 instruction(s), ends with forward jump to 0x004f6c73
    mov dword ptr [ebp - local_10], 0x64         # 004f6c5e
    jmp.d8 L_004f6c73                            # 004f6c65
L_004f6c67:
    # block 0x004f6c67: entered by jge at 0x004f6c5c, 3 instruction(s), falls into the block at 0x004f6c73
    mov edx, dword ptr [ebp + arg_c]             # 004f6c67
    and edx, 0xffff                              # 004f6c6a
    mov dword ptr [ebp - local_10], edx          # 004f6c70
L_004f6c73:
    # block 0x004f6c73: entered by jmp at 0x004f6c65, 17 instruction(s), calls indirect dword ptr [ecx + 0x44], ends with jne to 0x004f6cc7 (forward)
    mov ax, word ptr [ebp - local_10]            # 004f6c73
    mov word ptr [ebp + arg_c], ax               # 004f6c77
    mov ecx, dword ptr [ebp + arg_c]             # 004f6c7b
    and ecx, 0xffff                              # 004f6c7e
    push ecx                                     # 004f6c84
    mov edx, dword ptr [ebp - local_4]           # 004f6c85
    mov eax, dword ptr [edx + field_28f]         # 004f6c88
    mov ecx, dword ptr [ebp - local_4]           # 004f6c8e
    mov edx, dword ptr [ecx + field_28f]         # 004f6c91
    mov ecx, dword ptr [edx]                     # 004f6c97
    push eax                                     # 004f6c99
    call dword ptr [ecx + field_44]              # 004f6c9a
    mov edx, dword ptr [ebp - local_8]           # 004f6c9d
    mov dword ptr [edx + field_3ca], eax         # 004f6ca0
    mov eax, dword ptr [ebp - local_8]           # 004f6ca6
    cmp dword ptr [eax + field_3ca], 0x0         # 004f6ca9
    jne.d8 L_004f6cc7                            # 004f6cb0
    # block 0x004f6cb2: entered by fall-through of jne at 0x004f6cb0, 5 instruction(s), ends with forward jump to 0x004f6cd6
    mov ecx, dword ptr [ebp - local_4]           # 004f6cb2
    mov dx, word ptr [ebp + arg_c]               # 004f6cb5
    mov word ptr [ecx + field_144], dx           # 004f6cb9
    mov eax, 0x1                                 # 004f6cc0
    jmp.d8 L_004f6cd6                            # 004f6cc5
L_004f6cc7:
    # block 0x004f6cc7: entered by jne at 0x004f6cb0, 3 instruction(s), falls into the block at 0x004f6cd6
    mov eax, dword ptr [ebp - local_8]           # 004f6cc7
    mov dword ptr [eax + field_3c2], 0x40f       # 004f6cca
    {load} xor eax, eax                          # 004f6cd4
L_004f6cd6:
    # block 0x004f6cd6: entered by jmp at 0x004f6bdd; jmp at 0x004f6c1d; jmp at 0x004f6cc5, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f6cd6
    pop ebp                                      # 004f6cd8
    ret 0x8                                      # 004f6cd9

