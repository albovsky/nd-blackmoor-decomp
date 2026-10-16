# FUN_004e4bc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e4bc4
# extent:       0x004e4bc4-0x004e4cb6 (242 code bytes)
# span:         0x004e4bc4-0x004e4cb6 (code 242, tables 0, padding 0)
# sha256:       3a7d147b588169e2ba439f50cda5a10abe4f36814d4db592d304d17429000ee4
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e4bc4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1473; [edx + n] field_1473, field_1475
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1473, 0x1473  # offset +0x1473
.equ field_1475, 0x1475  # offset +0x1475

# --- external targets -----------------------------------------------

.org 0x004e4bc4 - 0x401000
.globl FUN_004e4bc4
FUN_004e4bc4:
    # block 0x004e4bc4: entry, 16 instruction(s), ends with forward jump to 0x004e4c03
    push ebp                                     # 004e4bc4
    {load} mov ebp, esp                          # 004e4bc5
    sub esp, 0x8                                 # 004e4bc7
    push esi                                     # 004e4bca
    push edi                                     # 004e4bcb
    mov dword ptr [ebp - local_8], ecx           # 004e4bcc
    mov ecx, 0x200                               # 004e4bcf
    {load} xor eax, eax                          # 004e4bd4
    mov edi, dword ptr [ebp - local_8]           # 004e4bd6
    add edi, 0x1475                              # 004e4bd9
    rep stosd dword ptr es:[edi], eax            # 004e4bdf
    stosw word ptr es:[edi], ax                  # 004e4be1
    mov eax, dword ptr [ebp - local_8]           # 004e4be3
    mov word ptr [eax + field_1473], 0x0         # 004e4be6
    mov word ptr [ebp - local_4], 0x0            # 004e4bef
    jmp.d8 L_004e4c03                            # 004e4bf5
L_004e4bf7:
    # block 0x004e4bf7: entered by jmp at 0x004e4cab, 3 instruction(s), falls into the block at 0x004e4c03
    mov cx, word ptr [ebp - local_4]             # 004e4bf7
    add cx, 0x1                                  # 004e4bfb
    mov word ptr [ebp - local_4], cx             # 004e4bff
L_004e4c03:
    # block 0x004e4c03: entered by jmp at 0x004e4bf5, 4 instruction(s), ends with jge to 0x004e4cb0 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4c03
    movsx eax, word ptr [0x5a1e5c]               # 004e4c07
    {load} cmp edx, eax                          # 004e4c0e
    jge.d32 L_004e4cb0                           # 004e4c10
    # block 0x004e4c16: entered by fall-through of jge at 0x004e4c10, 5 instruction(s), ends with je to 0x004e4c67 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e4c16
    imul ecx, ecx, 0x29                          # 004e4c1a
    movsx edx, word ptr [ecx + 0x5a1e62]         # 004e4c1d
    cmp edx, 0xa                                 # 004e4c24
    je.d8 L_004e4c67                             # 004e4c27
    # block 0x004e4c29: entered by fall-through of je at 0x004e4c27, 5 instruction(s), ends with je to 0x004e4cab (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e4c29
    imul eax, eax, 0x29                          # 004e4c2d
    movsx ecx, word ptr [eax + 0x5a1e62]         # 004e4c30
    cmp ecx, 0xa                                 # 004e4c37
    je.d8 L_004e4cab                             # 004e4c3a
    # block 0x004e4c3c: entered by fall-through of je at 0x004e4c3a, 5 instruction(s), ends with je to 0x004e4cab (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4c3c
    imul edx, edx, 0x29                          # 004e4c40
    movsx eax, word ptr [edx + 0x5a1e62]         # 004e4c43
    cmp eax, 0xb                                 # 004e4c4a
    je.d8 L_004e4cab                             # 004e4c4d
    # block 0x004e4c4f: entered by fall-through of je at 0x004e4c4d, 5 instruction(s), ends with jne to 0x004e4cab (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e4c4f
    imul ecx, ecx, 0x29                          # 004e4c53
    movsx edx, word ptr [ecx + 0x5a1e62]         # 004e4c56
    cmp dword ptr [4*edx + 0x585801], 0x1        # 004e4c5d
    jne.d8 L_004e4cab                            # 004e4c65
L_004e4c67:
    # block 0x004e4c67: entered by je at 0x004e4c27; fall-through of jne at 0x004e4c65, 16 instruction(s), falls into the block at 0x004e4cab
    movsx esi, word ptr [ebp - local_4]          # 004e4c67
    imul esi, esi, 0x29                          # 004e4c6b
    add esi, 0x5a1e62                            # 004e4c6e
    mov eax, dword ptr [ebp - local_8]           # 004e4c74
    movsx ecx, word ptr [eax + field_1473]       # 004e4c77
    imul ecx, ecx, 0x29                          # 004e4c7e
    mov edx, dword ptr [ebp - local_8]           # 004e4c81
    lea edi, [edx + ecx + field_1475]            # 004e4c84
    mov ecx, 0xa                                 # 004e4c8b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e4c90
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e4c92
    mov eax, dword ptr [ebp - local_8]           # 004e4c93
    mov cx, word ptr [eax + field_1473]          # 004e4c96
    add cx, 0x1                                  # 004e4c9d
    mov edx, dword ptr [ebp - local_8]           # 004e4ca1
    mov word ptr [edx + field_1473], cx          # 004e4ca4
L_004e4cab:
    # block 0x004e4cab: entered by je at 0x004e4c3a; je at 0x004e4c4d; jne at 0x004e4c65, 1 instruction(s), ends with backward jump to 0x004e4bf7
    jmp.d32 L_004e4bf7                           # 004e4cab
L_004e4cb0:
    # block 0x004e4cb0: entered by jge at 0x004e4c10, 5 instruction(s), ends with ret
    pop edi                                      # 004e4cb0
    pop esi                                      # 004e4cb1
    {load} mov esp, ebp                          # 004e4cb2
    pop ebp                                      # 004e4cb4
    ret                                          # 004e4cb5

