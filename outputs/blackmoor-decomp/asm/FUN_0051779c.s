# FUN_0051779c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051779c
# extent:       0x0051779c-0x00517a6b (719 code bytes)
# span:         0x0051779c-0x00517a70 (code 719, tables 0, padding 5)
# sha256:       87309214dca55f1d84ab22f0de0e2b1715aba98d854553aed4cdd1b9a607b240
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051779c
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_b, arg_c, arg_10, arg_13, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       8 ebp-relative slot(s): local_1, local_8, local_a, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4
# callees:      calls FUN_0050ea7e, FUN_0050ea87, FUN_005174bb, KERNEL32.dll!CreateFileA, KERNEL32.dll!GetLastError, FUN_0050ea0b, KERNEL32.dll!GetFileType, KERNEL32.dll!CloseHandle, FUN_005175de, FUN_005121dd, FUN_00512250, FUN_0051249c, FUN_005192a5, FUN_0051777a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 241 instruction(s), 42 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00517a70
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_b, 0xb  # offset +0xb
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_13, 0x13  # offset +0x13
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_005121dd, .text + (0x005121dd - 0x401000)
.set FUN_00512250, .text + (0x00512250 - 0x401000)
.set FUN_0051249c, .text + (0x0051249c - 0x401000)
.set FUN_005174bb, .text + (0x005174bb - 0x401000)
.set FUN_005175de, .text + (0x005175de - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)
.set FUN_005192a5, .text + (0x005192a5 - 0x401000)

.org 0x0051779c - 0x401000
.globl FUN_0051779c
FUN_0051779c:
    # block 0x0051779c: entry, 12 instruction(s), ends with je to 0x005177c2 (forward)
    push ebp                                     # 0051779c
    {load} mov ebp, esp                          # 0051779d
    sub esp, 0x1c                                # 0051779f
    mov ecx, dword ptr [ebp + arg_c]             # 005177a2
    push ebx                                     # 005177a5
    {load} xor ebx, ebx                          # 005177a6
    push esi                                     # 005177a8
    test cl, -0x80                               # 005177a9
    push edi                                     # 005177ac
    mov dword ptr [ebp - local_1c], 0xc          # 005177ad
    mov dword ptr [ebp - local_18], ebx          # 005177b4
    je.d8 L_005177c2                             # 005177b7
    # block 0x005177b9: entered by fall-through of je at 0x005177b7, 3 instruction(s), ends with forward jump to 0x005177cd
    mov dword ptr [ebp - local_14], ebx          # 005177b9
    mov byte ptr [ebp - local_1], 0x10           # 005177bc
    jmp.d8 L_005177cd                            # 005177c0
L_005177c2:
    # block 0x005177c2: entered by je at 0x005177b7, 2 instruction(s), falls into the block at 0x005177cd
    and byte ptr [ebp - local_1], 0x0            # 005177c2
    mov dword ptr [ebp - local_14], 0x1          # 005177c6
L_005177cd:
    # block 0x005177cd: entered by jmp at 0x005177c0, 3 instruction(s), ends with jne to 0x005177e7 (forward)
    mov eax, 0x8000                              # 005177cd
    test eax, ecx                                # 005177d2
    jne.d8 L_005177e7                            # 005177d4
    # block 0x005177d6: entered by fall-through of jne at 0x005177d4, 2 instruction(s), ends with jne to 0x005177e3 (forward)
    test ch, 0x40                                # 005177d6
    jne.d8 L_005177e3                            # 005177d9
    # block 0x005177db: entered by fall-through of jne at 0x005177d9, 2 instruction(s), ends with je to 0x005177e7 (forward)
    cmp dword ptr [0x63cd9c], eax                # 005177db
    je.d8 L_005177e7                             # 005177e1
L_005177e3:
    # block 0x005177e3: entered by jne at 0x005177d9; fall-through of je at 0x005177e1, 1 instruction(s), falls into the block at 0x005177e7
    or byte ptr [ebp - local_1], -0x80           # 005177e3
