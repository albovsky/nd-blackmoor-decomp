# FUN_0051623d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051623d
# extent:       0x0051623d-0x005163e9 (428 code bytes)
# span:         0x0051623d-0x005163e9 (code 428, tables 0, padding 0)
# sha256:       cbfbbe705eefb8d85700a7a793fcd28408c9abafb4138fe30c01d2a41757124d
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051623d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_14, field_1c; [esp + n] stk_10
# callees:      calls FUN_005163e9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 149 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_005163e9, .text + (0x005163e9 - 0x401000)

.org 0x0051623d - 0x401000
.globl FUN_0051623d
FUN_0051623d:
    # block 0x0051623d: entry, 6 instruction(s), ends with jne to 0x00516251 (forward)
    push ebx                                     # 0051623d
    push esi                                     # 0051623e
    push edi                                     # 0051623f
    {load} xor edi, edi                          # 00516240
    cmp dword ptr [0x568b84], edi                # 00516242
    jne.d8 L_00516251                            # 00516248
L_0051624a:
    # block 0x0051624a: entered by jl at 0x00516385; jg at 0x0051638d; jl at 0x005163af; fall-through of jne at 0x00516248, 2 instruction(s), ends with forward jump to 0x0051639d
    {load} xor eax, eax                          # 0051624a
    jmp.d32 L_0051639d                           # 0051624c
L_00516251:
    # block 0x00516251: entered by jne at 0x00516248, 6 instruction(s), ends with jne to 0x0051626f (forward)
    mov esi, dword ptr [esp + stk_10]            # 00516251
    push 0x1                                     # 00516255
    pop ebx                                      # 00516257
    mov eax, dword ptr [esi + field_14]          # 00516258
    cmp eax, dword ptr [0x568c18]                # 0051625b
    jne.d8 L_0051626f                            # 00516261
    # block 0x00516263: entered by fall-through of jne at 0x00516261, 2 instruction(s), ends with je to 0x00516371 (forward)
    cmp eax, dword ptr [0x568c28]                # 00516263
    je.d32 L_00516371                            # 00516269
L_0051626f:
    # block 0x0051626f: entered by jne at 0x00516261; fall-through of je at 0x00516269, 2 instruction(s), ends with je to 0x00516347 (forward)
    cmp dword ptr [0x63cc58], edi                # 0051626f
    je.d32 L_00516347                            # 00516275
    # block 0x0051627b: entered by fall-through of je at 0x00516275, 10 instruction(s), ends with jne to 0x005162c1 (forward)
    movzx ecx, word ptr [0x63cd06]               # 0051627b
    push ecx                                     # 00516282
    cmp word ptr [0x63ccf8], di                  # 00516283
    movzx ecx, word ptr [0x63cd04]               # 0051628a
    push ecx                                     # 00516291
    movzx ecx, word ptr [0x63cd02]               # 00516292
    push ecx                                     # 00516299
    movzx ecx, word ptr [0x63cd00]               # 0051629a
    push ecx                                     # 005162a1
    jne.d8 L_005162c1                            # 005162a2
    # block 0x005162a4: entered by fall-through of jne at 0x005162a2, 10 instruction(s), ends with forward jump to 0x005162d5
    movzx ecx, word ptr [0x63ccfc]               # 005162a4
    push edi                                     # 005162ab
    push ecx                                     # 005162ac
    movzx ecx, word ptr [0x63ccfe]               # 005162ad
    push ecx                                     # 005162b4
    movzx ecx, word ptr [0x63ccfa]               # 005162b5
    push ecx                                     # 005162bc
    push eax                                     # 005162bd
    push ebx                                     # 005162be
    jmp.d8 L_005162d5                            # 005162bf
L_005162c1:
    # block 0x005162c1: entered by jne at 0x005162a2, 8 instruction(s), falls into the block at 0x005162d5
    movzx ecx, word ptr [0x63ccfe]               # 005162c1
    push ecx                                     # 005162c8
    push edi                                     # 005162c9
    movzx ecx, word ptr [0x63ccfa]               # 005162ca
    push edi                                     # 005162d1
    push ecx                                     # 005162d2
    push eax                                     # 005162d3
    push edi                                     # 005162d4
