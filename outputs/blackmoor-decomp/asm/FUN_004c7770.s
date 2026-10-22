# FUN_004c7770
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7770
# extent:       0x004c7770-0x004c7ce8 (1400 code bytes)
# span:         0x004c7770-0x004c7ce8 (code 1400, tables 0, padding 0)
# sha256:       8e86eec09a731e820a5673a8371e99153610d4cd6129715ba39c3e0c5f0e0ed0
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_draw_draw_line
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c7770.c.txt, not original source) refers to the data labelled s_CDirectDraw__DrawLine_____lock_p_005553f8, s_CDirectDraw__DrawLine_____unlock_00555420
# name-note:    Locks a surface and draws a 16-bit line with Bresenham-style run stepping, then unlocks; lock/unlock strings name CDirectDraw::DrawLine.
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_64, local_78, local_88, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 7 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c4067, FUN_004c8757, FUN_004c880f, FUN_004c4202
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 342 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_64, 0x64  # offset -0x64
.equ local_78, 0x78  # offset -0x78
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c8757, .text + (0x004c8757 - 0x401000)
.set FUN_004c880f, .text + (0x004c880f - 0x401000)

.org 0x004c7770 - 0x401000
.globl FUN_004c7770
FUN_004c7770:
    # block 0x004c7770: entry, 20 instruction(s), calls FUN_004c4067, ends with jle to 0x004c77e5 (forward)
    push ebp                                     # 004c7770
    {load} mov ebp, esp                          # 004c7771
    sub esp, 0xbc                                # 004c7773
    mov dword ptr [ebp - local_bc], ecx          # 004c7779
    push 0x20                                    # 004c777f
    push 0x5553f8                                # 004c7781
    lea eax, [ebp - local_88]                    # 004c7786
    push eax                                     # 004c778c
    push 0x0                                     # 004c778d
    mov ecx, dword ptr [ebp + arg_8]             # 004c778f
    push ecx                                     # 004c7792
    mov ecx, dword ptr [ebp - local_bc]          # 004c7793
    call FUN_004c4067                            # 004c7799
    mov edx, dword ptr [ebp - local_64]          # 004c779e
    mov dword ptr [ebp - local_4], edx           # 004c77a1
    mov eax, dword ptr [ebp - local_78]          # 004c77a4
    mov dword ptr [ebp - local_90], eax          # 004c77a7
    mov ecx, dword ptr [ebp + arg_10]            # 004c77ad
    cmp ecx, dword ptr [ebp + arg_18]            # 004c77b0
    jle.d8 L_004c77e5                            # 004c77b3
    # block 0x004c77b5: entered by fall-through of jle at 0x004c77b3, 12 instruction(s), falls into the block at 0x004c77e5
    mov edx, dword ptr [ebp + arg_10]            # 004c77b5
    mov dword ptr [ebp - local_98], edx          # 004c77b8
    mov eax, dword ptr [ebp + arg_18]            # 004c77be
    mov dword ptr [ebp + arg_10], eax            # 004c77c1
    mov ecx, dword ptr [ebp - local_98]          # 004c77c4
    mov dword ptr [ebp + arg_18], ecx            # 004c77ca
    mov edx, dword ptr [ebp + arg_c]             # 004c77cd
    mov dword ptr [ebp - local_98], edx          # 004c77d0
    mov eax, dword ptr [ebp + arg_14]            # 004c77d6
    mov dword ptr [ebp + arg_c], eax             # 004c77d9
    mov ecx, dword ptr [ebp - local_98]          # 004c77dc
    mov dword ptr [ebp + arg_14], ecx            # 004c77e2
