# FUN_004cb058
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb058
# extent:       0x004cb058-0x004cb3ab (851 code bytes)
# span:         0x004cb058-0x004cb3ab (code 851, tables 0, padding 0)
# sha256:       568624cd62497da9fc1e586881fcf96b7ebac155ecb597534087bfeef8da33f8
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cb058_hit_test
# naming:       native port src/original_methods_fl25b.c:m4cb058_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4cb058_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25b-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7, field_9, field_12, field_16, field_1a, field_1e, field_5f, field_126, field_132, field_152, field_154; [ecx + n] field_4, field_8, field_c, field_10, field_12, field_16, field_5f, field_126, field_132, field_14e, field_152; [edx + n] field_2, field_4, field_7, field_e, field_12, field_16, field_126, field_152, field_154, field_15c
# callees:      calls FUN_004ea06c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25b.c:m4cb058_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 191 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_7, 0x7  # offset +0x7
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_5f, 0x5f  # offset +0x5f
.equ field_126, 0x126  # offset +0x126
.equ field_132, 0x132  # offset +0x132
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152
.equ field_154, 0x154  # offset +0x154
.equ field_15c, 0x15c  # offset +0x15c

# --- external targets -----------------------------------------------
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)

.org 0x004cb058 - 0x401000
.globl FUN_004cb058
FUN_004cb058:
    # block 0x004cb058: entry, 11 instruction(s), ends with je to 0x004cb3a3 (forward)
    push ebp                                     # 004cb058
    {load} mov ebp, esp                          # 004cb059
    push ecx                                     # 004cb05b
    mov dword ptr [ebp - local_4], ecx           # 004cb05c
    mov eax, dword ptr [ebp - local_4]           # 004cb05f
    mov dword ptr [eax + field_154], 0x0         # 004cb062
    mov ecx, dword ptr [ebp - local_4]           # 004cb06c
    mov dword ptr [ecx + field_14e], 0x0         # 004cb06f
    mov edx, dword ptr [ebp - local_4]           # 004cb079
    cmp dword ptr [edx + field_e], 0x0           # 004cb07c
    je.d32 L_004cb3a3                            # 004cb080
    # block 0x004cb086: entered by fall-through of je at 0x004cb080, 5 instruction(s), ends with je to 0x004cb0e2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb086
    movsx ecx, word ptr [eax + field_152]        # 004cb089
    movsx edx, word ptr [0x583a29]               # 004cb090
    {load} cmp ecx, edx                          # 004cb097
    je.d8 L_004cb0e2                             # 004cb099
    # block 0x004cb09b: entered by fall-through of je at 0x004cb099, 5 instruction(s), ends with jne to 0x004cb0e2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb09b
    mov ecx, dword ptr [eax + field_16]          # 004cb09e
    movsx edx, word ptr [ecx + field_5f]         # 004cb0a1
    cmp edx, 0xc8                                # 004cb0a5
    jne.d8 L_004cb0e2                            # 004cb0ab
    # block 0x004cb0ad: entered by fall-through of jne at 0x004cb0ab, 4 instruction(s), ends with je to 0x004cb0e2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb0ad
    movsx ecx, word ptr [eax + field_152]        # 004cb0b0
    cmp ecx, -0x1                                # 004cb0b7
    je.d8 L_004cb0e2                             # 004cb0ba
    # block 0x004cb0bc: entered by fall-through of je at 0x004cb0ba, 8 instruction(s), calls FUN_004ea06c, falls into the block at 0x004cb0e2
    mov edx, dword ptr [ebp - local_4]           # 004cb0bc
    mov ax, word ptr [edx + field_152]           # 004cb0bf
    push eax                                     # 004cb0c6
    mov ecx, 0x571442                            # 004cb0c7
    call FUN_004ea06c                            # 004cb0cc
    mov ecx, dword ptr [ebp - local_4]           # 004cb0d1
    mov dx, word ptr [ecx + field_152]           # 004cb0d4
    mov word ptr [0x583a29], dx                  # 004cb0db
