# FUN_00501540
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501540
# extent:       0x00501540-0x00501692 (338 code bytes)
# span:         0x00501540-0x005016a0 (code 338, tables 0, padding 14)
# sha256:       a72bc0dababf1490669d7db7dec7bff15d3f5ca87e4360112b9d253a340490ba
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501540
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_20
# fields:       [eax + n] field_1; [ebx + n] field_minus_4; [ecx + n] field_minus_1; [edi + n] field_4, field_minus_8; [esi + n] field_minus_4
# callees:      calls FUN_0050c920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 136 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_20, 0x20  # offset -0x20
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00501540 - 0x401000
.globl FUN_00501540
FUN_00501540:
    # block 0x00501540: entry, 24 instruction(s), calls FUN_0050c920, ends with jle to 0x00501617 (forward)
    push ebp                                     # 00501540
    {load} mov ebp, esp                          # 00501541
    sub esp, 0x14                                # 00501543
    push ebx                                     # 00501546
    push esi                                     # 00501547
    mov esi, dword ptr [ebp + arg_10]            # 00501548
    push edi                                     # 0050154b
    lea ebx, [4*esi]                             # 0050154c
    {load} mov eax, ebx                          # 00501553
    add eax, 0x3                                 # 00501555
    and al, -0x4                                 # 00501558
    call FUN_0050c920                            # 0050155a
    {load} mov eax, ebx                          # 0050155f
    {load} mov edi, esp                          # 00501561
    add eax, 0x3                                 # 00501563
    and al, -0x4                                 # 00501566
    call FUN_0050c920                            # 00501568
    {load} xor edx, edx                          # 0050156d
    {load} mov ebx, esp                          # 0050156f
    {load} xor ecx, ecx                          # 00501571
    {load} cmp esi, edx                          # 00501573
    mov dword ptr [ebp - local_c], ebx           # 00501575
    mov dword ptr [ebp - local_10], edx          # 00501578
    jle.d32 L_00501617                           # 0050157b
    # block 0x00501581: entered by fall-through of jle at 0x0050157b, 2 instruction(s), falls into the block at 0x00501587
    mov eax, dword ptr [ebp + arg_8]             # 00501581
    mov dword ptr [ebp - local_4], eax           # 00501584
L_00501587:
    # block 0x00501587: entered by jl at 0x00501611, 2 instruction(s), ends with jge to 0x00501596 (forward)
    cmp ecx, 0x2                                 # 00501587
    jge.d8 L_00501596                            # 0050158a
L_0050158c:
    # block 0x0050158c: entered by jne at 0x005015b4; fall-through of jge at 0x0050158a, 4 instruction(s), ends with forward jump to 0x005015fe
    mov eax, dword ptr [ebp - local_4]           # 0050158c
    mov dword ptr [edi + 4*ecx], edx             # 0050158f
    mov eax, dword ptr [eax]                     # 00501592
    jmp.d8 L_005015fe                            # 00501594
L_00501596:
    # block 0x00501596: entered by jge at 0x0050158a, 6 instruction(s), falls into the block at 0x005015a8
    lea eax, [edi + 4*ecx - field_minus_8]       # 00501596
    lea esi, [ebx + 4*ecx - field_minus_4]       # 0050159a
    mov dword ptr [ebp - local_8], eax           # 0050159e
    {load} mov eax, edi                          # 005015a1
    {load} sub eax, ebx                          # 005015a3
    mov dword ptr [ebp - local_14], eax          # 005015a5
