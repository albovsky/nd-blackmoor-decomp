# FUN_004b617a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b617a
# extent:       0x004b617a-0x004b6355 (475 code bytes)
# span:         0x004b617a-0x004b6355 (code 475, tables 0, padding 0)
# sha256:       8fbbf29fc408c2ecc47c6b647f72e8e8c01301b3825e1c08362be2d4ff36f4cb
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b617a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_225, field_229, field_22c, field_232, field_274, field_2fa; [ecx + n] field_1e, field_22a, field_232, field_252, field_254; [edx + n] field_21, field_230, field_252
# callees:      calls FUN_004f6334, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 115 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_225, 0x225  # offset +0x225
.equ field_229, 0x229  # offset +0x229
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22c, 0x22c  # offset +0x22c
.equ field_230, 0x230  # offset +0x230
.equ field_232, 0x232  # offset +0x232
.equ field_252, 0x252  # offset +0x252
.equ field_254, 0x254  # offset +0x254
.equ field_274, 0x274  # offset +0x274
.equ field_2fa, 0x2fa  # offset +0x2fa

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004b617a - 0x401000
.globl FUN_004b617a
FUN_004b617a:
    # block 0x004b617a: entry, 14 instruction(s), ends with je to 0x004b634f (forward)
    push ebp                                     # 004b617a
    {load} mov ebp, esp                          # 004b617b
    sub esp, 0x10                                # 004b617d
    push esi                                     # 004b6180
    push edi                                     # 004b6181
    mov dword ptr [ebp - local_10], ecx          # 004b6182
    mov eax, dword ptr [ebp - local_10]          # 004b6185
    movsx ecx, word ptr [eax + field_1e]         # 004b6188
    imul ecx, ecx, 0x8d                          # 004b618c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b6192
    mov dword ptr [ebp - local_8], edx           # 004b6198
    mov eax, dword ptr [ebp - local_10]          # 004b619b
    cmp dword ptr [eax + field_225], 0x0         # 004b619e
    je.d32 L_004b634f                            # 004b61a5
    # block 0x004b61ab: entered by fall-through of je at 0x004b61a5, 5 instruction(s), ends with jne to 0x004b634f (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004b61ab
    {load} xor edx, edx                          # 004b61ae
    mov dl, byte ptr [ecx + field_22a]           # 004b61b0
    test edx, edx                                # 004b61b6
    jne.d32 L_004b634f                           # 004b61b8
    # block 0x004b61be: entered by fall-through of jne at 0x004b61b8, 3 instruction(s), ends with jne to 0x004b634f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004b61be
    cmp dword ptr [eax + field_274], 0x0         # 004b61c1
    jne.d32 L_004b634f                           # 004b61c8
    # block 0x004b61ce: entered by fall-through of jne at 0x004b61c8, 5 instruction(s), ends with jne to 0x004b634f (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004b61ce
    movsx edx, word ptr [ecx + field_1e]         # 004b61d1
    imul edx, edx, 0x8d                          # 004b61d5
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004b61db
    jne.d32 L_004b634f                           # 004b61e2
    # block 0x004b61e8: entered by fall-through of jne at 0x004b61e2, 2 instruction(s), ends with jne to 0x004b621a (forward)
    cmp dword ptr [0x5c39e5], 0x276d             # 004b61e8
    jne.d8 L_004b621a                            # 004b61f2
    # block 0x004b61f4: entered by fall-through of jne at 0x004b61f2, 7 instruction(s), ends with forward jump to 0x004b634f
    mov eax, dword ptr [ebp - local_10]          # 004b61f4
    mov byte ptr [eax + field_229], 0x1          # 004b61f7
    mov ecx, dword ptr [ebp - local_10]          # 004b61fe
    movsx edx, word ptr [ecx + field_1e]         # 004b6201
    imul edx, edx, 0x8d                          # 004b6205
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b620b
    jmp.d32 L_004b634f                           # 004b6215
L_004b621a:
    # block 0x004b621a: entered by jne at 0x004b61f2, 2 instruction(s), ends with jne to 0x004b634f (forward)
    cmp dword ptr [0x5c39e5], 0x276c             # 004b621a
    jne.d32 L_004b634f                           # 004b6224
    # block 0x004b622a: entered by fall-through of jne at 0x004b6224, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b634f (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b622a
    movsx ecx, word ptr [eax + field_2fa]        # 004b622d
    mov dword ptr [ebp - local_c], ecx           # 004b6234
    mov edx, dword ptr [ebp - local_c]           # 004b6237
    push edx                                     # 004b623a
    mov ecx, 0x5cf1eb                            # 004b623b
    call FUN_004f6334                            # 004b6240
    test eax, eax                                # 004b6245
    jne.d32 L_004b634f                           # 004b6247
    # block 0x004b624d: entered by fall-through of jne at 0x004b6247, 4 instruction(s), ends with forward jump to 0x004b626c
    mov eax, dword ptr [ebp - local_10]          # 004b624d
    mov dword ptr [eax + field_274], 0x2         # 004b6250
    mov dword ptr [ebp - local_4], 0x0           # 004b625a
    jmp.d8 L_004b626c                            # 004b6261
L_004b6263:
    # block 0x004b6263: entered by jmp at 0x004b62a9, 3 instruction(s), falls into the block at 0x004b626c
    mov ecx, dword ptr [ebp - local_4]           # 004b6263
    add ecx, 0x1                                 # 004b6266
    mov dword ptr [ebp - local_4], ecx           # 004b6269
