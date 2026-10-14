# FUN_00433eaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433eaa
# extent:       0x00433eaa-0x00434025 (379 code bytes)
# span:         0x00433eaa-0x00434025 (code 379, tables 0, padding 0)
# sha256:       f0ee25c4ace7be4b20f134aac190d84b298dc481e2b97724855d2e7d4b7949db
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00434773, .text + (0x00434773 - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x00433eaa - 0x401000
.globl FUN_00433eaa
FUN_00433eaa:
    # block 0x00433eaa: <unfilled>
    push ebp                                     # 00433eaa
    {load} mov ebp, esp                          # 00433eab
    sub esp, 0xc                                 # 00433ead
    push edi                                     # 00433eb0
    mov dword ptr [ebp - local_c], ecx           # 00433eb1
    mov dword ptr [ebp - local_8], 0x0           # 00433eb4
    mov eax, dword ptr [ebp - local_c]           # 00433ebb
    mov dword ptr [eax + 0x5f64], 0x0            # 00433ebe
    mov ecx, dword ptr [ebp - local_c]           # 00433ec8
    mov edx, dword ptr [ebp - local_c]           # 00433ecb
    mov eax, dword ptr [edx + 0x1118]            # 00433ece
    mov dword ptr [ecx + 0x1008], eax            # 00433ed4
L_00433eda:
    # block 0x00433eda: <unfilled>
    mov ecx, 0x1                                 # 00433eda
    test ecx, ecx                                # 00433edf
    je.d32 L_00434020                            # 00433ee1
    # block 0x00433ee7: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 00433ee7
    mov eax, dword ptr [edx + 0x1124]            # 00433eea
    sub eax, 0x3                                 # 00433ef0
    cmp dword ptr [ebp - local_8], eax           # 00433ef3
    jb.d8 L_00433efd                             # 00433ef6
    # block 0x00433ef8: <unfilled>
    jmp.d32 L_00434020                           # 00433ef8
L_00433efd:
    # block 0x00433efd: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 00433efd
    mov edx, dword ptr [ecx + 0x1008]            # 00433f00
    push edx                                     # 00433f06
    mov ecx, dword ptr [ebp - local_c]           # 00433f07
    call FUN_00434773                            # 00433f0a
    test eax, eax                                # 00433f0f
    jne.d8 L_00433f33                            # 00433f11
    # block 0x00433f13: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 00433f13
    mov ecx, dword ptr [eax + 0x1008]            # 00433f16
    add ecx, 0x1                                 # 00433f1c
    mov edx, dword ptr [ebp - local_c]           # 00433f1f
    mov dword ptr [edx + 0x1008], ecx            # 00433f22
    mov eax, dword ptr [ebp - local_8]           # 00433f28
    add eax, 0x1                                 # 00433f2b
    mov dword ptr [ebp - local_8], eax           # 00433f2e
    jmp.d8 L_00433eda                            # 00433f31
L_00433f33:
    # block 0x00433f33: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 00433f33
    cmp dword ptr [ecx + 0x5f64], 0x3e6          # 00433f36
    jle.d8 L_00433f60                            # 00433f40
    # block 0x00433f42: <unfilled>
    push 0x545e38                                # 00433f42
    push 0x545e4c                                # 00433f47
    mov ecx, 0x583979                            # 00433f4c
    call FUN_0042639d                            # 00433f51
    mov ecx, 0x5cf659                            # 00433f56
    call FUN_004c97b4                            # 00433f5b
L_00433f60:
    # block 0x00433f60: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 00433f60
    mov eax, dword ptr [edx + 0x5f64]            # 00433f63
    mov ecx, dword ptr [ebp - local_c]           # 00433f69
    mov edx, dword ptr [ebp - local_c]           # 00433f6c
    mov edx, dword ptr [edx + 0x1008]            # 00433f6f
    mov dword ptr [ecx + 4*eax + 0x1144], edx    # 00433f75
    mov edi, 0x545e6c                            # 00433f7c
    or ecx, -0x1                                 # 00433f81
    {load} xor eax, eax                          # 00433f84
    repne scasb al, byte ptr es:[edi]            # 00433f86
    not ecx                                      # 00433f88
    add ecx, -0x1                                # 00433f8a
    mov eax, dword ptr [ebp - local_c]           # 00433f8d
    mov edx, dword ptr [eax + 0x1008]            # 00433f90
    {load} add edx, ecx                          # 00433f96
    mov eax, dword ptr [ebp - local_c]           # 00433f98
    mov dword ptr [eax + 0x1008], edx            # 00433f9b
    mov edi, 0x545e74                            # 00433fa1
    or ecx, -0x1                                 # 00433fa6
    {load} xor eax, eax                          # 00433fa9
    repne scasb al, byte ptr es:[edi]            # 00433fab
    not ecx                                      # 00433fad
    add ecx, -0x1                                # 00433faf
    mov edx, dword ptr [ebp - local_8]           # 00433fb2
    {load} add edx, ecx                          # 00433fb5
    mov dword ptr [ebp - local_8], edx           # 00433fb7
    mov eax, dword ptr [ebp - local_c]           # 00433fba
    mov ecx, dword ptr [eax + 0x1008]            # 00433fbd
    push ecx                                     # 00433fc3
    mov ecx, dword ptr [ebp - local_c]           # 00433fc4
    call FUN_004347b8                            # 00433fc7
    mov dword ptr [ebp - local_4], eax           # 00433fcc
    mov edx, dword ptr [ebp - local_4]           # 00433fcf
    add edx, 0x8                                 # 00433fd2
    mov eax, dword ptr [ebp - local_c]           # 00433fd5
    mov ecx, dword ptr [eax + 0x5f64]            # 00433fd8
    mov eax, dword ptr [ebp - local_c]           # 00433fde
    mov dword ptr [eax + 4*ecx + 0x3084], edx    # 00433fe1
    mov ecx, dword ptr [ebp - local_c]           # 00433fe8
    mov edx, dword ptr [ecx + 0x5f64]            # 00433feb
    add edx, 0x1                                 # 00433ff1
    mov eax, dword ptr [ebp - local_c]           # 00433ff4
    mov dword ptr [eax + 0x5f64], edx            # 00433ff7
    mov ecx, dword ptr [ebp - local_c]           # 00433ffd
    mov edx, dword ptr [ecx + 0x1008]            # 00434000
    add edx, 0xc                                 # 00434006
    mov eax, dword ptr [ebp - local_c]           # 00434009
    mov dword ptr [eax + 0x1008], edx            # 0043400c
    mov ecx, dword ptr [ebp - local_8]           # 00434012
    add ecx, 0xc                                 # 00434015
    mov dword ptr [ebp - local_8], ecx           # 00434018
    jmp.d32 L_00433eda                           # 0043401b
L_00434020:
    # block 0x00434020: <unfilled>
    pop edi                                      # 00434020
    {load} mov esp, ebp                          # 00434021
    pop ebp                                      # 00434023
    ret                                          # 00434024
