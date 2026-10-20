# FUN_0044d28c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d28c
# extent:       0x0044d28c-0x0044d597 (779 code bytes)
# span:         0x0044d28c-0x0044d597 (code 779, tables 0, padding 0)
# sha256:       5122b89df40c45c230f74e9cc21d9a09296e413aaa44038595344255321cf200
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44d28c_click
# naming:       native port src/original_methods_fl20b.c:m44d28c_click (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m44d28c_click. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 779 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_25, field_29, field_2d, field_35, field_39, field_55, field_59, field_65, field_69, field_75, field_79, field_81 and 5 more; [ecx + n] field_24, field_25, field_29, field_2d, field_31, field_51, field_61, field_71, field_8d, field_9d, field_a5, field_a9 and 1 more; [edx + n] field_1e, field_21, field_24, field_29, field_3d, field_5d, field_6d, field_7d, field_85, field_89, field_8d, field_95 and 3 more
# callees:      calls FUN_0044d597
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20b.c:m44d28c_click (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 226 instruction(s), 42 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_51, 0x51  # offset +0x51
.equ field_55, 0x55  # offset +0x55
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_69, 0x69  # offset +0x69
.equ field_6d, 0x6d  # offset +0x6d
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75
.equ field_79, 0x79  # offset +0x79
.equ field_7d, 0x7d  # offset +0x7d
.equ field_81, 0x81  # offset +0x81
.equ field_85, 0x85  # offset +0x85
.equ field_89, 0x89  # offset +0x89
.equ field_8d, 0x8d  # offset +0x8d
.equ field_91, 0x91  # offset +0x91
.equ field_95, 0x95  # offset +0x95
.equ field_99, 0x99  # offset +0x99
.equ field_9d, 0x9d  # offset +0x9d
.equ field_a1, 0xa1  # offset +0xa1
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ad, 0xad  # offset +0xad
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b5, 0xb5  # offset +0xb5
.equ field_b9, 0xb9  # offset +0xb9
.equ field_bd, 0xbd  # offset +0xbd

# --- external targets -----------------------------------------------
.set FUN_0044d597, .text + (0x0044d597 - 0x401000)

.org 0x0044d28c - 0x401000
.globl FUN_0044d28c
FUN_0044d28c:
    # block 0x0044d28c: entry, 7 instruction(s), ends with je to 0x0044d588 (forward)
    push ebp                                     # 0044d28c
    {load} mov ebp, esp                          # 0044d28d
    sub esp, 0x8                                 # 0044d28f
    mov dword ptr [ebp - local_8], ecx           # 0044d292
    mov eax, dword ptr [ebp - local_8]           # 0044d295
    cmp dword ptr [eax + field_25], 0x0          # 0044d298
    je.d32 L_0044d588                            # 0044d29c
    # block 0x0044d2a2: entered by fall-through of je at 0x0044d29c, 11 instruction(s), ends with jg to 0x0044d2e9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044d2a2
    mov byte ptr [ecx + field_24], 0x1           # 0044d2a5
    mov edx, dword ptr [ebp - local_8]           # 0044d2a9
    movsx eax, word ptr [edx + field_1e]         # 0044d2ac
    imul eax, eax, 0x8d                          # 0044d2b0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044d2b6
    mov dword ptr [ebp - local_4], ecx           # 0044d2bc
    movsx edx, word ptr [ebp + arg_8]            # 0044d2bf
    mov eax, dword ptr [ebp - local_4]           # 0044d2c3
    cmp edx, dword ptr [eax + field_99]          # 0044d2c6
    jg.d8 L_0044d2e9                             # 0044d2cc
    # block 0x0044d2ce: entered by fall-through of jg at 0x0044d2cc, 4 instruction(s), ends with jg to 0x0044d2e9 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d2ce
    mov edx, dword ptr [ebp - local_4]           # 0044d2d2
    cmp ecx, dword ptr [edx + field_8d]          # 0044d2d5
    jg.d8 L_0044d2e9                             # 0044d2db
    # block 0x0044d2dd: entered by fall-through of jg at 0x0044d2db, 4 instruction(s), ends with jge to 0x0044d2fa (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d2dd
    mov ecx, dword ptr [ebp - local_4]           # 0044d2e1
    cmp eax, dword ptr [ecx + field_51]          # 0044d2e4
    jge.d8 L_0044d2fa                            # 0044d2e7
L_0044d2e9:
    # block 0x0044d2e9: entered by jg at 0x0044d2cc; jg at 0x0044d2db; fall-through of jge at 0x0044d2e7, 4 instruction(s), ends with forward jump to 0x0044d591
    mov edx, dword ptr [ebp - local_8]           # 0044d2e9
    mov dword ptr [edx + field_29], 0x0          # 0044d2ec
    {load} xor eax, eax                          # 0044d2f3
    jmp.d32 L_0044d591                           # 0044d2f5
L_0044d2fa:
    # block 0x0044d2fa: entered by jge at 0x0044d2e7, 5 instruction(s), ends with jne to 0x0044d351 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0044d2fa
    mov dword ptr [eax + field_29], 0x1          # 0044d2fd
    mov ecx, dword ptr [ebp - local_8]           # 0044d304
    cmp dword ptr [ecx + field_2d], 0x0          # 0044d307
    jne.d8 L_0044d351                            # 0044d30b
    # block 0x0044d30d: entered by fall-through of jne at 0x0044d30b, 4 instruction(s), ends with jl to 0x0044d351 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d30d
    mov eax, dword ptr [ebp - local_4]           # 0044d311
    cmp edx, dword ptr [eax + field_65]          # 0044d314
    jl.d8 L_0044d351                             # 0044d317
    # block 0x0044d319: entered by fall-through of jl at 0x0044d317, 4 instruction(s), ends with jg to 0x0044d351 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d319
    mov edx, dword ptr [ebp - local_4]           # 0044d31d
    cmp ecx, dword ptr [edx + field_6d]          # 0044d320
    jg.d8 L_0044d351                             # 0044d323
    # block 0x0044d325: entered by fall-through of jg at 0x0044d323, 4 instruction(s), ends with jl to 0x0044d351 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d325
    mov ecx, dword ptr [ebp - local_4]           # 0044d329
    cmp eax, dword ptr [ecx + field_61]          # 0044d32c
    jl.d8 L_0044d351                             # 0044d32f
    # block 0x0044d331: entered by fall-through of jl at 0x0044d32f, 4 instruction(s), ends with jg to 0x0044d351 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d331
    mov eax, dword ptr [ebp - local_4]           # 0044d335
    cmp edx, dword ptr [eax + field_69]          # 0044d338
    jg.d8 L_0044d351                             # 0044d33b
    # block 0x0044d33d: entered by fall-through of jg at 0x0044d33b, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x1                                     # 0044d33d
    mov ecx, dword ptr [ebp - local_8]           # 0044d33f
    call FUN_0044d597                            # 0044d342
    mov eax, 0x1                                 # 0044d347
    jmp.d32 L_0044d591                           # 0044d34c
L_0044d351:
    # block 0x0044d351: entered by jne at 0x0044d30b; jl at 0x0044d317; jg at 0x0044d323; jl at 0x0044d32f; jg at 0x0044d33b, 3 instruction(s), ends with jne to 0x0044d486 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044d351
    cmp dword ptr [ecx + field_2d], 0x1          # 0044d354
    jne.d32 L_0044d486                           # 0044d358
    # block 0x0044d35e: entered by fall-through of jne at 0x0044d358, 4 instruction(s), ends with jl to 0x0044d3a2 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d35e
    mov eax, dword ptr [ebp - local_4]           # 0044d362
    cmp edx, dword ptr [eax + field_55]          # 0044d365
    jl.d8 L_0044d3a2                             # 0044d368
    # block 0x0044d36a: entered by fall-through of jl at 0x0044d368, 4 instruction(s), ends with jg to 0x0044d3a2 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d36a
    mov edx, dword ptr [ebp - local_4]           # 0044d36e
    cmp ecx, dword ptr [edx + field_5d]          # 0044d371
    jg.d8 L_0044d3a2                             # 0044d374
    # block 0x0044d376: entered by fall-through of jg at 0x0044d374, 4 instruction(s), ends with jl to 0x0044d3a2 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d376
    mov ecx, dword ptr [ebp - local_4]           # 0044d37a
    cmp eax, dword ptr [ecx + field_51]          # 0044d37d
    jl.d8 L_0044d3a2                             # 0044d380
    # block 0x0044d382: entered by fall-through of jl at 0x0044d380, 4 instruction(s), ends with jg to 0x0044d3a2 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d382
    mov eax, dword ptr [ebp - local_4]           # 0044d386
    cmp edx, dword ptr [eax + field_59]          # 0044d389
    jg.d8 L_0044d3a2                             # 0044d38c
    # block 0x0044d38e: entered by fall-through of jg at 0x0044d38c, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x0                                     # 0044d38e
    mov ecx, dword ptr [ebp - local_8]           # 0044d390
    call FUN_0044d597                            # 0044d393
    mov eax, 0x1                                 # 0044d398
    jmp.d32 L_0044d591                           # 0044d39d
L_0044d3a2:
    # block 0x0044d3a2: entered by jl at 0x0044d368; jg at 0x0044d374; jl at 0x0044d380; jg at 0x0044d38c, 4 instruction(s), ends with jl to 0x0044d3f2 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d3a2
    mov edx, dword ptr [ebp - local_4]           # 0044d3a6
    cmp ecx, dword ptr [edx + field_95]          # 0044d3a9
    jl.d8 L_0044d3f2                             # 0044d3af
    # block 0x0044d3b1: entered by fall-through of jl at 0x0044d3af, 4 instruction(s), ends with jg to 0x0044d3f2 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044d3b1
    mov ecx, dword ptr [ebp - local_4]           # 0044d3b5
    cmp eax, dword ptr [ecx + field_9d]          # 0044d3b8
    jg.d8 L_0044d3f2                             # 0044d3be
    # block 0x0044d3c0: entered by fall-through of jg at 0x0044d3be, 4 instruction(s), ends with jl to 0x0044d3f2 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d3c0
    mov eax, dword ptr [ebp - local_4]           # 0044d3c4
    cmp edx, dword ptr [eax + field_91]          # 0044d3c7
    jl.d8 L_0044d3f2                             # 0044d3cd
    # block 0x0044d3cf: entered by fall-through of jl at 0x0044d3cd, 4 instruction(s), ends with jg to 0x0044d3f2 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044d3cf
    mov edx, dword ptr [ebp - local_4]           # 0044d3d3
    cmp ecx, dword ptr [edx + field_99]          # 0044d3d6
    jg.d8 L_0044d3f2                             # 0044d3dc
    # block 0x0044d3de: entered by fall-through of jg at 0x0044d3dc, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x3                                     # 0044d3de
    mov ecx, dword ptr [ebp - local_8]           # 0044d3e0
    call FUN_0044d597                            # 0044d3e3
    mov eax, 0x1                                 # 0044d3e8
    jmp.d32 L_0044d591                           # 0044d3ed
L_0044d3f2:
    # block 0x0044d3f2: entered by jl at 0x0044d3af; jg at 0x0044d3be; jl at 0x0044d3cd; jg at 0x0044d3dc, 4 instruction(s), ends with jl to 0x0044d442 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044d3f2
    mov ecx, dword ptr [ebp - local_4]           # 0044d3f6
    cmp eax, dword ptr [ecx + field_a5]          # 0044d3f9
    jl.d8 L_0044d442                             # 0044d3ff
    # block 0x0044d401: entered by fall-through of jl at 0x0044d3ff, 4 instruction(s), ends with jg to 0x0044d442 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d401
    mov eax, dword ptr [ebp - local_4]           # 0044d405
    cmp edx, dword ptr [eax + field_ad]          # 0044d408
    jg.d8 L_0044d442                             # 0044d40e
    # block 0x0044d410: entered by fall-through of jg at 0x0044d40e, 4 instruction(s), ends with jl to 0x0044d442 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044d410
    mov edx, dword ptr [ebp - local_4]           # 0044d414
    cmp ecx, dword ptr [edx + field_a1]          # 0044d417
    jl.d8 L_0044d442                             # 0044d41d
    # block 0x0044d41f: entered by fall-through of jl at 0x0044d41d, 4 instruction(s), ends with jg to 0x0044d442 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d41f
    mov ecx, dword ptr [ebp - local_4]           # 0044d423
    cmp eax, dword ptr [ecx + field_a9]          # 0044d426
    jg.d8 L_0044d442                             # 0044d42c
    # block 0x0044d42e: entered by fall-through of jg at 0x0044d42c, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x4                                     # 0044d42e
    mov ecx, dword ptr [ebp - local_8]           # 0044d430
    call FUN_0044d597                            # 0044d433
    mov eax, 0x1                                 # 0044d438
    jmp.d32 L_0044d591                           # 0044d43d
L_0044d442:
    # block 0x0044d442: entered by jl at 0x0044d3ff; jg at 0x0044d40e; jl at 0x0044d41d; jg at 0x0044d42c, 4 instruction(s), ends with jl to 0x0044d486 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d442
    mov eax, dword ptr [ebp - local_4]           # 0044d446
    cmp edx, dword ptr [eax + field_75]          # 0044d449
    jl.d8 L_0044d486                             # 0044d44c
    # block 0x0044d44e: entered by fall-through of jl at 0x0044d44c, 4 instruction(s), ends with jg to 0x0044d486 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d44e
    mov edx, dword ptr [ebp - local_4]           # 0044d452
    cmp ecx, dword ptr [edx + field_7d]          # 0044d455
    jg.d8 L_0044d486                             # 0044d458
    # block 0x0044d45a: entered by fall-through of jg at 0x0044d458, 4 instruction(s), ends with jl to 0x0044d486 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d45a
    mov ecx, dword ptr [ebp - local_4]           # 0044d45e
    cmp eax, dword ptr [ecx + field_71]          # 0044d461
    jl.d8 L_0044d486                             # 0044d464
    # block 0x0044d466: entered by fall-through of jl at 0x0044d464, 4 instruction(s), ends with jg to 0x0044d486 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d466
    mov eax, dword ptr [ebp - local_4]           # 0044d46a
    cmp edx, dword ptr [eax + field_79]          # 0044d46d
    jg.d8 L_0044d486                             # 0044d470
    # block 0x0044d472: entered by fall-through of jg at 0x0044d470, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x6                                     # 0044d472
    mov ecx, dword ptr [ebp - local_8]           # 0044d474
    call FUN_0044d597                            # 0044d477
    mov eax, 0x1                                 # 0044d47c
    jmp.d32 L_0044d591                           # 0044d481
L_0044d486:
    # block 0x0044d486: entered by jne at 0x0044d358; jl at 0x0044d44c; jg at 0x0044d458; jl at 0x0044d464; jg at 0x0044d470, 4 instruction(s), ends with jl to 0x0044d4d6 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d486
    mov edx, dword ptr [ebp - local_4]           # 0044d48a
    cmp ecx, dword ptr [edx + field_85]          # 0044d48d
    jl.d8 L_0044d4d6                             # 0044d493
    # block 0x0044d495: entered by fall-through of jl at 0x0044d493, 4 instruction(s), ends with jg to 0x0044d4d6 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044d495
    mov ecx, dword ptr [ebp - local_4]           # 0044d499
    cmp eax, dword ptr [ecx + field_8d]          # 0044d49c
    jg.d8 L_0044d4d6                             # 0044d4a2
    # block 0x0044d4a4: entered by fall-through of jg at 0x0044d4a2, 4 instruction(s), ends with jl to 0x0044d4d6 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d4a4
    mov eax, dword ptr [ebp - local_4]           # 0044d4a8
    cmp edx, dword ptr [eax + field_81]          # 0044d4ab
    jl.d8 L_0044d4d6                             # 0044d4b1
    # block 0x0044d4b3: entered by fall-through of jl at 0x0044d4b1, 4 instruction(s), ends with jg to 0x0044d4d6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044d4b3
    mov edx, dword ptr [ebp - local_4]           # 0044d4b7
    cmp ecx, dword ptr [edx + field_89]          # 0044d4ba
    jg.d8 L_0044d4d6                             # 0044d4c0
    # block 0x0044d4c2: entered by fall-through of jg at 0x0044d4c0, 5 instruction(s), calls FUN_0044d597, ends with forward jump to 0x0044d591
    push 0x8                                     # 0044d4c2
    mov ecx, dword ptr [ebp - local_8]           # 0044d4c4
    call FUN_0044d597                            # 0044d4c7
    mov eax, 0x1                                 # 0044d4cc
    jmp.d32 L_0044d591                           # 0044d4d1
L_0044d4d6:
    # block 0x0044d4d6: entered by jl at 0x0044d493; jg at 0x0044d4a2; jl at 0x0044d4b1; jg at 0x0044d4c0, 4 instruction(s), ends with jl to 0x0044d506 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044d4d6
    mov ecx, dword ptr [ebp - local_4]           # 0044d4da
    cmp eax, dword ptr [ecx + field_25]          # 0044d4dd
    jl.d8 L_0044d506                             # 0044d4e0
    # block 0x0044d4e2: entered by fall-through of jl at 0x0044d4e0, 4 instruction(s), ends with jg to 0x0044d506 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d4e2
    mov eax, dword ptr [ebp - local_4]           # 0044d4e6
    cmp edx, dword ptr [eax + field_2d]          # 0044d4e9
    jg.d8 L_0044d506                             # 0044d4ec
    # block 0x0044d4ee: entered by fall-through of jg at 0x0044d4ec, 4 instruction(s), ends with jl to 0x0044d506 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044d4ee
    mov edx, dword ptr [ebp - local_4]           # 0044d4f2
    cmp ecx, dword ptr [edx + field_21]          # 0044d4f5
    jl.d8 L_0044d506                             # 0044d4f8
    # block 0x0044d4fa: entered by fall-through of jl at 0x0044d4f8, 4 instruction(s), ends with jle to 0x0044d536 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d4fa
    mov ecx, dword ptr [ebp - local_4]           # 0044d4fe
    cmp eax, dword ptr [ecx + field_29]          # 0044d501
    jle.d8 L_0044d536                            # 0044d504
L_0044d506:
    # block 0x0044d506: entered by jl at 0x0044d4e0; jg at 0x0044d4ec; jl at 0x0044d4f8; fall-through of jle at 0x0044d504, 4 instruction(s), ends with jl to 0x0044d541 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d506
    mov eax, dword ptr [ebp - local_4]           # 0044d50a
    cmp edx, dword ptr [eax + field_35]          # 0044d50d
    jl.d8 L_0044d541                             # 0044d510
    # block 0x0044d512: entered by fall-through of jl at 0x0044d510, 4 instruction(s), ends with jg to 0x0044d541 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d512
    mov edx, dword ptr [ebp - local_4]           # 0044d516
    cmp ecx, dword ptr [edx + field_3d]          # 0044d519
    jg.d8 L_0044d541                             # 0044d51c
    # block 0x0044d51e: entered by fall-through of jg at 0x0044d51c, 4 instruction(s), ends with jl to 0x0044d541 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d51e
    mov ecx, dword ptr [ebp - local_4]           # 0044d522
    cmp eax, dword ptr [ecx + field_31]          # 0044d525
    jl.d8 L_0044d541                             # 0044d528
    # block 0x0044d52a: entered by fall-through of jl at 0x0044d528, 4 instruction(s), ends with jg to 0x0044d541 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d52a
    mov eax, dword ptr [ebp - local_4]           # 0044d52e
    cmp edx, dword ptr [eax + field_39]          # 0044d531
    jg.d8 L_0044d541                             # 0044d534
L_0044d536:
    # block 0x0044d536: entered by jle at 0x0044d504; fall-through of jg at 0x0044d534, 4 instruction(s), ends with forward jump to 0x0044d591
    mov ecx, dword ptr [ebp - local_8]           # 0044d536
    mov byte ptr [ecx + field_24], 0x1           # 0044d539
    {load} xor eax, eax                          # 0044d53d
    jmp.d8 L_0044d591                            # 0044d53f
L_0044d541:
    # block 0x0044d541: entered by jl at 0x0044d510; jg at 0x0044d51c; jl at 0x0044d528; jg at 0x0044d534, 4 instruction(s), ends with jl to 0x0044d588 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044d541
    mov eax, dword ptr [ebp - local_4]           # 0044d545
    cmp edx, dword ptr [eax + field_b5]          # 0044d548
    jl.d8 L_0044d588                             # 0044d54e
    # block 0x0044d550: entered by fall-through of jl at 0x0044d54e, 4 instruction(s), ends with jg to 0x0044d588 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044d550
    mov edx, dword ptr [ebp - local_4]           # 0044d554
    cmp ecx, dword ptr [edx + field_bd]          # 0044d557
    jg.d8 L_0044d588                             # 0044d55d
    # block 0x0044d55f: entered by fall-through of jg at 0x0044d55d, 4 instruction(s), ends with jl to 0x0044d588 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044d55f
    mov ecx, dword ptr [ebp - local_4]           # 0044d563
    cmp eax, dword ptr [ecx + field_b1]          # 0044d566
    jl.d8 L_0044d588                             # 0044d56c
    # block 0x0044d56e: entered by fall-through of jl at 0x0044d56c, 4 instruction(s), ends with jg to 0x0044d588 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044d56e
    mov eax, dword ptr [ebp - local_4]           # 0044d572
    cmp edx, dword ptr [eax + field_b9]          # 0044d575
    jg.d8 L_0044d588                             # 0044d57b
    # block 0x0044d57d: entered by fall-through of jg at 0x0044d57b, 4 instruction(s), ends with forward jump to 0x0044d591
    mov ecx, dword ptr [ebp - local_8]           # 0044d57d
    mov byte ptr [ecx + field_24], 0x1           # 0044d580
    {load} xor eax, eax                          # 0044d584
    jmp.d8 L_0044d591                            # 0044d586
L_0044d588:
    # block 0x0044d588: entered by je at 0x0044d29c; jl at 0x0044d54e; jg at 0x0044d55d; jl at 0x0044d56c; jg at 0x0044d57b, 3 instruction(s), falls into the block at 0x0044d591
    mov edx, dword ptr [ebp - local_8]           # 0044d588
    mov byte ptr [edx + field_24], 0x0           # 0044d58b
    {load} xor eax, eax                          # 0044d58f
L_0044d591:
    # block 0x0044d591: entered by jmp at 0x0044d2f5; jmp at 0x0044d34c; jmp at 0x0044d39d; jmp at 0x0044d3ed; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0044d591
    pop ebp                                      # 0044d593
    ret 0x8                                      # 0044d594

