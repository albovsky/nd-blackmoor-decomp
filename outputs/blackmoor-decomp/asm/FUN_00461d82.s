# FUN_00461d82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461d82
# extent:       0x00461d82-0x00462567 (2021 code bytes)
# span:         0x00461d82-0x00462577 (code 2021, tables 16, padding 0)
# sha256:       db4580e66a3bfa7a60f2154ea5dc8a38dfe9b4bdb9fece637d35b5584a9f0d78
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00461d82
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_59, field_5b, field_5d, field_24a; [ecx + n] field_4, field_8, field_c, field_59, field_5b, field_5d; [edx + n] field_4, field_8, field_c, field_39, field_3b, field_4f, field_53, field_57, field_5b, field_5d
# callees:      calls FUN_00462b84
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 504 instruction(s), 9 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_39, 0x39  # offset +0x39
.equ field_3b, 0x3b  # offset +0x3b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_57, 0x57  # offset +0x57
.equ field_59, 0x59  # offset +0x59
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------
.set FUN_00462b84, .text + (0x00462b84 - 0x401000)

.org 0x00461d82 - 0x401000
.globl FUN_00461d82
FUN_00461d82:
    # block 0x00461d82: entry, 37 instruction(s), ends with ja to 0x0046255e (forward)
    push ebp                                     # 00461d82
    {load} mov ebp, esp                          # 00461d83
    sub esp, 0x10                                # 00461d85
    push esi                                     # 00461d88
    push edi                                     # 00461d89
    mov dword ptr [ebp - local_c], ecx           # 00461d8a
    mov eax, dword ptr [ebp - local_c]           # 00461d8d
    movsx ecx, word ptr [eax + field_1e]         # 00461d90
    imul ecx, ecx, 0x8d                          # 00461d94
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00461d9a
    mov dword ptr [ebp - local_4], edx           # 00461da0
    mov dword ptr [ebp - local_8], 0x0           # 00461da3
    mov eax, dword ptr [ebp - local_c]           # 00461daa
    movsx ecx, word ptr [eax + field_5b]         # 00461dad
    imul ecx, ecx, 0x140                         # 00461db1
    mov edx, dword ptr [ebp - local_c]           # 00461db7
    movsx eax, word ptr [edx + field_5d]         # 00461dba
    imul eax, eax, 0x28                          # 00461dbe
    lea ecx, [ecx + eax + 0x594dc9]              # 00461dc1
    mov edx, dword ptr [ebp - local_c]           # 00461dc8
    add edx, 0x29                                # 00461dcb
    mov eax, dword ptr [ecx]                     # 00461dce
    mov dword ptr [edx], eax                     # 00461dd0
    mov eax, dword ptr [ecx + field_4]           # 00461dd2
    mov dword ptr [edx + field_4], eax           # 00461dd5
    mov eax, dword ptr [ecx + field_8]           # 00461dd8
    mov dword ptr [edx + field_8], eax           # 00461ddb
    mov ecx, dword ptr [ecx + field_c]           # 00461dde
    mov dword ptr [edx + field_c], ecx           # 00461de1
    mov edx, dword ptr [ebp - local_c]           # 00461de4
    movsx eax, word ptr [edx + field_57]         # 00461de7
    mov dword ptr [ebp - local_10], eax          # 00461deb
    mov ecx, dword ptr [ebp - local_10]          # 00461dee
    sub ecx, 0x10                                # 00461df1
    mov dword ptr [ebp - local_10], ecx          # 00461df4
    cmp dword ptr [ebp - local_10], 0x3          # 00461df7
    ja.d32 L_0046255e                            # 00461dfb
    # block 0x00461e01: entered by fall-through of ja at 0x00461dfb, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x462567]
    mov edx, dword ptr [ebp - local_10]          # 00461e01
    jmp dword ptr [4*edx + SWTAB_00462567_VA]    # 00461e04
