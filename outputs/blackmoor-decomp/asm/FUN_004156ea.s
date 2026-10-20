# FUN_004156ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004156ea
# extent:       0x004156ea-0x004159db (753 code bytes)
# span:         0x004156ea-0x004159db (code 753, tables 0, padding 0)
# sha256:       5d0f8b9cf963b94d3a57de63d3d2f3aa3ac4692a1c6bbfa2ed4ff3b6c05d02ea
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         avf_decode_double
# naming:       native port src/avf_decoder.c:avf_decode_double (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the note is the acceptance note, a statement about the native port
# name-note:    Double-buffer decode; toggles on non-empty success. Fatal paths are status returns, buffers passed in, 0x4c7314 is the convert hook, extra native rejections of truncated input. Oracle not run whole.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_6, field_a, field_e, field_21, field_35, field_3d, field_45, field_17a, field_17e, field_18a, field_1c2; [ecx + n] field_e, field_39, field_3d, field_41, field_45, field_18a; [edx + n] field_6, field_a, field_e, field_21, field_35, field_39, field_3d, field_45, field_17a, field_17e, field_18a
# callees:      calls FUN_0050ca3e, FUN_004159db, FUN_004c7314, FUN_004150af, FUN_00416af3, FUN_0051dc6c, FUN_00415011, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:avf_decode_double (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 241 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_21, 0x21  # offset +0x21
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_18a, 0x18a  # offset +0x18a
.equ field_1c2, 0x1c2  # offset +0x1c2

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_004150af, .text + (0x004150af - 0x401000)
.set FUN_004159db, .text + (0x004159db - 0x401000)
.set FUN_00416af3, .text + (0x00416af3 - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004156ea - 0x401000
.globl FUN_004156ea
FUN_004156ea:
    # block 0x004156ea: entry, 7 instruction(s), ends with jne to 0x0041571c (forward)
    push ebp                                     # 004156ea
    {load} mov ebp, esp                          # 004156eb
    sub esp, 0x28                                # 004156ed
    mov dword ptr [ebp - local_28], ecx          # 004156f0
    mov eax, dword ptr [ebp + arg_8]             # 004156f3
    cmp dword ptr [eax + field_21], 0x0          # 004156f6
    jne.d8 L_0041571c                            # 004156fa
    # block 0x004156fc: entered by fall-through of jne at 0x004156fa, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004159d3
    mov ecx, dword ptr [ebp + arg_8]             # 004156fc
    add ecx, 0x4d                                # 004156ff
    push ecx                                     # 00415702
    push 0x541cdc                                # 00415703
    mov edx, dword ptr [ebp - local_28]          # 00415708
    add edx, 0x1c                                # 0041570b
    push edx                                     # 0041570e
    call FUN_0050ca3e                            # 0041570f
    add esp, 0xc                                 # 00415714
    jmp.d32 L_004159d3                           # 00415717
L_0041571c:
    # block 0x0041571c: entered by jne at 0x004156fa, 18 instruction(s), ends with je to 0x0041578c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0041571c
    movsx ecx, word ptr [eax + field_1c2]        # 0041571f
    mov dword ptr [ebp - local_14], ecx          # 00415726
    mov edx, dword ptr [ebp + arg_8]             # 00415729
    mov dword ptr [ebp - local_4], edx           # 0041572c
    mov eax, dword ptr [ebp - local_4]           # 0041572f
    add eax, 0x4d                                # 00415732
    mov dword ptr [ebp - local_1c], eax          # 00415735
    mov ecx, dword ptr [ebp - local_14]          # 00415738
    imul ecx, ecx, 0x13                          # 0041573b
    mov edx, dword ptr [ebp - local_4]           # 0041573e
    mov eax, dword ptr [edx + field_21]          # 00415741
    {load} add eax, ecx                          # 00415744
    mov dword ptr [ebp - local_10], eax          # 00415746
    mov ecx, dword ptr [ebp + arg_8]             # 00415749
    movsx edx, word ptr [ecx + field_18a]        # 0041574c
    test edx, edx                                # 00415753
    je.d8 L_0041578c                             # 00415755
    # block 0x00415757: entered by fall-through of je at 0x00415755, 13 instruction(s), ends with forward jump to 0x004157bf
    mov dword ptr [ebp - local_18], 0x0          # 00415757
    mov eax, dword ptr [ebp + arg_8]             # 0041575e
    mov ecx, dword ptr [eax + field_17a]         # 00415761
    mov dword ptr [ebp - local_20], ecx          # 00415767
    mov edx, dword ptr [ebp + arg_8]             # 0041576a
    mov eax, dword ptr [edx + field_17e]         # 0041576d
    mov dword ptr [ebp - local_8], eax           # 00415773
    mov ecx, dword ptr [ebp + arg_8]             # 00415776
    add ecx, 0x182                               # 00415779
    mov dword ptr [ebp - local_c], ecx           # 0041577f
    mov edx, dword ptr [ebp - local_c]           # 00415782
    mov word ptr [edx], 0x0                      # 00415785
    jmp.d8 L_004157bf                            # 0041578a
L_0041578c:
    # block 0x0041578c: entered by je at 0x00415755, 12 instruction(s), falls into the block at 0x004157bf
    mov dword ptr [ebp - local_18], 0x1          # 0041578c
    mov eax, dword ptr [ebp + arg_8]             # 00415793
    mov ecx, dword ptr [eax + field_17e]         # 00415796
    mov dword ptr [ebp - local_20], ecx          # 0041579c
    mov edx, dword ptr [ebp + arg_8]             # 0041579f
    mov eax, dword ptr [edx + field_17a]         # 004157a2
    mov dword ptr [ebp - local_8], eax           # 004157a8
    mov ecx, dword ptr [ebp + arg_8]             # 004157ab
    add ecx, 0x184                               # 004157ae
    mov dword ptr [ebp - local_c], ecx           # 004157b4
    mov edx, dword ptr [ebp - local_c]           # 004157b7
    mov word ptr [edx], 0x0                      # 004157ba
L_004157bf:
    # block 0x004157bf: entered by jmp at 0x0041578a, 5 instruction(s), ends with jne to 0x00415804 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004157bf
    {load} xor ecx, ecx                          # 004157c2
    mov cl, byte ptr [eax + field_e]             # 004157c4
    cmp ecx, 0x2                                 # 004157c7
    jne.d8 L_00415804                            # 004157ca
    # block 0x004157cc: entered by fall-through of jne at 0x004157ca, 3 instruction(s), ends with je to 0x004157e3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004157cc
    cmp dword ptr [edx + field_45], -0x1         # 004157cf
    je.d8 L_004157e3                             # 004157d3
    # block 0x004157d5: entered by fall-through of je at 0x004157d3, 5 instruction(s), ends with je to 0x00415804 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004157d5
    sub eax, 0x1                                 # 004157d8
    mov ecx, dword ptr [ebp - local_4]           # 004157db
    cmp dword ptr [ecx + field_45], eax          # 004157de
    je.d8 L_00415804                             # 004157e1
L_004157e3:
    # block 0x004157e3: entered by je at 0x004157d3; fall-through of je at 0x004157e1, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004159d1
    mov edx, dword ptr [ebp - local_1c]          # 004157e3
    push edx                                     # 004157e6
    mov eax, dword ptr [ebp - local_14]          # 004157e7
    push eax                                     # 004157ea
    push 0x541d2c                                # 004157eb
    mov ecx, dword ptr [ebp - local_28]          # 004157f0
    add ecx, 0x1c                                # 004157f3
    push ecx                                     # 004157f6
    call FUN_0050ca3e                            # 004157f7
    add esp, 0x10                                # 004157fc
    jmp.d32 L_004159d1                           # 004157ff
L_00415804:
    # block 0x00415804: entered by jne at 0x004157ca; je at 0x004157e1, 3 instruction(s), ends with jne to 0x00415833 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00415804
    cmp dword ptr [edx + field_a], 0x0           # 00415807
    jne.d8 L_00415833                            # 0041580b
    # block 0x0041580d: entered by fall-through of jne at 0x0041580b, 3 instruction(s), ends with jne to 0x00415833 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0041580d
    cmp dword ptr [eax + field_6], 0x0           # 00415810
    jne.d8 L_00415833                            # 00415814
    # block 0x00415816: entered by fall-through of jne at 0x00415814, 9 instruction(s), ends with forward jump to 0x004159d5
    mov ecx, dword ptr [ebp - local_c]           # 00415816
    mov dx, word ptr [ecx]                       # 00415819
    or dl, 0xc                                   # 0041581c
    mov eax, dword ptr [ebp - local_c]           # 0041581f
    mov word ptr [eax], dx                       # 00415822
    mov ecx, dword ptr [ebp - local_4]           # 00415825
    mov edx, dword ptr [ebp - local_14]          # 00415828
    mov dword ptr [ecx + field_45], edx          # 0041582b
    jmp.d32 L_004159d5                           # 0041582e
L_00415833:
    # block 0x00415833: entered by jne at 0x0041580b; jne at 0x00415814, 5 instruction(s), ends with jne to 0x004158b1 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00415833
    {load} xor ecx, ecx                          # 00415836
    mov cl, byte ptr [eax + field_e]             # 00415838
    test ecx, ecx                                # 0041583b
    jne.d8 L_004158b1                            # 0041583d
    # block 0x0041583f: entered by fall-through of jne at 0x0041583d, 36 instruction(s), calls FUN_004159db, FUN_004c7314, ends with forward jump to 0x004159d5
    mov edx, dword ptr [ebp - local_4]           # 0041583f
    mov eax, dword ptr [ebp - local_10]          # 00415842
    mov ecx, dword ptr [eax + field_a]           # 00415845
    mov dword ptr [edx + field_3d], ecx          # 00415848
    mov edx, dword ptr [ebp - local_4]           # 0041584b
    mov eax, dword ptr [ebp - local_10]          # 0041584e
    mov ecx, dword ptr [eax + field_6]           # 00415851
    mov dword ptr [edx + field_39], ecx          # 00415854
    mov edx, dword ptr [ebp - local_4]           # 00415857
    mov eax, dword ptr [ebp - local_20]          # 0041585a
    mov dword ptr [edx + field_35], eax          # 0041585d
    mov cx, word ptr [ebp - local_14]            # 00415860
    push ecx                                     # 00415864
    mov edx, dword ptr [ebp - local_4]           # 00415865
    push edx                                     # 00415868
    mov ecx, dword ptr [ebp - local_28]          # 00415869
    call FUN_004159db                            # 0041586c
    mov eax, dword ptr [ebp - local_4]           # 00415871
    mov ecx, dword ptr [eax + field_3d]          # 00415874
    push ecx                                     # 00415877
    mov edx, dword ptr [ebp - local_20]          # 00415878
    push edx                                     # 0041587b
    mov ecx, 0x5cf659                            # 0041587c
    call FUN_004c7314                            # 00415881
    mov eax, dword ptr [ebp - local_c]           # 00415886
    mov cx, word ptr [eax]                       # 00415889
    or cl, 0x1                                   # 0041588c
    mov edx, dword ptr [ebp - local_c]           # 0041588f
    mov word ptr [edx], cx                       # 00415892
    mov eax, dword ptr [ebp - local_4]           # 00415895
    mov ecx, dword ptr [ebp - local_14]          # 00415898
    mov dword ptr [eax + field_45], ecx          # 0041589b
    mov edx, dword ptr [ebp + arg_8]             # 0041589e
    mov ax, word ptr [ebp - local_18]            # 004158a1
    mov word ptr [edx + field_18a], ax           # 004158a5
    jmp.d32 L_004159d5                           # 004158ac
L_004158b1:
    # block 0x004158b1: entered by jne at 0x0041583d, 38 instruction(s), calls FUN_004150af, FUN_004159db, FUN_00416af3, ends with jne to 0x00415928 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004158b1
    mov edx, dword ptr [ebp - local_10]          # 004158b4
    mov eax, dword ptr [edx + field_a]           # 004158b7
    mov dword ptr [ecx + field_3d], eax          # 004158ba
    mov ecx, dword ptr [ebp - local_4]           # 004158bd
    mov edx, dword ptr [ebp - local_10]          # 004158c0
    mov eax, dword ptr [edx + field_6]           # 004158c3
    mov dword ptr [ecx + field_39], eax          # 004158c6
    mov ecx, dword ptr [ebp - local_4]           # 004158c9
    push ecx                                     # 004158cc
    mov ecx, dword ptr [ebp - local_28]          # 004158cd
    call FUN_004150af                            # 004158d0
    mov dx, word ptr [ebp - local_14]            # 004158d5
    push edx                                     # 004158d9
    mov eax, dword ptr [ebp - local_4]           # 004158da
    push eax                                     # 004158dd
    mov ecx, dword ptr [ebp - local_28]          # 004158de
    call FUN_004159db                            # 004158e1
    push 0x0                                     # 004158e6
    mov ecx, dword ptr [ebp - local_8]           # 004158e8
    push ecx                                     # 004158eb
    mov edx, dword ptr [ebp - local_4]           # 004158ec
    mov eax, dword ptr [edx + field_35]          # 004158ef
    push eax                                     # 004158f2
    mov ecx, dword ptr [ebp - local_4]           # 004158f3
    mov edx, dword ptr [ecx + field_41]          # 004158f6
    push edx                                     # 004158f9
    mov eax, dword ptr [ebp - local_20]          # 004158fa
    push eax                                     # 004158fd
    mov ecx, dword ptr [ebp - local_10]          # 004158fe
    push ecx                                     # 00415901
    mov ecx, dword ptr [ebp - local_28]          # 00415902
    call FUN_00416af3                            # 00415905
    mov edx, dword ptr [ebp - local_10]          # 0041590a
    {load} xor eax, eax                          # 0041590d
    mov al, byte ptr [edx + field_e]             # 0041590f
    cmp eax, 0x1                                 # 00415912
    jne.d8 L_00415928                            # 00415915
    # block 0x00415917: entered by fall-through of jne at 0x00415915, 6 instruction(s), ends with forward jump to 0x00415964
    mov ecx, dword ptr [ebp - local_c]           # 00415917
    mov dx, word ptr [ecx]                       # 0041591a
    or dl, 0x2                                   # 0041591d
    mov eax, dword ptr [ebp - local_c]           # 00415920
    mov word ptr [eax], dx                       # 00415923
    jmp.d8 L_00415964                            # 00415926
L_00415928:
    # block 0x00415928: entered by jne at 0x00415915, 5 instruction(s), ends with jne to 0x00415946 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00415928
    {load} xor edx, edx                          # 0041592b
    mov dl, byte ptr [ecx + field_e]             # 0041592d
    cmp edx, 0x2                                 # 00415930
    jne.d8 L_00415946                            # 00415933
    # block 0x00415935: entered by fall-through of jne at 0x00415933, 6 instruction(s), ends with forward jump to 0x00415964
    mov eax, dword ptr [ebp - local_c]           # 00415935
    mov cx, word ptr [eax]                       # 00415938
    or cl, 0x4                                   # 0041593b
    mov edx, dword ptr [ebp - local_c]           # 0041593e
    mov word ptr [edx], cx                       # 00415941
    jmp.d8 L_00415964                            # 00415944
L_00415946:
    # block 0x00415946: entered by jne at 0x00415933, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004159cf
    mov eax, dword ptr [ebp - local_1c]          # 00415946
    push eax                                     # 00415949
    mov ecx, dword ptr [ebp - local_14]          # 0041594a
    push ecx                                     # 0041594d
    push 0x541d84                                # 0041594e
    mov edx, dword ptr [ebp - local_28]          # 00415953
    add edx, 0x1c                                # 00415956
    push edx                                     # 00415959
    call FUN_0050ca3e                            # 0041595a
    add esp, 0x10                                # 0041595f
    jmp.d8 L_004159cf                            # 00415962
L_00415964:
    # block 0x00415964: entered by jmp at 0x00415926; jmp at 0x00415944, 16 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x004159d5
    mov eax, dword ptr [ebp - local_4]           # 00415964
    mov ecx, dword ptr [eax + field_35]          # 00415967
    mov dword ptr [ebp - local_24], ecx          # 0041596a
    mov edx, dword ptr [ebp - local_24]          # 0041596d
    push edx                                     # 00415970
    call FUN_0051dc6c                            # 00415971
    add esp, 0x4                                 # 00415976
    mov eax, dword ptr [ebp - local_4]           # 00415979
    mov dword ptr [eax + field_35], 0x0          # 0041597c
    mov ecx, dword ptr [ebp - local_4]           # 00415983
    mov edx, dword ptr [ebp - local_14]          # 00415986
    mov dword ptr [ecx + field_45], edx          # 00415989
    mov eax, dword ptr [ebp + arg_8]             # 0041598c
    mov cx, word ptr [ebp - local_18]            # 0041598f
    mov word ptr [eax + field_18a], cx           # 00415993
    jmp.d8 L_004159d5                            # 0041599a
L_0041599c:
    # block 0x0041599c: entered by jmp at 0x004159cf; jmp at 0x004159d1; jmp at 0x004159d3, 13 instruction(s), calls FUN_00415011, FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004159d5
    mov edx, dword ptr [ebp - local_4]           # 0041599c
    push edx                                     # 0041599f
    mov ecx, dword ptr [ebp - local_28]          # 004159a0
    call FUN_00415011                            # 004159a3
    mov eax, dword ptr [ebp - local_28]          # 004159a8
    add eax, 0x1c                                # 004159ab
    push eax                                     # 004159ae
    mov ecx, 0x583979                            # 004159af
    call FUN_004264e8                            # 004159b4
    mov dword ptr [0x63a58a], 0x4                # 004159b9
    mov ecx, 0x5cf659                            # 004159c3
    call FUN_004c97b4                            # 004159c8
    jmp.d8 L_004159d5                            # 004159cd
L_004159cf:
    # block 0x004159cf: entered by jmp at 0x00415962, 1 instruction(s), ends with backward jump to 0x0041599c
    jmp.d8 L_0041599c                            # 004159cf
L_004159d1:
    # block 0x004159d1: entered by jmp at 0x004157ff, 1 instruction(s), ends with backward jump to 0x0041599c
    jmp.d8 L_0041599c                            # 004159d1
L_004159d3:
    # block 0x004159d3: entered by jmp at 0x00415717, 1 instruction(s), ends with backward jump to 0x0041599c
    jmp.d8 L_0041599c                            # 004159d3
L_004159d5:
    # block 0x004159d5: entered by jmp at 0x0041582e; jmp at 0x004158ac; jmp at 0x0041599a; jmp at 0x004159cd, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004159d5
    pop ebp                                      # 004159d7
    ret 0x4                                      # 004159d8

