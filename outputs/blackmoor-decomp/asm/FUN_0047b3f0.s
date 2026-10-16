# FUN_0047b3f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b3f0
# extent:       0x0047b3f0-0x0047b4aa (186 code bytes)
# span:         0x0047b3f0-0x0047b4aa (code 186, tables 0, padding 0)
# sha256:       252fe25c5b07d09db259805233017b1ad853ca09e658a4b5d7f671300a540cca
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b3f0
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0047b3f0 - 0x401000
.globl FUN_0047b3f0
FUN_0047b3f0:
    # block 0x0047b3f0: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047b457 (forward)
    push ebp                                     # 0047b3f0
    {load} mov ebp, esp                          # 0047b3f1
    sub esp, 0x8                                 # 0047b3f3
    push esi                                     # 0047b3f6
    push edi                                     # 0047b3f7
    mov dword ptr [ebp - local_8], ecx           # 0047b3f8
    push 0x16c2                                  # 0047b3fb
    call FUN_0051dc43                            # 0047b400
    add esp, 0x4                                 # 0047b405
    mov dword ptr [ebp - local_4], eax           # 0047b408
    mov eax, dword ptr [ebp + arg_8]             # 0047b40b
    mov ecx, dword ptr [ebp - local_4]           # 0047b40e
    mov dword ptr [eax], ecx                     # 0047b411
    cmp dword ptr [ebp - local_4], 0x0           # 0047b413
    jne.d8 L_0047b457                            # 0047b417
    # block 0x0047b419: entered by fall-through of jne at 0x0047b417, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047b457
    movsx edx, word ptr [0x5c39e3]               # 0047b419
    push edx                                     # 0047b420
    mov eax, dword ptr [0x5bb57b]                # 0047b421
    push eax                                     # 0047b426
    push 0x54cdd4                                # 0047b427
    push 0x63888b                                # 0047b42c
    call FUN_0050ca3e                            # 0047b431
    add esp, 0x10                                # 0047b436
    push 0x63888b                                # 0047b439
    push 0x54ce00                                # 0047b43e
    mov ecx, 0x583979                            # 0047b443
    call FUN_0042639d                            # 0047b448
    mov ecx, 0x5cf659                            # 0047b44d
    call FUN_004c97b4                            # 0047b452
L_0047b457:
    # block 0x0047b457: entered by jne at 0x0047b417, 20 instruction(s), ends with je to 0x0047b4a2 (forward)
    mov ecx, 0x5b0                               # 0047b457
    mov edx, dword ptr [ebp + arg_c]             # 0047b45c
    mov esi, dword ptr [edx]                     # 0047b45f
    mov eax, dword ptr [ebp + arg_8]             # 0047b461
    mov edi, dword ptr [eax]                     # 0047b464
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047b466
    movsw word ptr es:[edi], word ptr [esi]      # 0047b468
    mov ecx, dword ptr [ebp + arg_10]            # 0047b46a
    mov edx, dword ptr [ecx]                     # 0047b46d
    add edx, 0x16c2                              # 0047b46f
    mov eax, dword ptr [ebp + arg_10]            # 0047b475
    mov dword ptr [eax], edx                     # 0047b478
    mov ecx, dword ptr [ebp + arg_c]             # 0047b47a
    mov edx, dword ptr [ecx]                     # 0047b47d
    add edx, 0x16c2                              # 0047b47f
    mov eax, dword ptr [ebp + arg_c]             # 0047b485
    mov dword ptr [eax], edx                     # 0047b488
    movsx ecx, word ptr [0x63a4cd]               # 0047b48a
    test ecx, ecx                                # 0047b491
    je.d8 L_0047b4a2                             # 0047b493
    # block 0x0047b495: entered by fall-through of je at 0x0047b493, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047b4a2
    push 0x54ce1c                                # 0047b495
    call FUN_0044a2b7                            # 0047b49a
    add esp, 0x4                                 # 0047b49f
L_0047b4a2:
    # block 0x0047b4a2: entered by je at 0x0047b493, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047b4a2
    pop esi                                      # 0047b4a3
    {load} mov esp, ebp                          # 0047b4a4
    pop ebp                                      # 0047b4a6
    ret 0xc                                      # 0047b4a7

