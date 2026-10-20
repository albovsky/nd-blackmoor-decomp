# FUN_004e72fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e72fb
# extent:       0x004e72fb-0x004e7512 (535 code bytes)
# span:         0x004e72fb-0x004e7512 (code 535, tables 0, padding 0)
# sha256:       3874a0680c241dc208291d7f7869de37e95da220eb99b5deb49558cfa0f3c379
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action83_runtime_step
# naming:       native port src/action_family_83_runtime.c:action83_runtime_step (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the summary is the acceptance note
# summary:      Mail and web branches, widths and stores match. Oracle runs the original dispatcher with the real 0x4e72fb over the corpus, 0 mismatches. Gate skip and phase pass-through are native extras; refresh is a callback.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [ecx + n] field_44; [edx + n] field_46, field_48
# callees:      calls FUN_004e444d, FUN_004e0559
# track-n:      outputs/blackmoor-decomp/src/action_family_83_runtime.c:action83_runtime_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 165 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_44, 0x44  # offset +0x44
.equ field_46, 0x46  # offset +0x46
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e444d, .text + (0x004e444d - 0x401000)

.org 0x004e72fb - 0x401000
.globl FUN_004e72fb
FUN_004e72fb:
    # block 0x004e72fb: entry, 14 instruction(s), ends with jne to 0x004e7452 (forward)
    push ebp                                     # 004e72fb
    {load} mov ebp, esp                          # 004e72fc
    sub esp, 0x10                                # 004e72fe
    push esi                                     # 004e7301
    push edi                                     # 004e7302
    mov dword ptr [ebp - local_10], ecx          # 004e7303
    movsx eax, word ptr [ebp + arg_8]            # 004e7306
    imul eax, eax, 0x8d                          # 004e730a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004e7310
    mov dword ptr [ebp - local_c], ecx           # 004e7316
    mov edx, dword ptr [ebp - local_c]           # 004e7319
    movsx eax, word ptr [edx]                    # 004e731c
    test eax, eax                                # 004e731f
    jne.d32 L_004e7452                           # 004e7321
    # block 0x004e7327: entered by fall-through of jne at 0x004e7321, 10 instruction(s), calls FUN_004e444d, ends with jne to 0x004e739e (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e7327
    add ecx, 0x2                                 # 004e732a
    push ecx                                     # 004e732d
    lea edx, [ebp - local_8]                     # 004e732e
    push edx                                     # 004e7331
    push 0x0                                     # 004e7332
    mov ecx, dword ptr [ebp - local_10]          # 004e7334
    call FUN_004e444d                            # 004e7337
    test eax, eax                                # 004e733c
    jne.d8 L_004e739e                            # 004e733e
    # block 0x004e7340: entered by fall-through of jne at 0x004e733e, 3 instruction(s), ends with forward jump to 0x004e7358
    mov ax, word ptr [0x5a1e5e]                  # 004e7340
    mov word ptr [ebp - local_4], ax             # 004e7346
    jmp.d8 L_004e7358                            # 004e734a
L_004e734c:
    # block 0x004e734c: entered by jmp at 0x004e7386, 3 instruction(s), falls into the block at 0x004e7358
    mov cx, word ptr [ebp - local_4]             # 004e734c
    sub cx, 0x1                                  # 004e7350
    mov word ptr [ebp - local_4], cx             # 004e7354
L_004e7358:
    # block 0x004e7358: entered by jmp at 0x004e734a, 3 instruction(s), ends with jle to 0x004e7388 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e7358
    test edx, edx                                # 004e735c
    jle.d8 L_004e7388                            # 004e735e
    # block 0x004e7360: entered by fall-through of jle at 0x004e735e, 11 instruction(s), ends with backward jump to 0x004e734c
    movsx esi, word ptr [ebp - local_4]          # 004e7360
    sub esi, 0x1                                 # 004e7364
    imul esi, esi, 0x4a                          # 004e7367
    add esi, 0x5a2664                            # 004e736a
    movsx edi, word ptr [ebp - local_4]          # 004e7370
    imul edi, edi, 0x4a                          # 004e7374
    add edi, 0x5a2664                            # 004e7377
    mov ecx, 0x12                                # 004e737d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e7382
    movsw word ptr es:[edi], word ptr [esi]      # 004e7384
    jmp.d8 L_004e734c                            # 004e7386
