# FUN_00509710
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509710
# extent:       0x00509710-0x00509903 (499 code bytes)
# span:         0x00509710-0x00509910 (code 499, tables 0, padding 13)
# sha256:       b1233897490f9a73f4f66a242c8a722b24f4976dabfe370388aec1d09d7ea070
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509710
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_454, field_minus_1; [ebp + n] field_1; [ebx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20; [edx + n] field_458; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 6 more
# callees:      calls FUN_00509910, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 158 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ field_454, 0x454  # offset +0x454
.equ field_458, 0x458  # offset +0x458

# --- external targets -----------------------------------------------
.set FUN_00509910, .text + (0x00509910 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00509710 - 0x401000
.globl FUN_00509710
FUN_00509710:
    # block 0x00509710: entry, 35 instruction(s), calls FUN_00509910, ends with jl to 0x00509780 (forward)
    sub esp, 0x2c                                # 00509710
    mov eax, dword ptr [esp + stk_30]            # 00509713
    push ebx                                     # 00509717
    push ebp                                     # 00509718
    push esi                                     # 00509719
    mov esi, dword ptr [esp + stk_44]            # 0050971a
    push edi                                     # 0050971e
    lea eax, [eax + 4*esi]                       # 0050971f
    push eax                                     # 00509722
    mov dword ptr [esp + stk_3c], eax            # 00509723
    call FUN_00509910                            # 00509727
    mov ebx, dword ptr [esp + stk_54]            # 0050972c
    mov ecx, 0x9                                 # 00509730
    {load} xor eax, eax                          # 00509735
    {load} mov edi, ebx                          # 00509737
    rep stosd dword ptr es:[edi], eax            # 00509739
    mov edi, dword ptr [esp + stk_50]            # 0050973b
    mov eax, dword ptr [esp + stk_58]            # 0050973f
    add esp, 0x4                                 # 00509743
    {load} xor ebp, ebp                          # 00509746
    {load} cmp edi, eax                          # 00509748
    mov dword ptr [esp + stk_10], ebp            # 0050974a
    mov dword ptr [esp + stk_18], ebp            # 0050974e
    mov dword ptr [esp + stk_20], ebp            # 00509752
    mov dword ptr [esp + stk_28], ebp            # 00509756
    mov dword ptr [esp + stk_30], ebp            # 0050975a
    mov dword ptr [esp + stk_14], ebp            # 0050975e
    mov dword ptr [esp + stk_1c], ebp            # 00509762
    mov dword ptr [esp + stk_24], ebp            # 00509766
    mov dword ptr [esp + stk_2c], ebp            # 0050976a
    mov dword ptr [esp + stk_34], ebp            # 0050976e
    mov dword ptr [esp + stk_48], ebp            # 00509772
    mov dword ptr [ebx], esi                     # 00509776
    mov dword ptr [ebx + field_4], edi           # 00509778
    jl.d8 L_00509780                             # 0050977b
    # block 0x0050977d: entered by fall-through of jl at 0x0050977b, 1 instruction(s), falls into the block at 0x00509780
    lea edi, [eax - field_minus_1]               # 0050977d
L_00509780:
    # block 0x00509780: entered by jl at 0x0050977b, 2 instruction(s), ends with jg to 0x00509871 (forward)
    {load} cmp esi, edi                          # 00509780
    jg.d32 L_00509871                            # 00509782
    # block 0x00509788: entered by fall-through of jg at 0x00509782, 6 instruction(s), falls into the block at 0x0050979e
    mov ecx, dword ptr [esp + stk_38]            # 00509788
    mov eax, dword ptr [esp + stk_44]            # 0050978c
    mov dword ptr [esp + stk_50], ecx            # 00509790
    mov ecx, dword ptr [esp + stk_40]            # 00509794
    {load} sub eax, ecx                          # 00509798
    mov dword ptr [esp + stk_40], eax            # 0050979a
L_0050979e:
    # block 0x0050979e: entered by jle at 0x0050986b, 7 instruction(s), calls FUN_00509910, ends with je to 0x0050985d (forward)
    mov edx, dword ptr [esp + stk_50]            # 0050979e
    push edx                                     # 005097a2
    call FUN_00509910                            # 005097a3
    {load} mov ecx, eax                          # 005097a8
    add esp, 0x4                                 # 005097aa
    test ecx, ecx                                # 005097ad
    je.d32 L_0050985d                            # 005097af
    # block 0x005097b5: entered by fall-through of je at 0x005097af, 9 instruction(s), ends with jne to 0x00509815 (forward)
    mov edx, dword ptr [esp + stk_40]            # 005097b5
    mov eax, dword ptr [esp + stk_50]            # 005097b9
    fld dword ptr [edx + eax]                    # 005097bd
    mov edx, dword ptr [esp + stk_58]            # 005097c0
    fadd dword ptr [edx + field_458]             # 005097c4
    fcomp dword ptr [eax]                        # 005097ca
    fnstsw ax                                    # 005097cc
    test ah, 0x1                                 # 005097ce
    jne.d8 L_00509815                            # 005097d1
    # block 0x005097d3: entered by fall-through of jne at 0x005097d1, 22 instruction(s), ends with forward jump to 0x0050985d
    mov eax, dword ptr [esp + stk_18]            # 005097d3
    mov edx, dword ptr [esp + stk_10]            # 005097d7
    {load} add eax, ecx                          # 005097db
    {load} add edx, esi                          # 005097dd
    mov dword ptr [esp + stk_18], eax            # 005097df
    {load} mov eax, esi                          # 005097e3
    imul eax, esi                                # 005097e5
    mov dword ptr [esp + stk_10], edx            # 005097e8
    mov edx, dword ptr [esp + stk_20]            # 005097ec
    {load} add edx, eax                          # 005097f0
    mov eax, dword ptr [esp + stk_28]            # 005097f2
    mov dword ptr [esp + stk_20], edx            # 005097f6
    {load} mov edx, ecx                          # 005097fa
    imul edx, ecx                                # 005097fc
    imul ecx, esi                                # 005097ff
    {load} add eax, edx                          # 00509802
    mov edx, dword ptr [esp + stk_30]            # 00509804
    {load} add edx, ecx                          # 00509808
    mov dword ptr [esp + stk_28], eax            # 0050980a
    mov dword ptr [esp + stk_30], edx            # 0050980e
    inc ebp                                      # 00509812
    jmp.d8 L_0050985d                            # 00509813
L_00509815:
    # block 0x00509815: entered by jne at 0x005097d1, 23 instruction(s), falls into the block at 0x0050985d
    mov eax, dword ptr [esp + stk_1c]            # 00509815
    mov edx, dword ptr [esp + stk_14]            # 00509819
    {load} add eax, ecx                          # 0050981d
    {load} add edx, esi                          # 0050981f
    mov dword ptr [esp + stk_1c], eax            # 00509821
    {load} mov eax, esi                          # 00509825
    imul eax, esi                                # 00509827
    mov dword ptr [esp + stk_14], edx            # 0050982a
    mov edx, dword ptr [esp + stk_24]            # 0050982e
    {load} add edx, eax                          # 00509832
    mov eax, dword ptr [esp + stk_2c]            # 00509834
    mov dword ptr [esp + stk_24], edx            # 00509838
    {load} mov edx, ecx                          # 0050983c
    imul edx, ecx                                # 0050983e
    imul ecx, esi                                # 00509841
    {load} add eax, edx                          # 00509844
    mov edx, dword ptr [esp + stk_34]            # 00509846
    mov dword ptr [esp + stk_2c], eax            # 0050984a
    mov eax, dword ptr [esp + stk_48]            # 0050984e
    {load} add edx, ecx                          # 00509852
    inc eax                                      # 00509854
    mov dword ptr [esp + stk_34], edx            # 00509855
    mov dword ptr [esp + stk_48], eax            # 00509859
L_0050985d:
    # block 0x0050985d: entered by je at 0x005097af; jmp at 0x00509813, 6 instruction(s), ends with jle to 0x0050979e (backward)
    mov ecx, dword ptr [esp + stk_50]            # 0050985d
    inc esi                                      # 00509861
    add ecx, 0x4                                 # 00509862
    {load} cmp esi, edi                          # 00509865
    mov dword ptr [esp + stk_50], ecx            # 00509867
    jle.d32 L_0050979e                           # 0050986b
L_00509871:
    # block 0x00509871: entered by jg at 0x00509782; fall-through of jle at 0x0050986b, 47 instruction(s), calls FUN_0050ce04, ends with ret
    mov edi, dword ptr [esp + stk_48]            # 00509871
    mov eax, dword ptr [esp + stk_58]            # 00509875
    {load} add edi, ebp                          # 00509879
    lea ecx, [ebp + field_1]                     # 0050987b
    mov dword ptr [esp + stk_48], edi            # 0050987e
    mov dword ptr [esp + stk_40], ecx            # 00509882
    fild dword ptr [esp + stk_48]                # 00509886
    fmul dword ptr [eax + field_454]             # 0050988a
    fidiv dword ptr [esp + stk_40]               # 00509890
    call FUN_0050ce04                            # 00509894
    lea ecx, [eax + field_1]                     # 00509899
    mov esi, dword ptr [esp + stk_14]            # 0050989c
    {load} mov edx, ecx                          # 005098a0
    mov edi, dword ptr [esp + stk_1c]            # 005098a2
    imul edx, dword ptr [esp + stk_10]           # 005098a6
    imul eax, ebp                                # 005098ab
    {load} add edx, esi                          # 005098ae
    mov esi, dword ptr [esp + stk_24]            # 005098b0
    mov dword ptr [ebx + field_8], edx           # 005098b4
    {load} mov edx, ecx                          # 005098b7
    imul edx, dword ptr [esp + stk_18]           # 005098b9
    {load} add edx, edi                          # 005098be
    mov edi, dword ptr [esp + stk_2c]            # 005098c0
    mov dword ptr [ebx + field_c], edx           # 005098c4
    {load} mov edx, ecx                          # 005098c7
    imul edx, dword ptr [esp + stk_20]           # 005098c9
    {load} add edx, esi                          # 005098ce
    mov esi, dword ptr [esp + stk_34]            # 005098d0
    mov dword ptr [ebx + field_10], edx          # 005098d4
    {load} mov edx, ecx                          # 005098d7
    imul ecx, dword ptr [esp + stk_30]           # 005098d9
    imul edx, dword ptr [esp + stk_28]           # 005098de
    {load} add ecx, esi                          # 005098e3
    {load} add edx, edi                          # 005098e5
    mov dword ptr [ebx + field_18], ecx          # 005098e7
    mov ecx, dword ptr [esp + stk_48]            # 005098ea
    {load} add eax, ecx                          # 005098ee
    pop edi                                      # 005098f0
    mov dword ptr [ebx + field_20], eax          # 005098f1
    {load} mov eax, ebp                          # 005098f4
    pop esi                                      # 005098f6
    mov dword ptr [ebx + field_14], edx          # 005098f7
    mov dword ptr [ebx + field_1c], ecx          # 005098fa
    pop ebp                                      # 005098fd
    pop ebx                                      # 005098fe
    add esp, 0x2c                                # 005098ff
    ret                                          # 00509902

# --- data items (not part of the function) -------------------------
.org 0x00509903 - 0x401000
PAD_00509903:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

