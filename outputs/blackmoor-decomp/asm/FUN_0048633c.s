# FUN_0048633c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048633c
# extent:       0x0048633c-0x004866b4 (888 code bytes)
# span:         0x0048633c-0x004866b4 (code 888, tables 0, padding 0)
# sha256:       0fb74a55768eca84e6e4fc7b1bc1d917226cd471256cfa864179ab5f767b36d9
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         good_drop_feedback
# naming:       native port src/action_family_ea_runtime.c:good_drop_feedback (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with good_drop_feedback (feedback +0x74b; always sets the caption flag). Native errors where the original overruns its 204-byte caption buffer; untested range.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_dc, local_e0
# fields:       [eax + n] field_26, field_76c, field_7be, field_bc1; [ecx + n] field_821, field_bac, field_bc1, field_bc9; [edi + n] field_minus_1; [edx + n] field_7be, field_821, field_bac
# callees:      calls FUN_0050cd50, FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:good_drop_feedback (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 244 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ field_26, 0x26  # offset +0x26
.equ field_76c, 0x76c  # offset +0x76c
.equ field_7be, 0x7be  # offset +0x7be
.equ field_821, 0x821  # offset +0x821
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bc1, 0xbc1  # offset +0xbc1
.equ field_bc9, 0xbc9  # offset +0xbc9

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0048633c - 0x401000
.globl FUN_0048633c
FUN_0048633c:
    # block 0x0048633c: entry, 19 instruction(s), ends with jne to 0x0048639b (forward)
    push ebp                                     # 0048633c
    {load} mov ebp, esp                          # 0048633d
    sub esp, 0xe0                                # 0048633f
    push esi                                     # 00486345
    push edi                                     # 00486346
    mov dword ptr [ebp - local_e0], ecx          # 00486347
    mov dword ptr [ebp - local_10], 0x0          # 0048634d
    mov eax, dword ptr [ebp - local_e0]          # 00486354
    movsx ecx, word ptr [eax + field_26]         # 0048635a
    imul ecx, ecx, 0x8d                          # 0048635e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00486364
    mov dword ptr [ebp - local_c], edx           # 0048636a
    mov edi, 0x54dbb0                            # 0048636d
    mov esi, dword ptr [ebp - local_c]           # 00486372
    add esi, 0x74b                               # 00486375
    mov ecx, 0x9                                 # 0048637b
    {load} xor eax, eax                          # 00486380
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486382
    jne.d8 L_0048639b                            # 00486384
    # block 0x00486386: entered by fall-through of jne at 0x00486384, 3 instruction(s), ends with forward jump to 0x004866ae
    mov ecx, dword ptr [ebp - local_e0]          # 00486386
    mov dword ptr [ecx + field_bac], 0x0         # 0048638c
    jmp.d32 L_004866ae                           # 00486396
L_0048639b:
    # block 0x0048639b: entered by jne at 0x00486384, 15 instruction(s), calls FUN_0050cd50, ends with jle to 0x004864c8 (forward)
    mov esi, dword ptr [ebp - local_c]           # 0048639b
    add esi, 0x74b                               # 0048639e
    mov edi, dword ptr [ebp - local_e0]          # 004863a4
    add edi, 0xb21                               # 004863aa
    mov ecx, 0xc                                 # 004863b0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004863b5
    movsb byte ptr es:[edi], byte ptr [esi]      # 004863b7
    call FUN_0050cd50                            # 004863b8
    cdq                                          # 004863bd
    mov ecx, 0x3                                 # 004863be
    idiv ecx                                     # 004863c3
    mov word ptr [ebp - local_4], dx             # 004863c5
    movsx edx, word ptr [ebp - local_4]          # 004863c9
    test edx, edx                                # 004863cd
    jle.d32 L_004864c8                           # 004863cf
    # block 0x004863d5: entered by fall-through of jle at 0x004863cf, 1 instruction(s), falls into the block at 0x004863dc
    mov dword ptr [ebp - local_8], 0x0           # 004863d5
