# FUN_0044b26a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b26a
# extent:       0x0044b26a-0x0044b3c8 (350 code bytes)
# span:         0x0044b26a-0x0044b3c8 (code 350, tables 0, padding 0)
# sha256:       d800a30bfee6a006119b98eff1f0a704f17bac09bae6f3e8c348cb00c760e7cc
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044b26a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_2; [edx + n] field_1, field_2
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 111 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0044b26a - 0x401000
.globl FUN_0044b26a
FUN_0044b26a:
    # block 0x0044b26a: entry, 13 instruction(s), ends with jl to 0x0044b29d (forward)
    push ebp                                     # 0044b26a
    {load} mov ebp, esp                          # 0044b26b
    sub esp, 0x14                                # 0044b26d
    mov dword ptr [ebp - local_8], ecx           # 0044b270
    movsx eax, word ptr [ebp + arg_8]            # 0044b273
    imul eax, eax, 0x8d                          # 0044b277
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044b27d
    mov dword ptr [ebp - local_4], ecx           # 0044b283
    mov edx, dword ptr [ebp - local_4]           # 0044b286
    {load} xor eax, eax                          # 0044b289
    mov al, byte ptr [edx]                       # 0044b28b
    test eax, eax                                # 0044b28d
    jl.d8 L_0044b29d                             # 0044b28f
    # block 0x0044b291: entered by fall-through of jl at 0x0044b28f, 5 instruction(s), ends with jle to 0x0044b2d5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044b291
    {load} xor edx, edx                          # 0044b294
    mov dl, byte ptr [ecx]                       # 0044b296
    cmp edx, 0x27                                # 0044b298
    jle.d8 L_0044b2d5                            # 0044b29b
L_0044b29d:
    # block 0x0044b29d: entered by jl at 0x0044b28f; fall-through of jle at 0x0044b29b, 3 instruction(s), ends with je to 0x0044b2d0 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044b29d
    test eax, eax                                # 0044b2a4
    je.d8 L_0044b2d0                             # 0044b2a6
    # block 0x0044b2a8: entered by fall-through of je at 0x0044b2a6, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0044b2d0
    mov ecx, dword ptr [ebp - local_4]           # 0044b2a8
    {load} xor edx, edx                          # 0044b2ab
    mov dl, byte ptr [ecx]                       # 0044b2ad
    push edx                                     # 0044b2af
    push 0x549028                                # 0044b2b0
    push 0x63888b                                # 0044b2b5
    call FUN_0050ca3e                            # 0044b2ba
    add esp, 0xc                                 # 0044b2bf
    push 0x0                                     # 0044b2c2
    push 0x0                                     # 0044b2c4
    push 0x63888b                                # 0044b2c6
    call FUN_0052139c                            # 0044b2cb
L_0044b2d0:
    # block 0x0044b2d0: entered by je at 0x0044b2a6, 1 instruction(s), ends with forward jump to 0x0044b3b5
    jmp.d32 L_0044b3b5                           # 0044b2d0
L_0044b2d5:
    # block 0x0044b2d5: entered by jle at 0x0044b29b, 5 instruction(s), ends with jg to 0x0044b342 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044b2d5
    {load} xor ecx, ecx                          # 0044b2d8
    mov cl, byte ptr [eax]                       # 0044b2da
    cmp ecx, 0x1d                                # 0044b2dc
    jg.d8 L_0044b342                             # 0044b2df
    # block 0x0044b2e1: entered by fall-through of jg at 0x0044b2df, 5 instruction(s), ends with jne to 0x0044b32a (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044b2e1
    {load} xor eax, eax                          # 0044b2e4
    mov al, byte ptr [edx + field_1]             # 0044b2e6
    test eax, eax                                # 0044b2e9
    jne.d8 L_0044b32a                            # 0044b2eb
    # block 0x0044b2ed: entered by fall-through of jne at 0x0044b2eb, 6 instruction(s), ends with je to 0x0044b32a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044b2ed
    {load} xor edx, edx                          # 0044b2f0
    mov dl, byte ptr [ecx]                       # 0044b2f2
    movsx eax, word ptr [2*edx + 0x58c959]       # 0044b2f4
    cmp eax, 0x270f                              # 0044b2fc
    je.d8 L_0044b32a                             # 0044b301
    # block 0x0044b303: entered by fall-through of je at 0x0044b301, 11 instruction(s), ends with forward jump to 0x0044b340
    mov ecx, dword ptr [ebp - local_4]           # 0044b303
    {load} xor edx, edx                          # 0044b306
    mov dl, byte ptr [ecx]                       # 0044b308
    mov eax, dword ptr [ebp - local_4]           # 0044b30a
    mov cx, word ptr [2*edx + 0x58c959]          # 0044b30d
    add cx, word ptr [eax + field_2]             # 0044b315
    mov edx, dword ptr [ebp - local_4]           # 0044b319
    {load} xor eax, eax                          # 0044b31c
    mov al, byte ptr [edx]                       # 0044b31e
    mov word ptr [2*eax + 0x58c959], cx          # 0044b320
    jmp.d8 L_0044b340                            # 0044b328
