# FUN_005029d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005029d0
# extent:       0x005029d0-0x00502d98 (968 code bytes)
# span:         0x005029d0-0x00502da0 (code 968, tables 0, padding 8)
# sha256:       5852a6d5b0e7b1307123f7f7a41e5da27dac0c2059db34e535ecdb396d8db0f3
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005029d0
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_20
# fields:       [ebx + n] field_1; [edi + n] field_4, field_8; [esi + n] field_4, field_8, field_10, field_14, field_18, field_1c, field_20, field_24, field_28
# callees:      calls FUN_00502440, FUN_0050c920, FUN_00502910, FUN_00502da0, FUN_0050f085, FUN_0050ea90, FUN_0050e936, FUN_00502630, FUN_005023e0, FUN_0050e97e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 362 instruction(s), 35 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_20, 0x20  # offset -0x20
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_005023e0, .text + (0x005023e0 - 0x401000)
.set FUN_00502440, .text + (0x00502440 - 0x401000)
.set FUN_00502630, .text + (0x00502630 - 0x401000)
.set FUN_00502910, .text + (0x00502910 - 0x401000)
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050f085, .text + (0x0050f085 - 0x401000)

.org 0x005029d0 - 0x401000
.globl FUN_005029d0
FUN_005029d0:
    # block 0x005029d0: entry, 16 instruction(s), ends with jle to 0x00502a04 (forward)
    push ebp                                     # 005029d0
    {load} mov ebp, esp                          # 005029d1
    sub esp, 0x14                                # 005029d3
    push ebx                                     # 005029d6
    push esi                                     # 005029d7
    mov esi, dword ptr [ebp + arg_8]             # 005029d8
    push edi                                     # 005029db
    mov ecx, 0xb                                 # 005029dc
    {load} xor eax, eax                          # 005029e1
    {load} mov edi, esi                          # 005029e3
    {load} xor ebx, ebx                          # 005029e5
    rep stosd dword ptr es:[edi], eax            # 005029e7
    mov edi, dword ptr [ebp + arg_c]             # 005029e9
    mov eax, dword ptr [edi + field_4]           # 005029ec
    test eax, eax                                # 005029ef
    jle.d8 L_00502a04                            # 005029f1
    # block 0x005029f3: entered by fall-through of jle at 0x005029f1, 2 instruction(s), falls into the block at 0x005029f8
    mov ecx, dword ptr [edi + field_8]           # 005029f3
    {load} mov edx, eax                          # 005029f6
L_005029f8:
    # block 0x005029f8: entered by jne at 0x00502a02, 2 instruction(s), ends with jle to 0x005029fe (forward)
    cmp dword ptr [ecx], 0x0                     # 005029f8
    jle.d8 L_005029fe                            # 005029fb
    # block 0x005029fd: entered by fall-through of jle at 0x005029fb, 1 instruction(s), falls into the block at 0x005029fe
    inc ebx                                      # 005029fd
L_005029fe:
    # block 0x005029fe: entered by jle at 0x005029fb, 3 instruction(s), ends with jne to 0x005029f8 (backward)
    add ecx, 0x4                                 # 005029fe
    dec edx                                      # 00502a01
    jne.d8 L_005029f8                            # 00502a02
