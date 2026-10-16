# FUN_00446688
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446688
# extent:       0x00446688-0x004468fe (630 code bytes)
# span:         0x00446688-0x004468fe (code 630, tables 0, padding 0)
# sha256:       37ba46ced92ebd3f6d6f5a8a93bcfcdbd3a5f35e9616417c63413b1b63a434e9
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00446688
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_minus_1; [ecx + n] field_1, field_minus_1; [edx + n] field_1, field_minus_1
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 181 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_39, 0x39  # offset -0x39
.equ local_3a, 0x3a  # offset -0x3a
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ field_1, 0x1  # offset +0x1

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00446688 - 0x401000
.globl FUN_00446688
FUN_00446688:
    # block 0x00446688: entry, 7 instruction(s), ends with je to 0x004466a2 (forward)
    push ebp                                     # 00446688
    {load} mov ebp, esp                          # 00446689
    sub esp, 0x44                                # 0044668b
    push esi                                     # 0044668e
    push edi                                     # 0044668f
    cmp dword ptr [0x638607], 0x0                # 00446690
    je.d8 L_004466a2                             # 00446697
    # block 0x00446699: entered by fall-through of je at 0x00446697, 2 instruction(s), ends with jne to 0x004466a7 (forward)
    cmp dword ptr [0x63860f], 0x0                # 00446699
    jne.d8 L_004466a7                            # 004466a0
L_004466a2:
    # block 0x004466a2: entered by je at 0x00446697; fall-through of jne at 0x004466a0, 1 instruction(s), ends with forward jump to 0x004468f8
    jmp.d32 L_004468f8                           # 004466a2
L_004466a7:
    # block 0x004466a7: entered by jne at 0x004466a0, 6 instruction(s), falls into the block at 0x004466c6
    mov eax, dword ptr [0x63875f]                # 004466a7
    mov dword ptr [ebp - local_8], eax           # 004466ac
    mov ecx, dword ptr [0x638763]                # 004466af
    mov dword ptr [ebp - local_4], ecx           # 004466b5
    mov dword ptr [ebp - local_34], 0x63887d     # 004466b8
    mov dword ptr [ebp - local_38], 0x63885f     # 004466bf
L_004466c6:
    # block 0x004466c6: entered by jne at 0x004466f8, 6 instruction(s), ends with jne to 0x00446703 (forward)
    mov edx, dword ptr [ebp - local_38]          # 004466c6
    mov al, byte ptr [edx]                       # 004466c9
    mov byte ptr [ebp - local_39], al            # 004466cb
    mov ecx, dword ptr [ebp - local_34]          # 004466ce
    cmp al, byte ptr [ecx]                       # 004466d1
    jne.d8 L_00446703                            # 004466d3
    # block 0x004466d5: entered by fall-through of jne at 0x004466d3, 2 instruction(s), ends with je to 0x004466fa (forward)
    cmp byte ptr [ebp - local_39], 0x0           # 004466d5
    je.d8 L_004466fa                             # 004466d9
    # block 0x004466db: entered by fall-through of je at 0x004466d9, 6 instruction(s), ends with jne to 0x00446703 (forward)
    mov edx, dword ptr [ebp - local_38]          # 004466db
    mov al, byte ptr [edx + field_1]             # 004466de
    mov byte ptr [ebp - local_3a], al            # 004466e1
    mov ecx, dword ptr [ebp - local_34]          # 004466e4
    cmp al, byte ptr [ecx + field_1]             # 004466e7
    jne.d8 L_00446703                            # 004466ea
    # block 0x004466ec: entered by fall-through of jne at 0x004466ea, 4 instruction(s), ends with jne to 0x004466c6 (backward)
    add dword ptr [ebp - local_38], 0x2          # 004466ec
    add dword ptr [ebp - local_34], 0x2          # 004466f0
    cmp byte ptr [ebp - local_3a], 0x0           # 004466f4
    jne.d8 L_004466c6                            # 004466f8
L_004466fa:
    # block 0x004466fa: entered by je at 0x004466d9; fall-through of jne at 0x004466f8, 2 instruction(s), ends with forward jump to 0x0044670b
    mov dword ptr [ebp - local_40], 0x0          # 004466fa
    jmp.d8 L_0044670b                            # 00446701
L_00446703:
    # block 0x00446703: entered by jne at 0x004466d3; jne at 0x004466ea, 3 instruction(s), falls into the block at 0x0044670b
    {load} sbb edx, edx                          # 00446703
    sbb edx, -0x1                                # 00446705
    mov dword ptr [ebp - local_40], edx          # 00446708
