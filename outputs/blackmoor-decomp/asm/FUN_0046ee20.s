# FUN_0046ee20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ee20
# extent:       0x0046ee20-0x0046f4b0 (1680 code bytes)
# span:         0x0046ee20-0x0046f4b0 (code 1680, tables 0, padding 0)
# sha256:       aab2693adcf7722d834145e7fb68c3e67ae735aafe6f8cb35d49f4968d0b7d71
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046ee20
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_87, field_8a; [ecx + n] field_89; [edx + n] field_88, field_8b
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 501 instruction(s), 106 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_87, 0x87  # offset +0x87
.equ field_88, 0x88  # offset +0x88
.equ field_89, 0x89  # offset +0x89
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8b, 0x8b  # offset +0x8b

# --- external targets -----------------------------------------------

.org 0x0046ee20 - 0x401000
.globl FUN_0046ee20
FUN_0046ee20:
    # block 0x0046ee20: entry, 23 instruction(s), ends with jne to 0x0046ee7f (forward)
    push ebp                                     # 0046ee20
    {load} mov ebp, esp                          # 0046ee21
    sub esp, 0x18                                # 0046ee23
    mov dword ptr [ebp - local_18], ecx          # 0046ee26
    mov eax, dword ptr [ebp - local_18]          # 0046ee29
    mov cl, byte ptr [eax + field_87]            # 0046ee2c
    mov byte ptr [ebp - local_4], cl             # 0046ee32
    mov edx, dword ptr [ebp - local_18]          # 0046ee35
    mov al, byte ptr [edx + field_88]            # 0046ee38
    mov byte ptr [ebp - local_8], al             # 0046ee3e
    mov ecx, dword ptr [ebp - local_18]          # 0046ee41
    mov dl, byte ptr [ecx + field_89]            # 0046ee44
    mov byte ptr [ebp - local_c], dl             # 0046ee4a
    mov eax, dword ptr [ebp - local_18]          # 0046ee4d
    mov cl, byte ptr [eax + field_8a]            # 0046ee50
    mov byte ptr [ebp - local_10], cl            # 0046ee56
    mov edx, dword ptr [ebp - local_18]          # 0046ee59
    mov al, byte ptr [edx + field_8b]            # 0046ee5c
    mov byte ptr [ebp - local_14], al            # 0046ee62
    mov ecx, dword ptr [ebp - local_14]          # 0046ee65
    and ecx, 0xff                                # 0046ee68
    test ecx, ecx                                # 0046ee6e
    jne.d8 L_0046ee7f                            # 0046ee70
    # block 0x0046ee72: entered by fall-through of jne at 0x0046ee70, 4 instruction(s), ends with jne to 0x0046ee86 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046ee72
    and edx, 0xff                                # 0046ee75
    test edx, edx                                # 0046ee7b
    jne.d8 L_0046ee86                            # 0046ee7d
L_0046ee7f:
    # block 0x0046ee7f: entered by jne at 0x0046ee70; fall-through of jne at 0x0046ee7d, 2 instruction(s), ends with forward jump to 0x0046f4ac
    {load} xor al, al                            # 0046ee7f
    jmp.d32 L_0046f4ac                           # 0046ee81
L_0046ee86:
    # block 0x0046ee86: entered by jne at 0x0046ee7d, 4 instruction(s), ends with jne to 0x0046eec1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046ee86
    and eax, 0xff                                # 0046ee89
    cmp eax, 0x1                                 # 0046ee8e
    jne.d8 L_0046eec1                            # 0046ee91
    # block 0x0046ee93: entered by fall-through of jne at 0x0046ee91, 4 instruction(s), ends with jne to 0x0046eec1 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046ee93
    and ecx, 0xff                                # 0046ee96
    cmp ecx, 0x2                                 # 0046ee9c
    jne.d8 L_0046eec1                            # 0046ee9f
    # block 0x0046eea1: entered by fall-through of jne at 0x0046ee9f, 4 instruction(s), ends with jne to 0x0046eec1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046eea1
    and edx, 0xff                                # 0046eea4
    test edx, edx                                # 0046eeaa
    jne.d8 L_0046eec1                            # 0046eeac
    # block 0x0046eeae: entered by fall-through of jne at 0x0046eeac, 4 instruction(s), ends with jne to 0x0046eec1 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046eeae
    and eax, 0xff                                # 0046eeb1
    test eax, eax                                # 0046eeb6
    jne.d8 L_0046eec1                            # 0046eeb8
    # block 0x0046eeba: entered by fall-through of jne at 0x0046eeb8, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x61                                 # 0046eeba
    jmp.d32 L_0046f4ac                           # 0046eebc
L_0046eec1:
    # block 0x0046eec1: entered by jne at 0x0046ee91; jne at 0x0046ee9f; jne at 0x0046eeac; jne at 0x0046eeb8, 4 instruction(s), ends with jne to 0x0046eeff (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046eec1
    and ecx, 0xff                                # 0046eec4
    cmp ecx, 0x2                                 # 0046eeca
    jne.d8 L_0046eeff                            # 0046eecd
    # block 0x0046eecf: entered by fall-through of jne at 0x0046eecd, 4 instruction(s), ends with jne to 0x0046eeff (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046eecf
    and edx, 0xff                                # 0046eed2
    cmp edx, 0x1                                 # 0046eed8
    jne.d8 L_0046eeff                            # 0046eedb
    # block 0x0046eedd: entered by fall-through of jne at 0x0046eedb, 4 instruction(s), ends with jne to 0x0046eeff (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046eedd
    and eax, 0xff                                # 0046eee0
    cmp eax, 0x1                                 # 0046eee5
    jne.d8 L_0046eeff                            # 0046eee8
    # block 0x0046eeea: entered by fall-through of jne at 0x0046eee8, 4 instruction(s), ends with jne to 0x0046eeff (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046eeea
    and ecx, 0xff                                # 0046eeed
    cmp ecx, 0x1                                 # 0046eef3
    jne.d8 L_0046eeff                            # 0046eef6
    # block 0x0046eef8: entered by fall-through of jne at 0x0046eef6, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x62                                 # 0046eef8
    jmp.d32 L_0046f4ac                           # 0046eefa
