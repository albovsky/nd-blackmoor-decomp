# FUN_0051576e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051576e
# extent:       0x0051576e-0x00515a64 (758 code bytes)
# span:         0x0051576e-0x00515a64 (code 758, tables 0, padding 0)
# sha256:       ab45af82599c2e8399b49bbcc6b09832609326251bf1234686fc592087e9305a
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051576e
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_f, arg_10, arg_13; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_17, field_44, field_c4, field_minus_4; [ebx + n] field_4, field_8, field_minus_4; [ecx + n] field_4, field_8, field_c, field_10, field_144, field_minus_4; [edi + n] field_4, field_8, field_minus_4, field_minus_20; [edx + n] field_minus_4, field_minus_8; [esi + n] field_1, field_4, field_minus_20
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 259 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_minus_20, 0x20  # offset -0x20
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_f, 0xf  # offset +0xf
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_13, 0x13  # offset +0x13
.equ field_17, 0x17  # offset +0x17
.equ field_44, 0x44  # offset +0x44
.equ field_c4, 0xc4  # offset +0xc4
.equ field_144, 0x144  # offset +0x144

# --- external targets -----------------------------------------------

.org 0x0051576e - 0x401000
.globl FUN_0051576e
FUN_0051576e:
    # block 0x0051576e: entry, 27 instruction(s), ends with jle to 0x0051591c (forward)
    push ebp                                     # 0051576e
    {load} mov ebp, esp                          # 0051576f
    sub esp, 0xc                                 # 00515771
    mov ecx, dword ptr [ebp + arg_8]             # 00515774
    mov eax, dword ptr [ebp + arg_10]            # 00515777
    push ebx                                     # 0051577a
    push esi                                     # 0051577b
    push edi                                     # 0051577c
    mov edi, dword ptr [ebp + arg_c]             # 0051577d
    {load} mov edx, edi                          # 00515780
    lea esi, [eax + field_17]                    # 00515782
    sub edx, dword ptr [ecx + field_c]           # 00515785
    mov eax, dword ptr [ecx + field_10]          # 00515788
    and esi, -0x10                               # 0051578b
    shr edx, 0xf                                 # 0051578e
    {load} mov ecx, edx                          # 00515791
    imul ecx, ecx, 0x204                         # 00515793
    lea ecx, [ecx + eax + field_144]             # 00515799
    mov dword ptr [ebp - local_c], ecx           # 005157a0
    mov ecx, dword ptr [edi - field_minus_4]     # 005157a3
    dec ecx                                      # 005157a6
    {load} cmp esi, ecx                          # 005157a7
    mov dword ptr [ebp + arg_10], ecx            # 005157a9
    mov ebx, dword ptr [ecx + edi - field_minus_4] # 005157ac
    lea edi, [ecx + edi - field_minus_4]         # 005157b0
    mov dword ptr [ebp - local_4], ebx           # 005157b4
    jle.d32 L_0051591c                           # 005157b7
    # block 0x005157bd: entered by fall-through of jle at 0x005157b7, 2 instruction(s), ends with jne to 0x00515915 (forward)
    test bl, 0x1                                 # 005157bd
    jne.d32 L_00515915                           # 005157c0
    # block 0x005157c6: entered by fall-through of jne at 0x005157c0, 3 instruction(s), ends with jg to 0x00515915 (forward)
    {load} add ebx, ecx                          # 005157c6
    {load} cmp esi, ebx                          # 005157c8
    jg.d32 L_00515915                            # 005157ca
    # block 0x005157d0: entered by fall-through of jg at 0x005157ca, 6 instruction(s), ends with jbe to 0x005157e5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 005157d0
    sar ecx, 0x4                                 # 005157d3
    dec ecx                                      # 005157d6
    cmp ecx, 0x3f                                # 005157d7
    mov dword ptr [ebp - local_8], ecx           # 005157da
    jbe.d8 L_005157e5                            # 005157dd
    # block 0x005157df: entered by fall-through of jbe at 0x005157dd, 3 instruction(s), falls into the block at 0x005157e5
    push 0x3f                                    # 005157df
    pop ecx                                      # 005157e1
    mov dword ptr [ebp - local_8], ecx           # 005157e2
