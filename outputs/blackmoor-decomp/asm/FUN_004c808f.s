# FUN_004c808f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c808f
# extent:       0x004c808f-0x004c8408 (889 code bytes)
# span:         0x004c808f-0x004c8408 (code 889, tables 0, padding 0)
# sha256:       68f48787dfd809fcc987545551f07329e7265197f96eb7bbdfde2c9a5f3f0053
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c808f
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c87ba, FUN_004c8872
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 316 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004c87ba, .text + (0x004c87ba - 0x401000)
.set FUN_004c8872, .text + (0x004c8872 - 0x401000)

.org 0x004c808f - 0x401000
.globl FUN_004c808f
FUN_004c808f:
    # block 0x004c808f: entry, 7 instruction(s), ends with jle to 0x004c80c4 (forward)
    push ebp                                     # 004c808f
    {load} mov ebp, esp                          # 004c8090
    sub esp, 0x38                                # 004c8092
    mov dword ptr [ebp - local_38], ecx          # 004c8095
    mov eax, dword ptr [ebp + arg_14]            # 004c8098
    cmp eax, dword ptr [ebp + arg_1c]            # 004c809b
    jle.d8 L_004c80c4                            # 004c809e
    # block 0x004c80a0: entered by fall-through of jle at 0x004c809e, 12 instruction(s), falls into the block at 0x004c80c4
    mov ecx, dword ptr [ebp + arg_14]            # 004c80a0
    mov dword ptr [ebp - local_14], ecx          # 004c80a3
    mov edx, dword ptr [ebp + arg_1c]            # 004c80a6
    mov dword ptr [ebp + arg_14], edx            # 004c80a9
    mov eax, dword ptr [ebp - local_14]          # 004c80ac
    mov dword ptr [ebp + arg_1c], eax            # 004c80af
    mov ecx, dword ptr [ebp + arg_10]            # 004c80b2
    mov dword ptr [ebp - local_14], ecx          # 004c80b5
    mov edx, dword ptr [ebp + arg_18]            # 004c80b8
    mov dword ptr [ebp + arg_10], edx            # 004c80bb
    mov eax, dword ptr [ebp - local_14]          # 004c80be
    mov dword ptr [ebp + arg_18], eax            # 004c80c1
L_004c80c4:
    # block 0x004c80c4: entered by jle at 0x004c809e, 14 instruction(s), ends with jge to 0x004c8102 (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 004c80c4
    imul ecx, dword ptr [ebp + arg_c]            # 004c80c7
    mov edx, dword ptr [ebp + arg_8]             # 004c80cb
    {load} add edx, ecx                          # 004c80ce
    movsx eax, word ptr [0x639895]               # 004c80d0
    mov ecx, dword ptr [ebp + arg_10]            # 004c80d7
    imul ecx, eax                                # 004c80da
    {load} add edx, ecx                          # 004c80dd
    mov dword ptr [ebp - local_30], edx          # 004c80df
    mov edx, dword ptr [ebp + arg_18]            # 004c80e2
    sub edx, dword ptr [ebp + arg_10]            # 004c80e5
    mov dword ptr [ebp - local_24], edx          # 004c80e8
    cmp dword ptr [ebp - local_24], 0x0          # 004c80eb
    jge.d8 L_004c8102                            # 004c80ef
    # block 0x004c80f1: entered by fall-through of jge at 0x004c80ef, 5 instruction(s), ends with forward jump to 0x004c8109
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c80f1
    mov eax, dword ptr [ebp - local_24]          # 004c80f8
    neg eax                                      # 004c80fb
    mov dword ptr [ebp - local_24], eax          # 004c80fd
    jmp.d8 L_004c8109                            # 004c8100
L_004c8102:
    # block 0x004c8102: entered by jge at 0x004c80ef, 1 instruction(s), falls into the block at 0x004c8109
    mov dword ptr [ebp - local_4], 0x1           # 004c8102
L_004c8109:
    # block 0x004c8109: entered by jmp at 0x004c8100, 5 instruction(s), ends with jne to 0x004c814c (forward)
    mov ecx, dword ptr [ebp + arg_1c]            # 004c8109
    sub ecx, dword ptr [ebp + arg_14]            # 004c810c
    mov dword ptr [ebp - local_20], ecx          # 004c810f
    cmp dword ptr [ebp - local_24], 0x0          # 004c8112
    jne.d8 L_004c814c                            # 004c8116
    # block 0x004c8118: entered by fall-through of jne at 0x004c8116, 2 instruction(s), ends with forward jump to 0x004c812a
    mov dword ptr [ebp - local_1c], 0x0          # 004c8118
    jmp.d8 L_004c812a                            # 004c811f
