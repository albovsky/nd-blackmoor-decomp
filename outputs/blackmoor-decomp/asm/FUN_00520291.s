# FUN_00520291
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520291
# extent:       0x00520291-0x00520397 (262 code bytes)
# span:         0x00520291-0x00520397 (code 262, tables 0, padding 0)
# sha256:       f8a09ebf09cafe62736c02310f0e2fc3e4a1e60d891a0dc2998f92ab00143c87
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520291
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_f, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_108
# fields:       [eax + n] field_8, field_18, field_minus_8; [ecx + n] field_8
# callees:      calls FUN_0051ea75, KERNEL32.dll!lstrcpyA, FUN_0052658e, KERNEL32.dll!lstrlenA, KERNEL32.dll!lstrcmpiA, FUN_0052094d, KERNEL32.dll!lstrcpynA, FUN_0051ff98, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 96 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ local_108, 0x108  # offset -0x108
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_f, 0xf  # offset +0xf
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_0051ff98, .text + (0x0051ff98 - 0x401000)
.set FUN_0052094d, .text + (0x0052094d - 0x401000)
.set FUN_0052658e, .text + (0x0052658e - 0x401000)

.org 0x00520291 - 0x401000
.globl FUN_00520291
FUN_00520291:
    # block 0x00520291: entry, 12 instruction(s), ends with jne to 0x005202b9 (forward)
    push ebp                                     # 00520291
    {load} mov ebp, esp                          # 00520292
    sub esp, 0x108                               # 00520294
    mov eax, dword ptr [ebp + arg_c]             # 0052029a
    push esi                                     # 0052029d
    {load} mov esi, eax                          # 0052029e
    mov eax, dword ptr [ecx + field_8]           # 005202a0
    shl esi, 0x2                                 # 005202a3
    mov dword ptr [ebp - local_4], ecx           # 005202a6
    mov eax, dword ptr [eax + esi]               # 005202a9
    cmp dword ptr [eax - field_minus_8], 0x0     # 005202ac
    jne.d8 L_005202b9                            # 005202b0
    # block 0x005202b2: entered by fall-through of jne at 0x005202b0, 2 instruction(s), ends with forward jump to 0x00520392
    {load} xor eax, eax                          # 005202b2
    jmp.d32 L_00520392                           # 005202b4
L_005202b9:
    # block 0x005202b9: entered by jne at 0x005202b0, 25 instruction(s), calls FUN_0051ea75, KERNEL32.dll!lstrcpyA, FUN_0052658e, KERNEL32.dll!lstrlenA, ends with jne to 0x00520344 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 005202b9
    push ebx                                     # 005202bc
    mov ebx, 0x104                               # 005202bd
    push edi                                     # 005202c2
    push ebx                                     # 005202c3
    call FUN_0051ea75                            # 005202c4
    {load} mov edi, eax                          # 005202c9
    mov eax, dword ptr [ebp - local_4]           # 005202cb
    mov eax, dword ptr [eax + field_8]           # 005202ce
    push dword ptr [eax + esi]                   # 005202d1
    push edi                                     # 005202d4
    call dword ptr [0x52a244]                    # 005202d5
    push 0x0                                     # 005202db
    push 0x0                                     # 005202dd
    push edi                                     # 005202df
    call FUN_0052658e                            # 005202e0
    push 0x1                                     # 005202e5
    pop esi                                      # 005202e7
    push edi                                     # 005202e8
    {load} sub esi, eax                          # 005202e9
    call dword ptr [0x52a1f8]                    # 005202eb
    {load} add esi, eax                          # 005202f1
    mov eax, dword ptr [ebp + arg_14]            # 005202f3
    {load} cmp esi, eax                          # 005202f6
    jne.d8 L_00520344                            # 005202f8
    # block 0x005202fa: entered by fall-through of jne at 0x005202f8, 15 instruction(s), calls KERNEL32.dll!lstrcmpiA, ends with je to 0x00520344 (forward)
    mov cl, byte ptr [esi + edi]                 # 005202fa
    and byte ptr [eax + edi], 0x0                # 005202fd
    push edi                                     # 00520301
    {load} add eax, edi                          # 00520302
    push dword ptr [ebp + arg_10]                # 00520304
    mov byte ptr [ebp + arg_f], cl               # 00520307
    mov dword ptr [ebp + arg_14], eax            # 0052030a
    call dword ptr [0x52a230]                    # 0052030d
    neg eax                                      # 00520313
    {load} sbb eax, eax                          # 00520315
    inc eax                                      # 00520317
    mov dword ptr [ebp + arg_10], eax            # 00520318
    mov al, byte ptr [ebp + arg_f]               # 0052031b
    mov byte ptr [esi + edi], al                 # 0052031e
    je.d8 L_00520344                             # 00520321
    # block 0x00520323: entered by fall-through of je at 0x00520321, 11 instruction(s), calls FUN_0052094d, KERNEL32.dll!lstrcpynA, ends with forward jump to 0x00520383
    lea eax, [ebp - local_108]                   # 00520323
    push ebx                                     # 00520329
    push eax                                     # 0052032a
    push dword ptr [ebp + arg_14]                # 0052032b
    call FUN_0052094d                            # 0052032e
    lea eax, [ebp - local_108]                   # 00520333
    push ebx                                     # 00520339
    push eax                                     # 0052033a
    push edi                                     # 0052033b
    call dword ptr [0x52a1d4]                    # 0052033c
    jmp.d8 L_00520383                            # 00520342
L_00520344:
    # block 0x00520344: entered by jne at 0x005202f8; je at 0x00520321, 3 instruction(s), ends with je to 0x00520383 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00520344
    cmp dword ptr [eax + field_18], -0x1         # 00520347
    je.d8 L_00520383                             # 0052034b
    # block 0x0052034d: entered by fall-through of je at 0x0052034b, 18 instruction(s), calls FUN_0052094d, KERNEL32.dll!lstrcpynA, FUN_0051ff98, falls into the block at 0x00520383
    lea ecx, [ebp - local_108]                   # 0052034d
    lea eax, [esi + edi]                         # 00520353
    push ebx                                     # 00520356
    push ecx                                     # 00520357
    push eax                                     # 00520358
    mov dword ptr [ebp + arg_c], eax             # 00520359
    call FUN_0052094d                            # 0052035c
    {load} sub ebx, esi                          # 00520361
    lea eax, [ebp - local_108]                   # 00520363
    push ebx                                     # 00520369
    push eax                                     # 0052036a
    push dword ptr [ebp + arg_c]                 # 0052036b
    call dword ptr [0x52a1d4]                    # 0052036e
    push dword ptr [ebp + arg_18]                # 00520374
    mov eax, dword ptr [ebp - local_4]           # 00520377
    push dword ptr [eax + field_18]              # 0052037a
    push edi                                     # 0052037d
    call FUN_0051ff98                            # 0052037e
L_00520383:
    # block 0x00520383: entered by jmp at 0x00520342; je at 0x0052034b, 7 instruction(s), calls FUN_0051eac4, falls into the block at 0x00520392
    mov ecx, dword ptr [ebp + arg_8]             # 00520383
    push -0x1                                    # 00520386
    call FUN_0051eac4                            # 00520388
    push 0x1                                     # 0052038d
    pop eax                                      # 0052038f
    pop edi                                      # 00520390
    pop ebx                                      # 00520391
L_00520392:
    # block 0x00520392: entered by jmp at 0x005202b4, 3 instruction(s), ends with ret 0x14
    pop esi                                      # 00520392
    leave                                        # 00520393
    ret 0x14                                     # 00520394