L_005177e7:
    # block 0x005177e7: entered by jne at 0x005177d4; je at 0x005177e1, 6 instruction(s), ends with je to 0x0051780e (forward)
    push 0x3                                     # 005177e7
    {load} mov eax, ecx                          # 005177e9
    pop esi                                      # 005177eb
    {load} and eax, esi                          # 005177ec
    {load} sub eax, ebx                          # 005177ee
    je.d8 L_0051780e                             # 005177f0
    # block 0x005177f2: entered by fall-through of je at 0x005177f0, 2 instruction(s), ends with je to 0x00517805 (forward)
    dec eax                                      # 005177f2
    je.d8 L_00517805                             # 005177f3
    # block 0x005177f5: entered by fall-through of je at 0x005177f3, 2 instruction(s), ends with jne to 0x005178a0 (forward)
    dec eax                                      # 005177f5
    jne.d32 L_005178a0                           # 005177f6
    # block 0x005177fc: entered by fall-through of jne at 0x005177f6, 2 instruction(s), ends with forward jump to 0x00517815
    mov dword ptr [ebp - local_c], 0xc0000000    # 005177fc
    jmp.d8 L_00517815                            # 00517803
L_00517805:
    # block 0x00517805: entered by je at 0x005177f3, 2 instruction(s), ends with forward jump to 0x00517815
    mov dword ptr [ebp - local_c], 0x40000000    # 00517805
    jmp.d8 L_00517815                            # 0051780c
L_0051780e:
    # block 0x0051780e: entered by je at 0x005177f0, 1 instruction(s), falls into the block at 0x00517815
    mov dword ptr [ebp - local_c], 0x80000000    # 0051780e
L_00517815:
    # block 0x00517815: entered by jmp at 0x00517803; jmp at 0x0051780c, 3 instruction(s), ends with je to 0x00517843 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00517815
    cmp eax, 0x10                                # 00517818
    je.d8 L_00517843                             # 0051781b
    # block 0x0051781d: entered by fall-through of je at 0x0051781b, 2 instruction(s), ends with je to 0x0051783a (forward)
    cmp eax, 0x20                                # 0051781d
    je.d8 L_0051783a                             # 00517820
    # block 0x00517822: entered by fall-through of je at 0x00517820, 2 instruction(s), ends with je to 0x00517831 (forward)
    cmp eax, 0x30                                # 00517822
    je.d8 L_00517831                             # 00517825
    # block 0x00517827: entered by fall-through of je at 0x00517825, 2 instruction(s), ends with jne to 0x005178a0 (forward)
    cmp eax, 0x40                                # 00517827
    jne.d8 L_005178a0                            # 0051782a
    # block 0x0051782c: entered by fall-through of jne at 0x0051782a, 2 instruction(s), ends with forward jump to 0x00517846
    mov dword ptr [ebp - local_10], esi          # 0051782c
    jmp.d8 L_00517846                            # 0051782f
L_00517831:
    # block 0x00517831: entered by je at 0x00517825, 2 instruction(s), ends with forward jump to 0x00517846
    mov dword ptr [ebp - local_10], 0x2          # 00517831
    jmp.d8 L_00517846                            # 00517838
L_0051783a:
    # block 0x0051783a: entered by je at 0x00517820, 2 instruction(s), ends with forward jump to 0x00517846
    mov dword ptr [ebp - local_10], 0x1          # 0051783a
    jmp.d8 L_00517846                            # 00517841
L_00517843:
    # block 0x00517843: entered by je at 0x0051781b, 1 instruction(s), falls into the block at 0x00517846
    mov dword ptr [ebp - local_10], ebx          # 00517843
L_00517846:
    # block 0x00517846: entered by jmp at 0x0051782f; jmp at 0x00517838; jmp at 0x00517841, 6 instruction(s), ends with jg to 0x0051788c (forward)
    mov edx, 0x700                               # 00517846
    mov eax, 0x400                               # 0051784b
    {load} and ecx, edx                          # 00517850
    mov edi, 0x100                               # 00517852
    {load} cmp ecx, eax                          # 00517857
    jg.d8 L_0051788c                             # 00517859
    # block 0x0051785b: entered by fall-through of jg at 0x00517859, 1 instruction(s), ends with je to 0x00517887 (forward)
    je.d8 L_00517887                             # 0051785b
    # block 0x0051785d: entered by fall-through of je at 0x0051785b, 2 instruction(s), ends with je to 0x00517887 (forward)
    {load} cmp ecx, ebx                          # 0051785d
    je.d8 L_00517887                             # 0051785f
    # block 0x00517861: entered by fall-through of je at 0x0051785f, 2 instruction(s), ends with je to 0x0051787e (forward)
    {load} cmp ecx, edi                          # 00517861
    je.d8 L_0051787e                             # 00517863
    # block 0x00517865: entered by fall-through of je at 0x00517863, 2 instruction(s), ends with je to 0x005178ba (forward)
    cmp ecx, 0x200                               # 00517865
    je.d8 L_005178ba                             # 0051786b
    # block 0x0051786d: entered by fall-through of je at 0x0051786b, 2 instruction(s), ends with jne to 0x005178a0 (forward)
    cmp ecx, 0x300                               # 0051786d
    jne.d8 L_005178a0                            # 00517873
    # block 0x00517875: entered by fall-through of jne at 0x00517873, 2 instruction(s), ends with forward jump to 0x005178ca
    mov dword ptr [ebp - local_8], 0x2           # 00517875
    jmp.d8 L_005178ca                            # 0051787c