L_004c77e5:
    # block 0x004c77e5: entered by jle at 0x004c77b3, 14 instruction(s), ends with jge to 0x004c7835 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 004c77e5
    imul edx, dword ptr [ebp - local_90]         # 004c77e8
    mov eax, dword ptr [ebp - local_4]           # 004c77ef
    {load} add eax, edx                          # 004c77f2
    movsx ecx, word ptr [0x639895]               # 004c77f4
    mov edx, dword ptr [ebp + arg_c]             # 004c77fb
    imul edx, ecx                                # 004c77fe
    {load} add eax, edx                          # 004c7801
    mov dword ptr [ebp - local_b4], eax          # 004c7803
    mov eax, dword ptr [ebp + arg_14]            # 004c7809
    sub eax, dword ptr [ebp + arg_c]             # 004c780c
    mov dword ptr [ebp - local_a8], eax          # 004c780f
    cmp dword ptr [ebp - local_a8], 0x0          # 004c7815
    jge.d8 L_004c7835                            # 004c781c
    # block 0x004c781e: entered by fall-through of jge at 0x004c781c, 5 instruction(s), ends with forward jump to 0x004c783c
    mov dword ptr [ebp - local_8], 0xffffffff    # 004c781e
    mov ecx, dword ptr [ebp - local_a8]          # 004c7825
    neg ecx                                      # 004c782b
    mov dword ptr [ebp - local_a8], ecx          # 004c782d
    jmp.d8 L_004c783c                            # 004c7833
L_004c7835:
    # block 0x004c7835: entered by jge at 0x004c781c, 1 instruction(s), falls into the block at 0x004c783c
    mov dword ptr [ebp - local_8], 0x1           # 004c7835
L_004c783c:
    # block 0x004c783c: entered by jmp at 0x004c7833, 5 instruction(s), ends with jne to 0x004c78a0 (forward)
    mov edx, dword ptr [ebp + arg_18]            # 004c783c
    sub edx, dword ptr [ebp + arg_10]            # 004c783f
    mov dword ptr [ebp - local_a4], edx          # 004c7842
    cmp dword ptr [ebp - local_a8], 0x0          # 004c7848
    jne.d8 L_004c78a0                            # 004c784f
    # block 0x004c7851: entered by fall-through of jne at 0x004c784f, 2 instruction(s), ends with forward jump to 0x004c786c
    mov dword ptr [ebp - local_a0], 0x0          # 004c7851
    jmp.d8 L_004c786c                            # 004c785b
L_004c785d:
    # block 0x004c785d: entered by jmp at 0x004c7899, 3 instruction(s), falls into the block at 0x004c786c
    mov eax, dword ptr [ebp - local_a0]          # 004c785d
    add eax, 0x1                                 # 004c7863
    mov dword ptr [ebp - local_a0], eax          # 004c7866
L_004c786c:
    # block 0x004c786c: entered by jmp at 0x004c785b, 3 instruction(s), ends with jg to 0x004c789b (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 004c786c
    cmp ecx, dword ptr [ebp - local_a4]          # 004c7872
    jg.d8 L_004c789b                             # 004c7878
    # block 0x004c787a: entered by fall-through of jg at 0x004c7878, 7 instruction(s), ends with backward jump to 0x004c785d
    mov edx, dword ptr [ebp - local_b4]          # 004c787a
    mov ax, word ptr [ebp + arg_1c]              # 004c7880
    mov word ptr [edx], ax                       # 004c7884
    mov ecx, dword ptr [ebp - local_b4]          # 004c7887
    add ecx, dword ptr [ebp - local_90]          # 004c788d
    mov dword ptr [ebp - local_b4], ecx          # 004c7893
    jmp.d8 L_004c785d                            # 004c7899
L_004c789b:
    # block 0x004c789b: entered by jg at 0x004c7878, 1 instruction(s), ends with forward jump to 0x004c7ce0
    jmp.d32 L_004c7ce0                           # 004c789b
L_004c78a0:
    # block 0x004c78a0: entered by jne at 0x004c784f, 2 instruction(s), ends with jne to 0x004c7901 (forward)
    cmp dword ptr [ebp - local_a4], 0x0          # 004c78a0
    jne.d8 L_004c7901                            # 004c78a7
    # block 0x004c78a9: entered by fall-through of jne at 0x004c78a7, 2 instruction(s), ends with forward jump to 0x004c78c4
    mov dword ptr [ebp - local_a0], 0x0          # 004c78a9
    jmp.d8 L_004c78c4                            # 004c78b3
