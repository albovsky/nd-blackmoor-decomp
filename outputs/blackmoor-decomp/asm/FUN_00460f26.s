# FUN_00460f26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00460f26
# extent:       0x00460f26-0x00461708 (2018 code bytes)
# span:         0x00460f26-0x00461710 (code 2018, tables 0, padding 8)
# sha256:       8dcbd6adb30aaf0c9f500cff32aebf8bd2f2ef88ebb406095f3bb6b608bfa95c
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_card_puzzle_render_callback
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.h:30 says "0x460f26 the render callback of generic Z entry type 10"
# name-note:    Render callback of generic Z entry type 10 for the card puzzle overlays.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_1c, local_20, local_24
# fields:       [eax + n] field_4b, field_48b, field_723, field_99b; [ecx + n] field_25, field_27, field_2b, field_4b, field_6b, field_633, field_653, field_723, field_aa3; [edx + n] field_25, field_2b, field_4b, field_3ab, field_633, field_653
# callees:      calls FUN_004d3a52, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 562 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_4b, 0x4b  # offset +0x4b
.equ field_6b, 0x6b  # offset +0x6b
.equ field_3ab, 0x3ab  # offset +0x3ab
.equ field_48b, 0x48b  # offset +0x48b
.equ field_633, 0x633  # offset +0x633
.equ field_653, 0x653  # offset +0x653
.equ field_723, 0x723  # offset +0x723
.equ field_99b, 0x99b  # offset +0x99b
.equ field_aa3, 0xaa3  # offset +0xaa3

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004d3a52, .text + (0x004d3a52 - 0x401000)

.org 0x00460f26 - 0x401000
.globl FUN_00460f26
FUN_00460f26:
    # block 0x00460f26: entry, 9 instruction(s), ends with forward jump to 0x00460f56
    push ebp                                     # 00460f26
    {load} mov ebp, esp                          # 00460f27
    sub esp, 0x24                                # 00460f29
    movsx eax, word ptr [0x61f4cf]               # 00460f2c
    imul eax, eax, 0x8d                          # 00460f33
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00460f39
    mov dword ptr [ebp - local_20], ecx          # 00460f3f
    mov word ptr [ebp - local_8], 0x0            # 00460f42
    jmp.d8 L_00460f56                            # 00460f48
L_00460f4a:
    # block 0x00460f4a: entered by jmp at 0x00461070, 3 instruction(s), falls into the block at 0x00460f56
    mov dx, word ptr [ebp - local_8]             # 00460f4a
    add dx, 0x1                                  # 00460f4e
    mov word ptr [ebp - local_8], dx             # 00460f52
L_00460f56:
    # block 0x00460f56: entered by jmp at 0x00460f48, 5 instruction(s), ends with jge to 0x00461075 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00460f56
    mov ecx, dword ptr [ebp - local_20]          # 00460f5a
    movsx edx, word ptr [ecx + field_27]         # 00460f5d
    {load} cmp eax, edx                          # 00460f61
    jge.d32 L_00461075                           # 00460f63
    # block 0x00460f69: entered by fall-through of jge at 0x00460f63, 2 instruction(s), ends with forward jump to 0x00460f7d
    mov word ptr [ebp - local_4], 0x0            # 00460f69
    jmp.d8 L_00460f7d                            # 00460f6f
L_00460f71:
    # block 0x00460f71: entered by jmp at 0x0046106b, 3 instruction(s), falls into the block at 0x00460f7d
    mov ax, word ptr [ebp - local_4]             # 00460f71
    .insn 0x66, 0x05, 0x0001{:u16}               # 00460f75
    mov word ptr [ebp - local_4], ax             # 00460f79
L_00460f7d:
    # block 0x00460f7d: entered by jmp at 0x00460f6f, 5 instruction(s), ends with jge to 0x00461070 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00460f7d
    mov edx, dword ptr [ebp - local_20]          # 00460f81
    movsx eax, word ptr [edx + field_25]         # 00460f84
    {load} cmp ecx, eax                          # 00460f88
    jge.d32 L_00461070                           # 00460f8a
    # block 0x00460f90: entered by fall-through of jge at 0x00460f8a, 18 instruction(s), calls FUN_004d3a52, ends with jne to 0x0046100f (forward)
    lea ecx, [ebp - local_1c]                    # 00460f90
    push ecx                                     # 00460f93
    movsx edx, word ptr [ebp - local_8]          # 00460f94
    imul edx, edx, 0xd0                          # 00460f98
    mov eax, dword ptr [ebp - local_20]          # 00460f9e
    lea ecx, [eax + edx + field_723]             # 00460fa1
    movsx edx, word ptr [ebp - local_4]          # 00460fa8
    shl edx, 0x4                                 # 00460fac
    {load} add ecx, edx                          # 00460faf
    push ecx                                     # 00460fb1
    call FUN_004d3a52                            # 00460fb2
    add esp, 0x8                                 # 00460fb7
    movsx eax, word ptr [ebp - local_8]          # 00460fba
    imul eax, eax, 0x34                          # 00460fbe
    add eax, 0x61f5f5                            # 00460fc1
    movsx ecx, word ptr [ebp - local_4]          # 00460fc6
    cmp dword ptr [eax + 4*ecx], 0x0             # 00460fca
    jne.d8 L_0046100f                            # 00460fce
    # block 0x00460fd0: entered by fall-through of jne at 0x00460fce, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x0046100f
    push 0x54af80                                # 00460fd0
    lea edx, [ebp - local_1c]                    # 00460fd5
    push edx                                     # 00460fd8
    movsx eax, word ptr [ebp - local_8]          # 00460fd9
    imul eax, eax, 0xd0                          # 00460fdd
    mov ecx, dword ptr [ebp - local_20]          # 00460fe3
    lea edx, [ecx + eax + field_723]             # 00460fe6
    movsx eax, word ptr [ebp - local_4]          # 00460fed
    shl eax, 0x4                                 # 00460ff1
    {load} add edx, eax                          # 00460ff4
    push edx                                     # 00460ff6
    mov ecx, dword ptr [0x5cf665]                # 00460ff7
    push ecx                                     # 00460ffd
    mov edx, dword ptr [0x5d15e3]                # 00460ffe
    push edx                                     # 00461004
    mov ecx, 0x5cf659                            # 00461005
    call FUN_004c5377                            # 0046100a
