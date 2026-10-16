# FUN_004c51a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c51a5
# extent:       0x004c51a5-0x004c5377 (466 code bytes)
# span:         0x004c51a5-0x004c5377 (code 466, tables 0, padding 0)
# sha256:       dc7b9a9ed6c6241cef6a4b866d5beb55aa030f2a9263d521b3c28f917702eb0b
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c51a5
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_114, local_118, local_11c, local_120, local_124
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 153 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c51a5 - 0x401000
.globl FUN_004c51a5
FUN_004c51a5:
    # block 0x004c51a5: entry, 9 instruction(s), ends with je to 0x004c529b (forward)
    push ebp                                     # 004c51a5
    {load} mov ebp, esp                          # 004c51a6
    sub esp, 0x124                               # 004c51a8
    push esi                                     # 004c51ae
    push edi                                     # 004c51af
    mov dword ptr [ebp - local_124], ecx         # 004c51b0
    movsx eax, word ptr [0x63a4cd]               # 004c51b6
    test eax, eax                                # 004c51bd
    je.d32 L_004c529b                            # 004c51bf
    # block 0x004c51c5: entered by fall-through of je at 0x004c51bf, 23 instruction(s), ends with jne to 0x004c522d (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c51c5
    mov edx, dword ptr [ebp + arg_10]            # 004c51c8
    mov eax, dword ptr [ecx + field_8]           # 004c51cb
    sub eax, dword ptr [edx]                     # 004c51ce
    mov dword ptr [ebp - local_120], eax         # 004c51d0
    mov ecx, dword ptr [ebp + arg_10]            # 004c51d6
    mov edx, dword ptr [ebp + arg_10]            # 004c51d9
    mov eax, dword ptr [ecx + field_c]           # 004c51dc
    sub eax, dword ptr [edx + field_4]           # 004c51df
    mov dword ptr [ebp - local_11c], eax         # 004c51e2
    mov ecx, dword ptr [ebp + arg_14]            # 004c51e8
    mov edx, dword ptr [ebp + arg_14]            # 004c51eb
    mov eax, dword ptr [ecx + field_8]           # 004c51ee
    sub eax, dword ptr [edx]                     # 004c51f1
    mov dword ptr [ebp - local_18], eax          # 004c51f3
    mov ecx, dword ptr [ebp + arg_14]            # 004c51f6
    mov edx, dword ptr [ebp + arg_14]            # 004c51f9
    mov eax, dword ptr [ecx + field_c]           # 004c51fc
    sub eax, dword ptr [edx + field_4]           # 004c51ff
    mov dword ptr [ebp - local_118], eax         # 004c5202
    mov ecx, dword ptr [ebp - local_120]         # 004c5208
    cmp ecx, dword ptr [ebp - local_18]          # 004c520e
    jne.d8 L_004c522d                            # 004c5211
    # block 0x004c5213: entered by fall-through of jne at 0x004c5211, 3 instruction(s), ends with jne to 0x004c522d (forward)
    mov edx, dword ptr [ebp - local_11c]         # 004c5213
    cmp edx, dword ptr [ebp - local_118]         # 004c5219
    jne.d8 L_004c522d                            # 004c521f
    # block 0x004c5221: entered by fall-through of jne at 0x004c521f, 2 instruction(s), ends with je to 0x004c522d (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c5221
    je.d8 L_004c522d                             # 004c5225
    # block 0x004c5227: entered by fall-through of je at 0x004c5225, 2 instruction(s), ends with jne to 0x004c529b (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c5227
    jne.d8 L_004c529b                            # 004c522b
L_004c522d:
    # block 0x004c522d: entered by jne at 0x004c5211; jne at 0x004c521f; je at 0x004c5225; fall-through of jne at 0x004c522b, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c536f
    mov eax, dword ptr [ebp + arg_14]            # 004c522d
    mov ecx, dword ptr [eax + field_c]           # 004c5230
    push ecx                                     # 004c5233
    mov edx, dword ptr [ebp + arg_14]            # 004c5234
    mov eax, dword ptr [edx + field_8]           # 004c5237
    push eax                                     # 004c523a
    mov ecx, dword ptr [ebp + arg_14]            # 004c523b
    mov edx, dword ptr [ecx + field_4]           # 004c523e
    push edx                                     # 004c5241
    mov eax, dword ptr [ebp + arg_14]            # 004c5242
    mov ecx, dword ptr [eax]                     # 004c5245
    push ecx                                     # 004c5247
    mov edx, dword ptr [ebp + arg_10]            # 004c5248
    mov eax, dword ptr [edx + field_c]           # 004c524b
    push eax                                     # 004c524e
    mov ecx, dword ptr [ebp + arg_10]            # 004c524f
    mov edx, dword ptr [ecx + field_8]           # 004c5252
    push edx                                     # 004c5255
    mov eax, dword ptr [ebp + arg_10]            # 004c5256
    mov ecx, dword ptr [eax + field_4]           # 004c5259
    push ecx                                     # 004c525c
    mov edx, dword ptr [ebp + arg_10]            # 004c525d
    mov eax, dword ptr [edx]                     # 004c5260
    push eax                                     # 004c5262
    mov ecx, dword ptr [ebp + arg_18]            # 004c5263
    push ecx                                     # 004c5266
    push 0x554848                                # 004c5267
    lea edx, [ebp - local_114]                   # 004c526c
    push edx                                     # 004c5272
    call FUN_0050ca3e                            # 004c5273
    add esp, 0x2c                                # 004c5278
    push 0x0                                     # 004c527b
    push 0x0                                     # 004c527d
    lea eax, [ebp - local_114]                   # 004c527f
    push eax                                     # 004c5285
    call FUN_0052139c                            # 004c5286
    mov ecx, dword ptr [ebp - local_124]         # 004c528b
    call FUN_004c97b4                            # 004c5291
    jmp.d32 L_004c536f                           # 004c5296
