# FUN_00494f1f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00494f1f
# extent:       0x00494f1f-0x00495536 (1559 code bytes)
# span:         0x00494f1f-0x00495536 (code 1559, tables 0, padding 0)
# sha256:       58bd0c60422e3fc6951007cd9061a8de66778e051bf91e3681f255ed0abeb14c
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00494f1f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_86, field_1f6f, field_1f7b, field_2023, field_2025, field_2027, field_2029, field_202b, field_202d, field_202f, field_2031, field_2033 and 7 more; [ecx + n] field_2f, field_87, field_1f73, field_2025, field_2027, field_2029, field_202d, field_202f, field_2031, field_2033, field_2035, field_2039 and 6 more; [edi + n] field_2f, field_2035; [edx + n] field_2f, field_85, field_1f47, field_1f53, field_1f7b, field_2023, field_202b, field_2035, field_203d, field_2041, field_2045, field_2075
# callees:      calls FUN_00495536, FUN_004c2a8d, FUN_004c46d1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 422 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_2f, 0x2f  # offset +0x2f
.equ field_85, 0x85  # offset +0x85
.equ field_86, 0x86  # offset +0x86
.equ field_87, 0x87  # offset +0x87
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f53, 0x1f53  # offset +0x1f53
.equ field_1f6f, 0x1f6f  # offset +0x1f6f
.equ field_1f73, 0x1f73  # offset +0x1f73
.equ field_1f7b, 0x1f7b  # offset +0x1f7b
.equ field_2023, 0x2023  # offset +0x2023
.equ field_2025, 0x2025  # offset +0x2025
.equ field_2027, 0x2027  # offset +0x2027
.equ field_2029, 0x2029  # offset +0x2029
.equ field_202b, 0x202b  # offset +0x202b
.equ field_202d, 0x202d  # offset +0x202d
.equ field_202f, 0x202f  # offset +0x202f
.equ field_2031, 0x2031  # offset +0x2031
.equ field_2033, 0x2033  # offset +0x2033
.equ field_2035, 0x2035  # offset +0x2035
.equ field_2039, 0x2039  # offset +0x2039
.equ field_203d, 0x203d  # offset +0x203d
.equ field_2041, 0x2041  # offset +0x2041
.equ field_2045, 0x2045  # offset +0x2045
.equ field_2049, 0x2049  # offset +0x2049
.equ field_2055, 0x2055  # offset +0x2055
.equ field_2059, 0x2059  # offset +0x2059
.equ field_205d, 0x205d  # offset +0x205d
.equ field_2061, 0x2061  # offset +0x2061
.equ field_2075, 0x2075  # offset +0x2075
.equ field_2079, 0x2079  # offset +0x2079
.equ field_207d, 0x207d  # offset +0x207d
.equ field_2081, 0x2081  # offset +0x2081

