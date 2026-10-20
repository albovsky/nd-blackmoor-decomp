# FUN_00412787
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00412787
# extent:       0x00412787-0x004129da (595 code bytes)
# span:         0x00412787-0x004129da (code 595, tables 0, padding 0)
# sha256:       4656759381574d9bfbba2bdd4fbb9c6b92ce3f283f46b86190688832279eda7e
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m412787_register_name
# naming:       native port src/original_methods_fl19b.c:m412787_register_name (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m412787_register_name. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 595 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_19, local_1a, local_20, local_24
# fields:       [eax + n] field_1, field_23; [edx + n] field_1, field_23, field_25
# callees:      calls FUN_00423259, FUN_0042ba3a, FUN_0052139c, FUN_004e0559
# track-n:      outputs/blackmoor-decomp/src/action_family_47_runtime.h:a47_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 166 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_19, 0x19  # offset -0x19
.equ local_1a, 0x1a  # offset -0x1a
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00412787 - 0x401000
.globl FUN_00412787
FUN_00412787:
    # block 0x00412787: entry, 16 instruction(s), ends with forward jump to 0x004127c6
    push ebp                                     # 00412787
    {load} mov ebp, esp                          # 00412788
    sub esp, 0x24                                # 0041278a
    push esi                                     # 0041278d
    push edi                                     # 0041278e
    mov dword ptr [ebp - local_10], ecx          # 0041278f
    movsx eax, word ptr [ebp + arg_8]            # 00412792
    imul eax, eax, 0x8d                          # 00412796
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0041279c
    mov dword ptr [ebp - local_8], ecx           # 004127a2
    mov edx, dword ptr [ebp - local_8]           # 004127a5
    movsx eax, word ptr [edx]                    # 004127a8
    sub eax, 0x3                                 # 004127ab
    mov word ptr [ebp - local_c], ax             # 004127ae
    mov word ptr [ebp - local_4], 0x0            # 004127b2
    jmp.d8 L_004127c6                            # 004127b8
L_004127ba:
    # block 0x004127ba: entered by jmp at 0x0041287a, 3 instruction(s), falls into the block at 0x004127c6
    mov cx, word ptr [ebp - local_4]             # 004127ba
    add cx, 0x1                                  # 004127be
    mov word ptr [ebp - local_4], cx             # 004127c2
L_004127c6:
    # block 0x004127c6: entered by jmp at 0x004127b8, 5 instruction(s), ends with jge to 0x0041287f (forward)
    movsx edx, word ptr [ebp - local_4]          # 004127c6
    movsx eax, word ptr [ebp - local_c]          # 004127ca
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 004127ce
    {load} cmp edx, ecx                          # 004127d6
    jge.d32 L_0041287f                           # 004127d8
    # block 0x004127de: entered by fall-through of jge at 0x004127d8, 9 instruction(s), falls into the block at 0x00412802
    mov edx, dword ptr [ebp - local_8]           # 004127de
    add edx, 0x2                                 # 004127e1
    mov dword ptr [ebp - local_14], edx          # 004127e4
    movsx eax, word ptr [ebp - local_c]          # 004127e7
    imul eax, eax, 0x3390                        # 004127eb
    movsx ecx, word ptr [ebp - local_4]          # 004127f1
    imul ecx, ecx, 0x21                          # 004127f5
    lea edx, [eax + ecx + 0x5957cb]              # 004127f8
    mov dword ptr [ebp - local_18], edx          # 004127ff
L_00412802:
    # block 0x00412802: entered by jne at 0x00412834, 6 instruction(s), ends with jne to 0x0041283f (forward)
    mov eax, dword ptr [ebp - local_18]          # 00412802
    mov cl, byte ptr [eax]                       # 00412805
    mov byte ptr [ebp - local_19], cl            # 00412807
    mov edx, dword ptr [ebp - local_14]          # 0041280a
    cmp cl, byte ptr [edx]                       # 0041280d
    jne.d8 L_0041283f                            # 0041280f
    # block 0x00412811: entered by fall-through of jne at 0x0041280f, 2 instruction(s), ends with je to 0x00412836 (forward)
    cmp byte ptr [ebp - local_19], 0x0           # 00412811
    je.d8 L_00412836                             # 00412815
    # block 0x00412817: entered by fall-through of je at 0x00412815, 6 instruction(s), ends with jne to 0x0041283f (forward)
    mov eax, dword ptr [ebp - local_18]          # 00412817
    mov cl, byte ptr [eax + field_1]             # 0041281a
    mov byte ptr [ebp - local_1a], cl            # 0041281d
    mov edx, dword ptr [ebp - local_14]          # 00412820
    cmp cl, byte ptr [edx + field_1]             # 00412823
    jne.d8 L_0041283f                            # 00412826
    # block 0x00412828: entered by fall-through of jne at 0x00412826, 4 instruction(s), ends with jne to 0x00412802 (backward)
    add dword ptr [ebp - local_18], 0x2          # 00412828
    add dword ptr [ebp - local_14], 0x2          # 0041282c
    cmp byte ptr [ebp - local_1a], 0x0           # 00412830
    jne.d8 L_00412802                            # 00412834
