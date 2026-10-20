# FUN_004f379c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f379c
# extent:       0x004f379c-0x004f3c26 (1162 code bytes)
# span:         0x004f379c-0x004f3c26 (code 1162, tables 0, padding 0)
# sha256:       73cf0d320d97645da5ea86ba7b25c8cb763ccf26fb4b42afbf075c04f982af59
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_his_sound_file_loader
# naming:       INFERRED (lower confidence, not verified): the repository text his-audio-recovery.md:14 says "`0x4f379c` opens the sound file and reads a 0x1e-byte header."
# name-note:    Opens the sound file, reads the 0x1e-byte HIS header and checks signature, version, size and marker.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_22, local_24, local_28, local_2c
# fields:       [eax + n] field_110, field_156, field_15e, field_162, field_1ae, field_1b2, field_1b6, field_1be, field_1c2, field_1c6, field_1da, field_287 and 2 more; [ecx + n] field_10e, field_122, field_126, field_152, field_156, field_15e, field_19e, field_1aa, field_1ae, field_1b2, field_1b6, field_1ba and 6 more; [edx + n] field_156, field_166, field_1aa, field_1b6, field_1ba, field_1be, field_1c2, field_1c6, field_1d6, field_1da, field_28b, field_3be and 3 more
# callees:      calls FUN_004f356e, FUN_0050d0a9, FUN_0050cf61, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004f438f, FUN_004f3c26
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28a.c:m4fadc4_set_name (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 297 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_22, 0x22  # offset -0x22
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ arg_8, 0x8  # offset +0x8
.equ field_10e, 0x10e  # offset +0x10e
.equ field_110, 0x110  # offset +0x110
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_152, 0x152  # offset +0x152
.equ field_156, 0x156  # offset +0x156
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_19e, 0x19e  # offset +0x19e
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1c6, 0x1c6  # offset +0x1c6
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1da, 0x1da  # offset +0x1da
.equ field_287, 0x287  # offset +0x287
.equ field_28b, 0x28b  # offset +0x28b
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_446, 0x446  # offset +0x446
.equ field_44a, 0x44a  # offset +0x44a
.equ field_466, 0x466  # offset +0x466
.equ field_46a, 0x46a  # offset +0x46a

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f3c26, .text + (0x004f3c26 - 0x401000)
.set FUN_004f438f, .text + (0x004f438f - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f379c - 0x401000
.globl FUN_004f379c
FUN_004f379c:
    # block 0x004f379c: entry, 27 instruction(s), ends with je to 0x004f3813 (forward)
    push ebp                                     # 004f379c
    {load} mov ebp, esp                          # 004f379d
    sub esp, 0x2c                                # 004f379f
    push esi                                     # 004f37a2
    push edi                                     # 004f37a3
    mov dword ptr [ebp - local_2c], ecx          # 004f37a4
    mov ax, word ptr [0x63aa14]                  # 004f37a7
    mov word ptr [ebp - local_24], ax            # 004f37ad
    mov ecx, 0x7                                 # 004f37b1
    {load} xor eax, eax                          # 004f37b6
    lea edi, [ebp - local_22]                    # 004f37b8
    rep stosd dword ptr es:[edi], eax            # 004f37bb
    stosw word ptr es:[edi], ax                  # 004f37bd
    mov ecx, dword ptr [ebp - local_2c]          # 004f37bf
    mov dword ptr [ecx + field_3be], 0x1         # 004f37c2
    mov edx, dword ptr [ebp - local_2c]          # 004f37cc
    mov dword ptr [edx + field_3c2], 0x3e8       # 004f37cf
    mov eax, dword ptr [ebp + arg_8]             # 004f37d9
    and eax, 0xffff                              # 004f37dc
    imul eax, eax, 0x5bb                         # 004f37e1
    mov ecx, dword ptr [ebp - local_2c]          # 004f37e7
    mov edx, dword ptr [ecx + field_3ce]         # 004f37ea
    {load} add edx, eax                          # 004f37f0
    mov dword ptr [ebp - local_28], edx          # 004f37f2
    mov eax, dword ptr [ebp - local_28]          # 004f37f5
    cmp dword ptr [eax + field_162], 0x0         # 004f37f8
    je.d8 L_004f3813                             # 004f37ff
    # block 0x004f3801: entered by fall-through of je at 0x004f37ff, 5 instruction(s), calls FUN_004f356e, falls into the block at 0x004f3813
    mov ecx, dword ptr [ebp + arg_8]             # 004f3801
    and ecx, 0xffff                              # 004f3804
    push ecx                                     # 004f380a
    mov ecx, dword ptr [ebp - local_2c]          # 004f380b
    call FUN_004f356e                            # 004f380e
L_004f3813:
    # block 0x004f3813: entered by je at 0x004f37ff, 11 instruction(s), calls FUN_0050d0a9, ends with jne to 0x004f3864 (forward)
    push 0x55dab0                                # 004f3813
    mov edx, dword ptr [ebp - local_28]          # 004f3818
    add edx, 0x4                                 # 004f381b
    push edx                                     # 004f381e
    call FUN_0050d0a9                            # 004f381f
    add esp, 0x8                                 # 004f3824
    mov ecx, dword ptr [ebp - local_28]          # 004f3827
    mov dword ptr [ecx + field_156], eax         # 004f382a
    mov edx, dword ptr [ebp - local_28]          # 004f3830
    cmp dword ptr [edx + field_156], 0x0         # 004f3833
    jne.d8 L_004f3864                            # 004f383a
    # block 0x004f383c: entered by fall-through of jne at 0x004f383a, 7 instruction(s), ends with forward jump to 0x004f3c1e
    mov eax, dword ptr [ebp - local_2c]          # 004f383c
    mov dword ptr [eax + field_3c2], 0x3ed       # 004f383f
    mov ecx, dword ptr [ebp - local_2c]          # 004f3849
    mov dword ptr [ecx + field_3be], 0x0         # 004f384c
    mov edx, dword ptr [ebp - local_2c]          # 004f3856
    mov eax, dword ptr [edx + field_3be]         # 004f3859
    jmp.d32 L_004f3c1e                           # 004f385f
L_004f3864:
    # block 0x004f3864: entered by jne at 0x004f383a, 12 instruction(s), calls FUN_0050cf61, ends with jne to 0x004f38b0 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f3864
    mov ecx, dword ptr [eax + field_156]         # 004f3867
    push ecx                                     # 004f386d
    push 0x1                                     # 004f386e
    push 0x1e                                    # 004f3870
    mov edx, dword ptr [ebp - local_28]          # 004f3872
    add edx, 0x10a                               # 004f3875
    push edx                                     # 004f387b
    call FUN_0050cf61                            # 004f387c
    add esp, 0x10                                # 004f3881
    test eax, eax                                # 004f3884
    jne.d8 L_004f38b0                            # 004f3886
    # block 0x004f3888: entered by fall-through of jne at 0x004f3886, 7 instruction(s), ends with forward jump to 0x004f3c1e
    mov eax, dword ptr [ebp - local_2c]          # 004f3888
    mov dword ptr [eax + field_3c2], 0x3ec       # 004f388b
    mov ecx, dword ptr [ebp - local_2c]          # 004f3895
    mov dword ptr [ecx + field_3be], 0x0         # 004f3898
    mov edx, dword ptr [ebp - local_2c]          # 004f38a2
    mov eax, dword ptr [edx + field_3be]         # 004f38a5
    jmp.d32 L_004f3c1e                           # 004f38ab
L_004f38b0:
    # block 0x004f38b0: entered by jne at 0x004f3886, 7 instruction(s), ends with jne to 0x004f38e6 (forward)
    mov edi, 0x55dab4                            # 004f38b0
    mov esi, dword ptr [ebp - local_28]          # 004f38b5
    add esi, 0x10a                               # 004f38b8
    mov ecx, 0x4                                 # 004f38be
    {load} xor eax, eax                          # 004f38c3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004f38c5
    jne.d8 L_004f38e6                            # 004f38c7
    # block 0x004f38c9: entered by fall-through of jne at 0x004f38c7, 4 instruction(s), ends with jne to 0x004f38e6 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f38c9
    movsx edx, word ptr [ecx + field_10e]        # 004f38cc
    cmp edx, 0x2                                 # 004f38d3
    jne.d8 L_004f38e6                            # 004f38d6
    # block 0x004f38d8: entered by fall-through of jne at 0x004f38d6, 4 instruction(s), ends with je to 0x004f3920 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f38d8
    movsx ecx, word ptr [eax + field_110]        # 004f38db
    test ecx, ecx                                # 004f38e2
    je.d8 L_004f3920                             # 004f38e4
L_004f38e6:
    # block 0x004f38e6: entered by jne at 0x004f38c7; jne at 0x004f38d6; fall-through of je at 0x004f38e4, 12 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f3c1e
    mov edx, dword ptr [ebp + arg_8]             # 004f38e6
    and edx, 0xffff                              # 004f38e9
    push edx                                     # 004f38ef
    mov ecx, dword ptr [ebp - local_2c]          # 004f38f0
    call FUN_004f356e                            # 004f38f3
    mov eax, dword ptr [ebp - local_2c]          # 004f38f8
    mov dword ptr [eax + field_3c2], 0x3f9       # 004f38fb
    mov ecx, dword ptr [ebp - local_2c]          # 004f3905
    mov dword ptr [ecx + field_3be], 0x0         # 004f3908
    mov edx, dword ptr [ebp - local_2c]          # 004f3912
    mov eax, dword ptr [edx + field_3be]         # 004f3915
    jmp.d32 L_004f3c1e                           # 004f391b
L_004f3920:
    # block 0x004f3920: entered by je at 0x004f38e4, 7 instruction(s), ends with jne to 0x004f3952 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f3920
    mov dword ptr [eax + field_162], 0x1         # 004f3923
    mov ecx, dword ptr [ebp - local_28]          # 004f392d
    mov dword ptr [ecx + field_152], 0x0         # 004f3930
    mov edx, dword ptr [ebp - local_28]          # 004f393a
    cmp dword ptr [edx + field_1aa], 0x0         # 004f393d
    jne.d8 L_004f3952                            # 004f3944
    # block 0x004f3946: entered by fall-through of jne at 0x004f3944, 3 instruction(s), ends with je to 0x004f3968 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f3946
    cmp dword ptr [eax + field_1ae], 0x0         # 004f3949
    je.d8 L_004f3968                             # 004f3950
L_004f3952:
    # block 0x004f3952: entered by jne at 0x004f3944; fall-through of je at 0x004f3950, 6 instruction(s), ends with jg to 0x004f398c (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f3952
    mov edx, dword ptr [ebp - local_28]          # 004f3955
    mov eax, dword ptr [ecx + field_1ae]         # 004f3958
    sub eax, dword ptr [edx + field_1aa]         # 004f395e
    test eax, eax                                # 004f3964
    jg.d8 L_004f398c                             # 004f3966
L_004f3968:
    # block 0x004f3968: entered by je at 0x004f3950; fall-through of jg at 0x004f3966, 8 instruction(s), falls into the block at 0x004f398c
    mov ecx, dword ptr [ebp - local_28]          # 004f3968
    mov edx, dword ptr [ebp - local_2c]          # 004f396b
    mov eax, dword ptr [edx + field_446]         # 004f396e
    mov dword ptr [ecx + field_1aa], eax         # 004f3974
    mov ecx, dword ptr [ebp - local_28]          # 004f397a
    mov edx, dword ptr [ebp - local_2c]          # 004f397d
    mov eax, dword ptr [edx + field_44a]         # 004f3980
    mov dword ptr [ecx + field_1ae], eax         # 004f3986
L_004f398c:
    # block 0x004f398c: entered by jg at 0x004f3966, 5 instruction(s), ends with jle to 0x004f39ca (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f398c
    mov edx, dword ptr [ebp - local_28]          # 004f398f
    mov eax, dword ptr [ecx + field_1b2]         # 004f3992
    cmp eax, dword ptr [edx + field_1b6]         # 004f3998
    jle.d8 L_004f39ca                            # 004f399e
    # block 0x004f39a0: entered by fall-through of jle at 0x004f399e, 10 instruction(s), falls into the block at 0x004f39ca
    mov ecx, dword ptr [ebp - local_28]          # 004f39a0
    mov edx, dword ptr [ecx + field_1b6]         # 004f39a3
    mov dword ptr [ebp - local_4], edx           # 004f39a9
    mov eax, dword ptr [ebp - local_28]          # 004f39ac
    mov ecx, dword ptr [ebp - local_28]          # 004f39af
    mov edx, dword ptr [ecx + field_1b2]         # 004f39b2
    mov dword ptr [eax + field_1b6], edx         # 004f39b8
    mov eax, dword ptr [ebp - local_28]          # 004f39be
    mov ecx, dword ptr [ebp - local_4]           # 004f39c1
    mov dword ptr [eax + field_1b2], ecx         # 004f39c4
L_004f39ca:
    # block 0x004f39ca: entered by jle at 0x004f399e, 5 instruction(s), ends with jle to 0x004f3a08 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004f39ca
    mov eax, dword ptr [ebp - local_28]          # 004f39cd
    mov ecx, dword ptr [edx + field_1ba]         # 004f39d0
    cmp ecx, dword ptr [eax + field_1be]         # 004f39d6
    jle.d8 L_004f3a08                            # 004f39dc
    # block 0x004f39de: entered by fall-through of jle at 0x004f39dc, 10 instruction(s), falls into the block at 0x004f3a08
    mov edx, dword ptr [ebp - local_28]          # 004f39de
    mov eax, dword ptr [edx + field_1be]         # 004f39e1
    mov dword ptr [ebp - local_4], eax           # 004f39e7
    mov ecx, dword ptr [ebp - local_28]          # 004f39ea
    mov edx, dword ptr [ebp - local_28]          # 004f39ed
    mov eax, dword ptr [edx + field_1ba]         # 004f39f0
    mov dword ptr [ecx + field_1be], eax         # 004f39f6
    mov ecx, dword ptr [ebp - local_28]          # 004f39fc
    mov edx, dword ptr [ebp - local_4]           # 004f39ff
    mov dword ptr [ecx + field_1ba], edx         # 004f3a02
L_004f3a08:
    # block 0x004f3a08: entered by jle at 0x004f39dc, 5 instruction(s), ends with jle to 0x004f3a46 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f3a08
    mov ecx, dword ptr [ebp - local_28]          # 004f3a0b
    mov edx, dword ptr [eax + field_1c2]         # 004f3a0e
    cmp edx, dword ptr [ecx + field_1c6]         # 004f3a14
    jle.d8 L_004f3a46                            # 004f3a1a
    # block 0x004f3a1c: entered by fall-through of jle at 0x004f3a1a, 10 instruction(s), falls into the block at 0x004f3a46
    mov eax, dword ptr [ebp - local_28]          # 004f3a1c
    mov ecx, dword ptr [eax + field_1c6]         # 004f3a1f
    mov dword ptr [ebp - local_4], ecx           # 004f3a25
    mov edx, dword ptr [ebp - local_28]          # 004f3a28
    mov eax, dword ptr [ebp - local_28]          # 004f3a2b
    mov ecx, dword ptr [eax + field_1c2]         # 004f3a2e
    mov dword ptr [edx + field_1c6], ecx         # 004f3a34
    mov edx, dword ptr [ebp - local_28]          # 004f3a3a
    mov eax, dword ptr [ebp - local_4]           # 004f3a3d
    mov dword ptr [edx + field_1c2], eax         # 004f3a40
L_004f3a46:
    # block 0x004f3a46: entered by jle at 0x004f3a1a, 3 instruction(s), ends with jg to 0x004f3a64 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f3a46
    cmp dword ptr [ecx + field_1d6], 0x1         # 004f3a49
    jg.d8 L_004f3a64                             # 004f3a50
    # block 0x004f3a52: entered by fall-through of jg at 0x004f3a50, 4 instruction(s), falls into the block at 0x004f3a64
    mov edx, dword ptr [ebp - local_28]          # 004f3a52
    mov eax, dword ptr [ebp - local_2c]          # 004f3a55
    mov ecx, dword ptr [eax + field_466]         # 004f3a58
    mov dword ptr [edx + field_1d6], ecx         # 004f3a5e
L_004f3a64:
    # block 0x004f3a64: entered by jg at 0x004f3a50, 3 instruction(s), ends with jg to 0x004f3a82 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004f3a64
    cmp dword ptr [edx + field_1da], 0x1         # 004f3a67
    jg.d8 L_004f3a82                             # 004f3a6e
    # block 0x004f3a70: entered by fall-through of jg at 0x004f3a6e, 4 instruction(s), falls into the block at 0x004f3a82
    mov eax, dword ptr [ebp - local_28]          # 004f3a70
    mov ecx, dword ptr [ebp - local_2c]          # 004f3a73
    mov edx, dword ptr [ecx + field_46a]         # 004f3a76
    mov dword ptr [eax + field_1da], edx         # 004f3a7c
L_004f3a82:
    # block 0x004f3a82: entered by jg at 0x004f3a6e, 13 instruction(s), ends with jge to 0x004f3b12 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004f3a82
    mov dword ptr [eax + field_287], 0x0         # 004f3a85
    mov ecx, dword ptr [ebp - local_28]          # 004f3a8f
    mov dword ptr [ecx + field_19e], 0x0         # 004f3a92
    mov edx, dword ptr [ebp - local_28]          # 004f3a9c
    mov dword ptr [edx + field_28b], 0x0         # 004f3a9f
    mov eax, dword ptr [ebp - local_28]          # 004f3aa9
    mov ecx, dword ptr [ebp - local_28]          # 004f3aac
    mov edx, dword ptr [ecx + field_122]         # 004f3aaf
    mov dword ptr [eax + field_15e], edx         # 004f3ab5
    mov eax, dword ptr [ebp - local_28]          # 004f3abb
    cmp dword ptr [eax + field_15e], 0x0         # 004f3abe
    jge.d8 L_004f3b12                            # 004f3ac5
    # block 0x004f3ac7: entered by fall-through of jge at 0x004f3ac5, 3 instruction(s), ends with je to 0x004f3b0b (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f3ac7
    test ecx, ecx                                # 004f3ace
    je.d8 L_004f3b0b                             # 004f3ad0
    # block 0x004f3ad2: entered by fall-through of je at 0x004f3ad0, 16 instruction(s), calls FUN_004f356e, FUN_0050ca3e, FUN_0052139c, falls into the block at 0x004f3b0b
    mov edx, dword ptr [ebp + arg_8]             # 004f3ad2
    and edx, 0xffff                              # 004f3ad5
    push edx                                     # 004f3adb
    mov ecx, dword ptr [ebp - local_2c]          # 004f3adc
    call FUN_004f356e                            # 004f3adf
    mov eax, dword ptr [ebp - local_28]          # 004f3ae4
    add eax, 0x4                                 # 004f3ae7
    push eax                                     # 004f3aea
    push 0x55dab8                                # 004f3aeb
    push 0x63888b                                # 004f3af0
    call FUN_0050ca3e                            # 004f3af5
    add esp, 0xc                                 # 004f3afa
    push 0x0                                     # 004f3afd
    push 0x0                                     # 004f3aff
    push 0x63888b                                # 004f3b01
    call FUN_0052139c                            # 004f3b06
L_004f3b0b:
    # block 0x004f3b0b: entered by je at 0x004f3ad0, 2 instruction(s), ends with forward jump to 0x004f3c1e
    {load} xor eax, eax                          # 004f3b0b
    jmp.d32 L_004f3c1e                           # 004f3b0d
L_004f3b12:
    # block 0x004f3b12: entered by jge at 0x004f3ac5, 4 instruction(s), ends with jne to 0x004f3b46 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f3b12
    movsx edx, word ptr [ecx + field_126]        # 004f3b15
    cmp edx, 0x2                                 # 004f3b1c
    jne.d8 L_004f3b46                            # 004f3b1f
    # block 0x004f3b21: entered by fall-through of jne at 0x004f3b1f, 15 instruction(s), falls into the block at 0x004f3b46
    mov edi, 0x55dafc                            # 004f3b21
    lea edx, [ebp - local_24]                    # 004f3b26
    or ecx, -0x1                                 # 004f3b29
    {load} xor eax, eax                          # 004f3b2c
    repne scasb al, byte ptr es:[edi]            # 004f3b2e
    not ecx                                      # 004f3b30
    {load} sub edi, ecx                          # 004f3b32
    {load} mov esi, edi                          # 004f3b34
    {load} mov eax, ecx                          # 004f3b36
    {load} mov edi, edx                          # 004f3b38
    shr ecx, 0x2                                 # 004f3b3a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004f3b3d
    {load} mov ecx, eax                          # 004f3b3f
    and ecx, 0x3                                 # 004f3b41
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004f3b44
L_004f3b46:
    # block 0x004f3b46: entered by jne at 0x004f3b1f, 3 instruction(s), ends with jle to 0x004f3bb8 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004f3b46
    cmp dword ptr [ecx + field_15e], 0x56220     # 004f3b49
    jle.d8 L_004f3bb8                            # 004f3b53
    # block 0x004f3b55: entered by fall-through of jle at 0x004f3b53, 5 instruction(s), ends with je to 0x004f3ba1 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004f3b55
    mov dword ptr [edx + field_166], 0x1         # 004f3b58
    movsx eax, word ptr [0x63a4cd]               # 004f3b62
    test eax, eax                                # 004f3b69
    je.d8 L_004f3ba1                             # 004f3b6b
    # block 0x004f3b6d: entered by fall-through of je at 0x004f3b6b, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f3ba1
    mov ecx, dword ptr [ebp - local_28]          # 004f3b6d
    add ecx, 0x4                                 # 004f3b70
    push ecx                                     # 004f3b73
    mov edx, dword ptr [ebp + arg_8]             # 004f3b74
    and edx, 0xffff                              # 004f3b77
    push edx                                     # 004f3b7d
    lea eax, [ebp - local_24]                    # 004f3b7e
    push eax                                     # 004f3b81
    push 0x55db08                                # 004f3b82
    push 0x63888b                                # 004f3b87
    call FUN_0050ca3e                            # 004f3b8c
    add esp, 0x14                                # 004f3b91
    push 0x63888b                                # 004f3b94
    call FUN_0044a2b7                            # 004f3b99
    add esp, 0x4                                 # 004f3b9e
L_004f3ba1:
    # block 0x004f3ba1: entered by je at 0x004f3b6b, 6 instruction(s), calls FUN_004f438f, ends with jne to 0x004f3bb6 (forward)
    mov cx, word ptr [ebp + arg_8]               # 004f3ba1
    push ecx                                     # 004f3ba5
    mov ecx, dword ptr [ebp - local_2c]          # 004f3ba6
    call FUN_004f438f                            # 004f3ba9
    test eax, eax                                # 004f3bae
    jne.d8 L_004f3bb6                            # 004f3bb0
    # block 0x004f3bb2: entered by fall-through of jne at 0x004f3bb0, 2 instruction(s), ends with forward jump to 0x004f3c1e
    {load} xor eax, eax                          # 004f3bb2
    jmp.d8 L_004f3c1e                            # 004f3bb4
L_004f3bb6:
    # block 0x004f3bb6: entered by jne at 0x004f3bb0, 1 instruction(s), ends with forward jump to 0x004f3c15
    jmp.d8 L_004f3c15                            # 004f3bb6
L_004f3bb8:
    # block 0x004f3bb8: entered by jle at 0x004f3b53, 5 instruction(s), ends with je to 0x004f3c00 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004f3bb8
    mov dword ptr [edx + field_166], 0x0         # 004f3bbb
    movsx eax, word ptr [0x63a4cd]               # 004f3bc5
    test eax, eax                                # 004f3bcc
    je.d8 L_004f3c00                             # 004f3bce
    # block 0x004f3bd0: entered by fall-through of je at 0x004f3bce, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f3c00
    mov ecx, dword ptr [ebp - local_28]          # 004f3bd0
    add ecx, 0x4                                 # 004f3bd3
    push ecx                                     # 004f3bd6
    mov edx, dword ptr [ebp + arg_8]             # 004f3bd7
    and edx, 0xffff                              # 004f3bda
    push edx                                     # 004f3be0
    push 0x55db40                                # 004f3be1
    push 0x63888b                                # 004f3be6
    call FUN_0050ca3e                            # 004f3beb
    add esp, 0x10                                # 004f3bf0
    push 0x63888b                                # 004f3bf3
    call FUN_0044a2b7                            # 004f3bf8
    add esp, 0x4                                 # 004f3bfd
L_004f3c00:
    # block 0x004f3c00: entered by je at 0x004f3bce, 6 instruction(s), calls FUN_004f3c26, ends with jne to 0x004f3c15 (forward)
    mov ax, word ptr [ebp + arg_8]               # 004f3c00
    push eax                                     # 004f3c04
    mov ecx, dword ptr [ebp - local_2c]          # 004f3c05
    call FUN_004f3c26                            # 004f3c08
    test eax, eax                                # 004f3c0d
    jne.d8 L_004f3c15                            # 004f3c0f
    # block 0x004f3c11: entered by fall-through of jne at 0x004f3c0f, 2 instruction(s), ends with forward jump to 0x004f3c1e
    {load} xor eax, eax                          # 004f3c11
    jmp.d8 L_004f3c1e                            # 004f3c13
L_004f3c15:
    # block 0x004f3c15: entered by jmp at 0x004f3bb6; jne at 0x004f3c0f, 2 instruction(s), falls into the block at 0x004f3c1e
    mov ecx, dword ptr [ebp - local_2c]          # 004f3c15
    mov eax, dword ptr [ecx + field_3be]         # 004f3c18
L_004f3c1e:
    # block 0x004f3c1e: entered by jmp at 0x004f385f; jmp at 0x004f38ab; jmp at 0x004f391b; jmp at 0x004f3b0d; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004f3c1e
    pop esi                                      # 004f3c1f
    {load} mov esp, ebp                          # 004f3c20
    pop ebp                                      # 004f3c22
    ret 0x4                                      # 004f3c23

