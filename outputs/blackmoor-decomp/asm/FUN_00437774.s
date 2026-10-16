# FUN_00437774
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437774
# extent:       0x00437774-0x00437cff (1419 code bytes)
# span:         0x00437774-0x00437cff (code 1419, tables 0, padding 0)
# sha256:       a5717327ce5582af68a15fcd5d073354d06cdd981885ed68f2f89ea40aec6db9
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00437774
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_b, field_c, field_d, field_e, field_1c, field_22, field_25, field_27; [ecx + n] field_4, field_5, field_21, field_22, field_28; [edx + n] field_4, field_5, field_1c, field_1d, field_1e, field_1f, field_20, field_26, field_29
# callees:      calls USER32.dll!GetKeyState, FUN_00425fc0, FUN_00425fa0, FUN_00493a47, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 397 instruction(s), 93 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ arg_8, 0x8  # offset +0x8
.equ field_b, 0xb  # offset +0xb
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd
.equ field_e, 0xe  # offset +0xe
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1f, 0x1f  # offset +0x1f
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_29, 0x29  # offset +0x29

# --- external targets -----------------------------------------------
.set FUN_00425fa0, .text + (0x00425fa0 - 0x401000)
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_00493a47, .text + (0x00493a47 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00437774 - 0x401000
.globl FUN_00437774
FUN_00437774:
    # block 0x00437774: entry, 9 instruction(s), ends with je to 0x004377af (forward)
    push ebp                                     # 00437774
    {load} mov ebp, esp                          # 00437775
    push ecx                                     # 00437777
    mov dword ptr [ebp - local_4], ecx           # 00437778
    mov eax, dword ptr [ebp - local_4]           # 0043777b
    {load} xor ecx, ecx                          # 0043777e
    mov cl, byte ptr [eax + field_4]             # 00437780
    test ecx, ecx                                # 00437783
    je.d8 L_004377af                             # 00437785
    # block 0x00437787: entered by fall-through of je at 0x00437785, 5 instruction(s), ends with jne to 0x004377af (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437787
    {load} xor eax, eax                          # 0043778a
    mov al, byte ptr [edx + field_1c]            # 0043778c
    test eax, eax                                # 0043778f
    jne.d8 L_004377af                            # 00437791
    # block 0x00437793: entered by fall-through of jne at 0x00437791, 3 instruction(s), ends with je to 0x004377a3 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437793
    cmp dword ptr [ecx], 0x70                    # 00437796
    je.d8 L_004377a3                             # 00437799
    # block 0x0043779b: entered by fall-through of je at 0x00437799, 3 instruction(s), ends with jne to 0x004377af (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0043779b
    cmp dword ptr [edx], 0x50                    # 0043779e
    jne.d8 L_004377af                            # 004377a1
L_004377a3:
    # block 0x004377a3: entered by je at 0x00437799; fall-through of jne at 0x004377a1, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov eax, dword ptr [ebp - local_4]           # 004377a3
    mov byte ptr [eax + field_1c], 0x1           # 004377a6
    jmp.d32 L_00437cf9                           # 004377aa
L_004377af:
    # block 0x004377af: entered by je at 0x00437785; jne at 0x00437791; jne at 0x004377a1, 3 instruction(s), ends with jne to 0x0043781d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004377af
    cmp dword ptr [ecx], 0x25                    # 004377b2
    jne.d8 L_0043781d                            # 004377b5
    # block 0x004377b7: entered by fall-through of jne at 0x004377b5, 2 instruction(s), ends with jne to 0x0043781d (forward)
    cmp dword ptr [0x583981], 0xe                # 004377b7
    jne.d8 L_0043781d                            # 004377be
    # block 0x004377c0: entered by fall-through of jne at 0x004377be, 2 instruction(s), ends with jne to 0x0043781d (forward)
    cmp dword ptr [0x583999], 0x3                # 004377c0
    jne.d8 L_0043781d                            # 004377c7
    # block 0x004377c9: entered by fall-through of jne at 0x004377c7, 2 instruction(s), ends with jne to 0x0043781d (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 004377c9
    jne.d8 L_0043781d                            # 004377d0
    # block 0x004377d2: entered by fall-through of jne at 0x004377d0, 2 instruction(s), ends with je to 0x0043781d (forward)
    cmp dword ptr [0x5a4c1c], 0x0                # 004377d2
    je.d8 L_0043781d                             # 004377d9
    # block 0x004377db: entered by fall-through of je at 0x004377d9, 11 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x00437811 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004377db
    mov byte ptr [edx + field_1f], 0x0           # 004377de
    mov eax, dword ptr [ebp - local_4]           # 004377e2
    mov byte ptr [eax + field_d], 0x0            # 004377e5
    mov dword ptr [0x5a4c18], 0x1                # 004377e9
    push 0x11                                    # 004377f3
    call dword ptr [0x52a4b8]                    # 004377f5
    movsx ecx, ax                                # 004377fb
    and ecx, 0x8000                              # 004377fe
    test ecx, ecx                                # 00437804
    je.d8 L_00437811                             # 00437806
    # block 0x00437808: entered by fall-through of je at 0x00437806, 3 instruction(s), ends with forward jump to 0x00437818
    mov edx, dword ptr [ebp - local_4]           # 00437808
    mov byte ptr [edx + field_1f], 0x1           # 0043780b
    jmp.d8 L_00437818                            # 0043780f
L_00437811:
    # block 0x00437811: entered by je at 0x00437806, 2 instruction(s), falls into the block at 0x00437818
    mov eax, dword ptr [ebp - local_4]           # 00437811
    mov byte ptr [eax + field_d], 0x1            # 00437814
L_00437818:
    # block 0x00437818: entered by jmp at 0x0043780f, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437818
L_0043781d:
    # block 0x0043781d: entered by jne at 0x004377b5; jne at 0x004377be; jne at 0x004377c7; jne at 0x004377d0; more, 3 instruction(s), ends with jne to 0x0043788b (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0043781d
    cmp dword ptr [ecx], 0x27                    # 00437820
    jne.d8 L_0043788b                            # 00437823
    # block 0x00437825: entered by fall-through of jne at 0x00437823, 2 instruction(s), ends with jne to 0x0043788b (forward)
    cmp dword ptr [0x583981], 0xe                # 00437825
    jne.d8 L_0043788b                            # 0043782c
    # block 0x0043782e: entered by fall-through of jne at 0x0043782c, 2 instruction(s), ends with jne to 0x0043788b (forward)
    cmp dword ptr [0x583999], 0x3                # 0043782e
    jne.d8 L_0043788b                            # 00437835
    # block 0x00437837: entered by fall-through of jne at 0x00437835, 2 instruction(s), ends with jne to 0x0043788b (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437837
    jne.d8 L_0043788b                            # 0043783e
    # block 0x00437840: entered by fall-through of jne at 0x0043783e, 2 instruction(s), ends with je to 0x0043788b (forward)
    cmp dword ptr [0x5a4c1c], 0x0                # 00437840
    je.d8 L_0043788b                             # 00437847
    # block 0x00437849: entered by fall-through of je at 0x00437847, 11 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x0043787f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437849
    mov byte ptr [edx + field_20], 0x0           # 0043784c
    mov eax, dword ptr [ebp - local_4]           # 00437850
    mov byte ptr [eax + field_e], 0x0            # 00437853
    mov dword ptr [0x5a4c18], 0x2                # 00437857
    push 0x11                                    # 00437861
    call dword ptr [0x52a4b8]                    # 00437863
    movsx ecx, ax                                # 00437869
    and ecx, 0x8000                              # 0043786c
    test ecx, ecx                                # 00437872
    je.d8 L_0043787f                             # 00437874
    # block 0x00437876: entered by fall-through of je at 0x00437874, 3 instruction(s), ends with forward jump to 0x00437886
    mov edx, dword ptr [ebp - local_4]           # 00437876
    mov byte ptr [edx + field_20], 0x1           # 00437879
    jmp.d8 L_00437886                            # 0043787d
L_0043787f:
    # block 0x0043787f: entered by je at 0x00437874, 2 instruction(s), falls into the block at 0x00437886
    mov eax, dword ptr [ebp - local_4]           # 0043787f
    mov byte ptr [eax + field_e], 0x1            # 00437882
L_00437886:
    # block 0x00437886: entered by jmp at 0x0043787d, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437886
L_0043788b:
    # block 0x0043788b: entered by jne at 0x00437823; jne at 0x0043782c; jne at 0x00437835; jne at 0x0043783e; more, 3 instruction(s), ends with jne to 0x004378f9 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0043788b
    cmp dword ptr [ecx], 0x26                    # 0043788e
    jne.d8 L_004378f9                            # 00437891
    # block 0x00437893: entered by fall-through of jne at 0x00437891, 2 instruction(s), ends with jne to 0x004378f9 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437893
    jne.d8 L_004378f9                            # 0043789a
    # block 0x0043789c: entered by fall-through of jne at 0x0043789a, 2 instruction(s), ends with jne to 0x004378f9 (forward)
    cmp dword ptr [0x583999], 0x3                # 0043789c
    jne.d8 L_004378f9                            # 004378a3
    # block 0x004378a5: entered by fall-through of jne at 0x004378a3, 2 instruction(s), ends with jne to 0x004378f9 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 004378a5
    jne.d8 L_004378f9                            # 004378ac
    # block 0x004378ae: entered by fall-through of jne at 0x004378ac, 2 instruction(s), ends with je to 0x004378f9 (forward)
    cmp dword ptr [0x5a4c1c], 0x0                # 004378ae
    je.d8 L_004378f9                             # 004378b5
    # block 0x004378b7: entered by fall-through of je at 0x004378b5, 11 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x004378ed (forward)
    mov edx, dword ptr [ebp - local_4]           # 004378b7
    mov byte ptr [edx + field_1d], 0x0           # 004378ba
    mov eax, dword ptr [ebp - local_4]           # 004378be
    mov byte ptr [eax + field_b], 0x0            # 004378c1
    mov dword ptr [0x5a4c18], 0x3                # 004378c5
    push 0x11                                    # 004378cf
    call dword ptr [0x52a4b8]                    # 004378d1
    movsx ecx, ax                                # 004378d7
    and ecx, 0x8000                              # 004378da
    test ecx, ecx                                # 004378e0
    je.d8 L_004378ed                             # 004378e2
    # block 0x004378e4: entered by fall-through of je at 0x004378e2, 3 instruction(s), ends with forward jump to 0x004378f4
    mov edx, dword ptr [ebp - local_4]           # 004378e4
    mov byte ptr [edx + field_1d], 0x1           # 004378e7
    jmp.d8 L_004378f4                            # 004378eb
L_004378ed:
    # block 0x004378ed: entered by je at 0x004378e2, 2 instruction(s), falls into the block at 0x004378f4
    mov eax, dword ptr [ebp - local_4]           # 004378ed
    mov byte ptr [eax + field_b], 0x1            # 004378f0
L_004378f4:
    # block 0x004378f4: entered by jmp at 0x004378eb, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 004378f4
L_004378f9:
    # block 0x004378f9: entered by jne at 0x00437891; jne at 0x0043789a; jne at 0x004378a3; jne at 0x004378ac; more, 3 instruction(s), ends with jne to 0x00437967 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004378f9
    cmp dword ptr [ecx], 0x28                    # 004378fc
    jne.d8 L_00437967                            # 004378ff
    # block 0x00437901: entered by fall-through of jne at 0x004378ff, 2 instruction(s), ends with jne to 0x00437967 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437901
    jne.d8 L_00437967                            # 00437908
    # block 0x0043790a: entered by fall-through of jne at 0x00437908, 2 instruction(s), ends with jne to 0x00437967 (forward)
    cmp dword ptr [0x583999], 0x3                # 0043790a
    jne.d8 L_00437967                            # 00437911
    # block 0x00437913: entered by fall-through of jne at 0x00437911, 2 instruction(s), ends with jne to 0x00437967 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437913
    jne.d8 L_00437967                            # 0043791a
    # block 0x0043791c: entered by fall-through of jne at 0x0043791a, 2 instruction(s), ends with je to 0x00437967 (forward)
    cmp dword ptr [0x5a4c1c], 0x0                # 0043791c
    je.d8 L_00437967                             # 00437923
    # block 0x00437925: entered by fall-through of je at 0x00437923, 11 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x0043795b (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437925
    mov byte ptr [edx + field_1e], 0x0           # 00437928
    mov eax, dword ptr [ebp - local_4]           # 0043792c
    mov byte ptr [eax + field_c], 0x0            # 0043792f
    mov dword ptr [0x5a4c18], 0x4                # 00437933
    push 0x11                                    # 0043793d
    call dword ptr [0x52a4b8]                    # 0043793f
    movsx ecx, ax                                # 00437945
    and ecx, 0x8000                              # 00437948
    test ecx, ecx                                # 0043794e
    je.d8 L_0043795b                             # 00437950
    # block 0x00437952: entered by fall-through of je at 0x00437950, 3 instruction(s), ends with forward jump to 0x00437962
    mov edx, dword ptr [ebp - local_4]           # 00437952
    mov byte ptr [edx + field_1e], 0x1           # 00437955
    jmp.d8 L_00437962                            # 00437959
L_0043795b:
    # block 0x0043795b: entered by je at 0x00437950, 2 instruction(s), falls into the block at 0x00437962
    mov eax, dword ptr [ebp - local_4]           # 0043795b
    mov byte ptr [eax + field_c], 0x1            # 0043795e
L_00437962:
    # block 0x00437962: entered by jmp at 0x00437959, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437962
L_00437967:
    # block 0x00437967: entered by jne at 0x004378ff; jne at 0x00437908; jne at 0x00437911; jne at 0x0043791a; more, 2 instruction(s), ends with je to 0x004379bb (forward)
    cmp dword ptr [0x5e32c9], 0x0                # 00437967
    je.d8 L_004379bb                             # 0043796e
    # block 0x00437970: entered by fall-through of je at 0x0043796e, 2 instruction(s), ends with jne to 0x004379bb (forward)
    cmp dword ptr [0x5e32e2], 0x0                # 00437970
    jne.d8 L_004379bb                            # 00437977
    # block 0x00437979: entered by fall-through of jne at 0x00437977, 3 instruction(s), ends with je to 0x004379a1 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437979
    cmp dword ptr [ecx], 0x25                    # 0043797c
    je.d8 L_004379a1                             # 0043797f
    # block 0x00437981: entered by fall-through of je at 0x0043797f, 3 instruction(s), ends with je to 0x004379a1 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437981
    cmp dword ptr [edx], 0x27                    # 00437984
    je.d8 L_004379a1                             # 00437987
    # block 0x00437989: entered by fall-through of je at 0x00437987, 3 instruction(s), ends with je to 0x004379a1 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437989
    cmp dword ptr [eax], 0xd                     # 0043798c
    je.d8 L_004379a1                             # 0043798f
    # block 0x00437991: entered by fall-through of je at 0x0043798f, 3 instruction(s), ends with je to 0x004379a1 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437991
    cmp dword ptr [ecx], 0x23                    # 00437994
    je.d8 L_004379a1                             # 00437997
    # block 0x00437999: entered by fall-through of je at 0x00437997, 3 instruction(s), ends with jne to 0x004379bb (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437999
    cmp dword ptr [edx], 0x24                    # 0043799c
    jne.d8 L_004379bb                            # 0043799f
L_004379a1:
    # block 0x004379a1: entered by je at 0x0043797f; je at 0x00437987; je at 0x0043798f; je at 0x00437997; more, 5 instruction(s), ends with forward jump to 0x00437cf9
    mov eax, dword ptr [ebp + arg_8]             # 004379a1
    mov cl, byte ptr [eax]                       # 004379a4
    mov byte ptr [0x5e32dd], cl                  # 004379a6
    mov dword ptr [0x5e32e2], 0x1                # 004379ac
    jmp.d32 L_00437cf9                           # 004379b6
L_004379bb:
    # block 0x004379bb: entered by je at 0x0043796e; jne at 0x00437977; jne at 0x0043799f, 2 instruction(s), ends with je to 0x004379ef (forward)
    cmp dword ptr [0x5e32cd], 0x0                # 004379bb
    je.d8 L_004379ef                             # 004379c2
    # block 0x004379c4: entered by fall-through of je at 0x004379c2, 2 instruction(s), ends with jne to 0x004379ef (forward)
    cmp dword ptr [0x5e32e2], 0x0                # 004379c4
    jne.d8 L_004379ef                            # 004379cb
    # block 0x004379cd: entered by fall-through of jne at 0x004379cb, 3 instruction(s), ends with jne to 0x004379ef (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004379cd
    cmp dword ptr [edx], 0xd                     # 004379d0
    jne.d8 L_004379ef                            # 004379d3
    # block 0x004379d5: entered by fall-through of jne at 0x004379d3, 5 instruction(s), ends with forward jump to 0x00437cf9
    mov eax, dword ptr [ebp + arg_8]             # 004379d5
    mov cl, byte ptr [eax]                       # 004379d8
    mov byte ptr [0x5e32dd], cl                  # 004379da
    mov dword ptr [0x5e32e2], 0x1                # 004379e0
    jmp.d32 L_00437cf9                           # 004379ea
L_004379ef:
    # block 0x004379ef: entered by je at 0x004379c2; jne at 0x004379cb; jne at 0x004379d3, 3 instruction(s), ends with jne to 0x00437a40 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004379ef
    cmp dword ptr [edx], 0x44                    # 004379f2
    jne.d8 L_00437a40                            # 004379f5
    # block 0x004379f7: entered by fall-through of jne at 0x004379f5, 5 instruction(s), ends with je to 0x00437a40 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004379f7
    {load} xor ecx, ecx                          # 004379fa
    mov cl, byte ptr [eax + field_4]             # 004379fc
    test ecx, ecx                                # 004379ff
    je.d8 L_00437a40                             # 00437a01
    # block 0x00437a03: entered by fall-through of je at 0x00437a01, 2 instruction(s), ends with jne to 0x00437a40 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437a03
    jne.d8 L_00437a40                            # 00437a0a
    # block 0x00437a0c: entered by fall-through of jne at 0x00437a0a, 2 instruction(s), ends with jne to 0x00437a40 (forward)
    cmp dword ptr [0x583999], 0x3                # 00437a0c
    jne.d8 L_00437a40                            # 00437a13
    # block 0x00437a15: entered by fall-through of jne at 0x00437a13, 5 instruction(s), ends with je to 0x00437a2f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437a15
    {load} xor eax, eax                          # 00437a18
    mov al, byte ptr [edx + field_5]             # 00437a1a
    test eax, eax                                # 00437a1d
    je.d8 L_00437a2f                             # 00437a1f
    # block 0x00437a21: entered by fall-through of je at 0x00437a1f, 4 instruction(s), calls FUN_00425fc0, ends with forward jump to 0x00437a3b
    mov ecx, dword ptr [ebp - local_4]           # 00437a21
    mov byte ptr [ecx + field_5], 0x0            # 00437a24
    call FUN_00425fc0                            # 00437a28
    jmp.d8 L_00437a3b                            # 00437a2d
L_00437a2f:
    # block 0x00437a2f: entered by je at 0x00437a1f, 3 instruction(s), calls FUN_00425fa0, falls into the block at 0x00437a3b
    mov edx, dword ptr [ebp - local_4]           # 00437a2f
    mov byte ptr [edx + field_5], 0x1            # 00437a32
    call FUN_00425fa0                            # 00437a36
L_00437a3b:
    # block 0x00437a3b: entered by jmp at 0x00437a2d, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437a3b
L_00437a40:
    # block 0x00437a40: entered by jne at 0x004379f5; je at 0x00437a01; jne at 0x00437a0a; jne at 0x00437a13, 3 instruction(s), ends with jne to 0x00437a8b (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437a40
    cmp dword ptr [eax], 0x54                    # 00437a43
    jne.d8 L_00437a8b                            # 00437a46
    # block 0x00437a48: entered by fall-through of jne at 0x00437a46, 5 instruction(s), ends with je to 0x00437a8b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437a48
    {load} xor edx, edx                          # 00437a4b
    mov dl, byte ptr [ecx + field_4]             # 00437a4d
    test edx, edx                                # 00437a50
    je.d8 L_00437a8b                             # 00437a52
    # block 0x00437a54: entered by fall-through of je at 0x00437a52, 2 instruction(s), ends with jne to 0x00437a8b (forward)
    cmp dword ptr [0x583981], 0xe                # 00437a54
    jne.d8 L_00437a8b                            # 00437a5b
    # block 0x00437a5d: entered by fall-through of jne at 0x00437a5b, 2 instruction(s), ends with jne to 0x00437a8b (forward)
    cmp dword ptr [0x583999], 0x3                # 00437a5d
    jne.d8 L_00437a8b                            # 00437a64
    # block 0x00437a66: entered by fall-through of jne at 0x00437a64, 5 instruction(s), ends with jl to 0x00437a86 (forward)
    mov eax, dword ptr [0x5c3a63]                # 00437a66
    add eax, 0x1                                 # 00437a6b
    mov dword ptr [0x5c3a63], eax                # 00437a6e
    cmp dword ptr [0x5c3a63], 0xa                # 00437a73
    jl.d8 L_00437a86                             # 00437a7a
    # block 0x00437a7c: entered by fall-through of jl at 0x00437a7a, 1 instruction(s), falls into the block at 0x00437a86
    mov dword ptr [0x5c3a63], 0x0                # 00437a7c
L_00437a86:
    # block 0x00437a86: entered by jl at 0x00437a7a, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437a86
L_00437a8b:
    # block 0x00437a8b: entered by jne at 0x00437a46; je at 0x00437a52; jne at 0x00437a5b; jne at 0x00437a64, 3 instruction(s), ends with jne to 0x00437ad2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437a8b
    cmp dword ptr [ecx], 0x46                    # 00437a8e
    jne.d8 L_00437ad2                            # 00437a91
    # block 0x00437a93: entered by fall-through of jne at 0x00437a91, 5 instruction(s), ends with je to 0x00437ad2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437a93
    {load} xor eax, eax                          # 00437a96
    mov al, byte ptr [edx + field_4]             # 00437a98
    test eax, eax                                # 00437a9b
    je.d8 L_00437ad2                             # 00437a9d
    # block 0x00437a9f: entered by fall-through of je at 0x00437a9d, 2 instruction(s), ends with jne to 0x00437ad2 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437a9f
    jne.d8 L_00437ad2                            # 00437aa6
    # block 0x00437aa8: entered by fall-through of jne at 0x00437aa6, 2 instruction(s), ends with jne to 0x00437ad2 (forward)
    cmp dword ptr [0x583999], 0x3                # 00437aa8
    jne.d8 L_00437ad2                            # 00437aaf
    # block 0x00437ab1: entered by fall-through of jne at 0x00437aaf, 5 instruction(s), ends with je to 0x00437ac6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437ab1
    {load} xor edx, edx                          # 00437ab4
    mov dl, byte ptr [ecx + field_22]            # 00437ab6
    test edx, edx                                # 00437ab9
    je.d8 L_00437ac6                             # 00437abb
    # block 0x00437abd: entered by fall-through of je at 0x00437abb, 3 instruction(s), ends with forward jump to 0x00437acd
    mov eax, dword ptr [ebp - local_4]           # 00437abd
    mov byte ptr [eax + field_22], 0x0           # 00437ac0
    jmp.d8 L_00437acd                            # 00437ac4
L_00437ac6:
    # block 0x00437ac6: entered by je at 0x00437abb, 2 instruction(s), falls into the block at 0x00437acd
    mov ecx, dword ptr [ebp - local_4]           # 00437ac6
    mov byte ptr [ecx + field_22], 0x1           # 00437ac9
L_00437acd:
    # block 0x00437acd: entered by jmp at 0x00437ac4, 1 instruction(s), ends with forward jump to 0x00437cf9
    jmp.d32 L_00437cf9                           # 00437acd
L_00437ad2:
    # block 0x00437ad2: entered by jne at 0x00437a91; je at 0x00437a9d; jne at 0x00437aa6; jne at 0x00437aaf, 3 instruction(s), ends with jne to 0x00437b06 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437ad2
    cmp dword ptr [edx], 0x56                    # 00437ad5
    jne.d8 L_00437b06                            # 00437ad8
    # block 0x00437ada: entered by fall-through of jne at 0x00437ad8, 2 instruction(s), ends with jne to 0x00437b06 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437ada
    jne.d8 L_00437b06                            # 00437ae1
    # block 0x00437ae3: entered by fall-through of jne at 0x00437ae1, 6 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x00437b06 (forward)
    push 0x11                                    # 00437ae3
    call dword ptr [0x52a4b8]                    # 00437ae5
    movsx eax, ax                                # 00437aeb
    and eax, 0x8000                              # 00437aee
    test eax, eax                                # 00437af3
    je.d8 L_00437b06                             # 00437af5
    # block 0x00437af7: entered by fall-through of je at 0x00437af5, 2 instruction(s), ends with forward jump to 0x00437cf9
    mov dword ptr [0x5d17ab], 0x1                # 00437af7
    jmp.d32 L_00437cf9                           # 00437b01
L_00437b06:
    # block 0x00437b06: entered by jne at 0x00437ad8; jne at 0x00437ae1; je at 0x00437af5, 3 instruction(s), ends with jne to 0x00437b41 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437b06
    cmp dword ptr [ecx], 0x43                    # 00437b09
    jne.d8 L_00437b41                            # 00437b0c
    # block 0x00437b0e: entered by fall-through of jne at 0x00437b0c, 5 instruction(s), ends with je to 0x00437b41 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437b0e
    {load} xor eax, eax                          # 00437b11
    mov al, byte ptr [edx + field_4]             # 00437b13
    test eax, eax                                # 00437b16
    je.d8 L_00437b41                             # 00437b18
    # block 0x00437b1a: entered by fall-through of je at 0x00437b18, 2 instruction(s), ends with jne to 0x00437b41 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437b1a
    jne.d8 L_00437b41                            # 00437b21
    # block 0x00437b23: entered by fall-through of jne at 0x00437b21, 2 instruction(s), ends with jne to 0x00437b41 (forward)
    cmp dword ptr [0x583999], 0x3                # 00437b23
    jne.d8 L_00437b41                            # 00437b2a
    # block 0x00437b2c: entered by fall-through of jne at 0x00437b2a, 2 instruction(s), ends with jne to 0x00437b41 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437b2c
    jne.d8 L_00437b41                            # 00437b33
    # block 0x00437b35: entered by fall-through of jne at 0x00437b33, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov ecx, dword ptr [ebp - local_4]           # 00437b35
    mov byte ptr [ecx + field_21], 0x1           # 00437b38
    jmp.d32 L_00437cf9                           # 00437b3c
L_00437b41:
    # block 0x00437b41: entered by jne at 0x00437b0c; je at 0x00437b18; jne at 0x00437b21; jne at 0x00437b2a; more, 3 instruction(s), ends with jne to 0x00437b7e (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437b41
    cmp dword ptr [edx], 0x52                    # 00437b44
    jne.d8 L_00437b7e                            # 00437b47
    # block 0x00437b49: entered by fall-through of jne at 0x00437b47, 2 instruction(s), ends with jne to 0x00437b7e (forward)
    cmp dword ptr [0x583981], 0xe                # 00437b49
    jne.d8 L_00437b7e                            # 00437b50
    # block 0x00437b52: entered by fall-through of jne at 0x00437b50, 2 instruction(s), ends with jne to 0x00437b7e (forward)
    cmp dword ptr [0x583999], 0x3                # 00437b52
    jne.d8 L_00437b7e                            # 00437b59
    # block 0x00437b5b: entered by fall-through of jne at 0x00437b59, 2 instruction(s), ends with jne to 0x00437b7e (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437b5b
    jne.d8 L_00437b7e                            # 00437b62
    # block 0x00437b64: entered by fall-through of jne at 0x00437b62, 4 instruction(s), calls FUN_00493a47, ends with je to 0x00437b7e (forward)
    mov ecx, 0x630a9a                            # 00437b64
    call FUN_00493a47                            # 00437b69
    test eax, eax                                # 00437b6e
    je.d8 L_00437b7e                             # 00437b70
    # block 0x00437b72: entered by fall-through of je at 0x00437b70, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov eax, dword ptr [ebp - local_4]           # 00437b72
    mov byte ptr [eax + field_25], 0x1           # 00437b75
    jmp.d32 L_00437cf9                           # 00437b79
L_00437b7e:
    # block 0x00437b7e: entered by jne at 0x00437b47; jne at 0x00437b50; jne at 0x00437b59; jne at 0x00437b62; more, 3 instruction(s), ends with jne to 0x00437bbb (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437b7e
    cmp dword ptr [ecx], 0x4d                    # 00437b81
    jne.d8 L_00437bbb                            # 00437b84
    # block 0x00437b86: entered by fall-through of jne at 0x00437b84, 2 instruction(s), ends with jne to 0x00437bbb (forward)
    cmp dword ptr [0x583981], 0xe                # 00437b86
    jne.d8 L_00437bbb                            # 00437b8d
    # block 0x00437b8f: entered by fall-through of jne at 0x00437b8d, 2 instruction(s), ends with jne to 0x00437bbb (forward)
    cmp dword ptr [0x583999], 0x3                # 00437b8f
    jne.d8 L_00437bbb                            # 00437b96
    # block 0x00437b98: entered by fall-through of jne at 0x00437b96, 2 instruction(s), ends with jne to 0x00437bbb (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437b98
    jne.d8 L_00437bbb                            # 00437b9f
    # block 0x00437ba1: entered by fall-through of jne at 0x00437b9f, 4 instruction(s), calls FUN_00493a47, ends with je to 0x00437bbb (forward)
    mov ecx, 0x630a9a                            # 00437ba1
    call FUN_00493a47                            # 00437ba6
    test eax, eax                                # 00437bab
    je.d8 L_00437bbb                             # 00437bad
    # block 0x00437baf: entered by fall-through of je at 0x00437bad, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov edx, dword ptr [ebp - local_4]           # 00437baf
    mov byte ptr [edx + field_26], 0x1           # 00437bb2
    jmp.d32 L_00437cf9                           # 00437bb6
L_00437bbb:
    # block 0x00437bbb: entered by jne at 0x00437b84; jne at 0x00437b8d; jne at 0x00437b96; jne at 0x00437b9f; more, 3 instruction(s), ends with jne to 0x00437c04 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437bbb
    cmp dword ptr [eax], 0x21                    # 00437bbe
    jne.d8 L_00437c04                            # 00437bc1
    # block 0x00437bc3: entered by fall-through of jne at 0x00437bc1, 2 instruction(s), ends with jne to 0x00437c04 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437bc3
    jne.d8 L_00437c04                            # 00437bca
    # block 0x00437bcc: entered by fall-through of jne at 0x00437bca, 2 instruction(s), ends with jne to 0x00437c04 (forward)
    cmp dword ptr [0x583999], 0x3                # 00437bcc
    jne.d8 L_00437c04                            # 00437bd3
    # block 0x00437bd5: entered by fall-through of jne at 0x00437bd3, 2 instruction(s), ends with jne to 0x00437c04 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437bd5
    jne.d8 L_00437c04                            # 00437bdc
    # block 0x00437bde: entered by fall-through of jne at 0x00437bdc, 5 instruction(s), ends with je to 0x00437c04 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437bde
    {load} xor edx, edx                          # 00437be1
    mov dl, byte ptr [ecx + field_4]             # 00437be3
    test edx, edx                                # 00437be6
    je.d8 L_00437c04                             # 00437be8
    # block 0x00437bea: entered by fall-through of je at 0x00437be8, 4 instruction(s), calls FUN_00493a47, ends with je to 0x00437c04 (forward)
    mov ecx, 0x630a9a                            # 00437bea
    call FUN_00493a47                            # 00437bef
    test eax, eax                                # 00437bf4
    je.d8 L_00437c04                             # 00437bf6
    # block 0x00437bf8: entered by fall-through of je at 0x00437bf6, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov eax, dword ptr [ebp - local_4]           # 00437bf8
    mov byte ptr [eax + field_27], 0x1           # 00437bfb
    jmp.d32 L_00437cf9                           # 00437bff
L_00437c04:
    # block 0x00437c04: entered by jne at 0x00437bc1; jne at 0x00437bca; jne at 0x00437bd3; jne at 0x00437bdc; more, 3 instruction(s), ends with jne to 0x00437c4d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437c04
    cmp dword ptr [ecx], 0x22                    # 00437c07
    jne.d8 L_00437c4d                            # 00437c0a
    # block 0x00437c0c: entered by fall-through of jne at 0x00437c0a, 2 instruction(s), ends with jne to 0x00437c4d (forward)
    cmp dword ptr [0x583981], 0xe                # 00437c0c
    jne.d8 L_00437c4d                            # 00437c13
    # block 0x00437c15: entered by fall-through of jne at 0x00437c13, 2 instruction(s), ends with jne to 0x00437c4d (forward)
    cmp dword ptr [0x583999], 0x3                # 00437c15
    jne.d8 L_00437c4d                            # 00437c1c
    # block 0x00437c1e: entered by fall-through of jne at 0x00437c1c, 2 instruction(s), ends with jne to 0x00437c4d (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437c1e
    jne.d8 L_00437c4d                            # 00437c25
    # block 0x00437c27: entered by fall-through of jne at 0x00437c25, 5 instruction(s), ends with je to 0x00437c4d (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437c27
    {load} xor eax, eax                          # 00437c2a
    mov al, byte ptr [edx + field_4]             # 00437c2c
    test eax, eax                                # 00437c2f
    je.d8 L_00437c4d                             # 00437c31
    # block 0x00437c33: entered by fall-through of je at 0x00437c31, 4 instruction(s), calls FUN_00493a47, ends with je to 0x00437c4d (forward)
    mov ecx, 0x630a9a                            # 00437c33
    call FUN_00493a47                            # 00437c38
    test eax, eax                                # 00437c3d
    je.d8 L_00437c4d                             # 00437c3f
    # block 0x00437c41: entered by fall-through of je at 0x00437c3f, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov ecx, dword ptr [ebp - local_4]           # 00437c41
    mov byte ptr [ecx + field_28], 0x1           # 00437c44
    jmp.d32 L_00437cf9                           # 00437c48
L_00437c4d:
    # block 0x00437c4d: entered by jne at 0x00437c0a; jne at 0x00437c13; jne at 0x00437c1c; jne at 0x00437c25; more, 3 instruction(s), ends with jne to 0x00437c93 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437c4d
    cmp dword ptr [edx], 0x24                    # 00437c50
    jne.d8 L_00437c93                            # 00437c53
    # block 0x00437c55: entered by fall-through of jne at 0x00437c53, 2 instruction(s), ends with jne to 0x00437c93 (forward)
    cmp dword ptr [0x583981], 0xe                # 00437c55
    jne.d8 L_00437c93                            # 00437c5c
    # block 0x00437c5e: entered by fall-through of jne at 0x00437c5c, 2 instruction(s), ends with jne to 0x00437c93 (forward)
    cmp dword ptr [0x583999], 0x3                # 00437c5e
    jne.d8 L_00437c93                            # 00437c65
    # block 0x00437c67: entered by fall-through of jne at 0x00437c65, 2 instruction(s), ends with jne to 0x00437c93 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00437c67
    jne.d8 L_00437c93                            # 00437c6e
    # block 0x00437c70: entered by fall-through of jne at 0x00437c6e, 5 instruction(s), ends with je to 0x00437c93 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00437c70
    {load} xor ecx, ecx                          # 00437c73
    mov cl, byte ptr [eax + field_4]             # 00437c75
    test ecx, ecx                                # 00437c78
    je.d8 L_00437c93                             # 00437c7a
    # block 0x00437c7c: entered by fall-through of je at 0x00437c7a, 4 instruction(s), calls FUN_00493a47, ends with je to 0x00437c93 (forward)
    mov ecx, 0x630a9a                            # 00437c7c
    call FUN_00493a47                            # 00437c81
    test eax, eax                                # 00437c86
    je.d8 L_00437c93                             # 00437c88
    # block 0x00437c8a: entered by fall-through of je at 0x00437c88, 3 instruction(s), ends with forward jump to 0x00437cf9
    mov edx, dword ptr [ebp - local_4]           # 00437c8a
    mov byte ptr [edx + field_29], 0x1           # 00437c8d
    jmp.d8 L_00437cf9                            # 00437c91
L_00437c93:
    # block 0x00437c93: entered by jne at 0x00437c53; jne at 0x00437c5c; jne at 0x00437c65; jne at 0x00437c6e; more, 3 instruction(s), ends with jne to 0x00437cf9 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437c93
    cmp dword ptr [eax], 0x9                     # 00437c96
    jne.d8 L_00437cf9                            # 00437c99
    # block 0x00437c9b: entered by fall-through of jne at 0x00437c99, 6 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x00437cf9 (forward)
    push 0x11                                    # 00437c9b
    call dword ptr [0x52a4b8]                    # 00437c9d
    movsx ecx, ax                                # 00437ca3
    and ecx, 0x8000                              # 00437ca6
    test ecx, ecx                                # 00437cac
    je.d8 L_00437cf9                             # 00437cae
    # block 0x00437cb0: entered by fall-through of je at 0x00437cae, 6 instruction(s), calls USER32.dll!GetKeyState, ends with je to 0x00437cf9 (forward)
    push 0x10                                    # 00437cb0
    call dword ptr [0x52a4b8]                    # 00437cb2
    movsx edx, ax                                # 00437cb8
    and edx, 0x8000                              # 00437cbb
    test edx, edx                                # 00437cc1
    je.d8 L_00437cf9                             # 00437cc3
    # block 0x00437cc5: entered by fall-through of je at 0x00437cc3, 5 instruction(s), ends with je to 0x00437ce6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00437cc5
    {load} xor ecx, ecx                          # 00437cc8
    mov cl, byte ptr [eax + field_4]             # 00437cca
    test ecx, ecx                                # 00437ccd
    je.d8 L_00437ce6                             # 00437ccf
    # block 0x00437cd1: entered by fall-through of je at 0x00437ccf, 6 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x00437cf9
    mov edx, dword ptr [ebp - local_4]           # 00437cd1
    mov byte ptr [edx + field_4], 0x0            # 00437cd4
    push 0x14                                    # 00437cd8
    mov ecx, 0x5c3a67                            # 00437cda
    call FUN_004fb2e3                            # 00437cdf
    jmp.d8 L_00437cf9                            # 00437ce4
L_00437ce6:
    # block 0x00437ce6: entered by je at 0x00437ccf, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00437cf9
    mov eax, dword ptr [ebp - local_4]           # 00437ce6
    mov byte ptr [eax + field_4], 0x1            # 00437ce9
    push 0x17                                    # 00437ced
    mov ecx, 0x5c3a67                            # 00437cef
    call FUN_004fb2e3                            # 00437cf4
L_00437cf9:
    # block 0x00437cf9: entered by jmp at 0x004377aa; jmp at 0x00437818; jmp at 0x00437886; jmp at 0x004378f4; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00437cf9
    pop ebp                                      # 00437cfb
    ret 0xc                                      # 00437cfc

