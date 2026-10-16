# FUN_00514f8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514f8e
# extent:       0x00514f8e-0x005152b9 (811 code bytes)
# span:         0x00514f8e-0x005152b9 (code 811, tables 0, padding 0)
# sha256:       7294a9f8ac89e576825cac5763b41f65209d0d8506a866a4c4cc1411faaa1e80
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514f8e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_f; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_43, field_44, field_c4; [ebx + n] field_4, field_8, field_minus_4; [ecx + n] field_4, field_8, field_c, field_10, field_43, field_144, field_minus_14; [edi + n] field_4, field_minus_20; [edx + n] field_4, field_8, field_minus_4
# callees:      calls KERNEL32.dll!HeapFree, FUN_0050ed50; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 264 instruction(s), 26 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_20, 0x20  # offset -0x20
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_f, 0xf  # offset +0xf
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_43, 0x43  # offset +0x43
.equ field_44, 0x44  # offset +0x44
.equ field_c4, 0xc4  # offset +0xc4
.equ field_144, 0x144  # offset +0x144

# --- external targets -----------------------------------------------
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)

.org 0x00514f8e - 0x401000
.globl FUN_00514f8e
FUN_00514f8e:
    # block 0x00514f8e: entry, 26 instruction(s), ends with jne to 0x00515054 (forward)
    push ebp                                     # 00514f8e
    {load} mov ebp, esp                          # 00514f8f
    sub esp, 0x14                                # 00514f91
    mov edx, dword ptr [ebp + arg_c]             # 00514f94
    mov ecx, dword ptr [ebp + arg_8]             # 00514f97
    push ebx                                     # 00514f9a
    push esi                                     # 00514f9b
    mov eax, dword ptr [ecx + field_10]          # 00514f9c
    {load} mov esi, edx                          # 00514f9f
    sub esi, dword ptr [ecx + field_c]           # 00514fa1
    mov ebx, dword ptr [edx - field_minus_4]     # 00514fa4
    add edx, -0x4                                # 00514fa7
    push edi                                     # 00514faa
    shr esi, 0xf                                 # 00514fab
    {load} mov ecx, esi                          # 00514fae
    mov edi, dword ptr [edx - field_minus_4]     # 00514fb0
    imul ecx, ecx, 0x204                         # 00514fb3
    dec ebx                                      # 00514fb9
    mov dword ptr [ebp - local_4], edi           # 00514fba
    lea ecx, [ecx + eax + field_144]             # 00514fbd
    mov dword ptr [ebp - local_c], ebx           # 00514fc4
    mov dword ptr [ebp - local_10], ecx          # 00514fc7
    mov ecx, dword ptr [ebx + edx]               # 00514fca
    test cl, 0x1                                 # 00514fcd
    mov dword ptr [ebp - local_8], ecx           # 00514fd0
    jne.d8 L_00515054                            # 00514fd3
    # block 0x00514fd5: entered by fall-through of jne at 0x00514fd3, 7 instruction(s), ends with jbe to 0x00514fe6 (forward)
    sar ecx, 0x4                                 # 00514fd5
    push 0x3f                                    # 00514fd8
    dec ecx                                      # 00514fda
    pop edi                                      # 00514fdb
    mov dword ptr [ebp + arg_c], ecx             # 00514fdc
    {load} cmp ecx, edi                          # 00514fdf
    jbe.d8 L_00514fe6                            # 00514fe1
    # block 0x00514fe3: entered by fall-through of jbe at 0x00514fe1, 1 instruction(s), falls into the block at 0x00514fe6
    mov dword ptr [ebp + arg_c], edi             # 00514fe3
