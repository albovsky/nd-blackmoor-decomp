# FUN_00503760
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503760
# extent:       0x00503760-0x005038d5 (373 code bytes)
# span:         0x00503760-0x005038e0 (code 373, tables 0, padding 11)
# sha256:       2bd2379b4ef19cea50b3eb172115f307d5d7fe25ecbbf9e6330daf42a3638f82
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503760
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_1; [ebp + n] field_8, field_10, field_14, field_1c, field_20, field_24, field_28; [ebx + n] field_minus_1; [ecx + n] field_minus_1; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24
# callees:      calls FUN_0050bd80, FUN_0050be30, FUN_00502da0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 143 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050bd80, .text + (0x0050bd80 - 0x401000)
.set FUN_0050be30, .text + (0x0050be30 - 0x401000)

.org 0x00503760 - 0x401000
.globl FUN_00503760
FUN_00503760:
    # block 0x00503760: entry, 10 instruction(s), ends with jle to 0x005038cd (forward)
    push ecx                                     # 00503760
    mov eax, dword ptr [esp + stk_14]            # 00503761
    push ebx                                     # 00503765
    push ebp                                     # 00503766
    push esi                                     # 00503767
    push edi                                     # 00503768
    {load} xor edi, edi                          # 00503769
    test eax, eax                                # 0050376b
    mov dword ptr [esp + stk_10], edi            # 0050376d
    jle.d32 L_005038cd                           # 00503771
    # block 0x00503777: entered by fall-through of jle at 0x00503771, 1 instruction(s), falls into the block at 0x0050377b
    mov ebp, dword ptr [esp + stk_18]            # 00503777
L_0050377b:
    # block 0x0050377b: entered by jmp at 0x005038b1, 10 instruction(s), calls FUN_0050bd80, ends with jl to 0x005037d7 (forward)
    mov ecx, dword ptr [ebp + field_24]          # 0050377b
    mov esi, dword ptr [esp + stk_20]            # 0050377e
    mov eax, dword ptr [ebp + field_28]          # 00503782
    push ecx                                     # 00503785
    push esi                                     # 00503786
    mov dword ptr [esp + stk_20], eax            # 00503787
    call FUN_0050bd80                            # 0050378b
    add esp, 0x8                                 # 00503790
    test eax, eax                                # 00503793
    jl.d8 L_005037d7                             # 00503795
    # block 0x00503797: entered by fall-through of jl at 0x00503795, 4 instruction(s), ends with je to 0x005037bd (forward)
    mov edx, dword ptr [ebp + field_20]          # 00503797
    mov ebx, dword ptr [edx + 4*eax]             # 0050379a
    test ebx, 0x80000000                         # 0050379d
    je.d8 L_005037bd                             # 005037a3
    # block 0x005037a5: entered by fall-through of je at 0x005037a3, 7 instruction(s), ends with forward jump to 0x005037dc
    mov edi, dword ptr [ebp + field_8]           # 005037a5
    {load} mov esi, ebx                          # 005037a8
    sar esi, 0xf                                 # 005037aa
    and ebx, 0x7fff                              # 005037ad
    and esi, 0x7fff                              # 005037b3
    {load} sub edi, ebx                          # 005037b9
    jmp.d8 L_005037dc                            # 005037bb
L_005037bd:
    # block 0x005037bd: entered by je at 0x005037a3, 8 instruction(s), calls FUN_0050be30, ends with forward jump to 0x00503874
    mov eax, dword ptr [ebp + field_1c]          # 005037bd
    movsx ecx, byte ptr [eax + ebx - field_minus_1] # 005037c0
    push ecx                                     # 005037c5
    push esi                                     # 005037c6
    call FUN_0050be30                            # 005037c7
    add esp, 0x8                                 # 005037cc
    lea esi, [ebx - field_minus_1]               # 005037cf
    jmp.d32 L_00503874                           # 005037d2
L_005037d7:
    # block 0x005037d7: entered by jl at 0x00503795, 2 instruction(s), falls into the block at 0x005037dc
    mov edi, dword ptr [ebp + field_8]           # 005037d7
    {load} xor esi, esi                          # 005037da
