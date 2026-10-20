# FUN_004a5eea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a5eea
# extent:       0x004a5eea-0x004a6270 (902 code bytes)
# span:         0x004a5eea-0x004a6270 (code 902, tables 0, padding 0)
# sha256:       e498a777180e49834036d9b13bc22b8ddb6e01c2e84930b4cf253fcc0040d36f
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ripped_letter_puzzle_renderer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a5eea.c.txt, not original source) refers to the data labelled s_Rip_Letter_puzzle_pSrcSurface_00550858, s_Ripped_Letter_Puzzle_CURRENT_are_005508ac
# name-note:    Redraws the Ripped Letter puzzle: restores backgrounds, draws the grid of letter pieces and the current piece.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_23, field_203; [ecx + n] field_21, field_22, field_23; [edx + n] field_21, field_203, field_5a8
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 227 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_203, 0x203  # offset +0x203
.equ field_5a8, 0x5a8  # offset +0x5a8

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004a5eea - 0x401000
.globl FUN_004a5eea
FUN_004a5eea:
    # block 0x004a5eea: entry, 9 instruction(s), ends with je to 0x004a5f72 (forward)
    push ebp                                     # 004a5eea
    {load} mov ebp, esp                          # 004a5eeb
    sub esp, 0x18                                # 004a5eed
    movsx eax, word ptr [0x61c8ed]               # 004a5ef0
    imul eax, eax, 0x8d                          # 004a5ef7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a5efd
    mov dword ptr [ebp - local_8], ecx           # 004a5f03
    cmp dword ptr [0x61cb35], 0x0                # 004a5f06
    je.d8 L_004a5f72                             # 004a5f0d
    # block 0x004a5f0f: entered by fall-through of je at 0x004a5f0d, 22 instruction(s), calls FUN_004c5377, falls into the block at 0x004a5f72
    mov dword ptr [0x61cb35], 0x0                # 004a5f0f
    push 0x550750                                # 004a5f19
    movsx edx, word ptr [0x61cb3b]               # 004a5f1e
    imul edx, edx, 0x60                          # 004a5f25
    movsx eax, word ptr [0x61cb39]               # 004a5f28
    shl eax, 0x4                                 # 004a5f2f
    lea ecx, [edx + eax + 0x61c8ef]              # 004a5f32
    push ecx                                     # 004a5f39
    movsx edx, word ptr [0x61cb3b]               # 004a5f3a
    imul edx, edx, 0x60                          # 004a5f41
    mov eax, dword ptr [ebp - local_8]           # 004a5f44
    lea ecx, [eax + edx + field_203]             # 004a5f47
    movsx edx, word ptr [0x61cb39]               # 004a5f4e
    shl edx, 0x4                                 # 004a5f55
    {load} add ecx, edx                          # 004a5f58
    push ecx                                     # 004a5f5a
    mov eax, dword ptr [0x5cf665]                # 004a5f5b
    push eax                                     # 004a5f60
    mov ecx, dword ptr [0x5d15e3]                # 004a5f61
    push ecx                                     # 004a5f67
    mov ecx, 0x5cf659                            # 004a5f68
    call FUN_004c5377                            # 004a5f6d
L_004a5f72:
    # block 0x004a5f72: entered by je at 0x004a5f0d, 2 instruction(s), ends with je to 0x004a5fa1 (forward)
    cmp dword ptr [0x61cb2f], 0x0                # 004a5f72
    je.d8 L_004a5fa1                             # 004a5f79
    # block 0x004a5f7b: entered by fall-through of je at 0x004a5f79, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004a5fa1
    push 0x550784                                # 004a5f7b
    push 0x61cb07                                # 004a5f80
    push 0x61cae7                                # 004a5f85
    mov edx, dword ptr [0x5cf665]                # 004a5f8a
    push edx                                     # 004a5f90
    mov eax, dword ptr [0x5d15e3]                # 004a5f91
    push eax                                     # 004a5f96
    mov ecx, 0x5cf659                            # 004a5f97
    call FUN_004c5377                            # 004a5f9c