L_00461e0b:
    # block 0x00461e0b: entered by switch case, 48 instruction(s), ends with jne to 0x00461fdc (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461e0b
    movsx ecx, word ptr [eax + field_5b]         # 00461e0e
    imul ecx, ecx, 0x140                         # 00461e12
    mov edx, dword ptr [ebp - local_c]           # 00461e18
    movsx esi, word ptr [edx + field_5d]         # 00461e1b
    imul esi, esi, 0x28                          # 00461e1f
    mov eax, dword ptr [ebp - local_4]           # 00461e22
    movsx edi, word ptr [eax + field_24a]        # 00461e25
    mov edx, dword ptr [ebp - local_c]           # 00461e2c
    mov eax, dword ptr [edx + field_4f]          # 00461e2f
    cdq                                          # 00461e32
    idiv edi                                     # 00461e33
    mov ecx, dword ptr [ecx + esi + 0x594dc9]    # 00461e35
    {load} sub ecx, eax                          # 00461e3c
    mov edx, dword ptr [ebp - local_c]           # 00461e3e
    movsx eax, word ptr [edx + field_5d]         # 00461e41
    imul eax, eax, 0x28                          # 00461e45
    mov edx, dword ptr [ebp - local_c]           # 00461e48
    movsx edx, word ptr [edx + field_5b]         # 00461e4b
    imul edx, edx, 0x140                         # 00461e4f
    mov dword ptr [edx + eax + 0x594dc9], ecx    # 00461e55
    mov eax, dword ptr [ebp - local_c]           # 00461e5c
    movsx ecx, word ptr [eax + field_5b]         # 00461e5f
    imul ecx, ecx, 0x140                         # 00461e63
    mov edx, dword ptr [ebp - local_c]           # 00461e69
    movsx eax, word ptr [edx + field_5d]         # 00461e6c
    imul eax, eax, 0x28                          # 00461e70
    mov ecx, dword ptr [ecx + eax + 0x594dc9]    # 00461e73
    mov edx, dword ptr [ebp - local_c]           # 00461e7a
    add ecx, dword ptr [edx + field_4f]          # 00461e7d
    mov eax, dword ptr [ebp - local_c]           # 00461e80
    movsx edx, word ptr [eax + field_5b]         # 00461e83
    imul edx, edx, 0x140                         # 00461e87
    mov eax, dword ptr [ebp - local_c]           # 00461e8d
    movsx eax, word ptr [eax + field_5d]         # 00461e90
    imul eax, eax, 0x28                          # 00461e94
    mov dword ptr [edx + eax + 0x594dd1], ecx    # 00461e97
    mov ecx, dword ptr [ebp - local_c]           # 00461e9e
    mov dx, word ptr [ecx + field_59]            # 00461ea1
    add dx, 0x1                                  # 00461ea5
    mov eax, dword ptr [ebp - local_c]           # 00461ea9
    mov word ptr [eax + field_59], dx            # 00461eac
    mov ecx, dword ptr [ebp - local_c]           # 00461eb0
    movsx edx, word ptr [ecx + field_59]         # 00461eb3
    mov eax, dword ptr [ebp - local_4]           # 00461eb7
    movsx ecx, word ptr [eax + field_24a]        # 00461eba
    {load} cmp edx, ecx                          # 00461ec1
    jne.d32 L_00461fdc                           # 00461ec3
    # block 0x00461ec9: entered by fall-through of jne at 0x00461ec3, 16 instruction(s), ends with jne to 0x00461f2f (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461ec9
    movsx eax, word ptr [edx + field_5b]         # 00461ecc
    imul eax, eax, 0x140                         # 00461ed0
    mov ecx, dword ptr [ebp - local_c]           # 00461ed6
    movsx edx, word ptr [ecx + field_5d]         # 00461ed9
    imul edx, edx, 0x28                          # 00461edd
    mov word ptr [eax + edx + 0x594ddb], 0x0     # 00461ee0
    mov eax, dword ptr [ebp - local_c]           # 00461eea
    movsx ecx, word ptr [eax + field_5b]         # 00461eed
    imul ecx, ecx, 0x140                         # 00461ef1
    mov edx, dword ptr [ebp - local_c]           # 00461ef7
    movsx eax, word ptr [edx + field_5d]         # 00461efa
    imul eax, eax, 0x28                          # 00461efe
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461f01
    test ecx, ecx                                # 00461f09
    jne.d8 L_00461f2f                            # 00461f0b
    # block 0x00461f0d: entered by fall-through of jne at 0x00461f0b, 7 instruction(s), falls into the block at 0x00461f2f
    mov edx, dword ptr [ebp - local_c]           # 00461f0d
    movsx eax, word ptr [edx + field_5b]         # 00461f10
    imul eax, eax, 0x140                         # 00461f14
    mov ecx, dword ptr [ebp - local_c]           # 00461f1a
    movsx edx, word ptr [ecx + field_5d]         # 00461f1d
    imul edx, edx, 0x28                          # 00461f21
    mov dword ptr [eax + edx + 0x594db5], 0x0    # 00461f24