L_00502a04:
    # block 0x00502a04: entered by jle at 0x005029f1; fall-through of jne at 0x00502a02, 22 instruction(s), calls FUN_00502440, FUN_0050c920, ends with jne to 0x00502a58 (forward)
    mov dword ptr [esi + field_4], eax           # 00502a04
    mov dword ptr [esi + field_8], ebx           # 00502a07
    mov eax, dword ptr [edi]                     # 00502a0a
    push ebx                                     # 00502a0c
    mov dword ptr [esi], eax                     # 00502a0d
    mov ecx, dword ptr [edi + field_4]           # 00502a0f
    mov edx, dword ptr [edi + field_8]           # 00502a12
    push ecx                                     # 00502a15
    push edx                                     # 00502a16
    call FUN_00502440                            # 00502a17
    mov dword ptr [ebp - local_4], eax           # 00502a1c
    lea eax, [4*ebx]                             # 00502a1f
    mov dword ptr [ebp - local_c], eax           # 00502a26
    add eax, 0x3                                 # 00502a29
    add esp, 0xc                                 # 00502a2c
    and al, -0x4                                 # 00502a2f
    call FUN_0050c920                            # 00502a31
    mov ecx, dword ptr [ebp - local_4]           # 00502a36
    {load} mov eax, esp                          # 00502a39
    test ecx, ecx                                # 00502a3b
    mov dword ptr [ebp - local_10], eax          # 00502a3d
    jne.d8 L_00502a58                            # 00502a40
    # block 0x00502a42: entered by fall-through of jne at 0x00502a40, 11 instruction(s), calls FUN_00502910, ends with ret
    push esi                                     # 00502a42
    call FUN_00502910                            # 00502a43
    add esp, 0x4                                 # 00502a48
    or eax, -0x1                                 # 00502a4b
    lea esp, [ebp - local_20]                    # 00502a4e
    pop edi                                      # 00502a51
    pop esi                                      # 00502a52
    pop ebx                                      # 00502a53
    {load} mov esp, ebp                          # 00502a54
    pop ebp                                      # 00502a56
    ret                                          # 00502a57
L_00502a58:
    # block 0x00502a58: entered by jne at 0x00502a40, 2 instruction(s), ends with jle to 0x00502a92 (forward)
    test ebx, ebx                                # 00502a58
    jle.d8 L_00502a92                            # 00502a5a
    # block 0x00502a5c: entered by fall-through of jle at 0x00502a5a, 4 instruction(s), falls into the block at 0x00502a67
    {load} sub eax, ecx                          # 00502a5c
    mov dword ptr [ebp + arg_8], ecx             # 00502a5e
    mov dword ptr [ebp - local_14], eax          # 00502a61
    mov dword ptr [ebp - local_8], ebx           # 00502a64
L_00502a67:
    # block 0x00502a67: entered by jne at 0x00502a8d, 15 instruction(s), calls FUN_00502da0, ends with jne to 0x00502a67 (backward)
    mov eax, dword ptr [ebp + arg_8]             # 00502a67
    mov ecx, dword ptr [eax]                     # 00502a6a
    push ecx                                     # 00502a6c
    call FUN_00502da0                            # 00502a6d
    mov ecx, dword ptr [ebp + arg_8]             # 00502a72
    mov edx, dword ptr [ebp - local_14]          # 00502a75
    add esp, 0x4                                 # 00502a78
    mov dword ptr [ecx], eax                     # 00502a7b
    mov eax, dword ptr [ebp - local_8]           # 00502a7d
    mov dword ptr [edx + ecx], ecx               # 00502a80
    add ecx, 0x4                                 # 00502a83
    dec eax                                      # 00502a86
    mov dword ptr [ebp + arg_8], ecx             # 00502a87
    mov dword ptr [ebp - local_8], eax           # 00502a8a
    jne.d8 L_00502a67                            # 00502a8d
    # block 0x00502a8f: entered by fall-through of jne at 0x00502a8d, 1 instruction(s), falls into the block at 0x00502a92
    mov eax, dword ptr [ebp - local_10]          # 00502a8f