L_004c78b5:
    # block 0x004c78b5: entered by jmp at 0x004c78fa, 3 instruction(s), falls into the block at 0x004c78c4
    mov edx, dword ptr [ebp - local_a0]          # 004c78b5
    add edx, 0x1                                 # 004c78bb
    mov dword ptr [ebp - local_a0], edx          # 004c78be
L_004c78c4:
    # block 0x004c78c4: entered by jmp at 0x004c78b3, 3 instruction(s), ends with jg to 0x004c78fc (forward)
    mov eax, dword ptr [ebp - local_a0]          # 004c78c4
    cmp eax, dword ptr [ebp - local_a8]          # 004c78ca
    jg.d8 L_004c78fc                             # 004c78d0
    # block 0x004c78d2: entered by fall-through of jg at 0x004c78d0, 10 instruction(s), ends with backward jump to 0x004c78b5
    mov ecx, dword ptr [ebp - local_b4]          # 004c78d2
    mov dx, word ptr [ebp + arg_1c]              # 004c78d8
    mov word ptr [ecx], dx                       # 004c78dc
    movsx eax, word ptr [0x639895]               # 004c78df
    mov ecx, dword ptr [ebp - local_8]           # 004c78e6
    imul ecx, eax                                # 004c78e9
    mov edx, dword ptr [ebp - local_b4]          # 004c78ec
    {load} add edx, ecx                          # 004c78f2
    mov dword ptr [ebp - local_b4], edx          # 004c78f4
    jmp.d8 L_004c78b5                            # 004c78fa
L_004c78fc:
    # block 0x004c78fc: entered by jg at 0x004c78d0, 1 instruction(s), ends with forward jump to 0x004c7cde
    jmp.d32 L_004c7cde                           # 004c78fc
L_004c7901:
    # block 0x004c7901: entered by jne at 0x004c78a7, 3 instruction(s), ends with jne to 0x004c796f (forward)
    mov eax, dword ptr [ebp - local_a8]          # 004c7901
    cmp eax, dword ptr [ebp - local_a4]          # 004c7907
    jne.d8 L_004c796f                            # 004c790d
    # block 0x004c790f: entered by fall-through of jne at 0x004c790d, 2 instruction(s), ends with forward jump to 0x004c792a
    mov dword ptr [ebp - local_a0], 0x0          # 004c790f
    jmp.d8 L_004c792a                            # 004c7919
L_004c791b:
    # block 0x004c791b: entered by jmp at 0x004c7968, 3 instruction(s), falls into the block at 0x004c792a
    mov ecx, dword ptr [ebp - local_a0]          # 004c791b
    add ecx, 0x1                                 # 004c7921
    mov dword ptr [ebp - local_a0], ecx          # 004c7924
L_004c792a:
    # block 0x004c792a: entered by jmp at 0x004c7919, 3 instruction(s), ends with jg to 0x004c796a (forward)
    mov edx, dword ptr [ebp - local_a0]          # 004c792a
    cmp edx, dword ptr [ebp - local_a8]          # 004c7930
    jg.d8 L_004c796a                             # 004c7936
    # block 0x004c7938: entered by fall-through of jg at 0x004c7936, 12 instruction(s), ends with backward jump to 0x004c791b
    mov eax, dword ptr [ebp - local_b4]          # 004c7938
    mov cx, word ptr [ebp + arg_1c]              # 004c793e
    mov word ptr [eax], cx                       # 004c7942
    movsx edx, word ptr [0x639895]               # 004c7945
    mov eax, dword ptr [ebp - local_8]           # 004c794c
    imul eax, edx                                # 004c794f
    mov ecx, dword ptr [ebp - local_90]          # 004c7952
    {load} add ecx, eax                          # 004c7958
    mov edx, dword ptr [ebp - local_b4]          # 004c795a
    {load} add edx, ecx                          # 004c7960
    mov dword ptr [ebp - local_b4], edx          # 004c7962
    jmp.d8 L_004c791b                            # 004c7968
