# FUN_0048905b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048905b
# extent:       0x0048905b-0x0048945b (1024 code bytes)
# span:         0x0048905b-0x0048945b (code 1024, tables 0, padding 0)
# sha256:       dec6ed30bb68f52ce12da80e7bbcc975b623c34f9481db1705dccfedaf4662b8
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_overlay_38_constructor
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_bindings_a36.h:47 says "the A-38.1 constructor (0x48905b) for raw 0x38"
# name-note:    A-38.1 constructor for raw 0x38 overlay rows.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_20, field_21, field_23, field_27, field_29, field_2d, field_33, field_35 and 4 more; [ecx + n] field_1c, field_20, field_23, field_25, field_29, field_2f, field_33, field_35, field_39, field_43, field_4d, field_51 and 4 more; [edx + n] field_4, field_8, field_c, field_1c, field_20, field_21, field_25, field_27, field_2b, field_31, field_35, field_37 and 9 more
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 306 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_37, 0x37  # offset +0x37
.equ field_39, 0x39  # offset +0x39
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3d, 0x3d  # offset +0x3d
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_aa, 0xaa  # offset +0xaa
.equ field_6ec, 0x6ec  # offset +0x6ec
.equ field_6ee, 0x6ee  # offset +0x6ee
.equ field_6f0, 0x6f0  # offset +0x6f0
.equ field_6f2, 0x6f2  # offset +0x6f2
.equ field_6f6, 0x6f6  # offset +0x6f6
.equ field_6fa, 0x6fa  # offset +0x6fa
.equ field_6fe, 0x6fe  # offset +0x6fe
.equ field_702, 0x702  # offset +0x702

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048905b - 0x401000
.globl FUN_0048905b
FUN_0048905b:
    # block 0x0048905b: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004890c2 (forward)
    push ebp                                     # 0048905b
    {load} mov ebp, esp                          # 0048905c
    sub esp, 0x14                                # 0048905e
    push esi                                     # 00489061
    push edi                                     # 00489062
    mov dword ptr [ebp - local_14], ecx          # 00489063
    push 0xaba                                   # 00489066
    call FUN_0051dc43                            # 0048906b
    add esp, 0x4                                 # 00489070
    mov dword ptr [ebp - local_10], eax          # 00489073
    mov eax, dword ptr [ebp + arg_8]             # 00489076
    mov ecx, dword ptr [ebp - local_10]          # 00489079
    mov dword ptr [eax], ecx                     # 0048907c
    cmp dword ptr [ebp - local_10], 0x0          # 0048907e
    jne.d8 L_004890c2                            # 00489082
    # block 0x00489084: entered by fall-through of jne at 0x00489082, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004890c2
    movsx edx, word ptr [0x5c39e3]               # 00489084
    push edx                                     # 0048908b
    mov eax, dword ptr [0x5bb57b]                # 0048908c
    push eax                                     # 00489091
    push 0x54dfcc                                # 00489092
    push 0x63888b                                # 00489097
    call FUN_0050ca3e                            # 0048909c
    add esp, 0x10                                # 004890a1
    push 0x63888b                                # 004890a4
    push 0x54dff8                                # 004890a9
    mov ecx, 0x583979                            # 004890ae
    call FUN_0042639d                            # 004890b3
    mov ecx, 0x5cf659                            # 004890b8
    call FUN_004c97b4                            # 004890bd
