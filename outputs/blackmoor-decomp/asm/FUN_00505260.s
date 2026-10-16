# FUN_00505260
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505260
# extent:       0x00505260-0x005053a0 (320 code bytes)
# span:         0x00505260-0x005053a0 (code 320, tables 0, padding 0)
# sha256:       f4370c96b3a6532a3b65012fa654dad32ec0446d370f025e97d9da5b65d7b502
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505260
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [ecx + n] field_minus_4; [edx + n] field_4; [esp + n] stk_10, stk_14, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30; [scaled index + n] field_minus_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 120 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x00505260 - 0x401000
.globl FUN_00505260
FUN_00505260:
    # block 0x00505260: entry, 68 instruction(s), ends with jle to 0x00505315 (forward)
    sub esp, 0x8                                 # 00505260
    mov eax, dword ptr [esp + stk_1c]            # 00505263
    push ebx                                     # 00505267
    mov ebx, dword ptr [esp + stk_1c]            # 00505268
    push ebp                                     # 0050526c
    push esi                                     # 0050526d
    {load} mov esi, eax                          # 0050526e
    mov edx, dword ptr [esp + stk_2c]            # 00505270
    mov ecx, dword ptr [esp + stk_20]            # 00505274
    neg esi                                      # 00505278
    {load} sbb esi, esi                          # 0050527a
    {load} mov ebp, eax                          # 0050527c
    {load} and esi, ebx                          # 0050527e
    mov ebx, dword ptr [ecx + 4*eax]             # 00505280
    neg ebp                                      # 00505283
    {load} sbb ebp, ebp                          # 00505285
    push edi                                     # 00505287
    {load} and ebp, edx                          # 00505288
    mov edi, dword ptr [ecx + 4*esi]             # 0050528a
    mov dword ptr [esp + stk_14], ebx            # 0050528d
    mov eax, dword ptr [ecx + 4*ebp]             # 00505291
    mov dword ptr [esp + stk_2c], eax            # 00505294
    {load} mov eax, ebx                          # 00505298
    cdq                                          # 0050529a
    and edx, 0x3                                 # 0050529b
    {load} add eax, edx                          # 0050529e
    {load} mov ecx, eax                          # 005052a0
    {load} mov eax, edi                          # 005052a2
    cdq                                          # 005052a4
    and edx, 0x3                                 # 005052a5
    {load} add eax, edx                          # 005052a8
    sar ecx, 0x2                                 # 005052aa
    sar eax, 0x2                                 # 005052ad
    mov dword ptr [esp + stk_30], ecx            # 005052b0
    {load} sub ecx, eax                          # 005052b4
    {load} mov eax, edi                          # 005052b6
    mov dword ptr [esp + stk_24], ecx            # 005052b8
    cdq                                          # 005052bc
    {load} sub eax, edx                          # 005052bd
    {load} mov edi, eax                          # 005052bf
    mov eax, dword ptr [esp + stk_2c]            # 005052c1
    cdq                                          # 005052c5
    and edx, 0x3                                 # 005052c6
    {load} add edx, eax                          # 005052c9
    {load} mov eax, ebx                          # 005052cb
    sar edx, 0x2                                 # 005052cd
    mov dword ptr [esp + stk_28], edx            # 005052d0
    cdq                                          # 005052d4
    {load} sub eax, edx                          # 005052d5
    mov edx, dword ptr [esp + stk_28]            # 005052d7
    {load} mov ebx, eax                          # 005052db
    mov eax, dword ptr [esp + stk_2c]            # 005052dd
    sar ebx                                      # 005052e1
    {load} sub ebx, edx                          # 005052e3
    mov edx, dword ptr [esp + stk_30]            # 005052e5
    {load} add ebx, edx                          # 005052e9
    cdq                                          # 005052eb
    {load} sub eax, edx                          # 005052ec
    {load} mov edx, eax                          # 005052ee
    sar edx                                      # 005052f0
    sar edi                                      # 005052f2
    lea eax, [edx + ebx]                         # 005052f4
    {load} add edi, ecx                          # 005052f7
    mov dword ptr [esp + stk_30], eax            # 005052f9
    {load} xor eax, eax                          # 005052fd
    test ecx, ecx                                # 005052ff
    mov dword ptr [esp + stk_10], edi            # 00505301
    jle.d8 L_00505315                            # 00505305
    # block 0x00505307: entered by fall-through of jle at 0x00505305, 4 instruction(s), falls into the block at 0x00505315
    mov edi, dword ptr [esp + stk_1c]            # 00505307
    rep stosd dword ptr es:[edi], eax            # 0050530b
    mov eax, dword ptr [esp + stk_24]            # 0050530d
    mov edi, dword ptr [esp + stk_10]            # 00505311
