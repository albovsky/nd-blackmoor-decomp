# FUN_00491db2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00491db2
# extent:       0x00491db2-0x004921a1 (1007 code bytes)
# span:         0x00491db2-0x004921a1 (code 1007, tables 0, padding 0)
# sha256:       cd87f727ef9863dfe7408b3d3728493d289eb997e589a959cc8e249d96e5a400
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raycast_map_validator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/491db2.c.txt, not original source) refers to the data labelled s_CRayCast__ValidateMap_____ERROR___0054ef4c, s_CRayCast__ValidateMap_____ERROR___0054f138
# name-note:    CRayCast::ValidateMap: scans the 0xa6 by 0xa6 map checking value ranges and flags, collects entries, and reports ERROR messages and aborts on invalid data.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_1f47, field_1f53, field_20c1, field_45c1, field_4765; [ecx + n] field_20c1, field_20c5, field_45ad, field_45c1, field_45c9, field_45cd, field_45d1, field_45d5, field_4765; [edx + n] field_1f67, field_20c1, field_20c9, field_45c5, field_45d9, field_4765, field_47ad
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 262 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f53, 0x1f53  # offset +0x1f53
.equ field_1f67, 0x1f67  # offset +0x1f67
.equ field_20c1, 0x20c1  # offset +0x20c1
.equ field_20c5, 0x20c5  # offset +0x20c5
.equ field_20c9, 0x20c9  # offset +0x20c9
.equ field_45ad, 0x45ad  # offset +0x45ad
.equ field_45c1, 0x45c1  # offset +0x45c1
.equ field_45c5, 0x45c5  # offset +0x45c5
.equ field_45c9, 0x45c9  # offset +0x45c9
.equ field_45cd, 0x45cd  # offset +0x45cd
.equ field_45d1, 0x45d1  # offset +0x45d1
.equ field_45d5, 0x45d5  # offset +0x45d5
.equ field_45d9, 0x45d9  # offset +0x45d9
.equ field_4765, 0x4765  # offset +0x4765
.equ field_47ad, 0x47ad  # offset +0x47ad

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00491db2 - 0x401000
.globl FUN_00491db2
FUN_00491db2:
    # block 0x00491db2: entry, 10 instruction(s), ends with forward jump to 0x00491de7
    push ebp                                     # 00491db2
    {load} mov ebp, esp                          # 00491db3
    sub esp, 0x24                                # 00491db5
    mov dword ptr [ebp - local_20], ecx          # 00491db8
    mov eax, dword ptr [ebp - local_20]          # 00491dbb
    mov dword ptr [eax + field_20c1], 0x0        # 00491dbe
    mov ecx, dword ptr [ebp - local_20]          # 00491dc8
    mov dword ptr [ecx + field_4765], 0x0        # 00491dcb
    mov dword ptr [ebp - local_c], 0x0           # 00491dd5
    jmp.d8 L_00491de7                            # 00491ddc
L_00491dde:
    # block 0x00491dde: entered by jmp at 0x00491e01, 3 instruction(s), falls into the block at 0x00491de7
    mov edx, dword ptr [ebp - local_c]           # 00491dde
    add edx, 0x1                                 # 00491de1
    mov dword ptr [ebp - local_c], edx           # 00491de4
L_00491de7:
    # block 0x00491de7: entered by jmp at 0x00491ddc, 2 instruction(s), ends with jge to 0x00491e03 (forward)
    cmp dword ptr [ebp - local_c], 0xf           # 00491de7
    jge.d8 L_00491e03                            # 00491deb
    # block 0x00491ded: entered by fall-through of jge at 0x00491deb, 5 instruction(s), ends with backward jump to 0x00491dde
    mov eax, dword ptr [ebp - local_c]           # 00491ded
    imul eax, eax, 0x1c                          # 00491df0
    mov ecx, dword ptr [ebp - local_20]          # 00491df3
    mov dword ptr [ecx + eax + field_45c1], 0x0  # 00491df6
    jmp.d8 L_00491dde                            # 00491e01