L_004863dc:
    # block 0x004863dc: entered by jmp at 0x004864c3, 2 instruction(s), ends with jne to 0x004864c8 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004863dc
    jne.d32 L_004864c8                           # 004863e0
    # block 0x004863e6: entered by fall-through of jne at 0x004863e0, 3 instruction(s), ends with jle to 0x004864c8 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004863e6
    test eax, eax                                # 004863ea
    jle.d32 L_004864c8                           # 004863ec
    # block 0x004863f2: entered by fall-through of jle at 0x004863ec, 3 instruction(s), ends with jne to 0x00486452 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004863f2
    cmp ecx, 0x1                                 # 004863f6
    jne.d8 L_00486452                            # 004863f9
    # block 0x004863fb: entered by fall-through of jne at 0x004863f9, 7 instruction(s), ends with je to 0x00486452 (forward)
    mov edi, 0x54dbbc                            # 004863fb
    mov esi, dword ptr [ebp - local_c]           # 00486400
    add esi, 0x77c                               # 00486403
    mov ecx, 0x9                                 # 00486409
    {load} xor edx, edx                          # 0048640e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486410
    je.d8 L_00486452                             # 00486412
    # block 0x00486414: entered by fall-through of je at 0x00486412, 21 instruction(s), ends with forward jump to 0x004864c3
    mov eax, dword ptr [ebp - local_c]           # 00486414
    add eax, 0x77c                               # 00486417
    {load} mov edi, eax                          # 0048641c
    mov ecx, dword ptr [ebp - local_e0]          # 0048641e
    add ecx, 0xb21                               # 00486424
    {load} mov edx, ecx                          # 0048642a
    or ecx, -0x1                                 # 0048642c
    {load} xor eax, eax                          # 0048642f
    repne scasb al, byte ptr es:[edi]            # 00486431
    not ecx                                      # 00486433
    {load} sub edi, ecx                          # 00486435
    {load} mov esi, edi                          # 00486437
    {load} mov eax, ecx                          # 00486439
    {load} mov edi, edx                          # 0048643b
    shr ecx, 0x2                                 # 0048643d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00486440
    {load} mov ecx, eax                          # 00486442
    and ecx, 0x3                                 # 00486444
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486447
    mov dword ptr [ebp - local_8], 0x1           # 00486449
    jmp.d8 L_004864c3                            # 00486450
L_00486452:
    # block 0x00486452: entered by jne at 0x004863f9; je at 0x00486412, 3 instruction(s), ends with jne to 0x004864b2 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00486452
    cmp ecx, 0x2                                 # 00486456
    jne.d8 L_004864b2                            # 00486459
    # block 0x0048645b: entered by fall-through of jne at 0x00486459, 7 instruction(s), ends with je to 0x004864b2 (forward)
    mov edi, 0x54dbc8                            # 0048645b
    mov esi, dword ptr [ebp - local_c]           # 00486460
    add esi, 0x79d                               # 00486463
    mov ecx, 0x9                                 # 00486469
    {load} xor edx, edx                          # 0048646e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486470
    je.d8 L_004864b2                             # 00486472
    # block 0x00486474: entered by fall-through of je at 0x00486472, 21 instruction(s), ends with forward jump to 0x004864c3
    mov eax, dword ptr [ebp - local_c]           # 00486474
    add eax, 0x79d                               # 00486477
    {load} mov edi, eax                          # 0048647c
    mov ecx, dword ptr [ebp - local_e0]          # 0048647e
    add ecx, 0xb21                               # 00486484
    {load} mov edx, ecx                          # 0048648a
    or ecx, -0x1                                 # 0048648c
    {load} xor eax, eax                          # 0048648f
    repne scasb al, byte ptr es:[edi]            # 00486491
    not ecx                                      # 00486493
    {load} sub edi, ecx                          # 00486495
    {load} mov esi, edi                          # 00486497
    {load} mov eax, ecx                          # 00486499
    {load} mov edi, edx                          # 0048649b
    shr ecx, 0x2                                 # 0048649d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004864a0
    {load} mov ecx, eax                          # 004864a2
    and ecx, 0x3                                 # 004864a4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004864a7
    mov dword ptr [ebp - local_8], 0x1           # 004864a9
    jmp.d8 L_004864c3                            # 004864b0
L_004864b2:
    # block 0x004864b2: entered by jne at 0x00486459; je at 0x00486472, 5 instruction(s), calls FUN_0050cd50, falls into the block at 0x004864c3
    call FUN_0050cd50                            # 004864b2
    cdq                                          # 004864b7
    mov ecx, 0x3                                 # 004864b8
    idiv ecx                                     # 004864bd
    mov word ptr [ebp - local_4], dx             # 004864bf
L_004864c3:
    # block 0x004864c3: entered by jmp at 0x00486450; jmp at 0x004864b0, 1 instruction(s), ends with backward jump to 0x004863dc
    jmp.d32 L_004863dc                           # 004864c3
