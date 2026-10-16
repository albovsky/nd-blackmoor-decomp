# FUN_00478f91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478f91
# extent:       0x00478f91-0x00479cbf (3374 code bytes)
# span:         0x00478f91-0x00479cd7 (code 3374, tables 24, padding 0)
# sha256:       01a4860504a1427a06386557701a9a053561e9cd04b56e379b7d4c1ac8f99c97
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478f91
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_14, field_18, field_1c, field_1e, field_20, field_21, field_24, field_28, field_2c, field_34, field_38, field_3c and 9 more; [ecx + n] field_4, field_10, field_14, field_18, field_20, field_24, field_28, field_2c, field_34, field_38, field_3c, field_40 and 7 more; [edx + n] field_4, field_8, field_c, field_14, field_23, field_28, field_30, field_34, field_48, field_1c0, field_1586, field_158a; [esi + n] field_28
# callees:      calls FUN_00479cd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 936 instruction(s), 4 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8
.equ field_ec, 0xec  # offset +0xec
.equ field_f0, 0xf0  # offset +0xf0
.equ field_f4, 0xf4  # offset +0xf4
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1586, 0x1586  # offset +0x1586
.equ field_158a, 0x158a  # offset +0x158a

# --- external targets -----------------------------------------------
.set FUN_00479cd7, .text + (0x00479cd7 - 0x401000)

.org 0x00478f91 - 0x401000
.globl FUN_00478f91
FUN_00478f91:
    # block 0x00478f91: entry, 33 instruction(s), ends with forward jump to 0x0047901a
    push ebp                                     # 00478f91
    {load} mov ebp, esp                          # 00478f92
    sub esp, 0x24                                # 00478f94
    push esi                                     # 00478f97
    push edi                                     # 00478f98
    mov dword ptr [ebp - local_20], ecx          # 00478f99
    mov eax, dword ptr [ebp - local_20]          # 00478f9c
    movsx ecx, word ptr [eax + field_1e]         # 00478f9f
    imul ecx, ecx, 0x8d                          # 00478fa3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00478fa9
    mov dword ptr [ebp - local_1c], edx          # 00478faf
    mov eax, dword ptr [ebp - local_1c]          # 00478fb2
    mov ecx, dword ptr [ebp - local_1c]          # 00478fb5
    mov edx, dword ptr [eax + field_e0]          # 00478fb8
    sub edx, dword ptr [ecx + field_d8]          # 00478fbe
    mov dword ptr [ebp - local_18], edx          # 00478fc4
    mov eax, dword ptr [ebp - local_1c]          # 00478fc7
    mov ecx, dword ptr [ebp - local_1c]          # 00478fca
    mov edx, dword ptr [eax + field_e4]          # 00478fcd
    sub edx, dword ptr [ecx + field_dc]          # 00478fd3
    mov dword ptr [ebp - local_c], edx           # 00478fd9
    mov eax, dword ptr [ebp - local_1c]          # 00478fdc
    mov ecx, dword ptr [ebp - local_1c]          # 00478fdf
    mov edx, dword ptr [eax + field_f0]          # 00478fe2
    sub edx, dword ptr [ecx + field_e8]          # 00478fe8
    mov dword ptr [ebp - local_8], edx           # 00478fee
    mov eax, dword ptr [ebp - local_1c]          # 00478ff1
    mov ecx, dword ptr [ebp - local_1c]          # 00478ff4
    mov edx, dword ptr [eax + field_f4]          # 00478ff7
    sub edx, dword ptr [ecx + field_ec]          # 00478ffd
    mov dword ptr [ebp - local_14], edx          # 00479003
    mov word ptr [ebp - local_4], 0x0            # 00479006
    jmp.d8 L_0047901a                            # 0047900c
L_0047900e:
    # block 0x0047900e: entered by jmp at 0x00479cb4, 3 instruction(s), falls into the block at 0x0047901a
    mov ax, word ptr [ebp - local_4]             # 0047900e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00479012
    mov word ptr [ebp - local_4], ax             # 00479016
L_0047901a:
    # block 0x0047901a: entered by jmp at 0x0047900c, 5 instruction(s), ends with jge to 0x00479cb9 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0047901a
    mov edx, dword ptr [ebp - local_1c]          # 0047901e
    movsx eax, word ptr [edx + field_23]         # 00479021
    {load} cmp ecx, eax                          # 00479025
    jge.d32 L_00479cb9                           # 00479027
    # block 0x0047902d: entered by fall-through of jge at 0x00479027, 2 instruction(s), ends with forward jump to 0x00479041
    mov word ptr [ebp - local_10], 0x0           # 0047902d
    jmp.d8 L_00479041                            # 00479033
L_00479035:
    # block 0x00479035: entered by jmp at 0x00479caf, 3 instruction(s), falls into the block at 0x00479041
    mov cx, word ptr [ebp - local_10]            # 00479035
    add cx, 0x1                                  # 00479039
    mov word ptr [ebp - local_10], cx            # 0047903d
L_00479041:
    # block 0x00479041: entered by jmp at 0x00479033, 5 instruction(s), ends with jge to 0x00479cb4 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00479041
    mov eax, dword ptr [ebp - local_1c]          # 00479045
    movsx ecx, word ptr [eax + field_21]         # 00479048
    {load} cmp edx, ecx                          # 0047904c
    jge.d32 L_00479cb4                           # 0047904e
    # block 0x00479054: entered by fall-through of jge at 0x0047904e, 18 instruction(s), ends with je to 0x00479caf (forward)
    mov ecx, 0x15                                # 00479054
    {load} xor eax, eax                          # 00479059
    movsx edx, word ptr [ebp - local_4]          # 0047905b
    imul edx, edx, 0x2a0                         # 0047905f
    mov esi, dword ptr [ebp - local_20]          # 00479065
    lea edi, [esi + edx + field_28]              # 00479068
    movsx edx, word ptr [ebp - local_10]         # 0047906c
    imul edx, edx, 0x54                          # 00479070
    {load} add edi, edx                          # 00479073
    rep stosd dword ptr es:[edi], eax            # 00479075
    movsx eax, word ptr [ebp - local_4]          # 00479077
    shl eax, 0x4                                 # 0047907b
    mov ecx, dword ptr [ebp - local_1c]          # 0047907e
    lea edx, [ecx + eax + field_2c]              # 00479081
    movsx eax, word ptr [ebp - local_10]         # 00479085
    movsx ecx, word ptr [edx + 2*eax]            # 00479089
    test ecx, ecx                                # 0047908d
    je.d32 L_00479caf                            # 0047908f
    # block 0x00479095: entered by fall-through of je at 0x0047908f, 19 instruction(s), ends with ja to 0x00479caf (forward)
    movsx edx, word ptr [ebp - local_4]          # 00479095
    imul edx, edx, 0x2a0                         # 00479099
    mov eax, dword ptr [ebp - local_20]          # 0047909f
    lea ecx, [eax + edx + field_28]              # 004790a2
    movsx edx, word ptr [ebp - local_10]         # 004790a6
    imul edx, edx, 0x54                          # 004790aa
    mov dword ptr [ecx + edx], 0x1               # 004790ad
    movsx eax, word ptr [ebp - local_4]          # 004790b4
    shl eax, 0x4                                 # 004790b8
    mov ecx, dword ptr [ebp - local_1c]          # 004790bb
    lea edx, [ecx + eax + field_2c]              # 004790be
    movsx eax, word ptr [ebp - local_10]         # 004790c2
    movsx ecx, word ptr [edx + 2*eax]            # 004790c6
    mov dword ptr [ebp - local_24], ecx          # 004790ca
    mov edx, dword ptr [ebp - local_24]          # 004790cd
    sub edx, 0x1                                 # 004790d0
    mov dword ptr [ebp - local_24], edx          # 004790d3
    cmp dword ptr [ebp - local_24], 0x5          # 004790d6
    ja.d32 L_00479caf                            # 004790da
    # block 0x004790e0: entered by fall-through of ja at 0x004790da, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x479cbf]
    mov eax, dword ptr [ebp - local_24]          # 004790e0
    jmp dword ptr [4*eax + SWTAB_00479cbf_VA]    # 004790e3