L_004c796a:
    # block 0x004c796a: entered by jg at 0x004c7936, 1 instruction(s), ends with forward jump to 0x004c7cdc
    jmp.d32 L_004c7cdc                           # 004c796a
L_004c796f:
    # block 0x004c796f: entered by jne at 0x004c790d, 3 instruction(s), ends with jl to 0x004c7b22 (forward)
    mov eax, dword ptr [ebp - local_a8]          # 004c796f
    cmp eax, dword ptr [ebp - local_a4]          # 004c7975
    jl.d32 L_004c7b22                            # 004c797b
    # block 0x004c7981: entered by fall-through of jl at 0x004c797b, 29 instruction(s), ends with jne to 0x004c7a10 (forward)
    mov eax, dword ptr [ebp - local_a8]          # 004c7981
    cdq                                          # 004c7987
    idiv dword ptr [ebp - local_a4]              # 004c7988
    mov dword ptr [ebp - local_c], eax           # 004c798e
    mov eax, dword ptr [ebp - local_a8]          # 004c7991
    cdq                                          # 004c7997
    idiv dword ptr [ebp - local_a4]              # 004c7998
    shl edx                                      # 004c799e
    mov dword ptr [ebp - local_94], edx          # 004c79a0
    mov ecx, dword ptr [ebp - local_a4]          # 004c79a6
    shl ecx                                      # 004c79ac
    mov dword ptr [ebp - local_b8], ecx          # 004c79ae
    mov eax, dword ptr [ebp - local_a8]          # 004c79b4
    cdq                                          # 004c79ba
    idiv dword ptr [ebp - local_a4]              # 004c79bb
    mov eax, dword ptr [ebp - local_a4]          # 004c79c1
    shl eax                                      # 004c79c7
    {load} sub edx, eax                          # 004c79c9
    mov dword ptr [ebp - local_b0], edx          # 004c79cb
    mov eax, dword ptr [ebp - local_c]           # 004c79d1
    cdq                                          # 004c79d4
    {load} sub eax, edx                          # 004c79d5
    sar eax                                      # 004c79d7
    add eax, 0x1                                 # 004c79d9
    mov dword ptr [ebp - local_ac], eax          # 004c79dc
    mov ecx, dword ptr [ebp - local_ac]          # 004c79e2
    mov dword ptr [ebp - local_9c], ecx          # 004c79e8
    cmp dword ptr [ebp - local_94], 0x0          # 004c79ee
    jne.d8 L_004c7a10                            # 004c79f5
    # block 0x004c79f7: entered by fall-through of jne at 0x004c79f5, 4 instruction(s), ends with jne to 0x004c7a10 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004c79f7
    and edx, 0x1                                 # 004c79fa
    test edx, edx                                # 004c79fd
    jne.d8 L_004c7a10                            # 004c79ff
    # block 0x004c7a01: entered by fall-through of jne at 0x004c79ff, 3 instruction(s), falls into the block at 0x004c7a10
    mov eax, dword ptr [ebp - local_ac]          # 004c7a01
    sub eax, 0x1                                 # 004c7a07
    mov dword ptr [ebp - local_ac], eax          # 004c7a0a
L_004c7a10:
    # block 0x004c7a10: entered by jne at 0x004c79f5; jne at 0x004c79ff, 4 instruction(s), ends with je to 0x004c7a2c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004c7a10
    and ecx, 0x1                                 # 004c7a13
    test ecx, ecx                                # 004c7a16
    je.d8 L_004c7a2c                             # 004c7a18
    # block 0x004c7a1a: entered by fall-through of je at 0x004c7a18, 3 instruction(s), falls into the block at 0x004c7a2c
    mov edx, dword ptr [ebp - local_b0]          # 004c7a1a
    add edx, dword ptr [ebp - local_a4]          # 004c7a20
    mov dword ptr [ebp - local_b0], edx          # 004c7a26