L_005157e5:
    # block 0x005157e5: entered by jbe at 0x005157dd, 3 instruction(s), ends with jne to 0x00515835 (forward)
    mov ebx, dword ptr [edi + field_4]           # 005157e5
    cmp ebx, dword ptr [edi + field_8]           # 005157e8
    jne.d8 L_00515835                            # 005157eb
    # block 0x005157ed: entered by fall-through of jne at 0x005157eb, 2 instruction(s), ends with jae to 0x00515811 (forward)
    cmp ecx, 0x20                                # 005157ed
    jae.d8 L_00515811                            # 005157f0
    # block 0x005157f2: entered by fall-through of jae at 0x005157f0, 8 instruction(s), ends with jne to 0x00515835 (forward)
    mov ebx, 0x80000000                          # 005157f2
    shr ebx, cl                                  # 005157f7
    mov ecx, dword ptr [ebp - local_8]           # 005157f9
    lea ecx, [ecx + eax + field_4]               # 005157fc
    not ebx                                      # 00515800
    and dword ptr [eax + 4*edx + field_44], ebx  # 00515802
    dec byte ptr [ecx]                           # 00515806
    jne.d8 L_00515835                            # 00515808
    # block 0x0051580a: entered by fall-through of jne at 0x00515808, 3 instruction(s), ends with forward jump to 0x00515835
    mov ecx, dword ptr [ebp + arg_8]             # 0051580a
    and dword ptr [ecx], ebx                     # 0051580d
    jmp.d8 L_00515835                            # 0051580f
L_00515811:
    # block 0x00515811: entered by jae at 0x005157f0, 9 instruction(s), ends with jne to 0x00515835 (forward)
    add ecx, -0x20                               # 00515811
    mov ebx, 0x80000000                          # 00515814
    shr ebx, cl                                  # 00515819
    mov ecx, dword ptr [ebp - local_8]           # 0051581b
    lea ecx, [ecx + eax + field_4]               # 0051581e
    not ebx                                      # 00515822
    and dword ptr [eax + 4*edx + field_c4], ebx  # 00515824
    dec byte ptr [ecx]                           # 0051582b
    jne.d8 L_00515835                            # 0051582d
    # block 0x0051582f: entered by fall-through of jne at 0x0051582d, 2 instruction(s), falls into the block at 0x00515835
    mov ecx, dword ptr [ebp + arg_8]             # 0051582f
    and dword ptr [ecx + field_4], ebx           # 00515832
L_00515835:
    # block 0x00515835: entered by jne at 0x005157eb; jne at 0x00515808; jmp at 0x0051580f; jne at 0x0051582d, 11 instruction(s), ends with jle to 0x00515903 (forward)
    mov ecx, dword ptr [edi + field_8]           # 00515835
    mov ebx, dword ptr [edi + field_4]           # 00515838
    mov dword ptr [ecx + field_4], ebx           # 0051583b
    mov ecx, dword ptr [edi + field_4]           # 0051583e
    mov edi, dword ptr [edi + field_8]           # 00515841
    mov dword ptr [ecx + field_8], edi           # 00515844
    mov ecx, dword ptr [ebp + arg_10]            # 00515847
    {load} sub ecx, esi                          # 0051584a
    add dword ptr [ebp - local_4], ecx           # 0051584c
    cmp dword ptr [ebp - local_4], 0x0           # 0051584f
    jle.d32 L_00515903                           # 00515853
    # block 0x00515859: entered by fall-through of jle at 0x00515853, 7 instruction(s), ends with jbe to 0x0051586f (forward)
    mov edi, dword ptr [ebp - local_4]           # 00515859
    mov ecx, dword ptr [ebp + arg_c]             # 0051585c
    sar edi, 0x4                                 # 0051585f
    dec edi                                      # 00515862
    lea ecx, [ecx + esi - field_minus_4]         # 00515863
    cmp edi, 0x3f                                # 00515867
    jbe.d8 L_0051586f                            # 0051586a
    # block 0x0051586c: entered by fall-through of jbe at 0x0051586a, 2 instruction(s), falls into the block at 0x0051586f
    push 0x3f                                    # 0051586c
    pop edi                                      # 0051586e
