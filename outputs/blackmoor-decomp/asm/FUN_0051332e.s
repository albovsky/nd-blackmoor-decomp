# FUN_0051332e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051332e
# extent:       0x0051332e-0x005134b9 (395 code bytes)
# span:         0x0051332e-0x005134b9 (code 395, tables 0, padding 0)
# sha256:       9a7038d8d9f00e0ad33bf90a2d9540e0cceac13811c19cf012ba22d7a54025af
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051332e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_414
# fields:       [eax + n] field_4
# callees:      calls FUN_005121dd, KERNEL32.dll!WriteFile, FUN_0050ea7e, FUN_0050ea87, KERNEL32.dll!GetLastError, FUN_0050ea0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 135 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_414, 0x414  # offset -0x414
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_005121dd, .text + (0x005121dd - 0x401000)

.org 0x0051332e - 0x401000
.globl FUN_0051332e
FUN_0051332e:
    # block 0x0051332e: entry, 11 instruction(s), ends with jne to 0x0051334e (forward)
    push ebp                                     # 0051332e
    {load} mov ebp, esp                          # 0051332f
    sub esp, 0x414                               # 00513331
    push ebx                                     # 00513337
    push esi                                     # 00513338
    push edi                                     # 00513339
    {load} xor edi, edi                          # 0051333a
    cmp dword ptr [ebp + arg_10], edi            # 0051333c
    mov dword ptr [ebp - local_8], edi           # 0051333f
    mov dword ptr [ebp - local_10], edi          # 00513342
    jne.d8 L_0051334e                            # 00513345
L_00513347:
    # block 0x00513347: entered by je at 0x00513497; fall-through of jne at 0x00513345, 2 instruction(s), ends with forward jump to 0x005134b4
    {load} xor eax, eax                          # 00513347
    jmp.d32 L_005134b4                           # 00513349
L_0051334e:
    # block 0x0051334e: entered by jne at 0x00513345, 10 instruction(s), ends with je to 0x0051337e (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051334e
    sar eax, 0x5                                 # 00513351
    lea ebx, [4*eax + 0x63cde0]                  # 00513354
    mov eax, dword ptr [ebp + arg_8]             # 0051335b
    and eax, 0x1f                                # 0051335e
    lea esi, [eax + 8*eax]                       # 00513361
    mov eax, dword ptr [ebx]                     # 00513364
    shl esi, 0x2                                 # 00513366
    test byte ptr [eax + esi + field_4], 0x20    # 00513369
    je.d8 L_0051337e                             # 0051336e
    # block 0x00513370: entered by fall-through of je at 0x0051336e, 5 instruction(s), calls FUN_005121dd, falls into the block at 0x0051337e
    push 0x2                                     # 00513370
    push edi                                     # 00513372
    push dword ptr [ebp + arg_8]                 # 00513373
    call FUN_005121dd                            # 00513376
    add esp, 0xc                                 # 0051337b
L_0051337e:
    # block 0x0051337e: entered by je at 0x0051336e, 4 instruction(s), ends with je to 0x0051344d (forward)
    mov eax, dword ptr [ebx]                     # 0051337e
    {load} add eax, esi                          # 00513380
    test byte ptr [eax + field_4], -0x80         # 00513382
    je.d32 L_0051344d                            # 00513386
    # block 0x0051338c: entered by fall-through of je at 0x00513386, 5 instruction(s), ends with jbe to 0x00513488 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 0051338c
    cmp dword ptr [ebp + arg_10], edi            # 0051338f
    mov dword ptr [ebp - local_4], eax           # 00513392
    mov dword ptr [ebp + arg_8], edi             # 00513395
    jbe.d32 L_00513488                           # 00513398
L_0051339e:
    # block 0x0051339e: entered by jb at 0x00513412; fall-through of jbe at 0x00513398, 1 instruction(s), falls into the block at 0x005133a4
    lea eax, [ebp - local_414]                   # 0051339e
