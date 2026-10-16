# FUN_004e412d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e412d
# extent:       0x004e412d-0x004e4337 (522 code bytes)
# span:         0x004e412d-0x004e4337 (code 522, tables 0, padding 0)
# sha256:       9a075219b2f088d7bf6c64a917313ca0b57b153cdeccb085bbd6ec5599f77e5d
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e412d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_1ca2, field_4528, field_4530, field_4d7d, field_53bf; [ecx + n] field_4, field_8, field_4528, field_4530, field_4d89, field_53bd; [edx + n] field_4, field_4530, field_4d81, field_4d85
# callees:      calls FUN_004ee2a9, FUN_004e22fd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 123 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_1ca2, 0x1ca2  # offset +0x1ca2
.equ field_4528, 0x4528  # offset +0x4528
.equ field_4530, 0x4530  # offset +0x4530
.equ field_4d7d, 0x4d7d  # offset +0x4d7d
.equ field_4d81, 0x4d81  # offset +0x4d81
.equ field_4d85, 0x4d85  # offset +0x4d85
.equ field_4d89, 0x4d89  # offset +0x4d89
.equ field_53bd, 0x53bd  # offset +0x53bd
.equ field_53bf, 0x53bf  # offset +0x53bf

# --- external targets -----------------------------------------------
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004ee2a9, .text + (0x004ee2a9 - 0x401000)

.org 0x004e412d - 0x401000
.globl FUN_004e412d
FUN_004e412d:
    # block 0x004e412d: entry, 7 instruction(s), ends with je to 0x004e4153 (forward)
    push ebp                                     # 004e412d
    {load} mov ebp, esp                          # 004e412e
    sub esp, 0x8                                 # 004e4130
    mov dword ptr [ebp - local_8], ecx           # 004e4133
    mov eax, dword ptr [ebp - local_8]           # 004e4136
    cmp dword ptr [eax + field_4528], 0x2        # 004e4139
    je.d8 L_004e4153                             # 004e4140
    # block 0x004e4142: entered by fall-through of je at 0x004e4140, 3 instruction(s), ends with je to 0x004e4153 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e4142
    cmp dword ptr [ecx + field_4528], 0x3        # 004e4145
    je.d8 L_004e4153                             # 004e414c
    # block 0x004e414e: entered by fall-through of je at 0x004e414c, 1 instruction(s), ends with forward jump to 0x004e4333
    jmp.d32 L_004e4333                           # 004e414e
L_004e4153:
    # block 0x004e4153: entered by je at 0x004e4140; je at 0x004e414c, 4 instruction(s), calls FUN_004ee2a9, ends with je to 0x004e4164 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e4153
    call FUN_004ee2a9                            # 004e4156
    test eax, eax                                # 004e415b
    je.d8 L_004e4164                             # 004e415d
    # block 0x004e415f: entered by fall-through of je at 0x004e415d, 1 instruction(s), ends with forward jump to 0x004e4333
    jmp.d32 L_004e4333                           # 004e415f
L_004e4164:
    # block 0x004e4164: entered by je at 0x004e415d, 2 instruction(s), ends with forward jump to 0x004e4178
    mov word ptr [ebp - local_4], 0x0            # 004e4164
    jmp.d8 L_004e4178                            # 004e416a
L_004e416c:
    # block 0x004e416c: entered by jmp at 0x004e4213, 3 instruction(s), falls into the block at 0x004e4178
    mov dx, word ptr [ebp - local_4]             # 004e416c
    add dx, 0x1                                  # 004e4170
    mov word ptr [ebp - local_4], dx             # 004e4174
