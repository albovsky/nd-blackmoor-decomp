# FUN_0050b5a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b5a0
# extent:       0x0050b5a0-0x0050b6e7 (327 code bytes)
# span:         0x0050b5a0-0x0050b6f0 (code 327, tables 0, padding 9)
# sha256:       9b8530a2911f64dff0d24a87816bbfcc862d92cb64a6215eefd3be6b20d353db
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b5a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c, field_1b; [edi + n] field_1, field_16, field_1a, field_1b; [esi + n] field_8, field_c, field_10, field_14, field_18; [esp + n] stk_10, stk_14, stk_1c, stk_20, stk_28
# callees:      calls FUN_0050b380, FUN_0050f830
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 142 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1b, 0x1b  # offset +0x1b
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0050b380, .text + (0x0050b380 - 0x401000)
.set FUN_0050f830, .text + (0x0050f830 - 0x401000)

.org 0x0050b5a0 - 0x401000
.globl FUN_0050b5a0
FUN_0050b5a0:
    # block 0x0050b5a0: entry, 15 instruction(s), ends with jne to 0x0050b610 (forward)
    sub esp, 0x10                                # 0050b5a0
    {load} xor edx, edx                          # 0050b5a3
    push ebx                                     # 0050b5a5
    push ebp                                     # 0050b5a6
    push esi                                     # 0050b5a7
    mov esi, dword ptr [esp + stk_20]            # 0050b5a8
    push edi                                     # 0050b5ac
    mov eax, dword ptr [esi + field_c]           # 0050b5ad
    mov edi, dword ptr [esi]                     # 0050b5b0
    mov ebx, dword ptr [esi + field_8]           # 0050b5b2
    {load} add edi, eax                          # 0050b5b5
    {load} sub ebx, eax                          # 0050b5b7
    mov eax, dword ptr [esi + field_14]          # 0050b5b9
    {load} cmp eax, edx                          # 0050b5bc
    jne.d8 L_0050b610                            # 0050b5be
    # block 0x0050b5c0: entered by fall-through of jne at 0x0050b5be, 2 instruction(s), ends with jge to 0x0050b5cf (forward)
    cmp ebx, 0x1b                                # 0050b5c0
    jge.d8 L_0050b5cf                            # 0050b5c3
    # block 0x0050b5c5: entered by fall-through of jge at 0x0050b5c3, 7 instruction(s), ends with ret
    pop edi                                      # 0050b5c5
    pop esi                                      # 0050b5c6
    pop ebp                                      # 0050b5c7
    {load} xor eax, eax                          # 0050b5c8
    pop ebx                                      # 0050b5ca
    add esp, 0x10                                # 0050b5cb
    ret                                          # 0050b5ce
L_0050b5cf:
    # block 0x0050b5cf: entered by jge at 0x0050b5c3, 4 instruction(s), ends with jne to 0x0050b667 (forward)
    mov ecx, dword ptr [edi]                     # 0050b5cf
    mov eax, 0x567774                            # 0050b5d1
    cmp ecx, dword ptr [eax]                     # 0050b5d6
    jne.d32 L_0050b667                           # 0050b5d8
    # block 0x0050b5de: entered by fall-through of jne at 0x0050b5d8, 5 instruction(s), ends with jge to 0x0050b5f4 (forward)
    {load} xor ecx, ecx                          # 0050b5de
    mov cl, byte ptr [edi + field_1a]            # 0050b5e0
    lea ebp, [ecx + field_1b]                    # 0050b5e3
    {load} cmp ebx, ebp                          # 0050b5e6
    jge.d8 L_0050b5f4                            # 0050b5e8
    # block 0x0050b5ea: entered by fall-through of jge at 0x0050b5e8, 7 instruction(s), ends with ret
    pop edi                                      # 0050b5ea
    pop esi                                      # 0050b5eb
    pop ebp                                      # 0050b5ec
    {load} xor eax, eax                          # 0050b5ed
    pop ebx                                      # 0050b5ef
    add esp, 0x10                                # 0050b5f0
    ret                                          # 0050b5f3