L_00461f2f:
    # block 0x00461f2f: entered by jne at 0x00461f0b, 43 instruction(s), calls FUN_00462b84, falls into the block at 0x00461fdc
    mov eax, dword ptr [ebp - local_c]           # 00461f2f
    movsx ecx, word ptr [eax + field_5b]         # 00461f32
    imul ecx, ecx, 0x140                         # 00461f36
    mov edx, dword ptr [ebp - local_c]           # 00461f3c
    movsx eax, word ptr [edx + field_5d]         # 00461f3f
    imul eax, eax, 0x28                          # 00461f43
    lea ecx, [ecx + eax + 0x594dc9]              # 00461f46
    push ecx                                     # 00461f4d
    push 0x0                                     # 00461f4e
    mov edx, dword ptr [ebp - local_c]           # 00461f50
    mov ax, word ptr [edx + field_5d]            # 00461f53
    push eax                                     # 00461f57
    mov ecx, dword ptr [ebp - local_c]           # 00461f58
    mov dx, word ptr [ecx + field_5b]            # 00461f5b
    push edx                                     # 00461f5f
    mov ecx, dword ptr [ebp - local_c]           # 00461f60
    call FUN_00462b84                            # 00461f63
    mov eax, dword ptr [ebp - local_c]           # 00461f68
    mov cx, word ptr [eax + field_5d]            # 00461f6b
    sub cx, 0x1                                  # 00461f6f
    mov edx, dword ptr [ebp - local_c]           # 00461f73
    mov word ptr [edx + field_5d], cx            # 00461f76
    mov eax, dword ptr [ebp - local_c]           # 00461f7a
    movsx ecx, word ptr [eax + field_5b]         # 00461f7d
    imul ecx, ecx, 0x140                         # 00461f81
    mov edx, dword ptr [ebp - local_c]           # 00461f87
    movsx eax, word ptr [edx + field_5d]         # 00461f8a
    imul eax, eax, 0x28                          # 00461f8e
    mov edx, dword ptr [ebp - local_c]           # 00461f91
    mov dx, word ptr [edx + field_39]            # 00461f94
    mov word ptr [ecx + eax + 0x594ddb], dx      # 00461f98
    mov eax, dword ptr [ebp - local_c]           # 00461fa0
    movsx ecx, word ptr [eax + field_5b]         # 00461fa3
    imul ecx, ecx, 0x140                         # 00461fa7
    mov edx, dword ptr [ebp - local_c]           # 00461fad
    movsx eax, word ptr [edx + field_5d]         # 00461fb0
    imul eax, eax, 0x28                          # 00461fb4
    mov dword ptr [ecx + eax + 0x594db5], 0x1    # 00461fb7
    mov ecx, dword ptr [ebp - local_c]           # 00461fc2
    mov word ptr [ecx + field_59], 0x0           # 00461fc5
    mov dword ptr [ebp - local_8], 0x1           # 00461fcb
    mov edx, dword ptr [ebp - local_c]           # 00461fd2
    mov dword ptr [edx + field_3b], 0x1          # 00461fd5
L_00461fdc:
    # block 0x00461fdc: entered by jne at 0x00461ec3, 1 instruction(s), ends with forward jump to 0x0046255e
    jmp.d32 L_0046255e                           # 00461fdc
