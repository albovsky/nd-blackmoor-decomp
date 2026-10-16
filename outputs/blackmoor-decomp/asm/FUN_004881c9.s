# FUN_004881c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004881c9
# extent:       0x004881c9-0x00488319 (336 code bytes)
# span:         0x004881c9-0x00488319 (code 336, tables 0, padding 0)
# sha256:       376d92f7af67db8cb75a7df87e4cbe348a7eb8862ea63937ee3fb7f2caf7770e
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004881c9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_25, field_6a, field_6c; [ecx + n] field_24, field_25, field_70, field_7a, field_425, field_427, field_52e; [edx + n] field_4, field_8, field_c, field_21, field_25, field_425
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 96 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_7a, 0x7a  # offset +0x7a
.equ field_425, 0x425  # offset +0x425
.equ field_427, 0x427  # offset +0x427
.equ field_52e, 0x52e  # offset +0x52e

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004881c9 - 0x401000
.globl FUN_004881c9
FUN_004881c9:
    # block 0x004881c9: entry, 13 instruction(s), ends with forward jump to 0x004881fc
    push ebp                                     # 004881c9
    {load} mov ebp, esp                          # 004881ca
    sub esp, 0x10                                # 004881cc
    push esi                                     # 004881cf
    push edi                                     # 004881d0
    mov dword ptr [ebp - local_10], ecx          # 004881d1
    mov eax, dword ptr [ebp - local_10]          # 004881d4
    movsx ecx, word ptr [eax + field_1e]         # 004881d7
    imul ecx, ecx, 0x8d                          # 004881db
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004881e1
    mov dword ptr [ebp - local_4], edx           # 004881e7
    mov dword ptr [ebp - local_8], 0x0           # 004881ea
    jmp.d8 L_004881fc                            # 004881f1
L_004881f3:
    # block 0x004881f3: entered by jmp at 0x004882fd, 3 instruction(s), falls into the block at 0x004881fc
    mov eax, dword ptr [ebp - local_8]           # 004881f3
    add eax, 0x1                                 # 004881f6
    mov dword ptr [ebp - local_8], eax           # 004881f9
L_004881fc:
    # block 0x004881fc: entered by jmp at 0x004881f1, 4 instruction(s), ends with jge to 0x00488302 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004881fc
    movsx edx, word ptr [ecx + field_425]        # 004881ff
    cmp dword ptr [ebp - local_8], edx           # 00488206
    jge.d32 L_00488302                           # 00488209
    # block 0x0048820f: entered by fall-through of jge at 0x00488209, 8 instruction(s), ends with je to 0x004882fd (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048820f
    mov ecx, dword ptr [ebp - local_10]          # 00488212
    movsx edx, word ptr [ecx + 2*eax + field_7a] # 00488215
    mov eax, dword ptr [ebp - local_8]           # 0048821a
    mov ecx, dword ptr [ebp - local_4]           # 0048821d
    movsx eax, word ptr [ecx + 2*eax + field_427] # 00488220
    {load} cmp edx, eax                          # 00488228
    je.d32 L_004882fd                            # 0048822a
    # block 0x00488230: entered by fall-through of je at 0x0048822a, 5 instruction(s), ends with je to 0x004882fb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00488230
    {load} xor edx, edx                          # 00488233
    mov dl, byte ptr [ecx + field_24]            # 00488235
    test edx, edx                                # 00488238
    je.d32 L_004882fb                            # 0048823a
    # block 0x00488240: entered by fall-through of je at 0x0048823a, 6 instruction(s), ends with jne to 0x004882fb (forward)
    mov eax, dword ptr [ebp - local_10]          # 00488240
    movsx ecx, word ptr [eax + field_6a]         # 00488243
    mov edx, dword ptr [ebp - local_4]           # 00488247
    movsx eax, word ptr [edx + field_425]        # 0048824a
    {load} cmp ecx, eax                          # 00488251
    jne.d32 L_004882fb                           # 00488253
    # block 0x00488259: entered by fall-through of jne at 0x00488253, 2 instruction(s), ends with forward jump to 0x0048826b
    mov dword ptr [ebp - local_c], 0x0           # 00488259
    jmp.d8 L_0048826b                            # 00488260
L_00488262:
    # block 0x00488262: entered by jmp at 0x004882af, 3 instruction(s), falls into the block at 0x0048826b
    mov ecx, dword ptr [ebp - local_c]           # 00488262
    add ecx, 0x1                                 # 00488265
    mov dword ptr [ebp - local_c], ecx           # 00488268
