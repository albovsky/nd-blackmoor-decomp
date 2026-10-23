# FUN_004e9d8f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9d8f
# extent:       0x004e9d8f-0x004e9e6c (221 code bytes)
# span:         0x004e9d8f-0x004e9e6c (code 221, tables 0, padding 0)
# sha256:       912dd7655ae1ae318bf8a09ca10e90628fbda61bc8a3194eb7baef78ddb54101
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e9d8f
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_23
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004e9d8f - 0x401000
.globl FUN_004e9d8f
FUN_004e9d8f:
    # block 0x004e9d8f: entry, 24 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9e10 (forward)
    push ebp                                     # 004e9d8f
    {load} mov ebp, esp                          # 004e9d90
    sub esp, 0x10                                # 004e9d92
    push esi                                     # 004e9d95
    push edi                                     # 004e9d96
    mov dword ptr [ebp - local_10], ecx          # 004e9d97
    mov eax, dword ptr [ebp + arg_c]             # 004e9d9a
    mov ecx, dword ptr [eax]                     # 004e9d9d
    mov dword ptr [ebp - local_4], ecx           # 004e9d9f
    mov edx, dword ptr [ebp - local_4]           # 004e9da2
    movsx eax, word ptr [edx + field_23]         # 004e9da5
    imul eax, eax, 0x22                          # 004e9da9
    add eax, 0x25                                # 004e9dac
    mov word ptr [ebp - local_8], ax             # 004e9daf
    movsx ecx, word ptr [ebp - local_8]          # 004e9db3
    push ecx                                     # 004e9db7
    call FUN_0051dc43                            # 004e9db8
    add esp, 0x4                                 # 004e9dbd
    mov dword ptr [ebp - local_c], eax           # 004e9dc0
    mov edx, dword ptr [ebp + arg_8]             # 004e9dc3
    mov eax, dword ptr [ebp - local_c]           # 004e9dc6
    mov dword ptr [edx], eax                     # 004e9dc9
    cmp dword ptr [ebp - local_c], 0x0           # 004e9dcb
    jne.d8 L_004e9e10                            # 004e9dcf
    # block 0x004e9dd1: entered by fall-through of jne at 0x004e9dcf, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9e10
    movsx ecx, word ptr [0x5c39e3]               # 004e9dd1
    push ecx                                     # 004e9dd8
    mov edx, dword ptr [0x5bb57b]                # 004e9dd9
    push edx                                     # 004e9ddf
    push 0x55ca38                                # 004e9de0
    push 0x63888b                                # 004e9de5
    call FUN_0050ca3e                            # 004e9dea
    add esp, 0x10                                # 004e9def
    push 0x63888b                                # 004e9df2
    push 0x55ca64                                # 004e9df7
    mov ecx, 0x583979                            # 004e9dfc
    call FUN_0042639d                            # 004e9e01
    mov ecx, 0x5cf659                            # 004e9e06
    call FUN_004c97b4                            # 004e9e0b
L_004e9e10:
    # block 0x004e9e10: entered by jne at 0x004e9dcf, 26 instruction(s), ends with je to 0x004e9e64 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e9e10
    mov eax, dword ptr [ebp + arg_c]             # 004e9e14
    mov esi, dword ptr [eax]                     # 004e9e17
    mov edx, dword ptr [ebp + arg_8]             # 004e9e19
    mov edi, dword ptr [edx]                     # 004e9e1c
    {load} mov eax, ecx                          # 004e9e1e
    shr ecx, 0x2                                 # 004e9e20
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9e23
    {load} mov ecx, eax                          # 004e9e25
    and ecx, 0x3                                 # 004e9e27
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9e2a
    movsx ecx, word ptr [ebp - local_8]          # 004e9e2c
    mov edx, dword ptr [ebp + arg_10]            # 004e9e30
    mov eax, dword ptr [edx]                     # 004e9e33
    {load} add eax, ecx                          # 004e9e35
    mov ecx, dword ptr [ebp + arg_10]            # 004e9e37
    mov dword ptr [ecx], eax                     # 004e9e3a
    movsx edx, word ptr [ebp - local_8]          # 004e9e3c
    mov eax, dword ptr [ebp + arg_c]             # 004e9e40
    mov ecx, dword ptr [eax]                     # 004e9e43
    {load} add ecx, edx                          # 004e9e45
    mov edx, dword ptr [ebp + arg_c]             # 004e9e47
    mov dword ptr [edx], ecx                     # 004e9e4a
    movsx eax, word ptr [0x63a4cd]               # 004e9e4c
    test eax, eax                                # 004e9e53
    je.d8 L_004e9e64                             # 004e9e55
    # block 0x004e9e57: entered by fall-through of je at 0x004e9e55, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9e64
    push 0x55ca80                                # 004e9e57
    call FUN_0044a2b7                            # 004e9e5c
    add esp, 0x4                                 # 004e9e61
L_004e9e64:
    # block 0x004e9e64: entered by je at 0x004e9e55, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004e9e64
    pop esi                                      # 004e9e65
    {load} mov esp, ebp                          # 004e9e66
    pop ebp                                      # 004e9e68
    ret 0xc                                      # 004e9e69

