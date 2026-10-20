# FUN_00432d1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00432d1a
# extent:       0x00432d1a-0x004336ad (2451 code bytes)
# span:         0x00432d1a-0x004336ad (code 2451, tables 0, padding 0)
# sha256:       1d9e5a654e361be8ba82cd95ab32047f73c59564e385209c697e5e6a7bba99ff
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_97_a1_caption_sound_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/blackmoor_app.mm:3257 says "raw 0xa1 shares the caption writer and the caption flag with raw 0x97 (0x432d1a is"
# name-note:    Single function handling raw 0x97 and raw 0xa1 rows (shares the caption writer and caption flag).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       25 ebp-relative slot(s): local_104, local_108, local_10c, local_11f, local_140, local_144, local_148, local_14c, local_150, local_154, local_158, local_15c and 13 more
# fields:       [eax + n] field_21, field_25, field_27, field_90, field_93, field_99, field_a5, field_a8; [ecx + n] field_91, field_97, field_a1, field_a5, field_a7, field_aa; [edx + n] field_23, field_2b, field_2d, field_2f, field_33, field_37, field_3b, field_3f, field_43, field_47, field_4b, field_4f and 21 more
# callees:      calls FUN_0044a2b7, FUN_00448d11, FUN_004fc62d, FUN_004faf98, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/action_family_97_runtime.h:action97_runtime_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 461 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_11f, 0x11f  # offset -0x11f
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_150, 0x150  # offset -0x150
.equ local_154, 0x154  # offset -0x154
.equ local_158, 0x158  # offset -0x158
.equ local_15c, 0x15c  # offset -0x15c
.equ local_160, 0x160  # offset -0x160
.equ local_164, 0x164  # offset -0x164
.equ local_168, 0x168  # offset -0x168
.equ local_16c, 0x16c  # offset -0x16c
.equ local_170, 0x170  # offset -0x170
.equ local_174, 0x174  # offset -0x174
.equ local_178, 0x178  # offset -0x178
.equ local_17c, 0x17c  # offset -0x17c
.equ local_180, 0x180  # offset -0x180
.equ local_184, 0x184  # offset -0x184
.equ local_188, 0x188  # offset -0x188
.equ local_18c, 0x18c  # offset -0x18c
.equ local_190, 0x190  # offset -0x190
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_37, 0x37  # offset +0x37
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_47, 0x47  # offset +0x47
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_57, 0x57  # offset +0x57
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_63, 0x63  # offset +0x63
.equ field_67, 0x67  # offset +0x67
.equ field_6b, 0x6b  # offset +0x6b
.equ field_6f, 0x6f  # offset +0x6f
.equ field_73, 0x73  # offset +0x73
.equ field_77, 0x77  # offset +0x77
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7f, 0x7f  # offset +0x7f
.equ field_83, 0x83  # offset +0x83
.equ field_87, 0x87  # offset +0x87
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_91, 0x91  # offset +0x91
.equ field_93, 0x93  # offset +0x93
.equ field_95, 0x95  # offset +0x95
.equ field_97, 0x97  # offset +0x97
.equ field_99, 0x99  # offset +0x99
.equ field_9d, 0x9d  # offset +0x9d
.equ field_a1, 0xa1  # offset +0xa1
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a7, 0xa7  # offset +0xa7
.equ field_a8, 0xa8  # offset +0xa8
.equ field_aa, 0xaa  # offset +0xaa

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x00432d1a - 0x401000
.globl FUN_00432d1a
FUN_00432d1a:
    # block 0x00432d1a: entry, 5 instruction(s), ends with je to 0x00432d34 (forward)
    push ebp                                     # 00432d1a
    {load} mov ebp, esp                          # 00432d1b
    sub esp, 0x190                               # 00432d1d
    cmp dword ptr [ebp + arg_10], 0x0            # 00432d23
    je.d8 L_00432d34                             # 00432d27
    # block 0x00432d29: entered by fall-through of je at 0x00432d27, 3 instruction(s), ends with forward jump to 0x00432d4a
    mov eax, dword ptr [ebp + arg_10]            # 00432d29
    mov dword ptr [ebp - local_108], eax         # 00432d2c
    jmp.d8 L_00432d4a                            # 00432d32
L_00432d34:
    # block 0x00432d34: entered by je at 0x00432d27, 4 instruction(s), falls into the block at 0x00432d4a
    movsx ecx, word ptr [ebp + arg_8]            # 00432d34
    imul ecx, ecx, 0x8d                          # 00432d38
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432d3e
    mov dword ptr [ebp - local_108], edx         # 00432d44
