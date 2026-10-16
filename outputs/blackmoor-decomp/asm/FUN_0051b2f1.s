# FUN_0051b2f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b2f1
# extent:       0x0051b2f1-0x0051b403 (274 code bytes)
# span:         0x0051b2f1-0x0051b403 (code 274, tables 0, padding 0)
# sha256:       e6638461dbe42873e2287ba2f6a10f7e562d2df095b657d418f6491f6689f760
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b2f1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_4, field_14, field_50, field_80, field_a4, field_cc; [edi + n] field_1c, field_20; [esi + n] field_1c, field_24, field_30, field_34
# callees:      calls FUN_0051ec6f, FUN_00525371, FUN_00524861, FUN_00526978, FUN_0052513f, FUN_0050f920, USER32.dll!SendMessageA, FUN_0051ab4b, USER32.dll!SetWindowLongA, FUN_0051ac62; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 101 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051b403
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_50, 0x50  # offset +0x50
.equ field_80, 0x80  # offset +0x80
.equ field_a4, 0xa4  # offset +0xa4
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051ac62, .text + (0x0051ac62 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_00524861, .text + (0x00524861 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00526978, .text + (0x00526978 - 0x401000)

.org 0x0051b2f1 - 0x401000
.globl FUN_0051b2f1
FUN_0051b2f1:
    # block 0x0051b2f1: entry, 12 instruction(s), calls FUN_0051ec6f, ends with je to 0x0051b33c (forward)
    push ebp                                     # 0051b2f1
    {load} mov ebp, esp                          # 0051b2f2
    sub esp, 0x2c                                # 0051b2f4
    push ebx                                     # 0051b2f7
    push esi                                     # 0051b2f8
    push edi                                     # 0051b2f9
    {load} mov esi, ecx                          # 0051b2fa
    call FUN_0051ec6f                            # 0051b2fc
    {load} mov edi, eax                          # 0051b301
    {load} xor ebx, ebx                          # 0051b303
    {load} cmp edi, ebx                          # 0051b305
    je.d8 L_0051b33c                             # 0051b307
    # block 0x0051b309: entered by fall-through of je at 0x0051b307, 2 instruction(s), ends with jne to 0x0051b334 (forward)
    cmp dword ptr [edi + field_1c], esi          # 0051b309
    jne.d8 L_0051b334                            # 0051b30c
    # block 0x0051b30e: entered by fall-through of jne at 0x0051b30c, 3 instruction(s), calls FUN_00525371, ends with jne to 0x0051b331 (forward)
    call FUN_00525371                            # 0051b30e
    cmp byte ptr [eax + field_14], bl            # 0051b313
    jne.d8 L_0051b331                            # 0051b316
    # block 0x0051b318: entered by fall-through of jne at 0x0051b316, 3 instruction(s), calls FUN_00525371, ends with jne to 0x0051b32b (forward)
    call FUN_00525371                            # 0051b318
    cmp edi, dword ptr [eax + field_4]           # 0051b31d
    jne.d8 L_0051b32b                            # 0051b320
    # block 0x0051b322: entered by fall-through of jne at 0x0051b320, 3 instruction(s), calls FUN_00524861, ends with je to 0x0051b331 (forward)
    call FUN_00524861                            # 0051b322
    test eax, eax                                # 0051b327
    je.d8 L_0051b331                             # 0051b329
L_0051b32b:
    # block 0x0051b32b: entered by jne at 0x0051b320; fall-through of je at 0x0051b329, 2 instruction(s), calls FUN_00526978, falls into the block at 0x0051b331
    push ebx                                     # 0051b32b
    call FUN_00526978                            # 0051b32c
L_0051b331:
    # block 0x0051b331: entered by jne at 0x0051b316; je at 0x0051b329, 1 instruction(s), falls into the block at 0x0051b334
    mov dword ptr [edi + field_1c], ebx          # 0051b331
L_0051b334:
    # block 0x0051b334: entered by jne at 0x0051b30c, 2 instruction(s), ends with jne to 0x0051b33c (forward)
    cmp dword ptr [edi + field_20], esi          # 0051b334
    jne.d8 L_0051b33c                            # 0051b337
    # block 0x0051b339: entered by fall-through of jne at 0x0051b337, 1 instruction(s), falls into the block at 0x0051b33c
    mov dword ptr [edi + field_20], ebx          # 0051b339
L_0051b33c:
    # block 0x0051b33c: entered by je at 0x0051b307; jne at 0x0051b337, 3 instruction(s), ends with je to 0x0051b34b (forward)
    mov ecx, dword ptr [esi + field_30]          # 0051b33c
    {load} cmp ecx, ebx                          # 0051b33f
    je.d8 L_0051b34b                             # 0051b341
    # block 0x0051b343: entered by fall-through of je at 0x0051b341, 3 instruction(s), calls indirect dword ptr [eax + 0x50], falls into the block at 0x0051b34b
    mov eax, dword ptr [ecx]                     # 0051b343
    call dword ptr [eax + field_50]              # 0051b345
    mov dword ptr [esi + field_30], ebx          # 0051b348
L_0051b34b:
    # block 0x0051b34b: entered by je at 0x0051b341, 5 instruction(s), ends with je to 0x0051b35b (forward)
    mov ecx, dword ptr [esi + field_34]          # 0051b34b
    push 0x1                                     # 0051b34e
    test ecx, ecx                                # 0051b350
    pop ebx                                      # 0051b352
    je.d8 L_0051b35b                             # 0051b353
    # block 0x0051b355: entered by fall-through of je at 0x0051b353, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051b35b
    mov eax, dword ptr [ecx]                     # 0051b355
    push ebx                                     # 0051b357
    call dword ptr [eax + field_4]               # 0051b358
L_0051b35b:
    # block 0x0051b35b: entered by je at 0x0051b353, 3 instruction(s), ends with je to 0x0051b3b0 (forward)
    and dword ptr [esi + field_34], 0x0          # 0051b35b
    test byte ptr [esi + field_24], bl           # 0051b35f
    je.d8 L_0051b3b0                             # 0051b362
    # block 0x0051b364: entered by fall-through of je at 0x0051b362, 4 instruction(s), calls FUN_0052513f, ends with je to 0x0051b3b0 (forward)
    call FUN_0052513f                            # 0051b364
    mov edi, dword ptr [eax + field_cc]          # 0051b369
    test edi, edi                                # 0051b36f
    je.d8 L_0051b3b0                             # 0051b371
    # block 0x0051b373: entered by fall-through of je at 0x0051b371, 2 instruction(s), ends with je to 0x0051b3b0 (forward)
    cmp dword ptr [edi + field_1c], 0x0          # 0051b373
    je.d8 L_0051b3b0                             # 0051b377
    # block 0x0051b379: entered by fall-through of je at 0x0051b377, 17 instruction(s), calls FUN_0050f920, USER32.dll!SendMessageA, falls into the block at 0x0051b3b0
    push 0x2c                                    # 0051b379
    lea eax, [ebp - local_2c]                    # 0051b37b
    push 0x0                                     # 0051b37e
    push eax                                     # 0051b380
    call FUN_0050f920                            # 0051b381
    mov eax, dword ptr [esi + field_1c]          # 0051b386
    add esp, 0xc                                 # 0051b389
    mov dword ptr [ebp - local_24], eax          # 0051b38c
    mov dword ptr [ebp - local_20], eax          # 0051b38f
    lea eax, [ebp - local_2c]                    # 0051b392
    mov dword ptr [ebp - local_2c], 0x28         # 0051b395
    push eax                                     # 0051b39c
    push 0x0                                     # 0051b39d
    push 0x405                                   # 0051b39f
    mov dword ptr [ebp - local_28], ebx          # 0051b3a4
    push dword ptr [edi + field_1c]              # 0051b3a7
    call dword ptr [0x52a4c8]                    # 0051b3aa
L_0051b3b0:
    # block 0x0051b3b0: entered by je at 0x0051b362; je at 0x0051b371; je at 0x0051b377, 12 instruction(s), calls indirect edi, FUN_0051ab4b, ends with jne to 0x0051b3ed (forward)
    mov edi, dword ptr [0x52a454]                # 0051b3b0
    push -0x4                                    # 0051b3b6
    push dword ptr [esi + field_1c]              # 0051b3b8
    call edi                                     # 0051b3bb
    {load} mov ecx, esi                          # 0051b3bd
    {load} mov ebx, eax                          # 0051b3bf
    call FUN_0051ab4b                            # 0051b3c1
    push -0x4                                    # 0051b3c6
    push dword ptr [esi + field_1c]              # 0051b3c8
    call edi                                     # 0051b3cb
    {load} cmp eax, ebx                          # 0051b3cd
    jne.d8 L_0051b3ed                            # 0051b3cf
    # block 0x0051b3d1: entered by fall-through of jne at 0x0051b3cf, 6 instruction(s), calls indirect dword ptr [eax + 0x80], ends with je to 0x0051b3ed (forward)
    mov eax, dword ptr [esi]                     # 0051b3d1
    {load} mov ecx, esi                          # 0051b3d3
    call dword ptr [eax + field_80]              # 0051b3d5
    mov eax, dword ptr [eax]                     # 0051b3db
    test eax, eax                                # 0051b3dd
    je.d8 L_0051b3ed                             # 0051b3df
    # block 0x0051b3e1: entered by fall-through of je at 0x0051b3df, 4 instruction(s), calls USER32.dll!SetWindowLongA, falls into the block at 0x0051b3ed
    push eax                                     # 0051b3e1
    push -0x4                                    # 0051b3e2
    push dword ptr [esi + field_1c]              # 0051b3e4
    call dword ptr [0x52a458]                    # 0051b3e7
L_0051b3ed:
    # block 0x0051b3ed: entered by jne at 0x0051b3cf; je at 0x0051b3df, 10 instruction(s), calls FUN_0051ac62, indirect dword ptr [eax + 0xa4], ends with ret
    {load} mov ecx, esi                          # 0051b3ed
    call FUN_0051ac62                            # 0051b3ef
    mov eax, dword ptr [esi]                     # 0051b3f4
    {load} mov ecx, esi                          # 0051b3f6
    call dword ptr [eax + field_a4]              # 0051b3f8
    pop edi                                      # 0051b3fe
    pop esi                                      # 0051b3ff
    pop ebx                                      # 0051b400
    leave                                        # 0051b401
    ret                                          # 0051b402

