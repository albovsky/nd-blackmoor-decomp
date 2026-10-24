# FUN_00478684
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478684
# extent:       0x00478684-0x00478915 (657 code bytes)
# span:         0x00478684-0x00478915 (code 657, tables 0, padding 0)
# sha256:       8d293171e23493b208658a7a02b196a236efe468b6fa9d7bb2132c31884a1a91
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478684
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_158e, field_1590, field_159a; [ecx + n] field_158e, field_1590, field_159e; [edx + n] field_158e, field_1590
# callees:      calls FUN_00478396, FUN_00478656
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m478684_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 201 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590
.equ field_159a, 0x159a  # offset +0x159a
.equ field_159e, 0x159e  # offset +0x159e

# --- external targets -----------------------------------------------
.set FUN_00478396, .text + (0x00478396 - 0x401000)
.set FUN_00478656, .text + (0x00478656 - 0x401000)

.org 0x00478684 - 0x401000
.globl FUN_00478684
FUN_00478684:
    # block 0x00478684: entry, 18 instruction(s), ends with je to 0x004786f6 (forward)
    push ebp                                     # 00478684
    {load} mov ebp, esp                          # 00478685
    sub esp, 0x20                                # 00478687
    mov dword ptr [ebp - local_20], ecx          # 0047868a
    mov dword ptr [ebp - local_c], 0x0           # 0047868d
    mov eax, dword ptr [ebp - local_20]          # 00478694
    mov word ptr [eax + field_159a], 0x0         # 00478697
    movsx ecx, word ptr [ebp + arg_8]            # 004786a0
    mov edx, dword ptr [ebp - local_20]          # 004786a4
    mov ax, word ptr [edx + 4*ecx + field_158e]  # 004786a7
    mov word ptr [ebp - local_14], ax            # 004786af
    movsx ecx, word ptr [ebp + arg_8]            # 004786b3
    mov edx, dword ptr [ebp - local_20]          # 004786b7
    mov ax, word ptr [edx + 4*ecx + field_1590]  # 004786ba
    mov word ptr [ebp - local_1c], ax            # 004786c2
    movsx ecx, word ptr [ebp + arg_c]            # 004786c6
    test ecx, ecx                                # 004786ca
    je.d8 L_004786f6                             # 004786cc
    # block 0x004786ce: entered by fall-through of je at 0x004786cc, 9 instruction(s), ends with forward jump to 0x00478702
    movsx edx, word ptr [ebp + arg_c]            # 004786ce
    mov eax, dword ptr [ebp - local_20]          # 004786d2
    mov cx, word ptr [eax + 4*edx + field_158e]  # 004786d5
    mov word ptr [ebp - local_4], cx             # 004786dd
    movsx edx, word ptr [ebp + arg_c]            # 004786e1
    mov eax, dword ptr [ebp - local_20]          # 004786e5
    mov cx, word ptr [eax + 4*edx + field_1590]  # 004786e8
    mov word ptr [ebp - local_18], cx            # 004786f0
    jmp.d8 L_00478702                            # 004786f4
L_004786f6:
    # block 0x004786f6: entered by je at 0x004786cc, 2 instruction(s), falls into the block at 0x00478702
    mov word ptr [ebp - local_4], 0x8            # 004786f6
    mov word ptr [ebp - local_18], 0x8           # 004786fc