L_00502a92:
    # block 0x00502a92: entered by jle at 0x00502a5a, 19 instruction(s), calls FUN_0050f085, FUN_0050c920, FUN_0050ea90, ends with jle to 0x00502b20 (forward)
    push 0x502e00                                # 00502a92
    push 0x4                                     # 00502a97
    push ebx                                     # 00502a99
    push eax                                     # 00502a9a
    call FUN_0050f085                            # 00502a9b
    mov eax, dword ptr [ebp - local_c]           # 00502aa0
    add esp, 0x10                                # 00502aa3
    add eax, 0x3                                 # 00502aa6
    and al, -0x4                                 # 00502aa9
    call FUN_0050c920                            # 00502aab
    mov eax, dword ptr [ebp - local_c]           # 00502ab0
    mov dword ptr [ebp + arg_8], esp             # 00502ab3
    push eax                                     # 00502ab6
    call FUN_0050ea90                            # 00502ab7
    mov dword ptr [esi + field_14], eax          # 00502abc
    add esp, 0x4                                 # 00502abf
    {load} xor eax, eax                          # 00502ac2
    test ebx, ebx                                # 00502ac4
    jle.d8 L_00502b20                            # 00502ac6
    # block 0x00502ac8: entered by fall-through of jle at 0x00502ac6, 2 instruction(s), falls into the block at 0x00502ace
    mov ecx, dword ptr [ebp - local_10]          # 00502ac8
    mov dword ptr [ebp - local_8], ecx           # 00502acb
L_00502ace:
    # block 0x00502ace: entered by jl at 0x00502aed, 13 instruction(s), ends with jl to 0x00502ace (backward)
    mov edx, dword ptr [ebp - local_8]           # 00502ace
    mov ecx, dword ptr [edx]                     # 00502ad1
    mov edx, dword ptr [ebp - local_4]           # 00502ad3
    {load} sub ecx, edx                          # 00502ad6
    mov edx, dword ptr [ebp + arg_8]             # 00502ad8
    sar ecx, 0x2                                 # 00502adb
    mov dword ptr [edx + 4*ecx], eax             # 00502ade
    mov edx, dword ptr [ebp - local_8]           # 00502ae1
    inc eax                                      # 00502ae4
    add edx, 0x4                                 # 00502ae5
    {load} cmp eax, ebx                          # 00502ae8
    mov dword ptr [ebp - local_8], edx           # 00502aea
    jl.d8 L_00502ace                             # 00502aed
    # block 0x00502aef: entered by fall-through of jl at 0x00502aed, 2 instruction(s), ends with jle to 0x00502b20 (forward)
    test ebx, ebx                                # 00502aef
    jle.d8 L_00502b20                            # 00502af1
    # block 0x00502af3: entered by fall-through of jle at 0x00502af1, 6 instruction(s), ends with forward jump to 0x00502b06
    mov eax, dword ptr [ebp + arg_8]             # 00502af3
    mov ecx, dword ptr [ebp - local_4]           # 00502af6
    {load} sub ecx, eax                          # 00502af9
    mov dword ptr [ebp - local_10], ebx          # 00502afb
    mov dword ptr [ebp - local_14], ecx          # 00502afe
    jmp.d8 L_00502b06                            # 00502b01
L_00502b03:
    # block 0x00502b03: entered by jne at 0x00502b1b, 1 instruction(s), falls into the block at 0x00502b06
    mov ecx, dword ptr [ebp - local_14]          # 00502b03
L_00502b06:
    # block 0x00502b06: entered by jmp at 0x00502b01, 9 instruction(s), ends with jne to 0x00502b03 (backward)
    mov edx, dword ptr [eax]                     # 00502b06
    mov edi, dword ptr [esi + field_14]          # 00502b08
    mov ecx, dword ptr [ecx + eax]               # 00502b0b
    add eax, 0x4                                 # 00502b0e
    mov dword ptr [edi + 4*edx], ecx             # 00502b11
    mov ecx, dword ptr [ebp - local_10]          # 00502b14
    dec ecx                                      # 00502b17
    mov dword ptr [ebp - local_10], ecx          # 00502b18
    jne.d8 L_00502b03                            # 00502b1b
    # block 0x00502b1d: entered by fall-through of jne at 0x00502b1b, 1 instruction(s), falls into the block at 0x00502b20
    mov edi, dword ptr [ebp + arg_c]             # 00502b1d
