# FUN_004bf9bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf9bb
# extent:       0x004bf9bb-0x004c0205 (2122 code bytes)
# span:         0x004bf9bb-0x004c0205 (code 2122, tables 0, padding 0)
# sha256:       d9c1c2583dff6cdb1d1b3d1f84a04b2df5f9c7ef5d615de89ac2ae5ae4eccdd4
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf9bb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       15 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 3 more
# fields:       [eax + n] field_21, field_29, field_2b, field_17a, field_17e, field_182, field_192, field_1ba, field_1be, field_1d6, field_1da, field_21e and 7 more; [ecx + n] field_27, field_2d, field_3b, field_17a, field_1b2, field_1b6, field_1ba, field_1be, field_1ca, field_1cc, field_1d4, field_1d6 and 11 more; [edx + n] field_2, field_4, field_21, field_27, field_17e, field_18e, field_1b2, field_1b6, field_1ca, field_1ce, field_1d6, field_21a and 8 more
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004d36ed, FUN_004bede7, FUN_0041632b, FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, FUN_004c2c3a, FUN_004161d1, FUN_0051dc43, FUN_004497a0 and 9 more; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_start (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 492 instruction(s), 26 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_3b, 0x3b  # offset +0x3b
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1da, 0x1da  # offset +0x1da
.equ field_20e, 0x20e  # offset +0x20e
.equ field_216, 0x216  # offset +0x216
.equ field_21a, 0x21a  # offset +0x21a
.equ field_21e, 0x21e  # offset +0x21e
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22e, 0x22e  # offset +0x22e
.equ field_230, 0x230  # offset +0x230
.equ field_234, 0x234  # offset +0x234
.equ field_236, 0x236  # offset +0x236
.equ field_23a, 0x23a  # offset +0x23a
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_004161d1, .text + (0x004161d1 - 0x401000)
.set FUN_0041632b, .text + (0x0041632b - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004497a0, .text + (0x004497a0 - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0044c4c1, .text + (0x0044c4c1 - 0x401000)
.set FUN_004bede7, .text + (0x004bede7 - 0x401000)
.set FUN_004bef11, .text + (0x004bef11 - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c0205, .text + (0x004c0205 - 0x401000)
.set FUN_004c04e3, .text + (0x004c04e3 - 0x401000)
.set FUN_004c0774, .text + (0x004c0774 - 0x401000)
.set FUN_004c2c3a, .text + (0x004c2c3a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004bf9bb - 0x401000
.globl FUN_004bf9bb
FUN_004bf9bb:
    # block 0x004bf9bb: entry, 52 instruction(s), ends with je to 0x004bfaab (forward)
    push ebp                                     # 004bf9bb
    {load} mov ebp, esp                          # 004bf9bc
    push -0x1                                    # 004bf9be
    push 0x52879b                                # 004bf9c0
    mov eax, dword ptr fs:[0x0]                  # 004bf9c5
    push eax                                     # 004bf9cb
    mov dword ptr fs:[0x0], esp                  # 004bf9cc
    sub esp, 0x34                                # 004bf9d3
    push esi                                     # 004bf9d6
    push edi                                     # 004bf9d7
    mov dword ptr [ebp - local_24], ecx          # 004bf9d8
    movsx eax, word ptr [ebp + arg_8]            # 004bf9db
    imul eax, eax, 0x8d                          # 004bf9df
    mov ecx, dword ptr [ebp - local_24]          # 004bf9e5
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004bf9e8
    mov dword ptr [ecx + field_226], edx         # 004bf9ee
    mov eax, dword ptr [ebp - local_24]          # 004bf9f4
    mov ecx, dword ptr [ebp - local_24]          # 004bf9f7
    mov edx, dword ptr [ecx + field_226]         # 004bf9fa
    mov dword ptr [eax + field_22a], edx         # 004bfa00
    mov eax, dword ptr [ebp - local_24]          # 004bfa06
    mov ecx, dword ptr [eax + field_226]         # 004bfa09
    mov edx, dword ptr [ebp - local_24]          # 004bfa0f
    mov ax, word ptr [ecx + field_3b]            # 004bfa12
    mov word ptr [edx + field_22e], ax           # 004bfa16
    mov ecx, dword ptr [ebp - local_24]          # 004bfa1d
    mov edx, dword ptr [ecx + field_226]         # 004bfa20
    add edx, 0x3d                                # 004bfa26
    mov eax, dword ptr [ebp - local_24]          # 004bfa29
    mov dword ptr [eax + field_230], edx         # 004bfa2c
    mov ecx, dword ptr [ebp - local_24]          # 004bfa32
    mov edx, dword ptr [ecx + field_230]         # 004bfa35
    mov eax, dword ptr [ebp - local_24]          # 004bfa3b
    movsx ecx, word ptr [eax + field_22e]        # 004bfa3e
    imul ecx, ecx, 0x6                           # 004bfa45
    lea edx, [edx + ecx + field_2]               # 004bfa48
    mov eax, dword ptr [ebp - local_24]          # 004bfa4c
    mov dword ptr [eax + field_236], edx         # 004bfa4f
    mov ecx, dword ptr [ebp - local_24]          # 004bfa55
    mov edx, dword ptr [ecx + field_236]         # 004bfa58
    movsx ax, byte ptr [edx - field_minus_2]     # 004bfa5e
    mov ecx, dword ptr [ebp - local_24]          # 004bfa63
    mov word ptr [ecx + field_234], ax           # 004bfa66
    mov edx, dword ptr [ebp - local_24]          # 004bfa6d
    mov eax, dword ptr [edx + field_236]         # 004bfa70
    mov dword ptr [ebp - local_10], eax          # 004bfa76
    movsx ecx, word ptr [ebp + arg_8]            # 004bfa79
    imul ecx, ecx, 0x8d                          # 004bfa7d
    mov edx, dword ptr [ecx + 0x5bb632]          # 004bfa83
    mov dword ptr [ebp - local_28], edx          # 004bfa89
    cmp dword ptr [ebp - local_28], 0x0          # 004bfa8c
    je.d8 L_004bfaab                             # 004bfa90
    # block 0x004bfa92: entered by fall-through of je at 0x004bfa90, 2 instruction(s), ends with je to 0x004c008f (forward)
    cmp dword ptr [ebp - local_28], 0x1          # 004bfa92
    je.d32 L_004c008f                            # 004bfa96
    # block 0x004bfa9c: entered by fall-through of je at 0x004bfa96, 2 instruction(s), ends with je to 0x004c01e6 (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 004bfa9c
    je.d32 L_004c01e6                            # 004bfaa0
    # block 0x004bfaa6: entered by fall-through of je at 0x004bfaa0, 1 instruction(s), ends with forward jump to 0x004c01f3
    jmp.d32 L_004c01f3                           # 004bfaa6
L_004bfaab:
    # block 0x004bfaab: entered by je at 0x004bfa90, 2 instruction(s), ends with je to 0x004bfaf8 (forward)
    cmp dword ptr [0x5c39f9], 0x0                # 004bfaab
    je.d8 L_004bfaf8                             # 004bfab2
    # block 0x004bfab4: entered by fall-through of je at 0x004bfab2, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c01f3
    movsx eax, word ptr [ebp + arg_8]            # 004bfab4
    imul eax, eax, 0x8d                          # 004bfab8
    add eax, 0x5bb5b3                            # 004bfabe
    push eax                                     # 004bfac3
    movsx ecx, word ptr [ebp + arg_8]            # 004bfac4
    push ecx                                     # 004bfac8
    push 0x552724                                # 004bfac9
    push 0x63888b                                # 004bface
    call FUN_0050ca3e                            # 004bfad3
    add esp, 0x10                                # 004bfad8
    push 0x0                                     # 004bfadb
    push 0x0                                     # 004bfadd
    push 0x63888b                                # 004bfadf
    call FUN_0052139c                            # 004bfae4
    mov ecx, 0x5cf659                            # 004bfae9
    call FUN_004c97b4                            # 004bfaee
    jmp.d32 L_004c01f3                           # 004bfaf3
L_004bfaf8:
    # block 0x004bfaf8: entered by je at 0x004bfab2, 14 instruction(s), calls FUN_004d36ed, ends with jne to 0x004bfb5a (forward)
    mov edx, dword ptr [ebp - local_24]          # 004bfaf8
    mov dword ptr [edx + field_240], 0x1         # 004bfafb
    mov eax, dword ptr [ebp - local_24]          # 004bfb05
    mov word ptr [eax + field_192], 0x0          # 004bfb08
    mov dword ptr [0x5bb1ca], 0x1                # 004bfb11
    call FUN_004d36ed                            # 004bfb1b
    mov ecx, dword ptr [ebp - local_24]          # 004bfb20
    mov edx, dword ptr [0x5839a9]                # 004bfb23
    mov dword ptr [ecx + field_20e], edx         # 004bfb29
    mov eax, dword ptr [ebp - local_24]          # 004bfb2f
    mov ecx, dword ptr [eax + field_22a]         # 004bfb32
    movsx edx, word ptr [ecx + field_27]         # 004bfb38
    cmp edx, 0x1                                 # 004bfb3c
    jne.d8 L_004bfb5a                            # 004bfb3f
    # block 0x004bfb41: entered by fall-through of jne at 0x004bfb3f, 4 instruction(s), ends with forward jump to 0x004bfb8f
    mov dword ptr [0x5839a9], 0x0                # 004bfb41
    mov eax, dword ptr [ebp - local_24]          # 004bfb4b
    mov dword ptr [eax + field_17a], 0x1         # 004bfb4e
    jmp.d8 L_004bfb8f                            # 004bfb58
L_004bfb5a:
    # block 0x004bfb5a: entered by jne at 0x004bfb3f, 6 instruction(s), falls into the block at 0x004bfb8f
    mov dword ptr [0x5839a9], 0x1                # 004bfb5a
    mov dword ptr [0x5d16cd], 0x0                # 004bfb64
    mov dword ptr [0x5d1683], 0x0                # 004bfb6e
    mov dword ptr [0x5d1639], 0x0                # 004bfb78
    mov ecx, dword ptr [ebp - local_24]          # 004bfb82
    mov dword ptr [ecx + field_17a], 0x0         # 004bfb85
L_004bfb8f:
    # block 0x004bfb8f: entered by jmp at 0x004bfb58, 8 instruction(s), calls FUN_004bede7, ends with je to 0x004bfbbe (forward)
    mov ecx, 0x6201f9                            # 004bfb8f
    call FUN_004bede7                            # 004bfb94
    mov edx, dword ptr [ebp - local_24]          # 004bfb99
    mov eax, dword ptr [edx + field_22a]         # 004bfb9c
    movsx ecx, word ptr [eax + field_21]         # 004bfba2
    mov dword ptr [ebp - local_2c], ecx          # 004bfba6
    cmp dword ptr [ebp - local_2c], 0x1          # 004bfba9
    je.d8 L_004bfbbe                             # 004bfbad
    # block 0x004bfbaf: entered by fall-through of je at 0x004bfbad, 3 instruction(s), ends with forward jump to 0x004bfbcb
    mov edx, dword ptr [ebp - local_24]          # 004bfbaf
    mov dword ptr [edx + field_17e], 0x0         # 004bfbb2
    jmp.d8 L_004bfbcb                            # 004bfbbc
L_004bfbbe:
    # block 0x004bfbbe: entered by je at 0x004bfbad, 2 instruction(s), falls into the block at 0x004bfbcb
    mov eax, dword ptr [ebp - local_24]          # 004bfbbe
    mov dword ptr [eax + field_17e], 0x1         # 004bfbc1
L_004bfbcb:
    # block 0x004bfbcb: entered by jmp at 0x004bfbbc, 25 instruction(s), calls FUN_0041632b, ends with je to 0x004bfcda (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004bfbcb
    add ecx, 0x8                                 # 004bfbce
    push ecx                                     # 004bfbd1
    mov ecx, 0x5e2dbe                            # 004bfbd2
    call FUN_0041632b                            # 004bfbd7
    mov dword ptr [0x5c39f9], 0x1                # 004bfbdc
    movsx edx, word ptr [ebp + arg_8]            # 004bfbe6
    imul edx, edx, 0x8d                          # 004bfbea
    mov dword ptr [edx + 0x5bb626], 0x0          # 004bfbf0
    mov dword ptr [0x5d19fb], 0x0                # 004bfbfa
    mov eax, dword ptr [ebp - local_24]          # 004bfc04
    mov dword ptr [eax + field_1da], 0x0         # 004bfc07
    mov ecx, dword ptr [ebp - local_24]          # 004bfc11
    mov dword ptr [ecx + field_216], 0x0         # 004bfc14
    mov edx, dword ptr [ebp - local_24]          # 004bfc1e
    mov dword ptr [edx + field_21a], 0x0         # 004bfc21
    mov eax, dword ptr [ebp - local_24]          # 004bfc2b
    mov dword ptr [eax + field_21e], 0x0         # 004bfc2e
    mov ecx, dword ptr [ebp - local_24]          # 004bfc38
    mov word ptr [ecx + field_244], 0xffff       # 004bfc3b
    mov edx, dword ptr [ebp - local_24]          # 004bfc44
    mov dword ptr [edx + field_24a], 0x0         # 004bfc47
    mov eax, dword ptr [ebp - local_24]          # 004bfc51
    cmp dword ptr [eax + field_1d6], 0x0         # 004bfc54
    je.d8 L_004bfcda                             # 004bfc5b
    # block 0x004bfc5d: entered by fall-through of je at 0x004bfc5b, 17 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x004bfcad (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004bfc5d
    add ecx, 0x4                                 # 004bfc60
    push ecx                                     # 004bfc63
    call FUN_0044c479                            # 004bfc64
    add esp, 0x4                                 # 004bfc69
    mov edx, dword ptr [ebp - local_24]          # 004bfc6c
    mov dword ptr [edx + field_4], 0x2           # 004bfc6f
    mov eax, dword ptr [ebp - local_24]          # 004bfc76
    mov ecx, dword ptr [eax + field_1d6]         # 004bfc79
    call FUN_00449a94                            # 004bfc7f
    mov ecx, dword ptr [ebp - local_24]          # 004bfc84
    mov edx, dword ptr [ecx + field_1d6]         # 004bfc87
    mov dword ptr [ebp - local_18], edx          # 004bfc8d
    mov eax, dword ptr [ebp - local_18]          # 004bfc90
    mov dword ptr [ebp - local_14], eax          # 004bfc93
    cmp dword ptr [ebp - local_14], 0x0          # 004bfc96
    je.d8 L_004bfcad                             # 004bfc9a
    # block 0x004bfc9c: entered by fall-through of je at 0x004bfc9a, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x004bfcb4
    push 0x1                                     # 004bfc9c
    mov ecx, dword ptr [ebp - local_14]          # 004bfc9e
    mov edx, dword ptr [ecx]                     # 004bfca1
    mov ecx, dword ptr [ebp - local_14]          # 004bfca3
    call dword ptr [edx]                         # 004bfca6
    mov dword ptr [ebp - local_30], eax          # 004bfca8
    jmp.d8 L_004bfcb4                            # 004bfcab
L_004bfcad:
    # block 0x004bfcad: entered by je at 0x004bfc9a, 1 instruction(s), falls into the block at 0x004bfcb4
    mov dword ptr [ebp - local_30], 0x0          # 004bfcad
L_004bfcb4:
    # block 0x004bfcb4: entered by jmp at 0x004bfcab, 9 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004bfcda
    mov eax, dword ptr [ebp - local_24]          # 004bfcb4
    mov dword ptr [eax + field_1d6], 0x0         # 004bfcb7
    mov ecx, dword ptr [ebp - local_24]          # 004bfcc1
    add ecx, 0x4                                 # 004bfcc4
    push ecx                                     # 004bfcc7
    call FUN_0044c4ab                            # 004bfcc8
    add esp, 0x4                                 # 004bfccd
    mov edx, dword ptr [ebp - local_24]          # 004bfcd0
    mov dword ptr [edx + field_4], 0x0           # 004bfcd3
L_004bfcda:
    # block 0x004bfcda: entered by je at 0x004bfc5b, 43 instruction(s), calls FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, ends with je to 0x004bfef1 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004bfcda
    add eax, 0x8                                 # 004bfcdd
    push eax                                     # 004bfce0
    mov ecx, 0x5e2dbe                            # 004bfce1
    call FUN_00415011                            # 004bfce6
    mov ecx, dword ptr [ebp - local_24]          # 004bfceb
    add ecx, 0x222                               # 004bfcee
    push ecx                                     # 004bfcf4
    mov ecx, 0x5cf659                            # 004bfcf5
    call FUN_004c2dfb                            # 004bfcfa
    mov edx, dword ptr [ebp - local_24]          # 004bfcff
    mov edi, dword ptr [edx + field_22a]         # 004bfd02
    mov eax, dword ptr [ebp - local_24]          # 004bfd08
    add eax, 0x159                               # 004bfd0b
    {load} mov edx, eax                          # 004bfd10
    or ecx, -0x1                                 # 004bfd12
    {load} xor eax, eax                          # 004bfd15
    repne scasb al, byte ptr es:[edi]            # 004bfd17
    not ecx                                      # 004bfd19
    {load} sub edi, ecx                          # 004bfd1b
    {load} mov esi, edi                          # 004bfd1d
    {load} mov eax, ecx                          # 004bfd1f
    {load} mov edi, edx                          # 004bfd21
    shr ecx, 0x2                                 # 004bfd23
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bfd26
    {load} mov ecx, eax                          # 004bfd28
    and ecx, 0x3                                 # 004bfd2a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bfd2d
    mov ecx, dword ptr [ebp - local_24]          # 004bfd2f
    mov word ptr [ecx + field_1cc], 0x1          # 004bfd32
    mov edx, dword ptr [ebp - local_24]          # 004bfd3b
    mov word ptr [edx + field_1ce], 0x2          # 004bfd3e
    mov eax, dword ptr [ebp - local_24]          # 004bfd47
    add eax, 0x8                                 # 004bfd4a
    push eax                                     # 004bfd4d
    call FUN_0044c4c1                            # 004bfd4e
    add esp, 0x4                                 # 004bfd53
    mov ecx, dword ptr [ebp - local_24]          # 004bfd56
    mov edx, dword ptr [ecx + field_22a]         # 004bfd59
    movsx eax, word ptr [edx + field_21]         # 004bfd5f
    mov dword ptr [ebp - local_34], eax          # 004bfd63
    cmp dword ptr [ebp - local_34], 0x1          # 004bfd66
    je.d32 L_004bfef1                            # 004bfd6a
    # block 0x004bfd70: entered by fall-through of je at 0x004bfd6a, 27 instruction(s), calls FUN_004c2c3a, FUN_004161d1, ends with jne to 0x004bfde9 (forward)
    push 0x55279c                                # 004bfd70
    push 0x1                                     # 004bfd75
    push 0x8                                     # 004bfd77
    mov ecx, dword ptr [ebp - local_24]          # 004bfd79
    mov edx, dword ptr [ebp - local_24]          # 004bfd7c
    mov eax, dword ptr [ecx + field_1be]         # 004bfd7f
    sub eax, dword ptr [edx + field_1b6]         # 004bfd85
    add eax, 0x1                                 # 004bfd8b
    push eax                                     # 004bfd8e
    mov ecx, dword ptr [ebp - local_24]          # 004bfd8f
    mov edx, dword ptr [ebp - local_24]          # 004bfd92
    mov eax, dword ptr [ecx + field_1ba]         # 004bfd95
    sub eax, dword ptr [edx + field_1b2]         # 004bfd9b
    add eax, 0x1                                 # 004bfda1
    push eax                                     # 004bfda4
    mov ecx, 0x5cf659                            # 004bfda5
    call FUN_004c2c3a                            # 004bfdaa
    mov ecx, dword ptr [ebp - local_24]          # 004bfdaf
    mov dword ptr [ecx + field_222], eax         # 004bfdb2
    mov edx, dword ptr [ebp - local_24]          # 004bfdb8
    add edx, 0x8                                 # 004bfdbb
    push edx                                     # 004bfdbe
    mov ecx, 0x5e2dbe                            # 004bfdbf
    call FUN_004161d1                            # 004bfdc4
    mov eax, dword ptr [ebp - local_24]          # 004bfdc9
    cmp dword ptr [eax + field_17a], 0x0         # 004bfdcc
    jne.d8 L_004bfde9                            # 004bfdd3
    # block 0x004bfdd5: entered by fall-through of jne at 0x004bfdd3, 5 instruction(s), falls into the block at 0x004bfde9
    mov ecx, dword ptr [ebp - local_24]          # 004bfdd5
    mov edx, dword ptr [ecx + field_222]         # 004bfdd8
    mov eax, dword ptr [ebp - local_24]          # 004bfdde
    mov ecx, dword ptr [eax + field_182]         # 004bfde1
    mov dword ptr [edx], ecx                     # 004bfde7
L_004bfde9:
    # block 0x004bfde9: entered by jne at 0x004bfdd3, 3 instruction(s), ends with jne to 0x004bfe90 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004bfde9
    cmp dword ptr [edx + field_1d6], 0x0         # 004bfdec
    jne.d32 L_004bfe90                           # 004bfdf3
    # block 0x004bfdf9: entered by fall-through of jne at 0x004bfdf3, 13 instruction(s), calls FUN_0050ca3e, FUN_0051dc43, ends with je to 0x004bfe4c (forward)
    mov eax, dword ptr [0x5bb57b]                # 004bfdf9
    push eax                                     # 004bfdfe
    push 0x5527ac                                # 004bfdff
    push 0x63888b                                # 004bfe04
    call FUN_0050ca3e                            # 004bfe09
    add esp, 0xc                                 # 004bfe0e
    push 0x46                                    # 004bfe11
    call FUN_0051dc43                            # 004bfe13
    add esp, 0x4                                 # 004bfe18
    mov dword ptr [ebp - local_20], eax          # 004bfe1b
    mov dword ptr [ebp - local_4], 0x0           # 004bfe1e
    cmp dword ptr [ebp - local_20], 0x0          # 004bfe25
    je.d8 L_004bfe4c                             # 004bfe29
    # block 0x004bfe2b: entered by fall-through of je at 0x004bfe29, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x004bfe53
    push 0x4                                     # 004bfe2b
    movsx ecx, word ptr [0x5b016f]               # 004bfe2d
    push ecx                                     # 004bfe34
    push 0x63888b                                # 004bfe35
    push 0x4c0c7d                                # 004bfe3a
    mov ecx, dword ptr [ebp - local_20]          # 004bfe3f
    call FUN_004497a0                            # 004bfe42
    mov dword ptr [ebp - local_38], eax          # 004bfe47
    jmp.d8 L_004bfe53                            # 004bfe4a
L_004bfe4c:
    # block 0x004bfe4c: entered by je at 0x004bfe29, 1 instruction(s), falls into the block at 0x004bfe53
    mov dword ptr [ebp - local_38], 0x0          # 004bfe4c
L_004bfe53:
    # block 0x004bfe53: entered by jmp at 0x004bfe4a, 8 instruction(s), ends with jne to 0x004bfe90 (forward)
    mov edx, dword ptr [ebp - local_38]          # 004bfe53
    mov dword ptr [ebp - local_1c], edx          # 004bfe56
    mov dword ptr [ebp - local_4], 0xffffffff    # 004bfe59
    mov eax, dword ptr [ebp - local_24]          # 004bfe60
    mov ecx, dword ptr [ebp - local_1c]          # 004bfe63
    mov dword ptr [eax + field_1d6], ecx         # 004bfe66
    cmp dword ptr [ebp - local_1c], 0x0          # 004bfe6c
    jne.d8 L_004bfe90                            # 004bfe70
    # block 0x004bfe72: entered by fall-through of jne at 0x004bfe70, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x004bfe90
    push 0x63888b                                # 004bfe72
    push 0x5527d8                                # 004bfe77
    mov ecx, 0x583979                            # 004bfe7c
    call FUN_0042639d                            # 004bfe81
    mov ecx, 0x5cf659                            # 004bfe86
    call FUN_004c97b4                            # 004bfe8b
L_004bfe90:
    # block 0x004bfe90: entered by jne at 0x004bfdf3; jne at 0x004bfe70, 5 instruction(s), ends with jne to 0x004bfebb (forward)
    mov edx, dword ptr [ebp - local_24]          # 004bfe90
    mov eax, dword ptr [edx + field_22a]         # 004bfe93
    movsx ecx, word ptr [eax + field_29]         # 004bfe99
    cmp ecx, 0x1                                 # 004bfe9d
    jne.d8 L_004bfebb                            # 004bfea0
    # block 0x004bfea2: entered by fall-through of jne at 0x004bfea0, 6 instruction(s), ends with forward jump to 0x004bfed2
    mov edx, dword ptr [ebp - local_24]          # 004bfea2
    mov eax, dword ptr [edx + field_22a]         # 004bfea5
    mov ecx, dword ptr [ebp - local_24]          # 004bfeab
    mov dx, word ptr [eax + field_2b]            # 004bfeae
    mov word ptr [ecx + field_1ca], dx           # 004bfeb2
    jmp.d8 L_004bfed2                            # 004bfeb9
L_004bfebb:
    # block 0x004bfebb: entered by jne at 0x004bfea0, 5 instruction(s), falls into the block at 0x004bfed2
    mov eax, dword ptr [ebp - local_24]          # 004bfebb
    mov ecx, dword ptr [eax + field_22a]         # 004bfebe
    mov edx, dword ptr [ebp - local_24]          # 004bfec4
    mov ax, word ptr [ecx + field_2d]            # 004bfec7
    mov word ptr [edx + field_1ca], ax           # 004bfecb
L_004bfed2:
    # block 0x004bfed2: entered by jmp at 0x004bfeb9, 6 instruction(s), calls FUN_00449bff, ends with forward jump to 0x004c0043
    mov ecx, dword ptr [ebp - local_24]          # 004bfed2
    mov word ptr [ecx + field_1d4], 0x0          # 004bfed5
    mov edx, dword ptr [ebp - local_24]          # 004bfede
    mov ecx, dword ptr [edx + field_1d6]         # 004bfee1
    call FUN_00449bff                            # 004bfee7
    jmp.d32 L_004c0043                           # 004bfeec
L_004bfef1:
    # block 0x004bfef1: entered by je at 0x004bfd6a, 25 instruction(s), calls FUN_004c2c3a, ends with je to 0x004bffca (forward)
    push 0x5527fc                                # 004bfef1
    push 0x0                                     # 004bfef6
    push 0x8                                     # 004bfef8
    mov eax, dword ptr [ebp - local_24]          # 004bfefa
    mov ecx, dword ptr [ebp - local_24]          # 004bfefd
    mov edx, dword ptr [eax + field_1be]         # 004bff00
    sub edx, dword ptr [ecx + field_1b6]         # 004bff06
    add edx, 0x1                                 # 004bff0c
    push edx                                     # 004bff0f
    mov eax, dword ptr [ebp - local_24]          # 004bff10
    mov ecx, dword ptr [ebp - local_24]          # 004bff13
    mov edx, dword ptr [eax + field_1ba]         # 004bff16
    sub edx, dword ptr [ecx + field_1b2]         # 004bff1c
    add edx, 0x1                                 # 004bff22
    push edx                                     # 004bff25
    mov ecx, 0x5cf659                            # 004bff26
    call FUN_004c2c3a                            # 004bff2b
    mov ecx, dword ptr [ebp - local_24]          # 004bff30
    mov dword ptr [ecx + field_222], eax         # 004bff33
    mov edx, dword ptr [ebp - local_24]          # 004bff39
    mov eax, dword ptr [edx + field_22a]         # 004bff3c
    movsx ecx, word ptr [eax + field_29]         # 004bff42
    mov dword ptr [ebp - local_3c], ecx          # 004bff46
    cmp dword ptr [ebp - local_3c], 0x2          # 004bff49
    je.d8 L_004bffca                             # 004bff4d
    # block 0x004bff4f: entered by fall-through of je at 0x004bff4d, 8 instruction(s), calls FUN_004bef11, ends with je to 0x004bffc8 (forward)
    push 0x0                                     # 004bff4f
    mov edx, dword ptr [ebp - local_24]          # 004bff51
    mov eax, dword ptr [edx + field_18e]         # 004bff54
    push eax                                     # 004bff5a
    mov ecx, 0x6201f9                            # 004bff5b
    call FUN_004bef11                            # 004bff60
    test eax, eax                                # 004bff65
    je.d8 L_004bffc8                             # 004bff67
    # block 0x004bff69: entered by fall-through of je at 0x004bff67, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x004bffa0 (forward)
    push 0x0                                     # 004bff69
    mov ecx, 0x6201f9                            # 004bff6b
    call FUN_004bf3b8                            # 004bff70
    push eax                                     # 004bff75
    push 0x55280c                                # 004bff76
    push 0x63888b                                # 004bff7b
    call FUN_0050ca3e                            # 004bff80
    add esp, 0xc                                 # 004bff85
    movsx ecx, word ptr [0x63a4cd]               # 004bff88
    test ecx, ecx                                # 004bff8f
    je.d8 L_004bffa0                             # 004bff91
    # block 0x004bff93: entered by fall-through of je at 0x004bff91, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bffa0
    push 0x63888b                                # 004bff93
    call FUN_0044a2b7                            # 004bff98
    add esp, 0x4                                 # 004bff9d
L_004bffa0:
    # block 0x004bffa0: entered by je at 0x004bff91, 7 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c01f3
    push 0x63888b                                # 004bffa0
    mov ecx, 0x583979                            # 004bffa5
    call FUN_004264e8                            # 004bffaa
    mov dword ptr [0x5bb20c], 0x1                # 004bffaf
    mov ecx, 0x5cf659                            # 004bffb9
    call FUN_004c97b4                            # 004bffbe
    jmp.d32 L_004c01f3                           # 004bffc3
L_004bffc8:
    # block 0x004bffc8: entered by je at 0x004bff67, 1 instruction(s), ends with forward jump to 0x004c0043
    jmp.d8 L_004c0043                            # 004bffc8
L_004bffca:
    # block 0x004bffca: entered by je at 0x004bff4d, 8 instruction(s), calls FUN_004bef11, ends with je to 0x004c0043 (forward)
    push 0x1                                     # 004bffca
    mov edx, dword ptr [ebp - local_24]          # 004bffcc
    mov eax, dword ptr [edx + field_18e]         # 004bffcf
    push eax                                     # 004bffd5
    mov ecx, 0x6201f9                            # 004bffd6
    call FUN_004bef11                            # 004bffdb
    test eax, eax                                # 004bffe0
    je.d8 L_004c0043                             # 004bffe2
    # block 0x004bffe4: entered by fall-through of je at 0x004bffe2, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x004c001b (forward)
    push 0x0                                     # 004bffe4
    mov ecx, 0x6201f9                            # 004bffe6
    call FUN_004bf3b8                            # 004bffeb
    push eax                                     # 004bfff0
    push 0x552824                                # 004bfff1
    push 0x63888b                                # 004bfff6
    call FUN_0050ca3e                            # 004bfffb
    add esp, 0xc                                 # 004c0000
    movsx ecx, word ptr [0x63a4cd]               # 004c0003
    test ecx, ecx                                # 004c000a
    je.d8 L_004c001b                             # 004c000c
    # block 0x004c000e: entered by fall-through of je at 0x004c000c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c001b
    push 0x63888b                                # 004c000e
    call FUN_0044a2b7                            # 004c0013
    add esp, 0x4                                 # 004c0018
L_004c001b:
    # block 0x004c001b: entered by je at 0x004c000c, 7 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c01f3
    push 0x63888b                                # 004c001b
    mov ecx, 0x583979                            # 004c0020
    call FUN_004264e8                            # 004c0025
    mov dword ptr [0x5bb20c], 0x1                # 004c002a
    mov ecx, 0x5cf659                            # 004c0034
    call FUN_004c97b4                            # 004c0039
    jmp.d32 L_004c01f3                           # 004c003e
L_004c0043:
    # block 0x004c0043: entered by jmp at 0x004bfeec; jmp at 0x004bffc8; je at 0x004bffe2, 6 instruction(s), ends with je to 0x004c0069 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c0043
    mov eax, dword ptr [edx + field_222]         # 004c0046
    mov dword ptr [0x5d19ef], eax                # 004c004c
    movsx ecx, word ptr [0x63a4cd]               # 004c0051
    test ecx, ecx                                # 004c0058
    je.d8 L_004c0069                             # 004c005a
    # block 0x004c005c: entered by fall-through of je at 0x004c005a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c0069
    push 0x55283c                                # 004c005c
    call FUN_0044a2b7                            # 004c0061
    add esp, 0x4                                 # 004c0066
L_004c0069:
    # block 0x004c0069: entered by je at 0x004c005a, 6 instruction(s), ends with forward jump to 0x004c01f3
    mov edx, dword ptr [ebp - local_24]          # 004c0069
    mov dword ptr [edx + field_240], 0x3         # 004c006c
    movsx eax, word ptr [ebp + arg_8]            # 004c0076
    imul eax, eax, 0x8d                          # 004c007a
    mov dword ptr [eax + 0x5bb632], 0x1          # 004c0080
    jmp.d32 L_004c01f3                           # 004c008a
L_004c008f:
    # block 0x004c008f: entered by je at 0x004bfa96, 12 instruction(s), ends with je to 0x004c00fa (forward)
    mov dword ptr [0x5d19fb], 0x0                # 004c008f
    mov ecx, dword ptr [ebp - local_24]          # 004c0099
    mov dword ptr [ecx + field_216], 0x0         # 004c009c
    mov edx, dword ptr [ebp - local_24]          # 004c00a6
    mov dword ptr [edx + field_24a], 0x0         # 004c00a9
    mov eax, dword ptr [ebp - local_24]          # 004c00b3
    mov dword ptr [eax + field_246], 0x0         # 004c00b6
    mov ecx, dword ptr [ebp - local_24]          # 004c00c0
    mov edx, dword ptr [ecx + field_22a]         # 004c00c3
    movsx eax, word ptr [edx + field_27]         # 004c00c9
    cmp eax, 0x1                                 # 004c00cd
    je.d8 L_004c00fa                             # 004c00d0
    # block 0x004c00d2: entered by fall-through of je at 0x004c00d0, 4 instruction(s), falls into the block at 0x004c00fa
    mov dword ptr [0x5839a9], 0x1                # 004c00d2
    mov dword ptr [0x5d1639], 0x0                # 004c00dc
    mov dword ptr [0x5d16cd], 0x0                # 004c00e6
    mov dword ptr [0x5d1683], 0x0                # 004c00f0
L_004c00fa:
    # block 0x004c00fa: entered by je at 0x004c00d0, 3 instruction(s), ends with forward jump to 0x004c0120
    mov ecx, dword ptr [ebp - local_24]          # 004c00fa
    mov word ptr [ecx + field_23a], 0x0          # 004c00fd
    jmp.d8 L_004c0120                            # 004c0106
L_004c0108:
    # block 0x004c0108: entered by jmp at 0x004c01c6, 5 instruction(s), falls into the block at 0x004c0120
    mov edx, dword ptr [ebp - local_24]          # 004c0108
    mov ax, word ptr [edx + field_23a]           # 004c010b
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c0112
    mov ecx, dword ptr [ebp - local_24]          # 004c0116
    mov word ptr [ecx + field_23a], ax           # 004c0119
L_004c0120:
    # block 0x004c0120: entered by jmp at 0x004c0106, 6 instruction(s), ends with jge to 0x004c01cb (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c0120
    movsx eax, word ptr [edx + field_23a]        # 004c0123
    mov ecx, dword ptr [ebp - local_24]          # 004c012a
    movsx edx, word ptr [ecx + field_234]        # 004c012d
    {load} cmp eax, edx                          # 004c0134
    jge.d32 L_004c01cb                           # 004c0136
    # block 0x004c013c: entered by fall-through of jge at 0x004c0136, 5 instruction(s), ends with jne to 0x004c01a2 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004c013c
    movsx ecx, word ptr [eax]                    # 004c013f
    movsx edx, word ptr [0x5bb50b]               # 004c0142
    {load} cmp ecx, edx                          # 004c0149
    jne.d8 L_004c01a2                            # 004c014b
    # block 0x004c014d: entered by fall-through of jne at 0x004c014b, 10 instruction(s), ends with je to 0x004c0188 (forward)
    mov dword ptr [0x5d19fb], 0x1                # 004c014d
    mov eax, dword ptr [ebp - local_24]          # 004c0157
    mov ecx, dword ptr [ebp - local_10]          # 004c015a
    mov dword ptr [eax + field_24a], ecx         # 004c015d
    mov edx, dword ptr [ebp - local_24]          # 004c0163
    mov eax, dword ptr [edx + field_22a]         # 004c0166
    movsx ecx, word ptr [eax + field_21]         # 004c016c
    mov dword ptr [ebp - local_40], ecx          # 004c0170
    cmp dword ptr [ebp - local_40], 0x1          # 004c0173
    je.d8 L_004c0188                             # 004c0177
    # block 0x004c0179: entered by fall-through of je at 0x004c0177, 5 instruction(s), calls FUN_004c0205, ends with forward jump to 0x004c0195
    mov dx, word ptr [ebp + arg_8]               # 004c0179
    push edx                                     # 004c017d
    mov ecx, dword ptr [ebp - local_24]          # 004c017e
    call FUN_004c0205                            # 004c0181
    jmp.d8 L_004c0195                            # 004c0186
L_004c0188:
    # block 0x004c0188: entered by je at 0x004c0177, 4 instruction(s), calls FUN_004c04e3, falls into the block at 0x004c0195
    mov ax, word ptr [ebp + arg_8]               # 004c0188
    push eax                                     # 004c018c
    mov ecx, dword ptr [ebp - local_24]          # 004c018d
    call FUN_004c04e3                            # 004c0190
L_004c0195:
    # block 0x004c0195: entered by jmp at 0x004c0186, 2 instruction(s), falls into the block at 0x004c01a2
    mov ecx, dword ptr [ebp - local_24]          # 004c0195
    mov dword ptr [ecx + field_246], 0x1         # 004c0198
L_004c01a2:
    # block 0x004c01a2: entered by jne at 0x004c014b, 7 instruction(s), ends with jge to 0x004c01c6 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c01a2
    movsx eax, word ptr [edx + field_23a]        # 004c01a5
    mov ecx, dword ptr [ebp - local_24]          # 004c01ac
    movsx edx, word ptr [ecx + field_234]        # 004c01af
    sub edx, 0x1                                 # 004c01b6
    {load} cmp eax, edx                          # 004c01b9
    jge.d8 L_004c01c6                            # 004c01bb
    # block 0x004c01bd: entered by fall-through of jge at 0x004c01bb, 3 instruction(s), falls into the block at 0x004c01c6
    mov eax, dword ptr [ebp - local_10]          # 004c01bd
    add eax, 0x22                                # 004c01c0
    mov dword ptr [ebp - local_10], eax          # 004c01c3
L_004c01c6:
    # block 0x004c01c6: entered by jge at 0x004c01bb, 1 instruction(s), ends with backward jump to 0x004c0108
    jmp.d32 L_004c0108                           # 004c01c6
L_004c01cb:
    # block 0x004c01cb: entered by jge at 0x004c0136, 3 instruction(s), ends with jne to 0x004c01e4 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004c01cb
    cmp dword ptr [ecx + field_246], 0x0         # 004c01ce
    jne.d8 L_004c01e4                            # 004c01d5
    # block 0x004c01d7: entered by fall-through of jne at 0x004c01d5, 2 instruction(s), falls into the block at 0x004c01e4
    mov edx, dword ptr [ebp - local_24]          # 004c01d7
    mov dword ptr [edx + field_240], 0x3         # 004c01da
L_004c01e4:
    # block 0x004c01e4: entered by jne at 0x004c01d5, 1 instruction(s), ends with forward jump to 0x004c01f3
    jmp.d8 L_004c01f3                            # 004c01e4
L_004c01e6:
    # block 0x004c01e6: entered by je at 0x004bfaa0, 4 instruction(s), calls FUN_004c0774, falls into the block at 0x004c01f3
    mov ax, word ptr [ebp + arg_8]               # 004c01e6
    push eax                                     # 004c01ea
    mov ecx, dword ptr [ebp - local_24]          # 004c01eb
    call FUN_004c0774                            # 004c01ee
L_004c01f3:
    # block 0x004c01f3: entered by jmp at 0x004bfaa6; jmp at 0x004bfaf3; jmp at 0x004bffc3; jmp at 0x004c003e; more, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - local_c]           # 004c01f3
    mov dword ptr fs:[0x0], ecx                  # 004c01f6
    pop edi                                      # 004c01fd
    pop esi                                      # 004c01fe
    {load} mov esp, ebp                          # 004c01ff
    pop ebp                                      # 004c0201
    ret 0x4                                      # 004c0202