L_004c8121:
    # block 0x004c8121: entered by jmp at 0x004c8145, 3 instruction(s), falls into the block at 0x004c812a
    mov edx, dword ptr [ebp - local_1c]          # 004c8121
    add edx, 0x1                                 # 004c8124
    mov dword ptr [ebp - local_1c], edx          # 004c8127
L_004c812a:
    # block 0x004c812a: entered by jmp at 0x004c811f, 3 instruction(s), ends with jg to 0x004c8147 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c812a
    cmp eax, dword ptr [ebp - local_20]          # 004c812d
    jg.d8 L_004c8147                             # 004c8130
    # block 0x004c8132: entered by fall-through of jg at 0x004c8130, 7 instruction(s), ends with backward jump to 0x004c8121
    mov ecx, dword ptr [ebp - local_30]          # 004c8132
    mov dx, word ptr [ebp + arg_20]              # 004c8135
    mov word ptr [ecx], dx                       # 004c8139
    mov eax, dword ptr [ebp - local_30]          # 004c813c
    add eax, dword ptr [ebp + arg_c]             # 004c813f
    mov dword ptr [ebp - local_30], eax          # 004c8142
    jmp.d8 L_004c8121                            # 004c8145
L_004c8147:
    # block 0x004c8147: entered by jg at 0x004c8130, 1 instruction(s), ends with forward jump to 0x004c8402
    jmp.d32 L_004c8402                           # 004c8147
L_004c814c:
    # block 0x004c814c: entered by jne at 0x004c8116, 2 instruction(s), ends with jne to 0x004c8192 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004c814c
    jne.d8 L_004c8192                            # 004c8150
    # block 0x004c8152: entered by fall-through of jne at 0x004c8150, 2 instruction(s), ends with forward jump to 0x004c8164
    mov dword ptr [ebp - local_1c], 0x0          # 004c8152
    jmp.d8 L_004c8164                            # 004c8159
L_004c815b:
    # block 0x004c815b: entered by jmp at 0x004c818b, 3 instruction(s), falls into the block at 0x004c8164
    mov ecx, dword ptr [ebp - local_1c]          # 004c815b
    add ecx, 0x1                                 # 004c815e
    mov dword ptr [ebp - local_1c], ecx          # 004c8161
L_004c8164:
    # block 0x004c8164: entered by jmp at 0x004c8159, 3 instruction(s), ends with jg to 0x004c818d (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c8164
    cmp edx, dword ptr [ebp - local_24]          # 004c8167
    jg.d8 L_004c818d                             # 004c816a
    # block 0x004c816c: entered by fall-through of jg at 0x004c816a, 10 instruction(s), ends with backward jump to 0x004c815b
    mov eax, dword ptr [ebp - local_30]          # 004c816c
    mov cx, word ptr [ebp + arg_20]              # 004c816f
    mov word ptr [eax], cx                       # 004c8173
    movsx edx, word ptr [0x639895]               # 004c8176
    mov eax, dword ptr [ebp - local_4]           # 004c817d
    imul eax, edx                                # 004c8180
    mov ecx, dword ptr [ebp - local_30]          # 004c8183
    {load} add ecx, eax                          # 004c8186
    mov dword ptr [ebp - local_30], ecx          # 004c8188
    jmp.d8 L_004c815b                            # 004c818b
L_004c818d:
    # block 0x004c818d: entered by jg at 0x004c816a, 1 instruction(s), ends with forward jump to 0x004c8402
    jmp.d32 L_004c8402                           # 004c818d
L_004c8192:
    # block 0x004c8192: entered by jne at 0x004c8150, 3 instruction(s), ends with jne to 0x004c81df (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c8192
    cmp edx, dword ptr [ebp - local_20]          # 004c8195
    jne.d8 L_004c81df                            # 004c8198
    # block 0x004c819a: entered by fall-through of jne at 0x004c8198, 2 instruction(s), ends with forward jump to 0x004c81ac
    mov dword ptr [ebp - local_1c], 0x0          # 004c819a
    jmp.d8 L_004c81ac                            # 004c81a1
