# FUN_004c2e97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2e97
# extent:       0x004c2e97-0x004c334f (1208 code bytes)
# span:         0x004c2e97-0x004c334f (code 1208, tables 0, padding 0)
# sha256:       120f9a25bf014bf133fddaef12969fa286f922fff5382d4e6618516f11de780c
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c2e97_read_pixel_format
# naming:       native port src/original_methods_fl27c.c:m4c2e97_read_pixel_format (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4c2e97_read_pixel_format: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27c-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_20, local_24, local_28, local_2c, local_34, local_7c, local_80, local_84, local_88
# fields:       [eax + n] field_38c2, field_38c4, field_38c5, field_38c6, field_38c8, field_38c9, field_38ca, field_38d0, field_38d2, field_38d3; [ecx + n] field_38a8, field_38c0, field_38c1, field_38c4, field_38c5, field_38c6, field_38c8, field_38c9, field_38ca, field_38d0, field_38d3; [edx + n] field_58, field_38a8, field_38c0, field_38c1, field_38c2, field_38c6, field_38c8, field_38c9, field_38ca, field_38d2
# callees:      calls FUN_004c88c7, FUN_0042639d, FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27c.c:m4c2e97_read_pixel_format (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 298 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_34, 0x34  # offset -0x34
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ arg_8, 0x8  # offset +0x8
.equ field_58, 0x58  # offset +0x58
.equ field_38a8, 0x38a8  # offset +0x38a8
.equ field_38c0, 0x38c0  # offset +0x38c0
.equ field_38c1, 0x38c1  # offset +0x38c1
.equ field_38c2, 0x38c2  # offset +0x38c2
.equ field_38c4, 0x38c4  # offset +0x38c4
.equ field_38c5, 0x38c5  # offset +0x38c5
.equ field_38c6, 0x38c6  # offset +0x38c6
.equ field_38c8, 0x38c8  # offset +0x38c8
.equ field_38c9, 0x38c9  # offset +0x38c9
.equ field_38ca, 0x38ca  # offset +0x38ca
.equ field_38d0, 0x38d0  # offset +0x38d0
.equ field_38d2, 0x38d2  # offset +0x38d2
.equ field_38d3, 0x38d3  # offset +0x38d3

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c2e97 - 0x401000
.globl FUN_004c2e97
FUN_004c2e97:
    # block 0x004c2e97: entry, 22 instruction(s), calls indirect dword ptr [edx + 0x58], ends with je to 0x004c2f02 (forward)
    push ebp                                     # 004c2e97
    {load} mov ebp, esp                          # 004c2e98
    sub esp, 0x88                                # 004c2e9a
    push ebx                                     # 004c2ea0
    push edi                                     # 004c2ea1
    mov dword ptr [ebp - local_88], ecx          # 004c2ea2
    mov ecx, 0x1f                                # 004c2ea8
    {load} xor eax, eax                          # 004c2ead
    lea edi, [ebp - local_80]                    # 004c2eaf
    rep stosd dword ptr es:[edi], eax            # 004c2eb2
    mov dword ptr [ebp - local_80], 0x7c         # 004c2eb4
    mov dword ptr [ebp - local_7c], 0x1000       # 004c2ebb
    lea eax, [ebp - local_80]                    # 004c2ec2
    push eax                                     # 004c2ec5
    mov ecx, dword ptr [ebp + arg_8]             # 004c2ec6
    mov edx, dword ptr [ecx]                     # 004c2ec9
    mov eax, dword ptr [ebp + arg_8]             # 004c2ecb
    push eax                                     # 004c2ece
    call dword ptr [edx + field_58]              # 004c2ecf
    mov dword ptr [ebp - local_4], eax           # 004c2ed2
    cmp dword ptr [ebp - local_4], 0x0           # 004c2ed5
    je.d8 L_004c2f02                             # 004c2ed9
    # block 0x004c2edb: entered by fall-through of je at 0x004c2ed9, 10 instruction(s), calls FUN_004c88c7, FUN_0042639d, ends with forward jump to 0x004c3347
    mov ecx, dword ptr [ebp - local_4]           # 004c2edb
    push ecx                                     # 004c2ede
    mov ecx, dword ptr [ebp - local_88]          # 004c2edf
    call FUN_004c88c7                            # 004c2ee5
    push eax                                     # 004c2eea
    push 0x553f14                                # 004c2eeb
    mov ecx, 0x583979                            # 004c2ef0
    call FUN_0042639d                            # 004c2ef5
    {load} xor ax, ax                            # 004c2efa
    jmp.d32 L_004c3347                           # 004c2efd