L_00514fe6:
    # block 0x00514fe6: entered by jbe at 0x00514fe1, 3 instruction(s), ends with jne to 0x00515038 (forward)
    mov ecx, dword ptr [ebx + edx + field_4]     # 00514fe6
    cmp ecx, dword ptr [ebx + edx + field_8]     # 00514fea
    jne.d8 L_00515038                            # 00514fee
    # block 0x00514ff0: entered by fall-through of jne at 0x00514fee, 3 instruction(s), ends with jae to 0x00515014 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00514ff0
    cmp ecx, 0x20                                # 00514ff3
    jae.d8 L_00515014                            # 00514ff6
    # block 0x00514ff8: entered by fall-through of jae at 0x00514ff6, 7 instruction(s), ends with jne to 0x00515038 (forward)
    mov edi, 0x80000000                          # 00514ff8
    shr edi, cl                                  # 00514ffd
    lea ecx, [ecx + eax + field_4]               # 00514fff
    not edi                                      # 00515003
    and dword ptr [eax + 4*esi + field_44], edi  # 00515005
    dec byte ptr [ecx]                           # 00515009
    jne.d8 L_00515038                            # 0051500b
    # block 0x0051500d: entered by fall-through of jne at 0x0051500b, 3 instruction(s), ends with forward jump to 0x00515038
    mov ecx, dword ptr [ebp + arg_8]             # 0051500d
    and dword ptr [ecx], edi                     # 00515010
    jmp.d8 L_00515038                            # 00515012
L_00515014:
    # block 0x00515014: entered by jae at 0x00514ff6, 9 instruction(s), ends with jne to 0x00515038 (forward)
    add ecx, -0x20                               # 00515014
    mov edi, 0x80000000                          # 00515017
    shr edi, cl                                  # 0051501c
    mov ecx, dword ptr [ebp + arg_c]             # 0051501e
    lea ecx, [ecx + eax + field_4]               # 00515021
    not edi                                      # 00515025
    and dword ptr [eax + 4*esi + field_c4], edi  # 00515027
    dec byte ptr [ecx]                           # 0051502e
    jne.d8 L_00515038                            # 00515030
    # block 0x00515032: entered by fall-through of jne at 0x00515030, 2 instruction(s), falls into the block at 0x00515038
    mov ecx, dword ptr [ebp + arg_8]             # 00515032
    and dword ptr [ecx + field_4], edi           # 00515035
L_00515038:
    # block 0x00515038: entered by jne at 0x00514fee; jne at 0x0051500b; jmp at 0x00515012; jne at 0x00515030, 8 instruction(s), falls into the block at 0x00515054
    mov ecx, dword ptr [ebx + edx + field_8]     # 00515038
    mov edi, dword ptr [ebx + edx + field_4]     # 0051503c
    mov dword ptr [ecx + field_4], edi           # 00515040
    mov ecx, dword ptr [ebx + edx + field_4]     # 00515043
    mov edi, dword ptr [ebx + edx + field_8]     # 00515047
    add ebx, dword ptr [ebp - local_8]           # 0051504b
    mov dword ptr [ecx + field_8], edi           # 0051504e
    mov dword ptr [ebp - local_c], ebx           # 00515051
L_00515054:
    # block 0x00515054: entered by jne at 0x00514fd3, 5 instruction(s), ends with jbe to 0x00515062 (forward)
    {load} mov edi, ebx                          # 00515054
    sar edi, 0x4                                 # 00515056
    dec edi                                      # 00515059
    cmp edi, 0x3f                                # 0051505a
    jbe.d8 L_00515062                            # 0051505d
    # block 0x0051505f: entered by fall-through of jbe at 0x0051505d, 2 instruction(s), falls into the block at 0x00515062
    push 0x3f                                    # 0051505f
    pop edi                                      # 00515061
