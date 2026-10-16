# FUN_00501730
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501730
# extent:       0x00501730-0x0050187a (330 code bytes)
# span:         0x00501730-0x00501880 (code 330, tables 0, padding 6)
# sha256:       f969cad93269c243de72f694edb34c7d1c833f16729b02671471e091fa5802f4
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501730
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_484, field_minus_400; [ecx + n] field_a0, field_484; [esi + n] field_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_34, stk_38, stk_3c
# callees:      calls FUN_004fee30, FUN_00501880, FUN_00501950
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 107 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_400, 0x400  # offset -0x400
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_484, 0x484  # offset +0x484

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_00501880, .text + (0x00501880 - 0x401000)
.set FUN_00501950, .text + (0x00501950 - 0x401000)

.org 0x00501730 - 0x401000
.globl FUN_00501730
FUN_00501730:
    # block 0x00501730: entry, 26 instruction(s), calls FUN_004fee30, ends with jle to 0x00501874 (forward)
    sub esp, 0x18                                # 00501730
    mov edx, dword ptr [esp + stk_1c]            # 00501733
    push ebp                                     # 00501737
    mov ebp, dword ptr [esp + stk_2c]            # 00501738
    push esi                                     # 0050173c
    mov esi, dword ptr [esp + stk_2c]            # 0050173d
    mov ecx, dword ptr [ebp + field_484]         # 00501741
    mov eax, dword ptr [esi]                     # 00501747
    shl ecx, 0x2                                 # 00501749
    push ecx                                     # 0050174c
    push edx                                     # 0050174d
    mov dword ptr [esp + stk_10], eax            # 0050174e
    call FUN_004fee30                            # 00501752
    mov ecx, dword ptr [esi + field_4]           # 00501757
    add esp, 0x8                                 # 0050175a
    mov dword ptr [esp + stk_1c], eax            # 0050175d
    mov dword ptr [esp + stk_10], 0x0            # 00501761
    mov ecx, dword ptr [ecx]                     # 00501769
    lea ecx, [ecx + 2*ecx]                       # 0050176b
    lea edx, [ecx + 4*ecx]                       # 0050176e
    mov ecx, dword ptr [esp + stk_28]            # 00501771
    mov edx, dword ptr [ecx + 4*edx + field_a0]  # 00501775
    mov ecx, dword ptr [ebp + field_484]         # 0050177c
    test ecx, ecx                                # 00501782
    mov dword ptr [esp + stk_28], edx            # 00501784
    jle.d32 L_00501874                           # 00501788
    # block 0x0050178e: entered by fall-through of jle at 0x00501788, 5 instruction(s), falls into the block at 0x0050179c
    add ebp, 0x888                               # 0050178e
    push ebx                                     # 00501794
    push edi                                     # 00501795
    {load} mov ebx, eax                          # 00501796
    mov dword ptr [esp + stk_1c], ebp            # 00501798
L_0050179c:
    # block 0x0050179c: entered by jl at 0x00501868, 19 instruction(s), calls FUN_004fee30, ends with jle to 0x00501812 (forward)
    mov ecx, dword ptr [ebp - field_minus_400]   # 0050179c
    mov eax, dword ptr [esp + stk_3c]            # 005017a2
    {disp8} mov edx, dword ptr [ebp]             # 005017a6
    mov edi, dword ptr [eax + 4*ecx]             # 005017a9
    mov ecx, dword ptr [esp + stk_10]            # 005017ac
    mov eax, dword ptr [eax + 4*edx]             # 005017b0
    mov edx, dword ptr [esp + stk_2c]            # 005017b3
    mov dword ptr [esp + stk_14], eax            # 005017b7
    lea eax, [4*ecx]                             # 005017bb
    push eax                                     # 005017c2
    push edx                                     # 005017c3
    mov dword ptr [esp + stk_3c], edi            # 005017c4
    call FUN_004fee30                            # 005017c8
    mov dword ptr [ebx], eax                     # 005017cd
    mov eax, dword ptr [esp + stk_38]            # 005017cf
    add esp, 0x8                                 # 005017d3
    {load} xor esi, esi                          # 005017d6
    test eax, eax                                # 005017d8
    jle.d8 L_00501812                            # 005017da
    # block 0x005017dc: entered by fall-through of jle at 0x005017da, 5 instruction(s), ends with forward jump to 0x005017ee
    mov eax, dword ptr [esp + stk_14]            # 005017dc
    {load} mov ecx, edi                          # 005017e0
    {load} sub eax, ecx                          # 005017e2
    mov dword ptr [esp + stk_20], eax            # 005017e4
    jmp.d8 L_005017ee                            # 005017e8
