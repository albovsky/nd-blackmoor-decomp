# FUN_005019e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005019e0
# extent:       0x005019e0-0x00501b3f (351 code bytes)
# span:         0x005019e0-0x00501b40 (code 351, tables 0, padding 1)
# sha256:       b2372512096015bbb1ac1d4dc7c37f9355c037b5e7601b175db1e254ef272e99
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005019e0
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_24
# fields:       [eax + n] field_1f8; [ebx + n] field_minus_4; [ecx + n] field_200, field_484, field_minus_4; [edi + n] field_4; [esi + n] field_484
# callees:      calls FUN_004fee30, FUN_0050c920, FUN_0050f085
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 125 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00501b40
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_200, 0x200  # offset +0x200
.equ field_484, 0x484  # offset +0x484

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050f085, .text + (0x0050f085 - 0x401000)

.org 0x005019e0 - 0x401000
.globl FUN_005019e0
FUN_005019e0:
    # block 0x005019e0: entry, 11 instruction(s), ends with je to 0x00501b33 (forward)
    push ebp                                     # 005019e0
    {load} mov ebp, esp                          # 005019e1
    sub esp, 0x18                                # 005019e3
    push ebx                                     # 005019e6
    push esi                                     # 005019e7
    push edi                                     # 005019e8
    mov edi, dword ptr [ebp + arg_c]             # 005019e9
    mov eax, dword ptr [edi + field_4]           # 005019ec
    mov ecx, dword ptr [eax + field_1f8]         # 005019ef
    test ecx, ecx                                # 005019f5
    je.d32 L_00501b33                            # 005019f7
    # block 0x005019fd: entered by fall-through of je at 0x005019f7, 23 instruction(s), calls FUN_004fee30, FUN_0050c920, ends with jle to 0x00501b26 (forward)
    mov esi, dword ptr [ebp + arg_10]            # 005019fd
    mov eax, dword ptr [ebp + arg_8]             # 00501a00
    mov ecx, dword ptr [edi]                     # 00501a03
    mov edx, dword ptr [esi + field_484]         # 00501a05
    mov dword ptr [ebp - local_4], ecx           # 00501a0b
    shl edx, 0x2                                 # 00501a0e
    push edx                                     # 00501a11
    push eax                                     # 00501a12
    call FUN_004fee30                            # 00501a13
    mov ecx, dword ptr [edi + field_4]           # 00501a18
    mov dword ptr [ebp - local_8], eax           # 00501a1b
    add esp, 0x8                                 # 00501a1e
    mov edi, dword ptr [ecx + field_200]         # 00501a21
    lea eax, [4*edi]                             # 00501a27
    add eax, 0x3                                 # 00501a2e
    and al, -0x4                                 # 00501a31
    call FUN_0050c920                            # 00501a33
    mov eax, dword ptr [esi + field_484]         # 00501a38
    {load} mov ebx, esp                          # 00501a3e
    test eax, eax                                # 00501a40
    mov dword ptr [ebp - local_10], ebx          # 00501a42
    mov dword ptr [ebp - local_18], 0x0          # 00501a45
    jle.d32 L_00501b26                           # 00501a4c
    # block 0x00501a52: entered by fall-through of jle at 0x00501a4c, 5 instruction(s), falls into the block at 0x00501a5f
    mov esi, dword ptr [ebp - local_8]           # 00501a52
    mov eax, dword ptr [ebp + arg_14]            # 00501a55
    {load} mov ecx, esi                          # 00501a58
    {load} sub eax, ecx                          # 00501a5a
    mov dword ptr [ebp + arg_14], eax            # 00501a5c
L_00501a5f:
    # block 0x00501a5f: entered by jl at 0x00501b20, 13 instruction(s), calls FUN_004fee30, ends with jle to 0x00501b0b (forward)
    mov edx, dword ptr [ebp - local_4]           # 00501a5f
    lea eax, [4*edx]                             # 00501a62
    push eax                                     # 00501a69
    mov eax, dword ptr [ebp + arg_8]             # 00501a6a
    push eax                                     # 00501a6d
    call FUN_004fee30                            # 00501a6e
    mov ecx, dword ptr [ebp - local_4]           # 00501a73
    mov dword ptr [esi], eax                     # 00501a76
    {load} xor eax, eax                          # 00501a78
    add esp, 0x8                                 # 00501a7a
    {load} cmp ecx, eax                          # 00501a7d
    mov dword ptr [ebp - local_14], eax          # 00501a7f
    jle.d32 L_00501b0b                           # 00501a82
    # block 0x00501a88: entered by fall-through of jle at 0x00501a82, 1 instruction(s), falls into the block at 0x00501a8b
    mov dword ptr [ebp + arg_c], eax             # 00501a88
L_00501a8b:
    # block 0x00501a8b: entered by jl at 0x00501b09, 2 instruction(s), ends with jle to 0x00501aad (forward)
    test edi, edi                                # 00501a8b
    jle.d8 L_00501aad                            # 00501a8d
    # block 0x00501a8f: entered by fall-through of jle at 0x00501a8d, 3 instruction(s), falls into the block at 0x00501a96
    mov eax, dword ptr [ebp + arg_c]             # 00501a8f
    {load} mov ecx, ebx                          # 00501a92
    {load} mov edx, edi                          # 00501a94
