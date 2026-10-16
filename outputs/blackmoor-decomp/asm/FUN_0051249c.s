# FUN_0051249c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051249c
# extent:       0x0051249c-0x00512675 (473 code bytes)
# span:         0x0051249c-0x00512675 (code 473, tables 0, padding 0)
# sha256:       14b1baa82559458d1f4cfaa6a0625988bc340556a33ff2a98b9d35712e0a652a
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051249c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_1, local_8, local_c
# fields:       [eax + n] field_4, field_5; [ebx + n] field_1; [ecx + n] field_5
# callees:      calls KERNEL32.dll!ReadFile, KERNEL32.dll!GetLastError, FUN_0050ea7e, FUN_0050ea87, FUN_0050ea0b, FUN_005121dd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_005121dd, .text + (0x005121dd - 0x401000)

.org 0x0051249c - 0x401000
.globl FUN_0051249c
FUN_0051249c:
    # block 0x0051249c: entry, 11 instruction(s), ends with je to 0x0051266e (forward)
    push ebp                                     # 0051249c
    {load} mov ebp, esp                          # 0051249d
    sub esp, 0xc                                 # 0051249f
    and dword ptr [ebp - local_8], 0x0           # 005124a2
    cmp dword ptr [ebp + arg_10], 0x0            # 005124a6
    push ebx                                     # 005124aa
    mov ebx, dword ptr [ebp + arg_c]             # 005124ab
    push esi                                     # 005124ae
    push edi                                     # 005124af
    {load} mov edx, ebx                          # 005124b0
    je.d32 L_0051266e                            # 005124b2
    # block 0x005124b8: entered by fall-through of je at 0x005124b2, 12 instruction(s), ends with jne to 0x0051266e (forward)
    mov eax, dword ptr [ebp + arg_8]             # 005124b8
    {load} mov ecx, eax                          # 005124bb
    and eax, 0x1f                                # 005124bd
    sar ecx, 0x5                                 # 005124c0
    lea esi, [eax + 8*eax]                       # 005124c3
    mov eax, dword ptr [4*ecx + 0x63cde0]        # 005124c6
    lea edi, [4*ecx + 0x63cde0]                  # 005124cd
    shl esi, 0x2                                 # 005124d4
    {load} add eax, esi                          # 005124d7
    mov cl, byte ptr [eax + field_4]             # 005124d9
    test cl, 0x2                                 # 005124dc
    jne.d32 L_0051266e                           # 005124df
    # block 0x005124e5: entered by fall-through of jne at 0x005124df, 2 instruction(s), ends with je to 0x00512507 (forward)
    test cl, 0x48                                # 005124e5
    je.d8 L_00512507                             # 005124e8
    # block 0x005124ea: entered by fall-through of je at 0x005124e8, 3 instruction(s), ends with je to 0x00512507 (forward)
    mov al, byte ptr [eax + field_5]             # 005124ea
    cmp al, 0xa                                  # 005124ed
    je.d8 L_00512507                             # 005124ef
    # block 0x005124f1: entered by fall-through of je at 0x005124ef, 6 instruction(s), falls into the block at 0x00512507
    dec dword ptr [ebp + arg_10]                 # 005124f1
    mov byte ptr [ebx], al                       # 005124f4
    mov eax, dword ptr [edi]                     # 005124f6
    lea edx, [ebx + field_1]                     # 005124f8
    mov dword ptr [ebp - local_8], 0x1           # 005124fb
    mov byte ptr [eax + esi + field_5], 0xa      # 00512502
