# FUN_005038e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005038e0
# extent:       0x005038e0-0x00503a9b (443 code bytes)
# span:         0x005038e0-0x00503aa0 (code 443, tables 0, padding 5)
# sha256:       cdc6c47635e63570cfac90c532779975d7d1a4ca61d11727448ab7ba207e19b5
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005038e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_14, field_minus_1; [edi + n] field_8, field_10, field_1c, field_20, field_24, field_28; [edx + n] field_1c, field_minus_1; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_38
# callees:      calls FUN_0050bd80, FUN_0050be30, FUN_00502da0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 168 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050bd80, .text + (0x0050bd80 - 0x401000)
.set FUN_0050be30, .text + (0x0050be30 - 0x401000)

.org 0x005038e0 - 0x401000
.globl FUN_005038e0
FUN_005038e0:
    # block 0x005038e0: entry, 21 instruction(s), ends with jge to 0x00503a91 (forward)
    sub esp, 0x8                                 # 005038e0
    mov ecx, dword ptr [esp + stk_14]            # 005038e3
    push ebx                                     # 005038e7
    mov ebx, dword ptr [esp + stk_1c]            # 005038e8
    {load} mov eax, ecx                          # 005038ec
    cdq                                          # 005038ee
    idiv ebx                                     # 005038ef
    push ebp                                     # 005038f1
    push esi                                     # 005038f2
    push edi                                     # 005038f3
    {load} xor esi, esi                          # 005038f4
    mov dword ptr [esp + stk_10], esi            # 005038f6
    {load} mov edi, eax                          # 005038fa
    mov eax, dword ptr [esp + stk_30]            # 005038fc
    {load} add eax, ecx                          # 00503900
    mov dword ptr [esp + stk_24], edi            # 00503902
    cdq                                          # 00503906
    idiv ebx                                     # 00503907
    {load} cmp edi, eax                          # 00503909
    mov dword ptr [esp + stk_14], eax            # 0050390b
    jge.d32 L_00503a91                           # 0050390f
L_00503915:
    # block 0x00503915: entered by jmp at 0x00503a77; fall-through of jge at 0x0050390f, 11 instruction(s), calls FUN_0050bd80, ends with jl to 0x00503977 (forward)
    mov edi, dword ptr [esp + stk_1c]            # 00503915
    mov edx, dword ptr [esp + stk_2c]            # 00503919
    mov ecx, dword ptr [edi + field_24]          # 0050391d
    mov ebp, dword ptr [edi + field_28]          # 00503920
    push ecx                                     # 00503923
    push edx                                     # 00503924
    mov dword ptr [esp + stk_38], ebp            # 00503925
    call FUN_0050bd80                            # 00503929
    add esp, 0x8                                 # 0050392e
    test eax, eax                                # 00503931
    jl.d8 L_00503977                             # 00503933
    # block 0x00503935: entered by fall-through of jl at 0x00503933, 4 instruction(s), ends with je to 0x0050395b (forward)
    mov ecx, dword ptr [edi + field_20]          # 00503935
    mov ebx, dword ptr [ecx + 4*eax]             # 00503938
    test ebx, 0x80000000                         # 0050393b
    je.d8 L_0050395b                             # 00503941
    # block 0x00503943: entered by fall-through of je at 0x00503941, 7 instruction(s), ends with forward jump to 0x0050397c
    mov edi, dword ptr [edi + field_8]           # 00503943
    {load} mov esi, ebx                          # 00503946
    sar esi, 0xf                                 # 00503948
    and ebx, 0x7fff                              # 0050394b
    and esi, 0x7fff                              # 00503951
    {load} sub edi, ebx                          # 00503957
    jmp.d8 L_0050397c                            # 00503959
L_0050395b:
    # block 0x0050395b: entered by je at 0x00503941, 9 instruction(s), calls FUN_0050be30, ends with forward jump to 0x00503a1a
    mov edx, dword ptr [edi + field_1c]          # 0050395b
    mov ecx, dword ptr [esp + stk_2c]            # 0050395e
    movsx eax, byte ptr [edx + ebx - field_minus_1] # 00503962
    push eax                                     # 00503967
    push ecx                                     # 00503968
    call FUN_0050be30                            # 00503969
    add esp, 0x8                                 # 0050396e
    dec ebx                                      # 00503971
    jmp.d32 L_00503a1a                           # 00503972
L_00503977:
    # block 0x00503977: entered by jl at 0x00503933, 2 instruction(s), falls into the block at 0x0050397c
    mov edi, dword ptr [edi + field_8]           # 00503977
    {load} xor esi, esi                          # 0050397a