L_004790ea:
    # block 0x004790ea: entered by switch case, 105 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00479caf
    movsx ecx, word ptr [ebp - local_4]          # 004790ea
    imul ecx, ecx, 0x2a0                         # 004790ee
    mov edx, dword ptr [ebp - local_20]          # 004790f4
    lea eax, [edx + ecx + field_28]              # 004790f7
    movsx ecx, word ptr [ebp - local_10]         # 004790fb
    imul ecx, ecx, 0x54                          # 004790ff
    lea edx, [eax + ecx + field_14]              # 00479102
    push edx                                     # 00479106
    push 0x0                                     # 00479107
    mov ax, word ptr [ebp - local_10]            # 00479109
    push eax                                     # 0047910d
    mov cx, word ptr [ebp - local_4]             # 0047910e
    push ecx                                     # 00479112
    mov ecx, dword ptr [ebp - local_20]          # 00479113
    call FUN_00479cd7                            # 00479116
    movsx edx, word ptr [ebp - local_4]          # 0047911b
    imul edx, edx, 0x2a0                         # 0047911f
    mov eax, dword ptr [ebp - local_20]          # 00479125
    lea ecx, [eax + edx + field_28]              # 00479128
    movsx edx, word ptr [ebp - local_10]         # 0047912c
    imul edx, edx, 0x54                          # 00479130
    mov dword ptr [ecx + edx + field_4], 0x1     # 00479133
    movsx eax, word ptr [ebp - local_4]          # 0047913b
    imul eax, eax, 0x2a0                         # 0047913f
    mov ecx, dword ptr [ebp - local_20]          # 00479145
    lea ecx, [ecx + eax + field_28]              # 00479148
    movsx esi, word ptr [ebp - local_10]         # 0047914c
    imul esi, esi, 0x54                          # 00479150
    mov edx, dword ptr [ebp - local_20]          # 00479153
    mov eax, dword ptr [edx + field_158a]        # 00479156
    sub eax, dword ptr [ebp - local_c]           # 0047915c
    cdq                                          # 0047915f
    {load} sub eax, edx                          # 00479160
    sar eax                                      # 00479162
    mov ecx, dword ptr [ecx + esi + field_18]    # 00479164
    {load} add ecx, eax                          # 00479168
    movsx edx, word ptr [ebp - local_10]         # 0047916a
    imul edx, edx, 0x54                          # 0047916e
    movsx eax, word ptr [ebp - local_4]          # 00479171
    imul eax, eax, 0x2a0                         # 00479175
    mov esi, dword ptr [ebp - local_20]          # 0047917b
    lea eax, [esi + eax + field_28]              # 0047917e
    mov dword ptr [eax + edx + field_18], ecx    # 00479182
    movsx ecx, word ptr [ebp - local_4]          # 00479186
    imul ecx, ecx, 0x2a0                         # 0047918a
    mov edx, dword ptr [ebp - local_20]          # 00479190
    lea ecx, [edx + ecx + field_28]              # 00479193
    movsx esi, word ptr [ebp - local_10]         # 00479197
    imul esi, esi, 0x54                          # 0047919b
    mov edx, dword ptr [ebp - local_20]          # 0047919e
    mov eax, dword ptr [edx + field_158a]        # 004791a1
    sub eax, dword ptr [ebp - local_c]           # 004791a7
    cdq                                          # 004791aa
    {load} sub eax, edx                          # 004791ab
    sar eax                                      # 004791ad
    mov ecx, dword ptr [ecx + esi + field_20]    # 004791af
    {load} sub ecx, eax                          # 004791b3
    movsx edx, word ptr [ebp - local_10]         # 004791b5
    imul edx, edx, 0x54                          # 004791b9
    movsx eax, word ptr [ebp - local_4]          # 004791bc
    imul eax, eax, 0x2a0                         # 004791c0
    mov esi, dword ptr [ebp - local_20]          # 004791c6
    lea eax, [esi + eax + field_28]              # 004791c9
    mov dword ptr [eax + edx + field_20], ecx    # 004791cd
    movsx ecx, word ptr [ebp - local_4]          # 004791d1
    imul ecx, ecx, 0x2a0                         # 004791d5
    mov edx, dword ptr [ebp - local_20]          # 004791db
    lea ecx, [edx + ecx + field_28]              # 004791de
    movsx esi, word ptr [ebp - local_10]         # 004791e2
    imul esi, esi, 0x54                          # 004791e6
    mov edx, dword ptr [ebp - local_1c]          # 004791e9
    movsx eax, word ptr [edx + field_1c0]        # 004791ec
    cdq                                          # 004791f3
    {load} sub eax, edx                          # 004791f4
    sar eax                                      # 004791f6
    mov ecx, dword ptr [ecx + esi + field_14]    # 004791f8
    {load} sub ecx, eax                          # 004791fc
    mov eax, dword ptr [ebp - local_18]          # 004791fe
    cdq                                          # 00479201
    {load} sub eax, edx                          # 00479202
    sar eax                                      # 00479204
    {load} sub ecx, eax                          # 00479206
    movsx edx, word ptr [ebp - local_4]          # 00479208
    imul edx, edx, 0x2a0                         # 0047920c
    mov eax, dword ptr [ebp - local_20]          # 00479212
    lea edx, [eax + edx + field_28]              # 00479215
    movsx eax, word ptr [ebp - local_10]         # 00479219
    imul eax, eax, 0x54                          # 0047921d
    mov dword ptr [edx + eax + field_14], ecx    # 00479220
    movsx ecx, word ptr [ebp - local_4]          # 00479224
    imul ecx, ecx, 0x2a0                         # 00479228
    mov edx, dword ptr [ebp - local_20]          # 0047922e
    lea eax, [edx + ecx + field_28]              # 00479231
    movsx ecx, word ptr [ebp - local_10]         # 00479235
    imul ecx, ecx, 0x54                          # 00479239
    mov edx, dword ptr [eax + ecx + field_14]    # 0047923c
    add edx, dword ptr [ebp - local_18]          # 00479240
    movsx eax, word ptr [ebp - local_4]          # 00479243
    imul eax, eax, 0x2a0                         # 00479247
    mov ecx, dword ptr [ebp - local_20]          # 0047924d
    lea eax, [ecx + eax + field_28]              # 00479250
    movsx ecx, word ptr [ebp - local_10]         # 00479254
    imul ecx, ecx, 0x54                          # 00479258
    mov dword ptr [eax + ecx + field_1c], edx    # 0047925b
    jmp.d32 L_00479caf                           # 0047925f