L_0050b5f4:
    # block 0x0050b5f4: entered by jge at 0x0050b5e8, 3 instruction(s), ends with jle to 0x0050b60d (forward)
    {load} xor eax, eax                          # 0050b5f4
    {load} cmp ecx, edx                          # 0050b5f6
    jle.d8 L_0050b60d                            # 0050b5f8
L_0050b5fa:
    # block 0x0050b5fa: entered by jl at 0x0050b60b; fall-through of jle at 0x0050b5f8, 8 instruction(s), ends with jl to 0x0050b5fa (backward)
    {load} xor ecx, ecx                          # 0050b5fa
    mov cl, byte ptr [edi + eax + field_1b]      # 0050b5fc
    add dword ptr [esi + field_18], ecx          # 0050b600
    {load} xor ecx, ecx                          # 0050b603
    mov cl, byte ptr [edi + field_1a]            # 0050b605
    inc eax                                      # 0050b608
    {load} cmp eax, ecx                          # 0050b609
    jl.d8 L_0050b5fa                             # 0050b60b
L_0050b60d:
    # block 0x0050b60d: entered by jle at 0x0050b5f8; fall-through of jl at 0x0050b60b, 1 instruction(s), falls into the block at 0x0050b610
    mov dword ptr [esi + field_14], ebp          # 0050b60d
L_0050b610:
    # block 0x0050b610: entered by jne at 0x0050b5be, 5 instruction(s), ends with jle to 0x0050b626 (forward)
    mov eax, dword ptr [esi + field_14]          # 0050b610
    mov ebp, dword ptr [esi + field_18]          # 0050b613
    {load} add eax, ebp                          # 0050b616
    {load} cmp eax, ebx                          # 0050b618
    jle.d8 L_0050b626                            # 0050b61a
    # block 0x0050b61c: entered by fall-through of jle at 0x0050b61a, 7 instruction(s), ends with ret
    pop edi                                      # 0050b61c
    pop esi                                      # 0050b61d
    pop ebp                                      # 0050b61e
    {load} xor eax, eax                          # 0050b61f
    pop ebx                                      # 0050b621
    add esp, 0x10                                # 0050b622
    ret                                          # 0050b625
L_0050b626:
    # block 0x0050b626: entered by jle at 0x0050b61a, 19 instruction(s), calls FUN_0050b380, ends with je to 0x0050b69f (forward)
    mov ebp, dword ptr [edi + field_16]          # 0050b626
    mov dword ptr [edi + field_16], edx          # 0050b629
    mov eax, dword ptr [esi + field_14]          # 0050b62c
    mov ecx, dword ptr [esi + field_18]          # 0050b62f
    mov dword ptr [esp + stk_14], eax            # 0050b632
    lea edx, [esp + stk_10]                      # 0050b636
    {load} add eax, edi                          # 0050b63a
    push edx                                     # 0050b63c
    mov dword ptr [esp + stk_28], ebp            # 0050b63d
    mov dword ptr [esp + stk_14], edi            # 0050b641
    mov dword ptr [esp + stk_1c], eax            # 0050b645
    mov dword ptr [esp + stk_20], ecx            # 0050b649
    call FUN_0050b380                            # 0050b64d
    lea eax, [esp + stk_28]                      # 0050b652
    add esp, 0x4                                 # 0050b656
    mov ecx, dword ptr [eax]                     # 0050b659
    mov eax, dword ptr [edi + field_16]          # 0050b65b
    {load} cmp ecx, eax                          # 0050b65e
    je.d8 L_0050b69f                             # 0050b660
    # block 0x0050b662: entered by fall-through of je at 0x0050b660, 2 instruction(s), falls into the block at 0x0050b667
    mov dword ptr [edi + field_16], ebp          # 0050b662
    {load} xor edx, edx                          # 0050b665