L_00515062:
    # block 0x00515062: entered by jbe at 0x0051505d, 4 instruction(s), ends with jne to 0x00515111 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00515062
    and ecx, 0x1                                 # 00515065
    mov dword ptr [ebp - local_14], ecx          # 00515068
    jne.d32 L_00515111                           # 0051506b
    # block 0x00515071: entered by fall-through of jne at 0x0051506b, 10 instruction(s), ends with jbe to 0x0051508d (forward)
    sub edx, dword ptr [ebp - local_4]           # 00515071
    mov ecx, dword ptr [ebp - local_4]           # 00515074
    sar ecx, 0x4                                 # 00515077
    push 0x3f                                    # 0051507a
    mov dword ptr [ebp - local_8], edx           # 0051507c
    dec ecx                                      # 0051507f
    pop edx                                      # 00515080
    {load} cmp ecx, edx                          # 00515081
    mov dword ptr [ebp + arg_c], ecx             # 00515083
    jbe.d8 L_0051508d                            # 00515086
    # block 0x00515088: entered by fall-through of jbe at 0x00515086, 2 instruction(s), falls into the block at 0x0051508d
    mov dword ptr [ebp + arg_c], edx             # 00515088
    {load} mov ecx, edx                          # 0051508b
L_0051508d:
    # block 0x0051508d: entered by jbe at 0x00515086, 7 instruction(s), ends with jbe to 0x0051509f (forward)
    add ebx, dword ptr [ebp - local_4]           # 0051508d
    {load} mov edi, ebx                          # 00515090
    mov dword ptr [ebp - local_c], ebx           # 00515092
    sar edi, 0x4                                 # 00515095
    dec edi                                      # 00515098
    {load} cmp edi, edx                          # 00515099
    jbe.d8 L_0051509f                            # 0051509b
    # block 0x0051509d: entered by fall-through of jbe at 0x0051509b, 1 instruction(s), falls into the block at 0x0051509f
    {load} mov edi, edx                          # 0051509d
L_0051509f:
    # block 0x0051509f: entered by jbe at 0x0051509b, 2 instruction(s), ends with je to 0x0051510e (forward)
    {load} cmp ecx, edi                          # 0051509f
    je.d8 L_0051510e                             # 005150a1
    # block 0x005150a3: entered by fall-through of je at 0x005150a1, 4 instruction(s), ends with jne to 0x005150f6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 005150a3
    mov edx, dword ptr [ecx + field_4]           # 005150a6
    cmp edx, dword ptr [ecx + field_8]           # 005150a9
    jne.d8 L_005150f6                            # 005150ac
    # block 0x005150ae: entered by fall-through of jne at 0x005150ac, 3 instruction(s), ends with jae to 0x005150d2 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 005150ae
    cmp ecx, 0x20                                # 005150b1
    jae.d8 L_005150d2                            # 005150b4
    # block 0x005150b6: entered by fall-through of jae at 0x005150b4, 7 instruction(s), ends with jne to 0x005150f6 (forward)
    mov edx, 0x80000000                          # 005150b6
    shr edx, cl                                  # 005150bb
    lea ecx, [ecx + eax + field_4]               # 005150bd
    not edx                                      # 005150c1
    and dword ptr [eax + 4*esi + field_44], edx  # 005150c3
    dec byte ptr [ecx]                           # 005150c7
    jne.d8 L_005150f6                            # 005150c9
    # block 0x005150cb: entered by fall-through of jne at 0x005150c9, 3 instruction(s), ends with forward jump to 0x005150f6
    mov ecx, dword ptr [ebp + arg_8]             # 005150cb
    and dword ptr [ecx], edx                     # 005150ce
    jmp.d8 L_005150f6                            # 005150d0
L_005150d2:
    # block 0x005150d2: entered by jae at 0x005150b4, 9 instruction(s), ends with jne to 0x005150f6 (forward)
    add ecx, -0x20                               # 005150d2
    mov edx, 0x80000000                          # 005150d5
    shr edx, cl                                  # 005150da
    mov ecx, dword ptr [ebp + arg_c]             # 005150dc
    lea ecx, [ecx + eax + field_4]               # 005150df
    not edx                                      # 005150e3
    and dword ptr [eax + 4*esi + field_c4], edx  # 005150e5
    dec byte ptr [ecx]                           # 005150ec
    jne.d8 L_005150f6                            # 005150ee
    # block 0x005150f0: entered by fall-through of jne at 0x005150ee, 2 instruction(s), falls into the block at 0x005150f6
    mov ecx, dword ptr [ebp + arg_8]             # 005150f0
    and dword ptr [ecx + field_4], edx           # 005150f3
