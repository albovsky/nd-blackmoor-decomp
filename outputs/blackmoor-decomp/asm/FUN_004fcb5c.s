# FUN_004fcb5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcb5c
# extent:       0x004fcb5c-0x004fccf2 (406 code bytes)
# span:         0x004fcb5c-0x004fccf2 (code 406, tables 0, padding 0)
# sha256:       4feec6951a00a65465aeec5c128621ed090e4dd8030f71e0ef2aadf212257cc5
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
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
.equ local_10, 0x10  # [ebp - 0x10]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004fcb5c - 0x401000
.globl FUN_004fcb5c
FUN_004fcb5c:
    # block 0x004fcb5c: <unfilled>
    push ebp                                     # 004fcb5c
    {load} mov ebp, esp                          # 004fcb5d
    sub esp, 0x10                                # 004fcb5f
    push esi                                     # 004fcb62
    mov dword ptr [ebp - local_8], ecx           # 004fcb63
    mov eax, dword ptr [ebp + arg_8]             # 004fcb66
    mov ecx, dword ptr [ebp - local_8]           # 004fcb69
    fld dword ptr [ecx + 4*eax + 0xb764]         # 004fcb6c
    fcomp dword ptr [0x52db78]                   # 004fcb73
    fnstsw ax                                    # 004fcb79
    test ah, 0x1                                 # 004fcb7b
    je.d8 L_004fcb89                             # 004fcb7e
    # block 0x004fcb80: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 004fcb80
    jmp.d8 L_004fcb99                            # 004fcb87
L_004fcb89:
    # block 0x004fcb89: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004fcb89
    mov eax, dword ptr [ebp - local_8]           # 004fcb8c
    fld dword ptr [eax + 4*edx + 0xb764]         # 004fcb8f
    fstp dword ptr [ebp - local_c]               # 004fcb96
L_004fcb99:
    # block 0x004fcb99: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004fcb99
    mov edx, dword ptr [ebp - local_8]           # 004fcb9c
    mov eax, dword ptr [ebp - local_c]           # 004fcb9f
    mov dword ptr [edx + 4*ecx + 0xb764], eax    # 004fcba2
    mov ecx, dword ptr [ebp + arg_8]             # 004fcba9
    mov edx, dword ptr [ebp - local_8]           # 004fcbac
    fld dword ptr [edx + 4*ecx + 0xb764]         # 004fcbaf
    fcomp dword ptr [0x52cbf4]                   # 004fcbb6
    fnstsw ax                                    # 004fcbbc
    test ah, 0x41                                # 004fcbbe
    jne.d8 L_004fcbcc                            # 004fcbc1
    # block 0x004fcbc3: <unfilled>
    mov dword ptr [ebp - local_10], 0x3f800000   # 004fcbc3
    jmp.d8 L_004fcbdc                            # 004fcbca
L_004fcbcc:
    # block 0x004fcbcc: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 004fcbcc
    mov ecx, dword ptr [ebp - local_8]           # 004fcbcf
    fld dword ptr [ecx + 4*eax + 0xb764]         # 004fcbd2
    fstp dword ptr [ebp - local_10]              # 004fcbd9
L_004fcbdc:
    # block 0x004fcbdc: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004fcbdc
    mov eax, dword ptr [ebp - local_8]           # 004fcbdf
    mov ecx, dword ptr [ebp - local_10]          # 004fcbe2
    mov dword ptr [eax + 4*edx + 0xb764], ecx    # 004fcbe5
    mov word ptr [ebp - local_4], 0x0            # 004fcbec
    jmp.d8 L_004fcc00                            # 004fcbf2
L_004fcbf4:
    # block 0x004fcbf4: <unfilled>
    mov dx, word ptr [ebp - local_4]             # 004fcbf4
    add dx, 0x1                                  # 004fcbf8
    mov word ptr [ebp - local_4], dx             # 004fcbfc
L_004fcc00:
    # block 0x004fcc00: <unfilled>
    movsx eax, word ptr [ebp - local_4]          # 004fcc00
    cmp eax, 0x20                                # 004fcc04
    jge.d32 L_004fcceb                           # 004fcc07
    # block 0x004fcc0d: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 004fcc0d
    imul ecx, ecx, 0x5bb                         # 004fcc11
    mov edx, dword ptr [ebp - local_8]           # 004fcc17
    movsx eax, word ptr [edx + ecx + 0x10c]      # 004fcc1a
    cmp eax, dword ptr [ebp + arg_8]             # 004fcc22
    jne.d32 L_004fcce6                           # 004fcc25
    # block 0x004fcc2b: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 004fcc2b
    imul ecx, ecx, 0x5bb                         # 004fcc2f
    mov edx, dword ptr [ebp - local_8]           # 004fcc35
    {load} xor eax, eax                          # 004fcc38
    mov ax, word ptr [edx + ecx + 0x132]         # 004fcc3a
    cmp eax, 0x1                                 # 004fcc42
    jne.d32 L_004fcce6                           # 004fcc45
    # block 0x004fcc4b: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 004fcc4b
    imul ecx, ecx, 0x5bb                         # 004fcc4f
    mov edx, dword ptr [ebp - local_8]           # 004fcc55
    mov eax, dword ptr [ebp + arg_8]             # 004fcc58
    mov esi, dword ptr [ebp - local_8]           # 004fcc5b
    fld dword ptr [edx + ecx + 0x138]            # 004fcc5e
    fmul dword ptr [esi + 4*eax + 0xb764]        # 004fcc65
    fmul dword ptr [0x52e4e0]                    # 004fcc6c
    fadd qword ptr [0x52e4d8]                    # 004fcc72
    call FUN_0050ce04                            # 004fcc78
    movsx ecx, word ptr [ebp - local_4]          # 004fcc7d
    imul ecx, ecx, 0x5bb                         # 004fcc81
    mov edx, dword ptr [ebp - local_8]           # 004fcc87
    mov dword ptr [edx + ecx + 0x140], eax       # 004fcc8a
    movsx eax, word ptr [ebp - local_4]          # 004fcc91
    imul eax, eax, 0x5bb                         # 004fcc95
    mov ecx, dword ptr [ebp - local_8]           # 004fcc9b
    mov edx, dword ptr [ebp + arg_8]             # 004fcc9e
    mov esi, dword ptr [ebp - local_8]           # 004fcca1
    fld dword ptr [ecx + eax + 0x13c]            # 004fcca4
    fmul dword ptr [esi + 4*edx + 0xb764]        # 004fccab
    fmul dword ptr [0x52e4e0]                    # 004fccb2
    fadd qword ptr [0x52e4d8]                    # 004fccb8
    call FUN_0050ce04                            # 004fccbe
    movsx ecx, word ptr [ebp - local_4]          # 004fccc3
    imul ecx, ecx, 0x5bb                         # 004fccc7
    mov edx, dword ptr [ebp - local_8]           # 004fcccd
    mov dword ptr [edx + ecx + 0x144], eax       # 004fccd0
    movsx eax, word ptr [ebp - local_4]          # 004fccd7
    push eax                                     # 004fccdb
    mov ecx, 0x5cf1eb                            # 004fccdc
    call FUN_004f684a                            # 004fcce1
L_004fcce6:
    # block 0x004fcce6: <unfilled>
    jmp.d32 L_004fcbf4                           # 004fcce6
L_004fcceb:
    # block 0x004fcceb: <unfilled>
    pop esi                                      # 004fcceb
    {load} mov esp, ebp                          # 004fccec
    pop ebp                                      # 004fccee
    ret 0x4                                      # 004fccef
