# FUN_004fadc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fadc4
# extent:       0x004fadc4-0x004faf98 (468 code bytes)
# span:         0x004fadc4-0x004faf98 (code 468, tables 0, padding 0)
# sha256:       0576d48f541320ff06b1ff2f8753d013d9d9c0516f44f4cf475e6d02577f2afa
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
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
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f379c, .text + (0x004f379c - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fadc4 - 0x401000
.globl FUN_004fadc4
FUN_004fadc4:
    # block 0x004fadc4: <unfilled>
    push ebp                                     # 004fadc4
    {load} mov ebp, esp                          # 004fadc5
    push ecx                                     # 004fadc7
    push esi                                     # 004fadc8
    push edi                                     # 004fadc9
    mov dword ptr [ebp - local_4], ecx           # 004fadca
    movsx eax, word ptr [0x63a4cd]               # 004fadcd
    test eax, eax                                # 004fadd4
    je.d8 L_004fae05                             # 004fadd6
    # block 0x004fadd8: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004fadd8
    push ecx                                     # 004faddb
    mov edx, dword ptr [ebp + arg_c]             # 004faddc
    and edx, 0xffff                              # 004faddf
    push edx                                     # 004fade5
    push 0x5605e0                                # 004fade6
    push 0x63888b                                # 004fadeb
    call FUN_0050ca3e                            # 004fadf0
    add esp, 0x10                                # 004fadf5
    push 0x63888b                                # 004fadf8
    call FUN_0044a2b7                            # 004fadfd
    add esp, 0x4                                 # 004fae02
L_004fae05:
    # block 0x004fae05: <unfilled>
    mov edi, dword ptr [ebp + arg_8]             # 004fae05
    mov eax, dword ptr [ebp + arg_c]             # 004fae08
    and eax, 0xffff                              # 004fae0b
    imul eax, eax, 0x5bb                         # 004fae10
    mov ecx, dword ptr [ebp - local_4]           # 004fae16
    lea edx, [ecx + eax + 0x8]                   # 004fae19
    or ecx, -0x1                                 # 004fae1d
    {load} xor eax, eax                          # 004fae20
    repne scasb al, byte ptr es:[edi]            # 004fae22
    not ecx                                      # 004fae24
    {load} sub edi, ecx                          # 004fae26
    {load} mov esi, edi                          # 004fae28
    {load} mov eax, ecx                          # 004fae2a
    {load} mov edi, edx                          # 004fae2c
    shr ecx, 0x2                                 # 004fae2e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fae31
    {load} mov ecx, eax                          # 004fae33
    and ecx, 0x3                                 # 004fae35
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fae38
    mov ecx, dword ptr [ebp + arg_c]             # 004fae3a
    and ecx, 0xffff                              # 004fae3d
    imul ecx, ecx, 0x5bb                         # 004fae43
    mov edx, dword ptr [ebp + arg_c]             # 004fae49
    and edx, 0xffff                              # 004fae4c
    imul edx, edx, 0x5bb                         # 004fae52
    mov eax, dword ptr [ebp - local_4]           # 004fae58
    movsx edx, word ptr [eax + edx + 0x10c]      # 004fae5b
    mov eax, dword ptr [ebp - local_4]           # 004fae63
    mov esi, dword ptr [ebp - local_4]           # 004fae66
    fld dword ptr [eax + ecx + 0x138]            # 004fae69
    fmul dword ptr [esi + 4*edx + 0xb764]        # 004fae70
    fmul dword ptr [0x52e4e0]                    # 004fae77
    fadd qword ptr [0x52e4d8]                    # 004fae7d
    call FUN_0050ce04                            # 004fae83
    mov ecx, dword ptr [ebp + arg_c]             # 004fae88
    and ecx, 0xffff                              # 004fae8b
    imul ecx, ecx, 0x5bb                         # 004fae91
    mov edx, dword ptr [ebp - local_4]           # 004fae97
    mov dword ptr [edx + ecx + 0x140], eax       # 004fae9a
    mov eax, dword ptr [ebp + arg_c]             # 004faea1
    and eax, 0xffff                              # 004faea4
    imul eax, eax, 0x5bb                         # 004faea9
    mov ecx, dword ptr [ebp + arg_c]             # 004faeaf
    and ecx, 0xffff                              # 004faeb2
    imul ecx, ecx, 0x5bb                         # 004faeb8
    mov edx, dword ptr [ebp - local_4]           # 004faebe
    movsx ecx, word ptr [edx + ecx + 0x10c]      # 004faec1
    mov edx, dword ptr [ebp - local_4]           # 004faec9
    mov esi, dword ptr [ebp - local_4]           # 004faecc
    fld dword ptr [edx + eax + 0x13c]            # 004faecf
    fmul dword ptr [esi + 4*ecx + 0xb764]        # 004faed6
    fmul dword ptr [0x52e4e0]                    # 004faedd
    fadd qword ptr [0x52e4d8]                    # 004faee3
    call FUN_0050ce04                            # 004faee9
    mov ecx, dword ptr [ebp + arg_c]             # 004faeee
    and ecx, 0xffff                              # 004faef1
    imul ecx, ecx, 0x5bb                         # 004faef7
    mov edx, dword ptr [ebp - local_4]           # 004faefd
    mov dword ptr [edx + ecx + 0x144], eax       # 004faf00
    mov ax, word ptr [ebp + arg_c]               # 004faf07
    push eax                                     # 004faf0b
    mov ecx, 0x5cf1eb                            # 004faf0c
    call FUN_004f379c                            # 004faf11
    test eax, eax                                # 004faf16
    jne.d8 L_004faf6f                            # 004faf18
    # block 0x004faf1a: <unfilled>
    mov ecx, 0x5cf1eb                            # 004faf1a
    call FUN_004fa2a8                            # 004faf1f
    push eax                                     # 004faf24
    mov ecx, dword ptr [ebp + arg_8]             # 004faf25
    push ecx                                     # 004faf28
    mov edx, dword ptr [ebp + arg_c]             # 004faf29
    and edx, 0xffff                              # 004faf2c
    push edx                                     # 004faf32
    push 0x560610                                # 004faf33
    push 0x63888b                                # 004faf38
    call FUN_0050ca3e                            # 004faf3d
    add esp, 0x14                                # 004faf42
    push 0x0                                     # 004faf45
    push 0x0                                     # 004faf47
    push 0x63888b                                # 004faf49
    call FUN_0052139c                            # 004faf4e
    movsx eax, word ptr [0x63a4cd]               # 004faf53
    test eax, eax                                # 004faf5a
    je.d8 L_004faf6b                             # 004faf5c
    # block 0x004faf5e: <unfilled>
    push 0x63888b                                # 004faf5e
    call FUN_0044a2b7                            # 004faf63
    add esp, 0x4                                 # 004faf68
L_004faf6b:
    # block 0x004faf6b: <unfilled>
    {load} xor eax, eax                          # 004faf6b
    jmp.d8 L_004faf90                            # 004faf6d
L_004faf6f:
    # block 0x004faf6f: <unfilled>
    mov ecx, dword ptr [ebp + arg_c]             # 004faf6f
    and ecx, 0xffff                              # 004faf72
    imul ecx, ecx, 0x5bb                         # 004faf78
    mov edx, dword ptr [ebp - local_4]           # 004faf7e
    mov word ptr [edx + ecx + 0x132], 0x1        # 004faf81
    mov eax, 0x1                                 # 004faf8b
L_004faf90:
    # block 0x004faf90: <unfilled>
    pop edi                                      # 004faf90
    pop esi                                      # 004faf91
    {load} mov esp, ebp                          # 004faf92
    pop ebp                                      # 004faf94
    ret 0x8                                      # 004faf95