L_0050b667:
    # block 0x0050b667: entered by jne at 0x0050b5d8, 12 instruction(s), calls FUN_0050f830, ends with jne to 0x0050b68a (forward)
    dec ebx                                      # 0050b667
    mov dword ptr [esi + field_14], edx          # 0050b668
    mov dword ptr [esi + field_18], edx          # 0050b66b
    push ebx                                     # 0050b66e
    lea edx, [edi + field_1]                     # 0050b66f
    push 0x4f                                    # 0050b672
    push edx                                     # 0050b674
    call FUN_0050f830                            # 0050b675
    {load} mov ecx, eax                          # 0050b67a
    add esp, 0xc                                 # 0050b67c
    test ecx, ecx                                # 0050b67f
    jne.d8 L_0050b68a                            # 0050b681
    # block 0x0050b683: entered by fall-through of jne at 0x0050b681, 3 instruction(s), falls into the block at 0x0050b68a
    mov ecx, dword ptr [esi + field_8]           # 0050b683
    mov eax, dword ptr [esi]                     # 0050b686
    {load} add ecx, eax                          # 0050b688
L_0050b68a:
    # block 0x0050b68a: entered by jne at 0x0050b681, 12 instruction(s), ends with ret
    mov ebx, dword ptr [esi]                     # 0050b68a
    {load} mov eax, ecx                          # 0050b68c
    {load} sub eax, ebx                          # 0050b68e
    mov dword ptr [esi + field_c], eax           # 0050b690
    {load} mov eax, edi                          # 0050b693
    pop edi                                      # 0050b695
    pop esi                                      # 0050b696
    pop ebp                                      # 0050b697
    {load} sub eax, ecx                          # 0050b698
    pop ebx                                      # 0050b69a
    add esp, 0x10                                # 0050b69b
    ret                                          # 0050b69e
L_0050b69f:
    # block 0x0050b69f: entered by je at 0x0050b660, 7 instruction(s), ends with je to 0x0050b6c6 (forward)
    mov eax, dword ptr [esi]                     # 0050b69f
    mov ebx, dword ptr [esi + field_c]           # 0050b6a1
    mov ecx, dword ptr [esp + stk_28]            # 0050b6a4
    {load} xor edx, edx                          # 0050b6a8
    {load} add eax, ebx                          # 0050b6aa
    {load} cmp ecx, edx                          # 0050b6ac
    je.d8 L_0050b6c6                             # 0050b6ae
    # block 0x0050b6b0: entered by fall-through of je at 0x0050b6ae, 8 instruction(s), falls into the block at 0x0050b6c6
    mov dword ptr [ecx], eax                     # 0050b6b0
    mov edi, dword ptr [esi + field_14]          # 0050b6b2
    mov dword ptr [ecx + field_4], edi           # 0050b6b5
    mov edi, dword ptr [esi + field_14]          # 0050b6b8
    {load} add edi, eax                          # 0050b6bb
    mov dword ptr [ecx + field_8], edi           # 0050b6bd
    mov eax, dword ptr [esi + field_18]          # 0050b6c0
    mov dword ptr [ecx + field_c], eax           # 0050b6c3
L_0050b6c6:
    # block 0x0050b6c6: entered by je at 0x0050b6ae, 15 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_14]          # 0050b6c6
    mov edi, dword ptr [esi + field_18]          # 0050b6c9
    mov ecx, dword ptr [esi + field_c]           # 0050b6cc
    {load} add eax, edi                          # 0050b6cf
    {load} add ecx, eax                          # 0050b6d1
    mov dword ptr [esi + field_10], edx          # 0050b6d3
    mov dword ptr [esi + field_c], ecx           # 0050b6d6
    mov dword ptr [esi + field_14], edx          # 0050b6d9
    mov dword ptr [esi + field_18], edx          # 0050b6dc
    pop edi                                      # 0050b6df
    pop esi                                      # 0050b6e0
    pop ebp                                      # 0050b6e1
    pop ebx                                      # 0050b6e2
    add esp, 0x10                                # 0050b6e3
    ret                                          # 0050b6e6

# --- data items (not part of the function) -------------------------
.org 0x0050b6e7 - 0x401000
PAD_0050b6e7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