L_00478702:
    # block 0x00478702: entered by jmp at 0x004786f4, 25 instruction(s), calls FUN_00478396, ends with je to 0x004787a7 (forward)
    movsx eax, word ptr [ebp - local_14]         # 00478702
    mov edx, dword ptr [ebp - local_20]          # 00478706
    movsx ecx, word ptr [edx + field_158e]       # 00478709
    {load} sub eax, ecx                          # 00478710
    cdq                                          # 00478712
    {load} xor eax, edx                          # 00478713
    {load} sub eax, edx                          # 00478715
    mov word ptr [ebp - local_10], ax            # 00478717
    movsx eax, word ptr [ebp - local_1c]         # 0047871b
    mov edx, dword ptr [ebp - local_20]          # 0047871f
    movsx ecx, word ptr [edx + field_1590]       # 00478722
    {load} sub eax, ecx                          # 00478729
    cdq                                          # 0047872b
    {load} xor eax, edx                          # 0047872c
    {load} sub eax, edx                          # 0047872e
    mov word ptr [ebp - local_8], ax             # 00478730
    mov dx, word ptr [ebp - local_1c]            # 00478734
    push edx                                     # 00478738
    mov ax, word ptr [ebp - local_14]            # 00478739
    push eax                                     # 0047873d
    push 0x1                                     # 0047873e
    mov ecx, dword ptr [ebp - local_20]          # 00478740
    call FUN_00478396                            # 00478743
    test eax, eax                                # 00478748
    je.d8 L_004787a7                             # 0047874a
    # block 0x0047874c: entered by fall-through of je at 0x0047874a, 11 instruction(s), ends with jge to 0x004787a7 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0047874c
    sub eax, 0x1                                 # 00478750
    mov ecx, dword ptr [ebp - local_20]          # 00478753
    movsx edx, word ptr [ecx + field_1590]       # 00478756
    {load} sub eax, edx                          # 0047875d
    cdq                                          # 0047875f
    {load} xor eax, edx                          # 00478760
    {load} sub eax, edx                          # 00478762
    movsx ecx, word ptr [ebp - local_8]          # 00478764
    {load} cmp eax, ecx                          # 00478768
    jge.d8 L_004787a7                            # 0047876a
    # block 0x0047876c: entered by fall-through of jge at 0x0047876a, 13 instruction(s), calls FUN_00478656, ends with jne to 0x004787a7 (forward)
    mov dx, word ptr [ebp - local_18]            # 0047876c
    push edx                                     # 00478770
    mov ax, word ptr [ebp - local_4]             # 00478771
    push eax                                     # 00478775
    movsx ecx, word ptr [ebp - local_1c]         # 00478776
    sub ecx, 0x1                                 # 0047877a
    push ecx                                     # 0047877d
    mov dx, word ptr [ebp - local_14]            # 0047877e
    push edx                                     # 00478782
    mov ecx, dword ptr [ebp - local_20]          # 00478783
    call FUN_00478656                            # 00478786
    test eax, eax                                # 0047878b
    jne.d8 L_004787a7                            # 0047878d
    # block 0x0047878f: entered by fall-through of jne at 0x0047878d, 4 instruction(s), ends with forward jump to 0x004788f8
    mov dword ptr [ebp - local_c], 0x1           # 0047878f
    mov eax, dword ptr [ebp - local_20]          # 00478796
    mov word ptr [eax + field_159a], 0x1         # 00478799
    jmp.d32 L_004788f8                           # 004787a2
