# FUN_00473651
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473651
# extent:       0x00473651-0x00473ac5 (1140 code bytes)
# span:         0x00473651-0x00473ac5 (code 1140, tables 0, padding 0)
# sha256:       f0052d327ab1c8d61657b1615a25c404295b7235db25f327d478a8ea84cac970
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00473651
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_b6, field_ba, field_345, field_347, field_365, field_36d, field_385, field_389, field_38d and 3 more; [ecx + n] field_4, field_8, field_c, field_b6, field_ba, field_361, field_365, field_389, field_38d, field_399, field_3a9, field_3b9; [edx + n] field_4, field_8, field_c, field_345, field_347, field_361, field_365, field_369, field_36d, field_385, field_391, field_39d and 6 more
# callees:      calls FUN_00473ac5, FUN_00475470
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m473206_click (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 311 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_345, 0x345  # offset +0x345
.equ field_347, 0x347  # offset +0x347
.equ field_361, 0x361  # offset +0x361
.equ field_365, 0x365  # offset +0x365
.equ field_369, 0x369  # offset +0x369
.equ field_36d, 0x36d  # offset +0x36d
.equ field_385, 0x385  # offset +0x385
.equ field_389, 0x389  # offset +0x389
.equ field_38d, 0x38d  # offset +0x38d
.equ field_391, 0x391  # offset +0x391
.equ field_395, 0x395  # offset +0x395
.equ field_399, 0x399  # offset +0x399
.equ field_39d, 0x39d  # offset +0x39d
.equ field_3a1, 0x3a1  # offset +0x3a1
.equ field_3a5, 0x3a5  # offset +0x3a5
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_3ad, 0x3ad  # offset +0x3ad
.equ field_3b1, 0x3b1  # offset +0x3b1
.equ field_3b5, 0x3b5  # offset +0x3b5
.equ field_3b9, 0x3b9  # offset +0x3b9
.equ field_3bd, 0x3bd  # offset +0x3bd
.equ field_3d1, 0x3d1  # offset +0x3d1

# --- external targets -----------------------------------------------
.set FUN_00473ac5, .text + (0x00473ac5 - 0x401000)
.set FUN_00475470, .text + (0x00475470 - 0x401000)

.org 0x00473651 - 0x401000
.globl FUN_00473651
FUN_00473651:
    # block 0x00473651: entry, 7 instruction(s), ends with jne to 0x00473671 (forward)
    push ebp                                     # 00473651
    {load} mov ebp, esp                          # 00473652
    sub esp, 0x10                                # 00473654
    mov dword ptr [ebp - local_10], ecx          # 00473657
    mov dword ptr [ebp - local_c], 0x0           # 0047365a
    cmp dword ptr [0x5a4bce], -0x1               # 00473661
    jne.d8 L_00473671                            # 00473668
    # block 0x0047366a: entered by fall-through of jne at 0x00473668, 2 instruction(s), ends with forward jump to 0x00473ac1
    {load} xor eax, eax                          # 0047366a
    jmp.d32 L_00473ac1                           # 0047366c
L_00473671:
    # block 0x00473671: entered by jne at 0x00473668, 60 instruction(s), calls FUN_00473ac5, ends with je to 0x00473811 (forward)
    mov eax, dword ptr [0x5a4bce]                # 00473671
    mov dword ptr [ebp - local_4], eax           # 00473676
    mov ecx, dword ptr [ebp - local_4]           # 00473679
    shl ecx, 0x4                                 # 0047367c
    add ecx, 0x5a4b5e                            # 0047367f
    mov dword ptr [ebp - local_8], ecx           # 00473685
    mov edx, dword ptr [ebp - local_10]          # 00473688
    mov dword ptr [edx + field_385], 0x0         # 0047368b
    mov eax, dword ptr [ebp - local_10]          # 00473695
    mov dword ptr [eax + field_389], 0x0         # 00473698
    mov ecx, dword ptr [ebp - local_10]          # 004736a2
    mov dword ptr [ecx + field_38d], 0x0         # 004736a5
    mov edx, dword ptr [ebp - local_10]          # 004736af
    mov dword ptr [edx + field_3d1], 0x0         # 004736b2
    mov eax, dword ptr [ebp - local_10]          # 004736bc
    movsx ecx, word ptr [eax + field_345]        # 004736bf
    mov edx, dword ptr [ebp - local_4]           # 004736c6
    imul edx, edx, 0x38                          # 004736c9
    mov eax, dword ptr [ebp - local_10]          # 004736cc
    mov eax, dword ptr [eax + edx + field_b6]    # 004736cf
    cdq                                          # 004736d6
    {load} sub eax, edx                          # 004736d7
    sar eax                                      # 004736d9
    {load} sub ecx, eax                          # 004736db
    mov edx, dword ptr [ebp - local_10]          # 004736dd
    mov dword ptr [edx + field_361], ecx         # 004736e0
    mov eax, dword ptr [ebp - local_10]          # 004736e6
    movsx ecx, word ptr [eax + field_347]        # 004736e9
    mov edx, dword ptr [ebp - local_4]           # 004736f0
    imul edx, edx, 0x38                          # 004736f3
    mov eax, dword ptr [ebp - local_10]          # 004736f6
    mov eax, dword ptr [eax + edx + field_ba]    # 004736f9
    cdq                                          # 00473700
    {load} sub eax, edx                          # 00473701
    sar eax                                      # 00473703
    {load} sub ecx, eax                          # 00473705
    mov edx, dword ptr [ebp - local_10]          # 00473707
    mov dword ptr [edx + field_365], ecx         # 0047370a
    mov eax, dword ptr [ebp - local_4]           # 00473710
    imul eax, eax, 0x38                          # 00473713
    mov ecx, dword ptr [ebp - local_10]          # 00473716
    mov edx, dword ptr [ecx + field_361]         # 00473719
    mov ecx, dword ptr [ebp - local_10]          # 0047371f
    mov eax, dword ptr [ecx + eax + field_b6]    # 00473722
    lea ecx, [edx + eax - field_minus_1]         # 00473729
    mov edx, dword ptr [ebp - local_10]          # 0047372d
    mov dword ptr [edx + field_369], ecx         # 00473730
    mov eax, dword ptr [ebp - local_4]           # 00473736
    imul eax, eax, 0x38                          # 00473739
    mov ecx, dword ptr [ebp - local_10]          # 0047373c
    mov edx, dword ptr [ecx + field_365]         # 0047373f
    mov ecx, dword ptr [ebp - local_10]          # 00473745
    mov eax, dword ptr [ecx + eax + field_ba]    # 00473748
    lea ecx, [edx + eax - field_minus_1]         # 0047374f
    mov edx, dword ptr [ebp - local_10]          # 00473753
    mov dword ptr [edx + field_36d], ecx         # 00473756
    mov ecx, dword ptr [ebp - local_10]          # 0047375c
    call FUN_00473ac5                            # 0047375f
    test eax, eax                                # 00473764
    je.d32 L_00473811                            # 00473766
    # block 0x0047376c: entered by fall-through of je at 0x00473766, 48 instruction(s), falls into the block at 0x00473811
    mov dword ptr [ebp - local_c], 0x1           # 0047376c
    mov eax, dword ptr [ebp - local_10]          # 00473773
    add eax, 0x361                               # 00473776
    mov ecx, dword ptr [ebp - local_10]          # 0047377b
    add ecx, 0x391                               # 0047377e
    mov edx, dword ptr [eax]                     # 00473784
    mov dword ptr [ecx], edx                     # 00473786
    mov edx, dword ptr [eax + field_4]           # 00473788
    mov dword ptr [ecx + field_4], edx           # 0047378b
    mov edx, dword ptr [eax + field_8]           # 0047378e
    mov dword ptr [ecx + field_8], edx           # 00473791
    mov eax, dword ptr [eax + field_c]           # 00473794
    mov dword ptr [ecx + field_c], eax           # 00473797
    mov ecx, dword ptr [ebp - local_10]          # 0047379a
    mov edx, dword ptr [ebp - local_10]          # 0047379d
    mov eax, dword ptr [ecx + field_399]         # 004737a0
    sub eax, dword ptr [edx + field_391]         # 004737a6
    cdq                                          # 004737ac
    {load} mov ecx, eax                          # 004737ad
    {load} xor ecx, edx                          # 004737af
    {load} sub ecx, edx                          # 004737b1
    mov edx, dword ptr [ebp - local_10]          # 004737b3
    mov eax, dword ptr [ebp - local_10]          # 004737b6
    mov edx, dword ptr [edx + field_39d]         # 004737b9
    sub edx, dword ptr [eax + field_395]         # 004737bf
    {load} mov eax, edx                          # 004737c5
    cdq                                          # 004737c7
    {load} xor eax, edx                          # 004737c8
    {load} sub eax, edx                          # 004737ca
    {load} add ecx, eax                          # 004737cc
    mov eax, dword ptr [ebp - local_10]          # 004737ce
    mov dword ptr [eax + field_385], ecx         # 004737d1
    mov ecx, dword ptr [ebp - local_10]          # 004737d7
    add ecx, 0x391                               # 004737da
    mov edx, dword ptr [ebp - local_10]          # 004737e0
    add edx, 0x3c1                               # 004737e3
    mov eax, dword ptr [ecx]                     # 004737e9
    mov dword ptr [edx], eax                     # 004737eb
    mov eax, dword ptr [ecx + field_4]           # 004737ed
    mov dword ptr [edx + field_4], eax           # 004737f0
    mov eax, dword ptr [ecx + field_8]           # 004737f3
    mov dword ptr [edx + field_8], eax           # 004737f6
    mov ecx, dword ptr [ecx + field_c]           # 004737f9
    mov dword ptr [edx + field_c], ecx           # 004737fc
    mov edx, dword ptr [ebp - local_10]          # 004737ff
    mov eax, dword ptr [ebp - local_10]          # 00473802
    mov ecx, dword ptr [eax + field_385]         # 00473805
    mov dword ptr [edx + field_3d1], ecx         # 0047380b
L_00473811:
    # block 0x00473811: entered by je at 0x00473766, 33 instruction(s), calls FUN_00473ac5, ends with je to 0x00473948 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00473811
    movsx ecx, word ptr [edx + field_345]        # 00473814
    mov edx, dword ptr [ebp - local_4]           # 0047381b
    imul edx, edx, 0x38                          # 0047381e
    mov eax, dword ptr [ebp - local_10]          # 00473821
    mov eax, dword ptr [eax + edx + field_b6]    # 00473824
    cdq                                          # 0047382b
    {load} sub eax, edx                          # 0047382c
    sar eax                                      # 0047382e
    {load} sub ecx, eax                          # 00473830
    mov edx, dword ptr [ebp - local_10]          # 00473832
    mov dword ptr [edx + field_361], ecx         # 00473835
    mov eax, dword ptr [ebp - local_4]           # 0047383b
    imul eax, eax, 0x38                          # 0047383e
    mov ecx, dword ptr [ebp - local_10]          # 00473841
    mov edx, dword ptr [ecx + field_361]         # 00473844
    mov ecx, dword ptr [ebp - local_10]          # 0047384a
    mov eax, dword ptr [ecx + eax + field_b6]    # 0047384d
    lea ecx, [edx + eax - field_minus_1]         # 00473854
    mov edx, dword ptr [ebp - local_10]          # 00473858
    mov dword ptr [edx + field_369], ecx         # 0047385b
    mov eax, dword ptr [ebp - local_10]          # 00473861
    mov ecx, dword ptr [ebp - local_8]           # 00473864
    mov edx, dword ptr [ecx + field_4]           # 00473867
    mov dword ptr [eax + field_365], edx         # 0047386a
    mov eax, dword ptr [ebp - local_10]          # 00473870
    mov ecx, dword ptr [ebp - local_8]           # 00473873
    mov edx, dword ptr [ecx + field_c]           # 00473876
    mov dword ptr [eax + field_36d], edx         # 00473879
    mov ecx, dword ptr [ebp - local_10]          # 0047387f
    call FUN_00473ac5                            # 00473882
    test eax, eax                                # 00473887
    je.d32 L_00473948                            # 00473889
    # block 0x0047388f: entered by fall-through of je at 0x00473889, 37 instruction(s), ends with jle to 0x00473948 (forward)
    mov dword ptr [ebp - local_c], 0x1           # 0047388f
    mov eax, dword ptr [ebp - local_10]          # 00473896
    add eax, 0x361                               # 00473899
    mov ecx, dword ptr [ebp - local_10]          # 0047389e
    add ecx, 0x3a1                               # 004738a1
    mov edx, dword ptr [eax]                     # 004738a7
    mov dword ptr [ecx], edx                     # 004738a9
    mov edx, dword ptr [eax + field_4]           # 004738ab
    mov dword ptr [ecx + field_4], edx           # 004738ae
    mov edx, dword ptr [eax + field_8]           # 004738b1
    mov dword ptr [ecx + field_8], edx           # 004738b4
    mov eax, dword ptr [eax + field_c]           # 004738b7
    mov dword ptr [ecx + field_c], eax           # 004738ba
    mov ecx, dword ptr [ebp - local_10]          # 004738bd
    mov edx, dword ptr [ebp - local_10]          # 004738c0
    mov eax, dword ptr [ecx + field_3a9]         # 004738c3
    sub eax, dword ptr [edx + field_3a1]         # 004738c9
    cdq                                          # 004738cf
    {load} mov ecx, eax                          # 004738d0
    {load} xor ecx, edx                          # 004738d2
    {load} sub ecx, edx                          # 004738d4
    mov edx, dword ptr [ebp - local_10]          # 004738d6
    mov eax, dword ptr [ebp - local_10]          # 004738d9
    mov edx, dword ptr [edx + field_3ad]         # 004738dc
    sub edx, dword ptr [eax + field_3a5]         # 004738e2
    {load} mov eax, edx                          # 004738e8
    cdq                                          # 004738ea
    {load} xor eax, edx                          # 004738eb
    {load} sub eax, edx                          # 004738ed
    {load} add ecx, eax                          # 004738ef
    mov eax, dword ptr [ebp - local_10]          # 004738f1
    mov dword ptr [eax + field_389], ecx         # 004738f4
    mov ecx, dword ptr [ebp - local_10]          # 004738fa
    mov edx, dword ptr [ebp - local_10]          # 004738fd
    mov eax, dword ptr [ecx + field_389]         # 00473900
    cmp eax, dword ptr [edx + field_3d1]         # 00473906
    jle.d8 L_00473948                            # 0047390c
    # block 0x0047390e: entered by fall-through of jle at 0x0047390c, 16 instruction(s), falls into the block at 0x00473948
    mov ecx, dword ptr [ebp - local_10]          # 0047390e
    add ecx, 0x3a1                               # 00473911
    mov edx, dword ptr [ebp - local_10]          # 00473917
    add edx, 0x3c1                               # 0047391a
    mov eax, dword ptr [ecx]                     # 00473920
    mov dword ptr [edx], eax                     # 00473922
    mov eax, dword ptr [ecx + field_4]           # 00473924
    mov dword ptr [edx + field_4], eax           # 00473927
    mov eax, dword ptr [ecx + field_8]           # 0047392a
    mov dword ptr [edx + field_8], eax           # 0047392d
    mov ecx, dword ptr [ecx + field_c]           # 00473930
    mov dword ptr [edx + field_c], ecx           # 00473933
    mov edx, dword ptr [ebp - local_10]          # 00473936
    mov eax, dword ptr [ebp - local_10]          # 00473939
    mov ecx, dword ptr [eax + field_389]         # 0047393c
    mov dword ptr [edx + field_3d1], ecx         # 00473942
L_00473948:
    # block 0x00473948: entered by je at 0x00473889; jle at 0x0047390c, 33 instruction(s), calls FUN_00473ac5, ends with je to 0x00473a7e (forward)
    mov edx, dword ptr [ebp - local_10]          # 00473948
    mov eax, dword ptr [ebp - local_8]           # 0047394b
    mov ecx, dword ptr [eax]                     # 0047394e
    mov dword ptr [edx + field_361], ecx         # 00473950
    mov edx, dword ptr [ebp - local_10]          # 00473956
    mov eax, dword ptr [ebp - local_8]           # 00473959
    mov ecx, dword ptr [eax + field_8]           # 0047395c
    mov dword ptr [edx + field_369], ecx         # 0047395f
    mov edx, dword ptr [ebp - local_10]          # 00473965
    movsx ecx, word ptr [edx + field_347]        # 00473968
    mov edx, dword ptr [ebp - local_4]           # 0047396f
    imul edx, edx, 0x38                          # 00473972
    mov eax, dword ptr [ebp - local_10]          # 00473975
    mov eax, dword ptr [eax + edx + field_ba]    # 00473978
    cdq                                          # 0047397f
    {load} sub eax, edx                          # 00473980
    sar eax                                      # 00473982
    {load} sub ecx, eax                          # 00473984
    mov edx, dword ptr [ebp - local_10]          # 00473986
    mov dword ptr [edx + field_365], ecx         # 00473989
    mov eax, dword ptr [ebp - local_4]           # 0047398f
    imul eax, eax, 0x38                          # 00473992
    mov ecx, dword ptr [ebp - local_10]          # 00473995
    mov edx, dword ptr [ecx + field_365]         # 00473998
    mov ecx, dword ptr [ebp - local_10]          # 0047399e
    mov eax, dword ptr [ecx + eax + field_ba]    # 004739a1
    lea ecx, [edx + eax - field_minus_1]         # 004739a8
    mov edx, dword ptr [ebp - local_10]          # 004739ac
    mov dword ptr [edx + field_36d], ecx         # 004739af
    mov ecx, dword ptr [ebp - local_10]          # 004739b5
    call FUN_00473ac5                            # 004739b8
    test eax, eax                                # 004739bd
    je.d32 L_00473a7e                            # 004739bf
    # block 0x004739c5: entered by fall-through of je at 0x004739bf, 37 instruction(s), ends with jle to 0x00473a7e (forward)
    mov dword ptr [ebp - local_c], 0x1           # 004739c5
    mov eax, dword ptr [ebp - local_10]          # 004739cc
    add eax, 0x361                               # 004739cf
    mov ecx, dword ptr [ebp - local_10]          # 004739d4
    add ecx, 0x3b1                               # 004739d7
    mov edx, dword ptr [eax]                     # 004739dd
    mov dword ptr [ecx], edx                     # 004739df
    mov edx, dword ptr [eax + field_4]           # 004739e1
    mov dword ptr [ecx + field_4], edx           # 004739e4
    mov edx, dword ptr [eax + field_8]           # 004739e7
    mov dword ptr [ecx + field_8], edx           # 004739ea
    mov eax, dword ptr [eax + field_c]           # 004739ed
    mov dword ptr [ecx + field_c], eax           # 004739f0
    mov ecx, dword ptr [ebp - local_10]          # 004739f3
    mov edx, dword ptr [ebp - local_10]          # 004739f6
    mov eax, dword ptr [ecx + field_3b9]         # 004739f9
    sub eax, dword ptr [edx + field_3b1]         # 004739ff
    cdq                                          # 00473a05
    {load} mov ecx, eax                          # 00473a06
    {load} xor ecx, edx                          # 00473a08
    {load} sub ecx, edx                          # 00473a0a
    mov edx, dword ptr [ebp - local_10]          # 00473a0c
    mov eax, dword ptr [ebp - local_10]          # 00473a0f
    mov edx, dword ptr [edx + field_3bd]         # 00473a12
    sub edx, dword ptr [eax + field_3b5]         # 00473a18
    {load} mov eax, edx                          # 00473a1e
    cdq                                          # 00473a20
    {load} xor eax, edx                          # 00473a21
    {load} sub eax, edx                          # 00473a23
    {load} add ecx, eax                          # 00473a25
    mov eax, dword ptr [ebp - local_10]          # 00473a27
    mov dword ptr [eax + field_38d], ecx         # 00473a2a
    mov ecx, dword ptr [ebp - local_10]          # 00473a30
    mov edx, dword ptr [ebp - local_10]          # 00473a33
    mov eax, dword ptr [ecx + field_38d]         # 00473a36
    cmp eax, dword ptr [edx + field_3d1]         # 00473a3c
    jle.d8 L_00473a7e                            # 00473a42
    # block 0x00473a44: entered by fall-through of jle at 0x00473a42, 16 instruction(s), falls into the block at 0x00473a7e
    mov ecx, dword ptr [ebp - local_10]          # 00473a44
    add ecx, 0x3b1                               # 00473a47
    mov edx, dword ptr [ebp - local_10]          # 00473a4d
    add edx, 0x3c1                               # 00473a50
    mov eax, dword ptr [ecx]                     # 00473a56
    mov dword ptr [edx], eax                     # 00473a58
    mov eax, dword ptr [ecx + field_4]           # 00473a5a
    mov dword ptr [edx + field_4], eax           # 00473a5d
    mov eax, dword ptr [ecx + field_8]           # 00473a60
    mov dword ptr [edx + field_8], eax           # 00473a63
    mov ecx, dword ptr [ecx + field_c]           # 00473a66
    mov dword ptr [edx + field_c], ecx           # 00473a69
    mov edx, dword ptr [ebp - local_10]          # 00473a6c
    mov eax, dword ptr [ebp - local_10]          # 00473a6f
    mov ecx, dword ptr [eax + field_38d]         # 00473a72
    mov dword ptr [edx + field_3d1], ecx         # 00473a78
L_00473a7e:
    # block 0x00473a7e: entered by je at 0x004739bf; jle at 0x00473a42, 2 instruction(s), ends with jne to 0x00473a92 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00473a7e
    jne.d8 L_00473a92                            # 00473a82
    # block 0x00473a84: entered by fall-through of jne at 0x00473a82, 3 instruction(s), ends with forward jump to 0x00473ac1
    mov dword ptr [0x5a4bce], 0xffffffff         # 00473a84
    {load} xor eax, eax                          # 00473a8e
    jmp.d8 L_00473ac1                            # 00473a90
L_00473a92:
    # block 0x00473a92: entered by jne at 0x00473a82, 14 instruction(s), calls FUN_00475470, falls into the block at 0x00473ac1
    mov edx, dword ptr [ebp - local_10]          # 00473a92
    add edx, 0x3c1                               # 00473a95
    mov eax, dword ptr [ebp - local_8]           # 00473a9b
    mov ecx, dword ptr [edx]                     # 00473a9e
    mov dword ptr [eax], ecx                     # 00473aa0
    mov ecx, dword ptr [edx + field_4]           # 00473aa2
    mov dword ptr [eax + field_4], ecx           # 00473aa5
    mov ecx, dword ptr [edx + field_8]           # 00473aa8
    mov dword ptr [eax + field_8], ecx           # 00473aab
    mov edx, dword ptr [edx + field_c]           # 00473aae
    mov dword ptr [eax + field_c], edx           # 00473ab1
    mov ecx, dword ptr [ebp - local_10]          # 00473ab4
    call FUN_00475470                            # 00473ab7
    mov eax, 0x1                                 # 00473abc
L_00473ac1:
    # block 0x00473ac1: entered by jmp at 0x0047366c; jmp at 0x00473a90, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00473ac1
    pop ebp                                      # 00473ac3
    ret                                          # 00473ac4