L_00412836:
    # block 0x00412836: entered by je at 0x00412815; fall-through of jne at 0x00412834, 2 instruction(s), ends with forward jump to 0x00412847
    mov dword ptr [ebp - local_20], 0x0          # 00412836
    jmp.d8 L_00412847                            # 0041283d
L_0041283f:
    # block 0x0041283f: entered by jne at 0x0041280f; jne at 0x00412826, 3 instruction(s), falls into the block at 0x00412847
    {load} sbb eax, eax                          # 0041283f
    sbb eax, -0x1                                # 00412841
    mov dword ptr [ebp - local_20], eax          # 00412844
L_00412847:
    # block 0x00412847: entered by jmp at 0x0041283d, 4 instruction(s), ends with je to 0x00412868 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00412847
    mov dword ptr [ebp - local_24], ecx          # 0041284a
    cmp dword ptr [ebp - local_24], 0x0          # 0041284d
    je.d8 L_00412868                             # 00412851
    # block 0x00412853: entered by fall-through of je at 0x00412851, 7 instruction(s), calls FUN_00423259, ends with jne to 0x0041287a (forward)
    mov edx, dword ptr [ebp - local_8]           # 00412853
    add edx, 0x2                                 # 00412856
    push edx                                     # 00412859
    mov ecx, 0x619a6b                            # 0041285a
    call FUN_00423259                            # 0041285f
    test eax, eax                                # 00412864
    jne.d8 L_0041287a                            # 00412866
L_00412868:
    # block 0x00412868: entered by je at 0x00412851; fall-through of jne at 0x00412866, 5 instruction(s), calls FUN_0042ba3a, ends with forward jump to 0x004129d2
    mov ax, word ptr [ebp + arg_8]               # 00412868
    push eax                                     # 0041286c
    call FUN_0042ba3a                            # 0041286d
    add esp, 0x4                                 # 00412872
    jmp.d32 L_004129d2                           # 00412875
L_0041287a:
    # block 0x0041287a: entered by jne at 0x00412866, 1 instruction(s), ends with backward jump to 0x004127ba
    jmp.d32 L_004127ba                           # 0041287a
L_0041287f:
    # block 0x0041287f: entered by jge at 0x004127d8, 4 instruction(s), ends with jne to 0x004128a6 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0041287f
    movsx edx, word ptr [2*ecx + 0x59fbdb]       # 00412883
    cmp edx, 0x190                               # 0041288b
    jne.d8 L_004128a6                            # 00412891
    # block 0x00412893: entered by fall-through of jne at 0x00412891, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00412971
    push 0x0                                     # 00412893
    push 0x0                                     # 00412895
    push 0x54164c                                # 00412897
    call FUN_0052139c                            # 0041289c
    jmp.d32 L_00412971                           # 004128a1
L_004128a6:
    # block 0x004128a6: entered by jne at 0x00412891, 34 instruction(s), ends with jge to 0x0041292a (forward)
    mov eax, dword ptr [ebp - local_8]           # 004128a6
    add eax, 0x2                                 # 004128a9
    {load} mov edi, eax                          # 004128ac
    movsx ecx, word ptr [ebp - local_c]          # 004128ae
    imul ecx, ecx, 0x3390                        # 004128b2
    movsx edx, word ptr [ebp - local_c]          # 004128b8
    movsx eax, word ptr [2*edx + 0x59fbdb]       # 004128bc
    imul eax, eax, 0x21                          # 004128c4
    lea ecx, [ecx + eax + 0x5957cb]              # 004128c7
    {load} mov edx, ecx                          # 004128ce
    or ecx, -0x1                                 # 004128d0
    {load} xor eax, eax                          # 004128d3
    repne scasb al, byte ptr es:[edi]            # 004128d5
    not ecx                                      # 004128d7
    {load} sub edi, ecx                          # 004128d9
    {load} mov esi, edi                          # 004128db
    {load} mov eax, ecx                          # 004128dd
    {load} mov edi, edx                          # 004128df
    shr ecx, 0x2                                 # 004128e1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004128e4
    {load} mov ecx, eax                          # 004128e6
    and ecx, 0x3                                 # 004128e8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004128eb
    movsx ecx, word ptr [ebp - local_c]          # 004128ed
    imul ecx, ecx, 0x320                         # 004128f1
    movsx edx, word ptr [ebp - local_c]          # 004128f7
    movsx eax, word ptr [2*edx + 0x59fbdb]       # 004128fb
    mov edx, dword ptr [ebp - local_8]           # 00412903
    mov dx, word ptr [edx + field_23]            # 00412906
    mov word ptr [ecx + 2*eax + 0x59f27b], dx    # 0041290a
    mov eax, dword ptr [ebp - local_8]           # 00412912
    movsx ecx, word ptr [eax + field_23]         # 00412915
    cmp ecx, 0xa                                 # 00412919
    jge.d8 L_0041292a                            # 0041291c
    # block 0x0041291e: entered by fall-through of jge at 0x0041291c, 4 instruction(s), ends with jne to 0x00412951 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041291e
    movsx eax, word ptr [edx + field_23]         # 00412921
    cmp eax, 0x7                                 # 00412925
    jne.d8 L_00412951                            # 00412928
