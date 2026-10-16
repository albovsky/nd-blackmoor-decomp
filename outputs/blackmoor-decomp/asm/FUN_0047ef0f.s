# FUN_0047ef0f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ef0f
# extent:       0x0047ef0f-0x0047f19d (654 code bytes)
# span:         0x0047ef0f-0x0047f19d (code 654, tables 0, padding 0)
# sha256:       0c6c8d351a99931dc42e062ce0e8d723958f482c0cd44a7c0082360fdcbf7e6b
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047ef0f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_49, field_7be, field_7c2, field_7d7, field_1344, field_1350, field_13c5, field_13e3, field_13e5; [ecx + n] field_48, field_7d7, field_1344, field_1350, field_13ca, field_13e5, field_1417; [edx + n] field_1e, field_e9, field_7a0, field_7c2, field_1350, field_13ce, field_13e3; [esi + n] field_7b6, field_7ba
# callees:      calls FUN_0047fa11, FUN_0047e9d3, FUN_00480abe, FUN_0047ed96
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 163 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_48, 0x48  # offset +0x48
.equ field_49, 0x49  # offset +0x49
.equ field_e9, 0xe9  # offset +0xe9
.equ field_7a0, 0x7a0  # offset +0x7a0
.equ field_7b6, 0x7b6  # offset +0x7b6
.equ field_7ba, 0x7ba  # offset +0x7ba
.equ field_7be, 0x7be  # offset +0x7be
.equ field_7c2, 0x7c2  # offset +0x7c2
.equ field_7d7, 0x7d7  # offset +0x7d7
.equ field_1344, 0x1344  # offset +0x1344
.equ field_1350, 0x1350  # offset +0x1350
.equ field_13c5, 0x13c5  # offset +0x13c5
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13ce, 0x13ce  # offset +0x13ce
.equ field_13e3, 0x13e3  # offset +0x13e3
.equ field_13e5, 0x13e5  # offset +0x13e5
.equ field_1417, 0x1417  # offset +0x1417

# --- external targets -----------------------------------------------
.set FUN_0047e9d3, .text + (0x0047e9d3 - 0x401000)
.set FUN_0047ed96, .text + (0x0047ed96 - 0x401000)
.set FUN_0047fa11, .text + (0x0047fa11 - 0x401000)
.set FUN_00480abe, .text + (0x00480abe - 0x401000)

