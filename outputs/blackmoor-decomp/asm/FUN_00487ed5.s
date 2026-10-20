# FUN_00487ed5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487ed5
# extent:       0x00487ed5-0x004881c9 (756 code bytes)
# span:         0x00487ed5-0x004881c9 (code 756, tables 0, padding 0)
# sha256:       650e438e73319c0554fe3d8c7d80e44ad20177639a8526db7de41dc7e3057ced
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487ed5_click_2788_2789
# naming:       native port src/original_methods_fl24b.c:m487ed5_click_2788_2789 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m487ed5_click_2788_2789 (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 600 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_25, field_65, field_66, field_6a, field_6c, field_71, field_7a, field_425, field_4cc, field_4fd; [ecx + n] field_23, field_25, field_65, field_66, field_6a, field_6c, field_75, field_78, field_425, field_447; [edx + n] field_1e, field_25, field_65, field_66, field_68, field_6a, field_76, field_447; [esi + n] field_7c
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m487ed5_click_2788_2789 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 196 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_65, 0x65  # offset +0x65
.equ field_66, 0x66  # offset +0x66
.equ field_68, 0x68  # offset +0x68
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6c, 0x6c  # offset +0x6c
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75
.equ field_76, 0x76  # offset +0x76
.equ field_78, 0x78  # offset +0x78
.equ field_7a, 0x7a  # offset +0x7a
.equ field_7c, 0x7c  # offset +0x7c
.equ field_425, 0x425  # offset +0x425
.equ field_447, 0x447  # offset +0x447
.equ field_4cc, 0x4cc  # offset +0x4cc
.equ field_4fd, 0x4fd  # offset +0x4fd

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00487ed5 - 0x401000
.globl FUN_00487ed5
FUN_00487ed5:
    # block 0x00487ed5: entry, 15 instruction(s), ends with je to 0x004881c3 (forward)
    push ebp                                     # 00487ed5
    {load} mov ebp, esp                          # 00487ed6
    sub esp, 0x10                                # 00487ed8
    push esi                                     # 00487edb
    push edi                                     # 00487edc
    mov dword ptr [ebp - local_10], ecx          # 00487edd
    mov dword ptr [ebp - local_4], 0x0           # 00487ee0
    mov eax, dword ptr [ebp - local_10]          # 00487ee7
    movsx ecx, word ptr [eax + field_1e]         # 00487eea
    imul ecx, ecx, 0x8d                          # 00487eee
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00487ef4
    mov dword ptr [ebp - local_8], edx           # 00487efa
    mov eax, dword ptr [ebp - local_10]          # 00487efd
    cmp dword ptr [eax + field_71], 0x0          # 00487f00
    je.d32 L_004881c3                            # 00487f04
    # block 0x00487f0a: entered by fall-through of je at 0x00487f04, 3 instruction(s), ends with jne to 0x004881c3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00487f0a
    cmp dword ptr [ecx + field_6c], 0x1          # 00487f0d
    jne.d32 L_004881c3                           # 00487f11
    # block 0x00487f17: entered by fall-through of jne at 0x00487f11, 5 instruction(s), ends with jne to 0x004881c3 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00487f17
    movsx eax, word ptr [edx + field_1e]         # 00487f1a
    imul eax, eax, 0x8d                          # 00487f1e
    cmp dword ptr [eax + 0x5bb632], 0x1          # 00487f24
    jne.d32 L_004881c3                           # 00487f2b
    # block 0x00487f31: entered by fall-through of jne at 0x00487f2b, 2 instruction(s), ends with jne to 0x00487f60 (forward)
    cmp dword ptr [0x5c39e5], 0x2789             # 00487f31
    jne.d8 L_00487f60                            # 00487f3b
    # block 0x00487f3d: entered by fall-through of jne at 0x00487f3b, 7 instruction(s), ends with forward jump to 0x004881c3
    mov ecx, dword ptr [ebp - local_10]          # 00487f3d
    mov byte ptr [ecx + field_75], 0x1           # 00487f40
    mov edx, dword ptr [ebp - local_10]          # 00487f44
    movsx eax, word ptr [edx + field_1e]         # 00487f47
    imul eax, eax, 0x8d                          # 00487f4b
    mov dword ptr [eax + 0x5bb632], 0x2          # 00487f51
    jmp.d32 L_004881c3                           # 00487f5b