L_00461fe1:
    # block 0x00461fe1: entered by switch case, 48 instruction(s), ends with jne to 0x004621b2 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461fe1
    movsx ecx, word ptr [eax + field_5b]         # 00461fe4
    imul ecx, ecx, 0x140                         # 00461fe8
    mov edx, dword ptr [ebp - local_c]           # 00461fee
    movsx esi, word ptr [edx + field_5d]         # 00461ff1
    imul esi, esi, 0x28                          # 00461ff5
    mov eax, dword ptr [ebp - local_4]           # 00461ff8
    movsx edi, word ptr [eax + field_24a]        # 00461ffb
    mov edx, dword ptr [ebp - local_c]           # 00462002
    mov eax, dword ptr [edx + field_53]          # 00462005
    cdq                                          # 00462008
    idiv edi                                     # 00462009
    mov ecx, dword ptr [ecx + esi + 0x594dcd]    # 0046200b
    {load} sub ecx, eax                          # 00462012
    mov edx, dword ptr [ebp - local_c]           # 00462014
    movsx eax, word ptr [edx + field_5d]         # 00462017
    imul eax, eax, 0x28                          # 0046201b
    mov edx, dword ptr [ebp - local_c]           # 0046201e
    movsx edx, word ptr [edx + field_5b]         # 00462021
    imul edx, edx, 0x140                         # 00462025
    mov dword ptr [edx + eax + 0x594dcd], ecx    # 0046202b
    mov eax, dword ptr [ebp - local_c]           # 00462032
    movsx ecx, word ptr [eax + field_5b]         # 00462035
    imul ecx, ecx, 0x140                         # 00462039
    mov edx, dword ptr [ebp - local_c]           # 0046203f
    movsx eax, word ptr [edx + field_5d]         # 00462042
    imul eax, eax, 0x28                          # 00462046
    mov ecx, dword ptr [ecx + eax + 0x594dcd]    # 00462049
    mov edx, dword ptr [ebp - local_c]           # 00462050
    add ecx, dword ptr [edx + field_53]          # 00462053
    mov eax, dword ptr [ebp - local_c]           # 00462056
    movsx edx, word ptr [eax + field_5b]         # 00462059
    imul edx, edx, 0x140                         # 0046205d
    mov eax, dword ptr [ebp - local_c]           # 00462063
    movsx eax, word ptr [eax + field_5d]         # 00462066
    imul eax, eax, 0x28                          # 0046206a
    mov dword ptr [edx + eax + 0x594dd5], ecx    # 0046206d
    mov ecx, dword ptr [ebp - local_c]           # 00462074
    mov dx, word ptr [ecx + field_59]            # 00462077
    add dx, 0x1                                  # 0046207b
    mov eax, dword ptr [ebp - local_c]           # 0046207f
    mov word ptr [eax + field_59], dx            # 00462082
    mov ecx, dword ptr [ebp - local_c]           # 00462086
    movsx edx, word ptr [ecx + field_59]         # 00462089
    mov eax, dword ptr [ebp - local_4]           # 0046208d
    movsx ecx, word ptr [eax + field_24a]        # 00462090
    {load} cmp edx, ecx                          # 00462097
    jne.d32 L_004621b2                           # 00462099
    # block 0x0046209f: entered by fall-through of jne at 0x00462099, 16 instruction(s), ends with jne to 0x00462105 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046209f
    movsx eax, word ptr [edx + field_5b]         # 004620a2
    imul eax, eax, 0x140                         # 004620a6
    mov ecx, dword ptr [ebp - local_c]           # 004620ac
    movsx edx, word ptr [ecx + field_5d]         # 004620af
    imul edx, edx, 0x28                          # 004620b3
    mov word ptr [eax + edx + 0x594ddb], 0x0     # 004620b6
    mov eax, dword ptr [ebp - local_c]           # 004620c0
    movsx ecx, word ptr [eax + field_5b]         # 004620c3
    imul ecx, ecx, 0x140                         # 004620c7
    mov edx, dword ptr [ebp - local_c]           # 004620cd
    movsx eax, word ptr [edx + field_5d]         # 004620d0
    imul eax, eax, 0x28                          # 004620d4
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 004620d7
    test ecx, ecx                                # 004620df
    jne.d8 L_00462105                            # 004620e1
    # block 0x004620e3: entered by fall-through of jne at 0x004620e1, 7 instruction(s), falls into the block at 0x00462105
    mov edx, dword ptr [ebp - local_c]           # 004620e3
    movsx eax, word ptr [edx + field_5b]         # 004620e6
    imul eax, eax, 0x140                         # 004620ea
    mov ecx, dword ptr [ebp - local_c]           # 004620f0
    movsx edx, word ptr [ecx + field_5d]         # 004620f3
    imul edx, edx, 0x28                          # 004620f7
    mov dword ptr [eax + edx + 0x594db5], 0x0    # 004620fa