L_005017ea:
    # block 0x005017ea: entered by jl at 0x0050180c, 1 instruction(s), falls into the block at 0x005017ee
    mov eax, dword ptr [esp + stk_20]            # 005017ea
L_005017ee:
    # block 0x005017ee: entered by jmp at 0x005017e8, 13 instruction(s), calls FUN_00501880, ends with jl to 0x005017ea (backward)
    mov eax, dword ptr [eax + edi]               # 005017ee
    mov ecx, dword ptr [edi]                     # 005017f1
    push eax                                     # 005017f3
    push ecx                                     # 005017f4
    call FUN_00501880                            # 005017f5
    mov edx, dword ptr [ebx]                     # 005017fa
    mov eax, dword ptr [esp + stk_38]            # 005017fc
    add esp, 0x8                                 # 00501800
    add edi, 0x4                                 # 00501803
    fstp dword ptr [edx + 4*esi]                 # 00501806
    inc esi                                      # 00501809
    {load} cmp esi, eax                          # 0050180a
    jl.d8 L_005017ea                             # 0050180c
    # block 0x0050180e: entered by fall-through of jl at 0x0050180c, 1 instruction(s), falls into the block at 0x00501812
    mov edi, dword ptr [esp + stk_34]            # 0050180e
L_00501812:
    # block 0x00501812: entered by jle at 0x005017da, 2 instruction(s), ends with jge to 0x00501849 (forward)
    cmp esi, dword ptr [esp + stk_10]            # 00501812
    jge.d8 L_00501849                            # 00501816
    # block 0x00501818: entered by fall-through of jge at 0x00501816, 4 instruction(s), falls into the block at 0x00501825
    mov ebp, dword ptr [esp + stk_14]            # 00501818
    mov eax, dword ptr [esp + stk_34]            # 0050181c
    lea edi, [edi + 4*esi]                       # 00501820
    {load} sub ebp, eax                          # 00501823
L_00501825:
    # block 0x00501825: entered by jl at 0x00501843, 13 instruction(s), calls FUN_00501950, ends with jl to 0x00501825 (backward)
    mov eax, dword ptr [edi + ebp]               # 00501825
    mov ecx, dword ptr [edi]                     # 00501828
    push eax                                     # 0050182a
    push ecx                                     # 0050182b
    call FUN_00501950                            # 0050182c
    mov edx, dword ptr [ebx]                     # 00501831
    mov eax, dword ptr [esp + stk_18]            # 00501833
    add esp, 0x8                                 # 00501837
    add edi, 0x4                                 # 0050183a
    fstp dword ptr [edx + 4*esi]                 # 0050183d
    inc esi                                      # 00501840
    {load} cmp esi, eax                          # 00501841
    jl.d8 L_00501825                             # 00501843
    # block 0x00501845: entered by fall-through of jl at 0x00501843, 1 instruction(s), falls into the block at 0x00501849
    mov ebp, dword ptr [esp + stk_1c]            # 00501845
L_00501849:
    # block 0x00501849: entered by jge at 0x00501816, 10 instruction(s), ends with jl to 0x0050179c (backward)
    mov ecx, dword ptr [esp + stk_38]            # 00501849
    mov eax, dword ptr [esp + stk_18]            # 0050184d
    inc eax                                      # 00501851
    add ebp, 0x4                                 # 00501852
    mov edx, dword ptr [ecx + field_484]         # 00501855
    add ebx, 0x4                                 # 0050185b
    {load} cmp eax, edx                          # 0050185e
    mov dword ptr [esp + stk_18], eax            # 00501860
    mov dword ptr [esp + stk_1c], ebp            # 00501864
    jl.d32 L_0050179c                            # 00501868
    # block 0x0050186e: entered by fall-through of jl at 0x00501868, 3 instruction(s), falls into the block at 0x00501874
    mov eax, dword ptr [esp + stk_24]            # 0050186e
    pop edi                                      # 00501872
    pop ebx                                      # 00501873
L_00501874:
    # block 0x00501874: entered by jle at 0x00501788, 4 instruction(s), ends with ret
    pop esi                                      # 00501874
    pop ebp                                      # 00501875
    add esp, 0x18                                # 00501876
    ret                                          # 00501879

# --- data items (not part of the function) -------------------------
.org 0x0050187a - 0x401000
PAD_0050187a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

