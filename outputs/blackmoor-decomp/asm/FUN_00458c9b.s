# FUN_00458c9b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458c9b
# extent:       0x00458c9b-0x00458dce (307 code bytes)
# span:         0x00458c9b-0x00458dce (code 307, tables 0, padding 0)
# sha256:       ae8e06056f2ccd16c5435d296548f69f79d37103a091c5c8fadb1111cd198693
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00458c9b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_d4, local_d8
# fields:       [eax + n] field_26; [ecx + n] field_b8, field_e1; [edi + n] field_minus_1
# callees:      calls FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_d4, 0xd4  # offset -0xd4
.equ local_d8, 0xd8  # offset -0xd8
.equ field_26, 0x26  # offset +0x26
.equ field_b8, 0xb8  # offset +0xb8
.equ field_e1, 0xe1  # offset +0xe1

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x00458c9b - 0x401000
.globl FUN_00458c9b
FUN_00458c9b:
    # block 0x00458c9b: entry, 24 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00458db1 (forward)
    push ebp                                     # 00458c9b
    {load} mov ebp, esp                          # 00458c9c
    sub esp, 0xd8                                # 00458c9e
    push esi                                     # 00458ca4
    push edi                                     # 00458ca5
    mov dword ptr [ebp - local_d8], ecx          # 00458ca6
    mov eax, dword ptr [ebp - local_d8]          # 00458cac
    movsx ecx, word ptr [eax + field_26]         # 00458cb2
    imul ecx, ecx, 0x8d                          # 00458cb6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00458cbc
    mov dword ptr [ebp - local_8], edx           # 00458cc2
    mov dword ptr [ebp - local_4], 0x0           # 00458cc5
    mov eax, dword ptr [ebp - local_d8]          # 00458ccc
    add eax, 0xc0                                # 00458cd2
    push eax                                     # 00458cd7
    mov ecx, 0x5c3a67                            # 00458cd8
    call FUN_004fb77a                            # 00458cdd
    mov ecx, dword ptr [ebp - local_d8]          # 00458ce2
    mov dx, word ptr [ecx + field_e1]            # 00458ce8
    push edx                                     # 00458cef
    mov ecx, 0x5c3a67                            # 00458cf0
    call FUN_004fb2e3                            # 00458cf5
    cmp dword ptr [0x5bb202], 0x0                # 00458cfa
    je.d32 L_00458db1                            # 00458d01
    # block 0x00458d07: entered by fall-through of je at 0x00458d01, 9 instruction(s), ends with jbe to 0x00458db1 (forward)
    mov edi, dword ptr [ebp - local_d8]          # 00458d07
    add edi, 0xc0                                # 00458d0d
    or ecx, -0x1                                 # 00458d13
    {load} xor eax, eax                          # 00458d16
    repne scasb al, byte ptr es:[edi]            # 00458d18
    not ecx                                      # 00458d1a
    add ecx, -0x1                                # 00458d1c
    test ecx, ecx                                # 00458d1f
    jbe.d32 L_00458db1                           # 00458d21
    # block 0x00458d27: entered by fall-through of jbe at 0x00458d21, 8 instruction(s), calls FUN_00423259, ends with je to 0x00458db1 (forward)
    mov eax, dword ptr [ebp - local_d8]          # 00458d27
    add eax, 0xc0                                # 00458d2d
    push eax                                     # 00458d32
    mov ecx, 0x619a6b                            # 00458d33
    call FUN_00423259                            # 00458d38
    mov dword ptr [ebp - local_4], eax           # 00458d3d
    cmp dword ptr [ebp - local_4], 0x0           # 00458d40
    je.d8 L_00458db1                             # 00458d44
    # block 0x00458d46: entered by fall-through of je at 0x00458d44, 8 instruction(s), ends with ja to 0x00458db1 (forward)
    mov edi, dword ptr [ebp - local_4]           # 00458d46
    or ecx, -0x1                                 # 00458d49
    {load} xor eax, eax                          # 00458d4c
    repne scasb al, byte ptr es:[edi]            # 00458d4e
    not ecx                                      # 00458d50
    add ecx, -0x1                                # 00458d52
    cmp ecx, 0x9c40                              # 00458d55
    ja.d8 L_00458db1                             # 00458d5b
    # block 0x00458d5d: entered by fall-through of ja at 0x00458d5b, 27 instruction(s), calls FUN_00448d11, falls into the block at 0x00458db1
    mov edi, dword ptr [ebp - local_4]           # 00458d5d
    or ecx, -0x1                                 # 00458d60
    {load} xor eax, eax                          # 00458d63
    repne scasb al, byte ptr es:[edi]            # 00458d65
    not ecx                                      # 00458d67
    mov esi, dword ptr [ebp - local_4]           # 00458d69
    lea edi, [ebp - local_d4]                    # 00458d6c
    {load} mov edx, ecx                          # 00458d72
    shr ecx, 0x2                                 # 00458d74
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00458d77
    {load} mov ecx, edx                          # 00458d79
    and ecx, 0x3                                 # 00458d7b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00458d7e
    lea edi, [ebp - local_d4]                    # 00458d80
    or ecx, -0x1                                 # 00458d86
    {load} xor eax, eax                          # 00458d89
    repne scasb al, byte ptr es:[edi]            # 00458d8b
    mov eax, dword ptr [0x54a628]                # 00458d8d
    mov dword ptr [edi - field_minus_1], eax     # 00458d92
    push 0x0                                     # 00458d95
    push -0x1                                    # 00458d97
    lea ecx, [ebp - local_d4]                    # 00458d99
    push ecx                                     # 00458d9f
    mov edx, dword ptr [0x5d03b3]                # 00458da0
    push edx                                     # 00458da6
    mov ecx, 0x619a05                            # 00458da7
    call FUN_00448d11                            # 00458dac
L_00458db1:
    # block 0x00458db1: entered by je at 0x00458d01; jbe at 0x00458d21; je at 0x00458d44; ja at 0x00458d5b, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret
    call dword ptr [0x52a23c]                    # 00458db1
    add eax, 0x3e8                               # 00458db7
    mov ecx, dword ptr [ebp - local_d8]          # 00458dbc
    mov dword ptr [ecx + field_b8], eax          # 00458dc2
    pop edi                                      # 00458dc8
    pop esi                                      # 00458dc9
    {load} mov esp, ebp                          # 00458dca
    pop ebp                                      # 00458dcc
    ret                                          # 00458dcd