L_005037dc:
    # block 0x005037dc: entered by jmp at 0x005037bb, 8 instruction(s), calls FUN_0050bd80, ends with jge to 0x0050381c (forward)
    mov ebx, dword ptr [esp + stk_18]            # 005037dc
    mov edx, dword ptr [esp + stk_20]            # 005037e0
    push ebx                                     # 005037e4
    push edx                                     # 005037e5
    call FUN_0050bd80                            # 005037e6
    add esp, 0x8                                 # 005037eb
    test eax, eax                                # 005037ee
    jge.d8 L_0050381c                            # 005037f0
L_005037f2:
    # block 0x005037f2: entered by jl at 0x00503808; fall-through of jge at 0x005037f0, 2 instruction(s), ends with jle to 0x00503810 (forward)
    cmp ebx, 0x1                                 # 005037f2
    jle.d8 L_00503810                            # 005037f5
    # block 0x005037f7: entered by fall-through of jle at 0x005037f5, 8 instruction(s), calls FUN_0050bd80, ends with jl to 0x005037f2 (backward)
    mov eax, dword ptr [esp + stk_20]            # 005037f7
    dec ebx                                      # 005037fb
    push ebx                                     # 005037fc
    push eax                                     # 005037fd
    call FUN_0050bd80                            # 005037fe
    add esp, 0x8                                 # 00503803
    test eax, eax                                # 00503806
    jl.d8 L_005037f2                             # 00503808
    # block 0x0050380a: entered by fall-through of jl at 0x00503808, 2 instruction(s), ends with forward jump to 0x0050381c
    mov dword ptr [esp + stk_18], ebx            # 0050380a
    jmp.d8 L_0050381c                            # 0050380e
L_00503810:
    # block 0x00503810: entered by jle at 0x005037f5, 3 instruction(s), ends with jl to 0x005038c4 (forward)
    test eax, eax                                # 00503810
    mov dword ptr [esp + stk_18], ebx            # 00503812
    jl.d32 L_005038c4                            # 00503816
L_0050381c:
    # block 0x0050381c: entered by jge at 0x005037f0; jmp at 0x0050380e; fall-through of jl at 0x00503816, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x00503857 (forward)
    push eax                                     # 0050381c
    call FUN_00502da0                            # 0050381d
    {load} mov edx, edi                          # 00503822
    add esp, 0x4                                 # 00503824
    {load} sub edx, esi                          # 00503827
    cmp edx, 0x1                                 # 00503829
    jle.d8 L_00503857                            # 0050382c
L_0050382e:
    # block 0x0050382e: entered by jg at 0x00503851; fall-through of jle at 0x0050382c, 16 instruction(s), ends with jg to 0x0050382e (backward)
    mov ecx, dword ptr [ebp + field_14]          # 0050382e
    sar edx                                      # 00503831
    lea ebx, [edx + esi]                         # 00503833
    cmp eax, dword ptr [ecx + 4*ebx]             # 00503836
    {load} sbb ecx, ecx                          # 00503839
    neg ecx                                      # 0050383b
    lea ebx, [ecx - field_minus_1]               # 0050383d
    neg ecx                                      # 00503840
    {load} and ecx, edx                          # 00503842
    {load} and ebx, edx                          # 00503844
    {load} sub edi, ecx                          # 00503846
    {load} add esi, ebx                          # 00503848
    {load} mov edx, edi                          # 0050384a
    {load} sub edx, esi                          # 0050384c
    cmp edx, 0x1                                 # 0050384e
    jg.d8 L_0050382e                             # 00503851
    # block 0x00503853: entered by fall-through of jg at 0x00503851, 1 instruction(s), falls into the block at 0x00503857
    mov ebx, dword ptr [esp + stk_18]            # 00503853
L_00503857:
    # block 0x00503857: entered by jle at 0x0050382c, 4 instruction(s), ends with jg to 0x005038b6 (forward)
    mov ecx, dword ptr [ebp + field_1c]          # 00503857
    movsx eax, byte ptr [ecx + esi]              # 0050385a
    {load} cmp eax, ebx                          # 0050385e
    jg.d8 L_005038b6                             # 00503860
    # block 0x00503862: entered by fall-through of jg at 0x00503860, 6 instruction(s), calls FUN_0050be30, falls into the block at 0x00503874
    mov edx, dword ptr [esp + stk_20]            # 00503862
    push eax                                     # 00503866
    push edx                                     # 00503867
    call FUN_0050be30                            # 00503868
    mov edi, dword ptr [esp + stk_18]            # 0050386d
    add esp, 0x8                                 # 00503871