L_00432d4a:
    # block 0x00432d4a: entered by jmp at 0x00432d32, 9 instruction(s), ends with je to 0x00432d99 (forward)
    mov eax, dword ptr [ebp - local_108]         # 00432d4a
    mov cx, word ptr [eax + field_21]            # 00432d50
    mov word ptr [ebp - local_10c], cx           # 00432d54
    movsx edx, word ptr [ebp + arg_8]            # 00432d5b
    imul edx, edx, 0x8d                          # 00432d5f
    mov eax, dword ptr [edx + 0x5bb632]          # 00432d65
    mov dword ptr [ebp - local_148], eax         # 00432d6b
    cmp dword ptr [ebp - local_148], 0x0         # 00432d71
    je.d8 L_00432d99                             # 00432d78
    # block 0x00432d7a: entered by fall-through of je at 0x00432d78, 2 instruction(s), ends with je to 0x0043353f (forward)
    cmp dword ptr [ebp - local_148], 0x1         # 00432d7a
    je.d32 L_0043353f                            # 00432d81
    # block 0x00432d87: entered by fall-through of je at 0x00432d81, 2 instruction(s), ends with je to 0x00433586 (forward)
    cmp dword ptr [ebp - local_148], 0x2         # 00432d87
    je.d32 L_00433586                            # 00432d8e
    # block 0x00432d94: entered by fall-through of je at 0x00432d8e, 1 instruction(s), ends with forward jump to 0x004336a9
    jmp.d32 L_004336a9                           # 00432d94
L_00432d99:
    # block 0x00432d99: entered by je at 0x00432d78, 3 instruction(s), ends with je to 0x00432db1 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00432d99
    test ecx, ecx                                # 00432da0
    je.d8 L_00432db1                             # 00432da2
    # block 0x00432da4: entered by fall-through of je at 0x00432da2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00432db1
    push 0x545d74                                # 00432da4
    call FUN_0044a2b7                            # 00432da9
    add esp, 0x4                                 # 00432dae
L_00432db1:
    # block 0x00432db1: entered by je at 0x00432da2, 2 instruction(s), ends with je to 0x00432e08 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 00432db1
    je.d8 L_00432e08                             # 00432db8
    # block 0x00432dba: entered by fall-through of je at 0x00432db8, 2 instruction(s), ends with je to 0x00432e08 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 00432dba
    je.d8 L_00432e08                             # 00432dbe
    # block 0x00432dc0: entered by fall-through of je at 0x00432dbe, 8 instruction(s), ends with jle to 0x00432e08 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00432dc0
    imul edx, edx, 0x8d                          # 00432dc4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432dca
    mov dword ptr [ebp - local_144], eax         # 00432dd0
    mov ecx, dword ptr [ebp - local_144]         # 00432dd6
    movsx edx, word ptr [ecx + field_aa]         # 00432ddc
    test edx, edx                                # 00432de3
    jle.d8 L_00432e08                            # 00432de5
    # block 0x00432de7: entered by fall-through of jle at 0x00432de5, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x00432e08
    push 0x0                                     # 00432de7
    push -0x1                                    # 00432de9
    mov eax, dword ptr [ebp - local_144]         # 00432deb
    add eax, 0xac                                # 00432df1
    push eax                                     # 00432df6
    mov ecx, dword ptr [0x5d03b3]                # 00432df7
    push ecx                                     # 00432dfd
    mov ecx, 0x619a05                            # 00432dfe
    call FUN_00448d11                            # 00432e03
L_00432e08:
    # block 0x00432e08: entered by je at 0x00432db8; je at 0x00432dbe; jle at 0x00432de5, 4 instruction(s), ends with je to 0x00432e3c (forward)
    mov edx, dword ptr [ebp - local_108]         # 00432e08
    movsx eax, word ptr [edx + field_a5]         # 00432e0e
    cmp eax, -0x1                                # 00432e15
    je.d8 L_00432e3c                             # 00432e18
    # block 0x00432e1a: entered by fall-through of je at 0x00432e18, 6 instruction(s), falls into the block at 0x00432e3c
    mov ecx, dword ptr [ebp - local_108]         # 00432e1a
    {load} xor edx, edx                          # 00432e20
    mov dl, byte ptr [ecx + field_a7]            # 00432e22
    mov eax, dword ptr [ebp - local_108]         # 00432e28
    movsx ecx, word ptr [eax + field_a5]         # 00432e2e
    mov dword ptr [4*ecx + 0x585801], edx        # 00432e35