L_0046eeff:
    # block 0x0046eeff: entered by jne at 0x0046eecd; jne at 0x0046eedb; jne at 0x0046eee8; jne at 0x0046eef6, 4 instruction(s), ends with jne to 0x0046ef3d (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046eeff
    and edx, 0xff                                # 0046ef02
    cmp edx, 0x2                                 # 0046ef08
    jne.d8 L_0046ef3d                            # 0046ef0b
    # block 0x0046ef0d: entered by fall-through of jne at 0x0046ef0b, 4 instruction(s), ends with jne to 0x0046ef3d (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046ef0d
    and eax, 0xff                                # 0046ef10
    cmp eax, 0x1                                 # 0046ef15
    jne.d8 L_0046ef3d                            # 0046ef18
    # block 0x0046ef1a: entered by fall-through of jne at 0x0046ef18, 4 instruction(s), ends with jne to 0x0046ef3d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046ef1a
    and ecx, 0xff                                # 0046ef1d
    cmp ecx, 0x2                                 # 0046ef23
    jne.d8 L_0046ef3d                            # 0046ef26
    # block 0x0046ef28: entered by fall-through of jne at 0x0046ef26, 4 instruction(s), ends with jne to 0x0046ef3d (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046ef28
    and edx, 0xff                                # 0046ef2b
    cmp edx, 0x1                                 # 0046ef31
    jne.d8 L_0046ef3d                            # 0046ef34
    # block 0x0046ef36: entered by fall-through of jne at 0x0046ef34, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x63                                 # 0046ef36
    jmp.d32 L_0046f4ac                           # 0046ef38
L_0046ef3d:
    # block 0x0046ef3d: entered by jne at 0x0046ef0b; jne at 0x0046ef18; jne at 0x0046ef26; jne at 0x0046ef34, 4 instruction(s), ends with jne to 0x0046ef79 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046ef3d
    and eax, 0xff                                # 0046ef40
    cmp eax, 0x2                                 # 0046ef45
    jne.d8 L_0046ef79                            # 0046ef48
    # block 0x0046ef4a: entered by fall-through of jne at 0x0046ef48, 4 instruction(s), ends with jne to 0x0046ef79 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046ef4a
    and ecx, 0xff                                # 0046ef4d
    cmp ecx, 0x1                                 # 0046ef53
    jne.d8 L_0046ef79                            # 0046ef56
    # block 0x0046ef58: entered by fall-through of jne at 0x0046ef56, 4 instruction(s), ends with jne to 0x0046ef79 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046ef58
    and edx, 0xff                                # 0046ef5b
    cmp edx, 0x1                                 # 0046ef61
    jne.d8 L_0046ef79                            # 0046ef64
    # block 0x0046ef66: entered by fall-through of jne at 0x0046ef64, 4 instruction(s), ends with jne to 0x0046ef79 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046ef66
    and eax, 0xff                                # 0046ef69
    test eax, eax                                # 0046ef6e
    jne.d8 L_0046ef79                            # 0046ef70
    # block 0x0046ef72: entered by fall-through of jne at 0x0046ef70, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x64                                 # 0046ef72
    jmp.d32 L_0046f4ac                           # 0046ef74
L_0046ef79:
    # block 0x0046ef79: entered by jne at 0x0046ef48; jne at 0x0046ef56; jne at 0x0046ef64; jne at 0x0046ef70, 4 instruction(s), ends with jne to 0x0046efb4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046ef79
    and ecx, 0xff                                # 0046ef7c
    cmp ecx, 0x1                                 # 0046ef82
    jne.d8 L_0046efb4                            # 0046ef85
    # block 0x0046ef87: entered by fall-through of jne at 0x0046ef85, 4 instruction(s), ends with jne to 0x0046efb4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046ef87
    and edx, 0xff                                # 0046ef8a
    test edx, edx                                # 0046ef90
    jne.d8 L_0046efb4                            # 0046ef92
    # block 0x0046ef94: entered by fall-through of jne at 0x0046ef92, 4 instruction(s), ends with jne to 0x0046efb4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046ef94
    and eax, 0xff                                # 0046ef97
    test eax, eax                                # 0046ef9c
    jne.d8 L_0046efb4                            # 0046ef9e
    # block 0x0046efa0: entered by fall-through of jne at 0x0046ef9e, 4 instruction(s), ends with jne to 0x0046efb4 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046efa0
    and ecx, 0xff                                # 0046efa3
    test ecx, ecx                                # 0046efa9
    jne.d8 L_0046efb4                            # 0046efab
    # block 0x0046efad: entered by fall-through of jne at 0x0046efab, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x65                                 # 0046efad
    jmp.d32 L_0046f4ac                           # 0046efaf