L_00502b20:
    # block 0x00502b20: entered by jle at 0x00502ac6; jle at 0x00502af1, 19 instruction(s), calls FUN_0050e936, FUN_00502630, FUN_0050ea90, ends with jle to 0x00502b7d (forward)
    mov edx, dword ptr [ebp - local_4]           # 00502b20
    push edx                                     # 00502b23
    call FUN_0050e936                            # 00502b24
    mov eax, dword ptr [ebp + arg_8]             # 00502b29
    push eax                                     # 00502b2c
    push ebx                                     # 00502b2d
    push edi                                     # 00502b2e
    call FUN_00502630                            # 00502b2f
    mov ecx, dword ptr [ebp - local_c]           # 00502b34
    mov dword ptr [esi + field_10], eax          # 00502b37
    push ecx                                     # 00502b3a
    call FUN_0050ea90                            # 00502b3b
    mov dword ptr [esi + field_18], eax          # 00502b40
    mov edx, dword ptr [edi + field_4]           # 00502b43
    add esp, 0x14                                # 00502b46
    {load} xor ecx, ecx                          # 00502b49
    {load} xor eax, eax                          # 00502b4b
    test edx, edx                                # 00502b4d
    jle.d8 L_00502b7d                            # 00502b4f
    # block 0x00502b51: entered by fall-through of jle at 0x00502b4f, 2 instruction(s), falls into the block at 0x00502b57
    mov edx, dword ptr [ebp + arg_8]             # 00502b51
    mov dword ptr [ebp + arg_c], edx             # 00502b54
L_00502b57:
    # block 0x00502b57: entered by jl at 0x00502b7b, 3 instruction(s), ends with jle to 0x00502b75 (forward)
    mov edx, dword ptr [edi + field_8]           # 00502b57
    cmp dword ptr [edx + 4*eax], 0x0             # 00502b5a
    jle.d8 L_00502b75                            # 00502b5e
    # block 0x00502b60: entered by fall-through of jle at 0x00502b5e, 8 instruction(s), falls into the block at 0x00502b75
    mov edx, dword ptr [ebp + arg_c]             # 00502b60
    mov ebx, dword ptr [esi + field_18]          # 00502b63
    inc ecx                                      # 00502b66
    mov edx, dword ptr [edx]                     # 00502b67
    mov dword ptr [ebx + 4*edx], eax             # 00502b69
    mov edx, dword ptr [ebp + arg_c]             # 00502b6c
    add edx, 0x4                                 # 00502b6f
    mov dword ptr [ebp + arg_c], edx             # 00502b72
L_00502b75:
    # block 0x00502b75: entered by jle at 0x00502b5e, 4 instruction(s), ends with jl to 0x00502b57 (backward)
    mov edx, dword ptr [edi + field_4]           # 00502b75
    inc eax                                      # 00502b78
    {load} cmp eax, edx                          # 00502b79
    jl.d8 L_00502b57                             # 00502b7b
L_00502b7d:
    # block 0x00502b7d: entered by jle at 0x00502b4f; fall-through of jl at 0x00502b7b, 9 instruction(s), calls FUN_0050ea90, ends with jle to 0x00502bcd (forward)
    push ecx                                     # 00502b7d
    call FUN_0050ea90                            # 00502b7e
    mov dword ptr [esi + field_1c], eax          # 00502b83
    mov eax, dword ptr [edi + field_4]           # 00502b86
    {load} xor ecx, ecx                          # 00502b89
    add esp, 0x4                                 # 00502b8b
    {load} cmp eax, ecx                          # 00502b8e
    mov dword ptr [ebp + arg_c], ecx             # 00502b90
    jle.d8 L_00502bcd                            # 00502b93
    # block 0x00502b95: entered by fall-through of jle at 0x00502b93, 2 instruction(s), falls into the block at 0x00502b9b
    mov eax, dword ptr [ebp + arg_8]             # 00502b95
    mov dword ptr [ebp + arg_8], eax             # 00502b98