L_004a5fa1:
    # block 0x004a5fa1: entered by je at 0x004a5f79, 2 instruction(s), ends with je to 0x004a600a (forward)
    cmp dword ptr [0x61cb2b], 0x0                # 004a5fa1
    je.d8 L_004a600a                             # 004a5fa8
    # block 0x004a5faa: entered by fall-through of je at 0x004a5fa8, 2 instruction(s), ends with jne to 0x004a600a (forward)
    cmp dword ptr [0x61cb2f], 0x0                # 004a5faa
    jne.d8 L_004a600a                            # 004a5fb1
    # block 0x004a5fb3: entered by fall-through of jne at 0x004a5fb1, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004a600a
    push 0x5507bc                                # 004a5fb3
    push 0x61cb07                                # 004a5fb8
    push 0x61cae7                                # 004a5fbd
    mov ecx, dword ptr [0x5cf665]                # 004a5fc2
    push ecx                                     # 004a5fc8
    mov edx, dword ptr [0x5d15e3]                # 004a5fc9
    push edx                                     # 004a5fcf
    mov ecx, 0x5cf659                            # 004a5fd0
    call FUN_004c5377                            # 004a5fd5
    push 0x5507f4                                # 004a5fda
    push 0x61cb17                                # 004a5fdf
    push 0x61caf7                                # 004a5fe4
    mov eax, dword ptr [0x5cf665]                # 004a5fe9
    push eax                                     # 004a5fee
    mov ecx, dword ptr [0x5d15e3]                # 004a5fef
    push ecx                                     # 004a5ff5
    mov ecx, 0x5cf659                            # 004a5ff6
    call FUN_004c5377                            # 004a5ffb
    mov dword ptr [0x61cb2b], 0x0                # 004a6000
L_004a600a:
    # block 0x004a600a: entered by je at 0x004a5fa8; jne at 0x004a5fb1, 2 instruction(s), ends with forward jump to 0x004a601e
    mov word ptr [ebp - local_10], 0x0           # 004a600a
    jmp.d8 L_004a601e                            # 004a6010
L_004a6012:
    # block 0x004a6012: entered by jmp at 0x004a61ce, 3 instruction(s), falls into the block at 0x004a601e
    mov dx, word ptr [ebp - local_10]            # 004a6012
    add dx, 0x1                                  # 004a6016
    mov word ptr [ebp - local_10], dx            # 004a601a
L_004a601e:
    # block 0x004a601e: entered by jmp at 0x004a6010, 5 instruction(s), ends with jge to 0x004a61d3 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004a601e
    mov ecx, dword ptr [ebp - local_8]           # 004a6022
    movsx edx, byte ptr [ecx + field_22]         # 004a6025
    {load} cmp eax, edx                          # 004a6029
    jge.d32 L_004a61d3                           # 004a602b
    # block 0x004a6031: entered by fall-through of jge at 0x004a602b, 2 instruction(s), ends with forward jump to 0x004a6045
    mov word ptr [ebp - local_c], 0x0            # 004a6031
    jmp.d8 L_004a6045                            # 004a6037
L_004a6039:
    # block 0x004a6039: entered by jmp at 0x004a61c9, 3 instruction(s), falls into the block at 0x004a6045
    mov ax, word ptr [ebp - local_c]             # 004a6039
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a603d
    mov word ptr [ebp - local_c], ax             # 004a6041
L_004a6045:
    # block 0x004a6045: entered by jmp at 0x004a6037, 5 instruction(s), ends with jge to 0x004a61ce (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004a6045
    mov edx, dword ptr [ebp - local_8]           # 004a6049
    movsx eax, byte ptr [edx + field_21]         # 004a604c
    {load} cmp ecx, eax                          # 004a6050
    jge.d32 L_004a61ce                           # 004a6052
    # block 0x004a6058: entered by fall-through of jge at 0x004a6052, 11 instruction(s), ends with jne to 0x004a6094 (forward)
    movsx ecx, word ptr [0x61cb33]               # 004a6058
    imul ecx, ecx, 0x7c                          # 004a605f
    movsx edx, word ptr [ebp - local_10]         # 004a6062
    imul edx, edx, 0xc                           # 004a6066
    lea eax, [ecx + edx + 0x591a28]              # 004a6069
    movsx ecx, word ptr [ebp - local_c]          # 004a6070
    mov dx, word ptr [eax + 2*ecx]               # 004a6074
    mov word ptr [ebp - local_4], dx             # 004a6078
    movsx eax, word ptr [ebp - local_4]          # 004a607c
    test eax, eax                                # 004a6080
    jne.d8 L_004a6094                            # 004a6082
    # block 0x004a6084: entered by fall-through of jne at 0x004a6082, 4 instruction(s), ends with forward jump to 0x004a60d7
    mov word ptr [ebp - local_14], 0x0           # 004a6084
    mov cx, word ptr [ebp - local_14]            # 004a608a
    mov word ptr [ebp - local_18], cx            # 004a608e
    jmp.d8 L_004a60d7                            # 004a6092