L_004c7a2c:
    # block 0x004c7a2c: entered by je at 0x004c7a18, 14 instruction(s), calls FUN_004c8757, ends with forward jump to 0x004c7a70
    mov ax, word ptr [ebp + arg_1c]              # 004c7a2c
    push eax                                     # 004c7a30
    mov ecx, dword ptr [ebp - local_ac]          # 004c7a31
    push ecx                                     # 004c7a37
    mov edx, dword ptr [ebp - local_8]           # 004c7a38
    push edx                                     # 004c7a3b
    mov eax, dword ptr [ebp - local_90]          # 004c7a3c
    push eax                                     # 004c7a42
    lea ecx, [ebp - local_b4]                    # 004c7a43
    push ecx                                     # 004c7a49
    mov ecx, dword ptr [ebp - local_bc]          # 004c7a4a
    call FUN_004c8757                            # 004c7a50
    mov dword ptr [ebp - local_a0], 0x0          # 004c7a55
    jmp.d8 L_004c7a70                            # 004c7a5f
L_004c7a61:
    # block 0x004c7a61: entered by jmp at 0x004c7aef, 3 instruction(s), falls into the block at 0x004c7a70
    mov edx, dword ptr [ebp - local_a0]          # 004c7a61
    add edx, 0x1                                 # 004c7a67
    mov dword ptr [ebp - local_a0], edx          # 004c7a6a
L_004c7a70:
    # block 0x004c7a70: entered by jmp at 0x004c7a5f, 4 instruction(s), ends with jge to 0x004c7af4 (forward)
    mov eax, dword ptr [ebp - local_a4]          # 004c7a70
    sub eax, 0x1                                 # 004c7a76
    cmp dword ptr [ebp - local_a0], eax          # 004c7a79
    jge.d8 L_004c7af4                            # 004c7a7f
    # block 0x004c7a81: entered by fall-through of jge at 0x004c7a7f, 7 instruction(s), ends with jle to 0x004c7ac6 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004c7a81
    mov dword ptr [ebp - local_8c], ecx          # 004c7a84
    mov edx, dword ptr [ebp - local_b0]          # 004c7a8a
    add edx, dword ptr [ebp - local_94]          # 004c7a90
    mov dword ptr [ebp - local_b0], edx          # 004c7a96
    cmp dword ptr [ebp - local_b0], 0x0          # 004c7a9c
    jle.d8 L_004c7ac6                            # 004c7aa3
    # block 0x004c7aa5: entered by fall-through of jle at 0x004c7aa3, 6 instruction(s), falls into the block at 0x004c7ac6
    mov eax, dword ptr [ebp - local_8c]          # 004c7aa5
    add eax, 0x1                                 # 004c7aab
    mov dword ptr [ebp - local_8c], eax          # 004c7aae
    mov ecx, dword ptr [ebp - local_b0]          # 004c7ab4
    sub ecx, dword ptr [ebp - local_b8]          # 004c7aba
    mov dword ptr [ebp - local_b0], ecx          # 004c7ac0
L_004c7ac6:
    # block 0x004c7ac6: entered by jle at 0x004c7aa3, 13 instruction(s), calls FUN_004c8757, ends with backward jump to 0x004c7a61
    mov dx, word ptr [ebp + arg_1c]              # 004c7ac6
    push edx                                     # 004c7aca
    mov eax, dword ptr [ebp - local_8c]          # 004c7acb
    push eax                                     # 004c7ad1
    mov ecx, dword ptr [ebp - local_8]           # 004c7ad2
    push ecx                                     # 004c7ad5
    mov edx, dword ptr [ebp - local_90]          # 004c7ad6
    push edx                                     # 004c7adc
    lea eax, [ebp - local_b4]                    # 004c7add
    push eax                                     # 004c7ae3
    mov ecx, dword ptr [ebp - local_bc]          # 004c7ae4
    call FUN_004c8757                            # 004c7aea
    jmp.d32 L_004c7a61                           # 004c7aef