L_004890c2:
    # block 0x004890c2: entered by jne at 0x00489082, 37 instruction(s), ends with forward jump to 0x00489149
    mov ecx, 0x2b                                # 004890c2
    {load} xor eax, eax                          # 004890c7
    mov edx, dword ptr [ebp + arg_8]             # 004890c9
    mov edi, dword ptr [edx]                     # 004890cc
    rep stosd dword ptr es:[edi], eax            # 004890ce
    mov eax, dword ptr [ebp + arg_c]             # 004890d0
    mov ecx, dword ptr [eax]                     # 004890d3
    mov dword ptr [ebp - local_c], ecx           # 004890d5
    mov edx, dword ptr [ebp - local_14]          # 004890d8
    mov eax, dword ptr [ebp + arg_8]             # 004890db
    mov ecx, dword ptr [eax]                     # 004890de
    mov dword ptr [edx + field_1c], ecx          # 004890e0
    mov edx, dword ptr [ebp - local_14]          # 004890e3
    mov eax, dword ptr [ebp - local_14]          # 004890e6
    mov ecx, dword ptr [eax + field_1c]          # 004890e9
    mov dword ptr [edx + field_20], ecx          # 004890ec
    mov edx, dword ptr [ebp - local_14]          # 004890ef
    mov eax, dword ptr [edx + field_20]          # 004890f2
    mov word ptr [eax + field_29], 0x2           # 004890f5
    mov ecx, dword ptr [ebp - local_14]          # 004890fb
    mov edx, dword ptr [ecx + field_20]          # 004890fe
    mov word ptr [edx + field_37], 0xf           # 00489101
    mov eax, dword ptr [ebp - local_14]          # 00489107
    mov ecx, dword ptr [eax + field_20]          # 0048910a
    mov word ptr [ecx + field_39], 0xffff        # 0048910d
    mov edx, dword ptr [ebp - local_14]          # 00489113
    mov eax, dword ptr [edx + field_20]          # 00489116
    mov ecx, dword ptr [ebp - local_c]           # 00489119
    mov dx, word ptr [ecx + field_2f]            # 0048911c
    mov word ptr [eax + field_51], dx            # 00489120
    mov eax, dword ptr [ebp - local_14]          # 00489124
    mov ecx, dword ptr [eax + field_20]          # 00489127
    mov edx, dword ptr [ebp - local_c]           # 0048912a
    mov ax, word ptr [edx + field_31]            # 0048912d
    mov word ptr [ecx + field_53], ax            # 00489131
    mov word ptr [ebp - local_4], 0x1            # 00489135
    jmp.d8 L_00489149                            # 0048913b
L_0048913d:
    # block 0x0048913d: entered by jmp at 0x00489163, 3 instruction(s), falls into the block at 0x00489149
    mov cx, word ptr [ebp - local_4]             # 0048913d
    add cx, 0x1                                  # 00489141
    mov word ptr [ebp - local_4], cx             # 00489145
L_00489149:
    # block 0x00489149: entered by jmp at 0x0048913b, 3 instruction(s), ends with jge to 0x00489165 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00489149
    cmp edx, 0xa                                 # 0048914d
    jge.d8 L_00489165                            # 00489150
    # block 0x00489152: entered by fall-through of jge at 0x00489150, 5 instruction(s), ends with backward jump to 0x0048913d
    mov eax, dword ptr [ebp - local_14]          # 00489152
    mov ecx, dword ptr [eax + field_20]          # 00489155
    movsx edx, word ptr [ebp - local_4]          # 00489158
    mov word ptr [ecx + 4*edx + field_51], 0xffff # 0048915c
    jmp.d8 L_0048913d                            # 00489163