L_00479264:
    # block 0x00479264: entered by switch case, 105 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00479caf
    movsx edx, word ptr [ebp - local_4]          # 00479264
    imul edx, edx, 0x2a0                         # 00479268
    mov eax, dword ptr [ebp - local_20]          # 0047926e
    lea ecx, [eax + edx + field_28]              # 00479271
    movsx edx, word ptr [ebp - local_10]         # 00479275
    imul edx, edx, 0x54                          # 00479279
    lea eax, [ecx + edx + field_34]              # 0047927c
    push eax                                     # 00479280
    push 0x0                                     # 00479281
    mov cx, word ptr [ebp - local_10]            # 00479283
    push ecx                                     # 00479287
    mov dx, word ptr [ebp - local_4]             # 00479288
    push edx                                     # 0047928c
    mov ecx, dword ptr [ebp - local_20]          # 0047928d
    call FUN_00479cd7                            # 00479290
    movsx eax, word ptr [ebp - local_4]          # 00479295
    imul eax, eax, 0x2a0                         # 00479299
    mov ecx, dword ptr [ebp - local_20]          # 0047929f
    lea edx, [ecx + eax + field_28]              # 004792a2
    movsx eax, word ptr [ebp - local_10]         # 004792a6
    imul eax, eax, 0x54                          # 004792aa
    mov dword ptr [edx + eax + field_c], 0x1     # 004792ad
    movsx ecx, word ptr [ebp - local_4]          # 004792b5
    imul ecx, ecx, 0x2a0                         # 004792b9
    mov edx, dword ptr [ebp - local_20]          # 004792bf
    lea ecx, [edx + ecx + field_28]              # 004792c2
    movsx esi, word ptr [ebp - local_10]         # 004792c6
    imul esi, esi, 0x54                          # 004792ca
    mov edx, dword ptr [ebp - local_20]          # 004792cd
    mov eax, dword ptr [edx + field_158a]        # 004792d0
    sub eax, dword ptr [ebp - local_c]           # 004792d6
    cdq                                          # 004792d9
    {load} sub eax, edx                          # 004792da
    sar eax                                      # 004792dc
    mov ecx, dword ptr [ecx + esi + field_38]    # 004792de
    {load} add ecx, eax                          # 004792e2
    movsx edx, word ptr [ebp - local_10]         # 004792e4
    imul edx, edx, 0x54                          # 004792e8
    movsx eax, word ptr [ebp - local_4]          # 004792eb
    imul eax, eax, 0x2a0                         # 004792ef
    mov esi, dword ptr [ebp - local_20]          # 004792f5
    lea eax, [esi + eax + field_28]              # 004792f8
    mov dword ptr [eax + edx + field_38], ecx    # 004792fc
    movsx ecx, word ptr [ebp - local_4]          # 00479300
    imul ecx, ecx, 0x2a0                         # 00479304
    mov edx, dword ptr [ebp - local_20]          # 0047930a
    lea ecx, [edx + ecx + field_28]              # 0047930d
    movsx esi, word ptr [ebp - local_10]         # 00479311
    imul esi, esi, 0x54                          # 00479315
    mov edx, dword ptr [ebp - local_20]          # 00479318
    mov eax, dword ptr [edx + field_158a]        # 0047931b
    sub eax, dword ptr [ebp - local_c]           # 00479321
    cdq                                          # 00479324
    {load} sub eax, edx                          # 00479325
    sar eax                                      # 00479327
    mov ecx, dword ptr [ecx + esi + field_40]    # 00479329
    {load} sub ecx, eax                          # 0047932d
    movsx edx, word ptr [ebp - local_10]         # 0047932f
    imul edx, edx, 0x54                          # 00479333
    movsx eax, word ptr [ebp - local_4]          # 00479336
    imul eax, eax, 0x2a0                         # 0047933a
    mov esi, dword ptr [ebp - local_20]          # 00479340
    lea eax, [esi + eax + field_28]              # 00479343
    mov dword ptr [eax + edx + field_40], ecx    # 00479347
    movsx ecx, word ptr [ebp - local_4]          # 0047934b
    imul ecx, ecx, 0x2a0                         # 0047934f
    mov edx, dword ptr [ebp - local_20]          # 00479355
    lea ecx, [edx + ecx + field_28]              # 00479358
    movsx esi, word ptr [ebp - local_10]         # 0047935c
    imul esi, esi, 0x54                          # 00479360
    mov edx, dword ptr [ebp - local_1c]          # 00479363
    movsx eax, word ptr [edx + field_1c0]        # 00479366
    cdq                                          # 0047936d
    {load} sub eax, edx                          # 0047936e
    sar eax                                      # 00479370
    mov ecx, dword ptr [ecx + esi + field_3c]    # 00479372
    {load} add ecx, eax                          # 00479376
    mov eax, dword ptr [ebp - local_18]          # 00479378
    cdq                                          # 0047937b
    {load} sub eax, edx                          # 0047937c
    sar eax                                      # 0047937e
    {load} sub ecx, eax                          # 00479380
    movsx edx, word ptr [ebp - local_4]          # 00479382
    imul edx, edx, 0x2a0                         # 00479386
    mov eax, dword ptr [ebp - local_20]          # 0047938c
    lea edx, [eax + edx + field_28]              # 0047938f
    movsx eax, word ptr [ebp - local_10]         # 00479393
    imul eax, eax, 0x54                          # 00479397
    mov dword ptr [edx + eax + field_34], ecx    # 0047939a
    movsx ecx, word ptr [ebp - local_4]          # 0047939e
    imul ecx, ecx, 0x2a0                         # 004793a2
    mov edx, dword ptr [ebp - local_20]          # 004793a8
    lea eax, [edx + ecx + field_28]              # 004793ab
    movsx ecx, word ptr [ebp - local_10]         # 004793af
    imul ecx, ecx, 0x54                          # 004793b3
    mov edx, dword ptr [eax + ecx + field_34]    # 004793b6
    add edx, dword ptr [ebp - local_18]          # 004793ba
    movsx eax, word ptr [ebp - local_4]          # 004793bd
    imul eax, eax, 0x2a0                         # 004793c1
    mov ecx, dword ptr [ebp - local_20]          # 004793c7
    lea eax, [ecx + eax + field_28]              # 004793ca
    movsx ecx, word ptr [ebp - local_10]         # 004793ce
    imul ecx, ecx, 0x54                          # 004793d2
    mov dword ptr [eax + ecx + field_3c], edx    # 004793d5
    jmp.d32 L_00479caf                           # 004793d9