L_0044670b:
    # block 0x0044670b: entered by jmp at 0x00446701, 4 instruction(s), ends with je to 0x004467fc (forward)
    mov eax, dword ptr [ebp - local_40]          # 0044670b
    mov dword ptr [ebp - local_44], eax          # 0044670e
    cmp dword ptr [ebp - local_44], 0x0          # 00446711
    je.d32 L_004467fc                            # 00446715
    # block 0x0044671b: entered by fall-through of je at 0x00446715, 2 instruction(s), ends with forward jump to 0x0044672d
    mov dword ptr [ebp - local_1c], 0x0          # 0044671b
    jmp.d8 L_0044672d                            # 00446722
L_00446724:
    # block 0x00446724: entered by jmp at 0x004467f7, 3 instruction(s), falls into the block at 0x0044672d
    mov ecx, dword ptr [ebp - local_1c]          # 00446724
    add ecx, 0x1                                 # 00446727
    mov dword ptr [ebp - local_1c], ecx          # 0044672a
L_0044672d:
    # block 0x0044672d: entered by jmp at 0x00446722, 8 instruction(s), ends with jae to 0x004467fc (forward)
    mov edi, 0x63887d                            # 0044672d
    or ecx, -0x1                                 # 00446732
    {load} xor eax, eax                          # 00446735
    repne scasb al, byte ptr es:[edi]            # 00446737
    not ecx                                      # 00446739
    add ecx, -0x1                                # 0044673b
    cmp dword ptr [ebp - local_1c], ecx          # 0044673e
    jae.d32 L_004467fc                           # 00446741
    # block 0x00446747: entered by fall-through of jae at 0x00446741, 48 instruction(s), calls FUN_004c5377, ends with backward jump to 0x00446724
    mov edx, dword ptr [ebp - local_1c]          # 00446747
    movsx eax, byte ptr [edx + 0x63887d]         # 0044674a
    sub eax, 0x30                                # 00446751
    mov dword ptr [ebp - local_30], eax          # 00446754
    mov ecx, dword ptr [ebp - local_8]           # 00446757
    mov dword ptr [ebp - local_2c], ecx          # 0044675a
    mov edx, dword ptr [ebp - local_4]           # 0044675d
    mov dword ptr [ebp - local_28], edx          # 00446760
    mov eax, dword ptr [ebp - local_30]          # 00446763
    mov ecx, dword ptr [4*eax + 0x638617]        # 00446766
    mov edx, dword ptr [ebp - local_2c]          # 0044676d
    lea eax, [edx + ecx - field_minus_1]         # 00446770
    mov dword ptr [ebp - local_24], eax          # 00446774
    mov ecx, dword ptr [ebp - local_30]          # 00446777
    mov edx, dword ptr [4*ecx + 0x63863f]        # 0044677a
    mov eax, dword ptr [ebp - local_28]          # 00446781
    lea ecx, [eax + edx - field_minus_1]         # 00446784
    mov dword ptr [ebp - local_20], ecx          # 00446788
    mov edx, dword ptr [ebp - local_2c]          # 0044678b
    sub edx, dword ptr [0x583186]                # 0044678e
    mov dword ptr [ebp - local_18], edx          # 00446794
    mov eax, dword ptr [ebp - local_24]          # 00446797
    sub eax, dword ptr [0x583186]                # 0044679a
    mov dword ptr [ebp - local_10], eax          # 004467a0
    mov ecx, dword ptr [ebp - local_28]          # 004467a3
    sub ecx, dword ptr [0x58318a]                # 004467a6
    mov dword ptr [ebp - local_14], ecx          # 004467ac
    mov edx, dword ptr [ebp - local_20]          # 004467af
    sub edx, dword ptr [0x58318a]                # 004467b2
    mov dword ptr [ebp - local_c], edx           # 004467b8
    push 0x548288                                # 004467bb
    lea eax, [ebp - local_2c]                    # 004467c0
    push eax                                     # 004467c3
    lea ecx, [ebp - local_18]                    # 004467c4
    push ecx                                     # 004467c7
    mov edx, dword ptr [0x5cf665]                # 004467c8
    push edx                                     # 004467ce
    mov eax, dword ptr [0x5d15e3]                # 004467cf
    push eax                                     # 004467d4
    mov ecx, 0x5cf659                            # 004467d5
    call FUN_004c5377                            # 004467da
    mov ecx, dword ptr [ebp - local_30]          # 004467df
    mov edx, dword ptr [4*ecx + 0x638617]        # 004467e2
    add edx, dword ptr [0x638767]                # 004467e9
    mov eax, dword ptr [ebp - local_8]           # 004467ef
    {load} add eax, edx                          # 004467f2
    mov dword ptr [ebp - local_8], eax           # 004467f4
    jmp.d32 L_00446724                           # 004467f7
L_004467fc:
    # block 0x004467fc: entered by je at 0x00446715; jae at 0x00446741, 6 instruction(s), ends with forward jump to 0x00446820
    mov ecx, dword ptr [0x63875f]                # 004467fc
    mov dword ptr [ebp - local_8], ecx           # 00446802
    mov edx, dword ptr [0x638763]                # 00446805
    mov dword ptr [ebp - local_4], edx           # 0044680b
    mov dword ptr [ebp - local_1c], 0x0          # 0044680e
    jmp.d8 L_00446820                            # 00446815