L_004e7388:
    # block 0x004e7388: entered by jle at 0x004e735e, 4 instruction(s), falls into the block at 0x004e739e
    mov word ptr [ebp - local_8], 0x0            # 004e7388
    mov ax, word ptr [0x5a1e5e]                  # 004e738e
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e7394
    mov word ptr [0x5a1e5e], ax                  # 004e7398
L_004e739e:
    # block 0x004e739e: entered by jne at 0x004e733e, 57 instruction(s), calls FUN_004e0559, ends with forward jump to 0x004e750a
    mov ecx, dword ptr [ebp - local_c]           # 004e739e
    add ecx, 0x2                                 # 004e73a1
    {load} mov edi, ecx                          # 004e73a4
    movsx edx, word ptr [ebp - local_8]          # 004e73a6
    imul edx, edx, 0x4a                          # 004e73aa
    add edx, 0x5a2664                            # 004e73ad
    or ecx, -0x1                                 # 004e73b3
    {load} xor eax, eax                          # 004e73b6
    repne scasb al, byte ptr es:[edi]            # 004e73b8
    not ecx                                      # 004e73ba
    {load} sub edi, ecx                          # 004e73bc
    {load} mov esi, edi                          # 004e73be
    {load} mov eax, ecx                          # 004e73c0
    {load} mov edi, edx                          # 004e73c2
    shr ecx, 0x2                                 # 004e73c4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e73c7
    {load} mov ecx, eax                          # 004e73c9
    and ecx, 0x3                                 # 004e73cb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e73ce
    mov ecx, dword ptr [ebp - local_c]           # 004e73d0
    add ecx, 0x23                                # 004e73d3
    {load} mov edi, ecx                          # 004e73d6
    movsx edx, word ptr [ebp - local_8]          # 004e73d8
    imul edx, edx, 0x4a                          # 004e73dc
    add edx, 0x5a2685                            # 004e73df
    or ecx, -0x1                                 # 004e73e5
    {load} xor eax, eax                          # 004e73e8
    repne scasb al, byte ptr es:[edi]            # 004e73ea
    not ecx                                      # 004e73ec
    {load} sub edi, ecx                          # 004e73ee
    {load} mov esi, edi                          # 004e73f0
    {load} mov eax, ecx                          # 004e73f2
    {load} mov edi, edx                          # 004e73f4
    shr ecx, 0x2                                 # 004e73f6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e73f9
    {load} mov ecx, eax                          # 004e73fb
    and ecx, 0x3                                 # 004e73fd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e7400
    movsx ecx, word ptr [ebp - local_8]          # 004e7402
    imul ecx, ecx, 0x4a                          # 004e7406
    mov edx, dword ptr [ebp - local_c]           # 004e7409
    mov ax, word ptr [edx + field_46]            # 004e740c
    mov word ptr [ecx + 0x5a26a6], ax            # 004e7410
    movsx ecx, word ptr [ebp - local_8]          # 004e7417
    imul ecx, ecx, 0x4a                          # 004e741b
    mov edx, dword ptr [ebp - local_c]           # 004e741e
    mov ax, word ptr [edx + field_48]            # 004e7421
    mov word ptr [ecx + 0x5a26a8], ax            # 004e7425
    movsx ecx, word ptr [ebp - local_8]          # 004e742c
    imul ecx, ecx, 0x4a                          # 004e7430
    mov dword ptr [ecx + 0x5a26aa], 0x0          # 004e7433
    push 0x1                                     # 004e743d
    push 0x1                                     # 004e743f
    push 0x3                                     # 004e7441
    mov ecx, 0x570508                            # 004e7443
    call FUN_004e0559                            # 004e7448
    jmp.d32 L_004e750a                           # 004e744d