L_00489165:
    # block 0x00489165: entered by jge at 0x00489150, 90 instruction(s), ends with forward jump to 0x0048928d
    mov edi, 0x54e014                            # 00489165
    mov eax, dword ptr [ebp - local_14]          # 0048916a
    mov ecx, dword ptr [eax + field_20]          # 0048916d
    add ecx, 0x79                                # 00489170
    {load} mov edx, ecx                          # 00489173
    or ecx, -0x1                                 # 00489175
    {load} xor eax, eax                          # 00489178
    repne scasb al, byte ptr es:[edi]            # 0048917a
    not ecx                                      # 0048917c
    {load} sub edi, ecx                          # 0048917e
    {load} mov esi, edi                          # 00489180
    {load} mov eax, ecx                          # 00489182
    {load} mov edi, edx                          # 00489184
    shr ecx, 0x2                                 # 00489186
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489189
    {load} mov ecx, eax                          # 0048918b
    and ecx, 0x3                                 # 0048918d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00489190
    mov ecx, dword ptr [ebp - local_14]          # 00489192
    mov edx, dword ptr [ecx + field_20]          # 00489195
    mov word ptr [edx + field_43], 0x1           # 00489198
    mov eax, dword ptr [ebp - local_14]          # 0048919e
    mov ecx, dword ptr [eax + field_20]          # 004891a1
    mov dword ptr [ecx + field_4d], 0x1          # 004891a4
    mov edi, dword ptr [ebp - local_c]           # 004891ab
    mov edx, dword ptr [ebp - local_14]          # 004891ae
    mov edx, dword ptr [edx + field_20]          # 004891b1
    or ecx, -0x1                                 # 004891b4
    {load} xor eax, eax                          # 004891b7
    repne scasb al, byte ptr es:[edi]            # 004891b9
    not ecx                                      # 004891bb
    {load} sub edi, ecx                          # 004891bd
    {load} mov esi, edi                          # 004891bf
    {load} mov eax, ecx                          # 004891c1
    {load} mov edi, edx                          # 004891c3
    shr ecx, 0x2                                 # 004891c5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004891c8
    {load} mov ecx, eax                          # 004891ca
    and ecx, 0x3                                 # 004891cc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004891cf
    mov ecx, dword ptr [ebp - local_14]          # 004891d1
    mov edx, dword ptr [ecx + field_20]          # 004891d4
    mov eax, dword ptr [ebp - local_c]           # 004891d7
    mov cx, word ptr [eax + field_21]            # 004891da
    mov word ptr [edx + field_21], cx            # 004891de
    mov edx, dword ptr [ebp - local_14]          # 004891e2
    mov eax, dword ptr [edx + field_20]          # 004891e5
    mov ecx, dword ptr [ebp - local_c]           # 004891e8
    mov dx, word ptr [ecx + field_23]            # 004891eb
    mov word ptr [eax + field_23], dx            # 004891ef
    mov eax, dword ptr [ebp - local_14]          # 004891f3
    mov ecx, dword ptr [eax + field_20]          # 004891f6
    mov edx, dword ptr [ebp - local_c]           # 004891f9
    mov ax, word ptr [edx + field_25]            # 004891fc
    mov word ptr [ecx + field_25], ax            # 00489200
    mov ecx, dword ptr [ebp - local_14]          # 00489204
    mov edx, dword ptr [ecx + field_20]          # 00489207
    mov eax, dword ptr [ebp - local_c]           # 0048920a
    mov cx, word ptr [eax + field_27]            # 0048920d
    mov word ptr [edx + field_27], cx            # 00489211
    mov edx, dword ptr [ebp - local_14]          # 00489215
    mov eax, dword ptr [edx + field_20]          # 00489218
    mov ecx, dword ptr [ebp - local_c]           # 0048921b
    mov dx, word ptr [ecx + field_29]            # 0048921e
    mov word ptr [eax + field_2d], dx            # 00489222
    mov eax, dword ptr [ebp - local_14]          # 00489226
    mov ecx, dword ptr [eax + field_20]          # 00489229
    mov edx, dword ptr [ebp - local_c]           # 0048922c
    mov ax, word ptr [edx + field_2b]            # 0048922f
    mov word ptr [ecx + field_2f], ax            # 00489233
    mov ecx, dword ptr [ebp - local_14]          # 00489237
    mov edx, dword ptr [ecx + field_20]          # 0048923a
    mov eax, dword ptr [ebp - local_c]           # 0048923d
    mov cx, word ptr [eax + field_2d]            # 00489240
    mov word ptr [edx + field_3d], cx            # 00489244
    mov edx, dword ptr [ebp - local_14]          # 00489248
    mov eax, dword ptr [edx + field_20]          # 0048924b
    mov ecx, dword ptr [ebp - local_c]           # 0048924e
    mov dx, word ptr [ecx + field_33]            # 00489251
    mov word ptr [eax + field_33], dx            # 00489255
    mov eax, dword ptr [ebp - local_14]          # 00489259
    mov ecx, dword ptr [eax + field_20]          # 0048925c
    mov edx, dword ptr [ebp - local_c]           # 0048925f
    mov ax, word ptr [edx + field_35]            # 00489262
    mov word ptr [ecx + field_35], ax            # 00489266
    mov ecx, dword ptr [ebp - local_14]          # 0048926a
    mov edx, dword ptr [ecx + field_20]          # 0048926d
    mov word ptr [edx + field_aa], 0x1           # 00489270
    mov word ptr [ebp - local_4], 0x0            # 00489279
    jmp.d8 L_0048928d                            # 0048927f
L_00489281:
    # block 0x00489281: entered by jmp at 0x0048938b, 3 instruction(s), falls into the block at 0x0048928d
    mov ax, word ptr [ebp - local_4]             # 00489281
    .insn 0x66, 0x05, 0x0001{:u16}               # 00489285
    mov word ptr [ebp - local_4], ax             # 00489289
