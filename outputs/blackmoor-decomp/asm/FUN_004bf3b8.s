# FUN_004bf3b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf3b8
# extent:       0x004bf3b8-0x004bf52a (370 code bytes)
# span:         0x004bf3b8-0x004bf542 (code 370, tables 24, padding 0)
# sha256:       fc8deb03127d18e7a434d1ff19f77c5ecdbc957078bf6415e28407720e0f9a9e
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf3b8_set_text
# naming:       native port src/original_methods_fl33a.c:m4bf3b8_set_text (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Selects by [self+0x2c0]+6 (unsigned, jump table of 6): copies one of five game strings to self+0xc0 or formats it through 0x50ca3e (one case with BinkGetError); returns self+0xc0; 130/130 instructions, 2/2.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2c0
# callees:      calls FUN_0050ca3e, binkw32.dll!_BinkGetError@0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33a.c:m4bf3b8_set_text (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 130 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004bf3b8 - 0x401000
.globl FUN_004bf3b8
FUN_004bf3b8:
    # block 0x004bf3b8: entry, 14 instruction(s), ends with ja to 0x004bf4ed (forward)
    push ebp                                     # 004bf3b8
    {load} mov ebp, esp                          # 004bf3b9
    sub esp, 0x8                                 # 004bf3bb
    push esi                                     # 004bf3be
    push edi                                     # 004bf3bf
    mov dword ptr [ebp - local_4], ecx           # 004bf3c0
    mov eax, dword ptr [ebp - local_4]           # 004bf3c3
    mov ecx, dword ptr [eax + field_2c0]         # 004bf3c6
    mov dword ptr [ebp - local_8], ecx           # 004bf3cc
    mov edx, dword ptr [ebp - local_8]           # 004bf3cf
    add edx, 0x6                                 # 004bf3d2
    mov dword ptr [ebp - local_8], edx           # 004bf3d5
    cmp dword ptr [ebp - local_8], 0x5           # 004bf3d8
    ja.d32 L_004bf4ed                            # 004bf3dc
    # block 0x004bf3e2: entered by fall-through of ja at 0x004bf3dc, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4bf52a]
    mov eax, dword ptr [ebp - local_8]           # 004bf3e2
    jmp dword ptr [4*eax + SWTAB_004bf52a_VA]    # 004bf3e5
L_004bf3ec:
    # block 0x004bf3ec: entered by switch case, 18 instruction(s), ends with forward jump to 0x004bf51a
    mov edi, 0x552494                            # 004bf3ec
    mov ecx, dword ptr [ebp - local_4]           # 004bf3f1
    add ecx, 0xc0                                # 004bf3f4
    {load} mov edx, ecx                          # 004bf3fa
    or ecx, -0x1                                 # 004bf3fc
    {load} xor eax, eax                          # 004bf3ff
    repne scasb al, byte ptr es:[edi]            # 004bf401
    not ecx                                      # 004bf403
    {load} sub edi, ecx                          # 004bf405
    {load} mov esi, edi                          # 004bf407
    {load} mov eax, ecx                          # 004bf409
    {load} mov edi, edx                          # 004bf40b
    shr ecx, 0x2                                 # 004bf40d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf410
    {load} mov ecx, eax                          # 004bf412
    and ecx, 0x3                                 # 004bf414
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf417
    jmp.d32 L_004bf51a                           # 004bf419
L_004bf41e:
    # block 0x004bf41e: entered by switch case, 18 instruction(s), ends with forward jump to 0x004bf51a
    mov edi, 0x5524bc                            # 004bf41e
    mov ecx, dword ptr [ebp - local_4]           # 004bf423
    add ecx, 0xc0                                # 004bf426
    {load} mov edx, ecx                          # 004bf42c
    or ecx, -0x1                                 # 004bf42e
    {load} xor eax, eax                          # 004bf431
    repne scasb al, byte ptr es:[edi]            # 004bf433
    not ecx                                      # 004bf435
    {load} sub edi, ecx                          # 004bf437
    {load} mov esi, edi                          # 004bf439
    {load} mov eax, ecx                          # 004bf43b
    {load} mov edi, edx                          # 004bf43d
    shr ecx, 0x2                                 # 004bf43f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf442
    {load} mov ecx, eax                          # 004bf444
    and ecx, 0x3                                 # 004bf446
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf449
    jmp.d32 L_004bf51a                           # 004bf44b
L_004bf450:
    # block 0x004bf450: entered by switch case, 18 instruction(s), ends with forward jump to 0x004bf51a
    mov edi, 0x5524e4                            # 004bf450
    mov ecx, dword ptr [ebp - local_4]           # 004bf455
    add ecx, 0xc0                                # 004bf458
    {load} mov edx, ecx                          # 004bf45e
    or ecx, -0x1                                 # 004bf460
    {load} xor eax, eax                          # 004bf463
    repne scasb al, byte ptr es:[edi]            # 004bf465
    not ecx                                      # 004bf467
    {load} sub edi, ecx                          # 004bf469
    {load} mov esi, edi                          # 004bf46b
    {load} mov eax, ecx                          # 004bf46d
    {load} mov edi, edx                          # 004bf46f
    shr ecx, 0x2                                 # 004bf471
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf474
    {load} mov ecx, eax                          # 004bf476
    and ecx, 0x3                                 # 004bf478
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf47b
    jmp.d32 L_004bf51a                           # 004bf47d