L_004b626c:
    # block 0x004b626c: entered by jmp at 0x004b6261, 4 instruction(s), ends with jge to 0x004b62ab (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b626c
    movsx eax, word ptr [edx + field_21]         # 004b626f
    cmp dword ptr [ebp - local_4], eax           # 004b6273
    jge.d8 L_004b62ab                            # 004b6276
    # block 0x004b6278: entered by fall-through of jge at 0x004b6276, 4 instruction(s), ends with jne to 0x004b6299 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004b6278
    movsx edx, word ptr [ecx + field_252]        # 004b627b
    cmp dword ptr [ebp - local_4], edx           # 004b6282
    jne.d8 L_004b6299                            # 004b6285
    # block 0x004b6287: entered by fall-through of jne at 0x004b6285, 4 instruction(s), ends with forward jump to 0x004b62a9
    mov eax, dword ptr [ebp - local_4]           # 004b6287
    mov ecx, dword ptr [ebp - local_10]          # 004b628a
    mov word ptr [ecx + 2*eax + field_232], 0x1  # 004b628d
    jmp.d8 L_004b62a9                            # 004b6297
L_004b6299:
    # block 0x004b6299: entered by jne at 0x004b6285, 3 instruction(s), falls into the block at 0x004b62a9
    mov edx, dword ptr [ebp - local_4]           # 004b6299
    mov eax, dword ptr [ebp - local_10]          # 004b629c
    mov word ptr [eax + 2*edx + field_232], 0x0  # 004b629f
L_004b62a9:
    # block 0x004b62a9: entered by jmp at 0x004b6297, 1 instruction(s), ends with backward jump to 0x004b6263
    jmp.d8 L_004b6263                            # 004b62a9
L_004b62ab:
    # block 0x004b62ab: entered by jge at 0x004b6276, 2 instruction(s), ends with forward jump to 0x004b62bd
    mov dword ptr [ebp - local_4], 0x0           # 004b62ab
    jmp.d8 L_004b62bd                            # 004b62b2
L_004b62b4:
    # block 0x004b62b4: entered by jmp at 0x004b630a, 3 instruction(s), falls into the block at 0x004b62bd
    mov ecx, dword ptr [ebp - local_4]           # 004b62b4
    add ecx, 0x1                                 # 004b62b7
    mov dword ptr [ebp - local_4], ecx           # 004b62ba
L_004b62bd:
    # block 0x004b62bd: entered by jmp at 0x004b62b2, 2 instruction(s), ends with jge to 0x004b630c (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 004b62bd
    jge.d8 L_004b630c                            # 004b62c1
    # block 0x004b62c3: entered by fall-through of jge at 0x004b62c1, 8 instruction(s), ends with je to 0x004b630a (forward)
    mov edx, dword ptr [ebp - local_10]          # 004b62c3
    movsx eax, word ptr [edx + field_252]        # 004b62c6
    mov ecx, dword ptr [ebp - local_8]           # 004b62cd
    lea edx, [ecx + 8*eax + field_254]           # 004b62d0
    mov eax, dword ptr [ebp - local_4]           # 004b62d7
    movsx ecx, word ptr [edx + 2*eax]            # 004b62da
    test ecx, ecx                                # 004b62de
    je.d8 L_004b630a                             # 004b62e0
    # block 0x004b62e2: entered by fall-through of je at 0x004b62e0, 8 instruction(s), falls into the block at 0x004b630a
    mov edx, dword ptr [ebp - local_10]          # 004b62e2
    movsx eax, word ptr [edx + field_252]        # 004b62e5
    mov ecx, dword ptr [ebp - local_8]           # 004b62ec
    lea edx, [ecx + 8*eax + field_254]           # 004b62ef
    mov eax, dword ptr [ebp - local_4]           # 004b62f6
    movsx ecx, word ptr [edx + 2*eax]            # 004b62f9
    mov edx, dword ptr [ebp - local_10]          # 004b62fd
    mov word ptr [edx + 2*ecx + field_230], 0x1  # 004b6300
L_004b630a:
    # block 0x004b630a: entered by je at 0x004b62e0, 1 instruction(s), ends with backward jump to 0x004b62b4
    jmp.d8 L_004b62b4                            # 004b630a
L_004b630c:
    # block 0x004b630c: entered by jge at 0x004b62c1, 4 instruction(s), ends with je to 0x004b634f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004b630c
    mov word ptr [eax + field_22c], 0x1          # 004b630f
    cmp dword ptr [0x5bb1ca], 0x0                # 004b6318
    je.d8 L_004b634f                             # 004b631f
    # block 0x004b6321: entered by fall-through of je at 0x004b631f, 7 instruction(s), ends with je to 0x004b634f (forward)
    mov edi, 0x551b18                            # 004b6321
    mov esi, dword ptr [ebp - local_8]           # 004b6326
    add esi, 0x2d9                               # 004b6329
    mov ecx, 0x9                                 # 004b632f
    {load} xor edx, edx                          # 004b6334
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b6336
    je.d8 L_004b634f                             # 004b6338
    # block 0x004b633a: entered by fall-through of je at 0x004b6338, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b634f
    mov eax, dword ptr [ebp - local_8]           # 004b633a
    mov cx, word ptr [eax + field_2fa]           # 004b633d
    push ecx                                     # 004b6344
    mov ecx, 0x5c3a67                            # 004b6345
    call FUN_004fb2e3                            # 004b634a
L_004b634f:
    # block 0x004b634f: entered by je at 0x004b61a5; jne at 0x004b61b8; jne at 0x004b61c8; jne at 0x004b61e2; more, 5 instruction(s), ends with ret
    pop edi                                      # 004b634f
    pop esi                                      # 004b6350
    {load} mov esp, ebp                          # 004b6351
    pop ebp                                      # 004b6353
    ret                                          # 004b6354