L_0051586f:
    # block 0x0051586f: entered by jbe at 0x0051586a, 13 instruction(s), ends with jne to 0x005158f1 (forward)
    mov ebx, dword ptr [ebp - local_c]           # 0051586f
    lea ebx, [ebx + 8*edi]                       # 00515872
    mov dword ptr [ebp + arg_10], ebx            # 00515875
    mov ebx, dword ptr [ebx + field_4]           # 00515878
    mov dword ptr [ecx + field_4], ebx           # 0051587b
    mov ebx, dword ptr [ebp + arg_10]            # 0051587e
    mov dword ptr [ecx + field_8], ebx           # 00515881
    mov dword ptr [ebx + field_4], ecx           # 00515884
    mov ebx, dword ptr [ecx + field_4]           # 00515887
    mov dword ptr [ebx + field_8], ecx           # 0051588a
    mov ebx, dword ptr [ecx + field_4]           # 0051588d
    cmp ebx, dword ptr [ecx + field_8]           # 00515890
    jne.d8 L_005158f1                            # 00515893
    # block 0x00515895: entered by fall-through of jne at 0x00515893, 6 instruction(s), ends with jae to 0x005158c8 (forward)
    mov cl, byte ptr [edi + eax + field_4]       # 00515895
    cmp edi, 0x20                                # 00515899
    mov byte ptr [ebp + arg_13], cl              # 0051589c
    inc cl                                       # 0051589f
    mov byte ptr [edi + eax + field_4], cl       # 005158a1
    jae.d8 L_005158c8                            # 005158a5
    # block 0x005158a7: entered by fall-through of jae at 0x005158a5, 2 instruction(s), ends with jne to 0x005158bb (forward)
    cmp byte ptr [ebp + arg_13], 0x0             # 005158a7
    jne.d8 L_005158bb                            # 005158ab
    # block 0x005158ad: entered by fall-through of jne at 0x005158ab, 5 instruction(s), falls into the block at 0x005158bb
    mov ebx, 0x80000000                          # 005158ad
    {load} mov ecx, edi                          # 005158b2
    shr ebx, cl                                  # 005158b4
    mov ecx, dword ptr [ebp + arg_8]             # 005158b6
    or dword ptr [ecx], ebx                      # 005158b9
L_005158bb:
    # block 0x005158bb: entered by jne at 0x005158ab, 4 instruction(s), ends with forward jump to 0x005158ed
    lea eax, [eax + 4*edx + field_44]            # 005158bb
    mov edx, 0x80000000                          # 005158bf
    {load} mov ecx, edi                          # 005158c4
    jmp.d8 L_005158ed                            # 005158c6
L_005158c8:
    # block 0x005158c8: entered by jae at 0x005158a5, 2 instruction(s), ends with jne to 0x005158de (forward)
    cmp byte ptr [ebp + arg_13], 0x0             # 005158c8
    jne.d8 L_005158de                            # 005158cc
    # block 0x005158ce: entered by fall-through of jne at 0x005158cc, 5 instruction(s), falls into the block at 0x005158de
    lea ecx, [edi - field_minus_20]              # 005158ce
    mov ebx, 0x80000000                          # 005158d1
    shr ebx, cl                                  # 005158d6
    mov ecx, dword ptr [ebp + arg_8]             # 005158d8
    or dword ptr [ecx + field_4], ebx            # 005158db
L_005158de:
    # block 0x005158de: entered by jne at 0x005158cc, 3 instruction(s), falls into the block at 0x005158ed
    lea eax, [eax + 4*edx + field_c4]            # 005158de
    lea ecx, [edi - field_minus_20]              # 005158e5
    mov edx, 0x80000000                          # 005158e8
L_005158ed:
    # block 0x005158ed: entered by jmp at 0x005158c6, 2 instruction(s), falls into the block at 0x005158f1
    shr edx, cl                                  # 005158ed
    or dword ptr [eax], edx                      # 005158ef