L_004c2f02:
    # block 0x004c2f02: entered by je at 0x004c2ed9, 1 instruction(s), falls into the block at 0x004c2f09
    mov byte ptr [ebp - local_84], 0x0           # 004c2f02
L_004c2f09:
    # block 0x004c2f09: entered by jmp at 0x004c2f2a, 4 instruction(s), ends with jne to 0x004c2f2c (forward)
    mov edx, dword ptr [ebp - local_28]          # 004c2f09
    and edx, 0x1                                 # 004c2f0c
    test edx, edx                                # 004c2f0f
    jne.d8 L_004c2f2c                            # 004c2f11
    # block 0x004c2f13: entered by fall-through of jne at 0x004c2f11, 7 instruction(s), ends with backward jump to 0x004c2f09
    mov eax, dword ptr [ebp - local_28]          # 004c2f13
    shr eax                                      # 004c2f16
    mov dword ptr [ebp - local_28], eax          # 004c2f18
    mov cl, byte ptr [ebp - local_84]            # 004c2f1b
    add cl, 0x1                                  # 004c2f21
    mov byte ptr [ebp - local_84], cl            # 004c2f24
    jmp.d8 L_004c2f09                            # 004c2f2a
L_004c2f2c:
    # block 0x004c2f2c: entered by jne at 0x004c2f11, 8 instruction(s), ends with jne to 0x004c2f62 (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c2f2c
    mov al, byte ptr [ebp - local_84]            # 004c2f32
    mov byte ptr [edx + field_38c2], al          # 004c2f38
    mov ecx, dword ptr [ebp - local_88]          # 004c2f3e
    mov dl, byte ptr [ebp - local_28]            # 004c2f44
    mov byte ptr [ecx + field_38c6], dl          # 004c2f47
    cmp dword ptr [ebp - local_28], 0x1f         # 004c2f4d
    jne.d8 L_004c2f62                            # 004c2f51
    # block 0x004c2f53: entered by fall-through of jne at 0x004c2f51, 3 instruction(s), ends with forward jump to 0x004c2f6f
    mov eax, dword ptr [ebp - local_88]          # 004c2f53
    mov byte ptr [eax + field_38ca], 0x5         # 004c2f59
    jmp.d8 L_004c2f6f                            # 004c2f60
L_004c2f62:
    # block 0x004c2f62: entered by jne at 0x004c2f51, 2 instruction(s), falls into the block at 0x004c2f6f
    mov ecx, dword ptr [ebp - local_88]          # 004c2f62
    mov byte ptr [ecx + field_38ca], 0x6         # 004c2f68
L_004c2f6f:
    # block 0x004c2f6f: entered by jmp at 0x004c2f60, 1 instruction(s), falls into the block at 0x004c2f76
    mov byte ptr [ebp - local_84], 0x0           # 004c2f6f
L_004c2f76:
    # block 0x004c2f76: entered by jmp at 0x004c2f97, 4 instruction(s), ends with jne to 0x004c2f99 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c2f76
    and edx, 0x1                                 # 004c2f79
    test edx, edx                                # 004c2f7c
    jne.d8 L_004c2f99                            # 004c2f7e
    # block 0x004c2f80: entered by fall-through of jne at 0x004c2f7e, 7 instruction(s), ends with backward jump to 0x004c2f76
    mov eax, dword ptr [ebp - local_24]          # 004c2f80
    shr eax                                      # 004c2f83
    mov dword ptr [ebp - local_24], eax          # 004c2f85
    mov cl, byte ptr [ebp - local_84]            # 004c2f88
    add cl, 0x1                                  # 004c2f8e
    mov byte ptr [ebp - local_84], cl            # 004c2f91
    jmp.d8 L_004c2f76                            # 004c2f97