L_004cb0e2:
    # block 0x004cb0e2: entered by je at 0x004cb099; jne at 0x004cb0ab; je at 0x004cb0ba, 3 instruction(s), ends with je to 0x004cb3a3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb0e2
    cmp dword ptr [eax + field_12], 0x0          # 004cb0e5
    je.d32 L_004cb3a3                            # 004cb0e9
    # block 0x004cb0ef: entered by fall-through of je at 0x004cb0e9, 3 instruction(s), ends with je to 0x004cb3a3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb0ef
    cmp dword ptr [ecx + field_16], 0x0          # 004cb0f2
    je.d32 L_004cb3a3                            # 004cb0f6
    # block 0x004cb0fc: entered by fall-through of je at 0x004cb0f6, 3 instruction(s), ends with je to 0x004cb3a3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb0fc
    cmp dword ptr [edx + field_15c], 0x0         # 004cb0ff
    je.d32 L_004cb3a3                            # 004cb106
    # block 0x004cb10c: entered by fall-through of je at 0x004cb106, 3 instruction(s), ends with forward jump to 0x004cb130
    mov eax, dword ptr [ebp - local_4]           # 004cb10c
    mov dword ptr [eax + field_132], 0x0         # 004cb10f
    jmp.d8 L_004cb130                            # 004cb119
L_004cb11b:
    # block 0x004cb11b: entered by jmp at 0x004cb2b0, 5 instruction(s), falls into the block at 0x004cb130
    mov ecx, dword ptr [ebp - local_4]           # 004cb11b
    mov edx, dword ptr [ecx + field_132]         # 004cb11e
    add edx, 0x1                                 # 004cb124
    mov eax, dword ptr [ebp - local_4]           # 004cb127
    mov dword ptr [eax + field_132], edx         # 004cb12a
L_004cb130:
    # block 0x004cb130: entered by jmp at 0x004cb119, 6 instruction(s), ends with jge to 0x004cb2b5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb130
    mov edx, dword ptr [ecx + field_12]          # 004cb133
    movsx eax, word ptr [edx + field_2]          # 004cb136
    mov ecx, dword ptr [ebp - local_4]           # 004cb13a
    cmp dword ptr [ecx + field_132], eax         # 004cb13d
    jge.d32 L_004cb2b5                           # 004cb143
    # block 0x004cb149: entered by fall-through of jge at 0x004cb143, 14 instruction(s), ends with jl to 0x004cb2b0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb149
    mov eax, dword ptr [edx + field_12]          # 004cb14c
    mov ecx, dword ptr [ebp - local_4]           # 004cb14f
    mov edx, dword ptr [ecx + field_132]         # 004cb152
    imul edx, edx, 0x18                          # 004cb158
    mov eax, dword ptr [eax + field_9]           # 004cb15b
    {load} add eax, edx                          # 004cb15e
    mov ecx, dword ptr [ebp - local_4]           # 004cb160
    mov dword ptr [ecx + field_126], eax         # 004cb163
    movsx edx, word ptr [ebp + arg_c]            # 004cb169
    mov eax, dword ptr [ebp - local_4]           # 004cb16d
    mov ecx, dword ptr [eax + field_126]         # 004cb170
    cmp edx, dword ptr [ecx + field_8]           # 004cb176
    jl.d32 L_004cb2b0                            # 004cb179
    # block 0x004cb17f: entered by fall-through of jl at 0x004cb179, 5 instruction(s), ends with jg to 0x004cb2b0 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004cb17f
    mov eax, dword ptr [ebp - local_4]           # 004cb183
    mov ecx, dword ptr [eax + field_126]         # 004cb186
    cmp edx, dword ptr [ecx + field_10]          # 004cb18c
    jg.d32 L_004cb2b0                            # 004cb18f
    # block 0x004cb195: entered by fall-through of jg at 0x004cb18f, 5 instruction(s), ends with jl to 0x004cb2b0 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004cb195
    mov eax, dword ptr [ebp - local_4]           # 004cb199
    mov ecx, dword ptr [eax + field_126]         # 004cb19c
    cmp edx, dword ptr [ecx + field_4]           # 004cb1a2
    jl.d32 L_004cb2b0                            # 004cb1a5
    # block 0x004cb1ab: entered by fall-through of jl at 0x004cb1a5, 5 instruction(s), ends with jg to 0x004cb2b0 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004cb1ab
    mov eax, dword ptr [ebp - local_4]           # 004cb1af
    mov ecx, dword ptr [eax + field_126]         # 004cb1b2
    cmp edx, dword ptr [ecx + field_c]           # 004cb1b8
    jg.d32 L_004cb2b0                            # 004cb1bb
    # block 0x004cb1c1: entered by fall-through of jg at 0x004cb1bb, 9 instruction(s), ends with je to 0x004cb29c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb1c1
    mov eax, dword ptr [ebp - local_4]           # 004cb1c4
    mov ecx, dword ptr [eax + field_126]         # 004cb1c7
    mov dword ptr [edx + field_154], ecx         # 004cb1cd
    mov edx, dword ptr [ebp - local_4]           # 004cb1d3
    mov eax, dword ptr [edx + field_126]         # 004cb1d6
    movsx ecx, word ptr [eax + field_16]         # 004cb1dc
    cmp ecx, -0x1                                # 004cb1e0
    je.d32 L_004cb29c                            # 004cb1e3
    # block 0x004cb1e9: entered by fall-through of je at 0x004cb1e3, 8 instruction(s), ends with jne to 0x004cb242 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb1e9
    mov eax, dword ptr [edx + field_16]          # 004cb1ec
    mov ecx, dword ptr [ebp - local_4]           # 004cb1ef
    mov edx, dword ptr [ecx + field_126]         # 004cb1f2
    movsx ecx, word ptr [edx + field_16]         # 004cb1f8
    movsx edx, word ptr [eax + 2*ecx + field_5f] # 004cb1fc
    cmp edx, 0xc8                                # 004cb201
    jne.d8 L_004cb242                            # 004cb207
    # block 0x004cb209: entered by fall-through of jne at 0x004cb207, 4 instruction(s), ends with je to 0x004cb242 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb209
    movsx ecx, word ptr [eax + field_152]        # 004cb20c
    cmp ecx, -0x1                                # 004cb213
    je.d8 L_004cb242                             # 004cb216
    # block 0x004cb218: entered by fall-through of je at 0x004cb216, 8 instruction(s), ends with forward jump to 0x004cb274
    mov edx, dword ptr [ebp - local_4]           # 004cb218
    movsx eax, word ptr [edx + field_152]        # 004cb21b
    add eax, 0x25                                # 004cb222
    mov dword ptr [0x5b44f0], eax                # 004cb225
    mov dword ptr [0x5b44f4], 0x1                # 004cb22a
    mov ecx, dword ptr [0x571ad3]                # 004cb234
    mov dword ptr [0x5d162d], ecx                # 004cb23a
    jmp.d8 L_004cb274                            # 004cb240
