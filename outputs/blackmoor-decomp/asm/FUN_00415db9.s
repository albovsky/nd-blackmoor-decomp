# FUN_00415db9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415db9
# extent:       0x00415db9-0x0041608b (722 code bytes)
# span:         0x00415db9-0x0041608b (code 722, tables 0, padding 0)
# sha256:       78599b1a90603040c67e238dc3df985540abbf9ea86823fa19c5994bab43c9dc
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00415db9
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_103c, local_1040 and 6 more
# fields:       [eax + n] field_21, field_2d, field_39; [ecx + n] field_2, field_35
# callees:      calls FUN_0050c920
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:avf_lzss_expand (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 202 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_103c, 0x103c  # offset -0x103c
.equ local_1040, 0x1040  # offset -0x1040
.equ local_1044, 0x1044  # offset -0x1044
.equ local_1048, 0x1048  # offset -0x1048
.equ local_104c, 0x104c  # offset -0x104c
.equ local_1050, 0x1050  # offset -0x1050
.equ local_1054, 0x1054  # offset -0x1054
.equ local_1058, 0x1058  # offset -0x1058
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_2d, 0x2d  # offset +0x2d
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00415db9 - 0x401000
.globl FUN_00415db9
FUN_00415db9:
    # block 0x00415db9: entry, 42 instruction(s), calls FUN_0050c920, falls into the block at 0x00415e67
    push ebp                                     # 00415db9
    {load} mov ebp, esp                          # 00415dba
    mov eax, 0x1058                              # 00415dbc
    call FUN_0050c920                            # 00415dc1
    push edi                                     # 00415dc6
    mov dword ptr [ebp - local_1058], ecx        # 00415dc7
    mov eax, dword ptr [ebp + arg_8]             # 00415dcd
    mov ecx, dword ptr [eax + field_39]          # 00415dd0
    mov dword ptr [ebp - local_1050], ecx        # 00415dd3
    movsx edx, word ptr [ebp + arg_c]            # 00415dd9
    imul edx, edx, 0x13                          # 00415ddd
    mov eax, dword ptr [ebp + arg_8]             # 00415de0
    mov ecx, dword ptr [eax + field_21]          # 00415de3
    mov eax, dword ptr [ebp + arg_8]             # 00415de6
    mov eax, dword ptr [eax + field_2d]          # 00415de9
    add eax, dword ptr [ecx + edx + field_2]     # 00415dec
    mov dword ptr [ebp - local_1c], eax          # 00415df0
    mov ecx, dword ptr [ebp + arg_8]             # 00415df3
    mov edx, dword ptr [ecx + field_35]          # 00415df6
    mov dword ptr [ebp - local_1054], edx        # 00415df9
    lea eax, [ebp - local_103c]                  # 00415dff
    mov dword ptr [ebp - local_14], eax          # 00415e05
    mov byte ptr [ebp - local_10], 0x0           # 00415e08
    mov dword ptr [ebp - local_18], 0x0          # 00415e0c
    mov dword ptr [ebp - local_24], 0xffffffff   # 00415e13
    mov dword ptr [ebp - local_1048], 0x1000     # 00415e1a
    mov dword ptr [ebp - local_c], 0x12          # 00415e24
    mov dword ptr [ebp - local_20], 0x2          # 00415e2b
    mov ecx, dword ptr [ebp - local_1048]        # 00415e32
    sub ecx, dword ptr [ebp - local_c]           # 00415e38
    mov eax, 0x20202020                          # 00415e3b
    lea edi, [ebp - local_103c]                  # 00415e40
    {load} mov edx, ecx                          # 00415e46
    shr ecx, 0x2                                 # 00415e48
    rep stosd dword ptr es:[edi], eax            # 00415e4b
    {load} mov ecx, edx                          # 00415e4d
    and ecx, 0x3                                 # 00415e4f
    rep stosb byte ptr es:[edi], al              # 00415e52
    mov eax, dword ptr [ebp - local_1048]        # 00415e54
    sub eax, dword ptr [ebp - local_c]           # 00415e5a
    mov dword ptr [ebp - local_8], eax           # 00415e5d
    mov dword ptr [ebp - local_4], 0x0           # 00415e60
L_00415e67:
    # block 0x00415e67: entered by jmp at 0x0041607f, 7 instruction(s), ends with jne to 0x00415ec0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00415e67
    shr ecx                                      # 00415e6a
    mov dword ptr [ebp - local_4], ecx           # 00415e6c
    mov edx, dword ptr [ebp - local_4]           # 00415e6f
    and edx, 0x100                               # 00415e72
    test edx, edx                                # 00415e78
    jne.d8 L_00415ec0                            # 00415e7a
    # block 0x00415e7c: entered by fall-through of jne at 0x00415e7a, 6 instruction(s), ends with jne to 0x00415e95 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00415e7c
    add eax, 0x1                                 # 00415e7f
    mov dword ptr [ebp - local_24], eax          # 00415e82
    mov ecx, dword ptr [ebp - local_24]          # 00415e85
    cmp ecx, dword ptr [ebp - local_1050]        # 00415e88
    jne.d8 L_00415e95                            # 00415e8e
    # block 0x00415e90: entered by fall-through of jne at 0x00415e8e, 1 instruction(s), ends with forward jump to 0x00416084
    jmp.d32 L_00416084                           # 00415e90
L_00415e95:
    # block 0x00415e95: entered by jne at 0x00415e8e, 14 instruction(s), falls into the block at 0x00415ec0
    mov edx, dword ptr [ebp - local_1c]          # 00415e95
    add edx, dword ptr [ebp - local_24]          # 00415e98
    mov al, byte ptr [edx]                       # 00415e9b
    mov byte ptr [ebp - local_28], al            # 00415e9d
    mov cl, byte ptr [ebp - local_28]            # 00415ea0
    sub cl, byte ptr [ebp - local_10]            # 00415ea3
    mov byte ptr [ebp - local_28], cl            # 00415ea6
    mov dl, byte ptr [ebp - local_10]            # 00415ea9
    add dl, 0x1                                  # 00415eac
    mov byte ptr [ebp - local_10], dl            # 00415eaf
    mov eax, dword ptr [ebp - local_28]          # 00415eb2
    and eax, 0xff                                # 00415eb5
    or ah, -0x1                                  # 00415eba
    mov dword ptr [ebp - local_4], eax           # 00415ebd
L_00415ec0:
    # block 0x00415ec0: entered by jne at 0x00415e7a, 4 instruction(s), ends with je to 0x00415f41 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00415ec0
    and ecx, 0x1                                 # 00415ec3
    test ecx, ecx                                # 00415ec6
    je.d8 L_00415f41                             # 00415ec8
    # block 0x00415eca: entered by fall-through of je at 0x00415ec8, 6 instruction(s), ends with jne to 0x00415ee3 (forward)
    mov edx, dword ptr [ebp - local_24]          # 00415eca
    add edx, 0x1                                 # 00415ecd
    mov dword ptr [ebp - local_24], edx          # 00415ed0
    mov eax, dword ptr [ebp - local_24]          # 00415ed3
    cmp eax, dword ptr [ebp - local_1050]        # 00415ed6
    jne.d8 L_00415ee3                            # 00415edc
    # block 0x00415ede: entered by fall-through of jne at 0x00415edc, 1 instruction(s), ends with forward jump to 0x00416084
    jmp.d32 L_00416084                           # 00415ede
L_00415ee3:
    # block 0x00415ee3: entered by jne at 0x00415edc, 30 instruction(s), ends with forward jump to 0x0041607f
    mov ecx, dword ptr [ebp - local_1c]          # 00415ee3
    add ecx, dword ptr [ebp - local_24]          # 00415ee6
    mov dl, byte ptr [ecx]                       # 00415ee9
    mov byte ptr [ebp - local_28], dl            # 00415eeb
    mov al, byte ptr [ebp - local_28]            # 00415eee
    sub al, byte ptr [ebp - local_10]            # 00415ef1
    mov byte ptr [ebp - local_28], al            # 00415ef4
    mov cl, byte ptr [ebp - local_10]            # 00415ef7
    add cl, 0x1                                  # 00415efa
    mov byte ptr [ebp - local_10], cl            # 00415efd
    mov edx, dword ptr [ebp - local_1054]        # 00415f00
    add edx, dword ptr [ebp - local_18]          # 00415f06
    mov al, byte ptr [ebp - local_28]            # 00415f09
    mov byte ptr [edx], al                       # 00415f0c
    mov ecx, dword ptr [ebp - local_18]          # 00415f0e
    add ecx, 0x1                                 # 00415f11
    mov dword ptr [ebp - local_18], ecx          # 00415f14
    mov edx, dword ptr [ebp - local_14]          # 00415f17
    add edx, dword ptr [ebp - local_8]           # 00415f1a
    mov al, byte ptr [ebp - local_28]            # 00415f1d
    mov byte ptr [edx], al                       # 00415f20
    mov ecx, dword ptr [ebp - local_8]           # 00415f22
    add ecx, 0x1                                 # 00415f25
    mov dword ptr [ebp - local_8], ecx           # 00415f28
    mov edx, dword ptr [ebp - local_1048]        # 00415f2b
    sub edx, 0x1                                 # 00415f31
    mov eax, dword ptr [ebp - local_8]           # 00415f34
    {load} and eax, edx                          # 00415f37
    mov dword ptr [ebp - local_8], eax           # 00415f39
    jmp.d32 L_0041607f                           # 00415f3c
L_00415f41:
    # block 0x00415f41: entered by je at 0x00415ec8, 6 instruction(s), ends with jne to 0x00415f5a (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00415f41
    add ecx, 0x1                                 # 00415f44
    mov dword ptr [ebp - local_24], ecx          # 00415f47
    mov edx, dword ptr [ebp - local_24]          # 00415f4a
    cmp edx, dword ptr [ebp - local_1050]        # 00415f4d
    jne.d8 L_00415f5a                            # 00415f53
    # block 0x00415f55: entered by fall-through of jne at 0x00415f53, 1 instruction(s), ends with forward jump to 0x00416084
    jmp.d32 L_00416084                           # 00415f55
L_00415f5a:
    # block 0x00415f5a: entered by jne at 0x00415f53, 19 instruction(s), ends with jne to 0x00415f9e (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00415f5a
    add eax, dword ptr [ebp - local_24]          # 00415f5d
    mov cl, byte ptr [eax]                       # 00415f60
    mov byte ptr [ebp - local_28], cl            # 00415f62
    mov dl, byte ptr [ebp - local_28]            # 00415f65
    sub dl, byte ptr [ebp - local_10]            # 00415f68
    mov byte ptr [ebp - local_28], dl            # 00415f6b
    mov al, byte ptr [ebp - local_10]            # 00415f6e
    add al, 0x1                                  # 00415f71
    mov byte ptr [ebp - local_10], al            # 00415f73
    mov ecx, dword ptr [ebp - local_28]          # 00415f76
    and ecx, 0xff                                # 00415f79
    mov dword ptr [ebp - local_1040], ecx        # 00415f7f
    mov edx, dword ptr [ebp - local_24]          # 00415f85
    add edx, 0x1                                 # 00415f88
    mov dword ptr [ebp - local_24], edx          # 00415f8b
    mov eax, dword ptr [ebp - local_24]          # 00415f8e
    cmp eax, dword ptr [ebp - local_1050]        # 00415f91
    jne.d8 L_00415f9e                            # 00415f97
    # block 0x00415f99: entered by fall-through of jne at 0x00415f97, 1 instruction(s), ends with forward jump to 0x00416084
    jmp.d32 L_00416084                           # 00415f99
L_00415f9e:
    # block 0x00415f9e: entered by jne at 0x00415f97, 25 instruction(s), ends with forward jump to 0x00416013
    mov ecx, dword ptr [ebp - local_1c]          # 00415f9e
    add ecx, dword ptr [ebp - local_24]          # 00415fa1
    mov dl, byte ptr [ecx]                       # 00415fa4
    mov byte ptr [ebp - local_28], dl            # 00415fa6
    mov al, byte ptr [ebp - local_28]            # 00415fa9
    sub al, byte ptr [ebp - local_10]            # 00415fac
    mov byte ptr [ebp - local_28], al            # 00415faf
    mov cl, byte ptr [ebp - local_10]            # 00415fb2
    add cl, 0x1                                  # 00415fb5
    mov byte ptr [ebp - local_10], cl            # 00415fb8
    mov edx, dword ptr [ebp - local_28]          # 00415fbb
    and edx, 0xff                                # 00415fbe
    mov dword ptr [ebp - local_1044], edx        # 00415fc4
    mov eax, dword ptr [ebp - local_1044]        # 00415fca
    and eax, 0xf0                                # 00415fd0
    shl eax, 0x4                                 # 00415fd5
    mov ecx, dword ptr [ebp - local_1040]        # 00415fd8
    {load} or ecx, eax                           # 00415fde
    mov dword ptr [ebp - local_1040], ecx        # 00415fe0
    mov edx, dword ptr [ebp - local_1044]        # 00415fe6
    and edx, 0xf                                 # 00415fec
    add edx, dword ptr [ebp - local_20]          # 00415fef
    mov dword ptr [ebp - local_1044], edx        # 00415ff2
    mov dword ptr [ebp - local_104c], 0x0        # 00415ff8
    jmp.d8 L_00416013                            # 00416002
L_00416004:
    # block 0x00416004: entered by jmp at 0x0041607d, 3 instruction(s), falls into the block at 0x00416013
    mov eax, dword ptr [ebp - local_104c]        # 00416004
    add eax, 0x1                                 # 0041600a
    mov dword ptr [ebp - local_104c], eax        # 0041600d
L_00416013:
    # block 0x00416013: entered by jmp at 0x00416002, 3 instruction(s), ends with ja to 0x0041607f (forward)
    mov ecx, dword ptr [ebp - local_104c]        # 00416013
    cmp ecx, dword ptr [ebp - local_1044]        # 00416019
    ja.d8 L_0041607f                             # 0041601f
    # block 0x00416021: entered by fall-through of ja at 0x0041601f, 28 instruction(s), ends with backward jump to 0x00416004
    mov edx, dword ptr [ebp - local_1040]        # 00416021
    add edx, dword ptr [ebp - local_104c]        # 00416027
    mov eax, dword ptr [ebp - local_1048]        # 0041602d
    sub eax, 0x1                                 # 00416033
    {load} and edx, eax                          # 00416036
    mov ecx, dword ptr [ebp - local_14]          # 00416038
    mov dl, byte ptr [ecx + edx]                 # 0041603b
    mov byte ptr [ebp - local_28], dl            # 0041603e
    mov eax, dword ptr [ebp - local_1054]        # 00416041
    add eax, dword ptr [ebp - local_18]          # 00416047
    mov cl, byte ptr [ebp - local_28]            # 0041604a
    mov byte ptr [eax], cl                       # 0041604d
    mov edx, dword ptr [ebp - local_18]          # 0041604f
    add edx, 0x1                                 # 00416052
    mov dword ptr [ebp - local_18], edx          # 00416055
    mov eax, dword ptr [ebp - local_14]          # 00416058
    add eax, dword ptr [ebp - local_8]           # 0041605b
    mov cl, byte ptr [ebp - local_28]            # 0041605e
    mov byte ptr [eax], cl                       # 00416061
    mov edx, dword ptr [ebp - local_8]           # 00416063
    add edx, 0x1                                 # 00416066
    mov dword ptr [ebp - local_8], edx           # 00416069
    mov eax, dword ptr [ebp - local_1048]        # 0041606c
    sub eax, 0x1                                 # 00416072
    mov ecx, dword ptr [ebp - local_8]           # 00416075
    {load} and ecx, eax                          # 00416078
    mov dword ptr [ebp - local_8], ecx           # 0041607a
    jmp.d8 L_00416004                            # 0041607d
L_0041607f:
    # block 0x0041607f: entered by jmp at 0x00415f3c; ja at 0x0041601f, 1 instruction(s), ends with backward jump to 0x00415e67
    jmp.d32 L_00415e67                           # 0041607f
L_00416084:
    # block 0x00416084: entered by jmp at 0x00415e90; jmp at 0x00415ede; jmp at 0x00415f55; jmp at 0x00415f99, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 00416084
    {load} mov esp, ebp                          # 00416085
    pop ebp                                      # 00416087
    ret 0x8                                      # 00416088