L_004c7af4:
    # block 0x004c7af4: entered by jge at 0x004c7a7f, 13 instruction(s), calls FUN_004c8757, ends with forward jump to 0x004c7cda
    mov cx, word ptr [ebp + arg_1c]              # 004c7af4
    push ecx                                     # 004c7af8
    mov edx, dword ptr [ebp - local_9c]          # 004c7af9
    push edx                                     # 004c7aff
    mov eax, dword ptr [ebp - local_8]           # 004c7b00
    push eax                                     # 004c7b03
    mov ecx, dword ptr [ebp - local_90]          # 004c7b04
    push ecx                                     # 004c7b0a
    lea edx, [ebp - local_b4]                    # 004c7b0b
    push edx                                     # 004c7b11
    mov ecx, dword ptr [ebp - local_bc]          # 004c7b12
    call FUN_004c8757                            # 004c7b18
    jmp.d32 L_004c7cda                           # 004c7b1d
L_004c7b22:
    # block 0x004c7b22: entered by jl at 0x004c797b, 29 instruction(s), ends with jne to 0x004c7bb1 (forward)
    mov eax, dword ptr [ebp - local_a4]          # 004c7b22
    cdq                                          # 004c7b28
    idiv dword ptr [ebp - local_a8]              # 004c7b29
    mov dword ptr [ebp - local_c], eax           # 004c7b2f
    mov eax, dword ptr [ebp - local_a4]          # 004c7b32
    cdq                                          # 004c7b38
    idiv dword ptr [ebp - local_a8]              # 004c7b39
    shl edx                                      # 004c7b3f
    mov dword ptr [ebp - local_94], edx          # 004c7b41
    mov eax, dword ptr [ebp - local_a8]          # 004c7b47
    shl eax                                      # 004c7b4d
    mov dword ptr [ebp - local_b8], eax          # 004c7b4f
    mov eax, dword ptr [ebp - local_a4]          # 004c7b55
    cdq                                          # 004c7b5b
    idiv dword ptr [ebp - local_a8]              # 004c7b5c
    mov ecx, dword ptr [ebp - local_a8]          # 004c7b62
    shl ecx                                      # 004c7b68
    {load} sub edx, ecx                          # 004c7b6a
    mov dword ptr [ebp - local_b0], edx          # 004c7b6c
    mov eax, dword ptr [ebp - local_c]           # 004c7b72
    cdq                                          # 004c7b75
    {load} sub eax, edx                          # 004c7b76
    sar eax                                      # 004c7b78
    add eax, 0x1                                 # 004c7b7a
    mov dword ptr [ebp - local_ac], eax          # 004c7b7d
    mov edx, dword ptr [ebp - local_ac]          # 004c7b83
    mov dword ptr [ebp - local_9c], edx          # 004c7b89
    cmp dword ptr [ebp - local_94], 0x0          # 004c7b8f
    jne.d8 L_004c7bb1                            # 004c7b96
    # block 0x004c7b98: entered by fall-through of jne at 0x004c7b96, 4 instruction(s), ends with jne to 0x004c7bb1 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c7b98
    and eax, 0x1                                 # 004c7b9b
    test eax, eax                                # 004c7b9e
    jne.d8 L_004c7bb1                            # 004c7ba0
    # block 0x004c7ba2: entered by fall-through of jne at 0x004c7ba0, 3 instruction(s), falls into the block at 0x004c7bb1
    mov ecx, dword ptr [ebp - local_ac]          # 004c7ba2
    sub ecx, 0x1                                 # 004c7ba8
    mov dword ptr [ebp - local_ac], ecx          # 004c7bab