L_005150f6:
    # block 0x005150f6: entered by jne at 0x005150ac; jne at 0x005150c9; jmp at 0x005150d0; jne at 0x005150ee, 8 instruction(s), falls into the block at 0x0051510e
    mov ecx, dword ptr [ebp - local_8]           # 005150f6
    mov edx, dword ptr [ecx + field_8]           # 005150f9
    mov ecx, dword ptr [ecx + field_4]           # 005150fc
    mov dword ptr [edx + field_4], ecx           # 005150ff
    mov ecx, dword ptr [ebp - local_8]           # 00515102
    mov edx, dword ptr [ecx + field_4]           # 00515105
    mov ecx, dword ptr [ecx + field_8]           # 00515108
    mov dword ptr [edx + field_8], ecx           # 0051510b
L_0051510e:
    # block 0x0051510e: entered by je at 0x005150a1, 1 instruction(s), falls into the block at 0x00515111
    mov edx, dword ptr [ebp - local_8]           # 0051510e
L_00515111:
    # block 0x00515111: entered by jne at 0x0051506b, 2 instruction(s), ends with jne to 0x00515120 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 00515111
    jne.d8 L_00515120                            # 00515115
    # block 0x00515117: entered by fall-through of jne at 0x00515115, 2 instruction(s), ends with je to 0x005151a9 (forward)
    cmp dword ptr [ebp + arg_c], edi             # 00515117
    je.d32 L_005151a9                            # 0051511a
L_00515120:
    # block 0x00515120: entered by jne at 0x00515115; fall-through of je at 0x0051511a, 13 instruction(s), ends with jne to 0x005151a9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00515120
    lea ecx, [ecx + 8*edi]                       # 00515123
    mov ecx, dword ptr [ecx + field_4]           # 00515126
    mov dword ptr [edx + field_4], ecx           # 00515129
    mov ecx, dword ptr [ebp - local_10]          # 0051512c
    lea ecx, [ecx + 8*edi]                       # 0051512f
    mov dword ptr [edx + field_8], ecx           # 00515132
    mov dword ptr [ecx + field_4], edx           # 00515135
    mov ecx, dword ptr [edx + field_4]           # 00515138
    mov dword ptr [ecx + field_8], edx           # 0051513b
    mov ecx, dword ptr [edx + field_4]           # 0051513e
    cmp ecx, dword ptr [edx + field_8]           # 00515141
    jne.d8 L_005151a9                            # 00515144
    # block 0x00515146: entered by fall-through of jne at 0x00515144, 6 instruction(s), ends with jae to 0x0051517d (forward)
    mov cl, byte ptr [edi + eax + field_4]       # 00515146
    cmp edi, 0x20                                # 0051514a
    mov byte ptr [ebp + arg_f], cl               # 0051514d
    inc cl                                       # 00515150
    mov byte ptr [edi + eax + field_4], cl       # 00515152
    jae.d8 L_0051517d                            # 00515156
    # block 0x00515158: entered by fall-through of jae at 0x00515156, 2 instruction(s), ends with jne to 0x0051516c (forward)
    cmp byte ptr [ebp + arg_f], 0x0              # 00515158
    jne.d8 L_0051516c                            # 0051515c
    # block 0x0051515e: entered by fall-through of jne at 0x0051515c, 5 instruction(s), falls into the block at 0x0051516c
    mov ebx, 0x80000000                          # 0051515e
    {load} mov ecx, edi                          # 00515163
    shr ebx, cl                                  # 00515165
    mov ecx, dword ptr [ebp + arg_8]             # 00515167
    or dword ptr [ecx], ebx                      # 0051516a