L_0046efb4:
    # block 0x0046efb4: entered by jne at 0x0046ef85; jne at 0x0046ef92; jne at 0x0046ef9e; jne at 0x0046efab, 4 instruction(s), ends with jne to 0x0046eff2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046efb4
    and edx, 0xff                                # 0046efb7
    cmp edx, 0x1                                 # 0046efbd
    jne.d8 L_0046eff2                            # 0046efc0
    # block 0x0046efc2: entered by fall-through of jne at 0x0046efc0, 4 instruction(s), ends with jne to 0x0046eff2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046efc2
    and eax, 0xff                                # 0046efc5
    cmp eax, 0x1                                 # 0046efca
    jne.d8 L_0046eff2                            # 0046efcd
    # block 0x0046efcf: entered by fall-through of jne at 0x0046efcd, 4 instruction(s), ends with jne to 0x0046eff2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046efcf
    and ecx, 0xff                                # 0046efd2
    cmp ecx, 0x2                                 # 0046efd8
    jne.d8 L_0046eff2                            # 0046efdb
    # block 0x0046efdd: entered by fall-through of jne at 0x0046efdb, 4 instruction(s), ends with jne to 0x0046eff2 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046efdd
    and edx, 0xff                                # 0046efe0
    cmp edx, 0x1                                 # 0046efe6
    jne.d8 L_0046eff2                            # 0046efe9
    # block 0x0046efeb: entered by fall-through of jne at 0x0046efe9, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x66                                 # 0046efeb
    jmp.d32 L_0046f4ac                           # 0046efed
L_0046eff2:
    # block 0x0046eff2: entered by jne at 0x0046efc0; jne at 0x0046efcd; jne at 0x0046efdb; jne at 0x0046efe9, 4 instruction(s), ends with jne to 0x0046f02e (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046eff2
    and eax, 0xff                                # 0046eff5
    cmp eax, 0x2                                 # 0046effa
    jne.d8 L_0046f02e                            # 0046effd
    # block 0x0046efff: entered by fall-through of jne at 0x0046effd, 4 instruction(s), ends with jne to 0x0046f02e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046efff
    and ecx, 0xff                                # 0046f002
    cmp ecx, 0x2                                 # 0046f008
    jne.d8 L_0046f02e                            # 0046f00b
    # block 0x0046f00d: entered by fall-through of jne at 0x0046f00b, 4 instruction(s), ends with jne to 0x0046f02e (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f00d
    and edx, 0xff                                # 0046f010
    cmp edx, 0x1                                 # 0046f016
    jne.d8 L_0046f02e                            # 0046f019
    # block 0x0046f01b: entered by fall-through of jne at 0x0046f019, 4 instruction(s), ends with jne to 0x0046f02e (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f01b
    and eax, 0xff                                # 0046f01e
    test eax, eax                                # 0046f023
    jne.d8 L_0046f02e                            # 0046f025
    # block 0x0046f027: entered by fall-through of jne at 0x0046f025, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x67                                 # 0046f027
    jmp.d32 L_0046f4ac                           # 0046f029
L_0046f02e:
    # block 0x0046f02e: entered by jne at 0x0046effd; jne at 0x0046f00b; jne at 0x0046f019; jne at 0x0046f025, 4 instruction(s), ends with jne to 0x0046f06c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f02e
    and ecx, 0xff                                # 0046f031
    cmp ecx, 0x1                                 # 0046f037
    jne.d8 L_0046f06c                            # 0046f03a
    # block 0x0046f03c: entered by fall-through of jne at 0x0046f03a, 4 instruction(s), ends with jne to 0x0046f06c (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f03c
    and edx, 0xff                                # 0046f03f
    cmp edx, 0x1                                 # 0046f045
    jne.d8 L_0046f06c                            # 0046f048
    # block 0x0046f04a: entered by fall-through of jne at 0x0046f048, 4 instruction(s), ends with jne to 0x0046f06c (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f04a
    and eax, 0xff                                # 0046f04d
    cmp eax, 0x1                                 # 0046f052
    jne.d8 L_0046f06c                            # 0046f055
    # block 0x0046f057: entered by fall-through of jne at 0x0046f055, 4 instruction(s), ends with jne to 0x0046f06c (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f057
    and ecx, 0xff                                # 0046f05a
    cmp ecx, 0x1                                 # 0046f060
    jne.d8 L_0046f06c                            # 0046f063
    # block 0x0046f065: entered by fall-through of jne at 0x0046f063, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x68                                 # 0046f065
    jmp.d32 L_0046f4ac                           # 0046f067
L_0046f06c:
    # block 0x0046f06c: entered by jne at 0x0046f03a; jne at 0x0046f048; jne at 0x0046f055; jne at 0x0046f063, 4 instruction(s), ends with jne to 0x0046f0a8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f06c
    and edx, 0xff                                # 0046f06f
    cmp edx, 0x1                                 # 0046f075
    jne.d8 L_0046f0a8                            # 0046f078
    # block 0x0046f07a: entered by fall-through of jne at 0x0046f078, 4 instruction(s), ends with jne to 0x0046f0a8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f07a
    and eax, 0xff                                # 0046f07d
    cmp eax, 0x1                                 # 0046f082
    jne.d8 L_0046f0a8                            # 0046f085
    # block 0x0046f087: entered by fall-through of jne at 0x0046f085, 4 instruction(s), ends with jne to 0x0046f0a8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f087
    and ecx, 0xff                                # 0046f08a
    test ecx, ecx                                # 0046f090
    jne.d8 L_0046f0a8                            # 0046f092
    # block 0x0046f094: entered by fall-through of jne at 0x0046f092, 4 instruction(s), ends with jne to 0x0046f0a8 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f094
    and edx, 0xff                                # 0046f097
    test edx, edx                                # 0046f09d
    jne.d8 L_0046f0a8                            # 0046f09f
    # block 0x0046f0a1: entered by fall-through of jne at 0x0046f09f, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x69                                 # 0046f0a1
    jmp.d32 L_0046f4ac                           # 0046f0a3