L_0046100f:
    # block 0x0046100f: entered by jne at 0x00460fce, 6 instruction(s), ends with jne to 0x0046106b (forward)
    movsx eax, word ptr [ebp - local_8]          # 0046100f
    imul eax, eax, 0x34                          # 00461013
    add eax, 0x61f5f5                            # 00461016
    movsx ecx, word ptr [ebp - local_4]          # 0046101b
    cmp dword ptr [eax + 4*ecx], 0x1             # 0046101f
    jne.d8 L_0046106b                            # 00461023
    # block 0x00461025: entered by fall-through of jne at 0x00461023, 19 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046106b
    push 0x54af94                                # 00461025
    lea edx, [ebp - local_1c]                    # 0046102a
    push edx                                     # 0046102d
    movsx eax, word ptr [ebp - local_8]          # 0046102e
    imul eax, eax, 0xd0                          # 00461032
    mov ecx, dword ptr [ebp - local_20]          # 00461038
    lea edx, [ecx + eax + field_6b]              # 0046103b
    movsx eax, word ptr [ebp - local_4]          # 0046103f
    shl eax, 0x4                                 # 00461043
    {load} add edx, eax                          # 00461046
    push edx                                     # 00461048
    mov ecx, dword ptr [0x5cf665]                # 00461049
    push ecx                                     # 0046104f
    movsx edx, word ptr [0x61f4cd]               # 00461050
    imul edx, edx, 0x4a                          # 00461057
    mov eax, dword ptr [edx + 0x5d1599]          # 0046105a
    push eax                                     # 00461060
    mov ecx, 0x5cf659                            # 00461061
    call FUN_004c5d4b                            # 00461066
L_0046106b:
    # block 0x0046106b: entered by jne at 0x00461023, 1 instruction(s), ends with backward jump to 0x00460f71
    jmp.d32 L_00460f71                           # 0046106b
L_00461070:
    # block 0x00461070: entered by jge at 0x00460f8a, 1 instruction(s), ends with backward jump to 0x00460f4a
    jmp.d32 L_00460f4a                           # 00461070
L_00461075:
    # block 0x00461075: entered by jge at 0x00460f63, 4 instruction(s), ends with je to 0x0046114a (forward)
    {load} xor ecx, ecx                          # 00461075
    mov cl, byte ptr [0x61f752]                  # 00461077
    test ecx, ecx                                # 0046107d
    je.d32 L_0046114a                            # 0046107f
    # block 0x00461085: entered by fall-through of je at 0x0046107f, 2 instruction(s), ends with forward jump to 0x00461099
    mov word ptr [ebp - local_4], 0x0            # 00461085
    jmp.d8 L_00461099                            # 0046108b
L_0046108d:
    # block 0x0046108d: entered by jmp at 0x00461145, 3 instruction(s), falls into the block at 0x00461099
    mov dx, word ptr [ebp - local_4]             # 0046108d
    add dx, 0x1                                  # 00461091
    mov word ptr [ebp - local_4], dx             # 00461095
L_00461099:
    # block 0x00461099: entered by jmp at 0x0046108b, 5 instruction(s), ends with jge to 0x0046114a (forward)
    movsx eax, word ptr [ebp - local_4]          # 00461099
    mov ecx, dword ptr [ebp - local_20]          # 0046109d
    movsx edx, word ptr [ecx + field_25]         # 004610a0
    {load} cmp eax, edx                          # 004610a4
    jge.d32 L_0046114a                           # 004610a6
    # block 0x004610ac: entered by fall-through of jge at 0x004610a6, 2 instruction(s), ends with forward jump to 0x004610c0
    mov word ptr [ebp - local_c], 0x0            # 004610ac
    jmp.d8 L_004610c0                            # 004610b2
L_004610b4:
    # block 0x004610b4: entered by jmp at 0x00461140, 3 instruction(s), falls into the block at 0x004610c0
    mov ax, word ptr [ebp - local_c]             # 004610b4
    .insn 0x66, 0x05, 0x0001{:u16}               # 004610b8
    mov word ptr [ebp - local_c], ax             # 004610bc