L_004cb242:
    # block 0x004cb242: entered by jne at 0x004cb207; je at 0x004cb216, 10 instruction(s), falls into the block at 0x004cb274
    mov edx, dword ptr [ebp - local_4]           # 004cb242
    mov eax, dword ptr [edx + field_16]          # 004cb245
    mov ecx, dword ptr [ebp - local_4]           # 004cb248
    mov edx, dword ptr [ecx + field_126]         # 004cb24b
    movsx ecx, word ptr [edx + field_16]         # 004cb251
    movsx edx, word ptr [eax + 2*ecx + field_5f] # 004cb255
    mov dword ptr [0x5b44f0], edx                # 004cb25a
    mov dword ptr [0x5b44f4], 0x1                # 004cb260
    mov eax, dword ptr [0x5d0377]                # 004cb26a
    mov dword ptr [0x5d162d], eax                # 004cb26f
L_004cb274:
    # block 0x004cb274: entered by jmp at 0x004cb240, 7 instruction(s), falls into the block at 0x004cb29c
    mov ecx, dword ptr [0x5b44f0]                # 004cb274
    shl ecx, 0x5                                 # 004cb27a
    mov edx, dword ptr [0x5b44f4]                # 004cb27d
    shl edx, 0x4                                 # 004cb283
    lea eax, [ecx + edx + 0x5b160c]              # 004cb286
    mov dword ptr [0x5d1631], eax                # 004cb28d
    mov dword ptr [0x5d1639], 0x1                # 004cb292
L_004cb29c:
    # block 0x004cb29c: entered by je at 0x004cb1e3, 3 instruction(s), ends with forward jump to 0x004cb3a5
    mov dword ptr [0x5c39e5], 0x27b0             # 004cb29c
    mov eax, 0x1                                 # 004cb2a6
    jmp.d32 L_004cb3a5                           # 004cb2ab
L_004cb2b0:
    # block 0x004cb2b0: entered by jl at 0x004cb179; jg at 0x004cb18f; jl at 0x004cb1a5; jg at 0x004cb1bb, 1 instruction(s), ends with backward jump to 0x004cb11b
    jmp.d32 L_004cb11b                           # 004cb2b0
