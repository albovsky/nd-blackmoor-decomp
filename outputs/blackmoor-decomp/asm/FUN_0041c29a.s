# FUN_0041c29a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c29a
# extent:       0x0041c29a-0x0041c3ba (288 code bytes)
# span:         0x0041c29a-0x0041c3ba (code 288, tables 0, padding 0)
# sha256:       696fb1cbc11b58cec298a02100d6faf21adf6535e4972e6e0169ef750c23e30a
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041c29a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1c, field_f73, field_f75, field_fa9; [ecx + n] field_6, field_f75, field_fa5; [edx + n] field_f73, field_fa5
# callees:      calls FUN_004c946b, FUN_004c2dfb, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bebc_lifted (function ledger class candidate_port; also m41c29a_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 78 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_6, 0x6  # offset +0x6
.equ field_1c, 0x1c  # offset +0x1c
.equ field_f73, 0xf73  # offset +0xf73
.equ field_f75, 0xf75  # offset +0xf75
.equ field_fa5, 0xfa5  # offset +0xfa5
.equ field_fa9, 0xfa9  # offset +0xfa9

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c946b, .text + (0x004c946b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041c29a - 0x401000
.globl FUN_0041c29a
FUN_0041c29a:
    # block 0x0041c29a: entry, 9 instruction(s), ends with je to 0x0041c2c8 (forward)
    push ebp                                     # 0041c29a
    {load} mov ebp, esp                          # 0041c29b
    sub esp, 0x10                                # 0041c29d
    push edi                                     # 0041c2a0
    mov dword ptr [ebp - local_10], ecx          # 0041c2a1
    mov eax, dword ptr [ebp - local_10]          # 0041c2a4
    movsx ecx, word ptr [eax + field_f73]        # 0041c2a7
    cmp ecx, -0x1                                # 0041c2ae
    je.d8 L_0041c2c8                             # 0041c2b1
    # block 0x0041c2b3: entered by fall-through of je at 0x0041c2b1, 5 instruction(s), calls FUN_004c946b, falls into the block at 0x0041c2c8
    mov edx, dword ptr [ebp - local_10]          # 0041c2b3
    mov ax, word ptr [edx + field_f73]           # 0041c2b6
    push eax                                     # 0041c2bd
    mov ecx, 0x5cf659                            # 0041c2be
    call FUN_004c946b                            # 0041c2c3
L_0041c2c8:
    # block 0x0041c2c8: entered by je at 0x0041c2b1, 4 instruction(s), ends with je to 0x0041c2ec (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0041c2c8
    movsx edx, word ptr [ecx + field_f75]        # 0041c2cb
    cmp edx, -0x1                                # 0041c2d2
    je.d8 L_0041c2ec                             # 0041c2d5
    # block 0x0041c2d7: entered by fall-through of je at 0x0041c2d5, 5 instruction(s), calls FUN_004c946b, falls into the block at 0x0041c2ec
    mov eax, dword ptr [ebp - local_10]          # 0041c2d7
    mov cx, word ptr [eax + field_f75]           # 0041c2da
    push ecx                                     # 0041c2e1
    mov ecx, 0x5cf659                            # 0041c2e2
    call FUN_004c946b                            # 0041c2e7
L_0041c2ec:
    # block 0x0041c2ec: entered by je at 0x0041c2d5, 6 instruction(s), ends with forward jump to 0x0041c318
    mov edx, dword ptr [ebp - local_10]          # 0041c2ec
    mov word ptr [edx + field_f73], 0xffff       # 0041c2ef
    mov eax, dword ptr [ebp - local_10]          # 0041c2f8
    mov word ptr [eax + field_f75], 0xffff       # 0041c2fb
    mov word ptr [ebp - local_8], 0x0            # 0041c304
    jmp.d8 L_0041c318                            # 0041c30a
L_0041c30c:
    # block 0x0041c30c: entered by jmp at 0x0041c361, 3 instruction(s), falls into the block at 0x0041c318
    mov cx, word ptr [ebp - local_8]             # 0041c30c
    add cx, 0x1                                  # 0041c310
    mov word ptr [ebp - local_8], cx             # 0041c314
L_0041c318:
    # block 0x0041c318: entered by jmp at 0x0041c30a, 3 instruction(s), ends with jge to 0x0041c363 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0041c318
    cmp edx, 0x4b                                # 0041c31c
    jge.d8 L_0041c363                            # 0041c31f
    # block 0x0041c321: entered by fall-through of jge at 0x0041c31f, 2 instruction(s), ends with forward jump to 0x0041c335
    mov word ptr [ebp - local_4], 0x0            # 0041c321
    jmp.d8 L_0041c335                            # 0041c327
L_0041c329:
    # block 0x0041c329: entered by jmp at 0x0041c35f, 3 instruction(s), falls into the block at 0x0041c335
    mov ax, word ptr [ebp - local_4]             # 0041c329
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041c32d
    mov word ptr [ebp - local_4], ax             # 0041c331
L_0041c335:
    # block 0x0041c335: entered by jmp at 0x0041c327, 3 instruction(s), ends with jge to 0x0041c361 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041c335
    cmp ecx, 0x4                                 # 0041c339
    jge.d8 L_0041c361                            # 0041c33c
    # block 0x0041c33e: entered by fall-through of jge at 0x0041c33c, 10 instruction(s), calls FUN_004c2dfb, ends with backward jump to 0x0041c329
    movsx edx, word ptr [ebp - local_8]          # 0041c33e
    imul edx, edx, 0x16                          # 0041c342
    mov eax, dword ptr [ebp - local_10]          # 0041c345
    lea ecx, [eax + edx + field_1c]              # 0041c348
    movsx edx, word ptr [ebp - local_4]          # 0041c34c
    lea eax, [ecx + 4*edx + field_6]             # 0041c350
    push eax                                     # 0041c354
    mov ecx, 0x5cf659                            # 0041c355
    call FUN_004c2dfb                            # 0041c35a
    jmp.d8 L_0041c329                            # 0041c35f
L_0041c361:
    # block 0x0041c361: entered by jge at 0x0041c33c, 1 instruction(s), ends with backward jump to 0x0041c30c
    jmp.d8 L_0041c30c                            # 0041c361
L_0041c363:
    # block 0x0041c363: entered by jge at 0x0041c31f, 3 instruction(s), ends with je to 0x0041c394 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0041c363
    cmp dword ptr [ecx + field_fa5], 0x0         # 0041c366
    je.d8 L_0041c394                             # 0041c36d
    # block 0x0041c36f: entered by fall-through of je at 0x0041c36d, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041c394
    mov edx, dword ptr [ebp - local_10]          # 0041c36f
    mov eax, dword ptr [edx + field_fa5]         # 0041c372
    mov dword ptr [ebp - local_c], eax           # 0041c378
    mov ecx, dword ptr [ebp - local_c]           # 0041c37b
    push ecx                                     # 0041c37e
    call FUN_0051dc6c                            # 0041c37f
    add esp, 0x4                                 # 0041c384
    mov edx, dword ptr [ebp - local_10]          # 0041c387
    mov dword ptr [edx + field_fa5], 0x0         # 0041c38a
L_0041c394:
    # block 0x0041c394: entered by je at 0x0041c36d, 12 instruction(s), ends with ret
    mov ecx, 0xa                                 # 0041c394
    {load} xor eax, eax                          # 0041c399
    mov edi, dword ptr [ebp - local_10]          # 0041c39b
    add edi, 0xf77                               # 0041c39e
    rep stosd dword ptr es:[edi], eax            # 0041c3a4
    stosw word ptr es:[edi], ax                  # 0041c3a6
    mov eax, dword ptr [ebp - local_10]          # 0041c3a8
    mov dword ptr [eax + field_fa9], 0x0         # 0041c3ab
    pop edi                                      # 0041c3b5
    {load} mov esp, ebp                          # 0041c3b6
    pop ebp                                      # 0041c3b8
    ret                                          # 0041c3b9