L_00446817:
    # block 0x00446817: entered by jmp at 0x004468cc, 3 instruction(s), falls into the block at 0x00446820
    mov eax, dword ptr [ebp - local_1c]          # 00446817
    add eax, 0x1                                 # 0044681a
    mov dword ptr [ebp - local_1c], eax          # 0044681d
L_00446820:
    # block 0x00446820: entered by jmp at 0x00446815, 8 instruction(s), ends with jae to 0x004468d1 (forward)
    mov edi, 0x63885f                            # 00446820
    or ecx, -0x1                                 # 00446825
    {load} xor eax, eax                          # 00446828
    repne scasb al, byte ptr es:[edi]            # 0044682a
    not ecx                                      # 0044682c
    add ecx, -0x1                                # 0044682e
    cmp dword ptr [ebp - local_1c], ecx          # 00446831
    jae.d32 L_004468d1                           # 00446834
    # block 0x0044683a: entered by fall-through of jae at 0x00446834, 40 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x00446817
    mov ecx, dword ptr [ebp - local_1c]          # 0044683a
    movsx edx, byte ptr [ecx + 0x63885f]         # 0044683d
    sub edx, 0x30                                # 00446844
    mov dword ptr [ebp - local_30], edx          # 00446847
    mov eax, dword ptr [ebp - local_8]           # 0044684a
    mov dword ptr [ebp - local_2c], eax          # 0044684d
    mov ecx, dword ptr [ebp - local_4]           # 00446850
    mov dword ptr [ebp - local_28], ecx          # 00446853
    mov edx, dword ptr [ebp - local_30]          # 00446856
    mov eax, dword ptr [4*edx + 0x638617]        # 00446859
    mov ecx, dword ptr [ebp - local_2c]          # 00446860
    lea edx, [ecx + eax - field_minus_1]         # 00446863
    mov dword ptr [ebp - local_24], edx          # 00446867
    mov eax, dword ptr [ebp - local_30]          # 0044686a
    mov ecx, dword ptr [4*eax + 0x63863f]        # 0044686d
    mov edx, dword ptr [ebp - local_28]          # 00446874
    lea eax, [edx + ecx - field_minus_1]         # 00446877
    mov dword ptr [ebp - local_20], eax          # 0044687b
    push 0x5482b4                                # 0044687e
    lea ecx, [ebp - local_2c]                    # 00446883
    push ecx                                     # 00446886
    mov edx, dword ptr [ebp - local_30]          # 00446887
    shl edx, 0x4                                 # 0044688a
    add edx, 0x6386bf                            # 0044688d
    push edx                                     # 00446893
    mov eax, dword ptr [0x5cf665]                # 00446894
    push eax                                     # 00446899
    mov ecx, dword ptr [0x63876f]                # 0044689a
    imul ecx, ecx, 0x4a                          # 004468a0
    mov edx, dword ptr [ecx + 0x5d1599]          # 004468a3
    push edx                                     # 004468a9
    mov ecx, 0x5cf659                            # 004468aa
    call FUN_004c5d4b                            # 004468af
    mov eax, dword ptr [ebp - local_30]          # 004468b4
    mov ecx, dword ptr [4*eax + 0x638617]        # 004468b7
    add ecx, dword ptr [0x638767]                # 004468be
    mov edx, dword ptr [ebp - local_8]           # 004468c4
    {load} add edx, ecx                          # 004468c7
    mov dword ptr [ebp - local_8], edx           # 004468c9
    jmp.d32 L_00446817                           # 004468cc
L_004468d1:
    # block 0x004468d1: entered by jae at 0x00446834, 15 instruction(s), falls into the block at 0x004468f8
    mov edi, 0x63885f                            # 004468d1
    mov edx, 0x63887d                            # 004468d6
    or ecx, -0x1                                 # 004468db
    {load} xor eax, eax                          # 004468de
    repne scasb al, byte ptr es:[edi]            # 004468e0
    not ecx                                      # 004468e2
    {load} sub edi, ecx                          # 004468e4
    {load} mov esi, edi                          # 004468e6
    {load} mov eax, ecx                          # 004468e8
    {load} mov edi, edx                          # 004468ea
    shr ecx, 0x2                                 # 004468ec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004468ef
    {load} mov ecx, eax                          # 004468f1
    and ecx, 0x3                                 # 004468f3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004468f6
L_004468f8:
    # block 0x004468f8: entered by jmp at 0x004466a2, 5 instruction(s), ends with ret
    pop edi                                      # 004468f8
    pop esi                                      # 004468f9
    {load} mov esp, ebp                          # 004468fa
    pop ebp                                      # 004468fc
    ret                                          # 004468fd