L_00491e03:
    # block 0x00491e03: entered by jge at 0x00491deb, 2 instruction(s), ends with forward jump to 0x00491e15
    mov dword ptr [ebp - local_14], 0x0          # 00491e03
    jmp.d8 L_00491e15                            # 00491e0a
L_00491e0c:
    # block 0x00491e0c: entered by jmp at 0x00492138, 3 instruction(s), falls into the block at 0x00491e15
    mov edx, dword ptr [ebp - local_14]          # 00491e0c
    add edx, 0x1                                 # 00491e0f
    mov dword ptr [ebp - local_14], edx          # 00491e12
L_00491e15:
    # block 0x00491e15: entered by jmp at 0x00491e0a, 2 instruction(s), ends with jge to 0x0049213d (forward)
    cmp dword ptr [ebp - local_14], 0xa6         # 00491e15
    jge.d32 L_0049213d                           # 00491e1c
    # block 0x00491e22: entered by fall-through of jge at 0x00491e1c, 2 instruction(s), ends with forward jump to 0x00491e34
    mov dword ptr [ebp - local_18], 0x0          # 00491e22
    jmp.d8 L_00491e34                            # 00491e29
L_00491e2b:
    # block 0x00491e2b: entered by jmp at 0x00492133, 3 instruction(s), falls into the block at 0x00491e34
    mov eax, dword ptr [ebp - local_18]          # 00491e2b
    add eax, 0x1                                 # 00491e2e
    mov dword ptr [ebp - local_18], eax          # 00491e31
L_00491e34:
    # block 0x00491e34: entered by jmp at 0x00491e29, 2 instruction(s), ends with jge to 0x00492138 (forward)
    cmp dword ptr [ebp - local_18], 0xa6         # 00491e34
    jge.d32 L_00492138                           # 00491e3b
    # block 0x00491e41: entered by fall-through of jge at 0x00491e3b, 13 instruction(s), ends with jge to 0x00491e9d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00491e41
    imul ecx, ecx, 0xa6                          # 00491e44
    mov edx, dword ptr [ebp - local_20]          # 00491e4a
    mov eax, dword ptr [edx + field_1f67]        # 00491e4d
    lea ecx, [eax + 2*ecx]                       # 00491e53
    mov edx, dword ptr [ebp - local_18]          # 00491e56
    mov ax, word ptr [ecx + 2*edx]               # 00491e59
    mov word ptr [ebp - local_4], ax             # 00491e5d
    mov ecx, dword ptr [ebp - local_4]           # 00491e61
    and ecx, 0xffff                              # 00491e64
    mov edx, dword ptr [ebp - local_20]          # 00491e6a
    cmp ecx, dword ptr [edx + field_47ad]        # 00491e6d
    jge.d8 L_00491e9d                            # 00491e73
    # block 0x00491e75: entered by fall-through of jge at 0x00491e73, 12 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0049219b
    mov eax, dword ptr [ebp - local_4]           # 00491e75
    and eax, 0xffff                              # 00491e78
    push eax                                     # 00491e7d
    mov ecx, dword ptr [ebp - local_18]          # 00491e7e
    push ecx                                     # 00491e81
    mov edx, dword ptr [ebp - local_14]          # 00491e82
    push edx                                     # 00491e85
    push 0x54ef4c                                # 00491e86
    push 0x63888b                                # 00491e8b
    call FUN_0050ca3e                            # 00491e90
    add esp, 0x14                                # 00491e95
    jmp.d32 L_0049219b                           # 00491e98