L_00501a96:
    # block 0x00501a96: entered by jne at 0x00501aa8, 8 instruction(s), ends with jne to 0x00501a96 (backward)
    mov ebx, dword ptr [ebp + arg_14]            # 00501a96
    add ecx, 0x4                                 # 00501a99
    mov ebx, dword ptr [ebx + esi]               # 00501a9c
    {load} add ebx, eax                          # 00501a9f
    add eax, 0x4                                 # 00501aa1
    mov dword ptr [ecx - field_minus_4], ebx     # 00501aa4
    dec edx                                      # 00501aa7
    jne.d8 L_00501a96                            # 00501aa8
    # block 0x00501aaa: entered by fall-through of jne at 0x00501aa8, 1 instruction(s), falls into the block at 0x00501aad
    mov ebx, dword ptr [ebp - local_10]          # 00501aaa
L_00501aad:
    # block 0x00501aad: entered by jle at 0x00501a8d, 8 instruction(s), calls FUN_0050f085, ends with jle to 0x00501aed (forward)
    push 0x501b40                                # 00501aad
    push 0x4                                     # 00501ab2
    push edi                                     # 00501ab4
    push ebx                                     # 00501ab5
    call FUN_0050f085                            # 00501ab6
    add esp, 0x10                                # 00501abb
    test edi, edi                                # 00501abe
    jle.d8 L_00501aed                            # 00501ac0
    # block 0x00501ac2: entered by fall-through of jle at 0x00501ac0, 3 instruction(s), falls into the block at 0x00501aca
    mov ecx, dword ptr [ebp + arg_c]             # 00501ac2
    {load} mov eax, ebx                          # 00501ac5
    mov dword ptr [ebp - local_c], edi           # 00501ac7
L_00501aca:
    # block 0x00501aca: entered by jne at 0x00501ae8, 12 instruction(s), ends with jne to 0x00501aca (backward)
    mov ebx, dword ptr [ebp + arg_14]            # 00501aca
    mov edx, dword ptr [eax]                     # 00501acd
    add eax, 0x4                                 # 00501acf
    add ecx, 0x4                                 # 00501ad2
    sub edx, dword ptr [ebx + esi]               # 00501ad5
    mov ebx, dword ptr [esi]                     # 00501ad8
    sar edx, 0x2                                 # 00501ada
    mov dword ptr [ebx + ecx - field_minus_4], edx # 00501add
    mov edx, dword ptr [ebp - local_c]           # 00501ae1
    dec edx                                      # 00501ae4
    mov dword ptr [ebp - local_c], edx           # 00501ae5
    jne.d8 L_00501aca                            # 00501ae8
    # block 0x00501aea: entered by fall-through of jne at 0x00501ae8, 1 instruction(s), falls into the block at 0x00501aed
    mov ebx, dword ptr [ebp - local_10]          # 00501aea
L_00501aed:
    # block 0x00501aed: entered by jle at 0x00501ac0, 10 instruction(s), ends with jl to 0x00501a8b (backward)
    mov edx, dword ptr [ebp + arg_c]             # 00501aed
    mov ecx, dword ptr [ebp - local_14]          # 00501af0
    lea eax, [4*edi]                             # 00501af3
    {load} add ecx, edi                          # 00501afa
    {load} add edx, eax                          # 00501afc
    mov eax, dword ptr [ebp - local_4]           # 00501afe
    {load} cmp ecx, eax                          # 00501b01
    mov dword ptr [ebp - local_14], ecx          # 00501b03
    mov dword ptr [ebp + arg_c], edx             # 00501b06
    jl.d8 L_00501a8b                             # 00501b09
L_00501b0b:
    # block 0x00501b0b: entered by jle at 0x00501a82; fall-through of jl at 0x00501b09, 8 instruction(s), ends with jl to 0x00501a5f (backward)
    mov ecx, dword ptr [ebp + arg_10]            # 00501b0b
    mov eax, dword ptr [ebp - local_18]          # 00501b0e
    inc eax                                      # 00501b11
    add esi, 0x4                                 # 00501b12
    mov edx, dword ptr [ecx + field_484]         # 00501b15
    mov dword ptr [ebp - local_18], eax          # 00501b1b
    {load} cmp eax, edx                          # 00501b1e
    jl.d32 L_00501a5f                            # 00501b20
L_00501b26:
    # block 0x00501b26: entered by jle at 0x00501a4c; fall-through of jl at 0x00501b20, 8 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 00501b26
    lea esp, [ebp - local_24]                    # 00501b29
    pop edi                                      # 00501b2c
    pop esi                                      # 00501b2d
    pop ebx                                      # 00501b2e
    {load} mov esp, ebp                          # 00501b2f
    pop ebp                                      # 00501b31
    ret                                          # 00501b32
L_00501b33:
    # block 0x00501b33: entered by je at 0x005019f7, 8 instruction(s), ends with ret
    lea esp, [ebp - local_24]                    # 00501b33
    {load} xor eax, eax                          # 00501b36
    pop edi                                      # 00501b38
    pop esi                                      # 00501b39
    pop ebx                                      # 00501b3a
    {load} mov esp, ebp                          # 00501b3b
    pop ebp                                      # 00501b3d
    ret                                          # 00501b3e

# --- data items (not part of the function) -------------------------
.org 0x00501b3f - 0x401000
PAD_00501b3f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