L_004c529b:
    # block 0x004c529b: entered by je at 0x004c51bf; jne at 0x004c522b, 44 instruction(s), ends with forward jump to 0x004c5330
    mov ecx, dword ptr [ebp + arg_8]             # 004c529b
    movsx edx, word ptr [ecx + field_2f]         # 004c529e
    mov eax, dword ptr [ebp + arg_10]            # 004c52a2
    mov ecx, dword ptr [eax + field_4]           # 004c52a5
    imul ecx, edx                                # 004c52a8
    mov edx, dword ptr [ebp + arg_8]             # 004c52ab
    mov eax, dword ptr [edx]                     # 004c52ae
    {load} add eax, ecx                          # 004c52b0
    movsx ecx, word ptr [0x639895]               # 004c52b2
    mov edx, dword ptr [ebp + arg_10]            # 004c52b9
    mov edx, dword ptr [edx]                     # 004c52bc
    imul edx, ecx                                # 004c52be
    {load} add eax, edx                          # 004c52c1
    mov dword ptr [ebp - local_4], eax           # 004c52c3
    mov eax, dword ptr [ebp + arg_c]             # 004c52c6
    movsx ecx, word ptr [eax + field_2f]         # 004c52c9
    mov edx, dword ptr [ebp + arg_14]            # 004c52cd
    mov eax, dword ptr [edx + field_4]           # 004c52d0
    imul eax, ecx                                # 004c52d3
    mov ecx, dword ptr [ebp + arg_c]             # 004c52d6
    mov edx, dword ptr [ecx]                     # 004c52d9
    {load} add edx, eax                          # 004c52db
    movsx eax, word ptr [0x639895]               # 004c52dd
    mov ecx, dword ptr [ebp + arg_14]            # 004c52e4
    mov ecx, dword ptr [ecx]                     # 004c52e7
    imul ecx, eax                                # 004c52e9
    {load} add edx, ecx                          # 004c52ec
    mov dword ptr [ebp - local_c], edx           # 004c52ee
    mov edx, dword ptr [ebp + arg_10]            # 004c52f1
    mov eax, dword ptr [ebp + arg_10]            # 004c52f4
    mov ecx, dword ptr [edx + field_c]           # 004c52f7
    sub ecx, dword ptr [eax + field_4]           # 004c52fa
    add ecx, 0x1                                 # 004c52fd
    mov dword ptr [ebp - local_10], ecx          # 004c5300
    mov edx, dword ptr [ebp + arg_10]            # 004c5303
    mov eax, dword ptr [ebp + arg_10]            # 004c5306
    mov ecx, dword ptr [edx + field_8]           # 004c5309
    sub ecx, dword ptr [eax]                     # 004c530c
    add ecx, 0x1                                 # 004c530e
    movsx edx, word ptr [0x639895]               # 004c5311
    imul ecx, edx                                # 004c5318
    mov dword ptr [ebp - local_8], ecx           # 004c531b
    mov dword ptr [ebp - local_14], 0x0          # 004c531e
    jmp.d8 L_004c5330                            # 004c5325
L_004c5327:
    # block 0x004c5327: entered by jmp at 0x004c536d, 3 instruction(s), falls into the block at 0x004c5330
    mov eax, dword ptr [ebp - local_14]          # 004c5327
    add eax, 0x1                                 # 004c532a
    mov dword ptr [ebp - local_14], eax          # 004c532d
L_004c5330:
    # block 0x004c5330: entered by jmp at 0x004c5325, 3 instruction(s), ends with jge to 0x004c536f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004c5330
    cmp ecx, dword ptr [ebp - local_10]          # 004c5333
    jge.d8 L_004c536f                            # 004c5336
    # block 0x004c5338: entered by fall-through of jge at 0x004c5336, 20 instruction(s), ends with backward jump to 0x004c5327
    mov ecx, dword ptr [ebp - local_8]           # 004c5338
    mov esi, dword ptr [ebp - local_4]           # 004c533b
    mov edi, dword ptr [ebp - local_c]           # 004c533e
    {load} mov edx, ecx                          # 004c5341
    shr ecx, 0x2                                 # 004c5343
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c5346
    {load} mov ecx, edx                          # 004c5348
    and ecx, 0x3                                 # 004c534a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c534d
    mov eax, dword ptr [ebp + arg_8]             # 004c534f
    movsx ecx, word ptr [eax + field_2f]         # 004c5352
    mov edx, dword ptr [ebp - local_4]           # 004c5356
    {load} add edx, ecx                          # 004c5359
    mov dword ptr [ebp - local_4], edx           # 004c535b
    mov eax, dword ptr [ebp + arg_c]             # 004c535e
    movsx ecx, word ptr [eax + field_2f]         # 004c5361
    mov edx, dword ptr [ebp - local_c]           # 004c5365
    {load} add edx, ecx                          # 004c5368
    mov dword ptr [ebp - local_c], edx           # 004c536a
    jmp.d8 L_004c5327                            # 004c536d
L_004c536f:
    # block 0x004c536f: entered by jmp at 0x004c5296; jge at 0x004c5336, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c536f
    pop esi                                      # 004c5370
    {load} mov esp, ebp                          # 004c5371
    pop ebp                                      # 004c5373
    ret 0x14                                     # 004c5374