L_00505315:
    # block 0x00505315: entered by jle at 0x00505305, 2 instruction(s), ends with jge to 0x0050534f (forward)
    {load} cmp eax, edi                          # 00505315
    jge.d8 L_0050534f                            # 00505317
    # block 0x00505319: entered by fall-through of jge at 0x00505317, 6 instruction(s), falls into the block at 0x00505332
    mov ecx, dword ptr [esp + stk_1c]            # 00505319
    mov dword ptr [esp + stk_28], 0x0            # 0050531d
    {load} sub edi, eax                          # 00505325
    lea ecx, [ecx + 4*eax]                       # 00505327
    mov eax, dword ptr [esp + stk_28]            # 0050532a
    mov dword ptr [esp + stk_2c], edi            # 0050532e
L_00505332:
    # block 0x00505332: entered by jne at 0x0050534d, 9 instruction(s), ends with jne to 0x00505332 (backward)
    mov edi, dword ptr [esp + stk_20]            # 00505332
    add ecx, 0x4                                 # 00505336
    add eax, 0x4                                 # 00505339
    mov edi, dword ptr [edi + 4*esi]             # 0050533c
    fld dword ptr [eax + edi - field_minus_4]    # 0050533f
    fmul dword ptr [ecx - field_minus_4]         # 00505343
    dec dword ptr [esp + stk_2c]                 # 00505346
    fstp dword ptr [ecx - field_minus_4]         # 0050534a
    jne.d8 L_00505332                            # 0050534d
L_0050534f:
    # block 0x0050534f: entered by jge at 0x00505317; fall-through of jne at 0x0050534d, 3 instruction(s), ends with jge to 0x00505383 (forward)
    mov ecx, dword ptr [esp + stk_30]            # 0050534f
    {load} cmp ebx, ecx                          # 00505353
    jge.d8 L_00505383                            # 00505355
    # block 0x00505357: entered by fall-through of jge at 0x00505355, 5 instruction(s), falls into the block at 0x00505369
    mov eax, dword ptr [esp + stk_1c]            # 00505357
    {load} sub ecx, ebx                          # 0050535b
    lea edx, [4*edx - field_minus_4]             # 0050535d
    lea eax, [eax + 4*ebx]                       # 00505364
    {load} add ebx, ecx                          # 00505367
L_00505369:
    # block 0x00505369: entered by jne at 0x00505381, 9 instruction(s), ends with jne to 0x00505369 (backward)
    mov esi, dword ptr [esp + stk_20]            # 00505369
    add eax, 0x4                                 # 0050536d
    sub edx, 0x4                                 # 00505370
    dec ecx                                      # 00505373
    mov esi, dword ptr [esi + 4*ebp]             # 00505374
    fld dword ptr [edx + esi + field_4]          # 00505377
    fmul dword ptr [eax - field_minus_4]         # 0050537b
    fstp dword ptr [eax - field_minus_4]         # 0050537e
    jne.d8 L_00505369                            # 00505381
L_00505383:
    # block 0x00505383: entered by jge at 0x00505355; fall-through of jne at 0x00505381, 3 instruction(s), ends with jge to 0x00505398 (forward)
    mov ecx, dword ptr [esp + stk_14]            # 00505383
    {load} cmp ebx, ecx                          # 00505387
    jge.d8 L_00505398                            # 00505389
    # block 0x0050538b: entered by fall-through of jge at 0x00505389, 5 instruction(s), falls into the block at 0x00505398
    mov edx, dword ptr [esp + stk_1c]            # 0050538b
    {load} sub ecx, ebx                          # 0050538f
    {load} xor eax, eax                          # 00505391
    lea edi, [edx + 4*ebx]                       # 00505393
    rep stosd dword ptr es:[edi], eax            # 00505396
L_00505398:
    # block 0x00505398: entered by jge at 0x00505389, 6 instruction(s), ends with ret
    pop edi                                      # 00505398
    pop esi                                      # 00505399
    pop ebp                                      # 0050539a
    pop ebx                                      # 0050539b
    add esp, 0x8                                 # 0050539c
    ret                                          # 0050539f

