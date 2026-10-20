# FUN_00414ceb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414ceb
# extent:       0x00414ceb-0x00415011 (806 code bytes)
# span:         0x00414ceb-0x00415011 (code 806, tables 0, padding 0)
# sha256:       4f9fd401655d0465b10cc6920ad34f26c436d48e97a6bd43113825bb70ba942f
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m414ceb_open_map
# naming:       native port src/original_methods_fl27c.c:m414ceb_open_map (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m414ceb_open_map: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27c-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_10, field_15, field_21, field_29, field_2d, field_31, field_3d, field_41, field_45; [ecx + n] field_17, field_25, field_29, field_2d, field_35, field_41; [edx + n] field_12, field_15, field_19, field_1b, field_21, field_25, field_29, field_2d, field_39, field_49
# callees:      calls FUN_0042639d, FUN_004c97b4, KERNEL32.dll!CreateFileA, KERNEL32.dll!CreateFileMappingA, KERNEL32.dll!MapViewOfFile, FUN_00415011, FUN_0051dc43
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:avf_open (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 224 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_15, 0x15  # offset +0x15
.equ field_17, 0x17  # offset +0x17
.equ field_19, 0x19  # offset +0x19
.equ field_1b, 0x1b  # offset +0x1b
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00414ceb - 0x401000
.globl FUN_00414ceb
FUN_00414ceb:
    # block 0x00414ceb: entry, 9 instruction(s), ends with je to 0x00414d2c (forward)
    push ebp                                     # 00414ceb
    {load} mov ebp, esp                          # 00414cec
    sub esp, 0x8                                 # 00414cee
    push esi                                     # 00414cf1
    push edi                                     # 00414cf2
    mov dword ptr [ebp - local_8], ecx           # 00414cf3
    mov eax, dword ptr [ebp + arg_8]             # 00414cf6
    cmp dword ptr [eax + field_21], 0x0          # 00414cf9
    je.d8 L_00414d2c                             # 00414cfd
    # block 0x00414cff: entered by fall-through of je at 0x00414cfd, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x00414d2c
    mov ecx, dword ptr [ebp + arg_8]             # 00414cff
    add ecx, 0x151                               # 00414d02
    push ecx                                     # 00414d08
    push 0x5418d0                                # 00414d09
    mov ecx, 0x583979                            # 00414d0e
    call FUN_0042639d                            # 00414d13
    mov dword ptr [0x63a58a], 0x4                # 00414d18
    mov ecx, 0x5cf659                            # 00414d22
    call FUN_004c97b4                            # 00414d27
L_00414d2c:
    # block 0x00414d2c: entered by je at 0x00414cfd, 31 instruction(s), ends with jne to 0x00414ddd (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00414d2c
    mov dword ptr [edx + field_21], 0x0          # 00414d2f
    mov eax, dword ptr [ebp + arg_8]             # 00414d36
    mov dword ptr [eax + field_31], 0x0          # 00414d39
    mov ecx, dword ptr [ebp + arg_8]             # 00414d40
    mov dword ptr [ecx + field_35], 0x0          # 00414d43
    mov edx, dword ptr [ebp + arg_8]             # 00414d4a
    mov dword ptr [edx + field_39], 0x0          # 00414d4d
    mov eax, dword ptr [ebp + arg_8]             # 00414d54
    mov dword ptr [eax + field_3d], 0x0          # 00414d57
    mov ecx, dword ptr [ebp + arg_8]             # 00414d5e
    mov dword ptr [ecx + field_41], 0x0          # 00414d61
    mov edx, dword ptr [ebp + arg_8]             # 00414d68
    mov dword ptr [edx + field_25], 0x0          # 00414d6b
    mov eax, dword ptr [ebp + arg_8]             # 00414d72
    mov dword ptr [eax + field_29], 0x0          # 00414d75
    mov ecx, dword ptr [ebp + arg_8]             # 00414d7c
    mov dword ptr [ecx + field_2d], 0x0          # 00414d7f
    mov edx, dword ptr [ebp + arg_8]             # 00414d86
    mov dword ptr [edx + field_49], 0x0          # 00414d89
    mov eax, dword ptr [ebp + arg_8]             # 00414d90
    mov dword ptr [eax + field_45], 0xffffffff   # 00414d93
    mov edi, dword ptr [ebp + arg_8]             # 00414d9a
    add edi, 0x4d                                # 00414d9d
    or ecx, -0x1                                 # 00414da0
    {load} xor eax, eax                          # 00414da3
    repne scasb al, byte ptr es:[edi]            # 00414da5
    not ecx                                      # 00414da7
    add ecx, -0x1                                # 00414da9
    test ecx, ecx                                # 00414dac
    jne.d8 L_00414ddd                            # 00414dae
    # block 0x00414db0: entered by fall-through of jne at 0x00414dae, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x00414ddd
    mov ecx, dword ptr [ebp + arg_8]             # 00414db0
    add ecx, 0x151                               # 00414db3
    push ecx                                     # 00414db9
    push 0x541900                                # 00414dba
    mov ecx, 0x583979                            # 00414dbf
    call FUN_0042639d                            # 00414dc4
    mov dword ptr [0x63a58a], 0x4                # 00414dc9
    mov ecx, 0x5cf659                            # 00414dd3
    call FUN_004c97b4                            # 00414dd8
L_00414ddd:
    # block 0x00414ddd: entered by jne at 0x00414dae, 15 instruction(s), calls KERNEL32.dll!CreateFileA, ends with jne to 0x00414e3a (forward)
    push 0x0                                     # 00414ddd
    push 0x8000000                               # 00414ddf
    push 0x3                                     # 00414de4
    push 0x0                                     # 00414de6
    push 0x0                                     # 00414de8
    push 0x80000000                              # 00414dea
    mov edx, dword ptr [ebp + arg_8]             # 00414def
    add edx, 0x4d                                # 00414df2
    push edx                                     # 00414df5
    call dword ptr [0x52a2bc]                    # 00414df6
    mov ecx, dword ptr [ebp + arg_8]             # 00414dfc
    mov dword ptr [ecx + field_25], eax          # 00414dff
    mov edx, dword ptr [ebp + arg_8]             # 00414e02
    cmp dword ptr [edx + field_25], -0x1         # 00414e05
    jne.d8 L_00414e3a                            # 00414e09
    # block 0x00414e0b: entered by fall-through of jne at 0x00414e09, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00415009
    mov eax, dword ptr [ebp + arg_8]             # 00414e0b
    add eax, 0x4d                                # 00414e0e
    push eax                                     # 00414e11
    push 0x541924                                # 00414e12
    mov ecx, 0x583979                            # 00414e17
    call FUN_0042639d                            # 00414e1c
    mov dword ptr [0x63a58a], 0x4                # 00414e21
    mov ecx, 0x5cf659                            # 00414e2b
    call FUN_004c97b4                            # 00414e30
    jmp.d32 L_00415009                           # 00414e35
L_00414e3a:
    # block 0x00414e3a: entered by jne at 0x00414e09, 14 instruction(s), calls KERNEL32.dll!CreateFileMappingA, ends with jne to 0x00414e8f (forward)
    push 0x0                                     # 00414e3a
    push 0x0                                     # 00414e3c
    push 0x0                                     # 00414e3e
    push 0x2                                     # 00414e40
    push 0x0                                     # 00414e42
    mov ecx, dword ptr [ebp + arg_8]             # 00414e44
    mov edx, dword ptr [ecx + field_25]          # 00414e47
    push edx                                     # 00414e4a
    call dword ptr [0x52a2c0]                    # 00414e4b
    mov ecx, dword ptr [ebp + arg_8]             # 00414e51
    mov dword ptr [ecx + field_29], eax          # 00414e54
    mov edx, dword ptr [ebp + arg_8]             # 00414e57
    cmp dword ptr [edx + field_29], 0x0          # 00414e5a
    jne.d8 L_00414e8f                            # 00414e5e
    # block 0x00414e60: entered by fall-through of jne at 0x00414e5e, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00415009
    mov eax, dword ptr [ebp + arg_8]             # 00414e60
    add eax, 0x4d                                # 00414e63
    push eax                                     # 00414e66
    push 0x54193c                                # 00414e67
    mov ecx, 0x583979                            # 00414e6c
    call FUN_0042639d                            # 00414e71
    mov dword ptr [0x63a58a], 0x4                # 00414e76
    mov ecx, 0x5cf659                            # 00414e80
    call FUN_004c97b4                            # 00414e85
    jmp.d32 L_00415009                           # 00414e8a
L_00414e8f:
    # block 0x00414e8f: entered by jne at 0x00414e5e, 13 instruction(s), calls KERNEL32.dll!MapViewOfFile, ends with jne to 0x00414ee2 (forward)
    push 0x0                                     # 00414e8f
    push 0x0                                     # 00414e91
    push 0x0                                     # 00414e93
    push 0x4                                     # 00414e95
    mov ecx, dword ptr [ebp + arg_8]             # 00414e97
    mov edx, dword ptr [ecx + field_29]          # 00414e9a
    push edx                                     # 00414e9d
    call dword ptr [0x52a2c4]                    # 00414e9e
    mov ecx, dword ptr [ebp + arg_8]             # 00414ea4
    mov dword ptr [ecx + field_2d], eax          # 00414ea7
    mov edx, dword ptr [ebp + arg_8]             # 00414eaa
    cmp dword ptr [edx + field_2d], 0x0          # 00414ead
    jne.d8 L_00414ee2                            # 00414eb1
    # block 0x00414eb3: entered by fall-through of jne at 0x00414eb1, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00415009
    mov eax, dword ptr [ebp + arg_8]             # 00414eb3
    add eax, 0x4d                                # 00414eb6
    push eax                                     # 00414eb9
    push 0x54195c                                # 00414eba
    mov ecx, 0x583979                            # 00414ebf
    call FUN_0042639d                            # 00414ec4
    mov dword ptr [0x63a58a], 0x4                # 00414ec9
    mov ecx, 0x5cf659                            # 00414ed3
    call FUN_004c97b4                            # 00414ed8
    jmp.d32 L_00415009                           # 00414edd
L_00414ee2:
    # block 0x00414ee2: entered by jne at 0x00414eb1, 12 instruction(s), ends with jne to 0x00414f21 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00414ee2
    mov esi, dword ptr [ecx + field_2d]          # 00414ee5
    mov ecx, 0x8                                 # 00414ee8
    mov edi, dword ptr [ebp + arg_8]             # 00414eed
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00414ef0
    movsb byte ptr es:[edi], byte ptr [esi]      # 00414ef2
    mov edi, 0x541978                            # 00414ef3
    mov esi, dword ptr [ebp + arg_8]             # 00414ef8
    mov ecx, 0xf                                 # 00414efb
    {load} xor edx, edx                          # 00414f00
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00414f02
    jne.d8 L_00414f21                            # 00414f04
    # block 0x00414f06: entered by fall-through of jne at 0x00414f04, 5 instruction(s), ends with jne to 0x00414f21 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00414f06
    {load} xor ecx, ecx                          # 00414f09
    mov cx, word ptr [eax + field_10]            # 00414f0b
    cmp ecx, 0x2                                 # 00414f0f
    jne.d8 L_00414f21                            # 00414f12
    # block 0x00414f14: entered by fall-through of jne at 0x00414f12, 5 instruction(s), ends with je to 0x00414f5c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00414f14
    {load} xor eax, eax                          # 00414f17
    mov ax, word ptr [edx + field_12]            # 00414f19
    test eax, eax                                # 00414f1d
    je.d8 L_00414f5c                             # 00414f1f
L_00414f21:
    # block 0x00414f21: entered by jne at 0x00414f04; jne at 0x00414f12; fall-through of je at 0x00414f1f, 14 instruction(s), calls FUN_00415011, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00415009
    mov ecx, dword ptr [ebp + arg_8]             # 00414f21
    push ecx                                     # 00414f24
    mov ecx, dword ptr [ebp - local_8]           # 00414f25
    call FUN_00415011                            # 00414f28
    mov edx, dword ptr [ebp + arg_8]             # 00414f2d
    add edx, 0x4d                                # 00414f30
    push edx                                     # 00414f33
    push 0x541988                                # 00414f34
    mov ecx, 0x583979                            # 00414f39
    call FUN_0042639d                            # 00414f3e
    mov dword ptr [0x63a58a], 0x4                # 00414f43
    mov ecx, 0x5cf659                            # 00414f4d
    call FUN_004c97b4                            # 00414f52
    jmp.d32 L_00415009                           # 00414f57
L_00414f5c:
    # block 0x00414f5c: entered by je at 0x00414f1f, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x00414fb7 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00414f5c
    movsx ecx, word ptr [eax + field_15]         # 00414f5f
    imul ecx, ecx, 0x13                          # 00414f63
    push ecx                                     # 00414f66
    call FUN_0051dc43                            # 00414f67
    add esp, 0x4                                 # 00414f6c
    mov dword ptr [ebp - local_4], eax           # 00414f6f
    mov edx, dword ptr [ebp + arg_8]             # 00414f72
    mov eax, dword ptr [ebp - local_4]           # 00414f75
    mov dword ptr [edx + field_21], eax          # 00414f78
    cmp dword ptr [ebp - local_4], 0x0           # 00414f7b
    jne.d8 L_00414fb7                            # 00414f7f
    # block 0x00414f81: entered by fall-through of jne at 0x00414f7f, 12 instruction(s), calls FUN_00415011, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00415009
    mov ecx, dword ptr [ebp + arg_8]             # 00414f81
    push ecx                                     # 00414f84
    mov ecx, dword ptr [ebp - local_8]           # 00414f85
    call FUN_00415011                            # 00414f88
    push 0x5419dc                                # 00414f8d
    push 0x5419ec                                # 00414f92
    mov ecx, 0x583979                            # 00414f97
    call FUN_0042639d                            # 00414f9c
    mov dword ptr [0x63a58a], 0x4                # 00414fa1
    mov ecx, 0x5cf659                            # 00414fab
    call FUN_004c97b4                            # 00414fb0
    jmp.d8 L_00415009                            # 00414fb5
L_00414fb7:
    # block 0x00414fb7: entered by jne at 0x00414f7f, 29 instruction(s), falls into the block at 0x00415009
    mov edx, dword ptr [ebp + arg_8]             # 00414fb7
    movsx ecx, word ptr [edx + field_15]         # 00414fba
    imul ecx, ecx, 0x13                          # 00414fbe
    mov eax, dword ptr [ebp + arg_8]             # 00414fc1
    mov esi, dword ptr [eax + field_2d]          # 00414fc4
    add esi, 0x21                                # 00414fc7
    mov edx, dword ptr [ebp + arg_8]             # 00414fca
    mov edi, dword ptr [edx + field_21]          # 00414fcd
    {load} mov eax, ecx                          # 00414fd0
    shr ecx, 0x2                                 # 00414fd2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00414fd5
    {load} mov ecx, eax                          # 00414fd7
    and ecx, 0x3                                 # 00414fd9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00414fdc
    mov ecx, dword ptr [ebp + arg_8]             # 00414fde
    movsx ecx, word ptr [ecx + field_17]         # 00414fe1
    mov edx, dword ptr [ebp + arg_8]             # 00414fe5
    movsx eax, word ptr [edx + field_19]         # 00414fe8
    imul ecx, eax                                # 00414fec
    mov edx, dword ptr [ebp + arg_8]             # 00414fef
    {load} xor eax, eax                          # 00414ff2
    mov al, byte ptr [edx + field_1b]            # 00414ff4
    cdq                                          # 00414ff7
    and edx, 0x7                                 # 00414ff8
    {load} add eax, edx                          # 00414ffb
    sar eax, 0x3                                 # 00414ffd
    imul ecx, eax                                # 00415000
    mov eax, dword ptr [ebp + arg_8]             # 00415003
    mov dword ptr [eax + field_41], ecx          # 00415006
L_00415009:
    # block 0x00415009: entered by jmp at 0x00414e35; jmp at 0x00414e8a; jmp at 0x00414edd; jmp at 0x00414f57; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00415009
    pop esi                                      # 0041500a
    {load} mov esp, ebp                          # 0041500b
    pop ebp                                      # 0041500d
    ret 0x4                                      # 0041500e