L_00432e3c:
    # block 0x00432e3c: entered by je at 0x00432e18, 204 instruction(s), ends with je to 0x004332d8 (forward)
    mov edx, dword ptr [ebp - local_10c]         # 00432e3c
    and edx, 0xffff                              # 00432e42
    imul edx, edx, 0x5bb                         # 00432e48
    mov eax, dword ptr [ebp - local_108]         # 00432e4e
    mov ecx, dword ptr [eax + field_27]          # 00432e54
    mov dword ptr [edx + 0x5c3b9b], ecx          # 00432e57
    mov edx, dword ptr [ebp - local_108]         # 00432e5d
    movsx eax, word ptr [edx + field_2b]         # 00432e63
    mov dword ptr [ebp - local_14c], eax         # 00432e67
    fild dword ptr [ebp - local_14c]             # 00432e6d
    fstp dword ptr [ebp - local_150]             # 00432e73
    fld dword ptr [ebp - local_150]              # 00432e79
    fdiv qword ptr [0x52c680]                    # 00432e7f
    fstp dword ptr [ebp - local_154]             # 00432e85
    fld dword ptr [ebp - local_154]              # 00432e8b
    mov ecx, dword ptr [ebp - local_10c]         # 00432e91
    and ecx, 0xffff                              # 00432e97
    imul ecx, ecx, 0x5bb                         # 00432e9d
    fstp dword ptr [ecx + 0x5c3b9f]              # 00432ea3
    mov edx, dword ptr [ebp - local_108]         # 00432ea9
    movsx eax, word ptr [edx + field_2d]         # 00432eaf
    mov dword ptr [ebp - local_158], eax         # 00432eb3
    fild dword ptr [ebp - local_158]             # 00432eb9
    fstp dword ptr [ebp - local_15c]             # 00432ebf
    fld dword ptr [ebp - local_15c]              # 00432ec5
    fdiv qword ptr [0x52c680]                    # 00432ecb
    fstp dword ptr [ebp - local_160]             # 00432ed1
    fld dword ptr [ebp - local_160]              # 00432ed7
    mov ecx, dword ptr [ebp - local_10c]         # 00432edd
    and ecx, 0xffff                              # 00432ee3
    imul ecx, ecx, 0x5bb                         # 00432ee9
    fstp dword ptr [ecx + 0x5c3ba3]              # 00432eef
    mov edx, dword ptr [ebp - local_10c]         # 00432ef5
    and edx, 0xffff                              # 00432efb
    imul edx, edx, 0x5bb                         # 00432f01
    mov eax, dword ptr [ebp - local_108]         # 00432f07
    mov cx, word ptr [eax + field_25]            # 00432f0d
    mov word ptr [edx + 0x5c3b97], cx            # 00432f11
    mov edx, dword ptr [ebp - local_10c]         # 00432f18
    and edx, 0xffff                              # 00432f1e
    imul edx, edx, 0x5bb                         # 00432f24
    mov dword ptr [edx + 0x5c3bd1], 0x0          # 00432f2a
    mov eax, dword ptr [ebp - local_10c]         # 00432f34
    and eax, 0xffff                              # 00432f3a
    imul eax, eax, 0x5bb                         # 00432f3f
    mov word ptr [eax + 0x5c3b99], 0x0           # 00432f45
    mov ecx, dword ptr [ebp - local_10c]         # 00432f4e
    and ecx, 0xffff                              # 00432f54
    imul ecx, ecx, 0x5bb                         # 00432f5a
    mov edx, dword ptr [ebp - local_108]         # 00432f60
    mov eax, dword ptr [edx + field_2f]          # 00432f66
    mov dword ptr [ecx + 0x5c3c15], eax          # 00432f69
    mov ecx, dword ptr [ebp - local_10c]         # 00432f6f
    and ecx, 0xffff                              # 00432f75
    imul ecx, ecx, 0x5bb                         # 00432f7b
    mov edx, dword ptr [ebp - local_108]         # 00432f81
    mov eax, dword ptr [edx + field_33]          # 00432f87
    mov dword ptr [ecx + 0x5c3c19], eax          # 00432f8a
    mov ecx, dword ptr [ebp - local_10c]         # 00432f90
    and ecx, 0xffff                              # 00432f96
    imul ecx, ecx, 0x5bb                         # 00432f9c
    mov edx, dword ptr [ebp - local_108]         # 00432fa2
    mov eax, dword ptr [edx + field_37]          # 00432fa8
    mov dword ptr [ecx + 0x5c3c1d], eax          # 00432fab
    mov ecx, dword ptr [ebp - local_10c]         # 00432fb1
    and ecx, 0xffff                              # 00432fb7
    imul ecx, ecx, 0x5bb                         # 00432fbd
    mov edx, dword ptr [ebp - local_108]         # 00432fc3
    mov eax, dword ptr [edx + field_3b]          # 00432fc9
    mov dword ptr [ecx + 0x5c3c21], eax          # 00432fcc
    mov ecx, dword ptr [ebp - local_10c]         # 00432fd2
    and ecx, 0xffff                              # 00432fd8
    imul ecx, ecx, 0x5bb                         # 00432fde
    mov edx, dword ptr [ebp - local_108]         # 00432fe4
    mov eax, dword ptr [edx + field_3f]          # 00432fea
    mov dword ptr [ecx + 0x5c3c25], eax          # 00432fed
    mov ecx, dword ptr [ebp - local_10c]         # 00432ff3
    and ecx, 0xffff                              # 00432ff9
    imul ecx, ecx, 0x5bb                         # 00432fff
    mov edx, dword ptr [ebp - local_108]         # 00433005
    mov eax, dword ptr [edx + field_43]          # 0043300b
    mov dword ptr [ecx + 0x5c3c29], eax          # 0043300e
    mov ecx, dword ptr [ebp - local_10c]         # 00433014
    and ecx, 0xffff                              # 0043301a
    imul ecx, ecx, 0x5bb                         # 00433020
    mov edx, dword ptr [ebp - local_108]         # 00433026
    mov eax, dword ptr [edx + field_47]          # 0043302c
    mov dword ptr [ecx + 0x5c3c2d], eax          # 0043302f
    mov ecx, dword ptr [ebp - local_10c]         # 00433035
    and ecx, 0xffff                              # 0043303b
    imul ecx, ecx, 0x5bb                         # 00433041
    mov edx, dword ptr [ebp - local_108]         # 00433047
    mov eax, dword ptr [edx + field_4b]          # 0043304d
    mov dword ptr [ecx + 0x5c3c31], eax          # 00433050
    mov ecx, dword ptr [ebp - local_10c]         # 00433056
    and ecx, 0xffff                              # 0043305c
    imul ecx, ecx, 0x5bb                         # 00433062
    mov edx, dword ptr [ebp - local_108]         # 00433068
    mov eax, dword ptr [edx + field_4f]          # 0043306e
    mov dword ptr [ecx + 0x5c3c35], eax          # 00433071
    mov ecx, dword ptr [ebp - local_10c]         # 00433077
    and ecx, 0xffff                              # 0043307d
    imul ecx, ecx, 0x5bb                         # 00433083
    mov edx, dword ptr [ebp - local_108]         # 00433089
    mov eax, dword ptr [edx + field_53]          # 0043308f
    mov dword ptr [ecx + 0x5c3c39], eax          # 00433092
    mov ecx, dword ptr [ebp - local_10c]         # 00433098
    and ecx, 0xffff                              # 0043309e
    imul ecx, ecx, 0x5bb                         # 004330a4
    mov edx, dword ptr [ebp - local_108]         # 004330aa
    mov eax, dword ptr [edx + field_57]          # 004330b0
    mov dword ptr [ecx + 0x5c3c3d], eax          # 004330b3
    mov ecx, dword ptr [ebp - local_10c]         # 004330b9
    and ecx, 0xffff                              # 004330bf
    imul ecx, ecx, 0x5bb                         # 004330c5
    mov edx, dword ptr [ebp - local_108]         # 004330cb
    mov eax, dword ptr [edx + field_5b]          # 004330d1
    mov dword ptr [ecx + 0x5c3c41], eax          # 004330d4
    mov ecx, dword ptr [ebp - local_10c]         # 004330da
    and ecx, 0xffff                              # 004330e0
    imul ecx, ecx, 0x5bb                         # 004330e6
    mov edx, dword ptr [ebp - local_108]         # 004330ec
    mov eax, dword ptr [edx + field_5f]          # 004330f2
    mov dword ptr [ecx + 0x5c3c45], eax          # 004330f5
    mov ecx, dword ptr [ebp - local_10c]         # 004330fb
    and ecx, 0xffff                              # 00433101
    imul ecx, ecx, 0x5bb                         # 00433107
    mov edx, dword ptr [ebp - local_108]         # 0043310d
    mov eax, dword ptr [edx + field_63]          # 00433113
    mov dword ptr [ecx + 0x5c3c75], eax          # 00433116
    mov ecx, dword ptr [ebp - local_10c]         # 0043311c
    and ecx, 0xffff                              # 00433122
    imul ecx, ecx, 0x5bb                         # 00433128
    mov edx, dword ptr [ebp - local_108]         # 0043312e
    mov eax, dword ptr [edx + field_67]          # 00433134
    mov dword ptr [ecx + 0x5c3c79], eax          # 00433137
    mov ecx, dword ptr [ebp - local_10c]         # 0043313d
    and ecx, 0xffff                              # 00433143
    imul ecx, ecx, 0x5bb                         # 00433149
    mov edx, dword ptr [ebp - local_108]         # 0043314f
    mov eax, dword ptr [edx + field_6b]          # 00433155
    mov dword ptr [ecx + 0x5c3c7d], eax          # 00433158
    mov ecx, dword ptr [ebp - local_10c]         # 0043315e
    and ecx, 0xffff                              # 00433164
    imul ecx, ecx, 0x5bb                         # 0043316a
    mov edx, dword ptr [ebp - local_108]         # 00433170
    mov eax, dword ptr [edx + field_6f]          # 00433176
    mov dword ptr [ecx + 0x5c3c81], eax          # 00433179
    mov ecx, dword ptr [ebp - local_10c]         # 0043317f
    and ecx, 0xffff                              # 00433185
    imul ecx, ecx, 0x5bb                         # 0043318b
    mov edx, dword ptr [ebp - local_108]         # 00433191
    mov eax, dword ptr [edx + field_73]          # 00433197
    mov dword ptr [ecx + 0x5c3c85], eax          # 0043319a
    mov ecx, dword ptr [ebp - local_10c]         # 004331a0
    and ecx, 0xffff                              # 004331a6
    imul ecx, ecx, 0x5bb                         # 004331ac
    mov edx, dword ptr [ebp - local_108]         # 004331b2
    mov eax, dword ptr [edx + field_77]          # 004331b8
    mov dword ptr [ecx + 0x5c3c89], eax          # 004331bb
    mov ecx, dword ptr [ebp - local_10c]         # 004331c1
    and ecx, 0xffff                              # 004331c7
    imul ecx, ecx, 0x5bb                         # 004331cd
    mov edx, dword ptr [ebp - local_108]         # 004331d3
    mov eax, dword ptr [edx + field_7b]          # 004331d9
    mov dword ptr [ecx + 0x5c3c8d], eax          # 004331dc
    mov ecx, dword ptr [ebp - local_10c]         # 004331e2
    and ecx, 0xffff                              # 004331e8
    imul ecx, ecx, 0x5bb                         # 004331ee
    mov edx, dword ptr [ebp - local_108]         # 004331f4
    mov eax, dword ptr [edx + field_7f]          # 004331fa
    mov dword ptr [ecx + 0x5c3c91], eax          # 004331fd
    mov ecx, dword ptr [ebp - local_10c]         # 00433203
    and ecx, 0xffff                              # 00433209
    imul ecx, ecx, 0x5bb                         # 0043320f
    mov edx, dword ptr [ebp - local_108]         # 00433215
    mov eax, dword ptr [edx + field_83]          # 0043321b
    mov dword ptr [ecx + 0x5c3c95], eax          # 00433221
    mov ecx, dword ptr [ebp - local_10c]         # 00433227
    and ecx, 0xffff                              # 0043322d
    imul ecx, ecx, 0x5bb                         # 00433233
    mov edx, dword ptr [ebp - local_108]         # 00433239
    mov al, byte ptr [edx + field_87]            # 0043323f
    mov byte ptr [ecx + 0x5c3c99], al            # 00433245
    mov ecx, dword ptr [ebp - local_10c]         # 0043324b
    and ecx, 0xffff                              # 00433251
    imul ecx, ecx, 0x5bb                         # 00433257
    mov edx, dword ptr [ebp - local_108]         # 0043325d
    mov eax, dword ptr [edx + field_88]          # 00433263
    mov dword ptr [ecx + 0x5c3cea], eax          # 00433269
    mov ecx, dword ptr [ebp - local_10c]         # 0043326f
    and ecx, 0xffff                              # 00433275
    imul ecx, ecx, 0x5bb                         # 0043327b
    mov edx, dword ptr [ebp - local_108]         # 00433281
    mov eax, dword ptr [edx + field_8c]          # 00433287
    mov dword ptr [ecx + 0x5c3cee], eax          # 0043328d
    mov ecx, dword ptr [ebp - local_10c]         # 00433293
    and ecx, 0xffff                              # 00433299
    imul ecx, ecx, 0x5bb                         # 0043329f
    fld dword ptr [ecx + 0x5c3b9f]               # 004332a5
    fcomp qword ptr [0x52c598]                   # 004332ab
    fnstsw ax                                    # 004332b1
    test ah, 0x1                                 # 004332b3
    je.d8 L_004332d8                             # 004332b6
    # block 0x004332b8: entered by fall-through of je at 0x004332b6, 6 instruction(s), ends with forward jump to 0x004332ec
    mov edx, dword ptr [ebp - local_10c]         # 004332b8
    and edx, 0xffff                              # 004332be
    imul edx, edx, 0x5bb                         # 004332c4
    fld dword ptr [edx + 0x5c3b9f]               # 004332ca
    fstp qword ptr [ebp - local_168]             # 004332d0
    jmp.d8 L_004332ec                            # 004332d6