L_004610c0:
    # block 0x004610c0: entered by jmp at 0x004610b2, 3 instruction(s), ends with jge to 0x00461145 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004610c0
    cmp ecx, 0x2                                 # 004610c4
    jge.d8 L_00461145                            # 004610c7
    # block 0x004610c9: entered by fall-through of jge at 0x004610c7, 5 instruction(s), ends with je to 0x00461140 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004610c9
    imul edx, edx, 0x120                         # 004610cd
    movsx eax, word ptr [ebp - local_4]          # 004610d3
    cmp dword ptr [edx + 4*eax + 0x61f5bf], 0x0  # 004610d7
    je.d8 L_00461140                             # 004610df
    # block 0x004610e1: entered by fall-through of je at 0x004610df, 26 instruction(s), calls FUN_004d3a52, FUN_004c5377, falls into the block at 0x00461140
    lea ecx, [ebp - local_1c]                    # 004610e1
    push ecx                                     # 004610e4
    movsx edx, word ptr [ebp - local_c]          # 004610e5
    imul edx, edx, 0xd0                          # 004610e9
    mov eax, dword ptr [ebp - local_20]          # 004610ef
    lea ecx, [eax + edx + field_48b]             # 004610f2
    movsx edx, word ptr [ebp - local_4]          # 004610f9
    shl edx, 0x4                                 # 004610fd
    {load} add ecx, edx                          # 00461100
    push ecx                                     # 00461102
    call FUN_004d3a52                            # 00461103
    add esp, 0x8                                 # 00461108
    push 0x54afb0                                # 0046110b
    lea eax, [ebp - local_1c]                    # 00461110
    push eax                                     # 00461113
    mov ecx, dword ptr [ebp - local_20]          # 00461114
    add ecx, 0x47b                               # 00461117
    push ecx                                     # 0046111d
    mov edx, dword ptr [0x5cf665]                # 0046111e
    push edx                                     # 00461124
    movsx eax, word ptr [0x61f4cd]               # 00461125
    imul eax, eax, 0x4a                          # 0046112c
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046112f
    push ecx                                     # 00461135
    mov ecx, 0x5cf659                            # 00461136
    call FUN_004c5377                            # 0046113b
L_00461140:
    # block 0x00461140: entered by je at 0x004610df, 1 instruction(s), ends with backward jump to 0x004610b4
    jmp.d32 L_004610b4                           # 00461140
L_00461145:
    # block 0x00461145: entered by jge at 0x004610c7, 1 instruction(s), ends with backward jump to 0x0046108d
    jmp.d32 L_0046108d                           # 00461145
L_0046114a:
    # block 0x0046114a: entered by je at 0x0046107f; jge at 0x004610a6, 4 instruction(s), ends with je to 0x00461349 (forward)
    {load} xor edx, edx                          # 0046114a
    mov dl, byte ptr [0x61f754]                  # 0046114c
    test edx, edx                                # 00461152
    je.d32 L_00461349                            # 00461154
    # block 0x0046115a: entered by fall-through of je at 0x00461154, 4 instruction(s), ends with je to 0x00461295 (forward)
    {load} xor eax, eax                          # 0046115a
    mov al, byte ptr [0x61f75b]                  # 0046115c
    test eax, eax                                # 00461161
    je.d32 L_00461295                            # 00461163
    # block 0x00461169: entered by fall-through of je at 0x00461163, 4 instruction(s), ends with je to 0x0046117d (forward)
    {load} xor ecx, ecx                          # 00461169
    mov cl, byte ptr [0x61f759]                  # 0046116b
    test ecx, ecx                                # 00461171
    je.d8 L_0046117d                             # 00461173
    # block 0x00461175: entered by fall-through of je at 0x00461173, 2 instruction(s), ends with forward jump to 0x00461183
    mov word ptr [ebp - local_24], 0x1           # 00461175
    jmp.d8 L_00461183                            # 0046117b
L_0046117d:
    # block 0x0046117d: entered by je at 0x00461173, 1 instruction(s), falls into the block at 0x00461183
    mov word ptr [ebp - local_24], 0x0           # 0046117d