L_0046f0a8:
    # block 0x0046f0a8: entered by jne at 0x0046f078; jne at 0x0046f085; jne at 0x0046f092; jne at 0x0046f09f, 4 instruction(s), ends with jne to 0x0046f0e5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f0a8
    and eax, 0xff                                # 0046f0ab
    cmp eax, 0x1                                 # 0046f0b0
    jne.d8 L_0046f0e5                            # 0046f0b3
    # block 0x0046f0b5: entered by fall-through of jne at 0x0046f0b3, 4 instruction(s), ends with jne to 0x0046f0e5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f0b5
    and ecx, 0xff                                # 0046f0b8
    cmp ecx, 0x2                                 # 0046f0be
    jne.d8 L_0046f0e5                            # 0046f0c1
    # block 0x0046f0c3: entered by fall-through of jne at 0x0046f0c1, 4 instruction(s), ends with jne to 0x0046f0e5 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f0c3
    and edx, 0xff                                # 0046f0c6
    cmp edx, 0x2                                 # 0046f0cc
    jne.d8 L_0046f0e5                            # 0046f0cf
    # block 0x0046f0d1: entered by fall-through of jne at 0x0046f0cf, 4 instruction(s), ends with jne to 0x0046f0e5 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f0d1
    and eax, 0xff                                # 0046f0d4
    cmp eax, 0x2                                 # 0046f0d9
    jne.d8 L_0046f0e5                            # 0046f0dc
    # block 0x0046f0de: entered by fall-through of jne at 0x0046f0dc, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6a                                 # 0046f0de
    jmp.d32 L_0046f4ac                           # 0046f0e0
L_0046f0e5:
    # block 0x0046f0e5: entered by jne at 0x0046f0b3; jne at 0x0046f0c1; jne at 0x0046f0cf; jne at 0x0046f0dc, 4 instruction(s), ends with jne to 0x0046f122 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f0e5
    and ecx, 0xff                                # 0046f0e8
    cmp ecx, 0x2                                 # 0046f0ee
    jne.d8 L_0046f122                            # 0046f0f1
    # block 0x0046f0f3: entered by fall-through of jne at 0x0046f0f1, 4 instruction(s), ends with jne to 0x0046f122 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f0f3
    and edx, 0xff                                # 0046f0f6
    cmp edx, 0x1                                 # 0046f0fc
    jne.d8 L_0046f122                            # 0046f0ff
    # block 0x0046f101: entered by fall-through of jne at 0x0046f0ff, 4 instruction(s), ends with jne to 0x0046f122 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f101
    and eax, 0xff                                # 0046f104
    cmp eax, 0x2                                 # 0046f109
    jne.d8 L_0046f122                            # 0046f10c
    # block 0x0046f10e: entered by fall-through of jne at 0x0046f10c, 4 instruction(s), ends with jne to 0x0046f122 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f10e
    and ecx, 0xff                                # 0046f111
    test ecx, ecx                                # 0046f117
    jne.d8 L_0046f122                            # 0046f119
    # block 0x0046f11b: entered by fall-through of jne at 0x0046f119, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6b                                 # 0046f11b
    jmp.d32 L_0046f4ac                           # 0046f11d
L_0046f122:
    # block 0x0046f122: entered by jne at 0x0046f0f1; jne at 0x0046f0ff; jne at 0x0046f10c; jne at 0x0046f119, 4 instruction(s), ends with jne to 0x0046f160 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f122
    and edx, 0xff                                # 0046f125
    cmp edx, 0x1                                 # 0046f12b
    jne.d8 L_0046f160                            # 0046f12e
    # block 0x0046f130: entered by fall-through of jne at 0x0046f12e, 4 instruction(s), ends with jne to 0x0046f160 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f130
    and eax, 0xff                                # 0046f133
    cmp eax, 0x2                                 # 0046f138
    jne.d8 L_0046f160                            # 0046f13b
    # block 0x0046f13d: entered by fall-through of jne at 0x0046f13b, 4 instruction(s), ends with jne to 0x0046f160 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f13d
    and ecx, 0xff                                # 0046f140
    cmp ecx, 0x1                                 # 0046f146
    jne.d8 L_0046f160                            # 0046f149
    # block 0x0046f14b: entered by fall-through of jne at 0x0046f149, 4 instruction(s), ends with jne to 0x0046f160 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f14b
    and edx, 0xff                                # 0046f14e
    cmp edx, 0x1                                 # 0046f154
    jne.d8 L_0046f160                            # 0046f157
    # block 0x0046f159: entered by fall-through of jne at 0x0046f157, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6c                                 # 0046f159
    jmp.d32 L_0046f4ac                           # 0046f15b