L_0051516c:
    # block 0x0051516c: entered by jne at 0x0051515c, 6 instruction(s), ends with forward jump to 0x005151a6
    mov ebx, 0x80000000                          # 0051516c
    {load} mov ecx, edi                          # 00515171
    shr ebx, cl                                  # 00515173
    lea eax, [eax + 4*esi + field_44]            # 00515175
    or dword ptr [eax], ebx                      # 00515179
    jmp.d8 L_005151a6                            # 0051517b
L_0051517d:
    # block 0x0051517d: entered by jae at 0x00515156, 2 instruction(s), ends with jne to 0x00515193 (forward)
    cmp byte ptr [ebp + arg_f], 0x0              # 0051517d
    jne.d8 L_00515193                            # 00515181
    # block 0x00515183: entered by fall-through of jne at 0x00515181, 5 instruction(s), falls into the block at 0x00515193
    lea ecx, [edi - field_minus_20]              # 00515183
    mov ebx, 0x80000000                          # 00515186
    shr ebx, cl                                  # 0051518b
    mov ecx, dword ptr [ebp + arg_8]             # 0051518d
    or dword ptr [ecx + field_4], ebx            # 00515190
L_00515193:
    # block 0x00515193: entered by jne at 0x00515181, 5 instruction(s), falls into the block at 0x005151a6
    lea ecx, [edi - field_minus_20]              # 00515193
    mov edi, 0x80000000                          # 00515196
    shr edi, cl                                  # 0051519b
    lea eax, [eax + 4*esi + field_c4]            # 0051519d
    or dword ptr [eax], edi                      # 005151a4
L_005151a6:
    # block 0x005151a6: entered by jmp at 0x0051517b, 1 instruction(s), falls into the block at 0x005151a9
    mov ebx, dword ptr [ebp - local_c]           # 005151a6
L_005151a9:
    # block 0x005151a9: entered by je at 0x0051511a; jne at 0x00515144, 5 instruction(s), ends with jne to 0x005152b4 (forward)
    mov eax, dword ptr [ebp - local_10]          # 005151a9
    mov dword ptr [edx], ebx                     # 005151ac
    mov dword ptr [ebx + edx - field_minus_4], ebx # 005151ae
    dec dword ptr [eax]                          # 005151b2
    jne.d32 L_005152b4                           # 005151b4
    # block 0x005151ba: entered by fall-through of jne at 0x005151b4, 3 instruction(s), ends with je to 0x005152a6 (forward)
    mov eax, dword ptr [0x63cdcc]                # 005151ba
    test eax, eax                                # 005151bf
    je.d32 L_005152a6                            # 005151c1
    # block 0x005151c7: entered by fall-through of je at 0x005151c1, 25 instruction(s), calls indirect edi, ends with jne to 0x00515234 (forward)
    mov ecx, dword ptr [0x63cdc4]                # 005151c7
    mov edi, dword ptr [0x52a19c]                # 005151cd
    shl ecx, 0xf                                 # 005151d3
    add ecx, dword ptr [eax + field_c]           # 005151d6
    mov ebx, 0x8000                              # 005151d9
    push 0x4000                                  # 005151de
    push ebx                                     # 005151e3
    push ecx                                     # 005151e4
    call edi                                     # 005151e5
    mov ecx, dword ptr [0x63cdc4]                # 005151e7
    mov eax, dword ptr [0x63cdcc]                # 005151ed
    mov edx, 0x80000000                          # 005151f2
    shr edx, cl                                  # 005151f7
    or dword ptr [eax + field_8], edx            # 005151f9
    mov eax, dword ptr [0x63cdcc]                # 005151fc
    mov ecx, dword ptr [0x63cdc4]                # 00515201
    mov eax, dword ptr [eax + field_10]          # 00515207
    and dword ptr [eax + 4*ecx + field_c4], 0x0  # 0051520a
    mov eax, dword ptr [0x63cdcc]                # 00515212
    mov eax, dword ptr [eax + field_10]          # 00515217
    dec byte ptr [eax + field_43]                # 0051521a
    mov eax, dword ptr [0x63cdcc]                # 0051521d
    mov ecx, dword ptr [eax + field_10]          # 00515222
    cmp byte ptr [ecx + field_43], 0x0           # 00515225
    jne.d8 L_00515234                            # 00515229
    # block 0x0051522b: entered by fall-through of jne at 0x00515229, 2 instruction(s), falls into the block at 0x00515234
    and dword ptr [eax + field_4], -0x2          # 0051522b
    mov eax, dword ptr [0x63cdcc]                # 0051522f