L_0041292a:
    # block 0x0041292a: entered by jge at 0x0041291c; fall-through of jne at 0x00412928, 8 instruction(s), ends with forward jump to 0x00412971
    movsx ecx, word ptr [ebp - local_c]          # 0041292a
    imul ecx, ecx, 0x320                         # 0041292e
    movsx edx, word ptr [ebp - local_c]          # 00412934
    movsx eax, word ptr [2*edx + 0x59fbdb]       # 00412938
    mov edx, dword ptr [ebp - local_8]           # 00412940
    mov dx, word ptr [edx + field_25]            # 00412943
    mov word ptr [ecx + 2*eax + 0x59fbe1], dx    # 00412947
    jmp.d8 L_00412971                            # 0041294f
L_00412951:
    # block 0x00412951: entered by jne at 0x00412928, 5 instruction(s), falls into the block at 0x00412971
    movsx eax, word ptr [ebp - local_c]          # 00412951
    imul eax, eax, 0x320                         # 00412955
    movsx ecx, word ptr [ebp - local_c]          # 0041295b
    movsx edx, word ptr [2*ecx + 0x59fbdb]       # 0041295f
    mov word ptr [eax + 2*edx + 0x59fbe1], 0x270f # 00412967
L_00412971:
    # block 0x00412971: entered by jmp at 0x004128a1; jmp at 0x0041294f, 9 instruction(s), ends with jne to 0x004129aa (forward)
    movsx eax, word ptr [ebp - local_c]          # 00412971
    mov cx, word ptr [2*eax + 0x59fbdb]          # 00412975
    add cx, 0x1                                  # 0041297d
    movsx edx, word ptr [ebp - local_c]          # 00412981
    mov word ptr [2*edx + 0x59fbdb], cx          # 00412985
    mov eax, dword ptr [ebp - local_8]           # 0041298d
    movsx ecx, word ptr [eax]                    # 00412990
    cmp ecx, 0x4                                 # 00412993
    jne.d8 L_004129aa                            # 00412996
    # block 0x00412998: entered by fall-through of jne at 0x00412996, 6 instruction(s), calls FUN_004e0559, ends with forward jump to 0x004129c5
    push 0x0                                     # 00412998
    push 0x1                                     # 0041299a
    push 0x2                                     # 0041299c
    mov ecx, 0x570508                            # 0041299e
    call FUN_004e0559                            # 004129a3
    jmp.d8 L_004129c5                            # 004129a8
L_004129aa:
    # block 0x004129aa: entered by jne at 0x00412996, 4 instruction(s), ends with jne to 0x004129c5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004129aa
    movsx eax, word ptr [edx]                    # 004129ad
    cmp eax, 0x3                                 # 004129b0
    jne.d8 L_004129c5                            # 004129b3
    # block 0x004129b5: entered by fall-through of jne at 0x004129b3, 5 instruction(s), calls FUN_004e0559, falls into the block at 0x004129c5
    push 0x1                                     # 004129b5
    push 0x1                                     # 004129b7
    push 0x2                                     # 004129b9
    mov ecx, 0x570508                            # 004129bb
    call FUN_004e0559                            # 004129c0
L_004129c5:
    # block 0x004129c5: entered by jmp at 0x004129a8; jne at 0x004129b3, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004129d2
    mov cx, word ptr [ebp + arg_8]               # 004129c5
    push ecx                                     # 004129c9
    call FUN_0042ba3a                            # 004129ca
    add esp, 0x4                                 # 004129cf
L_004129d2:
    # block 0x004129d2: entered by jmp at 0x00412875, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004129d2
    pop esi                                      # 004129d3
    {load} mov esp, ebp                          # 004129d4
    pop ebp                                      # 004129d6
    ret 0x4                                      # 004129d7