L_00503874:
    # block 0x00503874: entered by jmp at 0x005037d2, 2 instruction(s), ends with je to 0x005038c4 (forward)
    cmp esi, -0x1                                # 00503874
    je.d8 L_005038c4                             # 00503877
    # block 0x00503879: entered by fall-through of je at 0x00503877, 8 instruction(s), ends with jle to 0x005038ab (forward)
    {disp8} mov eax, dword ptr [ebp]             # 00503879
    mov edx, dword ptr [ebp + field_10]          # 0050387c
    {load} mov ecx, eax                          # 0050387f
    imul ecx, esi                                # 00503881
    lea ecx, [edx + 4*ecx]                       # 00503884
    {load} xor edx, edx                          # 00503887
    test eax, eax                                # 00503889
    jle.d8 L_005038ab                            # 0050388b
    # block 0x0050388d: entered by fall-through of jle at 0x0050388b, 2 instruction(s), falls into the block at 0x00503894
    mov eax, dword ptr [esp + stk_1c]            # 0050388d
    lea eax, [eax + 4*edi]                       # 00503891
L_00503894:
    # block 0x00503894: entered by jl at 0x005038a5, 9 instruction(s), ends with jl to 0x00503894 (backward)
    mov esi, dword ptr [ecx]                     # 00503894
    inc edi                                      # 00503896
    mov dword ptr [eax], esi                     # 00503897
    {disp8} mov esi, dword ptr [ebp]             # 00503899
    add eax, 0x4                                 # 0050389c
    inc edx                                      # 0050389f
    add ecx, 0x4                                 # 005038a0
    {load} cmp edx, esi                          # 005038a3
    jl.d8 L_00503894                             # 005038a5
    # block 0x005038a7: entered by fall-through of jl at 0x005038a5, 1 instruction(s), falls into the block at 0x005038ab
    mov dword ptr [esp + stk_10], edi            # 005038a7
L_005038ab:
    # block 0x005038ab: entered by jle at 0x0050388b, 2 instruction(s), ends with jge to 0x005038cd (forward)
    cmp edi, dword ptr [esp + stk_24]            # 005038ab
    jge.d8 L_005038cd                            # 005038af
    # block 0x005038b1: entered by fall-through of jge at 0x005038af, 1 instruction(s), ends with backward jump to 0x0050377b
    jmp.d32 L_0050377b                           # 005038b1
L_005038b6:
    # block 0x005038b6: entered by jg at 0x00503860, 5 instruction(s), calls FUN_0050be30, falls into the block at 0x005038c4
    mov ecx, dword ptr [esp + stk_20]            # 005038b6
    push ebx                                     # 005038ba
    push ecx                                     # 005038bb
    call FUN_0050be30                            # 005038bc
    add esp, 0x8                                 # 005038c1
L_005038c4:
    # block 0x005038c4: entered by jl at 0x00503816; je at 0x00503877, 7 instruction(s), ends with ret
    pop edi                                      # 005038c4
    pop esi                                      # 005038c5
    pop ebp                                      # 005038c6
    or eax, -0x1                                 # 005038c7
    pop ebx                                      # 005038ca
    pop ecx                                      # 005038cb
    ret                                          # 005038cc
L_005038cd:
    # block 0x005038cd: entered by jle at 0x00503771; jge at 0x005038af, 7 instruction(s), ends with ret
    pop edi                                      # 005038cd
    pop esi                                      # 005038ce
    pop ebp                                      # 005038cf
    {load} xor eax, eax                          # 005038d0
    pop ebx                                      # 005038d2
    pop ecx                                      # 005038d3
    ret                                          # 005038d4

# --- data items (not part of the function) -------------------------
.org 0x005038d5 - 0x401000
PAD_005038d5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