L_0046f160:
    # block 0x0046f160: entered by jne at 0x0046f12e; jne at 0x0046f13b; jne at 0x0046f149; jne at 0x0046f157, 4 instruction(s), ends with jne to 0x0046f19b (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f160
    and eax, 0xff                                # 0046f163
    cmp eax, 0x2                                 # 0046f168
    jne.d8 L_0046f19b                            # 0046f16b
    # block 0x0046f16d: entered by fall-through of jne at 0x0046f16b, 4 instruction(s), ends with jne to 0x0046f19b (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f16d
    and ecx, 0xff                                # 0046f170
    cmp ecx, 0x2                                 # 0046f176
    jne.d8 L_0046f19b                            # 0046f179
    # block 0x0046f17b: entered by fall-through of jne at 0x0046f179, 4 instruction(s), ends with jne to 0x0046f19b (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f17b
    and edx, 0xff                                # 0046f17e
    test edx, edx                                # 0046f184
    jne.d8 L_0046f19b                            # 0046f186
    # block 0x0046f188: entered by fall-through of jne at 0x0046f186, 4 instruction(s), ends with jne to 0x0046f19b (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f188
    and eax, 0xff                                # 0046f18b
    test eax, eax                                # 0046f190
    jne.d8 L_0046f19b                            # 0046f192
    # block 0x0046f194: entered by fall-through of jne at 0x0046f192, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6d                                 # 0046f194
    jmp.d32 L_0046f4ac                           # 0046f196
L_0046f19b:
    # block 0x0046f19b: entered by jne at 0x0046f16b; jne at 0x0046f179; jne at 0x0046f186; jne at 0x0046f192, 4 instruction(s), ends with jne to 0x0046f1d7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f19b
    and ecx, 0xff                                # 0046f19e
    cmp ecx, 0x2                                 # 0046f1a4
    jne.d8 L_0046f1d7                            # 0046f1a7
    # block 0x0046f1a9: entered by fall-through of jne at 0x0046f1a7, 4 instruction(s), ends with jne to 0x0046f1d7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f1a9
    and edx, 0xff                                # 0046f1ac
    cmp edx, 0x1                                 # 0046f1b2
    jne.d8 L_0046f1d7                            # 0046f1b5
    # block 0x0046f1b7: entered by fall-through of jne at 0x0046f1b5, 4 instruction(s), ends with jne to 0x0046f1d7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f1b7
    and eax, 0xff                                # 0046f1ba
    test eax, eax                                # 0046f1bf
    jne.d8 L_0046f1d7                            # 0046f1c1
    # block 0x0046f1c3: entered by fall-through of jne at 0x0046f1c1, 4 instruction(s), ends with jne to 0x0046f1d7 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f1c3
    and ecx, 0xff                                # 0046f1c6
    test ecx, ecx                                # 0046f1cc
    jne.d8 L_0046f1d7                            # 0046f1ce
    # block 0x0046f1d0: entered by fall-through of jne at 0x0046f1ce, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6e                                 # 0046f1d0
    jmp.d32 L_0046f4ac                           # 0046f1d2
L_0046f1d7:
    # block 0x0046f1d7: entered by jne at 0x0046f1a7; jne at 0x0046f1b5; jne at 0x0046f1c1; jne at 0x0046f1ce, 4 instruction(s), ends with jne to 0x0046f214 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f1d7
    and edx, 0xff                                # 0046f1da
    cmp edx, 0x2                                 # 0046f1e0
    jne.d8 L_0046f214                            # 0046f1e3
    # block 0x0046f1e5: entered by fall-through of jne at 0x0046f1e3, 4 instruction(s), ends with jne to 0x0046f214 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f1e5
    and eax, 0xff                                # 0046f1e8
    cmp eax, 0x2                                 # 0046f1ed
    jne.d8 L_0046f214                            # 0046f1f0
    # block 0x0046f1f2: entered by fall-through of jne at 0x0046f1f0, 4 instruction(s), ends with jne to 0x0046f214 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f1f2
    and ecx, 0xff                                # 0046f1f5
    cmp ecx, 0x2                                 # 0046f1fb
    jne.d8 L_0046f214                            # 0046f1fe
    # block 0x0046f200: entered by fall-through of jne at 0x0046f1fe, 4 instruction(s), ends with jne to 0x0046f214 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f200
    and edx, 0xff                                # 0046f203
    test edx, edx                                # 0046f209
    jne.d8 L_0046f214                            # 0046f20b
    # block 0x0046f20d: entered by fall-through of jne at 0x0046f20b, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x6f                                 # 0046f20d
    jmp.d32 L_0046f4ac                           # 0046f20f
L_0046f214:
    # block 0x0046f214: entered by jne at 0x0046f1e3; jne at 0x0046f1f0; jne at 0x0046f1fe; jne at 0x0046f20b, 4 instruction(s), ends with jne to 0x0046f251 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f214
    and eax, 0xff                                # 0046f217
    cmp eax, 0x1                                 # 0046f21c
    jne.d8 L_0046f251                            # 0046f21f
    # block 0x0046f221: entered by fall-through of jne at 0x0046f21f, 4 instruction(s), ends with jne to 0x0046f251 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f221
    and ecx, 0xff                                # 0046f224
    cmp ecx, 0x2                                 # 0046f22a
    jne.d8 L_0046f251                            # 0046f22d
    # block 0x0046f22f: entered by fall-through of jne at 0x0046f22d, 4 instruction(s), ends with jne to 0x0046f251 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f22f
    and edx, 0xff                                # 0046f232
    cmp edx, 0x2                                 # 0046f238
    jne.d8 L_0046f251                            # 0046f23b
    # block 0x0046f23d: entered by fall-through of jne at 0x0046f23b, 4 instruction(s), ends with jne to 0x0046f251 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f23d
    and eax, 0xff                                # 0046f240
    cmp eax, 0x1                                 # 0046f245
    jne.d8 L_0046f251                            # 0046f248
    # block 0x0046f24a: entered by fall-through of jne at 0x0046f248, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x70                                 # 0046f24a
    jmp.d32 L_0046f4ac                           # 0046f24c