L_00502b9b:
    # block 0x00502b9b: entered by jl at 0x00502bcb, 5 instruction(s), ends with jle to 0x00502bc5 (forward)
    mov edx, dword ptr [edi + field_8]           # 00502b9b
    lea eax, [edx + 4*ecx]                       # 00502b9e
    mov edx, dword ptr [edx + 4*ecx]             # 00502ba1
    test edx, edx                                # 00502ba4
    jle.d8 L_00502bc5                            # 00502ba6
    # block 0x00502ba8: entered by fall-through of jle at 0x00502ba6, 11 instruction(s), falls into the block at 0x00502bc5
    mov ebx, dword ptr [ebp + arg_8]             # 00502ba8
    mov edx, dword ptr [esi + field_1c]          # 00502bab
    mov al, byte ptr [eax]                       # 00502bae
    mov ebx, dword ptr [ebx]                     # 00502bb0
    mov byte ptr [edx + ebx], al                 # 00502bb2
    mov edx, dword ptr [ebp + arg_c]             # 00502bb5
    mov eax, dword ptr [ebp + arg_8]             # 00502bb8
    inc edx                                      # 00502bbb
    add eax, 0x4                                 # 00502bbc
    mov dword ptr [ebp + arg_c], edx             # 00502bbf
    mov dword ptr [ebp + arg_8], eax             # 00502bc2
L_00502bc5:
    # block 0x00502bc5: entered by jle at 0x00502ba6, 4 instruction(s), ends with jl to 0x00502b9b (backward)
    mov eax, dword ptr [edi + field_4]           # 00502bc5
    inc ecx                                      # 00502bc8
    {load} cmp ecx, eax                          # 00502bc9
    jl.d8 L_00502b9b                             # 00502bcb
L_00502bcd:
    # block 0x00502bcd: entered by jle at 0x00502b93; fall-through of jl at 0x00502bcb, 8 instruction(s), calls FUN_005023e0, ends with jge to 0x00502beb (forward)
    mov ecx, dword ptr [esi + field_8]           # 00502bcd
    push ecx                                     # 00502bd0
    call FUN_005023e0                            # 00502bd1
    add eax, -0x4                                # 00502bd6
    add esp, 0x4                                 # 00502bd9
    cmp eax, 0x5                                 # 00502bdc
    mov dword ptr [esi + field_24], eax          # 00502bdf
    jge.d8 L_00502beb                            # 00502be2
    # block 0x00502be4: entered by fall-through of jge at 0x00502be2, 1 instruction(s), falls into the block at 0x00502beb
    mov dword ptr [esi + field_24], 0x5          # 00502be4
L_00502beb:
    # block 0x00502beb: entered by jge at 0x00502be2, 4 instruction(s), ends with jle to 0x00502bfa (forward)
    mov ecx, dword ptr [esi + field_24]          # 00502beb
    mov eax, 0x8                                 # 00502bee
    {load} cmp ecx, eax                          # 00502bf3
    jle.d8 L_00502bfa                            # 00502bf5
    # block 0x00502bf7: entered by fall-through of jle at 0x00502bf5, 1 instruction(s), falls into the block at 0x00502bfa
    mov dword ptr [esi + field_24], eax          # 00502bf7
L_00502bfa:
    # block 0x00502bfa: entered by jle at 0x00502bf5, 14 instruction(s), calls FUN_0050e97e, ends with jle to 0x00502ca5 (forward)
    mov ecx, dword ptr [esi + field_24]          # 00502bfa
    mov edi, 0x1                                 # 00502bfd
    shl edi, cl                                  # 00502c02
    push 0x4                                     # 00502c04
    push edi                                     # 00502c06
    mov dword ptr [ebp - local_10], edi          # 00502c07
    call FUN_0050e97e                            # 00502c0a
    mov dword ptr [esi + field_20], eax          # 00502c0f
    mov eax, dword ptr [ebp + arg_c]             # 00502c12
    add esp, 0x8                                 # 00502c15
    {load} xor ebx, ebx                          # 00502c18
    test eax, eax                                # 00502c1a
    mov dword ptr [esi + field_28], ebx          # 00502c1c
    jle.d32 L_00502ca5                           # 00502c1f
