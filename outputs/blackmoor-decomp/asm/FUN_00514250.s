# FUN_00514250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514250
# extent:       0x00514250-0x00514467 (535 code bytes)
# span:         0x00514250-0x00514467 (code 535, tables 0, padding 0)
# sha256:       2f3293946d200fcced98934cd92a8a805e6d0b1895bafe24bb1f936802920a27
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514250
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_6, local_8, local_9, local_c
# fields:       [eax + n] field_minus_600
# callees:      calls FUN_005146ff, FUN_005145fe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 189 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_9, 0x9  # offset -0x9
.equ local_c, 0xc  # offset -0xc
.equ field_minus_600, 0x600  # offset -0x600
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005145fe, .text + (0x005145fe - 0x401000)
.set FUN_005146ff, .text + (0x005146ff - 0x401000)

.org 0x00514250 - 0x401000
.globl FUN_00514250
FUN_00514250:
    # block 0x00514250: entry, 12 instruction(s), ends with je to 0x0051427b (forward)
    push ebp                                     # 00514250
    {load} mov ebp, esp                          # 00514251
    sub esp, 0xc                                 # 00514253
    mov eax, dword ptr [ebp + arg_8]             # 00514256
    push ebx                                     # 00514259
    push edi                                     # 0051425a
    {load} mov edi, eax                          # 0051425b
    and edi, 0x1f                                # 0051425d
    push 0x1                                     # 00514260
    test al, 0x8                                 # 00514262
    pop ebx                                      # 00514264
    je.d8 L_0051427b                             # 00514265
    # block 0x00514267: entered by fall-through of je at 0x00514265, 2 instruction(s), ends with je to 0x0051427b (forward)
    test byte ptr [ebp + arg_10], bl             # 00514267
    je.d8 L_0051427b                             # 0051426a
    # block 0x0051426c: entered by fall-through of je at 0x0051426a, 5 instruction(s), calls FUN_005146ff, ends with forward jump to 0x00514445
    push ebx                                     # 0051426c
    call FUN_005146ff                            # 0051426d
    pop ecx                                      # 00514272
    and edi, -0x9                                # 00514273
    jmp.d32 L_00514445                           # 00514276
L_0051427b:
    # block 0x0051427b: entered by je at 0x00514265; je at 0x0051426a, 2 instruction(s), ends with je to 0x00514295 (forward)
    test al, 0x4                                 # 0051427b
    je.d8 L_00514295                             # 0051427d
    # block 0x0051427f: entered by fall-through of je at 0x0051427d, 2 instruction(s), ends with je to 0x00514295 (forward)
    test byte ptr [ebp + arg_10], 0x4            # 0051427f
    je.d8 L_00514295                             # 00514283
    # block 0x00514285: entered by fall-through of je at 0x00514283, 5 instruction(s), calls FUN_005146ff, ends with forward jump to 0x00514445
    push 0x4                                     # 00514285
    call FUN_005146ff                            # 00514287
    pop ecx                                      # 0051428c
    and edi, -0x5                                # 0051428d
    jmp.d32 L_00514445                           # 00514290
L_00514295:
    # block 0x00514295: entered by je at 0x0051427d; je at 0x00514283, 2 instruction(s), ends with je to 0x0051436f (forward)
    test bl, al                                  # 00514295
    je.d32 L_0051436f                            # 00514297
    # block 0x0051429d: entered by fall-through of je at 0x00514297, 2 instruction(s), ends with je to 0x0051436f (forward)
    test byte ptr [ebp + arg_10], 0x8            # 0051429d
    je.d32 L_0051436f                            # 005142a1
    # block 0x005142a7: entered by fall-through of je at 0x005142a1, 7 instruction(s), calls FUN_005146ff, ends with je to 0x00514347 (forward)
    push 0x8                                     # 005142a7
    call FUN_005146ff                            # 005142a9
    pop ecx                                      # 005142ae
    mov eax, 0xc00                               # 005142af
    mov ecx, dword ptr [ebp + arg_10]            # 005142b4
    {load} and ecx, eax                          # 005142b7
    je.d32 L_00514347                            # 005142b9
    # block 0x005142bf: entered by fall-through of je at 0x005142b9, 2 instruction(s), ends with je to 0x0051431f (forward)
    cmp ecx, 0x400                               # 005142bf
    je.d8 L_0051431f                             # 005142c5
    # block 0x005142c7: entered by fall-through of je at 0x005142c5, 2 instruction(s), ends with je to 0x005142f7 (forward)
    cmp ecx, 0x800                               # 005142c7
    je.d8 L_005142f7                             # 005142cd
    # block 0x005142cf: entered by fall-through of je at 0x005142cd, 2 instruction(s), ends with jne to 0x00514367 (forward)
    {load} cmp ecx, eax                          # 005142cf
    jne.d32 L_00514367                           # 005142d1
    # block 0x005142d7: entered by fall-through of jne at 0x005142d1, 7 instruction(s), ends with ja to 0x005142ef (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 005142d7
    fld qword ptr [ecx]                          # 005142da
    fcomp qword ptr [0x52c7b0]                   # 005142dc
    fld qword ptr [0x568a28]                     # 005142e2
    fnstsw ax                                    # 005142e8
    sahf                                         # 005142ea
    ja.d8 L_005142ef                             # 005142eb
    # block 0x005142ed: entered by fall-through of ja at 0x005142eb, 1 instruction(s), falls into the block at 0x005142ef
    fchs                                         # 005142ed
