# FUN_004fd8b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd8b0
# extent:       0x004fd8b0-0x004fdb8d (733 code bytes)
# span:         0x004fd8b0-0x004fdb90 (code 733, tables 0, padding 3)
# sha256:       ed47b62cb5b1739f994008adad2fe0d02c838de8ae865418b372f3ad5a9362f9
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd8b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4; [edi + n] field_4, field_8, field_c; [edx + n] field_4; [esi + n] field_8, field_c, field_34, field_38, field_3c, field_40, field_44, field_48, field_4c, field_74; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_28, stk_30, stk_48, stk_50, stk_54
# callees:      calls FUN_0050ebca, FUN_0050ea90, FUN_004fd650, FUN_004fd160, FUN_0050ba50, FUN_004fd2b0, FUN_0050b260, FUN_0050b6f0, FUN_0050ba70, FUN_004ffb90, FUN_0050b180, FUN_004fd530, FUN_004fe700, FUN_004fe660
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 265 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_28, 0x28  # offset +0x28
.equ stk_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------
.set FUN_004fd160, .text + (0x004fd160 - 0x401000)
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fd530, .text + (0x004fd530 - 0x401000)
.set FUN_004fd650, .text + (0x004fd650 - 0x401000)
.set FUN_004fe660, .text + (0x004fe660 - 0x401000)
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_004ffb90, .text + (0x004ffb90 - 0x401000)
.set FUN_0050b180, .text + (0x0050b180 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050b6f0, .text + (0x0050b6f0 - 0x401000)
.set FUN_0050ba50, .text + (0x0050ba50 - 0x401000)
.set FUN_0050ba70, .text + (0x0050ba70 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)

.org 0x004fd8b0 - 0x401000
.globl FUN_004fd8b0
FUN_004fd8b0:
    # block 0x004fd8b0: entry, 35 instruction(s), calls FUN_0050ebca, FUN_0050ea90, ends with jle to 0x004fdb86 (forward)
    sub esp, 0x38                                # 004fd8b0
    push ebx                                     # 004fd8b3
    push ebp                                     # 004fd8b4
    push esi                                     # 004fd8b5
    mov esi, dword ptr [esp + stk_48]            # 004fd8b6
    mov eax, dword ptr [esi + field_34]          # 004fd8ba
    mov ecx, dword ptr [esi + field_48]          # 004fd8bd
    shl eax, 0x5                                 # 004fd8c0
    push eax                                     # 004fd8c3
    push ecx                                     # 004fd8c4
    call FUN_0050ebca                            # 004fd8c5
    mov edx, dword ptr [esi + field_34]          # 004fd8ca
    mov dword ptr [esi + field_48], eax          # 004fd8cd
    mov eax, dword ptr [esi + field_4c]          # 004fd8d0
    shl edx, 0x4                                 # 004fd8d3
    push edx                                     # 004fd8d6
    push eax                                     # 004fd8d7
    call FUN_0050ebca                            # 004fd8d8
    mov ecx, dword ptr [esi + field_34]          # 004fd8dd
    mov dword ptr [esi + field_4c], eax          # 004fd8e0
    shl ecx, 0x3                                 # 004fd8e3
    push ecx                                     # 004fd8e6
    call FUN_0050ea90                            # 004fd8e7
    mov edx, dword ptr [esi + field_34]          # 004fd8ec
    mov dword ptr [esi + field_3c], eax          # 004fd8ef
    shl edx, 0x4                                 # 004fd8f2
    push edx                                     # 004fd8f5
    call FUN_0050ea90                            # 004fd8f6
    mov dword ptr [esi + field_44], eax          # 004fd8fb
    mov eax, dword ptr [esi + field_34]          # 004fd8fe
    {load} xor ebp, ebp                          # 004fd901
    add esp, 0x18                                # 004fd903
    {load} xor ebx, ebx                          # 004fd906
    {load} cmp eax, ebp                          # 004fd908
    jle.d32 L_004fdb86                           # 004fd90a
    # block 0x004fd910: entered by fall-through of jle at 0x004fd90a, 2 instruction(s), ends with forward jump to 0x004fd915
    push edi                                     # 004fd910
    jmp.d8 L_004fd915                            # 004fd911
L_004fd913:
    # block 0x004fd913: entered by jl at 0x004fdb7f, 1 instruction(s), falls into the block at 0x004fd915
    {load} xor ebp, ebp                          # 004fd913
L_004fd915:
    # block 0x004fd915: entered by jmp at 0x004fd911, 2 instruction(s), ends with jne to 0x004fd936 (forward)
    {load} cmp ebx, ebp                          # 004fd915
    jne.d8 L_004fd936                            # 004fd917
    # block 0x004fd919: entered by fall-through of jne at 0x004fd917, 11 instruction(s), calls FUN_004fd650, ends with forward jump to 0x004fd995
    mov edx, dword ptr [esi + field_3c]          # 004fd919
    mov ecx, dword ptr [esp + stk_50]            # 004fd91c
    mov eax, dword ptr [esp + stk_54]            # 004fd920
    mov dword ptr [edx], ecx                     # 004fd924
    push eax                                     # 004fd926
    push ecx                                     # 004fd927
    push esi                                     # 004fd928
    mov dword ptr [edx + field_4], eax           # 004fd929
    call FUN_004fd650                            # 004fd92c
    add esp, 0xc                                 # 004fd931
    jmp.d8 L_004fd995                            # 004fd934
L_004fd936:
    # block 0x004fd936: entered by jne at 0x004fd917, 26 instruction(s), calls FUN_004fd650, FUN_004fd160, ends with jge to 0x004fd988 (forward)
    mov eax, dword ptr [esi + field_38]          # 004fd936
    lea edi, [8*ebx]                             # 004fd939
    mov ecx, dword ptr [eax + edi + field_4]     # 004fd940
    push ecx                                     # 004fd944
    mov edx, dword ptr [eax + edi]               # 004fd945
    push edx                                     # 004fd948
    push esi                                     # 004fd949
    call FUN_004fd650                            # 004fd94a
    mov edx, dword ptr [esi + field_4c]          # 004fd94f
    {load} mov eax, ebx                          # 004fd952
    shl eax, 0x4                                 # 004fd954
    push ebp                                     # 004fd957
    {load} add eax, edx                          # 004fd958
    push ebp                                     # 004fd95a
    {load} mov ecx, ebx                          # 004fd95b
    push eax                                     # 004fd95d
    mov eax, dword ptr [esi + field_48]          # 004fd95e
    shl ecx, 0x5                                 # 004fd961
    {load} add ecx, eax                          # 004fd964
    push ecx                                     # 004fd966
    push esi                                     # 004fd967
    call FUN_004fd160                            # 004fd968
    add esp, 0x20                                # 004fd96d
    test eax, eax                                # 004fd970
    mov eax, dword ptr [esi + field_3c]          # 004fd972
    jge.d8 L_004fd988                            # 004fd975
    # block 0x004fd977: entered by fall-through of jge at 0x004fd975, 4 instruction(s), ends with forward jump to 0x004fd995
    {load} add edi, eax                          # 004fd977
    mov dword ptr [edi], 0xffffffff              # 004fd979
    mov dword ptr [edi + field_4], 0xffffffff    # 004fd97f
    jmp.d8 L_004fd995                            # 004fd986
L_004fd988:
    # block 0x004fd988: entered by jge at 0x004fd975, 5 instruction(s), falls into the block at 0x004fd995
    mov edx, dword ptr [esi + field_8]           # 004fd988
    {load} add edi, eax                          # 004fd98b
    mov dword ptr [edi], edx                     # 004fd98d
    mov eax, dword ptr [esi + field_c]           # 004fd98f
    mov dword ptr [edi + field_4], eax           # 004fd992
L_004fd995:
    # block 0x004fd995: entered by jmp at 0x004fd934; jmp at 0x004fd986, 7 instruction(s), ends with je to 0x004fdadf (forward)
    mov ecx, dword ptr [esi + field_3c]          # 004fd995
    mov edx, dword ptr [ecx + 8*ebx]             # 004fd998
    lea eax, [ecx + 8*ebx]                       # 004fd99b
    mov ecx, dword ptr [ecx + 8*ebx + field_4]   # 004fd99e
    {load} and edx, ecx                          # 004fd9a2
    cmp edx, -0x1                                # 004fd9a4
    je.d32 L_004fdadf                            # 004fd9a7
    # block 0x004fd9ad: entered by fall-through of je at 0x004fd9a7, 10 instruction(s), calls FUN_0050ba50, falls into the block at 0x004fd9cb
    mov eax, dword ptr [esi + field_40]          # 004fd9ad
    mov dword ptr [esp + stk_10], ebp            # 004fd9b0
    mov dword ptr [esp + stk_14], ebp            # 004fd9b4
    lea ebp, [esi + field_74]                    # 004fd9b8
    mov ecx, dword ptr [eax + 4*ebx]             # 004fd9bb
    or edi, -0x1                                 # 004fd9be
    push ecx                                     # 004fd9c1
    push ebp                                     # 004fd9c2
    call FUN_0050ba50                            # 004fd9c3
    add esp, 0x8                                 # 004fd9c8
L_004fd9cb:
    # block 0x004fd9cb: entered by je at 0x004fda87, 9 instruction(s), calls FUN_004fd2b0, ends with jl to 0x004fdaae (forward)
    push -0x1                                    # 004fd9cb
    lea edx, [esp + stk_1c]                      # 004fd9cd
    push -0x1                                    # 004fd9d1
    push edx                                     # 004fd9d3
    push esi                                     # 004fd9d4
    call FUN_004fd2b0                            # 004fd9d5
    add esp, 0x10                                # 004fd9da
    test edx, edx                                # 004fd9dd
    jl.d32 L_004fdaae                            # 004fd9df
    # block 0x004fd9e5: entered by fall-through of jl at 0x004fd9df, 1 instruction(s), ends with jg to 0x004fd9ef (forward)
    jg.d8 L_004fd9ef                             # 004fd9e5
    # block 0x004fd9e7: entered by fall-through of jg at 0x004fd9e5, 2 instruction(s), ends with jb to 0x004fdaae (forward)
    test eax, eax                                # 004fd9e7
    jb.d32 L_004fdaae                            # 004fd9e9
L_004fd9ef:
    # block 0x004fd9ef: entered by jg at 0x004fd9e5; fall-through of jb at 0x004fd9e9, 7 instruction(s), calls FUN_0050b260, ends with jne to 0x004fdaae (forward)
    lea eax, [esp + stk_18]                      # 004fd9ef
    push eax                                     # 004fd9f3
    call FUN_0050b260                            # 004fd9f4
    mov ecx, dword ptr [esi + field_40]          # 004fd9f9
    add esp, 0x4                                 # 004fd9fc
    cmp eax, dword ptr [ecx + 4*ebx]             # 004fd9ff
    jne.d32 L_004fdaae                           # 004fda02
    # block 0x004fda08: entered by fall-through of jne at 0x004fda02, 11 instruction(s), calls FUN_0050b6f0, FUN_0050ba70, ends with je to 0x004fda75 (forward)
    lea edx, [esp + stk_18]                      # 004fda08
    push edx                                     # 004fda0c
    push ebp                                     # 004fda0d
    call FUN_0050b6f0                            # 004fda0e
    lea eax, [esp + stk_30]                      # 004fda13
    push eax                                     # 004fda17
    push ebp                                     # 004fda18
    call FUN_0050ba70                            # 004fda19
    add esp, 0x10                                # 004fda1e
    test eax, eax                                # 004fda21
    je.d8 L_004fda75                             # 004fda23
L_004fda25:
    # block 0x004fda25: entered by jne at 0x004fda73; fall-through of je at 0x004fda23, 1 instruction(s), ends with jle to 0x004fda63 (forward)
    jle.d8 L_004fda63                            # 004fda25
    # block 0x004fda27: entered by fall-through of jle at 0x004fda25, 12 instruction(s), calls FUN_004ffb90, ends with je to 0x004fda61 (forward)
    lea ecx, [esp + stk_28]                      # 004fda27
    {load} mov edx, ebx                          # 004fda2b
    push ecx                                     # 004fda2d
    mov ecx, dword ptr [esi + field_48]          # 004fda2e
    shl edx, 0x5                                 # 004fda31
    {load} add edx, ecx                          # 004fda34
    push edx                                     # 004fda36
    call FUN_004ffb90                            # 004fda37
    add esp, 0x8                                 # 004fda3c
    cmp edi, -0x1                                # 004fda3f
    {load} mov ecx, eax                          # 004fda42
    je.d8 L_004fda61                             # 004fda44
    # block 0x004fda46: entered by fall-through of je at 0x004fda44, 9 instruction(s), falls into the block at 0x004fda61
    lea eax, [ecx + edi]                         # 004fda46
    mov edi, dword ptr [esp + stk_10]            # 004fda49
    sar eax, 0x2                                 # 004fda4d
    cdq                                          # 004fda50
    {load} add edi, eax                          # 004fda51
    mov eax, dword ptr [esp + stk_14]            # 004fda53
    {load} adc eax, edx                          # 004fda57
    mov dword ptr [esp + stk_10], edi            # 004fda59
    mov dword ptr [esp + stk_14], eax            # 004fda5d
L_004fda61:
    # block 0x004fda61: entered by je at 0x004fda44, 1 instruction(s), falls into the block at 0x004fda63
    {load} mov edi, ecx                          # 004fda61
L_004fda63:
    # block 0x004fda63: entered by jle at 0x004fda25, 7 instruction(s), calls FUN_0050ba70, ends with jne to 0x004fda25 (backward)
    lea eax, [esp + stk_28]                      # 004fda63
    push eax                                     # 004fda67
    push ebp                                     # 004fda68
    call FUN_0050ba70                            # 004fda69
    add esp, 0x8                                 # 004fda6e
    test eax, eax                                # 004fda71
    jne.d8 L_004fda25                            # 004fda73
L_004fda75:
    # block 0x004fda75: entered by je at 0x004fda23; fall-through of jne at 0x004fda73, 7 instruction(s), calls FUN_0050b180, ends with je to 0x004fd9cb (backward)
    lea ecx, [esp + stk_18]                      # 004fda75
    push ecx                                     # 004fda79
    call FUN_0050b180                            # 004fda7a
    {load} and eax, edx                          # 004fda7f
    add esp, 0x4                                 # 004fda81
    cmp eax, -0x1                                # 004fda84
    je.d32 L_004fd9cb                            # 004fda87
    # block 0x004fda8d: entered by fall-through of je at 0x004fda87, 10 instruction(s), calls FUN_0050b180, falls into the block at 0x004fdaae
    lea edx, [esp + stk_18]                      # 004fda8d
    push edx                                     # 004fda91
    call FUN_0050b180                            # 004fda92
    mov edi, dword ptr [esp + stk_14]            # 004fda97
    mov ecx, dword ptr [esp + stk_18]            # 004fda9b
    add esp, 0x4                                 # 004fda9f
    {load} sub eax, edi                          # 004fdaa2
    {load} sbb edx, ecx                          # 004fdaa4
    mov dword ptr [esp + stk_10], eax            # 004fdaa6
    mov dword ptr [esp + stk_14], edx            # 004fdaaa
L_004fdaae:
    # block 0x004fdaae: entered by jl at 0x004fd9df; jb at 0x004fd9e9; jne at 0x004fda02, 4 instruction(s), ends with jg to 0x004fdac8 (forward)
    mov ecx, dword ptr [esp + stk_14]            # 004fdaae
    {load} xor eax, eax                          # 004fdab2
    {load} cmp ecx, eax                          # 004fdab4
    jg.d8 L_004fdac8                             # 004fdab6
    # block 0x004fdab8: entered by fall-through of jg at 0x004fdab6, 1 instruction(s), ends with jl to 0x004fdac0 (forward)
    jl.d8 L_004fdac0                             # 004fdab8
    # block 0x004fdaba: entered by fall-through of jl at 0x004fdab8, 2 instruction(s), ends with jae to 0x004fdac8 (forward)
    cmp dword ptr [esp + stk_10], eax            # 004fdaba
    jae.d8 L_004fdac8                            # 004fdabe
L_004fdac0:
    # block 0x004fdac0: entered by jl at 0x004fdab8; fall-through of jae at 0x004fdabe, 2 instruction(s), falls into the block at 0x004fdac8
    mov dword ptr [esp + stk_10], eax            # 004fdac0
    mov dword ptr [esp + stk_14], eax            # 004fdac4
L_004fdac8:
    # block 0x004fdac8: entered by jg at 0x004fdab6; jae at 0x004fdabe, 8 instruction(s), falls into the block at 0x004fdadf
    mov ecx, dword ptr [esi + field_44]          # 004fdac8
    {load} mov eax, ebx                          # 004fdacb
    mov edx, dword ptr [esp + stk_14]            # 004fdacd
    shl eax, 0x4                                 # 004fdad1
    {load} add eax, ecx                          # 004fdad4
    mov ecx, dword ptr [esp + stk_10]            # 004fdad6
    mov dword ptr [eax], ecx                     # 004fdada
    mov dword ptr [eax + field_4], edx           # 004fdadc
L_004fdadf:
    # block 0x004fdadf: entered by je at 0x004fd9a7, 8 instruction(s), calls FUN_004fd650, falls into the block at 0x004fdaf5
    mov eax, dword ptr [esi + field_38]          # 004fdadf
    mov ecx, dword ptr [eax + 8*ebx + field_c]   # 004fdae2
    push ecx                                     # 004fdae6
    mov edx, dword ptr [eax + 8*ebx + field_8]   # 004fdae7
    push edx                                     # 004fdaeb
    push esi                                     # 004fdaec
    call FUN_004fd650                            # 004fdaed
    add esp, 0xc                                 # 004fdaf2
L_004fdaf5:
    # block 0x004fdaf5: entered by jmp at 0x004fdb2b, 9 instruction(s), calls FUN_004fd530, ends with jl to 0x004fdb2d (forward)
    lea eax, [esp + stk_18]                      # 004fdaf5
    push eax                                     # 004fdaf9
    push esi                                     # 004fdafa
    call FUN_004fd530                            # 004fdafb
    {load} mov edi, edx                          # 004fdb00
    add esp, 0x8                                 # 004fdb02
    test edi, edi                                # 004fdb05
    {load} mov ebp, eax                          # 004fdb07
    jl.d8 L_004fdb2d                             # 004fdb09
    # block 0x004fdb0b: entered by fall-through of jl at 0x004fdb09, 1 instruction(s), ends with jg to 0x004fdb11 (forward)
    jg.d8 L_004fdb11                             # 004fdb0b
    # block 0x004fdb0d: entered by fall-through of jg at 0x004fdb0b, 2 instruction(s), ends with jb to 0x004fdb2d (forward)
    test ebp, ebp                                # 004fdb0d
    jb.d8 L_004fdb2d                             # 004fdb0f
L_004fdb11:
    # block 0x004fdb11: entered by jg at 0x004fdb0b; fall-through of jb at 0x004fdb0f, 7 instruction(s), calls FUN_0050b180, ends with jne to 0x004fdb52 (forward)
    lea ecx, [esp + stk_18]                      # 004fdb11
    push ecx                                     # 004fdb15
    call FUN_0050b180                            # 004fdb16
    {load} and eax, edx                          # 004fdb1b
    add esp, 0x4                                 # 004fdb1d
    cmp eax, -0x1                                # 004fdb20
    jne.d8 L_004fdb52                            # 004fdb23
    # block 0x004fdb25: entered by fall-through of jne at 0x004fdb23, 3 instruction(s), ends with backward jump to 0x004fdaf5
    mov dword ptr [esi + field_8], ebp           # 004fdb25
    mov dword ptr [esi + field_c], edi           # 004fdb28
    jmp.d8 L_004fdaf5                            # 004fdb2b
L_004fdb2d:
    # block 0x004fdb2d: entered by jl at 0x004fdb09; jb at 0x004fdb0f, 14 instruction(s), calls FUN_004fe700, FUN_004fe660, ends with forward jump to 0x004fdb79
    mov ecx, dword ptr [esi + field_48]          # 004fdb2d
    {load} mov edx, ebx                          # 004fdb30
    shl edx, 0x5                                 # 004fdb32
    {load} add edx, ecx                          # 004fdb35
    push edx                                     # 004fdb37
    call FUN_004fe700                            # 004fdb38
    mov edx, dword ptr [esi + field_4c]          # 004fdb3d
    {load} mov eax, ebx                          # 004fdb40
    shl eax, 0x4                                 # 004fdb42
    {load} add eax, edx                          # 004fdb45
    push eax                                     # 004fdb47
    call FUN_004fe660                            # 004fdb48
    add esp, 0x8                                 # 004fdb4d
    jmp.d8 L_004fdb79                            # 004fdb50
L_004fdb52:
    # block 0x004fdb52: entered by jne at 0x004fdb23, 14 instruction(s), calls FUN_0050b180, falls into the block at 0x004fdb79
    mov edx, dword ptr [esi + field_44]          # 004fdb52
    {load} mov ecx, ebx                          # 004fdb55
    shl ecx, 0x4                                 # 004fdb57
    lea eax, [esp + stk_18]                      # 004fdb5a
    push eax                                     # 004fdb5e
    lea edi, [ecx + edx]                         # 004fdb5f
    call FUN_0050b180                            # 004fdb62
    mov ebp, dword ptr [edi]                     # 004fdb67
    mov ecx, dword ptr [edi + field_4]           # 004fdb69
    add esp, 0x4                                 # 004fdb6c
    {load} sub eax, ebp                          # 004fdb6f
    {load} sbb edx, ecx                          # 004fdb71
    mov dword ptr [edi + field_8], eax           # 004fdb73
    mov dword ptr [edi + field_c], edx           # 004fdb76
L_004fdb79:
    # block 0x004fdb79: entered by jmp at 0x004fdb50, 4 instruction(s), ends with jl to 0x004fd913 (backward)
    mov eax, dword ptr [esi + field_34]          # 004fdb79
    inc ebx                                      # 004fdb7c
    {load} cmp ebx, eax                          # 004fdb7d
    jl.d32 L_004fd913                            # 004fdb7f
    # block 0x004fdb85: entered by fall-through of jl at 0x004fdb7f, 1 instruction(s), falls into the block at 0x004fdb86
    pop edi                                      # 004fdb85
L_004fdb86:
    # block 0x004fdb86: entered by jle at 0x004fd90a, 5 instruction(s), ends with ret
    pop esi                                      # 004fdb86
    pop ebp                                      # 004fdb87
    pop ebx                                      # 004fdb88
    add esp, 0x38                                # 004fdb89
    ret                                          # 004fdb8c

# --- data items (not part of the function) -------------------------
.org 0x004fdb8d - 0x401000
PAD_004fdb8d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