L_004a6094:
    # block 0x004a6094: entered by jne at 0x004a6082, 3 instruction(s), ends with jne to 0x004a60ad (forward)
    movsx edx, word ptr [ebp - local_4]          # 004a6094
    cmp edx, -0xa                                # 004a6098
    jne.d8 L_004a60ad                            # 004a609b
    # block 0x004a609d: entered by fall-through of jne at 0x004a609b, 4 instruction(s), ends with forward jump to 0x004a60d7
    mov word ptr [ebp - local_14], 0xfff6        # 004a609d
    mov ax, word ptr [ebp - local_14]            # 004a60a3
    mov word ptr [ebp - local_18], ax            # 004a60a7
    jmp.d8 L_004a60d7                            # 004a60ab
L_004a60ad:
    # block 0x004a60ad: entered by jne at 0x004a609b, 13 instruction(s), falls into the block at 0x004a60d7
    movsx eax, word ptr [ebp - local_4]          # 004a60ad
    mov ecx, dword ptr [ebp - local_8]           # 004a60b1
    movsx ecx, byte ptr [ecx + field_21]         # 004a60b4
    cdq                                          # 004a60b8
    idiv ecx                                     # 004a60b9
    mov word ptr [ebp - local_18], ax            # 004a60bb
    movsx edx, word ptr [ebp - local_4]          # 004a60bf
    movsx eax, word ptr [ebp - local_18]         # 004a60c3
    mov ecx, dword ptr [ebp - local_8]           # 004a60c7
    movsx ecx, byte ptr [ecx + field_21]         # 004a60ca
    imul eax, ecx                                # 004a60ce
    {load} sub edx, eax                          # 004a60d1
    mov word ptr [ebp - local_14], dx            # 004a60d3
L_004a60d7:
    # block 0x004a60d7: entered by jmp at 0x004a6092; jmp at 0x004a60ab, 2 instruction(s), ends with je to 0x004a614b (forward)
    cmp dword ptr [0x61cb27], 0x0                # 004a60d7
    je.d8 L_004a614b                             # 004a60de
    # block 0x004a60e0: entered by fall-through of je at 0x004a60de, 3 instruction(s), ends with jne to 0x004a614b (forward)
    movsx edx, word ptr [ebp - local_14]         # 004a60e0
    cmp edx, -0xa                                # 004a60e4
    jne.d8 L_004a614b                            # 004a60e7
    # block 0x004a60e9: entered by fall-through of jne at 0x004a60e7, 3 instruction(s), ends with jne to 0x004a614b (forward)
    movsx eax, word ptr [ebp - local_18]         # 004a60e9
    cmp eax, -0xa                                # 004a60ed
    jne.d8 L_004a614b                            # 004a60f0
    # block 0x004a60f2: entered by fall-through of jne at 0x004a60f0, 23 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a61c9
    push 0x55082c                                # 004a60f2
    movsx ecx, word ptr [ebp - local_10]         # 004a60f7
    imul ecx, ecx, 0x60                          # 004a60fb
    movsx edx, word ptr [ebp - local_c]          # 004a60fe
    shl edx, 0x4                                 # 004a6102
    lea eax, [ecx + edx + 0x61c8ef]              # 004a6105
    push eax                                     # 004a610c
    movsx ecx, word ptr [ebp - local_10]         # 004a610d
    imul ecx, ecx, 0x60                          # 004a6111
    mov edx, dword ptr [ebp - local_8]           # 004a6114
    lea eax, [edx + ecx + field_203]             # 004a6117
    movsx ecx, word ptr [ebp - local_c]          # 004a611e
    shl ecx, 0x4                                 # 004a6122
    {load} add eax, ecx                          # 004a6125
    push eax                                     # 004a6127
    mov edx, dword ptr [0x5cf665]                # 004a6128
    push edx                                     # 004a612e
    mov eax, dword ptr [0x5d15e3]                # 004a612f
    push eax                                     # 004a6134
    mov ecx, 0x5cf659                            # 004a6135
    call FUN_004c5377                            # 004a613a
    mov dword ptr [0x61cb27], 0x0                # 004a613f
    jmp.d8 L_004a61c9                            # 004a6149