L_00512507:
    # block 0x00512507: entered by je at 0x005124e8; je at 0x005124ef, 10 instruction(s), calls KERNEL32.dll!ReadFile, ends with jne to 0x00512559 (forward)
    lea eax, [ebp - local_c]                     # 00512507
    push 0x0                                     # 0051250a
    push eax                                     # 0051250c
    mov eax, dword ptr [edi]                     # 0051250d
    push dword ptr [ebp + arg_10]                # 0051250f
    push edx                                     # 00512512
    push dword ptr [eax + esi]                   # 00512513
    call dword ptr [0x52a0fc]                    # 00512516
    test eax, eax                                # 0051251c
    jne.d8 L_00512559                            # 0051251e
    # block 0x00512520: entered by fall-through of jne at 0x0051251e, 5 instruction(s), calls KERNEL32.dll!GetLastError, ends with jne to 0x00512541 (forward)
    call dword ptr [0x52a2a4]                    # 00512520
    push 0x5                                     # 00512526
    pop esi                                      # 00512528
    {load} cmp eax, esi                          # 00512529
    jne.d8 L_00512541                            # 0051252b
    # block 0x0051252d: entered by fall-through of jne at 0x0051252b, 5 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with forward jump to 0x00512551
    call FUN_0050ea7e                            # 0051252d
    mov dword ptr [eax], 0x9                     # 00512532
    call FUN_0050ea87                            # 00512538
    mov dword ptr [eax], esi                     # 0051253d
    jmp.d8 L_00512551                            # 0051253f
L_00512541:
    # block 0x00512541: entered by jne at 0x0051252b, 2 instruction(s), ends with je to 0x0051266e (forward)
    cmp eax, 0x6d                                # 00512541
    je.d32 L_0051266e                            # 00512544
    # block 0x0051254a: entered by fall-through of je at 0x00512544, 3 instruction(s), calls FUN_0050ea0b, falls into the block at 0x00512551
    push eax                                     # 0051254a
    call FUN_0050ea0b                            # 0051254b
    pop ecx                                      # 00512550
L_00512551:
    # block 0x00512551: entered by jmp at 0x0051253f, 2 instruction(s), ends with forward jump to 0x00512670
    or eax, -0x1                                 # 00512551
    jmp.d32 L_00512670                           # 00512554
L_00512559:
    # block 0x00512559: entered by jne at 0x0051251e, 7 instruction(s), ends with je to 0x00512669 (forward)
    mov eax, dword ptr [edi]                     # 00512559
    mov edx, dword ptr [ebp - local_c]           # 0051255b
    add dword ptr [ebp - local_8], edx           # 0051255e
    lea ecx, [eax + esi + field_4]               # 00512561
    mov al, byte ptr [eax + esi + field_4]       # 00512565
    test al, -0x80                               # 00512569
    je.d32 L_00512669                            # 0051256b
    # block 0x00512571: entered by fall-through of je at 0x0051256b, 2 instruction(s), ends with je to 0x0051257e (forward)
    test edx, edx                                # 00512571
    je.d8 L_0051257e                             # 00512573
    # block 0x00512575: entered by fall-through of je at 0x00512573, 2 instruction(s), ends with jne to 0x0051257e (forward)
    cmp byte ptr [ebx], 0xa                      # 00512575
    jne.d8 L_0051257e                            # 00512578
    # block 0x0051257a: entered by fall-through of jne at 0x00512578, 2 instruction(s), ends with forward jump to 0x00512580
    or al, 0x4                                   # 0051257a
    jmp.d8 L_00512580                            # 0051257c
L_0051257e:
    # block 0x0051257e: entered by je at 0x00512573; jne at 0x00512578, 1 instruction(s), falls into the block at 0x00512580
    and al, -0x5                                 # 0051257e
L_00512580:
    # block 0x00512580: entered by jmp at 0x0051257c, 8 instruction(s), ends with jae to 0x00512663 (forward)
    mov byte ptr [ecx], al                       # 00512580
    mov eax, dword ptr [ebp + arg_c]             # 00512582
    mov ecx, dword ptr [ebp - local_8]           # 00512585
    mov dword ptr [ebp + arg_10], eax            # 00512588
    {load} add ecx, eax                          # 0051258b
    {load} cmp eax, ecx                          # 0051258d
    mov dword ptr [ebp - local_8], ecx           # 0051258f
    jae.d32 L_00512663                           # 00512592
L_00512598:
    # block 0x00512598: entered by jb at 0x0051264b; fall-through of jae at 0x00512592, 4 instruction(s), ends with je to 0x00512653 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00512598
    mov al, byte ptr [eax]                       # 0051259b
    cmp al, 0x1a                                 # 0051259d
    je.d32 L_00512653                            # 0051259f
    # block 0x005125a5: entered by fall-through of je at 0x0051259f, 2 instruction(s), ends with je to 0x005125b4 (forward)
    cmp al, 0xd                                  # 005125a5
    je.d8 L_005125b4                             # 005125a7
    # block 0x005125a9: entered by fall-through of je at 0x005125a7, 4 instruction(s), ends with forward jump to 0x00512645
    mov byte ptr [ebx], al                       # 005125a9
    inc ebx                                      # 005125ab
    inc dword ptr [ebp + arg_10]                 # 005125ac
    jmp.d32 L_00512645                           # 005125af