L_005133a4:
    # block 0x005133a4: entered by jl at 0x005133d6, 4 instruction(s), ends with jae to 0x005133d8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 005133a4
    sub ecx, dword ptr [ebp + arg_c]             # 005133a7
    cmp ecx, dword ptr [ebp + arg_10]            # 005133aa
    jae.d8 L_005133d8                            # 005133ad
    # block 0x005133af: entered by fall-through of jae at 0x005133ad, 5 instruction(s), ends with jne to 0x005133c3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 005133af
    inc dword ptr [ebp - local_4]                # 005133b2
    mov cl, byte ptr [ecx]                       # 005133b5
    cmp cl, 0xa                                  # 005133b7
    jne.d8 L_005133c3                            # 005133ba
    # block 0x005133bc: entered by fall-through of jne at 0x005133ba, 3 instruction(s), falls into the block at 0x005133c3
    inc dword ptr [ebp - local_10]               # 005133bc
    mov byte ptr [eax], 0xd                      # 005133bf
    inc eax                                      # 005133c2
L_005133c3:
    # block 0x005133c3: entered by jne at 0x005133ba, 7 instruction(s), ends with jl to 0x005133a4 (backward)
    mov byte ptr [eax], cl                       # 005133c3
    inc eax                                      # 005133c5
    {load} mov ecx, eax                          # 005133c6
    lea edx, [ebp - local_414]                   # 005133c8
    {load} sub ecx, edx                          # 005133ce
    cmp ecx, 0x400                               # 005133d0
    jl.d8 L_005133a4                             # 005133d6
L_005133d8:
    # block 0x005133d8: entered by jae at 0x005133ad; fall-through of jl at 0x005133d6, 14 instruction(s), calls KERNEL32.dll!WriteFile, ends with je to 0x00513442 (forward)
    {load} mov edi, eax                          # 005133d8
    lea eax, [ebp - local_414]                   # 005133da
    {load} sub edi, eax                          # 005133e0
    lea eax, [ebp - local_c]                     # 005133e2
    push 0x0                                     # 005133e5
    push eax                                     # 005133e7
    lea eax, [ebp - local_414]                   # 005133e8
    push edi                                     # 005133ee
    push eax                                     # 005133ef
    mov eax, dword ptr [ebx]                     # 005133f0
    push dword ptr [eax + esi]                   # 005133f2
    call dword ptr [0x52a100]                    # 005133f5
    test eax, eax                                # 005133fb
    je.d8 L_00513442                             # 005133fd
    # block 0x005133ff: entered by fall-through of je at 0x005133fd, 4 instruction(s), ends with jl to 0x00513414 (forward)
    mov eax, dword ptr [ebp - local_c]           # 005133ff
    add dword ptr [ebp - local_8], eax           # 00513402
    {load} cmp eax, edi                          # 00513405
    jl.d8 L_00513414                             # 00513407
    # block 0x00513409: entered by fall-through of jl at 0x00513407, 4 instruction(s), ends with jb to 0x0051339e (backward)
    mov eax, dword ptr [ebp - local_4]           # 00513409
    sub eax, dword ptr [ebp + arg_c]             # 0051340c
    cmp eax, dword ptr [ebp + arg_10]            # 0051340f
    jb.d8 L_0051339e                             # 00513412
L_00513414:
    # block 0x00513414: entered by jl at 0x00513407; jmp at 0x0051344b; fall-through of jb at 0x00513412, 1 instruction(s), falls into the block at 0x00513416
    {load} xor edi, edi                          # 00513414
L_00513416:
    # block 0x00513416: entered by jmp at 0x0051346d; jmp at 0x00513478, 3 instruction(s), ends with jne to 0x005134b1 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00513416
    {load} cmp eax, edi                          # 00513419
    jne.d32 L_005134b1                           # 0051341b
    # block 0x00513421: entered by fall-through of jne at 0x0051341b, 2 instruction(s), ends with je to 0x00513488 (forward)
    cmp dword ptr [ebp + arg_8], edi             # 00513421
    je.d8 L_00513488                             # 00513424
    # block 0x00513426: entered by fall-through of je at 0x00513424, 4 instruction(s), ends with jne to 0x0051347a (forward)
    push 0x5                                     # 00513426
    pop esi                                      # 00513428
    cmp dword ptr [ebp + arg_8], esi             # 00513429
    jne.d8 L_0051347a                            # 0051342c
    # block 0x0051342e: entered by fall-through of jne at 0x0051342c, 5 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with forward jump to 0x00513483
    call FUN_0050ea7e                            # 0051342e
    mov dword ptr [eax], 0x9                     # 00513433
    call FUN_0050ea87                            # 00513439
    mov dword ptr [eax], esi                     # 0051343e
    jmp.d8 L_00513483                            # 00513440