L_004c2f99:
    # block 0x004c2f99: entered by jne at 0x004c2f7e, 8 instruction(s), ends with jne to 0x004c2fcf (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c2f99
    mov al, byte ptr [ebp - local_84]            # 004c2f9f
    mov byte ptr [edx + field_38c1], al          # 004c2fa5
    mov ecx, dword ptr [ebp - local_88]          # 004c2fab
    mov dl, byte ptr [ebp - local_24]            # 004c2fb1
    mov byte ptr [ecx + field_38c5], dl          # 004c2fb4
    cmp dword ptr [ebp - local_24], 0x1f         # 004c2fba
    jne.d8 L_004c2fcf                            # 004c2fbe
    # block 0x004c2fc0: entered by fall-through of jne at 0x004c2fbe, 3 instruction(s), ends with forward jump to 0x004c2fdc
    mov eax, dword ptr [ebp - local_88]          # 004c2fc0
    mov byte ptr [eax + field_38c9], 0x5         # 004c2fc6
    jmp.d8 L_004c2fdc                            # 004c2fcd
L_004c2fcf:
    # block 0x004c2fcf: entered by jne at 0x004c2fbe, 2 instruction(s), falls into the block at 0x004c2fdc
    mov ecx, dword ptr [ebp - local_88]          # 004c2fcf
    mov byte ptr [ecx + field_38c9], 0x6         # 004c2fd5
L_004c2fdc:
    # block 0x004c2fdc: entered by jmp at 0x004c2fcd, 1 instruction(s), falls into the block at 0x004c2fe3
    mov byte ptr [ebp - local_84], 0x0           # 004c2fdc
L_004c2fe3:
    # block 0x004c2fe3: entered by jmp at 0x004c3004, 4 instruction(s), ends with jne to 0x004c3006 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004c2fe3
    and edx, 0x1                                 # 004c2fe6
    test edx, edx                                # 004c2fe9
    jne.d8 L_004c3006                            # 004c2feb
    # block 0x004c2fed: entered by fall-through of jne at 0x004c2feb, 7 instruction(s), ends with backward jump to 0x004c2fe3
    mov eax, dword ptr [ebp - local_20]          # 004c2fed
    shr eax                                      # 004c2ff0
    mov dword ptr [ebp - local_20], eax          # 004c2ff2
    mov cl, byte ptr [ebp - local_84]            # 004c2ff5
    add cl, 0x1                                  # 004c2ffb
    mov byte ptr [ebp - local_84], cl            # 004c2ffe
    jmp.d8 L_004c2fe3                            # 004c3004
L_004c3006:
    # block 0x004c3006: entered by jne at 0x004c2feb, 8 instruction(s), ends with jne to 0x004c303c (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c3006
    mov al, byte ptr [ebp - local_84]            # 004c300c
    mov byte ptr [edx + field_38c0], al          # 004c3012
    mov ecx, dword ptr [ebp - local_88]          # 004c3018
    mov dl, byte ptr [ebp - local_20]            # 004c301e
    mov byte ptr [ecx + field_38c4], dl          # 004c3021
    cmp dword ptr [ebp - local_20], 0x1f         # 004c3027
    jne.d8 L_004c303c                            # 004c302b
    # block 0x004c302d: entered by fall-through of jne at 0x004c302b, 3 instruction(s), ends with forward jump to 0x004c3049
    mov eax, dword ptr [ebp - local_88]          # 004c302d
    mov byte ptr [eax + field_38c8], 0x5         # 004c3033
    jmp.d8 L_004c3049                            # 004c303a
L_004c303c:
    # block 0x004c303c: entered by jne at 0x004c302b, 2 instruction(s), falls into the block at 0x004c3049
    mov ecx, dword ptr [ebp - local_88]          # 004c303c
    mov byte ptr [ecx + field_38c8], 0x6         # 004c3042
L_004c3049:
    # block 0x004c3049: entered by jmp at 0x004c303a, 17 instruction(s), ends with je to 0x004c30b0 (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c3049
    mov al, byte ptr [0x5b0257]                  # 004c304f
    and al, byte ptr [edx + field_38c6]          # 004c3054
    mov byte ptr [0x5b0257], al                  # 004c305a
    mov ecx, dword ptr [ebp - local_88]          # 004c305f
    mov dl, byte ptr [0x5b0258]                  # 004c3065
    and dl, byte ptr [ecx + field_38c5]          # 004c306b
    mov byte ptr [0x5b0258], dl                  # 004c3071
    mov eax, dword ptr [ebp - local_88]          # 004c3077
    mov cl, byte ptr [0x5b0259]                  # 004c307d
    and cl, byte ptr [eax + field_38c4]          # 004c3083
    mov byte ptr [0x5b0259], cl                  # 004c3089
    mov edx, dword ptr [ebp - local_88]          # 004c308f
    {load} xor eax, eax                          # 004c3095
    mov al, byte ptr [edx + field_38ca]          # 004c3097
    cmp eax, 0x5                                 # 004c309d
    je.d8 L_004c30b0                             # 004c30a0
    # block 0x004c30a2: entered by fall-through of je at 0x004c30a0, 3 instruction(s), falls into the block at 0x004c30b0
    mov cl, byte ptr [0x5b0257]                  # 004c30a2
    shl cl                                       # 004c30a8
    mov byte ptr [0x5b0257], cl                  # 004c30aa
