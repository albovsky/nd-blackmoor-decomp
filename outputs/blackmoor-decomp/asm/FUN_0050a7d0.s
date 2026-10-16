# FUN_0050a7d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a7d0
# extent:       0x0050a7d0-0x0050a8d5 (261 code bytes)
# span:         0x0050a7d0-0x0050a8e0 (code 261, tables 0, padding 11)
# sha256:       48c987755c74878cb810055bb007f2e1b03c8c0754f5c521585705ef842c853a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050a450 (+0x380)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a7d0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c, field_40, field_510; [ebx + n] field_340, field_344; [ecx + n] field_4; [edx + n] field_1c, field_504, field_minus_4; [esp + n] stk_10, stk_14, stk_1c, stk_20, stk_24, stk_28
# callees:      calls FUN_0050a8e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_40, 0x40  # offset +0x40
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_504, 0x504  # offset +0x504
.equ field_510, 0x510  # offset +0x510

# --- external targets -----------------------------------------------
.set FUN_0050a8e0, .text + (0x0050a8e0 - 0x401000)

.org 0x0050a7d0 - 0x401000
.globl FUN_0050a7d0
FUN_0050a7d0:
    # block 0x0050a7d0: entry, 19 instruction(s), ends with je to 0x0050a8c4 (forward)
    sub esp, 0x8                                 # 0050a7d0
    mov eax, dword ptr [esp + stk_10]            # 0050a7d3
    push ebx                                     # 0050a7d7
    push esi                                     # 0050a7d8
    mov esi, dword ptr [esp + stk_1c]            # 0050a7d9
    mov ebx, dword ptr [eax + field_510]         # 0050a7dd
    mov eax, dword ptr [esp + stk_14]            # 0050a7e3
    push edi                                     # 0050a7e7
    mov ecx, dword ptr [eax + field_40]          # 0050a7e8
    mov eax, dword ptr [eax + field_1c]          # 0050a7eb
    mov edx, dword ptr [ecx + field_4]           # 0050a7ee
    mov ecx, dword ptr [edx + field_1c]          # 0050a7f1
    mov eax, dword ptr [ecx + 4*eax]             # 0050a7f4
    cdq                                          # 0050a7f7
    {load} sub eax, edx                          # 0050a7f8
    sar eax                                      # 0050a7fa
    test esi, esi                                # 0050a7fc
    mov dword ptr [esp + stk_10], eax            # 0050a7fe
    je.d32 L_0050a8c4                            # 0050a802
    # block 0x0050a808: entered by fall-through of je at 0x0050a802, 9 instruction(s), ends with jle to 0x0050a898 (forward)
    mov ecx, dword ptr [ebx + field_340]         # 0050a808
    mov edx, dword ptr [esp + stk_1c]            # 0050a80e
    imul ecx, dword ptr [esi]                    # 0050a812
    push ebp                                     # 0050a815
    {load} xor edi, edi                          # 0050a816
    {load} xor ebp, ebp                          # 0050a818
    cmp dword ptr [edx + field_504], 0x1         # 0050a81a
    mov dword ptr [esp + stk_10], 0x1            # 0050a821
    jle.d8 L_0050a898                            # 0050a829
    # block 0x0050a82b: entered by fall-through of jle at 0x0050a829, 3 instruction(s), ends with forward jump to 0x0050a83b
    add edx, 0x108                               # 0050a82b
    mov dword ptr [esp + stk_1c], edx            # 0050a831
    jmp.d8 L_0050a83b                            # 0050a835
L_0050a837:
    # block 0x0050a837: entered by jl at 0x0050a892, 1 instruction(s), falls into the block at 0x0050a83b
    mov esi, dword ptr [esp + stk_24]            # 0050a837