L_00491e9d:
    # block 0x00491e9d: entered by jge at 0x00491e73, 5 instruction(s), ends with jle to 0x00491ed9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00491e9d
    and eax, 0xffff                              # 00491ea0
    mov ecx, dword ptr [ebp - local_20]          # 00491ea5
    cmp eax, dword ptr [ecx + field_45ad]        # 00491ea8
    jle.d8 L_00491ed9                            # 00491eae
    # block 0x00491eb0: entered by fall-through of jle at 0x00491eae, 12 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00492199
    mov edx, dword ptr [ebp - local_4]           # 00491eb0
    and edx, 0xffff                              # 00491eb3
    push edx                                     # 00491eb9
    mov eax, dword ptr [ebp - local_18]          # 00491eba
    push eax                                     # 00491ebd
    mov ecx, dword ptr [ebp - local_14]          # 00491ebe
    push ecx                                     # 00491ec1
    push 0x54efa4                                # 00491ec2
    push 0x63888b                                # 00491ec7
    call FUN_0050ca3e                            # 00491ecc
    add esp, 0x14                                # 00491ed1
    jmp.d32 L_00492199                           # 00491ed4
L_00491ed9:
    # block 0x00491ed9: entered by jle at 0x00491eae, 12 instruction(s), ends with je to 0x00491f40 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00491ed9
    imul edx, edx, 0xa6                          # 00491edc
    mov eax, dword ptr [ebp - local_20]          # 00491ee2
    mov ecx, dword ptr [eax + field_1f47]        # 00491ee5
    lea edx, [ecx + 4*edx]                       # 00491eeb
    mov eax, dword ptr [ebp - local_18]          # 00491eee
    mov ecx, dword ptr [edx + 4*eax]             # 00491ef1
    mov dword ptr [ebp - local_1c], ecx          # 00491ef4
    mov edx, dword ptr [ebp - local_1c]          # 00491ef7
    and edx, 0x8000000                           # 00491efa
    test edx, edx                                # 00491f00
    je.d8 L_00491f40                             # 00491f02
    # block 0x00491f04: entered by fall-through of je at 0x00491f02, 4 instruction(s), ends with jne to 0x00491f40 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00491f04
    and eax, 0x2000000                           # 00491f07
    test eax, eax                                # 00491f0c
    jne.d8 L_00491f40                            # 00491f0e
    # block 0x00491f10: entered by fall-through of jne at 0x00491f0e, 4 instruction(s), ends with jne to 0x00491f40 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00491f10
    and ecx, 0x4000000                           # 00491f13
    test ecx, ecx                                # 00491f19
    jne.d8 L_00491f40                            # 00491f1b
    # block 0x00491f1d: entered by fall-through of jne at 0x00491f1b, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00492197
    mov edx, dword ptr [ebp - local_1c]          # 00491f1d
    push edx                                     # 00491f20
    mov eax, dword ptr [ebp - local_18]          # 00491f21
    push eax                                     # 00491f24
    mov ecx, dword ptr [ebp - local_14]          # 00491f25
    push ecx                                     # 00491f28
    push 0x54f018                                # 00491f29
    push 0x63888b                                # 00491f2e
    call FUN_0050ca3e                            # 00491f33
    add esp, 0x14                                # 00491f38
    jmp.d32 L_00492197                           # 00491f3b