L_0046f251:
    # block 0x0046f251: entered by jne at 0x0046f21f; jne at 0x0046f22d; jne at 0x0046f23b; jne at 0x0046f248, 4 instruction(s), ends with jne to 0x0046f28f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f251
    and ecx, 0xff                                # 0046f254
    cmp ecx, 0x2                                 # 0046f25a
    jne.d8 L_0046f28f                            # 0046f25d
    # block 0x0046f25f: entered by fall-through of jne at 0x0046f25d, 4 instruction(s), ends with jne to 0x0046f28f (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f25f
    and edx, 0xff                                # 0046f262
    cmp edx, 0x2                                 # 0046f268
    jne.d8 L_0046f28f                            # 0046f26b
    # block 0x0046f26d: entered by fall-through of jne at 0x0046f26b, 4 instruction(s), ends with jne to 0x0046f28f (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f26d
    and eax, 0xff                                # 0046f270
    cmp eax, 0x1                                 # 0046f275
    jne.d8 L_0046f28f                            # 0046f278
    # block 0x0046f27a: entered by fall-through of jne at 0x0046f278, 4 instruction(s), ends with jne to 0x0046f28f (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f27a
    and ecx, 0xff                                # 0046f27d
    cmp ecx, 0x2                                 # 0046f283
    jne.d8 L_0046f28f                            # 0046f286
    # block 0x0046f288: entered by fall-through of jne at 0x0046f286, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x71                                 # 0046f288
    jmp.d32 L_0046f4ac                           # 0046f28a
L_0046f28f:
    # block 0x0046f28f: entered by jne at 0x0046f25d; jne at 0x0046f26b; jne at 0x0046f278; jne at 0x0046f286, 4 instruction(s), ends with jne to 0x0046f2cc (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f28f
    and edx, 0xff                                # 0046f292
    cmp edx, 0x1                                 # 0046f298
    jne.d8 L_0046f2cc                            # 0046f29b
    # block 0x0046f29d: entered by fall-through of jne at 0x0046f29b, 4 instruction(s), ends with jne to 0x0046f2cc (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f29d
    and eax, 0xff                                # 0046f2a0
    cmp eax, 0x2                                 # 0046f2a5
    jne.d8 L_0046f2cc                            # 0046f2a8
    # block 0x0046f2aa: entered by fall-through of jne at 0x0046f2a8, 4 instruction(s), ends with jne to 0x0046f2cc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f2aa
    and ecx, 0xff                                # 0046f2ad
    cmp ecx, 0x1                                 # 0046f2b3
    jne.d8 L_0046f2cc                            # 0046f2b6
    # block 0x0046f2b8: entered by fall-through of jne at 0x0046f2b6, 4 instruction(s), ends with jne to 0x0046f2cc (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f2b8
    and edx, 0xff                                # 0046f2bb
    test edx, edx                                # 0046f2c1
    jne.d8 L_0046f2cc                            # 0046f2c3
    # block 0x0046f2c5: entered by fall-through of jne at 0x0046f2c3, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x72                                 # 0046f2c5
    jmp.d32 L_0046f4ac                           # 0046f2c7
L_0046f2cc:
    # block 0x0046f2cc: entered by jne at 0x0046f29b; jne at 0x0046f2a8; jne at 0x0046f2b6; jne at 0x0046f2c3, 4 instruction(s), ends with jne to 0x0046f308 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f2cc
    and eax, 0xff                                # 0046f2cf
    cmp eax, 0x1                                 # 0046f2d4
    jne.d8 L_0046f308                            # 0046f2d7
    # block 0x0046f2d9: entered by fall-through of jne at 0x0046f2d7, 4 instruction(s), ends with jne to 0x0046f308 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f2d9
    and ecx, 0xff                                # 0046f2dc
    cmp ecx, 0x1                                 # 0046f2e2
    jne.d8 L_0046f308                            # 0046f2e5
    # block 0x0046f2e7: entered by fall-through of jne at 0x0046f2e5, 4 instruction(s), ends with jne to 0x0046f308 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f2e7
    and edx, 0xff                                # 0046f2ea
    cmp edx, 0x1                                 # 0046f2f0
    jne.d8 L_0046f308                            # 0046f2f3
    # block 0x0046f2f5: entered by fall-through of jne at 0x0046f2f3, 4 instruction(s), ends with jne to 0x0046f308 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f2f5
    and eax, 0xff                                # 0046f2f8
    test eax, eax                                # 0046f2fd
    jne.d8 L_0046f308                            # 0046f2ff
    # block 0x0046f301: entered by fall-through of jne at 0x0046f2ff, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x73                                 # 0046f301
    jmp.d32 L_0046f4ac                           # 0046f303