.org 0x0047ef0f - 0x401000
.globl FUN_0047ef0f
FUN_0047ef0f:
    # block 0x0047ef0f: entry, 14 instruction(s), ends with je to 0x0047f197 (forward)
    push ebp                                     # 0047ef0f
    {load} mov ebp, esp                          # 0047ef10
    sub esp, 0xc                                 # 0047ef12
    push ebx                                     # 0047ef15
    push esi                                     # 0047ef16
    mov dword ptr [ebp - local_c], ecx           # 0047ef17
    mov eax, dword ptr [ebp - local_c]           # 0047ef1a
    movsx ecx, word ptr [eax + field_1e]         # 0047ef1d
    imul ecx, ecx, 0x8d                          # 0047ef21
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047ef27
    mov dword ptr [ebp - local_4], edx           # 0047ef2d
    mov eax, dword ptr [ebp - local_c]           # 0047ef30
    cmp dword ptr [eax + field_13c5], 0x0        # 0047ef33
    je.d32 L_0047f197                            # 0047ef3a
    # block 0x0047ef40: entered by fall-through of je at 0x0047ef3a, 5 instruction(s), ends with je to 0x0047f197 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047ef40
    {load} xor edx, edx                          # 0047ef43
    mov dl, byte ptr [ecx + field_48]            # 0047ef45
    test edx, edx                                # 0047ef48
    je.d32 L_0047f197                            # 0047ef4a
    # block 0x0047ef50: entered by fall-through of je at 0x0047ef4a, 5 instruction(s), ends with jne to 0x0047f197 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047ef50
    {load} xor ecx, ecx                          # 0047ef53
    mov cl, byte ptr [eax + field_49]            # 0047ef55
    test ecx, ecx                                # 0047ef58
    jne.d32 L_0047f197                           # 0047ef5a
    # block 0x0047ef60: entered by fall-through of jne at 0x0047ef5a, 5 instruction(s), ends with jne to 0x0047f197 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047ef60
    {load} xor eax, eax                          # 0047ef63
    mov al, byte ptr [edx + field_13ce]          # 0047ef65
    test eax, eax                                # 0047ef6b
    jne.d32 L_0047f197                           # 0047ef6d
    # block 0x0047ef73: entered by fall-through of jne at 0x0047ef6d, 3 instruction(s), ends with jne to 0x0047f197 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047ef73
    cmp dword ptr [ecx + field_13ca], 0x0        # 0047ef76
    jne.d32 L_0047f197                           # 0047ef7d
    # block 0x0047ef83: entered by fall-through of jne at 0x0047ef7d, 5 instruction(s), ends with jne to 0x0047f197 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047ef83
    movsx eax, word ptr [edx + field_1e]         # 0047ef86
    imul eax, eax, 0x8d                          # 0047ef8a
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0047ef90
    jne.d32 L_0047f197                           # 0047ef97
    # block 0x0047ef9d: entered by fall-through of jne at 0x0047ef97, 4 instruction(s), ends with je to 0x0047f197 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047ef9d
    movsx edx, word ptr [ecx + field_1417]       # 0047efa0
    test edx, edx                                # 0047efa7
    je.d32 L_0047f197                            # 0047efa9
    # block 0x0047efaf: entered by fall-through of je at 0x0047efa9, 3 instruction(s), ends with je to 0x0047f033 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047efaf
    cmp dword ptr [eax + field_1344], 0x0        # 0047efb2
    je.d8 L_0047f033                             # 0047efb9
    # block 0x0047efbb: entered by fall-through of je at 0x0047efb9, 28 instruction(s), calls FUN_0047fa11, ends with forward jump to 0x0047f182
    mov ecx, dword ptr [ebp - local_c]           # 0047efbb
    mov dx, word ptr [ecx + field_1350]          # 0047efbe
    mov word ptr [ebp - local_8], dx             # 0047efc5
    mov ax, word ptr [ebp - local_8]             # 0047efc9
    push eax                                     # 0047efcd
    mov ecx, dword ptr [ebp - local_c]           # 0047efce
    call FUN_0047fa11                            # 0047efd1
    movsx ecx, word ptr [ebp - local_8]          # 0047efd6
    imul ecx, ecx, 0x25                          # 0047efda
    movsx edx, word ptr [ebp - local_8]          # 0047efdd
    imul edx, edx, 0x25                          # 0047efe1
    mov eax, dword ptr [ebp - local_c]           # 0047efe4
    mov esi, dword ptr [ebp - local_c]           # 0047efe7
    mov ecx, dword ptr [eax + ecx + field_7be]   # 0047efea
    sub ecx, dword ptr [esi + edx + field_7b6]   # 0047eff1
    mov edx, dword ptr [ebp - local_c]           # 0047eff8
    mov word ptr [edx + field_13e3], cx          # 0047effb
    movsx eax, word ptr [ebp - local_8]          # 0047f002
    imul eax, eax, 0x25                          # 0047f006
    movsx ecx, word ptr [ebp - local_8]          # 0047f009
    imul ecx, ecx, 0x25                          # 0047f00d
    mov edx, dword ptr [ebp - local_c]           # 0047f010
    mov esi, dword ptr [ebp - local_c]           # 0047f013
    mov eax, dword ptr [edx + eax + field_7c2]   # 0047f016
    sub eax, dword ptr [esi + ecx + field_7ba]   # 0047f01d
    mov ecx, dword ptr [ebp - local_c]           # 0047f024
    mov word ptr [ecx + field_13e5], ax          # 0047f027
    jmp.d32 L_0047f182                           # 0047f02e
L_0047f033:
    # block 0x0047f033: entered by je at 0x0047efb9, 6 instruction(s), calls FUN_0047e9d3, ends with jne to 0x0047f04d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047f033
    call FUN_0047e9d3                            # 0047f036
    mov word ptr [ebp - local_8], ax             # 0047f03b
    movsx edx, word ptr [ebp - local_8]          # 0047f03f
    cmp edx, -0x1                                # 0047f043
    jne.d8 L_0047f04d                            # 0047f046
    # block 0x0047f048: entered by fall-through of jne at 0x0047f046, 1 instruction(s), ends with forward jump to 0x0047f197
    jmp.d32 L_0047f197                           # 0047f048
