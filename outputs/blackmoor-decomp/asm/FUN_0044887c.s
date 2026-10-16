# FUN_0044887c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044887c
# extent:       0x0044887c-0x00448d11 (1173 code bytes)
# span:         0x0044887c-0x00448d11 (code 1173, tables 0, padding 0)
# sha256:       fb6bf65473759e833d52884adf94356112ca47657739f2782d160f67cbb3dd3d
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044887c
# arguments:    12 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c, arg_30, arg_34; ret 0x30 (callee pops 48 bytes); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_138c, local_1390, local_1394, local_1398
# fields:       [eax + n] field_10; [ecx + n] field_10, field_2c, field_2e, field_38; [edx + n] field_10, field_32, field_34
# callees:      calls FUN_0050c920, FUN_0050ca3e, FUN_0044a2b7, FUN_004d3836, FUN_004d270b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 297 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_138c, 0x138c  # offset -0x138c
.equ local_1390, 0x1390  # offset -0x1390
.equ local_1394, 0x1394  # offset -0x1394
.equ local_1398, 0x1398  # offset -0x1398
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ arg_30, 0x30  # offset +0x30
.equ field_32, 0x32  # offset +0x32
.equ field_34, 0x34  # offset +0x34
.equ arg_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004d270b, .text + (0x004d270b - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0044887c - 0x401000
.globl FUN_0044887c
FUN_0044887c:
    # block 0x0044887c: entry, 14 instruction(s), calls FUN_0050c920, falls into the block at 0x004488b9
    push ebp                                     # 0044887c
    {load} mov ebp, esp                          # 0044887d
    mov eax, 0x1398                              # 0044887f
    call FUN_0050c920                            # 00448884
    push esi                                     # 00448889
    push edi                                     # 0044888a
    mov dword ptr [ebp - local_1398], ecx        # 0044888b
    mov dword ptr [ebp - local_4], 0x0           # 00448891
    mov ecx, 0x4e2                               # 00448898
    {load} xor eax, eax                          # 0044889d
    lea edi, [ebp - local_138c]                  # 0044889f
    rep stosd dword ptr es:[edi], eax            # 004488a5
    mov word ptr [ebp - local_1394], 0x0         # 004488a7
    mov word ptr [ebp - local_1390], 0x0         # 004488b0
L_004488b9:
    # block 0x004488b9: entered by jmp at 0x00448cf8, 3 instruction(s), ends with je to 0x00448cfd (forward)
    mov eax, 0x1                                 # 004488b9
    test eax, eax                                # 004488be
    je.d32 L_00448cfd                            # 004488c0
    # block 0x004488c6: entered by fall-through of je at 0x004488c0, 3 instruction(s), ends with je to 0x00448a24 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004488c6
    cmp dword ptr [ecx], 0x0                     # 004488c9
    je.d32 L_00448a24                            # 004488cc
    # block 0x004488d2: entered by fall-through of je at 0x004488cc, 3 instruction(s), ends with je to 0x00448900 (forward)
    mov edx, dword ptr [ebp - local_1398]        # 004488d2
    cmp dword ptr [edx + field_34], 0x0          # 004488d8
    je.d8 L_00448900                             # 004488dc
    # block 0x004488de: entered by fall-through of je at 0x004488dc, 8 instruction(s), ends with forward jump to 0x00448996
    movsx eax, word ptr [ebp + arg_c]            # 004488de
    imul eax, eax, 0x1d0                         # 004488e2
    mov ecx, dword ptr [ebp + arg_14]            # 004488e8
    mov dx, word ptr [ecx]                       # 004488eb
    add dx, word ptr [eax + 0x5adb3c]            # 004488ee
    mov eax, dword ptr [ebp + arg_14]            # 004488f5
    mov word ptr [eax], dx                       # 004488f8
    jmp.d32 L_00448996                           # 004488fb
L_00448900:
    # block 0x00448900: entered by je at 0x004488dc, 3 instruction(s), ends with je to 0x0044895b (forward)
    mov ecx, dword ptr [ebp - local_1398]        # 00448900
    cmp dword ptr [ecx + field_38], 0x0          # 00448906
    je.d8 L_0044895b                             # 0044890a
    # block 0x0044890c: entered by fall-through of je at 0x0044890a, 21 instruction(s), ends with forward jump to 0x00448996
    movsx edx, word ptr [ebp + arg_c]            # 0044890c
    imul edx, edx, 0x1d0                         # 00448910
    movsx ecx, word ptr [edx + 0x5adb3c]         # 00448916
    movsx edx, word ptr [ebp + arg_c]            # 0044891d
    imul edx, edx, 0x1d0                         # 00448921
    movsx eax, word ptr [edx + 0x5adb3c]         # 00448927
    cdq                                          # 0044892e
    mov esi, 0x9                                 # 0044892f
    idiv esi                                     # 00448934
    {load} add eax, ecx                          # 00448936
    cdq                                          # 00448938
    {load} sub eax, edx                          # 00448939
    sar eax                                      # 0044893b
    mov ecx, dword ptr [ebp + arg_14]            # 0044893d
    mov dx, word ptr [ecx]                       # 00448940
    {load} add dx, ax                            # 00448943
    mov eax, dword ptr [ebp + arg_14]            # 00448946
    mov word ptr [eax], dx                       # 00448949
    mov ecx, dword ptr [ebp - local_1398]        # 0044894c
    mov dword ptr [ecx + field_38], 0x0          # 00448952
    jmp.d8 L_00448996                            # 00448959
L_0044895b:
    # block 0x0044895b: entered by je at 0x0044890a, 15 instruction(s), falls into the block at 0x00448996
    movsx edx, word ptr [ebp + arg_c]            # 0044895b
    imul edx, edx, 0x1d0                         # 0044895f
    movsx ecx, word ptr [edx + 0x5adb3c]         # 00448965
    movsx edx, word ptr [ebp + arg_c]            # 0044896c
    imul edx, edx, 0x1d0                         # 00448970
    movsx eax, word ptr [edx + 0x5adb3c]         # 00448976
    cdq                                          # 0044897d
    mov esi, 0x9                                 # 0044897e
    idiv esi                                     # 00448983
    {load} add ecx, eax                          # 00448985
    mov eax, dword ptr [ebp + arg_14]            # 00448987
    mov dx, word ptr [eax]                       # 0044898a
    {load} add dx, cx                            # 0044898d
    mov eax, dword ptr [ebp + arg_14]            # 00448990
    mov word ptr [eax], dx                       # 00448993
L_00448996:
    # block 0x00448996: entered by jmp at 0x004488fb; jmp at 0x00448959, 5 instruction(s), ends with jl to 0x00448a1b (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 00448996
    movsx edx, word ptr [ecx]                    # 00448999
    movsx eax, word ptr [ebp + arg_18]           # 0044899c
    {load} cmp edx, eax                          # 004489a0
    jl.d8 L_00448a1b                             # 004489a2
    # block 0x004489a4: entered by fall-through of jl at 0x004489a2, 4 instruction(s), ends with jle to 0x004489bb (forward)
    mov ecx, dword ptr [ebp + arg_24]            # 004489a4
    movsx edx, word ptr [ecx]                    # 004489a7
    cmp edx, 0x2                                 # 004489aa
    jle.d8 L_004489bb                            # 004489ad
    # block 0x004489af: entered by fall-through of jle at 0x004489ad, 4 instruction(s), ends with je to 0x004489d2 (forward)
    mov eax, dword ptr [ebp + arg_30]            # 004489af
    and eax, 0xff                                # 004489b2
    test eax, eax                                # 004489b7
    je.d8 L_004489d2                             # 004489b9
L_004489bb:
    # block 0x004489bb: entered by jle at 0x004489ad; fall-through of je at 0x004489b9, 4 instruction(s), ends with jle to 0x00448a1b (forward)
    mov ecx, dword ptr [ebp + arg_24]            # 004489bb
    movsx edx, word ptr [ecx]                    # 004489be
    cmp edx, 0x6                                 # 004489c1
    jle.d8 L_00448a1b                            # 004489c4
    # block 0x004489c6: entered by fall-through of jle at 0x004489c4, 4 instruction(s), ends with je to 0x00448a1b (forward)
    mov eax, dword ptr [ebp + arg_30]            # 004489c6
    and eax, 0xff                                # 004489c9
    test eax, eax                                # 004489ce
    je.d8 L_00448a1b                             # 004489d0
L_004489d2:
    # block 0x004489d2: entered by je at 0x004489b9; fall-through of je at 0x004489d0, 2 instruction(s), ends with jne to 0x00448a1b (forward)
    cmp dword ptr [ebp + arg_34], 0x0            # 004489d2
    jne.d8 L_00448a1b                            # 004489d6
    # block 0x004489d8: entered by fall-through of jne at 0x004489d6, 3 instruction(s), ends with je to 0x00448a1b (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004489d8
    test ecx, ecx                                # 004489df
    je.d8 L_00448a1b                             # 004489e1
    # block 0x004489e3: entered by fall-through of je at 0x004489e1, 3 instruction(s), ends with jne to 0x00448a1b (forward)
    mov edx, dword ptr [ebp - local_1398]        # 004489e3
    cmp dword ptr [edx + field_10], 0x0          # 004489e9
    jne.d8 L_00448a1b                            # 004489ed
    # block 0x004489ef: entered by fall-through of jne at 0x004489ed, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00448a1b
    push 0x5487b8                                # 004489ef
    push 0x63888b                                # 004489f4
    call FUN_0050ca3e                            # 004489f9
    add esp, 0x8                                 # 004489fe
    push 0x63888b                                # 00448a01
    call FUN_0044a2b7                            # 00448a06
    add esp, 0x4                                 # 00448a0b
    mov eax, dword ptr [ebp - local_1398]        # 00448a0e
    mov dword ptr [eax + field_10], 0x1          # 00448a14
L_00448a1b:
    # block 0x00448a1b: entered by jl at 0x004489a2; jle at 0x004489c4; je at 0x004489d0; jne at 0x004489d6; more, 2 instruction(s), falls into the block at 0x00448a24
    mov ecx, dword ptr [ebp + arg_10]            # 00448a1b
    mov dword ptr [ecx], 0x0                     # 00448a1e
L_00448a24:
    # block 0x00448a24: entered by je at 0x004488cc, 8 instruction(s), ends with jne to 0x00448a3c (forward)
    mov edi, dword ptr [ebp + arg_8]             # 00448a24
    or ecx, -0x1                                 # 00448a27
    {load} xor eax, eax                          # 00448a2a
    repne scasb al, byte ptr es:[edi]            # 00448a2c
    not ecx                                      # 00448a2e
    add ecx, -0x1                                # 00448a30
    test ecx, ecx                                # 00448a33
    jne.d8 L_00448a3c                            # 00448a35
    # block 0x00448a37: entered by fall-through of jne at 0x00448a35, 1 instruction(s), ends with forward jump to 0x00448cfd
    jmp.d32 L_00448cfd                           # 00448a37
L_00448a3c:
    # block 0x00448a3c: entered by jne at 0x00448a35; jmp at 0x00448ad0, 19 instruction(s), calls FUN_004d3836, ends with jge to 0x00448ad5 (forward)
    mov edx, dword ptr [ebp + arg_20]            # 00448a3c
    movsx esi, word ptr [edx]                    # 00448a3f
    movsx eax, word ptr [ebp + arg_c]            # 00448a42
    imul eax, eax, 0x1d0                         # 00448a46
    add eax, 0x5adb3a                            # 00448a4c
    push eax                                     # 00448a51
    movsx ecx, word ptr [ebp + arg_c]            # 00448a52
    imul ecx, ecx, 0x7f3                         # 00448a56
    add ecx, 0x5a4c24                            # 00448a5c
    push ecx                                     # 00448a62
    lea edx, [ebp - local_138c]                  # 00448a63
    push edx                                     # 00448a69
    call FUN_004d3836                            # 00448a6a
    add esp, 0xc                                 # 00448a6f
    movsx eax, ax                                # 00448a72
    {load} add esi, eax                          # 00448a75
    movsx ecx, word ptr [ebp + arg_1c]           # 00448a77
    {load} cmp esi, ecx                          # 00448a7b
    jge.d8 L_00448ad5                            # 00448a7d
    # block 0x00448a7f: entered by fall-through of jge at 0x00448a7d, 5 instruction(s), ends with je to 0x00448ad5 (forward)
    movsx edx, word ptr [ebp - local_1394]       # 00448a7f
    mov eax, dword ptr [ebp + arg_8]             # 00448a86
    movsx ecx, byte ptr [eax + edx]              # 00448a89
    test ecx, ecx                                # 00448a8d
    je.d8 L_00448ad5                             # 00448a8f
    # block 0x00448a91: entered by fall-through of je at 0x00448a8f, 12 instruction(s), ends with backward jump to 0x00448a3c
    movsx edx, word ptr [ebp - local_1394]       # 00448a91
    movsx eax, word ptr [ebp - local_1390]       # 00448a98
    mov ecx, dword ptr [ebp + arg_8]             # 00448a9f
    mov dl, byte ptr [ecx + edx]                 # 00448aa2
    mov byte ptr [ebp + eax - local_138c], dl    # 00448aa5
    mov ax, word ptr [ebp - local_1390]          # 00448aac
    .insn 0x66, 0x05, 0x0001{:u16}               # 00448ab3
    mov word ptr [ebp - local_1390], ax          # 00448ab7
    mov cx, word ptr [ebp - local_1394]          # 00448abe
    add cx, 0x1                                  # 00448ac5
    mov word ptr [ebp - local_1394], cx          # 00448ac9
    jmp.d32 L_00448a3c                           # 00448ad0
L_00448ad5:
    # block 0x00448ad5: entered by jge at 0x00448a7d; je at 0x00448a8f, 5 instruction(s), ends with jne to 0x00448af7 (forward)
    movsx edx, word ptr [ebp - local_1394]       # 00448ad5
    mov eax, dword ptr [ebp + arg_8]             # 00448adc
    movsx ecx, byte ptr [eax + edx]              # 00448adf
    test ecx, ecx                                # 00448ae3
    jne.d8 L_00448af7                            # 00448ae5
    # block 0x00448ae7: entered by fall-through of jne at 0x00448ae5, 5 instruction(s), falls into the block at 0x00448af7
    mov edx, dword ptr [ebp + arg_24]            # 00448ae7
    mov ax, word ptr [edx]                       # 00448aea
    .insn 0x66, 0x05, 0x0001{:u16}               # 00448aed
    mov ecx, dword ptr [ebp + arg_24]            # 00448af1
    mov word ptr [ecx], ax                       # 00448af4
L_00448af7:
    # block 0x00448af7: entered by jne at 0x00448ae5, 5 instruction(s), ends with je to 0x00448bbf (forward)
    movsx edx, word ptr [ebp - local_1394]       # 00448af7
    mov eax, dword ptr [ebp + arg_8]             # 00448afe
    movsx ecx, byte ptr [eax + edx]              # 00448b01
    test ecx, ecx                                # 00448b05
    je.d32 L_00448bbf                            # 00448b07
    # block 0x00448b0d: entered by fall-through of je at 0x00448b07, 8 instruction(s), falls into the block at 0x00448b40
    mov dx, word ptr [ebp - local_1390]          # 00448b0d
    sub dx, 0x1                                  # 00448b14
    mov word ptr [ebp - local_1390], dx          # 00448b18
    mov ax, word ptr [ebp - local_1394]          # 00448b1f
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00448b26
    mov word ptr [ebp - local_1394], ax          # 00448b2a
    movsx ecx, word ptr [ebp - local_1390]       # 00448b31
    mov byte ptr [ebp + ecx - local_138c], 0x0   # 00448b38
L_00448b40:
    # block 0x00448b40: entered by jmp at 0x00448b83, 4 instruction(s), ends with je to 0x00448b85 (forward)
    movsx edx, word ptr [ebp - local_1390]       # 00448b40
    movsx eax, byte ptr [ebp + edx - local_138c] # 00448b47
    cmp eax, 0x20                                # 00448b4f
    je.d8 L_00448b85                             # 00448b52
    # block 0x00448b54: entered by fall-through of je at 0x00448b52, 3 instruction(s), ends with jl to 0x00448b85 (forward)
    movsx ecx, word ptr [ebp - local_1390]       # 00448b54
    test ecx, ecx                                # 00448b5b
    jl.d8 L_00448b85                             # 00448b5d
    # block 0x00448b5f: entered by fall-through of jl at 0x00448b5d, 7 instruction(s), ends with backward jump to 0x00448b40
    mov dx, word ptr [ebp - local_1390]          # 00448b5f
    sub dx, 0x1                                  # 00448b66
    mov word ptr [ebp - local_1390], dx          # 00448b6a
    mov ax, word ptr [ebp - local_1394]          # 00448b71
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00448b78
    mov word ptr [ebp - local_1394], ax          # 00448b7c
    jmp.d8 L_00448b40                            # 00448b83
L_00448b85:
    # block 0x00448b85: entered by je at 0x00448b52; jl at 0x00448b5d, 9 instruction(s), falls into the block at 0x00448bbf
    mov cx, word ptr [ebp - local_1390]          # 00448b85
    add cx, 0x1                                  # 00448b8c
    mov word ptr [ebp - local_1390], cx          # 00448b90
    mov dx, word ptr [ebp - local_1394]          # 00448b97
    add dx, 0x1                                  # 00448b9e
    mov word ptr [ebp - local_1394], dx          # 00448ba2
    movsx eax, word ptr [ebp - local_1390]       # 00448ba9
    mov byte ptr [ebp + eax - local_138c], 0x0   # 00448bb0
    mov dword ptr [ebp - local_4], 0x1           # 00448bb8
L_00448bbf:
    # block 0x00448bbf: entered by je at 0x00448b07, 8 instruction(s), ends with jbe to 0x00448c96 (forward)
    lea edi, [ebp - local_138c]                  # 00448bbf
    or ecx, -0x1                                 # 00448bc5
    {load} xor eax, eax                          # 00448bc8
    repne scasb al, byte ptr es:[edi]            # 00448bca
    not ecx                                      # 00448bcc
    add ecx, -0x1                                # 00448bce
    test ecx, ecx                                # 00448bd1
    jbe.d32 L_00448c96                           # 00448bd3
    # block 0x00448bd9: entered by fall-through of jbe at 0x00448bd3, 3 instruction(s), ends with jne to 0x00448c96 (forward)
    mov ecx, dword ptr [ebp - local_1398]        # 00448bd9
    cmp dword ptr [ecx + field_10], 0x0          # 00448bdf
    jne.d32 L_00448c96                           # 00448be3
    # block 0x00448be9: entered by fall-through of jne at 0x00448be3, 2 instruction(s), ends with jne to 0x00448c57 (forward)
    cmp dword ptr [ebp + arg_34], 0x0            # 00448be9
    jne.d8 L_00448c57                            # 00448bed
    # block 0x00448bef: entered by fall-through of jne at 0x00448bed, 31 instruction(s), calls FUN_004d270b, falls into the block at 0x00448c57
    mov edx, dword ptr [ebp - local_1398]        # 00448bef
    mov ax, word ptr [edx + field_32]            # 00448bf5
    push eax                                     # 00448bf9
    mov ecx, dword ptr [ebp - local_1398]        # 00448bfa
    mov edx, dword ptr [ecx + field_2e]          # 00448c00
    push edx                                     # 00448c03
    mov ax, word ptr [ebp + arg_28]              # 00448c04
    push eax                                     # 00448c08
    mov ecx, dword ptr [ebp + arg_2c]            # 00448c09
    push ecx                                     # 00448c0c
    movsx edx, word ptr [ebp + arg_c]            # 00448c0d
    mov eax, dword ptr [4*edx + 0x5d032f]        # 00448c11
    push eax                                     # 00448c18
    mov ecx, dword ptr [ebp + arg_14]            # 00448c19
    mov dx, word ptr [ecx]                       # 00448c1c
    push edx                                     # 00448c1f
    mov eax, dword ptr [ebp + arg_20]            # 00448c20
    mov cx, word ptr [eax]                       # 00448c23
    push ecx                                     # 00448c26
    movsx edx, word ptr [ebp + arg_c]            # 00448c27
    imul edx, edx, 0x1d0                         # 00448c2b
    add edx, 0x5adb3a                            # 00448c31
    push edx                                     # 00448c37
    movsx eax, word ptr [ebp + arg_c]            # 00448c38
    imul eax, eax, 0x7f3                         # 00448c3c
    add eax, 0x5a4c24                            # 00448c42
    push eax                                     # 00448c47
    lea ecx, [ebp - local_138c]                  # 00448c48
    push ecx                                     # 00448c4e
    call FUN_004d270b                            # 00448c4f
    add esp, 0x28                                # 00448c54
L_00448c57:
    # block 0x00448c57: entered by jne at 0x00448bed, 17 instruction(s), calls FUN_004d3836, falls into the block at 0x00448c96
    movsx edx, word ptr [ebp + arg_c]            # 00448c57
    imul edx, edx, 0x1d0                         # 00448c5b
    add edx, 0x5adb3a                            # 00448c61
    push edx                                     # 00448c67
    movsx eax, word ptr [ebp + arg_c]            # 00448c68
    imul eax, eax, 0x7f3                         # 00448c6c
    add eax, 0x5a4c24                            # 00448c72
    push eax                                     # 00448c77
    lea ecx, [ebp - local_138c]                  # 00448c78
    push ecx                                     # 00448c7e
    call FUN_004d3836                            # 00448c7f
    add esp, 0xc                                 # 00448c84
    mov edx, dword ptr [ebp + arg_20]            # 00448c87
    mov cx, word ptr [edx]                       # 00448c8a
    {load} add cx, ax                            # 00448c8d
    mov edx, dword ptr [ebp + arg_20]            # 00448c90
    mov word ptr [edx], cx                       # 00448c93
L_00448c96:
    # block 0x00448c96: entered by jbe at 0x00448bd3; jne at 0x00448be3, 2 instruction(s), ends with je to 0x00448ccc (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00448c96
    je.d8 L_00448ccc                             # 00448c9a
    # block 0x00448c9c: entered by fall-through of je at 0x00448c9a, 12 instruction(s), falls into the block at 0x00448ccc
    mov dword ptr [ebp - local_4], 0x0           # 00448c9c
    mov eax, dword ptr [ebp + arg_20]            # 00448ca3
    mov ecx, dword ptr [ebp - local_1398]        # 00448ca6
    mov dx, word ptr [ecx + field_2c]            # 00448cac
    mov word ptr [eax], dx                       # 00448cb0
    mov eax, dword ptr [ebp + arg_10]            # 00448cb3
    mov dword ptr [eax], 0x1                     # 00448cb6
    mov ecx, dword ptr [ebp + arg_24]            # 00448cbc
    mov dx, word ptr [ecx]                       # 00448cbf
    add dx, 0x1                                  # 00448cc2
    mov eax, dword ptr [ebp + arg_24]            # 00448cc6
    mov word ptr [eax], dx                       # 00448cc9
L_00448ccc:
    # block 0x00448ccc: entered by je at 0x00448c9a, 10 instruction(s), ends with jne to 0x00448cf8 (forward)
    mov ecx, 0x4e2                               # 00448ccc
    {load} xor eax, eax                          # 00448cd1
    lea edi, [ebp - local_138c]                  # 00448cd3
    rep stosd dword ptr es:[edi], eax            # 00448cd9
    mov word ptr [ebp - local_1390], 0x0         # 00448cdb
    movsx ecx, word ptr [ebp - local_1394]       # 00448ce4
    mov edx, dword ptr [ebp + arg_8]             # 00448ceb
    movsx eax, byte ptr [edx + ecx]              # 00448cee
    test eax, eax                                # 00448cf2
    jne.d8 L_00448cf8                            # 00448cf4
    # block 0x00448cf6: entered by fall-through of jne at 0x00448cf4, 1 instruction(s), ends with forward jump to 0x00448cfd
    jmp.d8 L_00448cfd                            # 00448cf6
L_00448cf8:
    # block 0x00448cf8: entered by jne at 0x00448cf4, 1 instruction(s), ends with backward jump to 0x004488b9
    jmp.d32 L_004488b9                           # 00448cf8
L_00448cfd:
    # block 0x00448cfd: entered by je at 0x004488c0; jmp at 0x00448a37; jmp at 0x00448cf6, 9 instruction(s), ends with ret 0x30
    mov ecx, 0x4e2                               # 00448cfd
    {load} xor eax, eax                          # 00448d02
    mov edi, dword ptr [ebp + arg_8]             # 00448d04
    rep stosd dword ptr es:[edi], eax            # 00448d07
    pop edi                                      # 00448d09
    pop esi                                      # 00448d0a
    {load} mov esp, ebp                          # 00448d0b
    pop ebp                                      # 00448d0d
    ret 0x30                                     # 00448d0e