L_004864c8:
    # block 0x004864c8: entered by jle at 0x004863cf; jne at 0x004863e0; jle at 0x004863ec, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00486677 (forward)
    mov edx, dword ptr [ebp - local_e0]          # 004864c8
    add edx, 0xb21                               # 004864ce
    push edx                                     # 004864d4
    mov ecx, 0x5c3a67                            # 004864d5
    call FUN_004fb77a                            # 004864da
    mov eax, dword ptr [ebp - local_c]           # 004864df
    mov cx, word ptr [eax + field_76c]           # 004864e2
    push ecx                                     # 004864e9
    mov ecx, 0x5c3a67                            # 004864ea
    call FUN_004fb2e3                            # 004864ef
    cmp dword ptr [0x5bb202], 0x0                # 004864f4
    je.d32 L_00486677                            # 004864fb
    # block 0x00486501: entered by fall-through of je at 0x004864fb, 11 instruction(s), ends with jbe to 0x004865cf (forward)
    movsx edx, word ptr [ebp - local_4]          # 00486501
    imul edx, edx, 0x21                          # 00486505
    mov eax, dword ptr [ebp - local_c]           # 00486508
    lea edi, [eax + edx + field_7be]             # 0048650b
    or ecx, -0x1                                 # 00486512
    {load} xor eax, eax                          # 00486515
    repne scasb al, byte ptr es:[edi]            # 00486517
    not ecx                                      # 00486519
    add ecx, -0x1                                # 0048651b
    test ecx, ecx                                # 0048651e
    jbe.d32 L_004865cf                           # 00486520
    # block 0x00486526: entered by fall-through of jbe at 0x00486520, 10 instruction(s), calls FUN_00423259, ends with je to 0x004865c8 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00486526
    imul ecx, ecx, 0x21                          # 0048652a
    mov edx, dword ptr [ebp - local_c]           # 0048652d
    lea eax, [edx + ecx + field_7be]             # 00486530
    push eax                                     # 00486537
    mov ecx, 0x619a6b                            # 00486538
    call FUN_00423259                            # 0048653d
    mov dword ptr [ebp - local_10], eax          # 00486542
    cmp dword ptr [ebp - local_10], 0x0          # 00486545
    je.d8 L_004865c8                             # 00486549
    # block 0x0048654b: entered by fall-through of je at 0x00486549, 8 instruction(s), ends with ja to 0x004865c8 (forward)
    mov edi, dword ptr [ebp - local_10]          # 0048654b
    or ecx, -0x1                                 # 0048654e
    {load} xor eax, eax                          # 00486551
    repne scasb al, byte ptr es:[edi]            # 00486553
    not ecx                                      # 00486555
    add ecx, -0x1                                # 00486557
    cmp ecx, 0x9c40                              # 0048655a
    ja.d8 L_004865c8                             # 00486560
    # block 0x00486562: entered by fall-through of ja at 0x00486560, 30 instruction(s), calls FUN_00448d11, ends with forward jump to 0x004865cf
    mov edi, dword ptr [ebp - local_10]          # 00486562
    or ecx, -0x1                                 # 00486565
    {load} xor eax, eax                          # 00486568
    repne scasb al, byte ptr es:[edi]            # 0048656a
    not ecx                                      # 0048656c
    mov esi, dword ptr [ebp - local_10]          # 0048656e
    lea edi, [ebp - local_dc]                    # 00486571
    {load} mov edx, ecx                          # 00486577
    shr ecx, 0x2                                 # 00486579
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048657c
    {load} mov ecx, edx                          # 0048657e
    and ecx, 0x3                                 # 00486580
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486583
    lea edi, [ebp - local_dc]                    # 00486585
    or ecx, -0x1                                 # 0048658b
    {load} xor eax, eax                          # 0048658e
    repne scasb al, byte ptr es:[edi]            # 00486590
    mov eax, dword ptr [0x54dbd4]                # 00486592
    mov dword ptr [edi - field_minus_1], eax     # 00486597
    push 0x0                                     # 0048659a
    push -0x1                                    # 0048659c
    lea ecx, [ebp - local_dc]                    # 0048659e
    push ecx                                     # 004865a4
    mov edx, dword ptr [0x5d03b3]                # 004865a5
    push edx                                     # 004865ab
    mov ecx, 0x619a05                            # 004865ac
    call FUN_00448d11                            # 004865b1
    mov eax, dword ptr [ebp - local_e0]          # 004865b6
    mov dword ptr [eax + field_bc1], 0x1         # 004865bc
    jmp.d8 L_004865cf                            # 004865c6