L_005015a8:
    # block 0x005015a8: entered by jmp at 0x005015f1, 6 instruction(s), ends with jne to 0x0050158c (backward)
    mov eax, dword ptr [ebp - local_4]           # 005015a8
    fld dword ptr [eax]                          # 005015ab
    fcomp dword ptr [esi]                        # 005015ad
    fnstsw ax                                    # 005015af
    test ah, 0x1                                 # 005015b1
    jne.d8 L_0050158c                            # 005015b4
    # block 0x005015b6: entered by fall-through of jne at 0x005015b4, 6 instruction(s), ends with jge to 0x005015f3 (forward)
    mov eax, dword ptr [ebp - local_14]          # 005015b6
    mov ebx, dword ptr [ebp + arg_c]             # 005015b9
    mov eax, dword ptr [eax + esi]               # 005015bc
    {load} add eax, ebx                          # 005015bf
    {load} cmp edx, eax                          # 005015c1
    jge.d8 L_005015f3                            # 005015c3
    # block 0x005015c5: entered by fall-through of jge at 0x005015c3, 2 instruction(s), ends with jle to 0x005015f3 (forward)
    cmp ecx, 0x1                                 # 005015c5
    jle.d8 L_005015f3                            # 005015c8
    # block 0x005015ca: entered by fall-through of jle at 0x005015c8, 5 instruction(s), ends with je to 0x005015f3 (forward)
    fld dword ptr [esi]                          # 005015ca
    fcomp dword ptr [esi - field_minus_4]        # 005015cc
    fnstsw ax                                    # 005015cf
    test ah, 0x41                                # 005015d1
    je.d8 L_005015f3                             # 005015d4
    # block 0x005015d6: entered by fall-through of je at 0x005015d4, 5 instruction(s), ends with jge to 0x005015f3 (forward)
    mov eax, dword ptr [ebp - local_8]           # 005015d6
    mov eax, dword ptr [eax]                     # 005015d9
    {load} add eax, ebx                          # 005015db
    {load} cmp edx, eax                          # 005015dd
    jge.d8 L_005015f3                            # 005015df
    # block 0x005015e1: entered by fall-through of jge at 0x005015df, 7 instruction(s), ends with backward jump to 0x005015a8
    mov eax, dword ptr [ebp - local_8]           # 005015e1
    mov ebx, dword ptr [ebp - local_c]           # 005015e4
    dec ecx                                      # 005015e7
    sub esi, 0x4                                 # 005015e8
    sub eax, 0x4                                 # 005015eb
    mov dword ptr [ebp - local_8], eax           # 005015ee
    jmp.d8 L_005015a8                            # 005015f1
L_005015f3:
    # block 0x005015f3: entered by jge at 0x005015c3; jle at 0x005015c8; je at 0x005015d4; jge at 0x005015df, 4 instruction(s), falls into the block at 0x005015fe
    mov eax, dword ptr [ebp - local_4]           # 005015f3
    mov ebx, dword ptr [ebp - local_c]           # 005015f6
    mov dword ptr [edi + 4*ecx], edx             # 005015f9
    mov eax, dword ptr [eax]                     # 005015fc
L_005015fe:
    # block 0x005015fe: entered by jmp at 0x00501594, 9 instruction(s), ends with jl to 0x00501587 (backward)
    mov esi, dword ptr [ebp - local_4]           # 005015fe
    mov dword ptr [ebx + 4*ecx], eax             # 00501601
    mov eax, dword ptr [ebp + arg_10]            # 00501604
    inc ecx                                      # 00501607
    inc edx                                      # 00501608
    add esi, 0x4                                 # 00501609
    {load} cmp edx, eax                          # 0050160c
    mov dword ptr [ebp - local_4], esi           # 0050160e
    jl.d32 L_00501587                            # 00501611
L_00501617:
    # block 0x00501617: entered by jle at 0x0050157b; fall-through of jl at 0x00501611, 4 instruction(s), ends with jle to 0x00501688 (forward)
    {load} xor edx, edx                          # 00501617
    test ecx, ecx                                # 00501619
    mov dword ptr [ebp - local_c], edx           # 0050161b
    jle.d8 L_00501688                            # 0050161e
    # block 0x00501620: entered by fall-through of jle at 0x0050161e, 5 instruction(s), ends with forward jump to 0x0050162f
    {load} mov eax, ebx                          # 00501620
    lea esi, [edi + field_4]                     # 00501622
    {load} sub eax, edi                          # 00501625
    mov dword ptr [ebp - local_14], eax          # 00501627
    jmp.d8 L_0050162f                            # 0050162a
L_0050162c:
    # block 0x0050162c: entered by jl at 0x00501686, 1 instruction(s), falls into the block at 0x0050162f
    mov eax, dword ptr [ebp - local_14]          # 0050162c