L_00502c25:
    # block 0x00502c25: entered by jl at 0x00502ca3; fall-through of jle at 0x00502c1f, 6 instruction(s), ends with jge to 0x00502c39 (forward)
    mov edx, dword ptr [esi + field_1c]          # 00502c25
    movsx eax, byte ptr [edx + ebx]              # 00502c28
    lea ecx, [edx + ebx]                         # 00502c2c
    mov edx, dword ptr [esi + field_28]          # 00502c2f
    {load} cmp edx, eax                          # 00502c32
    jge.d8 L_00502c39                            # 00502c34
    # block 0x00502c36: entered by fall-through of jge at 0x00502c34, 1 instruction(s), falls into the block at 0x00502c39
    mov dword ptr [esi + field_28], eax          # 00502c36
L_00502c39:
    # block 0x00502c39: entered by jge at 0x00502c34, 3 instruction(s), ends with jg to 0x00502c9d (forward)
    movsx eax, byte ptr [ecx]                    # 00502c39
    cmp eax, dword ptr [esi + field_24]          # 00502c3c
    jg.d8 L_00502c9d                             # 00502c3f
    # block 0x00502c41: entered by fall-through of jg at 0x00502c3f, 15 instruction(s), calls FUN_00502da0, ends with jle to 0x00502c9a (forward)
    mov ecx, dword ptr [esi + field_14]          # 00502c41
    mov edx, dword ptr [ecx + 4*ebx]             # 00502c44
    push edx                                     # 00502c47
    call FUN_00502da0                            # 00502c48
    mov ecx, dword ptr [esi + field_24]          # 00502c4d
    mov dword ptr [ebp + arg_8], eax             # 00502c50
    mov eax, dword ptr [esi + field_1c]          # 00502c53
    add esp, 0x4                                 # 00502c56
    {load} xor edi, edi                          # 00502c59
    movsx edx, byte ptr [eax + ebx]              # 00502c5b
    {load} sub ecx, edx                          # 00502c5f
    mov eax, 0x1                                 # 00502c61
    shl eax, cl                                  # 00502c66
    test eax, eax                                # 00502c68
    jle.d8 L_00502c9a                            # 00502c6a
L_00502c6c:
    # block 0x00502c6c: entered by jl at 0x00502c98; fall-through of jle at 0x00502c6a, 18 instruction(s), ends with jl to 0x00502c6c (backward)
    {load} mov eax, edi                          # 00502c6c
    {load} mov ecx, edx                          # 00502c6e
    mov edx, dword ptr [ebp + arg_8]             # 00502c70
    shl eax, cl                                  # 00502c73
    mov ecx, dword ptr [esi + field_20]          # 00502c75
    {load} or eax, edx                           # 00502c78
    inc edi                                      # 00502c7a
    {load} mov edx, eax                          # 00502c7b
    lea eax, [ebx + field_1]                     # 00502c7d
    mov dword ptr [ecx + 4*edx], eax             # 00502c80
    mov eax, dword ptr [esi + field_1c]          # 00502c83
    mov ecx, dword ptr [esi + field_24]          # 00502c86
    movsx edx, byte ptr [eax + ebx]              # 00502c89
    {load} sub ecx, edx                          # 00502c8d
    mov eax, 0x1                                 # 00502c8f
    shl eax, cl                                  # 00502c94
    {load} cmp edi, eax                          # 00502c96
    jl.d8 L_00502c6c                             # 00502c98
L_00502c9a:
    # block 0x00502c9a: entered by jle at 0x00502c6a; fall-through of jl at 0x00502c98, 1 instruction(s), falls into the block at 0x00502c9d
    mov edi, dword ptr [ebp - local_10]          # 00502c9a
L_00502c9d:
    # block 0x00502c9d: entered by jg at 0x00502c3f, 4 instruction(s), ends with jl to 0x00502c25 (backward)
    mov eax, dword ptr [ebp + arg_c]             # 00502c9d
    inc ebx                                      # 00502ca0
    {load} cmp ebx, eax                          # 00502ca1
    jl.d8 L_00502c25                             # 00502ca3