L_00462105:
    # block 0x00462105: entered by jne at 0x004620e1, 43 instruction(s), calls FUN_00462b84, falls into the block at 0x004621b2
    mov eax, dword ptr [ebp - local_c]           # 00462105
    movsx ecx, word ptr [eax + field_5b]         # 00462108
    imul ecx, ecx, 0x140                         # 0046210c
    mov edx, dword ptr [ebp - local_c]           # 00462112
    movsx eax, word ptr [edx + field_5d]         # 00462115
    imul eax, eax, 0x28                          # 00462119
    lea ecx, [ecx + eax + 0x594dc9]              # 0046211c
    push ecx                                     # 00462123
    push 0x0                                     # 00462124
    mov edx, dword ptr [ebp - local_c]           # 00462126
    mov ax, word ptr [edx + field_5d]            # 00462129
    push eax                                     # 0046212d
    mov ecx, dword ptr [ebp - local_c]           # 0046212e
    mov dx, word ptr [ecx + field_5b]            # 00462131
    push edx                                     # 00462135
    mov ecx, dword ptr [ebp - local_c]           # 00462136
    call FUN_00462b84                            # 00462139
    mov eax, dword ptr [ebp - local_c]           # 0046213e
    mov cx, word ptr [eax + field_5b]            # 00462141
    sub cx, 0x1                                  # 00462145
    mov edx, dword ptr [ebp - local_c]           # 00462149
    mov word ptr [edx + field_5b], cx            # 0046214c
    mov eax, dword ptr [ebp - local_c]           # 00462150
    movsx ecx, word ptr [eax + field_5b]         # 00462153
    imul ecx, ecx, 0x140                         # 00462157
    mov edx, dword ptr [ebp - local_c]           # 0046215d
    movsx eax, word ptr [edx + field_5d]         # 00462160
    imul eax, eax, 0x28                          # 00462164
    mov edx, dword ptr [ebp - local_c]           # 00462167
    mov dx, word ptr [edx + field_39]            # 0046216a
    mov word ptr [ecx + eax + 0x594ddb], dx      # 0046216e
    mov eax, dword ptr [ebp - local_c]           # 00462176
    movsx ecx, word ptr [eax + field_5b]         # 00462179
    imul ecx, ecx, 0x140                         # 0046217d
    mov edx, dword ptr [ebp - local_c]           # 00462183
    movsx eax, word ptr [edx + field_5d]         # 00462186
    imul eax, eax, 0x28                          # 0046218a
    mov dword ptr [ecx + eax + 0x594db5], 0x1    # 0046218d
    mov ecx, dword ptr [ebp - local_c]           # 00462198
    mov word ptr [ecx + field_59], 0x0           # 0046219b
    mov dword ptr [ebp - local_8], 0x1           # 004621a1
    mov edx, dword ptr [ebp - local_c]           # 004621a8
    mov dword ptr [edx + field_3b], 0x1          # 004621ab
L_004621b2:
    # block 0x004621b2: entered by jne at 0x00462099, 1 instruction(s), ends with forward jump to 0x0046255e
    jmp.d32 L_0046255e                           # 004621b2
L_004621b7:
    # block 0x004621b7: entered by switch case, 48 instruction(s), ends with jne to 0x00462388 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004621b7
    movsx ecx, word ptr [eax + field_5b]         # 004621ba
    imul ecx, ecx, 0x140                         # 004621be
    mov edx, dword ptr [ebp - local_c]           # 004621c4
    movsx esi, word ptr [edx + field_5d]         # 004621c7
    imul esi, esi, 0x28                          # 004621cb
    mov eax, dword ptr [ebp - local_4]           # 004621ce
    movsx edi, word ptr [eax + field_24a]        # 004621d1
    mov edx, dword ptr [ebp - local_c]           # 004621d8
    mov eax, dword ptr [edx + field_53]          # 004621db
    cdq                                          # 004621de
    idiv edi                                     # 004621df
    mov ecx, dword ptr [ecx + esi + 0x594dcd]    # 004621e1
    {load} add ecx, eax                          # 004621e8
    mov edx, dword ptr [ebp - local_c]           # 004621ea
    movsx eax, word ptr [edx + field_5d]         # 004621ed
    imul eax, eax, 0x28                          # 004621f1
    mov edx, dword ptr [ebp - local_c]           # 004621f4
    movsx edx, word ptr [edx + field_5b]         # 004621f7
    imul edx, edx, 0x140                         # 004621fb
    mov dword ptr [edx + eax + 0x594dcd], ecx    # 00462201
    mov eax, dword ptr [ebp - local_c]           # 00462208
    movsx ecx, word ptr [eax + field_5b]         # 0046220b
    imul ecx, ecx, 0x140                         # 0046220f
    mov edx, dword ptr [ebp - local_c]           # 00462215
    movsx eax, word ptr [edx + field_5d]         # 00462218
    imul eax, eax, 0x28                          # 0046221c
    mov ecx, dword ptr [ecx + eax + 0x594dcd]    # 0046221f
    mov edx, dword ptr [ebp - local_c]           # 00462226
    add ecx, dword ptr [edx + field_53]          # 00462229
    mov eax, dword ptr [ebp - local_c]           # 0046222c
    movsx edx, word ptr [eax + field_5b]         # 0046222f
    imul edx, edx, 0x140                         # 00462233
    mov eax, dword ptr [ebp - local_c]           # 00462239
    movsx eax, word ptr [eax + field_5d]         # 0046223c
    imul eax, eax, 0x28                          # 00462240
    mov dword ptr [edx + eax + 0x594dd5], ecx    # 00462243
    mov ecx, dword ptr [ebp - local_c]           # 0046224a
    mov dx, word ptr [ecx + field_59]            # 0046224d
    add dx, 0x1                                  # 00462251
    mov eax, dword ptr [ebp - local_c]           # 00462255
    mov word ptr [eax + field_59], dx            # 00462258
    mov ecx, dword ptr [ebp - local_c]           # 0046225c
    movsx edx, word ptr [ecx + field_59]         # 0046225f
    mov eax, dword ptr [ebp - local_4]           # 00462263
    movsx ecx, word ptr [eax + field_24a]        # 00462266
    {load} cmp edx, ecx                          # 0046226d
    jne.d32 L_00462388                           # 0046226f
    # block 0x00462275: entered by fall-through of jne at 0x0046226f, 16 instruction(s), ends with jne to 0x004622db (forward)
    mov edx, dword ptr [ebp - local_c]           # 00462275
    movsx eax, word ptr [edx + field_5b]         # 00462278
    imul eax, eax, 0x140                         # 0046227c
    mov ecx, dword ptr [ebp - local_c]           # 00462282
    movsx edx, word ptr [ecx + field_5d]         # 00462285
    imul edx, edx, 0x28                          # 00462289
    mov word ptr [eax + edx + 0x594ddb], 0x0     # 0046228c
    mov eax, dword ptr [ebp - local_c]           # 00462296
    movsx ecx, word ptr [eax + field_5b]         # 00462299
    imul ecx, ecx, 0x140                         # 0046229d
    mov edx, dword ptr [ebp - local_c]           # 004622a3
    movsx eax, word ptr [edx + field_5d]         # 004622a6
    imul eax, eax, 0x28                          # 004622aa
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 004622ad
    test ecx, ecx                                # 004622b5
    jne.d8 L_004622db                            # 004622b7
    # block 0x004622b9: entered by fall-through of jne at 0x004622b7, 7 instruction(s), falls into the block at 0x004622db
    mov edx, dword ptr [ebp - local_c]           # 004622b9
    movsx eax, word ptr [edx + field_5b]         # 004622bc
    imul eax, eax, 0x140                         # 004622c0
    mov ecx, dword ptr [ebp - local_c]           # 004622c6
    movsx edx, word ptr [ecx + field_5d]         # 004622c9
    imul edx, edx, 0x28                          # 004622cd
    mov dword ptr [eax + edx + 0x594db5], 0x0    # 004622d0