L_004332d8:
    # block 0x004332d8: entered by je at 0x004332b6, 2 instruction(s), falls into the block at 0x004332ec
    mov dword ptr [ebp - local_168], 0x0         # 004332d8
    mov dword ptr [ebp - local_164], 0x3ff00000  # 004332e2
L_004332ec:
    # block 0x004332ec: entered by jmp at 0x004332d6, 15 instruction(s), ends with jne to 0x0043335a (forward)
    fld qword ptr [ebp - local_168]              # 004332ec
    fstp dword ptr [ebp - local_16c]             # 004332f2
    fld dword ptr [ebp - local_16c]              # 004332f8
    mov eax, dword ptr [ebp - local_10c]         # 004332fe
    and eax, 0xffff                              # 00433304
    imul eax, eax, 0x5bb                         # 00433309
    fstp dword ptr [eax + 0x5c3b9f]              # 0043330f
    mov ecx, dword ptr [ebp - local_10c]         # 00433315
    and ecx, 0xffff                              # 0043331b
    imul ecx, ecx, 0x5bb                         # 00433321
    fld dword ptr [ecx + 0x5c3b9f]               # 00433327
    fcomp qword ptr [0x52c7b0]                   # 0043332d
    fnstsw ax                                    # 00433333
    test ah, 0x41                                # 00433335
    jne.d8 L_0043335a                            # 00433338
    # block 0x0043333a: entered by fall-through of jne at 0x00433338, 6 instruction(s), ends with forward jump to 0x0043336e
    mov edx, dword ptr [ebp - local_10c]         # 0043333a
    and edx, 0xffff                              # 00433340
    imul edx, edx, 0x5bb                         # 00433346
    fld dword ptr [edx + 0x5c3b9f]               # 0043334c
    fstp qword ptr [ebp - local_174]             # 00433352
    jmp.d8 L_0043336e                            # 00433358