L_0048826b:
    # block 0x0048826b: entered by jmp at 0x00488260, 4 instruction(s), ends with jge to 0x004882b1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048826b
    movsx eax, word ptr [edx + field_21]         # 0048826e
    cmp dword ptr [ebp - local_c], eax           # 00488272
    jge.d8 L_004882b1                            # 00488275
    # block 0x00488277: entered by fall-through of jge at 0x00488275, 4 instruction(s), ends with jne to 0x00488294 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00488277
    mov edx, dword ptr [ebp - local_10]          # 0048827a
    cmp dword ptr [edx + 4*ecx + field_25], 0x3  # 0048827d
    jne.d8 L_00488294                            # 00488282
    # block 0x00488284: entered by fall-through of jne at 0x00488282, 4 instruction(s), ends with forward jump to 0x004882af
    mov eax, dword ptr [ebp - local_c]           # 00488284
    mov ecx, dword ptr [ebp - local_10]          # 00488287
    mov dword ptr [ecx + 4*eax + field_25], 0x2  # 0048828a
    jmp.d8 L_004882af                            # 00488292
L_00488294:
    # block 0x00488294: entered by jne at 0x00488282, 4 instruction(s), ends with jne to 0x004882af (forward)
    mov edx, dword ptr [ebp - local_c]           # 00488294
    mov eax, dword ptr [ebp - local_10]          # 00488297
    cmp dword ptr [eax + 4*edx + field_25], 0x1  # 0048829a
    jne.d8 L_004882af                            # 0048829f
    # block 0x004882a1: entered by fall-through of jne at 0x0048829f, 3 instruction(s), falls into the block at 0x004882af
    mov ecx, dword ptr [ebp - local_c]           # 004882a1
    mov edx, dword ptr [ebp - local_10]          # 004882a4
    mov dword ptr [edx + 4*ecx + field_25], 0x0  # 004882a7
L_004882af:
    # block 0x004882af: entered by jmp at 0x00488292; jne at 0x0048829f, 1 instruction(s), ends with backward jump to 0x00488262
    jmp.d8 L_00488262                            # 004882af
L_004882b1:
    # block 0x004882b1: entered by jge at 0x00488275, 16 instruction(s), ends with je to 0x004882fb (forward)
    mov eax, dword ptr [ebp - local_10]          # 004882b1
    mov word ptr [eax + field_6a], 0x0           # 004882b4
    {load} xor ecx, ecx                          # 004882ba
    mov edx, dword ptr [ebp - local_10]          # 004882bc
    add edx, 0x7a                                # 004882bf
    mov dword ptr [edx], ecx                     # 004882c2
    mov dword ptr [edx + field_4], ecx           # 004882c4
    mov dword ptr [edx + field_8], ecx           # 004882c7
    mov dword ptr [edx + field_c], ecx           # 004882ca
    mov edi, 0x54de1c                            # 004882cd
    mov esi, dword ptr [ebp - local_4]           # 004882d2
    add esi, 0x50d                               # 004882d5
    mov ecx, 0x9                                 # 004882db
    {load} xor eax, eax                          # 004882e0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004882e2
    je.d8 L_004882fb                             # 004882e4
    # block 0x004882e6: entered by fall-through of je at 0x004882e4, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004882fb
    mov ecx, dword ptr [ebp - local_4]           # 004882e6
    mov dx, word ptr [ecx + field_52e]           # 004882e9
    push edx                                     # 004882f0
    mov ecx, 0x5c3a67                            # 004882f1
    call FUN_004fb2e3                            # 004882f6
L_004882fb:
    # block 0x004882fb: entered by je at 0x0048823a; jne at 0x00488253; je at 0x004882e4, 1 instruction(s), ends with forward jump to 0x00488313
    jmp.d8 L_00488313                            # 004882fb
L_004882fd:
    # block 0x004882fd: entered by je at 0x0048822a, 1 instruction(s), ends with backward jump to 0x004881f3
    jmp.d32 L_004881f3                           # 004882fd
L_00488302:
    # block 0x00488302: entered by jge at 0x00488209, 4 instruction(s), falls into the block at 0x00488313
    mov eax, dword ptr [ebp - local_10]          # 00488302
    mov dword ptr [eax + field_6c], 0x2          # 00488305
    mov ecx, dword ptr [ebp - local_10]          # 0048830c
    mov byte ptr [ecx + field_70], 0x1           # 0048830f
L_00488313:
    # block 0x00488313: entered by jmp at 0x004882fb, 5 instruction(s), ends with ret
    pop edi                                      # 00488313
    pop esi                                      # 00488314
    {load} mov esp, ebp                          # 00488315
    pop ebp                                      # 00488317
    ret                                          # 00488318

