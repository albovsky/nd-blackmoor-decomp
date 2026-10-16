# FUN_004f8ce2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8ce2
# extent:       0x004f8ce2-0x004f8df4 (274 code bytes)
# span:         0x004f8ce2-0x004f8df4 (code 274, tables 0, padding 0)
# sha256:       a22e5fd0033bf05cbdc7f441e1ae8275c4cec76cc3cf9285ef496891649ff220
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8ce2
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_29b, field_2db, field_3ca, field_3d2; [ecx + n] field_29b, field_2db, field_3ca, field_3ce; [edx + n] field_48, field_29b, field_2db, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2db, 0x2db  # offset +0x2db
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f8ce2 - 0x401000
.globl FUN_004f8ce2
FUN_004f8ce2:
    # block 0x004f8ce2: entry, 15 instruction(s), ends with je to 0x004f8dec (forward)
    push ebp                                     # 004f8ce2
    {load} mov ebp, esp                          # 004f8ce3
    sub esp, 0xc                                 # 004f8ce5
    mov dword ptr [ebp - local_c], ecx           # 004f8ce8
    mov eax, dword ptr [ebp + arg_8]             # 004f8ceb
    imul eax, eax, 0x5bb                         # 004f8cee
    mov ecx, dword ptr [ebp - local_c]           # 004f8cf4
    mov edx, dword ptr [ecx + field_3ce]         # 004f8cf7
    {load} add edx, eax                          # 004f8cfd
    mov dword ptr [ebp - local_4], edx           # 004f8cff
    mov eax, dword ptr [ebp - local_c]           # 004f8d02
    mov dword ptr [eax + field_3ca], 0x0         # 004f8d05
    mov ecx, dword ptr [ebp - local_4]           # 004f8d0f
    cmp dword ptr [ecx + field_29b], 0x0         # 004f8d12
    je.d32 L_004f8dec                            # 004f8d19
    # block 0x004f8d1f: entered by fall-through of je at 0x004f8d19, 3 instruction(s), ends with je to 0x004f8d32 (forward)
    {load} xor edx, edx                          # 004f8d1f
    test edx, edx                                # 004f8d21
    je.d8 L_004f8d32                             # 004f8d23
    # block 0x004f8d25: entered by fall-through of je at 0x004f8d23, 2 instruction(s), falls into the block at 0x004f8d32
    mov eax, dword ptr [ebp - local_c]           # 004f8d25
    mov dword ptr [eax + field_3d2], 0x1         # 004f8d28
L_004f8d32:
    # block 0x004f8d32: entered by je at 0x004f8d23, 16 instruction(s), calls indirect dword ptr [edx + 0x48], ends with jne to 0x004f8de8 (forward)
    push 0x0                                     # 004f8d32
    mov ecx, dword ptr [ebp - local_4]           # 004f8d34
    mov edx, dword ptr [ecx + field_2db]         # 004f8d37
    push edx                                     # 004f8d3d
    mov eax, dword ptr [ebp - local_4]           # 004f8d3e
    mov ecx, dword ptr [eax + field_29b]         # 004f8d41
    mov edx, dword ptr [ebp - local_4]           # 004f8d47
    mov eax, dword ptr [edx + field_29b]         # 004f8d4a
    mov edx, dword ptr [eax]                     # 004f8d50
    push ecx                                     # 004f8d52
    call dword ptr [edx + field_48]              # 004f8d53
    mov ecx, dword ptr [ebp - local_c]           # 004f8d56
    mov dword ptr [ecx + field_3ca], eax         # 004f8d59
    mov edx, dword ptr [ebp - local_c]           # 004f8d5f
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8d62
    jne.d8 L_004f8de8                            # 004f8d69
    # block 0x004f8d6b: entered by fall-through of jne at 0x004f8d69, 3 instruction(s), ends with je to 0x004f8de1 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f8d6b
    test eax, eax                                # 004f8d72
    je.d8 L_004f8de1                             # 004f8d74
    # block 0x004f8d76: entered by fall-through of je at 0x004f8d74, 4 instruction(s), ends with jne to 0x004f8d92 (forward)
    mov dword ptr [ebp - local_8], 0x0           # 004f8d76
    mov ecx, dword ptr [ebp - local_4]           # 004f8d7d
    cmp dword ptr [ecx + field_2db], 0x0         # 004f8d80
    jne.d8 L_004f8d92                            # 004f8d87
    # block 0x004f8d89: entered by fall-through of jne at 0x004f8d87, 2 instruction(s), ends with forward jump to 0x004f8dba
    mov dword ptr [ebp - local_8], 0x55f0ac      # 004f8d89
    jmp.d8 L_004f8dba                            # 004f8d90
L_004f8d92:
    # block 0x004f8d92: entered by jne at 0x004f8d87, 3 instruction(s), ends with jne to 0x004f8da7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f8d92
    cmp dword ptr [edx + field_2db], 0x1         # 004f8d95
    jne.d8 L_004f8da7                            # 004f8d9c
    # block 0x004f8d9e: entered by fall-through of jne at 0x004f8d9c, 2 instruction(s), ends with forward jump to 0x004f8dba
    mov dword ptr [ebp - local_8], 0x55f0bc      # 004f8d9e
    jmp.d8 L_004f8dba                            # 004f8da5
L_004f8da7:
    # block 0x004f8da7: entered by jne at 0x004f8d9c, 3 instruction(s), ends with jne to 0x004f8dba (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f8da7
    cmp dword ptr [eax + field_2db], 0x2         # 004f8daa
    jne.d8 L_004f8dba                            # 004f8db1
    # block 0x004f8db3: entered by fall-through of jne at 0x004f8db1, 1 instruction(s), falls into the block at 0x004f8dba
    mov dword ptr [ebp - local_8], 0x55f0d4      # 004f8db3
L_004f8dba:
    # block 0x004f8dba: entered by jmp at 0x004f8d90; jmp at 0x004f8da5; jne at 0x004f8db1, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f8de1
    mov ecx, dword ptr [ebp - local_8]           # 004f8dba
    push ecx                                     # 004f8dbd
    mov edx, dword ptr [ebp + arg_8]             # 004f8dbe
    push edx                                     # 004f8dc1
    push 0x55f0e8                                # 004f8dc2
    push 0x63888b                                # 004f8dc7
    call FUN_0050ca3e                            # 004f8dcc
    add esp, 0x10                                # 004f8dd1
    push 0x63888b                                # 004f8dd4
    call FUN_0044a2b7                            # 004f8dd9
    add esp, 0x4                                 # 004f8dde
L_004f8de1:
    # block 0x004f8de1: entered by je at 0x004f8d74, 2 instruction(s), ends with forward jump to 0x004f8dee
    mov eax, 0x1                                 # 004f8de1
    jmp.d8 L_004f8dee                            # 004f8de6
L_004f8de8:
    # block 0x004f8de8: entered by jne at 0x004f8d69, 2 instruction(s), ends with forward jump to 0x004f8dee
    {load} xor eax, eax                          # 004f8de8
    jmp.d8 L_004f8dee                            # 004f8dea
L_004f8dec:
    # block 0x004f8dec: entered by je at 0x004f8d19, 1 instruction(s), falls into the block at 0x004f8dee
    {load} xor eax, eax                          # 004f8dec
L_004f8dee:
    # block 0x004f8dee: entered by jmp at 0x004f8de6; jmp at 0x004f8dea, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f8dee
    pop ebp                                      # 004f8df0
    ret 0x4                                      # 004f8df1

