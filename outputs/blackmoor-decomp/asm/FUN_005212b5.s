# FUN_005212b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005212b5
# extent:       0x005212b5-0x0052139c (231 code bytes)
# span:         0x005212b5-0x0052139c (code 231, tables 0, padding 0)
# sha256:       63ec6e58638a0e382fe3940831fbcbfae2c00d79b1cefa624104af33f3a88dc2
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005212b5
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_114
# fields:       [edi + n] field_78, field_9c
# callees:      calls FUN_00521287, FUN_0052142d, USER32.dll!SendMessageA, KERNEL32.dll!GetModuleFileNameA, USER32.dll!MessageBoxA, USER32.dll!EnableWindow
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_114, 0x114  # offset -0x114
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_78, 0x78  # offset +0x78
.equ field_9c, 0x9c  # offset +0x9c

# --- external targets -----------------------------------------------
.set FUN_00521287, .text + (0x00521287 - 0x401000)
.set FUN_0052142d, .text + (0x0052142d - 0x401000)

.org 0x005212b5 - 0x401000
.globl FUN_005212b5
FUN_005212b5:
    # block 0x005212b5: entry, 19 instruction(s), calls FUN_00521287, FUN_0052142d, ends with je to 0x005212f9 (forward)
    push ebp                                     # 005212b5
    {load} mov ebp, esp                          # 005212b6
    sub esp, 0x114                               # 005212b8
    push ebx                                     # 005212be
    push esi                                     # 005212bf
    push edi                                     # 005212c0
    {load} xor ebx, ebx                          # 005212c1
    {load} mov edi, ecx                          # 005212c3
    push ebx                                     # 005212c5
    mov dword ptr [ebp - local_10], edi          # 005212c6
    call FUN_00521287                            # 005212c9
    lea eax, [ebp - local_4]                     # 005212ce
    push eax                                     # 005212d1
    push ebx                                     # 005212d2
    call FUN_0052142d                            # 005212d3
    {load} xor esi, esi                          # 005212d8
    {load} cmp eax, ebx                          # 005212da
    mov dword ptr [ebp - local_c], eax           # 005212dc
    je.d8 L_005212f9                             # 005212df
    # block 0x005212e1: entered by fall-through of je at 0x005212df, 7 instruction(s), calls USER32.dll!SendMessageA, ends with je to 0x005212f9 (forward)
    push ebx                                     # 005212e1
    push ebx                                     # 005212e2
    push 0x376                                   # 005212e3
    push dword ptr [ebp - local_4]               # 005212e8
    call dword ptr [0x52a4c8]                    # 005212eb
    {load} cmp eax, ebx                          # 005212f1
    je.d8 L_005212f9                             # 005212f3
    # block 0x005212f5: entered by fall-through of je at 0x005212f3, 2 instruction(s), ends with forward jump to 0x00521303
    {load} mov esi, eax                          # 005212f5
    jmp.d8 L_00521303                            # 005212f7
L_005212f9:
    # block 0x005212f9: entered by je at 0x005212df; je at 0x005212f3, 2 instruction(s), ends with je to 0x00521303 (forward)
    {load} cmp edi, ebx                          # 005212f9
    je.d8 L_00521303                             # 005212fb
    # block 0x005212fd: entered by fall-through of je at 0x005212fb, 1 instruction(s), falls into the block at 0x00521303
    lea esi, [edi + field_9c]                    # 005212fd
L_00521303:
    # block 0x00521303: entered by jmp at 0x005212f7; je at 0x005212fb, 3 instruction(s), ends with je to 0x0052131d (forward)
    {load} cmp esi, ebx                          # 00521303
    mov dword ptr [ebp - local_8], ebx           # 00521305
    je.d8 L_0052131d                             # 00521308
    # block 0x0052130a: entered by fall-through of je at 0x00521308, 5 instruction(s), ends with je to 0x0052131d (forward)
    mov eax, dword ptr [esi]                     # 0052130a
    mov dword ptr [ebp - local_8], eax           # 0052130c
    mov eax, dword ptr [ebp + arg_10]            # 0052130f
    {load} cmp eax, ebx                          # 00521312
    je.d8 L_0052131d                             # 00521314
    # block 0x00521316: entered by fall-through of je at 0x00521314, 2 instruction(s), falls into the block at 0x0052131d
    add eax, 0x30000                             # 00521316
    mov dword ptr [esi], eax                     # 0052131b