L_0043335a:
    # block 0x0043335a: entered by jne at 0x00433338, 2 instruction(s), falls into the block at 0x0043336e
    mov dword ptr [ebp - local_174], 0x0         # 0043335a
    mov dword ptr [ebp - local_170], 0x0         # 00433364
L_0043336e:
    # block 0x0043336e: entered by jmp at 0x00433358, 15 instruction(s), ends with je to 0x004333dc (forward)
    fld qword ptr [ebp - local_174]              # 0043336e
    fstp dword ptr [ebp - local_178]             # 00433374
    fld dword ptr [ebp - local_178]              # 0043337a
    mov eax, dword ptr [ebp - local_10c]         # 00433380
    and eax, 0xffff                              # 00433386
    imul eax, eax, 0x5bb                         # 0043338b
    fstp dword ptr [eax + 0x5c3b9f]              # 00433391
    mov ecx, dword ptr [ebp - local_10c]         # 00433397
    and ecx, 0xffff                              # 0043339d
    imul ecx, ecx, 0x5bb                         # 004333a3
    fld dword ptr [ecx + 0x5c3ba3]               # 004333a9
    fcomp qword ptr [0x52c598]                   # 004333af
    fnstsw ax                                    # 004333b5
    test ah, 0x1                                 # 004333b7
    je.d8 L_004333dc                             # 004333ba
    # block 0x004333bc: entered by fall-through of je at 0x004333ba, 6 instruction(s), ends with forward jump to 0x004333f0
    mov edx, dword ptr [ebp - local_10c]         # 004333bc
    and edx, 0xffff                              # 004333c2
    imul edx, edx, 0x5bb                         # 004333c8
    fld dword ptr [edx + 0x5c3ba3]               # 004333ce
    fstp qword ptr [ebp - local_180]             # 004333d4
    jmp.d8 L_004333f0                            # 004333da
