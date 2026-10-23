# FUN_0047a1a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047a1a9
# extent:       0x0047a1a9-0x0047a28c (227 code bytes)
# span:         0x0047a1a9-0x0047a28c (code 227, tables 0, padding 0)
# sha256:       2fea5032ca68ce81560e0e7a8c01a4fd84788ab90fede4437d160f0b7f431a55
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047a1a9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_1e5, field_1590; [ecx + n] field_158e, field_1594; [edx + n] field_25, field_1592
# callees:      calls FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m47a1a9_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 65 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_1e5, 0x1e5  # offset +0x1e5
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590
.equ field_1592, 0x1592  # offset +0x1592
.equ field_1594, 0x1594  # offset +0x1594

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047a1a9 - 0x401000
.globl FUN_0047a1a9
FUN_0047a1a9:
    # block 0x0047a1a9: entry, 13 instruction(s), ends with forward jump to 0x0047a1de
    push ebp                                     # 0047a1a9
    {load} mov ebp, esp                          # 0047a1aa
    sub esp, 0x10                                # 0047a1ac
    push esi                                     # 0047a1af
    push edi                                     # 0047a1b0
    mov dword ptr [ebp - local_10], ecx          # 0047a1b1
    mov eax, dword ptr [ebp - local_10]          # 0047a1b4
    movsx ecx, word ptr [eax + field_1e]         # 0047a1b7
    imul ecx, ecx, 0x8d                          # 0047a1bb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047a1c1
    mov dword ptr [ebp - local_8], edx           # 0047a1c7
    mov word ptr [ebp - local_4], 0x0            # 0047a1ca
    jmp.d8 L_0047a1de                            # 0047a1d0
L_0047a1d2:
    # block 0x0047a1d2: entered by jmp at 0x0047a27f, 3 instruction(s), falls into the block at 0x0047a1de
    mov ax, word ptr [ebp - local_4]             # 0047a1d2
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047a1d6
    mov word ptr [ebp - local_4], ax             # 0047a1da
L_0047a1de:
    # block 0x0047a1de: entered by jmp at 0x0047a1d0, 5 instruction(s), ends with jge to 0x0047a284 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0047a1de
    mov edx, dword ptr [ebp - local_8]           # 0047a1e2
    movsx eax, word ptr [edx + field_25]         # 0047a1e5
    {load} cmp ecx, eax                          # 0047a1e9
    jge.d32 L_0047a284                           # 0047a1eb
    # block 0x0047a1f1: entered by fall-through of jge at 0x0047a1eb, 7 instruction(s), ends with jne to 0x0047a27f (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0047a1f1
    mov edx, dword ptr [ebp - local_10]          # 0047a1f5
    movsx eax, word ptr [edx + 4*ecx + field_1592] # 0047a1f8
    mov ecx, dword ptr [ebp - local_10]          # 0047a200
    movsx edx, word ptr [ecx + field_158e]       # 0047a203
    {load} cmp eax, edx                          # 0047a20a
    jne.d8 L_0047a27f                            # 0047a20c
    # block 0x0047a20e: entered by fall-through of jne at 0x0047a20c, 7 instruction(s), ends with jne to 0x0047a27f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0047a20e
    mov ecx, dword ptr [ebp - local_10]          # 0047a212
    movsx edx, word ptr [ecx + 4*eax + field_1594] # 0047a215
    mov eax, dword ptr [ebp - local_10]          # 0047a21d
    movsx ecx, word ptr [eax + field_1590]       # 0047a220
    {load} cmp edx, ecx                          # 0047a227
    jne.d8 L_0047a27f                            # 0047a229
    # block 0x0047a22b: entered by fall-through of jne at 0x0047a229, 7 instruction(s), ends with je to 0x0047a278 (forward)
    mov edi, 0x54cb98                            # 0047a22b
    mov esi, dword ptr [ebp - local_8]           # 0047a230
    add esi, 0x1c4                               # 0047a233
    mov ecx, 0x9                                 # 0047a239
    {load} xor edx, edx                          # 0047a23e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a240
    je.d8 L_0047a278                             # 0047a242
    # block 0x0047a244: entered by fall-through of je at 0x0047a242, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0047a278 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047a244
    movsx ecx, word ptr [eax + field_1e5]        # 0047a247
    mov dword ptr [ebp - local_c], ecx           # 0047a24e
    mov edx, dword ptr [ebp - local_c]           # 0047a251
    push edx                                     # 0047a254
    mov ecx, 0x5cf1eb                            # 0047a255
    call FUN_004f6334                            # 0047a25a
    test eax, eax                                # 0047a25f
    jne.d8 L_0047a278                            # 0047a261
    # block 0x0047a263: entered by fall-through of jne at 0x0047a261, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0047a278
    mov eax, dword ptr [ebp - local_8]           # 0047a263
    mov cx, word ptr [eax + field_1e5]           # 0047a266
    push ecx                                     # 0047a26d
    mov ecx, 0x5c3a67                            # 0047a26e
    call FUN_004fb2e3                            # 0047a273
L_0047a278:
    # block 0x0047a278: entered by je at 0x0047a242; jne at 0x0047a261, 2 instruction(s), ends with forward jump to 0x0047a286
    mov eax, 0x1                                 # 0047a278
    jmp.d8 L_0047a286                            # 0047a27d
L_0047a27f:
    # block 0x0047a27f: entered by jne at 0x0047a20c; jne at 0x0047a229, 1 instruction(s), ends with backward jump to 0x0047a1d2
    jmp.d32 L_0047a1d2                           # 0047a27f
L_0047a284:
    # block 0x0047a284: entered by jge at 0x0047a1eb, 1 instruction(s), falls into the block at 0x0047a286
    {load} xor eax, eax                          # 0047a284
L_0047a286:
    # block 0x0047a286: entered by jmp at 0x0047a27d, 5 instruction(s), ends with ret
    pop edi                                      # 0047a286
    pop esi                                      # 0047a287
    {load} mov esp, ebp                          # 0047a288
    pop ebp                                      # 0047a28a
    ret                                          # 0047a28b

