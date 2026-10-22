# FUN_004752cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004752cd
# extent:       0x004752cd-0x00475470 (419 code bytes)
# span:         0x004752cd-0x00475470 (code 419, tables 0, padding 0)
# sha256:       30a953183c2397bd9bae4b7a1e79bfb403625561da95038c580260ab13b33c1f
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004752cd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_6c, local_70
# fields:       [eax + n] field_76, field_351; [ecx + n] field_76; [edi + n] field_4, field_6; [edx + n] field_76, field_393
# callees:      calls FUN_004fb2e3, FUN_00423259, FUN_00448d11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 134 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_76, 0x76  # offset +0x76
.equ field_351, 0x351  # offset +0x351
.equ field_393, 0x393  # offset +0x393

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004752cd - 0x401000
.globl FUN_004752cd
FUN_004752cd:
    # block 0x004752cd: entry, 10 instruction(s), ends with jne to 0x004752f0 (forward)
    push ebp                                     # 004752cd
    {load} mov ebp, esp                          # 004752ce
    sub esp, 0x70                                # 004752d0
    push esi                                     # 004752d3
    push edi                                     # 004752d4
    mov dword ptr [ebp - local_70], ecx          # 004752d5
    mov dword ptr [ebp - local_4], 0x0           # 004752d8
    mov eax, dword ptr [ebp - local_70]          # 004752df
    cmp dword ptr [eax + field_351], 0x0         # 004752e2
    jne.d8 L_004752f0                            # 004752e9
    # block 0x004752eb: entered by fall-through of jne at 0x004752e9, 1 instruction(s), ends with forward jump to 0x0047546a
    jmp.d32 L_0047546a                           # 004752eb
L_004752f0:
    # block 0x004752f0: entered by jne at 0x004752e9, 8 instruction(s), calls FUN_004fb2e3, ends with je to 0x0047546a (forward)
    mov ecx, dword ptr [ebp - local_70]          # 004752f0
    mov edx, dword ptr [ecx + field_76]          # 004752f3
    mov ax, word ptr [edx + field_393]           # 004752f6
    push eax                                     # 004752fd
    mov ecx, 0x5c3a67                            # 004752fe
    call FUN_004fb2e3                            # 00475303
    cmp dword ptr [0x5bb202], 0x0                # 00475308
    je.d32 L_0047546a                            # 0047530f
    # block 0x00475315: entered by fall-through of je at 0x0047530f, 10 instruction(s), ends with jbe to 0x004753d5 (forward)
    mov ecx, dword ptr [ebp - local_70]          # 00475315
    mov edi, dword ptr [ecx + field_76]          # 00475318
    add edi, 0x2ed                               # 0047531b
    or ecx, -0x1                                 # 00475321
    {load} xor eax, eax                          # 00475324
    repne scasb al, byte ptr es:[edi]            # 00475326
    not ecx                                      # 00475328
    add ecx, -0x1                                # 0047532a
    test ecx, ecx                                # 0047532d
    jbe.d32 L_004753d5                           # 0047532f
    # block 0x00475335: entered by fall-through of jbe at 0x0047532f, 9 instruction(s), calls FUN_00423259, ends with je to 0x004753ce (forward)
    mov edx, dword ptr [ebp - local_70]          # 00475335
    mov eax, dword ptr [edx + field_76]          # 00475338
    add eax, 0x3a3                               # 0047533b
    push eax                                     # 00475340
    mov ecx, 0x619a6b                            # 00475341
    call FUN_00423259                            # 00475346
    mov dword ptr [ebp - local_4], eax           # 0047534b
    cmp dword ptr [ebp - local_4], 0x0           # 0047534e
    je.d8 L_004753ce                             # 00475352
    # block 0x00475354: entered by fall-through of je at 0x00475352, 8 instruction(s), ends with ja to 0x004753ce (forward)
    mov edi, dword ptr [ebp - local_4]           # 00475354
    or ecx, -0x1                                 # 00475357
    {load} xor eax, eax                          # 0047535a
    repne scasb al, byte ptr es:[edi]            # 0047535c
    not ecx                                      # 0047535e
    add ecx, -0x1                                # 00475360
    cmp ecx, 0x9c40                              # 00475363
    ja.d8 L_004753ce                             # 00475369
    # block 0x0047536b: entered by fall-through of ja at 0x00475369, 33 instruction(s), calls FUN_00448d11, ends with forward jump to 0x004753d5
    mov edi, dword ptr [ebp - local_4]           # 0047536b
    or ecx, -0x1                                 # 0047536e
    {load} xor eax, eax                          # 00475371
    repne scasb al, byte ptr es:[edi]            # 00475373
    not ecx                                      # 00475375
    mov esi, dword ptr [ebp - local_4]           # 00475377
    lea edi, [ebp - local_6c]                    # 0047537a
    {load} mov edx, ecx                          # 0047537d
    shr ecx, 0x2                                 # 0047537f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00475382
    {load} mov ecx, edx                          # 00475384
    and ecx, 0x3                                 # 00475386
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00475389
    lea edi, [ebp - local_6c]                    # 0047538b
    or ecx, -0x1                                 # 0047538e
    {load} xor eax, eax                          # 00475391
    repne scasb al, byte ptr es:[edi]            # 00475393
    add edi, -0x1                                # 00475395
    mov eax, dword ptr [0x54c6c8]                # 00475398
    mov dword ptr [edi], eax                     # 0047539d
    mov cx, word ptr [0x54c6cc]                  # 0047539f
    mov word ptr [edi + field_4], cx             # 004753a6
    mov dl, byte ptr [0x54c6ce]                  # 004753aa
    mov byte ptr [edi + field_6], dl             # 004753b0
    push 0x0                                     # 004753b3
    push -0x1                                    # 004753b5
    lea eax, [ebp - local_6c]                    # 004753b7
    push eax                                     # 004753ba
    mov ecx, dword ptr [0x5d03b3]                # 004753bb
    push ecx                                     # 004753c1
    mov ecx, 0x619a05                            # 004753c2
    call FUN_00448d11                            # 004753c7
    jmp.d8 L_004753d5                            # 004753cc