L_00487f60:
    # block 0x00487f60: entered by jne at 0x00487f3b, 2 instruction(s), ends with jne to 0x004881c3 (forward)
    cmp dword ptr [0x5c39e5], 0x2788             # 00487f60
    jne.d32 L_004881c3                           # 00487f6a
    # block 0x00487f70: entered by fall-through of jne at 0x00487f6a, 5 instruction(s), ends with jne to 0x00487fbd (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00487f70
    {load} xor edx, edx                          # 00487f73
    mov dl, byte ptr [ecx + field_23]            # 00487f75
    test edx, edx                                # 00487f78
    jne.d8 L_00487fbd                            # 00487f7a
    # block 0x00487f7c: entered by fall-through of jne at 0x00487f7a, 5 instruction(s), ends with jne to 0x00487fb8 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00487f7c
    movsx ecx, word ptr [eax + field_66]         # 00487f7f
    mov edx, dword ptr [ebp - local_10]          # 00487f83
    cmp dword ptr [edx + 4*ecx + field_25], 0x0  # 00487f86
    jne.d8 L_00487fb8                            # 00487f8b
    # block 0x00487f8d: entered by fall-through of jne at 0x00487f8b, 11 instruction(s), falls into the block at 0x00487fb8
    mov eax, dword ptr [ebp - local_10]          # 00487f8d
    mov byte ptr [eax + field_65], 0x1           # 00487f90
    mov ecx, dword ptr [ebp - local_10]          # 00487f94
    mov dx, word ptr [ecx + field_6a]            # 00487f97
    add dx, 0x1                                  # 00487f9b
    mov eax, dword ptr [ebp - local_10]          # 00487f9f
    mov word ptr [eax + field_6a], dx            # 00487fa2
    mov ecx, dword ptr [ebp - local_10]          # 00487fa6
    movsx edx, word ptr [ecx + field_66]         # 00487fa9
    mov eax, dword ptr [ebp - local_10]          # 00487fad
    mov dword ptr [eax + 4*edx + field_25], 0x1  # 00487fb0
L_00487fb8:
    # block 0x00487fb8: entered by jne at 0x00487f8b, 1 instruction(s), ends with forward jump to 0x004880bc
    jmp.d32 L_004880bc                           # 00487fb8
L_00487fbd:
    # block 0x00487fbd: entered by jne at 0x00487f7a, 5 instruction(s), ends with jne to 0x00488001 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00487fbd
    movsx edx, word ptr [ecx + field_66]         # 00487fc0
    mov eax, dword ptr [ebp - local_10]          # 00487fc4
    cmp dword ptr [eax + 4*edx + field_25], 0x0  # 00487fc7
    jne.d8 L_00488001                            # 00487fcc
    # block 0x00487fce: entered by fall-through of jne at 0x00487fcc, 5 instruction(s), ends with jne to 0x00488001 (forward)
    movsx ecx, word ptr [0x583a29]               # 00487fce
    mov edx, dword ptr [ebp - local_8]           # 00487fd5
    movsx eax, word ptr [edx + field_447]        # 00487fd8
    {load} cmp ecx, eax                          # 00487fdf
    jne.d8 L_00488001                            # 00487fe1
    # block 0x00487fe3: entered by fall-through of jne at 0x00487fe1, 6 instruction(s), ends with forward jump to 0x004880bc
    mov dword ptr [ebp - local_4], 0x1           # 00487fe3
    mov ecx, dword ptr [ebp - local_10]          # 00487fea
    movsx edx, word ptr [ecx + field_66]         # 00487fed
    mov eax, dword ptr [ebp - local_10]          # 00487ff1
    mov dword ptr [eax + 4*edx + field_25], 0x2  # 00487ff4
    jmp.d32 L_004880bc                           # 00487ffc
L_00488001:
    # block 0x00488001: entered by jne at 0x00487fcc; jne at 0x00487fe1, 5 instruction(s), ends with jne to 0x0048803f (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00488001
    movsx edx, word ptr [ecx + field_66]         # 00488004
    mov eax, dword ptr [ebp - local_10]          # 00488008
    cmp dword ptr [eax + 4*edx + field_25], 0x0  # 0048800b
    jne.d8 L_0048803f                            # 00488010
    # block 0x00488012: entered by fall-through of jne at 0x00488010, 12 instruction(s), ends with forward jump to 0x004880bc
    mov ecx, dword ptr [ebp - local_10]          # 00488012
    mov byte ptr [ecx + field_65], 0x1           # 00488015
    mov edx, dword ptr [ebp - local_10]          # 00488019
    mov ax, word ptr [edx + field_6a]            # 0048801c
    .insn 0x66, 0x05, 0x0001{:u16}               # 00488020
    mov ecx, dword ptr [ebp - local_10]          # 00488024
    mov word ptr [ecx + field_6a], ax            # 00488027
    mov edx, dword ptr [ebp - local_10]          # 0048802b
    movsx eax, word ptr [edx + field_66]         # 0048802e
    mov ecx, dword ptr [ebp - local_10]          # 00488032
    mov dword ptr [ecx + 4*eax + field_25], 0x1  # 00488035
    jmp.d8 L_004880bc                            # 0048803d