L_004793de:
    # block 0x004793de: entered by switch case, 209 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00479caf
    movsx edx, word ptr [ebp - local_4]          # 004793de
    imul edx, edx, 0x2a0                         # 004793e2
    mov eax, dword ptr [ebp - local_20]          # 004793e8
    lea ecx, [eax + edx + field_28]              # 004793eb
    movsx edx, word ptr [ebp - local_10]         # 004793ef
    imul edx, edx, 0x54                          # 004793f3
    lea eax, [ecx + edx + field_14]              # 004793f6
    push eax                                     # 004793fa
    push 0x0                                     # 004793fb
    mov cx, word ptr [ebp - local_10]            # 004793fd
    push ecx                                     # 00479401
    mov dx, word ptr [ebp - local_4]             # 00479402
    push edx                                     # 00479406
    mov ecx, dword ptr [ebp - local_20]          # 00479407
    call FUN_00479cd7                            # 0047940a
    movsx eax, word ptr [ebp - local_4]          # 0047940f
    imul eax, eax, 0x2a0                         # 00479413
    mov ecx, dword ptr [ebp - local_20]          # 00479419
    lea edx, [ecx + eax + field_28]              # 0047941c
    movsx eax, word ptr [ebp - local_10]         # 00479420
    imul eax, eax, 0x54                          # 00479424
    mov dword ptr [edx + eax + field_4], 0x1     # 00479427
    movsx ecx, word ptr [ebp - local_4]          # 0047942f
    imul ecx, ecx, 0x2a0                         # 00479433
    mov edx, dword ptr [ebp - local_20]          # 00479439
    lea ecx, [edx + ecx + field_28]              # 0047943c
    movsx esi, word ptr [ebp - local_10]         # 00479440
    imul esi, esi, 0x54                          # 00479444
    mov edx, dword ptr [ebp - local_20]          # 00479447
    mov eax, dword ptr [edx + field_158a]        # 0047944a
    sub eax, dword ptr [ebp - local_c]           # 00479450
    cdq                                          # 00479453
    {load} sub eax, edx                          # 00479454
    sar eax                                      # 00479456
    mov ecx, dword ptr [ecx + esi + field_18]    # 00479458
    {load} add ecx, eax                          # 0047945c
    movsx edx, word ptr [ebp - local_10]         # 0047945e
    imul edx, edx, 0x54                          # 00479462
    movsx eax, word ptr [ebp - local_4]          # 00479465
    imul eax, eax, 0x2a0                         # 00479469
    mov esi, dword ptr [ebp - local_20]          # 0047946f
    lea eax, [esi + eax + field_28]              # 00479472
    mov dword ptr [eax + edx + field_18], ecx    # 00479476
    movsx ecx, word ptr [ebp - local_4]          # 0047947a
    imul ecx, ecx, 0x2a0                         # 0047947e
    mov edx, dword ptr [ebp - local_20]          # 00479484
    lea ecx, [edx + ecx + field_28]              # 00479487
    movsx esi, word ptr [ebp - local_10]         # 0047948b
    imul esi, esi, 0x54                          # 0047948f
    mov edx, dword ptr [ebp - local_20]          # 00479492
    mov eax, dword ptr [edx + field_158a]        # 00479495
    sub eax, dword ptr [ebp - local_c]           # 0047949b
    cdq                                          # 0047949e
    {load} sub eax, edx                          # 0047949f
    sar eax                                      # 004794a1
    mov ecx, dword ptr [ecx + esi + field_20]    # 004794a3
    {load} sub ecx, eax                          # 004794a7
    movsx edx, word ptr [ebp - local_10]         # 004794a9
    imul edx, edx, 0x54                          # 004794ad
    movsx eax, word ptr [ebp - local_4]          # 004794b0
    imul eax, eax, 0x2a0                         # 004794b4
    mov esi, dword ptr [ebp - local_20]          # 004794ba
    lea eax, [esi + eax + field_28]              # 004794bd
    mov dword ptr [eax + edx + field_20], ecx    # 004794c1
    movsx ecx, word ptr [ebp - local_4]          # 004794c5
    imul ecx, ecx, 0x2a0                         # 004794c9
    mov edx, dword ptr [ebp - local_20]          # 004794cf
    lea ecx, [edx + ecx + field_28]              # 004794d2
    movsx esi, word ptr [ebp - local_10]         # 004794d6
    imul esi, esi, 0x54                          # 004794da
    mov edx, dword ptr [ebp - local_1c]          # 004794dd
    movsx eax, word ptr [edx + field_1c0]        # 004794e0
    cdq                                          # 004794e7
    {load} sub eax, edx                          # 004794e8
    sar eax                                      # 004794ea
    mov ecx, dword ptr [ecx + esi + field_14]    # 004794ec
    {load} sub ecx, eax                          # 004794f0
    mov eax, dword ptr [ebp - local_18]          # 004794f2
    cdq                                          # 004794f5
    {load} sub eax, edx                          # 004794f6
    sar eax                                      # 004794f8
    {load} sub ecx, eax                          # 004794fa
    movsx edx, word ptr [ebp - local_4]          # 004794fc
    imul edx, edx, 0x2a0                         # 00479500
    mov eax, dword ptr [ebp - local_20]          # 00479506
    lea edx, [eax + edx + field_28]              # 00479509
    movsx eax, word ptr [ebp - local_10]         # 0047950d
    imul eax, eax, 0x54                          # 00479511
    mov dword ptr [edx + eax + field_14], ecx    # 00479514
    movsx ecx, word ptr [ebp - local_4]          # 00479518
    imul ecx, ecx, 0x2a0                         # 0047951c
    mov edx, dword ptr [ebp - local_20]          # 00479522
    lea eax, [edx + ecx + field_28]              # 00479525
    movsx ecx, word ptr [ebp - local_10]         # 00479529
    imul ecx, ecx, 0x54                          # 0047952d
    mov edx, dword ptr [eax + ecx + field_14]    # 00479530
    add edx, dword ptr [ebp - local_18]          # 00479534
    movsx eax, word ptr [ebp - local_4]          # 00479537
    imul eax, eax, 0x2a0                         # 0047953b
    mov ecx, dword ptr [ebp - local_20]          # 00479541
    lea eax, [ecx + eax + field_28]              # 00479544
    movsx ecx, word ptr [ebp - local_10]         # 00479548
    imul ecx, ecx, 0x54                          # 0047954c
    mov dword ptr [eax + ecx + field_1c], edx    # 0047954f
    movsx edx, word ptr [ebp - local_4]          # 00479553
    imul edx, edx, 0x2a0                         # 00479557
    mov eax, dword ptr [ebp - local_20]          # 0047955d
    lea ecx, [eax + edx + field_28]              # 00479560
    movsx edx, word ptr [ebp - local_10]         # 00479564
    imul edx, edx, 0x54                          # 00479568
    lea eax, [ecx + edx + field_34]              # 0047956b
    push eax                                     # 0047956f
    push 0x0                                     # 00479570
    mov cx, word ptr [ebp - local_10]            # 00479572
    push ecx                                     # 00479576
    mov dx, word ptr [ebp - local_4]             # 00479577
    push edx                                     # 0047957b
    mov ecx, dword ptr [ebp - local_20]          # 0047957c
    call FUN_00479cd7                            # 0047957f
    movsx eax, word ptr [ebp - local_4]          # 00479584
    imul eax, eax, 0x2a0                         # 00479588
    mov ecx, dword ptr [ebp - local_20]          # 0047958e
    lea edx, [ecx + eax + field_28]              # 00479591
    movsx eax, word ptr [ebp - local_10]         # 00479595
    imul eax, eax, 0x54                          # 00479599
    mov dword ptr [edx + eax + field_c], 0x1     # 0047959c
    movsx ecx, word ptr [ebp - local_4]          # 004795a4
    imul ecx, ecx, 0x2a0                         # 004795a8
    mov edx, dword ptr [ebp - local_20]          # 004795ae
    lea ecx, [edx + ecx + field_28]              # 004795b1
    movsx esi, word ptr [ebp - local_10]         # 004795b5
    imul esi, esi, 0x54                          # 004795b9
    mov edx, dword ptr [ebp - local_20]          # 004795bc
    mov eax, dword ptr [edx + field_158a]        # 004795bf
    sub eax, dword ptr [ebp - local_c]           # 004795c5
    cdq                                          # 004795c8
    {load} sub eax, edx                          # 004795c9
    sar eax                                      # 004795cb
    mov ecx, dword ptr [ecx + esi + field_38]    # 004795cd
    {load} add ecx, eax                          # 004795d1
    movsx edx, word ptr [ebp - local_10]         # 004795d3
    imul edx, edx, 0x54                          # 004795d7
    movsx eax, word ptr [ebp - local_4]          # 004795da
    imul eax, eax, 0x2a0                         # 004795de
    mov esi, dword ptr [ebp - local_20]          # 004795e4
    lea eax, [esi + eax + field_28]              # 004795e7
    mov dword ptr [eax + edx + field_38], ecx    # 004795eb
    movsx ecx, word ptr [ebp - local_4]          # 004795ef
    imul ecx, ecx, 0x2a0                         # 004795f3
    mov edx, dword ptr [ebp - local_20]          # 004795f9
    lea ecx, [edx + ecx + field_28]              # 004795fc
    movsx esi, word ptr [ebp - local_10]         # 00479600
    imul esi, esi, 0x54                          # 00479604
    mov edx, dword ptr [ebp - local_20]          # 00479607
    mov eax, dword ptr [edx + field_158a]        # 0047960a
    sub eax, dword ptr [ebp - local_c]           # 00479610
    cdq                                          # 00479613
    {load} sub eax, edx                          # 00479614
    sar eax                                      # 00479616
    mov ecx, dword ptr [ecx + esi + field_40]    # 00479618
    {load} sub ecx, eax                          # 0047961c
    movsx edx, word ptr [ebp - local_10]         # 0047961e
    imul edx, edx, 0x54                          # 00479622
    movsx eax, word ptr [ebp - local_4]          # 00479625
    imul eax, eax, 0x2a0                         # 00479629
    mov esi, dword ptr [ebp - local_20]          # 0047962f
    lea eax, [esi + eax + field_28]              # 00479632
    mov dword ptr [eax + edx + field_40], ecx    # 00479636
    movsx ecx, word ptr [ebp - local_4]          # 0047963a
    imul ecx, ecx, 0x2a0                         # 0047963e
    mov edx, dword ptr [ebp - local_20]          # 00479644
    lea ecx, [edx + ecx + field_28]              # 00479647
    movsx esi, word ptr [ebp - local_10]         # 0047964b
    imul esi, esi, 0x54                          # 0047964f
    mov edx, dword ptr [ebp - local_1c]          # 00479652
    movsx eax, word ptr [edx + field_1c0]        # 00479655
    cdq                                          # 0047965c
    {load} sub eax, edx                          # 0047965d
    sar eax                                      # 0047965f
    mov ecx, dword ptr [ecx + esi + field_3c]    # 00479661
    {load} add ecx, eax                          # 00479665
    mov eax, dword ptr [ebp - local_18]          # 00479667
    cdq                                          # 0047966a
    {load} sub eax, edx                          # 0047966b
    sar eax                                      # 0047966d
    {load} sub ecx, eax                          # 0047966f
    movsx edx, word ptr [ebp - local_4]          # 00479671
    imul edx, edx, 0x2a0                         # 00479675
    mov eax, dword ptr [ebp - local_20]          # 0047967b
    lea edx, [eax + edx + field_28]              # 0047967e
    movsx eax, word ptr [ebp - local_10]         # 00479682
    imul eax, eax, 0x54                          # 00479686
    mov dword ptr [edx + eax + field_34], ecx    # 00479689
    movsx ecx, word ptr [ebp - local_4]          # 0047968d
    imul ecx, ecx, 0x2a0                         # 00479691
    mov edx, dword ptr [ebp - local_20]          # 00479697
    lea eax, [edx + ecx + field_28]              # 0047969a
    movsx ecx, word ptr [ebp - local_10]         # 0047969e
    imul ecx, ecx, 0x54                          # 004796a2
    mov edx, dword ptr [eax + ecx + field_34]    # 004796a5
    add edx, dword ptr [ebp - local_18]          # 004796a9
    movsx eax, word ptr [ebp - local_4]          # 004796ac
    imul eax, eax, 0x2a0                         # 004796b0
    mov ecx, dword ptr [ebp - local_20]          # 004796b6
    lea eax, [ecx + eax + field_28]              # 004796b9
    movsx ecx, word ptr [ebp - local_10]         # 004796bd
    imul ecx, ecx, 0x54                          # 004796c1
    mov dword ptr [eax + ecx + field_3c], edx    # 004796c4
    jmp.d32 L_00479caf                           # 004796c8