L_004333dc:
    # block 0x004333dc: entered by je at 0x004333ba, 2 instruction(s), falls into the block at 0x004333f0
    mov dword ptr [ebp - local_180], 0x0         # 004333dc
    mov dword ptr [ebp - local_17c], 0x3ff00000  # 004333e6
L_004333f0:
    # block 0x004333f0: entered by jmp at 0x004333da, 15 instruction(s), ends with jne to 0x0043345e (forward)
    fld qword ptr [ebp - local_180]              # 004333f0
    fstp dword ptr [ebp - local_184]             # 004333f6
    fld dword ptr [ebp - local_184]              # 004333fc
    mov eax, dword ptr [ebp - local_10c]         # 00433402
    and eax, 0xffff                              # 00433408
    imul eax, eax, 0x5bb                         # 0043340d
    fstp dword ptr [eax + 0x5c3ba3]              # 00433413
    mov ecx, dword ptr [ebp - local_10c]         # 00433419
    and ecx, 0xffff                              # 0043341f
    imul ecx, ecx, 0x5bb                         # 00433425
    fld dword ptr [ecx + 0x5c3ba3]               # 0043342b
    fcomp qword ptr [0x52c7b0]                   # 00433431
    fnstsw ax                                    # 00433437
    test ah, 0x41                                # 00433439
    jne.d8 L_0043345e                            # 0043343c
    # block 0x0043343e: entered by fall-through of jne at 0x0043343c, 6 instruction(s), ends with forward jump to 0x00433472
    mov edx, dword ptr [ebp - local_10c]         # 0043343e
    and edx, 0xffff                              # 00433444
    imul edx, edx, 0x5bb                         # 0043344a
    fld dword ptr [edx + 0x5c3ba3]               # 00433450
    fstp qword ptr [ebp - local_18c]             # 00433456
    jmp.d8 L_00433472                            # 0043345c
L_0043345e:
    # block 0x0043345e: entered by jne at 0x0043343c, 2 instruction(s), falls into the block at 0x00433472
    mov dword ptr [ebp - local_18c], 0x0         # 0043345e
    mov dword ptr [ebp - local_188], 0x0         # 00433468