L_005142ef:
    # block 0x005142ef: entered by ja at 0x005142eb, 3 instruction(s), ends with forward jump to 0x00514365
    fstp qword ptr [ebp - local_c]               # 005142ef
    fld qword ptr [ebp - local_c]                # 005142f2
    jmp.d8 L_00514365                            # 005142f5
L_005142f7:
    # block 0x005142f7: entered by je at 0x005142cd, 6 instruction(s), ends with jbe to 0x0051430f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 005142f7
    fld qword ptr [ecx]                          # 005142fa
    fcomp qword ptr [0x52c7b0]                   # 005142fc
    fnstsw ax                                    # 00514302
    sahf                                         # 00514304
    jbe.d8 L_0051430f                            # 00514305
    # block 0x00514307: entered by fall-through of jbe at 0x00514305, 2 instruction(s), ends with forward jump to 0x00514317
    fld qword ptr [0x568a18]                     # 00514307
    jmp.d8 L_00514317                            # 0051430d
L_0051430f:
    # block 0x0051430f: entered by jbe at 0x00514305, 2 instruction(s), falls into the block at 0x00514317
    fld qword ptr [0x568a28]                     # 0051430f
    fchs                                         # 00514315
L_00514317:
    # block 0x00514317: entered by jmp at 0x0051430d, 3 instruction(s), ends with forward jump to 0x00514365
    fstp qword ptr [ebp - local_c]               # 00514317
    fld qword ptr [ebp - local_c]                # 0051431a
    jmp.d8 L_00514365                            # 0051431d
L_0051431f:
    # block 0x0051431f: entered by je at 0x005142c5, 6 instruction(s), ends with jbe to 0x00514337 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0051431f
    fld qword ptr [ecx]                          # 00514322
    fcomp qword ptr [0x52c7b0]                   # 00514324
    fnstsw ax                                    # 0051432a
    sahf                                         # 0051432c
    jbe.d8 L_00514337                            # 0051432d
    # block 0x0051432f: entered by fall-through of jbe at 0x0051432d, 2 instruction(s), ends with forward jump to 0x0051433f
    fld qword ptr [0x568a28]                     # 0051432f
    jmp.d8 L_0051433f                            # 00514335
L_00514337:
    # block 0x00514337: entered by jbe at 0x0051432d, 2 instruction(s), falls into the block at 0x0051433f
    fld qword ptr [0x568a18]                     # 00514337
    fchs                                         # 0051433d
L_0051433f:
    # block 0x0051433f: entered by jmp at 0x00514335, 3 instruction(s), ends with forward jump to 0x00514365
    fstp qword ptr [ebp - local_c]               # 0051433f
    fld qword ptr [ebp - local_c]                # 00514342
    jmp.d8 L_00514365                            # 00514345
L_00514347:
    # block 0x00514347: entered by je at 0x005142b9, 7 instruction(s), ends with ja to 0x0051435f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00514347
    fld qword ptr [ecx]                          # 0051434a
    fcomp qword ptr [0x52c7b0]                   # 0051434c
    fld qword ptr [0x568a18]                     # 00514352
    fnstsw ax                                    # 00514358
    sahf                                         # 0051435a
    ja.d8 L_0051435f                             # 0051435b
    # block 0x0051435d: entered by fall-through of ja at 0x0051435b, 1 instruction(s), falls into the block at 0x0051435f
    fchs                                         # 0051435d
L_0051435f:
    # block 0x0051435f: entered by ja at 0x0051435b, 2 instruction(s), falls into the block at 0x00514365
    fstp qword ptr [ebp - local_c]               # 0051435f
    fld qword ptr [ebp - local_c]                # 00514362
L_00514365:
    # block 0x00514365: entered by jmp at 0x005142f5; jmp at 0x0051431d; jmp at 0x00514345, 1 instruction(s), falls into the block at 0x00514367
    fstp qword ptr [ecx]                         # 00514365