L_004e7452:
    # block 0x004e7452: entered by jne at 0x004e7321, 10 instruction(s), calls FUN_004e444d, ends with jne to 0x004e7488 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e7452
    add edx, 0x2                                 # 004e7455
    push edx                                     # 004e7458
    lea eax, [ebp - local_8]                     # 004e7459
    push eax                                     # 004e745c
    push 0x1                                     # 004e745d
    mov ecx, dword ptr [ebp - local_10]          # 004e745f
    call FUN_004e444d                            # 004e7462
    test eax, eax                                # 004e7467
    jne.d8 L_004e7488                            # 004e7469
    # block 0x004e746b: entered by fall-through of jne at 0x004e7469, 5 instruction(s), falls into the block at 0x004e7488
    mov cx, word ptr [0x5a1e60]                  # 004e746b
    mov word ptr [ebp - local_8], cx             # 004e7472
    mov dx, word ptr [0x5a1e60]                  # 004e7476
    add dx, 0x1                                  # 004e747d
    mov word ptr [0x5a1e60], dx                  # 004e7481
L_004e7488:
    # block 0x004e7488: entered by jne at 0x004e7469, 40 instruction(s), calls FUN_004e0559, falls into the block at 0x004e750a
    mov eax, dword ptr [ebp - local_c]           # 004e7488
    add eax, 0x2                                 # 004e748b
    {load} mov edi, eax                          # 004e748e
    movsx ecx, word ptr [ebp - local_8]          # 004e7490
    imul ecx, ecx, 0x29                          # 004e7494
    add ecx, 0x5a434c                            # 004e7497
    {load} mov edx, ecx                          # 004e749d
    or ecx, -0x1                                 # 004e749f
    {load} xor eax, eax                          # 004e74a2
    repne scasb al, byte ptr es:[edi]            # 004e74a4
    not ecx                                      # 004e74a6
    {load} sub edi, ecx                          # 004e74a8
    {load} mov esi, edi                          # 004e74aa
    {load} mov eax, ecx                          # 004e74ac
    {load} mov edi, edx                          # 004e74ae
    shr ecx, 0x2                                 # 004e74b0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e74b3
    {load} mov ecx, eax                          # 004e74b5
    and ecx, 0x3                                 # 004e74b7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e74ba
    movsx ecx, word ptr [ebp - local_8]          # 004e74bc
    imul ecx, ecx, 0x29                          # 004e74c0
    mov edx, dword ptr [ebp - local_c]           # 004e74c3
    mov ax, word ptr [edx + field_46]            # 004e74c6
    mov word ptr [ecx + 0x5a436d], ax            # 004e74ca
    movsx ecx, word ptr [ebp - local_8]          # 004e74d1
    imul ecx, ecx, 0x29                          # 004e74d5
    mov edx, dword ptr [ebp - local_c]           # 004e74d8
    mov ax, word ptr [edx + field_48]            # 004e74db
    mov word ptr [ecx + 0x5a436f], ax            # 004e74df
    mov ecx, dword ptr [ebp - local_c]           # 004e74e6
    movsx edx, word ptr [ecx + field_44]         # 004e74e9
    movsx eax, word ptr [ebp - local_8]          # 004e74ed
    imul eax, eax, 0x29                          # 004e74f1
    mov dword ptr [eax + 0x5a4371], edx          # 004e74f4
    push 0x2                                     # 004e74fa
    push 0x1                                     # 004e74fc
    push 0x3                                     # 004e74fe
    mov ecx, 0x570508                            # 004e7500
    call FUN_004e0559                            # 004e7505
L_004e750a:
    # block 0x004e750a: entered by jmp at 0x004e744d, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004e750a
    pop esi                                      # 004e750b
    {load} mov esp, ebp                          # 004e750c
    pop ebp                                      # 004e750e
    ret 0x4                                      # 004e750f