L_00461183:
    # block 0x00461183: entered by jmp at 0x0046117b, 4 instruction(s), ends with je to 0x004611e7 (forward)
    movsx edx, word ptr [ebp - local_24]         # 00461183
    movsx eax, word ptr [0x61f755]               # 00461187
    {load} cmp edx, eax                          # 0046118e
    je.d8 L_004611e7                             # 00461190
    # block 0x00461192: entered by fall-through of je at 0x00461190, 26 instruction(s), calls FUN_004d3a52, FUN_004c5377, falls into the block at 0x004611e7
    lea ecx, [ebp - local_1c]                    # 00461192
    push ecx                                     # 00461195
    movsx edx, word ptr [0x61f755]               # 00461196
    shl edx, 0x4                                 # 0046119d
    mov eax, dword ptr [ebp - local_20]          # 004611a0
    lea ecx, [eax + edx + field_4b]              # 004611a3
    push ecx                                     # 004611a7
    call FUN_004d3a52                            # 004611a8
    add esp, 0x8                                 # 004611ad
    push 0x54afc0                                # 004611b0
    lea edx, [ebp - local_1c]                    # 004611b5
    push edx                                     # 004611b8
    movsx eax, word ptr [0x61f755]               # 004611b9
    neg eax                                      # 004611c0
    {load} sbb eax, eax                          # 004611c2
    inc eax                                      # 004611c4
    shl eax, 0x4                                 # 004611c5
    mov ecx, dword ptr [ebp - local_20]          # 004611c8
    lea edx, [ecx + eax + field_4b]              # 004611cb
    push edx                                     # 004611cf
    mov eax, dword ptr [0x5cf665]                # 004611d0
    push eax                                     # 004611d5
    mov ecx, dword ptr [0x5d15e3]                # 004611d6
    push ecx                                     # 004611dc
    mov ecx, 0x5cf659                            # 004611dd
    call FUN_004c5377                            # 004611e2
L_004611e7:
    # block 0x004611e7: entered by je at 0x00461190, 12 instruction(s), calls FUN_004d3a52, ends with jne to 0x0046124a (forward)
    lea edx, [ebp - local_1c]                    # 004611e7
    push edx                                     # 004611ea
    movsx eax, word ptr [ebp - local_24]         # 004611eb
    shl eax, 0x4                                 # 004611ef
    mov ecx, dword ptr [ebp - local_20]          # 004611f2
    lea edx, [ecx + eax + field_4b]              # 004611f5
    push edx                                     # 004611f9
    call FUN_004d3a52                            # 004611fa
    add esp, 0x8                                 # 004611ff
    movsx eax, word ptr [0x61f782]               # 00461202
    test eax, eax                                # 00461209
    jne.d8 L_0046124a                            # 0046120b
    # block 0x0046120d: entered by fall-through of jne at 0x0046120b, 4 instruction(s), ends with jne to 0x0046124a (forward)
    {load} xor ecx, ecx                          # 0046120d
    mov cl, byte ptr [0x61f75a]                  # 0046120f
    test ecx, ecx                                # 00461215
    jne.d8 L_0046124a                            # 00461217
    # block 0x00461219: entered by fall-through of jne at 0x00461217, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00461290
    push 0x54afd0                                # 00461219
    lea edx, [ebp - local_1c]                    # 0046121e
    push edx                                     # 00461221
    movsx eax, word ptr [ebp - local_24]         # 00461222
    shl eax, 0x4                                 # 00461226
    mov ecx, dword ptr [ebp - local_20]          # 00461229
    lea edx, [ecx + eax + field_4b]              # 0046122c
    push edx                                     # 00461230
    mov eax, dword ptr [0x5cf665]                # 00461231
    push eax                                     # 00461236
    mov ecx, dword ptr [0x5d15e3]                # 00461237
    push ecx                                     # 0046123d
    mov ecx, 0x5cf659                            # 0046123e
    call FUN_004c5377                            # 00461243
    jmp.d8 L_00461290                            # 00461248
L_0046124a:
    # block 0x0046124a: entered by jne at 0x0046120b; jne at 0x00461217, 4 instruction(s), ends with jne to 0x00461290 (forward)
    {load} xor edx, edx                          # 0046124a
    mov dl, byte ptr [0x61f75a]                  # 0046124c
    test edx, edx                                # 00461252
    jne.d8 L_00461290                            # 00461254
    # block 0x00461256: entered by fall-through of jne at 0x00461254, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x00461290
    push 0x54afe0                                # 00461256
    lea eax, [ebp - local_1c]                    # 0046125b
    push eax                                     # 0046125e
    movsx ecx, word ptr [ebp - local_24]         # 0046125f
    shl ecx, 0x4                                 # 00461263
    mov edx, dword ptr [ebp - local_20]          # 00461266
    lea eax, [edx + ecx + field_2b]              # 00461269
    push eax                                     # 0046126d
    mov ecx, dword ptr [0x5cf665]                # 0046126e
    push ecx                                     # 00461274
    movsx edx, word ptr [0x61f4cd]               # 00461275
    imul edx, edx, 0x4a                          # 0046127c
    mov eax, dword ptr [edx + 0x5d1599]          # 0046127f
    push eax                                     # 00461285
    mov ecx, 0x5cf659                            # 00461286
    call FUN_004c5377                            # 0046128b
L_00461290:
    # block 0x00461290: entered by jmp at 0x00461248; jne at 0x00461254, 1 instruction(s), ends with forward jump to 0x00461349
    jmp.d32 L_00461349                           # 00461290