L_004bf482:
    # block 0x004bf482: entered by switch case, 18 instruction(s), ends with forward jump to 0x004bf51a
    mov edi, 0x552508                            # 004bf482
    mov ecx, dword ptr [ebp - local_4]           # 004bf487
    add ecx, 0xc0                                # 004bf48a
    {load} mov edx, ecx                          # 004bf490
    or ecx, -0x1                                 # 004bf492
    {load} xor eax, eax                          # 004bf495
    repne scasb al, byte ptr es:[edi]            # 004bf497
    not ecx                                      # 004bf499
    {load} sub edi, ecx                          # 004bf49b
    {load} mov esi, edi                          # 004bf49d
    {load} mov eax, ecx                          # 004bf49f
    {load} mov edi, edx                          # 004bf4a1
    shr ecx, 0x2                                 # 004bf4a3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf4a6
    {load} mov ecx, eax                          # 004bf4a8
    and ecx, 0x3                                 # 004bf4aa
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf4ad
    jmp.d8 L_004bf51a                            # 004bf4af
L_004bf4b1:
    # block 0x004bf4b1: entered by switch case, 9 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004bf51a
    mov ecx, dword ptr [ebp + arg_8]             # 004bf4b1
    push ecx                                     # 004bf4b4
    push 0x552540                                # 004bf4b5
    mov edx, dword ptr [ebp - local_4]           # 004bf4ba
    add edx, 0xc0                                # 004bf4bd
    push edx                                     # 004bf4c3
    call FUN_0050ca3e                            # 004bf4c4
    add esp, 0xc                                 # 004bf4c9
    jmp.d8 L_004bf51a                            # 004bf4cc
L_004bf4ce:
    # block 0x004bf4ce: entered by switch case, 9 instruction(s), calls binkw32.dll!_BinkGetError@0, FUN_0050ca3e, ends with forward jump to 0x004bf51a
    call dword ptr [0x52a514]                    # 004bf4ce
    push eax                                     # 004bf4d4
    push 0x552564                                # 004bf4d5
    mov eax, dword ptr [ebp - local_4]           # 004bf4da
    add eax, 0xc0                                # 004bf4dd
    push eax                                     # 004bf4e2
    call FUN_0050ca3e                            # 004bf4e3
    add esp, 0xc                                 # 004bf4e8
    jmp.d8 L_004bf51a                            # 004bf4eb
L_004bf4ed:
    # block 0x004bf4ed: entered by ja at 0x004bf3dc, 17 instruction(s), falls into the block at 0x004bf51a
    mov edi, 0x552594                            # 004bf4ed
    mov ecx, dword ptr [ebp - local_4]           # 004bf4f2
    add ecx, 0xc0                                # 004bf4f5
    {load} mov edx, ecx                          # 004bf4fb
    or ecx, -0x1                                 # 004bf4fd
    {load} xor eax, eax                          # 004bf500
    repne scasb al, byte ptr es:[edi]            # 004bf502
    not ecx                                      # 004bf504
    {load} sub edi, ecx                          # 004bf506
    {load} mov esi, edi                          # 004bf508
    {load} mov eax, ecx                          # 004bf50a
    {load} mov edi, edx                          # 004bf50c
    shr ecx, 0x2                                 # 004bf50e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf511
    {load} mov ecx, eax                          # 004bf513
    and ecx, 0x3                                 # 004bf515
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf518
L_004bf51a:
    # block 0x004bf51a: entered by jmp at 0x004bf419; jmp at 0x004bf44b; jmp at 0x004bf47d; jmp at 0x004bf4af; more, 7 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004bf51a
    add eax, 0xc0                                # 004bf51d
    pop edi                                      # 004bf522
    pop esi                                      # 004bf523
    {load} mov esp, ebp                          # 004bf524
    pop ebp                                      # 004bf526
    ret 0x4                                      # 004bf527

# --- data items (not part of the function) -------------------------
.org 0x004bf52a - 0x401000
SWTAB_004bf52a:  # 6 case address(es)
    .long L_004bf4ce - .text + 0x401000
    .long L_004bf4b1 - .text + 0x401000
    .long L_004bf482 - .text + 0x401000
    .long L_004bf450 - .text + 0x401000
    .long L_004bf3ec - .text + 0x401000
    .long L_004bf41e - .text + 0x401000
.set SWTAB_004bf52a_VA, SWTAB_004bf52a - .text + 0x401000