L_0046f308:
    # block 0x0046f308: entered by jne at 0x0046f2d7; jne at 0x0046f2e5; jne at 0x0046f2f3; jne at 0x0046f2ff, 4 instruction(s), ends with jne to 0x0046f343 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f308
    and ecx, 0xff                                # 0046f30b
    cmp ecx, 0x2                                 # 0046f311
    jne.d8 L_0046f343                            # 0046f314
    # block 0x0046f316: entered by fall-through of jne at 0x0046f314, 4 instruction(s), ends with jne to 0x0046f343 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f316
    and edx, 0xff                                # 0046f319
    test edx, edx                                # 0046f31f
    jne.d8 L_0046f343                            # 0046f321
    # block 0x0046f323: entered by fall-through of jne at 0x0046f321, 4 instruction(s), ends with jne to 0x0046f343 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f323
    and eax, 0xff                                # 0046f326
    test eax, eax                                # 0046f32b
    jne.d8 L_0046f343                            # 0046f32d
    # block 0x0046f32f: entered by fall-through of jne at 0x0046f32d, 4 instruction(s), ends with jne to 0x0046f343 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f32f
    and ecx, 0xff                                # 0046f332
    test ecx, ecx                                # 0046f338
    jne.d8 L_0046f343                            # 0046f33a
    # block 0x0046f33c: entered by fall-through of jne at 0x0046f33a, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x74                                 # 0046f33c
    jmp.d32 L_0046f4ac                           # 0046f33e
L_0046f343:
    # block 0x0046f343: entered by jne at 0x0046f314; jne at 0x0046f321; jne at 0x0046f32d; jne at 0x0046f33a, 4 instruction(s), ends with jne to 0x0046f380 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f343
    and edx, 0xff                                # 0046f346
    cmp edx, 0x1                                 # 0046f34c
    jne.d8 L_0046f380                            # 0046f34f
    # block 0x0046f351: entered by fall-through of jne at 0x0046f34f, 4 instruction(s), ends with jne to 0x0046f380 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f351
    and eax, 0xff                                # 0046f354
    cmp eax, 0x1                                 # 0046f359
    jne.d8 L_0046f380                            # 0046f35c
    # block 0x0046f35e: entered by fall-through of jne at 0x0046f35c, 4 instruction(s), ends with jne to 0x0046f380 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f35e
    and ecx, 0xff                                # 0046f361
    cmp ecx, 0x2                                 # 0046f367
    jne.d8 L_0046f380                            # 0046f36a
    # block 0x0046f36c: entered by fall-through of jne at 0x0046f36a, 4 instruction(s), ends with jne to 0x0046f380 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f36c
    and edx, 0xff                                # 0046f36f
    test edx, edx                                # 0046f375
    jne.d8 L_0046f380                            # 0046f377
    # block 0x0046f379: entered by fall-through of jne at 0x0046f377, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x75                                 # 0046f379
    jmp.d32 L_0046f4ac                           # 0046f37b
L_0046f380:
    # block 0x0046f380: entered by jne at 0x0046f34f; jne at 0x0046f35c; jne at 0x0046f36a; jne at 0x0046f377, 4 instruction(s), ends with jne to 0x0046f3bd (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f380
    and eax, 0xff                                # 0046f383
    cmp eax, 0x1                                 # 0046f388
    jne.d8 L_0046f3bd                            # 0046f38b
    # block 0x0046f38d: entered by fall-through of jne at 0x0046f38b, 4 instruction(s), ends with jne to 0x0046f3bd (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f38d
    and ecx, 0xff                                # 0046f390
    cmp ecx, 0x1                                 # 0046f396
    jne.d8 L_0046f3bd                            # 0046f399
    # block 0x0046f39b: entered by fall-through of jne at 0x0046f399, 4 instruction(s), ends with jne to 0x0046f3bd (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f39b
    and edx, 0xff                                # 0046f39e
    cmp edx, 0x1                                 # 0046f3a4
    jne.d8 L_0046f3bd                            # 0046f3a7
    # block 0x0046f3a9: entered by fall-through of jne at 0x0046f3a7, 4 instruction(s), ends with jne to 0x0046f3bd (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f3a9
    and eax, 0xff                                # 0046f3ac
    cmp eax, 0x2                                 # 0046f3b1
    jne.d8 L_0046f3bd                            # 0046f3b4
    # block 0x0046f3b6: entered by fall-through of jne at 0x0046f3b4, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x76                                 # 0046f3b6
    jmp.d32 L_0046f4ac                           # 0046f3b8
L_0046f3bd:
    # block 0x0046f3bd: entered by jne at 0x0046f38b; jne at 0x0046f399; jne at 0x0046f3a7; jne at 0x0046f3b4, 4 instruction(s), ends with jne to 0x0046f3fa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f3bd
    and ecx, 0xff                                # 0046f3c0
    cmp ecx, 0x1                                 # 0046f3c6
    jne.d8 L_0046f3fa                            # 0046f3c9
    # block 0x0046f3cb: entered by fall-through of jne at 0x0046f3c9, 4 instruction(s), ends with jne to 0x0046f3fa (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f3cb
    and edx, 0xff                                # 0046f3ce
    cmp edx, 0x2                                 # 0046f3d4
    jne.d8 L_0046f3fa                            # 0046f3d7
    # block 0x0046f3d9: entered by fall-through of jne at 0x0046f3d7, 4 instruction(s), ends with jne to 0x0046f3fa (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f3d9
    and eax, 0xff                                # 0046f3dc
    cmp eax, 0x2                                 # 0046f3e1
    jne.d8 L_0046f3fa                            # 0046f3e4
    # block 0x0046f3e6: entered by fall-through of jne at 0x0046f3e4, 4 instruction(s), ends with jne to 0x0046f3fa (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f3e6
    and ecx, 0xff                                # 0046f3e9
    test ecx, ecx                                # 0046f3ef
    jne.d8 L_0046f3fa                            # 0046f3f1
    # block 0x0046f3f3: entered by fall-through of jne at 0x0046f3f1, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x77                                 # 0046f3f3
    jmp.d32 L_0046f4ac                           # 0046f3f5