L_004c81a3:
    # block 0x004c81a3: entered by jmp at 0x004c81d8, 3 instruction(s), falls into the block at 0x004c81ac
    mov eax, dword ptr [ebp - local_1c]          # 004c81a3
    add eax, 0x1                                 # 004c81a6
    mov dword ptr [ebp - local_1c], eax          # 004c81a9
L_004c81ac:
    # block 0x004c81ac: entered by jmp at 0x004c81a1, 3 instruction(s), ends with jg to 0x004c81da (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c81ac
    cmp ecx, dword ptr [ebp - local_24]          # 004c81af
    jg.d8 L_004c81da                             # 004c81b2
    # block 0x004c81b4: entered by fall-through of jg at 0x004c81b2, 12 instruction(s), ends with backward jump to 0x004c81a3
    mov edx, dword ptr [ebp - local_30]          # 004c81b4
    mov ax, word ptr [ebp + arg_20]              # 004c81b7
    mov word ptr [edx], ax                       # 004c81bb
    movsx ecx, word ptr [0x639895]               # 004c81be
    mov edx, dword ptr [ebp - local_4]           # 004c81c5
    imul edx, ecx                                # 004c81c8
    mov eax, dword ptr [ebp + arg_c]             # 004c81cb
    {load} add eax, edx                          # 004c81ce
    mov ecx, dword ptr [ebp - local_30]          # 004c81d0
    {load} add ecx, eax                          # 004c81d3
    mov dword ptr [ebp - local_30], ecx          # 004c81d5
    jmp.d8 L_004c81a3                            # 004c81d8
L_004c81da:
    # block 0x004c81da: entered by jg at 0x004c81b2, 1 instruction(s), ends with forward jump to 0x004c8402
    jmp.d32 L_004c8402                           # 004c81da
L_004c81df:
    # block 0x004c81df: entered by jne at 0x004c8198, 3 instruction(s), ends with jl to 0x004c82f9 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c81df
    cmp edx, dword ptr [ebp - local_20]          # 004c81e2
    jl.d32 L_004c82f9                            # 004c81e5
    # block 0x004c81eb: entered by fall-through of jl at 0x004c81e5, 29 instruction(s), ends with jne to 0x004c8247 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c81eb
    cdq                                          # 004c81ee
    idiv dword ptr [ebp - local_20]              # 004c81ef
    mov dword ptr [ebp - local_8], eax           # 004c81f2
    mov eax, dword ptr [ebp - local_24]          # 004c81f5
    cdq                                          # 004c81f8
    idiv dword ptr [ebp - local_20]              # 004c81f9
    shl edx                                      # 004c81fc
    mov dword ptr [ebp - local_10], edx          # 004c81fe
    mov eax, dword ptr [ebp - local_20]          # 004c8201
    shl eax                                      # 004c8204
    mov dword ptr [ebp - local_34], eax          # 004c8206
    mov eax, dword ptr [ebp - local_24]          # 004c8209
    cdq                                          # 004c820c
    idiv dword ptr [ebp - local_20]              # 004c820d
    mov ecx, dword ptr [ebp - local_20]          # 004c8210
    shl ecx                                      # 004c8213
    {load} sub edx, ecx                          # 004c8215
    mov dword ptr [ebp - local_2c], edx          # 004c8217
    mov eax, dword ptr [ebp - local_8]           # 004c821a
    cdq                                          # 004c821d
    {load} sub eax, edx                          # 004c821e
    sar eax                                      # 004c8220
    add eax, 0x1                                 # 004c8222
    mov dword ptr [ebp - local_28], eax          # 004c8225
    mov edx, dword ptr [ebp - local_28]          # 004c8228
    mov dword ptr [ebp - local_18], edx          # 004c822b
    cmp dword ptr [ebp - local_10], 0x0          # 004c822e
    jne.d8 L_004c8247                            # 004c8232
    # block 0x004c8234: entered by fall-through of jne at 0x004c8232, 4 instruction(s), ends with jne to 0x004c8247 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c8234
    and eax, 0x1                                 # 004c8237
    test eax, eax                                # 004c823a
    jne.d8 L_004c8247                            # 004c823c
    # block 0x004c823e: entered by fall-through of jne at 0x004c823c, 3 instruction(s), falls into the block at 0x004c8247
    mov ecx, dword ptr [ebp - local_28]          # 004c823e
    sub ecx, 0x1                                 # 004c8241
    mov dword ptr [ebp - local_28], ecx          # 004c8244