L_0051787e:
    # block 0x0051787e: entered by je at 0x00517863, 2 instruction(s), ends with forward jump to 0x005178ca
    mov dword ptr [ebp - local_8], 0x4           # 0051787e
    jmp.d8 L_005178ca                            # 00517885
L_00517887:
    # block 0x00517887: entered by je at 0x0051785b; je at 0x0051785f, 2 instruction(s), ends with forward jump to 0x005178ca
    mov dword ptr [ebp - local_8], esi           # 00517887
    jmp.d8 L_005178ca                            # 0051788a
L_0051788c:
    # block 0x0051788c: entered by jg at 0x00517859, 2 instruction(s), ends with je to 0x005178c3 (forward)
    cmp ecx, 0x500                               # 0051788c
    je.d8 L_005178c3                             # 00517892
    # block 0x00517894: entered by fall-through of je at 0x00517892, 2 instruction(s), ends with je to 0x005178ba (forward)
    cmp ecx, 0x600                               # 00517894
    je.d8 L_005178ba                             # 0051789a
    # block 0x0051789c: entered by fall-through of je at 0x0051789a, 2 instruction(s), ends with je to 0x005178c3 (forward)
    {load} cmp ecx, edx                          # 0051789c
    je.d8 L_005178c3                             # 0051789e
L_005178a0:
    # block 0x005178a0: entered by jne at 0x005177f6; jne at 0x0051782a; jne at 0x00517873; fall-through of je at 0x0051789e, 6 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with forward jump to 0x00517a66
    call FUN_0050ea7e                            # 005178a0
    mov dword ptr [eax], 0x16                    # 005178a5
    call FUN_0050ea87                            # 005178ab
    mov dword ptr [eax], ebx                     # 005178b0
    or eax, -0x1                                 # 005178b2
    jmp.d32 L_00517a66                           # 005178b5
L_005178ba:
    # block 0x005178ba: entered by je at 0x0051786b; je at 0x0051789a, 2 instruction(s), ends with forward jump to 0x005178ca
    mov dword ptr [ebp - local_8], 0x5           # 005178ba
    jmp.d8 L_005178ca                            # 005178c1
L_005178c3:
    # block 0x005178c3: entered by je at 0x00517892; je at 0x0051789e, 1 instruction(s), falls into the block at 0x005178ca
    mov dword ptr [ebp - local_8], 0x1           # 005178c3
L_005178ca:
    # block 0x005178ca: entered by jmp at 0x0051787c; jmp at 0x00517885; jmp at 0x0051788a; jmp at 0x005178c1, 4 instruction(s), ends with je to 0x005178e9 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 005178ca
    mov esi, 0x80                                # 005178cd
    test edi, eax                                # 005178d2
    je.d8 L_005178e9                             # 005178d4
    # block 0x005178d6: entered by fall-through of je at 0x005178d4, 5 instruction(s), ends with jne to 0x005178e9 (forward)
    mov ecx, dword ptr [0x63ca0c]                # 005178d6
    not ecx                                      # 005178dc
    and ecx, dword ptr [ebp + arg_14]            # 005178de
    test cl, -0x80                               # 005178e1
    jne.d8 L_005178e9                            # 005178e4
    # block 0x005178e6: entered by fall-through of jne at 0x005178e4, 2 instruction(s), falls into the block at 0x005178e9
    push 0x1                                     # 005178e6
    pop esi                                      # 005178e8