L_004e4178:
    # block 0x004e4178: entered by jmp at 0x004e416a, 3 instruction(s), ends with jge to 0x004e4218 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e4178
    cmp eax, 0x1a                                # 004e417c
    jge.d32 L_004e4218                           # 004e417f
    # block 0x004e4185: entered by fall-through of jge at 0x004e417f, 13 instruction(s), calls FUN_004e22fd, ends with je to 0x004e4213 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e4185
    mov dx, word ptr [ecx + field_8]             # 004e4188
    push edx                                     # 004e418c
    mov eax, dword ptr [ebp - local_8]           # 004e418d
    mov cx, word ptr [eax + field_4]             # 004e4190
    push ecx                                     # 004e4194
    movsx edx, word ptr [ebp - local_4]          # 004e4195
    imul edx, edx, 0x18f                         # 004e4199
    mov eax, dword ptr [ebp - local_8]           # 004e419f
    lea ecx, [eax + edx + field_1ca2]            # 004e41a2
    call FUN_004e22fd                            # 004e41a9
    test eax, eax                                # 004e41ae
    je.d8 L_004e4213                             # 004e41b0
    # block 0x004e41b2: entered by fall-through of je at 0x004e41b0, 3 instruction(s), ends with jne to 0x004e41d6 (forward)
    movsx ecx, word ptr [0x583a29]               # 004e41b2
    cmp ecx, -0x1                                # 004e41b9
    jne.d8 L_004e41d6                            # 004e41bc
    # block 0x004e41be: entered by fall-through of jne at 0x004e41bc, 4 instruction(s), ends with forward jump to 0x004e41f0
    mov edx, dword ptr [0x5d0377]                # 004e41be
    mov dword ptr [0x5d162d], edx                # 004e41c4
    mov dword ptr [0x5b44f0], 0x4                # 004e41ca
    jmp.d8 L_004e41f0                            # 004e41d4
L_004e41d6:
    # block 0x004e41d6: entered by jne at 0x004e41bc, 5 instruction(s), falls into the block at 0x004e41f0
    mov eax, dword ptr [0x571ad3]                # 004e41d6
    mov dword ptr [0x5d162d], eax                # 004e41db
    movsx ecx, word ptr [0x583a29]               # 004e41e0
    add ecx, 0x25                                # 004e41e7
    mov dword ptr [0x5b44f0], ecx                # 004e41ea
L_004e41f0:
    # block 0x004e41f0: entered by jmp at 0x004e41d4, 7 instruction(s), ends with forward jump to 0x004e4333
    mov edx, dword ptr [0x5b44f0]                # 004e41f0
    shl edx, 0x5                                 # 004e41f6
    mov eax, dword ptr [0x5b44f4]                # 004e41f9
    shl eax, 0x4                                 # 004e41fe
    lea ecx, [edx + eax + 0x5b160c]              # 004e4201
    mov dword ptr [0x5d1631], ecx                # 004e4208
    jmp.d32 L_004e4333                           # 004e420e
L_004e4213:
    # block 0x004e4213: entered by je at 0x004e41b0, 1 instruction(s), ends with backward jump to 0x004e416c
    jmp.d32 L_004e416c                           # 004e4213
L_004e4218:
    # block 0x004e4218: entered by jge at 0x004e417f, 3 instruction(s), ends with je to 0x004e4240 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e4218
    cmp dword ptr [edx + field_4530], 0x9        # 004e421b
    je.d8 L_004e4240                             # 004e4222
    # block 0x004e4224: entered by fall-through of je at 0x004e4222, 3 instruction(s), ends with je to 0x004e4240 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e4224
    cmp dword ptr [eax + field_4530], 0xe        # 004e4227
    je.d8 L_004e4240                             # 004e422e
    # block 0x004e4230: entered by fall-through of je at 0x004e422e, 3 instruction(s), ends with jne to 0x004e4333 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e4230
    cmp dword ptr [ecx + field_4530], 0xd        # 004e4233
    jne.d32 L_004e4333                           # 004e423a
L_004e4240:
    # block 0x004e4240: entered by je at 0x004e4222; je at 0x004e422e; fall-through of jne at 0x004e423a, 2 instruction(s), ends with forward jump to 0x004e4254
    mov word ptr [ebp - local_4], 0x0            # 004e4240
    jmp.d8 L_004e4254                            # 004e4246
L_004e4248:
    # block 0x004e4248: entered by jmp at 0x004e432e, 3 instruction(s), falls into the block at 0x004e4254
    mov dx, word ptr [ebp - local_4]             # 004e4248
    add dx, 0x1                                  # 004e424c
    mov word ptr [ebp - local_4], dx             # 004e4250