L_0050397c:
    # block 0x0050397c: entered by jmp at 0x00503959, 7 instruction(s), calls FUN_0050bd80, ends with jge to 0x005039b4 (forward)
    mov ebx, dword ptr [esp + stk_2c]            # 0050397c
    push ebp                                     # 00503980
    push ebx                                     # 00503981
    call FUN_0050bd80                            # 00503982
    add esp, 0x8                                 # 00503987
    test eax, eax                                # 0050398a
    jge.d8 L_005039b4                            # 0050398c
L_0050398e:
    # block 0x0050398e: entered by jl at 0x005039a0; fall-through of jge at 0x0050398c, 2 instruction(s), ends with jle to 0x005039a8 (forward)
    cmp ebp, 0x1                                 # 0050398e
    jle.d8 L_005039a8                            # 00503991
    # block 0x00503993: entered by fall-through of jle at 0x00503991, 7 instruction(s), calls FUN_0050bd80, ends with jl to 0x0050398e (backward)
    dec ebp                                      # 00503993
    push ebp                                     # 00503994
    push ebx                                     # 00503995
    call FUN_0050bd80                            # 00503996
    add esp, 0x8                                 # 0050399b
    test eax, eax                                # 0050399e
    jl.d8 L_0050398e                             # 005039a0
    # block 0x005039a2: entered by fall-through of jl at 0x005039a0, 2 instruction(s), ends with forward jump to 0x005039b4
    mov dword ptr [esp + stk_30], ebp            # 005039a2
    jmp.d8 L_005039b4                            # 005039a6
L_005039a8:
    # block 0x005039a8: entered by jle at 0x00503991, 3 instruction(s), ends with jl to 0x00503a86 (forward)
    test eax, eax                                # 005039a8
    mov dword ptr [esp + stk_30], ebp            # 005039aa
    jl.d32 L_00503a86                            # 005039ae
L_005039b4:
    # block 0x005039b4: entered by jge at 0x0050398c; jmp at 0x005039a6; fall-through of jl at 0x005039ae, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x005039f7 (forward)
    push eax                                     # 005039b4
    call FUN_00502da0                            # 005039b5
    {load} mov edx, edi                          # 005039ba
    add esp, 0x4                                 # 005039bc
    {load} sub edx, esi                          # 005039bf
    cmp edx, 0x1                                 # 005039c1
    jle.d8 L_005039f7                            # 005039c4
    # block 0x005039c6: entered by fall-through of jle at 0x005039c4, 2 instruction(s), falls into the block at 0x005039cd
    mov ecx, dword ptr [esp + stk_1c]            # 005039c6
    mov ebx, dword ptr [ecx + field_14]          # 005039ca
L_005039cd:
    # block 0x005039cd: entered by jg at 0x005039ed, 15 instruction(s), ends with jg to 0x005039cd (backward)
    sar edx                                      # 005039cd
    lea ecx, [edx + esi]                         # 005039cf
    cmp eax, dword ptr [ebx + 4*ecx]             # 005039d2
    {load} sbb ecx, ecx                          # 005039d5
    neg ecx                                      # 005039d7
    lea ebp, [ecx - field_minus_1]               # 005039d9
    neg ecx                                      # 005039dc
    {load} and ecx, edx                          # 005039de
    {load} and ebp, edx                          # 005039e0
    {load} sub edi, ecx                          # 005039e2
    {load} add esi, ebp                          # 005039e4
    {load} mov edx, edi                          # 005039e6
    {load} sub edx, esi                          # 005039e8
    cmp edx, 0x1                                 # 005039ea
    jg.d8 L_005039cd                             # 005039ed
    # block 0x005039ef: entered by fall-through of jg at 0x005039ed, 2 instruction(s), falls into the block at 0x005039f7
    mov ebp, dword ptr [esp + stk_30]            # 005039ef
    mov ebx, dword ptr [esp + stk_2c]            # 005039f3
L_005039f7:
    # block 0x005039f7: entered by jle at 0x005039c4, 5 instruction(s), ends with jg to 0x00503a7c (forward)
    mov edx, dword ptr [esp + stk_1c]            # 005039f7
    mov eax, dword ptr [edx + field_1c]          # 005039fb
    movsx eax, byte ptr [eax + esi]              # 005039fe
    {load} cmp eax, ebp                          # 00503a02
    jg.d8 L_00503a7c                             # 00503a04
    # block 0x00503a06: entered by fall-through of jg at 0x00503a04, 7 instruction(s), calls FUN_0050be30, falls into the block at 0x00503a1a
    push eax                                     # 00503a06
    push ebx                                     # 00503a07
    call FUN_0050be30                            # 00503a08
    mov edi, dword ptr [esp + stk_24]            # 00503a0d
    {load} mov ebx, esi                          # 00503a11
    mov esi, dword ptr [esp + stk_18]            # 00503a13
    add esp, 0x8                                 # 00503a17