L_004787a7:
    # block 0x004787a7: entered by je at 0x0047874a; jge at 0x0047876a; jne at 0x0047878d, 9 instruction(s), calls FUN_00478396, ends with je to 0x0047881a (forward)
    mov cx, word ptr [ebp - local_1c]            # 004787a7
    push ecx                                     # 004787ab
    mov dx, word ptr [ebp - local_14]            # 004787ac
    push edx                                     # 004787b0
    push 0x3                                     # 004787b1
    mov ecx, dword ptr [ebp - local_20]          # 004787b3
    call FUN_00478396                            # 004787b6
    test eax, eax                                # 004787bb
    je.d8 L_0047881a                             # 004787bd
    # block 0x004787bf: entered by fall-through of je at 0x004787bd, 11 instruction(s), ends with jge to 0x0047881a (forward)
    movsx eax, word ptr [ebp - local_1c]         # 004787bf
    add eax, 0x1                                 # 004787c3
    mov ecx, dword ptr [ebp - local_20]          # 004787c6
    movsx edx, word ptr [ecx + field_1590]       # 004787c9
    {load} sub eax, edx                          # 004787d0
    cdq                                          # 004787d2
    {load} xor eax, edx                          # 004787d3
    {load} sub eax, edx                          # 004787d5
    movsx ecx, word ptr [ebp - local_8]          # 004787d7
    {load} cmp eax, ecx                          # 004787db
    jge.d8 L_0047881a                            # 004787dd
    # block 0x004787df: entered by fall-through of jge at 0x004787dd, 13 instruction(s), calls FUN_00478656, ends with jne to 0x0047881a (forward)
    mov dx, word ptr [ebp - local_18]            # 004787df
    push edx                                     # 004787e3
    mov ax, word ptr [ebp - local_4]             # 004787e4
    push eax                                     # 004787e8
    movsx ecx, word ptr [ebp - local_1c]         # 004787e9
    add ecx, 0x1                                 # 004787ed
    push ecx                                     # 004787f0
    mov dx, word ptr [ebp - local_14]            # 004787f1
    push edx                                     # 004787f5
    mov ecx, dword ptr [ebp - local_20]          # 004787f6
    call FUN_00478656                            # 004787f9
    test eax, eax                                # 004787fe
    jne.d8 L_0047881a                            # 00478800
    # block 0x00478802: entered by fall-through of jne at 0x00478800, 4 instruction(s), ends with forward jump to 0x004788f8
    mov dword ptr [ebp - local_c], 0x1           # 00478802
    mov eax, dword ptr [ebp - local_20]          # 00478809
    mov word ptr [eax + field_159a], 0x3         # 0047880c
    jmp.d32 L_004788f8                           # 00478815
L_0047881a:
    # block 0x0047881a: entered by je at 0x004787bd; jge at 0x004787dd; jne at 0x00478800, 9 instruction(s), calls FUN_00478396, ends with je to 0x0047888a (forward)
    mov cx, word ptr [ebp - local_1c]            # 0047881a
    push ecx                                     # 0047881e
    mov dx, word ptr [ebp - local_14]            # 0047881f
    push edx                                     # 00478823
    push 0x4                                     # 00478824
    mov ecx, dword ptr [ebp - local_20]          # 00478826
    call FUN_00478396                            # 00478829
    test eax, eax                                # 0047882e
    je.d8 L_0047888a                             # 00478830
    # block 0x00478832: entered by fall-through of je at 0x00478830, 11 instruction(s), ends with jge to 0x0047888a (forward)
    movsx eax, word ptr [ebp - local_14]         # 00478832
    sub eax, 0x1                                 # 00478836
    mov ecx, dword ptr [ebp - local_20]          # 00478839
    movsx edx, word ptr [ecx + field_158e]       # 0047883c
    {load} sub eax, edx                          # 00478843
    cdq                                          # 00478845
    {load} xor eax, edx                          # 00478846
    {load} sub eax, edx                          # 00478848
    movsx ecx, word ptr [ebp - local_10]         # 0047884a
    {load} cmp eax, ecx                          # 0047884e
    jge.d8 L_0047888a                            # 00478850
    # block 0x00478852: entered by fall-through of jge at 0x00478850, 13 instruction(s), calls FUN_00478656, ends with jne to 0x0047888a (forward)
    mov dx, word ptr [ebp - local_18]            # 00478852
    push edx                                     # 00478856
    mov ax, word ptr [ebp - local_4]             # 00478857
    push eax                                     # 0047885b
    mov cx, word ptr [ebp - local_1c]            # 0047885c
    push ecx                                     # 00478860
    movsx edx, word ptr [ebp - local_14]         # 00478861
    sub edx, 0x1                                 # 00478865
    push edx                                     # 00478868
    mov ecx, dword ptr [ebp - local_20]          # 00478869
    call FUN_00478656                            # 0047886c
    test eax, eax                                # 00478871
    jne.d8 L_0047888a                            # 00478873
    # block 0x00478875: entered by fall-through of jne at 0x00478873, 4 instruction(s), ends with forward jump to 0x004788f8
    mov dword ptr [ebp - local_c], 0x1           # 00478875
    mov eax, dword ptr [ebp - local_20]          # 0047887c
    mov word ptr [eax + field_159a], 0x4         # 0047887f
    jmp.d8 L_004788f8                            # 00478888