L_00514367:
    # block 0x00514367: entered by jne at 0x005142d1, 2 instruction(s), ends with forward jump to 0x00514445
    and edi, -0x2                                # 00514367
    jmp.d32 L_00514445                           # 0051436a
L_0051436f:
    # block 0x0051436f: entered by je at 0x00514297; je at 0x005142a1, 2 instruction(s), ends with je to 0x00514445 (forward)
    test al, 0x2                                 # 0051436f
    je.d32 L_00514445                            # 00514371
    # block 0x00514377: entered by fall-through of je at 0x00514371, 2 instruction(s), ends with je to 0x00514445 (forward)
    test byte ptr [ebp + arg_10], 0x10           # 00514377
    je.d32 L_00514445                            # 0051437b
    # block 0x00514381: entered by fall-through of je at 0x0051437b, 4 instruction(s), ends with je to 0x0051438a (forward)
    push esi                                     # 00514381
    {load} xor esi, esi                          # 00514382
    test al, 0x10                                # 00514384
    je.d8 L_0051438a                             # 00514386
    # block 0x00514388: entered by fall-through of je at 0x00514386, 1 instruction(s), falls into the block at 0x0051438a
    {load} mov esi, ebx                          # 00514388
L_0051438a:
    # block 0x0051438a: entered by je at 0x00514386, 8 instruction(s), ends with je to 0x00514433 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 0051438a
    fld qword ptr [eax]                          # 0051438d
    fstp qword ptr [ebp - local_c]               # 0051438f
    fld qword ptr [ebp - local_c]                # 00514392
    fcomp qword ptr [0x52c7b0]                   # 00514395
    fnstsw ax                                    # 0051439b
    sahf                                         # 0051439d
    je.d32 L_00514433                            # 0051439e
    # block 0x005143a4: entered by fall-through of je at 0x0051439e, 13 instruction(s), calls FUN_005145fe, ends with jge to 0x005143d5 (forward)
    fld qword ptr [ebp - local_c]                # 005143a4
    lea eax, [ebp - local_4]                     # 005143a7
    push eax                                     # 005143aa
    push ecx                                     # 005143ab
    push ecx                                     # 005143ac
    fstp qword ptr [esp]                         # 005143ad
    call FUN_005145fe                            # 005143b0
    mov eax, dword ptr [ebp - local_4]           # 005143b5
    add esp, 0xc                                 # 005143b8
    fstp qword ptr [ebp - local_c]               # 005143bb
    lea ecx, [eax - field_minus_600]             # 005143be
    cmp ecx, 0xfffffbce                          # 005143c4
    jge.d8 L_005143d5                            # 005143ca
    # block 0x005143cc: entered by fall-through of jge at 0x005143ca, 4 instruction(s), ends with forward jump to 0x00514429
    fldz                                         # 005143cc
    {load} mov esi, ebx                          # 005143ce
    fstp qword ptr [ebp - local_c]               # 005143d0
    jmp.d8 L_00514429                            # 005143d3
L_005143d5:
    # block 0x005143d5: entered by jge at 0x005143ca, 5 instruction(s), ends with jae to 0x005143e7 (forward)
    fld qword ptr [ebp - local_c]                # 005143d5
    fcomp qword ptr [0x52c7b0]                   # 005143d8
    fnstsw ax                                    # 005143de
    sahf                                         # 005143e0
    jae.d8 L_005143e7                            # 005143e1
    # block 0x005143e3: entered by fall-through of jae at 0x005143e1, 2 instruction(s), ends with forward jump to 0x005143e9
    {load} mov edx, ebx                          # 005143e3
    jmp.d8 L_005143e9                            # 005143e5
L_005143e7:
    # block 0x005143e7: entered by jae at 0x005143e1, 1 instruction(s), falls into the block at 0x005143e9
    {load} xor edx, edx                          # 005143e7
L_005143e9:
    # block 0x005143e9: entered by jmp at 0x005143e5, 7 instruction(s), ends with jge to 0x0051441d (forward)
    mov al, byte ptr [ebp - local_6]             # 005143e9
    and eax, 0xf                                 # 005143ec
    or al, 0x10                                  # 005143ef
    mov word ptr [ebp - local_6], ax             # 005143f1
    mov eax, 0xfffffc03                          # 005143f5
    {load} cmp ecx, eax                          # 005143fa
    jge.d8 L_0051441d                            # 005143fc
    # block 0x005143fe: entered by fall-through of jge at 0x005143fc, 1 instruction(s), falls into the block at 0x00514400
    {load} sub eax, ecx                          # 005143fe