L_004cb2b5:
    # block 0x004cb2b5: entered by jge at 0x004cb143, 5 instruction(s), ends with je to 0x004cb3a3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb2b5
    mov edx, dword ptr [ecx + field_12]          # 004cb2b8
    movsx eax, byte ptr [edx + field_4]          # 004cb2bb
    test eax, eax                                # 004cb2bf
    je.d32 L_004cb3a3                            # 004cb2c1
    # block 0x004cb2c7: entered by fall-through of je at 0x004cb2c1, 5 instruction(s), ends with jl to 0x004cb3a3 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004cb2c7
    mov edx, dword ptr [ebp - local_4]           # 004cb2cb
    mov eax, dword ptr [edx + field_15c]         # 004cb2ce
    cmp ecx, dword ptr [eax + field_16]          # 004cb2d4
    jl.d32 L_004cb3a3                            # 004cb2d7
    # block 0x004cb2dd: entered by fall-through of jl at 0x004cb2d7, 5 instruction(s), ends with jg to 0x004cb3a3 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004cb2dd
    mov edx, dword ptr [ebp - local_4]           # 004cb2e1
    mov eax, dword ptr [edx + field_15c]         # 004cb2e4
    cmp ecx, dword ptr [eax + field_1e]          # 004cb2ea
    jg.d32 L_004cb3a3                            # 004cb2ed
    # block 0x004cb2f3: entered by fall-through of jg at 0x004cb2ed, 5 instruction(s), ends with jl to 0x004cb3a3 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004cb2f3
    mov edx, dword ptr [ebp - local_4]           # 004cb2f7
    mov eax, dword ptr [edx + field_15c]         # 004cb2fa
    cmp ecx, dword ptr [eax + field_12]          # 004cb300
    jl.d32 L_004cb3a3                            # 004cb303
    # block 0x004cb309: entered by fall-through of jl at 0x004cb303, 5 instruction(s), ends with jg to 0x004cb3a3 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004cb309
    mov edx, dword ptr [ebp - local_4]           # 004cb30d
    mov eax, dword ptr [edx + field_15c]         # 004cb310
    cmp ecx, dword ptr [eax + field_1a]          # 004cb316
    jg.d32 L_004cb3a3                            # 004cb319
    # block 0x004cb31f: entered by fall-through of jg at 0x004cb319, 7 instruction(s), ends with je to 0x004cb392 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb31f
    mov dword ptr [ecx + field_14e], 0x1         # 004cb322
    mov edx, dword ptr [ebp - local_4]           # 004cb32c
    mov eax, dword ptr [edx + field_12]          # 004cb32f
    movsx ecx, word ptr [eax + field_7]          # 004cb332
    cmp ecx, -0x1                                # 004cb336
    je.d8 L_004cb392                             # 004cb339
    # block 0x004cb33b: entered by fall-through of je at 0x004cb339, 17 instruction(s), falls into the block at 0x004cb392
    mov edx, dword ptr [ebp - local_4]           # 004cb33b
    mov eax, dword ptr [edx + field_16]          # 004cb33e
    mov ecx, dword ptr [ebp - local_4]           # 004cb341
    mov edx, dword ptr [ecx + field_12]          # 004cb344
    movsx ecx, word ptr [edx + field_7]          # 004cb347
    movsx edx, word ptr [eax + 2*ecx + field_5f] # 004cb34b
    mov dword ptr [0x5b44f0], edx                # 004cb350
    mov dword ptr [0x5b44f4], 0x0                # 004cb356
    mov eax, dword ptr [0x5d0377]                # 004cb360
    mov dword ptr [0x5d162d], eax                # 004cb365
    mov ecx, dword ptr [0x5b44f0]                # 004cb36a
    shl ecx, 0x5                                 # 004cb370
    mov edx, dword ptr [0x5b44f4]                # 004cb373
    shl edx, 0x4                                 # 004cb379
    lea eax, [ecx + edx + 0x5b160c]              # 004cb37c
    mov dword ptr [0x5d1631], eax                # 004cb383
    mov dword ptr [0x5d1639], 0x1                # 004cb388
L_004cb392:
    # block 0x004cb392: entered by je at 0x004cb339, 3 instruction(s), ends with forward jump to 0x004cb3a5
    mov dword ptr [0x5c39e5], 0x27b2             # 004cb392
    mov eax, 0x1                                 # 004cb39c
    jmp.d8 L_004cb3a5                            # 004cb3a1
L_004cb3a3:
    # block 0x004cb3a3: entered by je at 0x004cb080; je at 0x004cb0e9; je at 0x004cb0f6; je at 0x004cb106; more, 1 instruction(s), falls into the block at 0x004cb3a5
    {load} xor eax, eax                          # 004cb3a3
L_004cb3a5:
    # block 0x004cb3a5: entered by jmp at 0x004cb2ab; jmp at 0x004cb3a1, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004cb3a5
    pop ebp                                      # 004cb3a7
    ret 0x8                                      # 004cb3a8