L_004622db:
    # block 0x004622db: entered by jne at 0x004622b7, 43 instruction(s), calls FUN_00462b84, falls into the block at 0x00462388
    mov eax, dword ptr [ebp - local_c]           # 004622db
    movsx ecx, word ptr [eax + field_5b]         # 004622de
    imul ecx, ecx, 0x140                         # 004622e2
    mov edx, dword ptr [ebp - local_c]           # 004622e8
    movsx eax, word ptr [edx + field_5d]         # 004622eb
    imul eax, eax, 0x28                          # 004622ef
    lea ecx, [ecx + eax + 0x594dc9]              # 004622f2
    push ecx                                     # 004622f9
    push 0x0                                     # 004622fa
    mov edx, dword ptr [ebp - local_c]           # 004622fc
    mov ax, word ptr [edx + field_5d]            # 004622ff
    push eax                                     # 00462303
    mov ecx, dword ptr [ebp - local_c]           # 00462304
    mov dx, word ptr [ecx + field_5b]            # 00462307
    push edx                                     # 0046230b
    mov ecx, dword ptr [ebp - local_c]           # 0046230c
    call FUN_00462b84                            # 0046230f
    mov eax, dword ptr [ebp - local_c]           # 00462314
    mov cx, word ptr [eax + field_5b]            # 00462317
    add cx, 0x1                                  # 0046231b
    mov edx, dword ptr [ebp - local_c]           # 0046231f
    mov word ptr [edx + field_5b], cx            # 00462322
    mov eax, dword ptr [ebp - local_c]           # 00462326
    movsx ecx, word ptr [eax + field_5b]         # 00462329
    imul ecx, ecx, 0x140                         # 0046232d
    mov edx, dword ptr [ebp - local_c]           # 00462333
    movsx eax, word ptr [edx + field_5d]         # 00462336
    imul eax, eax, 0x28                          # 0046233a
    mov edx, dword ptr [ebp - local_c]           # 0046233d
    mov dx, word ptr [edx + field_39]            # 00462340
    mov word ptr [ecx + eax + 0x594ddb], dx      # 00462344
    mov eax, dword ptr [ebp - local_c]           # 0046234c
    movsx ecx, word ptr [eax + field_5b]         # 0046234f
    imul ecx, ecx, 0x140                         # 00462353
    mov edx, dword ptr [ebp - local_c]           # 00462359
    movsx eax, word ptr [edx + field_5d]         # 0046235c
    imul eax, eax, 0x28                          # 00462360
    mov dword ptr [ecx + eax + 0x594db5], 0x1    # 00462363
    mov ecx, dword ptr [ebp - local_c]           # 0046236e
    mov word ptr [ecx + field_59], 0x0           # 00462371
    mov dword ptr [ebp - local_8], 0x1           # 00462377
    mov edx, dword ptr [ebp - local_c]           # 0046237e
    mov dword ptr [edx + field_3b], 0x1          # 00462381
