# FUN_004f70b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f70b0
# extent:       0x004f70b0-0x004f7207 (343 code bytes)
# span:         0x004f70b0-0x004f7207 (code 343, tables 0, padding 0)
# sha256:       d92d6d2994389c7fe923cb9391113845f1c5b10a4d405e4c3db8878aebaf9fa8
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f70b0
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; ret 0x20 (callee pops 32 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_27c, field_3c2, field_3dc, field_3e4, field_3e8, field_3f0, field_3f4; [ecx + n] field_280, field_3da, field_3e0, field_3ec; [edx + n] field_284, field_3dc, field_3e4, field_3e8, field_3f0
# callees:      calls FUN_004f709c, FUN_004f88de, FUN_004f875f, FUN_004f861c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 98 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ field_27c, 0x27c  # offset +0x27c
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3da, 0x3da  # offset +0x3da
.equ field_3dc, 0x3dc  # offset +0x3dc
.equ field_3e0, 0x3e0  # offset +0x3e0
.equ field_3e4, 0x3e4  # offset +0x3e4
.equ field_3e8, 0x3e8  # offset +0x3e8
.equ field_3ec, 0x3ec  # offset +0x3ec
.equ field_3f0, 0x3f0  # offset +0x3f0
.equ field_3f4, 0x3f4  # offset +0x3f4

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f861c, .text + (0x004f861c - 0x401000)
.set FUN_004f875f, .text + (0x004f875f - 0x401000)
.set FUN_004f88de, .text + (0x004f88de - 0x401000)

.org 0x004f70b0 - 0x401000
.globl FUN_004f70b0
FUN_004f70b0:
    # block 0x004f70b0: entry, 10 instruction(s), calls FUN_004f709c, ends with jne to 0x004f70d7 (forward)
    push ebp                                     # 004f70b0
    {load} mov ebp, esp                          # 004f70b1
    sub esp, 0x28                                # 004f70b3
    mov dword ptr [ebp - local_4], ecx           # 004f70b6
    mov eax, dword ptr [ebp - local_4]           # 004f70b9
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f70bc
    mov ecx, dword ptr [ebp - local_4]           # 004f70c6
    call FUN_004f709c                            # 004f70c9
    test eax, eax                                # 004f70ce
    jne.d8 L_004f70d7                            # 004f70d0
    # block 0x004f70d2: entered by fall-through of jne at 0x004f70d0, 1 instruction(s), ends with forward jump to 0x004f7201
    jmp.d32 L_004f7201                           # 004f70d2
L_004f70d7:
    # block 0x004f70d7: entered by jne at 0x004f70d0, 84 instruction(s), calls FUN_004f88de, FUN_004f875f, FUN_004f861c, falls into the block at 0x004f7201
    mov ecx, dword ptr [ebp - local_4]           # 004f70d7
    mov dx, word ptr [ebp + arg_8]               # 004f70da
    mov word ptr [ecx + field_3da], dx           # 004f70de
    mov eax, dword ptr [ebp - local_4]           # 004f70e5
    mov cx, word ptr [ebp + arg_c]               # 004f70e8
    mov word ptr [eax + field_3f4], cx           # 004f70ec
    mov edx, dword ptr [ebp - local_4]           # 004f70f3
    mov eax, dword ptr [ebp + arg_10]            # 004f70f6
    mov dword ptr [edx + field_3dc], eax         # 004f70f9
    mov ecx, dword ptr [ebp - local_4]           # 004f70ff
    mov edx, dword ptr [ebp + arg_14]            # 004f7102
    mov dword ptr [ecx + field_3e0], edx         # 004f7105
    mov eax, dword ptr [ebp - local_4]           # 004f710b
    mov ecx, dword ptr [ebp + arg_18]            # 004f710e
    mov dword ptr [eax + field_3e4], ecx         # 004f7111
    mov edx, dword ptr [ebp - local_4]           # 004f7117
    mov eax, dword ptr [ebp + arg_1c]            # 004f711a
    mov dword ptr [edx + field_3e8], eax         # 004f711d
    mov ecx, dword ptr [ebp - local_4]           # 004f7123
    mov edx, dword ptr [ebp + arg_20]            # 004f7126
    mov dword ptr [ecx + field_3ec], edx         # 004f7129
    mov eax, dword ptr [ebp - local_4]           # 004f712f
    mov ecx, dword ptr [ebp + arg_24]            # 004f7132
    mov dword ptr [eax + field_3f0], ecx         # 004f7135
    mov edx, dword ptr [ebp - local_4]           # 004f713b
    mov eax, dword ptr [edx + field_284]         # 004f713e
    push eax                                     # 004f7144
    mov ecx, dword ptr [ebp - local_4]           # 004f7145
    mov edx, dword ptr [ecx + field_280]         # 004f7148
    push edx                                     # 004f714e
    mov eax, dword ptr [ebp - local_4]           # 004f714f
    mov ecx, dword ptr [eax + field_27c]         # 004f7152
    push ecx                                     # 004f7158
    mov edx, dword ptr [ebp - local_4]           # 004f7159
    fild dword ptr [edx + field_3f0]             # 004f715c
    fstp dword ptr [ebp - local_8]               # 004f7162
    mov eax, dword ptr [ebp - local_8]           # 004f7165
    push eax                                     # 004f7168
    mov ecx, dword ptr [ebp - local_4]           # 004f7169
    fild dword ptr [ecx + field_3ec]             # 004f716c
    fstp dword ptr [ebp - local_c]               # 004f7172
    mov edx, dword ptr [ebp - local_c]           # 004f7175
    push edx                                     # 004f7178
    mov eax, dword ptr [ebp - local_4]           # 004f7179
    fild dword ptr [eax + field_3e8]             # 004f717c
    fstp dword ptr [ebp - local_10]              # 004f7182
    mov ecx, dword ptr [ebp - local_10]          # 004f7185
    push ecx                                     # 004f7188
    mov ecx, dword ptr [ebp - local_4]           # 004f7189
    call FUN_004f88de                            # 004f718c
    mov edx, dword ptr [ebp - local_4]           # 004f7191
    fild dword ptr [edx + field_3f0]             # 004f7194
    fstp dword ptr [ebp - local_14]              # 004f719a
    mov eax, dword ptr [ebp - local_14]          # 004f719d
    push eax                                     # 004f71a0
    mov ecx, dword ptr [ebp - local_4]           # 004f71a1
    fild dword ptr [ecx + field_3ec]             # 004f71a4
    fstp dword ptr [ebp - local_18]              # 004f71aa
    mov edx, dword ptr [ebp - local_18]          # 004f71ad
    push edx                                     # 004f71b0
    mov eax, dword ptr [ebp - local_4]           # 004f71b1
    fild dword ptr [eax + field_3e8]             # 004f71b4
    fstp dword ptr [ebp - local_1c]              # 004f71ba
    mov ecx, dword ptr [ebp - local_1c]          # 004f71bd
    push ecx                                     # 004f71c0
    mov ecx, dword ptr [ebp - local_4]           # 004f71c1
    call FUN_004f875f                            # 004f71c4
    mov edx, dword ptr [ebp - local_4]           # 004f71c9
    fild dword ptr [edx + field_3e4]             # 004f71cc
    fstp dword ptr [ebp - local_20]              # 004f71d2
    mov eax, dword ptr [ebp - local_20]          # 004f71d5
    push eax                                     # 004f71d8
    mov ecx, dword ptr [ebp - local_4]           # 004f71d9
    fild dword ptr [ecx + field_3e0]             # 004f71dc
    fstp dword ptr [ebp - local_24]              # 004f71e2
    mov edx, dword ptr [ebp - local_24]          # 004f71e5
    push edx                                     # 004f71e8
    mov eax, dword ptr [ebp - local_4]           # 004f71e9
    fild dword ptr [eax + field_3dc]             # 004f71ec
    fstp dword ptr [ebp - local_28]              # 004f71f2
    mov ecx, dword ptr [ebp - local_28]          # 004f71f5
    push ecx                                     # 004f71f8
    mov ecx, dword ptr [ebp - local_4]           # 004f71f9
    call FUN_004f861c                            # 004f71fc
L_004f7201:
    # block 0x004f7201: entered by jmp at 0x004f70d2, 3 instruction(s), ends with ret 0x20
    {load} mov esp, ebp                          # 004f7201
    pop ebp                                      # 004f7203
    ret 0x20                                     # 004f7204