L_00433472:
    # block 0x00433472: entered by jmp at 0x0043345c, 29 instruction(s), calls FUN_004fc62d, FUN_004faf98, ends with jne to 0x00433526 (forward)
    fld qword ptr [ebp - local_18c]              # 00433472
    fstp dword ptr [ebp - local_190]             # 00433478
    fld dword ptr [ebp - local_190]              # 0043347e
    mov eax, dword ptr [ebp - local_10c]         # 00433484
    and eax, 0xffff                              # 0043348a
    imul eax, eax, 0x5bb                         # 0043348f
    fstp dword ptr [eax + 0x5c3ba3]              # 00433495
    push 0x0                                     # 0043349b
    lea ecx, [ebp - local_104]                   # 0043349d
    push ecx                                     # 004334a3
    mov edx, dword ptr [ebp - local_108]         # 004334a4
    movsx eax, word ptr [edx + field_23]         # 004334aa
    push eax                                     # 004334ae
    mov ecx, dword ptr [ebp - local_108]         # 004334af
    push ecx                                     # 004334b5
    mov dx, word ptr [ebp - local_10c]           # 004334b6
    push edx                                     # 004334bd
    mov ecx, 0x5c3a67                            # 004334be
    call FUN_004fc62d                            # 004334c3
    mov ax, word ptr [ebp - local_10c]           # 004334c8
    push eax                                     # 004334cf
    lea ecx, [ebp - local_104]                   # 004334d0
    push ecx                                     # 004334d6
    mov ecx, 0x5c3a67                            # 004334d7
    call FUN_004faf98                            # 004334dc
    mov edx, dword ptr [ebp - local_108]         # 004334e1
    movsx eax, word ptr [edx + field_91]         # 004334e7
    cmp eax, 0x270f                              # 004334ee
    jne.d8 L_00433526                            # 004334f3
    # block 0x004334f5: entered by fall-through of jne at 0x004334f3, 4 instruction(s), ends with jne to 0x00433526 (forward)
    mov ecx, dword ptr [ebp - local_108]         # 004334f5
    movsx edx, word ptr [ecx + field_a5]         # 004334fb
    cmp edx, -0x1                                # 00433502
    jne.d8 L_00433526                            # 00433505
    # block 0x00433507: entered by fall-through of jne at 0x00433505, 3 instruction(s), ends with jne to 0x00433526 (forward)
    mov eax, dword ptr [ebp - local_108]         # 00433507
    cmp dword ptr [eax + field_27], 0x0          # 0043350d
    jne.d8 L_00433526                            # 00433511
    # block 0x00433513: entered by fall-through of jne at 0x00433511, 4 instruction(s), ends with forward jump to 0x0043353a
    movsx ecx, word ptr [ebp + arg_8]            # 00433513
    imul ecx, ecx, 0x8d                          # 00433517
    mov byte ptr [ecx + 0x5bb625], 0x1           # 0043351d
    jmp.d8 L_0043353a                            # 00433524
L_00433526:
    # block 0x00433526: entered by jne at 0x004334f3; jne at 0x00433505; jne at 0x00433511, 3 instruction(s), falls into the block at 0x0043353a
    movsx edx, word ptr [ebp + arg_8]            # 00433526
    imul edx, edx, 0x8d                          # 0043352a
    mov dword ptr [edx + 0x5bb632], 0x1          # 00433530
L_0043353a:
    # block 0x0043353a: entered by jmp at 0x00433524, 1 instruction(s), ends with forward jump to 0x004336a9
    jmp.d32 L_004336a9                           # 0043353a
L_0043353f:
    # block 0x0043353f: entered by je at 0x00432d81, 5 instruction(s), ends with je to 0x0043356d (forward)
    mov eax, dword ptr [ebp - local_108]         # 0043353f
    {load} xor ecx, ecx                          # 00433545
    mov cl, byte ptr [eax + field_90]            # 00433547
    cmp ecx, 0x1                                 # 0043354d
    je.d8 L_0043356d                             # 00433550
    # block 0x00433552: entered by fall-through of je at 0x00433550, 7 instruction(s), calls FUN_004f6334, ends with jne to 0x00433581 (forward)
    mov edx, dword ptr [ebp - local_10c]         # 00433552
    and edx, 0xffff                              # 00433558
    push edx                                     # 0043355e
    mov ecx, 0x5cf1eb                            # 0043355f
    call FUN_004f6334                            # 00433564
    test eax, eax                                # 00433569
    jne.d8 L_00433581                            # 0043356b
L_0043356d:
    # block 0x0043356d: entered by je at 0x00433550; fall-through of jne at 0x0043356b, 3 instruction(s), falls into the block at 0x00433581
    movsx eax, word ptr [ebp + arg_8]            # 0043356d
    imul eax, eax, 0x8d                          # 00433571
    mov dword ptr [eax + 0x5bb632], 0x2          # 00433577
