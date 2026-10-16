# FUN_00526471
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526471
# extent:       0x00526471-0x0052658e (285 code bytes)
# span:         0x00526471-0x0052658e (code 285, tables 0, padding 0)
# sha256:       5da5a32730774fdca42453f5d67c2d1bf527a7e12a2d63311b8722b74f077572
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526471
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_108, local_20c, local_30c
# fields:       [edi + n] field_8, field_c, field_10; [esi + n] field_68, field_78, field_88, field_8c, field_90
# callees:      calls FUN_00525371, KERNEL32.dll!GetModuleFileNameA, FUN_0050fff4, FUN_0052658e, FUN_0050ffb2, FUN_0051fb2e, KERNEL32.dll!lstrcpyA, KERNEL32.dll!lstrcatA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 88 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_108, 0x108  # offset -0x108
.equ local_20c, 0x20c  # offset -0x20c
.equ local_30c, 0x30c  # offset -0x30c
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_68, 0x68  # offset +0x68
.equ field_78, 0x78  # offset +0x78
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_0050ffb2, .text + (0x0050ffb2 - 0x401000)
.set FUN_0050fff4, .text + (0x0050fff4 - 0x401000)
.set FUN_0051fb2e, .text + (0x0051fb2e - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_0052658e, .text + (0x0052658e - 0x401000)

.org 0x00526471 - 0x401000
.globl FUN_00526471
FUN_00526471:
    # block 0x00526471: entry, 36 instruction(s), calls FUN_00525371, KERNEL32.dll!GetModuleFileNameA, FUN_0050fff4, FUN_0052658e, ends with jne to 0x005264ef (forward)
    push ebp                                     # 00526471
    {load} mov ebp, esp                          # 00526472
    sub esp, 0x30c                               # 00526474
    push ebx                                     # 0052647a
    push esi                                     # 0052647b
    push edi                                     # 0052647c
    {load} mov esi, ecx                          # 0052647d
    call FUN_00525371                            # 0052647f
    {load} mov edi, eax                          # 00526484
    mov eax, dword ptr [esi + field_68]          # 00526486
    mov ebx, 0x104                               # 00526489
    mov dword ptr [edi + field_8], eax           # 0052648e
    mov eax, dword ptr [esi + field_68]          # 00526491
    mov dword ptr [edi + field_c], eax           # 00526494
    lea eax, [ebp - local_20c]                   # 00526497
    push ebx                                     # 0052649d
    push eax                                     # 0052649e
    push dword ptr [esi + field_68]              # 0052649f
    call dword ptr [0x52a28c]                    # 005264a2
    lea eax, [ebp - local_20c]                   # 005264a8
    push 0x2e                                    # 005264ae
    push eax                                     # 005264b0
    call FUN_0050fff4                            # 005264b1
    and byte ptr [eax], 0x0                      # 005264b6
    pop ecx                                      # 005264b9
    pop ecx                                      # 005264ba
    mov dword ptr [ebp - local_4], eax           # 005264bb
    lea eax, [ebp - local_108]                   # 005264be
    push ebx                                     # 005264c4
    push eax                                     # 005264c5
    lea eax, [ebp - local_20c]                   # 005264c6
    push eax                                     # 005264cc
    call FUN_0052658e                            # 005264cd
    {load} xor ebx, ebx                          # 005264d2
    cmp dword ptr [esi + field_88], ebx          # 005264d4
    jne.d8 L_005264ef                            # 005264da
    # block 0x005264dc: entered by fall-through of jne at 0x005264da, 5 instruction(s), calls FUN_0050ffb2, falls into the block at 0x005264ef
    lea eax, [ebp - local_108]                   # 005264dc
    push eax                                     # 005264e2
    call FUN_0050ffb2                            # 005264e3
    pop ecx                                      # 005264e8
    mov dword ptr [esi + field_88], eax          # 005264e9
L_005264ef:
    # block 0x005264ef: entered by jne at 0x005264da, 2 instruction(s), ends with jne to 0x00526526 (forward)
    cmp dword ptr [esi + field_78], ebx          # 005264ef
    jne.d8 L_00526526                            # 005264f2
    # block 0x005264f4: entered by fall-through of jne at 0x005264f2, 7 instruction(s), calls FUN_0051fb2e, ends with je to 0x00526517 (forward)
    lea eax, [ebp - local_30c]                   # 005264f4
    push 0x100                                   # 005264fa
    push eax                                     # 005264ff
    push 0xe000                                  # 00526500
    call FUN_0051fb2e                            # 00526505
    test eax, eax                                # 0052650a
    je.d8 L_00526517                             # 0052650c
    # block 0x0052650e: entered by fall-through of je at 0x0052650c, 3 instruction(s), ends with forward jump to 0x0052651d
    lea eax, [ebp - local_30c]                   # 0052650e
    push eax                                     # 00526514
    jmp.d8 L_0052651d                            # 00526515
L_00526517:
    # block 0x00526517: entered by je at 0x0052650c, 1 instruction(s), falls into the block at 0x0052651d
    push dword ptr [esi + field_88]              # 00526517
L_0052651d:
    # block 0x0052651d: entered by jmp at 0x00526515, 3 instruction(s), calls FUN_0050ffb2, falls into the block at 0x00526526
    call FUN_0050ffb2                            # 0052651d
    pop ecx                                      # 00526522
    mov dword ptr [esi + field_78], eax          # 00526523
L_00526526:
    # block 0x00526526: entered by jne at 0x005264f2, 5 instruction(s), ends with jne to 0x0052655b (forward)
    mov eax, dword ptr [esi + field_78]          # 00526526
    mov dword ptr [edi + field_10], eax          # 00526529
    cmp dword ptr [esi + field_8c], ebx          # 0052652c
    lea edi, [esi + field_8c]                    # 00526532
    jne.d8 L_0052655b                            # 00526538
    # block 0x0052653a: entered by fall-through of jne at 0x00526538, 10 instruction(s), calls KERNEL32.dll!lstrcpyA, FUN_0050ffb2, falls into the block at 0x0052655b
    mov ebx, dword ptr [ebp - local_4]           # 0052653a
    push 0x5301f4                                # 0052653d
    push ebx                                     # 00526542
    call dword ptr [0x52a244]                    # 00526543
    lea eax, [ebp - local_20c]                   # 00526549
    push eax                                     # 0052654f
    call FUN_0050ffb2                            # 00526550
    mov dword ptr [edi], eax                     # 00526555
    and byte ptr [ebx], 0x0                      # 00526557
    pop ecx                                      # 0052655a
L_0052655b:
    # block 0x0052655b: entered by jne at 0x00526538, 2 instruction(s), ends with jne to 0x00526589 (forward)
    cmp dword ptr [esi + field_90], 0x0          # 0052655b
    jne.d8 L_00526589                            # 00526562
    # block 0x00526564: entered by fall-through of jne at 0x00526562, 9 instruction(s), calls KERNEL32.dll!lstrcatA, FUN_0050ffb2, falls into the block at 0x00526589
    lea eax, [ebp - local_108]                   # 00526564
    push 0x5301ec                                # 0052656a
    push eax                                     # 0052656f
    call dword ptr [0x52a228]                    # 00526570
    lea eax, [ebp - local_108]                   # 00526576
    push eax                                     # 0052657c
    call FUN_0050ffb2                            # 0052657d
    pop ecx                                      # 00526582
    mov dword ptr [esi + field_90], eax          # 00526583
L_00526589:
    # block 0x00526589: entered by jne at 0x00526562, 5 instruction(s), ends with ret
    pop edi                                      # 00526589
    pop esi                                      # 0052658a
    pop ebx                                      # 0052658b
    leave                                        # 0052658c
    ret                                          # 0052658d

