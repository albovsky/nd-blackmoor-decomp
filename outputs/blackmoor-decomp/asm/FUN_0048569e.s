# FUN_0048569e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048569e
# extent:       0x0048569e-0x00485ca1 (1539 code bytes)
# span:         0x0048569e-0x00485ca1 (code 1539, tables 0, padding 0)
# sha256:       1a7f0c74498a1030be7456da172cb166b303699e5e9344ca604eb160e484a600
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48569e_handle_key
# naming:       native port src/original_methods_fl21b.c:m48569e_handle_key (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48569e_handle_key. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 1539 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_26, field_2a, field_3a, field_8f, field_ac, field_a92, field_a9e, field_b83, field_ba7 and 4 more; [ecx + n] field_4, field_8, field_c, field_23, field_26, field_2a, field_2d, field_32, field_36, field_3a, field_ac, field_a96 and 7 more; [edx + n] field_4, field_8, field_c, field_2a, field_2d, field_2e, field_32, field_36, field_4a, field_4b, field_8f, field_9f and 6 more; [esi + n] field_2a, field_2e, field_bf
# callees:      calls FUN_00484622, FUN_004853b0, FUN_00485f12, FUN_00485ca1, FUN_004846c2, FUN_00484f0d, FUN_00485d52, FUN_004841cb, FUN_00484935
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl21b.c:m48569e_handle_key (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 356 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_23, 0x23  # offset +0x23
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4b, 0x4b  # offset +0x4b
.equ field_8f, 0x8f  # offset +0x8f
.equ field_9f, 0x9f  # offset +0x9f
.equ field_ac, 0xac  # offset +0xac
.equ field_af, 0xaf  # offset +0xaf
.equ field_bf, 0xbf  # offset +0xbf
.equ field_a92, 0xa92  # offset +0xa92
.equ field_a96, 0xa96  # offset +0xa96
.equ field_a9a, 0xa9a  # offset +0xa9a
.equ field_a9e, 0xa9e  # offset +0xa9e
.equ field_b83, 0xb83  # offset +0xb83
.equ field_ba7, 0xba7  # offset +0xba7
.equ field_bab, 0xbab  # offset +0xbab
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bb0, 0xbb0  # offset +0xbb0
.equ field_bc5, 0xbc5  # offset +0xbc5
.equ field_bc7, 0xbc7  # offset +0xbc7
.equ field_c25, 0xc25  # offset +0xc25
.equ field_c2b, 0xc2b  # offset +0xc2b

# --- external targets -----------------------------------------------
.set FUN_004841cb, .text + (0x004841cb - 0x401000)
.set FUN_00484622, .text + (0x00484622 - 0x401000)
.set FUN_004846c2, .text + (0x004846c2 - 0x401000)
.set FUN_00484935, .text + (0x00484935 - 0x401000)
.set FUN_00484f0d, .text + (0x00484f0d - 0x401000)
.set FUN_004853b0, .text + (0x004853b0 - 0x401000)
.set FUN_00485ca1, .text + (0x00485ca1 - 0x401000)
.set FUN_00485d52, .text + (0x00485d52 - 0x401000)
.set FUN_00485f12, .text + (0x00485f12 - 0x401000)

.org 0x0048569e - 0x401000
.globl FUN_0048569e
FUN_0048569e:
    # block 0x0048569e: entry, 13 instruction(s), ends with je to 0x00485c9c (forward)
    push ebp                                     # 0048569e
    {load} mov ebp, esp                          # 0048569f
    sub esp, 0xc                                 # 004856a1
    push esi                                     # 004856a4
    mov dword ptr [ebp - local_c], ecx           # 004856a5
    mov eax, dword ptr [ebp - local_c]           # 004856a8
    movsx ecx, word ptr [eax + field_26]         # 004856ab
    imul ecx, ecx, 0x8d                          # 004856af
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004856b5
    mov dword ptr [ebp - local_8], edx           # 004856bb
    mov eax, dword ptr [ebp - local_c]           # 004856be
    cmp dword ptr [eax + field_ba7], 0x0         # 004856c1
    je.d32 L_00485c9c                            # 004856c8
    # block 0x004856ce: entered by fall-through of je at 0x004856c8, 5 instruction(s), ends with jne to 0x00485c9c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004856ce
    {load} xor edx, edx                          # 004856d1
    mov dl, byte ptr [ecx + field_bb0]           # 004856d3
    test edx, edx                                # 004856d9
    jne.d32 L_00485c9c                           # 004856db
    # block 0x004856e1: entered by fall-through of jne at 0x004856db, 3 instruction(s), ends with jne to 0x00485c9c (forward)
    mov eax, dword ptr [ebp - local_c]           # 004856e1
    cmp dword ptr [eax + field_bac], 0x0         # 004856e4
    jne.d32 L_00485c9c                           # 004856eb
    # block 0x004856f1: entered by fall-through of jne at 0x004856eb, 5 instruction(s), ends with jne to 0x00485c9c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004856f1
    movsx edx, word ptr [ecx + field_26]         # 004856f4
    imul edx, edx, 0x8d                          # 004856f8
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004856fe
    jne.d32 L_00485c9c                           # 00485705
    # block 0x0048570b: entered by fall-through of jne at 0x00485705, 2 instruction(s), ends with jne to 0x0048573d (forward)
    cmp dword ptr [0x5c39e5], 0x2779             # 0048570b
    jne.d8 L_0048573d                            # 00485715
    # block 0x00485717: entered by fall-through of jne at 0x00485715, 7 instruction(s), ends with forward jump to 0x00485c9c
    mov eax, dword ptr [ebp - local_c]           # 00485717
    mov byte ptr [eax + field_bab], 0x1          # 0048571a
    mov ecx, dword ptr [ebp - local_c]           # 00485721
    movsx edx, word ptr [ecx + field_26]         # 00485724
    imul edx, edx, 0x8d                          # 00485728
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048572e
    jmp.d32 L_00485c9c                           # 00485738
L_0048573d:
    # block 0x0048573d: entered by jne at 0x00485715, 2 instruction(s), ends with jne to 0x0048575b (forward)
    cmp dword ptr [0x5c39e5], 0x277c             # 0048573d
    jne.d8 L_0048575b                            # 00485747
    # block 0x00485749: entered by fall-through of jne at 0x00485747, 3 instruction(s), ends with forward jump to 0x00485c9c
    mov eax, dword ptr [ebp - local_c]           # 00485749
    mov dword ptr [eax + field_c2b], 0x1         # 0048574c
    jmp.d32 L_00485c9c                           # 00485756
L_0048575b:
    # block 0x0048575b: entered by jne at 0x00485747, 2 instruction(s), ends with jne to 0x0048582a (forward)
    cmp dword ptr [0x5c39e5], 0x2778             # 0048575b
    jne.d32 L_0048582a                           # 00485765
    # block 0x0048576b: entered by fall-through of jne at 0x00485765, 6 instruction(s), calls FUN_00484622, ends with jne to 0x00485785 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048576b
    call FUN_00484622                            # 0048576e
    mov word ptr [ebp - local_4], ax             # 00485773
    movsx ecx, word ptr [ebp - local_4]          # 00485777
    cmp ecx, -0x1                                # 0048577b
    jne.d8 L_00485785                            # 0048577e
    # block 0x00485780: entered by fall-through of jne at 0x0048577e, 1 instruction(s), ends with forward jump to 0x00485c9c
    jmp.d32 L_00485c9c                           # 00485780
L_00485785:
    # block 0x00485785: entered by jne at 0x0048577e, 36 instruction(s), calls FUN_004853b0, FUN_00485f12, ends with forward jump to 0x00485c9c
    mov dx, word ptr [ebp - local_4]             # 00485785
    push edx                                     # 00485789
    mov ecx, dword ptr [ebp - local_c]           # 0048578a
    call FUN_004853b0                            # 0048578d
    mov ecx, dword ptr [ebp - local_c]           # 00485792
    call FUN_00485f12                            # 00485795
    mov eax, dword ptr [ebp - local_c]           # 0048579a
    mov dword ptr [eax + field_a92], 0x1         # 0048579d
    mov ecx, dword ptr [ebp - local_c]           # 004857a7
    mov dx, word ptr [ebp - local_4]             # 004857aa
    mov word ptr [ecx + field_a9e], dx           # 004857ae
    mov eax, dword ptr [ebp - local_c]           # 004857b5
    movsx ecx, word ptr [eax + field_a9e]        # 004857b8
    imul ecx, ecx, 0x85                          # 004857bf
    mov edx, dword ptr [ebp - local_c]           # 004857c5
    movsx eax, word ptr [edx + field_a9e]        # 004857c8
    imul eax, eax, 0x85                          # 004857cf
    mov edx, dword ptr [ebp - local_c]           # 004857d5
    mov esi, dword ptr [ebp - local_c]           # 004857d8
    mov ecx, dword ptr [edx + ecx + field_32]    # 004857db
    sub ecx, dword ptr [esi + eax + field_2a]    # 004857df
    mov edx, dword ptr [ebp - local_c]           # 004857e3
    mov word ptr [edx + field_bc5], cx           # 004857e6
    mov eax, dword ptr [ebp - local_c]           # 004857ed
    movsx ecx, word ptr [eax + field_a9e]        # 004857f0
    imul ecx, ecx, 0x85                          # 004857f7
    mov edx, dword ptr [ebp - local_c]           # 004857fd
    movsx eax, word ptr [edx + field_a9e]        # 00485800
    imul eax, eax, 0x85                          # 00485807
    mov edx, dword ptr [ebp - local_c]           # 0048580d
    mov esi, dword ptr [ebp - local_c]           # 00485810
    mov ecx, dword ptr [edx + ecx + field_36]    # 00485813
    sub ecx, dword ptr [esi + eax + field_2e]    # 00485817
    mov edx, dword ptr [ebp - local_c]           # 0048581b
    mov word ptr [edx + field_bc7], cx           # 0048581e
    jmp.d32 L_00485c9c                           # 00485825
L_0048582a:
    # block 0x0048582a: entered by jne at 0x00485765, 3 instruction(s), ends with jne to 0x004859a6 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048582a
    cmp dword ptr [eax + field_a92], 0x0         # 0048582d
    jne.d32 L_004859a6                           # 00485834
    # block 0x0048583a: entered by fall-through of jne at 0x00485834, 2 instruction(s), ends with jne to 0x004859a6 (forward)
    cmp dword ptr [0x5c39e5], 0x2777             # 0048583a
    jne.d32 L_004859a6                           # 00485844
    # block 0x0048584a: entered by fall-through of jne at 0x00485844, 8 instruction(s), calls FUN_00485ca1, FUN_004846c2, ends with jne to 0x0048586c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048584a
    call FUN_00485ca1                            # 0048584d
    mov ecx, dword ptr [ebp - local_c]           # 00485852
    call FUN_004846c2                            # 00485855
    mov word ptr [ebp - local_4], ax             # 0048585a
    movsx ecx, word ptr [ebp - local_4]          # 0048585e
    cmp ecx, -0x1                                # 00485862
    jne.d8 L_0048586c                            # 00485865
    # block 0x00485867: entered by fall-through of jne at 0x00485865, 1 instruction(s), ends with forward jump to 0x00485c9c
    jmp.d32 L_00485c9c                           # 00485867
L_0048586c:
    # block 0x0048586c: entered by jne at 0x00485865, 30 instruction(s), calls FUN_00484f0d, ends with je to 0x00485924 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048586c
    mov ax, word ptr [ebp - local_4]             # 0048586f
    mov word ptr [edx + field_a9e], ax           # 00485873
    mov ecx, dword ptr [ebp - local_c]           # 0048587a
    mov dword ptr [ecx + field_a9a], 0x1         # 0048587d
    mov edx, dword ptr [ebp - local_c]           # 00485887
    movsx eax, word ptr [edx + field_a9e]        # 0048588a
    imul eax, eax, 0x85                          # 00485891
    mov ecx, dword ptr [ebp - local_c]           # 00485897
    lea edx, [ecx + eax + field_2a]              # 0048589a
    mov eax, dword ptr [ebp - local_c]           # 0048589e
    add eax, 0xae0                               # 004858a1
    mov ecx, dword ptr [edx]                     # 004858a6
    mov dword ptr [eax], ecx                     # 004858a8
    mov ecx, dword ptr [edx + field_4]           # 004858aa
    mov dword ptr [eax + field_4], ecx           # 004858ad
    mov ecx, dword ptr [edx + field_8]           # 004858b0
    mov dword ptr [eax + field_8], ecx           # 004858b3
    mov edx, dword ptr [edx + field_c]           # 004858b6
    mov dword ptr [eax + field_c], edx           # 004858b9
    mov eax, dword ptr [ebp - local_c]           # 004858bc
    movsx ecx, word ptr [eax + field_a9e]        # 004858bf
    imul ecx, ecx, 0x42                          # 004858c6
    mov edx, dword ptr [ebp - local_8]           # 004858c9
    lea eax, [edx + ecx + field_8f]              # 004858cc
    push eax                                     # 004858d3
    mov ecx, dword ptr [ebp - local_c]           # 004858d4
    call FUN_00484f0d                            # 004858d7
    test eax, eax                                # 004858dc
    je.d8 L_00485924                             # 004858de
    # block 0x004858e0: entered by fall-through of je at 0x004858de, 18 instruction(s), falls into the block at 0x00485924
    mov ecx, dword ptr [ebp - local_c]           # 004858e0
    movsx edx, word ptr [ecx + field_a9e]        # 004858e3
    imul edx, edx, 0x42                          # 004858ea
    mov eax, dword ptr [ebp - local_8]           # 004858ed
    lea ecx, [eax + edx + field_8f]              # 004858f0
    mov edx, dword ptr [ebp - local_c]           # 004858f7
    movsx eax, word ptr [edx + field_a9e]        # 004858fa
    imul eax, eax, 0x85                          # 00485901
    mov edx, dword ptr [ebp - local_c]           # 00485907
    lea eax, [edx + eax + field_2a]              # 0048590a
    mov edx, dword ptr [ecx]                     # 0048590e
    mov dword ptr [eax], edx                     # 00485910
    mov edx, dword ptr [ecx + field_4]           # 00485912
    mov dword ptr [eax + field_4], edx           # 00485915
    mov edx, dword ptr [ecx + field_8]           # 00485918
    mov dword ptr [eax + field_8], edx           # 0048591b
    mov ecx, dword ptr [ecx + field_c]           # 0048591e
    mov dword ptr [eax + field_c], ecx           # 00485921
L_00485924:
    # block 0x00485924: entered by je at 0x004858de, 27 instruction(s), ends with forward jump to 0x00485c9c
    mov edx, dword ptr [ebp - local_c]           # 00485924
    movsx eax, word ptr [edx + field_a9e]        # 00485927
    imul eax, eax, 0x85                          # 0048592e
    mov ecx, dword ptr [ebp - local_c]           # 00485934
    movsx edx, word ptr [ecx + field_a9e]        # 00485937
    imul edx, edx, 0x85                          # 0048593e
    mov ecx, dword ptr [ebp - local_c]           # 00485944
    mov esi, dword ptr [ebp - local_c]           # 00485947
    mov eax, dword ptr [ecx + eax + field_32]    # 0048594a
    sub eax, dword ptr [esi + edx + field_2a]    # 0048594e
    mov ecx, dword ptr [ebp - local_c]           # 00485952
    mov word ptr [ecx + field_bc5], ax           # 00485955
    mov edx, dword ptr [ebp - local_c]           # 0048595c
    movsx eax, word ptr [edx + field_a9e]        # 0048595f
    imul eax, eax, 0x85                          # 00485966
    mov ecx, dword ptr [ebp - local_c]           # 0048596c
    movsx edx, word ptr [ecx + field_a9e]        # 0048596f
    imul edx, edx, 0x85                          # 00485976
    mov ecx, dword ptr [ebp - local_c]           # 0048597c
    mov esi, dword ptr [ebp - local_c]           # 0048597f
    mov eax, dword ptr [ecx + eax + field_36]    # 00485982
    sub eax, dword ptr [esi + edx + field_2e]    # 00485986
    mov ecx, dword ptr [ebp - local_c]           # 0048598a
    mov word ptr [ecx + field_bc7], ax           # 0048598d
    mov edx, dword ptr [ebp - local_c]           # 00485994
    mov dword ptr [edx + field_a92], 0x1         # 00485997
    jmp.d32 L_00485c9c                           # 004859a1
L_004859a6:
    # block 0x004859a6: entered by jne at 0x00485834; jne at 0x00485844, 2 instruction(s), ends with je to 0x004859c2 (forward)
    cmp dword ptr [0x5c39e5], 0x277b             # 004859a6
    je.d8 L_004859c2                             # 004859b0
    # block 0x004859b2: entered by fall-through of je at 0x004859b0, 2 instruction(s), ends with jne to 0x00485c9c (forward)
    cmp dword ptr [0x5c39e5], 0x277a             # 004859b2
    jne.d32 L_00485c9c                           # 004859bc
L_004859c2:
    # block 0x004859c2: entered by je at 0x004859b0; fall-through of jne at 0x004859bc, 8 instruction(s), calls FUN_00485d52, ends with jne to 0x00485b10 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004859c2
    call FUN_00485d52                            # 004859c5
    mov eax, dword ptr [ebp - local_c]           # 004859ca
    mov dword ptr [eax + field_a92], 0x0         # 004859cd
    mov ecx, dword ptr [ebp - local_c]           # 004859d7
    mov dword ptr [ecx + field_a96], 0x1         # 004859da
    cmp dword ptr [0x5c39e5], 0x277b             # 004859e4
    jne.d32 L_00485b10                           # 004859ee
    # block 0x004859f4: entered by fall-through of jne at 0x004859ee, 5 instruction(s), ends with je to 0x00485a37 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004859f4
    {load} xor eax, eax                          # 004859f7
    mov al, byte ptr [edx + field_2d]            # 004859f9
    test eax, eax                                # 004859fc
    je.d8 L_00485a37                             # 004859fe
    # block 0x00485a00: entered by fall-through of je at 0x004859fe, 5 instruction(s), ends with je to 0x00485b10 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00485a00
    {load} xor edx, edx                          # 00485a03
    mov dl, byte ptr [ecx + field_2d]            # 00485a05
    test edx, edx                                # 00485a08
    je.d32 L_00485b10                            # 00485a0a
    # block 0x00485a10: entered by fall-through of je at 0x00485a0a, 9 instruction(s), ends with jne to 0x00485b10 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00485a10
    movsx ecx, word ptr [eax + field_c25]        # 00485a13
    mov edx, dword ptr [ebp - local_8]           # 00485a1a
    movsx eax, word ptr [edx + 2*ecx + field_2e] # 00485a1d
    mov ecx, dword ptr [ebp - local_c]           # 00485a22
    movsx edx, word ptr [ecx + field_a9e]        # 00485a25
    add edx, 0x1                                 # 00485a2c
    {load} cmp eax, edx                          # 00485a2f
    jne.d32 L_00485b10                           # 00485a31
L_00485a37:
    # block 0x00485a37: entered by je at 0x004859fe; fall-through of jne at 0x00485a31, 50 instruction(s), calls FUN_004841cb, ends with forward jump to 0x00485c7d
    mov eax, dword ptr [ebp - local_c]           # 00485a37
    movsx ecx, word ptr [eax + field_a9e]        # 00485a3a
    imul ecx, ecx, 0x42                          # 00485a41
    mov edx, dword ptr [ebp - local_8]           # 00485a44
    lea eax, [edx + ecx + field_9f]              # 00485a47
    mov ecx, dword ptr [ebp - local_c]           # 00485a4e
    movsx edx, word ptr [ecx + field_a9e]        # 00485a51
    imul edx, edx, 0x85                          # 00485a58
    mov ecx, dword ptr [ebp - local_c]           # 00485a5e
    lea edx, [ecx + edx + field_2a]              # 00485a61
    mov ecx, dword ptr [eax]                     # 00485a65
    mov dword ptr [edx], ecx                     # 00485a67
    mov ecx, dword ptr [eax + field_4]           # 00485a69
    mov dword ptr [edx + field_4], ecx           # 00485a6c
    mov ecx, dword ptr [eax + field_8]           # 00485a6f
    mov dword ptr [edx + field_8], ecx           # 00485a72
    mov eax, dword ptr [eax + field_c]           # 00485a75
    mov dword ptr [edx + field_c], eax           # 00485a78
    mov ecx, dword ptr [ebp - local_c]           # 00485a7b
    movsx edx, word ptr [ecx + field_a9e]        # 00485a7e
    imul edx, edx, 0x85                          # 00485a85
    mov eax, dword ptr [ebp - local_c]           # 00485a8b
    lea ecx, [eax + edx + field_3a]              # 00485a8e
    push ecx                                     # 00485a92
    mov edx, dword ptr [ebp - local_c]           # 00485a93
    movsx eax, word ptr [edx + field_a9e]        # 00485a96
    imul eax, eax, 0x85                          # 00485a9d
    mov ecx, dword ptr [ebp - local_c]           # 00485aa3
    lea edx, [ecx + eax + field_2a]              # 00485aa6
    push edx                                     # 00485aaa
    mov ecx, dword ptr [ebp - local_c]           # 00485aab
    call FUN_004841cb                            # 00485aae
    mov eax, dword ptr [ebp - local_c]           # 00485ab3
    movsx ecx, word ptr [eax + field_a9e]        # 00485ab6
    imul ecx, ecx, 0x85                          # 00485abd
    mov edx, dword ptr [ebp - local_c]           # 00485ac3
    mov byte ptr [edx + ecx + field_4b], 0x1     # 00485ac6
    mov eax, dword ptr [ebp - local_c]           # 00485acb
    movsx ecx, word ptr [eax + field_a9e]        # 00485ace
    imul ecx, ecx, 0x85                          # 00485ad5
    mov edx, dword ptr [ebp - local_c]           # 00485adb
    mov byte ptr [edx + ecx + field_ac], 0x1     # 00485ade
    mov eax, dword ptr [ebp - local_c]           # 00485ae6
    mov dword ptr [eax + field_b83], 0x1         # 00485ae9
    mov ecx, dword ptr [ebp - local_c]           # 00485af3
    mov dx, word ptr [ecx + field_c25]           # 00485af6
    add dx, 0x1                                  # 00485afd
    mov eax, dword ptr [ebp - local_c]           # 00485b01
    mov word ptr [eax + field_c25], dx           # 00485b04
    jmp.d32 L_00485c7d                           # 00485b0b
L_00485b10:
    # block 0x00485b10: entered by jne at 0x004859ee; je at 0x00485a0a; jne at 0x00485a31, 5 instruction(s), ends with je to 0x00485bea (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00485b10
    {load} xor edx, edx                          # 00485b13
    mov dl, byte ptr [ecx + field_23]            # 00485b15
    test edx, edx                                # 00485b18
    je.d32 L_00485bea                            # 00485b1a
    # block 0x00485b20: entered by fall-through of je at 0x00485b1a, 48 instruction(s), calls FUN_004841cb, ends with forward jump to 0x00485c70
    mov eax, dword ptr [ebp - local_c]           # 00485b20
    movsx ecx, word ptr [eax + field_a9e]        # 00485b23
    imul ecx, ecx, 0x42                          # 00485b2a
    mov edx, dword ptr [ebp - local_8]           # 00485b2d
    lea eax, [edx + ecx + field_af]              # 00485b30
    mov ecx, dword ptr [ebp - local_c]           # 00485b37
    movsx edx, word ptr [ecx + field_a9e]        # 00485b3a
    imul edx, edx, 0x85                          # 00485b41
    mov ecx, dword ptr [ebp - local_c]           # 00485b47
    lea edx, [ecx + edx + field_2a]              # 00485b4a
    mov ecx, dword ptr [eax]                     # 00485b4e
    mov dword ptr [edx], ecx                     # 00485b50
    mov ecx, dword ptr [eax + field_4]           # 00485b52
    mov dword ptr [edx + field_4], ecx           # 00485b55
    mov ecx, dword ptr [eax + field_8]           # 00485b58
    mov dword ptr [edx + field_8], ecx           # 00485b5b
    mov eax, dword ptr [eax + field_c]           # 00485b5e
    mov dword ptr [edx + field_c], eax           # 00485b61
    mov ecx, dword ptr [ebp - local_c]           # 00485b64
    movsx edx, word ptr [ecx + field_a9e]        # 00485b67
    imul edx, edx, 0x85                          # 00485b6e
    mov eax, dword ptr [ebp - local_c]           # 00485b74
    lea ecx, [eax + edx + field_3a]              # 00485b77
    push ecx                                     # 00485b7b
    mov edx, dword ptr [ebp - local_c]           # 00485b7c
    movsx eax, word ptr [edx + field_a9e]        # 00485b7f
    imul eax, eax, 0x85                          # 00485b86
    mov ecx, dword ptr [ebp - local_c]           # 00485b8c
    lea edx, [ecx + eax + field_2a]              # 00485b8f
    push edx                                     # 00485b93
    mov ecx, dword ptr [ebp - local_c]           # 00485b94
    call FUN_004841cb                            # 00485b97
    mov eax, dword ptr [ebp - local_c]           # 00485b9c
    movsx ecx, word ptr [eax + field_a9e]        # 00485b9f
    imul ecx, ecx, 0x42                          # 00485ba6
    mov edx, dword ptr [ebp - local_c]           # 00485ba9
    movsx eax, word ptr [edx + field_a9e]        # 00485bac
    imul eax, eax, 0x85                          # 00485bb3
    mov edx, dword ptr [ebp - local_c]           # 00485bb9
    mov esi, dword ptr [ebp - local_8]           # 00485bbc
    mov cl, byte ptr [esi + ecx + field_bf]      # 00485bbf
    mov byte ptr [edx + eax + field_4a], cl      # 00485bc6
    mov edx, dword ptr [ebp - local_c]           # 00485bca
    movsx eax, word ptr [edx + field_a9e]        # 00485bcd
    imul eax, eax, 0x85                          # 00485bd4
    mov ecx, dword ptr [ebp - local_c]           # 00485bda
    mov byte ptr [ecx + eax + field_ac], 0x0     # 00485bdd
    jmp.d32 L_00485c70                           # 00485be5
L_00485bea:
    # block 0x00485bea: entered by je at 0x00485b1a, 35 instruction(s), falls into the block at 0x00485c70
    mov edx, dword ptr [ebp - local_c]           # 00485bea
    add edx, 0xaa0                               # 00485bed
    mov eax, dword ptr [ebp - local_c]           # 00485bf3
    movsx ecx, word ptr [eax + field_a9e]        # 00485bf6
    imul ecx, ecx, 0x85                          # 00485bfd
    mov eax, dword ptr [ebp - local_c]           # 00485c03
    lea ecx, [eax + ecx + field_2a]              # 00485c06
    mov eax, dword ptr [edx]                     # 00485c0a
    mov dword ptr [ecx], eax                     # 00485c0c
    mov eax, dword ptr [edx + field_4]           # 00485c0e
    mov dword ptr [ecx + field_4], eax           # 00485c11
    mov eax, dword ptr [edx + field_8]           # 00485c14
    mov dword ptr [ecx + field_8], eax           # 00485c17
    mov edx, dword ptr [edx + field_c]           # 00485c1a
    mov dword ptr [ecx + field_c], edx           # 00485c1d
    mov eax, dword ptr [ebp - local_c]           # 00485c20
    add eax, 0xac0                               # 00485c23
    mov ecx, dword ptr [ebp - local_c]           # 00485c28
    movsx edx, word ptr [ecx + field_a9e]        # 00485c2b
    imul edx, edx, 0x85                          # 00485c32
    mov ecx, dword ptr [ebp - local_c]           # 00485c38
    lea edx, [ecx + edx + field_3a]              # 00485c3b
    mov ecx, dword ptr [eax]                     # 00485c3f
    mov dword ptr [edx], ecx                     # 00485c41
    mov ecx, dword ptr [eax + field_4]           # 00485c43
    mov dword ptr [edx + field_4], ecx           # 00485c46
    mov ecx, dword ptr [eax + field_8]           # 00485c49
    mov dword ptr [edx + field_8], ecx           # 00485c4c
    mov eax, dword ptr [eax + field_c]           # 00485c4f
    mov dword ptr [edx + field_c], eax           # 00485c52
    mov ecx, dword ptr [ebp - local_c]           # 00485c55
    movsx edx, word ptr [ecx + field_a9e]        # 00485c58
    imul edx, edx, 0x85                          # 00485c5f
    mov eax, dword ptr [ebp - local_c]           # 00485c65
    mov byte ptr [eax + edx + field_ac], 0x1     # 00485c68
L_00485c70:
    # block 0x00485c70: entered by jmp at 0x00485be5, 2 instruction(s), falls into the block at 0x00485c7d
    mov ecx, dword ptr [ebp - local_c]           # 00485c70
    mov dword ptr [ecx + field_b83], 0x0         # 00485c73
L_00485c7d:
    # block 0x00485c7d: entered by jmp at 0x00485b0b, 7 instruction(s), calls FUN_00484935, falls into the block at 0x00485c9c
    mov edx, dword ptr [ebp - local_c]           # 00485c7d
    mov ax, word ptr [edx + field_a9e]           # 00485c80
    push eax                                     # 00485c87
    mov ecx, dword ptr [ebp - local_c]           # 00485c88
    call FUN_00484935                            # 00485c8b
    mov ecx, dword ptr [ebp - local_c]           # 00485c90
    mov word ptr [ecx + field_a9e], 0xffff       # 00485c93
L_00485c9c:
    # block 0x00485c9c: entered by je at 0x004856c8; jne at 0x004856db; jne at 0x004856eb; jne at 0x00485705; more, 4 instruction(s), ends with ret
    pop esi                                      # 00485c9c
    {load} mov esp, ebp                          # 00485c9d
    pop ebp                                      # 00485c9f
    ret                                          # 00485ca0