L_004796cd:
    # block 0x004796cd: entered by switch case, 106 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00479caf
    movsx edx, word ptr [ebp - local_4]          # 004796cd
    imul edx, edx, 0x2a0                         # 004796d1
    mov eax, dword ptr [ebp - local_20]          # 004796d7
    lea ecx, [eax + edx + field_28]              # 004796da
    movsx edx, word ptr [ebp - local_10]         # 004796de
    imul edx, edx, 0x54                          # 004796e2
    lea eax, [ecx + edx + field_24]              # 004796e5
    push eax                                     # 004796e9
    push 0x0                                     # 004796ea
    mov cx, word ptr [ebp - local_10]            # 004796ec
    push ecx                                     # 004796f0
    mov dx, word ptr [ebp - local_4]             # 004796f1
    push edx                                     # 004796f5
    mov ecx, dword ptr [ebp - local_20]          # 004796f6
    call FUN_00479cd7                            # 004796f9
    movsx eax, word ptr [ebp - local_4]          # 004796fe
    imul eax, eax, 0x2a0                         # 00479702
    mov ecx, dword ptr [ebp - local_20]          # 00479708
    lea edx, [ecx + eax + field_28]              # 0047970b
    movsx eax, word ptr [ebp - local_10]         # 0047970f
    imul eax, eax, 0x54                          # 00479713
    mov dword ptr [edx + eax + field_8], 0x1     # 00479716
    movsx ecx, word ptr [ebp - local_4]          # 0047971e
    imul ecx, ecx, 0x2a0                         # 00479722
    mov edx, dword ptr [ebp - local_20]          # 00479728
    lea ecx, [edx + ecx + field_28]              # 0047972b
    movsx esi, word ptr [ebp - local_10]         # 0047972f
    imul esi, esi, 0x54                          # 00479733
    mov edx, dword ptr [ebp - local_20]          # 00479736
    mov eax, dword ptr [edx + field_1586]        # 00479739
    sub eax, dword ptr [ebp - local_8]           # 0047973f
    cdq                                          # 00479742
    {load} sub eax, edx                          # 00479743
    sar eax                                      # 00479745
    mov ecx, dword ptr [ecx + esi + field_24]    # 00479747
    {load} add ecx, eax                          # 0047974b
    movsx edx, word ptr [ebp - local_10]         # 0047974d
    imul edx, edx, 0x54                          # 00479751
    movsx eax, word ptr [ebp - local_4]          # 00479754
    imul eax, eax, 0x2a0                         # 00479758
    mov esi, dword ptr [ebp - local_20]          # 0047975e
    lea eax, [esi + eax + field_28]              # 00479761
    mov dword ptr [eax + edx + field_24], ecx    # 00479765
    movsx ecx, word ptr [ebp - local_4]          # 00479769
    imul ecx, ecx, 0x2a0                         # 0047976d
    mov edx, dword ptr [ebp - local_20]          # 00479773
    lea ecx, [edx + ecx + field_28]              # 00479776
    movsx esi, word ptr [ebp - local_10]         # 0047977a
    imul esi, esi, 0x54                          # 0047977e
    mov edx, dword ptr [ebp - local_20]          # 00479781
    mov eax, dword ptr [edx + field_1586]        # 00479784
    sub eax, dword ptr [ebp - local_8]           # 0047978a
    cdq                                          # 0047978d
    {load} sub eax, edx                          # 0047978e
    sar eax                                      # 00479790
    mov ecx, dword ptr [ecx + esi + field_2c]    # 00479792
    {load} sub ecx, eax                          # 00479796
    movsx edx, word ptr [ebp - local_10]         # 00479798
    imul edx, edx, 0x54                          # 0047979c
    movsx eax, word ptr [ebp - local_4]          # 0047979f
    imul eax, eax, 0x2a0                         # 004797a3
    mov esi, dword ptr [ebp - local_20]          # 004797a9
    lea eax, [esi + eax + field_28]              # 004797ac
    mov dword ptr [eax + edx + field_2c], ecx    # 004797b0
    movsx ecx, word ptr [ebp - local_4]          # 004797b4
    imul ecx, ecx, 0x2a0                         # 004797b8
    mov edx, dword ptr [ebp - local_20]          # 004797be
    lea ecx, [edx + ecx + field_28]              # 004797c1
    movsx esi, word ptr [ebp - local_10]         # 004797c5
    imul esi, esi, 0x54                          # 004797c9
    mov edx, dword ptr [ebp - local_1c]          # 004797cc
    movsx eax, word ptr [edx + field_1c0]        # 004797cf
    cdq                                          # 004797d6
    {load} sub eax, edx                          # 004797d7
    {load} mov edi, eax                          # 004797d9
    sar edi                                      # 004797db
    mov eax, dword ptr [ebp - local_14]          # 004797dd
    cdq                                          # 004797e0
    {load} sub eax, edx                          # 004797e1
    sar eax                                      # 004797e3
    {load} add edi, eax                          # 004797e5
    mov eax, dword ptr [ecx + esi + field_28]    # 004797e7
    {load} sub eax, edi                          # 004797eb
    movsx ecx, word ptr [ebp - local_10]         # 004797ed
    imul ecx, ecx, 0x54                          # 004797f1
    movsx edx, word ptr [ebp - local_4]          # 004797f4
    imul edx, edx, 0x2a0                         # 004797f8
    mov esi, dword ptr [ebp - local_20]          # 004797fe
    lea edx, [esi + edx + field_28]              # 00479801
    mov dword ptr [edx + ecx + field_28], eax    # 00479805
    movsx eax, word ptr [ebp - local_4]          # 00479809
    imul eax, eax, 0x2a0                         # 0047980d
    mov ecx, dword ptr [ebp - local_20]          # 00479813
    lea edx, [ecx + eax + field_28]              # 00479816
    movsx eax, word ptr [ebp - local_10]         # 0047981a
    imul eax, eax, 0x54                          # 0047981e
    mov ecx, dword ptr [edx + eax + field_28]    # 00479821
    add ecx, dword ptr [ebp - local_14]          # 00479825
    movsx edx, word ptr [ebp - local_4]          # 00479828
    imul edx, edx, 0x2a0                         # 0047982c
    mov eax, dword ptr [ebp - local_20]          # 00479832
    lea edx, [eax + edx + field_28]              # 00479835
    movsx eax, word ptr [ebp - local_10]         # 00479839
    imul eax, eax, 0x54                          # 0047983d
    mov dword ptr [edx + eax + field_30], ecx    # 00479840
    jmp.d32 L_00479caf                           # 00479844
