# FUN_0047a28c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047a28c
# extent:       0x0047a28c-0x0047a3d9 (333 code bytes)
# span:         0x0047a28c-0x0047a3d9 (code 333, tables 0, padding 0)
# sha256:       eaa8ac758ae81391bbebae78a42f629c7a3a82f8f767893a804b4b07bee65da4
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047a28c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_27, field_2b, field_1536, field_1586, field_159c; [ecx + n] field_29, field_1536, field_153e, field_159c; [edx + n] field_4, field_8, field_c, field_1c2, field_1586, field_159c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m47a28c_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 88 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1536, 0x1536  # offset +0x1536
.equ field_153e, 0x153e  # offset +0x153e
.equ field_1586, 0x1586  # offset +0x1586
.equ field_159c, 0x159c  # offset +0x159c

# --- external targets -----------------------------------------------

.org 0x0047a28c - 0x401000
.globl FUN_0047a28c
FUN_0047a28c:
    # block 0x0047a28c: entry, 16 instruction(s), ends with jge to 0x0047a3d0 (forward)
    push ebp                                     # 0047a28c
    {load} mov ebp, esp                          # 0047a28d
    sub esp, 0x10                                # 0047a28f
    mov dword ptr [ebp - local_10], ecx          # 0047a292
    mov eax, dword ptr [ebp - local_10]          # 0047a295
    movsx ecx, word ptr [eax + field_1e]         # 0047a298
    imul ecx, ecx, 0x8d                          # 0047a29c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047a2a2
    mov dword ptr [ebp - local_c], edx           # 0047a2a8
    mov eax, dword ptr [ebp - local_10]          # 0047a2ab
    movsx ecx, word ptr [eax + field_159c]       # 0047a2ae
    mov edx, dword ptr [ebp - local_c]           # 0047a2b5
    movsx eax, word ptr [edx + field_1c2]        # 0047a2b8
    add eax, 0x3                                 # 0047a2bf
    {load} cmp ecx, eax                          # 0047a2c2
    jge.d32 L_0047a3d0                           # 0047a2c4
    # block 0x0047a2ca: entered by fall-through of jge at 0x0047a2c4, 23 instruction(s), ends with jne to 0x0047a373 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047a2ca
    mov dx, word ptr [ecx + field_29]            # 0047a2cd
    mov word ptr [ebp - local_8], dx             # 0047a2d1
    mov eax, dword ptr [ebp - local_c]           # 0047a2d5
    mov cx, word ptr [eax + field_27]            # 0047a2d8
    mov word ptr [ebp - local_4], cx             # 0047a2dc
    mov edx, dword ptr [ebp - local_10]          # 0047a2e0
    add edx, 0x1536                              # 0047a2e3
    mov eax, dword ptr [ebp - local_10]          # 0047a2e9
    add eax, 0x1566                              # 0047a2ec
    mov ecx, dword ptr [edx]                     # 0047a2f1
    mov dword ptr [eax], ecx                     # 0047a2f3
    mov ecx, dword ptr [edx + field_4]           # 0047a2f5
    mov dword ptr [eax + field_4], ecx           # 0047a2f8
    mov ecx, dword ptr [edx + field_8]           # 0047a2fb
    mov dword ptr [eax + field_8], ecx           # 0047a2fe
    mov edx, dword ptr [edx + field_c]           # 0047a301
    mov dword ptr [eax + field_c], edx           # 0047a304
    mov eax, dword ptr [ebp - local_c]           # 0047a307
    {load} xor ecx, ecx                          # 0047a30a
    mov cl, byte ptr [eax + field_2b]            # 0047a30c
    cmp ecx, 0x1                                 # 0047a30f
    jne.d8 L_0047a373                            # 0047a312
    # block 0x0047a314: entered by fall-through of jne at 0x0047a312, 23 instruction(s), ends with forward jump to 0x0047a3d0
    mov edx, dword ptr [ebp - local_c]           # 0047a314
    movsx ecx, word ptr [edx + field_1c2]        # 0047a317
    mov edx, dword ptr [ebp - local_10]          # 0047a31e
    mov eax, dword ptr [edx + field_1586]        # 0047a321
    cdq                                          # 0047a327
    idiv ecx                                     # 0047a328
    mov ecx, dword ptr [ebp - local_10]          # 0047a32a
    mov edx, dword ptr [ecx + field_1536]        # 0047a32d
    {load} sub edx, eax                          # 0047a333
    mov eax, dword ptr [ebp - local_10]          # 0047a335
    mov dword ptr [eax + field_1536], edx        # 0047a338
    mov ecx, dword ptr [ebp - local_10]          # 0047a33e
    mov edx, dword ptr [ecx + field_1536]        # 0047a341
    mov eax, dword ptr [ebp - local_10]          # 0047a347
    add edx, dword ptr [eax + field_1586]        # 0047a34a
    mov ecx, dword ptr [ebp - local_10]          # 0047a350
    mov dword ptr [ecx + field_153e], edx        # 0047a353
    mov edx, dword ptr [ebp - local_10]          # 0047a359
    mov ax, word ptr [edx + field_159c]          # 0047a35c
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047a363
    mov ecx, dword ptr [ebp - local_10]          # 0047a367
    mov word ptr [ecx + field_159c], ax          # 0047a36a
    jmp.d8 L_0047a3d0                            # 0047a371
L_0047a373:
    # block 0x0047a373: entered by jne at 0x0047a312, 22 instruction(s), falls into the block at 0x0047a3d0
    mov edx, dword ptr [ebp - local_c]           # 0047a373
    movsx ecx, word ptr [edx + field_1c2]        # 0047a376
    mov edx, dword ptr [ebp - local_10]          # 0047a37d
    mov eax, dword ptr [edx + field_1586]        # 0047a380
    cdq                                          # 0047a386
    idiv ecx                                     # 0047a387
    mov ecx, dword ptr [ebp - local_10]          # 0047a389
    mov edx, dword ptr [ecx + field_1536]        # 0047a38c
    {load} add edx, eax                          # 0047a392
    mov eax, dword ptr [ebp - local_10]          # 0047a394
    mov dword ptr [eax + field_1536], edx        # 0047a397
    mov ecx, dword ptr [ebp - local_10]          # 0047a39d
    mov edx, dword ptr [ecx + field_1536]        # 0047a3a0
    mov eax, dword ptr [ebp - local_10]          # 0047a3a6
    add edx, dword ptr [eax + field_1586]        # 0047a3a9
    mov ecx, dword ptr [ebp - local_10]          # 0047a3af
    mov dword ptr [ecx + field_153e], edx        # 0047a3b2
    mov edx, dword ptr [ebp - local_10]          # 0047a3b8
    mov ax, word ptr [edx + field_159c]          # 0047a3bb
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047a3c2
    mov ecx, dword ptr [ebp - local_10]          # 0047a3c6
    mov word ptr [ecx + field_159c], ax          # 0047a3c9
L_0047a3d0:
    # block 0x0047a3d0: entered by jge at 0x0047a2c4; jmp at 0x0047a371, 4 instruction(s), ends with ret
    mov eax, 0x1                                 # 0047a3d0
    {load} mov esp, ebp                          # 0047a3d5
    pop ebp                                      # 0047a3d7
    ret                                          # 0047a3d8