L_005158f1:
    # block 0x005158f1: entered by jne at 0x00515893, 6 instruction(s), ends with forward jump to 0x00515906
    mov edx, dword ptr [ebp + arg_c]             # 005158f1
    mov ecx, dword ptr [ebp - local_4]           # 005158f4
    lea eax, [edx + esi - field_minus_4]         # 005158f7
    mov dword ptr [eax], ecx                     # 005158fb
    mov dword ptr [ecx + eax - field_minus_4], ecx # 005158fd
    jmp.d8 L_00515906                            # 00515901
L_00515903:
    # block 0x00515903: entered by jle at 0x00515853, 1 instruction(s), falls into the block at 0x00515906
    mov edx, dword ptr [ebp + arg_c]             # 00515903
L_00515906:
    # block 0x00515906: entered by jmp at 0x00515901, 4 instruction(s), ends with forward jump to 0x00515a5c
    lea eax, [esi + field_1]                     # 00515906
    mov dword ptr [edx - field_minus_4], eax     # 00515909
    mov dword ptr [edx + esi - field_minus_8], eax # 0051590c
    jmp.d32 L_00515a5c                           # 00515910
L_00515915:
    # block 0x00515915: entered by jne at 0x005157c0; jg at 0x005157ca, 2 instruction(s), ends with forward jump to 0x00515a5f
    {load} xor eax, eax                          # 00515915
    jmp.d32 L_00515a5f                           # 00515917
L_0051591c:
    # block 0x0051591c: entered by jle at 0x005157b7, 1 instruction(s), ends with jge to 0x00515a5c (forward)
    jge.d32 L_00515a5c                           # 0051591c
    # block 0x00515922: entered by fall-through of jge at 0x0051591c, 12 instruction(s), ends with jbe to 0x00515947 (forward)
    mov ebx, dword ptr [ebp + arg_c]             # 00515922
    sub dword ptr [ebp + arg_10], esi            # 00515925
    lea ecx, [esi + field_1]                     # 00515928
    mov dword ptr [ebx - field_minus_4], ecx     # 0051592b
    lea ebx, [ebx + esi - field_minus_4]         # 0051592e
    mov esi, dword ptr [ebp + arg_10]            # 00515932
    mov dword ptr [ebp + arg_c], ebx             # 00515935
    sar esi, 0x4                                 # 00515938
    dec esi                                      # 0051593b
    mov dword ptr [ebx - field_minus_4], ecx     # 0051593c
    cmp esi, 0x3f                                # 0051593f
    jbe.d8 L_00515947                            # 00515942
    # block 0x00515944: entered by fall-through of jbe at 0x00515942, 2 instruction(s), falls into the block at 0x00515947
    push 0x3f                                    # 00515944
    pop esi                                      # 00515946
L_00515947:
    # block 0x00515947: entered by jbe at 0x00515942, 2 instruction(s), ends with jne to 0x005159d6 (forward)
    test byte ptr [ebp - local_4], 0x1           # 00515947
    jne.d32 L_005159d6                           # 0051594b
    # block 0x00515951: entered by fall-through of jne at 0x0051594b, 5 instruction(s), ends with jbe to 0x00515960 (forward)
    mov esi, dword ptr [ebp - local_4]           # 00515951
    sar esi, 0x4                                 # 00515954
    dec esi                                      # 00515957
    cmp esi, 0x3f                                # 00515958
    jbe.d8 L_00515960                            # 0051595b
    # block 0x0051595d: entered by fall-through of jbe at 0x0051595b, 2 instruction(s), falls into the block at 0x00515960
    push 0x3f                                    # 0051595d
    pop esi                                      # 0051595f