L_00479849:
    # block 0x00479849: entered by switch case, 105 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00479caf
    movsx ecx, word ptr [ebp - local_4]          # 00479849
    imul ecx, ecx, 0x2a0                         # 0047984d
    mov edx, dword ptr [ebp - local_20]          # 00479853
    lea eax, [edx + ecx + field_28]              # 00479856
    movsx ecx, word ptr [ebp - local_10]         # 0047985a
    imul ecx, ecx, 0x54                          # 0047985e
    lea edx, [eax + ecx + field_44]              # 00479861
    push edx                                     # 00479865
    push 0x0                                     # 00479866
    mov ax, word ptr [ebp - local_10]            # 00479868
    push eax                                     # 0047986c
    mov cx, word ptr [ebp - local_4]             # 0047986d
    push ecx                                     # 00479871
    mov ecx, dword ptr [ebp - local_20]          # 00479872
    call FUN_00479cd7                            # 00479875
    movsx edx, word ptr [ebp - local_4]          # 0047987a
    imul edx, edx, 0x2a0                         # 0047987e
    mov eax, dword ptr [ebp - local_20]          # 00479884
    lea ecx, [eax + edx + field_28]              # 00479887
    movsx edx, word ptr [ebp - local_10]         # 0047988b
    imul edx, edx, 0x54                          # 0047988f
    mov dword ptr [ecx + edx + field_10], 0x1    # 00479892
    movsx eax, word ptr [ebp - local_4]          # 0047989a
    imul eax, eax, 0x2a0                         # 0047989e
    mov ecx, dword ptr [ebp - local_20]          # 004798a4
    lea ecx, [ecx + eax + field_28]              # 004798a7
    movsx esi, word ptr [ebp - local_10]         # 004798ab
    imul esi, esi, 0x54                          # 004798af
    mov edx, dword ptr [ebp - local_20]          # 004798b2
    mov eax, dword ptr [edx + field_1586]        # 004798b5
    sub eax, dword ptr [ebp - local_8]           # 004798bb
    cdq                                          # 004798be
    {load} sub eax, edx                          # 004798bf
    sar eax                                      # 004798c1
    mov ecx, dword ptr [ecx + esi + field_44]    # 004798c3
    {load} add ecx, eax                          # 004798c7
    movsx edx, word ptr [ebp - local_10]         # 004798c9
    imul edx, edx, 0x54                          # 004798cd
    movsx eax, word ptr [ebp - local_4]          # 004798d0
    imul eax, eax, 0x2a0                         # 004798d4
    mov esi, dword ptr [ebp - local_20]          # 004798da
    lea eax, [esi + eax + field_28]              # 004798dd
    mov dword ptr [eax + edx + field_44], ecx    # 004798e1
    movsx ecx, word ptr [ebp - local_4]          # 004798e5
    imul ecx, ecx, 0x2a0                         # 004798e9
    mov edx, dword ptr [ebp - local_20]          # 004798ef
    lea ecx, [edx + ecx + field_28]              # 004798f2
    movsx esi, word ptr [ebp - local_10]         # 004798f6
    imul esi, esi, 0x54                          # 004798fa
    mov edx, dword ptr [ebp - local_20]          # 004798fd
    mov eax, dword ptr [edx + field_1586]        # 00479900
    sub eax, dword ptr [ebp - local_8]           # 00479906
    cdq                                          # 00479909
    {load} sub eax, edx                          # 0047990a
    sar eax                                      # 0047990c
    mov ecx, dword ptr [ecx + esi + field_4c]    # 0047990e
    {load} sub ecx, eax                          # 00479912
    movsx edx, word ptr [ebp - local_10]         # 00479914
    imul edx, edx, 0x54                          # 00479918
    movsx eax, word ptr [ebp - local_4]          # 0047991b
    imul eax, eax, 0x2a0                         # 0047991f
    mov esi, dword ptr [ebp - local_20]          # 00479925
    lea eax, [esi + eax + field_28]              # 00479928
    mov dword ptr [eax + edx + field_4c], ecx    # 0047992c
    movsx ecx, word ptr [ebp - local_4]          # 00479930
    imul ecx, ecx, 0x2a0                         # 00479934
    mov edx, dword ptr [ebp - local_20]          # 0047993a
    lea ecx, [edx + ecx + field_28]              # 0047993d
    movsx esi, word ptr [ebp - local_10]         # 00479941
    imul esi, esi, 0x54                          # 00479945
    mov edx, dword ptr [ebp - local_1c]          # 00479948
    movsx eax, word ptr [edx + field_1c0]        # 0047994b
    cdq                                          # 00479952
    {load} sub eax, edx                          # 00479953
    sar eax                                      # 00479955
    mov ecx, dword ptr [ecx + esi + field_50]    # 00479957
    {load} add ecx, eax                          # 0047995b
    mov eax, dword ptr [ebp - local_14]          # 0047995d
    cdq                                          # 00479960
    {load} sub eax, edx                          # 00479961
    sar eax                                      # 00479963
    {load} sub ecx, eax                          # 00479965
    movsx edx, word ptr [ebp - local_4]          # 00479967
    imul edx, edx, 0x2a0                         # 0047996b
    mov eax, dword ptr [ebp - local_20]          # 00479971
    lea edx, [eax + edx + field_28]              # 00479974
    movsx eax, word ptr [ebp - local_10]         # 00479978
    imul eax, eax, 0x54                          # 0047997c
    mov dword ptr [edx + eax + field_48], ecx    # 0047997f
    movsx ecx, word ptr [ebp - local_4]          # 00479983
    imul ecx, ecx, 0x2a0                         # 00479987
    mov edx, dword ptr [ebp - local_20]          # 0047998d
    lea eax, [edx + ecx + field_28]              # 00479990
    movsx ecx, word ptr [ebp - local_10]         # 00479994
    imul ecx, ecx, 0x54                          # 00479998
    mov edx, dword ptr [eax + ecx + field_48]    # 0047999b
    add edx, dword ptr [ebp - local_14]          # 0047999f
    movsx eax, word ptr [ebp - local_4]          # 004799a2
    imul eax, eax, 0x2a0                         # 004799a6
    mov ecx, dword ptr [ebp - local_20]          # 004799ac
    lea eax, [ecx + eax + field_28]              # 004799af
    movsx ecx, word ptr [ebp - local_10]         # 004799b3
    imul ecx, ecx, 0x54                          # 004799b7
    mov dword ptr [eax + ecx + field_50], edx    # 004799ba
    jmp.d32 L_00479caf                           # 004799be
