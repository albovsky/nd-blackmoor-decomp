# FUN_0047ff0e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ff0e
# extent:       0x0047ff0e-0x004809a7 (2713 code bytes)
# span:         0x0047ff0e-0x004809a7 (code 2713, tables 0, padding 0)
# sha256:       19986566febb5109f5458ed6341eab19852391102aae71d8eb551559033c9fc7
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47ff0e_handle_click
# naming:       native port src/original_methods_fl22b.c:m47ff0e_handle_click (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m47ff0e_handle_click. Caption longer than 200 is rejected natively (original overruns its frame; direct test only). Unicorn differential: 300 fixtures, all instructions. Window covers 2713 bytes. See tasks/fl22b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_d8, local_dc
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_5e, field_b9, field_7a0, field_7b6, field_7be, field_7c2, field_7c6, field_7c9 and 13 more; [ecx + n] field_4, field_8, field_c, field_1e, field_5e, field_e9, field_7a0, field_7b6, field_7c6, field_7d7, field_1344, field_1348 and 5 more; [edi + n] field_minus_1; [edx + n] field_4, field_8, field_c, field_a9, field_e9, field_7a0, field_7b6, field_7d6, field_7d7, field_7d8, field_1344, field_1350 and 6 more; [esi + n] field_7b6, field_7ba
# callees:      calls FUN_00480b34, FUN_0047e8fe, FUN_0047fa11, FUN_00480abe, FUN_0047e9d3, FUN_0047fb76, FUN_0047e582, FUN_0047ed96, FUN_0047e99e, FUN_0047e52f, FUN_004809a7, FUN_00480a1d, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_00423259, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl22b.c:m47ff0e_handle_click (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 583 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_5e, 0x5e  # offset +0x5e
.equ field_a9, 0xa9  # offset +0xa9
.equ field_b9, 0xb9  # offset +0xb9
.equ field_e9, 0xe9  # offset +0xe9
.equ field_7a0, 0x7a0  # offset +0x7a0
.equ field_7b6, 0x7b6  # offset +0x7b6
.equ field_7ba, 0x7ba  # offset +0x7ba
.equ field_7be, 0x7be  # offset +0x7be
.equ field_7c2, 0x7c2  # offset +0x7c2
.equ field_7c6, 0x7c6  # offset +0x7c6
.equ field_7c9, 0x7c9  # offset +0x7c9
.equ field_7d6, 0x7d6  # offset +0x7d6
.equ field_7d7, 0x7d7  # offset +0x7d7
.equ field_7d8, 0x7d8  # offset +0x7d8
.equ field_1344, 0x1344  # offset +0x1344
.equ field_1348, 0x1348  # offset +0x1348
.equ field_134c, 0x134c  # offset +0x134c
.equ field_1350, 0x1350  # offset +0x1350
.equ field_13a2, 0x13a2  # offset +0x13a2
.equ field_13b0, 0x13b0  # offset +0x13b0
.equ field_13b1, 0x13b1  # offset +0x13b1
.equ field_13c5, 0x13c5  # offset +0x13c5
.equ field_13c9, 0x13c9  # offset +0x13c9
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13ce, 0x13ce  # offset +0x13ce
.equ field_13df, 0x13df  # offset +0x13df
.equ field_13e3, 0x13e3  # offset +0x13e3
.equ field_13e5, 0x13e5  # offset +0x13e5
.equ field_13e7, 0x13e7  # offset +0x13e7

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047e582, .text + (0x0047e582 - 0x401000)
.set FUN_0047e8fe, .text + (0x0047e8fe - 0x401000)
.set FUN_0047e99e, .text + (0x0047e99e - 0x401000)
.set FUN_0047e9d3, .text + (0x0047e9d3 - 0x401000)
.set FUN_0047ed96, .text + (0x0047ed96 - 0x401000)
.set FUN_0047fa11, .text + (0x0047fa11 - 0x401000)
.set FUN_0047fb76, .text + (0x0047fb76 - 0x401000)
.set FUN_004809a7, .text + (0x004809a7 - 0x401000)
.set FUN_00480a1d, .text + (0x00480a1d - 0x401000)
.set FUN_00480abe, .text + (0x00480abe - 0x401000)
.set FUN_00480b34, .text + (0x00480b34 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047ff0e - 0x401000
.globl FUN_0047ff0e
FUN_0047ff0e:
    # block 0x0047ff0e: entry, 16 instruction(s), ends with je to 0x004809a0 (forward)
    push ebp                                     # 0047ff0e
    {load} mov ebp, esp                          # 0047ff0f
    sub esp, 0xdc                                # 0047ff11
    push ebx                                     # 0047ff17
    push esi                                     # 0047ff18
    push edi                                     # 0047ff19
    mov dword ptr [ebp - local_dc], ecx          # 0047ff1a
    mov dword ptr [ebp - local_c], 0x0           # 0047ff20
    mov eax, dword ptr [ebp - local_dc]          # 0047ff27
    movsx ecx, word ptr [eax + field_1e]         # 0047ff2d
    imul ecx, ecx, 0x8d                          # 0047ff31
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047ff37
    mov dword ptr [ebp - local_4], edx           # 0047ff3d
    mov eax, dword ptr [ebp - local_dc]          # 0047ff40
    cmp dword ptr [eax + field_13c5], 0x0        # 0047ff46
    je.d32 L_004809a0                            # 0047ff4d
    # block 0x0047ff53: entered by fall-through of je at 0x0047ff4d, 5 instruction(s), ends with jne to 0x004809a0 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 0047ff53
    {load} xor edx, edx                          # 0047ff59
    mov dl, byte ptr [ecx + field_13ce]          # 0047ff5b
    test edx, edx                                # 0047ff61
    jne.d32 L_004809a0                           # 0047ff63
    # block 0x0047ff69: entered by fall-through of jne at 0x0047ff63, 3 instruction(s), ends with jne to 0x004809a0 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 0047ff69
    cmp dword ptr [eax + field_13ca], 0x0        # 0047ff6f
    jne.d32 L_004809a0                           # 0047ff76
    # block 0x0047ff7c: entered by fall-through of jne at 0x0047ff76, 5 instruction(s), ends with jne to 0x004809a0 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 0047ff7c
    movsx edx, word ptr [ecx + field_1e]         # 0047ff82
    imul edx, edx, 0x8d                          # 0047ff86
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0047ff8c
    jne.d32 L_004809a0                           # 0047ff93
    # block 0x0047ff99: entered by fall-through of jne at 0x0047ff93, 2 instruction(s), ends with je to 0x0047ffb1 (forward)
    cmp dword ptr [0x5c39e5], 0x278f             # 0047ff99
    je.d8 L_0047ffb1                             # 0047ffa3
    # block 0x0047ffa5: entered by fall-through of je at 0x0047ffa3, 2 instruction(s), ends with jne to 0x0047fffa (forward)
    cmp dword ptr [0x5c39e5], 0x2790             # 0047ffa5
    jne.d8 L_0047fffa                            # 0047ffaf
L_0047ffb1:
    # block 0x0047ffb1: entered by je at 0x0047ffa3; fall-through of jne at 0x0047ffaf, 11 instruction(s), calls FUN_00480b34, ends with jne to 0x0047fff5 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 0047ffb1
    movsx ecx, word ptr [eax + field_1e]         # 0047ffb7
    imul ecx, ecx, 0x8d                          # 0047ffbb
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0047ffc1
    mov ecx, dword ptr [ebp - local_dc]          # 0047ffcb
    call FUN_00480b34                            # 0047ffd1
    mov edx, dword ptr [ebp - local_dc]          # 0047ffd6
    {load} xor eax, eax                          # 0047ffdc
    mov al, byte ptr [edx + field_13ce]          # 0047ffde
    test eax, eax                                # 0047ffe4
    jne.d8 L_0047fff5                            # 0047ffe6
    # block 0x0047ffe8: entered by fall-through of jne at 0x0047ffe6, 2 instruction(s), falls into the block at 0x0047fff5
    mov ecx, dword ptr [ebp - local_dc]          # 0047ffe8
    mov byte ptr [ecx + field_13c9], 0x1         # 0047ffee
L_0047fff5:
    # block 0x0047fff5: entered by jne at 0x0047ffe6, 1 instruction(s), ends with forward jump to 0x004809a0
    jmp.d32 L_004809a0                           # 0047fff5
L_0047fffa:
    # block 0x0047fffa: entered by jne at 0x0047ffaf, 2 instruction(s), ends with jne to 0x004800f6 (forward)
    cmp dword ptr [0x5c39e5], 0x278e             # 0047fffa
    jne.d32 L_004800f6                           # 00480004
    # block 0x0048000a: entered by fall-through of jne at 0x00480004, 6 instruction(s), calls FUN_0047e8fe, ends with jne to 0x00480027 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 0048000a
    call FUN_0047e8fe                            # 00480010
    mov word ptr [ebp - local_8], ax             # 00480015
    movsx edx, word ptr [ebp - local_8]          # 00480019
    cmp edx, -0x1                                # 0048001d
    jne.d8 L_00480027                            # 00480020
    # block 0x00480022: entered by fall-through of jne at 0x00480020, 1 instruction(s), ends with forward jump to 0x004809a0
    jmp.d32 L_004809a0                           # 00480022
L_00480027:
    # block 0x00480027: entered by jne at 0x00480020, 36 instruction(s), calls FUN_0047fa11, FUN_00480abe, ends with forward jump to 0x004809a0
    mov ax, word ptr [ebp - local_8]             # 00480027
    push eax                                     # 0048002b
    mov ecx, dword ptr [ebp - local_dc]          # 0048002c
    call FUN_0047fa11                            # 00480032
    mov ecx, dword ptr [ebp - local_dc]          # 00480037
    call FUN_00480abe                            # 0048003d
    mov ecx, dword ptr [ebp - local_dc]          # 00480042
    mov dword ptr [ecx + field_1344], 0x1        # 00480048
    mov edx, dword ptr [ebp - local_dc]          # 00480052
    mov ax, word ptr [ebp - local_8]             # 00480058
    mov word ptr [edx + field_1350], ax          # 0048005c
    mov ecx, dword ptr [ebp - local_dc]          # 00480063
    movsx edx, word ptr [ecx + field_1350]       # 00480069
    imul edx, edx, 0x25                          # 00480070
    mov eax, dword ptr [ebp - local_dc]          # 00480073
    movsx ecx, word ptr [eax + field_1350]       # 00480079
    imul ecx, ecx, 0x25                          # 00480080
    mov eax, dword ptr [ebp - local_dc]          # 00480083
    mov esi, dword ptr [ebp - local_dc]          # 00480089
    mov edx, dword ptr [eax + edx + field_7be]   # 0048008f
    sub edx, dword ptr [esi + ecx + field_7b6]   # 00480096
    mov eax, dword ptr [ebp - local_dc]          # 0048009d
    mov word ptr [eax + field_13e3], dx          # 004800a3
    mov ecx, dword ptr [ebp - local_dc]          # 004800aa
    movsx edx, word ptr [ecx + field_1350]       # 004800b0
    imul edx, edx, 0x25                          # 004800b7
    mov eax, dword ptr [ebp - local_dc]          # 004800ba
    movsx ecx, word ptr [eax + field_1350]       # 004800c0
    imul ecx, ecx, 0x25                          # 004800c7
    mov eax, dword ptr [ebp - local_dc]          # 004800ca
    mov esi, dword ptr [ebp - local_dc]          # 004800d0
    mov edx, dword ptr [eax + edx + field_7c2]   # 004800d6
    sub edx, dword ptr [esi + ecx + field_7ba]   # 004800dd
    mov eax, dword ptr [ebp - local_dc]          # 004800e4
    mov word ptr [eax + field_13e5], dx          # 004800ea
    jmp.d32 L_004809a0                           # 004800f1
L_004800f6:
    # block 0x004800f6: entered by jne at 0x00480004, 3 instruction(s), ends with jne to 0x00480111 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 004800f6
    cmp dword ptr [ecx + field_1344], 0x0        # 004800fc
    jne.d8 L_00480111                            # 00480103
    # block 0x00480105: entered by fall-through of jne at 0x00480103, 2 instruction(s), ends with je to 0x0048013a (forward)
    cmp dword ptr [0x5c39e5], 0x278d             # 00480105
    je.d8 L_0048013a                             # 0048010f
L_00480111:
    # block 0x00480111: entered by jne at 0x00480103; fall-through of je at 0x0048010f, 3 instruction(s), ends with je to 0x00480524 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 00480111
    cmp dword ptr [edx + field_1344], 0x0        # 00480117
    je.d32 L_00480524                            # 0048011e
    # block 0x00480124: entered by fall-through of je at 0x0048011e, 5 instruction(s), ends with je to 0x00480524 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 00480124
    {load} xor ecx, ecx                          # 0048012a
    mov cl, byte ptr [eax + field_13b1]          # 0048012c
    test ecx, ecx                                # 00480132
    je.d32 L_00480524                            # 00480134
L_0048013a:
    # block 0x0048013a: entered by je at 0x0048010f; fall-through of je at 0x00480134, 7 instruction(s), ends with je to 0x004801b0 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 0048013a
    mov dword ptr [edx + field_1344], 0x1        # 00480140
    mov eax, dword ptr [ebp - local_dc]          # 0048014a
    {load} xor ecx, ecx                          # 00480150
    mov cl, byte ptr [eax + field_13b0]          # 00480152
    test ecx, ecx                                # 00480158
    je.d8 L_004801b0                             # 0048015a
    # block 0x0048015c: entered by fall-through of je at 0x0048015a, 5 instruction(s), ends with jne to 0x004801b0 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 0048015c
    {load} xor eax, eax                          # 00480162
    mov al, byte ptr [edx + field_13b1]          # 00480164
    test eax, eax                                # 0048016a
    jne.d8 L_004801b0                            # 0048016c
    # block 0x0048016e: entered by fall-through of jne at 0x0048016c, 13 instruction(s), calls FUN_0047e9d3, FUN_0047fb76, ends with forward jump to 0x0048051f
    mov ecx, dword ptr [ebp - local_dc]          # 0048016e
    call FUN_0047e9d3                            # 00480174
    mov word ptr [ebp - local_8], ax             # 00480179
    mov ecx, dword ptr [ebp - local_dc]          # 0048017d
    mov dx, word ptr [ebp - local_8]             # 00480183
    mov word ptr [ecx + field_1350], dx          # 00480187
    mov ax, word ptr [ebp - local_8]             # 0048018e
    push eax                                     # 00480192
    mov ecx, dword ptr [ebp - local_dc]          # 00480193
    call FUN_0047fb76                            # 00480199
    mov ecx, dword ptr [ebp - local_dc]          # 0048019e
    mov byte ptr [ecx + field_13b1], 0x1         # 004801a4
    jmp.d32 L_0048051f                           # 004801ab
L_004801b0:
    # block 0x004801b0: entered by je at 0x0048015a; jne at 0x0048016c, 5 instruction(s), ends with jne to 0x004801e2 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004801b0
    {load} xor eax, eax                          # 004801b6
    mov al, byte ptr [edx + field_13b0]          # 004801b8
    test eax, eax                                # 004801be
    jne.d8 L_004801e2                            # 004801c0
    # block 0x004801c2: entered by fall-through of jne at 0x004801c0, 6 instruction(s), calls FUN_0047e9d3, falls into the block at 0x004801e2
    mov ecx, dword ptr [ebp - local_dc]          # 004801c2
    call FUN_0047e9d3                            # 004801c8
    mov word ptr [ebp - local_8], ax             # 004801cd
    mov ecx, dword ptr [ebp - local_dc]          # 004801d1
    mov dx, word ptr [ebp - local_8]             # 004801d7
    mov word ptr [ecx + field_1350], dx          # 004801db
L_004801e2:
    # block 0x004801e2: entered by jne at 0x004801c0, 12 instruction(s), ends with je to 0x00480286 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 004801e2
    movsx ecx, word ptr [eax + field_1350]       # 004801e8
    imul ecx, ecx, 0x25                          # 004801ef
    mov edx, dword ptr [ebp - local_dc]          # 004801f2
    {load} xor eax, eax                          # 004801f8
    mov al, byte ptr [edx + ecx + field_7d7]     # 004801fa
    imul eax, eax, 0x53                          # 00480201
    mov ecx, dword ptr [ebp - local_4]           # 00480204
    {load} xor edx, edx                          # 00480207
    mov dl, byte ptr [ecx + eax + field_e9]      # 00480209
    test edx, edx                                # 00480210
    je.d8 L_00480286                             # 00480212
    # block 0x00480214: entered by fall-through of je at 0x00480212, 22 instruction(s), calls FUN_0047e582, FUN_0047ed96, falls into the block at 0x00480286
    push 0x1                                     # 00480214
    mov eax, dword ptr [ebp - local_dc]          # 00480216
    movsx ecx, word ptr [eax + field_1350]       # 0048021c
    imul ecx, ecx, 0x25                          # 00480223
    mov edx, dword ptr [ebp - local_dc]          # 00480226
    movzx ax, byte ptr [edx + ecx + field_7d7]   # 0048022c
    push eax                                     # 00480235
    mov ecx, dword ptr [ebp - local_dc]          # 00480236
    mov dx, word ptr [ecx + field_13a2]          # 0048023c
    push edx                                     # 00480243
    mov ecx, dword ptr [ebp - local_dc]          # 00480244
    call FUN_0047e582                            # 0048024a
    mov eax, dword ptr [ebp - local_dc]          # 0048024f
    mov cx, word ptr [eax + field_13a2]          # 00480255
    push ecx                                     # 0048025c
    mov ecx, dword ptr [ebp - local_dc]          # 0048025d
    call FUN_0047ed96                            # 00480263
    mov edx, dword ptr [ebp - local_dc]          # 00480268
    mov ax, word ptr [edx + field_13a2]          # 0048026e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00480275
    mov ecx, dword ptr [ebp - local_dc]          # 00480279
    mov word ptr [ecx + field_13a2], ax          # 0048027f
L_00480286:
    # block 0x00480286: entered by je at 0x00480212, 33 instruction(s), calls FUN_0047e99e, ends with je to 0x0048037d (forward)
    mov edx, dword ptr [ebp - local_dc]          # 00480286
    mov byte ptr [edx + field_13b1], 0x0         # 0048028c
    mov eax, dword ptr [ebp - local_dc]          # 00480293
    mov dword ptr [eax + field_134c], 0x1        # 00480299
    mov ecx, dword ptr [ebp - local_dc]          # 004802a3
    movsx edx, word ptr [ecx + field_1350]       # 004802a9
    imul edx, edx, 0x25                          # 004802b0
    mov eax, dword ptr [ebp - local_dc]          # 004802b3
    lea ecx, [eax + edx + field_7b6]             # 004802b9
    mov edx, dword ptr [ebp - local_dc]          # 004802c0
    add edx, 0x1392                              # 004802c6
    mov eax, dword ptr [ecx]                     # 004802cc
    mov dword ptr [edx], eax                     # 004802ce
    mov eax, dword ptr [ecx + field_4]           # 004802d0
    mov dword ptr [edx + field_4], eax           # 004802d3
    mov eax, dword ptr [ecx + field_8]           # 004802d6
    mov dword ptr [edx + field_8], eax           # 004802d9
    mov ecx, dword ptr [ecx + field_c]           # 004802dc
    mov dword ptr [edx + field_c], ecx           # 004802df
    mov edx, dword ptr [ebp - local_dc]          # 004802e2
    movsx eax, word ptr [edx + field_1350]       # 004802e8
    imul eax, eax, 0x25                          # 004802ef
    mov ecx, dword ptr [ebp - local_dc]          # 004802f2
    {load} xor edx, edx                          # 004802f8
    mov dl, byte ptr [ecx + eax + field_7d7]     # 004802fa
    imul edx, edx, 0x53                          # 00480301
    mov eax, dword ptr [ebp - local_4]           # 00480304
    lea ecx, [eax + edx + field_b9]              # 00480307
    push ecx                                     # 0048030e
    mov ecx, dword ptr [ebp - local_dc]          # 0048030f
    call FUN_0047e99e                            # 00480315
    test eax, eax                                # 0048031a
    je.d8 L_0048037d                             # 0048031c
    # block 0x0048031e: entered by fall-through of je at 0x0048031c, 22 instruction(s), falls into the block at 0x0048037d
    mov edx, dword ptr [ebp - local_dc]          # 0048031e
    movsx eax, word ptr [edx + field_1350]       # 00480324
    imul eax, eax, 0x25                          # 0048032b
    mov ecx, dword ptr [ebp - local_dc]          # 0048032e
    {load} xor edx, edx                          # 00480334
    mov dl, byte ptr [ecx + eax + field_7d7]     # 00480336
    imul edx, edx, 0x53                          # 0048033d
    mov eax, dword ptr [ebp - local_4]           # 00480340
    lea ecx, [eax + edx + field_b9]              # 00480343
    mov edx, dword ptr [ebp - local_dc]          # 0048034a
    movsx eax, word ptr [edx + field_1350]       # 00480350
    imul eax, eax, 0x25                          # 00480357
    mov edx, dword ptr [ebp - local_dc]          # 0048035a
    lea eax, [edx + eax + field_7b6]             # 00480360
    mov edx, dword ptr [ecx]                     # 00480367
    mov dword ptr [eax], edx                     # 00480369
    mov edx, dword ptr [ecx + field_4]           # 0048036b
    mov dword ptr [eax + field_4], edx           # 0048036e
    mov edx, dword ptr [ecx + field_8]           # 00480371
    mov dword ptr [eax + field_8], edx           # 00480374
    mov ecx, dword ptr [ecx + field_c]           # 00480377
    mov dword ptr [eax + field_c], ecx           # 0048037a
L_0048037d:
    # block 0x0048037d: entered by je at 0x0048031c, 49 instruction(s), calls FUN_0047e52f, ends with jle to 0x00480514 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 0048037d
    movsx eax, word ptr [edx + field_1350]       # 00480383
    imul eax, eax, 0x25                          # 0048038a
    mov ecx, dword ptr [ebp - local_dc]          # 0048038d
    lea edx, [ecx + eax + field_7c6]             # 00480393
    push edx                                     # 0048039a
    mov eax, dword ptr [ebp - local_dc]          # 0048039b
    movsx ecx, word ptr [eax + field_1350]       # 004803a1
    imul ecx, ecx, 0x25                          # 004803a8
    mov edx, dword ptr [ebp - local_dc]          # 004803ab
    lea eax, [edx + ecx + field_7b6]             # 004803b1
    push eax                                     # 004803b8
    mov ecx, dword ptr [ebp - local_dc]          # 004803b9
    call FUN_0047e52f                            # 004803bf
    mov ecx, dword ptr [ebp - local_dc]          # 004803c4
    movsx edx, word ptr [ecx + field_1350]       # 004803ca
    imul edx, edx, 0x25                          # 004803d1
    mov eax, dword ptr [ebp - local_dc]          # 004803d4
    movsx ecx, word ptr [eax + field_1350]       # 004803da
    imul ecx, ecx, 0x25                          # 004803e1
    mov eax, dword ptr [ebp - local_dc]          # 004803e4
    mov esi, dword ptr [ebp - local_dc]          # 004803ea
    mov edx, dword ptr [eax + edx + field_7be]   # 004803f0
    sub edx, dword ptr [esi + ecx + field_7b6]   # 004803f7
    mov eax, dword ptr [ebp - local_dc]          # 004803fe
    mov word ptr [eax + field_13e3], dx          # 00480404
    mov ecx, dword ptr [ebp - local_dc]          # 0048040b
    movsx edx, word ptr [ecx + field_1350]       # 00480411
    imul edx, edx, 0x25                          # 00480418
    mov eax, dword ptr [ebp - local_dc]          # 0048041b
    movsx ecx, word ptr [eax + field_1350]       # 00480421
    imul ecx, ecx, 0x25                          # 00480428
    mov eax, dword ptr [ebp - local_dc]          # 0048042b
    mov esi, dword ptr [ebp - local_dc]          # 00480431
    mov edx, dword ptr [eax + edx + field_7c2]   # 00480437
    sub edx, dword ptr [esi + ecx + field_7ba]   # 0048043e
    mov eax, dword ptr [ebp - local_dc]          # 00480445
    mov word ptr [eax + field_13e5], dx          # 0048044b
    mov ecx, dword ptr [ebp - local_dc]          # 00480452
    movsx edx, word ptr [ecx + field_1350]       # 00480458
    imul edx, edx, 0x25                          # 0048045f
    mov eax, dword ptr [ebp - local_dc]          # 00480462
    {load} xor ecx, ecx                          # 00480468
    mov cl, byte ptr [eax + edx + field_7d7]     # 0048046a
    mov edx, dword ptr [ebp - local_dc]          # 00480471
    {load} xor eax, eax                          # 00480477
    mov al, byte ptr [edx + ecx + field_7a0]     # 00480479
    test eax, eax                                # 00480480
    jle.d32 L_00480514                           # 00480482
    # block 0x00480488: entered by fall-through of jle at 0x00480482, 12 instruction(s), ends with jne to 0x00480514 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 00480488
    movsx edx, word ptr [ecx + field_1350]       # 0048048e
    imul edx, edx, 0x25                          # 00480495
    mov eax, dword ptr [ebp - local_dc]          # 00480498
    {load} xor ecx, ecx                          # 0048049e
    mov cl, byte ptr [eax + edx + field_7d7]     # 004804a0
    imul ecx, ecx, 0x53                          # 004804a7
    mov edx, dword ptr [ebp - local_4]           # 004804aa
    {load} xor eax, eax                          # 004804ad
    mov al, byte ptr [edx + ecx + field_e9]      # 004804af
    test eax, eax                                # 004804b6
    jne.d8 L_00480514                            # 004804b8
    # block 0x004804ba: entered by fall-through of jne at 0x004804b8, 17 instruction(s), falls into the block at 0x00480514
    mov ecx, dword ptr [ebp - local_dc]          # 004804ba
    movsx edx, word ptr [ecx + field_1350]       # 004804c0
    imul edx, edx, 0x25                          # 004804c7
    mov eax, dword ptr [ebp - local_dc]          # 004804ca
    {load} xor ecx, ecx                          # 004804d0
    mov cl, byte ptr [eax + edx + field_7d7]     # 004804d2
    mov edx, dword ptr [ebp - local_dc]          # 004804d9
    mov al, byte ptr [edx + ecx + field_7a0]     # 004804df
    sub al, 0x1                                  # 004804e6
    mov ecx, dword ptr [ebp - local_dc]          # 004804e8
    movsx edx, word ptr [ecx + field_1350]       # 004804ee
    imul edx, edx, 0x25                          # 004804f5
    mov ecx, dword ptr [ebp - local_dc]          # 004804f8
    {load} xor ebx, ebx                          # 004804fe
    mov bl, byte ptr [ecx + edx + field_7d7]     # 00480500
    mov edx, dword ptr [ebp - local_dc]          # 00480507
    mov byte ptr [edx + ebx + field_7a0], al     # 0048050d
L_00480514:
    # block 0x00480514: entered by jle at 0x00480482; jne at 0x004804b8, 2 instruction(s), calls FUN_004809a7, falls into the block at 0x0048051f
    mov ecx, dword ptr [ebp - local_dc]          # 00480514
    call FUN_004809a7                            # 0048051a
L_0048051f:
    # block 0x0048051f: entered by jmp at 0x004801ab, 1 instruction(s), ends with forward jump to 0x004809a0
    jmp.d32 L_004809a0                           # 0048051f
L_00480524:
    # block 0x00480524: entered by je at 0x0048011e; je at 0x00480134, 2 instruction(s), ends with jne to 0x004809a0 (forward)
    cmp dword ptr [0x5c39e5], 0x2791             # 00480524
    jne.d32 L_004809a0                           # 0048052e
    # block 0x00480534: entered by fall-through of jne at 0x0048052e, 42 instruction(s), calls FUN_0047ed96, ends with je to 0x00480697 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 00480534
    mov dword ptr [eax + field_1344], 0x0        # 0048053a
    mov ecx, dword ptr [ebp - local_dc]          # 00480544
    mov dword ptr [ecx + field_1348], 0x1        # 0048054a
    mov edx, dword ptr [ebp - local_dc]          # 00480554
    add edx, 0x1352                              # 0048055a
    mov eax, dword ptr [ebp - local_dc]          # 00480560
    movsx ecx, word ptr [eax + field_1350]       # 00480566
    imul ecx, ecx, 0x25                          # 0048056d
    mov eax, dword ptr [ebp - local_dc]          # 00480570
    lea ecx, [eax + ecx + field_7b6]             # 00480576
    mov eax, dword ptr [edx]                     # 0048057d
    mov dword ptr [ecx], eax                     # 0048057f
    mov eax, dword ptr [edx + field_4]           # 00480581
    mov dword ptr [ecx + field_4], eax           # 00480584
    mov eax, dword ptr [edx + field_8]           # 00480587
    mov dword ptr [ecx + field_8], eax           # 0048058a
    mov edx, dword ptr [edx + field_c]           # 0048058d
    mov dword ptr [ecx + field_c], edx           # 00480590
    mov eax, dword ptr [ebp - local_dc]          # 00480593
    add eax, 0x1372                              # 00480599
    mov ecx, dword ptr [ebp - local_dc]          # 0048059e
    movsx edx, word ptr [ecx + field_1350]       # 004805a4
    imul edx, edx, 0x25                          # 004805ab
    mov ecx, dword ptr [ebp - local_dc]          # 004805ae
    lea edx, [ecx + edx + field_7c6]             # 004805b4
    mov ecx, dword ptr [eax]                     # 004805bb
    mov dword ptr [edx], ecx                     # 004805bd
    mov ecx, dword ptr [eax + field_4]           # 004805bf
    mov dword ptr [edx + field_4], ecx           # 004805c2
    mov ecx, dword ptr [eax + field_8]           # 004805c5
    mov dword ptr [edx + field_8], ecx           # 004805c8
    mov eax, dword ptr [eax + field_c]           # 004805cb
    mov dword ptr [edx + field_c], eax           # 004805ce
    mov ecx, dword ptr [ebp - local_dc]          # 004805d1
    mov dx, word ptr [ecx + field_1350]          # 004805d7
    push edx                                     # 004805de
    mov ecx, dword ptr [ebp - local_dc]          # 004805df
    call FUN_0047ed96                            # 004805e5
    mov eax, dword ptr [ebp - local_dc]          # 004805ea
    cmp dword ptr [eax + field_13df], 0x0        # 004805f0
    je.d32 L_00480697                            # 004805f7
    # block 0x004805fd: entered by fall-through of je at 0x004805f7, 5 instruction(s), ends with je to 0x00480697 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004805fd
    {load} xor edx, edx                          # 00480600
    mov dl, byte ptr [ecx + field_5e]            # 00480602
    cmp edx, 0x2                                 # 00480605
    je.d32 L_00480697                            # 00480608
    # block 0x0048060e: entered by fall-through of je at 0x00480608, 25 instruction(s), calls FUN_00480a1d, ends with forward jump to 0x00480991
    mov eax, dword ptr [ebp - local_dc]          # 0048060e
    movsx ecx, word ptr [eax + field_1350]       # 00480614
    imul ecx, ecx, 0x25                          # 0048061b
    mov edx, dword ptr [ebp - local_dc]          # 0048061e
    mov byte ptr [edx + ecx + field_7d8], 0x1    # 00480624
    mov eax, dword ptr [ebp - local_dc]          # 0048062c
    movsx ecx, word ptr [eax + field_1350]       # 00480632
    imul ecx, ecx, 0x25                          # 00480639
    mov edx, dword ptr [ebp - local_dc]          # 0048063c
    {load} xor eax, eax                          # 00480642
    mov al, byte ptr [edx + ecx + field_7d7]     # 00480644
    mov ecx, dword ptr [ebp - local_dc]          # 0048064b
    mov dl, byte ptr [ecx + eax + field_7a0]     # 00480651
    add dl, 0x1                                  # 00480658
    mov eax, dword ptr [ebp - local_dc]          # 0048065b
    movsx ecx, word ptr [eax + field_1350]       # 00480661
    imul ecx, ecx, 0x25                          # 00480668
    mov eax, dword ptr [ebp - local_dc]          # 0048066b
    {load} xor ebx, ebx                          # 00480671
    mov bl, byte ptr [eax + ecx + field_7d7]     # 00480673
    mov ecx, dword ptr [ebp - local_dc]          # 0048067a
    mov byte ptr [ecx + ebx + field_7a0], dl     # 00480680
    mov ecx, dword ptr [ebp - local_dc]          # 00480687
    call FUN_00480a1d                            # 0048068d
    jmp.d32 L_00480991                           # 00480692
L_00480697:
    # block 0x00480697: entered by je at 0x004805f7; je at 0x00480608, 3 instruction(s), ends with je to 0x0048071e (forward)
    mov edx, dword ptr [ebp - local_dc]          # 00480697
    cmp dword ptr [edx + field_13df], 0x0        # 0048069d
    je.d8 L_0048071e                             # 004806a4
    # block 0x004806a6: entered by fall-through of je at 0x004806a4, 5 instruction(s), ends with jne to 0x0048071e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004806a6
    {load} xor ecx, ecx                          # 004806a9
    mov cl, byte ptr [eax + field_5e]            # 004806ab
    cmp ecx, 0x2                                 # 004806ae
    jne.d8 L_0048071e                            # 004806b1
    # block 0x004806b3: entered by fall-through of jne at 0x004806b1, 20 instruction(s), calls FUN_00480a1d, ends with forward jump to 0x004808af
    mov edx, dword ptr [ebp - local_dc]          # 004806b3
    movsx eax, word ptr [edx + field_1350]       # 004806b9
    imul eax, eax, 0x25                          # 004806c0
    mov ecx, dword ptr [ebp - local_dc]          # 004806c3
    {load} xor edx, edx                          # 004806c9
    mov dl, byte ptr [ecx + eax + field_7d7]     # 004806cb
    mov eax, dword ptr [ebp - local_dc]          # 004806d2
    mov cl, byte ptr [eax + edx + field_7a0]     # 004806d8
    add cl, 0x1                                  # 004806df
    mov edx, dword ptr [ebp - local_dc]          # 004806e2
    movsx eax, word ptr [edx + field_1350]       # 004806e8
    imul eax, eax, 0x25                          # 004806ef
    mov edx, dword ptr [ebp - local_dc]          # 004806f2
    {load} xor ebx, ebx                          # 004806f8
    mov bl, byte ptr [edx + eax + field_7d7]     # 004806fa
    mov eax, dword ptr [ebp - local_dc]          # 00480701
    mov byte ptr [eax + ebx + field_7a0], cl     # 00480707
    mov ecx, dword ptr [ebp - local_dc]          # 0048070e
    call FUN_00480a1d                            # 00480714
    jmp.d32 L_004808af                           # 00480719
L_0048071e:
    # block 0x0048071e: entered by je at 0x004806a4; jne at 0x004806b1, 7 instruction(s), ends with je to 0x004808af (forward)
    mov edi, 0x54d5a4                            # 0048071e
    mov esi, dword ptr [ebp - local_4]           # 00480723
    add esi, 0x7a8                               # 00480726
    mov ecx, 0x9                                 # 0048072c
    {load} xor edx, edx                          # 00480731
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00480733
    je.d32 L_004808af                            # 00480735
    # block 0x0048073b: entered by fall-through of je at 0x00480735, 13 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with je to 0x004808af (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048073b
    mov cx, word ptr [eax + field_7c9]           # 0048073e
    push ecx                                     # 00480745
    mov ecx, 0x5c3a67                            # 00480746
    call FUN_004fb2e3                            # 0048074b
    call dword ptr [0x52a23c]                    # 00480750
    add eax, 0xc8                                # 00480756
    mov edx, dword ptr [ebp - local_dc]          # 0048075b
    mov dword ptr [edx + field_13e7], eax        # 00480761
    mov eax, dword ptr [ebp - local_dc]          # 00480767
    mov dword ptr [eax + field_13ca], 0x1        # 0048076d
    cmp dword ptr [0x5bb202], 0x0                # 00480777
    je.d32 L_004808af                            # 0048077e
    # block 0x00480784: entered by fall-through of je at 0x0048077e, 9 instruction(s), ends with jbe to 0x00480832 (forward)
    mov edi, dword ptr [ebp - local_4]           # 00480784
    add edi, 0x7d9                               # 00480787
    or ecx, -0x1                                 # 0048078d
    {load} xor eax, eax                          # 00480790
    repne scasb al, byte ptr es:[edi]            # 00480792
    not ecx                                      # 00480794
    add ecx, -0x1                                # 00480796
    test ecx, ecx                                # 00480799
    jbe.d32 L_00480832                           # 0048079b
    # block 0x004807a1: entered by fall-through of jbe at 0x0048079b, 8 instruction(s), calls FUN_00423259, ends with je to 0x0048082b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004807a1
    add ecx, 0x7d9                               # 004807a4
    push ecx                                     # 004807aa
    mov ecx, 0x619a6b                            # 004807ab
    call FUN_00423259                            # 004807b0
    mov dword ptr [ebp - local_c], eax           # 004807b5
    cmp dword ptr [ebp - local_c], 0x0           # 004807b8
    je.d8 L_0048082b                             # 004807bc
    # block 0x004807be: entered by fall-through of je at 0x004807bc, 8 instruction(s), ends with ja to 0x0048082b (forward)
    mov edi, dword ptr [ebp - local_c]           # 004807be
    or ecx, -0x1                                 # 004807c1
    {load} xor eax, eax                          # 004807c4
    repne scasb al, byte ptr es:[edi]            # 004807c6
    not ecx                                      # 004807c8
    add ecx, -0x1                                # 004807ca
    cmp ecx, 0x9c40                              # 004807cd
    ja.d8 L_0048082b                             # 004807d3
    # block 0x004807d5: entered by fall-through of ja at 0x004807d3, 28 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00480832
    mov edi, dword ptr [ebp - local_c]           # 004807d5
    or ecx, -0x1                                 # 004807d8
    {load} xor eax, eax                          # 004807db
    repne scasb al, byte ptr es:[edi]            # 004807dd
    not ecx                                      # 004807df
    mov esi, dword ptr [ebp - local_c]           # 004807e1
    lea edi, [ebp - local_d8]                    # 004807e4
    {load} mov edx, ecx                          # 004807ea
    shr ecx, 0x2                                 # 004807ec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004807ef
    {load} mov ecx, edx                          # 004807f1
    and ecx, 0x3                                 # 004807f3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004807f6
    lea edi, [ebp - local_d8]                    # 004807f8
    or ecx, -0x1                                 # 004807fe
    {load} xor eax, eax                          # 00480801
    repne scasb al, byte ptr es:[edi]            # 00480803
    mov eax, dword ptr [0x54d5b0]                # 00480805
    mov dword ptr [edi - field_minus_1], eax     # 0048080a
    push 0x0                                     # 0048080d
    push -0x1                                    # 0048080f
    lea ecx, [ebp - local_d8]                    # 00480811
    push ecx                                     # 00480817
    mov edx, dword ptr [0x5d03b3]                # 00480818
    push edx                                     # 0048081e
    mov ecx, 0x619a05                            # 0048081f
    call FUN_00448d11                            # 00480824
    jmp.d8 L_00480832                            # 00480829
L_0048082b:
    # block 0x0048082b: entered by je at 0x004807bc; ja at 0x004807d3, 1 instruction(s), falls into the block at 0x00480832
    mov dword ptr [ebp - local_c], 0x0           # 0048082b
L_00480832:
    # block 0x00480832: entered by jbe at 0x0048079b; jmp at 0x00480829, 2 instruction(s), ends with jne to 0x004808af (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00480832
    jne.d8 L_004808af                            # 00480836
    # block 0x00480838: entered by fall-through of jne at 0x00480836, 9 instruction(s), ends with jbe to 0x004808af (forward)
    mov edi, dword ptr [ebp - local_4]           # 00480838
    add edi, 0x7fa                               # 0048083b
    or ecx, -0x1                                 # 00480841
    {load} xor eax, eax                          # 00480844
    repne scasb al, byte ptr es:[edi]            # 00480846
    not ecx                                      # 00480848
    add ecx, -0x1                                # 0048084a
    test ecx, ecx                                # 0048084d
    jbe.d8 L_004808af                            # 0048084f
    # block 0x00480851: entered by fall-through of jbe at 0x0048084f, 31 instruction(s), calls FUN_00448d11, falls into the block at 0x004808af
    mov eax, dword ptr [ebp - local_4]           # 00480851
    add eax, 0x7fa                               # 00480854
    {load} mov edi, eax                          # 00480859
    lea edx, [ebp - local_d8]                    # 0048085b
    or ecx, -0x1                                 # 00480861
    {load} xor eax, eax                          # 00480864
    repne scasb al, byte ptr es:[edi]            # 00480866
    not ecx                                      # 00480868
    {load} sub edi, ecx                          # 0048086a
    {load} mov esi, edi                          # 0048086c
    {load} mov eax, ecx                          # 0048086e
    {load} mov edi, edx                          # 00480870
    shr ecx, 0x2                                 # 00480872
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00480875
    {load} mov ecx, eax                          # 00480877
    and ecx, 0x3                                 # 00480879
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048087c
    lea edi, [ebp - local_d8]                    # 0048087e
    or ecx, -0x1                                 # 00480884
    {load} xor eax, eax                          # 00480887
    repne scasb al, byte ptr es:[edi]            # 00480889
    mov ecx, dword ptr [0x54d5b4]                # 0048088b
    mov dword ptr [edi - field_minus_1], ecx     # 00480891
    push 0x0                                     # 00480894
    push -0x1                                    # 00480896
    lea edx, [ebp - local_d8]                    # 00480898
    push edx                                     # 0048089e
    mov eax, dword ptr [0x5d03b3]                # 0048089f
    push eax                                     # 004808a4
    mov ecx, 0x619a05                            # 004808a5
    call FUN_00448d11                            # 004808aa
L_004808af:
    # block 0x004808af: entered by jmp at 0x00480719; je at 0x00480735; je at 0x0048077e; jne at 0x00480836; more, 46 instruction(s), calls FUN_0047e52f, falls into the block at 0x00480991
    mov ecx, dword ptr [ebp - local_dc]          # 004808af
    movsx edx, word ptr [ecx + field_1350]       # 004808b5
    imul edx, edx, 0x25                          # 004808bc
    mov eax, dword ptr [ebp - local_dc]          # 004808bf
    mov byte ptr [eax + edx + field_7d8], 0x0    # 004808c5
    mov ecx, dword ptr [ebp - local_dc]          # 004808cd
    movsx edx, word ptr [ecx + field_1350]       # 004808d3
    imul edx, edx, 0x25                          # 004808da
    mov eax, dword ptr [ebp - local_dc]          # 004808dd
    {load} xor ecx, ecx                          # 004808e3
    mov cl, byte ptr [eax + edx + field_7d7]     # 004808e5
    imul ecx, ecx, 0x53                          # 004808ec
    mov edx, dword ptr [ebp - local_4]           # 004808ef
    lea eax, [edx + ecx + field_a9]              # 004808f2
    mov ecx, dword ptr [ebp - local_dc]          # 004808f9
    movsx edx, word ptr [ecx + field_1350]       # 004808ff
    imul edx, edx, 0x25                          # 00480906
    mov ecx, dword ptr [ebp - local_dc]          # 00480909
    lea edx, [ecx + edx + field_7b6]             # 0048090f
    mov ecx, dword ptr [eax]                     # 00480916
    mov dword ptr [edx], ecx                     # 00480918
    mov ecx, dword ptr [eax + field_4]           # 0048091a
    mov dword ptr [edx + field_4], ecx           # 0048091d
    mov ecx, dword ptr [eax + field_8]           # 00480920
    mov dword ptr [edx + field_8], ecx           # 00480923
    mov eax, dword ptr [eax + field_c]           # 00480926
    mov dword ptr [edx + field_c], eax           # 00480929
    mov ecx, dword ptr [ebp - local_dc]          # 0048092c
    movsx edx, word ptr [ecx + field_1350]       # 00480932
    imul edx, edx, 0x25                          # 00480939
    mov eax, dword ptr [ebp - local_dc]          # 0048093c
    lea ecx, [eax + edx + field_7c6]             # 00480942
    push ecx                                     # 00480949
    mov edx, dword ptr [ebp - local_dc]          # 0048094a
    movsx eax, word ptr [edx + field_1350]       # 00480950
    imul eax, eax, 0x25                          # 00480957
    mov ecx, dword ptr [ebp - local_dc]          # 0048095a
    lea edx, [ecx + eax + field_7b6]             # 00480960
    push edx                                     # 00480967
    mov ecx, dword ptr [ebp - local_dc]          # 00480968
    call FUN_0047e52f                            # 0048096e
    mov eax, dword ptr [ebp - local_dc]          # 00480973
    movsx ecx, word ptr [eax + field_1350]       # 00480979
    imul ecx, ecx, 0x25                          # 00480980
    mov edx, dword ptr [ebp - local_dc]          # 00480983
    mov byte ptr [edx + ecx + field_7d6], 0x0    # 00480989
L_00480991:
    # block 0x00480991: entered by jmp at 0x00480692, 2 instruction(s), falls into the block at 0x004809a0
    mov eax, dword ptr [ebp - local_dc]          # 00480991
    mov word ptr [eax + field_1350], 0xffff      # 00480997
L_004809a0:
    # block 0x004809a0: entered by je at 0x0047ff4d; jne at 0x0047ff63; jne at 0x0047ff76; jne at 0x0047ff93; more, 6 instruction(s), ends with ret
    pop edi                                      # 004809a0
    pop esi                                      # 004809a1
    pop ebx                                      # 004809a2
    {load} mov esp, ebp                          # 004809a3
    pop ebp                                      # 004809a5
    ret                                          # 004809a6