L_00461295:
    # block 0x00461295: entered by je at 0x00461163, 54 instruction(s), calls FUN_004d3a52, FUN_004c5377, falls into the block at 0x00461349
    lea ecx, [ebp - local_1c]                    # 00461295
    push ecx                                     # 00461298
    movsx edx, word ptr [0x61f755]               # 00461299
    shl edx, 0x4                                 # 004612a0
    mov eax, dword ptr [ebp - local_20]          # 004612a3
    lea ecx, [eax + edx + field_4b]              # 004612a6
    push ecx                                     # 004612aa
    call FUN_004d3a52                            # 004612ab
    add esp, 0x8                                 # 004612b0
    push 0x54aff0                                # 004612b3
    lea edx, [ebp - local_1c]                    # 004612b8
    push edx                                     # 004612bb
    movsx eax, word ptr [0x61f755]               # 004612bc
    shl eax, 0x4                                 # 004612c3
    mov ecx, dword ptr [ebp - local_20]          # 004612c6
    lea edx, [ecx + eax + field_2b]              # 004612c9
    push edx                                     # 004612cd
    mov eax, dword ptr [0x5cf665]                # 004612ce
    push eax                                     # 004612d3
    movsx ecx, word ptr [0x61f4cd]               # 004612d4
    imul ecx, ecx, 0x4a                          # 004612db
    mov edx, dword ptr [ecx + 0x5d1599]          # 004612de
    push edx                                     # 004612e4
    mov ecx, 0x5cf659                            # 004612e5
    call FUN_004c5377                            # 004612ea
    lea eax, [ebp - local_1c]                    # 004612ef
    push eax                                     # 004612f2
    movsx ecx, word ptr [0x61f755]               # 004612f3
    neg ecx                                      # 004612fa
    {load} sbb ecx, ecx                          # 004612fc
    inc ecx                                      # 004612fe
    shl ecx, 0x4                                 # 004612ff
    mov edx, dword ptr [ebp - local_20]          # 00461302
    lea eax, [edx + ecx + field_4b]              # 00461305
    push eax                                     # 00461309
    call FUN_004d3a52                            # 0046130a
    add esp, 0x8                                 # 0046130f
    push 0x54b000                                # 00461312
    lea ecx, [ebp - local_1c]                    # 00461317
    push ecx                                     # 0046131a
    movsx edx, word ptr [0x61f755]               # 0046131b
    neg edx                                      # 00461322
    {load} sbb edx, edx                          # 00461324
    inc edx                                      # 00461326
    shl edx, 0x4                                 # 00461327
    mov eax, dword ptr [ebp - local_20]          # 0046132a
    lea ecx, [eax + edx + field_4b]              # 0046132d
    push ecx                                     # 00461331
    mov edx, dword ptr [0x5cf665]                # 00461332
    push edx                                     # 00461338
    mov eax, dword ptr [0x5d15e3]                # 00461339
    push eax                                     # 0046133e
    mov ecx, 0x5cf659                            # 0046133f
    call FUN_004c5377                            # 00461344
L_00461349:
    # block 0x00461349: entered by je at 0x00461154; jmp at 0x00461290, 4 instruction(s), ends with je to 0x004613b8 (forward)
    {load} xor ecx, ecx                          # 00461349
    mov cl, byte ptr [0x61f74a]                  # 0046134b
    test ecx, ecx                                # 00461351
    je.d8 L_004613b8                             # 00461353
    # block 0x00461355: entered by fall-through of je at 0x00461353, 26 instruction(s), calls FUN_004d3a52, FUN_004c5377, ends with forward jump to 0x00461422
    lea edx, [ebp - local_1c]                    # 00461355
    push edx                                     # 00461358
    movsx eax, word ptr [0x61f74b]               # 00461359
    shl eax, 0x4                                 # 00461360
    mov ecx, dword ptr [ebp - local_20]          # 00461363
    lea edx, [ecx + eax + field_653]             # 00461366
    push edx                                     # 0046136d
    call FUN_004d3a52                            # 0046136e
    add esp, 0x8                                 # 00461373
    push 0x54b010                                # 00461376
    lea eax, [ebp - local_1c]                    # 0046137b
    push eax                                     # 0046137e
    movsx ecx, word ptr [0x61f74b]               # 0046137f
    shl ecx, 0x4                                 # 00461386
    mov edx, dword ptr [ebp - local_20]          # 00461389
    lea eax, [edx + ecx + field_3ab]             # 0046138c
    push eax                                     # 00461393
    mov ecx, dword ptr [0x5cf665]                # 00461394
    push ecx                                     # 0046139a
    movsx edx, word ptr [0x61f4cd]               # 0046139b
    imul edx, edx, 0x4a                          # 004613a2
    mov eax, dword ptr [edx + 0x5d1599]          # 004613a5
    push eax                                     # 004613ab
    mov ecx, 0x5cf659                            # 004613ac
    call FUN_004c5377                            # 004613b1
    jmp.d8 L_00461422                            # 004613b6