L_00513442:
    # block 0x00513442: entered by je at 0x005133fd, 3 instruction(s), calls KERNEL32.dll!GetLastError, ends with backward jump to 0x00513414
    call dword ptr [0x52a2a4]                    # 00513442
    mov dword ptr [ebp + arg_8], eax             # 00513448
    jmp.d8 L_00513414                            # 0051344b
L_0051344d:
    # block 0x0051344d: entered by je at 0x00513386, 9 instruction(s), calls KERNEL32.dll!WriteFile, ends with je to 0x0051346f (forward)
    lea ecx, [ebp - local_c]                     # 0051344d
    push edi                                     # 00513450
    push ecx                                     # 00513451
    push dword ptr [ebp + arg_10]                # 00513452
    push dword ptr [ebp + arg_c]                 # 00513455
    push dword ptr [eax]                         # 00513458
    call dword ptr [0x52a100]                    # 0051345a
    test eax, eax                                # 00513460
    je.d8 L_0051346f                             # 00513462
    # block 0x00513464: entered by fall-through of je at 0x00513462, 4 instruction(s), ends with backward jump to 0x00513416
    mov eax, dword ptr [ebp - local_c]           # 00513464
    mov dword ptr [ebp + arg_8], edi             # 00513467
    mov dword ptr [ebp - local_8], eax           # 0051346a
    jmp.d8 L_00513416                            # 0051346d
L_0051346f:
    # block 0x0051346f: entered by je at 0x00513462, 3 instruction(s), calls KERNEL32.dll!GetLastError, ends with backward jump to 0x00513416
    call dword ptr [0x52a2a4]                    # 0051346f
    mov dword ptr [ebp + arg_8], eax             # 00513475
    jmp.d8 L_00513416                            # 00513478
L_0051347a:
    # block 0x0051347a: entered by jne at 0x0051342c, 3 instruction(s), calls FUN_0050ea0b, falls into the block at 0x00513483
    push dword ptr [ebp + arg_8]                 # 0051347a
    call FUN_0050ea0b                            # 0051347d
    pop ecx                                      # 00513482
L_00513483:
    # block 0x00513483: entered by jmp at 0x00513440; jmp at 0x005134af, 2 instruction(s), ends with forward jump to 0x005134b4
    or eax, -0x1                                 # 00513483
    jmp.d8 L_005134b4                            # 00513486
L_00513488:
    # block 0x00513488: entered by jbe at 0x00513398; je at 0x00513424, 3 instruction(s), ends with je to 0x0051349d (forward)
    mov eax, dword ptr [ebx]                     # 00513488
    test byte ptr [eax + esi + field_4], 0x40    # 0051348a
    je.d8 L_0051349d                             # 0051348f
    # block 0x00513491: entered by fall-through of je at 0x0051348f, 3 instruction(s), ends with je to 0x00513347 (backward)
    mov eax, dword ptr [ebp + arg_c]             # 00513491
    cmp byte ptr [eax], 0x1a                     # 00513494
    je.d32 L_00513347                            # 00513497
L_0051349d:
    # block 0x0051349d: entered by je at 0x0051348f; fall-through of je at 0x00513497, 5 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with backward jump to 0x00513483
    call FUN_0050ea7e                            # 0051349d
    mov dword ptr [eax], 0x1c                    # 005134a2
    call FUN_0050ea87                            # 005134a8
    mov dword ptr [eax], edi                     # 005134ad
    jmp.d8 L_00513483                            # 005134af
L_005134b1:
    # block 0x005134b1: entered by jne at 0x0051341b, 1 instruction(s), falls into the block at 0x005134b4
    sub eax, dword ptr [ebp - local_10]          # 005134b1
L_005134b4:
    # block 0x005134b4: entered by jmp at 0x00513349; jmp at 0x00513486, 5 instruction(s), ends with ret
    pop edi                                      # 005134b4
    pop esi                                      # 005134b5
    pop ebx                                      # 005134b6
    leave                                        # 005134b7
    ret                                          # 005134b8