L_004c30b0:
    # block 0x004c30b0: entered by je at 0x004c30a0, 5 instruction(s), ends with je to 0x004c30d1 (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c30b0
    {load} xor eax, eax                          # 004c30b6
    mov al, byte ptr [edx + field_38c9]          # 004c30b8
    cmp eax, 0x5                                 # 004c30be
    je.d8 L_004c30d1                             # 004c30c1
    # block 0x004c30c3: entered by fall-through of je at 0x004c30c1, 3 instruction(s), falls into the block at 0x004c30d1
    mov cl, byte ptr [0x5b0258]                  # 004c30c3
    shl cl                                       # 004c30c9
    mov byte ptr [0x5b0258], cl                  # 004c30cb
L_004c30d1:
    # block 0x004c30d1: entered by je at 0x004c30c1, 5 instruction(s), ends with je to 0x004c30f2 (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c30d1
    {load} xor eax, eax                          # 004c30d7
    mov al, byte ptr [edx + field_38c8]          # 004c30d9
    cmp eax, 0x5                                 # 004c30df
    je.d8 L_004c30f2                             # 004c30e2
    # block 0x004c30e4: entered by fall-through of je at 0x004c30e2, 3 instruction(s), falls into the block at 0x004c30f2
    mov cl, byte ptr [0x5b0259]                  # 004c30e4
    shl cl                                       # 004c30ea
    mov byte ptr [0x5b0259], cl                  # 004c30ec
L_004c30f2:
    # block 0x004c30f2: entered by je at 0x004c30e2, 43 instruction(s), ends with jne to 0x004c31e0 (forward)
    {load} xor edx, edx                          # 004c30f2
    mov dl, byte ptr [0x5b0257]                  # 004c30f4
    mov eax, dword ptr [ebp - local_88]          # 004c30fa
    {load} xor ecx, ecx                          # 004c3100
    mov cl, byte ptr [eax + field_38c2]          # 004c3102
    shl edx, cl                                  # 004c3108
    {load} xor ecx, ecx                          # 004c310a
    mov cl, byte ptr [0x5b0258]                  # 004c310c
    {load} mov eax, ecx                          # 004c3112
    mov ecx, dword ptr [ebp - local_88]          # 004c3114
    {load} xor ebx, ebx                          # 004c311a
    mov bl, byte ptr [ecx + field_38c1]          # 004c311c
    {load} mov ecx, ebx                          # 004c3122
    shl eax, cl                                  # 004c3124
    {load} or edx, eax                           # 004c3126
    {load} xor eax, eax                          # 004c3128
    mov al, byte ptr [0x5b0259]                  # 004c312a
    mov ecx, dword ptr [ebp - local_88]          # 004c312f
    {load} xor ebx, ebx                          # 004c3135
    mov bl, byte ptr [ecx + field_38c0]          # 004c3137
    {load} mov ecx, ebx                          # 004c313d
    shl eax, cl                                  # 004c313f
    {load} or edx, eax                           # 004c3141
    mov eax, dword ptr [ebp - local_88]          # 004c3143
    mov word ptr [eax + field_38d0], dx          # 004c3149
    mov ecx, dword ptr [ebp - local_88]          # 004c3150
    {load} xor edx, edx                          # 004c3156
    mov dx, word ptr [ecx + field_38d0]          # 004c3158
    and edx, 0xff                                # 004c315f
    mov eax, dword ptr [ebp - local_88]          # 004c3165
    mov byte ptr [eax + field_38d2], dl          # 004c316b
    mov ecx, dword ptr [ebp - local_88]          # 004c3171
    {load} xor edx, edx                          # 004c3177
    mov dx, word ptr [ecx + field_38d0]          # 004c3179
    sar edx, 0x8                                 # 004c3180
    and edx, 0xff                                # 004c3183
    mov eax, dword ptr [ebp - local_88]          # 004c3189
    mov byte ptr [eax + field_38d3], dl          # 004c318f
    mov ecx, dword ptr [ebp - local_88]          # 004c3195
    {load} xor edx, edx                          # 004c319b
    mov dl, byte ptr [ecx + field_38ca]          # 004c319d
    cmp edx, 0x5                                 # 004c31a3
    jne.d8 L_004c31e0                            # 004c31a6
    # block 0x004c31a8: entered by fall-through of jne at 0x004c31a6, 5 instruction(s), ends with jne to 0x004c31e0 (forward)
    mov eax, dword ptr [ebp - local_88]          # 004c31a8
    {load} xor ecx, ecx                          # 004c31ae
    mov cl, byte ptr [eax + field_38c9]          # 004c31b0
    cmp ecx, 0x5                                 # 004c31b6
    jne.d8 L_004c31e0                            # 004c31b9
    # block 0x004c31bb: entered by fall-through of jne at 0x004c31b9, 5 instruction(s), ends with jne to 0x004c31e0 (forward)
    mov edx, dword ptr [ebp - local_88]          # 004c31bb
    {load} xor eax, eax                          # 004c31c1
    mov al, byte ptr [edx + field_38c8]          # 004c31c3
    cmp eax, 0x5                                 # 004c31c9
    jne.d8 L_004c31e0                            # 004c31cc
    # block 0x004c31ce: entered by fall-through of jne at 0x004c31cc, 3 instruction(s), ends with forward jump to 0x004c31f0
    mov ecx, dword ptr [ebp - local_88]          # 004c31ce
    mov dword ptr [ecx + field_38a8], 0x0        # 004c31d4
    jmp.d8 L_004c31f0                            # 004c31de