L_0050a83b:
    # block 0x0050a83b: entered by jmp at 0x0050a835, 7 instruction(s), ends with jne to 0x0050a874 (forward)
    mov edx, dword ptr [esp + stk_1c]            # 0050a83b
    mov edx, dword ptr [edx]                     # 0050a83f
    mov esi, dword ptr [esi + 4*edx]             # 0050a841
    {load} mov eax, esi                          # 0050a844
    and eax, 0x7fff                              # 0050a846
    {load} cmp eax, esi                          # 0050a84b
    jne.d8 L_0050a874                            # 0050a84d
    # block 0x0050a84f: entered by fall-through of jne at 0x0050a84d, 13 instruction(s), calls FUN_0050a8e0, falls into the block at 0x0050a874
    mov esi, dword ptr [ebx + field_340]         # 0050a84f
    mov edi, dword ptr [ebx + 4*edx + field_344] # 0050a855
    imul esi, eax                                # 0050a85c
    mov eax, dword ptr [esp + stk_28]            # 0050a85f
    push eax                                     # 0050a863
    push esi                                     # 0050a864
    push ecx                                     # 0050a865
    push edi                                     # 0050a866
    push ebp                                     # 0050a867
    call FUN_0050a8e0                            # 0050a868
    add esp, 0x14                                # 0050a86d
    {load} mov ebp, edi                          # 0050a870
    {load} mov ecx, esi                          # 0050a872
L_0050a874:
    # block 0x0050a874: entered by jne at 0x0050a84d, 9 instruction(s), ends with jl to 0x0050a837 (backward)
    mov edx, dword ptr [esp + stk_1c]            # 0050a874
    mov eax, dword ptr [esp + stk_10]            # 0050a878
    add edx, 0x4                                 # 0050a87c
    inc eax                                      # 0050a87f
    mov dword ptr [esp + stk_1c], edx            # 0050a880
    mov edx, dword ptr [esp + stk_20]            # 0050a884
    mov dword ptr [esp + stk_10], eax            # 0050a888
    cmp eax, dword ptr [edx + field_504]         # 0050a88c
    jl.d8 L_0050a837                             # 0050a892
    # block 0x0050a894: entered by fall-through of jl at 0x0050a892, 1 instruction(s), falls into the block at 0x0050a898
    mov eax, dword ptr [esp + stk_14]            # 0050a894
L_0050a898:
    # block 0x0050a898: entered by jle at 0x0050a829, 3 instruction(s), ends with jge to 0x0050a8b8 (forward)
    {load} cmp edi, eax                          # 0050a898
    pop ebp                                      # 0050a89a
    jge.d8 L_0050a8b8                            # 0050a89b
    # block 0x0050a89d: entered by fall-through of jge at 0x0050a89b, 3 instruction(s), falls into the block at 0x0050a8a6
    mov edx, dword ptr [esp + stk_24]            # 0050a89d
    {load} sub eax, edi                          # 0050a8a1
    lea edx, [edx + 4*edi]                       # 0050a8a3
L_0050a8a6:
    # block 0x0050a8a6: entered by jne at 0x0050a8b6, 6 instruction(s), ends with jne to 0x0050a8a6 (backward)
    fld dword ptr [4*ecx + 0x566aa0]             # 0050a8a6
    fmul dword ptr [edx]                         # 0050a8ad
    add edx, 0x4                                 # 0050a8af
    dec eax                                      # 0050a8b2
    fstp dword ptr [edx - field_minus_4]         # 0050a8b3
    jne.d8 L_0050a8a6                            # 0050a8b6
L_0050a8b8:
    # block 0x0050a8b8: entered by jge at 0x0050a89b; fall-through of jne at 0x0050a8b6, 6 instruction(s), ends with ret
    pop edi                                      # 0050a8b8
    pop esi                                      # 0050a8b9
    mov eax, 0x1                                 # 0050a8ba
    pop ebx                                      # 0050a8bf
    add esp, 0x8                                 # 0050a8c0
    ret                                          # 0050a8c3
L_0050a8c4:
    # block 0x0050a8c4: entered by je at 0x0050a802, 9 instruction(s), ends with ret
    mov edi, dword ptr [esp + stk_24]            # 0050a8c4
    {load} mov ecx, eax                          # 0050a8c8
    {load} xor eax, eax                          # 0050a8ca
    rep stosd dword ptr es:[edi], eax            # 0050a8cc
    pop edi                                      # 0050a8ce
    pop esi                                      # 0050a8cf
    pop ebx                                      # 0050a8d0
    add esp, 0x8                                 # 0050a8d1
    ret                                          # 0050a8d4

# --- data items (not part of the function) -------------------------
.org 0x0050a8d5 - 0x401000
PAD_0050a8d5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