L_0044b32a:
    # block 0x0044b32a: entered by jne at 0x0044b2eb; je at 0x0044b301, 6 instruction(s), falls into the block at 0x0044b340
    mov ecx, dword ptr [ebp - local_4]           # 0044b32a
    {load} xor edx, edx                          # 0044b32d
    mov dl, byte ptr [ecx]                       # 0044b32f
    mov eax, dword ptr [ebp - local_4]           # 0044b331
    mov cx, word ptr [eax + field_2]             # 0044b334
    mov word ptr [2*edx + 0x58c959], cx          # 0044b338
L_0044b340:
    # block 0x0044b340: entered by jmp at 0x0044b328, 1 instruction(s), ends with forward jump to 0x0044b3b5
    jmp.d8 L_0044b3b5                            # 0044b340
L_0044b342:
    # block 0x0044b342: entered by jg at 0x0044b2df, 5 instruction(s), ends with jne to 0x0044b39a (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044b342
    {load} xor eax, eax                          # 0044b345
    mov al, byte ptr [edx + field_1]             # 0044b347
    test eax, eax                                # 0044b34a
    jne.d8 L_0044b39a                            # 0044b34c
    # block 0x0044b34e: entered by fall-through of jne at 0x0044b34c, 8 instruction(s), ends with jne to 0x0044b39a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044b34e
    {load} xor edx, edx                          # 0044b351
    mov dl, byte ptr [ecx]                       # 0044b353
    fld dword ptr [4*edx + 0x58c91d]             # 0044b355
    fcomp dword ptr [0x52cbe8]                   # 0044b35c
    fnstsw ax                                    # 0044b362
    test ah, 0x40                                # 0044b364
    jne.d8 L_0044b39a                            # 0044b367
    # block 0x0044b369: entered by fall-through of jne at 0x0044b367, 15 instruction(s), ends with forward jump to 0x0044b3b5
    mov eax, dword ptr [ebp - local_4]           # 0044b369
    {load} xor ecx, ecx                          # 0044b36c
    mov cl, byte ptr [eax]                       # 0044b36e
    mov edx, dword ptr [ebp - local_4]           # 0044b370
    movsx eax, word ptr [edx + field_2]          # 0044b373
    mov dword ptr [ebp - local_c], eax           # 0044b377
    fild dword ptr [ebp - local_c]               # 0044b37a
    fstp dword ptr [ebp - local_10]              # 0044b37d
    fld dword ptr [ebp - local_10]               # 0044b380
    fadd dword ptr [4*ecx + 0x58c91d]            # 0044b383
    mov ecx, dword ptr [ebp - local_4]           # 0044b38a
    {load} xor edx, edx                          # 0044b38d
    mov dl, byte ptr [ecx]                       # 0044b38f
    fstp dword ptr [4*edx + 0x58c91d]            # 0044b391
    jmp.d8 L_0044b3b5                            # 0044b398
L_0044b39a:
    # block 0x0044b39a: entered by jne at 0x0044b34c; jne at 0x0044b367, 8 instruction(s), falls into the block at 0x0044b3b5
    mov eax, dword ptr [ebp - local_4]           # 0044b39a
    movsx ecx, word ptr [eax + field_2]          # 0044b39d
    mov dword ptr [ebp - local_14], ecx          # 0044b3a1
    fild dword ptr [ebp - local_14]              # 0044b3a4
    mov edx, dword ptr [ebp - local_4]           # 0044b3a7
    {load} xor eax, eax                          # 0044b3aa
    mov al, byte ptr [edx]                       # 0044b3ac
    fstp dword ptr [4*eax + 0x58c91d]            # 0044b3ae
L_0044b3b5:
    # block 0x0044b3b5: entered by jmp at 0x0044b2d0; jmp at 0x0044b340; jmp at 0x0044b398, 7 instruction(s), calls FUN_0042ba3a, ends with ret 0x4
    mov cx, word ptr [ebp + arg_8]               # 0044b3b5
    push ecx                                     # 0044b3b9
    call FUN_0042ba3a                            # 0044b3ba
    add esp, 0x4                                 # 0044b3bf
    {load} mov esp, ebp                          # 0044b3c2
    pop ebp                                      # 0044b3c4
    ret 0x4                                      # 0044b3c5

