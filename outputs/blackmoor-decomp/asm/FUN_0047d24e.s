# FUN_0047d24e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d24e
# extent:       0x0047d24e-0x0047d3d2 (388 code bytes)
# span:         0x0047d24e-0x0047d3e0 (code 388, tables 0, padding 14)
# sha256:       c6808a43c3312cd263c7433312490289a00449f94bed7c28fee620ffeb60b6cb
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047d24e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_21, field_e1, field_35b; [ecx + n] field_4, field_111
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 100 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_21, 0x21  # offset +0x21
.equ field_e1, 0xe1  # offset +0xe1
.equ field_111, 0x111  # offset +0x111
.equ field_35b, 0x35b  # offset +0x35b

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0047d24e - 0x401000
.globl FUN_0047d24e
FUN_0047d24e:
    # block 0x0047d24e: entry, 7 instruction(s), ends with jne to 0x0047d26a (forward)
    push ebp                                     # 0047d24e
    {load} mov ebp, esp                          # 0047d24f
    sub esp, 0xc                                 # 0047d251
    mov eax, dword ptr [0x61e3a4]                # 0047d254
    mov dword ptr [ebp - local_c], eax           # 0047d259
    cmp dword ptr [0x61e3bc], 0x0                # 0047d25c
    jne.d8 L_0047d26a                            # 0047d263
    # block 0x0047d265: entered by fall-through of jne at 0x0047d263, 1 instruction(s), ends with forward jump to 0x0047d3ce
    jmp.d32 L_0047d3ce                           # 0047d265
L_0047d26a:
    # block 0x0047d26a: entered by jne at 0x0047d263, 2 instruction(s), ends with je to 0x0047d2a4 (forward)
    cmp dword ptr [0x61e3c8], 0x0                # 0047d26a
    je.d8 L_0047d2a4                             # 0047d271
    # block 0x0047d273: entered by fall-through of je at 0x0047d271, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x0047d2a4
    push 0x54d1a0                                # 0047d273
    push 0x61e5f4                                # 0047d278
    push 0x583196                                # 0047d27d
    mov ecx, dword ptr [0x5cf665]                # 0047d282
    push ecx                                     # 0047d288
    mov edx, dword ptr [0x5d15e3]                # 0047d289
    push edx                                     # 0047d28f
    mov ecx, 0x5cf659                            # 0047d290
    call FUN_004c5377                            # 0047d295
    mov dword ptr [0x61e3c8], 0x0                # 0047d29a
L_0047d2a4:
    # block 0x0047d2a4: entered by je at 0x0047d271, 4 instruction(s), ends with je to 0x0047d2f2 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047d2a4
    movsx ecx, byte ptr [eax + field_35b]        # 0047d2a7
    test ecx, ecx                                # 0047d2ae
    je.d8 L_0047d2f2                             # 0047d2b0
    # block 0x0047d2b2: entered by fall-through of je at 0x0047d2b0, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x0047d2f2
    push 0x54d1c8                                # 0047d2b2
    push 0x61e554                                # 0047d2b7
    mov edx, dword ptr [0x61e624]                # 0047d2bc
    shl edx, 0x4                                 # 0047d2c2
    mov eax, dword ptr [ebp - local_c]           # 0047d2c5
    lea ecx, [eax + edx + field_e1]              # 0047d2c8
    push ecx                                     # 0047d2cf
    mov edx, dword ptr [0x5cf665]                # 0047d2d0
    push edx                                     # 0047d2d6
    movsx eax, word ptr [0x61e39c]               # 0047d2d7
    imul eax, eax, 0x4a                          # 0047d2de
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047d2e1
    push ecx                                     # 0047d2e7
    mov ecx, 0x5cf659                            # 0047d2e8
    call FUN_004c5377                            # 0047d2ed
L_0047d2f2:
    # block 0x0047d2f2: entered by je at 0x0047d2b0, 5 instruction(s), ends with forward jump to 0x0047d31d
    mov edx, dword ptr [0x61e624]                # 0047d2f2
    imul edx, dword ptr [0x61e618]               # 0047d2f8
    mov dword ptr [ebp - local_4], edx           # 0047d2ff
    mov dword ptr [ebp - local_8], 0x0           # 0047d302
    jmp.d8 L_0047d31d                            # 0047d309