L_005178e9:
    # block 0x005178e9: entered by je at 0x005178d4; jne at 0x005178e4, 2 instruction(s), ends with je to 0x005178f7 (forward)
    test al, 0x40                                # 005178e9
    je.d8 L_005178f7                             # 005178eb
    # block 0x005178ed: entered by fall-through of je at 0x005178eb, 2 instruction(s), falls into the block at 0x005178f7
    or esi, 0x4000000                            # 005178ed
    or byte ptr [ebp - local_a], 0x1             # 005178f3
L_005178f7:
    # block 0x005178f7: entered by je at 0x005178eb, 2 instruction(s), ends with je to 0x005178fe (forward)
    test ah, 0x10                                # 005178f7
    je.d8 L_005178fe                             # 005178fa
    # block 0x005178fc: entered by fall-through of je at 0x005178fa, 1 instruction(s), falls into the block at 0x005178fe
    {load} or esi, edi                           # 005178fc
L_005178fe:
    # block 0x005178fe: entered by je at 0x005178fa, 2 instruction(s), ends with je to 0x0051790a (forward)
    test al, 0x20                                # 005178fe
    je.d8 L_0051790a                             # 00517900
    # block 0x00517902: entered by fall-through of je at 0x00517900, 2 instruction(s), ends with forward jump to 0x00517914
    or esi, 0x8000000                            # 00517902
    jmp.d8 L_00517914                            # 00517908
L_0051790a:
    # block 0x0051790a: entered by je at 0x00517900, 2 instruction(s), ends with je to 0x00517914 (forward)
    test al, 0x10                                # 0051790a
    je.d8 L_00517914                             # 0051790c
    # block 0x0051790e: entered by fall-through of je at 0x0051790c, 1 instruction(s), falls into the block at 0x00517914
    or esi, 0x10000000                           # 0051790e
L_00517914:
    # block 0x00517914: entered by jmp at 0x00517908; je at 0x0051790c, 5 instruction(s), calls FUN_005174bb, ends with jne to 0x0051793c (forward)
    call FUN_005174bb                            # 00517914
    {load} mov ebx, eax                          # 00517919
    or edi, -0x1                                 # 0051791b
    {load} cmp ebx, edi                          # 0051791e
    jne.d8 L_0051793c                            # 00517920
    # block 0x00517922: entered by fall-through of jne at 0x00517920, 6 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with forward jump to 0x00517a66
    call FUN_0050ea7e                            # 00517922
    mov dword ptr [eax], 0x18                    # 00517927
    call FUN_0050ea87                            # 0051792d
    and dword ptr [eax], 0x0                     # 00517932
    {load} mov eax, edi                          # 00517935
    jmp.d32 L_00517a66                           # 00517937
L_0051793c:
    # block 0x0051793c: entered by jne at 0x00517920, 12 instruction(s), calls KERNEL32.dll!CreateFileA, ends with jne to 0x0051796f (forward)
    push 0x0                                     # 0051793c
    push esi                                     # 0051793e
    push dword ptr [ebp - local_8]               # 0051793f
    lea eax, [ebp - local_1c]                    # 00517942
    push eax                                     # 00517945
    push dword ptr [ebp - local_10]              # 00517946
    push dword ptr [ebp - local_c]               # 00517949
    push dword ptr [ebp + arg_8]                 # 0051794c
    call dword ptr [0x52a2bc]                    # 0051794f
    {load} mov esi, eax                          # 00517955
    {load} cmp esi, edi                          # 00517957
    jne.d8 L_0051796f                            # 00517959
L_0051795b:
    # block 0x0051795b: entered by jmp at 0x00517981; fall-through of jne at 0x00517959, 6 instruction(s), calls KERNEL32.dll!GetLastError, FUN_0050ea0b, ends with forward jump to 0x00517a5d
    call dword ptr [0x52a2a4]                    # 0051795b
    push eax                                     # 00517961
    call FUN_0050ea0b                            # 00517962
    pop ecx                                      # 00517967
    {load} mov esi, edi                          # 00517968
    jmp.d32 L_00517a5d                           # 0051796a