L_00503a1a:
    # block 0x00503a1a: entered by jmp at 0x00503972, 2 instruction(s), ends with je to 0x00503a86 (forward)
    cmp ebx, -0x1                                # 00503a1a
    je.d8 L_00503a86                             # 00503a1d
    # block 0x00503a1f: entered by fall-through of je at 0x00503a1d, 9 instruction(s), ends with jle to 0x00503a6b (forward)
    mov eax, dword ptr [edi]                     # 00503a1f
    mov edx, dword ptr [edi + field_10]          # 00503a21
    {load} mov ecx, eax                          # 00503a24
    imul ecx, ebx                                # 00503a26
    {load} xor ebx, ebx                          # 00503a29
    lea ecx, [edx + 4*ecx]                       # 00503a2b
    {load} xor edx, edx                          # 00503a2e
    {load} cmp eax, ebx                          # 00503a30
    jle.d8 L_00503a6b                            # 00503a32
L_00503a34:
    # block 0x00503a34: entered by jl at 0x00503a69; fall-through of jle at 0x00503a32, 11 instruction(s), ends with jne to 0x00503a61 (forward)
    mov eax, dword ptr [esp + stk_20]            # 00503a34
    mov ebp, dword ptr [esp + stk_24]            # 00503a38
    mov eax, dword ptr [eax + 4*esi]             # 00503a3c
    inc esi                                      # 00503a3f
    mov dword ptr [esp + stk_10], esi            # 00503a40
    fld dword ptr [eax + 4*ebp]                  # 00503a44
    fadd dword ptr [ecx]                         # 00503a47
    lea eax, [eax + 4*ebp]                       # 00503a49
    fstp dword ptr [eax]                         # 00503a4c
    cmp esi, dword ptr [esp + stk_28]            # 00503a4e
    jne.d8 L_00503a61                            # 00503a52
    # block 0x00503a54: entered by fall-through of jne at 0x00503a52, 5 instruction(s), falls into the block at 0x00503a61
    {load} mov eax, ebp                          # 00503a54
    mov dword ptr [esp + stk_10], ebx            # 00503a56
    inc eax                                      # 00503a5a
    {load} mov esi, ebx                          # 00503a5b
    mov dword ptr [esp + stk_24], eax            # 00503a5d
L_00503a61:
    # block 0x00503a61: entered by jne at 0x00503a52, 5 instruction(s), ends with jl to 0x00503a34 (backward)
    mov eax, dword ptr [edi]                     # 00503a61
    inc edx                                      # 00503a63
    add ecx, 0x4                                 # 00503a64
    {load} cmp edx, eax                          # 00503a67
    jl.d8 L_00503a34                             # 00503a69
L_00503a6b:
    # block 0x00503a6b: entered by jle at 0x00503a32; fall-through of jl at 0x00503a69, 4 instruction(s), ends with jge to 0x00503a91 (forward)
    mov ecx, dword ptr [esp + stk_24]            # 00503a6b
    mov eax, dword ptr [esp + stk_14]            # 00503a6f
    {load} cmp ecx, eax                          # 00503a73
    jge.d8 L_00503a91                            # 00503a75
    # block 0x00503a77: entered by fall-through of jge at 0x00503a75, 1 instruction(s), ends with backward jump to 0x00503915
    jmp.d32 L_00503915                           # 00503a77
L_00503a7c:
    # block 0x00503a7c: entered by jg at 0x00503a04, 4 instruction(s), calls FUN_0050be30, falls into the block at 0x00503a86
    push ebp                                     # 00503a7c
    push ebx                                     # 00503a7d
    call FUN_0050be30                            # 00503a7e
    add esp, 0x8                                 # 00503a83
L_00503a86:
    # block 0x00503a86: entered by jl at 0x005039ae; je at 0x00503a1d, 7 instruction(s), ends with ret
    pop edi                                      # 00503a86
    pop esi                                      # 00503a87
    pop ebp                                      # 00503a88
    or eax, -0x1                                 # 00503a89
    pop ebx                                      # 00503a8c
    add esp, 0x8                                 # 00503a8d
    ret                                          # 00503a90
L_00503a91:
    # block 0x00503a91: entered by jge at 0x0050390f; jge at 0x00503a75, 7 instruction(s), ends with ret
    pop edi                                      # 00503a91
    pop esi                                      # 00503a92
    pop ebp                                      # 00503a93
    {load} xor eax, eax                          # 00503a94
    pop ebx                                      # 00503a96
    add esp, 0x8                                 # 00503a97
    ret                                          # 00503a9a

# --- data items (not part of the function) -------------------------
.org 0x00503a9b - 0x401000
PAD_00503a9b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