L_00515960:
    # block 0x00515960: entered by jbe at 0x0051595b, 3 instruction(s), ends with jne to 0x005159af (forward)
    mov ecx, dword ptr [edi + field_4]           # 00515960
    cmp ecx, dword ptr [edi + field_8]           # 00515963
    jne.d8 L_005159af                            # 00515966
    # block 0x00515968: entered by fall-through of jne at 0x00515966, 2 instruction(s), ends with jae to 0x0051598b (forward)
    cmp esi, 0x20                                # 00515968
    jae.d8 L_0051598b                            # 0051596b
    # block 0x0051596d: entered by fall-through of jae at 0x0051596b, 8 instruction(s), ends with jne to 0x005159ac (forward)
    mov ebx, 0x80000000                          # 0051596d
    {load} mov ecx, esi                          # 00515972
    shr ebx, cl                                  # 00515974
    lea esi, [esi + eax + field_4]               # 00515976
    not ebx                                      # 0051597a
    and dword ptr [eax + 4*edx + field_44], ebx  # 0051597c
    dec byte ptr [esi]                           # 00515980
    jne.d8 L_005159ac                            # 00515982
    # block 0x00515984: entered by fall-through of jne at 0x00515982, 3 instruction(s), ends with forward jump to 0x005159ac
    mov ecx, dword ptr [ebp + arg_8]             # 00515984
    and dword ptr [ecx], ebx                     # 00515987
    jmp.d8 L_005159ac                            # 00515989
L_0051598b:
    # block 0x0051598b: entered by jae at 0x0051596b, 8 instruction(s), ends with jne to 0x005159ac (forward)
    lea ecx, [esi - field_minus_20]              # 0051598b
    mov ebx, 0x80000000                          # 0051598e
    shr ebx, cl                                  # 00515993
    lea ecx, [esi + eax + field_4]               # 00515995
    not ebx                                      # 00515999
    and dword ptr [eax + 4*edx + field_c4], ebx  # 0051599b
    dec byte ptr [ecx]                           # 005159a2
    jne.d8 L_005159ac                            # 005159a4
    # block 0x005159a6: entered by fall-through of jne at 0x005159a4, 2 instruction(s), falls into the block at 0x005159ac
    mov ecx, dword ptr [ebp + arg_8]             # 005159a6
    and dword ptr [ecx + field_4], ebx           # 005159a9
L_005159ac:
    # block 0x005159ac: entered by jne at 0x00515982; jmp at 0x00515989; jne at 0x005159a4, 1 instruction(s), falls into the block at 0x005159af
    mov ebx, dword ptr [ebp + arg_c]             # 005159ac
L_005159af:
    # block 0x005159af: entered by jne at 0x00515966, 13 instruction(s), ends with jbe to 0x005159d6 (forward)
    mov ecx, dword ptr [edi + field_8]           # 005159af
    mov esi, dword ptr [edi + field_4]           # 005159b2
    mov dword ptr [ecx + field_4], esi           # 005159b5
    mov ecx, dword ptr [edi + field_4]           # 005159b8
    mov esi, dword ptr [edi + field_8]           # 005159bb
    mov dword ptr [ecx + field_8], esi           # 005159be
    mov esi, dword ptr [ebp + arg_10]            # 005159c1
    add esi, dword ptr [ebp - local_4]           # 005159c4
    mov dword ptr [ebp + arg_10], esi            # 005159c7
    sar esi, 0x4                                 # 005159ca
    dec esi                                      # 005159cd
    cmp esi, 0x3f                                # 005159ce
    jbe.d8 L_005159d6                            # 005159d1
    # block 0x005159d3: entered by fall-through of jbe at 0x005159d1, 2 instruction(s), falls into the block at 0x005159d6
    push 0x3f                                    # 005159d3
    pop esi                                      # 005159d5