L_004753ce:
    # block 0x004753ce: entered by je at 0x00475352; ja at 0x00475369, 1 instruction(s), falls into the block at 0x004753d5
    mov dword ptr [ebp - local_4], 0x0           # 004753ce
L_004753d5:
    # block 0x004753d5: entered by jbe at 0x0047532f; jmp at 0x004753cc, 2 instruction(s), ends with jne to 0x0047546a (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004753d5
    jne.d32 L_0047546a                           # 004753d9
    # block 0x004753df: entered by fall-through of jne at 0x004753d9, 10 instruction(s), ends with jbe to 0x0047546a (forward)
    mov edx, dword ptr [ebp - local_70]          # 004753df
    mov edi, dword ptr [edx + field_76]          # 004753e2
    add edi, 0x3c4                               # 004753e5
    or ecx, -0x1                                 # 004753eb
    {load} xor eax, eax                          # 004753ee
    repne scasb al, byte ptr es:[edi]            # 004753f0
    not ecx                                      # 004753f2
    add ecx, -0x1                                # 004753f4
    test ecx, ecx                                # 004753f7
    jbe.d8 L_0047546a                            # 004753f9
    # block 0x004753fb: entered by fall-through of jbe at 0x004753f9, 37 instruction(s), calls FUN_00448d11, falls into the block at 0x0047546a
    mov eax, dword ptr [ebp - local_70]          # 004753fb
    mov ecx, dword ptr [eax + field_76]          # 004753fe
    add ecx, 0x3c4                               # 00475401
    {load} mov edi, ecx                          # 00475407
    lea edx, [ebp - local_6c]                    # 00475409
    or ecx, -0x1                                 # 0047540c
    {load} xor eax, eax                          # 0047540f
    repne scasb al, byte ptr es:[edi]            # 00475411
    not ecx                                      # 00475413
    {load} sub edi, ecx                          # 00475415
    {load} mov esi, edi                          # 00475417
    {load} mov eax, ecx                          # 00475419
    {load} mov edi, edx                          # 0047541b
    shr ecx, 0x2                                 # 0047541d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00475420
    {load} mov ecx, eax                          # 00475422
    and ecx, 0x3                                 # 00475424
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00475427
    lea edi, [ebp - local_6c]                    # 00475429
    or ecx, -0x1                                 # 0047542c
    {load} xor eax, eax                          # 0047542f
    repne scasb al, byte ptr es:[edi]            # 00475431
    add edi, -0x1                                # 00475433
    mov ecx, dword ptr [0x54c6d0]                # 00475436
    mov dword ptr [edi], ecx                     # 0047543c
    mov dx, word ptr [0x54c6d4]                  # 0047543e
    mov word ptr [edi + field_4], dx             # 00475445
    mov al, byte ptr [0x54c6d6]                  # 00475449
    mov byte ptr [edi + field_6], al             # 0047544e
    push 0x0                                     # 00475451
    push -0x1                                    # 00475453
    lea ecx, [ebp - local_6c]                    # 00475455
    push ecx                                     # 00475458
    mov edx, dword ptr [0x5d03b3]                # 00475459
    push edx                                     # 0047545f
    mov ecx, 0x619a05                            # 00475460
    call FUN_00448d11                            # 00475465
L_0047546a:
    # block 0x0047546a: entered by jmp at 0x004752eb; je at 0x0047530f; jne at 0x004753d9; jbe at 0x004753f9, 5 instruction(s), ends with ret
    pop edi                                      # 0047546a
    pop esi                                      # 0047546b
    {load} mov esp, ebp                          # 0047546c
    pop ebp                                      # 0047546e
    ret                                          # 0047546f