L_004c8247:
    # block 0x004c8247: entered by jne at 0x004c8232; jne at 0x004c823c, 4 instruction(s), ends with je to 0x004c825a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c8247
    and edx, 0x1                                 # 004c824a
    test edx, edx                                # 004c824d
    je.d8 L_004c825a                             # 004c824f
    # block 0x004c8251: entered by fall-through of je at 0x004c824f, 3 instruction(s), falls into the block at 0x004c825a
    mov eax, dword ptr [ebp - local_2c]          # 004c8251
    add eax, dword ptr [ebp - local_20]          # 004c8254
    mov dword ptr [ebp - local_2c], eax          # 004c8257
L_004c825a:
    # block 0x004c825a: entered by je at 0x004c824f, 14 instruction(s), calls FUN_004c87ba, ends with forward jump to 0x004c8288
    mov cl, byte ptr [ebp + arg_20]              # 004c825a
    push ecx                                     # 004c825d
    mov edx, dword ptr [ebp - local_28]          # 004c825e
    push edx                                     # 004c8261
    mov eax, dword ptr [ebp - local_4]           # 004c8262
    push eax                                     # 004c8265
    mov ecx, dword ptr [ebp + arg_c]             # 004c8266
    push ecx                                     # 004c8269
    lea edx, [ebp - local_30]                    # 004c826a
    push edx                                     # 004c826d
    mov ecx, dword ptr [ebp - local_38]          # 004c826e
    call FUN_004c87ba                            # 004c8271
    mov dword ptr [ebp - local_1c], 0x0          # 004c8276
    jmp.d8 L_004c8288                            # 004c827d
L_004c827f:
    # block 0x004c827f: entered by jmp at 0x004c82d6, 3 instruction(s), falls into the block at 0x004c8288
    mov eax, dword ptr [ebp - local_1c]          # 004c827f
    add eax, 0x1                                 # 004c8282
    mov dword ptr [ebp - local_1c], eax          # 004c8285
L_004c8288:
    # block 0x004c8288: entered by jmp at 0x004c827d, 4 instruction(s), ends with jge to 0x004c82d8 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004c8288
    sub ecx, 0x1                                 # 004c828b
    cmp dword ptr [ebp - local_1c], ecx          # 004c828e
    jge.d8 L_004c82d8                            # 004c8291
    # block 0x004c8293: entered by fall-through of jge at 0x004c8291, 7 instruction(s), ends with jle to 0x004c82ba (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c8293
    mov dword ptr [ebp - local_c], edx           # 004c8296
    mov eax, dword ptr [ebp - local_2c]          # 004c8299
    add eax, dword ptr [ebp - local_10]          # 004c829c
    mov dword ptr [ebp - local_2c], eax          # 004c829f
    cmp dword ptr [ebp - local_2c], 0x0          # 004c82a2
    jle.d8 L_004c82ba                            # 004c82a6
    # block 0x004c82a8: entered by fall-through of jle at 0x004c82a6, 6 instruction(s), falls into the block at 0x004c82ba
    mov ecx, dword ptr [ebp - local_c]           # 004c82a8
    add ecx, 0x1                                 # 004c82ab
    mov dword ptr [ebp - local_c], ecx           # 004c82ae
    mov edx, dword ptr [ebp - local_2c]          # 004c82b1
    sub edx, dword ptr [ebp - local_34]          # 004c82b4
    mov dword ptr [ebp - local_2c], edx          # 004c82b7
L_004c82ba:
    # block 0x004c82ba: entered by jle at 0x004c82a6, 13 instruction(s), calls FUN_004c87ba, ends with backward jump to 0x004c827f
    mov al, byte ptr [ebp + arg_20]              # 004c82ba
    push eax                                     # 004c82bd
    mov ecx, dword ptr [ebp - local_c]           # 004c82be
    push ecx                                     # 004c82c1
    mov edx, dword ptr [ebp - local_4]           # 004c82c2
    push edx                                     # 004c82c5
    mov eax, dword ptr [ebp + arg_c]             # 004c82c6
    push eax                                     # 004c82c9
    lea ecx, [ebp - local_30]                    # 004c82ca
    push ecx                                     # 004c82cd
    mov ecx, dword ptr [ebp - local_38]          # 004c82ce
    call FUN_004c87ba                            # 004c82d1
    jmp.d8 L_004c827f                            # 004c82d6