L_0051796f:
    # block 0x0051796f: entered by jne at 0x00517959, 4 instruction(s), calls KERNEL32.dll!GetFileType, ends with jne to 0x00517983 (forward)
    push esi                                     # 0051796f
    call dword ptr [0x52a17c]                    # 00517970
    test eax, eax                                # 00517976
    jne.d8 L_00517983                            # 00517978
    # block 0x0051797a: entered by fall-through of jne at 0x00517978, 3 instruction(s), calls KERNEL32.dll!CloseHandle, ends with backward jump to 0x0051795b
    push esi                                     # 0051797a
    call dword ptr [0x52a2b8]                    # 0051797b
    jmp.d8 L_0051795b                            # 00517981
L_00517983:
    # block 0x00517983: entered by jne at 0x00517978, 2 instruction(s), ends with jne to 0x0051798e (forward)
    cmp eax, 0x2                                 # 00517983
    jne.d8 L_0051798e                            # 00517986
    # block 0x00517988: entered by fall-through of jne at 0x00517986, 2 instruction(s), ends with forward jump to 0x00517997
    or byte ptr [ebp - local_1], 0x40            # 00517988
    jmp.d8 L_00517997                            # 0051798c
L_0051798e:
    # block 0x0051798e: entered by jne at 0x00517986, 2 instruction(s), ends with jne to 0x00517997 (forward)
    cmp eax, 0x3                                 # 0051798e
    jne.d8 L_00517997                            # 00517991
    # block 0x00517993: entered by fall-through of jne at 0x00517991, 1 instruction(s), falls into the block at 0x00517997
    or byte ptr [ebp - local_1], 0x8             # 00517993
L_00517997:
    # block 0x00517997: entered by jmp at 0x0051798c; jne at 0x00517991, 19 instruction(s), calls FUN_005175de, ends with jne to 0x00517a44 (forward)
    push esi                                     # 00517997
    push ebx                                     # 00517998
    call FUN_005175de                            # 00517999
    {load} mov eax, ebx                          # 0051799e
    pop ecx                                      # 005179a0
    sar eax, 0x5                                 # 005179a1
    pop ecx                                      # 005179a4
    mov cl, byte ptr [ebp - local_1]             # 005179a5
    lea edi, [4*eax + 0x63cde0]                  # 005179a8
    {load} mov eax, ebx                          # 005179af
    or cl, 0x1                                   # 005179b1
    and eax, 0x1f                                # 005179b4
    mov byte ptr [ebp + arg_b], cl               # 005179b7
    lea esi, [eax + 8*eax]                       # 005179ba
    mov eax, dword ptr [edi]                     # 005179bd
    shl esi, 0x2                                 # 005179bf
    and byte ptr [ebp + arg_b], 0x48             # 005179c2
    mov byte ptr [eax + esi + field_4], cl       # 005179c6
    jne.d8 L_00517a44                            # 005179ca
    # block 0x005179cc: entered by fall-through of jne at 0x005179ca, 2 instruction(s), ends with je to 0x00517a44 (forward)
    test cl, -0x80                               # 005179cc
    je.d8 L_00517a44                             # 005179cf
    # block 0x005179d1: entered by fall-through of je at 0x005179cf, 2 instruction(s), ends with je to 0x00517a44 (forward)
    test byte ptr [ebp + arg_c], 0x2             # 005179d1
    je.d8 L_00517a44                             # 005179d5
    # block 0x005179d7: entered by fall-through of je at 0x005179d5, 8 instruction(s), calls FUN_005121dd, ends with jne to 0x00517a05 (forward)
    push 0x2                                     # 005179d7
    push -0x1                                    # 005179d9
    push ebx                                     # 005179db
    call FUN_005121dd                            # 005179dc
    add esp, 0xc                                 # 005179e1
    cmp eax, -0x1                                # 005179e4
    mov dword ptr [ebp - local_10], eax          # 005179e7
    jne.d8 L_00517a05                            # 005179ea
    # block 0x005179ec: entered by fall-through of jne at 0x005179ea, 3 instruction(s), calls FUN_0050ea87, ends with je to 0x00517a44 (forward)
    call FUN_0050ea87                            # 005179ec
    cmp dword ptr [eax], 0x83                    # 005179f1
    je.d8 L_00517a44                             # 005179f7