L_004613b8:
    # block 0x004613b8: entered by je at 0x00461353, 4 instruction(s), ends with je to 0x00461422 (forward)
    {load} xor ecx, ecx                          # 004613b8
    mov cl, byte ptr [0x61f749]                  # 004613ba
    test ecx, ecx                                # 004613c0
    je.d8 L_00461422                             # 004613c2
    # block 0x004613c4: entered by fall-through of je at 0x004613c2, 24 instruction(s), calls FUN_004d3a52, FUN_004c5377, falls into the block at 0x00461422
    lea edx, [ebp - local_1c]                    # 004613c4
    push edx                                     # 004613c7
    movsx eax, word ptr [0x61f74b]               # 004613c8
    shl eax, 0x4                                 # 004613cf
    mov ecx, dword ptr [ebp - local_20]          # 004613d2
    lea edx, [ecx + eax + field_653]             # 004613d5
    push edx                                     # 004613dc
    call FUN_004d3a52                            # 004613dd
    add esp, 0x8                                 # 004613e2
    push 0x54b01c                                # 004613e5
    lea eax, [ebp - local_1c]                    # 004613ea
    push eax                                     # 004613ed
    movsx ecx, word ptr [0x61f74b]               # 004613ee
    shl ecx, 0x4                                 # 004613f5
    mov edx, dword ptr [ebp - local_20]          # 004613f8
    lea eax, [edx + ecx + field_653]             # 004613fb
    push eax                                     # 00461402
    mov ecx, dword ptr [0x5cf665]                # 00461403
    push ecx                                     # 00461409
    mov edx, dword ptr [0x5d15e3]                # 0046140a
    push edx                                     # 00461410
    mov ecx, 0x5cf659                            # 00461411
    call FUN_004c5377                            # 00461416
    mov byte ptr [0x61f749], 0x0                 # 0046141b
L_00461422:
    # block 0x00461422: entered by jmp at 0x004613b6; je at 0x004613c2, 4 instruction(s), ends with je to 0x00461490 (forward)
    {load} xor eax, eax                          # 00461422
    mov al, byte ptr [0x61f74d]                  # 00461424
    test eax, eax                                # 00461429
    je.d8 L_00461490                             # 0046142b
    # block 0x0046142d: entered by fall-through of je at 0x0046142b, 3 instruction(s), ends with je to 0x00461490 (forward)
    movsx ecx, word ptr [0x61f780]               # 0046142d
    cmp ecx, -0x1                                # 00461434
    je.d8 L_00461490                             # 00461437
    # block 0x00461439: entered by fall-through of je at 0x00461437, 24 instruction(s), calls FUN_004d3a52, FUN_004c5d4b, ends with forward jump to 0x004614f1
    lea edx, [ebp - local_1c]                    # 00461439
    push edx                                     # 0046143c
    mov eax, dword ptr [ebp - local_20]          # 0046143d
    add eax, 0xa8b                               # 00461440
    push eax                                     # 00461445
    call FUN_004d3a52                            # 00461446
    add esp, 0x8                                 # 0046144b
    push 0x54b030                                # 0046144e
    lea ecx, [ebp - local_1c]                    # 00461453
    push ecx                                     # 00461456
    movsx edx, word ptr [0x61f750]               # 00461457
    shl edx, 0x4                                 # 0046145e
    mov eax, dword ptr [ebp - local_20]          # 00461461
    lea ecx, [eax + edx + field_99b]             # 00461464
    push ecx                                     # 0046146b
    mov edx, dword ptr [0x5cf665]                # 0046146c
    push edx                                     # 00461472
    movsx eax, word ptr [0x61f4cd]               # 00461473
    imul eax, eax, 0x4a                          # 0046147a
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046147d
    push ecx                                     # 00461483
    mov ecx, 0x5cf659                            # 00461484
    call FUN_004c5d4b                            # 00461489
    jmp.d8 L_004614f1                            # 0046148e
L_00461490:
    # block 0x00461490: entered by je at 0x0046142b; je at 0x00461437, 4 instruction(s), ends with je to 0x004614f1 (forward)
    {load} xor edx, edx                          # 00461490
    mov dl, byte ptr [0x61f74e]                  # 00461492
    test edx, edx                                # 00461498
    je.d8 L_004614f1                             # 0046149a
    # block 0x0046149c: entered by fall-through of je at 0x0046149a, 23 instruction(s), calls FUN_004d3a52, FUN_004c5d4b, falls into the block at 0x004614f1
    lea eax, [ebp - local_1c]                    # 0046149c
    push eax                                     # 0046149f
    mov ecx, dword ptr [ebp - local_20]          # 004614a0
    add ecx, 0xb93                               # 004614a3
    push ecx                                     # 004614a9
    call FUN_004d3a52                            # 004614aa
    add esp, 0x8                                 # 004614af
    push 0x54b04c                                # 004614b2
    lea edx, [ebp - local_1c]                    # 004614b7
    push edx                                     # 004614ba
    movsx eax, word ptr [0x61f750]               # 004614bb
    shl eax, 0x4                                 # 004614c2
    mov ecx, dword ptr [ebp - local_20]          # 004614c5
    lea edx, [ecx + eax + field_aa3]             # 004614c8
    push edx                                     # 004614cf
    mov eax, dword ptr [0x5cf665]                # 004614d0
    push eax                                     # 004614d5
    movsx ecx, word ptr [0x61f4cd]               # 004614d6
    imul ecx, ecx, 0x4a                          # 004614dd
    mov edx, dword ptr [ecx + 0x5d1599]          # 004614e0
    push edx                                     # 004614e6
    mov ecx, 0x5cf659                            # 004614e7
    call FUN_004c5d4b                            # 004614ec