L_004c82d8:
    # block 0x004c82d8: entered by jge at 0x004c8291, 13 instruction(s), calls FUN_004c87ba, ends with forward jump to 0x004c8402
    mov dl, byte ptr [ebp + arg_20]              # 004c82d8
    push edx                                     # 004c82db
    mov eax, dword ptr [ebp - local_18]          # 004c82dc
    push eax                                     # 004c82df
    mov ecx, dword ptr [ebp - local_4]           # 004c82e0
    push ecx                                     # 004c82e3
    mov edx, dword ptr [ebp + arg_c]             # 004c82e4
    push edx                                     # 004c82e7
    lea eax, [ebp - local_30]                    # 004c82e8
    push eax                                     # 004c82eb
    mov ecx, dword ptr [ebp - local_38]          # 004c82ec
    call FUN_004c87ba                            # 004c82ef
    jmp.d32 L_004c8402                           # 004c82f4
L_004c82f9:
    # block 0x004c82f9: entered by jl at 0x004c81e5, 29 instruction(s), ends with jne to 0x004c8355 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004c82f9
    cdq                                          # 004c82fc
    idiv dword ptr [ebp - local_24]              # 004c82fd
    mov dword ptr [ebp - local_8], eax           # 004c8300
    mov eax, dword ptr [ebp - local_20]          # 004c8303
    cdq                                          # 004c8306
    idiv dword ptr [ebp - local_24]              # 004c8307
    shl edx                                      # 004c830a
    mov dword ptr [ebp - local_10], edx          # 004c830c
    mov ecx, dword ptr [ebp - local_24]          # 004c830f
    shl ecx                                      # 004c8312
    mov dword ptr [ebp - local_34], ecx          # 004c8314
    mov eax, dword ptr [ebp - local_20]          # 004c8317
    cdq                                          # 004c831a
    idiv dword ptr [ebp - local_24]              # 004c831b
    mov eax, dword ptr [ebp - local_24]          # 004c831e
    shl eax                                      # 004c8321
    {load} sub edx, eax                          # 004c8323
    mov dword ptr [ebp - local_2c], edx          # 004c8325
    mov eax, dword ptr [ebp - local_8]           # 004c8328
    cdq                                          # 004c832b
    {load} sub eax, edx                          # 004c832c
    sar eax                                      # 004c832e
    add eax, 0x1                                 # 004c8330
    mov dword ptr [ebp - local_28], eax          # 004c8333
    mov ecx, dword ptr [ebp - local_28]          # 004c8336
    mov dword ptr [ebp - local_18], ecx          # 004c8339
    cmp dword ptr [ebp - local_10], 0x0          # 004c833c
    jne.d8 L_004c8355                            # 004c8340
    # block 0x004c8342: entered by fall-through of jne at 0x004c8340, 4 instruction(s), ends with jne to 0x004c8355 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c8342
    and edx, 0x1                                 # 004c8345
    test edx, edx                                # 004c8348
    jne.d8 L_004c8355                            # 004c834a
    # block 0x004c834c: entered by fall-through of jne at 0x004c834a, 3 instruction(s), falls into the block at 0x004c8355
    mov eax, dword ptr [ebp - local_28]          # 004c834c
    sub eax, 0x1                                 # 004c834f
    mov dword ptr [ebp - local_28], eax          # 004c8352
L_004c8355:
    # block 0x004c8355: entered by jne at 0x004c8340; jne at 0x004c834a, 4 instruction(s), ends with je to 0x004c8368 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c8355
    and ecx, 0x1                                 # 004c8358
    test ecx, ecx                                # 004c835b
    je.d8 L_004c8368                             # 004c835d
    # block 0x004c835f: entered by fall-through of je at 0x004c835d, 3 instruction(s), falls into the block at 0x004c8368
    mov edx, dword ptr [ebp - local_2c]          # 004c835f
    add edx, dword ptr [ebp - local_24]          # 004c8362
    mov dword ptr [ebp - local_2c], edx          # 004c8365
L_004c8368:
    # block 0x004c8368: entered by je at 0x004c835d, 14 instruction(s), calls FUN_004c8872, ends with forward jump to 0x004c8396
    mov al, byte ptr [ebp + arg_20]              # 004c8368
    push eax                                     # 004c836b
    mov ecx, dword ptr [ebp - local_28]          # 004c836c
    push ecx                                     # 004c836f
    mov edx, dword ptr [ebp - local_4]           # 004c8370
    push edx                                     # 004c8373
    mov eax, dword ptr [ebp + arg_c]             # 004c8374
    push eax                                     # 004c8377
    lea ecx, [ebp - local_30]                    # 004c8378
    push ecx                                     # 004c837b
    mov ecx, dword ptr [ebp - local_38]          # 004c837c
    call FUN_004c8872                            # 004c837f
    mov dword ptr [ebp - local_1c], 0x0          # 004c8384
    jmp.d8 L_004c8396                            # 004c838b