L_004865c8:
    # block 0x004865c8: entered by je at 0x00486549; ja at 0x00486560, 1 instruction(s), falls into the block at 0x004865cf
    mov dword ptr [ebp - local_10], 0x0          # 004865c8
L_004865cf:
    # block 0x004865cf: entered by jbe at 0x00486520; jmp at 0x004865c6, 2 instruction(s), ends with jne to 0x00486677 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 004865cf
    jne.d32 L_00486677                           # 004865d3
    # block 0x004865d9: entered by fall-through of jne at 0x004865d3, 11 instruction(s), ends with jbe to 0x00486677 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004865d9
    imul ecx, ecx, 0xc8                          # 004865dd
    mov edx, dword ptr [ebp - local_c]           # 004865e3
    lea edi, [edx + ecx + field_821]             # 004865e6
    or ecx, -0x1                                 # 004865ed
    {load} xor eax, eax                          # 004865f0
    repne scasb al, byte ptr es:[edi]            # 004865f2
    not ecx                                      # 004865f4
    add ecx, -0x1                                # 004865f6
    test ecx, ecx                                # 004865f9
    jbe.d8 L_00486677                            # 004865fb
    # block 0x004865fd: entered by fall-through of jbe at 0x004865fb, 35 instruction(s), calls FUN_00448d11, falls into the block at 0x00486677
    movsx eax, word ptr [ebp - local_4]          # 004865fd
    imul eax, eax, 0xc8                          # 00486601
    mov ecx, dword ptr [ebp - local_c]           # 00486607
    lea edx, [ecx + eax + field_821]             # 0048660a
    {load} mov edi, edx                          # 00486611
    lea edx, [ebp - local_dc]                    # 00486613
    or ecx, -0x1                                 # 00486619
    {load} xor eax, eax                          # 0048661c
    repne scasb al, byte ptr es:[edi]            # 0048661e
    not ecx                                      # 00486620
    {load} sub edi, ecx                          # 00486622
    {load} mov esi, edi                          # 00486624
    {load} mov eax, ecx                          # 00486626
    {load} mov edi, edx                          # 00486628
    shr ecx, 0x2                                 # 0048662a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048662d
    {load} mov ecx, eax                          # 0048662f
    and ecx, 0x3                                 # 00486631
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486634
    lea edi, [ebp - local_dc]                    # 00486636
    or ecx, -0x1                                 # 0048663c
    {load} xor eax, eax                          # 0048663f
    repne scasb al, byte ptr es:[edi]            # 00486641
    mov ecx, dword ptr [0x54dbd8]                # 00486643
    mov dword ptr [edi - field_minus_1], ecx     # 00486649
    push 0x0                                     # 0048664c
    push -0x1                                    # 0048664e
    lea edx, [ebp - local_dc]                    # 00486650
    push edx                                     # 00486656
    mov eax, dword ptr [0x5d03b3]                # 00486657
    push eax                                     # 0048665c
    mov ecx, 0x619a05                            # 0048665d
    call FUN_00448d11                            # 00486662
    mov ecx, dword ptr [ebp - local_e0]          # 00486667
    mov dword ptr [ecx + field_bc1], 0x1         # 0048666d
L_00486677:
    # block 0x00486677: entered by je at 0x004864fb; jne at 0x004865d3; jbe at 0x004865fb, 8 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004866ae
    mov edx, dword ptr [ebp - local_e0]          # 00486677
    mov dword ptr [edx + field_bac], 0x2         # 0048667d
    mov eax, dword ptr [ebp - local_e0]          # 00486687
    mov dword ptr [eax + field_bc1], 0x1         # 0048668d
    call dword ptr [0x52a23c]                    # 00486697
    add eax, 0x7d0                               # 0048669d
    mov ecx, dword ptr [ebp - local_e0]          # 004866a2
    mov dword ptr [ecx + field_bc9], eax         # 004866a8
L_004866ae:
    # block 0x004866ae: entered by jmp at 0x00486396, 5 instruction(s), ends with ret
    pop edi                                      # 004866ae
    pop esi                                      # 004866af
    {load} mov esp, ebp                          # 004866b0
    pop ebp                                      # 004866b2
    ret                                          # 004866b3