L_004614f1:
    # block 0x004614f1: entered by jmp at 0x0046148e; je at 0x0046149a, 4 instruction(s), ends with je to 0x00461587 (forward)
    {load} xor eax, eax                          # 004614f1
    mov al, byte ptr [0x61f74f]                  # 004614f3
    test eax, eax                                # 004614f8
    je.d32 L_00461587                            # 004614fa
    # block 0x00461500: entered by fall-through of je at 0x004614fa, 39 instruction(s), calls FUN_004d3a52, FUN_004c5377, falls into the block at 0x00461587
    lea ecx, [ebp - local_1c]                    # 00461500
    push ecx                                     # 00461503
    mov edx, dword ptr [ebp - local_20]          # 00461504
    add edx, 0xa8b                               # 00461507
    push edx                                     # 0046150d
    call FUN_004d3a52                            # 0046150e
    add esp, 0x8                                 # 00461513
    push 0x54b068                                # 00461516
    lea eax, [ebp - local_1c]                    # 0046151b
    push eax                                     # 0046151e
    mov ecx, dword ptr [ebp - local_20]          # 0046151f
    add ecx, 0xa8b                               # 00461522
    push ecx                                     # 00461528
    mov edx, dword ptr [0x5cf665]                # 00461529
    push edx                                     # 0046152f
    mov eax, dword ptr [0x5d15e3]                # 00461530
    push eax                                     # 00461535
    mov ecx, 0x5cf659                            # 00461536
    call FUN_004c5377                            # 0046153b
    lea ecx, [ebp - local_1c]                    # 00461540
    push ecx                                     # 00461543
    mov edx, dword ptr [ebp - local_20]          # 00461544
    add edx, 0xb93                               # 00461547
    push edx                                     # 0046154d
    call FUN_004d3a52                            # 0046154e
    add esp, 0x8                                 # 00461553
    push 0x54b07c                                # 00461556
    lea eax, [ebp - local_1c]                    # 0046155b
    push eax                                     # 0046155e
    mov ecx, dword ptr [ebp - local_20]          # 0046155f
    add ecx, 0xb93                               # 00461562
    push ecx                                     # 00461568
    mov edx, dword ptr [0x5cf665]                # 00461569
    push edx                                     # 0046156f
    mov eax, dword ptr [0x5d15e3]                # 00461570
    push eax                                     # 00461575
    mov ecx, 0x5cf659                            # 00461576
    call FUN_004c5377                            # 0046157b
    mov byte ptr [0x61f74f], 0x0                 # 00461580
L_00461587:
    # block 0x00461587: entered by je at 0x004614fa, 3 instruction(s), ends with je to 0x004615ea (forward)
    movsx ecx, word ptr [0x61f786]               # 00461587
    cmp ecx, -0x1                                # 0046158e
    je.d8 L_004615ea                             # 00461591
    # block 0x00461593: entered by fall-through of je at 0x00461591, 23 instruction(s), calls FUN_004d3a52, FUN_004c5d4b, falls into the block at 0x004615ea
    lea edx, [ebp - local_1c]                    # 00461593
    push edx                                     # 00461596
    movsx eax, word ptr [0x61f788]               # 00461597
    shl eax, 0x4                                 # 0046159e
    add eax, 0x61f78e                            # 004615a1
    push eax                                     # 004615a6
    call FUN_004d3a52                            # 004615a7
    add esp, 0x8                                 # 004615ac
    push 0x54b090                                # 004615af
    lea ecx, [ebp - local_1c]                    # 004615b4
    push ecx                                     # 004615b7
    movsx edx, word ptr [0x61f788]               # 004615b8
    shl edx, 0x4                                 # 004615bf
    add edx, 0x61f7ae                            # 004615c2
    push edx                                     # 004615c8
    mov eax, dword ptr [0x5cf665]                # 004615c9
    push eax                                     # 004615ce
    movsx ecx, word ptr [0x61f4cd]               # 004615cf
    imul ecx, ecx, 0x4a                          # 004615d6
    mov edx, dword ptr [ecx + 0x5d1599]          # 004615d9
    push edx                                     # 004615df
    mov ecx, 0x5cf659                            # 004615e0
    call FUN_004c5d4b                            # 004615e5
L_004615ea:
    # block 0x004615ea: entered by je at 0x00461591, 4 instruction(s), ends with je to 0x00461704 (forward)
    {load} xor eax, eax                          # 004615ea
    mov al, byte ptr [0x61f753]                  # 004615ec
    test eax, eax                                # 004615f1
    je.d32 L_00461704                            # 004615f3
    # block 0x004615f9: entered by fall-through of je at 0x004615f3, 4 instruction(s), ends with je to 0x00461681 (forward)
    {load} xor ecx, ecx                          # 004615f9
    mov cl, byte ptr [0x61f75c]                  # 004615fb
    test ecx, ecx                                # 00461601
    je.d8 L_00461681                             # 00461603
    # block 0x00461605: entered by fall-through of je at 0x00461603, 2 instruction(s), ends with forward jump to 0x00461619
    mov word ptr [ebp - local_c], 0x0            # 00461605
    jmp.d8 L_00461619                            # 0046160b