L_004c31e0:
    # block 0x004c31e0: entered by jne at 0x004c31a6; jne at 0x004c31b9; jne at 0x004c31cc, 2 instruction(s), falls into the block at 0x004c31f0
    mov edx, dword ptr [ebp - local_88]          # 004c31e0
    mov dword ptr [edx + field_38a8], 0x1        # 004c31e6
L_004c31f0:
    # block 0x004c31f0: entered by jmp at 0x004c31de, 3 instruction(s), ends with je to 0x004c3343 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c31f0
    test eax, eax                                # 004c31f7
    je.d32 L_004c3343                            # 004c31f9
    # block 0x004c31ff: entered by fall-through of je at 0x004c31f9, 64 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004c32fb (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004c31ff
    push ecx                                     # 004c3202
    mov edx, dword ptr [ebp - local_88]          # 004c3203
    {load} xor eax, eax                          # 004c3209
    mov al, byte ptr [edx + field_38d2]          # 004c320b
    push eax                                     # 004c3211
    mov ecx, dword ptr [ebp - local_88]          # 004c3212
    {load} xor edx, edx                          # 004c3218
    mov dl, byte ptr [ecx + field_38d3]          # 004c321a
    push edx                                     # 004c3220
    mov eax, dword ptr [ebp - local_88]          # 004c3221
    {load} xor ecx, ecx                          # 004c3227
    mov cx, word ptr [eax + field_38d0]          # 004c3229
    push ecx                                     # 004c3230
    mov edx, dword ptr [ebp - local_88]          # 004c3231
    mov eax, dword ptr [edx + field_38a8]        # 004c3237
    push eax                                     # 004c323d
    mov ecx, dword ptr [ebp - local_88]          # 004c323e
    {load} xor edx, edx                          # 004c3244
    mov dl, byte ptr [ecx + field_38c8]          # 004c3246
    push edx                                     # 004c324c
    mov eax, dword ptr [ebp - local_88]          # 004c324d
    {load} xor ecx, ecx                          # 004c3253
    mov cl, byte ptr [eax + field_38c4]          # 004c3255
    push ecx                                     # 004c325b
    mov edx, dword ptr [ebp - local_88]          # 004c325c
    {load} xor eax, eax                          # 004c3262
    mov al, byte ptr [edx + field_38c0]          # 004c3264
    push eax                                     # 004c326a
    mov ecx, dword ptr [ebp - local_88]          # 004c326b
    {load} xor edx, edx                          # 004c3271
    mov dl, byte ptr [ecx + field_38c9]          # 004c3273
    push edx                                     # 004c3279
    mov eax, dword ptr [ebp - local_88]          # 004c327a
    {load} xor ecx, ecx                          # 004c3280
    mov cl, byte ptr [eax + field_38c5]          # 004c3282
    push ecx                                     # 004c3288
    mov edx, dword ptr [ebp - local_88]          # 004c3289
    {load} xor eax, eax                          # 004c328f
    mov al, byte ptr [edx + field_38c1]          # 004c3291
    push eax                                     # 004c3297
    mov ecx, dword ptr [ebp - local_88]          # 004c3298
    {load} xor edx, edx                          # 004c329e
    mov dl, byte ptr [ecx + field_38ca]          # 004c32a0
    push edx                                     # 004c32a6
    mov eax, dword ptr [ebp - local_88]          # 004c32a7
    {load} xor ecx, ecx                          # 004c32ad
    mov cl, byte ptr [eax + field_38c6]          # 004c32af
    push ecx                                     # 004c32b5
    mov edx, dword ptr [ebp - local_88]          # 004c32b6
    {load} xor eax, eax                          # 004c32bc
    mov al, byte ptr [edx + field_38c2]          # 004c32be
    push eax                                     # 004c32c4
    push 0x553f30                                # 004c32c5
    push 0x63888b                                # 004c32ca
    call FUN_0050ca3e                            # 004c32cf
    add esp, 0x40                                # 004c32d4
    push 0x63888b                                # 004c32d7
    call FUN_0044a2b7                            # 004c32dc
    add esp, 0x4                                 # 004c32e1
    mov ecx, dword ptr [ebp - local_34]          # 004c32e4
    and ecx, 0x2                                 # 004c32e7
    test ecx, ecx                                # 004c32ea
    je.d8 L_004c32fb                             # 004c32ec
    # block 0x004c32ee: entered by fall-through of je at 0x004c32ec, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c32fb
    push 0x55400c                                # 004c32ee
    call FUN_0044a2b7                            # 004c32f3
    add esp, 0x4                                 # 004c32f8