L_004c7bb1:
    # block 0x004c7bb1: entered by jne at 0x004c7b96; jne at 0x004c7ba0, 4 instruction(s), ends with je to 0x004c7bcd (forward)
    mov edx, dword ptr [ebp - local_c]           # 004c7bb1
    and edx, 0x1                                 # 004c7bb4
    test edx, edx                                # 004c7bb7
    je.d8 L_004c7bcd                             # 004c7bb9
    # block 0x004c7bbb: entered by fall-through of je at 0x004c7bb9, 3 instruction(s), falls into the block at 0x004c7bcd
    mov eax, dword ptr [ebp - local_b0]          # 004c7bbb
    add eax, dword ptr [ebp - local_a8]          # 004c7bc1
    mov dword ptr [ebp - local_b0], eax          # 004c7bc7
L_004c7bcd:
    # block 0x004c7bcd: entered by je at 0x004c7bb9, 14 instruction(s), calls FUN_004c880f, ends with forward jump to 0x004c7c11
    mov cx, word ptr [ebp + arg_1c]              # 004c7bcd
    push ecx                                     # 004c7bd1
    mov edx, dword ptr [ebp - local_ac]          # 004c7bd2
    push edx                                     # 004c7bd8
    mov eax, dword ptr [ebp - local_8]           # 004c7bd9
    push eax                                     # 004c7bdc
    mov ecx, dword ptr [ebp - local_90]          # 004c7bdd
    push ecx                                     # 004c7be3
    lea edx, [ebp - local_b4]                    # 004c7be4
    push edx                                     # 004c7bea
    mov ecx, dword ptr [ebp - local_bc]          # 004c7beb
    call FUN_004c880f                            # 004c7bf1
    mov dword ptr [ebp - local_a0], 0x0          # 004c7bf6
    jmp.d8 L_004c7c11                            # 004c7c00
L_004c7c02:
    # block 0x004c7c02: entered by jmp at 0x004c7c90, 3 instruction(s), falls into the block at 0x004c7c11
    mov eax, dword ptr [ebp - local_a0]          # 004c7c02
    add eax, 0x1                                 # 004c7c08
    mov dword ptr [ebp - local_a0], eax          # 004c7c0b
L_004c7c11:
    # block 0x004c7c11: entered by jmp at 0x004c7c00, 4 instruction(s), ends with jge to 0x004c7c95 (forward)
    mov ecx, dword ptr [ebp - local_a8]          # 004c7c11
    sub ecx, 0x1                                 # 004c7c17
    cmp dword ptr [ebp - local_a0], ecx          # 004c7c1a
    jge.d8 L_004c7c95                            # 004c7c20
    # block 0x004c7c22: entered by fall-through of jge at 0x004c7c20, 7 instruction(s), ends with jle to 0x004c7c67 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004c7c22
    mov dword ptr [ebp - local_8c], edx          # 004c7c25
    mov eax, dword ptr [ebp - local_b0]          # 004c7c2b
    add eax, dword ptr [ebp - local_94]          # 004c7c31
    mov dword ptr [ebp - local_b0], eax          # 004c7c37
    cmp dword ptr [ebp - local_b0], 0x0          # 004c7c3d
    jle.d8 L_004c7c67                            # 004c7c44
    # block 0x004c7c46: entered by fall-through of jle at 0x004c7c44, 6 instruction(s), falls into the block at 0x004c7c67
    mov ecx, dword ptr [ebp - local_8c]          # 004c7c46
    add ecx, 0x1                                 # 004c7c4c
    mov dword ptr [ebp - local_8c], ecx          # 004c7c4f
    mov edx, dword ptr [ebp - local_b0]          # 004c7c55
    sub edx, dword ptr [ebp - local_b8]          # 004c7c5b
    mov dword ptr [ebp - local_b0], edx          # 004c7c61