L_005179f9:
    # block 0x005179f9: entered by je at 0x00517a30; je at 0x00517a42; fall-through of je at 0x005179f7, 5 instruction(s), calls FUN_00512250, ends with forward jump to 0x00517a5d
    push ebx                                     # 005179f9
    call FUN_00512250                            # 005179fa
    pop ecx                                      # 005179ff
    or esi, -0x1                                 # 00517a00
    jmp.d8 L_00517a5d                            # 00517a03
L_00517a05:
    # block 0x00517a05: entered by jne at 0x005179ea, 9 instruction(s), calls FUN_0051249c, ends with jne to 0x00517a32 (forward)
    and byte ptr [ebp + arg_13], 0x0             # 00517a05
    lea eax, [ebp + arg_13]                      # 00517a09
    push 0x1                                     # 00517a0c
    push eax                                     # 00517a0e
    push ebx                                     # 00517a0f
    call FUN_0051249c                            # 00517a10
    add esp, 0xc                                 # 00517a15
    test eax, eax                                # 00517a18
    jne.d8 L_00517a32                            # 00517a1a
    # block 0x00517a1c: entered by fall-through of jne at 0x00517a1a, 2 instruction(s), ends with jne to 0x00517a32 (forward)
    cmp byte ptr [ebp + arg_13], 0x1a            # 00517a1c
    jne.d8 L_00517a32                            # 00517a20
    # block 0x00517a22: entered by fall-through of jne at 0x00517a20, 7 instruction(s), calls FUN_005192a5, ends with je to 0x005179f9 (backward)
    push dword ptr [ebp - local_10]              # 00517a22
    push ebx                                     # 00517a25
    call FUN_005192a5                            # 00517a26
    pop ecx                                      # 00517a2b
    cmp eax, -0x1                                # 00517a2c
    pop ecx                                      # 00517a2f
    je.d8 L_005179f9                             # 00517a30
L_00517a32:
    # block 0x00517a32: entered by jne at 0x00517a1a; jne at 0x00517a20; fall-through of je at 0x00517a30, 7 instruction(s), calls FUN_005121dd, ends with je to 0x005179f9 (backward)
    push 0x0                                     # 00517a32
    push 0x0                                     # 00517a34
    push ebx                                     # 00517a36
    call FUN_005121dd                            # 00517a37
    add esp, 0xc                                 # 00517a3c
    cmp eax, -0x1                                # 00517a3f
    je.d8 L_005179f9                             # 00517a42
L_00517a44:
    # block 0x00517a44: entered by jne at 0x005179ca; je at 0x005179cf; je at 0x005179d5; je at 0x005179f7; more, 2 instruction(s), ends with jne to 0x00517a5b (forward)
    cmp byte ptr [ebp + arg_b], 0x0              # 00517a44
    jne.d8 L_00517a5b                            # 00517a48
    # block 0x00517a4a: entered by fall-through of jne at 0x00517a48, 2 instruction(s), ends with je to 0x00517a5b (forward)
    test byte ptr [ebp + arg_c], 0x8             # 00517a4a
    je.d8 L_00517a5b                             # 00517a4e
    # block 0x00517a50: entered by fall-through of je at 0x00517a4e, 3 instruction(s), falls into the block at 0x00517a5b
    mov eax, dword ptr [edi]                     # 00517a50
    or byte ptr [eax + esi + field_4], 0x20      # 00517a52
    lea eax, [eax + esi + field_4]               # 00517a57
L_00517a5b:
    # block 0x00517a5b: entered by jne at 0x00517a48; je at 0x00517a4e, 1 instruction(s), falls into the block at 0x00517a5d
    {load} mov esi, ebx                          # 00517a5b
L_00517a5d:
    # block 0x00517a5d: entered by jmp at 0x0051796a; jmp at 0x00517a03, 4 instruction(s), calls FUN_0051777a, falls into the block at 0x00517a66
    push ebx                                     # 00517a5d
    call FUN_0051777a                            # 00517a5e
    pop ecx                                      # 00517a63
    {load} mov eax, esi                          # 00517a64
L_00517a66:
    # block 0x00517a66: entered by jmp at 0x005178b5; jmp at 0x00517937, 5 instruction(s), ends with ret
    pop edi                                      # 00517a66
    pop esi                                      # 00517a67
    pop ebx                                      # 00517a68
    leave                                        # 00517a69
    ret                                          # 00517a6a

# --- data items (not part of the function) -------------------------
.org 0x00517a6b - 0x401000
PAD_00517a6b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

