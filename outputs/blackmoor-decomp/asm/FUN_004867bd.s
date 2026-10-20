# FUN_004867bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004867bd
# extent:       0x004867bd-0x004876c1 (3844 code bytes)
# span:         0x004867bd-0x004876dd (code 3844, tables 28, padding 0)
# sha256:       98e222e5451740e8032b2c2e66e5fec3289b0272c199ec01f56920facab8afde
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_onebuild_puzzle_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ea_runtime.h:17 says "0x4867bd the handler, a switch on the row phase dword"
# name-note:    Handler of the raw 0xea Onebuild puzzle: a switch on the row phase dword.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_e4, local_e8, local_ec, local_f0, local_f4, local_f8 and 1 more
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_1e, field_21, field_22, field_24, field_26, field_5ec, field_5f4, field_608 and 27 more; [ecx + n] field_4, field_8, field_c, field_1c, field_26, field_5ec, field_5f0, field_604, field_60a, field_610, field_635, field_a92 and 25 more; [edi + n] field_minus_1; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_22, field_26, field_28, field_5e8, field_5f4, field_5fc, field_60a and 29 more
# callees:      calls FUN_004e8d96, FUN_004c2790, FUN_0048421e, FUN_004d39f9, FUN_00486725, FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fba69, FUN_0048633c, FUN_004866b4, FUN_00485fb6, FUN_00448d11, FUN_00423259, FUN_0042ba3a and 1 more
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:ea_step (function ledger class candidate_port; also phase0, phase1, phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 819 instruction(s), 47 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ local_fc, 0xfc  # offset -0xfc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_5e8, 0x5e8  # offset +0x5e8
.equ field_5ec, 0x5ec  # offset +0x5ec
.equ field_5f0, 0x5f0  # offset +0x5f0
.equ field_5f4, 0x5f4  # offset +0x5f4
.equ field_5fc, 0x5fc  # offset +0x5fc
.equ field_604, 0x604  # offset +0x604
.equ field_608, 0x608  # offset +0x608
.equ field_60a, 0x60a  # offset +0x60a
.equ field_60c, 0x60c  # offset +0x60c
.equ field_60e, 0x60e  # offset +0x60e
.equ field_610, 0x610  # offset +0x610
.equ field_612, 0x612  # offset +0x612
.equ field_635, 0x635  # offset +0x635
.equ field_666, 0x666  # offset +0x666
.equ field_a92, 0xa92  # offset +0xa92
.equ field_a96, 0xa96  # offset +0xa96
.equ field_a9a, 0xa9a  # offset +0xa9a
.equ field_a9e, 0xa9e  # offset +0xa9e
.equ field_b42, 0xb42  # offset +0xb42
.equ field_b83, 0xb83  # offset +0xb83
.equ field_b87, 0xb87  # offset +0xb87
.equ field_b8b, 0xb8b  # offset +0xb8b
.equ field_b8f, 0xb8f  # offset +0xb8f
.equ field_b93, 0xb93  # offset +0xb93
.equ field_b97, 0xb97  # offset +0xb97
.equ field_b9b, 0xb9b  # offset +0xb9b
.equ field_b9f, 0xb9f  # offset +0xb9f
.equ field_ba3, 0xba3  # offset +0xba3
.equ field_ba7, 0xba7  # offset +0xba7
.equ field_bab, 0xbab  # offset +0xbab
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bb0, 0xbb0  # offset +0xbb0
.equ field_bc1, 0xbc1  # offset +0xbc1
.equ field_bc9, 0xbc9  # offset +0xbc9
.equ field_bcd, 0xbcd  # offset +0xbcd
.equ field_c25, 0xc25  # offset +0xc25
.equ field_c27, 0xc27  # offset +0xc27
.equ field_c2b, 0xc2b  # offset +0xc2b
.equ field_c2f, 0xc2f  # offset +0xc2f
.equ field_c33, 0xc33  # offset +0xc33
.equ field_c35, 0xc35  # offset +0xc35
.equ field_c37, 0xc37  # offset +0xc37
.equ field_c39, 0xc39  # offset +0xc39
.equ field_dab, 0xdab  # offset +0xdab
.equ field_dad, 0xdad  # offset +0xdad
.equ field_daf, 0xdaf  # offset +0xdaf
.equ field_db1, 0xdb1  # offset +0xdb1
.equ field_db3, 0xdb3  # offset +0xdb3
.equ field_db7, 0xdb7  # offset +0xdb7
.equ field_dbb, 0xdbb  # offset +0xdbb
.equ field_dbf, 0xdbf  # offset +0xdbf
.equ field_dc1, 0xdc1  # offset +0xdc1
.equ field_dc3, 0xdc3  # offset +0xdc3
.equ field_de5, 0xde5  # offset +0xde5
.equ field_ede, 0xede  # offset +0xede
.equ field_ee0, 0xee0  # offset +0xee0
.equ field_ee2, 0xee2  # offset +0xee2
.equ field_ee4, 0xee4  # offset +0xee4
.equ field_ee6, 0xee6  # offset +0xee6
.equ field_eea, 0xeea  # offset +0xeea
.equ field_eee, 0xeee  # offset +0xeee
.equ field_ef2, 0xef2  # offset +0xef2
.equ field_ef4, 0xef4  # offset +0xef4
.equ field_ef6, 0xef6  # offset +0xef6

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_00483fb5, .text + (0x00483fb5 - 0x401000)
.set FUN_0048421e, .text + (0x0048421e - 0x401000)
.set FUN_00485fb6, .text + (0x00485fb6 - 0x401000)
.set FUN_0048633c, .text + (0x0048633c - 0x401000)
.set FUN_004866b4, .text + (0x004866b4 - 0x401000)
.set FUN_00486725, .text + (0x00486725 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004867bd - 0x401000
.globl FUN_004867bd
FUN_004867bd:
    # block 0x004867bd: entry, 17 instruction(s), ends with je to 0x00486826 (forward)
    push ebp                                     # 004867bd
    {load} mov ebp, esp                          # 004867be
    sub esp, 0xfc                                # 004867c0
    push esi                                     # 004867c6
    push edi                                     # 004867c7
    mov dword ptr [ebp - local_f4], ecx          # 004867c8
    mov dword ptr [ebp - local_18], 0x0          # 004867ce
    movsx eax, word ptr [ebp + arg_8]            # 004867d5
    imul eax, eax, 0x8d                          # 004867d9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004867df
    mov dword ptr [ebp - local_c], ecx           # 004867e5
    movsx edx, word ptr [ebp + arg_8]            # 004867e8
    imul edx, edx, 0x8d                          # 004867ec
    mov eax, dword ptr [edx + 0x5bb632]          # 004867f2
    mov dword ptr [ebp - local_f8], eax          # 004867f8
    cmp dword ptr [ebp - local_f8], 0x0          # 004867fe
    je.d8 L_00486826                             # 00486805
    # block 0x00486807: entered by fall-through of je at 0x00486805, 2 instruction(s), ends with je to 0x00486ccf (forward)
    cmp dword ptr [ebp - local_f8], 0x1          # 00486807
    je.d32 L_00486ccf                            # 0048680e
    # block 0x00486814: entered by fall-through of je at 0x0048680e, 2 instruction(s), ends with je to 0x004874a6 (forward)
    cmp dword ptr [ebp - local_f8], 0x2          # 00486814
    je.d32 L_004874a6                            # 0048681b
    # block 0x00486821: entered by fall-through of je at 0x0048681b, 1 instruction(s), ends with forward jump to 0x004876b9
    jmp.d32 L_004876b9                           # 00486821
L_00486826:
    # block 0x00486826: entered by je at 0x00486805, 92 instruction(s), calls FUN_004e8d96, ends with jne to 0x00486a40 (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00486826
    mov dx, word ptr [ebp + arg_8]               # 0048682c
    mov word ptr [ecx + field_26], dx            # 00486830
    mov eax, dword ptr [ebp - local_f4]          # 00486834
    mov dword ptr [eax + field_ba7], 0x1         # 0048683a
    mov dword ptr [0x5bb1ca], 0x1                # 00486844
    mov ecx, 0x571442                            # 0048684e
    call FUN_004e8d96                            # 00486853
    mov ecx, dword ptr [ebp - local_f4]          # 00486858
    mov dword ptr [ecx + field_a92], 0x0         # 0048685e
    mov edx, dword ptr [ebp - local_f4]          # 00486868
    mov word ptr [edx + field_a9e], 0xffff       # 0048686e
    mov eax, dword ptr [ebp - local_f4]          # 00486877
    mov dword ptr [eax + field_a92], 0x0         # 0048687d
    mov ecx, dword ptr [ebp - local_f4]          # 00486887
    mov dword ptr [ecx + field_a96], 0x0         # 0048688d
    mov edx, dword ptr [ebp - local_f4]          # 00486897
    mov dword ptr [edx + field_a9a], 0x0         # 0048689d
    mov eax, dword ptr [ebp - local_f4]          # 004868a7
    mov byte ptr [eax + field_bb0], 0x0          # 004868ad
    mov ecx, dword ptr [ebp - local_f4]          # 004868b4
    mov byte ptr [ecx + field_bab], 0x0          # 004868ba
    mov edx, dword ptr [ebp - local_f4]          # 004868c1
    mov dword ptr [edx + field_bac], 0x0         # 004868c7
    mov eax, dword ptr [ebp - local_f4]          # 004868d1
    movsx ecx, word ptr [eax + field_26]         # 004868d7
    imul ecx, ecx, 0x8d                          # 004868db
    mov dword ptr [ecx + 0x5bb632], 0x1          # 004868e1
    {load} xor edx, edx                          # 004868eb
    mov eax, dword ptr [ebp - local_f4]          # 004868ed
    add eax, 0xaa0                               # 004868f3
    mov dword ptr [eax], edx                     # 004868f8
    mov dword ptr [eax + field_4], edx           # 004868fa
    mov dword ptr [eax + field_8], edx           # 004868fd
    mov dword ptr [eax + field_c], edx           # 00486900
    {load} xor ecx, ecx                          # 00486903
    mov edx, dword ptr [ebp - local_f4]          # 00486905
    add edx, 0xab0                               # 0048690b
    mov dword ptr [edx], ecx                     # 00486911
    mov dword ptr [edx + field_4], ecx           # 00486913
    mov dword ptr [edx + field_8], ecx           # 00486916
    mov dword ptr [edx + field_c], ecx           # 00486919
    {load} xor eax, eax                          # 0048691c
    mov ecx, dword ptr [ebp - local_f4]          # 0048691e
    add ecx, 0xac0                               # 00486924
    mov dword ptr [ecx], eax                     # 0048692a
    mov dword ptr [ecx + field_4], eax           # 0048692c
    mov dword ptr [ecx + field_8], eax           # 0048692f
    mov dword ptr [ecx + field_c], eax           # 00486932
    {load} xor edx, edx                          # 00486935
    mov eax, dword ptr [ebp - local_f4]          # 00486937
    add eax, 0xad0                               # 0048693d
    mov dword ptr [eax], edx                     # 00486942
    mov dword ptr [eax + field_4], edx           # 00486944
    mov dword ptr [eax + field_8], edx           # 00486947
    mov dword ptr [eax + field_c], edx           # 0048694a
    {load} xor ecx, ecx                          # 0048694d
    mov edx, dword ptr [ebp - local_f4]          # 0048694f
    add edx, 0xbb1                               # 00486955
    mov dword ptr [edx], ecx                     # 0048695b
    mov dword ptr [edx + field_4], ecx           # 0048695d
    mov dword ptr [edx + field_8], ecx           # 00486960
    mov dword ptr [edx + field_c], ecx           # 00486963
    mov eax, dword ptr [ebp - local_f4]          # 00486966
    mov dword ptr [eax + field_bc9], 0x0         # 0048696c
    mov ecx, dword ptr [ebp - local_f4]          # 00486976
    mov dword ptr [ecx + field_bc1], 0x0         # 0048697c
    mov edx, dword ptr [ebp - local_f4]          # 00486986
    mov word ptr [edx + field_c25], 0x0          # 0048698c
    mov eax, dword ptr [ebp - local_f4]          # 00486995
    mov dword ptr [eax + field_c2b], 0x0         # 0048699b
    mov ecx, dword ptr [ebp - local_f4]          # 004869a5
    mov dword ptr [ecx + field_c2f], 0x0         # 004869ab
    mov edx, dword ptr [ebp - local_f4]          # 004869b5
    mov word ptr [edx + field_c33], 0x0          # 004869bb
    mov eax, dword ptr [ebp - local_f4]          # 004869c4
    mov word ptr [eax + field_c35], 0x0          # 004869ca
    mov ecx, dword ptr [ebp - local_c]           # 004869d3
    mov edx, dword ptr [ebp - local_c]           # 004869d6
    mov eax, dword ptr [ecx + field_5f0]         # 004869d9
    sub eax, dword ptr [edx + field_5e8]         # 004869df
    mov ecx, dword ptr [ebp - local_f4]          # 004869e5
    mov word ptr [ecx + field_c37], ax           # 004869eb
    mov edx, dword ptr [ebp - local_c]           # 004869f2
    mov eax, dword ptr [ebp - local_c]           # 004869f5
    mov ecx, dword ptr [edx + field_5f4]         # 004869f8
    sub ecx, dword ptr [eax + field_5ec]         # 004869fe
    mov edx, dword ptr [ebp - local_f4]          # 00486a04
    mov word ptr [edx + field_c39], cx           # 00486a0a
    mov eax, dword ptr [ebp - local_f4]          # 00486a11
    cmp dword ptr [eax + field_22], 0x0          # 00486a17
    jne.d8 L_00486a40                            # 00486a1b
    # block 0x00486a1d: entered by fall-through of jne at 0x00486a1b, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00486a40
    push 0x54dbdc                                # 00486a1d
    push 0x6                                     # 00486a22
    mov ecx, dword ptr [ebp - local_c]           # 00486a24
    push ecx                                     # 00486a27
    push 0x54dbf4                                # 00486a28
    mov ecx, 0x5cf659                            # 00486a2d
    call FUN_004c2790                            # 00486a32
    mov edx, dword ptr [ebp - local_f4]          # 00486a37
    mov dword ptr [edx + field_22], eax          # 00486a3d
L_00486a40:
    # block 0x00486a40: entered by jne at 0x00486a1b, 30 instruction(s), ends with je to 0x00486b38 (forward)
    mov eax, dword ptr [ebp - local_f4]          # 00486a40
    mov dword ptr [eax + field_1e], 0x0          # 00486a46
    mov ecx, dword ptr [ebp - local_f4]          # 00486a4d
    mov dword ptr [ecx + field_b8f], 0x0         # 00486a53
    mov edx, dword ptr [ebp - local_f4]          # 00486a5d
    mov dword ptr [edx + field_b93], 0x0         # 00486a63
    mov eax, dword ptr [ebp - local_c]           # 00486a6d
    mov ecx, dword ptr [ebp - local_c]           # 00486a70
    mov edx, dword ptr [eax + field_5f4]         # 00486a73
    sub edx, dword ptr [ecx + field_5ec]         # 00486a79
    neg edx                                      # 00486a7f
    {load} sbb edx, edx                          # 00486a81
    neg edx                                      # 00486a83
    mov eax, dword ptr [ebp - local_f4]          # 00486a85
    mov dword ptr [eax + field_b8b], edx         # 00486a8b
    mov ecx, dword ptr [ebp - local_c]           # 00486a91
    mov edx, dword ptr [ebp - local_c]           # 00486a94
    mov eax, dword ptr [ecx + field_604]         # 00486a97
    sub eax, dword ptr [edx + field_5fc]         # 00486a9d
    neg eax                                      # 00486aa3
    {load} sbb eax, eax                          # 00486aa5
    neg eax                                      # 00486aa7
    mov ecx, dword ptr [ebp - local_f4]          # 00486aa9
    mov dword ptr [ecx + field_c27], eax         # 00486aaf
    mov edx, dword ptr [ebp - local_c]           # 00486ab5
    mov eax, dword ptr [ebp - local_c]           # 00486ab8
    mov ecx, dword ptr [edx + field_5f4]         # 00486abb
    sub ecx, dword ptr [eax + field_5ec]         # 00486ac1
    test ecx, ecx                                # 00486ac7
    je.d8 L_00486b38                             # 00486ac9
    # block 0x00486acb: entered by fall-through of je at 0x00486ac9, 7 instruction(s), ends with je to 0x00486b38 (forward)
    mov edi, 0x54dbfc                            # 00486acb
    mov esi, dword ptr [ebp - local_c]           # 00486ad0
    add esi, 0x5c7                               # 00486ad3
    mov ecx, 0x8                                 # 00486ad9
    {load} xor edx, edx                          # 00486ade
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486ae0
    je.d8 L_00486b38                             # 00486ae2
    # block 0x00486ae4: entered by fall-through of je at 0x00486ae2, 7 instruction(s), ends with je to 0x00486b38 (forward)
    mov edi, 0x63a8a8                            # 00486ae4
    mov esi, dword ptr [ebp - local_c]           # 00486ae9
    add esi, 0x5c7                               # 00486aec
    mov ecx, 0x1                                 # 00486af2
    {load} xor eax, eax                          # 00486af7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486af9
    je.d8 L_00486b38                             # 00486afb
    # block 0x00486afd: entered by fall-through of je at 0x00486afb, 13 instruction(s), calls FUN_004c2790, ends with forward jump to 0x00486b48
    push 0x54dc04                                # 00486afd
    push 0x6                                     # 00486b02
    mov ecx, dword ptr [ebp - local_c]           # 00486b04
    add ecx, 0x5c7                               # 00486b07
    push ecx                                     # 00486b0d
    push 0x54dc18                                # 00486b0e
    mov ecx, 0x5cf659                            # 00486b13
    call FUN_004c2790                            # 00486b18
    mov edx, dword ptr [ebp - local_f4]          # 00486b1d
    mov dword ptr [edx + field_1e], eax          # 00486b23
    mov eax, dword ptr [ebp - local_f4]          # 00486b26
    mov dword ptr [eax + field_b8b], 0x1         # 00486b2c
    jmp.d8 L_00486b48                            # 00486b36
L_00486b38:
    # block 0x00486b38: entered by je at 0x00486ac9; je at 0x00486ae2; je at 0x00486afb, 2 instruction(s), falls into the block at 0x00486b48
    mov ecx, dword ptr [ebp - local_f4]          # 00486b38
    mov dword ptr [ecx + field_b8b], 0x0         # 00486b3e
L_00486b48:
    # block 0x00486b48: entered by jmp at 0x00486b36, 2 instruction(s), ends with forward jump to 0x00486b5a
    mov dword ptr [ebp - local_8], 0x0           # 00486b48
    jmp.d8 L_00486b5a                            # 00486b4f
L_00486b51:
    # block 0x00486b51: entered by jmp at 0x00486b9b, 3 instruction(s), falls into the block at 0x00486b5a
    mov edx, dword ptr [ebp - local_8]           # 00486b51
    add edx, 0x1                                 # 00486b54
    mov dword ptr [ebp - local_8], edx           # 00486b57
L_00486b5a:
    # block 0x00486b5a: entered by jmp at 0x00486b4f, 2 instruction(s), ends with jge to 0x00486b9d (forward)
    cmp dword ptr [ebp - local_8], 0x14          # 00486b5a
    jge.d8 L_00486b9d                            # 00486b5e
    # block 0x00486b60: entered by fall-through of jge at 0x00486b5e, 2 instruction(s), ends with forward jump to 0x00486b72
    mov dword ptr [ebp - local_4], 0x0           # 00486b60
    jmp.d8 L_00486b72                            # 00486b67
L_00486b69:
    # block 0x00486b69: entered by jmp at 0x00486b99, 3 instruction(s), falls into the block at 0x00486b72
    mov eax, dword ptr [ebp - local_4]           # 00486b69
    add eax, 0x1                                 # 00486b6c
    mov dword ptr [ebp - local_4], eax           # 00486b6f
L_00486b72:
    # block 0x00486b72: entered by jmp at 0x00486b67, 2 instruction(s), ends with jge to 0x00486b9b (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00486b72
    jge.d8 L_00486b9b                            # 00486b76
    # block 0x00486b78: entered by fall-through of jge at 0x00486b76, 8 instruction(s), ends with backward jump to 0x00486b69
    mov ecx, dword ptr [ebp - local_8]           # 00486b78
    imul ecx, ecx, 0x85                          # 00486b7b
    mov edx, dword ptr [ebp - local_f4]          # 00486b81
    lea eax, [edx + ecx + field_28]              # 00486b87
    mov ecx, dword ptr [ebp - local_4]           # 00486b8b
    imul ecx, ecx, 0x18                          # 00486b8e
    mov dword ptr [eax + ecx + field_24], 0x0    # 00486b91
    jmp.d8 L_00486b69                            # 00486b99
L_00486b9b:
    # block 0x00486b9b: entered by jge at 0x00486b76, 1 instruction(s), ends with backward jump to 0x00486b51
    jmp.d8 L_00486b51                            # 00486b9b
L_00486b9d:
    # block 0x00486b9d: entered by jge at 0x00486b5e, 2 instruction(s), ends with forward jump to 0x00486baf
    mov dword ptr [ebp - local_8], 0x0           # 00486b9d
    jmp.d8 L_00486baf                            # 00486ba4
L_00486ba6:
    # block 0x00486ba6: entered by jmp at 0x00486bcb, 3 instruction(s), falls into the block at 0x00486baf
    mov edx, dword ptr [ebp - local_8]           # 00486ba6
    add edx, 0x1                                 # 00486ba9
    mov dword ptr [ebp - local_8], edx           # 00486bac
L_00486baf:
    # block 0x00486baf: entered by jmp at 0x00486ba4, 4 instruction(s), ends with jge to 0x00486bcd (forward)
    mov eax, dword ptr [ebp - local_c]           # 00486baf
    movsx ecx, word ptr [eax + field_21]         # 00486bb2
    cmp dword ptr [ebp - local_8], ecx           # 00486bb6
    jge.d8 L_00486bcd                            # 00486bb9
    # block 0x00486bbb: entered by fall-through of jge at 0x00486bb9, 5 instruction(s), calls FUN_0048421e, ends with backward jump to 0x00486ba6
    mov dx, word ptr [ebp - local_8]             # 00486bbb
    push edx                                     # 00486bbf
    mov ecx, dword ptr [ebp - local_f4]          # 00486bc0
    call FUN_0048421e                            # 00486bc6
    jmp.d8 L_00486ba6                            # 00486bcb
L_00486bcd:
    # block 0x00486bcd: entered by jge at 0x00486bb9, 55 instruction(s), calls FUN_004d39f9, ends with forward jump to 0x004876b9
    call FUN_004d39f9                            # 00486bcd
    mov ecx, dword ptr [ebp - local_f4]          # 00486bd2
    mov word ptr [ecx + field_1c], ax            # 00486bd8
    mov edx, dword ptr [ebp - local_f4]          # 00486bdc
    movsx eax, word ptr [edx + field_1c]         # 00486be2
    imul eax, eax, 0x4a                          # 00486be6
    mov dword ptr [eax + 0x5d1591], 0xa          # 00486be9
    mov ecx, dword ptr [ebp - local_f4]          # 00486bf3
    movsx edx, word ptr [ecx + field_1c]         # 00486bf9
    imul edx, edx, 0x4a                          # 00486bfd
    mov dword ptr [edx + 0x5d1595], 0x4876ed     # 00486c00
    mov eax, dword ptr [ebp - local_f4]          # 00486c0a
    movsx ecx, word ptr [eax + field_1c]         # 00486c10
    imul ecx, ecx, 0x4a                          # 00486c14
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00486c17
    mov edx, dword ptr [ebp - local_f4]          # 00486c21
    movsx eax, word ptr [edx + field_1c]         # 00486c27
    imul eax, eax, 0x4a                          # 00486c2b
    mov dword ptr [eax + 0x5d159d], 0x0          # 00486c2e
    mov ecx, dword ptr [ebp - local_f4]          # 00486c38
    movsx edx, word ptr [ecx + field_1c]         # 00486c3e
    imul edx, edx, 0x4a                          # 00486c42
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00486c45
    mov eax, dword ptr [ebp - local_f4]          # 00486c4f
    movsx ecx, word ptr [eax + field_1c]         # 00486c55
    imul ecx, ecx, 0x4a                          # 00486c59
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00486c5c
    mov edx, dword ptr [ebp - local_f4]          # 00486c66
    movsx eax, word ptr [edx + field_1c]         # 00486c6c
    imul eax, eax, 0x4a                          # 00486c70
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00486c73
    mov ecx, dword ptr [ebp - local_f4]          # 00486c7d
    movsx edx, word ptr [ecx + field_1c]         # 00486c83
    imul edx, edx, 0x4a                          # 00486c87
    mov word ptr [edx + 0x5d15ad], 0x0           # 00486c8a
    mov edi, 0x54dc20                            # 00486c93
    mov eax, dword ptr [ebp - local_f4]          # 00486c98
    movsx ecx, word ptr [eax + field_1c]         # 00486c9e
    imul ecx, ecx, 0x4a                          # 00486ca2
    add ecx, 0x5d15b3                            # 00486ca5
    {load} mov edx, ecx                          # 00486cab
    or ecx, -0x1                                 # 00486cad
    {load} xor eax, eax                          # 00486cb0
    repne scasb al, byte ptr es:[edi]            # 00486cb2
    not ecx                                      # 00486cb4
    {load} sub edi, ecx                          # 00486cb6
    {load} mov esi, edi                          # 00486cb8
    {load} mov eax, ecx                          # 00486cba
    {load} mov edi, edx                          # 00486cbc
    shr ecx, 0x2                                 # 00486cbe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00486cc1
    {load} mov ecx, eax                          # 00486cc3
    and ecx, 0x3                                 # 00486cc5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486cc8
    jmp.d32 L_004876b9                           # 00486cca
L_00486ccf:
    # block 0x00486ccf: entered by je at 0x0048680e, 5 instruction(s), ends with ja to 0x004874a1 (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00486ccf
    mov edx, dword ptr [ecx + field_bac]         # 00486cd5
    mov dword ptr [ebp - local_fc], edx          # 00486cdb
    cmp dword ptr [ebp - local_fc], 0x6          # 00486ce1
    ja.d32 L_004874a1                            # 00486ce8
    # block 0x00486cee: entered by fall-through of ja at 0x00486ce8, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4876c1]
    mov eax, dword ptr [ebp - local_fc]          # 00486cee
    jmp dword ptr [4*eax + SWTAB_004876c1_VA]    # 00486cf4
L_00486cfb:
    # block 0x00486cfb: entered by switch case, 3 instruction(s), ends with je to 0x00486de4 (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00486cfb
    cmp dword ptr [ecx + field_c2b], 0x0         # 00486d01
    je.d32 L_00486de4                            # 00486d08
    # block 0x00486d0e: entered by fall-through of je at 0x00486d08, 3 instruction(s), ends with jne to 0x00486d9c (forward)
    mov edx, dword ptr [ebp - local_f4]          # 00486d0e
    cmp dword ptr [edx + field_b8b], 0x0         # 00486d14
    jne.d8 L_00486d9c                            # 00486d1b
    # block 0x00486d1d: entered by fall-through of jne at 0x00486d1b, 7 instruction(s), calls FUN_00486725, ends with jne to 0x00486d9a (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00486d1d
    call FUN_00486725                            # 00486d23
    mov eax, dword ptr [ebp - local_f4]          # 00486d28
    {load} xor ecx, ecx                          # 00486d2e
    mov cl, byte ptr [eax + field_bb0]           # 00486d30
    test ecx, ecx                                # 00486d36
    jne.d8 L_00486d9a                            # 00486d38
    # block 0x00486d3a: entered by fall-through of jne at 0x00486d38, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00486d9a
    mov edx, dword ptr [ebp - local_c]           # 00486d3a
    add edx, 0x645                               # 00486d3d
    push edx                                     # 00486d43
    mov ecx, 0x5c3a67                            # 00486d44
    call FUN_004fb77a                            # 00486d49
    mov eax, dword ptr [ebp - local_c]           # 00486d4e
    mov cx, word ptr [eax + field_666]           # 00486d51
    push ecx                                     # 00486d58
    mov ecx, 0x5c3a67                            # 00486d59
    call FUN_004fb2e3                            # 00486d5e
    call dword ptr [0x52a23c]                    # 00486d63
    add eax, 0x320                               # 00486d69
    mov edx, dword ptr [ebp - local_f4]          # 00486d6e
    mov dword ptr [edx + field_bcd], eax         # 00486d74
    mov eax, dword ptr [ebp - local_f4]          # 00486d7a
    mov dword ptr [eax + field_bac], 0x4         # 00486d80
    mov ecx, dword ptr [ebp - local_f4]          # 00486d8a
    mov dword ptr [ecx + field_c2f], 0x1         # 00486d90
L_00486d9a:
    # block 0x00486d9a: entered by jne at 0x00486d38, 1 instruction(s), ends with forward jump to 0x00486dd4
    jmp.d8 L_00486dd4                            # 00486d9a
L_00486d9c:
    # block 0x00486d9c: entered by jne at 0x00486d1b, 11 instruction(s), calls FUN_004fb77a, KERNEL32.dll!GetTickCount, falls into the block at 0x00486dd4
    mov edx, dword ptr [ebp - local_f4]          # 00486d9c
    mov dword ptr [edx + field_bac], 0x3         # 00486da2
    mov eax, dword ptr [ebp - local_c]           # 00486dac
    add eax, 0x614                               # 00486daf
    push eax                                     # 00486db4
    mov ecx, 0x5c3a67                            # 00486db5
    call FUN_004fb77a                            # 00486dba
    call dword ptr [0x52a23c]                    # 00486dbf
    add eax, 0x64                                # 00486dc5
    mov ecx, dword ptr [ebp - local_f4]          # 00486dc8
    mov dword ptr [ecx + field_bcd], eax         # 00486dce
L_00486dd4:
    # block 0x00486dd4: entered by jmp at 0x00486d9a, 2 instruction(s), falls into the block at 0x00486de4
    mov edx, dword ptr [ebp - local_f4]          # 00486dd4
    mov dword ptr [edx + field_c2b], 0x0         # 00486dda
L_00486de4:
    # block 0x00486de4: entered by je at 0x00486d08, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d32 L_004874a1                           # 00486de4
L_00486de9:
    # block 0x00486de9: entered by switch case, 7 instruction(s), ends with je to 0x00486e3c (forward)
    mov edi, 0x54dc3c                            # 00486de9
    mov esi, dword ptr [ebp - local_c]           # 00486dee
    add esi, 0x614                               # 00486df1
    mov ecx, 0x9                                 # 00486df7
    {load} xor eax, eax                          # 00486dfc
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486dfe
    je.d8 L_00486e3c                             # 00486e00
    # block 0x00486e02: entered by fall-through of je at 0x00486e00, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00486e3c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00486e02
    movsx edx, word ptr [ecx + field_635]        # 00486e05
    mov dword ptr [ebp - local_e8], edx          # 00486e0c
    mov eax, dword ptr [ebp - local_e8]          # 00486e12
    push eax                                     # 00486e18
    mov ecx, 0x5cf1eb                            # 00486e19
    call FUN_004f6334                            # 00486e1e
    test eax, eax                                # 00486e23
    jne.d8 L_00486e3c                            # 00486e25
    # block 0x00486e27: entered by fall-through of jne at 0x00486e25, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00486e3c
    mov ecx, dword ptr [ebp - local_c]           # 00486e27
    mov dx, word ptr [ecx + field_635]           # 00486e2a
    push edx                                     # 00486e31
    mov ecx, 0x5c3a67                            # 00486e32
    call FUN_004fb2e3                            # 00486e37
L_00486e3c:
    # block 0x00486e3c: entered by je at 0x00486e00; jne at 0x00486e25, 12 instruction(s), ends with jl to 0x00486e99 (forward)
    mov eax, dword ptr [ebp - local_f4]          # 00486e3c
    movsx eax, word ptr [eax + field_c35]        # 00486e42
    mov ecx, dword ptr [ebp - local_c]           # 00486e49
    movsx ecx, word ptr [ecx + field_60a]        # 00486e4c
    cdq                                          # 00486e53
    idiv ecx                                     # 00486e54
    mov word ptr [ebp - local_10], ax            # 00486e56
    movsx edx, word ptr [ebp - local_10]         # 00486e5a
    mov eax, dword ptr [ebp - local_c]           # 00486e5e
    movsx ecx, word ptr [eax + field_608]        # 00486e61
    {load} cmp edx, ecx                          # 00486e68
    jl.d8 L_00486e99                             # 00486e6a
    # block 0x00486e6c: entered by fall-through of jl at 0x00486e6a, 7 instruction(s), falls into the block at 0x00486e99
    mov edx, dword ptr [ebp - local_f4]          # 00486e6c
    mov word ptr [edx + field_c35], 0x0          # 00486e72
    mov eax, dword ptr [ebp - local_f4]          # 00486e7b
    mov cx, word ptr [eax + field_c33]           # 00486e81
    add cx, 0x1                                  # 00486e88
    mov edx, dword ptr [ebp - local_f4]          # 00486e8c
    mov word ptr [edx + field_c33], cx           # 00486e92
L_00486e99:
    # block 0x00486e99: entered by jl at 0x00486e6a, 6 instruction(s), ends with jge to 0x00486ff5 (forward)
    mov eax, dword ptr [ebp - local_f4]          # 00486e99
    movsx ecx, word ptr [eax + field_c33]        # 00486e9f
    mov edx, dword ptr [ebp - local_c]           # 00486ea6
    movsx eax, word ptr [edx + field_612]        # 00486ea9
    {load} cmp ecx, eax                          # 00486eb0
    jge.d32 L_00486ff5                           # 00486eb2
    # block 0x00486eb8: entered by fall-through of jge at 0x00486eb2, 62 instruction(s), ends with forward jump to 0x004870c5
    mov ecx, dword ptr [ebp - local_f4]          # 00486eb8
    movsx eax, word ptr [ecx + field_c35]        # 00486ebe
    mov edx, dword ptr [ebp - local_c]           # 00486ec5
    movsx ecx, word ptr [edx + field_60a]        # 00486ec8
    cdq                                          # 00486ecf
    idiv ecx                                     # 00486ed0
    mov word ptr [ebp - local_10], ax            # 00486ed2
    mov edx, dword ptr [ebp - local_f4]          # 00486ed6
    movsx eax, word ptr [edx + field_c35]        # 00486edc
    mov ecx, dword ptr [ebp - local_c]           # 00486ee3
    movsx ecx, word ptr [ecx + field_60a]        # 00486ee6
    cdq                                          # 00486eed
    idiv ecx                                     # 00486eee
    mov word ptr [ebp - local_14], dx            # 00486ef0
    mov edx, dword ptr [ebp - local_c]           # 00486ef4
    movsx eax, word ptr [edx + field_60c]        # 00486ef7
    mov ecx, dword ptr [ebp - local_f4]          # 00486efe
    movsx edx, word ptr [ecx + field_c37]        # 00486f04
    mov ecx, dword ptr [ebp - local_c]           # 00486f0b
    movsx ecx, word ptr [ecx + field_610]        # 00486f0e
    {load} add edx, ecx                          # 00486f15
    movsx ecx, word ptr [ebp - local_14]         # 00486f17
    imul edx, ecx                                # 00486f1b
    {load} add eax, edx                          # 00486f1e
    mov edx, dword ptr [ebp - local_f4]          # 00486f20
    mov dword ptr [edx + field_b97], eax         # 00486f26
    mov eax, dword ptr [ebp - local_c]           # 00486f2c
    movsx ecx, word ptr [eax + field_60e]        # 00486f2f
    mov edx, dword ptr [ebp - local_f4]          # 00486f36
    movsx eax, word ptr [edx + field_c39]        # 00486f3c
    mov edx, dword ptr [ebp - local_c]           # 00486f43
    movsx edx, word ptr [edx + field_610]        # 00486f46
    {load} add eax, edx                          # 00486f4d
    movsx edx, word ptr [ebp - local_10]         # 00486f4f
    imul eax, edx                                # 00486f53
    {load} add ecx, eax                          # 00486f56
    mov eax, dword ptr [ebp - local_f4]          # 00486f58
    mov dword ptr [eax + field_b9b], ecx         # 00486f5e
    mov ecx, dword ptr [ebp - local_f4]          # 00486f64
    movsx edx, word ptr [ecx + field_c37]        # 00486f6a
    mov eax, dword ptr [ebp - local_f4]          # 00486f71
    mov ecx, dword ptr [eax + field_b97]         # 00486f77
    {load} add ecx, edx                          # 00486f7d
    mov edx, dword ptr [ebp - local_f4]          # 00486f7f
    mov dword ptr [edx + field_b9f], ecx         # 00486f85
    mov eax, dword ptr [ebp - local_f4]          # 00486f8b
    movsx ecx, word ptr [eax + field_c39]        # 00486f91
    mov edx, dword ptr [ebp - local_f4]          # 00486f98
    mov eax, dword ptr [edx + field_b9b]         # 00486f9e
    {load} add eax, ecx                          # 00486fa4
    mov ecx, dword ptr [ebp - local_f4]          # 00486fa6
    mov dword ptr [ecx + field_ba3], eax         # 00486fac
    mov edx, dword ptr [ebp - local_f4]          # 00486fb2
    mov ax, word ptr [edx + field_c35]           # 00486fb8
    .insn 0x66, 0x05, 0x0001{:u16}               # 00486fbf
    mov ecx, dword ptr [ebp - local_f4]          # 00486fc3
    mov word ptr [ecx + field_c35], ax           # 00486fc9
    mov edx, dword ptr [ebp - local_f4]          # 00486fd0
    mov dword ptr [edx + field_bac], 0x4         # 00486fd6
    mov eax, dword ptr [ebp - local_f4]          # 00486fe0
    mov dword ptr [eax + field_b93], 0x1         # 00486fe6
    jmp.d32 L_004870c5                           # 00486ff0
L_00486ff5:
    # block 0x00486ff5: entered by jge at 0x00486eb2, 20 instruction(s), calls FUN_004fba69, FUN_00486725, ends with jne to 0x004870c5 (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00486ff5
    mov word ptr [ecx + field_c33], 0x0          # 00486ffb
    mov edx, dword ptr [ebp - local_f4]          # 00487004
    mov dword ptr [edx + field_b8f], 0x1         # 0048700a
    mov eax, dword ptr [ebp - local_f4]          # 00487014
    mov dword ptr [eax + field_b93], 0x0         # 0048701a
    mov ecx, dword ptr [ebp - local_f4]          # 00487024
    mov dword ptr [ecx + field_bac], 0x0         # 0048702a
    mov edx, dword ptr [ebp - local_c]           # 00487034
    add edx, 0x614                               # 00487037
    push edx                                     # 0048703d
    mov ecx, 0x5c3a67                            # 0048703e
    call FUN_004fba69                            # 00487043
    mov ecx, dword ptr [ebp - local_f4]          # 00487048
    call FUN_00486725                            # 0048704e
    mov eax, dword ptr [ebp - local_f4]          # 00487053
    {load} xor ecx, ecx                          # 00487059
    mov cl, byte ptr [eax + field_bb0]           # 0048705b
    test ecx, ecx                                # 00487061
    jne.d8 L_004870c5                            # 00487063
    # block 0x00487065: entered by fall-through of jne at 0x00487063, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x004870c5
    mov edx, dword ptr [ebp - local_c]           # 00487065
    add edx, 0x645                               # 00487068
    push edx                                     # 0048706e
    mov ecx, 0x5c3a67                            # 0048706f
    call FUN_004fb77a                            # 00487074
    mov eax, dword ptr [ebp - local_c]           # 00487079
    mov cx, word ptr [eax + field_666]           # 0048707c
    push ecx                                     # 00487083
    mov ecx, 0x5c3a67                            # 00487084
    call FUN_004fb2e3                            # 00487089
    call dword ptr [0x52a23c]                    # 0048708e
    add eax, 0x320                               # 00487094
    mov edx, dword ptr [ebp - local_f4]          # 00487099
    mov dword ptr [edx + field_bcd], eax         # 0048709f
    mov eax, dword ptr [ebp - local_f4]          # 004870a5
    mov dword ptr [eax + field_bac], 0x4         # 004870ab
    mov ecx, dword ptr [ebp - local_f4]          # 004870b5
    mov dword ptr [ecx + field_c2f], 0x1         # 004870bb
L_004870c5:
    # block 0x004870c5: entered by jmp at 0x00486ff0; jne at 0x00487063, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d32 L_004874a1                           # 004870c5
L_004870ca:
    # block 0x004870ca: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00487134 (forward)
    call dword ptr [0x52a23c]                    # 004870ca
    mov edx, dword ptr [ebp - local_f4]          # 004870d0
    cmp eax, dword ptr [edx + field_bcd]         # 004870d6
    jb.d8 L_00487134                             # 004870dc
    # block 0x004870de: entered by fall-through of jb at 0x004870dc, 3 instruction(s), ends with je to 0x0048710f (forward)
    mov eax, dword ptr [ebp - local_f4]          # 004870de
    cmp dword ptr [eax + field_c2f], 0x0         # 004870e4
    je.d8 L_0048710f                             # 004870eb
    # block 0x004870ed: entered by fall-through of je at 0x004870eb, 5 instruction(s), ends with forward jump to 0x00487134
    mov ecx, dword ptr [ebp - local_f4]          # 004870ed
    mov dword ptr [ecx + field_bac], 0x0         # 004870f3
    mov edx, dword ptr [ebp - local_f4]          # 004870fd
    mov dword ptr [edx + field_c2f], 0x0         # 00487103
    jmp.d8 L_00487134                            # 0048710d
L_0048710f:
    # block 0x0048710f: entered by je at 0x004870eb, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00487134
    call dword ptr [0x52a23c]                    # 0048710f
    add eax, 0x64                                # 00487115
    mov ecx, dword ptr [ebp - local_f4]          # 00487118
    mov dword ptr [ecx + field_bcd], eax         # 0048711e
    mov edx, dword ptr [ebp - local_f4]          # 00487124
    mov dword ptr [edx + field_bac], 0x3         # 0048712a
L_00487134:
    # block 0x00487134: entered by jb at 0x004870dc; jmp at 0x0048710d, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d32 L_004874a1                           # 00487134
L_00487139:
    # block 0x00487139: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004871f5 (forward)
    call dword ptr [0x52a23c]                    # 00487139
    mov ecx, dword ptr [ebp - local_f4]          # 0048713f
    cmp eax, dword ptr [ecx + field_bc9]         # 00487145
    jb.d32 L_004871f5                            # 0048714b
    # block 0x00487151: entered by fall-through of jb at 0x0048714b, 8 instruction(s), calls FUN_004fba69, ends with je to 0x004871ad (forward)
    mov edx, dword ptr [ebp - local_f4]          # 00487151
    add edx, 0xb52                               # 00487157
    push edx                                     # 0048715d
    mov ecx, 0x5c3a67                            # 0048715e
    call FUN_004fba69                            # 00487163
    mov eax, dword ptr [ebp - local_f4]          # 00487168
    cmp dword ptr [eax + field_b87], 0x0         # 0048716e
    je.d8 L_004871ad                             # 00487175
    # block 0x00487177: entered by fall-through of je at 0x00487175, 3 instruction(s), ends with je to 0x004871ad (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00487177
    cmp dword ptr [ecx + field_b83], 0x0         # 0048717d
    je.d8 L_004871ad                             # 00487184
    # block 0x00487186: entered by fall-through of je at 0x00487184, 5 instruction(s), calls FUN_0048633c, ends with jne to 0x004871ab (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 00487186
    call FUN_0048633c                            # 0048718c
    mov edx, dword ptr [ebp - local_f4]          # 00487191
    cmp dword ptr [edx + field_c27], 0x0         # 00487197
    jne.d8 L_004871ab                            # 0048719e
    # block 0x004871a0: entered by fall-through of jne at 0x0048719e, 2 instruction(s), calls FUN_00486725, falls into the block at 0x004871ab
    mov ecx, dword ptr [ebp - local_f4]          # 004871a0
    call FUN_00486725                            # 004871a6
L_004871ab:
    # block 0x004871ab: entered by jne at 0x0048719e, 1 instruction(s), ends with forward jump to 0x004871f5
    jmp.d8 L_004871f5                            # 004871ab
L_004871ad:
    # block 0x004871ad: entered by je at 0x00487175; je at 0x00487184, 3 instruction(s), ends with je to 0x004871e5 (forward)
    mov eax, dword ptr [ebp - local_f4]          # 004871ad
    cmp dword ptr [eax + field_b87], 0x0         # 004871b3
    je.d8 L_004871e5                             # 004871ba
    # block 0x004871bc: entered by fall-through of je at 0x004871ba, 7 instruction(s), calls FUN_004866b4, ends with jne to 0x004871e5 (forward)
    mov ecx, dword ptr [ebp - local_f4]          # 004871bc
    add ecx, 0xab0                               # 004871c2
    push ecx                                     # 004871c8
    mov ecx, dword ptr [ebp - local_f4]          # 004871c9
    call FUN_004866b4                            # 004871cf
    test eax, eax                                # 004871d4
    jne.d8 L_004871e5                            # 004871d6
    # block 0x004871d8: entered by fall-through of jne at 0x004871d6, 3 instruction(s), calls FUN_00485fb6, ends with forward jump to 0x004871f5
    mov ecx, dword ptr [ebp - local_f4]          # 004871d8
    call FUN_00485fb6                            # 004871de
    jmp.d8 L_004871f5                            # 004871e3
L_004871e5:
    # block 0x004871e5: entered by je at 0x004871ba; jne at 0x004871d6, 2 instruction(s), falls into the block at 0x004871f5
    mov edx, dword ptr [ebp - local_f4]          # 004871e5
    mov dword ptr [edx + field_bac], 0x0         # 004871eb
L_004871f5:
    # block 0x004871f5: entered by jb at 0x0048714b; jmp at 0x004871ab; jmp at 0x004871e3, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d32 L_004874a1                           # 004871f5
L_004871fa:
    # block 0x004871fa: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with je to 0x00487236 (forward)
    mov eax, dword ptr [ebp - local_f4]          # 004871fa
    movsx ecx, word ptr [eax + field_b42]        # 00487200
    mov dword ptr [ebp - local_ec], ecx          # 00487207
    mov edx, dword ptr [ebp - local_ec]          # 0048720d
    push edx                                     # 00487213
    mov ecx, 0x5cf1eb                            # 00487214
    call FUN_004f6334                            # 00487219
    test eax, eax                                # 0048721e
    je.d8 L_00487236                             # 00487220
    # block 0x00487222: entered by fall-through of je at 0x00487220, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048729f (forward)
    call dword ptr [0x52a23c]                    # 00487222
    mov ecx, dword ptr [ebp - local_f4]          # 00487228
    cmp eax, dword ptr [ecx + field_bc9]         # 0048722e
    jb.d8 L_0048729f                             # 00487234
L_00487236:
    # block 0x00487236: entered by je at 0x00487220; fall-through of jb at 0x00487234, 7 instruction(s), calls FUN_004fba69, ends with je to 0x0048728f (forward)
    mov edx, dword ptr [ebp - local_f4]          # 00487236
    add edx, 0xb21                               # 0048723c
    push edx                                     # 00487242
    mov ecx, 0x5c3a67                            # 00487243
    call FUN_004fba69                            # 00487248
    cmp dword ptr [0x5bb202], 0x0                # 0048724d
    je.d8 L_0048728f                             # 00487254
    # block 0x00487256: entered by fall-through of je at 0x00487254, 3 instruction(s), ends with je to 0x0048728f (forward)
    mov eax, dword ptr [ebp - local_f4]          # 00487256
    cmp dword ptr [eax + field_bc1], 0x0         # 0048725c
    je.d8 L_0048728f                             # 00487263
    # block 0x00487265: entered by fall-through of je at 0x00487263, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x0048728f
    push 0x0                                     # 00487265
    push -0x1                                    # 00487267
    push 0x54dc48                                # 00487269
    mov ecx, dword ptr [0x5d03b3]                # 0048726e
    push ecx                                     # 00487274
    mov ecx, 0x619a05                            # 00487275
    call FUN_00448d11                            # 0048727a
    mov edx, dword ptr [ebp - local_f4]          # 0048727f
    mov dword ptr [edx + field_bc1], 0x0         # 00487285
L_0048728f:
    # block 0x0048728f: entered by je at 0x00487254; je at 0x00487263, 2 instruction(s), falls into the block at 0x0048729f
    mov eax, dword ptr [ebp - local_f4]          # 0048728f
    mov dword ptr [eax + field_bac], 0x0         # 00487295
L_0048729f:
    # block 0x0048729f: entered by jb at 0x00487234, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d32 L_004874a1                           # 0048729f
L_004872a4:
    # block 0x004872a4: entered by switch case, 7 instruction(s), ends with je to 0x00487432 (forward)
    mov edi, 0x54dc50                            # 004872a4
    mov esi, dword ptr [ebp - local_c]           # 004872a9
    add esi, 0xdc4                               # 004872ac
    mov ecx, 0x9                                 # 004872b2
    {load} xor edx, edx                          # 004872b7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004872b9
    je.d32 L_00487432                            # 004872bb
    # block 0x004872c1: entered by fall-through of je at 0x004872bb, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00487420 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004872c1
    add eax, 0xdc4                               # 004872c4
    push eax                                     # 004872c9
    mov ecx, 0x5c3a67                            # 004872ca
    call FUN_004fb77a                            # 004872cf
    mov ecx, dword ptr [ebp - local_c]           # 004872d4
    mov dx, word ptr [ecx + field_de5]           # 004872d7
    push edx                                     # 004872de
    mov ecx, 0x5c3a67                            # 004872df
    call FUN_004fb2e3                            # 004872e4
    cmp dword ptr [0x5bb202], 0x0                # 004872e9
    je.d32 L_00487420                            # 004872f0
    # block 0x004872f6: entered by fall-through of je at 0x004872f0, 9 instruction(s), ends with jbe to 0x004873a3 (forward)
    mov edi, dword ptr [ebp - local_c]           # 004872f6
    add edi, 0xdf5                               # 004872f9
    or ecx, -0x1                                 # 004872ff
    {load} xor eax, eax                          # 00487302
    repne scasb al, byte ptr es:[edi]            # 00487304
    not ecx                                      # 00487306
    add ecx, -0x1                                # 00487308
    test ecx, ecx                                # 0048730b
    jbe.d32 L_004873a3                           # 0048730d
    # block 0x00487313: entered by fall-through of jbe at 0x0048730d, 8 instruction(s), calls FUN_00423259, ends with je to 0x0048739c (forward)
    mov eax, dword ptr [ebp - local_c]           # 00487313
    add eax, 0xdf5                               # 00487316
    push eax                                     # 0048731b
    mov ecx, 0x619a6b                            # 0048731c
    call FUN_00423259                            # 00487321
    mov dword ptr [ebp - local_18], eax          # 00487326
    cmp dword ptr [ebp - local_18], 0x0          # 00487329
    je.d8 L_0048739c                             # 0048732d
    # block 0x0048732f: entered by fall-through of je at 0x0048732d, 8 instruction(s), ends with ja to 0x0048739c (forward)
    mov edi, dword ptr [ebp - local_18]          # 0048732f
    or ecx, -0x1                                 # 00487332
    {load} xor eax, eax                          # 00487335
    repne scasb al, byte ptr es:[edi]            # 00487337
    not ecx                                      # 00487339
    add ecx, -0x1                                # 0048733b
    cmp ecx, 0x9c40                              # 0048733e
    ja.d8 L_0048739c                             # 00487344
    # block 0x00487346: entered by fall-through of ja at 0x00487344, 28 instruction(s), calls FUN_00448d11, ends with forward jump to 0x004873a3
    mov edi, dword ptr [ebp - local_18]          # 00487346
    or ecx, -0x1                                 # 00487349
    {load} xor eax, eax                          # 0048734c
    repne scasb al, byte ptr es:[edi]            # 0048734e
    not ecx                                      # 00487350
    mov esi, dword ptr [ebp - local_18]          # 00487352
    lea edi, [ebp - local_e4]                    # 00487355
    {load} mov edx, ecx                          # 0048735b
    shr ecx, 0x2                                 # 0048735d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00487360
    {load} mov ecx, edx                          # 00487362
    and ecx, 0x3                                 # 00487364
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00487367
    lea edi, [ebp - local_e4]                    # 00487369
    or ecx, -0x1                                 # 0048736f
    {load} xor eax, eax                          # 00487372
    repne scasb al, byte ptr es:[edi]            # 00487374
    mov eax, dword ptr [0x54dc5c]                # 00487376
    mov dword ptr [edi - field_minus_1], eax     # 0048737b
    push 0x0                                     # 0048737e
    push -0x1                                    # 00487380
    lea ecx, [ebp - local_e4]                    # 00487382
    push ecx                                     # 00487388
    mov edx, dword ptr [0x5d03b3]                # 00487389
    push edx                                     # 0048738f
    mov ecx, 0x619a05                            # 00487390
    call FUN_00448d11                            # 00487395
    jmp.d8 L_004873a3                            # 0048739a
L_0048739c:
    # block 0x0048739c: entered by je at 0x0048732d; ja at 0x00487344, 1 instruction(s), falls into the block at 0x004873a3
    mov dword ptr [ebp - local_18], 0x0          # 0048739c
L_004873a3:
    # block 0x004873a3: entered by jbe at 0x0048730d; jmp at 0x0048739a, 2 instruction(s), ends with jne to 0x00487420 (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004873a3
    jne.d8 L_00487420                            # 004873a7
    # block 0x004873a9: entered by fall-through of jne at 0x004873a7, 9 instruction(s), ends with jbe to 0x00487420 (forward)
    mov edi, dword ptr [ebp - local_c]           # 004873a9
    add edi, 0xe16                               # 004873ac
    or ecx, -0x1                                 # 004873b2
    {load} xor eax, eax                          # 004873b5
    repne scasb al, byte ptr es:[edi]            # 004873b7
    not ecx                                      # 004873b9
    add ecx, -0x1                                # 004873bb
    test ecx, ecx                                # 004873be
    jbe.d8 L_00487420                            # 004873c0
    # block 0x004873c2: entered by fall-through of jbe at 0x004873c0, 31 instruction(s), calls FUN_00448d11, falls into the block at 0x00487420
    mov eax, dword ptr [ebp - local_c]           # 004873c2
    add eax, 0xe16                               # 004873c5
    {load} mov edi, eax                          # 004873ca
    lea edx, [ebp - local_e4]                    # 004873cc
    or ecx, -0x1                                 # 004873d2
    {load} xor eax, eax                          # 004873d5
    repne scasb al, byte ptr es:[edi]            # 004873d7
    not ecx                                      # 004873d9
    {load} sub edi, ecx                          # 004873db
    {load} mov esi, edi                          # 004873dd
    {load} mov eax, ecx                          # 004873df
    {load} mov edi, edx                          # 004873e1
    shr ecx, 0x2                                 # 004873e3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004873e6
    {load} mov ecx, eax                          # 004873e8
    and ecx, 0x3                                 # 004873ea
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004873ed
    lea edi, [ebp - local_e4]                    # 004873ef
    or ecx, -0x1                                 # 004873f5
    {load} xor eax, eax                          # 004873f8
    repne scasb al, byte ptr es:[edi]            # 004873fa
    mov ecx, dword ptr [0x54dc60]                # 004873fc
    mov dword ptr [edi - field_minus_1], ecx     # 00487402
    push 0x0                                     # 00487405
    push -0x1                                    # 00487407
    lea edx, [ebp - local_e4]                    # 00487409
    push edx                                     # 0048740f
    mov eax, dword ptr [0x5d03b3]                # 00487410
    push eax                                     # 00487415
    mov ecx, 0x619a05                            # 00487416
    call FUN_00448d11                            # 0048741b
L_00487420:
    # block 0x00487420: entered by je at 0x004872f0; jne at 0x004873a7; jbe at 0x004873c0, 3 instruction(s), ends with forward jump to 0x0048744c
    mov ecx, dword ptr [ebp - local_f4]          # 00487420
    mov dword ptr [ecx + field_bac], 0x5         # 00487426
    jmp.d8 L_0048744c                            # 00487430
L_00487432:
    # block 0x00487432: entered by je at 0x004872bb, 4 instruction(s), falls into the block at 0x0048744c
    mov edx, dword ptr [ebp - local_f4]          # 00487432
    movsx eax, word ptr [edx + field_26]         # 00487438
    imul eax, eax, 0x8d                          # 0048743c
    mov dword ptr [eax + 0x5bb632], 0x2          # 00487442
L_0048744c:
    # block 0x0048744c: entered by jmp at 0x00487430, 1 instruction(s), ends with forward jump to 0x004874a1
    jmp.d8 L_004874a1                            # 0048744c
L_0048744e:
    # block 0x0048744e: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004874a1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048744e
    movsx edx, word ptr [ecx + field_de5]        # 00487451
    mov dword ptr [ebp - local_f0], edx          # 00487458
    mov eax, dword ptr [ebp - local_f0]          # 0048745e
    push eax                                     # 00487464
    mov ecx, 0x5cf1eb                            # 00487465
    call FUN_004f6334                            # 0048746a
    test eax, eax                                # 0048746f
    jne.d8 L_004874a1                            # 00487471
    # block 0x00487473: entered by fall-through of jne at 0x00487471, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004874a1
    mov ecx, dword ptr [ebp - local_c]           # 00487473
    add ecx, 0xdc4                               # 00487476
    push ecx                                     # 0048747c
    mov ecx, 0x5c3a67                            # 0048747d
    call FUN_004fba69                            # 00487482
    mov edx, dword ptr [ebp - local_f4]          # 00487487
    movsx eax, word ptr [edx + field_26]         # 0048748d
    imul eax, eax, 0x8d                          # 00487491
    mov dword ptr [eax + 0x5bb632], 0x2          # 00487497
L_004874a1:
    # block 0x004874a1: entered by ja at 0x00486ce8; jmp at 0x00486de4; jmp at 0x004870c5; jmp at 0x00487134; more, 1 instruction(s), ends with forward jump to 0x004876b9
    jmp.d32 L_004876b9                           # 004874a1
L_004874a6:
    # block 0x004874a6: entered by je at 0x0048681b, 6 instruction(s), ends with je to 0x004875a8 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004874a6
    mov ecx, dword ptr [ebp - local_f4]          # 004874b0
    {load} xor edx, edx                          # 004874b6
    mov dl, byte ptr [ecx + field_bab]           # 004874b8
    test edx, edx                                # 004874be
    je.d32 L_004875a8                            # 004874c0
    # block 0x004874c6: entered by fall-through of je at 0x004874c0, 4 instruction(s), ends with je to 0x00487578 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004874c6
    movsx ecx, word ptr [eax + field_ede]        # 004874c9
    cmp ecx, 0x270f                              # 004874d0
    je.d32 L_00487578                            # 004874d6
    # block 0x004874dc: entered by fall-through of je at 0x004874d6, 25 instruction(s), ends with jne to 0x00487564 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004874dc
    movsx eax, word ptr [edx + field_ede]        # 004874df
    mov dword ptr [0x5bb57b], eax                # 004874e6
    mov ecx, dword ptr [ebp - local_c]           # 004874eb
    mov dx, word ptr [ecx + field_ee0]           # 004874ee
    mov word ptr [0x5bb599], dx                  # 004874f5
    mov eax, dword ptr [ebp - local_c]           # 004874fc
    mov cx, word ptr [eax + field_ee2]           # 004874ff
    mov word ptr [0x5bb595], cx                  # 00487506
    mov edx, dword ptr [ebp - local_c]           # 0048750d
    mov ax, word ptr [edx + field_ee4]           # 00487510
    mov word ptr [0x5c39ff], ax                  # 00487517
    mov ecx, dword ptr [ebp - local_c]           # 0048751d
    mov edx, dword ptr [ecx + field_ee6]         # 00487520
    mov dword ptr [0x5bb59b], edx                # 00487526
    mov eax, dword ptr [ebp - local_c]           # 0048752c
    mov ecx, dword ptr [eax + field_eea]         # 0048752f
    mov dword ptr [0x5bb59f], ecx                # 00487535
    mov edx, dword ptr [ebp - local_c]           # 0048753b
    mov eax, dword ptr [edx + field_eee]         # 0048753e
    mov dword ptr [0x5bb5a3], eax                # 00487544
    mov ecx, dword ptr [ebp - local_c]           # 00487549
    movsx edx, word ptr [ecx + field_ef2]        # 0048754c
    cmp edx, 0x1                                 # 00487553
    jne.d8 L_00487564                            # 00487556
    # block 0x00487558: entered by fall-through of jne at 0x00487556, 2 instruction(s), ends with forward jump to 0x0048756e
    mov dword ptr [0x5bb1ca], 0x0                # 00487558
    jmp.d8 L_0048756e                            # 00487562
L_00487564:
    # block 0x00487564: entered by jne at 0x00487556, 1 instruction(s), falls into the block at 0x0048756e
    mov dword ptr [0x5bb1ca], 0x1                # 00487564
L_0048756e:
    # block 0x0048756e: entered by jmp at 0x00487562, 1 instruction(s), falls into the block at 0x00487578
    mov dword ptr [0x583999], 0x4                # 0048756e
L_00487578:
    # block 0x00487578: entered by je at 0x004874d6, 4 instruction(s), ends with je to 0x004875a3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00487578
    movsx ecx, word ptr [eax + field_ef4]        # 0048757b
    cmp ecx, -0x1                                # 00487582
    je.d8 L_004875a3                             # 00487585
    # block 0x00487587: entered by fall-through of je at 0x00487585, 6 instruction(s), falls into the block at 0x004875a3
    mov edx, dword ptr [ebp - local_c]           # 00487587
    {load} xor eax, eax                          # 0048758a
    mov al, byte ptr [edx + field_ef6]           # 0048758c
    mov ecx, dword ptr [ebp - local_c]           # 00487592
    movsx edx, word ptr [ecx + field_ef4]        # 00487595
    mov dword ptr [4*edx + 0x585801], eax        # 0048759c
L_004875a3:
    # block 0x004875a3: entered by je at 0x00487585, 1 instruction(s), ends with forward jump to 0x0048769b
    jmp.d32 L_0048769b                           # 004875a3
L_004875a8:
    # block 0x004875a8: entered by je at 0x004874c0, 5 instruction(s), ends with je to 0x0048769b (forward)
    mov eax, dword ptr [ebp - local_f4]          # 004875a8
    {load} xor ecx, ecx                          # 004875ae
    mov cl, byte ptr [eax + field_bb0]           # 004875b0
    test ecx, ecx                                # 004875b6
    je.d32 L_0048769b                            # 004875b8
    # block 0x004875be: entered by fall-through of je at 0x004875b8, 4 instruction(s), ends with je to 0x00487670 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004875be
    movsx eax, word ptr [edx + field_dab]        # 004875c1
    cmp eax, 0x270f                              # 004875c8
    je.d32 L_00487670                            # 004875cd
    # block 0x004875d3: entered by fall-through of je at 0x004875cd, 25 instruction(s), ends with jne to 0x0048765c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004875d3
    movsx edx, word ptr [ecx + field_dab]        # 004875d6
    mov dword ptr [0x5bb57b], edx                # 004875dd
    mov eax, dword ptr [ebp - local_c]           # 004875e3
    mov cx, word ptr [eax + field_dad]           # 004875e6
    mov word ptr [0x5bb599], cx                  # 004875ed
    mov edx, dword ptr [ebp - local_c]           # 004875f4
    mov ax, word ptr [edx + field_daf]           # 004875f7
    mov word ptr [0x5bb595], ax                  # 004875fe
    mov ecx, dword ptr [ebp - local_c]           # 00487604
    mov dx, word ptr [ecx + field_db1]           # 00487607
    mov word ptr [0x5c39ff], dx                  # 0048760e
    mov eax, dword ptr [ebp - local_c]           # 00487615
    mov ecx, dword ptr [eax + field_db3]         # 00487618
    mov dword ptr [0x5bb59b], ecx                # 0048761e
    mov edx, dword ptr [ebp - local_c]           # 00487624
    mov eax, dword ptr [edx + field_db7]         # 00487627
    mov dword ptr [0x5bb59f], eax                # 0048762d
    mov ecx, dword ptr [ebp - local_c]           # 00487632
    mov edx, dword ptr [ecx + field_dbb]         # 00487635
    mov dword ptr [0x5bb5a3], edx                # 0048763b
    mov eax, dword ptr [ebp - local_c]           # 00487641
    movsx ecx, word ptr [eax + field_dbf]        # 00487644
    cmp ecx, 0x1                                 # 0048764b
    jne.d8 L_0048765c                            # 0048764e
    # block 0x00487650: entered by fall-through of jne at 0x0048764e, 2 instruction(s), ends with forward jump to 0x00487666
    mov dword ptr [0x5bb1ca], 0x0                # 00487650
    jmp.d8 L_00487666                            # 0048765a
L_0048765c:
    # block 0x0048765c: entered by jne at 0x0048764e, 1 instruction(s), falls into the block at 0x00487666
    mov dword ptr [0x5bb1ca], 0x1                # 0048765c
L_00487666:
    # block 0x00487666: entered by jmp at 0x0048765a, 1 instruction(s), falls into the block at 0x00487670
    mov dword ptr [0x583999], 0x4                # 00487666
L_00487670:
    # block 0x00487670: entered by je at 0x004875cd, 4 instruction(s), ends with je to 0x0048769b (forward)
    mov edx, dword ptr [ebp - local_c]           # 00487670
    movsx eax, word ptr [edx + field_dc1]        # 00487673
    cmp eax, -0x1                                # 0048767a
    je.d8 L_0048769b                             # 0048767d
    # block 0x0048767f: entered by fall-through of je at 0x0048767d, 6 instruction(s), falls into the block at 0x0048769b
    mov ecx, dword ptr [ebp - local_c]           # 0048767f
    {load} xor edx, edx                          # 00487682
    mov dl, byte ptr [ecx + field_dc3]           # 00487684
    mov eax, dword ptr [ebp - local_c]           # 0048768a
    movsx ecx, word ptr [eax + field_dc1]        # 0048768d
    mov dword ptr [4*ecx + 0x585801], edx        # 00487694
L_0048769b:
    # block 0x0048769b: entered by jmp at 0x004875a3; je at 0x004875b8; je at 0x0048767d, 7 instruction(s), calls FUN_0042ba3a, FUN_00483fb5, falls into the block at 0x004876b9
    mov edx, dword ptr [ebp - local_f4]          # 0048769b
    mov ax, word ptr [edx + field_26]            # 004876a1
    push eax                                     # 004876a5
    call FUN_0042ba3a                            # 004876a6
    add esp, 0x4                                 # 004876ab
    mov ecx, dword ptr [ebp - local_f4]          # 004876ae
    call FUN_00483fb5                            # 004876b4
L_004876b9:
    # block 0x004876b9: entered by jmp at 0x00486821; jmp at 0x00486cca; jmp at 0x004874a1, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004876b9
    pop esi                                      # 004876ba
    {load} mov esp, ebp                          # 004876bb
    pop ebp                                      # 004876bd
    ret 0x4                                      # 004876be

# --- data items (not part of the function) -------------------------
.org 0x004876c1 - 0x401000
SWTAB_004876c1:  # 7 case address(es)
    .long L_00486cfb - .text + 0x401000
    .long L_00487139 - .text + 0x401000
    .long L_004871fa - .text + 0x401000
    .long L_00486de9 - .text + 0x401000
    .long L_004870ca - .text + 0x401000
    .long L_0048744e - .text + 0x401000
    .long L_004872a4 - .text + 0x401000
.set SWTAB_004876c1_VA, SWTAB_004876c1 - .text + 0x401000