L_0050162f:
    # block 0x0050162f: entered by jmp at 0x0050162a, 3 instruction(s), ends with jge to 0x00501646 (forward)
    lea edi, [ecx - field_minus_1]               # 0050162f
    {load} cmp edx, edi                          # 00501632
    jge.d8 L_00501646                            # 00501634
    # block 0x00501636: entered by fall-through of jge at 0x00501634, 5 instruction(s), ends with jne to 0x00501646 (forward)
    fld dword ptr [eax + esi]                    # 00501636
    fcomp dword ptr [ebx]                        # 00501639
    fnstsw ax                                    # 0050163b
    test ah, 0x41                                # 0050163d
    jne.d8 L_00501646                            # 00501640
    # block 0x00501642: entered by fall-through of jne at 0x00501640, 2 instruction(s), ends with forward jump to 0x00501650
    mov eax, dword ptr [esi]                     # 00501642
    jmp.d8 L_00501650                            # 00501644
L_00501646:
    # block 0x00501646: entered by jge at 0x00501634; jne at 0x00501640, 3 instruction(s), falls into the block at 0x00501650
    mov eax, dword ptr [esi - field_minus_4]     # 00501646
    mov edi, dword ptr [ebp + arg_c]             # 00501649
    lea eax, [eax + edi + field_1]               # 0050164c
L_00501650:
    # block 0x00501650: entered by jmp at 0x00501644, 3 instruction(s), ends with jle to 0x00501659 (forward)
    mov edi, dword ptr [ebp + arg_10]            # 00501650
    {load} cmp eax, edi                          # 00501653
    jle.d8 L_00501659                            # 00501655
    # block 0x00501657: entered by fall-through of jle at 0x00501655, 1 instruction(s), falls into the block at 0x00501659
    {load} mov eax, edi                          # 00501657
L_00501659:
    # block 0x00501659: entered by jle at 0x00501655, 3 instruction(s), ends with jge to 0x0050167a (forward)
    mov edi, dword ptr [ebp - local_10]          # 00501659
    {load} cmp edi, eax                          # 0050165c
    jge.d8 L_0050167a                            # 0050165e
    # block 0x00501660: entered by fall-through of jge at 0x0050165e, 5 instruction(s), falls into the block at 0x0050166d
    mov edx, dword ptr [ebp + arg_8]             # 00501660
    {load} sub eax, edi                          # 00501663
    lea edx, [edx + 4*edi]                       # 00501665
    {load} add edi, eax                          # 00501668
    mov dword ptr [ebp - local_10], edi          # 0050166a
L_0050166d:
    # block 0x0050166d: entered by jne at 0x00501675, 5 instruction(s), ends with jne to 0x0050166d (backward)
    mov edi, dword ptr [ebx]                     # 0050166d
    mov dword ptr [edx], edi                     # 0050166f
    add edx, 0x4                                 # 00501671
    dec eax                                      # 00501674
    jne.d8 L_0050166d                            # 00501675
    # block 0x00501677: entered by fall-through of jne at 0x00501675, 1 instruction(s), falls into the block at 0x0050167a
    mov edx, dword ptr [ebp - local_c]           # 00501677
L_0050167a:
    # block 0x0050167a: entered by jge at 0x0050165e, 6 instruction(s), ends with jl to 0x0050162c (backward)
    inc edx                                      # 0050167a
    add esi, 0x4                                 # 0050167b
    add ebx, 0x4                                 # 0050167e
    {load} cmp edx, ecx                          # 00501681
    mov dword ptr [ebp - local_c], edx           # 00501683
    jl.d8 L_0050162c                             # 00501686
L_00501688:
    # block 0x00501688: entered by jle at 0x0050161e; fall-through of jl at 0x00501686, 7 instruction(s), ends with ret
    lea esp, [ebp - local_20]                    # 00501688
    pop edi                                      # 0050168b
    pop esi                                      # 0050168c
    pop ebx                                      # 0050168d
    {load} mov esp, ebp                          # 0050168e
    pop ebp                                      # 00501690
    ret                                          # 00501691

# --- data items (not part of the function) -------------------------
.org 0x00501692 - 0x401000
PAD_00501692:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