L_0047f04d:
    # block 0x0047f04d: entered by jne at 0x0047f046, 44 instruction(s), calls FUN_0047fa11, ends with jle to 0x0047f182 (forward)
    mov ax, word ptr [ebp - local_8]             # 0047f04d
    push eax                                     # 0047f051
    mov ecx, dword ptr [ebp - local_c]           # 0047f052
    call FUN_0047fa11                            # 0047f055
    mov ecx, dword ptr [ebp - local_c]           # 0047f05a
    mov dword ptr [ecx + field_1344], 0x1        # 0047f05d
    mov edx, dword ptr [ebp - local_c]           # 0047f067
    mov ax, word ptr [ebp - local_8]             # 0047f06a
    mov word ptr [edx + field_1350], ax          # 0047f06e
    mov ecx, dword ptr [ebp - local_c]           # 0047f075
    movsx edx, word ptr [ecx + field_1350]       # 0047f078
    imul edx, edx, 0x25                          # 0047f07f
    mov eax, dword ptr [ebp - local_c]           # 0047f082
    movsx ecx, word ptr [eax + field_1350]       # 0047f085
    imul ecx, ecx, 0x25                          # 0047f08c
    mov eax, dword ptr [ebp - local_c]           # 0047f08f
    mov esi, dword ptr [ebp - local_c]           # 0047f092
    mov edx, dword ptr [eax + edx + field_7be]   # 0047f095
    sub edx, dword ptr [esi + ecx + field_7b6]   # 0047f09c
    mov eax, dword ptr [ebp - local_c]           # 0047f0a3
    mov word ptr [eax + field_13e3], dx          # 0047f0a6
    mov ecx, dword ptr [ebp - local_c]           # 0047f0ad
    movsx edx, word ptr [ecx + field_1350]       # 0047f0b0
    imul edx, edx, 0x25                          # 0047f0b7
    mov eax, dword ptr [ebp - local_c]           # 0047f0ba
    movsx ecx, word ptr [eax + field_1350]       # 0047f0bd
    imul ecx, ecx, 0x25                          # 0047f0c4
    mov eax, dword ptr [ebp - local_c]           # 0047f0c7
    mov esi, dword ptr [ebp - local_c]           # 0047f0ca
    mov edx, dword ptr [eax + edx + field_7c2]   # 0047f0cd
    sub edx, dword ptr [esi + ecx + field_7ba]   # 0047f0d4
    mov eax, dword ptr [ebp - local_c]           # 0047f0db
    mov word ptr [eax + field_13e5], dx          # 0047f0de
    mov ecx, dword ptr [ebp - local_c]           # 0047f0e5
    movsx edx, word ptr [ecx + field_1350]       # 0047f0e8
    imul edx, edx, 0x25                          # 0047f0ef
    mov eax, dword ptr [ebp - local_c]           # 0047f0f2
    {load} xor ecx, ecx                          # 0047f0f5
    mov cl, byte ptr [eax + edx + field_7d7]     # 0047f0f7
    mov edx, dword ptr [ebp - local_c]           # 0047f0fe
    {load} xor eax, eax                          # 0047f101
    mov al, byte ptr [edx + ecx + field_7a0]     # 0047f103
    test eax, eax                                # 0047f10a
    jle.d8 L_0047f182                            # 0047f10c
    # block 0x0047f10e: entered by fall-through of jle at 0x0047f10c, 12 instruction(s), ends with jne to 0x0047f182 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047f10e
    movsx edx, word ptr [ecx + field_1350]       # 0047f111
    imul edx, edx, 0x25                          # 0047f118
    mov eax, dword ptr [ebp - local_c]           # 0047f11b
    {load} xor ecx, ecx                          # 0047f11e
    mov cl, byte ptr [eax + edx + field_7d7]     # 0047f120
    imul ecx, ecx, 0x53                          # 0047f127
    mov edx, dword ptr [ebp - local_4]           # 0047f12a
    {load} xor eax, eax                          # 0047f12d
    mov al, byte ptr [edx + ecx + field_e9]      # 0047f12f
    test eax, eax                                # 0047f136
    jne.d8 L_0047f182                            # 0047f138
    # block 0x0047f13a: entered by fall-through of jne at 0x0047f138, 17 instruction(s), falls into the block at 0x0047f182
    mov ecx, dword ptr [ebp - local_c]           # 0047f13a
    movsx edx, word ptr [ecx + field_1350]       # 0047f13d
    imul edx, edx, 0x25                          # 0047f144
    mov eax, dword ptr [ebp - local_c]           # 0047f147
    {load} xor ecx, ecx                          # 0047f14a
    mov cl, byte ptr [eax + edx + field_7d7]     # 0047f14c
    mov edx, dword ptr [ebp - local_c]           # 0047f153
    mov al, byte ptr [edx + ecx + field_7a0]     # 0047f156
    sub al, 0x1                                  # 0047f15d
    mov ecx, dword ptr [ebp - local_c]           # 0047f15f
    movsx edx, word ptr [ecx + field_1350]       # 0047f162
    imul edx, edx, 0x25                          # 0047f169
    mov ecx, dword ptr [ebp - local_c]           # 0047f16c
    {load} xor ebx, ebx                          # 0047f16f
    mov bl, byte ptr [ecx + edx + field_7d7]     # 0047f171
    mov edx, dword ptr [ebp - local_c]           # 0047f178
    mov byte ptr [edx + ebx + field_7a0], al     # 0047f17b
L_0047f182:
    # block 0x0047f182: entered by jmp at 0x0047f02e; jle at 0x0047f10c; jne at 0x0047f138, 6 instruction(s), calls FUN_00480abe, FUN_0047ed96, falls into the block at 0x0047f197
    mov ecx, dword ptr [ebp - local_c]           # 0047f182
    call FUN_00480abe                            # 0047f185
    mov ax, word ptr [ebp - local_8]             # 0047f18a
    push eax                                     # 0047f18e
    mov ecx, dword ptr [ebp - local_c]           # 0047f18f
    call FUN_0047ed96                            # 0047f192
L_0047f197:
    # block 0x0047f197: entered by je at 0x0047ef3a; je at 0x0047ef4a; jne at 0x0047ef5a; jne at 0x0047ef6d; more, 5 instruction(s), ends with ret
    pop esi                                      # 0047f197
    pop ebx                                      # 0047f198
    {load} mov esp, ebp                          # 0047f199
    pop ebp                                      # 0047f19b
    ret                                          # 0047f19c