L_005125b4:
    # block 0x005125b4: entered by je at 0x005125a7, 3 instruction(s), ends with jae to 0x005125d2 (forward)
    dec ecx                                      # 005125b4
    cmp dword ptr [ebp + arg_10], ecx            # 005125b5
    jae.d8 L_005125d2                            # 005125b8
    # block 0x005125ba: entered by fall-through of jae at 0x005125b8, 4 instruction(s), ends with jne to 0x005125c9 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 005125ba
    inc eax                                      # 005125bd
    cmp byte ptr [eax], 0xa                      # 005125be
    jne.d8 L_005125c9                            # 005125c1
    # block 0x005125c3: entered by fall-through of jne at 0x005125c1, 2 instruction(s), ends with forward jump to 0x00512627
    add dword ptr [ebp + arg_10], 0x2            # 005125c3
    jmp.d8 L_00512627                            # 005125c7
L_005125c9:
    # block 0x005125c9: entered by jne at 0x005125c1, 4 instruction(s), ends with forward jump to 0x00512645
    mov byte ptr [ebx], 0xd                      # 005125c9
    inc ebx                                      # 005125cc
    mov dword ptr [ebp + arg_10], eax            # 005125cd
    jmp.d8 L_00512645                            # 005125d0
L_005125d2:
    # block 0x005125d2: entered by jae at 0x005125b8, 12 instruction(s), calls KERNEL32.dll!ReadFile, ends with jne to 0x005125fa (forward)
    lea eax, [ebp - local_c]                     # 005125d2
    push 0x0                                     # 005125d5
    push eax                                     # 005125d7
    inc dword ptr [ebp + arg_10]                 # 005125d8
    lea eax, [ebp - local_1]                     # 005125db
    push 0x1                                     # 005125de
    push eax                                     # 005125e0
    mov eax, dword ptr [edi]                     # 005125e1
    push dword ptr [eax + esi]                   # 005125e3
    call dword ptr [0x52a0fc]                    # 005125e6
    test eax, eax                                # 005125ec
    jne.d8 L_005125fa                            # 005125ee
    # block 0x005125f0: entered by fall-through of jne at 0x005125ee, 3 instruction(s), calls KERNEL32.dll!GetLastError, ends with jne to 0x00512641 (forward)
    call dword ptr [0x52a2a4]                    # 005125f0
    test eax, eax                                # 005125f6
    jne.d8 L_00512641                            # 005125f8
L_005125fa:
    # block 0x005125fa: entered by jne at 0x005125ee; fall-through of jne at 0x005125f8, 2 instruction(s), ends with je to 0x00512641 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 005125fa
    je.d8 L_00512641                             # 005125fe
    # block 0x00512600: entered by fall-through of je at 0x005125fe, 3 instruction(s), ends with je to 0x0051261c (forward)
    mov eax, dword ptr [edi]                     # 00512600
    test byte ptr [eax + esi + field_4], 0x48    # 00512602
    je.d8 L_0051261c                             # 00512607
    # block 0x00512609: entered by fall-through of je at 0x00512607, 3 instruction(s), ends with je to 0x00512627 (forward)
    mov al, byte ptr [ebp - local_1]             # 00512609
    cmp al, 0xa                                  # 0051260c
    je.d8 L_00512627                             # 0051260e
    # block 0x00512610: entered by fall-through of je at 0x0051260e, 5 instruction(s), ends with forward jump to 0x00512645
    mov byte ptr [ebx], 0xd                      # 00512610
    mov ecx, dword ptr [edi]                     # 00512613
    inc ebx                                      # 00512615
    mov byte ptr [ecx + esi + field_5], al       # 00512616
    jmp.d8 L_00512645                            # 0051261a