L_004e4254:
    # block 0x004e4254: entered by jmp at 0x004e4246, 5 instruction(s), ends with jge to 0x004e4333 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e4254
    mov ecx, dword ptr [ebp - local_8]           # 004e4258
    movsx edx, word ptr [ecx + field_53bd]       # 004e425b
    {load} cmp eax, edx                          # 004e4262
    jge.d32 L_004e4333                           # 004e4264
    # block 0x004e426a: entered by fall-through of jge at 0x004e4264, 7 instruction(s), ends with jl to 0x004e432e (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e426a
    shl eax, 0x4                                 # 004e426e
    mov ecx, dword ptr [ebp - local_8]           # 004e4271
    mov edx, dword ptr [ebp - local_8]           # 004e4274
    mov ecx, dword ptr [ecx + field_8]           # 004e4277
    cmp ecx, dword ptr [edx + eax + field_4d81]  # 004e427a
    jl.d32 L_004e432e                            # 004e4281
    # block 0x004e4287: entered by fall-through of jl at 0x004e4281, 7 instruction(s), ends with jg to 0x004e432e (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4287
    shl edx, 0x4                                 # 004e428b
    mov eax, dword ptr [ebp - local_8]           # 004e428e
    mov ecx, dword ptr [ebp - local_8]           # 004e4291
    mov eax, dword ptr [eax + field_8]           # 004e4294
    cmp eax, dword ptr [ecx + edx + field_4d89]  # 004e4297
    jg.d32 L_004e432e                            # 004e429e
    # block 0x004e42a4: entered by fall-through of jg at 0x004e429e, 7 instruction(s), ends with jl to 0x004e432e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e42a4
    shl ecx, 0x4                                 # 004e42a8
    mov edx, dword ptr [ebp - local_8]           # 004e42ab
    mov eax, dword ptr [ebp - local_8]           # 004e42ae
    mov edx, dword ptr [edx + field_4]           # 004e42b1
    cmp edx, dword ptr [eax + ecx + field_4d7d]  # 004e42b4
    jl.d8 L_004e432e                             # 004e42bb
    # block 0x004e42bd: entered by fall-through of jl at 0x004e42bb, 7 instruction(s), ends with jg to 0x004e432e (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e42bd
    shl eax, 0x4                                 # 004e42c1
    mov ecx, dword ptr [ebp - local_8]           # 004e42c4
    mov edx, dword ptr [ebp - local_8]           # 004e42c7
    mov ecx, dword ptr [ecx + field_4]           # 004e42ca
    cmp ecx, dword ptr [edx + eax + field_4d85]  # 004e42cd
    jg.d8 L_004e432e                             # 004e42d4
    # block 0x004e42d6: entered by fall-through of jg at 0x004e42d4, 15 instruction(s), ends with forward jump to 0x004e4333
    mov edx, dword ptr [0x5d0377]                # 004e42d6
    mov dword ptr [0x5d162d], edx                # 004e42dc
    mov dword ptr [0x5b44f0], 0x4                # 004e42e2
    mov dword ptr [0x5b44f4], 0x1                # 004e42ec
    mov eax, dword ptr [0x5b44f0]                # 004e42f6
    shl eax, 0x5                                 # 004e42fb
    mov ecx, dword ptr [0x5b44f4]                # 004e42fe
    shl ecx, 0x4                                 # 004e4304
    lea edx, [eax + ecx + 0x5b160c]              # 004e4307
    mov dword ptr [0x5d1631], edx                # 004e430e
    mov dword ptr [0x5c39e5], 0x27d8             # 004e4314
    mov eax, dword ptr [ebp - local_8]           # 004e431e
    mov cx, word ptr [ebp - local_4]             # 004e4321
    mov word ptr [eax + field_53bf], cx          # 004e4325
    jmp.d8 L_004e4333                            # 004e432c
L_004e432e:
    # block 0x004e432e: entered by jl at 0x004e4281; jg at 0x004e429e; jl at 0x004e42bb; jg at 0x004e42d4, 1 instruction(s), ends with backward jump to 0x004e4248
    jmp.d32 L_004e4248                           # 004e432e
L_004e4333:
    # block 0x004e4333: entered by jmp at 0x004e414e; jmp at 0x004e415f; jmp at 0x004e420e; jne at 0x004e423a; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e4333
    pop ebp                                      # 004e4335
    ret                                          # 004e4336