L_005162d5:
    # block 0x005162d5: entered by jmp at 0x005162bf, 13 instruction(s), calls FUN_005163e9, ends with jne to 0x0051632f (forward)
    push ebx                                     # 005162d5
    call FUN_005163e9                            # 005162d6
    movzx eax, word ptr [0x63ccb2]               # 005162db
    add esp, 0x2c                                # 005162e2
    cmp word ptr [0x63cca4], di                  # 005162e5
    push eax                                     # 005162ec
    movzx eax, word ptr [0x63ccb0]               # 005162ed
    push eax                                     # 005162f4
    movzx eax, word ptr [0x63ccae]               # 005162f5
    push eax                                     # 005162fc
    movzx eax, word ptr [0x63ccac]               # 005162fd
    push eax                                     # 00516304
    jne.d8 L_0051632f                            # 00516305
    # block 0x00516307: entered by fall-through of jne at 0x00516305, 9 instruction(s), falls into the block at 0x00516324
    movzx eax, word ptr [0x63cca8]               # 00516307
    push edi                                     # 0051630e
    push eax                                     # 0051630f
    movzx eax, word ptr [0x63ccaa]               # 00516310
    push eax                                     # 00516317
    movzx eax, word ptr [0x63cca6]               # 00516318
    push eax                                     # 0051631f
    push dword ptr [esi + field_14]              # 00516320
    push ebx                                     # 00516323
L_00516324:
    # block 0x00516324: entered by jmp at 0x00516345, 4 instruction(s), calls FUN_005163e9, ends with forward jump to 0x00516371
    push edi                                     # 00516324
    call FUN_005163e9                            # 00516325
    add esp, 0x2c                                # 0051632a
    jmp.d8 L_00516371                            # 0051632d
L_0051632f:
    # block 0x0051632f: entered by jne at 0x00516305, 9 instruction(s), ends with backward jump to 0x00516324
    movzx eax, word ptr [0x63ccaa]               # 0051632f
    push eax                                     # 00516336
    push edi                                     # 00516337
    movzx eax, word ptr [0x63cca6]               # 00516338
    push edi                                     # 0051633f
    push eax                                     # 00516340
    push dword ptr [esi + field_14]              # 00516341
    push edi                                     # 00516344
    jmp.d8 L_00516324                            # 00516345
L_00516347:
    # block 0x00516347: entered by je at 0x00516275, 25 instruction(s), calls FUN_005163e9, falls into the block at 0x00516371
    push edi                                     # 00516347
    push edi                                     # 00516348
    push edi                                     # 00516349
    push 0x2                                     # 0051634a
    push edi                                     # 0051634c
    push edi                                     # 0051634d
    push ebx                                     # 0051634e
    push 0x4                                     # 0051634f
    push eax                                     # 00516351
    push ebx                                     # 00516352
    push ebx                                     # 00516353
    call FUN_005163e9                            # 00516354
    push edi                                     # 00516359
    push edi                                     # 0051635a
    push edi                                     # 0051635b
    push 0x2                                     # 0051635c
    push edi                                     # 0051635e
    push edi                                     # 0051635f
    push 0x5                                     # 00516360
    push 0xa                                     # 00516362
    push dword ptr [esi + field_14]              # 00516364
    push ebx                                     # 00516367
    push edi                                     # 00516368
    call FUN_005163e9                            # 00516369
    add esp, 0x58                                # 0051636e