L_0051261c:
    # block 0x0051261c: entered by je at 0x00512607, 2 instruction(s), ends with jne to 0x0051262c (forward)
    cmp ebx, dword ptr [ebp + arg_c]             # 0051261c
    jne.d8 L_0051262c                            # 0051261f
    # block 0x00512621: entered by fall-through of jne at 0x0051261f, 2 instruction(s), ends with jne to 0x0051262c (forward)
    cmp byte ptr [ebp - local_1], 0xa            # 00512621
    jne.d8 L_0051262c                            # 00512625
L_00512627:
    # block 0x00512627: entered by jmp at 0x005125c7; je at 0x0051260e; fall-through of jne at 0x00512625, 2 instruction(s), ends with forward jump to 0x00512644
    mov byte ptr [ebx], 0xa                      # 00512627
    jmp.d8 L_00512644                            # 0051262a
L_0051262c:
    # block 0x0051262c: entered by jne at 0x0051261f; jne at 0x00512625, 7 instruction(s), calls FUN_005121dd, ends with je to 0x00512645 (forward)
    push 0x1                                     # 0051262c
    push -0x1                                    # 0051262e
    push dword ptr [ebp + arg_8]                 # 00512630
    call FUN_005121dd                            # 00512633
    add esp, 0xc                                 # 00512638
    cmp byte ptr [ebp - local_1], 0xa            # 0051263b
    je.d8 L_00512645                             # 0051263f
L_00512641:
    # block 0x00512641: entered by jne at 0x005125f8; je at 0x005125fe; fall-through of je at 0x0051263f, 1 instruction(s), falls into the block at 0x00512644
    mov byte ptr [ebx], 0xd                      # 00512641
L_00512644:
    # block 0x00512644: entered by jmp at 0x0051262a, 1 instruction(s), falls into the block at 0x00512645
    inc ebx                                      # 00512644
L_00512645:
    # block 0x00512645: entered by jmp at 0x005125af; jmp at 0x005125d0; jmp at 0x0051261a; je at 0x0051263f, 3 instruction(s), ends with jb to 0x00512598 (backward)
    mov ecx, dword ptr [ebp - local_8]           # 00512645
    cmp dword ptr [ebp + arg_10], ecx            # 00512648
    jb.d32 L_00512598                            # 0051264b
    # block 0x00512651: entered by fall-through of jb at 0x0051264b, 1 instruction(s), ends with forward jump to 0x00512663
    jmp.d8 L_00512663                            # 00512651
L_00512653:
    # block 0x00512653: entered by je at 0x0051259f, 5 instruction(s), ends with jne to 0x00512663 (forward)
    mov eax, dword ptr [edi]                     # 00512653
    lea esi, [eax + esi + field_4]               # 00512655
    mov al, byte ptr [esi]                       # 00512659
    test al, 0x40                                # 0051265b
    jne.d8 L_00512663                            # 0051265d
    # block 0x0051265f: entered by fall-through of jne at 0x0051265d, 2 instruction(s), falls into the block at 0x00512663
    or al, 0x2                                   # 0051265f
    mov byte ptr [esi], al                       # 00512661
L_00512663:
    # block 0x00512663: entered by jae at 0x00512592; jmp at 0x00512651; jne at 0x0051265d, 2 instruction(s), falls into the block at 0x00512669
    sub ebx, dword ptr [ebp + arg_c]             # 00512663
    mov dword ptr [ebp - local_8], ebx           # 00512666
L_00512669:
    # block 0x00512669: entered by je at 0x0051256b, 2 instruction(s), ends with forward jump to 0x00512670
    mov eax, dword ptr [ebp - local_8]           # 00512669
    jmp.d8 L_00512670                            # 0051266c
L_0051266e:
    # block 0x0051266e: entered by je at 0x005124b2; jne at 0x005124df; je at 0x00512544, 1 instruction(s), falls into the block at 0x00512670
    {load} xor eax, eax                          # 0051266e
L_00512670:
    # block 0x00512670: entered by jmp at 0x00512554; jmp at 0x0051266c, 5 instruction(s), ends with ret
    pop edi                                      # 00512670
    pop esi                                      # 00512671
    pop ebx                                      # 00512672
    leave                                        # 00512673
    ret                                          # 00512674

