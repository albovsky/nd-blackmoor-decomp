# FUN_004468fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004468fe
# extent:       0x004468fe-0x00446ec4 (1478 code bytes)
# span:         0x004468fe-0x00446ed0 (code 1478, tables 0, padding 12)
# sha256:       a17ceb31d6c75672ec3f349e8da615c67b08b20a9540013b55e23ca5dd944b49
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4468fe_draw_clock
# naming:       native port src/original_methods_fl21b.c:m4468fe_draw_clock (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4468fe_draw_clock. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 1490 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       24 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 12 more
# fields:       [eax + n] field_1, field_minus_1; [ecx + n] field_1, field_minus_1; [edx + n] field_1, field_minus_1
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl21b.c:m4468fe_draw_clock (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 420 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_39, 0x39  # offset -0x39
.equ local_3a, 0x3a  # offset -0x3a
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_4d, 0x4d  # offset -0x4d
.equ local_4e, 0x4e  # offset -0x4e
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ field_1, 0x1  # offset +0x1

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004468fe - 0x401000
.globl FUN_004468fe
FUN_004468fe:
    # block 0x004468fe: entry, 7 instruction(s), ends with je to 0x00446918 (forward)
    push ebp                                     # 004468fe
    {load} mov ebp, esp                          # 004468ff
    sub esp, 0x58                                # 00446901
    push esi                                     # 00446904
    push edi                                     # 00446905
    cmp dword ptr [0x63860b], 0x0                # 00446906
    je.d8 L_00446918                             # 0044690d
    # block 0x0044690f: entered by fall-through of je at 0x0044690d, 2 instruction(s), ends with jne to 0x0044691d (forward)
    cmp dword ptr [0x638613], 0x0                # 0044690f
    jne.d8 L_0044691d                            # 00446916
L_00446918:
    # block 0x00446918: entered by je at 0x0044690d; fall-through of jne at 0x00446916, 1 instruction(s), ends with forward jump to 0x00446ebe
    jmp.d32 L_00446ebe                           # 00446918
L_0044691d:
    # block 0x0044691d: entered by jne at 0x00446916, 6 instruction(s), falls into the block at 0x0044693c
    mov eax, dword ptr [0x638827]                # 0044691d
    mov dword ptr [ebp - local_8], eax           # 00446922
    mov ecx, dword ptr [0x63882b]                # 00446925
    mov dword ptr [ebp - local_4], ecx           # 0044692b
    mov dword ptr [ebp - local_34], 0x638869     # 0044692e
    mov dword ptr [ebp - local_38], 0x63884b     # 00446935
L_0044693c:
    # block 0x0044693c: entered by jne at 0x0044696e, 6 instruction(s), ends with jne to 0x00446979 (forward)
    mov edx, dword ptr [ebp - local_38]          # 0044693c
    mov al, byte ptr [edx]                       # 0044693f
    mov byte ptr [ebp - local_39], al            # 00446941
    mov ecx, dword ptr [ebp - local_34]          # 00446944
    cmp al, byte ptr [ecx]                       # 00446947
    jne.d8 L_00446979                            # 00446949
    # block 0x0044694b: entered by fall-through of jne at 0x00446949, 2 instruction(s), ends with je to 0x00446970 (forward)
    cmp byte ptr [ebp - local_39], 0x0           # 0044694b
    je.d8 L_00446970                             # 0044694f
    # block 0x00446951: entered by fall-through of je at 0x0044694f, 6 instruction(s), ends with jne to 0x00446979 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00446951
    mov al, byte ptr [edx + field_1]             # 00446954
    mov byte ptr [ebp - local_3a], al            # 00446957
    mov ecx, dword ptr [ebp - local_34]          # 0044695a
    cmp al, byte ptr [ecx + field_1]             # 0044695d
    jne.d8 L_00446979                            # 00446960
    # block 0x00446962: entered by fall-through of jne at 0x00446960, 4 instruction(s), ends with jne to 0x0044693c (backward)
    add dword ptr [ebp - local_38], 0x2          # 00446962
    add dword ptr [ebp - local_34], 0x2          # 00446966
    cmp byte ptr [ebp - local_3a], 0x0           # 0044696a
    jne.d8 L_0044693c                            # 0044696e
L_00446970:
    # block 0x00446970: entered by je at 0x0044694f; fall-through of jne at 0x0044696e, 2 instruction(s), ends with forward jump to 0x00446981
    mov dword ptr [ebp - local_40], 0x0          # 00446970
    jmp.d8 L_00446981                            # 00446977
L_00446979:
    # block 0x00446979: entered by jne at 0x00446949; jne at 0x00446960, 3 instruction(s), falls into the block at 0x00446981
    {load} sbb edx, edx                          # 00446979
    sbb edx, -0x1                                # 0044697b
    mov dword ptr [ebp - local_40], edx          # 0044697e
L_00446981:
    # block 0x00446981: entered by jmp at 0x00446977, 4 instruction(s), ends with jne to 0x004469f0 (forward)
    mov eax, dword ptr [ebp - local_40]          # 00446981
    mov dword ptr [ebp - local_44], eax          # 00446984
    cmp dword ptr [ebp - local_44], 0x0          # 00446987
    jne.d8 L_004469f0                            # 0044698b
    # block 0x0044698d: entered by fall-through of jne at 0x0044698b, 2 instruction(s), falls into the block at 0x0044699b
    mov dword ptr [ebp - local_48], 0x638873     # 0044698d
    mov dword ptr [ebp - local_4c], 0x638855     # 00446994
L_0044699b:
    # block 0x0044699b: entered by jne at 0x004469cd, 6 instruction(s), ends with jne to 0x004469d8 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 0044699b
    mov dl, byte ptr [ecx]                       # 0044699e
    mov byte ptr [ebp - local_4d], dl            # 004469a0
    mov eax, dword ptr [ebp - local_48]          # 004469a3
    cmp dl, byte ptr [eax]                       # 004469a6
    jne.d8 L_004469d8                            # 004469a8
    # block 0x004469aa: entered by fall-through of jne at 0x004469a8, 2 instruction(s), ends with je to 0x004469cf (forward)
    cmp byte ptr [ebp - local_4d], 0x0           # 004469aa
    je.d8 L_004469cf                             # 004469ae
    # block 0x004469b0: entered by fall-through of je at 0x004469ae, 6 instruction(s), ends with jne to 0x004469d8 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004469b0
    mov dl, byte ptr [ecx + field_1]             # 004469b3
    mov byte ptr [ebp - local_4e], dl            # 004469b6
    mov eax, dword ptr [ebp - local_48]          # 004469b9
    cmp dl, byte ptr [eax + field_1]             # 004469bc
    jne.d8 L_004469d8                            # 004469bf
    # block 0x004469c1: entered by fall-through of jne at 0x004469bf, 4 instruction(s), ends with jne to 0x0044699b (backward)
    add dword ptr [ebp - local_4c], 0x2          # 004469c1
    add dword ptr [ebp - local_48], 0x2          # 004469c5
    cmp byte ptr [ebp - local_4e], 0x0           # 004469c9
    jne.d8 L_0044699b                            # 004469cd
L_004469cf:
    # block 0x004469cf: entered by je at 0x004469ae; fall-through of jne at 0x004469cd, 2 instruction(s), ends with forward jump to 0x004469e0
    mov dword ptr [ebp - local_54], 0x0          # 004469cf
    jmp.d8 L_004469e0                            # 004469d6
L_004469d8:
    # block 0x004469d8: entered by jne at 0x004469a8; jne at 0x004469bf, 3 instruction(s), falls into the block at 0x004469e0
    {load} sbb ecx, ecx                          # 004469d8
    sbb ecx, -0x1                                # 004469da
    mov dword ptr [ebp - local_54], ecx          # 004469dd
L_004469e0:
    # block 0x004469e0: entered by jmp at 0x004469d6, 4 instruction(s), ends with je to 0x00446c5a (forward)
    mov edx, dword ptr [ebp - local_54]          # 004469e0
    mov dword ptr [ebp - local_58], edx          # 004469e3
    cmp dword ptr [ebp - local_58], 0x0          # 004469e6
    je.d32 L_00446c5a                            # 004469ea
L_004469f0:
    # block 0x004469f0: entered by jne at 0x0044698b; fall-through of je at 0x004469ea, 2 instruction(s), ends with forward jump to 0x00446a02
    mov dword ptr [ebp - local_1c], 0x0          # 004469f0
    jmp.d8 L_00446a02                            # 004469f7
L_004469f9:
    # block 0x004469f9: entered by jmp at 0x00446acd, 3 instruction(s), falls into the block at 0x00446a02
    mov eax, dword ptr [ebp - local_1c]          # 004469f9
    add eax, 0x1                                 # 004469fc
    mov dword ptr [ebp - local_1c], eax          # 004469ff
L_00446a02:
    # block 0x00446a02: entered by jmp at 0x004469f7, 8 instruction(s), ends with jae to 0x00446ad2 (forward)
    mov edi, 0x638869                            # 00446a02
    or ecx, -0x1                                 # 00446a07
    {load} xor eax, eax                          # 00446a0a
    repne scasb al, byte ptr es:[edi]            # 00446a0c
    not ecx                                      # 00446a0e
    add ecx, -0x1                                # 00446a10
    cmp dword ptr [ebp - local_1c], ecx          # 00446a13
    jae.d32 L_00446ad2                           # 00446a16
    # block 0x00446a1c: entered by fall-through of jae at 0x00446a16, 48 instruction(s), calls FUN_004c5377, ends with backward jump to 0x004469f9
    mov ecx, dword ptr [ebp - local_1c]          # 00446a1c
    movsx edx, byte ptr [ecx + 0x638869]         # 00446a1f
    sub edx, 0x30                                # 00446a26
    mov dword ptr [ebp - local_30], edx          # 00446a29
    mov eax, dword ptr [ebp - local_8]           # 00446a2c
    mov dword ptr [ebp - local_2c], eax          # 00446a2f
    mov ecx, dword ptr [ebp - local_4]           # 00446a32
    mov dword ptr [ebp - local_28], ecx          # 00446a35
    mov edx, dword ptr [ebp - local_30]          # 00446a38
    mov eax, dword ptr [4*edx + 0x638667]        # 00446a3b
    mov ecx, dword ptr [ebp - local_2c]          # 00446a42
    lea edx, [ecx + eax - field_minus_1]         # 00446a45
    mov dword ptr [ebp - local_24], edx          # 00446a49
    mov eax, dword ptr [ebp - local_30]          # 00446a4c
    mov ecx, dword ptr [4*eax + 0x63868f]        # 00446a4f
    mov edx, dword ptr [ebp - local_28]          # 00446a56
    lea eax, [edx + ecx - field_minus_1]         # 00446a59
    mov dword ptr [ebp - local_20], eax          # 00446a5d
    mov ecx, dword ptr [ebp - local_2c]          # 00446a60
    sub ecx, dword ptr [0x583186]                # 00446a63
    mov dword ptr [ebp - local_18], ecx          # 00446a69
    mov edx, dword ptr [ebp - local_24]          # 00446a6c
    sub edx, dword ptr [0x583186]                # 00446a6f
    mov dword ptr [ebp - local_10], edx          # 00446a75
    mov eax, dword ptr [ebp - local_28]          # 00446a78
    sub eax, dword ptr [0x58318a]                # 00446a7b
    mov dword ptr [ebp - local_14], eax          # 00446a81
    mov ecx, dword ptr [ebp - local_20]          # 00446a84
    sub ecx, dword ptr [0x58318a]                # 00446a87
    mov dword ptr [ebp - local_c], ecx           # 00446a8d
    push 0x5482c4                                # 00446a90
    lea edx, [ebp - local_2c]                    # 00446a95
    push edx                                     # 00446a98
    lea eax, [ebp - local_18]                    # 00446a99
    push eax                                     # 00446a9c
    mov ecx, dword ptr [0x5cf665]                # 00446a9d
    push ecx                                     # 00446aa3
    mov edx, dword ptr [0x5d15e3]                # 00446aa4
    push edx                                     # 00446aaa
    mov ecx, 0x5cf659                            # 00446aab
    call FUN_004c5377                            # 00446ab0
    mov eax, dword ptr [ebp - local_30]          # 00446ab5
    mov ecx, dword ptr [4*eax + 0x638667]        # 00446ab8
    add ecx, dword ptr [0x63882f]                # 00446abf
    mov edx, dword ptr [ebp - local_8]           # 00446ac5
    {load} add edx, ecx                          # 00446ac8
    mov dword ptr [ebp - local_8], edx           # 00446aca
    jmp.d32 L_004469f9                           # 00446acd
L_00446ad2:
    # block 0x00446ad2: entered by jae at 0x00446a16, 48 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00446b8a
    mov eax, dword ptr [ebp - local_8]           # 00446ad2
    mov dword ptr [ebp - local_2c], eax          # 00446ad5
    mov eax, dword ptr [0x63868f]                # 00446ad8
    sub eax, dword ptr [0x6386bb]                # 00446add
    cdq                                          # 00446ae3
    {load} sub eax, edx                          # 00446ae4
    sar eax                                      # 00446ae6
    mov ecx, dword ptr [ebp - local_4]           # 00446ae8
    {load} add ecx, eax                          # 00446aeb
    mov dword ptr [ebp - local_28], ecx          # 00446aed
    mov edx, dword ptr [0x6386b7]                # 00446af0
    mov eax, dword ptr [ebp - local_2c]          # 00446af6
    lea ecx, [eax + edx - field_minus_1]         # 00446af9
    mov dword ptr [ebp - local_24], ecx          # 00446afd
    mov edx, dword ptr [0x6386bb]                # 00446b00
    mov eax, dword ptr [ebp - local_28]          # 00446b06
    lea ecx, [eax + edx - field_minus_1]         # 00446b09
    mov dword ptr [ebp - local_20], ecx          # 00446b0d
    mov edx, dword ptr [ebp - local_2c]          # 00446b10
    sub edx, dword ptr [0x583186]                # 00446b13
    mov dword ptr [ebp - local_18], edx          # 00446b19
    mov eax, dword ptr [ebp - local_24]          # 00446b1c
    sub eax, dword ptr [0x583186]                # 00446b1f
    mov dword ptr [ebp - local_10], eax          # 00446b25
    mov ecx, dword ptr [ebp - local_28]          # 00446b28
    sub ecx, dword ptr [0x58318a]                # 00446b2b
    mov dword ptr [ebp - local_14], ecx          # 00446b31
    mov edx, dword ptr [ebp - local_20]          # 00446b34
    sub edx, dword ptr [0x58318a]                # 00446b37
    mov dword ptr [ebp - local_c], edx           # 00446b3d
    push 0x5482f0                                # 00446b40
    lea eax, [ebp - local_2c]                    # 00446b45
    push eax                                     # 00446b48
    lea ecx, [ebp - local_18]                    # 00446b49
    push ecx                                     # 00446b4c
    mov edx, dword ptr [0x5cf665]                # 00446b4d
    push edx                                     # 00446b53
    mov eax, dword ptr [0x5d15e3]                # 00446b54
    push eax                                     # 00446b59
    mov ecx, 0x5cf659                            # 00446b5a
    call FUN_004c5377                            # 00446b5f
    mov ecx, dword ptr [0x6386b7]                # 00446b64
    add ecx, dword ptr [0x63882f]                # 00446b6a
    mov edx, dword ptr [ebp - local_8]           # 00446b70
    {load} add edx, ecx                          # 00446b73
    mov dword ptr [ebp - local_8], edx           # 00446b75
    mov dword ptr [ebp - local_1c], 0x0          # 00446b78
    jmp.d8 L_00446b8a                            # 00446b7f
L_00446b81:
    # block 0x00446b81: entered by jmp at 0x00446c55, 3 instruction(s), falls into the block at 0x00446b8a
    mov eax, dword ptr [ebp - local_1c]          # 00446b81
    add eax, 0x1                                 # 00446b84
    mov dword ptr [ebp - local_1c], eax          # 00446b87
L_00446b8a:
    # block 0x00446b8a: entered by jmp at 0x00446b7f, 8 instruction(s), ends with jae to 0x00446c5a (forward)
    mov edi, 0x638873                            # 00446b8a
    or ecx, -0x1                                 # 00446b8f
    {load} xor eax, eax                          # 00446b92
    repne scasb al, byte ptr es:[edi]            # 00446b94
    not ecx                                      # 00446b96
    add ecx, -0x1                                # 00446b98
    cmp dword ptr [ebp - local_1c], ecx          # 00446b9b
    jae.d32 L_00446c5a                           # 00446b9e
    # block 0x00446ba4: entered by fall-through of jae at 0x00446b9e, 48 instruction(s), calls FUN_004c5377, ends with backward jump to 0x00446b81
    mov ecx, dword ptr [ebp - local_1c]          # 00446ba4
    movsx edx, byte ptr [ecx + 0x638873]         # 00446ba7
    sub edx, 0x30                                # 00446bae
    mov dword ptr [ebp - local_30], edx          # 00446bb1
    mov eax, dword ptr [ebp - local_8]           # 00446bb4
    mov dword ptr [ebp - local_2c], eax          # 00446bb7
    mov ecx, dword ptr [ebp - local_4]           # 00446bba
    mov dword ptr [ebp - local_28], ecx          # 00446bbd
    mov edx, dword ptr [ebp - local_30]          # 00446bc0
    mov eax, dword ptr [4*edx + 0x638667]        # 00446bc3
    mov ecx, dword ptr [ebp - local_2c]          # 00446bca
    lea edx, [ecx + eax - field_minus_1]         # 00446bcd
    mov dword ptr [ebp - local_24], edx          # 00446bd1
    mov eax, dword ptr [ebp - local_30]          # 00446bd4
    mov ecx, dword ptr [4*eax + 0x63868f]        # 00446bd7
    mov edx, dword ptr [ebp - local_28]          # 00446bde
    lea eax, [edx + ecx - field_minus_1]         # 00446be1
    mov dword ptr [ebp - local_20], eax          # 00446be5
    mov ecx, dword ptr [ebp - local_2c]          # 00446be8
    sub ecx, dword ptr [0x583186]                # 00446beb
    mov dword ptr [ebp - local_18], ecx          # 00446bf1
    mov edx, dword ptr [ebp - local_24]          # 00446bf4
    sub edx, dword ptr [0x583186]                # 00446bf7
    mov dword ptr [ebp - local_10], edx          # 00446bfd
    mov eax, dword ptr [ebp - local_28]          # 00446c00
    sub eax, dword ptr [0x58318a]                # 00446c03
    mov dword ptr [ebp - local_14], eax          # 00446c09
    mov ecx, dword ptr [ebp - local_20]          # 00446c0c
    sub ecx, dword ptr [0x58318a]                # 00446c0f
    mov dword ptr [ebp - local_c], ecx           # 00446c15
    push 0x54831c                                # 00446c18
    lea edx, [ebp - local_2c]                    # 00446c1d
    push edx                                     # 00446c20
    lea eax, [ebp - local_18]                    # 00446c21
    push eax                                     # 00446c24
    mov ecx, dword ptr [0x5cf665]                # 00446c25
    push ecx                                     # 00446c2b
    mov edx, dword ptr [0x5d15e3]                # 00446c2c
    push edx                                     # 00446c32
    mov ecx, 0x5cf659                            # 00446c33
    call FUN_004c5377                            # 00446c38
    mov eax, dword ptr [ebp - local_30]          # 00446c3d
    mov ecx, dword ptr [4*eax + 0x638667]        # 00446c40
    add ecx, dword ptr [0x63882f]                # 00446c47
    mov edx, dword ptr [ebp - local_8]           # 00446c4d
    {load} add edx, ecx                          # 00446c50
    mov dword ptr [ebp - local_8], edx           # 00446c52
    jmp.d32 L_00446b81                           # 00446c55
L_00446c5a:
    # block 0x00446c5a: entered by je at 0x004469ea; jae at 0x00446b9e, 6 instruction(s), ends with forward jump to 0x00446c7d
    mov eax, dword ptr [0x638827]                # 00446c5a
    mov dword ptr [ebp - local_8], eax           # 00446c5f
    mov ecx, dword ptr [0x63882b]                # 00446c62
    mov dword ptr [ebp - local_4], ecx           # 00446c68
    mov dword ptr [ebp - local_1c], 0x0          # 00446c6b
    jmp.d8 L_00446c7d                            # 00446c72
L_00446c74:
    # block 0x00446c74: entered by jmp at 0x00446d29, 3 instruction(s), falls into the block at 0x00446c7d
    mov edx, dword ptr [ebp - local_1c]          # 00446c74
    add edx, 0x1                                 # 00446c77
    mov dword ptr [ebp - local_1c], edx          # 00446c7a
L_00446c7d:
    # block 0x00446c7d: entered by jmp at 0x00446c72, 8 instruction(s), ends with jae to 0x00446d2e (forward)
    mov edi, 0x63884b                            # 00446c7d
    or ecx, -0x1                                 # 00446c82
    {load} xor eax, eax                          # 00446c85
    repne scasb al, byte ptr es:[edi]            # 00446c87
    not ecx                                      # 00446c89
    add ecx, -0x1                                # 00446c8b
    cmp dword ptr [ebp - local_1c], ecx          # 00446c8e
    jae.d32 L_00446d2e                           # 00446c91
    # block 0x00446c97: entered by fall-through of jae at 0x00446c91, 40 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x00446c74
    mov eax, dword ptr [ebp - local_1c]          # 00446c97
    movsx ecx, byte ptr [eax + 0x63884b]         # 00446c9a
    sub ecx, 0x30                                # 00446ca1
    mov dword ptr [ebp - local_30], ecx          # 00446ca4
    mov edx, dword ptr [ebp - local_8]           # 00446ca7
    mov dword ptr [ebp - local_2c], edx          # 00446caa
    mov eax, dword ptr [ebp - local_4]           # 00446cad
    mov dword ptr [ebp - local_28], eax          # 00446cb0
    mov ecx, dword ptr [ebp - local_30]          # 00446cb3
    mov edx, dword ptr [4*ecx + 0x638667]        # 00446cb6
    mov eax, dword ptr [ebp - local_2c]          # 00446cbd
    lea ecx, [eax + edx - field_minus_1]         # 00446cc0
    mov dword ptr [ebp - local_24], ecx          # 00446cc4
    mov edx, dword ptr [ebp - local_30]          # 00446cc7
    mov eax, dword ptr [4*edx + 0x63868f]        # 00446cca
    mov ecx, dword ptr [ebp - local_28]          # 00446cd1
    lea edx, [ecx + eax - field_minus_1]         # 00446cd4
    mov dword ptr [ebp - local_20], edx          # 00446cd8
    push 0x548348                                # 00446cdb
    lea eax, [ebp - local_2c]                    # 00446ce0
    push eax                                     # 00446ce3
    mov ecx, dword ptr [ebp - local_30]          # 00446ce4
    shl ecx, 0x4                                 # 00446ce7
    add ecx, 0x638777                            # 00446cea
    push ecx                                     # 00446cf0
    mov edx, dword ptr [0x5cf665]                # 00446cf1
    push edx                                     # 00446cf7
    mov eax, dword ptr [0x638837]                # 00446cf8
    imul eax, eax, 0x4a                          # 00446cfd
    mov ecx, dword ptr [eax + 0x5d1599]          # 00446d00
    push ecx                                     # 00446d06
    mov ecx, 0x5cf659                            # 00446d07
    call FUN_004c5d4b                            # 00446d0c
    mov edx, dword ptr [ebp - local_30]          # 00446d11
    mov eax, dword ptr [4*edx + 0x638667]        # 00446d14
    add eax, dword ptr [0x63882f]                # 00446d1b
    mov ecx, dword ptr [ebp - local_8]           # 00446d21
    {load} add ecx, eax                          # 00446d24
    mov dword ptr [ebp - local_8], ecx           # 00446d26
    jmp.d32 L_00446c74                           # 00446d29
L_00446d2e:
    # block 0x00446d2e: entered by jae at 0x00446c91, 37 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00446dbf
    mov edx, dword ptr [ebp - local_8]           # 00446d2e
    mov dword ptr [ebp - local_2c], edx          # 00446d31
    mov eax, dword ptr [0x63868f]                # 00446d34
    sub eax, dword ptr [0x6386bb]                # 00446d39
    cdq                                          # 00446d3f
    {load} sub eax, edx                          # 00446d40
    sar eax                                      # 00446d42
    mov ecx, dword ptr [ebp - local_4]           # 00446d44
    {load} add ecx, eax                          # 00446d47
    mov dword ptr [ebp - local_28], ecx          # 00446d49
    mov edx, dword ptr [0x6386b7]                # 00446d4c
    mov eax, dword ptr [ebp - local_2c]          # 00446d52
    lea ecx, [eax + edx - field_minus_1]         # 00446d55
    mov dword ptr [ebp - local_24], ecx          # 00446d59
    mov edx, dword ptr [0x6386bb]                # 00446d5c
    mov eax, dword ptr [ebp - local_28]          # 00446d62
    lea ecx, [eax + edx - field_minus_1]         # 00446d65
    mov dword ptr [ebp - local_20], ecx          # 00446d69
    push 0x548358                                # 00446d6c
    lea edx, [ebp - local_2c]                    # 00446d71
    push edx                                     # 00446d74
    push 0x638817                                # 00446d75
    mov eax, dword ptr [0x5cf665]                # 00446d7a
    push eax                                     # 00446d7f
    mov ecx, dword ptr [0x638837]                # 00446d80
    imul ecx, ecx, 0x4a                          # 00446d86
    mov edx, dword ptr [ecx + 0x5d1599]          # 00446d89
    push edx                                     # 00446d8f
    mov ecx, 0x5cf659                            # 00446d90
    call FUN_004c5d4b                            # 00446d95
    mov eax, dword ptr [0x6386b7]                # 00446d9a
    add eax, dword ptr [0x63882f]                # 00446d9f
    mov ecx, dword ptr [ebp - local_8]           # 00446da5
    {load} add ecx, eax                          # 00446da8
    mov dword ptr [ebp - local_8], ecx           # 00446daa
    mov dword ptr [ebp - local_1c], 0x0          # 00446dad
    jmp.d8 L_00446dbf                            # 00446db4
L_00446db6:
    # block 0x00446db6: entered by jmp at 0x00446e6b, 3 instruction(s), falls into the block at 0x00446dbf
    mov edx, dword ptr [ebp - local_1c]          # 00446db6
    add edx, 0x1                                 # 00446db9
    mov dword ptr [ebp - local_1c], edx          # 00446dbc
L_00446dbf:
    # block 0x00446dbf: entered by jmp at 0x00446db4, 8 instruction(s), ends with jae to 0x00446e70 (forward)
    mov edi, 0x638855                            # 00446dbf
    or ecx, -0x1                                 # 00446dc4
    {load} xor eax, eax                          # 00446dc7
    repne scasb al, byte ptr es:[edi]            # 00446dc9
    not ecx                                      # 00446dcb
    add ecx, -0x1                                # 00446dcd
    cmp dword ptr [ebp - local_1c], ecx          # 00446dd0
    jae.d32 L_00446e70                           # 00446dd3
    # block 0x00446dd9: entered by fall-through of jae at 0x00446dd3, 40 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x00446db6
    mov eax, dword ptr [ebp - local_1c]          # 00446dd9
    movsx ecx, byte ptr [eax + 0x638855]         # 00446ddc
    sub ecx, 0x30                                # 00446de3
    mov dword ptr [ebp - local_30], ecx          # 00446de6
    mov edx, dword ptr [ebp - local_8]           # 00446de9
    mov dword ptr [ebp - local_2c], edx          # 00446dec
    mov eax, dword ptr [ebp - local_4]           # 00446def
    mov dword ptr [ebp - local_28], eax          # 00446df2
    mov ecx, dword ptr [ebp - local_30]          # 00446df5
    mov edx, dword ptr [4*ecx + 0x638667]        # 00446df8
    mov eax, dword ptr [ebp - local_2c]          # 00446dff
    lea ecx, [eax + edx - field_minus_1]         # 00446e02
    mov dword ptr [ebp - local_24], ecx          # 00446e06
    mov edx, dword ptr [ebp - local_30]          # 00446e09
    mov eax, dword ptr [4*edx + 0x63868f]        # 00446e0c
    mov ecx, dword ptr [ebp - local_28]          # 00446e13
    lea edx, [ecx + eax - field_minus_1]         # 00446e16
    mov dword ptr [ebp - local_20], edx          # 00446e1a
    push 0x548368                                # 00446e1d
    lea eax, [ebp - local_2c]                    # 00446e22
    push eax                                     # 00446e25
    mov ecx, dword ptr [ebp - local_30]          # 00446e26
    shl ecx, 0x4                                 # 00446e29
    add ecx, 0x638777                            # 00446e2c
    push ecx                                     # 00446e32
    mov edx, dword ptr [0x5cf665]                # 00446e33
    push edx                                     # 00446e39
    mov eax, dword ptr [0x638837]                # 00446e3a
    imul eax, eax, 0x4a                          # 00446e3f
    mov ecx, dword ptr [eax + 0x5d1599]          # 00446e42
    push ecx                                     # 00446e48
    mov ecx, 0x5cf659                            # 00446e49
    call FUN_004c5d4b                            # 00446e4e
    mov edx, dword ptr [ebp - local_30]          # 00446e53
    mov eax, dword ptr [4*edx + 0x638667]        # 00446e56
    add eax, dword ptr [0x63882f]                # 00446e5d
    mov ecx, dword ptr [ebp - local_8]           # 00446e63
    {load} add ecx, eax                          # 00446e66
    mov dword ptr [ebp - local_8], ecx           # 00446e68
    jmp.d32 L_00446db6                           # 00446e6b
L_00446e70:
    # block 0x00446e70: entered by jae at 0x00446dd3, 30 instruction(s), falls into the block at 0x00446ebe
    mov edi, 0x63884b                            # 00446e70
    mov edx, 0x638869                            # 00446e75
    or ecx, -0x1                                 # 00446e7a
    {load} xor eax, eax                          # 00446e7d
    repne scasb al, byte ptr es:[edi]            # 00446e7f
    not ecx                                      # 00446e81
    {load} sub edi, ecx                          # 00446e83
    {load} mov esi, edi                          # 00446e85
    {load} mov eax, ecx                          # 00446e87
    {load} mov edi, edx                          # 00446e89
    shr ecx, 0x2                                 # 00446e8b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00446e8e
    {load} mov ecx, eax                          # 00446e90
    and ecx, 0x3                                 # 00446e92
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00446e95
    mov edi, 0x638855                            # 00446e97
    mov edx, 0x638873                            # 00446e9c
    or ecx, -0x1                                 # 00446ea1
    {load} xor eax, eax                          # 00446ea4
    repne scasb al, byte ptr es:[edi]            # 00446ea6
    not ecx                                      # 00446ea8
    {load} sub edi, ecx                          # 00446eaa
    {load} mov esi, edi                          # 00446eac
    {load} mov eax, ecx                          # 00446eae
    {load} mov edi, edx                          # 00446eb0
    shr ecx, 0x2                                 # 00446eb2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00446eb5
    {load} mov ecx, eax                          # 00446eb7
    and ecx, 0x3                                 # 00446eb9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00446ebc
L_00446ebe:
    # block 0x00446ebe: entered by jmp at 0x00446918, 5 instruction(s), ends with ret
    pop edi                                      # 00446ebe
    pop esi                                      # 00446ebf
    {load} mov esp, ebp                          # 00446ec0
    pop ebp                                      # 00446ec2
    ret                                          # 00446ec3

# --- data items (not part of the function) -------------------------
.org 0x00446ec4 - 0x401000
PAD_00446ec4:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