L_0046f3fa:
    # block 0x0046f3fa: entered by jne at 0x0046f3c9; jne at 0x0046f3d7; jne at 0x0046f3e4; jne at 0x0046f3f1, 4 instruction(s), ends with jne to 0x0046f435 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046f3fa
    and edx, 0xff                                # 0046f3fd
    cmp edx, 0x2                                 # 0046f403
    jne.d8 L_0046f435                            # 0046f406
    # block 0x0046f408: entered by fall-through of jne at 0x0046f406, 4 instruction(s), ends with jne to 0x0046f435 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046f408
    and eax, 0xff                                # 0046f40b
    cmp eax, 0x1                                 # 0046f410
    jne.d8 L_0046f435                            # 0046f413
    # block 0x0046f415: entered by fall-through of jne at 0x0046f413, 4 instruction(s), ends with jne to 0x0046f435 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f415
    and ecx, 0xff                                # 0046f418
    cmp ecx, 0x1                                 # 0046f41e
    jne.d8 L_0046f435                            # 0046f421
    # block 0x0046f423: entered by fall-through of jne at 0x0046f421, 4 instruction(s), ends with jne to 0x0046f435 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f423
    and edx, 0xff                                # 0046f426
    cmp edx, 0x2                                 # 0046f42c
    jne.d8 L_0046f435                            # 0046f42f
    # block 0x0046f431: entered by fall-through of jne at 0x0046f42f, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x78                                 # 0046f431
    jmp.d8 L_0046f4ac                            # 0046f433
L_0046f435:
    # block 0x0046f435: entered by jne at 0x0046f406; jne at 0x0046f413; jne at 0x0046f421; jne at 0x0046f42f, 4 instruction(s), ends with jne to 0x0046f46f (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046f435
    and eax, 0xff                                # 0046f438
    cmp eax, 0x2                                 # 0046f43d
    jne.d8 L_0046f46f                            # 0046f440
    # block 0x0046f442: entered by fall-through of jne at 0x0046f440, 4 instruction(s), ends with jne to 0x0046f46f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046f442
    and ecx, 0xff                                # 0046f445
    cmp ecx, 0x1                                 # 0046f44b
    jne.d8 L_0046f46f                            # 0046f44e
    # block 0x0046f450: entered by fall-through of jne at 0x0046f44e, 4 instruction(s), ends with jne to 0x0046f46f (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046f450
    and edx, 0xff                                # 0046f453
    cmp edx, 0x2                                 # 0046f459
    jne.d8 L_0046f46f                            # 0046f45c
    # block 0x0046f45e: entered by fall-through of jne at 0x0046f45c, 4 instruction(s), ends with jne to 0x0046f46f (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f45e
    and eax, 0xff                                # 0046f461
    cmp eax, 0x2                                 # 0046f466
    jne.d8 L_0046f46f                            # 0046f469
    # block 0x0046f46b: entered by fall-through of jne at 0x0046f469, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x79                                 # 0046f46b
    jmp.d8 L_0046f4ac                            # 0046f46d
L_0046f46f:
    # block 0x0046f46f: entered by jne at 0x0046f440; jne at 0x0046f44e; jne at 0x0046f45c; jne at 0x0046f469, 4 instruction(s), ends with jne to 0x0046f4aa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046f46f
    and ecx, 0xff                                # 0046f472
    cmp ecx, 0x2                                 # 0046f478
    jne.d8 L_0046f4aa                            # 0046f47b
    # block 0x0046f47d: entered by fall-through of jne at 0x0046f47b, 4 instruction(s), ends with jne to 0x0046f4aa (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046f47d
    and edx, 0xff                                # 0046f480
    cmp edx, 0x2                                 # 0046f486
    jne.d8 L_0046f4aa                            # 0046f489
    # block 0x0046f48b: entered by fall-through of jne at 0x0046f489, 4 instruction(s), ends with jne to 0x0046f4aa (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046f48b
    and eax, 0xff                                # 0046f48e
    cmp eax, 0x1                                 # 0046f493
    jne.d8 L_0046f4aa                            # 0046f496
    # block 0x0046f498: entered by fall-through of jne at 0x0046f496, 4 instruction(s), ends with jne to 0x0046f4aa (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f498
    and ecx, 0xff                                # 0046f49b
    cmp ecx, 0x1                                 # 0046f4a1
    jne.d8 L_0046f4aa                            # 0046f4a4
    # block 0x0046f4a6: entered by fall-through of jne at 0x0046f4a4, 2 instruction(s), ends with forward jump to 0x0046f4ac
    mov al, 0x7a                                 # 0046f4a6
    jmp.d8 L_0046f4ac                            # 0046f4a8
L_0046f4aa:
    # block 0x0046f4aa: entered by jne at 0x0046f47b; jne at 0x0046f489; jne at 0x0046f496; jne at 0x0046f4a4, 1 instruction(s), falls into the block at 0x0046f4ac
    {load} xor al, al                            # 0046f4aa
L_0046f4ac:
    # block 0x0046f4ac: entered by jmp at 0x0046ee81; jmp at 0x0046eebc; jmp at 0x0046eefa; jmp at 0x0046ef38; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046f4ac
    pop ebp                                      # 0046f4ae
    ret                                          # 0046f4af