L_00462388:
    # block 0x00462388: entered by jne at 0x0046226f, 1 instruction(s), ends with forward jump to 0x0046255e
    jmp.d32 L_0046255e                           # 00462388
L_0046238d:
    # block 0x0046238d: entered by switch case, 48 instruction(s), ends with jne to 0x0046255e (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046238d
    movsx ecx, word ptr [eax + field_5b]         # 00462390
    imul ecx, ecx, 0x140                         # 00462394
    mov edx, dword ptr [ebp - local_c]           # 0046239a
    movsx esi, word ptr [edx + field_5d]         # 0046239d
    imul esi, esi, 0x28                          # 004623a1
    mov eax, dword ptr [ebp - local_4]           # 004623a4
    movsx edi, word ptr [eax + field_24a]        # 004623a7
    mov edx, dword ptr [ebp - local_c]           # 004623ae
    mov eax, dword ptr [edx + field_4f]          # 004623b1
    cdq                                          # 004623b4
    idiv edi                                     # 004623b5
    mov ecx, dword ptr [ecx + esi + 0x594dc9]    # 004623b7
    {load} add ecx, eax                          # 004623be
    mov edx, dword ptr [ebp - local_c]           # 004623c0
    movsx eax, word ptr [edx + field_5d]         # 004623c3
    imul eax, eax, 0x28                          # 004623c7
    mov edx, dword ptr [ebp - local_c]           # 004623ca
    movsx edx, word ptr [edx + field_5b]         # 004623cd
    imul edx, edx, 0x140                         # 004623d1
    mov dword ptr [edx + eax + 0x594dc9], ecx    # 004623d7
    mov eax, dword ptr [ebp - local_c]           # 004623de
    movsx ecx, word ptr [eax + field_5b]         # 004623e1
    imul ecx, ecx, 0x140                         # 004623e5
    mov edx, dword ptr [ebp - local_c]           # 004623eb
    movsx eax, word ptr [edx + field_5d]         # 004623ee
    imul eax, eax, 0x28                          # 004623f2
    mov ecx, dword ptr [ecx + eax + 0x594dc9]    # 004623f5
    mov edx, dword ptr [ebp - local_c]           # 004623fc
    add ecx, dword ptr [edx + field_4f]          # 004623ff
    mov eax, dword ptr [ebp - local_c]           # 00462402
    movsx edx, word ptr [eax + field_5b]         # 00462405
    imul edx, edx, 0x140                         # 00462409
    mov eax, dword ptr [ebp - local_c]           # 0046240f
    movsx eax, word ptr [eax + field_5d]         # 00462412
    imul eax, eax, 0x28                          # 00462416
    mov dword ptr [edx + eax + 0x594dd1], ecx    # 00462419
    mov ecx, dword ptr [ebp - local_c]           # 00462420
    mov dx, word ptr [ecx + field_59]            # 00462423
    add dx, 0x1                                  # 00462427
    mov eax, dword ptr [ebp - local_c]           # 0046242b
    mov word ptr [eax + field_59], dx            # 0046242e
    mov ecx, dword ptr [ebp - local_c]           # 00462432
    movsx edx, word ptr [ecx + field_59]         # 00462435
    mov eax, dword ptr [ebp - local_4]           # 00462439
    movsx ecx, word ptr [eax + field_24a]        # 0046243c
    {load} cmp edx, ecx                          # 00462443
    jne.d32 L_0046255e                           # 00462445
    # block 0x0046244b: entered by fall-through of jne at 0x00462445, 16 instruction(s), ends with jne to 0x004624b1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046244b
    movsx eax, word ptr [edx + field_5b]         # 0046244e
    imul eax, eax, 0x140                         # 00462452
    mov ecx, dword ptr [ebp - local_c]           # 00462458
    movsx edx, word ptr [ecx + field_5d]         # 0046245b
    imul edx, edx, 0x28                          # 0046245f
    mov word ptr [eax + edx + 0x594ddb], 0x0     # 00462462
    mov eax, dword ptr [ebp - local_c]           # 0046246c
    movsx ecx, word ptr [eax + field_5b]         # 0046246f
    imul ecx, ecx, 0x140                         # 00462473
    mov edx, dword ptr [ebp - local_c]           # 00462479
    movsx eax, word ptr [edx + field_5d]         # 0046247c
    imul eax, eax, 0x28                          # 00462480
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00462483
    test ecx, ecx                                # 0046248b
    jne.d8 L_004624b1                            # 0046248d
    # block 0x0046248f: entered by fall-through of jne at 0x0046248d, 7 instruction(s), falls into the block at 0x004624b1
    mov edx, dword ptr [ebp - local_c]           # 0046248f
    movsx eax, word ptr [edx + field_5b]         # 00462492
    imul eax, eax, 0x140                         # 00462496
    mov ecx, dword ptr [ebp - local_c]           # 0046249c
    movsx edx, word ptr [ecx + field_5d]         # 0046249f
    imul edx, edx, 0x28                          # 004624a3
    mov dword ptr [eax + edx + 0x594db5], 0x0    # 004624a6