L_0048928d:
    # block 0x0048928d: entered by jmp at 0x0048927f, 6 instruction(s), ends with jge to 0x00489390 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048928d
    mov edx, dword ptr [ebp - local_14]          # 00489291
    mov eax, dword ptr [edx + field_20]          # 00489294
    movsx edx, word ptr [eax + field_aa]         # 00489297
    {load} cmp ecx, edx                          # 0048929e
    jge.d32 L_00489390                           # 004892a0
    # block 0x004892a6: entered by fall-through of jge at 0x004892a0, 59 instruction(s), ends with backward jump to 0x00489281
    mov eax, dword ptr [ebp - local_14]          # 004892a6
    mov ecx, dword ptr [eax + field_1c]          # 004892a9
    movsx edx, word ptr [ebp - local_4]          # 004892ac
    imul edx, edx, 0x26                          # 004892b0
    mov word ptr [ecx + edx + field_6ec], 0x0    # 004892b3
    mov eax, dword ptr [ebp - local_14]          # 004892bd
    mov ecx, dword ptr [eax + field_1c]          # 004892c0
    movsx edx, word ptr [ebp - local_4]          # 004892c3
    imul edx, edx, 0x26                          # 004892c7
    mov word ptr [ecx + edx + field_6ee], 0x0    # 004892ca
    mov eax, dword ptr [ebp - local_14]          # 004892d4
    mov ecx, dword ptr [eax + field_1c]          # 004892d7
    movsx edx, word ptr [ebp - local_4]          # 004892da
    imul edx, edx, 0x26                          # 004892de
    mov word ptr [ecx + edx + field_6f0], 0x2    # 004892e1
    mov eax, dword ptr [ebp - local_c]           # 004892eb
    add eax, 0x37                                # 004892ee
    mov ecx, dword ptr [ebp - local_14]          # 004892f1
    mov edx, dword ptr [ecx + field_1c]          # 004892f4
    movsx ecx, word ptr [ebp - local_4]          # 004892f7
    imul ecx, ecx, 0x26                          # 004892fb
    lea edx, [edx + ecx + field_702]             # 004892fe
    mov ecx, dword ptr [eax]                     # 00489305
    mov dword ptr [edx], ecx                     # 00489307
    mov ecx, dword ptr [eax + field_4]           # 00489309
    mov dword ptr [edx + field_4], ecx           # 0048930c
    mov ecx, dword ptr [eax + field_8]           # 0048930f
    mov dword ptr [edx + field_8], ecx           # 00489312
    mov eax, dword ptr [eax + field_c]           # 00489315
    mov dword ptr [edx + field_c], eax           # 00489318
    mov ecx, dword ptr [ebp - local_14]          # 0048931b
    mov edx, dword ptr [ecx + field_1c]          # 0048931e
    movsx eax, word ptr [ebp - local_4]          # 00489321
    imul eax, eax, 0x26                          # 00489325
    mov dword ptr [edx + eax + field_6f6], 0x0   # 00489328
    mov ecx, dword ptr [ebp - local_14]          # 00489333
    mov edx, dword ptr [ecx + field_1c]          # 00489336
    movsx eax, word ptr [ebp - local_4]          # 00489339
    imul eax, eax, 0x26                          # 0048933d
    mov dword ptr [edx + eax + field_6f2], 0x0   # 00489340
    mov ecx, dword ptr [ebp - local_c]           # 0048934b
    mov edx, dword ptr [ebp - local_c]           # 0048934e
    mov eax, dword ptr [ecx + field_43]          # 00489351
    sub eax, dword ptr [edx + field_3b]          # 00489354
    mov ecx, dword ptr [ebp - local_14]          # 00489357
    mov edx, dword ptr [ecx + field_1c]          # 0048935a
    movsx ecx, word ptr [ebp - local_4]          # 0048935d
    imul ecx, ecx, 0x26                          # 00489361
    mov dword ptr [edx + ecx + field_6fe], eax   # 00489364
    mov edx, dword ptr [ebp - local_c]           # 0048936b
    mov eax, dword ptr [ebp - local_c]           # 0048936e
    mov ecx, dword ptr [edx + field_3f]          # 00489371
    sub ecx, dword ptr [eax + field_37]          # 00489374
    mov edx, dword ptr [ebp - local_14]          # 00489377
    mov eax, dword ptr [edx + field_1c]          # 0048937a
    movsx edx, word ptr [ebp - local_4]          # 0048937d
    imul edx, edx, 0x26                          # 00489381
    mov dword ptr [eax + edx + field_6fa], ecx   # 00489384
    jmp.d32 L_00489281                           # 0048938b