# --- external targets -----------------------------------------------
.set FUN_00495536, .text + (0x00495536 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c46d1, .text + (0x004c46d1 - 0x401000)

.org 0x00494f1f - 0x401000
.globl FUN_00494f1f
FUN_00494f1f:
    # block 0x00494f1f: entry, 14 instruction(s), ends with je to 0x0049505e (forward)
    push ebp                                     # 00494f1f
    {load} mov ebp, esp                          # 00494f20
    sub esp, 0x24                                # 00494f22
    push esi                                     # 00494f25
    push edi                                     # 00494f26
    mov dword ptr [ebp - local_24], ecx          # 00494f27
    mov eax, dword ptr [ebp - local_24]          # 00494f2a
    mov dword ptr [eax + field_1f6f], 0x0        # 00494f2d
    mov ecx, dword ptr [ebp - local_24]          # 00494f37
    mov dword ptr [ecx + field_1f73], 0x0        # 00494f3a
    mov byte ptr [0x58322e], 0x0                 # 00494f44
    mov edx, dword ptr [ebp - local_24]          # 00494f4b
    cmp dword ptr [edx + field_1f7b], 0x0        # 00494f4e
    je.d32 L_0049505e                            # 00494f55
    # block 0x00494f5b: entered by fall-through of je at 0x00494f55, 74 instruction(s), calls FUN_00495536, falls into the block at 0x0049505e
    mov eax, dword ptr [ebp - local_24]          # 00494f5b
    mov dword ptr [eax + field_1f7b], 0x0        # 00494f5e
    mov ecx, dword ptr [ebp - local_24]          # 00494f68
    add ecx, 0x2023                              # 00494f6b
    push ecx                                     # 00494f71
    mov edx, dword ptr [ebp - local_24]          # 00494f72
    add edx, 0x82                                # 00494f75
    push edx                                     # 00494f7b
    mov ecx, dword ptr [ebp - local_24]          # 00494f7c
    call FUN_00495536                            # 00494f7f
    mov eax, dword ptr [ebp - local_24]          # 00494f84
    add eax, 0x2025                              # 00494f87
    push eax                                     # 00494f8c
    mov ecx, dword ptr [ebp - local_24]          # 00494f8d
    add ecx, 0x88                                # 00494f90
    push ecx                                     # 00494f96
    mov ecx, dword ptr [ebp - local_24]          # 00494f97
    call FUN_00495536                            # 00494f9a
    mov edx, dword ptr [ebp - local_24]          # 00494f9f
    add edx, 0x2027                              # 00494fa2
    push edx                                     # 00494fa8
    mov eax, dword ptr [ebp - local_24]          # 00494fa9
    add eax, 0x8b                                # 00494fac
    push eax                                     # 00494fb1
    mov ecx, dword ptr [ebp - local_24]          # 00494fb2
    call FUN_00495536                            # 00494fb5
    mov ecx, dword ptr [ebp - local_24]          # 00494fba
    add ecx, 0x2029                              # 00494fbd
    push ecx                                     # 00494fc3
    mov edx, dword ptr [ebp - local_24]          # 00494fc4
    add edx, 0x8e                                # 00494fc7
    push edx                                     # 00494fcd
    mov ecx, dword ptr [ebp - local_24]          # 00494fce
    call FUN_00495536                            # 00494fd1
    mov eax, dword ptr [ebp - local_24]          # 00494fd6
    add eax, 0x202b                              # 00494fd9
    push eax                                     # 00494fde
    mov ecx, dword ptr [ebp - local_24]          # 00494fdf
    add ecx, 0x91                                # 00494fe2
    push ecx                                     # 00494fe8
    mov ecx, dword ptr [ebp - local_24]          # 00494fe9
    call FUN_00495536                            # 00494fec
    mov edx, dword ptr [ebp - local_24]          # 00494ff1
    add edx, 0x202d                              # 00494ff4
    push edx                                     # 00494ffa
    mov eax, dword ptr [ebp - local_24]          # 00494ffb
    add eax, 0x94                                # 00494ffe
    push eax                                     # 00495003
    mov ecx, dword ptr [ebp - local_24]          # 00495004
    call FUN_00495536                            # 00495007
    mov ecx, dword ptr [ebp - local_24]          # 0049500c
    add ecx, 0x202f                              # 0049500f
    push ecx                                     # 00495015
    mov edx, dword ptr [ebp - local_24]          # 00495016
    add edx, 0x97                                # 00495019
    push edx                                     # 0049501f
    mov ecx, dword ptr [ebp - local_24]          # 00495020
    call FUN_00495536                            # 00495023
    mov eax, dword ptr [ebp - local_24]          # 00495028
    add eax, 0x2031                              # 0049502b
    push eax                                     # 00495030
    mov ecx, dword ptr [ebp - local_24]          # 00495031
    add ecx, 0x9a                                # 00495034
    push ecx                                     # 0049503a
    mov ecx, dword ptr [ebp - local_24]          # 0049503b
    call FUN_00495536                            # 0049503e
    mov edx, dword ptr [ebp - local_24]          # 00495043
    add edx, 0x2033                              # 00495046
    push edx                                     # 0049504c
    mov eax, dword ptr [ebp - local_24]          # 0049504d
    add eax, 0x9d                                # 00495050
    push eax                                     # 00495055
    mov ecx, dword ptr [ebp - local_24]          # 00495056
    call FUN_00495536                            # 00495059
L_0049505e:
    # block 0x0049505e: entered by je at 0x00494f55, 89 instruction(s), calls FUN_004c2a8d, FUN_004c46d1, ends with forward jump to 0x004951ef
    mov ecx, dword ptr [0x635bb4]                # 0049505e
    shl ecx                                      # 00495064
    mov edx, dword ptr [ebp - local_24]          # 00495066
    mov dword ptr [edx + field_203d], ecx        # 00495069
    mov eax, dword ptr [0x635bb8]                # 0049506f
    shl eax                                      # 00495074
    mov ecx, dword ptr [ebp - local_24]          # 00495076
    mov dword ptr [ecx + field_2041], eax        # 00495079
    mov edx, dword ptr [ebp - local_24]          # 0049507f
    mov dword ptr [edx + field_2045], 0x2        # 00495082
    mov eax, dword ptr [ebp - local_24]          # 0049508c
    mov dword ptr [eax + field_2049], 0x2        # 0049508f
    push 0x54f85c                                # 00495099
    push 0x8                                     # 0049509e
    mov ecx, dword ptr [ebp - local_24]          # 004950a0
    mov dx, word ptr [ecx + field_2041]          # 004950a3
    push edx                                     # 004950aa
    mov eax, dword ptr [ebp - local_24]          # 004950ab
    mov cx, word ptr [eax + field_203d]          # 004950ae
    push ecx                                     # 004950b5
    mov ecx, 0x5cf659                            # 004950b6
    call FUN_004c2a8d                            # 004950bb
    mov edx, dword ptr [ebp - local_24]          # 004950c0
    mov dword ptr [edx + field_2035], eax        # 004950c3
    push 0x54f870                                # 004950c9
    push 0x8                                     # 004950ce
    mov eax, dword ptr [ebp - local_24]          # 004950d0
    mov cx, word ptr [eax + field_2049]          # 004950d3
    push ecx                                     # 004950da
    mov edx, dword ptr [ebp - local_24]          # 004950db
    mov ax, word ptr [edx + field_2045]          # 004950de
    push eax                                     # 004950e5
    mov ecx, 0x5cf659                            # 004950e6
    call FUN_004c2a8d                            # 004950eb
    mov ecx, dword ptr [ebp - local_24]          # 004950f0
    mov dword ptr [ecx + field_2039], eax        # 004950f3
    push 0x0                                     # 004950f9
    push 0x0                                     # 004950fb
    push 0x0                                     # 004950fd
    mov edx, dword ptr [ebp - local_24]          # 004950ff
    mov eax, dword ptr [edx + field_2035]        # 00495102
    push eax                                     # 00495108
    mov ecx, 0x5cf659                            # 00495109
    call FUN_004c46d1                            # 0049510e
    mov ecx, dword ptr [ebp - local_24]          # 00495113
    mov dl, byte ptr [ecx + field_87]            # 00495116
    push edx                                     # 0049511c
    mov eax, dword ptr [ebp - local_24]          # 0049511d
    mov cl, byte ptr [eax + field_86]            # 00495120
    push ecx                                     # 00495126
    mov edx, dword ptr [ebp - local_24]          # 00495127
    mov al, byte ptr [edx + field_85]            # 0049512a
    push eax                                     # 00495130
    mov ecx, dword ptr [ebp - local_24]          # 00495131
    mov edx, dword ptr [ecx + field_2039]        # 00495134
    push edx                                     # 0049513a
    mov ecx, 0x5cf659                            # 0049513b
    call FUN_004c46d1                            # 00495140
    mov eax, dword ptr [ebp - local_24]          # 00495145
    mov dword ptr [eax + field_2055], 0x0        # 00495148
    mov ecx, dword ptr [ebp - local_24]          # 00495152
    mov dword ptr [ecx + field_2059], 0x0        # 00495155
    mov edx, dword ptr [ebp - local_24]          # 0049515f
    mov eax, dword ptr [edx + field_203d]        # 00495162
    sub eax, 0x1                                 # 00495168
    mov ecx, dword ptr [ebp - local_24]          # 0049516b
    mov dword ptr [ecx + field_205d], eax        # 0049516e
    mov edx, dword ptr [ebp - local_24]          # 00495174
    mov eax, dword ptr [edx + field_2041]        # 00495177
    sub eax, 0x1                                 # 0049517d
    mov ecx, dword ptr [ebp - local_24]          # 00495180
    mov dword ptr [ecx + field_2061], eax        # 00495183
    mov edx, dword ptr [ebp - local_24]          # 00495189
    mov dword ptr [edx + field_2075], 0x0        # 0049518c
    mov eax, dword ptr [ebp - local_24]          # 00495196
    mov dword ptr [eax + field_2079], 0x0        # 00495199
    mov ecx, dword ptr [ebp - local_24]          # 004951a3
    mov edx, dword ptr [ecx + field_2045]        # 004951a6
    sub edx, 0x1                                 # 004951ac
    mov eax, dword ptr [ebp - local_24]          # 004951af
    mov dword ptr [eax + field_207d], edx        # 004951b2
    mov ecx, dword ptr [ebp - local_24]          # 004951b8
    mov edx, dword ptr [ecx + field_2049]        # 004951bb
    sub edx, 0x1                                 # 004951c1
    mov eax, dword ptr [ebp - local_24]          # 004951c4
    mov dword ptr [eax + field_2081], edx        # 004951c7
    mov dword ptr [ebp - local_14], 0x0          # 004951cd
    mov dword ptr [ebp - local_10], 0x0          # 004951d4
    jmp.d8 L_004951ef                            # 004951db
L_004951dd:
    # block 0x004951dd: entered by jmp at 0x0049552b, 6 instruction(s), falls into the block at 0x004951ef
    mov ecx, dword ptr [ebp - local_14]          # 004951dd
    add ecx, 0x1                                 # 004951e0
    mov dword ptr [ebp - local_14], ecx          # 004951e3
    mov edx, dword ptr [ebp - local_10]          # 004951e6
    add edx, 0x2                                 # 004951e9
    mov dword ptr [ebp - local_10], edx          # 004951ec
L_004951ef:
    # block 0x004951ef: entered by jmp at 0x004951db, 3 instruction(s), ends with jge to 0x00495530 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004951ef
    cmp eax, dword ptr [0x635bb8]                # 004951f2
    jge.d32 L_00495530                           # 004951f8
    # block 0x004951fe: entered by fall-through of jge at 0x004951f8, 3 instruction(s), ends with forward jump to 0x00495220
    mov dword ptr [ebp - local_20], 0x0          # 004951fe
    mov dword ptr [ebp - local_1c], 0x0          # 00495205
    jmp.d8 L_00495220                            # 0049520c
L_0049520e:
    # block 0x0049520e: entered by jmp at 0x004954c8, 6 instruction(s), falls into the block at 0x00495220
    mov ecx, dword ptr [ebp - local_20]          # 0049520e
    add ecx, 0x1                                 # 00495211
    mov dword ptr [ebp - local_20], ecx          # 00495214
    mov edx, dword ptr [ebp - local_1c]          # 00495217
    add edx, 0x2                                 # 0049521a
    mov dword ptr [ebp - local_1c], edx          # 0049521d
L_00495220:
    # block 0x00495220: entered by jmp at 0x0049520c, 3 instruction(s), ends with jge to 0x004954cd (forward)
    mov eax, dword ptr [ebp - local_20]          # 00495220
    cmp eax, dword ptr [0x635bb4]                # 00495223
    jge.d32 L_004954cd                           # 00495229
    # block 0x0049522f: entered by fall-through of jge at 0x00495229, 34 instruction(s), ends with je to 0x004952d9 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0049522f
    imul ecx, ecx, 0xa6                          # 00495232
    mov edx, dword ptr [ebp - local_24]          # 00495238
    mov eax, dword ptr [edx + field_1f47]        # 0049523b
    lea ecx, [eax + 4*ecx]                       # 00495241
    mov edx, dword ptr [ebp - local_20]          # 00495244
    mov eax, dword ptr [ecx + 4*edx]             # 00495247
    mov dword ptr [ebp - local_18], eax          # 0049524a
    mov ecx, dword ptr [ebp - local_14]          # 0049524d
    imul ecx, ecx, 0xa6                          # 00495250
    mov edx, dword ptr [ebp - local_24]          # 00495256
    mov eax, dword ptr [edx + field_1f53]        # 00495259
    lea ecx, [eax + 4*ecx]                       # 0049525f
    mov edx, dword ptr [ebp - local_20]          # 00495262
    mov eax, dword ptr [ecx + 4*edx]             # 00495265
    mov dword ptr [ebp - local_8], eax           # 00495268
    mov ecx, dword ptr [ebp - local_24]          # 0049526b
    mov edx, dword ptr [ecx + field_2035]        # 0049526e
    mov eax, dword ptr [ebp - local_24]          # 00495274
    mov ecx, dword ptr [eax + field_2035]        # 00495277
    movsx eax, word ptr [ecx + field_2f]         # 0049527d
    mov ecx, dword ptr [ebp - local_10]          # 00495281
    imul ecx, eax                                # 00495284
    mov edx, dword ptr [edx]                     # 00495287
    {load} add edx, ecx                          # 00495289
    movsx eax, word ptr [0x639895]               # 0049528b
    mov ecx, dword ptr [ebp - local_1c]          # 00495292
    imul ecx, eax                                # 00495295
    {load} add edx, ecx                          # 00495298
    mov dword ptr [ebp - local_c], edx           # 0049529a
    mov edx, dword ptr [ebp - local_18]          # 0049529d
    and edx, 0x1000000                           # 004952a0
    test edx, edx                                # 004952a6
    je.d8 L_004952d9                             # 004952a8
    # block 0x004952aa: entered by fall-through of je at 0x004952a8, 13 instruction(s), falls into the block at 0x004952d9
    mov eax, dword ptr [ebp - local_c]           # 004952aa
    mov dword ptr [ebp - local_4], eax           # 004952ad
    mov ecx, dword ptr [ebp - local_4]           # 004952b0
    mov edx, dword ptr [ebp - local_24]          # 004952b3
    mov ax, word ptr [edx + field_2023]          # 004952b6
    mov word ptr [ecx], ax                       # 004952bd
    mov ecx, dword ptr [ebp - local_4]           # 004952c0
    add ecx, 0x2                                 # 004952c3
    mov dword ptr [ebp - local_4], ecx           # 004952c6
    mov edx, dword ptr [ebp - local_4]           # 004952c9
    mov eax, dword ptr [ebp - local_24]          # 004952cc
    mov cx, word ptr [eax + field_2023]          # 004952cf
    mov word ptr [edx], cx                       # 004952d6
L_004952d9:
    # block 0x004952d9: entered by je at 0x004952a8, 2 instruction(s), ends with je to 0x0049531b (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004952d9
    je.d8 L_0049531b                             # 004952dd
    # block 0x004952df: entered by fall-through of je at 0x004952dd, 4 instruction(s), ends with jne to 0x0049531b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004952df
    and edx, 0x1000000                           # 004952e2
    test edx, edx                                # 004952e8
    jne.d8 L_0049531b                            # 004952ea
    # block 0x004952ec: entered by fall-through of jne at 0x004952ea, 13 instruction(s), falls into the block at 0x0049531b
    mov eax, dword ptr [ebp - local_c]           # 004952ec
    mov dword ptr [ebp - local_4], eax           # 004952ef
    mov ecx, dword ptr [ebp - local_4]           # 004952f2
    mov edx, dword ptr [ebp - local_24]          # 004952f5
    mov ax, word ptr [edx + field_202b]          # 004952f8
    mov word ptr [ecx], ax                       # 004952ff
    mov ecx, dword ptr [ebp - local_4]           # 00495302
    add ecx, 0x2                                 # 00495305
    mov dword ptr [ebp - local_4], ecx           # 00495308
    mov edx, dword ptr [ebp - local_4]           # 0049530b
    mov eax, dword ptr [ebp - local_24]          # 0049530e
    mov cx, word ptr [eax + field_202b]          # 00495311
    mov word ptr [edx], cx                       # 00495318
L_0049531b:
    # block 0x0049531b: entered by je at 0x004952dd; jne at 0x004952ea, 4 instruction(s), ends with jne to 0x00495334 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0049531b
    and edx, 0x2000000                           # 0049531e
    test edx, edx                                # 00495324
    jne.d8 L_00495334                            # 00495326
    # block 0x00495328: entered by fall-through of jne at 0x00495326, 4 instruction(s), ends with je to 0x00495363 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00495328
    and eax, 0x4000000                           # 0049532b
    test eax, eax                                # 00495330
    je.d8 L_00495363                             # 00495332
L_00495334:
    # block 0x00495334: entered by jne at 0x00495326; fall-through of je at 0x00495332, 13 instruction(s), falls into the block at 0x00495363
    mov ecx, dword ptr [ebp - local_c]           # 00495334
    mov dword ptr [ebp - local_4], ecx           # 00495337
    mov edx, dword ptr [ebp - local_4]           # 0049533a
    mov eax, dword ptr [ebp - local_24]          # 0049533d
    mov cx, word ptr [eax + field_202d]          # 00495340
    mov word ptr [edx], cx                       # 00495347
    mov edx, dword ptr [ebp - local_4]           # 0049534a
    add edx, 0x2                                 # 0049534d
    mov dword ptr [ebp - local_4], edx           # 00495350
    mov eax, dword ptr [ebp - local_4]           # 00495353
    mov ecx, dword ptr [ebp - local_24]          # 00495356
    mov dx, word ptr [ecx + field_202d]          # 00495359
    mov word ptr [eax], dx                       # 00495360
L_00495363:
    # block 0x00495363: entered by je at 0x00495332, 4 instruction(s), ends with je to 0x0049539e (forward)
    mov eax, dword ptr [ebp - local_18]          # 00495363
    and eax, 0x10000000                          # 00495366
    test eax, eax                                # 0049536b
    je.d8 L_0049539e                             # 0049536d
    # block 0x0049536f: entered by fall-through of je at 0x0049536d, 13 instruction(s), falls into the block at 0x0049539e
    mov ecx, dword ptr [ebp - local_c]           # 0049536f
    mov dword ptr [ebp - local_4], ecx           # 00495372
    mov edx, dword ptr [ebp - local_4]           # 00495375
    mov eax, dword ptr [ebp - local_24]          # 00495378
    mov cx, word ptr [eax + field_202f]          # 0049537b
    mov word ptr [edx], cx                       # 00495382
    mov edx, dword ptr [ebp - local_4]           # 00495385
    add edx, 0x2                                 # 00495388
    mov dword ptr [ebp - local_4], edx           # 0049538b
    mov eax, dword ptr [ebp - local_4]           # 0049538e
    mov ecx, dword ptr [ebp - local_24]          # 00495391
    mov dx, word ptr [ecx + field_202f]          # 00495394
    mov word ptr [eax], dx                       # 0049539b
L_0049539e:
    # block 0x0049539e: entered by je at 0x0049536d, 4 instruction(s), ends with je to 0x004953d9 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0049539e
    and eax, 0x20000000                          # 004953a1
    test eax, eax                                # 004953a6
    je.d8 L_004953d9                             # 004953a8
    # block 0x004953aa: entered by fall-through of je at 0x004953a8, 13 instruction(s), falls into the block at 0x004953d9
    mov ecx, dword ptr [ebp - local_c]           # 004953aa
    mov dword ptr [ebp - local_4], ecx           # 004953ad
    mov edx, dword ptr [ebp - local_4]           # 004953b0
    mov eax, dword ptr [ebp - local_24]          # 004953b3
    mov cx, word ptr [eax + field_2031]          # 004953b6
    mov word ptr [edx], cx                       # 004953bd
    mov edx, dword ptr [ebp - local_4]           # 004953c0
    add edx, 0x2                                 # 004953c3
    mov dword ptr [ebp - local_4], edx           # 004953c6
    mov eax, dword ptr [ebp - local_4]           # 004953c9
    mov ecx, dword ptr [ebp - local_24]          # 004953cc
    mov dx, word ptr [ecx + field_2031]          # 004953cf
    mov word ptr [eax], dx                       # 004953d6
L_004953d9:
    # block 0x004953d9: entered by je at 0x004953a8, 4 instruction(s), ends with jne to 0x00495415 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004953d9
    and eax, 0xff                                # 004953dc
    cmp eax, 0x2                                 # 004953e1
    jne.d8 L_00495415                            # 004953e4
    # block 0x004953e6: entered by fall-through of jne at 0x004953e4, 13 instruction(s), falls into the block at 0x00495415
    mov ecx, dword ptr [ebp - local_c]           # 004953e6
    mov dword ptr [ebp - local_4], ecx           # 004953e9
    mov edx, dword ptr [ebp - local_4]           # 004953ec
    mov eax, dword ptr [ebp - local_24]          # 004953ef
    mov cx, word ptr [eax + field_2027]          # 004953f2
    mov word ptr [edx], cx                       # 004953f9
    mov edx, dword ptr [ebp - local_4]           # 004953fc
    add edx, 0x2                                 # 004953ff
    mov dword ptr [ebp - local_4], edx           # 00495402
    mov eax, dword ptr [ebp - local_4]           # 00495405
    mov ecx, dword ptr [ebp - local_24]          # 00495408
    mov dx, word ptr [ecx + field_2027]          # 0049540b
    mov word ptr [eax], dx                       # 00495412
L_00495415:
    # block 0x00495415: entered by jne at 0x004953e4, 4 instruction(s), ends with jne to 0x00495451 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00495415
    and eax, 0xff                                # 00495418
    cmp eax, 0x3                                 # 0049541d
    jne.d8 L_00495451                            # 00495420
    # block 0x00495422: entered by fall-through of jne at 0x00495420, 13 instruction(s), falls into the block at 0x00495451
    mov ecx, dword ptr [ebp - local_c]           # 00495422
    mov dword ptr [ebp - local_4], ecx           # 00495425
    mov edx, dword ptr [ebp - local_4]           # 00495428
    mov eax, dword ptr [ebp - local_24]          # 0049542b
    mov cx, word ptr [eax + field_2033]          # 0049542e
    mov word ptr [edx], cx                       # 00495435
    mov edx, dword ptr [ebp - local_4]           # 00495438
    add edx, 0x2                                 # 0049543b
    mov dword ptr [ebp - local_4], edx           # 0049543e
    mov eax, dword ptr [ebp - local_4]           # 00495441
    mov ecx, dword ptr [ebp - local_24]          # 00495444
    mov dx, word ptr [ecx + field_2033]          # 00495447
    mov word ptr [eax], dx                       # 0049544e
L_00495451:
    # block 0x00495451: entered by jne at 0x00495420, 4 instruction(s), ends with je to 0x0049548c (forward)
    mov eax, dword ptr [ebp - local_18]          # 00495451
    and eax, 0x8000000                           # 00495454
    test eax, eax                                # 00495459
    je.d8 L_0049548c                             # 0049545b
    # block 0x0049545d: entered by fall-through of je at 0x0049545b, 13 instruction(s), falls into the block at 0x0049548c
    mov ecx, dword ptr [ebp - local_c]           # 0049545d
    mov dword ptr [ebp - local_4], ecx           # 00495460
    mov edx, dword ptr [ebp - local_4]           # 00495463
    mov eax, dword ptr [ebp - local_24]          # 00495466
    mov cx, word ptr [eax + field_2025]          # 00495469
    mov word ptr [edx], cx                       # 00495470
    mov edx, dword ptr [ebp - local_4]           # 00495473
    add edx, 0x2                                 # 00495476
    mov dword ptr [ebp - local_4], edx           # 00495479
    mov eax, dword ptr [ebp - local_4]           # 0049547c
    mov ecx, dword ptr [ebp - local_24]          # 0049547f
    mov dx, word ptr [ecx + field_2025]          # 00495482
    mov word ptr [eax], dx                       # 00495489
L_0049548c:
    # block 0x0049548c: entered by je at 0x0049545b, 4 instruction(s), ends with jne to 0x004954c8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0049548c
    and eax, 0xff                                # 0049548f
    cmp eax, 0x1                                 # 00495494
    jne.d8 L_004954c8                            # 00495497
    # block 0x00495499: entered by fall-through of jne at 0x00495497, 13 instruction(s), falls into the block at 0x004954c8
    mov ecx, dword ptr [ebp - local_c]           # 00495499
    mov dword ptr [ebp - local_4], ecx           # 0049549c
    mov edx, dword ptr [ebp - local_4]           # 0049549f
    mov eax, dword ptr [ebp - local_24]          # 004954a2
    mov cx, word ptr [eax + field_2029]          # 004954a5
    mov word ptr [edx], cx                       # 004954ac
    mov edx, dword ptr [ebp - local_4]           # 004954af
    add edx, 0x2                                 # 004954b2
    mov dword ptr [ebp - local_4], edx           # 004954b5
    mov eax, dword ptr [ebp - local_4]           # 004954b8
    mov ecx, dword ptr [ebp - local_24]          # 004954bb
    mov dx, word ptr [ecx + field_2029]          # 004954be
    mov word ptr [eax], dx                       # 004954c5
L_004954c8:
    # block 0x004954c8: entered by jne at 0x00495497, 1 instruction(s), ends with backward jump to 0x0049520e
    jmp.d32 L_0049520e                           # 004954c8
L_004954cd:
    # block 0x004954cd: entered by jge at 0x00495229, 29 instruction(s), ends with backward jump to 0x004951dd
    mov eax, dword ptr [ebp - local_24]          # 004954cd
    mov ecx, dword ptr [eax + field_2035]        # 004954d0
    movsx ecx, word ptr [ecx + field_2f]         # 004954d6
    mov edx, dword ptr [ebp - local_24]          # 004954da
    mov eax, dword ptr [edx + field_2035]        # 004954dd
    mov edx, dword ptr [ebp - local_24]          # 004954e3
    mov edx, dword ptr [edx + field_2035]        # 004954e6
    movsx edx, word ptr [edx + field_2f]         # 004954ec
    mov esi, dword ptr [ebp - local_10]          # 004954f0
    imul esi, edx                                # 004954f3
    mov eax, dword ptr [eax]                     # 004954f6
    {load} add esi, eax                          # 004954f8
    mov edx, dword ptr [ebp - local_24]          # 004954fa
    mov eax, dword ptr [edx + field_2035]        # 004954fd
    mov edx, dword ptr [ebp - local_10]          # 00495503
    add edx, 0x1                                 # 00495506
    mov edi, dword ptr [ebp - local_24]          # 00495509
    mov edi, dword ptr [edi + field_2035]        # 0049550c
    movsx edi, word ptr [edi + field_2f]         # 00495512
    imul edx, edi                                # 00495516
    mov edi, dword ptr [eax]                     # 00495519
    {load} add edi, edx                          # 0049551b
    {load} mov eax, ecx                          # 0049551d
    shr ecx, 0x2                                 # 0049551f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00495522
    {load} mov ecx, eax                          # 00495524
    and ecx, 0x3                                 # 00495526
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00495529
    jmp.d32 L_004951dd                           # 0049552b
L_00495530:
    # block 0x00495530: entered by jge at 0x004951f8, 5 instruction(s), ends with ret
    pop edi                                      # 00495530
    pop esi                                      # 00495531
    {load} mov esp, ebp                          # 00495532
    pop ebp                                      # 00495534
    ret                                          # 00495535