L_004624b1:
    # block 0x004624b1: entered by jne at 0x0046248d, 43 instruction(s), calls FUN_00462b84, falls into the block at 0x0046255e
    mov eax, dword ptr [ebp - local_c]           # 004624b1
    movsx ecx, word ptr [eax + field_5b]         # 004624b4
    imul ecx, ecx, 0x140                         # 004624b8
    mov edx, dword ptr [ebp - local_c]           # 004624be
    movsx eax, word ptr [edx + field_5d]         # 004624c1
    imul eax, eax, 0x28                          # 004624c5
    lea ecx, [ecx + eax + 0x594dc9]              # 004624c8
    push ecx                                     # 004624cf
    push 0x0                                     # 004624d0
    mov edx, dword ptr [ebp - local_c]           # 004624d2
    mov ax, word ptr [edx + field_5d]            # 004624d5
    push eax                                     # 004624d9
    mov ecx, dword ptr [ebp - local_c]           # 004624da
    mov dx, word ptr [ecx + field_5b]            # 004624dd
    push edx                                     # 004624e1
    mov ecx, dword ptr [ebp - local_c]           # 004624e2
    call FUN_00462b84                            # 004624e5
    mov eax, dword ptr [ebp - local_c]           # 004624ea
    mov cx, word ptr [eax + field_5d]            # 004624ed
    add cx, 0x1                                  # 004624f1
    mov edx, dword ptr [ebp - local_c]           # 004624f5
    mov word ptr [edx + field_5d], cx            # 004624f8
    mov eax, dword ptr [ebp - local_c]           # 004624fc
    movsx ecx, word ptr [eax + field_5b]         # 004624ff
    imul ecx, ecx, 0x140                         # 00462503
    mov edx, dword ptr [ebp - local_c]           # 00462509
    movsx eax, word ptr [edx + field_5d]         # 0046250c
    imul eax, eax, 0x28                          # 00462510
    mov edx, dword ptr [ebp - local_c]           # 00462513
    mov dx, word ptr [edx + field_39]            # 00462516
    mov word ptr [ecx + eax + 0x594ddb], dx      # 0046251a
    mov eax, dword ptr [ebp - local_c]           # 00462522
    movsx ecx, word ptr [eax + field_5b]         # 00462525
    imul ecx, ecx, 0x140                         # 00462529
    mov edx, dword ptr [ebp - local_c]           # 0046252f
    movsx eax, word ptr [edx + field_5d]         # 00462532
    imul eax, eax, 0x28                          # 00462536
    mov dword ptr [ecx + eax + 0x594db5], 0x1    # 00462539
    mov ecx, dword ptr [ebp - local_c]           # 00462544
    mov word ptr [ecx + field_59], 0x0           # 00462547
    mov dword ptr [ebp - local_8], 0x1           # 0046254d
    mov edx, dword ptr [ebp - local_c]           # 00462554
    mov dword ptr [edx + field_3b], 0x1          # 00462557
L_0046255e:
    # block 0x0046255e: entered by ja at 0x00461dfb; jmp at 0x00461fdc; jmp at 0x004621b2; jmp at 0x00462388; more, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 0046255e
    pop edi                                      # 00462561
    pop esi                                      # 00462562
    {load} mov esp, ebp                          # 00462563
    pop ebp                                      # 00462565
    ret                                          # 00462566

# --- data items (not part of the function) -------------------------
.org 0x00462567 - 0x401000
SWTAB_00462567:  # 4 case address(es)
    .long L_00461e0b - .text + 0x401000
    .long L_00461fe1 - .text + 0x401000
    .long L_004621b7 - .text + 0x401000
    .long L_0046238d - .text + 0x401000
.set SWTAB_00462567_VA, SWTAB_00462567 - .text + 0x401000