L_00491f40:
    # block 0x00491f40: entered by je at 0x00491f02; jne at 0x00491f0e; jne at 0x00491f1b, 15 instruction(s), ends with je to 0x00491f81 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00491f40
    imul edx, edx, 0xa6                          # 00491f43
    mov eax, dword ptr [ebp - local_20]          # 00491f49
    mov ecx, dword ptr [eax + field_1f53]        # 00491f4c
    lea edx, [ecx + 4*edx]                       # 00491f52
    mov eax, dword ptr [ebp - local_18]          # 00491f55
    mov ecx, dword ptr [edx + 4*eax]             # 00491f58
    mov dword ptr [ebp - local_10], ecx          # 00491f5b
    mov edx, dword ptr [ebp - local_10]          # 00491f5e
    and edx, 0xff                                # 00491f61
    mov byte ptr [ebp - local_8], dl             # 00491f67
    mov al, byte ptr [ebp - local_8]             # 00491f6a
    mov byte ptr [ebp - local_24], al            # 00491f6d
    cmp byte ptr [ebp - local_24], 0x1           # 00491f70
    je.d8 L_00491f81                             # 00491f74
    # block 0x00491f76: entered by fall-through of je at 0x00491f74, 2 instruction(s), ends with je to 0x00491ff6 (forward)
    cmp byte ptr [ebp - local_24], 0x2           # 00491f76
    je.d8 L_00491ff6                             # 00491f7a
    # block 0x00491f7c: entered by fall-through of je at 0x00491f7a, 1 instruction(s), ends with forward jump to 0x00492133
    jmp.d32 L_00492133                           # 00491f7c
L_00491f81:
    # block 0x00491f81: entered by je at 0x00491f74, 3 instruction(s), ends with jl to 0x00491fb0 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00491f81
    cmp dword ptr [ecx + field_20c1], 0x4        # 00491f84
    jl.d8 L_00491fb0                             # 00491f8b
    # block 0x00491f8d: entered by fall-through of jl at 0x00491f8b, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00492195
    mov edx, dword ptr [ebp - local_10]          # 00491f8d
    push edx                                     # 00491f90
    mov eax, dword ptr [ebp - local_18]          # 00491f91
    push eax                                     # 00491f94
    mov ecx, dword ptr [ebp - local_14]          # 00491f95
    push ecx                                     # 00491f98
    push 0x54f078                                # 00491f99
    push 0x63888b                                # 00491f9e
    call FUN_0050ca3e                            # 00491fa3
    add esp, 0x14                                # 00491fa8
    jmp.d32 L_00492195                           # 00491fab
L_00491fb0:
    # block 0x00491fb0: entered by jl at 0x00491f8b, 16 instruction(s), ends with forward jump to 0x00492133
    mov edx, dword ptr [ebp - local_20]          # 00491fb0
    mov eax, dword ptr [edx + field_20c1]        # 00491fb3
    mov ecx, dword ptr [ebp - local_20]          # 00491fb9
    mov edx, dword ptr [ebp - local_14]          # 00491fbc
    mov dword ptr [ecx + 8*eax + field_20c5], edx # 00491fbf
    mov eax, dword ptr [ebp - local_20]          # 00491fc6
    mov ecx, dword ptr [eax + field_20c1]        # 00491fc9
    mov edx, dword ptr [ebp - local_20]          # 00491fcf
    mov eax, dword ptr [ebp - local_18]          # 00491fd2
    mov dword ptr [edx + 8*ecx + field_20c9], eax # 00491fd5
    mov ecx, dword ptr [ebp - local_20]          # 00491fdc
    mov edx, dword ptr [ecx + field_20c1]        # 00491fdf
    add edx, 0x1                                 # 00491fe5
    mov eax, dword ptr [ebp - local_20]          # 00491fe8
    mov dword ptr [eax + field_20c1], edx        # 00491feb
    jmp.d32 L_00492133                           # 00491ff1
