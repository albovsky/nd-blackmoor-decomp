# FUN_005067c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005067c0
# extent:       0x005067c0-0x00506988 (456 code bytes)
# span:         0x005067c0-0x00506990 (code 456, tables 0, padding 8)
# sha256:       6ea2aa9375d01f984ec9488fac6b09979b64e271272aa2bf1dea0176bc19aba3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00506670 (+0x150)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005067c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [ebp + n] field_10, field_14, field_minus_400; [ebx + n] field_4, field_444, field_484, field_888; [ecx + n] field_4; [edi + n] field_minus_40; [edx + n] field_4; [esp + n] stk_10, stk_18, stk_1c, stk_20, stk_24
# callees:      calls FUN_0050e97e, FUN_0050be60, FUN_004ff2f0, FUN_00506650
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 161 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_40, 0x40  # offset -0x40
.equ field_minus_400, 0x400  # offset -0x400
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_444, 0x444  # offset +0x444
.equ field_484, 0x484  # offset +0x484
.equ field_888, 0x888  # offset +0x888

# --- external targets -----------------------------------------------
.set FUN_004ff2f0, .text + (0x004ff2f0 - 0x401000)
.set FUN_00506650, .text + (0x00506650 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x005067c0 - 0x401000
.globl FUN_005067c0
FUN_005067c0:
    # block 0x005067c0: entry, 23 instruction(s), calls FUN_0050e97e, FUN_0050be60, ends with je to 0x0050680c (forward)
    push ecx                                     # 005067c0
    push ebx                                     # 005067c1
    push ebp                                     # 005067c2
    push esi                                     # 005067c3
    push edi                                     # 005067c4
    push 0xc88                                   # 005067c5
    push 0x1                                     # 005067ca
    call FUN_0050e97e                            # 005067cc
    mov esi, dword ptr [esp + stk_24]            # 005067d1
    {load} mov ebx, eax                          # 005067d5
    mov eax, dword ptr [esp + stk_20]            # 005067d7
    mov ecx, 0x322                               # 005067db
    {load} mov edi, ebx                          # 005067e0
    push 0x1                                     # 005067e2
    mov ebp, dword ptr [eax + field_1c]          # 005067e4
    {load} xor eax, eax                          # 005067e7
    rep stosd dword ptr es:[edi], eax            # 005067e9
    push esi                                     # 005067eb
    mov dword ptr [esp + stk_20], ebp            # 005067ec
    call FUN_0050be60                            # 005067f0
    add esp, 0x10                                # 005067f5
    test eax, eax                                # 005067f8
    je.d8 L_0050680c                             # 005067fa
    # block 0x005067fc: entered by fall-through of je at 0x005067fa, 7 instruction(s), calls FUN_0050be60, ends with forward jump to 0x00506812
    push 0x4                                     # 005067fc
    push esi                                     # 005067fe
    call FUN_0050be60                            # 005067ff
    add esp, 0x8                                 # 00506804
    inc eax                                      # 00506807
    mov dword ptr [ebx], eax                     # 00506808
    jmp.d8 L_00506812                            # 0050680a
L_0050680c:
    # block 0x0050680c: entered by je at 0x005067fa, 1 instruction(s), falls into the block at 0x00506812
    mov dword ptr [ebx], 0x1                     # 0050680c
L_00506812:
    # block 0x00506812: entered by jmp at 0x0050680a, 6 instruction(s), calls FUN_0050be60, ends with je to 0x005068cc (forward)
    push 0x1                                     # 00506812
    push esi                                     # 00506814
    call FUN_0050be60                            # 00506815
    add esp, 0x8                                 # 0050681a
    test eax, eax                                # 0050681d
    je.d32 L_005068cc                            # 0050681f
    # block 0x00506825: entered by fall-through of je at 0x0050681f, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x005068cc (forward)
    push 0x8                                     # 00506825
    push esi                                     # 00506827
    call FUN_0050be60                            # 00506828
    add esp, 0x8                                 # 0050682d
    inc eax                                      # 00506830
    test eax, eax                                # 00506831
    mov dword ptr [ebx + field_484], eax         # 00506833
    mov dword ptr [esp + stk_1c], 0x0            # 00506839
    jle.d32 L_005068cc                           # 00506841
    # block 0x00506847: entered by fall-through of jle at 0x00506841, 1 instruction(s), falls into the block at 0x0050684d
    lea ebp, [ebx + field_888]                   # 00506847
L_0050684d:
    # block 0x0050684d: entered by jl at 0x005068c6, 20 instruction(s), calls FUN_004ff2f0, FUN_0050be60, ends with jl to 0x00506977 (forward)
    mov ecx, dword ptr [esp + stk_18]            # 0050684d
    mov edx, dword ptr [ecx + field_4]           # 00506851
    push edx                                     # 00506854
    call FUN_004ff2f0                            # 00506855
    push eax                                     # 0050685a
    push esi                                     # 0050685b
    call FUN_0050be60                            # 0050685c
    {load} mov edi, eax                          # 00506861
    mov eax, dword ptr [esp + stk_24]            # 00506863
    mov dword ptr [ebp - field_minus_400], edi   # 00506867
    mov ecx, dword ptr [eax + field_4]           # 0050686d
    push ecx                                     # 00506870
    call FUN_004ff2f0                            # 00506871
    push eax                                     # 00506876
    push esi                                     # 00506877
    call FUN_0050be60                            # 00506878
    add esp, 0x18                                # 0050687d
    {disp8} mov dword ptr [ebp], eax             # 00506880
    test edi, edi                                # 00506883
    jl.d32 L_00506977                            # 00506885
    # block 0x0050688b: entered by fall-through of jl at 0x00506885, 2 instruction(s), ends with jl to 0x00506977 (forward)
    test eax, eax                                # 0050688b
    jl.d32 L_00506977                            # 0050688d
    # block 0x00506893: entered by fall-through of jl at 0x0050688d, 2 instruction(s), ends with je to 0x00506977 (forward)
    {load} cmp edi, eax                          # 00506893
    je.d32 L_00506977                            # 00506895
    # block 0x0050689b: entered by fall-through of je at 0x00506895, 4 instruction(s), ends with jge to 0x00506977 (forward)
    mov edx, dword ptr [esp + stk_18]            # 0050689b
    mov ecx, dword ptr [edx + field_4]           # 0050689f
    {load} cmp edi, ecx                          # 005068a2
    jge.d32 L_00506977                           # 005068a4
    # block 0x005068aa: entered by fall-through of jge at 0x005068a4, 2 instruction(s), ends with jge to 0x00506977 (forward)
    {load} cmp eax, ecx                          # 005068aa
    jge.d32 L_00506977                           # 005068ac
    # block 0x005068b2: entered by fall-through of jge at 0x005068ac, 7 instruction(s), ends with jl to 0x0050684d (backward)
    mov eax, dword ptr [esp + stk_1c]            # 005068b2
    mov ecx, dword ptr [ebx + field_484]         # 005068b6
    inc eax                                      # 005068bc
    add ebp, 0x4                                 # 005068bd
    {load} cmp eax, ecx                          # 005068c0
    mov dword ptr [esp + stk_1c], eax            # 005068c2
    jl.d8 L_0050684d                             # 005068c6
    # block 0x005068c8: entered by fall-through of jl at 0x005068c6, 1 instruction(s), falls into the block at 0x005068cc
    mov ebp, dword ptr [esp + stk_10]            # 005068c8
L_005068cc:
    # block 0x005068cc: entered by je at 0x0050681f; jle at 0x00506841, 6 instruction(s), calls FUN_0050be60, ends with jg to 0x00506977 (forward)
    push 0x2                                     # 005068cc
    push esi                                     # 005068ce
    call FUN_0050be60                            # 005068cf
    add esp, 0x8                                 # 005068d4
    test eax, eax                                # 005068d7
    jg.d32 L_00506977                            # 005068d9
    # block 0x005068df: entered by fall-through of jg at 0x005068d9, 2 instruction(s), ends with jle to 0x00506918 (forward)
    cmp dword ptr [ebx], 0x1                     # 005068df
    jle.d8 L_00506918                            # 005068e2
    # block 0x005068e4: entered by fall-through of jle at 0x005068e2, 5 instruction(s), ends with jle to 0x00506914 (forward)
    mov eax, dword ptr [esp + stk_18]            # 005068e4
    {load} xor ebp, ebp                          # 005068e8
    mov ecx, dword ptr [eax + field_4]           # 005068ea
    test ecx, ecx                                # 005068ed
    jle.d8 L_00506914                            # 005068ef
    # block 0x005068f1: entered by fall-through of jle at 0x005068ef, 1 instruction(s), falls into the block at 0x005068f4
    lea edi, [ebx + field_4]                     # 005068f1
L_005068f4:
    # block 0x005068f4: entered by jl at 0x00506912, 8 instruction(s), calls FUN_0050be60, ends with jge to 0x00506977 (forward)
    push 0x4                                     # 005068f4
    push esi                                     # 005068f6
    call FUN_0050be60                            # 005068f7
    mov dword ptr [edi], eax                     # 005068fc
    mov ecx, dword ptr [ebx]                     # 005068fe
    add esp, 0x8                                 # 00506900
    {load} cmp eax, ecx                          # 00506903
    jge.d8 L_00506977                            # 00506905
    # block 0x00506907: entered by fall-through of jge at 0x00506905, 5 instruction(s), ends with jl to 0x005068f4 (backward)
    mov ecx, dword ptr [esp + stk_18]            # 00506907
    inc ebp                                      # 0050690b
    add edi, 0x4                                 # 0050690c
    cmp ebp, dword ptr [ecx + field_4]           # 0050690f
    jl.d8 L_005068f4                             # 00506912
L_00506914:
    # block 0x00506914: entered by jle at 0x005068ef; fall-through of jl at 0x00506912, 1 instruction(s), falls into the block at 0x00506918
    mov ebp, dword ptr [esp + stk_10]            # 00506914
L_00506918:
    # block 0x00506918: entered by jle at 0x005068e2, 4 instruction(s), ends with jle to 0x0050696f (forward)
    mov eax, dword ptr [ebx]                     # 00506918
    mov dword ptr [esp + stk_1c], 0x0            # 0050691a
    test eax, eax                                # 00506922
    jle.d8 L_0050696f                            # 00506924
    # block 0x00506926: entered by fall-through of jle at 0x00506924, 1 instruction(s), falls into the block at 0x0050692c
    lea edi, [ebx + field_444]                   # 00506926
L_0050692c:
    # block 0x0050692c: entered by jl at 0x0050696d, 11 instruction(s), calls FUN_0050be60, ends with jge to 0x00506977 (forward)
    push 0x8                                     # 0050692c
    push esi                                     # 0050692e
    call FUN_0050be60                            # 0050692f
    push 0x8                                     # 00506934
    push esi                                     # 00506936
    call FUN_0050be60                            # 00506937
    mov dword ptr [edi - field_minus_40], eax    # 0050693c
    mov ecx, dword ptr [ebp + field_10]          # 0050693f
    add esp, 0x10                                # 00506942
    {load} cmp eax, ecx                          # 00506945
    jge.d8 L_00506977                            # 00506947
    # block 0x00506949: entered by fall-through of jge at 0x00506947, 8 instruction(s), calls FUN_0050be60, ends with jge to 0x00506977 (forward)
    push 0x8                                     # 00506949
    push esi                                     # 0050694b
    call FUN_0050be60                            # 0050694c
    mov dword ptr [edi], eax                     # 00506951
    mov ecx, dword ptr [ebp + field_14]          # 00506953
    add esp, 0x8                                 # 00506956
    {load} cmp eax, ecx                          # 00506959
    jge.d8 L_00506977                            # 0050695b
    # block 0x0050695d: entered by fall-through of jge at 0x0050695b, 7 instruction(s), ends with jl to 0x0050692c (backward)
    mov eax, dword ptr [esp + stk_1c]            # 0050695d
    mov ecx, dword ptr [ebx]                     # 00506961
    inc eax                                      # 00506963
    add edi, 0x4                                 # 00506964
    {load} cmp eax, ecx                          # 00506967
    mov dword ptr [esp + stk_1c], eax            # 00506969
    jl.d8 L_0050692c                             # 0050696d
L_0050696f:
    # block 0x0050696f: entered by jle at 0x00506924; fall-through of jl at 0x0050696d, 7 instruction(s), ends with ret
    pop edi                                      # 0050696f
    pop esi                                      # 00506970
    {load} mov eax, ebx                          # 00506971
    pop ebp                                      # 00506973
    pop ebx                                      # 00506974
    pop ecx                                      # 00506975
    ret                                          # 00506976
L_00506977:
    # block 0x00506977: entered by jl at 0x00506885; jl at 0x0050688d; je at 0x00506895; jge at 0x005068a4; more, 10 instruction(s), calls FUN_00506650, ends with ret
    push ebx                                     # 00506977
    call FUN_00506650                            # 00506978
    add esp, 0x4                                 # 0050697d
    {load} xor eax, eax                          # 00506980
    pop edi                                      # 00506982
    pop esi                                      # 00506983
    pop ebp                                      # 00506984
    pop ebx                                      # 00506985
    pop ecx                                      # 00506986
    ret                                          # 00506987

# --- data items (not part of the function) -------------------------
.org 0x00506988 - 0x401000
PAD_00506988:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