L_004c838d:
    # block 0x004c838d: entered by jmp at 0x004c83e4, 3 instruction(s), falls into the block at 0x004c8396
    mov edx, dword ptr [ebp - local_1c]          # 004c838d
    add edx, 0x1                                 # 004c8390
    mov dword ptr [ebp - local_1c], edx          # 004c8393
L_004c8396:
    # block 0x004c8396: entered by jmp at 0x004c838b, 4 instruction(s), ends with jge to 0x004c83e6 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c8396
    sub eax, 0x1                                 # 004c8399
    cmp dword ptr [ebp - local_1c], eax          # 004c839c
    jge.d8 L_004c83e6                            # 004c839f
    # block 0x004c83a1: entered by fall-through of jge at 0x004c839f, 7 instruction(s), ends with jle to 0x004c83c8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c83a1
    mov dword ptr [ebp - local_c], ecx           # 004c83a4
    mov edx, dword ptr [ebp - local_2c]          # 004c83a7
    add edx, dword ptr [ebp - local_10]          # 004c83aa
    mov dword ptr [ebp - local_2c], edx          # 004c83ad
    cmp dword ptr [ebp - local_2c], 0x0          # 004c83b0
    jle.d8 L_004c83c8                            # 004c83b4
    # block 0x004c83b6: entered by fall-through of jle at 0x004c83b4, 6 instruction(s), falls into the block at 0x004c83c8
    mov eax, dword ptr [ebp - local_c]           # 004c83b6
    add eax, 0x1                                 # 004c83b9
    mov dword ptr [ebp - local_c], eax           # 004c83bc
    mov ecx, dword ptr [ebp - local_2c]          # 004c83bf
    sub ecx, dword ptr [ebp - local_34]          # 004c83c2
    mov dword ptr [ebp - local_2c], ecx          # 004c83c5
L_004c83c8:
    # block 0x004c83c8: entered by jle at 0x004c83b4, 13 instruction(s), calls FUN_004c8872, ends with backward jump to 0x004c838d
    mov dl, byte ptr [ebp + arg_20]              # 004c83c8
    push edx                                     # 004c83cb
    mov eax, dword ptr [ebp - local_c]           # 004c83cc
    push eax                                     # 004c83cf
    mov ecx, dword ptr [ebp - local_4]           # 004c83d0
    push ecx                                     # 004c83d3
    mov edx, dword ptr [ebp + arg_c]             # 004c83d4
    push edx                                     # 004c83d7
    lea eax, [ebp - local_30]                    # 004c83d8
    push eax                                     # 004c83db
    mov ecx, dword ptr [ebp - local_38]          # 004c83dc
    call FUN_004c8872                            # 004c83df
    jmp.d8 L_004c838d                            # 004c83e4
L_004c83e6:
    # block 0x004c83e6: entered by jge at 0x004c839f, 12 instruction(s), calls FUN_004c8872, falls into the block at 0x004c8402
    mov cl, byte ptr [ebp + arg_20]              # 004c83e6
    push ecx                                     # 004c83e9
    mov edx, dword ptr [ebp - local_18]          # 004c83ea
    push edx                                     # 004c83ed
    mov eax, dword ptr [ebp - local_4]           # 004c83ee
    push eax                                     # 004c83f1
    mov ecx, dword ptr [ebp + arg_c]             # 004c83f2
    push ecx                                     # 004c83f5
    lea edx, [ebp - local_30]                    # 004c83f6
    push edx                                     # 004c83f9
    mov ecx, dword ptr [ebp - local_38]          # 004c83fa
    call FUN_004c8872                            # 004c83fd
L_004c8402:
    # block 0x004c8402: entered by jmp at 0x004c8147; jmp at 0x004c818d; jmp at 0x004c81da; jmp at 0x004c82f4, 3 instruction(s), ends with ret 0x1c
    {load} mov esp, ebp                          # 004c8402
    pop ebp                                      # 004c8404
    ret 0x1c                                     # 004c8405