L_0052131d:
    # block 0x0052131d: entered by je at 0x00521308; je at 0x00521314, 3 instruction(s), ends with jne to 0x0052133c (forward)
    mov ebx, dword ptr [ebp + arg_c]             # 0052131d
    test bl, -0x10                               # 00521320
    jne.d8 L_0052133c                            # 00521323
    # block 0x00521325: entered by fall-through of jne at 0x00521323, 4 instruction(s), ends with jbe to 0x00521339 (forward)
    {load} mov eax, ebx                          # 00521325
    and eax, 0xf                                 # 00521327
    cmp eax, 0x1                                 # 0052132a
    jbe.d8 L_00521339                            # 0052132d
    # block 0x0052132f: entered by fall-through of jbe at 0x0052132d, 2 instruction(s), ends with jbe to 0x0052133c (forward)
    cmp eax, 0x2                                 # 0052132f
    jbe.d8 L_0052133c                            # 00521332
    # block 0x00521334: entered by fall-through of jbe at 0x00521332, 2 instruction(s), ends with ja to 0x0052133c (forward)
    cmp eax, 0x4                                 # 00521334
    ja.d8 L_0052133c                             # 00521337
L_00521339:
    # block 0x00521339: entered by jbe at 0x0052132d; fall-through of ja at 0x00521337, 1 instruction(s), falls into the block at 0x0052133c
    or ebx, 0x30                                 # 00521339
L_0052133c:
    # block 0x0052133c: entered by jne at 0x00521323; jbe at 0x00521332; ja at 0x00521337, 2 instruction(s), ends with je to 0x00521345 (forward)
    test edi, edi                                # 0052133c
    je.d8 L_00521345                             # 0052133e
    # block 0x00521340: entered by fall-through of je at 0x0052133e, 2 instruction(s), ends with forward jump to 0x0052135f
    mov edi, dword ptr [edi + field_78]          # 00521340
    jmp.d8 L_0052135f                            # 00521343
L_00521345:
    # block 0x00521345: entered by je at 0x0052133e, 6 instruction(s), calls KERNEL32.dll!GetModuleFileNameA, falls into the block at 0x0052135f
    lea eax, [ebp - local_114]                   # 00521345
    push 0x104                                   # 0052134b
    push eax                                     # 00521350
    push 0x0                                     # 00521351
    lea edi, [ebp - local_114]                   # 00521353
    call dword ptr [0x52a28c]                    # 00521359
L_0052135f:
    # block 0x0052135f: entered by jmp at 0x00521343, 8 instruction(s), calls USER32.dll!MessageBoxA, ends with je to 0x00521378 (forward)
    push ebx                                     # 0052135f
    push edi                                     # 00521360
    push dword ptr [ebp + arg_8]                 # 00521361
    push dword ptr [ebp - local_c]               # 00521364
    call dword ptr [0x52a3d8]                    # 00521367
    test esi, esi                                # 0052136d
    {load} mov edi, eax                          # 0052136f
    je.d8 L_00521378                             # 00521371
    # block 0x00521373: entered by fall-through of je at 0x00521371, 2 instruction(s), falls into the block at 0x00521378
    mov eax, dword ptr [ebp - local_8]           # 00521373
    mov dword ptr [esi], eax                     # 00521376
L_00521378:
    # block 0x00521378: entered by je at 0x00521371, 2 instruction(s), ends with je to 0x00521389 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00521378
    je.d8 L_00521389                             # 0052137c
    # block 0x0052137e: entered by fall-through of je at 0x0052137c, 3 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x00521389
    push 0x1                                     # 0052137e
    push dword ptr [ebp - local_4]               # 00521380
    call dword ptr [0x52a4d0]                    # 00521383
L_00521389:
    # block 0x00521389: entered by je at 0x0052137c, 9 instruction(s), calls FUN_00521287, ends with ret 0xc
    mov ecx, dword ptr [ebp - local_10]          # 00521389
    push 0x1                                     # 0052138c
    call FUN_00521287                            # 0052138e
    {load} mov eax, edi                          # 00521393
    pop edi                                      # 00521395
    pop esi                                      # 00521396
    pop ebx                                      # 00521397
    leave                                        # 00521398
    ret 0xc                                      # 00521399