L_004799c3:
    # block 0x004799c3: entered by switch case, 209 instruction(s), calls FUN_00479cd7, falls into the block at 0x00479caf
    movsx edx, word ptr [ebp - local_4]          # 004799c3
    imul edx, edx, 0x2a0                         # 004799c7
    mov eax, dword ptr [ebp - local_20]          # 004799cd
    lea ecx, [eax + edx + field_28]              # 004799d0
    movsx edx, word ptr [ebp - local_10]         # 004799d4
    imul edx, edx, 0x54                          # 004799d8
    lea eax, [ecx + edx + field_24]              # 004799db
    push eax                                     # 004799df
    push 0x0                                     # 004799e0
    mov cx, word ptr [ebp - local_10]            # 004799e2
    push ecx                                     # 004799e6
    mov dx, word ptr [ebp - local_4]             # 004799e7
    push edx                                     # 004799eb
    mov ecx, dword ptr [ebp - local_20]          # 004799ec
    call FUN_00479cd7                            # 004799ef
    movsx eax, word ptr [ebp - local_4]          # 004799f4
    imul eax, eax, 0x2a0                         # 004799f8
    mov ecx, dword ptr [ebp - local_20]          # 004799fe
    lea edx, [ecx + eax + field_28]              # 00479a01
    movsx eax, word ptr [ebp - local_10]         # 00479a05
    imul eax, eax, 0x54                          # 00479a09
    mov dword ptr [edx + eax + field_8], 0x1     # 00479a0c
    movsx ecx, word ptr [ebp - local_4]          # 00479a14
    imul ecx, ecx, 0x2a0                         # 00479a18
    mov edx, dword ptr [ebp - local_20]          # 00479a1e
    lea ecx, [edx + ecx + field_28]              # 00479a21
    movsx esi, word ptr [ebp - local_10]         # 00479a25
    imul esi, esi, 0x54                          # 00479a29
    mov edx, dword ptr [ebp - local_20]          # 00479a2c
    mov eax, dword ptr [edx + field_1586]        # 00479a2f
    sub eax, dword ptr [ebp - local_8]           # 00479a35
    cdq                                          # 00479a38
    {load} sub eax, edx                          # 00479a39
    sar eax                                      # 00479a3b
    mov ecx, dword ptr [ecx + esi + field_24]    # 00479a3d
    {load} add ecx, eax                          # 00479a41
    movsx edx, word ptr [ebp - local_10]         # 00479a43
    imul edx, edx, 0x54                          # 00479a47
    movsx eax, word ptr [ebp - local_4]          # 00479a4a
    imul eax, eax, 0x2a0                         # 00479a4e
    mov esi, dword ptr [ebp - local_20]          # 00479a54
    lea eax, [esi + eax + field_28]              # 00479a57
    mov dword ptr [eax + edx + field_24], ecx    # 00479a5b
    movsx ecx, word ptr [ebp - local_4]          # 00479a5f
    imul ecx, ecx, 0x2a0                         # 00479a63
    mov edx, dword ptr [ebp - local_20]          # 00479a69
    lea ecx, [edx + ecx + field_28]              # 00479a6c
    movsx esi, word ptr [ebp - local_10]         # 00479a70
    imul esi, esi, 0x54                          # 00479a74
    mov edx, dword ptr [ebp - local_20]          # 00479a77
    mov eax, dword ptr [edx + field_1586]        # 00479a7a
    sub eax, dword ptr [ebp - local_8]           # 00479a80
    cdq                                          # 00479a83
    {load} sub eax, edx                          # 00479a84
    sar eax                                      # 00479a86
    mov ecx, dword ptr [ecx + esi + field_2c]    # 00479a88
    {load} sub ecx, eax                          # 00479a8c
    movsx edx, word ptr [ebp - local_10]         # 00479a8e
    imul edx, edx, 0x54                          # 00479a92
    movsx eax, word ptr [ebp - local_4]          # 00479a95
    imul eax, eax, 0x2a0                         # 00479a99
    mov esi, dword ptr [ebp - local_20]          # 00479a9f
    lea eax, [esi + eax + field_28]              # 00479aa2
    mov dword ptr [eax + edx + field_2c], ecx    # 00479aa6
    movsx ecx, word ptr [ebp - local_4]          # 00479aaa
    imul ecx, ecx, 0x2a0                         # 00479aae
    mov edx, dword ptr [ebp - local_20]          # 00479ab4
    lea ecx, [edx + ecx + field_28]              # 00479ab7
    movsx esi, word ptr [ebp - local_10]         # 00479abb
    imul esi, esi, 0x54                          # 00479abf
    mov edx, dword ptr [ebp - local_1c]          # 00479ac2
    movsx eax, word ptr [edx + field_1c0]        # 00479ac5
    cdq                                          # 00479acc
    {load} sub eax, edx                          # 00479acd
    {load} mov edi, eax                          # 00479acf
    sar edi                                      # 00479ad1
    mov eax, dword ptr [ebp - local_14]          # 00479ad3
    cdq                                          # 00479ad6
    {load} sub eax, edx                          # 00479ad7
    sar eax                                      # 00479ad9
    {load} add edi, eax                          # 00479adb
    mov eax, dword ptr [ecx + esi + field_28]    # 00479add
    {load} sub eax, edi                          # 00479ae1
    movsx ecx, word ptr [ebp - local_10]         # 00479ae3
    imul ecx, ecx, 0x54                          # 00479ae7
    movsx edx, word ptr [ebp - local_4]          # 00479aea
    imul edx, edx, 0x2a0                         # 00479aee
    mov esi, dword ptr [ebp - local_20]          # 00479af4
    lea edx, [esi + edx + field_28]              # 00479af7
    mov dword ptr [edx + ecx + field_28], eax    # 00479afb
    movsx eax, word ptr [ebp - local_4]          # 00479aff
    imul eax, eax, 0x2a0                         # 00479b03
    mov ecx, dword ptr [ebp - local_20]          # 00479b09
    lea edx, [ecx + eax + field_28]              # 00479b0c
    movsx eax, word ptr [ebp - local_10]         # 00479b10
    imul eax, eax, 0x54                          # 00479b14
    mov ecx, dword ptr [edx + eax + field_28]    # 00479b17
    add ecx, dword ptr [ebp - local_14]          # 00479b1b
    movsx edx, word ptr [ebp - local_4]          # 00479b1e
    imul edx, edx, 0x2a0                         # 00479b22
    mov eax, dword ptr [ebp - local_20]          # 00479b28
    lea edx, [eax + edx + field_28]              # 00479b2b
    movsx eax, word ptr [ebp - local_10]         # 00479b2f
    imul eax, eax, 0x54                          # 00479b33
    mov dword ptr [edx + eax + field_30], ecx    # 00479b36
    movsx ecx, word ptr [ebp - local_4]          # 00479b3a
    imul ecx, ecx, 0x2a0                         # 00479b3e
    mov edx, dword ptr [ebp - local_20]          # 00479b44
    lea eax, [edx + ecx + field_28]              # 00479b47
    movsx ecx, word ptr [ebp - local_10]         # 00479b4b
    imul ecx, ecx, 0x54                          # 00479b4f
    lea edx, [eax + ecx + field_44]              # 00479b52
    push edx                                     # 00479b56
    push 0x0                                     # 00479b57
    mov ax, word ptr [ebp - local_10]            # 00479b59
    push eax                                     # 00479b5d
    mov cx, word ptr [ebp - local_4]             # 00479b5e
    push ecx                                     # 00479b62
    mov ecx, dword ptr [ebp - local_20]          # 00479b63
    call FUN_00479cd7                            # 00479b66
    movsx edx, word ptr [ebp - local_4]          # 00479b6b
    imul edx, edx, 0x2a0                         # 00479b6f
    mov eax, dword ptr [ebp - local_20]          # 00479b75
    lea ecx, [eax + edx + field_28]              # 00479b78
    movsx edx, word ptr [ebp - local_10]         # 00479b7c
    imul edx, edx, 0x54                          # 00479b80
    mov dword ptr [ecx + edx + field_10], 0x1    # 00479b83
    movsx eax, word ptr [ebp - local_4]          # 00479b8b
    imul eax, eax, 0x2a0                         # 00479b8f
    mov ecx, dword ptr [ebp - local_20]          # 00479b95
    lea ecx, [ecx + eax + field_28]              # 00479b98
    movsx esi, word ptr [ebp - local_10]         # 00479b9c
    imul esi, esi, 0x54                          # 00479ba0
    mov edx, dword ptr [ebp - local_20]          # 00479ba3
    mov eax, dword ptr [edx + field_1586]        # 00479ba6
    sub eax, dword ptr [ebp - local_8]           # 00479bac
    cdq                                          # 00479baf
    {load} sub eax, edx                          # 00479bb0
    sar eax                                      # 00479bb2
    mov ecx, dword ptr [ecx + esi + field_44]    # 00479bb4
    {load} add ecx, eax                          # 00479bb8
    movsx edx, word ptr [ebp - local_10]         # 00479bba
    imul edx, edx, 0x54                          # 00479bbe
    movsx eax, word ptr [ebp - local_4]          # 00479bc1
    imul eax, eax, 0x2a0                         # 00479bc5
    mov esi, dword ptr [ebp - local_20]          # 00479bcb
    lea eax, [esi + eax + field_28]              # 00479bce
    mov dword ptr [eax + edx + field_44], ecx    # 00479bd2
    movsx ecx, word ptr [ebp - local_4]          # 00479bd6
    imul ecx, ecx, 0x2a0                         # 00479bda
    mov edx, dword ptr [ebp - local_20]          # 00479be0
    lea ecx, [edx + ecx + field_28]              # 00479be3
    movsx esi, word ptr [ebp - local_10]         # 00479be7
    imul esi, esi, 0x54                          # 00479beb
    mov edx, dword ptr [ebp - local_20]          # 00479bee
    mov eax, dword ptr [edx + field_1586]        # 00479bf1
    sub eax, dword ptr [ebp - local_8]           # 00479bf7
    cdq                                          # 00479bfa
    {load} sub eax, edx                          # 00479bfb
    sar eax                                      # 00479bfd
    mov ecx, dword ptr [ecx + esi + field_4c]    # 00479bff
    {load} sub ecx, eax                          # 00479c03
    movsx edx, word ptr [ebp - local_10]         # 00479c05
    imul edx, edx, 0x54                          # 00479c09
    movsx eax, word ptr [ebp - local_4]          # 00479c0c
    imul eax, eax, 0x2a0                         # 00479c10
    mov esi, dword ptr [ebp - local_20]          # 00479c16
    lea eax, [esi + eax + field_28]              # 00479c19
    mov dword ptr [eax + edx + field_4c], ecx    # 00479c1d
    movsx ecx, word ptr [ebp - local_4]          # 00479c21
    imul ecx, ecx, 0x2a0                         # 00479c25
    mov edx, dword ptr [ebp - local_20]          # 00479c2b
    lea ecx, [edx + ecx + field_28]              # 00479c2e
    movsx esi, word ptr [ebp - local_10]         # 00479c32
    imul esi, esi, 0x54                          # 00479c36
    mov edx, dword ptr [ebp - local_1c]          # 00479c39
    movsx eax, word ptr [edx + field_1c0]        # 00479c3c
    cdq                                          # 00479c43
    {load} sub eax, edx                          # 00479c44
    sar eax                                      # 00479c46
    mov ecx, dword ptr [ecx + esi + field_50]    # 00479c48
    {load} add ecx, eax                          # 00479c4c
    mov eax, dword ptr [ebp - local_14]          # 00479c4e
    cdq                                          # 00479c51
    {load} sub eax, edx                          # 00479c52
    sar eax                                      # 00479c54
    {load} sub ecx, eax                          # 00479c56
    movsx edx, word ptr [ebp - local_4]          # 00479c58
    imul edx, edx, 0x2a0                         # 00479c5c
    mov eax, dword ptr [ebp - local_20]          # 00479c62
    lea edx, [eax + edx + field_28]              # 00479c65
    movsx eax, word ptr [ebp - local_10]         # 00479c69
    imul eax, eax, 0x54                          # 00479c6d
    mov dword ptr [edx + eax + field_48], ecx    # 00479c70
    movsx ecx, word ptr [ebp - local_4]          # 00479c74
    imul ecx, ecx, 0x2a0                         # 00479c78
    mov edx, dword ptr [ebp - local_20]          # 00479c7e
    lea eax, [edx + ecx + field_28]              # 00479c81
    movsx ecx, word ptr [ebp - local_10]         # 00479c85
    imul ecx, ecx, 0x54                          # 00479c89
    mov edx, dword ptr [eax + ecx + field_48]    # 00479c8c
    add edx, dword ptr [ebp - local_14]          # 00479c90
    movsx eax, word ptr [ebp - local_4]          # 00479c93
    imul eax, eax, 0x2a0                         # 00479c97
    mov ecx, dword ptr [ebp - local_20]          # 00479c9d
    lea eax, [ecx + eax + field_28]              # 00479ca0
    movsx ecx, word ptr [ebp - local_10]         # 00479ca4
    imul ecx, ecx, 0x54                          # 00479ca8
    mov dword ptr [eax + ecx + field_50], edx    # 00479cab