L_00502ca5:
    # block 0x00502ca5: entered by jle at 0x00502c1f; fall-through of jl at 0x00502ca3, 12 instruction(s), ends with jle to 0x00502d8c (forward)
    mov ebx, dword ptr [esi + field_24]          # 00502ca5
    mov ecx, 0x1f                                # 00502ca8
    {load} sub ecx, ebx                          # 00502cad
    mov eax, 0xfffffffe                          # 00502caf
    shl eax, cl                                  # 00502cb4
    {load} xor ebx, ebx                          # 00502cb6
    {load} cmp edi, ebx                          # 00502cb8
    mov dword ptr [ebp + arg_8], ebx             # 00502cba
    mov dword ptr [ebp - local_4], ebx           # 00502cbd
    mov dword ptr [ebp - local_c], ebx           # 00502cc0
    mov dword ptr [ebp - local_14], eax          # 00502cc3
    jle.d32 L_00502d8c                           # 00502cc6
L_00502ccc:
    # block 0x00502ccc: entered by jl at 0x00502d86; fall-through of jle at 0x00502cc6, 11 instruction(s), calls FUN_00502da0, ends with jne to 0x00502d7a (forward)
    mov edx, dword ptr [esi + field_24]          # 00502ccc
    mov edi, dword ptr [ebp - local_c]           # 00502ccf
    mov ecx, 0x20                                # 00502cd2
    {load} sub ecx, edx                          # 00502cd7
    shl edi, cl                                  # 00502cd9
    push edi                                     # 00502cdb
    call FUN_00502da0                            # 00502cdc
    mov ecx, dword ptr [esi + field_20]          # 00502ce1
    add esp, 0x4                                 # 00502ce4
    cmp dword ptr [ecx + 4*eax], 0x0             # 00502ce7
    jne.d32 L_00502d7a                           # 00502ceb
    # block 0x00502cf1: entered by fall-through of jne at 0x00502ceb, 4 instruction(s), ends with jge to 0x00502d11 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00502cf1
    lea eax, [ebx + field_1]                     # 00502cf4
    {load} cmp eax, edx                          # 00502cf7
    jge.d8 L_00502d11                            # 00502cf9
    # block 0x00502cfb: entered by fall-through of jge at 0x00502cf9, 2 instruction(s), falls into the block at 0x00502d01
    mov ecx, dword ptr [esi + field_14]          # 00502cfb
    lea ecx, [ecx + 4*eax]                       # 00502cfe
L_00502d01:
    # block 0x00502d01: entered by jl at 0x00502d0c, 2 instruction(s), ends with ja to 0x00502d0e (forward)
    cmp dword ptr [ecx], edi                     # 00502d01
    ja.d8 L_00502d0e                             # 00502d03
    # block 0x00502d05: entered by fall-through of ja at 0x00502d03, 5 instruction(s), ends with jl to 0x00502d01 (backward)
    inc ebx                                      # 00502d05
    inc eax                                      # 00502d06
    add ecx, 0x4                                 # 00502d07
    {load} cmp eax, edx                          # 00502d0a
    jl.d8 L_00502d01                             # 00502d0c
L_00502d0e:
    # block 0x00502d0e: entered by ja at 0x00502d03; fall-through of jl at 0x00502d0c, 1 instruction(s), falls into the block at 0x00502d11
    mov dword ptr [ebp + arg_8], ebx             # 00502d0e
L_00502d11:
    # block 0x00502d11: entered by jge at 0x00502cf9, 3 instruction(s), ends with jge to 0x00502d3a (forward)
    mov eax, dword ptr [ebp - local_4]           # 00502d11
    {load} cmp eax, edx                          # 00502d14
    jge.d8 L_00502d3a                            # 00502d16
    # block 0x00502d18: entered by fall-through of jge at 0x00502d16, 2 instruction(s), falls into the block at 0x00502d1e
    mov ecx, dword ptr [esi + field_14]          # 00502d18
    lea eax, [ecx + 4*eax]                       # 00502d1b