L_0047888a:
    # block 0x0047888a: entered by je at 0x00478830; jge at 0x00478850; jne at 0x00478873, 9 instruction(s), calls FUN_00478396, ends with je to 0x004788f8 (forward)
    mov cx, word ptr [ebp - local_1c]            # 0047888a
    push ecx                                     # 0047888e
    mov dx, word ptr [ebp - local_14]            # 0047888f
    push edx                                     # 00478893
    push 0x2                                     # 00478894
    mov ecx, dword ptr [ebp - local_20]          # 00478896
    call FUN_00478396                            # 00478899
    test eax, eax                                # 0047889e
    je.d8 L_004788f8                             # 004788a0
    # block 0x004788a2: entered by fall-through of je at 0x004788a0, 11 instruction(s), ends with jge to 0x004788f8 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004788a2
    add eax, 0x1                                 # 004788a6
    mov ecx, dword ptr [ebp - local_20]          # 004788a9
    movsx edx, word ptr [ecx + field_158e]       # 004788ac
    {load} sub eax, edx                          # 004788b3
    cdq                                          # 004788b5
    {load} xor eax, edx                          # 004788b6
    {load} sub eax, edx                          # 004788b8
    movsx ecx, word ptr [ebp - local_10]         # 004788ba
    {load} cmp eax, ecx                          # 004788be
    jge.d8 L_004788f8                            # 004788c0
    # block 0x004788c2: entered by fall-through of jge at 0x004788c0, 13 instruction(s), calls FUN_00478656, ends with jne to 0x004788f8 (forward)
    mov dx, word ptr [ebp - local_18]            # 004788c2
    push edx                                     # 004788c6
    mov ax, word ptr [ebp - local_4]             # 004788c7
    push eax                                     # 004788cb
    mov cx, word ptr [ebp - local_1c]            # 004788cc
    push ecx                                     # 004788d0
    movsx edx, word ptr [ebp - local_14]         # 004788d1
    add edx, 0x1                                 # 004788d5
    push edx                                     # 004788d8
    mov ecx, dword ptr [ebp - local_20]          # 004788d9
    call FUN_00478656                            # 004788dc
    test eax, eax                                # 004788e1
    jne.d8 L_004788f8                            # 004788e3
    # block 0x004788e5: entered by fall-through of jne at 0x004788e3, 3 instruction(s), falls into the block at 0x004788f8
    mov dword ptr [ebp - local_c], 0x1           # 004788e5
    mov eax, dword ptr [ebp - local_20]          # 004788ec
    mov word ptr [eax + field_159a], 0x2         # 004788ef
L_004788f8:
    # block 0x004788f8: entered by jmp at 0x004787a2; jmp at 0x00478815; jmp at 0x00478888; je at 0x004788a0; more, 2 instruction(s), ends with je to 0x0047890c (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004788f8
    je.d8 L_0047890c                             # 004788fc
    # block 0x004788fe: entered by fall-through of je at 0x004788fc, 3 instruction(s), falls into the block at 0x0047890c
    mov ecx, dword ptr [ebp - local_20]          # 004788fe
    mov dx, word ptr [ebp + arg_8]               # 00478901
    mov word ptr [ecx + field_159e], dx          # 00478905
L_0047890c:
    # block 0x0047890c: entered by je at 0x004788fc, 4 instruction(s), ends with ret 0x8
    mov eax, dword ptr [ebp - local_c]           # 0047890c
    {load} mov esp, ebp                          # 0047890f
    pop ebp                                      # 00478911
    ret 0x8                                      # 00478912

