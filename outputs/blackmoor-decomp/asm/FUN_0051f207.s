# FUN_0051f207
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f207
# extent:       0x0051f207-0x0051f351 (330 code bytes)
# span:         0x0051f207-0x0051f351 (code 330, tables 0, padding 0)
# sha256:       f1b40378329ed5ba3271f594e99be326266cf7f16283880525446f98724ab041
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f207
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_20
# fields:       [eax + n] field_1c, field_20, field_58; [ebx + n] field_bc; [ecx + n] field_1c; [edi + n] field_1c, field_50; [esi + n] field_4, field_8, field_20
# callees:      calls FUN_0051abe4, FUN_0051c174, FUN_0051d373, FUN_0050c193, USER32.dll!SendMessageA, FUN_0051f1bc, FUN_00525b0f, FUN_0051d657; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 110 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051f351
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_20, 0x20  # offset -0x20
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)
.set FUN_0051d373, .text + (0x0051d373 - 0x401000)
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)
.set FUN_0051f1bc, .text + (0x0051f1bc - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051f207 - 0x401000
.globl FUN_0051f207
FUN_0051f207:
    # block 0x0051f207: entry, 11 instruction(s), ends with je to 0x0051f348 (forward)
    push ebp                                     # 0051f207
    {load} mov ebp, esp                          # 0051f208
    sub esp, 0x20                                # 0051f20a
    push ebx                                     # 0051f20d
    push esi                                     # 0051f20e
    mov esi, dword ptr [ebp + arg_c]             # 0051f20f
    {load} xor ebx, ebx                          # 0051f212
    {load} cmp esi, ebx                          # 0051f214
    push edi                                     # 0051f216
    mov dword ptr [ebp - local_4], ecx           # 0051f217
    je.d32 L_0051f348                            # 0051f21a
    # block 0x0051f220: entered by fall-through of je at 0x0051f21a, 3 instruction(s), ends with je to 0x0051f29c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051f220
    {load} sub eax, ebx                          # 0051f223
    je.d8 L_0051f29c                             # 0051f225
    # block 0x0051f227: entered by fall-through of je at 0x0051f225, 3 instruction(s), ends with je to 0x0051f235 (forward)
    dec eax                                      # 0051f227
    dec eax                                      # 0051f228
    je.d8 L_0051f235                             # 0051f229
    # block 0x0051f22b: entered by fall-through of je at 0x0051f229, 2 instruction(s), ends with forward jump to 0x0051f348
    sub eax, 0x7fff                              # 0051f22b
    jmp.d32 L_0051f348                           # 0051f230
L_0051f235:
    # block 0x0051f235: entered by je at 0x0051f229, 4 instruction(s), calls FUN_0051abe4, ends with je to 0x0051f29c (forward)
    push dword ptr [esi]                         # 0051f235
    call FUN_0051abe4                            # 0051f237
    {load} cmp eax, ebx                          # 0051f23c
    je.d8 L_0051f29c                             # 0051f23e
    # block 0x0051f240: entered by fall-through of je at 0x0051f23e, 5 instruction(s), calls FUN_0051c174, ends with je to 0x0051f29c (forward)
    {load} mov ecx, eax                          # 0051f240
    call FUN_0051c174                            # 0051f242
    {load} mov edi, eax                          # 0051f247
    {load} cmp edi, ebx                          # 0051f249
    je.d8 L_0051f29c                             # 0051f24b
    # block 0x0051f24d: entered by fall-through of je at 0x0051f24b, 4 instruction(s), calls FUN_0051d373, ends with je to 0x0051f29c (forward)
    {load} mov ecx, edi                          # 0051f24d
    call FUN_0051d373                            # 0051f24f
    test eax, eax                                # 0051f254
    je.d8 L_0051f29c                             # 0051f256
    # block 0x0051f258: entered by fall-through of je at 0x0051f256, 2 instruction(s), ends with je to 0x0051f29c (forward)
    cmp dword ptr [edi + field_50], ebx          # 0051f258
    je.d8 L_0051f29c                             # 0051f25b
    # block 0x0051f25d: entered by fall-through of je at 0x0051f25b, 4 instruction(s), calls FUN_0050c193, ends with je to 0x0051f29c (forward)
    call FUN_0050c193                            # 0051f25d
    mov ecx, dword ptr [ebp - local_4]           # 0051f262
    cmp dword ptr [ecx + field_1c], ebx          # 0051f265
    je.d8 L_0051f29c                             # 0051f268
    # block 0x0051f26a: entered by fall-through of je at 0x0051f268, 3 instruction(s), ends with jne to 0x0051f27b (forward)
    mov ecx, dword ptr [esi + field_4]           # 0051f26a
    cmp ecx, 0x100                               # 0051f26d
    jne.d8 L_0051f27b                            # 0051f273
    # block 0x0051f275: entered by fall-through of jne at 0x0051f273, 2 instruction(s), ends with je to 0x0051f283 (forward)
    cmp dword ptr [esi + field_8], 0xd           # 0051f275
    je.d8 L_0051f283                             # 0051f279
L_0051f27b:
    # block 0x0051f27b: entered by jne at 0x0051f273; fall-through of je at 0x0051f279, 2 instruction(s), ends with jne to 0x0051f29c (forward)
    cmp ecx, 0x202                               # 0051f27b
    jne.d8 L_0051f29c                            # 0051f281
L_0051f283:
    # block 0x0051f283: entered by je at 0x0051f279; fall-through of jne at 0x0051f281, 4 instruction(s), falls into the block at 0x0051f291
    push ebx                                     # 0051f283
    push 0xe146                                  # 0051f284
    push 0x111                                   # 0051f289
    push dword ptr [eax + field_1c]              # 0051f28e
L_0051f291:
    # block 0x0051f291: entered by jmp at 0x0051f2cb, 2 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x0051f33c
    call dword ptr [0x52a4c8]                    # 0051f291
    jmp.d32 L_0051f33c                           # 0051f297
L_0051f29c:
    # block 0x0051f29c: entered by je at 0x0051f225; je at 0x0051f23e; je at 0x0051f24b; je at 0x0051f256; more, 4 instruction(s), calls FUN_0050c193, ends with jae to 0x0051f2cd (forward)
    call FUN_0050c193                            # 0051f29c
    cmp dword ptr [0x63c79c], 0x333              # 0051f2a1
    {load} mov edi, eax                          # 0051f2ab
    jae.d8 L_0051f2cd                            # 0051f2ad
    # block 0x0051f2af: entered by fall-through of jae at 0x0051f2ad, 2 instruction(s), ends with je to 0x0051f2cd (forward)
    {load} cmp edi, ebx                          # 0051f2af
    je.d8 L_0051f2cd                             # 0051f2b1
    # block 0x0051f2b3: entered by fall-through of je at 0x0051f2b1, 4 instruction(s), calls FUN_0051f1bc, ends with je to 0x0051f2cd (forward)
    push esi                                     # 0051f2b3
    call FUN_0051f1bc                            # 0051f2b4
    test eax, eax                                # 0051f2b9
    je.d8 L_0051f2cd                             # 0051f2bb
    # block 0x0051f2bd: entered by fall-through of je at 0x0051f2bb, 5 instruction(s), ends with backward jump to 0x0051f291
    push ebx                                     # 0051f2bd
    push 0xe146                                  # 0051f2be
    push 0x111                                   # 0051f2c3
    push dword ptr [edi + field_1c]              # 0051f2c8
    jmp.d8 L_0051f291                            # 0051f2cb
L_0051f2cd:
    # block 0x0051f2cd: entered by jae at 0x0051f2ad; je at 0x0051f2b1; je at 0x0051f2bb, 2 instruction(s), ends with jne to 0x0051f348 (forward)
    cmp dword ptr [ebp + arg_8], ebx             # 0051f2cd
    jne.d8 L_0051f348                            # 0051f2d0
    # block 0x0051f2d2: entered by fall-through of jne at 0x0051f2d0, 3 instruction(s), ends with je to 0x0051f348 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0051f2d2
    cmp dword ptr [eax + field_20], ebx          # 0051f2d5
    je.d8 L_0051f348                             # 0051f2d8
    # block 0x0051f2da: entered by fall-through of je at 0x0051f2d8, 3 instruction(s), ends with jb to 0x0051f348 (forward)
    mov eax, dword ptr [esi + field_4]           # 0051f2da
    cmp eax, 0x100                               # 0051f2dd
    jb.d8 L_0051f348                             # 0051f2e2
    # block 0x0051f2e4: entered by fall-through of jb at 0x0051f2e2, 2 instruction(s), ends with ja to 0x0051f348 (forward)
    cmp eax, 0x108                               # 0051f2e4
    ja.d8 L_0051f348                             # 0051f2e9
    # block 0x0051f2eb: entered by fall-through of ja at 0x0051f2e9, 6 instruction(s), calls FUN_00525b0f, ends with jne to 0x0051f348 (forward)
    push 0x52496c                                # 0051f2eb
    mov ecx, 0x63c444                            # 0051f2f0
    call FUN_00525b0f                            # 0051f2f5
    {load} mov ebx, eax                          # 0051f2fa
    cmp dword ptr [ebx + field_bc], 0x0          # 0051f2fc
    jne.d8 L_0051f348                            # 0051f303
    # block 0x0051f305: entered by fall-through of jne at 0x0051f303, 10 instruction(s), calls FUN_0051d657, ends with je to 0x0051f341 (forward)
    push 0x7                                     # 0051f305
    lea edi, [ebp - local_20]                    # 0051f307
    pop ecx                                      # 0051f30a
    mov dword ptr [ebx + field_bc], 0x1          # 0051f30b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0051f315
    mov esi, dword ptr [ebp - local_4]           # 0051f317
    mov ecx, dword ptr [esi + field_20]          # 0051f31a
    call FUN_0051d657                            # 0051f31d
    test eax, eax                                # 0051f322
    je.d8 L_0051f341                             # 0051f324
    # block 0x0051f326: entered by fall-through of je at 0x0051f324, 7 instruction(s), calls indirect dword ptr [eax + 0x58], ends with je to 0x0051f341 (forward)
    mov eax, dword ptr [esi]                     # 0051f326
    lea ecx, [ebp - local_20]                    # 0051f328
    push ecx                                     # 0051f32b
    {load} mov ecx, esi                          # 0051f32c
    call dword ptr [eax + field_58]              # 0051f32e
    test eax, eax                                # 0051f331
    je.d8 L_0051f341                             # 0051f333
    # block 0x0051f335: entered by fall-through of je at 0x0051f333, 1 instruction(s), falls into the block at 0x0051f33c
    and dword ptr [ebx + field_bc], 0x0          # 0051f335
L_0051f33c:
    # block 0x0051f33c: entered by jmp at 0x0051f297, 3 instruction(s), ends with forward jump to 0x0051f34a
    push 0x1                                     # 0051f33c
    pop eax                                      # 0051f33e
    jmp.d8 L_0051f34a                            # 0051f33f
L_0051f341:
    # block 0x0051f341: entered by je at 0x0051f324; je at 0x0051f333, 1 instruction(s), falls into the block at 0x0051f348
    and dword ptr [ebx + field_bc], 0x0          # 0051f341
L_0051f348:
    # block 0x0051f348: entered by je at 0x0051f21a; jmp at 0x0051f230; jne at 0x0051f2d0; je at 0x0051f2d8; more, 1 instruction(s), falls into the block at 0x0051f34a
    {load} xor eax, eax                          # 0051f348
L_0051f34a:
    # block 0x0051f34a: entered by jmp at 0x0051f33f, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 0051f34a
    pop esi                                      # 0051f34b
    pop ebx                                      # 0051f34c
    leave                                        # 0051f34d
    ret 0x8                                      # 0051f34e

