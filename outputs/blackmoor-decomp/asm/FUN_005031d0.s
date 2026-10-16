# FUN_005031d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005031d0
# extent:       0x005031d0-0x005033cb (507 code bytes)
# span:         0x005031d0-0x005033d0 (code 507, tables 0, padding 5)
# sha256:       60828f60a50a5ba0ea5f6288552ed4c888a7e6436f6537cee970eb3044d9b20c
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005031d0
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_24
# fields:       [eax + n] field_minus_4; [ecx + n] field_14, field_minus_1; [edi + n] field_8, field_10, field_1c, field_20, field_24, field_28; [edx + n] field_1c, field_minus_1
# callees:      calls FUN_0050c920, FUN_0050bd80, FUN_0050be30, FUN_00502da0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 195 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005033d0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_24, 0x24  # offset -0x24
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050bd80, .text + (0x0050bd80 - 0x401000)
.set FUN_0050be30, .text + (0x0050be30 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x005031d0 - 0x401000
.globl FUN_005031d0
FUN_005031d0:
    # block 0x005031d0: entry, 27 instruction(s), calls FUN_0050c920, ends with jle to 0x0050336b (forward)
    push ebp                                     # 005031d0
    {load} mov ebp, esp                          # 005031d1
    sub esp, 0x18                                # 005031d3
    mov eax, dword ptr [ebp + arg_14]            # 005031d6
    push ebx                                     # 005031d9
    push esi                                     # 005031da
    push edi                                     # 005031db
    mov edi, dword ptr [ebp + arg_8]             # 005031dc
    cdq                                          # 005031df
    idiv dword ptr [edi]                         # 005031e0
    {load} mov esi, eax                          # 005031e2
    mov dword ptr [ebp - local_4], esi           # 005031e4
    lea ebx, [4*esi]                             # 005031e7
    {load} mov eax, ebx                          # 005031ee
    add eax, 0x3                                 # 005031f0
    and al, -0x4                                 # 005031f3
    call FUN_0050c920                            # 005031f5
    {load} mov eax, ebx                          # 005031fa
    mov dword ptr [ebp + arg_14], esp            # 005031fc
    add eax, 0x3                                 # 005031ff
    and al, -0x4                                 # 00503202
    call FUN_0050c920                            # 00503204
    {load} mov ecx, esp                          # 00503209
    mov dword ptr [ebp - local_8], 0x0           # 0050320b
    test esi, esi                                # 00503212
    mov dword ptr [ebp - local_10], ecx          # 00503214
    jle.d32 L_0050336b                           # 00503217
    # block 0x0050321d: entered by fall-through of jle at 0x00503217, 4 instruction(s), falls into the block at 0x00503228
    mov eax, dword ptr [ebp + arg_14]            # 0050321d
    mov dword ptr [ebp - local_c], ecx           # 00503220
    {load} sub eax, ecx                          # 00503223
    mov dword ptr [ebp - local_18], eax          # 00503225
L_00503228:
    # block 0x00503228: entered by jl at 0x00503362, 10 instruction(s), calls FUN_0050bd80, ends with jl to 0x00503283 (forward)
    mov ecx, dword ptr [edi + field_24]          # 00503228
    mov edx, dword ptr [ebp + arg_10]            # 0050322b
    mov eax, dword ptr [edi + field_28]          # 0050322e
    push ecx                                     # 00503231
    push edx                                     # 00503232
    mov dword ptr [ebp + arg_14], eax            # 00503233
    call FUN_0050bd80                            # 00503236
    add esp, 0x8                                 # 0050323b
    test eax, eax                                # 0050323e
    jl.d8 L_00503283                             # 00503240
    # block 0x00503242: entered by fall-through of jl at 0x00503240, 4 instruction(s), ends with je to 0x00503268 (forward)
    mov ecx, dword ptr [edi + field_20]          # 00503242
    mov ebx, dword ptr [ecx + 4*eax]             # 00503245
    test ebx, 0x80000000                         # 00503248
    je.d8 L_00503268                             # 0050324e
    # block 0x00503250: entered by fall-through of je at 0x0050324e, 7 instruction(s), ends with forward jump to 0x00503288
    mov edi, dword ptr [edi + field_8]           # 00503250
    {load} mov esi, ebx                          # 00503253
    sar esi, 0xf                                 # 00503255
    and ebx, 0x7fff                              # 00503258
    and esi, 0x7fff                              # 0050325e
    {load} sub edi, ebx                          # 00503264
    jmp.d8 L_00503288                            # 00503266
L_00503268:
    # block 0x00503268: entered by je at 0x0050324e, 9 instruction(s), calls FUN_0050be30, ends with forward jump to 0x00503337
    mov edx, dword ptr [edi + field_1c]          # 00503268
    mov ecx, dword ptr [ebp + arg_10]            # 0050326b
    movsx eax, byte ptr [edx + ebx - field_minus_1] # 0050326e
    push eax                                     # 00503273
    push ecx                                     # 00503274
    call FUN_0050be30                            # 00503275
    add esp, 0x8                                 # 0050327a
    dec ebx                                      # 0050327d
    jmp.d32 L_00503337                           # 0050327e
L_00503283:
    # block 0x00503283: entered by jl at 0x00503240, 2 instruction(s), falls into the block at 0x00503288
    mov edi, dword ptr [edi + field_8]           # 00503283
    {load} xor esi, esi                          # 00503286
L_00503288:
    # block 0x00503288: entered by jmp at 0x00503266, 8 instruction(s), calls FUN_0050bd80, ends with jge to 0x005032bf (forward)
    mov ebx, dword ptr [ebp + arg_14]            # 00503288
    mov edx, dword ptr [ebp + arg_10]            # 0050328b
    push ebx                                     # 0050328e
    push edx                                     # 0050328f
    call FUN_0050bd80                            # 00503290
    add esp, 0x8                                 # 00503295
    test eax, eax                                # 00503298
    jge.d8 L_005032bf                            # 0050329a
L_0050329c:
    # block 0x0050329c: entered by jl at 0x005032b1; fall-through of jge at 0x0050329a, 2 instruction(s), ends with jle to 0x005032b8 (forward)
    cmp ebx, 0x1                                 # 0050329c
    jle.d8 L_005032b8                            # 0050329f
    # block 0x005032a1: entered by fall-through of jle at 0x0050329f, 8 instruction(s), calls FUN_0050bd80, ends with jl to 0x0050329c (backward)
    mov eax, dword ptr [ebp + arg_10]            # 005032a1
    dec ebx                                      # 005032a4
    push ebx                                     # 005032a5
    push eax                                     # 005032a6
    call FUN_0050bd80                            # 005032a7
    add esp, 0x8                                 # 005032ac
    test eax, eax                                # 005032af
    jl.d8 L_0050329c                             # 005032b1
    # block 0x005032b3: entered by fall-through of jl at 0x005032b1, 2 instruction(s), ends with forward jump to 0x005032bf
    mov dword ptr [ebp + arg_14], ebx            # 005032b3
    jmp.d8 L_005032bf                            # 005032b6
L_005032b8:
    # block 0x005032b8: entered by jle at 0x0050329f, 3 instruction(s), ends with jl to 0x0050332e (forward)
    test eax, eax                                # 005032b8
    mov dword ptr [ebp + arg_14], ebx            # 005032ba
    jl.d8 L_0050332e                             # 005032bd
L_005032bf:
    # block 0x005032bf: entered by jge at 0x0050329a; jmp at 0x005032b6; fall-through of jl at 0x005032bd, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x00503302 (forward)
    push eax                                     # 005032bf
    call FUN_00502da0                            # 005032c0
    {load} mov edx, edi                          # 005032c5
    add esp, 0x4                                 # 005032c7
    {load} sub edx, esi                          # 005032ca
    cmp edx, 0x1                                 # 005032cc
    jle.d8 L_00503302                            # 005032cf
    # block 0x005032d1: entered by fall-through of jle at 0x005032cf, 3 instruction(s), falls into the block at 0x005032da
    mov ecx, dword ptr [ebp + arg_8]             # 005032d1
    mov ecx, dword ptr [ecx + field_14]          # 005032d4
    mov dword ptr [ebp - local_14], ecx          # 005032d7
L_005032da:
    # block 0x005032da: entered by jg at 0x005032fd, 16 instruction(s), ends with jg to 0x005032da (backward)
    mov ebx, dword ptr [ebp - local_14]          # 005032da
    sar edx                                      # 005032dd
    lea ecx, [edx + esi]                         # 005032df
    cmp eax, dword ptr [ebx + 4*ecx]             # 005032e2
    {load} sbb ecx, ecx                          # 005032e5
    neg ecx                                      # 005032e7
    lea ebx, [ecx - field_minus_1]               # 005032e9
    neg ecx                                      # 005032ec
    {load} and ecx, edx                          # 005032ee
    {load} and ebx, edx                          # 005032f0
    {load} sub edi, ecx                          # 005032f2
    {load} add esi, ebx                          # 005032f4
    {load} mov edx, edi                          # 005032f6
    {load} sub edx, esi                          # 005032f8
    cmp edx, 0x1                                 # 005032fa
    jg.d8 L_005032da                             # 005032fd
    # block 0x005032ff: entered by fall-through of jg at 0x005032fd, 1 instruction(s), falls into the block at 0x00503302
    mov ebx, dword ptr [ebp + arg_14]            # 005032ff
L_00503302:
    # block 0x00503302: entered by jle at 0x005032cf, 5 instruction(s), ends with jg to 0x00503321 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00503302
    mov eax, dword ptr [edx + field_1c]          # 00503305
    movsx eax, byte ptr [eax + esi]              # 00503308
    {load} cmp eax, ebx                          # 0050330c
    jg.d8 L_00503321                             # 0050330e
    # block 0x00503310: entered by fall-through of jg at 0x0050330e, 7 instruction(s), calls FUN_0050be30, ends with forward jump to 0x00503331
    mov ecx, dword ptr [ebp + arg_10]            # 00503310
    push eax                                     # 00503313
    push ecx                                     # 00503314
    call FUN_0050be30                            # 00503315
    add esp, 0x8                                 # 0050331a
    {load} mov ebx, esi                          # 0050331d
    jmp.d8 L_00503331                            # 0050331f
L_00503321:
    # block 0x00503321: entered by jg at 0x0050330e, 5 instruction(s), calls FUN_0050be30, falls into the block at 0x0050332e
    mov edx, dword ptr [ebp + arg_10]            # 00503321
    push ebx                                     # 00503324
    push edx                                     # 00503325
    call FUN_0050be30                            # 00503326
    add esp, 0x8                                 # 0050332b
L_0050332e:
    # block 0x0050332e: entered by jl at 0x005032bd, 1 instruction(s), falls into the block at 0x00503331
    or ebx, -0x1                                 # 0050332e
L_00503331:
    # block 0x00503331: entered by jmp at 0x0050331f, 2 instruction(s), falls into the block at 0x00503337
    mov esi, dword ptr [ebp - local_4]           # 00503331
    mov edi, dword ptr [ebp + arg_8]             # 00503334
L_00503337:
    # block 0x00503337: entered by jmp at 0x0050327e, 5 instruction(s), ends with je to 0x005033be (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00503337
    mov eax, dword ptr [ebp - local_c]           # 0050333a
    cmp ebx, -0x1                                # 0050333d
    mov dword ptr [ecx + eax], ebx               # 00503340
    je.d8 L_005033be                             # 00503343
    # block 0x00503345: entered by fall-through of je at 0x00503343, 12 instruction(s), ends with jl to 0x00503228 (backward)
    mov edx, dword ptr [edi]                     # 00503345
    mov ecx, dword ptr [edi + field_10]          # 00503347
    imul edx, ebx                                # 0050334a
    add eax, 0x4                                 # 0050334d
    lea edx, [ecx + 4*edx]                       # 00503350
    mov ecx, dword ptr [ebp - local_8]           # 00503353
    mov dword ptr [eax - field_minus_4], edx     # 00503356
    inc ecx                                      # 00503359
    {load} cmp ecx, esi                          # 0050335a
    mov dword ptr [ebp - local_8], ecx           # 0050335c
    mov dword ptr [ebp - local_c], eax           # 0050335f
    jl.d32 L_00503228                            # 00503362
    # block 0x00503368: entered by fall-through of jl at 0x00503362, 1 instruction(s), falls into the block at 0x0050336b
    mov ecx, dword ptr [ebp - local_10]          # 00503368
L_0050336b:
    # block 0x0050336b: entered by jle at 0x00503217, 4 instruction(s), ends with jle to 0x005033b2 (forward)
    mov eax, dword ptr [edi]                     # 0050336b
    {load} xor ebx, ebx                          # 0050336d
    test eax, eax                                # 0050336f
    jle.d8 L_005033b2                            # 00503371
    # block 0x00503373: entered by fall-through of jle at 0x00503371, 2 instruction(s), falls into the block at 0x00503379
    mov eax, dword ptr [ebp + arg_c]             # 00503373
    mov dword ptr [ebp + arg_10], eax            # 00503376
L_00503379:
    # block 0x00503379: entered by jl at 0x005033b0, 2 instruction(s), ends with jle to 0x0050339c (forward)
    test esi, esi                                # 00503379
    jle.d8 L_0050339c                            # 0050337b
    # block 0x0050337d: entered by fall-through of jle at 0x0050337b, 2 instruction(s), falls into the block at 0x00503382
    mov eax, dword ptr [ebp + arg_10]            # 0050337d
    {load} mov edx, esi                          # 00503380
L_00503382:
    # block 0x00503382: entered by jne at 0x00503394, 8 instruction(s), ends with jne to 0x00503382 (backward)
    mov esi, dword ptr [ecx]                     # 00503382
    add ecx, 0x4                                 # 00503384
    add eax, 0x4                                 # 00503387
    dec edx                                      # 0050338a
    fld dword ptr [esi + 4*ebx]                  # 0050338b
    fadd dword ptr [eax - field_minus_4]         # 0050338e
    fstp dword ptr [eax - field_minus_4]         # 00503391
    jne.d8 L_00503382                            # 00503394
    # block 0x00503396: entered by fall-through of jne at 0x00503394, 2 instruction(s), falls into the block at 0x0050339c
    mov esi, dword ptr [ebp - local_4]           # 00503396
    mov ecx, dword ptr [ebp - local_10]          # 00503399
L_0050339c:
    # block 0x0050339c: entered by jle at 0x0050337b, 8 instruction(s), ends with jl to 0x00503379 (backward)
    mov edx, dword ptr [ebp + arg_10]            # 0050339c
    lea eax, [4*esi]                             # 0050339f
    {load} add edx, eax                          # 005033a6
    mov eax, dword ptr [edi]                     # 005033a8
    inc ebx                                      # 005033aa
    mov dword ptr [ebp + arg_10], edx            # 005033ab
    {load} cmp ebx, eax                          # 005033ae
    jl.d8 L_00503379                             # 005033b0
L_005033b2:
    # block 0x005033b2: entered by jle at 0x00503371; fall-through of jl at 0x005033b0, 8 instruction(s), ends with ret
    {load} xor eax, eax                          # 005033b2
    lea esp, [ebp - local_24]                    # 005033b4
    pop edi                                      # 005033b7
    pop esi                                      # 005033b8
    pop ebx                                      # 005033b9
    {load} mov esp, ebp                          # 005033ba
    pop ebp                                      # 005033bc
    ret                                          # 005033bd
L_005033be:
    # block 0x005033be: entered by je at 0x00503343, 8 instruction(s), ends with ret
    lea esp, [ebp - local_24]                    # 005033be
    or eax, -0x1                                 # 005033c1
    pop edi                                      # 005033c4
    pop esi                                      # 005033c5
    pop ebx                                      # 005033c6
    {load} mov esp, ebp                          # 005033c7
    pop ebp                                      # 005033c9
    ret                                          # 005033ca

# --- data items (not part of the function) -------------------------
.org 0x005033cb - 0x401000
PAD_005033cb:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