L_00516371:
    # block 0x00516371: entered by je at 0x00516269; jmp at 0x0051632d, 5 instruction(s), ends with jge to 0x005163a1 (forward)
    mov edx, dword ptr [0x568c1c]                # 00516371
    mov eax, dword ptr [0x568c2c]                # 00516377
    mov ecx, dword ptr [esi + field_1c]          # 0051637c
    {load} cmp edx, eax                          # 0051637f
    jge.d8 L_005163a1                            # 00516381
    # block 0x00516383: entered by fall-through of jge at 0x00516381, 2 instruction(s), ends with jl to 0x0051624a (backward)
    {load} cmp ecx, edx                          # 00516383
    jl.d32 L_0051624a                            # 00516385
    # block 0x0051638b: entered by fall-through of jl at 0x00516385, 2 instruction(s), ends with jg to 0x0051624a (backward)
    {load} cmp ecx, eax                          # 0051638b
    jg.d32 L_0051624a                            # 0051638d
    # block 0x00516393: entered by fall-through of jg at 0x0051638d, 2 instruction(s), ends with jle to 0x005163b5 (forward)
    {load} cmp ecx, edx                          # 00516393
    jle.d8 L_005163b5                            # 00516395
    # block 0x00516397: entered by fall-through of jle at 0x00516395, 2 instruction(s), ends with jge to 0x005163b5 (forward)
    {load} cmp ecx, eax                          # 00516397
    jge.d8 L_005163b5                            # 00516399
L_0051639b:
    # block 0x0051639b: entered by jl at 0x005163a3; jg at 0x005163a7; fall-through of jge at 0x00516399, 1 instruction(s), falls into the block at 0x0051639d
    {load} mov eax, ebx                          # 0051639b
L_0051639d:
    # block 0x0051639d: entered by jmp at 0x0051624c; jmp at 0x005163da, 4 instruction(s), ends with ret
    pop edi                                      # 0051639d
    pop esi                                      # 0051639e
    pop ebx                                      # 0051639f
    ret                                          # 005163a0
L_005163a1:
    # block 0x005163a1: entered by jge at 0x00516381, 2 instruction(s), ends with jl to 0x0051639b (backward)
    {load} cmp ecx, eax                          # 005163a1
    jl.d8 L_0051639b                             # 005163a3
    # block 0x005163a5: entered by fall-through of jl at 0x005163a3, 2 instruction(s), ends with jg to 0x0051639b (backward)
    {load} cmp ecx, edx                          # 005163a5
    jg.d8 L_0051639b                             # 005163a7
    # block 0x005163a9: entered by fall-through of jg at 0x005163a7, 2 instruction(s), ends with jle to 0x005163b5 (forward)
    {load} cmp ecx, eax                          # 005163a9
    jle.d8 L_005163b5                            # 005163ab
    # block 0x005163ad: entered by fall-through of jle at 0x005163ab, 2 instruction(s), ends with jl to 0x0051624a (backward)
    {load} cmp ecx, edx                          # 005163ad
    jl.d32 L_0051624a                            # 005163af
L_005163b5:
    # block 0x005163b5: entered by jle at 0x00516395; jge at 0x00516399; jle at 0x005163ab; fall-through of jl at 0x005163af, 8 instruction(s), ends with jne to 0x005163dc (forward)
    mov eax, dword ptr [esi + field_8]           # 005163b5
    imul eax, eax, 0x3c                          # 005163b8
    add eax, dword ptr [esi + field_4]           # 005163bb
    imul eax, eax, 0x3c                          # 005163be
    add eax, dword ptr [esi]                     # 005163c1
    imul eax, eax, 0x3e8                         # 005163c3
    {load} cmp ecx, edx                          # 005163c9
    jne.d8 L_005163dc                            # 005163cb
    # block 0x005163cd: entered by fall-through of jne at 0x005163cb, 3 instruction(s), falls into the block at 0x005163d8
    {load} xor ecx, ecx                          # 005163cd
    cmp eax, dword ptr [0x568c20]                # 005163cf
    setge cl                                     # 005163d5
L_005163d8:
    # block 0x005163d8: entered by jmp at 0x005163e7, 2 instruction(s), ends with backward jump to 0x0051639d
    {load} mov eax, ecx                          # 005163d8
    jmp.d8 L_0051639d                            # 005163da
L_005163dc:
    # block 0x005163dc: entered by jne at 0x005163cb, 4 instruction(s), ends with backward jump to 0x005163d8
    {load} xor ecx, ecx                          # 005163dc
    cmp eax, dword ptr [0x568c30]                # 005163de
    setl cl                                      # 005163e4
    jmp.d8 L_005163d8                            # 005163e7