L_005159d6:
    # block 0x005159d6: entered by jne at 0x0051594b; jbe at 0x005159d1, 11 instruction(s), ends with jne to 0x00515a53 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 005159d6
    mov edi, dword ptr [ecx + 8*esi + field_4]   # 005159d9
    lea ecx, [ecx + 8*esi]                       # 005159dd
    mov dword ptr [ebx + field_4], edi           # 005159e0
    mov dword ptr [ebx + field_8], ecx           # 005159e3
    mov dword ptr [ecx + field_4], ebx           # 005159e6
    mov ecx, dword ptr [ebx + field_4]           # 005159e9
    mov dword ptr [ecx + field_8], ebx           # 005159ec
    mov ecx, dword ptr [ebx + field_4]           # 005159ef
    cmp ecx, dword ptr [ebx + field_8]           # 005159f2
    jne.d8 L_00515a53                            # 005159f5
    # block 0x005159f7: entered by fall-through of jne at 0x005159f5, 6 instruction(s), ends with jae to 0x00515a2a (forward)
    mov cl, byte ptr [esi + eax + field_4]       # 005159f7
    cmp esi, 0x20                                # 005159fb
    mov byte ptr [ebp + arg_f], cl               # 005159fe
    inc cl                                       # 00515a01
    mov byte ptr [esi + eax + field_4], cl       # 00515a03
    jae.d8 L_00515a2a                            # 00515a07
    # block 0x00515a09: entered by fall-through of jae at 0x00515a07, 2 instruction(s), ends with jne to 0x00515a1d (forward)
    cmp byte ptr [ebp + arg_f], 0x0              # 00515a09
    jne.d8 L_00515a1d                            # 00515a0d
    # block 0x00515a0f: entered by fall-through of jne at 0x00515a0d, 5 instruction(s), falls into the block at 0x00515a1d
    mov edi, 0x80000000                          # 00515a0f
    {load} mov ecx, esi                          # 00515a14
    shr edi, cl                                  # 00515a16
    mov ecx, dword ptr [ebp + arg_8]             # 00515a18
    or dword ptr [ecx], edi                      # 00515a1b
L_00515a1d:
    # block 0x00515a1d: entered by jne at 0x00515a0d, 4 instruction(s), ends with forward jump to 0x00515a4f
    lea eax, [eax + 4*edx + field_44]            # 00515a1d
    mov edx, 0x80000000                          # 00515a21
    {load} mov ecx, esi                          # 00515a26
    jmp.d8 L_00515a4f                            # 00515a28
L_00515a2a:
    # block 0x00515a2a: entered by jae at 0x00515a07, 2 instruction(s), ends with jne to 0x00515a40 (forward)
    cmp byte ptr [ebp + arg_f], 0x0              # 00515a2a
    jne.d8 L_00515a40                            # 00515a2e
    # block 0x00515a30: entered by fall-through of jne at 0x00515a2e, 5 instruction(s), falls into the block at 0x00515a40
    lea ecx, [esi - field_minus_20]              # 00515a30
    mov edi, 0x80000000                          # 00515a33
    shr edi, cl                                  # 00515a38
    mov ecx, dword ptr [ebp + arg_8]             # 00515a3a
    or dword ptr [ecx + field_4], edi            # 00515a3d
L_00515a40:
    # block 0x00515a40: entered by jne at 0x00515a2e, 3 instruction(s), falls into the block at 0x00515a4f
    lea eax, [eax + 4*edx + field_c4]            # 00515a40
    lea ecx, [esi - field_minus_20]              # 00515a47
    mov edx, 0x80000000                          # 00515a4a
L_00515a4f:
    # block 0x00515a4f: entered by jmp at 0x00515a28, 2 instruction(s), falls into the block at 0x00515a53
    shr edx, cl                                  # 00515a4f
    or dword ptr [eax], edx                      # 00515a51
L_00515a53:
    # block 0x00515a53: entered by jne at 0x005159f5, 3 instruction(s), falls into the block at 0x00515a5c
    mov eax, dword ptr [ebp + arg_10]            # 00515a53
    mov dword ptr [ebx], eax                     # 00515a56
    mov dword ptr [eax + ebx - field_minus_4], eax # 00515a58
L_00515a5c:
    # block 0x00515a5c: entered by jmp at 0x00515910; jge at 0x0051591c, 2 instruction(s), falls into the block at 0x00515a5f
    push 0x1                                     # 00515a5c
    pop eax                                      # 00515a5e
L_00515a5f:
    # block 0x00515a5f: entered by jmp at 0x00515917, 5 instruction(s), ends with ret
    pop edi                                      # 00515a5f
    pop esi                                      # 00515a60
    pop ebx                                      # 00515a61
    leave                                        # 00515a62
    ret                                          # 00515a63