L_0047d30b:
    # block 0x0047d30b: entered by jmp at 0x0047d3c9, 6 instruction(s), falls into the block at 0x0047d31d
    mov eax, dword ptr [ebp - local_8]           # 0047d30b
    add eax, 0x1                                 # 0047d30e
    mov dword ptr [ebp - local_8], eax           # 0047d311
    mov ecx, dword ptr [ebp - local_4]           # 0047d314
    add ecx, 0x1                                 # 0047d317
    mov dword ptr [ebp - local_4], ecx           # 0047d31a
L_0047d31d:
    # block 0x0047d31d: entered by jmp at 0x0047d309, 3 instruction(s), ends with jge to 0x0047d3ce (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047d31d
    cmp edx, dword ptr [0x61e618]                # 0047d320
    jge.d32 L_0047d3ce                           # 0047d326
    # block 0x0047d32c: entered by fall-through of jge at 0x0047d326, 5 instruction(s), ends with jne to 0x0047d38f (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047d32c
    imul eax, eax, 0xc                           # 0047d32f
    mov ecx, dword ptr [0x61e3ac]                # 0047d332
    cmp dword ptr [ecx + eax + field_4], 0x1     # 0047d338
    jne.d8 L_0047d38f                            # 0047d33d
    # block 0x0047d33f: entered by fall-through of jne at 0x0047d33d, 22 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0047d3c9
    push 0x54d1e4                                # 0047d33f
    mov edx, dword ptr [ebp - local_8]           # 0047d344
    shl edx, 0x4                                 # 0047d347
    add edx, 0x61e3d4                            # 0047d34a
    push edx                                     # 0047d350
    mov eax, dword ptr [ebp - local_4]           # 0047d351
    imul eax, eax, 0xc                           # 0047d354
    mov ecx, dword ptr [0x61e3ac]                # 0047d357
    mov edx, dword ptr [ecx + eax]               # 0047d35d
    shl edx, 0x4                                 # 0047d360
    mov eax, dword ptr [ebp - local_c]           # 0047d363
    lea ecx, [eax + edx + field_21]              # 0047d366
    push ecx                                     # 0047d36a
    mov edx, dword ptr [0x5cf665]                # 0047d36b
    push edx                                     # 0047d371
    movsx eax, word ptr [0x61e39c]               # 0047d372
    imul eax, eax, 0x4a                          # 0047d379
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047d37c
    push ecx                                     # 0047d382
    mov ecx, 0x5cf659                            # 0047d383
    call FUN_004c5377                            # 0047d388
    jmp.d8 L_0047d3c9                            # 0047d38d
L_0047d38f:
    # block 0x0047d38f: entered by jne at 0x0047d33d, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x0047d3c9
    push 0x54d20c                                # 0047d38f
    mov edx, dword ptr [ebp - local_8]           # 0047d394
    shl edx, 0x4                                 # 0047d397
    add edx, 0x61e3d4                            # 0047d39a
    push edx                                     # 0047d3a0
    mov eax, dword ptr [ebp - local_8]           # 0047d3a1
    shl eax, 0x4                                 # 0047d3a4
    mov ecx, dword ptr [ebp - local_c]           # 0047d3a7
    lea edx, [ecx + eax + field_111]             # 0047d3aa
    push edx                                     # 0047d3b1
    mov eax, dword ptr [0x5cf665]                # 0047d3b2
    push eax                                     # 0047d3b7
    mov ecx, dword ptr [0x5d15e3]                # 0047d3b8
    push ecx                                     # 0047d3be
    mov ecx, 0x5cf659                            # 0047d3bf
    call FUN_004c5377                            # 0047d3c4
L_0047d3c9:
    # block 0x0047d3c9: entered by jmp at 0x0047d38d, 1 instruction(s), ends with backward jump to 0x0047d30b
    jmp.d32 L_0047d30b                           # 0047d3c9
L_0047d3ce:
    # block 0x0047d3ce: entered by jmp at 0x0047d265; jge at 0x0047d326, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047d3ce
    pop ebp                                      # 0047d3d0
    ret                                          # 0047d3d1

# --- data items (not part of the function) -------------------------
.org 0x0047d3d2 - 0x401000
PAD_0047d3d2:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