L_00433581:
    # block 0x00433581: entered by jne at 0x0043356b, 1 instruction(s), ends with forward jump to 0x004336a9
    jmp.d32 L_004336a9                           # 00433581
L_00433586:
    # block 0x00433586: entered by je at 0x00432d8e, 3 instruction(s), ends with je to 0x0043359e (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00433586
    test ecx, ecx                                # 0043358d
    je.d8 L_0043359e                             # 0043358f
    # block 0x00433591: entered by fall-through of je at 0x0043358f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043359e
    push 0x545d9c                                # 00433591
    call FUN_0044a2b7                            # 00433596
    add esp, 0x4                                 # 0043359b
L_0043359e:
    # block 0x0043359e: entered by je at 0x0043358f, 4 instruction(s), ends with je to 0x0043366b (forward)
    mov edx, dword ptr [ebp - local_108]         # 0043359e
    movsx eax, word ptr [edx + field_91]         # 004335a4
    cmp eax, 0x270f                              # 004335ab
    je.d32 L_0043366b                            # 004335b0
    # block 0x004335b6: entered by fall-through of je at 0x004335b0, 25 instruction(s), ends with jne to 0x00433657 (forward)
    mov ecx, dword ptr [ebp - local_108]         # 004335b6
    movsx edx, word ptr [ecx + field_91]         # 004335bc
    mov dword ptr [0x5bb57b], edx                # 004335c3
    mov eax, dword ptr [ebp - local_108]         # 004335c9
    mov cx, word ptr [eax + field_93]            # 004335cf
    mov word ptr [0x5bb599], cx                  # 004335d6
    mov edx, dword ptr [ebp - local_108]         # 004335dd
    mov ax, word ptr [edx + field_95]            # 004335e3
    mov word ptr [0x5bb595], ax                  # 004335ea
    mov ecx, dword ptr [ebp - local_108]         # 004335f0
    mov dx, word ptr [ecx + field_97]            # 004335f6
    mov word ptr [0x5c39ff], dx                  # 004335fd
    mov eax, dword ptr [ebp - local_108]         # 00433604
    mov ecx, dword ptr [eax + field_99]          # 0043360a
    mov dword ptr [0x5bb59b], ecx                # 00433610
    mov edx, dword ptr [ebp - local_108]         # 00433616
    mov eax, dword ptr [edx + field_9d]          # 0043361c
    mov dword ptr [0x5bb59f], eax                # 00433622
    mov ecx, dword ptr [ebp - local_108]         # 00433627
    mov edx, dword ptr [ecx + field_a1]          # 0043362d
    mov dword ptr [0x5bb5a3], edx                # 00433633
    mov eax, dword ptr [ebp - local_108]         # 00433639
    movsx ecx, word ptr [eax + field_a8]         # 0043363f
    cmp ecx, 0x1                                 # 00433646
    jne.d8 L_00433657                            # 00433649
    # block 0x0043364b: entered by fall-through of jne at 0x00433649, 2 instruction(s), ends with forward jump to 0x00433661
    mov dword ptr [0x5bb1ca], 0x0                # 0043364b
    jmp.d8 L_00433661                            # 00433655
L_00433657:
    # block 0x00433657: entered by jne at 0x00433649, 1 instruction(s), falls into the block at 0x00433661
    mov dword ptr [0x5bb1ca], 0x1                # 00433657
L_00433661:
    # block 0x00433661: entered by jmp at 0x00433655, 1 instruction(s), falls into the block at 0x0043366b
    mov dword ptr [0x583999], 0x4                # 00433661
L_0043366b:
    # block 0x0043366b: entered by je at 0x004335b0, 5 instruction(s), ends with jne to 0x0043369c (forward)
    mov edx, dword ptr [ebp - local_108]         # 0043366b
    {load} xor eax, eax                          # 00433671
    mov al, byte ptr [edx + field_90]            # 00433673
    test eax, eax                                # 00433679
    jne.d8 L_0043369c                            # 0043367b
    # block 0x0043367d: entered by fall-through of jne at 0x0043367b, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x0043369c
    mov cx, word ptr [ebp - local_10c]           # 0043367d
    mov word ptr [ebp - local_11f], cx           # 00433684
    lea edx, [ebp - local_140]                   # 0043368b
    push edx                                     # 00433691
    mov ecx, 0x5c3a67                            # 00433692
    call FUN_004fba69                            # 00433697
L_0043369c:
    # block 0x0043369c: entered by jne at 0x0043367b, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004336a9
    mov ax, word ptr [ebp + arg_8]               # 0043369c
    push eax                                     # 004336a0
    call FUN_0042ba3a                            # 004336a1
    add esp, 0x4                                 # 004336a6
L_004336a9:
    # block 0x004336a9: entered by jmp at 0x00432d94; jmp at 0x0043353a; jmp at 0x00433581, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004336a9
    pop ebp                                      # 004336ab
    ret                                          # 004336ac