L_00491ff6:
    # block 0x00491ff6: entered by je at 0x00491f7a, 19 instruction(s), ends with jl to 0x00492064 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00491ff6
    mov edx, dword ptr [ecx + field_4765]        # 00491ff9
    imul edx, edx, 0x1c                          # 00491fff
    mov eax, dword ptr [ebp - local_20]          # 00492002
    mov dword ptr [eax + edx + field_45c1], 0x1  # 00492005
    mov ecx, dword ptr [ebp - local_10]          # 00492010
    shr ecx, 0x8                                 # 00492013
    and ecx, 0xff                                # 00492016
    mov edx, dword ptr [ebp - local_20]          # 0049201c
    mov eax, dword ptr [edx + field_4765]        # 0049201f
    imul eax, eax, 0x1c                          # 00492025
    mov edx, dword ptr [ebp - local_20]          # 00492028
    mov dword ptr [edx + eax + field_45c5], ecx  # 0049202b
    mov eax, dword ptr [ebp - local_20]          # 00492032
    mov ecx, dword ptr [eax + field_4765]        # 00492035
    imul ecx, ecx, 0x1c                          # 0049203b
    mov edx, dword ptr [ebp - local_20]          # 0049203e
    cmp dword ptr [edx + ecx + field_45c5], 0x1  # 00492041
    jl.d8 L_00492064                             # 00492049
    # block 0x0049204b: entered by fall-through of jl at 0x00492049, 6 instruction(s), ends with jle to 0x0049209a (forward)
    mov eax, dword ptr [ebp - local_20]          # 0049204b
    mov ecx, dword ptr [eax + field_4765]        # 0049204e
    imul ecx, ecx, 0x1c                          # 00492054
    mov edx, dword ptr [ebp - local_20]          # 00492057
    cmp dword ptr [edx + ecx + field_45c5], 0xf  # 0049205a
    jle.d8 L_0049209a                            # 00492062
L_00492064:
    # block 0x00492064: entered by jl at 0x00492049; fall-through of jle at 0x00492062, 15 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00492193
    mov eax, dword ptr [ebp - local_20]          # 00492064
    mov ecx, dword ptr [eax + field_4765]        # 00492067
    imul ecx, ecx, 0x1c                          # 0049206d
    mov edx, dword ptr [ebp - local_20]          # 00492070
    mov eax, dword ptr [edx + ecx + field_45c5]  # 00492073
    push eax                                     # 0049207a
    mov ecx, dword ptr [ebp - local_18]          # 0049207b
    push ecx                                     # 0049207e
    mov edx, dword ptr [ebp - local_14]          # 0049207f
    push edx                                     # 00492082
    push 0x54f0e0                                # 00492083
    push 0x63888b                                # 00492088
    call FUN_0050ca3e                            # 0049208d
    add esp, 0x14                                # 00492092
    jmp.d32 L_00492193                           # 00492095
L_0049209a:
    # block 0x0049209a: entered by jle at 0x00492062, 34 instruction(s), falls into the block at 0x00492133
    mov eax, dword ptr [ebp - local_8]           # 0049209a
    and eax, 0xff                                # 0049209d
    mov ecx, dword ptr [ebp - local_20]          # 004920a2
    mov edx, dword ptr [ecx + field_4765]        # 004920a5
    imul edx, edx, 0x1c                          # 004920ab
    mov ecx, dword ptr [ebp - local_20]          # 004920ae
    mov dword ptr [ecx + edx + field_45c9], eax  # 004920b1
    mov edx, dword ptr [ebp - local_20]          # 004920b8
    mov eax, dword ptr [edx + field_4765]        # 004920bb
    imul eax, eax, 0x1c                          # 004920c1
    mov ecx, dword ptr [ebp - local_20]          # 004920c4
    mov dword ptr [ecx + eax + field_45cd], 0x0  # 004920c7
    mov edx, dword ptr [ebp - local_20]          # 004920d2
    mov eax, dword ptr [edx + field_4765]        # 004920d5
    imul eax, eax, 0x1c                          # 004920db
    mov ecx, dword ptr [ebp - local_20]          # 004920de
    mov dword ptr [ecx + eax + field_45d1], 0x1  # 004920e1
    mov edx, dword ptr [ebp - local_20]          # 004920ec
    mov eax, dword ptr [edx + field_4765]        # 004920ef
    imul eax, eax, 0x1c                          # 004920f5
    mov ecx, dword ptr [ebp - local_20]          # 004920f8
    mov edx, dword ptr [ebp - local_14]          # 004920fb
    mov dword ptr [ecx + eax + field_45d5], edx  # 004920fe
    mov eax, dword ptr [ebp - local_20]          # 00492105
    mov ecx, dword ptr [eax + field_4765]        # 00492108
    imul ecx, ecx, 0x1c                          # 0049210e
    mov edx, dword ptr [ebp - local_20]          # 00492111
    mov eax, dword ptr [ebp - local_18]          # 00492114
    mov dword ptr [edx + ecx + field_45d9], eax  # 00492117
    mov ecx, dword ptr [ebp - local_20]          # 0049211e
    mov edx, dword ptr [ecx + field_4765]        # 00492121
    add edx, 0x1                                 # 00492127
    mov eax, dword ptr [ebp - local_20]          # 0049212a
    mov dword ptr [eax + field_4765], edx        # 0049212d