L_00479caf:
    # block 0x00479caf: entered by je at 0x0047908f; ja at 0x004790da; jmp at 0x0047925f; jmp at 0x004793d9; more, 1 instruction(s), ends with backward jump to 0x00479035
    jmp.d32 L_00479035                           # 00479caf
L_00479cb4:
    # block 0x00479cb4: entered by jge at 0x0047904e, 1 instruction(s), ends with backward jump to 0x0047900e
    jmp.d32 L_0047900e                           # 00479cb4
L_00479cb9:
    # block 0x00479cb9: entered by jge at 0x00479027, 5 instruction(s), ends with ret
    pop edi                                      # 00479cb9
    pop esi                                      # 00479cba
    {load} mov esp, ebp                          # 00479cbb
    pop ebp                                      # 00479cbd
    ret                                          # 00479cbe

# --- data items (not part of the function) -------------------------
.org 0x00479cbf - 0x401000
SWTAB_00479cbf:  # 6 case address(es)
    .long L_004790ea - .text + 0x401000
    .long L_004796cd - .text + 0x401000
    .long L_00479264 - .text + 0x401000
    .long L_00479849 - .text + 0x401000
    .long L_004793de - .text + 0x401000
    .long L_004799c3 - .text + 0x401000
.set SWTAB_00479cbf_VA, SWTAB_00479cbf - .text + 0x401000