L_0048803f:
    # block 0x0048803f: entered by jne at 0x00488010, 5 instruction(s), ends with jne to 0x0048807d (forward)
    mov edx, dword ptr [ebp - local_10]          # 0048803f
    movsx eax, word ptr [edx + field_66]         # 00488042
    mov ecx, dword ptr [ebp - local_10]          # 00488046
    cmp dword ptr [ecx + 4*eax + field_25], 0x2  # 00488049
    jne.d8 L_0048807d                            # 0048804e
    # block 0x00488050: entered by fall-through of jne at 0x0048804e, 12 instruction(s), ends with forward jump to 0x004880bc
    mov edx, dword ptr [ebp - local_10]          # 00488050
    mov byte ptr [edx + field_65], 0x1           # 00488053
    mov eax, dword ptr [ebp - local_10]          # 00488057
    mov cx, word ptr [eax + field_6a]            # 0048805a
    add cx, 0x1                                  # 0048805e
    mov edx, dword ptr [ebp - local_10]          # 00488062
    mov word ptr [edx + field_6a], cx            # 00488065
    mov eax, dword ptr [ebp - local_10]          # 00488069
    movsx ecx, word ptr [eax + field_66]         # 0048806c
    mov edx, dword ptr [ebp - local_10]          # 00488070
    mov dword ptr [edx + 4*ecx + field_25], 0x3  # 00488073
    jmp.d8 L_004880bc                            # 0048807b
L_0048807d:
    # block 0x0048807d: entered by jne at 0x0048804e, 5 instruction(s), ends with jne to 0x004880bc (forward)
    mov eax, dword ptr [ebp - local_10]          # 0048807d
    movsx ecx, word ptr [eax + field_66]         # 00488080
    mov edx, dword ptr [ebp - local_10]          # 00488084
    cmp dword ptr [edx + 4*ecx + field_25], 0x1  # 00488087
    jne.d8 L_004880bc                            # 0048808c
    # block 0x0048808e: entered by fall-through of jne at 0x0048808c, 5 instruction(s), ends with jne to 0x004880bc (forward)
    movsx eax, word ptr [0x583a29]               # 0048808e
    mov ecx, dword ptr [ebp - local_8]           # 00488095
    movsx edx, word ptr [ecx + field_447]        # 00488098
    {load} cmp eax, edx                          # 0048809f
    jne.d8 L_004880bc                            # 004880a1
    # block 0x004880a3: entered by fall-through of jne at 0x004880a1, 5 instruction(s), falls into the block at 0x004880bc
    mov eax, dword ptr [ebp - local_10]          # 004880a3
    movsx ecx, word ptr [eax + field_66]         # 004880a6
    mov edx, dword ptr [ebp - local_10]          # 004880aa
    mov dword ptr [edx + 4*ecx + field_25], 0x3  # 004880ad
    mov dword ptr [ebp - local_4], 0x1           # 004880b5
L_004880bc:
    # block 0x004880bc: entered by jmp at 0x00487fb8; jmp at 0x00487ffc; jmp at 0x0048803d; jmp at 0x0048807b; more, 5 instruction(s), ends with je to 0x0048816b (forward)
    mov eax, dword ptr [ebp - local_10]          # 004880bc
    {load} xor ecx, ecx                          # 004880bf
    mov cl, byte ptr [eax + field_65]            # 004880c1
    test ecx, ecx                                # 004880c4
    je.d32 L_0048816b                            # 004880c6
    # block 0x004880cc: entered by fall-through of je at 0x004880c6, 6 instruction(s), ends with forward jump to 0x004880ec
    mov edx, dword ptr [ebp - local_10]          # 004880cc
    mov eax, dword ptr [ebp - local_10]          # 004880cf
    mov cx, word ptr [eax + field_66]            # 004880d2
    mov word ptr [edx + field_68], cx            # 004880d6
    mov dword ptr [ebp - local_c], 0x0           # 004880da
    jmp.d8 L_004880ec                            # 004880e1
L_004880e3:
    # block 0x004880e3: entered by jmp at 0x00488114, 3 instruction(s), falls into the block at 0x004880ec
    mov edx, dword ptr [ebp - local_c]           # 004880e3
    add edx, 0x1                                 # 004880e6
    mov dword ptr [ebp - local_c], edx           # 004880e9