L_00489390:
    # block 0x00489390: entered by jge at 0x004892a0, 63 instruction(s), ends with je to 0x00489453 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 00489390
    mov ecx, dword ptr [eax]                     # 00489393
    add ecx, 0x47                                # 00489395
    mov edx, dword ptr [ebp + arg_c]             # 00489398
    mov dword ptr [edx], ecx                     # 0048939b
    mov eax, dword ptr [ebp + arg_10]            # 0048939d
    mov ecx, dword ptr [eax]                     # 004893a0
    add ecx, 0x47                                # 004893a2
    mov edx, dword ptr [ebp + arg_10]            # 004893a5
    mov dword ptr [edx], ecx                     # 004893a8
    mov eax, dword ptr [ebp + arg_c]             # 004893aa
    mov ecx, dword ptr [eax]                     # 004893ad
    mov dword ptr [ebp - local_8], ecx           # 004893af
    mov edx, dword ptr [ebp - local_14]          # 004893b2
    mov eax, dword ptr [edx + field_20]          # 004893b5
    movsx ecx, word ptr [eax + field_35]         # 004893b8
    mov edx, dword ptr [ebp - local_14]          # 004893bc
    mov eax, dword ptr [edx + field_20]          # 004893bf
    movsx edx, word ptr [eax + field_33]         # 004893c2
    {load} sub ecx, edx                          # 004893c6
    add ecx, 0x1                                 # 004893c8
    shl ecx, 0x4                                 # 004893cb
    mov esi, dword ptr [ebp - local_8]           # 004893ce
    mov eax, dword ptr [ebp - local_14]          # 004893d1
    mov edi, dword ptr [eax + field_1c]          # 004893d4
    add edi, 0xac                                # 004893d7
    {load} mov edx, ecx                          # 004893dd
    shr ecx, 0x2                                 # 004893df
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004893e2
    {load} mov ecx, edx                          # 004893e4
    and ecx, 0x3                                 # 004893e6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004893e9
    mov eax, dword ptr [ebp - local_14]          # 004893eb
    mov ecx, dword ptr [eax + field_20]          # 004893ee
    movsx edx, word ptr [ecx + field_35]         # 004893f1
    mov eax, dword ptr [ebp - local_14]          # 004893f5
    mov ecx, dword ptr [eax + field_20]          # 004893f8
    movsx eax, word ptr [ecx + field_33]         # 004893fb
    {load} sub edx, eax                          # 004893ff
    add edx, 0x1                                 # 00489401
    shl edx, 0x4                                 # 00489404
    mov ecx, dword ptr [ebp + arg_c]             # 00489407
    mov eax, dword ptr [ecx]                     # 0048940a
    {load} add eax, edx                          # 0048940c
    mov ecx, dword ptr [ebp + arg_c]             # 0048940e
    mov dword ptr [ecx], eax                     # 00489411
    mov edx, dword ptr [ebp - local_14]          # 00489413
    mov eax, dword ptr [edx + field_20]          # 00489416
    movsx ecx, word ptr [eax + field_35]         # 00489419
    mov edx, dword ptr [ebp - local_14]          # 0048941d
    mov eax, dword ptr [edx + field_20]          # 00489420
    movsx edx, word ptr [eax + field_33]         # 00489423
    {load} sub ecx, edx                          # 00489427
    add ecx, 0x1                                 # 00489429
    shl ecx, 0x4                                 # 0048942c
    mov eax, dword ptr [ebp + arg_10]            # 0048942f
    mov edx, dword ptr [eax]                     # 00489432
    {load} add edx, ecx                          # 00489434
    mov eax, dword ptr [ebp + arg_10]            # 00489436
    mov dword ptr [eax], edx                     # 00489439
    movsx ecx, word ptr [0x63a4cd]               # 0048943b
    test ecx, ecx                                # 00489442
    je.d8 L_00489453                             # 00489444
    # block 0x00489446: entered by fall-through of je at 0x00489444, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00489453
    push 0x54e020                                # 00489446
    call FUN_0044a2b7                            # 0048944b
    add esp, 0x4                                 # 00489450
L_00489453:
    # block 0x00489453: entered by je at 0x00489444, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00489453
    pop esi                                      # 00489454
    {load} mov esp, ebp                          # 00489455
    pop ebp                                      # 00489457
    ret 0xc                                      # 00489458