L_00492133:
    # block 0x00492133: entered by jmp at 0x00491f7c; jmp at 0x00491ff1, 1 instruction(s), ends with backward jump to 0x00491e2b
    jmp.d32 L_00491e2b                           # 00492133
L_00492138:
    # block 0x00492138: entered by jge at 0x00491e3b, 1 instruction(s), ends with backward jump to 0x00491e0c
    jmp.d32 L_00491e0c                           # 00492138
L_0049213d:
    # block 0x0049213d: entered by jge at 0x00491e1c, 3 instruction(s), ends with jne to 0x0049215d (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0049213d
    cmp dword ptr [ecx + field_20c1], 0x0        # 00492140
    jne.d8 L_0049215d                            # 00492147
    # block 0x00492149: entered by fall-through of jne at 0x00492147, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00492191
    push 0x54f138                                # 00492149
    push 0x63888b                                # 0049214e
    call FUN_0050ca3e                            # 00492153
    add esp, 0x8                                 # 00492158
    jmp.d8 L_00492191                            # 0049215b
L_0049215d:
    # block 0x0049215d: entered by jne at 0x00492147, 1 instruction(s), ends with forward jump to 0x0049219d
    jmp.d8 L_0049219d                            # 0049215d
L_0049215f:
    # block 0x0049215f: entered by jmp at 0x00492191; jmp at 0x00492193; jmp at 0x00492195; jmp at 0x00492197; more, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00492185 (forward)
    push 0x0                                     # 0049215f
    push 0x0                                     # 00492161
    push 0x63888b                                # 00492163
    call FUN_0052139c                            # 00492168
    movsx edx, word ptr [0x63a4cd]               # 0049216d
    test edx, edx                                # 00492174
    je.d8 L_00492185                             # 00492176
    # block 0x00492178: entered by fall-through of je at 0x00492176, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00492185
    push 0x63888b                                # 00492178
    call FUN_0044a2b7                            # 0049217d
    add esp, 0x4                                 # 00492182
L_00492185:
    # block 0x00492185: entered by je at 0x00492176, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0049219d
    mov ecx, 0x5cf659                            # 00492185
    call FUN_004c97b4                            # 0049218a
    jmp.d8 L_0049219d                            # 0049218f
L_00492191:
    # block 0x00492191: entered by jmp at 0x0049215b, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 00492191
L_00492193:
    # block 0x00492193: entered by jmp at 0x00492095, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 00492193
L_00492195:
    # block 0x00492195: entered by jmp at 0x00491fab, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 00492195
L_00492197:
    # block 0x00492197: entered by jmp at 0x00491f3b, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 00492197
L_00492199:
    # block 0x00492199: entered by jmp at 0x00491ed4, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 00492199
L_0049219b:
    # block 0x0049219b: entered by jmp at 0x00491e98, 1 instruction(s), ends with backward jump to 0x0049215f
    jmp.d8 L_0049215f                            # 0049219b
L_0049219d:
    # block 0x0049219d: entered by jmp at 0x0049215d; jmp at 0x0049218f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0049219d
    pop ebp                                      # 0049219f
    ret                                          # 004921a0