L_00515234:
    # block 0x00515234: entered by jne at 0x00515229, 2 instruction(s), ends with jne to 0x005152a6 (forward)
    cmp dword ptr [eax + field_8], -0x1          # 00515234
    jne.d8 L_005152a6                            # 00515238
    # block 0x0051523a: entered by fall-through of jne at 0x00515238, 27 instruction(s), calls indirect edi, KERNEL32.dll!HeapFree, FUN_0050ed50, ends with jbe to 0x00515298 (forward)
    push ebx                                     # 0051523a
    push 0x0                                     # 0051523b
    push dword ptr [eax + field_c]               # 0051523d
    call edi                                     # 00515240
    mov eax, dword ptr [0x63cdcc]                # 00515242
    push dword ptr [eax + field_10]              # 00515247
    push 0x0                                     # 0051524a
    push dword ptr [0x63cdd8]                    # 0051524c
    call dword ptr [0x52a14c]                    # 00515252
    mov eax, dword ptr [0x63cdd0]                # 00515258
    mov edx, dword ptr [0x63cdd4]                # 0051525d
    lea eax, [eax + 4*eax]                       # 00515263
    shl eax, 0x2                                 # 00515266
    {load} mov ecx, eax                          # 00515269
    mov eax, dword ptr [0x63cdcc]                # 0051526b
    {load} sub ecx, eax                          # 00515270
    lea ecx, [ecx + edx - field_minus_14]        # 00515272
    push ecx                                     # 00515276
    lea ecx, [eax + field_14]                    # 00515277
    push ecx                                     # 0051527a
    push eax                                     # 0051527b
    call FUN_0050ed50                            # 0051527c
    mov eax, dword ptr [ebp + arg_8]             # 00515281
    add esp, 0xc                                 # 00515284
    dec dword ptr [0x63cdd0]                     # 00515287
    cmp eax, dword ptr [0x63cdcc]                # 0051528d
    jbe.d8 L_00515298                            # 00515293
    # block 0x00515295: entered by fall-through of jbe at 0x00515293, 1 instruction(s), falls into the block at 0x00515298
    sub eax, 0x14                                # 00515295
L_00515298:
    # block 0x00515298: entered by jbe at 0x00515293, 3 instruction(s), ends with forward jump to 0x005152a9
    mov ecx, dword ptr [0x63cdd4]                # 00515298
    mov dword ptr [0x63cdc8], ecx                # 0051529e
    jmp.d8 L_005152a9                            # 005152a4
L_005152a6:
    # block 0x005152a6: entered by je at 0x005151c1; jne at 0x00515238, 1 instruction(s), falls into the block at 0x005152a9
    mov eax, dword ptr [ebp + arg_8]             # 005152a6
L_005152a9:
    # block 0x005152a9: entered by jmp at 0x005152a4, 2 instruction(s), falls into the block at 0x005152b4
    mov dword ptr [0x63cdcc], eax                # 005152a9
    mov dword ptr [0x63cdc4], esi                # 005152ae
L_005152b4:
    # block 0x005152b4: entered by jne at 0x005151b4, 5 instruction(s), ends with ret
    pop edi                                      # 005152b4
    pop esi                                      # 005152b5
    pop ebx                                      # 005152b6
    leave                                        # 005152b7
    ret                                          # 005152b8