L_00514400:
    # block 0x00514400: entered by jne at 0x0051441b, 2 instruction(s), ends with je to 0x0051440b (forward)
    test byte ptr [ebp - local_c], bl            # 00514400
    je.d8 L_0051440b                             # 00514403
    # block 0x00514405: entered by fall-through of je at 0x00514403, 2 instruction(s), ends with jne to 0x0051440b (forward)
    test esi, esi                                # 00514405
    jne.d8 L_0051440b                            # 00514407
    # block 0x00514409: entered by fall-through of jne at 0x00514407, 1 instruction(s), falls into the block at 0x0051440b
    {load} mov esi, ebx                          # 00514409
L_0051440b:
    # block 0x0051440b: entered by je at 0x00514403; jne at 0x00514407, 3 instruction(s), ends with je to 0x00514417 (forward)
    shr dword ptr [ebp - local_c]                # 0051440b
    test byte ptr [ebp - local_8], bl            # 0051440e
    je.d8 L_00514417                             # 00514411
    # block 0x00514413: entered by fall-through of je at 0x00514411, 1 instruction(s), falls into the block at 0x00514417
    or byte ptr [ebp - local_9], -0x80           # 00514413
L_00514417:
    # block 0x00514417: entered by je at 0x00514411, 3 instruction(s), ends with jne to 0x00514400 (backward)
    shr dword ptr [ebp - local_8]                # 00514417
    dec eax                                      # 0051441a
    jne.d8 L_00514400                            # 0051441b
L_0051441d:
    # block 0x0051441d: entered by jge at 0x005143fc; fall-through of jne at 0x0051441b, 2 instruction(s), ends with je to 0x00514429 (forward)
    test edx, edx                                # 0051441d
    je.d8 L_00514429                             # 0051441f
    # block 0x00514421: entered by fall-through of je at 0x0051441f, 3 instruction(s), falls into the block at 0x00514429
    fld qword ptr [ebp - local_c]                # 00514421
    fchs                                         # 00514424
    fstp qword ptr [ebp - local_c]               # 00514426
L_00514429:
    # block 0x00514429: entered by jmp at 0x005143d3; je at 0x0051441f, 4 instruction(s), ends with forward jump to 0x00514435
    fld qword ptr [ebp - local_c]                # 00514429
    mov eax, dword ptr [ebp + arg_c]             # 0051442c
    fstp qword ptr [eax]                         # 0051442f
    jmp.d8 L_00514435                            # 00514431
L_00514433:
    # block 0x00514433: entered by je at 0x0051439e, 1 instruction(s), falls into the block at 0x00514435
    {load} mov esi, ebx                          # 00514433
L_00514435:
    # block 0x00514435: entered by jmp at 0x00514431, 3 instruction(s), ends with je to 0x00514442 (forward)
    test esi, esi                                # 00514435
    pop esi                                      # 00514437
    je.d8 L_00514442                             # 00514438
    # block 0x0051443a: entered by fall-through of je at 0x00514438, 3 instruction(s), calls FUN_005146ff, falls into the block at 0x00514442
    push 0x10                                    # 0051443a
    call FUN_005146ff                            # 0051443c
    pop ecx                                      # 00514441
L_00514442:
    # block 0x00514442: entered by je at 0x00514438, 1 instruction(s), falls into the block at 0x00514445
    and edi, -0x3                                # 00514442
L_00514445:
    # block 0x00514445: entered by jmp at 0x00514276; jmp at 0x00514290; jmp at 0x0051436a; je at 0x00514371; more, 2 instruction(s), ends with je to 0x0051445c (forward)
    test byte ptr [ebp + arg_8], 0x10            # 00514445
    je.d8 L_0051445c                             # 00514449
    # block 0x0051444b: entered by fall-through of je at 0x00514449, 2 instruction(s), ends with je to 0x0051445c (forward)
    test byte ptr [ebp + arg_10], 0x20           # 0051444b
    je.d8 L_0051445c                             # 0051444f
    # block 0x00514451: entered by fall-through of je at 0x0051444f, 4 instruction(s), calls FUN_005146ff, falls into the block at 0x0051445c
    push 0x20                                    # 00514451
    call FUN_005146ff                            # 00514453
    pop ecx                                      # 00514458
    and edi, -0x11                               # 00514459
L_0051445c:
    # block 0x0051445c: entered by je at 0x00514449; je at 0x0051444f, 7 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051445c
    test edi, edi                                # 0051445e
    pop edi                                      # 00514460
    pop ebx                                      # 00514461
    sete al                                      # 00514462
    leave                                        # 00514465
    ret                                          # 00514466