L_00502d1e:
    # block 0x00502d1e: entered by jl at 0x00502d35, 5 instruction(s), ends with jb to 0x00502d37 (forward)
    mov ecx, dword ptr [eax]                     # 00502d1e
    mov ebx, dword ptr [ebp - local_14]          # 00502d20
    {load} and ecx, ebx                          # 00502d23
    {load} cmp edi, ecx                          # 00502d25
    jb.d8 L_00502d37                             # 00502d27
    # block 0x00502d29: entered by fall-through of jb at 0x00502d27, 6 instruction(s), ends with jl to 0x00502d1e (backward)
    mov ecx, dword ptr [ebp - local_4]           # 00502d29
    add eax, 0x4                                 # 00502d2c
    inc ecx                                      # 00502d2f
    {load} cmp ecx, edx                          # 00502d30
    mov dword ptr [ebp - local_4], ecx           # 00502d32
    jl.d8 L_00502d1e                             # 00502d35
L_00502d37:
    # block 0x00502d37: entered by jb at 0x00502d27; fall-through of jl at 0x00502d35, 1 instruction(s), falls into the block at 0x00502d3a
    mov ebx, dword ptr [ebp + arg_8]             # 00502d37
L_00502d3a:
    # block 0x00502d3a: entered by jge at 0x00502d16, 6 instruction(s), ends with jbe to 0x00502d51 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00502d3a
    {load} mov eax, edx                          # 00502d3d
    mov edx, dword ptr [ebp - local_4]           # 00502d3f
    {load} sub eax, edx                          # 00502d42
    cmp ecx, 0x7fff                              # 00502d44
    jbe.d8 L_00502d51                            # 00502d4a
    # block 0x00502d4c: entered by fall-through of jbe at 0x00502d4a, 1 instruction(s), falls into the block at 0x00502d51
    mov ebx, 0x7fff                              # 00502d4c
L_00502d51:
    # block 0x00502d51: entered by jbe at 0x00502d4a, 2 instruction(s), ends with jbe to 0x00502d5d (forward)
    cmp eax, 0x7fff                              # 00502d51
    jbe.d8 L_00502d5d                            # 00502d56
    # block 0x00502d58: entered by fall-through of jbe at 0x00502d56, 1 instruction(s), falls into the block at 0x00502d5d
    mov eax, 0x7fff                              # 00502d58
L_00502d5d:
    # block 0x00502d5d: entered by jbe at 0x00502d56, 9 instruction(s), calls FUN_00502da0, falls into the block at 0x00502d7a
    or ebx, 0xffff0000                           # 00502d5d
    push edi                                     # 00502d63
    shl ebx, 0xf                                 # 00502d64
    {load} or ebx, eax                           # 00502d67
    call FUN_00502da0                            # 00502d69
    mov edx, dword ptr [esi + field_20]          # 00502d6e
    add esp, 0x4                                 # 00502d71
    mov dword ptr [edx + 4*eax], ebx             # 00502d74
    mov ebx, dword ptr [ebp + arg_8]             # 00502d77
L_00502d7a:
    # block 0x00502d7a: entered by jne at 0x00502ceb, 6 instruction(s), ends with jl to 0x00502ccc (backward)
    mov eax, dword ptr [ebp - local_c]           # 00502d7a
    mov ecx, dword ptr [ebp - local_10]          # 00502d7d
    inc eax                                      # 00502d80
    {load} cmp eax, ecx                          # 00502d81
    mov dword ptr [ebp - local_c], eax           # 00502d83
    jl.d32 L_00502ccc                            # 00502d86
L_00502d8c:
    # block 0x00502d8c: entered by jle at 0x00502cc6; fall-through of jl at 0x00502d86, 8 instruction(s), ends with ret
    lea esp, [ebp - local_20]                    # 00502d8c
    {load} xor eax, eax                          # 00502d8f
    pop edi                                      # 00502d91
    pop esi                                      # 00502d92
    pop ebx                                      # 00502d93
    {load} mov esp, ebp                          # 00502d94
    pop ebp                                      # 00502d96
    ret                                          # 00502d97

# --- data items (not part of the function) -------------------------
.org 0x00502d98 - 0x401000
PAD_00502d98:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