L_004a614b:
    # block 0x004a614b: entered by je at 0x004a60de; jne at 0x004a60e7; jne at 0x004a60f0, 3 instruction(s), ends with je to 0x004a61c9 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a614b
    cmp ecx, -0xa                                # 004a614f
    je.d8 L_004a61c9                             # 004a6152
    # block 0x004a6154: entered by fall-through of je at 0x004a6152, 3 instruction(s), ends with je to 0x004a61c9 (forward)
    movsx edx, word ptr [ebp - local_18]         # 004a6154
    cmp edx, -0xa                                # 004a6158
    je.d8 L_004a61c9                             # 004a615b
    # block 0x004a615d: entered by fall-through of je at 0x004a615b, 28 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004a61c9
    push 0x550858                                # 004a615d
    movsx eax, word ptr [ebp - local_10]         # 004a6162
    imul eax, eax, 0x60                          # 004a6166
    movsx ecx, word ptr [ebp - local_c]          # 004a6169
    shl ecx, 0x4                                 # 004a616d
    lea edx, [eax + ecx + 0x61c8ef]              # 004a6170
    push edx                                     # 004a6177
    movsx eax, word ptr [ebp - local_18]         # 004a6178
    imul eax, eax, 0x60                          # 004a617c
    mov ecx, dword ptr [ebp - local_8]           # 004a617f
    lea edx, [ecx + eax + field_23]              # 004a6182
    movsx eax, word ptr [ebp - local_14]         # 004a6186
    shl eax, 0x4                                 # 004a618a
    {load} add edx, eax                          # 004a618d
    push edx                                     # 004a618f
    mov ecx, dword ptr [0x5cf665]                # 004a6190
    push ecx                                     # 004a6196
    movsx edx, word ptr [0x61cb33]               # 004a6197
    imul edx, edx, 0x7c                          # 004a619e
    movsx eax, word ptr [ebp - local_10]         # 004a61a1
    imul eax, eax, 0xc                           # 004a61a5
    lea ecx, [edx + eax + 0x591a64]              # 004a61a8
    movsx edx, word ptr [ebp - local_c]          # 004a61af
    movsx eax, word ptr [ecx + 2*edx]            # 004a61b3
    mov ecx, dword ptr [4*eax + 0x61cacf]        # 004a61b7
    push ecx                                     # 004a61be
    mov ecx, 0x5cf659                            # 004a61bf
    call FUN_004c5d4b                            # 004a61c4
L_004a61c9:
    # block 0x004a61c9: entered by jmp at 0x004a6149; je at 0x004a6152; je at 0x004a615b, 1 instruction(s), ends with backward jump to 0x004a6039
    jmp.d32 L_004a6039                           # 004a61c9
L_004a61ce:
    # block 0x004a61ce: entered by jge at 0x004a6052, 1 instruction(s), ends with backward jump to 0x004a6012
    jmp.d32 L_004a6012                           # 004a61ce
L_004a61d3:
    # block 0x004a61d3: entered by jge at 0x004a602b, 2 instruction(s), ends with je to 0x004a626c (forward)
    cmp dword ptr [0x61cb2f], 0x0                # 004a61d3
    je.d32 L_004a626c                            # 004a61da
    # block 0x004a61e0: entered by fall-through of je at 0x004a61da, 5 instruction(s), ends with je to 0x004a6225 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004a61e0
    {load} xor eax, eax                          # 004a61e3
    mov al, byte ptr [edx + field_5a8]           # 004a61e5
    test eax, eax                                # 004a61eb
    je.d8 L_004a6225                             # 004a61ed
    # block 0x004a61ef: entered by fall-through of je at 0x004a61ed, 13 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004a626c
    push 0x550878                                # 004a61ef
    push 0x61cb17                                # 004a61f4
    mov ecx, dword ptr [ebp - local_8]           # 004a61f9
    add ecx, 0x5a9                               # 004a61fc
    push ecx                                     # 004a6202
    mov edx, dword ptr [0x5cf665]                # 004a6203
    push edx                                     # 004a6209
    movsx eax, word ptr [0x61cae5]               # 004a620a
    mov ecx, dword ptr [4*eax + 0x61cacf]        # 004a6211
    push ecx                                     # 004a6218
    mov ecx, 0x5cf659                            # 004a6219
    call FUN_004c5d4b                            # 004a621e
    jmp.d8 L_004a626c                            # 004a6223
L_004a6225:
    # block 0x004a6225: entered by je at 0x004a61ed, 17 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004a626c
    push 0x5508ac                                # 004a6225
    push 0x61cb17                                # 004a622a
    movsx edx, word ptr [0x61cae1]               # 004a622f
    imul edx, edx, 0x60                          # 004a6236
    mov eax, dword ptr [ebp - local_8]           # 004a6239
    lea ecx, [eax + edx + field_23]              # 004a623c
    movsx edx, word ptr [0x61cadf]               # 004a6240
    shl edx, 0x4                                 # 004a6247
    {load} add ecx, edx                          # 004a624a
    push ecx                                     # 004a624c
    mov eax, dword ptr [0x5cf665]                # 004a624d
    push eax                                     # 004a6252
    movsx ecx, word ptr [0x61cae5]               # 004a6253
    mov edx, dword ptr [4*ecx + 0x61cacf]        # 004a625a
    push edx                                     # 004a6261
    mov ecx, 0x5cf659                            # 004a6262
    call FUN_004c5d4b                            # 004a6267
L_004a626c:
    # block 0x004a626c: entered by je at 0x004a61da; jmp at 0x004a6223, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a626c
    pop ebp                                      # 004a626e
    ret                                          # 004a626f