L_004c7c67:
    # block 0x004c7c67: entered by jle at 0x004c7c44, 13 instruction(s), calls FUN_004c880f, ends with backward jump to 0x004c7c02
    mov ax, word ptr [ebp + arg_1c]              # 004c7c67
    push eax                                     # 004c7c6b
    mov ecx, dword ptr [ebp - local_8c]          # 004c7c6c
    push ecx                                     # 004c7c72
    mov edx, dword ptr [ebp - local_8]           # 004c7c73
    push edx                                     # 004c7c76
    mov eax, dword ptr [ebp - local_90]          # 004c7c77
    push eax                                     # 004c7c7d
    lea ecx, [ebp - local_b4]                    # 004c7c7e
    push ecx                                     # 004c7c84
    mov ecx, dword ptr [ebp - local_bc]          # 004c7c85
    call FUN_004c880f                            # 004c7c8b
    jmp.d32 L_004c7c02                           # 004c7c90
L_004c7c95:
    # block 0x004c7c95: entered by jge at 0x004c7c20, 13 instruction(s), calls FUN_004c880f, ends with forward jump to 0x004c7cd8
    mov dx, word ptr [ebp + arg_1c]              # 004c7c95
    push edx                                     # 004c7c99
    mov eax, dword ptr [ebp - local_9c]          # 004c7c9a
    push eax                                     # 004c7ca0
    mov ecx, dword ptr [ebp - local_8]           # 004c7ca1
    push ecx                                     # 004c7ca4
    mov edx, dword ptr [ebp - local_90]          # 004c7ca5
    push edx                                     # 004c7cab
    lea eax, [ebp - local_b4]                    # 004c7cac
    push eax                                     # 004c7cb2
    mov ecx, dword ptr [ebp - local_bc]          # 004c7cb3
    call FUN_004c880f                            # 004c7cb9
    jmp.d8 L_004c7cd8                            # 004c7cbe
L_004c7cc0:
    # block 0x004c7cc0: entered by jmp at 0x004c7cd8; jmp at 0x004c7cda; jmp at 0x004c7cdc; jmp at 0x004c7cde; more, 7 instruction(s), calls FUN_004c4202, ends with forward jump to 0x004c7ce2
    push 0x555420                                # 004c7cc0
    push 0x0                                     # 004c7cc5
    mov ecx, dword ptr [ebp + arg_8]             # 004c7cc7
    push ecx                                     # 004c7cca
    mov ecx, dword ptr [ebp - local_bc]          # 004c7ccb
    call FUN_004c4202                            # 004c7cd1
    jmp.d8 L_004c7ce2                            # 004c7cd6
L_004c7cd8:
    # block 0x004c7cd8: entered by jmp at 0x004c7cbe, 1 instruction(s), ends with backward jump to 0x004c7cc0
    jmp.d8 L_004c7cc0                            # 004c7cd8
L_004c7cda:
    # block 0x004c7cda: entered by jmp at 0x004c7b1d, 1 instruction(s), ends with backward jump to 0x004c7cc0
    jmp.d8 L_004c7cc0                            # 004c7cda
L_004c7cdc:
    # block 0x004c7cdc: entered by jmp at 0x004c796a, 1 instruction(s), ends with backward jump to 0x004c7cc0
    jmp.d8 L_004c7cc0                            # 004c7cdc
L_004c7cde:
    # block 0x004c7cde: entered by jmp at 0x004c78fc, 1 instruction(s), ends with backward jump to 0x004c7cc0
    jmp.d8 L_004c7cc0                            # 004c7cde
L_004c7ce0:
    # block 0x004c7ce0: entered by jmp at 0x004c789b, 1 instruction(s), ends with backward jump to 0x004c7cc0
    jmp.d8 L_004c7cc0                            # 004c7ce0
L_004c7ce2:
    # block 0x004c7ce2: entered by jmp at 0x004c7cd6, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004c7ce2
    pop ebp                                      # 004c7ce4
    ret 0x18                                     # 004c7ce5