L_0046160d:
    # block 0x0046160d: entered by jmp at 0x0046167f, 3 instruction(s), falls into the block at 0x00461619
    mov dx, word ptr [ebp - local_c]             # 0046160d
    add dx, 0x1                                  # 00461611
    mov word ptr [ebp - local_c], dx             # 00461615
L_00461619:
    # block 0x00461619: entered by jmp at 0x0046160b, 4 instruction(s), ends with jg to 0x00461681 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00461619
    movsx ecx, word ptr [0x61f77e]               # 0046161d
    {load} cmp eax, ecx                          # 00461624
    jg.d8 L_00461681                             # 00461626
    # block 0x00461628: entered by fall-through of jg at 0x00461626, 25 instruction(s), calls FUN_004d3a52, FUN_004c5377, ends with backward jump to 0x0046160d
    lea edx, [ebp - local_1c]                    # 00461628
    push edx                                     # 0046162b
    movsx eax, word ptr [ebp - local_c]          # 0046162c
    shl eax, 0x4                                 # 00461630
    mov ecx, dword ptr [ebp - local_20]          # 00461633
    lea edx, [ecx + eax + field_633]             # 00461636
    push edx                                     # 0046163d
    call FUN_004d3a52                            # 0046163e
    add esp, 0x8                                 # 00461643
    push 0x54b0a8                                # 00461646
    lea eax, [ebp - local_1c]                    # 0046164b
    push eax                                     # 0046164e
    movsx ecx, word ptr [ebp - local_c]          # 0046164f
    shl ecx, 0x4                                 # 00461653
    add ecx, 0x61f75e                            # 00461656
    push ecx                                     # 0046165c
    mov edx, dword ptr [0x5cf665]                # 0046165d
    push edx                                     # 00461663
    movsx eax, word ptr [0x61f4cd]               # 00461664
    imul eax, eax, 0x4a                          # 0046166b
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046166e
    push ecx                                     # 00461674
    mov ecx, 0x5cf659                            # 00461675
    call FUN_004c5377                            # 0046167a
    jmp.d8 L_0046160d                            # 0046167f
L_00461681:
    # block 0x00461681: entered by je at 0x00461603; jg at 0x00461626, 4 instruction(s), ends with je to 0x00461704 (forward)
    {load} xor edx, edx                          # 00461681
    mov dl, byte ptr [0x61f75d]                  # 00461683
    test edx, edx                                # 00461689
    je.d8 L_00461704                             # 0046168b
    # block 0x0046168d: entered by fall-through of je at 0x0046168b, 2 instruction(s), ends with forward jump to 0x004616a1
    mov word ptr [ebp - local_c], 0x0            # 0046168d
    jmp.d8 L_004616a1                            # 00461693
L_00461695:
    # block 0x00461695: entered by jmp at 0x00461702, 3 instruction(s), falls into the block at 0x004616a1
    mov ax, word ptr [ebp - local_c]             # 00461695
    .insn 0x66, 0x05, 0x0001{:u16}               # 00461699
    mov word ptr [ebp - local_c], ax             # 0046169d
L_004616a1:
    # block 0x004616a1: entered by jmp at 0x00461693, 3 instruction(s), ends with jg to 0x00461704 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004616a1
    cmp ecx, 0x1                                 # 004616a5
    jg.d8 L_00461704                             # 004616a8
    # block 0x004616aa: entered by fall-through of jg at 0x004616a8, 25 instruction(s), calls FUN_004d3a52, FUN_004c5377, ends with backward jump to 0x00461695
    lea edx, [ebp - local_1c]                    # 004616aa
    push edx                                     # 004616ad
    movsx eax, word ptr [ebp - local_c]          # 004616ae
    shl eax, 0x4                                 # 004616b2
    mov ecx, dword ptr [ebp - local_20]          # 004616b5
    lea edx, [ecx + eax + field_633]             # 004616b8
    push edx                                     # 004616bf
    call FUN_004d3a52                            # 004616c0
    add esp, 0x8                                 # 004616c5
    push 0x54b0b8                                # 004616c8
    lea eax, [ebp - local_1c]                    # 004616cd
    push eax                                     # 004616d0
    movsx ecx, word ptr [ebp - local_c]          # 004616d1
    shl ecx, 0x4                                 # 004616d5
    mov edx, dword ptr [ebp - local_20]          # 004616d8
    lea eax, [edx + ecx + field_633]             # 004616db
    push eax                                     # 004616e2
    mov ecx, dword ptr [0x5cf665]                # 004616e3
    push ecx                                     # 004616e9
    mov edx, dword ptr [0x5d15e3]                # 004616ea
    push edx                                     # 004616f0
    mov ecx, 0x5cf659                            # 004616f1
    call FUN_004c5377                            # 004616f6
    mov byte ptr [0x61f75d], 0x0                 # 004616fb
    jmp.d8 L_00461695                            # 00461702
L_00461704:
    # block 0x00461704: entered by je at 0x004615f3; je at 0x0046168b; jg at 0x004616a8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00461704
    pop ebp                                      # 00461706
    ret                                          # 00461707

# --- data items (not part of the function) -------------------------
.org 0x00461708 - 0x401000
PAD_00461708:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