L_004c32fb:
    # block 0x004c32fb: entered by je at 0x004c32ec, 4 instruction(s), ends with je to 0x004c3312 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004c32fb
    and edx, 0x20                                # 004c32fe
    test edx, edx                                # 004c3301
    je.d8 L_004c3312                             # 004c3303
    # block 0x004c3305: entered by fall-through of je at 0x004c3303, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c3312
    push 0x55403c                                # 004c3305
    call FUN_0044a2b7                            # 004c330a
    add esp, 0x4                                 # 004c330f
L_004c3312:
    # block 0x004c3312: entered by je at 0x004c3303, 4 instruction(s), ends with je to 0x004c3329 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004c3312
    and eax, 0x40                                # 004c3315
    test eax, eax                                # 004c3318
    je.d8 L_004c3329                             # 004c331a
    # block 0x004c331c: entered by fall-through of je at 0x004c331a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c3329
    push 0x554074                                # 004c331c
    call FUN_0044a2b7                            # 004c3321
    add esp, 0x4                                 # 004c3326
L_004c3329:
    # block 0x004c3329: entered by je at 0x004c331a, 4 instruction(s), ends with je to 0x004c3343 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004c3329
    and ecx, 0x400                               # 004c332c
    test ecx, ecx                                # 004c3332
    je.d8 L_004c3343                             # 004c3334
    # block 0x004c3336: entered by fall-through of je at 0x004c3334, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c3343
    push 0x5540a0                                # 004c3336
    call FUN_0044a2b7                            # 004c333b
    add esp, 0x4                                 # 004c3340
L_004c3343:
    # block 0x004c3343: entered by je at 0x004c31f9; je at 0x004c3334, 1 instruction(s), falls into the block at 0x004c3347
    mov ax, 0x1                                  # 004c3343
L_004c3347:
    # block 0x004c3347: entered by jmp at 0x004c2efd, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004c3347
    pop ebx                                      # 004c3348
    {load} mov esp, ebp                          # 004c3349
    pop ebp                                      # 004c334b
    ret 0x4                                      # 004c334c