L_004880ec:
    # block 0x004880ec: entered by jmp at 0x004880e1, 5 instruction(s), ends with jge to 0x00488116 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004880ec
    movsx ecx, word ptr [eax + field_425]        # 004880ef
    sub ecx, 0x1                                 # 004880f6
    cmp dword ptr [ebp - local_c], ecx           # 004880f9
    jge.d8 L_00488116                            # 004880fc
    # block 0x004880fe: entered by fall-through of jge at 0x004880fc, 7 instruction(s), ends with backward jump to 0x004880e3
    mov edx, dword ptr [ebp - local_c]           # 004880fe
    mov eax, dword ptr [ebp - local_10]          # 00488101
    mov ecx, dword ptr [ebp - local_c]           # 00488104
    mov esi, dword ptr [ebp - local_10]          # 00488107
    mov cx, word ptr [esi + 2*ecx + field_7c]    # 0048810a
    mov word ptr [eax + 2*edx + field_7a], cx    # 0048810f
    jmp.d8 L_004880e3                            # 00488114
L_00488116:
    # block 0x00488116: entered by jge at 0x004880fc, 9 instruction(s), ends with je to 0x00488169 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00488116
    movsx eax, word ptr [edx + field_66]         # 00488119
    add eax, 0x1                                 # 0048811d
    mov ecx, dword ptr [ebp - local_8]           # 00488120
    movsx edx, word ptr [ecx + field_425]        # 00488123
    mov ecx, dword ptr [ebp - local_10]          # 0048812a
    mov word ptr [ecx + 2*edx + field_78], ax    # 0048812d
    cmp dword ptr [0x5bb1ca], 0x0                # 00488132
    je.d8 L_00488169                             # 00488139
    # block 0x0048813b: entered by fall-through of je at 0x00488139, 7 instruction(s), ends with je to 0x00488169 (forward)
    mov edi, 0x54de04                            # 0048813b
    mov esi, dword ptr [ebp - local_8]           # 00488140
    add esi, 0x4ab                               # 00488143
    mov ecx, 0x9                                 # 00488149
    {load} xor edx, edx                          # 0048814e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00488150
    je.d8 L_00488169                             # 00488152
    # block 0x00488154: entered by fall-through of je at 0x00488152, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00488169
    mov eax, dword ptr [ebp - local_8]           # 00488154
    mov cx, word ptr [eax + field_4cc]           # 00488157
    push ecx                                     # 0048815e
    mov ecx, 0x5c3a67                            # 0048815f
    call FUN_004fb2e3                            # 00488164
L_00488169:
    # block 0x00488169: entered by je at 0x00488139; je at 0x00488152, 1 instruction(s), ends with forward jump to 0x004881a8
    jmp.d8 L_004881a8                            # 00488169
L_0048816b:
    # block 0x0048816b: entered by je at 0x004880c6, 2 instruction(s), ends with je to 0x004881a8 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0048816b
    je.d8 L_004881a8                             # 0048816f
    # block 0x00488171: entered by fall-through of je at 0x0048816f, 2 instruction(s), ends with je to 0x004881a8 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 00488171
    je.d8 L_004881a8                             # 00488178
    # block 0x0048817a: entered by fall-through of je at 0x00488178, 7 instruction(s), ends with je to 0x004881a8 (forward)
    mov edi, 0x54de10                            # 0048817a
    mov esi, dword ptr [ebp - local_8]           # 0048817f
    add esi, 0x4dc                               # 00488182
    mov ecx, 0x9                                 # 00488188
    {load} xor edx, edx                          # 0048818d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048818f
    je.d8 L_004881a8                             # 00488191
    # block 0x00488193: entered by fall-through of je at 0x00488191, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004881a8
    mov eax, dword ptr [ebp - local_8]           # 00488193
    mov cx, word ptr [eax + field_4fd]           # 00488196
    push ecx                                     # 0048819d
    mov ecx, 0x5c3a67                            # 0048819e
    call FUN_004fb2e3                            # 004881a3
L_004881a8:
    # block 0x004881a8: entered by jmp at 0x00488169; je at 0x0048816f; je at 0x00488178; je at 0x00488191, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004881c3
    call dword ptr [0x52a23c]                    # 004881a8
    add eax, 0x1f4                               # 004881ae
    mov edx, dword ptr [ebp - local_10]          # 004881b3
    mov dword ptr [edx + field_76], eax          # 004881b6
    mov eax, dword ptr [ebp - local_10]          # 004881b9
    mov dword ptr [eax + field_6c], 0x0          # 004881bc
L_004881c3:
    # block 0x004881c3: entered by je at 0x00487f04; jne at 0x00487f11; jne at 0x00487f2b; jmp at 0x00487f5b; more, 5 instruction(s), ends with ret
    pop edi                                      # 004881c3
    pop esi                                      # 004881c4
    {load} mov esp, ebp                          # 004881c5
    pop ebp                                      # 004881c7
    ret                                          # 004881c8

