# FUN_00427a50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00427a50
# extent:       0x00427a50-0x0042a9b4 (12132 code bytes)
# span:         0x00427a50-0x0042acad (code 12132, tables 761, padding 0)
# sha256:       41778bbe0b676916876808865a5ee44c660fb899fcbdd8994249c19ab934a895
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_scene_row_dispatcher
# naming:       INFERRED (lower confidence, not verified): the repository text tasks/A-0C.1-body-boundary-and-decoder.md:16 says "normalised dispatch is `0x427a50`"
# name-note:    Normalised per-row dispatcher with arms per runtime type.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       52 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_118, local_11c, local_120, local_124, local_128, local_12c, local_130 and 40 more
# fields:       [eax + n] field_2, field_4, field_6, field_8, field_c, field_10, field_24, field_2f; [ecx + n] field_2, field_4, field_6, field_8, field_c, field_10, field_25, field_2b, field_2d, field_31, field_35, field_39; [edx + n] field_2, field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_21, field_23, field_24 and 3 more
# callees:      calls FUN_00423f57, FUN_0042ae73, FUN_0042b07e, FUN_0042b2e4, FUN_00414947, FUN_004cb586, FUN_0042b510, FUN_0042ba3a, FUN_0044727a, FUN_004cd6ff, FUN_004ced84, FUN_00420c17, FUN_0042c221, FUN_0042d35a, FUN_004bf9bb, FUN_004899ca and 106 more
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.h:convo3f_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 2703 instruction(s), 177 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
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
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ local_1b4, 0x1b4  # offset -0x1b4
.equ local_1b8, 0x1b8  # offset -0x1b8
.equ local_1bc, 0x1bc  # offset -0x1bc
.equ local_1c4, 0x1c4  # offset -0x1c4
.equ local_1c8, 0x1c8  # offset -0x1c8
.equ local_1cc, 0x1cc  # offset -0x1cc
.equ local_1d4, 0x1d4  # offset -0x1d4
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_c2, 0xc2  # offset +0xc2
.equ field_de, 0xde  # offset +0xde

# --- external targets -----------------------------------------------
.set FUN_00411f24, .text + (0x00411f24 - 0x401000)
.set FUN_004121b8, .text + (0x004121b8 - 0x401000)
.set FUN_00412234, .text + (0x00412234 - 0x401000)
.set FUN_00412787, .text + (0x00412787 - 0x401000)
.set FUN_004129da, .text + (0x004129da - 0x401000)
.set FUN_00412cb9, .text + (0x00412cb9 - 0x401000)
.set FUN_00414947, .text + (0x00414947 - 0x401000)
.set FUN_00420c17, .text + (0x00420c17 - 0x401000)
.set FUN_00423f57, .text + (0x00423f57 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0042acad, .text + (0x0042acad - 0x401000)
.set FUN_0042ae73, .text + (0x0042ae73 - 0x401000)
.set FUN_0042b07e, .text + (0x0042b07e - 0x401000)
.set FUN_0042b2e4, .text + (0x0042b2e4 - 0x401000)
.set FUN_0042b510, .text + (0x0042b510 - 0x401000)
.set FUN_0042b87a, .text + (0x0042b87a - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0042babf, .text + (0x0042babf - 0x401000)
.set FUN_0042c221, .text + (0x0042c221 - 0x401000)
.set FUN_0042d35a, .text + (0x0042d35a - 0x401000)
.set FUN_0042e493, .text + (0x0042e493 - 0x401000)
.set FUN_0042e560, .text + (0x0042e560 - 0x401000)
.set FUN_0042e844, .text + (0x0042e844 - 0x401000)
.set FUN_0042ea87, .text + (0x0042ea87 - 0x401000)
.set FUN_0042ed54, .text + (0x0042ed54 - 0x401000)
.set FUN_0042f510, .text + (0x0042f510 - 0x401000)
.set FUN_0042fc70, .text + (0x0042fc70 - 0x401000)
.set FUN_00430ca0, .text + (0x00430ca0 - 0x401000)
.set FUN_004313e3, .text + (0x004313e3 - 0x401000)
.set FUN_00431b5a, .text + (0x00431b5a - 0x401000)
.set FUN_00432d1a, .text + (0x00432d1a - 0x401000)
.set FUN_004336ad, .text + (0x004336ad - 0x401000)
.set FUN_004338bb, .text + (0x004338bb - 0x401000)
.set FUN_00433bd2, .text + (0x00433bd2 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0043e8b8, .text + (0x0043e8b8 - 0x401000)
.set FUN_0043e96c, .text + (0x0043e96c - 0x401000)
.set FUN_0044727a, .text + (0x0044727a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044b26a, .text + (0x0044b26a - 0x401000)
.set FUN_0044b3c8, .text + (0x0044b3c8 - 0x401000)
.set FUN_0044b641, .text + (0x0044b641 - 0x401000)
.set FUN_0044da08, .text + (0x0044da08 - 0x401000)
.set FUN_0044efcd, .text + (0x0044efcd - 0x401000)
.set FUN_00452576, .text + (0x00452576 - 0x401000)
.set FUN_00455cc3, .text + (0x00455cc3 - 0x401000)
.set FUN_0045764a, .text + (0x0045764a - 0x401000)
.set FUN_00458e55, .text + (0x00458e55 - 0x401000)
.set FUN_0045a07b, .text + (0x0045a07b - 0x401000)
.set FUN_0045c18f, .text + (0x0045c18f - 0x401000)
.set FUN_0045f0e6, .text + (0x0045f0e6 - 0x401000)
.set FUN_00463392, .text + (0x00463392 - 0x401000)
.set FUN_004650db, .text + (0x004650db - 0x401000)
.set FUN_004662d8, .text + (0x004662d8 - 0x401000)
.set FUN_00467fcd, .text + (0x00467fcd - 0x401000)
.set FUN_004695f7, .text + (0x004695f7 - 0x401000)
.set FUN_0046cda0, .text + (0x0046cda0 - 0x401000)
.set FUN_0046f986, .text + (0x0046f986 - 0x401000)
.set FUN_00471722, .text + (0x00471722 - 0x401000)
.set FUN_0047428c, .text + (0x0047428c - 0x401000)
.set FUN_00476a25, .text + (0x00476a25 - 0x401000)
.set FUN_0047a416, .text + (0x0047a416 - 0x401000)
.set FUN_0047c0f0, .text + (0x0047c0f0 - 0x401000)
.set FUN_0047d788, .text + (0x0047d788 - 0x401000)
.set FUN_00480e02, .text + (0x00480e02 - 0x401000)
.set FUN_00482a08, .text + (0x00482a08 - 0x401000)
.set FUN_004867bd, .text + (0x004867bd - 0x401000)
.set FUN_00488319, .text + (0x00488319 - 0x401000)
.set FUN_004899ca, .text + (0x004899ca - 0x401000)
.set FUN_0048ae05, .text + (0x0048ae05 - 0x401000)
.set FUN_0048c1c0, .text + (0x0048c1c0 - 0x401000)
.set FUN_0048d914, .text + (0x0048d914 - 0x401000)
.set FUN_0048f181, .text + (0x0048f181 - 0x401000)
.set FUN_004a2180, .text + (0x004a2180 - 0x401000)
.set FUN_004a4f58, .text + (0x004a4f58 - 0x401000)
.set FUN_004a6c61, .text + (0x004a6c61 - 0x401000)
.set FUN_004a8d28, .text + (0x004a8d28 - 0x401000)
.set FUN_004aa81e, .text + (0x004aa81e - 0x401000)
.set FUN_004aba6d, .text + (0x004aba6d - 0x401000)
.set FUN_004af225, .text + (0x004af225 - 0x401000)
.set FUN_004b2ce6, .text + (0x004b2ce6 - 0x401000)
.set FUN_004b4a68, .text + (0x004b4a68 - 0x401000)
.set FUN_004b64a9, .text + (0x004b64a9 - 0x401000)
.set FUN_004b777d, .text + (0x004b777d - 0x401000)
.set FUN_004b8e92, .text + (0x004b8e92 - 0x401000)
.set FUN_004bca71, .text + (0x004bca71 - 0x401000)
.set FUN_004bf9bb, .text + (0x004bf9bb - 0x401000)
.set FUN_004c36b2, .text + (0x004c36b2 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cb586, .text + (0x004cb586 - 0x401000)
.set FUN_004cd6ff, .text + (0x004cd6ff - 0x401000)
.set FUN_004ced84, .text + (0x004ced84 - 0x401000)
.set FUN_004d7a15, .text + (0x004d7a15 - 0x401000)
.set FUN_004de24f, .text + (0x004de24f - 0x401000)
.set FUN_004de2d8, .text + (0x004de2d8 - 0x401000)
.set FUN_004e13e4, .text + (0x004e13e4 - 0x401000)
.set FUN_004e303b, .text + (0x004e303b - 0x401000)
.set FUN_004e386e, .text + (0x004e386e - 0x401000)
.set FUN_004e71da, .text + (0x004e71da - 0x401000)
.set FUN_004e7253, .text + (0x004e7253 - 0x401000)
.set FUN_004e72fb, .text + (0x004e72fb - 0x401000)
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004ea3a0, .text + (0x004ea3a0 - 0x401000)
.set FUN_004eaadc, .text + (0x004eaadc - 0x401000)
.set FUN_004eac4c, .text + (0x004eac4c - 0x401000)
.set FUN_004eaca8, .text + (0x004eaca8 - 0x401000)
.set FUN_004ead69, .text + (0x004ead69 - 0x401000)
.set FUN_004eaf2a, .text + (0x004eaf2a - 0x401000)
.set FUN_004eb5f2, .text + (0x004eb5f2 - 0x401000)
.set FUN_004eb96e, .text + (0x004eb96e - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)
.set FUN_004fb018, .text + (0x004fb018 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)
.set FUN_004fc9f1, .text + (0x004fc9f1 - 0x401000)
.set FUN_004fca60, .text + (0x004fca60 - 0x401000)
.set FUN_004fce5e, .text + (0x004fce5e - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00427a50 - 0x401000
.globl FUN_00427a50
FUN_00427a50:
    # block 0x00427a50: entry, 7 instruction(s), ends with forward jump to 0x00427a78
    push ebp                                     # 00427a50
    {load} mov ebp, esp                          # 00427a51
    sub esp, 0x1d8                               # 00427a53
    push esi                                     # 00427a59
    push edi                                     # 00427a5a
    mov word ptr [ebp - local_11c], 0x0          # 00427a5b
    jmp.d8 L_00427a78                            # 00427a64
L_00427a66:
    # block 0x00427a66: entered by jmp at 0x00427acb; jmp at 0x0042a9a9, 3 instruction(s), falls into the block at 0x00427a78
    mov ax, word ptr [ebp - local_11c]           # 00427a66
    .insn 0x66, 0x05, 0x0001{:u16}               # 00427a6d
    mov word ptr [ebp - local_11c], ax           # 00427a71
L_00427a78:
    # block 0x00427a78: entered by jmp at 0x00427a64, 4 instruction(s), ends with jge to 0x0042a9ae (forward)
    movsx ecx, word ptr [ebp - local_11c]        # 00427a78
    movsx edx, word ptr [0x5c39e3]               # 00427a7f
    {load} cmp ecx, edx                          # 00427a86
    jge.d32 L_0042a9ae                           # 00427a88
    # block 0x00427a8e: entered by fall-through of jge at 0x00427a88, 2 instruction(s), ends with je to 0x00427a9c (forward)
    cmp dword ptr [0x583999], 0x3                # 00427a8e
    je.d8 L_00427a9c                             # 00427a95
    # block 0x00427a97: entered by fall-through of je at 0x00427a95, 1 instruction(s), ends with forward jump to 0x0042a9ae
    jmp.d32 L_0042a9ae                           # 00427a97
L_00427a9c:
    # block 0x00427a9c: entered by je at 0x00427a95, 6 instruction(s), ends with jne to 0x00427acb (forward)
    movsx eax, word ptr [ebp - local_11c]        # 00427a9c
    imul eax, eax, 0x8d                          # 00427aa3
    {load} xor ecx, ecx                          # 00427aa9
    mov cl, byte ptr [eax + 0x5bb625]            # 00427aab
    test ecx, ecx                                # 00427ab1
    jne.d8 L_00427acb                            # 00427ab3
    # block 0x00427ab5: entered by fall-through of jne at 0x00427ab3, 4 instruction(s), ends with je to 0x00427acd (forward)
    movsx edx, word ptr [ebp - local_11c]        # 00427ab5
    imul edx, edx, 0x8d                          # 00427abc
    cmp dword ptr [edx + 0x5bb638], 0x0          # 00427ac2
    je.d8 L_00427acd                             # 00427ac9
L_00427acb:
    # block 0x00427acb: entered by jne at 0x00427ab3; fall-through of je at 0x00427ac9, 1 instruction(s), ends with backward jump to 0x00427a66
    jmp.d8 L_00427a66                            # 00427acb
L_00427acd:
    # block 0x00427acd: entered by je at 0x00427ac9, 13 instruction(s), ends with ja to 0x0042a963 (forward)
    movsx eax, word ptr [ebp - local_11c]        # 00427acd
    imul eax, eax, 0x8d                          # 00427ad4
    mov dword ptr [eax + 0x5bb626], 0x0          # 00427ada
    movsx ecx, word ptr [ebp - local_11c]        # 00427ae4
    imul ecx, ecx, 0x8d                          # 00427aeb
    {load} xor edx, edx                          # 00427af1
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 00427af3
    mov dword ptr [ebp - local_154], edx         # 00427af9
    mov eax, dword ptr [ebp - local_154]         # 00427aff
    sub eax, 0xa                                 # 00427b05
    mov dword ptr [ebp - local_154], eax         # 00427b08
    cmp dword ptr [ebp - local_154], 0xec        # 00427b0e
    ja.d32 L_0042a963                            # 00427b18
    # block 0x00427b1e: entered by fall-through of ja at 0x00427b18, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x42a9b4]
    mov edx, dword ptr [ebp - local_154]         # 00427b1e
    {load} xor ecx, ecx                          # 00427b24
    mov cl, byte ptr [edx + IDXTAB_0042aba4_VA]  # 00427b26
    jmp dword ptr [4*ecx + SWTAB_0042a9b4_VA]    # 00427b2c
L_00427b33:
    # block 0x00427b33: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427b66 (forward)
    push 0x1                                     # 00427b33
    movsx eax, word ptr [ebp - local_11c]        # 00427b35
    imul eax, eax, 0x8d                          # 00427b3c
    add eax, 0x5bb5e9                            # 00427b42
    push eax                                     # 00427b47
    mov ecx, 0x63786d                            # 00427b48
    call FUN_00423f57                            # 00427b4d
    test eax, eax                                # 00427b52
    je.d8 L_00427b66                             # 00427b54
    # block 0x00427b56: entered by fall-through of je at 0x00427b54, 4 instruction(s), calls FUN_0042ae73, falls into the block at 0x00427b66
    mov cx, word ptr [ebp - local_11c]           # 00427b56
    push ecx                                     # 00427b5d
    call FUN_0042ae73                            # 00427b5e
    add esp, 0x4                                 # 00427b63
L_00427b66:
    # block 0x00427b66: entered by je at 0x00427b54, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427b66
L_00427b6b:
    # block 0x00427b6b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427b9f (forward)
    push 0x0                                     # 00427b6b
    movsx edx, word ptr [ebp - local_11c]        # 00427b6d
    imul edx, edx, 0x8d                          # 00427b74
    add edx, 0x5bb5e9                            # 00427b7a
    push edx                                     # 00427b80
    mov ecx, 0x63786d                            # 00427b81
    call FUN_00423f57                            # 00427b86
    test eax, eax                                # 00427b8b
    je.d8 L_00427b9f                             # 00427b8d
    # block 0x00427b8f: entered by fall-through of je at 0x00427b8d, 4 instruction(s), calls FUN_0042ae73, falls into the block at 0x00427b9f
    mov ax, word ptr [ebp - local_11c]           # 00427b8f
    push eax                                     # 00427b96
    call FUN_0042ae73                            # 00427b97
    add esp, 0x4                                 # 00427b9c
L_00427b9f:
    # block 0x00427b9f: entered by je at 0x00427b8d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427b9f
L_00427ba4:
    # block 0x00427ba4: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427bd8 (forward)
    push 0x1                                     # 00427ba4
    movsx ecx, word ptr [ebp - local_11c]        # 00427ba6
    imul ecx, ecx, 0x8d                          # 00427bad
    add ecx, 0x5bb5e9                            # 00427bb3
    push ecx                                     # 00427bb9
    mov ecx, 0x63786d                            # 00427bba
    call FUN_00423f57                            # 00427bbf
    test eax, eax                                # 00427bc4
    je.d8 L_00427bd8                             # 00427bc6
    # block 0x00427bc8: entered by fall-through of je at 0x00427bc6, 4 instruction(s), calls FUN_0042ae73, falls into the block at 0x00427bd8
    mov dx, word ptr [ebp - local_11c]           # 00427bc8
    push edx                                     # 00427bcf
    call FUN_0042ae73                            # 00427bd0
    add esp, 0x4                                 # 00427bd5
L_00427bd8:
    # block 0x00427bd8: entered by je at 0x00427bc6, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427bd8
L_00427bdd:
    # block 0x00427bdd: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427c10 (forward)
    push 0x1                                     # 00427bdd
    movsx eax, word ptr [ebp - local_11c]        # 00427bdf
    imul eax, eax, 0x8d                          # 00427be6
    add eax, 0x5bb5e9                            # 00427bec
    push eax                                     # 00427bf1
    mov ecx, 0x63786d                            # 00427bf2
    call FUN_00423f57                            # 00427bf7
    test eax, eax                                # 00427bfc
    je.d8 L_00427c10                             # 00427bfe
    # block 0x00427c00: entered by fall-through of je at 0x00427bfe, 4 instruction(s), calls FUN_0042b07e, falls into the block at 0x00427c10
    mov cx, word ptr [ebp - local_11c]           # 00427c00
    push ecx                                     # 00427c07
    call FUN_0042b07e                            # 00427c08
    add esp, 0x4                                 # 00427c0d
L_00427c10:
    # block 0x00427c10: entered by je at 0x00427bfe, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427c10
L_00427c15:
    # block 0x00427c15: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427c49 (forward)
    push 0x0                                     # 00427c15
    movsx edx, word ptr [ebp - local_11c]        # 00427c17
    imul edx, edx, 0x8d                          # 00427c1e
    add edx, 0x5bb5e9                            # 00427c24
    push edx                                     # 00427c2a
    mov ecx, 0x63786d                            # 00427c2b
    call FUN_00423f57                            # 00427c30
    test eax, eax                                # 00427c35
    je.d8 L_00427c49                             # 00427c37
    # block 0x00427c39: entered by fall-through of je at 0x00427c37, 4 instruction(s), calls FUN_0042b07e, falls into the block at 0x00427c49
    mov ax, word ptr [ebp - local_11c]           # 00427c39
    push eax                                     # 00427c40
    call FUN_0042b07e                            # 00427c41
    add esp, 0x4                                 # 00427c46
L_00427c49:
    # block 0x00427c49: entered by je at 0x00427c37, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427c49
L_00427c4e:
    # block 0x00427c4e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427c82 (forward)
    push 0x0                                     # 00427c4e
    movsx ecx, word ptr [ebp - local_11c]        # 00427c50
    imul ecx, ecx, 0x8d                          # 00427c57
    add ecx, 0x5bb5e9                            # 00427c5d
    push ecx                                     # 00427c63
    mov ecx, 0x63786d                            # 00427c64
    call FUN_00423f57                            # 00427c69
    test eax, eax                                # 00427c6e
    je.d8 L_00427c82                             # 00427c70
    # block 0x00427c72: entered by fall-through of je at 0x00427c70, 4 instruction(s), calls FUN_0042b2e4, falls into the block at 0x00427c82
    mov dx, word ptr [ebp - local_11c]           # 00427c72
    push edx                                     # 00427c79
    call FUN_0042b2e4                            # 00427c7a
    add esp, 0x4                                 # 00427c7f
L_00427c82:
    # block 0x00427c82: entered by je at 0x00427c70, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427c82
L_00427c87:
    # block 0x00427c87: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427cbc (forward)
    push 0x1                                     # 00427c87
    movsx eax, word ptr [ebp - local_11c]        # 00427c89
    imul eax, eax, 0x8d                          # 00427c90
    add eax, 0x5bb5e9                            # 00427c96
    push eax                                     # 00427c9b
    mov ecx, 0x63786d                            # 00427c9c
    call FUN_00423f57                            # 00427ca1
    test eax, eax                                # 00427ca6
    je.d8 L_00427cbc                             # 00427ca8
    # block 0x00427caa: entered by fall-through of je at 0x00427ca8, 4 instruction(s), calls FUN_00414947, falls into the block at 0x00427cbc
    mov cx, word ptr [ebp - local_11c]           # 00427caa
    push ecx                                     # 00427cb1
    mov ecx, 0x6385db                            # 00427cb2
    call FUN_00414947                            # 00427cb7
L_00427cbc:
    # block 0x00427cbc: entered by je at 0x00427ca8, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427cbc
L_00427cc1:
    # block 0x00427cc1: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427cf7 (forward)
    push 0x1                                     # 00427cc1
    movsx edx, word ptr [ebp - local_11c]        # 00427cc3
    imul edx, edx, 0x8d                          # 00427cca
    add edx, 0x5bb5e9                            # 00427cd0
    push edx                                     # 00427cd6
    mov ecx, 0x63786d                            # 00427cd7
    call FUN_00423f57                            # 00427cdc
    test eax, eax                                # 00427ce1
    je.d8 L_00427cf7                             # 00427ce3
    # block 0x00427ce5: entered by fall-through of je at 0x00427ce3, 4 instruction(s), calls FUN_004cb586, falls into the block at 0x00427cf7
    mov ax, word ptr [ebp - local_11c]           # 00427ce5
    push eax                                     # 00427cec
    mov ecx, 0x63847b                            # 00427ced
    call FUN_004cb586                            # 00427cf2
L_00427cf7:
    # block 0x00427cf7: entered by je at 0x00427ce3, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427cf7
L_00427cfc:
    # block 0x00427cfc: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427e0c (forward)
    push 0x0                                     # 00427cfc
    movsx ecx, word ptr [ebp - local_11c]        # 00427cfe
    imul ecx, ecx, 0x8d                          # 00427d05
    add ecx, 0x5bb5e9                            # 00427d0b
    push ecx                                     # 00427d11
    mov ecx, 0x63786d                            # 00427d12
    call FUN_00423f57                            # 00427d17
    test eax, eax                                # 00427d1c
    je.d32 L_00427e0c                            # 00427d1e
    # block 0x00427d24: entered by fall-through of je at 0x00427d1e, 39 instruction(s), falls into the block at 0x00427e0c
    movsx edx, word ptr [ebp - local_11c]        # 00427d24
    imul edx, edx, 0x8d                          # 00427d2b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427d31
    movsx ecx, word ptr [eax]                    # 00427d37
    mov dword ptr [0x5bb57b], ecx                # 00427d3a
    movsx edx, word ptr [ebp - local_11c]        # 00427d40
    imul edx, edx, 0x8d                          # 00427d47
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427d4d
    mov cx, word ptr [eax + field_2]             # 00427d53
    mov word ptr [0x5bb599], cx                  # 00427d57
    movsx edx, word ptr [ebp - local_11c]        # 00427d5e
    imul edx, edx, 0x8d                          # 00427d65
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427d6b
    mov cx, word ptr [eax + field_4]             # 00427d71
    mov word ptr [0x5bb595], cx                  # 00427d75
    movsx edx, word ptr [ebp - local_11c]        # 00427d7c
    imul edx, edx, 0x8d                          # 00427d83
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427d89
    mov cx, word ptr [eax + field_6]             # 00427d8f
    mov word ptr [0x5c39ff], cx                  # 00427d93
    movsx edx, word ptr [ebp - local_11c]        # 00427d9a
    imul edx, edx, 0x8d                          # 00427da1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427da7
    mov ecx, dword ptr [eax + field_8]           # 00427dad
    mov dword ptr [0x5bb59b], ecx                # 00427db0
    movsx edx, word ptr [ebp - local_11c]        # 00427db6
    imul edx, edx, 0x8d                          # 00427dbd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427dc3
    mov ecx, dword ptr [eax + field_c]           # 00427dc9
    mov dword ptr [0x5bb59f], ecx                # 00427dcc
    movsx edx, word ptr [ebp - local_11c]        # 00427dd2
    imul edx, edx, 0x8d                          # 00427dd9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00427ddf
    mov ecx, dword ptr [eax + field_10]          # 00427de5
    mov dword ptr [0x5bb5a3], ecx                # 00427de8
    mov dword ptr [0x583999], 0x4                # 00427dee
    movsx edx, word ptr [ebp - local_11c]        # 00427df8
    imul edx, edx, 0x8d                          # 00427dff
    mov byte ptr [edx + 0x5bb625], 0x1           # 00427e05
L_00427e0c:
    # block 0x00427e0c: entered by je at 0x00427d1e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427e0c
L_00427e11:
    # block 0x00427e11: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427e44 (forward)
    push 0x1                                     # 00427e11
    movsx eax, word ptr [ebp - local_11c]        # 00427e13
    imul eax, eax, 0x8d                          # 00427e1a
    add eax, 0x5bb5e9                            # 00427e20
    push eax                                     # 00427e25
    mov ecx, 0x63786d                            # 00427e26
    call FUN_00423f57                            # 00427e2b
    test eax, eax                                # 00427e30
    je.d8 L_00427e44                             # 00427e32
    # block 0x00427e34: entered by fall-through of je at 0x00427e32, 4 instruction(s), calls FUN_0042b510, falls into the block at 0x00427e44
    mov cx, word ptr [ebp - local_11c]           # 00427e34
    push ecx                                     # 00427e3b
    call FUN_0042b510                            # 00427e3c
    add esp, 0x4                                 # 00427e41
L_00427e44:
    # block 0x00427e44: entered by je at 0x00427e32, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427e44
L_00427e49:
    # block 0x00427e49: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427e91 (forward)
    push 0x0                                     # 00427e49
    movsx edx, word ptr [ebp - local_11c]        # 00427e4b
    imul edx, edx, 0x8d                          # 00427e52
    add edx, 0x5bb5e9                            # 00427e58
    push edx                                     # 00427e5e
    mov ecx, 0x63786d                            # 00427e5f
    call FUN_00423f57                            # 00427e64
    test eax, eax                                # 00427e69
    je.d8 L_00427e91                             # 00427e6b
    # block 0x00427e6d: entered by fall-through of je at 0x00427e6b, 6 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00427e91
    mov dword ptr [0x5a4c1c], 0x0                # 00427e6d
    mov dword ptr [0x586825], 0x1                # 00427e77
    mov ax, word ptr [ebp - local_11c]           # 00427e81
    push eax                                     # 00427e88
    call FUN_0042ba3a                            # 00427e89
    add esp, 0x4                                 # 00427e8e
L_00427e91:
    # block 0x00427e91: entered by je at 0x00427e6b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427e91
L_00427e96:
    # block 0x00427e96: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427ee8 (forward)
    push 0x0                                     # 00427e96
    movsx ecx, word ptr [ebp - local_11c]        # 00427e98
    imul ecx, ecx, 0x8d                          # 00427e9f
    add ecx, 0x5bb5e9                            # 00427ea5
    push ecx                                     # 00427eab
    mov ecx, 0x63786d                            # 00427eac
    call FUN_00423f57                            # 00427eb1
    test eax, eax                                # 00427eb6
    je.d8 L_00427ee8                             # 00427eb8
    # block 0x00427eba: entered by fall-through of je at 0x00427eb8, 7 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00427ee8
    mov dword ptr [0x5bb1ca], 0x1                # 00427eba
    mov dword ptr [0x5a4c1c], 0x1                # 00427ec4
    mov dword ptr [0x586825], 0x0                # 00427ece
    mov dx, word ptr [ebp - local_11c]           # 00427ed8
    push edx                                     # 00427edf
    call FUN_0042ba3a                            # 00427ee0
    add esp, 0x4                                 # 00427ee5
L_00427ee8:
    # block 0x00427ee8: entered by je at 0x00427eb8, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427ee8
L_00427eed:
    # block 0x00427eed: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427f22 (forward)
    push 0x0                                     # 00427eed
    movsx eax, word ptr [ebp - local_11c]        # 00427eef
    imul eax, eax, 0x8d                          # 00427ef6
    add eax, 0x5bb5e9                            # 00427efc
    push eax                                     # 00427f01
    mov ecx, 0x63786d                            # 00427f02
    call FUN_00423f57                            # 00427f07
    test eax, eax                                # 00427f0c
    je.d8 L_00427f22                             # 00427f0e
    # block 0x00427f10: entered by fall-through of je at 0x00427f0e, 4 instruction(s), calls FUN_0044727a, falls into the block at 0x00427f22
    mov cx, word ptr [ebp - local_11c]           # 00427f10
    push ecx                                     # 00427f17
    mov ecx, 0x6198d7                            # 00427f18
    call FUN_0044727a                            # 00427f1d
L_00427f22:
    # block 0x00427f22: entered by je at 0x00427f0e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427f22
L_00427f27:
    # block 0x00427f27: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427f5d (forward)
    push 0x0                                     # 00427f27
    movsx edx, word ptr [ebp - local_11c]        # 00427f29
    imul edx, edx, 0x8d                          # 00427f30
    add edx, 0x5bb5e9                            # 00427f36
    push edx                                     # 00427f3c
    mov ecx, 0x63786d                            # 00427f3d
    call FUN_00423f57                            # 00427f42
    test eax, eax                                # 00427f47
    je.d8 L_00427f5d                             # 00427f49
    # block 0x00427f4b: entered by fall-through of je at 0x00427f49, 4 instruction(s), calls FUN_004cd6ff, falls into the block at 0x00427f5d
    mov ax, word ptr [ebp - local_11c]           # 00427f4b
    push eax                                     # 00427f52
    mov ecx, 0x63821d                            # 00427f53
    call FUN_004cd6ff                            # 00427f58
L_00427f5d:
    # block 0x00427f5d: entered by je at 0x00427f49, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427f5d
L_00427f62:
    # block 0x00427f62: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427f98 (forward)
    push 0x0                                     # 00427f62
    movsx ecx, word ptr [ebp - local_11c]        # 00427f64
    imul ecx, ecx, 0x8d                          # 00427f6b
    add ecx, 0x5bb5e9                            # 00427f71
    push ecx                                     # 00427f77
    mov ecx, 0x63786d                            # 00427f78
    call FUN_00423f57                            # 00427f7d
    test eax, eax                                # 00427f82
    je.d8 L_00427f98                             # 00427f84
    # block 0x00427f86: entered by fall-through of je at 0x00427f84, 4 instruction(s), calls FUN_004ced84, falls into the block at 0x00427f98
    mov dx, word ptr [ebp - local_11c]           # 00427f86
    push edx                                     # 00427f8d
    mov ecx, 0x63821d                            # 00427f8e
    call FUN_004ced84                            # 00427f93
L_00427f98:
    # block 0x00427f98: entered by je at 0x00427f84, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427f98
L_00427f9d:
    # block 0x00427f9d: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00427fd2 (forward)
    push 0x0                                     # 00427f9d
    movsx eax, word ptr [ebp - local_11c]        # 00427f9f
    imul eax, eax, 0x8d                          # 00427fa6
    add eax, 0x5bb5e9                            # 00427fac
    push eax                                     # 00427fb1
    mov ecx, 0x63786d                            # 00427fb2
    call FUN_00423f57                            # 00427fb7
    test eax, eax                                # 00427fbc
    je.d8 L_00427fd2                             # 00427fbe
    # block 0x00427fc0: entered by fall-through of je at 0x00427fbe, 4 instruction(s), calls FUN_00420c17, falls into the block at 0x00427fd2
    mov cx, word ptr [ebp - local_11c]           # 00427fc0
    push ecx                                     # 00427fc7
    mov ecx, 0x6177e8                            # 00427fc8
    call FUN_00420c17                            # 00427fcd
L_00427fd2:
    # block 0x00427fd2: entered by je at 0x00427fbe, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00427fd2
L_00427fd7:
    # block 0x00427fd7: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042800b (forward)
    push 0x1                                     # 00427fd7
    movsx edx, word ptr [ebp - local_11c]        # 00427fd9
    imul edx, edx, 0x8d                          # 00427fe0
    add edx, 0x5bb5e9                            # 00427fe6
    push edx                                     # 00427fec
    mov ecx, 0x63786d                            # 00427fed
    call FUN_00423f57                            # 00427ff2
    test eax, eax                                # 00427ff7
    je.d8 L_0042800b                             # 00427ff9
    # block 0x00427ffb: entered by fall-through of je at 0x00427ff9, 4 instruction(s), calls FUN_0042c221, falls into the block at 0x0042800b
    mov ax, word ptr [ebp - local_11c]           # 00427ffb
    push eax                                     # 00428002
    call FUN_0042c221                            # 00428003
    add esp, 0x4                                 # 00428008
L_0042800b:
    # block 0x0042800b: entered by je at 0x00427ff9, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042800b
L_00428010:
    # block 0x00428010: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428044 (forward)
    push 0x1                                     # 00428010
    movsx ecx, word ptr [ebp - local_11c]        # 00428012
    imul ecx, ecx, 0x8d                          # 00428019
    add ecx, 0x5bb5e9                            # 0042801f
    push ecx                                     # 00428025
    mov ecx, 0x63786d                            # 00428026
    call FUN_00423f57                            # 0042802b
    test eax, eax                                # 00428030
    je.d8 L_00428044                             # 00428032
    # block 0x00428034: entered by fall-through of je at 0x00428032, 4 instruction(s), calls FUN_0042d35a, falls into the block at 0x00428044
    mov dx, word ptr [ebp - local_11c]           # 00428034
    push edx                                     # 0042803b
    call FUN_0042d35a                            # 0042803c
    add esp, 0x4                                 # 00428041
L_00428044:
    # block 0x00428044: entered by je at 0x00428032, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428044
L_00428049:
    # block 0x00428049: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042807e (forward)
    push 0x0                                     # 00428049
    movsx eax, word ptr [ebp - local_11c]        # 0042804b
    imul eax, eax, 0x8d                          # 00428052
    add eax, 0x5bb5e9                            # 00428058
    push eax                                     # 0042805d
    mov ecx, 0x63786d                            # 0042805e
    call FUN_00423f57                            # 00428063
    test eax, eax                                # 00428068
    je.d8 L_0042807e                             # 0042806a
    # block 0x0042806c: entered by fall-through of je at 0x0042806a, 4 instruction(s), calls FUN_004bf9bb, falls into the block at 0x0042807e
    mov cx, word ptr [ebp - local_11c]           # 0042806c
    push ecx                                     # 00428073
    mov ecx, 0x637fcf                            # 00428074
    call FUN_004bf9bb                            # 00428079
L_0042807e:
    # block 0x0042807e: entered by je at 0x0042806a, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042807e
L_00428083:
    # block 0x00428083: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004280b9 (forward)
    push 0x1                                     # 00428083
    movsx edx, word ptr [ebp - local_11c]        # 00428085
    imul edx, edx, 0x8d                          # 0042808c
    add edx, 0x5bb5e9                            # 00428092
    push edx                                     # 00428098
    mov ecx, 0x63786d                            # 00428099
    call FUN_00423f57                            # 0042809e
    test eax, eax                                # 004280a3
    je.d8 L_004280b9                             # 004280a5
    # block 0x004280a7: entered by fall-through of je at 0x004280a5, 4 instruction(s), calls FUN_004899ca, falls into the block at 0x004280b9
    mov ax, word ptr [ebp - local_11c]           # 004280a7
    push eax                                     # 004280ae
    mov ecx, 0x619935                            # 004280af
    call FUN_004899ca                            # 004280b4
L_004280b9:
    # block 0x004280b9: entered by je at 0x004280a5, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004280b9
L_004280be:
    # block 0x004280be: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004280f4 (forward)
    push 0x1                                     # 004280be
    movsx ecx, word ptr [ebp - local_11c]        # 004280c0
    imul ecx, ecx, 0x8d                          # 004280c7
    add ecx, 0x5bb5e9                            # 004280cd
    push ecx                                     # 004280d3
    mov ecx, 0x63786d                            # 004280d4
    call FUN_00423f57                            # 004280d9
    test eax, eax                                # 004280de
    je.d8 L_004280f4                             # 004280e0
    # block 0x004280e2: entered by fall-through of je at 0x004280e0, 4 instruction(s), calls FUN_0044b26a, falls into the block at 0x004280f4
    mov dx, word ptr [ebp - local_11c]           # 004280e2
    push edx                                     # 004280e9
    mov ecx, 0x637fb1                            # 004280ea
    call FUN_0044b26a                            # 004280ef
L_004280f4:
    # block 0x004280f4: entered by je at 0x004280e0, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004280f4
L_004280f9:
    # block 0x004280f9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042812e (forward)
    push 0x1                                     # 004280f9
    movsx eax, word ptr [ebp - local_11c]        # 004280fb
    imul eax, eax, 0x8d                          # 00428102
    add eax, 0x5bb5e9                            # 00428108
    push eax                                     # 0042810d
    mov ecx, 0x63786d                            # 0042810e
    call FUN_00423f57                            # 00428113
    test eax, eax                                # 00428118
    je.d8 L_0042812e                             # 0042811a
    # block 0x0042811c: entered by fall-through of je at 0x0042811a, 4 instruction(s), calls FUN_0044b3c8, falls into the block at 0x0042812e
    mov cx, word ptr [ebp - local_11c]           # 0042811c
    push ecx                                     # 00428123
    mov ecx, 0x637fb1                            # 00428124
    call FUN_0044b3c8                            # 00428129
L_0042812e:
    # block 0x0042812e: entered by je at 0x0042811a, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042812e
L_00428133:
    # block 0x00428133: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428169 (forward)
    push 0x1                                     # 00428133
    movsx edx, word ptr [ebp - local_11c]        # 00428135
    imul edx, edx, 0x8d                          # 0042813c
    add edx, 0x5bb5e9                            # 00428142
    push edx                                     # 00428148
    mov ecx, 0x63786d                            # 00428149
    call FUN_00423f57                            # 0042814e
    test eax, eax                                # 00428153
    je.d8 L_00428169                             # 00428155
    # block 0x00428157: entered by fall-through of je at 0x00428155, 4 instruction(s), calls FUN_0044b641, falls into the block at 0x00428169
    mov ax, word ptr [ebp - local_11c]           # 00428157
    push eax                                     # 0042815e
    mov ecx, 0x637fb1                            # 0042815f
    call FUN_0044b641                            # 00428164
L_00428169:
    # block 0x00428169: entered by je at 0x00428155, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428169
L_0042816e:
    # block 0x0042816e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004281ce (forward)
    push 0x0                                     # 0042816e
    movsx ecx, word ptr [ebp - local_11c]        # 00428170
    imul ecx, ecx, 0x8d                          # 00428177
    add ecx, 0x5bb5e9                            # 0042817d
    push ecx                                     # 00428183
    mov ecx, 0x63786d                            # 00428184
    call FUN_00423f57                            # 00428189
    test eax, eax                                # 0042818e
    je.d8 L_004281ce                             # 00428190
    # block 0x00428192: entered by fall-through of je at 0x00428190, 15 instruction(s), calls FUN_00448d11, FUN_0042ba3a, falls into the block at 0x004281ce
    push 0x0                                     # 00428192
    push -0x1                                    # 00428194
    movsx edx, word ptr [ebp - local_11c]        # 00428196
    imul edx, edx, 0x8d                          # 0042819d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004281a3
    add eax, 0x2                                 # 004281a9
    push eax                                     # 004281ac
    mov ecx, dword ptr [0x5d03b3]                # 004281ad
    push ecx                                     # 004281b3
    mov ecx, 0x619a05                            # 004281b4
    call FUN_00448d11                            # 004281b9
    mov dx, word ptr [ebp - local_11c]           # 004281be
    push edx                                     # 004281c5
    call FUN_0042ba3a                            # 004281c6
    add esp, 0x4                                 # 004281cb
L_004281ce:
    # block 0x004281ce: entered by je at 0x00428190, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004281ce
L_004281d3:
    # block 0x004281d3: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428427 (forward)
    push 0x0                                     # 004281d3
    movsx eax, word ptr [ebp - local_11c]        # 004281d5
    imul eax, eax, 0x8d                          # 004281dc
    add eax, 0x5bb5e9                            # 004281e2
    push eax                                     # 004281e7
    mov ecx, 0x63786d                            # 004281e8
    call FUN_00423f57                            # 004281ed
    test eax, eax                                # 004281f2
    je.d32 L_00428427                            # 004281f4
    # block 0x004281fa: entered by fall-through of je at 0x004281f4, 10 instruction(s), ends with je to 0x00428254 (forward)
    movsx ecx, word ptr [ebp - local_11c]        # 004281fa
    imul ecx, ecx, 0x8d                          # 00428201
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00428207
    mov dword ptr [ebp - local_138], edx         # 0042820d
    movsx eax, word ptr [ebp - local_11c]        # 00428213
    imul eax, eax, 0x8d                          # 0042821a
    mov ecx, dword ptr [eax + 0x5bb632]          # 00428220
    mov dword ptr [ebp - local_158], ecx         # 00428226
    cmp dword ptr [ebp - local_158], 0x0         # 0042822c
    je.d8 L_00428254                             # 00428233
    # block 0x00428235: entered by fall-through of je at 0x00428233, 2 instruction(s), ends with je to 0x00428355 (forward)
    cmp dword ptr [ebp - local_158], 0x1         # 00428235
    je.d32 L_00428355                            # 0042823c
    # block 0x00428242: entered by fall-through of je at 0x0042823c, 2 instruction(s), ends with je to 0x004283de (forward)
    cmp dword ptr [ebp - local_158], 0x2         # 00428242
    je.d32 L_004283de                            # 00428249
    # block 0x0042824f: entered by fall-through of je at 0x00428249, 1 instruction(s), ends with forward jump to 0x00428427
    jmp.d32 L_00428427                           # 0042824f
L_00428254:
    # block 0x00428254: entered by je at 0x00428233, 4 instruction(s), ends with jne to 0x004282ab (forward)
    mov edx, dword ptr [ebp - local_138]         # 00428254
    movsx eax, word ptr [edx]                    # 0042825a
    test eax, eax                                # 0042825d
    jne.d8 L_004282ab                            # 0042825f
    # block 0x00428261: entered by fall-through of jne at 0x0042825f, 13 instruction(s), calls FUN_00448d11, ends with jle to 0x004282a0 (forward)
    push 0x1                                     # 00428261
    push -0x1                                    # 00428263
    mov ecx, dword ptr [ebp - local_138]         # 00428265
    add ecx, 0xc                                 # 0042826b
    push ecx                                     # 0042826e
    mov edx, dword ptr [0x5d03b3]                # 0042826f
    push edx                                     # 00428275
    mov ecx, 0x619a05                            # 00428276
    call FUN_00448d11                            # 0042827b
    mov word ptr [ebp - local_134], ax           # 00428280
    movsx eax, word ptr [ebp - local_134]        # 00428287
    cmp eax, 0x2                                 # 0042828e
    jle.d8 L_004282a0                            # 00428291
    # block 0x00428293: entered by fall-through of jle at 0x00428291, 3 instruction(s), ends with forward jump to 0x004282ab
    mov ecx, dword ptr [ebp - local_138]         # 00428293
    mov word ptr [ecx], 0x1                      # 00428299
    jmp.d8 L_004282ab                            # 0042829e
L_004282a0:
    # block 0x004282a0: entered by jle at 0x00428291, 2 instruction(s), falls into the block at 0x004282ab
    mov edx, dword ptr [ebp - local_138]         # 004282a0
    mov word ptr [edx], 0x2                      # 004282a6
L_004282ab:
    # block 0x004282ab: entered by jne at 0x0042825f; jmp at 0x0042829e, 5 instruction(s), ends with je to 0x004282ce (forward)
    mov eax, dword ptr [ebp - local_138]         # 004282ab
    movsx ecx, word ptr [eax]                    # 004282b1
    mov dword ptr [ebp - local_15c], ecx         # 004282b4
    cmp dword ptr [ebp - local_15c], 0x1         # 004282ba
    je.d8 L_004282ce                             # 004282c1
    # block 0x004282c3: entered by fall-through of je at 0x004282c1, 2 instruction(s), ends with je to 0x004282f0 (forward)
    cmp dword ptr [ebp - local_15c], 0x2         # 004282c3
    je.d8 L_004282f0                             # 004282ca
    # block 0x004282cc: entered by fall-through of je at 0x004282ca, 1 instruction(s), ends with forward jump to 0x0042830f
    jmp.d8 L_0042830f                            # 004282cc
L_004282ce:
    # block 0x004282ce: entered by je at 0x004282c1, 8 instruction(s), calls FUN_004de24f, ends with forward jump to 0x0042830f
    mov edx, dword ptr [ebp - local_138]         # 004282ce
    add edx, 0xc                                 # 004282d4
    push edx                                     # 004282d7
    push 0x2                                     # 004282d8
    mov ecx, 0x61f864                            # 004282da
    call FUN_004de24f                            # 004282df
    mov dword ptr [0x5b1606], 0x0                # 004282e4
    jmp.d8 L_0042830f                            # 004282ee
L_004282f0:
    # block 0x004282f0: entered by je at 0x004282ca, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x0042830f
    push 0x0                                     # 004282f0
    push -0x1                                    # 004282f2
    mov eax, dword ptr [ebp - local_138]         # 004282f4
    add eax, 0xc                                 # 004282fa
    push eax                                     # 004282fd
    mov ecx, dword ptr [0x5d03b3]                # 004282fe
    push ecx                                     # 00428304
    mov ecx, 0x619a05                            # 00428305
    call FUN_00448d11                            # 0042830a
L_0042830f:
    # block 0x0042830f: entered by jmp at 0x004282cc; jmp at 0x004282ee, 5 instruction(s), ends with je to 0x0042832a (forward)
    mov edx, dword ptr [ebp - local_138]         # 0042830f
    movsx eax, word ptr [edx + field_2]          # 00428315
    mov dword ptr [ebp - local_160], eax         # 00428319
    cmp dword ptr [ebp - local_160], 0x2         # 0042831f
    je.d8 L_0042832a                             # 00428326
    # block 0x00428328: entered by fall-through of je at 0x00428326, 1 instruction(s), ends with forward jump to 0x0042833e
    jmp.d8 L_0042833e                            # 00428328
L_0042832a:
    # block 0x0042832a: entered by je at 0x00428326, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0042833e
    call dword ptr [0x52a23c]                    # 0042832a
    mov ecx, dword ptr [ebp - local_138]         # 00428330
    add eax, dword ptr [ecx + field_6]           # 00428336
    mov dword ptr [0x5bb226], eax                # 00428339
L_0042833e:
    # block 0x0042833e: entered by jmp at 0x00428328, 3 instruction(s), falls into the block at 0x00428355
    movsx edx, word ptr [ebp - local_11c]        # 0042833e
    imul edx, edx, 0x8d                          # 00428345
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042834b
L_00428355:
    # block 0x00428355: entered by je at 0x0042823c, 5 instruction(s), ends with je to 0x00428379 (forward)
    mov eax, dword ptr [ebp - local_138]         # 00428355
    movsx ecx, word ptr [eax + field_2]          # 0042835b
    mov dword ptr [ebp - local_164], ecx         # 0042835f
    cmp dword ptr [ebp - local_164], 0x1         # 00428365
    je.d8 L_00428379                             # 0042836c
    # block 0x0042836e: entered by fall-through of je at 0x0042836c, 2 instruction(s), ends with je to 0x004283b7 (forward)
    cmp dword ptr [ebp - local_164], 0x2         # 0042836e
    je.d8 L_004283b7                             # 00428375
    # block 0x00428377: entered by fall-through of je at 0x00428375, 1 instruction(s), ends with forward jump to 0x004283dc
    jmp.d8 L_004283dc                            # 00428377
L_00428379:
    # block 0x00428379: entered by je at 0x0042836c, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004283b5 (forward)
    mov edx, dword ptr [ebp - local_138]         # 00428379
    movsx eax, word ptr [edx + field_4]          # 0042837f
    mov dword ptr [ebp - local_150], eax         # 00428383
    mov ecx, dword ptr [ebp - local_150]         # 00428389
    push ecx                                     # 0042838f
    mov ecx, 0x5cf1eb                            # 00428390
    call FUN_004f6334                            # 00428395
    test eax, eax                                # 0042839a
    jne.d8 L_004283b5                            # 0042839c
    # block 0x0042839e: entered by fall-through of jne at 0x0042839c, 3 instruction(s), falls into the block at 0x004283b5
    movsx edx, word ptr [ebp - local_11c]        # 0042839e
    imul edx, edx, 0x8d                          # 004283a5
    mov dword ptr [edx + 0x5bb632], 0x2          # 004283ab
L_004283b5:
    # block 0x004283b5: entered by jne at 0x0042839c, 1 instruction(s), ends with forward jump to 0x004283dc
    jmp.d8 L_004283dc                            # 004283b5
L_004283b7:
    # block 0x004283b7: entered by je at 0x00428375, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004283dc (forward)
    call dword ptr [0x52a23c]                    # 004283b7
    cmp eax, dword ptr [0x5bb226]                # 004283bd
    jbe.d8 L_004283dc                            # 004283c3
    # block 0x004283c5: entered by fall-through of jbe at 0x004283c3, 3 instruction(s), falls into the block at 0x004283dc
    movsx eax, word ptr [ebp - local_11c]        # 004283c5
    imul eax, eax, 0x8d                          # 004283cc
    mov dword ptr [eax + 0x5bb632], 0x2          # 004283d2
L_004283dc:
    # block 0x004283dc: entered by jmp at 0x00428377; jmp at 0x004283b5; jbe at 0x004283c3, 1 instruction(s), ends with forward jump to 0x00428427
    jmp.d8 L_00428427                            # 004283dc
L_004283de:
    # block 0x004283de: entered by je at 0x00428249, 5 instruction(s), ends with je to 0x00428401 (forward)
    mov ecx, dword ptr [ebp - local_138]         # 004283de
    movsx edx, word ptr [ecx]                    # 004283e4
    mov dword ptr [ebp - local_168], edx         # 004283e7
    cmp dword ptr [ebp - local_168], 0x1         # 004283ed
    je.d8 L_00428401                             # 004283f4
    # block 0x004283f6: entered by fall-through of je at 0x004283f4, 2 instruction(s), ends with je to 0x0042840d (forward)
    cmp dword ptr [ebp - local_168], 0x2         # 004283f6
    je.d8 L_0042840d                             # 004283fd
    # block 0x004283ff: entered by fall-through of je at 0x004283fd, 1 instruction(s), ends with forward jump to 0x00428417
    jmp.d8 L_00428417                            # 004283ff
L_00428401:
    # block 0x00428401: entered by je at 0x004283f4, 3 instruction(s), calls FUN_004de2d8, ends with forward jump to 0x00428417
    mov ecx, 0x61f864                            # 00428401
    call FUN_004de2d8                            # 00428406
    jmp.d8 L_00428417                            # 0042840b
L_0042840d:
    # block 0x0042840d: entered by je at 0x004283fd, 1 instruction(s), falls into the block at 0x00428417
    mov dword ptr [0x5b1602], 0x1                # 0042840d
L_00428417:
    # block 0x00428417: entered by jmp at 0x004283ff; jmp at 0x0042840b, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00428427
    mov ax, word ptr [ebp - local_11c]           # 00428417
    push eax                                     # 0042841e
    call FUN_0042ba3a                            # 0042841f
    add esp, 0x4                                 # 00428424
L_00428427:
    # block 0x00428427: entered by je at 0x004281f4; jmp at 0x0042824f; jmp at 0x004283dc, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428427
L_0042842c:
    # block 0x0042842c: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428460 (forward)
    push 0x0                                     # 0042842c
    movsx ecx, word ptr [ebp - local_11c]        # 0042842e
    imul ecx, ecx, 0x8d                          # 00428435
    add ecx, 0x5bb5e9                            # 0042843b
    push ecx                                     # 00428441
    mov ecx, 0x63786d                            # 00428442
    call FUN_00423f57                            # 00428447
    test eax, eax                                # 0042844c
    je.d8 L_00428460                             # 0042844e
    # block 0x00428450: entered by fall-through of je at 0x0042844e, 4 instruction(s), calls FUN_0042acad, falls into the block at 0x00428460
    mov dx, word ptr [ebp - local_11c]           # 00428450
    push edx                                     # 00428457
    call FUN_0042acad                            # 00428458
    add esp, 0x4                                 # 0042845d
L_00428460:
    # block 0x00428460: entered by je at 0x0042844e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428460
L_00428465:
    # block 0x00428465: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042849a (forward)
    push 0x0                                     # 00428465
    movsx eax, word ptr [ebp - local_11c]        # 00428467
    imul eax, eax, 0x8d                          # 0042846e
    add eax, 0x5bb5e9                            # 00428474
    push eax                                     # 00428479
    mov ecx, 0x63786d                            # 0042847a
    call FUN_00423f57                            # 0042847f
    test eax, eax                                # 00428484
    je.d8 L_0042849a                             # 00428486
    # block 0x00428488: entered by fall-through of je at 0x00428486, 4 instruction(s), calls FUN_00411f24, falls into the block at 0x0042849a
    mov cx, word ptr [ebp - local_11c]           # 00428488
    push ecx                                     # 0042848f
    mov ecx, 0x619a41                            # 00428490
    call FUN_00411f24                            # 00428495
L_0042849a:
    # block 0x0042849a: entered by je at 0x00428486, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042849a
L_0042849f:
    # block 0x0042849f: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004284d5 (forward)
    push 0x0                                     # 0042849f
    movsx edx, word ptr [ebp - local_11c]        # 004284a1
    imul edx, edx, 0x8d                          # 004284a8
    add edx, 0x5bb5e9                            # 004284ae
    push edx                                     # 004284b4
    mov ecx, 0x63786d                            # 004284b5
    call FUN_00423f57                            # 004284ba
    test eax, eax                                # 004284bf
    je.d8 L_004284d5                             # 004284c1
    # block 0x004284c3: entered by fall-through of je at 0x004284c1, 4 instruction(s), calls FUN_004121b8, falls into the block at 0x004284d5
    mov ax, word ptr [ebp - local_11c]           # 004284c3
    push eax                                     # 004284ca
    mov ecx, 0x619a41                            # 004284cb
    call FUN_004121b8                            # 004284d0
L_004284d5:
    # block 0x004284d5: entered by je at 0x004284c1, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004284d5
L_004284da:
    # block 0x004284da: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428510 (forward)
    push 0x0                                     # 004284da
    movsx ecx, word ptr [ebp - local_11c]        # 004284dc
    imul ecx, ecx, 0x8d                          # 004284e3
    add ecx, 0x5bb5e9                            # 004284e9
    push ecx                                     # 004284ef
    mov ecx, 0x63786d                            # 004284f0
    call FUN_00423f57                            # 004284f5
    test eax, eax                                # 004284fa
    je.d8 L_00428510                             # 004284fc
    # block 0x004284fe: entered by fall-through of je at 0x004284fc, 4 instruction(s), calls FUN_00412234, falls into the block at 0x00428510
    mov dx, word ptr [ebp - local_11c]           # 004284fe
    push edx                                     # 00428505
    mov ecx, 0x619a41                            # 00428506
    call FUN_00412234                            # 0042850b
L_00428510:
    # block 0x00428510: entered by je at 0x004284fc, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428510
L_00428515:
    # block 0x00428515: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042854a (forward)
    push 0x0                                     # 00428515
    movsx eax, word ptr [ebp - local_11c]        # 00428517
    imul eax, eax, 0x8d                          # 0042851e
    add eax, 0x5bb5e9                            # 00428524
    push eax                                     # 00428529
    mov ecx, 0x63786d                            # 0042852a
    call FUN_00423f57                            # 0042852f
    test eax, eax                                # 00428534
    je.d8 L_0042854a                             # 00428536
    # block 0x00428538: entered by fall-through of je at 0x00428536, 4 instruction(s), calls FUN_00412787, falls into the block at 0x0042854a
    mov cx, word ptr [ebp - local_11c]           # 00428538
    push ecx                                     # 0042853f
    mov ecx, 0x619a41                            # 00428540
    call FUN_00412787                            # 00428545
L_0042854a:
    # block 0x0042854a: entered by je at 0x00428536, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042854a
L_0042854f:
    # block 0x0042854f: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428585 (forward)
    push 0x0                                     # 0042854f
    movsx edx, word ptr [ebp - local_11c]        # 00428551
    imul edx, edx, 0x8d                          # 00428558
    add edx, 0x5bb5e9                            # 0042855e
    push edx                                     # 00428564
    mov ecx, 0x63786d                            # 00428565
    call FUN_00423f57                            # 0042856a
    test eax, eax                                # 0042856f
    je.d8 L_00428585                             # 00428571
    # block 0x00428573: entered by fall-through of je at 0x00428571, 4 instruction(s), calls FUN_004129da, falls into the block at 0x00428585
    mov ax, word ptr [ebp - local_11c]           # 00428573
    push eax                                     # 0042857a
    mov ecx, 0x619a41                            # 0042857b
    call FUN_004129da                            # 00428580
L_00428585:
    # block 0x00428585: entered by je at 0x00428571, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428585
L_0042858a:
    # block 0x0042858a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004285c0 (forward)
    push 0x0                                     # 0042858a
    movsx ecx, word ptr [ebp - local_11c]        # 0042858c
    imul ecx, ecx, 0x8d                          # 00428593
    add ecx, 0x5bb5e9                            # 00428599
    push ecx                                     # 0042859f
    mov ecx, 0x63786d                            # 004285a0
    call FUN_00423f57                            # 004285a5
    test eax, eax                                # 004285aa
    je.d8 L_004285c0                             # 004285ac
    # block 0x004285ae: entered by fall-through of je at 0x004285ac, 4 instruction(s), calls FUN_00412cb9, falls into the block at 0x004285c0
    mov dx, word ptr [ebp - local_11c]           # 004285ae
    push edx                                     # 004285b5
    mov ecx, 0x619a41                            # 004285b6
    call FUN_00412cb9                            # 004285bb
L_004285c0:
    # block 0x004285c0: entered by je at 0x004285ac, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004285c0
L_004285c5:
    # block 0x004285c5: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004285f8 (forward)
    push 0x0                                     # 004285c5
    movsx eax, word ptr [ebp - local_11c]        # 004285c7
    imul eax, eax, 0x8d                          # 004285ce
    add eax, 0x5bb5e9                            # 004285d4
    push eax                                     # 004285d9
    mov ecx, 0x63786d                            # 004285da
    call FUN_00423f57                            # 004285df
    test eax, eax                                # 004285e4
    je.d8 L_004285f8                             # 004285e6
    # block 0x004285e8: entered by fall-through of je at 0x004285e6, 4 instruction(s), calls FUN_0042b87a, falls into the block at 0x004285f8
    mov cx, word ptr [ebp - local_11c]           # 004285e8
    push ecx                                     # 004285ef
    call FUN_0042b87a                            # 004285f0
    add esp, 0x4                                 # 004285f5
L_004285f8:
    # block 0x004285f8: entered by je at 0x004285e6, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004285f8
L_004285fd:
    # block 0x004285fd: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428646 (forward)
    push 0x0                                     # 004285fd
    movsx edx, word ptr [ebp - local_11c]        # 004285ff
    imul edx, edx, 0x8d                          # 00428606
    add edx, 0x5bb5e9                            # 0042860c
    push edx                                     # 00428612
    mov ecx, 0x63786d                            # 00428613
    call FUN_00423f57                            # 00428618
    test eax, eax                                # 0042861d
    je.d8 L_00428646                             # 0042861f
    # block 0x00428621: entered by fall-through of je at 0x0042861f, 7 instruction(s), calls FUN_004d7a15, falls into the block at 0x00428646
    push 0x0                                     # 00428621
    push 0x545630                                # 00428623
    mov ecx, 0x5e2e70                            # 00428628
    call FUN_004d7a15                            # 0042862d
    movsx eax, word ptr [ebp - local_11c]        # 00428632
    imul eax, eax, 0x8d                          # 00428639
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042863f
L_00428646:
    # block 0x00428646: entered by je at 0x0042861f, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428646
L_0042864b:
    # block 0x0042864b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042868d (forward)
    push 0x0                                     # 0042864b
    movsx ecx, word ptr [ebp - local_11c]        # 0042864d
    imul ecx, ecx, 0x8d                          # 00428654
    add ecx, 0x5bb5e9                            # 0042865a
    push ecx                                     # 00428660
    mov ecx, 0x63786d                            # 00428661
    call FUN_00423f57                            # 00428666
    test eax, eax                                # 0042866b
    je.d8 L_0042868d                             # 0042866d
    # block 0x0042866f: entered by fall-through of je at 0x0042866d, 4 instruction(s), falls into the block at 0x0042868d
    mov dword ptr [0x5bb1ca], 0x0                # 0042866f
    movsx edx, word ptr [ebp - local_11c]        # 00428679
    imul edx, edx, 0x8d                          # 00428680
    mov byte ptr [edx + 0x5bb625], 0x1           # 00428686
L_0042868d:
    # block 0x0042868d: entered by je at 0x0042866d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042868d
L_00428692:
    # block 0x00428692: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004286d3 (forward)
    push 0x0                                     # 00428692
    movsx eax, word ptr [ebp - local_11c]        # 00428694
    imul eax, eax, 0x8d                          # 0042869b
    add eax, 0x5bb5e9                            # 004286a1
    push eax                                     # 004286a6
    mov ecx, 0x63786d                            # 004286a7
    call FUN_00423f57                            # 004286ac
    test eax, eax                                # 004286b1
    je.d8 L_004286d3                             # 004286b3
    # block 0x004286b5: entered by fall-through of je at 0x004286b3, 4 instruction(s), falls into the block at 0x004286d3
    mov dword ptr [0x5bb1ca], 0x1                # 004286b5
    movsx ecx, word ptr [ebp - local_11c]        # 004286bf
    imul ecx, ecx, 0x8d                          # 004286c6
    mov byte ptr [ecx + 0x5bb625], 0x1           # 004286cc
L_004286d3:
    # block 0x004286d3: entered by je at 0x004286b3, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004286d3
L_004286d8:
    # block 0x004286d8: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428758 (forward)
    push 0x0                                     # 004286d8
    movsx edx, word ptr [ebp - local_11c]        # 004286da
    imul edx, edx, 0x8d                          # 004286e1
    add edx, 0x5bb5e9                            # 004286e7
    push edx                                     # 004286ed
    mov ecx, 0x63786d                            # 004286ee
    call FUN_00423f57                            # 004286f3
    test eax, eax                                # 004286f8
    je.d8 L_00428758                             # 004286fa
    # block 0x004286fc: entered by fall-through of je at 0x004286fa, 20 instruction(s), calls FUN_00433bd2, falls into the block at 0x00428758
    movsx eax, word ptr [ebp - local_11c]        # 004286fc
    imul eax, eax, 0x8d                          # 00428703
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00428709
    mov dword ptr [ebp - local_10], ecx          # 0042870f
    mov edx, dword ptr [ebp - local_10]          # 00428712
    {load} xor eax, eax                          # 00428715
    mov al, byte ptr [edx]                       # 00428717
    imul eax, eax, 0x106                         # 00428719
    add eax, 0x585d65                            # 0042871f
    push eax                                     # 00428724
    call FUN_00433bd2                            # 00428725
    add esp, 0x4                                 # 0042872a
    mov ecx, dword ptr [ebp - local_10]          # 0042872d
    {load} xor edx, edx                          # 00428730
    mov dl, byte ptr [ecx]                       # 00428732
    imul edx, edx, 0x106                         # 00428734
    mov dword ptr [edx + 0x585d65], 0x1          # 0042873a
    movsx eax, word ptr [ebp - local_11c]        # 00428744
    imul eax, eax, 0x8d                          # 0042874b
    mov byte ptr [eax + 0x5bb625], 0x1           # 00428751
L_00428758:
    # block 0x00428758: entered by je at 0x004286fa, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428758
L_0042875d:
    # block 0x0042875d: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004287c7 (forward)
    push 0x0                                     # 0042875d
    movsx ecx, word ptr [ebp - local_11c]        # 0042875f
    imul ecx, ecx, 0x8d                          # 00428766
    add ecx, 0x5bb5e9                            # 0042876c
    push ecx                                     # 00428772
    mov ecx, 0x63786d                            # 00428773
    call FUN_00423f57                            # 00428778
    test eax, eax                                # 0042877d
    je.d8 L_004287c7                             # 0042877f
    # block 0x00428781: entered by fall-through of je at 0x0042877f, 15 instruction(s), calls FUN_00433bd2, falls into the block at 0x004287c7
    movsx edx, word ptr [ebp - local_11c]        # 00428781
    imul edx, edx, 0x8d                          # 00428788
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042878e
    mov dword ptr [ebp - local_10], eax          # 00428794
    mov ecx, dword ptr [ebp - local_10]          # 00428797
    {load} xor edx, edx                          # 0042879a
    mov dl, byte ptr [ecx]                       # 0042879c
    imul edx, edx, 0x106                         # 0042879e
    add edx, 0x585d65                            # 004287a4
    push edx                                     # 004287aa
    call FUN_00433bd2                            # 004287ab
    add esp, 0x4                                 # 004287b0
    movsx eax, word ptr [ebp - local_11c]        # 004287b3
    imul eax, eax, 0x8d                          # 004287ba
    mov byte ptr [eax + 0x5bb625], 0x1           # 004287c0
L_004287c7:
    # block 0x004287c7: entered by je at 0x0042877f, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004287c7
L_004287cc:
    # block 0x004287cc: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428cce (forward)
    push 0x0                                     # 004287cc
    movsx ecx, word ptr [ebp - local_11c]        # 004287ce
    imul ecx, ecx, 0x8d                          # 004287d5
    add ecx, 0x5bb5e9                            # 004287db
    push ecx                                     # 004287e1
    mov ecx, 0x63786d                            # 004287e2
    call FUN_00423f57                            # 004287e7
    test eax, eax                                # 004287ec
    je.d32 L_00428cce                            # 004287ee
    # block 0x004287f4: entered by fall-through of je at 0x004287ee, 14 instruction(s), ends with ja to 0x00428cce (forward)
    movsx edx, word ptr [ebp - local_11c]        # 004287f4
    imul edx, edx, 0x8d                          # 004287fb
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00428801
    mov dword ptr [ebp - local_4], eax           # 00428807
    mov ecx, dword ptr [ebp - local_4]           # 0042880a
    movsx edx, word ptr [ecx]                    # 0042880d
    imul edx, edx, 0x106                         # 00428810
    add edx, 0x585d65                            # 00428816
    mov dword ptr [ebp - local_140], edx         # 0042881c
    mov eax, dword ptr [ebp - local_4]           # 00428822
    movsx ecx, word ptr [eax + field_2]          # 00428825
    mov dword ptr [ebp - local_16c], ecx         # 00428829
    cmp dword ptr [ebp - local_16c], 0x6         # 0042882f
    ja.d32 L_00428cce                            # 00428836
    # block 0x0042883c: entered by fall-through of ja at 0x00428836, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x42ac91]
    mov edx, dword ptr [ebp - local_16c]         # 0042883c
    jmp dword ptr [4*edx + SWTAB_0042ac91_VA]    # 00428842
L_00428849:
    # block 0x00428849: entered by switch case, 8 instruction(s), calls FUN_00433bd2, ends with forward jump to 0x00428cce
    mov eax, dword ptr [ebp - local_140]         # 00428849
    push eax                                     # 0042884f
    call FUN_00433bd2                            # 00428850
    add esp, 0x4                                 # 00428855
    movsx ecx, word ptr [ebp - local_11c]        # 00428858
    imul ecx, ecx, 0x8d                          # 0042885f
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00428865
    jmp.d32 L_00428cce                           # 0042886c
L_00428871:
    # block 0x00428871: entered by switch case, 6 instruction(s), ends with forward jump to 0x00428cce
    mov edx, dword ptr [ebp - local_140]         # 00428871
    mov dword ptr [edx], 0x1                     # 00428877
    movsx eax, word ptr [ebp - local_11c]        # 0042887d
    imul eax, eax, 0x8d                          # 00428884
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042888a
    jmp.d32 L_00428cce                           # 00428891
L_00428896:
    # block 0x00428896: entered by switch case, 6 instruction(s), ends with forward jump to 0x00428cce
    mov ecx, dword ptr [ebp - local_140]         # 00428896
    mov dword ptr [ecx], 0x2                     # 0042889c
    movsx edx, word ptr [ebp - local_11c]        # 004288a2
    imul edx, edx, 0x8d                          # 004288a9
    mov byte ptr [edx + 0x5bb625], 0x1           # 004288af
    jmp.d32 L_00428cce                           # 004288b6
L_004288bb:
    # block 0x004288bb: entered by switch case, 3 instruction(s), ends with je to 0x004288eb (forward)
    mov eax, dword ptr [ebp - local_140]         # 004288bb
    cmp dword ptr [eax], 0x1                     # 004288c1
    je.d8 L_004288eb                             # 004288c4
    # block 0x004288c6: entered by fall-through of je at 0x004288c4, 3 instruction(s), ends with je to 0x004288eb (forward)
    mov ecx, dword ptr [ebp - local_140]         # 004288c6
    cmp dword ptr [ecx], 0x2                     # 004288cc
    je.d8 L_004288eb                             # 004288cf
    # block 0x004288d1: entered by fall-through of je at 0x004288cf, 3 instruction(s), ends with je to 0x004288eb (forward)
    mov edx, dword ptr [ebp - local_140]         # 004288d1
    cmp dword ptr [edx], 0x5                     # 004288d7
    je.d8 L_004288eb                             # 004288da
    # block 0x004288dc: entered by fall-through of je at 0x004288da, 3 instruction(s), ends with jne to 0x004289bd (forward)
    mov eax, dword ptr [ebp - local_140]         # 004288dc
    cmp dword ptr [eax], 0x6                     # 004288e2
    jne.d32 L_004289bd                           # 004288e5
L_004288eb:
    # block 0x004288eb: entered by je at 0x004288c4; je at 0x004288cf; je at 0x004288da; fall-through of jne at 0x004288e5, 18 instruction(s), ends with jl to 0x00428954 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004288eb
    movsx edx, word ptr [ecx + field_4]          # 004288ee
    mov eax, dword ptr [ebp - local_140]         # 004288f2
    mov ecx, dword ptr [eax + field_10]          # 004288f8
    {load} add ecx, edx                          # 004288fb
    mov edx, dword ptr [ebp - local_140]         # 004288fd
    mov dword ptr [edx + field_10], ecx          # 00428903
    mov eax, dword ptr [ebp - local_4]           # 00428906
    movsx ecx, word ptr [eax + field_6]          # 00428909
    mov edx, dword ptr [ebp - local_140]         # 0042890d
    mov eax, dword ptr [edx + field_c]           # 00428913
    {load} add eax, ecx                          # 00428916
    mov ecx, dword ptr [ebp - local_140]         # 00428918
    mov dword ptr [ecx + field_c], eax           # 0042891e
    mov edx, dword ptr [ebp - local_4]           # 00428921
    movsx eax, word ptr [edx + field_8]          # 00428924
    cmp eax, 0x1388                              # 00428928
    jl.d8 L_00428954                             # 0042892d
    # block 0x0042892f: entered by fall-through of jl at 0x0042892d, 9 instruction(s), ends with forward jump to 0x0042896f
    mov ecx, dword ptr [ebp - local_4]           # 0042892f
    movsx edx, word ptr [ecx + field_8]          # 00428932
    movsx eax, word ptr [2*edx + 0x5adb81]       # 00428936
    mov ecx, dword ptr [ebp - local_140]         # 0042893e
    mov edx, dword ptr [ecx + field_8]           # 00428944
    {load} add edx, eax                          # 00428947
    mov eax, dword ptr [ebp - local_140]         # 00428949
    mov dword ptr [eax + field_8], edx           # 0042894f
    jmp.d8 L_0042896f                            # 00428952
L_00428954:
    # block 0x00428954: entered by jl at 0x0042892d, 7 instruction(s), falls into the block at 0x0042896f
    mov ecx, dword ptr [ebp - local_4]           # 00428954
    movsx edx, word ptr [ecx + field_8]          # 00428957
    mov eax, dword ptr [ebp - local_140]         # 0042895b
    mov ecx, dword ptr [eax + field_8]           # 00428961
    {load} add ecx, edx                          # 00428964
    mov edx, dword ptr [ebp - local_140]         # 00428966
    mov dword ptr [edx + field_8], ecx           # 0042896c
L_0042896f:
    # block 0x0042896f: entered by jmp at 0x00428952, 16 instruction(s), falls into the block at 0x004289bd
    mov eax, dword ptr [ebp - local_140]         # 0042896f
    mov ecx, dword ptr [eax + field_10]          # 00428975
    imul ecx, ecx, 0x36ee80                      # 00428978
    mov edx, dword ptr [ebp - local_140]         # 0042897e
    mov eax, dword ptr [edx + field_c]           # 00428984
    imul eax, eax, 0xea60                        # 00428987
    {load} add ecx, eax                          # 0042898d
    mov edx, dword ptr [ebp - local_140]         # 0042898f
    mov eax, dword ptr [edx + field_8]           # 00428995
    imul eax, eax, 0x3e8                         # 00428998
    {load} add ecx, eax                          # 0042899e
    mov edx, dword ptr [ebp - local_140]         # 004289a0
    mov dword ptr [edx + field_4], ecx           # 004289a6
    movsx eax, word ptr [ebp - local_11c]        # 004289a9
    imul eax, eax, 0x8d                          # 004289b0
    mov byte ptr [eax + 0x5bb625], 0x1           # 004289b6
L_004289bd:
    # block 0x004289bd: entered by jne at 0x004288e5, 1 instruction(s), ends with forward jump to 0x00428cce
    jmp.d32 L_00428cce                           # 004289bd
L_004289c2:
    # block 0x004289c2: entered by switch case, 3 instruction(s), ends with je to 0x004289f2 (forward)
    mov ecx, dword ptr [ebp - local_140]         # 004289c2
    cmp dword ptr [ecx], 0x1                     # 004289c8
    je.d8 L_004289f2                             # 004289cb
    # block 0x004289cd: entered by fall-through of je at 0x004289cb, 3 instruction(s), ends with je to 0x004289f2 (forward)
    mov edx, dword ptr [ebp - local_140]         # 004289cd
    cmp dword ptr [edx], 0x2                     # 004289d3
    je.d8 L_004289f2                             # 004289d6
    # block 0x004289d8: entered by fall-through of je at 0x004289d6, 3 instruction(s), ends with je to 0x004289f2 (forward)
    mov eax, dword ptr [ebp - local_140]         # 004289d8
    cmp dword ptr [eax], 0x5                     # 004289de
    je.d8 L_004289f2                             # 004289e1
    # block 0x004289e3: entered by fall-through of je at 0x004289e1, 3 instruction(s), ends with jne to 0x00428b10 (forward)
    mov ecx, dword ptr [ebp - local_140]         # 004289e3
    cmp dword ptr [ecx], 0x6                     # 004289e9
    jne.d32 L_00428b10                           # 004289ec
L_004289f2:
    # block 0x004289f2: entered by je at 0x004289cb; je at 0x004289d6; je at 0x004289e1; fall-through of jne at 0x004289ec, 18 instruction(s), ends with jl to 0x00428a5c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004289f2
    movsx eax, word ptr [edx + field_4]          # 004289f5
    mov ecx, dword ptr [ebp - local_140]         # 004289f9
    mov edx, dword ptr [ecx + field_10]          # 004289ff
    {load} sub edx, eax                          # 00428a02
    mov eax, dword ptr [ebp - local_140]         # 00428a04
    mov dword ptr [eax + field_10], edx          # 00428a0a
    mov ecx, dword ptr [ebp - local_4]           # 00428a0d
    movsx edx, word ptr [ecx + field_6]          # 00428a10
    mov eax, dword ptr [ebp - local_140]         # 00428a14
    mov ecx, dword ptr [eax + field_c]           # 00428a1a
    {load} sub ecx, edx                          # 00428a1d
    mov edx, dword ptr [ebp - local_140]         # 00428a1f
    mov dword ptr [edx + field_c], ecx           # 00428a25
    mov eax, dword ptr [ebp - local_4]           # 00428a28
    movsx ecx, word ptr [eax + field_8]          # 00428a2b
    cmp ecx, 0x1388                              # 00428a2f
    jl.d8 L_00428a5c                             # 00428a35
    # block 0x00428a37: entered by fall-through of jl at 0x00428a35, 9 instruction(s), ends with forward jump to 0x00428a77
    mov edx, dword ptr [ebp - local_4]           # 00428a37
    movsx eax, word ptr [edx + field_8]          # 00428a3a
    movsx ecx, word ptr [2*eax + 0x5adb81]       # 00428a3e
    mov edx, dword ptr [ebp - local_140]         # 00428a46
    mov eax, dword ptr [edx + field_8]           # 00428a4c
    {load} sub eax, ecx                          # 00428a4f
    mov ecx, dword ptr [ebp - local_140]         # 00428a51
    mov dword ptr [ecx + field_8], eax           # 00428a57
    jmp.d8 L_00428a77                            # 00428a5a
L_00428a5c:
    # block 0x00428a5c: entered by jl at 0x00428a35, 7 instruction(s), falls into the block at 0x00428a77
    mov edx, dword ptr [ebp - local_4]           # 00428a5c
    movsx eax, word ptr [edx + field_8]          # 00428a5f
    mov ecx, dword ptr [ebp - local_140]         # 00428a63
    mov edx, dword ptr [ecx + field_8]           # 00428a69
    {load} sub edx, eax                          # 00428a6c
    mov eax, dword ptr [ebp - local_140]         # 00428a6e
    mov dword ptr [eax + field_8], edx           # 00428a74
L_00428a77:
    # block 0x00428a77: entered by jmp at 0x00428a5a, 3 instruction(s), ends with jge to 0x00428a90 (forward)
    mov ecx, dword ptr [ebp - local_140]         # 00428a77
    cmp dword ptr [ecx + field_10], 0x0          # 00428a7d
    jge.d8 L_00428a90                            # 00428a81
    # block 0x00428a83: entered by fall-through of jge at 0x00428a81, 2 instruction(s), falls into the block at 0x00428a90
    mov edx, dword ptr [ebp - local_140]         # 00428a83
    mov dword ptr [edx + field_10], 0x0          # 00428a89
L_00428a90:
    # block 0x00428a90: entered by jge at 0x00428a81, 3 instruction(s), ends with jge to 0x00428aa9 (forward)
    mov eax, dword ptr [ebp - local_140]         # 00428a90
    cmp dword ptr [eax + field_c], 0x0           # 00428a96
    jge.d8 L_00428aa9                            # 00428a9a
    # block 0x00428a9c: entered by fall-through of jge at 0x00428a9a, 2 instruction(s), falls into the block at 0x00428aa9
    mov ecx, dword ptr [ebp - local_140]         # 00428a9c
    mov dword ptr [ecx + field_c], 0x0           # 00428aa2
L_00428aa9:
    # block 0x00428aa9: entered by jge at 0x00428a9a, 3 instruction(s), ends with jge to 0x00428ac2 (forward)
    mov edx, dword ptr [ebp - local_140]         # 00428aa9
    cmp dword ptr [edx + field_8], 0x0           # 00428aaf
    jge.d8 L_00428ac2                            # 00428ab3
    # block 0x00428ab5: entered by fall-through of jge at 0x00428ab3, 2 instruction(s), falls into the block at 0x00428ac2
    mov eax, dword ptr [ebp - local_140]         # 00428ab5
    mov dword ptr [eax + field_8], 0x0           # 00428abb
L_00428ac2:
    # block 0x00428ac2: entered by jge at 0x00428ab3, 16 instruction(s), falls into the block at 0x00428b10
    mov ecx, dword ptr [ebp - local_140]         # 00428ac2
    mov edx, dword ptr [ecx + field_10]          # 00428ac8
    imul edx, edx, 0x36ee80                      # 00428acb
    mov eax, dword ptr [ebp - local_140]         # 00428ad1
    mov ecx, dword ptr [eax + field_c]           # 00428ad7
    imul ecx, ecx, 0xea60                        # 00428ada
    {load} add edx, ecx                          # 00428ae0
    mov eax, dword ptr [ebp - local_140]         # 00428ae2
    mov ecx, dword ptr [eax + field_8]           # 00428ae8
    imul ecx, ecx, 0x3e8                         # 00428aeb
    {load} add edx, ecx                          # 00428af1
    mov eax, dword ptr [ebp - local_140]         # 00428af3
    mov dword ptr [eax + field_4], edx           # 00428af9
    movsx ecx, word ptr [ebp - local_11c]        # 00428afc
    imul ecx, ecx, 0x8d                          # 00428b03
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00428b09
L_00428b10:
    # block 0x00428b10: entered by jne at 0x004289ec, 1 instruction(s), ends with forward jump to 0x00428cce
    jmp.d32 L_00428cce                           # 00428b10
L_00428b15:
    # block 0x00428b15: entered by switch case, 3 instruction(s), ends with jne to 0x00428cce (forward)
    mov edx, dword ptr [ebp - local_140]         # 00428b15
    cmp dword ptr [edx], 0x1                     # 00428b1b
    jne.d32 L_00428cce                           # 00428b1e
    # block 0x00428b24: entered by fall-through of jne at 0x00428b1e, 12 instruction(s), ends with jl to 0x00428b6d (forward)
    mov eax, dword ptr [ebp - local_4]           # 00428b24
    movsx ecx, word ptr [eax + field_4]          # 00428b27
    mov edx, dword ptr [ebp - local_140]         # 00428b2b
    mov dword ptr [edx + field_24], ecx          # 00428b31
    mov eax, dword ptr [ebp - local_4]           # 00428b34
    movsx ecx, word ptr [eax + field_6]          # 00428b37
    mov edx, dword ptr [ebp - local_140]         # 00428b3b
    mov dword ptr [edx + field_20], ecx          # 00428b41
    mov eax, dword ptr [ebp - local_4]           # 00428b44
    movsx ecx, word ptr [eax + field_8]          # 00428b47
    cmp ecx, 0x1388                              # 00428b4b
    jl.d8 L_00428b6d                             # 00428b51
    # block 0x00428b53: entered by fall-through of jl at 0x00428b51, 6 instruction(s), ends with forward jump to 0x00428b7d
    mov edx, dword ptr [ebp - local_4]           # 00428b53
    movsx eax, word ptr [edx + field_8]          # 00428b56
    movsx ecx, word ptr [2*eax + 0x5adb81]       # 00428b5a
    mov edx, dword ptr [ebp - local_140]         # 00428b62
    mov dword ptr [edx + field_1c], ecx          # 00428b68
    jmp.d8 L_00428b7d                            # 00428b6b
L_00428b6d:
    # block 0x00428b6d: entered by jl at 0x00428b51, 4 instruction(s), falls into the block at 0x00428b7d
    mov eax, dword ptr [ebp - local_4]           # 00428b6d
    movsx ecx, word ptr [eax + field_8]          # 00428b70
    mov edx, dword ptr [ebp - local_140]         # 00428b74
    mov dword ptr [edx + field_1c], ecx          # 00428b7a
L_00428b7d:
    # block 0x00428b7d: entered by jmp at 0x00428b6b, 35 instruction(s), ends with forward jump to 0x00428c16
    mov eax, dword ptr [ebp - local_140]         # 00428b7d
    mov ecx, dword ptr [eax + field_24]          # 00428b83
    imul ecx, ecx, 0x36ee80                      # 00428b86
    mov edx, dword ptr [ebp - local_140]         # 00428b8c
    mov eax, dword ptr [edx + field_20]          # 00428b92
    imul eax, eax, 0xea60                        # 00428b95
    {load} add ecx, eax                          # 00428b9b
    mov edx, dword ptr [ebp - local_140]         # 00428b9d
    mov eax, dword ptr [edx + field_1c]          # 00428ba3
    imul eax, eax, 0x3e8                         # 00428ba6
    {load} add ecx, eax                          # 00428bac
    mov edx, dword ptr [ebp - local_140]         # 00428bae
    mov dword ptr [edx + field_18], ecx          # 00428bb4
    mov esi, dword ptr [ebp - local_4]           # 00428bb7
    add esi, 0xc                                 # 00428bba
    mov edi, dword ptr [ebp - local_140]         # 00428bbd
    add edi, 0x28                                # 00428bc3
    mov ecx, 0xc                                 # 00428bc6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00428bcb
    movsb byte ptr es:[edi], byte ptr [esi]      # 00428bcd
    mov esi, dword ptr [ebp - local_4]           # 00428bce
    add esi, 0x3d                                # 00428bd1
    mov edi, dword ptr [ebp - local_140]         # 00428bd4
    add edi, 0x59                                # 00428bda
    mov ecx, 0x8                                 # 00428bdd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00428be2
    movsb byte ptr es:[edi], byte ptr [esi]      # 00428be4
    mov esi, dword ptr [ebp - local_4]           # 00428be5
    add esi, 0x5e                                # 00428be8
    mov edi, dword ptr [ebp - local_140]         # 00428beb
    add edi, 0x7a                                # 00428bf1
    mov ecx, 0x19                                # 00428bf4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00428bf9
    mov dword ptr [ebp - local_148], 0x0         # 00428bfb
    jmp.d8 L_00428c16                            # 00428c05
L_00428c07:
    # block 0x00428c07: entered by jmp at 0x00428c35, 3 instruction(s), falls into the block at 0x00428c16
    mov eax, dword ptr [ebp - local_148]         # 00428c07
    add eax, 0x1                                 # 00428c0d
    mov dword ptr [ebp - local_148], eax         # 00428c10
L_00428c16:
    # block 0x00428c16: entered by jmp at 0x00428c05, 2 instruction(s), ends with jge to 0x00428c37 (forward)
    cmp dword ptr [ebp - local_148], 0xa         # 00428c16
    jge.d8 L_00428c37                            # 00428c1d
    # block 0x00428c1f: entered by fall-through of jge at 0x00428c1d, 4 instruction(s), ends with backward jump to 0x00428c07
    mov ecx, dword ptr [ebp - local_148]         # 00428c1f
    mov edx, dword ptr [ebp - local_140]         # 00428c25
    mov word ptr [edx + 4*ecx + field_de], 0xffff # 00428c2b
    jmp.d8 L_00428c07                            # 00428c35
L_00428c37:
    # block 0x00428c37: entered by jge at 0x00428c1d, 5 instruction(s), ends with forward jump to 0x00428c60
    mov eax, dword ptr [ebp - local_4]           # 00428c37
    add eax, 0xc4                                # 00428c3a
    mov dword ptr [ebp - local_12c], eax         # 00428c3f
    mov dword ptr [ebp - local_144], 0x0         # 00428c45
    jmp.d8 L_00428c60                            # 00428c4f
L_00428c51:
    # block 0x00428c51: entered by jmp at 0x00428c9c, 3 instruction(s), falls into the block at 0x00428c60
    mov ecx, dword ptr [ebp - local_144]         # 00428c51
    add ecx, 0x1                                 # 00428c57
    mov dword ptr [ebp - local_144], ecx         # 00428c5a
L_00428c60:
    # block 0x00428c60: entered by jmp at 0x00428c4f, 4 instruction(s), ends with jge to 0x00428c9e (forward)
    mov edx, dword ptr [ebp - local_4]           # 00428c60
    movsx eax, word ptr [edx + field_c2]         # 00428c63
    cmp dword ptr [ebp - local_144], eax         # 00428c6a
    jge.d8 L_00428c9e                            # 00428c70
    # block 0x00428c72: entered by fall-through of jge at 0x00428c70, 9 instruction(s), ends with backward jump to 0x00428c51
    mov ecx, dword ptr [ebp - local_144]         # 00428c72
    mov edx, dword ptr [ebp - local_140]         # 00428c78
    mov eax, dword ptr [ebp - local_12c]         # 00428c7e
    mov eax, dword ptr [eax]                     # 00428c84
    mov dword ptr [edx + 4*ecx + field_de], eax  # 00428c86
    mov ecx, dword ptr [ebp - local_12c]         # 00428c8d
    add ecx, 0x4                                 # 00428c93
    mov dword ptr [ebp - local_12c], ecx         # 00428c96
    jmp.d8 L_00428c51                            # 00428c9c
L_00428c9e:
    # block 0x00428c9e: entered by jge at 0x00428c70, 9 instruction(s), falls into the block at 0x00428cce
    mov edx, dword ptr [ebp - local_140]         # 00428c9e
    mov dword ptr [edx + field_14], 0x0          # 00428ca4
    mov eax, dword ptr [ebp - local_4]           # 00428cab
    movsx ecx, word ptr [eax + field_2]          # 00428cae
    mov edx, dword ptr [ebp - local_140]         # 00428cb2
    mov dword ptr [edx], ecx                     # 00428cb8
    movsx eax, word ptr [ebp - local_11c]        # 00428cba
    imul eax, eax, 0x8d                          # 00428cc1
    mov byte ptr [eax + 0x5bb625], 0x1           # 00428cc7
L_00428cce:
    # block 0x00428cce: entered by je at 0x004287ee; ja at 0x00428836; jmp at 0x0042886c; jmp at 0x00428891; more, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428cce
L_00428cd3:
    # block 0x00428cd3: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428d07 (forward)
    push 0x1                                     # 00428cd3
    movsx ecx, word ptr [ebp - local_11c]        # 00428cd5
    imul ecx, ecx, 0x8d                          # 00428cdc
    add ecx, 0x5bb5e9                            # 00428ce2
    push ecx                                     # 00428ce8
    mov ecx, 0x63786d                            # 00428ce9
    call FUN_00423f57                            # 00428cee
    test eax, eax                                # 00428cf3
    je.d8 L_00428d07                             # 00428cf5
    # block 0x00428cf7: entered by fall-through of je at 0x00428cf5, 4 instruction(s), calls FUN_0042e844, falls into the block at 0x00428d07
    mov dx, word ptr [ebp - local_11c]           # 00428cf7
    push edx                                     # 00428cfe
    call FUN_0042e844                            # 00428cff
    add esp, 0x4                                 # 00428d04
L_00428d07:
    # block 0x00428d07: entered by je at 0x00428cf5, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428d07
L_00428d0c:
    # block 0x00428d0c: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428d3f (forward)
    push 0x1                                     # 00428d0c
    movsx eax, word ptr [ebp - local_11c]        # 00428d0e
    imul eax, eax, 0x8d                          # 00428d15
    add eax, 0x5bb5e9                            # 00428d1b
    push eax                                     # 00428d20
    mov ecx, 0x63786d                            # 00428d21
    call FUN_00423f57                            # 00428d26
    test eax, eax                                # 00428d2b
    je.d8 L_00428d3f                             # 00428d2d
    # block 0x00428d2f: entered by fall-through of je at 0x00428d2d, 4 instruction(s), calls FUN_0042ea87, falls into the block at 0x00428d3f
    mov cx, word ptr [ebp - local_11c]           # 00428d2f
    push ecx                                     # 00428d36
    call FUN_0042ea87                            # 00428d37
    add esp, 0x4                                 # 00428d3c
L_00428d3f:
    # block 0x00428d3f: entered by je at 0x00428d2d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428d3f
L_00428d44:
    # block 0x00428d44: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428e2d (forward)
    push 0x0                                     # 00428d44
    movsx edx, word ptr [ebp - local_11c]        # 00428d46
    imul edx, edx, 0x8d                          # 00428d4d
    add edx, 0x5bb5e9                            # 00428d53
    push edx                                     # 00428d59
    mov ecx, 0x63786d                            # 00428d5a
    call FUN_00423f57                            # 00428d5f
    test eax, eax                                # 00428d64
    je.d32 L_00428e2d                            # 00428d66
    # block 0x00428d6c: entered by fall-through of je at 0x00428d66, 6 instruction(s), ends with jne to 0x00428d91 (forward)
    movsx eax, word ptr [ebp - local_11c]        # 00428d6c
    imul eax, eax, 0x8d                          # 00428d73
    {load} xor ecx, ecx                          # 00428d79
    mov cl, byte ptr [eax + 0x5bb5e3]            # 00428d7b
    cmp ecx, 0x6b                                # 00428d81
    jne.d8 L_00428d91                            # 00428d84
    # block 0x00428d86: entered by fall-through of jne at 0x00428d84, 2 instruction(s), ends with forward jump to 0x00428d9a
    mov word ptr [ebp - local_130], 0xa          # 00428d86
    jmp.d8 L_00428d9a                            # 00428d8f
L_00428d91:
    # block 0x00428d91: entered by jne at 0x00428d84, 1 instruction(s), falls into the block at 0x00428d9a
    mov word ptr [ebp - local_130], 0x2          # 00428d91
L_00428d9a:
    # block 0x00428d9a: entered by jmp at 0x00428d8f, 2 instruction(s), ends with forward jump to 0x00428dae
    mov word ptr [ebp - local_14], 0x0           # 00428d9a
    jmp.d8 L_00428dae                            # 00428da0
L_00428da2:
    # block 0x00428da2: entered by jmp at 0x00428e1b, 3 instruction(s), falls into the block at 0x00428dae
    mov dx, word ptr [ebp - local_14]            # 00428da2
    add dx, 0x1                                  # 00428da6
    mov word ptr [ebp - local_14], dx            # 00428daa
L_00428dae:
    # block 0x00428dae: entered by jmp at 0x00428da0, 4 instruction(s), ends with jge to 0x00428e1d (forward)
    movsx eax, word ptr [ebp - local_14]         # 00428dae
    movsx ecx, word ptr [ebp - local_130]        # 00428db2
    {load} cmp eax, ecx                          # 00428db9
    jge.d8 L_00428e1d                            # 00428dbb
    # block 0x00428dbd: entered by fall-through of jge at 0x00428dbb, 7 instruction(s), ends with je to 0x00428e1b (forward)
    movsx edx, word ptr [ebp - local_11c]        # 00428dbd
    imul edx, edx, 0x8d                          # 00428dc4
    movsx eax, word ptr [ebp - local_14]         # 00428dca
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 00428dce
    movsx edx, word ptr [ecx + 4*eax]            # 00428dd4
    cmp edx, -0x1                                # 00428dd8
    je.d8 L_00428e1b                             # 00428ddb
    # block 0x00428ddd: entered by fall-through of je at 0x00428ddb, 11 instruction(s), falls into the block at 0x00428e1b
    movsx eax, word ptr [ebp - local_11c]        # 00428ddd
    imul eax, eax, 0x8d                          # 00428de4
    movsx ecx, word ptr [ebp - local_14]         # 00428dea
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00428dee
    movsx eax, word ptr [edx + 4*ecx + field_2]  # 00428df4
    movsx ecx, word ptr [ebp - local_11c]        # 00428df9
    imul ecx, ecx, 0x8d                          # 00428e00
    movsx edx, word ptr [ebp - local_14]         # 00428e06
    mov ecx, dword ptr [ecx + 0x5bb5e5]          # 00428e0a
    movsx edx, word ptr [ecx + 4*edx]            # 00428e10
    mov dword ptr [4*edx + 0x585801], eax        # 00428e14
L_00428e1b:
    # block 0x00428e1b: entered by je at 0x00428ddb, 1 instruction(s), ends with backward jump to 0x00428da2
    jmp.d8 L_00428da2                            # 00428e1b
L_00428e1d:
    # block 0x00428e1d: entered by jge at 0x00428dbb, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00428e2d
    mov ax, word ptr [ebp - local_11c]           # 00428e1d
    push eax                                     # 00428e24
    call FUN_0042ba3a                            # 00428e25
    add esp, 0x4                                 # 00428e2a
L_00428e2d:
    # block 0x00428e2d: entered by je at 0x00428d66, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428e2d
L_00428e32:
    # block 0x00428e32: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428f0c (forward)
    push 0x0                                     # 00428e32
    movsx ecx, word ptr [ebp - local_11c]        # 00428e34
    imul ecx, ecx, 0x8d                          # 00428e3b
    add ecx, 0x5bb5e9                            # 00428e41
    push ecx                                     # 00428e47
    mov ecx, 0x63786d                            # 00428e48
    call FUN_00423f57                            # 00428e4d
    test eax, eax                                # 00428e52
    je.d32 L_00428f0c                            # 00428e54
    # block 0x00428e5a: entered by fall-through of je at 0x00428e54, 14 instruction(s), ends with forward jump to 0x00428eb3
    movsx edx, word ptr [ebp - local_11c]        # 00428e5a
    imul edx, edx, 0x8d                          # 00428e61
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00428e67
    mov cx, word ptr [eax]                       # 00428e6d
    mov word ptr [ebp - local_130], cx           # 00428e70
    movsx edx, word ptr [ebp - local_11c]        # 00428e77
    imul edx, edx, 0x8d                          # 00428e7e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00428e84
    mov dword ptr [ebp - local_120], eax         # 00428e8a
    mov ecx, dword ptr [ebp - local_120]         # 00428e90
    add ecx, 0x2                                 # 00428e96
    mov dword ptr [ebp - local_120], ecx         # 00428e99
    mov word ptr [ebp - local_14], 0x0           # 00428e9f
    jmp.d8 L_00428eb3                            # 00428ea5
L_00428ea7:
    # block 0x00428ea7: entered by jmp at 0x00428efa, 3 instruction(s), falls into the block at 0x00428eb3
    mov dx, word ptr [ebp - local_14]            # 00428ea7
    add dx, 0x1                                  # 00428eab
    mov word ptr [ebp - local_14], dx            # 00428eaf
L_00428eb3:
    # block 0x00428eb3: entered by jmp at 0x00428ea5, 4 instruction(s), ends with jge to 0x00428efc (forward)
    movsx eax, word ptr [ebp - local_14]         # 00428eb3
    movsx ecx, word ptr [ebp - local_130]        # 00428eb7
    {load} cmp eax, ecx                          # 00428ebe
    jge.d8 L_00428efc                            # 00428ec0
    # block 0x00428ec2: entered by fall-through of jge at 0x00428ec0, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x00428ed3 (forward)
    call FUN_0050cd50                            # 00428ec2
    and eax, 0x80000001                          # 00428ec7
    jns.d8 L_00428ed3                            # 00428ecc
    # block 0x00428ece: entered by fall-through of jns at 0x00428ecc, 3 instruction(s), falls into the block at 0x00428ed3
    dec eax                                      # 00428ece
    or eax, -0x2                                 # 00428ecf
    inc eax                                      # 00428ed2
L_00428ed3:
    # block 0x00428ed3: entered by jns at 0x00428ecc, 9 instruction(s), ends with backward jump to 0x00428ea7
    mov word ptr [ebp - local_c], ax             # 00428ed3
    movsx edx, word ptr [ebp - local_c]          # 00428ed7
    mov eax, dword ptr [ebp - local_120]         # 00428edb
    movsx ecx, word ptr [eax]                    # 00428ee1
    mov dword ptr [4*ecx + 0x585801], edx        # 00428ee4
    mov edx, dword ptr [ebp - local_120]         # 00428eeb
    add edx, 0x2                                 # 00428ef1
    mov dword ptr [ebp - local_120], edx         # 00428ef4
    jmp.d8 L_00428ea7                            # 00428efa
L_00428efc:
    # block 0x00428efc: entered by jge at 0x00428ec0, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00428f0c
    mov ax, word ptr [ebp - local_11c]           # 00428efc
    push eax                                     # 00428f03
    call FUN_0042ba3a                            # 00428f04
    add esp, 0x4                                 # 00428f09
L_00428f0c:
    # block 0x00428f0c: entered by je at 0x00428e54, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428f0c
L_00428f11:
    # block 0x00428f11: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428f45 (forward)
    push 0x0                                     # 00428f11
    movsx ecx, word ptr [ebp - local_11c]        # 00428f13
    imul ecx, ecx, 0x8d                          # 00428f1a
    add ecx, 0x5bb5e9                            # 00428f20
    push ecx                                     # 00428f26
    mov ecx, 0x63786d                            # 00428f27
    call FUN_00423f57                            # 00428f2c
    test eax, eax                                # 00428f31
    je.d8 L_00428f45                             # 00428f33
    # block 0x00428f35: entered by fall-through of je at 0x00428f33, 4 instruction(s), calls FUN_0042ed54, falls into the block at 0x00428f45
    mov dx, word ptr [ebp - local_11c]           # 00428f35
    push edx                                     # 00428f3c
    call FUN_0042ed54                            # 00428f3d
    add esp, 0x4                                 # 00428f42
L_00428f45:
    # block 0x00428f45: entered by je at 0x00428f33, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428f45
L_00428f4a:
    # block 0x00428f4a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428f7d (forward)
    push 0x0                                     # 00428f4a
    movsx eax, word ptr [ebp - local_11c]        # 00428f4c
    imul eax, eax, 0x8d                          # 00428f53
    add eax, 0x5bb5e9                            # 00428f59
    push eax                                     # 00428f5e
    mov ecx, 0x63786d                            # 00428f5f
    call FUN_00423f57                            # 00428f64
    test eax, eax                                # 00428f69
    je.d8 L_00428f7d                             # 00428f6b
    # block 0x00428f6d: entered by fall-through of je at 0x00428f6b, 4 instruction(s), calls FUN_00430ca0, falls into the block at 0x00428f7d
    mov cx, word ptr [ebp - local_11c]           # 00428f6d
    push ecx                                     # 00428f74
    call FUN_00430ca0                            # 00428f75
    add esp, 0x4                                 # 00428f7a
L_00428f7d:
    # block 0x00428f7d: entered by je at 0x00428f6b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428f7d
L_00428f82:
    # block 0x00428f82: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428fb6 (forward)
    push 0x0                                     # 00428f82
    movsx edx, word ptr [ebp - local_11c]        # 00428f84
    imul edx, edx, 0x8d                          # 00428f8b
    add edx, 0x5bb5e9                            # 00428f91
    push edx                                     # 00428f97
    mov ecx, 0x63786d                            # 00428f98
    call FUN_00423f57                            # 00428f9d
    test eax, eax                                # 00428fa2
    je.d8 L_00428fb6                             # 00428fa4
    # block 0x00428fa6: entered by fall-through of je at 0x00428fa4, 4 instruction(s), calls FUN_004313e3, falls into the block at 0x00428fb6
    mov ax, word ptr [ebp - local_11c]           # 00428fa6
    push eax                                     # 00428fad
    call FUN_004313e3                            # 00428fae
    add esp, 0x4                                 # 00428fb3
L_00428fb6:
    # block 0x00428fb6: entered by je at 0x00428fa4, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428fb6
L_00428fbb:
    # block 0x00428fbb: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00428fef (forward)
    push 0x0                                     # 00428fbb
    movsx ecx, word ptr [ebp - local_11c]        # 00428fbd
    imul ecx, ecx, 0x8d                          # 00428fc4
    add ecx, 0x5bb5e9                            # 00428fca
    push ecx                                     # 00428fd0
    mov ecx, 0x63786d                            # 00428fd1
    call FUN_00423f57                            # 00428fd6
    test eax, eax                                # 00428fdb
    je.d8 L_00428fef                             # 00428fdd
    # block 0x00428fdf: entered by fall-through of je at 0x00428fdd, 4 instruction(s), calls FUN_00431b5a, falls into the block at 0x00428fef
    mov dx, word ptr [ebp - local_11c]           # 00428fdf
    push edx                                     # 00428fe6
    call FUN_00431b5a                            # 00428fe7
    add esp, 0x4                                 # 00428fec
L_00428fef:
    # block 0x00428fef: entered by je at 0x00428fdd, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00428fef
L_00428ff4:
    # block 0x00428ff4: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429027 (forward)
    push 0x0                                     # 00428ff4
    movsx eax, word ptr [ebp - local_11c]        # 00428ff6
    imul eax, eax, 0x8d                          # 00428ffd
    add eax, 0x5bb5e9                            # 00429003
    push eax                                     # 00429008
    mov ecx, 0x63786d                            # 00429009
    call FUN_00423f57                            # 0042900e
    test eax, eax                                # 00429013
    je.d8 L_00429027                             # 00429015
    # block 0x00429017: entered by fall-through of je at 0x00429015, 4 instruction(s), calls FUN_0042f510, falls into the block at 0x00429027
    mov cx, word ptr [ebp - local_11c]           # 00429017
    push ecx                                     # 0042901e
    call FUN_0042f510                            # 0042901f
    add esp, 0x4                                 # 00429024
L_00429027:
    # block 0x00429027: entered by je at 0x00429015, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429027
L_0042902c:
    # block 0x0042902c: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429060 (forward)
    push 0x0                                     # 0042902c
    movsx edx, word ptr [ebp - local_11c]        # 0042902e
    imul edx, edx, 0x8d                          # 00429035
    add edx, 0x5bb5e9                            # 0042903b
    push edx                                     # 00429041
    mov ecx, 0x63786d                            # 00429042
    call FUN_00423f57                            # 00429047
    test eax, eax                                # 0042904c
    je.d8 L_00429060                             # 0042904e
    # block 0x00429050: entered by fall-through of je at 0x0042904e, 4 instruction(s), calls FUN_0042fc70, falls into the block at 0x00429060
    mov ax, word ptr [ebp - local_11c]           # 00429050
    push eax                                     # 00429057
    call FUN_0042fc70                            # 00429058
    add esp, 0x4                                 # 0042905d
L_00429060:
    # block 0x00429060: entered by je at 0x0042904e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429060
L_00429065:
    # block 0x00429065: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004290bb (forward)
    push 0x0                                     # 00429065
    movsx ecx, word ptr [ebp - local_11c]        # 00429067
    imul ecx, ecx, 0x8d                          # 0042906e
    add ecx, 0x5bb5e9                            # 00429074
    push ecx                                     # 0042907a
    mov ecx, 0x63786d                            # 0042907b
    call FUN_00423f57                            # 00429080
    test eax, eax                                # 00429085
    je.d8 L_004290bb                             # 00429087
    # block 0x00429089: entered by fall-through of je at 0x00429087, 7 instruction(s), calls FUN_004fb018, falls into the block at 0x004290bb
    mov ecx, 0x5c3a67                            # 00429089
    call FUN_004fb018                            # 0042908e
    mov dword ptr [0x583981], 0x6                # 00429093
    mov dword ptr [0x5839a1], 0x0                # 0042909d
    movsx edx, word ptr [ebp - local_11c]        # 004290a7
    imul edx, edx, 0x8d                          # 004290ae
    mov byte ptr [edx + 0x5bb625], 0x1           # 004290b4
L_004290bb:
    # block 0x004290bb: entered by je at 0x00429087, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004290bb
L_004290c0:
    # block 0x004290c0: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042916a (forward)
    push 0x0                                     # 004290c0
    movsx eax, word ptr [ebp - local_11c]        # 004290c2
    imul eax, eax, 0x8d                          # 004290c9
    add eax, 0x5bb5e9                            # 004290cf
    push eax                                     # 004290d4
    mov ecx, 0x63786d                            # 004290d5
    call FUN_00423f57                            # 004290da
    test eax, eax                                # 004290df
    je.d32 L_0042916a                            # 004290e1
    # block 0x004290e7: entered by fall-through of je at 0x004290e1, 2 instruction(s), ends with je to 0x004290fc (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 004290e7
    je.d8 L_004290fc                             # 004290ee
    # block 0x004290f0: entered by fall-through of je at 0x004290ee, 3 instruction(s), calls FUN_004e303b, ends with forward jump to 0x00429124
    mov ecx, 0x57975c                            # 004290f0
    call FUN_004e303b                            # 004290f5
    jmp.d8 L_00429124                            # 004290fa
L_004290fc:
    # block 0x004290fc: entered by je at 0x004290ee, 2 instruction(s), ends with jne to 0x00429111 (forward)
    cmp dword ptr [0x583204], 0x4                # 004290fc
    jne.d8 L_00429111                            # 00429103
    # block 0x00429105: entered by fall-through of jne at 0x00429103, 3 instruction(s), calls FUN_004eb96e, ends with forward jump to 0x00429124
    mov ecx, 0x57fd34                            # 00429105
    call FUN_004eb96e                            # 0042910a
    jmp.d8 L_00429124                            # 0042910f
L_00429111:
    # block 0x00429111: entered by jne at 0x00429103, 2 instruction(s), ends with jne to 0x00429124 (forward)
    cmp dword ptr [0x583204], 0x3                # 00429111
    jne.d8 L_00429124                            # 00429118
    # block 0x0042911a: entered by fall-through of jne at 0x00429118, 2 instruction(s), calls FUN_004e7d04, falls into the block at 0x00429124
    mov ecx, 0x571442                            # 0042911a
    call FUN_004e7d04                            # 0042911f
L_00429124:
    # block 0x00429124: entered by jmp at 0x004290fa; jmp at 0x0042910f; jne at 0x00429118, 9 instruction(s), calls FUN_004fb018, falls into the block at 0x0042916a
    mov ecx, 0x5c3a67                            # 00429124
    call FUN_004fb018                            # 00429129
    mov dword ptr [0x583981], 0x6                # 0042912e
    mov dword ptr [0x5839a1], 0x0                # 00429138
    mov dword ptr [0x583999], 0x0                # 00429142
    mov dword ptr [0x5bb1e2], 0x0                # 0042914c
    movsx ecx, word ptr [ebp - local_11c]        # 00429156
    imul ecx, ecx, 0x8d                          # 0042915d
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00429163
L_0042916a:
    # block 0x0042916a: entered by je at 0x004290e1, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042916a
L_0042916f:
    # block 0x0042916f: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004291b1 (forward)
    push 0x0                                     # 0042916f
    movsx edx, word ptr [ebp - local_11c]        # 00429171
    imul edx, edx, 0x8d                          # 00429178
    add edx, 0x5bb5e9                            # 0042917e
    push edx                                     # 00429184
    mov ecx, 0x63786d                            # 00429185
    call FUN_00423f57                            # 0042918a
    test eax, eax                                # 0042918f
    je.d8 L_004291b1                             # 00429191
    # block 0x00429193: entered by fall-through of je at 0x00429191, 6 instruction(s), calls FUN_0042e560, falls into the block at 0x004291b1
    push 0x2                                     # 00429193
    call FUN_0042e560                            # 00429195
    add esp, 0x4                                 # 0042919a
    movsx eax, word ptr [ebp - local_11c]        # 0042919d
    imul eax, eax, 0x8d                          # 004291a4
    mov byte ptr [eax + 0x5bb625], 0x1           # 004291aa
L_004291b1:
    # block 0x004291b1: entered by je at 0x00429191, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004291b1
L_004291b6:
    # block 0x004291b6: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004291f3 (forward)
    push 0x0                                     # 004291b6
    movsx ecx, word ptr [ebp - local_11c]        # 004291b8
    imul ecx, ecx, 0x8d                          # 004291bf
    add ecx, 0x5bb5e9                            # 004291c5
    push ecx                                     # 004291cb
    mov ecx, 0x63786d                            # 004291cc
    call FUN_00423f57                            # 004291d1
    test eax, eax                                # 004291d6
    je.d8 L_004291f3                             # 004291d8
    # block 0x004291da: entered by fall-through of je at 0x004291d8, 4 instruction(s), calls FUN_0042e493, falls into the block at 0x004291f3
    call FUN_0042e493                            # 004291da
    movsx edx, word ptr [ebp - local_11c]        # 004291df
    imul edx, edx, 0x8d                          # 004291e6
    mov byte ptr [edx + 0x5bb625], 0x1           # 004291ec
L_004291f3:
    # block 0x004291f3: entered by je at 0x004291d8, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004291f3
L_004291f8:
    # block 0x004291f8: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429270 (forward)
    push 0x0                                     # 004291f8
    movsx eax, word ptr [ebp - local_11c]        # 004291fa
    imul eax, eax, 0x8d                          # 00429201
    add eax, 0x5bb5e9                            # 00429207
    push eax                                     # 0042920c
    mov ecx, 0x63786d                            # 0042920d
    call FUN_00423f57                            # 00429212
    test eax, eax                                # 00429217
    je.d8 L_00429270                             # 00429219
    # block 0x0042921b: entered by fall-through of je at 0x00429219, 11 instruction(s), calls FUN_004fb018, FUN_0043dbd5, falls into the block at 0x00429270
    mov ecx, 0x5c3a67                            # 0042921b
    call FUN_004fb018                            # 00429220
    mov dword ptr [0x583985], 0x6                # 00429225
    mov dword ptr [0x583981], 0x5                # 0042922f
    mov dword ptr [0x583991], 0x0                # 00429239
    call FUN_0043dbd5                            # 00429243
    mov dword ptr [0x583999], 0x0                # 00429248
    mov dword ptr [0x5bb1e2], 0x0                # 00429252
    movsx ecx, word ptr [ebp - local_11c]        # 0042925c
    imul ecx, ecx, 0x8d                          # 00429263
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00429269
L_00429270:
    # block 0x00429270: entered by je at 0x00429219, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429270
L_00429275:
    # block 0x00429275: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042931f (forward)
    push 0x0                                     # 00429275
    movsx edx, word ptr [ebp - local_11c]        # 00429277
    imul edx, edx, 0x8d                          # 0042927e
    add edx, 0x5bb5e9                            # 00429284
    push edx                                     # 0042928a
    mov ecx, 0x63786d                            # 0042928b
    call FUN_00423f57                            # 00429290
    test eax, eax                                # 00429295
    je.d32 L_0042931f                            # 00429297
    # block 0x0042929d: entered by fall-through of je at 0x00429297, 11 instruction(s), ends with je to 0x0042930b (forward)
    movsx eax, word ptr [ebp - local_11c]        # 0042929d
    imul eax, eax, 0x8d                          # 004292a4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004292aa
    mov dx, word ptr [ecx]                       # 004292b0
    mov word ptr [0x58c94f], dx                  # 004292b3
    movsx eax, word ptr [ebp - local_11c]        # 004292ba
    imul eax, eax, 0x8d                          # 004292c1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004292c7
    movsx edx, word ptr [ecx + field_2]          # 004292cd
    cmp edx, -0x1                                # 004292d1
    je.d8 L_0042930b                             # 004292d4
    # block 0x004292d6: entered by fall-through of je at 0x004292d4, 9 instruction(s), falls into the block at 0x0042930b
    movsx eax, word ptr [ebp - local_11c]        # 004292d6
    imul eax, eax, 0x8d                          # 004292dd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004292e3
    movsx edx, word ptr [ecx + field_4]          # 004292e9
    movsx eax, word ptr [ebp - local_11c]        # 004292ed
    imul eax, eax, 0x8d                          # 004292f4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004292fa
    movsx eax, word ptr [ecx + field_2]          # 00429300
    mov dword ptr [4*eax + 0x585801], edx        # 00429304
L_0042930b:
    # block 0x0042930b: entered by je at 0x004292d4, 3 instruction(s), falls into the block at 0x0042931f
    movsx ecx, word ptr [ebp - local_11c]        # 0042930b
    imul ecx, ecx, 0x8d                          # 00429312
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00429318
L_0042931f:
    # block 0x0042931f: entered by je at 0x00429297, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042931f
L_00429324:
    # block 0x00429324: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042936e (forward)
    push 0x0                                     # 00429324
    movsx edx, word ptr [ebp - local_11c]        # 00429326
    imul edx, edx, 0x8d                          # 0042932d
    add edx, 0x5bb5e9                            # 00429333
    push edx                                     # 00429339
    mov ecx, 0x63786d                            # 0042933a
    call FUN_00423f57                            # 0042933f
    test eax, eax                                # 00429344
    je.d8 L_0042936e                             # 00429346
    # block 0x00429348: entered by fall-through of je at 0x00429346, 7 instruction(s), calls FUN_004e13e4, falls into the block at 0x0042936e
    mov ax, word ptr [ebp - local_11c]           # 00429348
    push eax                                     # 0042934f
    mov ecx, 0x570508                            # 00429350
    call FUN_004e13e4                            # 00429355
    movsx ecx, word ptr [ebp - local_11c]        # 0042935a
    imul ecx, ecx, 0x8d                          # 00429361
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00429367
L_0042936e:
    # block 0x0042936e: entered by je at 0x00429346, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042936e
L_00429373:
    # block 0x00429373: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429446 (forward)
    push 0x0                                     # 00429373
    movsx edx, word ptr [ebp - local_11c]        # 00429375
    imul edx, edx, 0x8d                          # 0042937c
    add edx, 0x5bb5e9                            # 00429382
    push edx                                     # 00429388
    mov ecx, 0x63786d                            # 00429389
    call FUN_00423f57                            # 0042938e
    test eax, eax                                # 00429393
    je.d32 L_00429446                            # 00429395
    # block 0x0042939b: entered by fall-through of je at 0x00429395, 22 instruction(s), calls FUN_0043e96c, FUN_0043e8b8, ends with je to 0x00429446 (forward)
    movsx eax, word ptr [ebp - local_11c]        # 0042939b
    imul eax, eax, 0x8d                          # 004293a2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004293a8
    mov dword ptr [ebp - local_14c], ecx         # 004293ae
    mov edx, dword ptr [ebp - local_14c]         # 004293b4
    mov eax, dword ptr [edx]                     # 004293ba
    mov dword ptr [0x63aa10], eax                # 004293bc
    mov ecx, dword ptr [ebp - local_14c]         # 004293c1
    mov edx, dword ptr [ecx + field_4]           # 004293c7
    mov dword ptr [0x55cd94], edx                # 004293ca
    movsx eax, word ptr [ebp - local_11c]        # 004293d0
    imul eax, eax, 0x8d                          # 004293d7
    mov byte ptr [eax + 0x5bb625], 0x1           # 004293dd
    call FUN_0043e96c                            # 004293e4
    call FUN_0043e8b8                            # 004293e9
    mov ecx, dword ptr [0x5bb57f]                # 004293ee
    mov dword ptr [0x5bb57b], ecx                # 004293f4
    mov dx, word ptr [0x5bb57b]                  # 004293fa
    mov word ptr [0x5c3a4f], dx                  # 00429401
    movsx eax, word ptr [0x63a4cd]               # 00429408
    test eax, eax                                # 0042940f
    je.d8 L_00429446                             # 00429411
    # block 0x00429413: entered by fall-through of je at 0x00429411, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00429446
    mov ecx, dword ptr [0x5bb57b]                # 00429413
    push ecx                                     # 00429419
    mov edx, dword ptr [0x63aa10]                # 0042941a
    push edx                                     # 00429420
    mov eax, dword ptr [0x55cd94]                # 00429421
    push eax                                     # 00429426
    push 0x545640                                # 00429427
    push 0x63888b                                # 0042942c
    call FUN_0050ca3e                            # 00429431
    add esp, 0x14                                # 00429436
    push 0x63888b                                # 00429439
    call FUN_0044a2b7                            # 0042943e
    add esp, 0x4                                 # 00429443
L_00429446:
    # block 0x00429446: entered by je at 0x00429395; je at 0x00429411, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429446
L_0042944b:
    # block 0x0042944b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429481 (forward)
    push 0x0                                     # 0042944b
    movsx ecx, word ptr [ebp - local_11c]        # 0042944d
    imul ecx, ecx, 0x8d                          # 00429454
    add ecx, 0x5bb5e9                            # 0042945a
    push ecx                                     # 00429460
    mov ecx, 0x63786d                            # 00429461
    call FUN_00423f57                            # 00429466
    test eax, eax                                # 0042946b
    je.d8 L_00429481                             # 0042946d
    # block 0x0042946f: entered by fall-through of je at 0x0042946d, 4 instruction(s), calls FUN_004eaadc, falls into the block at 0x00429481
    mov dx, word ptr [ebp - local_11c]           # 0042946f
    push edx                                     # 00429476
    mov ecx, 0x571442                            # 00429477
    call FUN_004eaadc                            # 0042947c
L_00429481:
    # block 0x00429481: entered by je at 0x0042946d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429481
L_00429486:
    # block 0x00429486: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004294bb (forward)
    push 0x0                                     # 00429486
    movsx eax, word ptr [ebp - local_11c]        # 00429488
    imul eax, eax, 0x8d                          # 0042948f
    add eax, 0x5bb5e9                            # 00429495
    push eax                                     # 0042949a
    mov ecx, 0x63786d                            # 0042949b
    call FUN_00423f57                            # 004294a0
    test eax, eax                                # 004294a5
    je.d8 L_004294bb                             # 004294a7
    # block 0x004294a9: entered by fall-through of je at 0x004294a7, 4 instruction(s), calls FUN_004eac4c, falls into the block at 0x004294bb
    mov cx, word ptr [ebp - local_11c]           # 004294a9
    push ecx                                     # 004294b0
    mov ecx, 0x571442                            # 004294b1
    call FUN_004eac4c                            # 004294b6
L_004294bb:
    # block 0x004294bb: entered by je at 0x004294a7, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004294bb
L_004294c0:
    # block 0x004294c0: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429506 (forward)
    push 0x0                                     # 004294c0
    movsx edx, word ptr [ebp - local_11c]        # 004294c2
    imul edx, edx, 0x8d                          # 004294c9
    add edx, 0x5bb5e9                            # 004294cf
    push edx                                     # 004294d5
    mov ecx, 0x63786d                            # 004294d6
    call FUN_00423f57                            # 004294db
    test eax, eax                                # 004294e0
    je.d8 L_00429506                             # 004294e2
    # block 0x004294e4: entered by fall-through of je at 0x004294e2, 8 instruction(s), calls FUN_004ead69, FUN_0042ba3a, falls into the block at 0x00429506
    mov ax, word ptr [ebp - local_11c]           # 004294e4
    push eax                                     # 004294eb
    mov ecx, 0x571442                            # 004294ec
    call FUN_004ead69                            # 004294f1
    mov cx, word ptr [ebp - local_11c]           # 004294f6
    push ecx                                     # 004294fd
    call FUN_0042ba3a                            # 004294fe
    add esp, 0x4                                 # 00429503
L_00429506:
    # block 0x00429506: entered by je at 0x004294e2, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429506
L_0042950b:
    # block 0x0042950b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429556 (forward)
    push 0x0                                     # 0042950b
    movsx edx, word ptr [ebp - local_11c]        # 0042950d
    imul edx, edx, 0x8d                          # 00429514
    add edx, 0x5bb5e9                            # 0042951a
    push edx                                     # 00429520
    mov ecx, 0x63786d                            # 00429521
    call FUN_00423f57                            # 00429526
    test eax, eax                                # 0042952b
    je.d8 L_00429556                             # 0042952d
    # block 0x0042952f: entered by fall-through of je at 0x0042952d, 6 instruction(s), calls FUN_004eb5f2, falls into the block at 0x00429556
    mov ecx, 0x571442                            # 0042952f
    call FUN_004eb5f2                            # 00429534
    mov word ptr [0x583f1d], 0xffff              # 00429539
    movsx eax, word ptr [ebp - local_11c]        # 00429542
    imul eax, eax, 0x8d                          # 00429549
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042954f
L_00429556:
    # block 0x00429556: entered by je at 0x0042952d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429556
L_0042955b:
    # block 0x0042955b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429591 (forward)
    push 0x0                                     # 0042955b
    movsx ecx, word ptr [ebp - local_11c]        # 0042955d
    imul ecx, ecx, 0x8d                          # 00429564
    add ecx, 0x5bb5e9                            # 0042956a
    push ecx                                     # 00429570
    mov ecx, 0x63786d                            # 00429571
    call FUN_00423f57                            # 00429576
    test eax, eax                                # 0042957b
    je.d8 L_00429591                             # 0042957d
    # block 0x0042957f: entered by fall-through of je at 0x0042957d, 4 instruction(s), calls FUN_004eaca8, falls into the block at 0x00429591
    mov dx, word ptr [ebp - local_11c]           # 0042957f
    push edx                                     # 00429586
    mov ecx, 0x571442                            # 00429587
    call FUN_004eaca8                            # 0042958c
L_00429591:
    # block 0x00429591: entered by je at 0x0042957d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429591
L_00429596:
    # block 0x00429596: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004295cb (forward)
    push 0x1                                     # 00429596
    movsx eax, word ptr [ebp - local_11c]        # 00429598
    imul eax, eax, 0x8d                          # 0042959f
    add eax, 0x5bb5e9                            # 004295a5
    push eax                                     # 004295aa
    mov ecx, 0x63786d                            # 004295ab
    call FUN_00423f57                            # 004295b0
    test eax, eax                                # 004295b5
    je.d8 L_004295cb                             # 004295b7
    # block 0x004295b9: entered by fall-through of je at 0x004295b7, 4 instruction(s), calls FUN_004ea3a0, falls into the block at 0x004295cb
    mov cx, word ptr [ebp - local_11c]           # 004295b9
    push ecx                                     # 004295c0
    mov ecx, 0x571442                            # 004295c1
    call FUN_004ea3a0                            # 004295c6
L_004295cb:
    # block 0x004295cb: entered by je at 0x004295b7, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004295cb
L_004295d0:
    # block 0x004295d0: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429606 (forward)
    push 0x0                                     # 004295d0
    movsx edx, word ptr [ebp - local_11c]        # 004295d2
    imul edx, edx, 0x8d                          # 004295d9
    add edx, 0x5bb5e9                            # 004295df
    push edx                                     # 004295e5
    mov ecx, 0x63786d                            # 004295e6
    call FUN_00423f57                            # 004295eb
    test eax, eax                                # 004295f0
    je.d8 L_00429606                             # 004295f2
    # block 0x004295f4: entered by fall-through of je at 0x004295f2, 4 instruction(s), calls FUN_004eaf2a, falls into the block at 0x00429606
    mov ax, word ptr [ebp - local_11c]           # 004295f4
    push eax                                     # 004295fb
    mov ecx, 0x571442                            # 004295fc
    call FUN_004eaf2a                            # 00429601
L_00429606:
    # block 0x00429606: entered by je at 0x004295f2, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429606
L_0042960b:
    # block 0x0042960b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429655 (forward)
    push 0x0                                     # 0042960b
    movsx ecx, word ptr [ebp - local_11c]        # 0042960d
    imul ecx, ecx, 0x8d                          # 00429614
    add ecx, 0x5bb5e9                            # 0042961a
    push ecx                                     # 00429620
    mov ecx, 0x63786d                            # 00429621
    call FUN_00423f57                            # 00429626
    test eax, eax                                # 0042962b
    je.d8 L_00429655                             # 0042962d
    # block 0x0042962f: entered by fall-through of je at 0x0042962d, 7 instruction(s), calls FUN_004e386e, falls into the block at 0x00429655
    mov dx, word ptr [ebp - local_11c]           # 0042962f
    push edx                                     # 00429636
    mov ecx, 0x57975c                            # 00429637
    call FUN_004e386e                            # 0042963c
    movsx eax, word ptr [ebp - local_11c]        # 00429641
    imul eax, eax, 0x8d                          # 00429648
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042964e
L_00429655:
    # block 0x00429655: entered by je at 0x0042962d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429655
L_0042965a:
    # block 0x0042965a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004296a4 (forward)
    push 0x0                                     # 0042965a
    movsx ecx, word ptr [ebp - local_11c]        # 0042965c
    imul ecx, ecx, 0x8d                          # 00429663
    add ecx, 0x5bb5e9                            # 00429669
    push ecx                                     # 0042966f
    mov ecx, 0x63786d                            # 00429670
    call FUN_00423f57                            # 00429675
    test eax, eax                                # 0042967a
    je.d8 L_004296a4                             # 0042967c
    # block 0x0042967e: entered by fall-through of je at 0x0042967c, 7 instruction(s), calls FUN_004e71da, falls into the block at 0x004296a4
    mov dx, word ptr [ebp - local_11c]           # 0042967e
    push edx                                     # 00429685
    mov ecx, 0x57975c                            # 00429686
    call FUN_004e71da                            # 0042968b
    movsx eax, word ptr [ebp - local_11c]        # 00429690
    imul eax, eax, 0x8d                          # 00429697
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042969d
L_004296a4:
    # block 0x004296a4: entered by je at 0x0042967c, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004296a4
L_004296a9:
    # block 0x004296a9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004296f3 (forward)
    push 0x0                                     # 004296a9
    movsx ecx, word ptr [ebp - local_11c]        # 004296ab
    imul ecx, ecx, 0x8d                          # 004296b2
    add ecx, 0x5bb5e9                            # 004296b8
    push ecx                                     # 004296be
    mov ecx, 0x63786d                            # 004296bf
    call FUN_00423f57                            # 004296c4
    test eax, eax                                # 004296c9
    je.d8 L_004296f3                             # 004296cb
    # block 0x004296cd: entered by fall-through of je at 0x004296cb, 7 instruction(s), calls FUN_004e7253, falls into the block at 0x004296f3
    mov dx, word ptr [ebp - local_11c]           # 004296cd
    push edx                                     # 004296d4
    mov ecx, 0x57975c                            # 004296d5
    call FUN_004e7253                            # 004296da
    movsx eax, word ptr [ebp - local_11c]        # 004296df
    imul eax, eax, 0x8d                          # 004296e6
    mov byte ptr [eax + 0x5bb625], 0x1           # 004296ec
L_004296f3:
    # block 0x004296f3: entered by je at 0x004296cb, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004296f3
L_004296f8:
    # block 0x004296f8: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429742 (forward)
    push 0x0                                     # 004296f8
    movsx ecx, word ptr [ebp - local_11c]        # 004296fa
    imul ecx, ecx, 0x8d                          # 00429701
    add ecx, 0x5bb5e9                            # 00429707
    push ecx                                     # 0042970d
    mov ecx, 0x63786d                            # 0042970e
    call FUN_00423f57                            # 00429713
    test eax, eax                                # 00429718
    je.d8 L_00429742                             # 0042971a
    # block 0x0042971c: entered by fall-through of je at 0x0042971a, 7 instruction(s), calls FUN_004e72fb, falls into the block at 0x00429742
    mov dx, word ptr [ebp - local_11c]           # 0042971c
    push edx                                     # 00429723
    mov ecx, 0x57975c                            # 00429724
    call FUN_004e72fb                            # 00429729
    movsx eax, word ptr [ebp - local_11c]        # 0042972e
    imul eax, eax, 0x8d                          # 00429735
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042973b
L_00429742:
    # block 0x00429742: entered by je at 0x0042971a, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429742
L_00429747:
    # block 0x00429747: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042977d (forward)
    push 0x0                                     # 00429747
    movsx ecx, word ptr [ebp - local_11c]        # 00429749
    imul ecx, ecx, 0x8d                          # 00429750
    add ecx, 0x5bb5e9                            # 00429756
    push ecx                                     # 0042975c
    mov ecx, 0x63786d                            # 0042975d
    call FUN_00423f57                            # 00429762
    test eax, eax                                # 00429767
    je.d8 L_0042977d                             # 00429769
    # block 0x0042976b: entered by fall-through of je at 0x00429769, 4 instruction(s), calls FUN_004c36b2, falls into the block at 0x0042977d
    mov dx, word ptr [ebp - local_11c]           # 0042976b
    push edx                                     # 00429772
    mov ecx, 0x5cf659                            # 00429773
    call FUN_004c36b2                            # 00429778
L_0042977d:
    # block 0x0042977d: entered by je at 0x00429769, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042977d
L_00429782:
    # block 0x00429782: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004297b9 (forward)
    push 0x0                                     # 00429782
    movsx eax, word ptr [ebp - local_11c]        # 00429784
    imul eax, eax, 0x8d                          # 0042978b
    add eax, 0x5bb5e9                            # 00429791
    push eax                                     # 00429796
    mov ecx, 0x63786d                            # 00429797
    call FUN_00423f57                            # 0042979c
    test eax, eax                                # 004297a1
    je.d8 L_004297b9                             # 004297a3
    # block 0x004297a5: entered by fall-through of je at 0x004297a3, 6 instruction(s), calls FUN_00432d1a, falls into the block at 0x004297b9
    push 0x0                                     # 004297a5
    push 0x0                                     # 004297a7
    mov cx, word ptr [ebp - local_11c]           # 004297a9
    push ecx                                     # 004297b0
    call FUN_00432d1a                            # 004297b1
    add esp, 0xc                                 # 004297b6
L_004297b9:
    # block 0x004297b9: entered by je at 0x004297a3, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 004297b9
L_004297be:
    # block 0x004297be: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x004297f8 (forward)
    push 0x0                                     # 004297be
    movsx edx, word ptr [ebp - local_11c]        # 004297c0
    imul edx, edx, 0x8d                          # 004297c7
    add edx, 0x5bb5e9                            # 004297cd
    push edx                                     # 004297d3
    mov ecx, 0x63786d                            # 004297d4
    call FUN_00423f57                            # 004297d9
    test eax, eax                                # 004297de
    je.d8 L_004297f8                             # 004297e0
    # block 0x004297e2: entered by fall-through of je at 0x004297e0, 7 instruction(s), calls FUN_00432d1a, ends with forward jump to 0x0042983d
    push 0x0                                     # 004297e2
    push 0x1                                     # 004297e4
    mov ax, word ptr [ebp - local_11c]           # 004297e6
    push eax                                     # 004297ed
    call FUN_00432d1a                            # 004297ee
    add esp, 0xc                                 # 004297f3
    jmp.d8 L_0042983d                            # 004297f6
L_004297f8:
    # block 0x004297f8: entered by je at 0x004297e0, 6 instruction(s), ends with jne to 0x0042983d (forward)
    movsx ecx, word ptr [ebp - local_11c]        # 004297f8
    imul ecx, ecx, 0x8d                          # 004297ff
    {load} xor edx, edx                          # 00429805
    mov dl, byte ptr [ecx + 0x5bb5e4]            # 00429807
    cmp edx, 0x2                                 # 0042980d
    jne.d8 L_0042983d                            # 00429810
    # block 0x00429812: entered by fall-through of jne at 0x00429810, 6 instruction(s), falls into the block at 0x0042983d
    movsx eax, word ptr [ebp - local_11c]        # 00429812
    imul eax, eax, 0x8d                          # 00429819
    mov byte ptr [eax + 0x5bb625], 0x0           # 0042981f
    movsx ecx, word ptr [ebp - local_11c]        # 00429826
    imul ecx, ecx, 0x8d                          # 0042982d
    mov dword ptr [ecx + 0x5bb632], 0x0          # 00429833
L_0042983d:
    # block 0x0042983d: entered by jmp at 0x004297f6; jne at 0x00429810, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042983d
L_00429842:
    # block 0x00429842: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429cf6 (forward)
    push 0x0                                     # 00429842
    movsx edx, word ptr [ebp - local_11c]        # 00429844
    imul edx, edx, 0x8d                          # 0042984b
    add edx, 0x5bb5e9                            # 00429851
    push edx                                     # 00429857
    mov ecx, 0x63786d                            # 00429858
    call FUN_00423f57                            # 0042985d
    test eax, eax                                # 00429862
    je.d32 L_00429cf6                            # 00429864
    # block 0x0042986a: entered by fall-through of je at 0x00429864, 79 instruction(s), ends with je to 0x00429a47 (forward)
    movsx eax, word ptr [ebp - local_11c]        # 0042986a
    imul eax, eax, 0x8d                          # 00429871
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00429877
    mov dword ptr [ebp - local_128], ecx         # 0042987d
    mov edx, dword ptr [ebp - local_128]         # 00429883
    mov ax, word ptr [edx + field_21]            # 00429889
    mov word ptr [ebp - local_124], ax           # 0042988d
    mov ecx, dword ptr [ebp - local_124]         # 00429894
    and ecx, 0xffff                              # 0042989a
    imul ecx, ecx, 0x5bb                         # 004298a0
    mov edx, dword ptr [ebp - local_128]         # 004298a6
    mov eax, dword ptr [edx + field_27]          # 004298ac
    mov dword ptr [ecx + 0x5c3b9b], eax          # 004298af
    mov ecx, dword ptr [ebp - local_128]         # 004298b5
    movsx edx, word ptr [ecx + field_2b]         # 004298bb
    mov dword ptr [ebp - local_170], edx         # 004298bf
    fild dword ptr [ebp - local_170]             # 004298c5
    fstp dword ptr [ebp - local_174]             # 004298cb
    fld dword ptr [ebp - local_174]              # 004298d1
    fdiv qword ptr [0x52c680]                    # 004298d7
    fstp dword ptr [ebp - local_178]             # 004298dd
    fld dword ptr [ebp - local_178]              # 004298e3
    mov eax, dword ptr [ebp - local_124]         # 004298e9
    and eax, 0xffff                              # 004298ef
    imul eax, eax, 0x5bb                         # 004298f4
    fstp dword ptr [eax + 0x5c3b9f]              # 004298fa
    mov ecx, dword ptr [ebp - local_128]         # 00429900
    movsx edx, word ptr [ecx + field_2d]         # 00429906
    mov dword ptr [ebp - local_17c], edx         # 0042990a
    fild dword ptr [ebp - local_17c]             # 00429910
    fstp dword ptr [ebp - local_180]             # 00429916
    fld dword ptr [ebp - local_180]              # 0042991c
    fdiv qword ptr [0x52c680]                    # 00429922
    fstp dword ptr [ebp - local_184]             # 00429928
    fld dword ptr [ebp - local_184]              # 0042992e
    mov eax, dword ptr [ebp - local_124]         # 00429934
    and eax, 0xffff                              # 0042993a
    imul eax, eax, 0x5bb                         # 0042993f
    fstp dword ptr [eax + 0x5c3ba3]              # 00429945
    mov ecx, dword ptr [ebp - local_124]         # 0042994b
    and ecx, 0xffff                              # 00429951
    imul ecx, ecx, 0x5bb                         # 00429957
    mov word ptr [ecx + 0x5c3b97], 0x7           # 0042995d
    mov edx, dword ptr [ebp - local_124]         # 00429966
    and edx, 0xffff                              # 0042996c
    imul edx, edx, 0x5bb                         # 00429972
    mov word ptr [edx + 0x5c3b99], 0x0           # 00429978
    mov eax, dword ptr [ebp - local_128]         # 00429981
    movsx ecx, word ptr [eax + field_2f]         # 00429987
    mov edx, dword ptr [ebp - local_124]         # 0042998b
    and edx, 0xffff                              # 00429991
    imul edx, edx, 0x5bb                         # 00429997
    mov dword ptr [edx + 0x5c3cda], ecx          # 0042999d
    mov eax, dword ptr [ebp - local_124]         # 004299a3
    and eax, 0xffff                              # 004299a9
    imul eax, eax, 0x5bb                         # 004299ae
    mov ecx, dword ptr [ebp - local_128]         # 004299b4
    mov edx, dword ptr [ecx + field_31]          # 004299ba
    mov dword ptr [eax + 0x5c3cde], edx          # 004299bd
    mov eax, dword ptr [ebp - local_124]         # 004299c3
    and eax, 0xffff                              # 004299c9
    imul eax, eax, 0x5bb                         # 004299ce
    mov ecx, dword ptr [ebp - local_128]         # 004299d4
    mov edx, dword ptr [ecx + field_35]          # 004299da
    mov dword ptr [eax + 0x5c3ce2], edx          # 004299dd
    mov eax, dword ptr [ebp - local_124]         # 004299e3
    and eax, 0xffff                              # 004299e9
    imul eax, eax, 0x5bb                         # 004299ee
    mov ecx, dword ptr [ebp - local_128]         # 004299f4
    mov edx, dword ptr [ecx + field_39]          # 004299fa
    mov dword ptr [eax + 0x5c3ce6], edx          # 004299fd
    mov eax, dword ptr [ebp - local_124]         # 00429a03
    and eax, 0xffff                              # 00429a09
    imul eax, eax, 0x5bb                         # 00429a0e
    fld dword ptr [eax + 0x5c3b9f]               # 00429a14
    fcomp qword ptr [0x52c598]                   # 00429a1a
    fnstsw ax                                    # 00429a20
    test ah, 0x1                                 # 00429a22
    je.d8 L_00429a47                             # 00429a25
    # block 0x00429a27: entered by fall-through of je at 0x00429a25, 6 instruction(s), ends with forward jump to 0x00429a5b
    mov ecx, dword ptr [ebp - local_124]         # 00429a27
    and ecx, 0xffff                              # 00429a2d
    imul ecx, ecx, 0x5bb                         # 00429a33
    fld dword ptr [ecx + 0x5c3b9f]               # 00429a39
    fstp qword ptr [ebp - local_18c]             # 00429a3f
    jmp.d8 L_00429a5b                            # 00429a45
L_00429a47:
    # block 0x00429a47: entered by je at 0x00429a25, 2 instruction(s), falls into the block at 0x00429a5b
    mov dword ptr [ebp - local_18c], 0x0         # 00429a47
    mov dword ptr [ebp - local_188], 0x3ff00000  # 00429a51
L_00429a5b:
    # block 0x00429a5b: entered by jmp at 0x00429a45, 15 instruction(s), ends with jne to 0x00429ac9 (forward)
    fld qword ptr [ebp - local_18c]              # 00429a5b
    fstp dword ptr [ebp - local_190]             # 00429a61
    fld dword ptr [ebp - local_190]              # 00429a67
    mov edx, dword ptr [ebp - local_124]         # 00429a6d
    and edx, 0xffff                              # 00429a73
    imul edx, edx, 0x5bb                         # 00429a79
    fstp dword ptr [edx + 0x5c3b9f]              # 00429a7f
    mov eax, dword ptr [ebp - local_124]         # 00429a85
    and eax, 0xffff                              # 00429a8b
    imul eax, eax, 0x5bb                         # 00429a90
    fld dword ptr [eax + 0x5c3b9f]               # 00429a96
    fcomp qword ptr [0x52c7b0]                   # 00429a9c
    fnstsw ax                                    # 00429aa2
    test ah, 0x41                                # 00429aa4
    jne.d8 L_00429ac9                            # 00429aa7
    # block 0x00429aa9: entered by fall-through of jne at 0x00429aa7, 6 instruction(s), ends with forward jump to 0x00429add
    mov ecx, dword ptr [ebp - local_124]         # 00429aa9
    and ecx, 0xffff                              # 00429aaf
    imul ecx, ecx, 0x5bb                         # 00429ab5
    fld dword ptr [ecx + 0x5c3b9f]               # 00429abb
    fstp qword ptr [ebp - local_198]             # 00429ac1
    jmp.d8 L_00429add                            # 00429ac7
L_00429ac9:
    # block 0x00429ac9: entered by jne at 0x00429aa7, 2 instruction(s), falls into the block at 0x00429add
    mov dword ptr [ebp - local_198], 0x0         # 00429ac9
    mov dword ptr [ebp - local_194], 0x0         # 00429ad3
L_00429add:
    # block 0x00429add: entered by jmp at 0x00429ac7, 15 instruction(s), ends with je to 0x00429b4b (forward)
    fld qword ptr [ebp - local_198]              # 00429add
    fstp dword ptr [ebp - local_19c]             # 00429ae3
    fld dword ptr [ebp - local_19c]              # 00429ae9
    mov edx, dword ptr [ebp - local_124]         # 00429aef
    and edx, 0xffff                              # 00429af5
    imul edx, edx, 0x5bb                         # 00429afb
    fstp dword ptr [edx + 0x5c3b9f]              # 00429b01
    mov eax, dword ptr [ebp - local_124]         # 00429b07
    and eax, 0xffff                              # 00429b0d
    imul eax, eax, 0x5bb                         # 00429b12
    fld dword ptr [eax + 0x5c3ba3]               # 00429b18
    fcomp qword ptr [0x52c598]                   # 00429b1e
    fnstsw ax                                    # 00429b24
    test ah, 0x1                                 # 00429b26
    je.d8 L_00429b4b                             # 00429b29
    # block 0x00429b2b: entered by fall-through of je at 0x00429b29, 6 instruction(s), ends with forward jump to 0x00429b5f
    mov ecx, dword ptr [ebp - local_124]         # 00429b2b
    and ecx, 0xffff                              # 00429b31
    imul ecx, ecx, 0x5bb                         # 00429b37
    fld dword ptr [ecx + 0x5c3ba3]               # 00429b3d
    fstp qword ptr [ebp - local_1a4]             # 00429b43
    jmp.d8 L_00429b5f                            # 00429b49
L_00429b4b:
    # block 0x00429b4b: entered by je at 0x00429b29, 2 instruction(s), falls into the block at 0x00429b5f
    mov dword ptr [ebp - local_1a4], 0x0         # 00429b4b
    mov dword ptr [ebp - local_1a0], 0x3ff00000  # 00429b55
L_00429b5f:
    # block 0x00429b5f: entered by jmp at 0x00429b49, 15 instruction(s), ends with jne to 0x00429bcd (forward)
    fld qword ptr [ebp - local_1a4]              # 00429b5f
    fstp dword ptr [ebp - local_1a8]             # 00429b65
    fld dword ptr [ebp - local_1a8]              # 00429b6b
    mov edx, dword ptr [ebp - local_124]         # 00429b71
    and edx, 0xffff                              # 00429b77
    imul edx, edx, 0x5bb                         # 00429b7d
    fstp dword ptr [edx + 0x5c3ba3]              # 00429b83
    mov eax, dword ptr [ebp - local_124]         # 00429b89
    and eax, 0xffff                              # 00429b8f
    imul eax, eax, 0x5bb                         # 00429b94
    fld dword ptr [eax + 0x5c3ba3]               # 00429b9a
    fcomp qword ptr [0x52c7b0]                   # 00429ba0
    fnstsw ax                                    # 00429ba6
    test ah, 0x41                                # 00429ba8
    jne.d8 L_00429bcd                            # 00429bab
    # block 0x00429bad: entered by fall-through of jne at 0x00429bab, 6 instruction(s), ends with forward jump to 0x00429be1
    mov ecx, dword ptr [ebp - local_124]         # 00429bad
    and ecx, 0xffff                              # 00429bb3
    imul ecx, ecx, 0x5bb                         # 00429bb9
    fld dword ptr [ecx + 0x5c3ba3]               # 00429bbf
    fstp qword ptr [ebp - local_1b0]             # 00429bc5
    jmp.d8 L_00429be1                            # 00429bcb
L_00429bcd:
    # block 0x00429bcd: entered by jne at 0x00429bab, 2 instruction(s), falls into the block at 0x00429be1
    mov dword ptr [ebp - local_1b0], 0x0         # 00429bcd
    mov dword ptr [ebp - local_1ac], 0x0         # 00429bd7
L_00429be1:
    # block 0x00429be1: entered by jmp at 0x00429bcb, 24 instruction(s), calls FUN_004fc62d, ends with je to 0x00429c5c (forward)
    fld qword ptr [ebp - local_1b0]              # 00429be1
    fstp dword ptr [ebp - local_1b4]             # 00429be7
    fld dword ptr [ebp - local_1b4]              # 00429bed
    mov edx, dword ptr [ebp - local_124]         # 00429bf3
    and edx, 0xffff                              # 00429bf9
    imul edx, edx, 0x5bb                         # 00429bff
    fstp dword ptr [edx + 0x5c3ba3]              # 00429c05
    push 0x0                                     # 00429c0b
    lea eax, [ebp - local_118]                   # 00429c0d
    push eax                                     # 00429c13
    mov ecx, dword ptr [ebp - local_128]         # 00429c14
    movsx edx, word ptr [ecx + field_25]         # 00429c1a
    push edx                                     # 00429c1e
    mov eax, dword ptr [ebp - local_128]         # 00429c1f
    push eax                                     # 00429c25
    mov cx, word ptr [ebp - local_124]           # 00429c26
    push ecx                                     # 00429c2d
    mov ecx, 0x5c3a67                            # 00429c2e
    call FUN_004fc62d                            # 00429c33
    mov edx, dword ptr [ebp - local_128]         # 00429c38
    movsx eax, word ptr [edx + field_23]         # 00429c3e
    mov dword ptr [ebp - local_1b8], eax         # 00429c42
    cmp dword ptr [ebp - local_1b8], 0x1         # 00429c48
    je.d8 L_00429c5c                             # 00429c4f
    # block 0x00429c51: entered by fall-through of je at 0x00429c4f, 2 instruction(s), ends with je to 0x00429c93 (forward)
    cmp dword ptr [ebp - local_1b8], 0x2         # 00429c51
    je.d8 L_00429c93                             # 00429c58
    # block 0x00429c5a: entered by fall-through of je at 0x00429c58, 1 instruction(s), ends with forward jump to 0x00429cca
    jmp.d8 L_00429cca                            # 00429c5a
L_00429c5c:
    # block 0x00429c5c: entered by je at 0x00429c4f, 11 instruction(s), calls FUN_004faf98, ends with forward jump to 0x00429ce2
    mov ecx, dword ptr [ebp - local_124]         # 00429c5c
    and ecx, 0xffff                              # 00429c62
    imul ecx, ecx, 0x5bb                         # 00429c68
    mov dword ptr [ecx + 0x5c3bd1], 0x0          # 00429c6e
    mov dx, word ptr [ebp - local_124]           # 00429c78
    push edx                                     # 00429c7f
    lea eax, [ebp - local_118]                   # 00429c80
    push eax                                     # 00429c86
    mov ecx, 0x5c3a67                            # 00429c87
    call FUN_004faf98                            # 00429c8c
    jmp.d8 L_00429ce2                            # 00429c91
L_00429c93:
    # block 0x00429c93: entered by je at 0x00429c58, 11 instruction(s), calls FUN_004faf98, ends with forward jump to 0x00429ce2
    mov ecx, dword ptr [ebp - local_124]         # 00429c93
    and ecx, 0xffff                              # 00429c99
    imul ecx, ecx, 0x5bb                         # 00429c9f
    mov dword ptr [ecx + 0x5c3bd1], 0x1          # 00429ca5
    mov dx, word ptr [ebp - local_124]           # 00429caf
    push edx                                     # 00429cb6
    lea eax, [ebp - local_118]                   # 00429cb7
    push eax                                     # 00429cbd
    mov ecx, 0x5c3a67                            # 00429cbe
    call FUN_004faf98                            # 00429cc3
    jmp.d8 L_00429ce2                            # 00429cc8
L_00429cca:
    # block 0x00429cca: entered by jmp at 0x00429c5a, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00429ce2
    push 0x0                                     # 00429cca
    push 0x0                                     # 00429ccc
    push 0x545698                                # 00429cce
    call FUN_0052139c                            # 00429cd3
    mov ecx, 0x5cf659                            # 00429cd8
    call FUN_004c97b4                            # 00429cdd
L_00429ce2:
    # block 0x00429ce2: entered by jmp at 0x00429c91; jmp at 0x00429cc8, 3 instruction(s), falls into the block at 0x00429cf6
    movsx ecx, word ptr [ebp - local_11c]        # 00429ce2
    imul ecx, ecx, 0x8d                          # 00429ce9
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00429cef
L_00429cf6:
    # block 0x00429cf6: entered by je at 0x00429864, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429cf6
L_00429cfb:
    # block 0x00429cfb: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429d2f (forward)
    push 0x1                                     # 00429cfb
    movsx edx, word ptr [ebp - local_11c]        # 00429cfd
    imul edx, edx, 0x8d                          # 00429d04
    add edx, 0x5bb5e9                            # 00429d0a
    push edx                                     # 00429d10
    mov ecx, 0x63786d                            # 00429d11
    call FUN_00423f57                            # 00429d16
    test eax, eax                                # 00429d1b
    je.d8 L_00429d2f                             # 00429d1d
    # block 0x00429d1f: entered by fall-through of je at 0x00429d1d, 4 instruction(s), calls FUN_0042babf, falls into the block at 0x00429d2f
    mov ax, word ptr [ebp - local_11c]           # 00429d1f
    push eax                                     # 00429d26
    call FUN_0042babf                            # 00429d27
    add esp, 0x4                                 # 00429d2c
L_00429d2f:
    # block 0x00429d2f: entered by je at 0x00429d1d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429d2f
L_00429d34:
    # block 0x00429d34: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429d6a (forward)
    push 0x0                                     # 00429d34
    movsx ecx, word ptr [ebp - local_11c]        # 00429d36
    imul ecx, ecx, 0x8d                          # 00429d3d
    add ecx, 0x5bb5e9                            # 00429d43
    push ecx                                     # 00429d49
    mov ecx, 0x63786d                            # 00429d4a
    call FUN_00423f57                            # 00429d4f
    test eax, eax                                # 00429d54
    je.d8 L_00429d6a                             # 00429d56
    # block 0x00429d58: entered by fall-through of je at 0x00429d56, 5 instruction(s), calls FUN_004336ad, falls into the block at 0x00429d6a
    push 0x0                                     # 00429d58
    mov dx, word ptr [ebp - local_11c]           # 00429d5a
    push edx                                     # 00429d61
    call FUN_004336ad                            # 00429d62
    add esp, 0x8                                 # 00429d67
L_00429d6a:
    # block 0x00429d6a: entered by je at 0x00429d56, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429d6a
L_00429d6f:
    # block 0x00429d6f: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429da4 (forward)
    push 0x0                                     # 00429d6f
    movsx eax, word ptr [ebp - local_11c]        # 00429d71
    imul eax, eax, 0x8d                          # 00429d78
    add eax, 0x5bb5e9                            # 00429d7e
    push eax                                     # 00429d83
    mov ecx, 0x63786d                            # 00429d84
    call FUN_00423f57                            # 00429d89
    test eax, eax                                # 00429d8e
    je.d8 L_00429da4                             # 00429d90
    # block 0x00429d92: entered by fall-through of je at 0x00429d90, 5 instruction(s), calls FUN_004336ad, falls into the block at 0x00429da4
    push 0x1                                     # 00429d92
    mov cx, word ptr [ebp - local_11c]           # 00429d94
    push ecx                                     # 00429d9b
    call FUN_004336ad                            # 00429d9c
    add esp, 0x8                                 # 00429da1
L_00429da4:
    # block 0x00429da4: entered by je at 0x00429d90, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429da4
L_00429da9:
    # block 0x00429da9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429e07 (forward)
    push 0x0                                     # 00429da9
    movsx edx, word ptr [ebp - local_11c]        # 00429dab
    imul edx, edx, 0x8d                          # 00429db2
    add edx, 0x5bb5e9                            # 00429db8
    push edx                                     # 00429dbe
    mov ecx, 0x63786d                            # 00429dbf
    call FUN_00423f57                            # 00429dc4
    test eax, eax                                # 00429dc9
    je.d8 L_00429e07                             # 00429dcb
    # block 0x00429dcd: entered by fall-through of je at 0x00429dcb, 12 instruction(s), calls FUN_004fc9f1, FUN_0042ba3a, falls into the block at 0x00429e07
    movsx eax, word ptr [ebp - local_11c]        # 00429dcd
    imul eax, eax, 0x8d                          # 00429dd4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00429dda
    mov dword ptr [ebp - local_13c], ecx         # 00429de0
    mov edx, dword ptr [ebp - local_13c]         # 00429de6
    push edx                                     # 00429dec
    mov ecx, 0x5c3a67                            # 00429ded
    call FUN_004fc9f1                            # 00429df2
    mov ax, word ptr [ebp - local_11c]           # 00429df7
    push eax                                     # 00429dfe
    call FUN_0042ba3a                            # 00429dff
    add esp, 0x4                                 # 00429e04
L_00429e07:
    # block 0x00429e07: entered by je at 0x00429dcb, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429e07
L_00429e0c:
    # block 0x00429e0c: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429ed7 (forward)
    push 0x0                                     # 00429e0c
    movsx ecx, word ptr [ebp - local_11c]        # 00429e0e
    imul ecx, ecx, 0x8d                          # 00429e15
    add ecx, 0x5bb5e9                            # 00429e1b
    push ecx                                     # 00429e21
    mov ecx, 0x63786d                            # 00429e22
    call FUN_00423f57                            # 00429e27
    test eax, eax                                # 00429e2c
    je.d32 L_00429ed7                            # 00429e2e
    # block 0x00429e34: entered by fall-through of je at 0x00429e2e, 37 instruction(s), calls FUN_004fca60, FUN_0042ba3a, falls into the block at 0x00429ed7
    movsx edx, word ptr [ebp - local_11c]        # 00429e34
    imul edx, edx, 0x8d                          # 00429e3b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00429e41
    mov dword ptr [ebp - local_8], eax           # 00429e47
    mov ecx, dword ptr [ebp - local_8]           # 00429e4a
    {load} xor edx, edx                          # 00429e4d
    mov dl, byte ptr [ecx + field_2]             # 00429e4f
    mov dword ptr [ebp - local_1bc], edx         # 00429e52
    fild dword ptr [ebp - local_1bc]             # 00429e58
    fstp qword ptr [ebp - local_1c4]             # 00429e5e
    fld qword ptr [ebp - local_1c4]              # 00429e64
    fdiv qword ptr [0x52c680]                    # 00429e6a
    fstp dword ptr [ebp - local_1c8]             # 00429e70
    fld dword ptr [ebp - local_1c8]              # 00429e76
    push ecx                                     # 00429e7c
    fstp dword ptr [esp]                         # 00429e7d
    mov eax, dword ptr [ebp - local_8]           # 00429e80
    {load} xor ecx, ecx                          # 00429e83
    mov cl, byte ptr [eax + field_2]             # 00429e85
    mov dword ptr [ebp - local_1cc], ecx         # 00429e88
    fild dword ptr [ebp - local_1cc]             # 00429e8e
    fstp qword ptr [ebp - local_1d4]             # 00429e94
    fld qword ptr [ebp - local_1d4]              # 00429e9a
    fdiv qword ptr [0x52c680]                    # 00429ea0
    fstp dword ptr [ebp - local_1d8]             # 00429ea6
    fld dword ptr [ebp - local_1d8]              # 00429eac
    push ecx                                     # 00429eb2
    fstp dword ptr [esp]                         # 00429eb3
    mov edx, dword ptr [ebp - local_8]           # 00429eb6
    mov ax, word ptr [edx]                       # 00429eb9
    push eax                                     # 00429ebc
    mov ecx, 0x5c3a67                            # 00429ebd
    call FUN_004fca60                            # 00429ec2
    mov cx, word ptr [ebp - local_11c]           # 00429ec7
    push ecx                                     # 00429ece
    call FUN_0042ba3a                            # 00429ecf
    add esp, 0x4                                 # 00429ed4
L_00429ed7:
    # block 0x00429ed7: entered by je at 0x00429e2e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429ed7
L_00429edc:
    # block 0x00429edc: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429f12 (forward)
    push 0x0                                     # 00429edc
    movsx edx, word ptr [ebp - local_11c]        # 00429ede
    imul edx, edx, 0x8d                          # 00429ee5
    add edx, 0x5bb5e9                            # 00429eeb
    push edx                                     # 00429ef1
    mov ecx, 0x63786d                            # 00429ef2
    call FUN_00423f57                            # 00429ef7
    test eax, eax                                # 00429efc
    je.d8 L_00429f12                             # 00429efe
    # block 0x00429f00: entered by fall-through of je at 0x00429efe, 4 instruction(s), calls FUN_004fce5e, falls into the block at 0x00429f12
    mov ax, word ptr [ebp - local_11c]           # 00429f00
    push eax                                     # 00429f07
    mov ecx, 0x5c3a67                            # 00429f08
    call FUN_004fce5e                            # 00429f0d
L_00429f12:
    # block 0x00429f12: entered by je at 0x00429efe, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429f12
L_00429f17:
    # block 0x00429f17: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429f4b (forward)
    push 0x0                                     # 00429f17
    movsx ecx, word ptr [ebp - local_11c]        # 00429f19
    imul ecx, ecx, 0x8d                          # 00429f20
    add ecx, 0x5bb5e9                            # 00429f26
    push ecx                                     # 00429f2c
    mov ecx, 0x63786d                            # 00429f2d
    call FUN_00423f57                            # 00429f32
    test eax, eax                                # 00429f37
    je.d8 L_00429f4b                             # 00429f39
    # block 0x00429f3b: entered by fall-through of je at 0x00429f39, 4 instruction(s), calls FUN_004338bb, falls into the block at 0x00429f4b
    mov dx, word ptr [ebp - local_11c]           # 00429f3b
    push edx                                     # 00429f42
    call FUN_004338bb                            # 00429f43
    add esp, 0x4                                 # 00429f48
L_00429f4b:
    # block 0x00429f4b: entered by je at 0x00429f39, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429f4b
L_00429f50:
    # block 0x00429f50: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429f85 (forward)
    push 0x0                                     # 00429f50
    movsx eax, word ptr [ebp - local_11c]        # 00429f52
    imul eax, eax, 0x8d                          # 00429f59
    add eax, 0x5bb5e9                            # 00429f5f
    push eax                                     # 00429f64
    mov ecx, 0x63786d                            # 00429f65
    call FUN_00423f57                            # 00429f6a
    test eax, eax                                # 00429f6f
    je.d8 L_00429f85                             # 00429f71
    # block 0x00429f73: entered by fall-through of je at 0x00429f71, 4 instruction(s), calls FUN_004695f7, falls into the block at 0x00429f85
    mov cx, word ptr [ebp - local_11c]           # 00429f73
    push ecx                                     # 00429f7a
    mov ecx, 0x616ab2                            # 00429f7b
    call FUN_004695f7                            # 00429f80
L_00429f85:
    # block 0x00429f85: entered by je at 0x00429f71, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429f85
L_00429f8a:
    # block 0x00429f8a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429fc0 (forward)
    push 0x0                                     # 00429f8a
    movsx edx, word ptr [ebp - local_11c]        # 00429f8c
    imul edx, edx, 0x8d                          # 00429f93
    add edx, 0x5bb5e9                            # 00429f99
    push edx                                     # 00429f9f
    mov ecx, 0x63786d                            # 00429fa0
    call FUN_00423f57                            # 00429fa5
    test eax, eax                                # 00429faa
    je.d8 L_00429fc0                             # 00429fac
    # block 0x00429fae: entered by fall-through of je at 0x00429fac, 4 instruction(s), calls FUN_004b4a68, falls into the block at 0x00429fc0
    mov ax, word ptr [ebp - local_11c]           # 00429fae
    push eax                                     # 00429fb5
    mov ecx, 0x617066                            # 00429fb6
    call FUN_004b4a68                            # 00429fbb
L_00429fc0:
    # block 0x00429fc0: entered by je at 0x00429fac, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429fc0
L_00429fc5:
    # block 0x00429fc5: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x00429ffb (forward)
    push 0x0                                     # 00429fc5
    movsx ecx, word ptr [ebp - local_11c]        # 00429fc7
    imul ecx, ecx, 0x8d                          # 00429fce
    add ecx, 0x5bb5e9                            # 00429fd4
    push ecx                                     # 00429fda
    mov ecx, 0x63786d                            # 00429fdb
    call FUN_00423f57                            # 00429fe0
    test eax, eax                                # 00429fe5
    je.d8 L_00429ffb                             # 00429fe7
    # block 0x00429fe9: entered by fall-through of je at 0x00429fe7, 4 instruction(s), calls FUN_0045a07b, falls into the block at 0x00429ffb
    mov dx, word ptr [ebp - local_11c]           # 00429fe9
    push edx                                     # 00429ff0
    mov ecx, 0x61c7ed                            # 00429ff1
    call FUN_0045a07b                            # 00429ff6
L_00429ffb:
    # block 0x00429ffb: entered by je at 0x00429fe7, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 00429ffb
L_0042a000:
    # block 0x0042a000: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a035 (forward)
    push 0x0                                     # 0042a000
    movsx eax, word ptr [ebp - local_11c]        # 0042a002
    imul eax, eax, 0x8d                          # 0042a009
    add eax, 0x5bb5e9                            # 0042a00f
    push eax                                     # 0042a014
    mov ecx, 0x63786d                            # 0042a015
    call FUN_00423f57                            # 0042a01a
    test eax, eax                                # 0042a01f
    je.d8 L_0042a035                             # 0042a021
    # block 0x0042a023: entered by fall-through of je at 0x0042a021, 4 instruction(s), calls FUN_004a4f58, falls into the block at 0x0042a035
    mov cx, word ptr [ebp - local_11c]           # 0042a023
    push ecx                                     # 0042a02a
    mov ecx, 0x61c8cf                            # 0042a02b
    call FUN_004a4f58                            # 0042a030
L_0042a035:
    # block 0x0042a035: entered by je at 0x0042a021, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a035
L_0042a03a:
    # block 0x0042a03a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a070 (forward)
    push 0x0                                     # 0042a03a
    movsx edx, word ptr [ebp - local_11c]        # 0042a03c
    imul edx, edx, 0x8d                          # 0042a043
    add edx, 0x5bb5e9                            # 0042a049
    push edx                                     # 0042a04f
    mov ecx, 0x63786d                            # 0042a050
    call FUN_00423f57                            # 0042a055
    test eax, eax                                # 0042a05a
    je.d8 L_0042a070                             # 0042a05c
    # block 0x0042a05e: entered by fall-through of je at 0x0042a05c, 4 instruction(s), calls FUN_0048ae05, falls into the block at 0x0042a070
    mov ax, word ptr [ebp - local_11c]           # 0042a05e
    push eax                                     # 0042a065
    mov ecx, 0x61d10f                            # 0042a066
    call FUN_0048ae05                            # 0042a06b
L_0042a070:
    # block 0x0042a070: entered by je at 0x0042a05c, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a070
L_0042a075:
    # block 0x0042a075: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a0ab (forward)
    push 0x0                                     # 0042a075
    movsx ecx, word ptr [ebp - local_11c]        # 0042a077
    imul ecx, ecx, 0x8d                          # 0042a07e
    add ecx, 0x5bb5e9                            # 0042a084
    push ecx                                     # 0042a08a
    mov ecx, 0x63786d                            # 0042a08b
    call FUN_00423f57                            # 0042a090
    test eax, eax                                # 0042a095
    je.d8 L_0042a0ab                             # 0042a097
    # block 0x0042a099: entered by fall-through of je at 0x0042a097, 4 instruction(s), calls FUN_004a2180, falls into the block at 0x0042a0ab
    mov dx, word ptr [ebp - local_11c]           # 0042a099
    push edx                                     # 0042a0a0
    mov ecx, 0x61d2dd                            # 0042a0a1
    call FUN_004a2180                            # 0042a0a6
L_0042a0ab:
    # block 0x0042a0ab: entered by je at 0x0042a097, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a0ab
L_0042a0b0:
    # block 0x0042a0b0: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a0e5 (forward)
    push 0x0                                     # 0042a0b0
    movsx eax, word ptr [ebp - local_11c]        # 0042a0b2
    imul eax, eax, 0x8d                          # 0042a0b9
    add eax, 0x5bb5e9                            # 0042a0bf
    push eax                                     # 0042a0c4
    mov ecx, 0x63786d                            # 0042a0c5
    call FUN_00423f57                            # 0042a0ca
    test eax, eax                                # 0042a0cf
    je.d8 L_0042a0e5                             # 0042a0d1
    # block 0x0042a0d3: entered by fall-through of je at 0x0042a0d1, 4 instruction(s), calls FUN_004af225, falls into the block at 0x0042a0e5
    mov cx, word ptr [ebp - local_11c]           # 0042a0d3
    push ecx                                     # 0042a0da
    mov ecx, 0x6369e4                            # 0042a0db
    call FUN_004af225                            # 0042a0e0
L_0042a0e5:
    # block 0x0042a0e5: entered by je at 0x0042a0d1, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a0e5
L_0042a0ea:
    # block 0x0042a0ea: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a120 (forward)
    push 0x0                                     # 0042a0ea
    movsx edx, word ptr [ebp - local_11c]        # 0042a0ec
    imul edx, edx, 0x8d                          # 0042a0f3
    add edx, 0x5bb5e9                            # 0042a0f9
    push edx                                     # 0042a0ff
    mov ecx, 0x63786d                            # 0042a100
    call FUN_00423f57                            # 0042a105
    test eax, eax                                # 0042a10a
    je.d8 L_0042a120                             # 0042a10c
    # block 0x0042a10e: entered by fall-through of je at 0x0042a10c, 4 instruction(s), calls FUN_0048d914, falls into the block at 0x0042a120
    mov ax, word ptr [ebp - local_11c]           # 0042a10e
    push eax                                     # 0042a115
    mov ecx, 0x61d345                            # 0042a116
    call FUN_0048d914                            # 0042a11b
L_0042a120:
    # block 0x0042a120: entered by je at 0x0042a10c, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a120
L_0042a125:
    # block 0x0042a125: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a15b (forward)
    push 0x0                                     # 0042a125
    movsx ecx, word ptr [ebp - local_11c]        # 0042a127
    imul ecx, ecx, 0x8d                          # 0042a12e
    add ecx, 0x5bb5e9                            # 0042a134
    push ecx                                     # 0042a13a
    mov ecx, 0x63786d                            # 0042a13b
    call FUN_00423f57                            # 0042a140
    test eax, eax                                # 0042a145
    je.d8 L_0042a15b                             # 0042a147
    # block 0x0042a149: entered by fall-through of je at 0x0042a147, 4 instruction(s), calls FUN_004a6c61, falls into the block at 0x0042a15b
    mov dx, word ptr [ebp - local_11c]           # 0042a149
    push edx                                     # 0042a150
    mov ecx, 0x61d3a1                            # 0042a151
    call FUN_004a6c61                            # 0042a156
L_0042a15b:
    # block 0x0042a15b: entered by je at 0x0042a147, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a15b
L_0042a160:
    # block 0x0042a160: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a195 (forward)
    push 0x0                                     # 0042a160
    movsx eax, word ptr [ebp - local_11c]        # 0042a162
    imul eax, eax, 0x8d                          # 0042a169
    add eax, 0x5bb5e9                            # 0042a16f
    push eax                                     # 0042a174
    mov ecx, 0x63786d                            # 0042a175
    call FUN_00423f57                            # 0042a17a
    test eax, eax                                # 0042a17f
    je.d8 L_0042a195                             # 0042a181
    # block 0x0042a183: entered by fall-through of je at 0x0042a181, 4 instruction(s), calls FUN_004b64a9, falls into the block at 0x0042a195
    mov cx, word ptr [ebp - local_11c]           # 0042a183
    push ecx                                     # 0042a18a
    mov ecx, 0x61d449                            # 0042a18b
    call FUN_004b64a9                            # 0042a190
L_0042a195:
    # block 0x0042a195: entered by je at 0x0042a181, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a195
L_0042a19a:
    # block 0x0042a19a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a1d0 (forward)
    push 0x0                                     # 0042a19a
    movsx edx, word ptr [ebp - local_11c]        # 0042a19c
    imul edx, edx, 0x8d                          # 0042a1a3
    add edx, 0x5bb5e9                            # 0042a1a9
    push edx                                     # 0042a1af
    mov ecx, 0x63786d                            # 0042a1b0
    call FUN_00423f57                            # 0042a1b5
    test eax, eax                                # 0042a1ba
    je.d8 L_0042a1d0                             # 0042a1bc
    # block 0x0042a1be: entered by fall-through of je at 0x0042a1bc, 4 instruction(s), calls FUN_004aba6d, falls into the block at 0x0042a1d0
    mov ax, word ptr [ebp - local_11c]           # 0042a1be
    push eax                                     # 0042a1c5
    mov ecx, 0x61d6c1                            # 0042a1c6
    call FUN_004aba6d                            # 0042a1cb
L_0042a1d0:
    # block 0x0042a1d0: entered by je at 0x0042a1bc, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a1d0
L_0042a1d5:
    # block 0x0042a1d5: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a20b (forward)
    push 0x0                                     # 0042a1d5
    movsx ecx, word ptr [ebp - local_11c]        # 0042a1d7
    imul ecx, ecx, 0x8d                          # 0042a1de
    add ecx, 0x5bb5e9                            # 0042a1e4
    push ecx                                     # 0042a1ea
    mov ecx, 0x63786d                            # 0042a1eb
    call FUN_00423f57                            # 0042a1f0
    test eax, eax                                # 0042a1f5
    je.d8 L_0042a20b                             # 0042a1f7
    # block 0x0042a1f9: entered by fall-through of je at 0x0042a1f7, 4 instruction(s), calls FUN_004662d8, falls into the block at 0x0042a20b
    mov dx, word ptr [ebp - local_11c]           # 0042a1f9
    push edx                                     # 0042a200
    mov ecx, 0x61d723                            # 0042a201
    call FUN_004662d8                            # 0042a206
L_0042a20b:
    # block 0x0042a20b: entered by je at 0x0042a1f7, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a20b
L_0042a210:
    # block 0x0042a210: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a245 (forward)
    push 0x0                                     # 0042a210
    movsx eax, word ptr [ebp - local_11c]        # 0042a212
    imul eax, eax, 0x8d                          # 0042a219
    add eax, 0x5bb5e9                            # 0042a21f
    push eax                                     # 0042a224
    mov ecx, 0x63786d                            # 0042a225
    call FUN_00423f57                            # 0042a22a
    test eax, eax                                # 0042a22f
    je.d8 L_0042a245                             # 0042a231
    # block 0x0042a233: entered by fall-through of je at 0x0042a231, 4 instruction(s), calls FUN_00463392, falls into the block at 0x0042a245
    mov cx, word ptr [ebp - local_11c]           # 0042a233
    push ecx                                     # 0042a23a
    mov ecx, 0x61d779                            # 0042a23b
    call FUN_00463392                            # 0042a240
L_0042a245:
    # block 0x0042a245: entered by je at 0x0042a231, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a245
L_0042a24a:
    # block 0x0042a24a: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a280 (forward)
    push 0x0                                     # 0042a24a
    movsx edx, word ptr [ebp - local_11c]        # 0042a24c
    imul edx, edx, 0x8d                          # 0042a253
    add edx, 0x5bb5e9                            # 0042a259
    push edx                                     # 0042a25f
    mov ecx, 0x63786d                            # 0042a260
    call FUN_00423f57                            # 0042a265
    test eax, eax                                # 0042a26a
    je.d8 L_0042a280                             # 0042a26c
    # block 0x0042a26e: entered by fall-through of je at 0x0042a26c, 4 instruction(s), calls FUN_00488319, falls into the block at 0x0042a280
    mov ax, word ptr [ebp - local_11c]           # 0042a26e
    push eax                                     # 0042a275
    mov ecx, 0x61d7d8                            # 0042a276
    call FUN_00488319                            # 0042a27b
L_0042a280:
    # block 0x0042a280: entered by je at 0x0042a26c, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a280
L_0042a285:
    # block 0x0042a285: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a2bb (forward)
    push 0x0                                     # 0042a285
    movsx ecx, word ptr [ebp - local_11c]        # 0042a287
    imul ecx, ecx, 0x8d                          # 0042a28e
    add ecx, 0x5bb5e9                            # 0042a294
    push ecx                                     # 0042a29a
    mov ecx, 0x63786d                            # 0042a29b
    call FUN_00423f57                            # 0042a2a0
    test eax, eax                                # 0042a2a5
    je.d8 L_0042a2bb                             # 0042a2a7
    # block 0x0042a2a9: entered by fall-through of je at 0x0042a2a7, 4 instruction(s), calls FUN_004b2ce6, falls into the block at 0x0042a2bb
    mov dx, word ptr [ebp - local_11c]           # 0042a2a9
    push edx                                     # 0042a2b0
    mov ecx, 0x6204c1                            # 0042a2b1
    call FUN_004b2ce6                            # 0042a2b6
L_0042a2bb:
    # block 0x0042a2bb: entered by je at 0x0042a2a7, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a2bb
L_0042a2c0:
    # block 0x0042a2c0: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a2f7 (forward)
    push 0x0                                     # 0042a2c0
    movsx eax, word ptr [ebp - local_11c]        # 0042a2c2
    imul eax, eax, 0x8d                          # 0042a2c9
    add eax, 0x5bb5e9                            # 0042a2cf
    push eax                                     # 0042a2d4
    mov ecx, 0x63786d                            # 0042a2d5
    call FUN_00423f57                            # 0042a2da
    test eax, eax                                # 0042a2df
    je.d8 L_0042a2f7                             # 0042a2e1
    # block 0x0042a2e3: entered by fall-through of je at 0x0042a2e1, 5 instruction(s), calls FUN_00471722, falls into the block at 0x0042a2f7
    push 0x0                                     # 0042a2e3
    mov cx, word ptr [ebp - local_11c]           # 0042a2e5
    push ecx                                     # 0042a2ec
    mov ecx, 0x62387c                            # 0042a2ed
    call FUN_00471722                            # 0042a2f2
L_0042a2f7:
    # block 0x0042a2f7: entered by je at 0x0042a2e1, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a2f7
L_0042a2fc:
    # block 0x0042a2fc: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a334 (forward)
    push 0x0                                     # 0042a2fc
    movsx edx, word ptr [ebp - local_11c]        # 0042a2fe
    imul edx, edx, 0x8d                          # 0042a305
    add edx, 0x5bb5e9                            # 0042a30b
    push edx                                     # 0042a311
    mov ecx, 0x63786d                            # 0042a312
    call FUN_00423f57                            # 0042a317
    test eax, eax                                # 0042a31c
    je.d8 L_0042a334                             # 0042a31e
    # block 0x0042a320: entered by fall-through of je at 0x0042a31e, 5 instruction(s), calls FUN_00471722, falls into the block at 0x0042a334
    push 0x1                                     # 0042a320
    mov ax, word ptr [ebp - local_11c]           # 0042a322
    push eax                                     # 0042a329
    mov ecx, 0x62387c                            # 0042a32a
    call FUN_00471722                            # 0042a32f
L_0042a334:
    # block 0x0042a334: entered by je at 0x0042a31e, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a334
L_0042a339:
    # block 0x0042a339: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a36f (forward)
    push 0x0                                     # 0042a339
    movsx ecx, word ptr [ebp - local_11c]        # 0042a33b
    imul ecx, ecx, 0x8d                          # 0042a342
    add ecx, 0x5bb5e9                            # 0042a348
    push ecx                                     # 0042a34e
    mov ecx, 0x63786d                            # 0042a34f
    call FUN_00423f57                            # 0042a354
    test eax, eax                                # 0042a359
    je.d8 L_0042a36f                             # 0042a35b
    # block 0x0042a35d: entered by fall-through of je at 0x0042a35b, 4 instruction(s), calls FUN_0048c1c0, falls into the block at 0x0042a36f
    mov dx, word ptr [ebp - local_11c]           # 0042a35d
    push edx                                     # 0042a364
    mov ecx, 0x624686                            # 0042a365
    call FUN_0048c1c0                            # 0042a36a
L_0042a36f:
    # block 0x0042a36f: entered by je at 0x0042a35b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a36f
L_0042a374:
    # block 0x0042a374: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a3a9 (forward)
    push 0x0                                     # 0042a374
    movsx eax, word ptr [ebp - local_11c]        # 0042a376
    imul eax, eax, 0x8d                          # 0042a37d
    add eax, 0x5bb5e9                            # 0042a383
    push eax                                     # 0042a388
    mov ecx, 0x63786d                            # 0042a389
    call FUN_00423f57                            # 0042a38e
    test eax, eax                                # 0042a393
    je.d8 L_0042a3a9                             # 0042a395
    # block 0x0042a397: entered by fall-through of je at 0x0042a395, 4 instruction(s), calls FUN_0047d788, falls into the block at 0x0042a3a9
    mov cx, word ptr [ebp - local_11c]           # 0042a397
    push ecx                                     # 0042a39e
    mov ecx, 0x6246dc                            # 0042a39f
    call FUN_0047d788                            # 0042a3a4
L_0042a3a9:
    # block 0x0042a3a9: entered by je at 0x0042a395, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a3a9
L_0042a3ae:
    # block 0x0042a3ae: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a3e4 (forward)
    push 0x0                                     # 0042a3ae
    movsx edx, word ptr [ebp - local_11c]        # 0042a3b0
    imul edx, edx, 0x8d                          # 0042a3b7
    add edx, 0x5bb5e9                            # 0042a3bd
    push edx                                     # 0042a3c3
    mov ecx, 0x63786d                            # 0042a3c4
    call FUN_00423f57                            # 0042a3c9
    test eax, eax                                # 0042a3ce
    je.d8 L_0042a3e4                             # 0042a3d0
    # block 0x0042a3d2: entered by fall-through of je at 0x0042a3d0, 4 instruction(s), calls FUN_0047a416, falls into the block at 0x0042a3e4
    mov ax, word ptr [ebp - local_11c]           # 0042a3d2
    push eax                                     # 0042a3d9
    mov ecx, 0x621a02                            # 0042a3da
    call FUN_0047a416                            # 0042a3df
L_0042a3e4:
    # block 0x0042a3e4: entered by je at 0x0042a3d0, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a3e4
L_0042a3e9:
    # block 0x0042a3e9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a41f (forward)
    push 0x0                                     # 0042a3e9
    movsx ecx, word ptr [ebp - local_11c]        # 0042a3eb
    imul ecx, ecx, 0x8d                          # 0042a3f2
    add ecx, 0x5bb5e9                            # 0042a3f8
    push ecx                                     # 0042a3fe
    mov ecx, 0x63786d                            # 0042a3ff
    call FUN_00423f57                            # 0042a404
    test eax, eax                                # 0042a409
    je.d8 L_0042a41f                             # 0042a40b
    # block 0x0042a40d: entered by fall-through of je at 0x0042a40b, 4 instruction(s), calls FUN_00476a25, falls into the block at 0x0042a41f
    mov dx, word ptr [ebp - local_11c]           # 0042a40d
    push edx                                     # 0042a414
    mov ecx, 0x622fa2                            # 0042a415
    call FUN_00476a25                            # 0042a41a
L_0042a41f:
    # block 0x0042a41f: entered by je at 0x0042a40b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a41f
L_0042a424:
    # block 0x0042a424: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a459 (forward)
    push 0x0                                     # 0042a424
    movsx eax, word ptr [ebp - local_11c]        # 0042a426
    imul eax, eax, 0x8d                          # 0042a42d
    add eax, 0x5bb5e9                            # 0042a433
    push eax                                     # 0042a438
    mov ecx, 0x63786d                            # 0042a439
    call FUN_00423f57                            # 0042a43e
    test eax, eax                                # 0042a443
    je.d8 L_0042a459                             # 0042a445
    # block 0x0042a447: entered by fall-through of je at 0x0042a445, 4 instruction(s), calls FUN_0045c18f, falls into the block at 0x0042a459
    mov cx, word ptr [ebp - local_11c]           # 0042a447
    push ecx                                     # 0042a44e
    mov ecx, 0x624734                            # 0042a44f
    call FUN_0045c18f                            # 0042a454
L_0042a459:
    # block 0x0042a459: entered by je at 0x0042a445, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a459
L_0042a45e:
    # block 0x0042a45e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a494 (forward)
    push 0x0                                     # 0042a45e
    movsx edx, word ptr [ebp - local_11c]        # 0042a460
    imul edx, edx, 0x8d                          # 0042a467
    add edx, 0x5bb5e9                            # 0042a46d
    push edx                                     # 0042a473
    mov ecx, 0x63786d                            # 0042a474
    call FUN_00423f57                            # 0042a479
    test eax, eax                                # 0042a47e
    je.d8 L_0042a494                             # 0042a480
    # block 0x0042a482: entered by fall-through of je at 0x0042a480, 4 instruction(s), calls FUN_0045764a, falls into the block at 0x0042a494
    mov ax, word ptr [ebp - local_11c]           # 0042a482
    push eax                                     # 0042a489
    mov ecx, 0x6248ed                            # 0042a48a
    call FUN_0045764a                            # 0042a48f
L_0042a494:
    # block 0x0042a494: entered by je at 0x0042a480, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a494
L_0042a499:
    # block 0x0042a499: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a4cf (forward)
    push 0x0                                     # 0042a499
    movsx ecx, word ptr [ebp - local_11c]        # 0042a49b
    imul ecx, ecx, 0x8d                          # 0042a4a2
    add ecx, 0x5bb5e9                            # 0042a4a8
    push ecx                                     # 0042a4ae
    mov ecx, 0x63786d                            # 0042a4af
    call FUN_00423f57                            # 0042a4b4
    test eax, eax                                # 0042a4b9
    je.d8 L_0042a4cf                             # 0042a4bb
    # block 0x0042a4bd: entered by fall-through of je at 0x0042a4bb, 4 instruction(s), calls FUN_0044efcd, falls into the block at 0x0042a4cf
    mov dx, word ptr [ebp - local_11c]           # 0042a4bd
    push edx                                     # 0042a4c4
    mov ecx, 0x624931                            # 0042a4c5
    call FUN_0044efcd                            # 0042a4ca
L_0042a4cf:
    # block 0x0042a4cf: entered by je at 0x0042a4bb, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a4cf
L_0042a4d4:
    # block 0x0042a4d4: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a509 (forward)
    push 0x0                                     # 0042a4d4
    movsx eax, word ptr [ebp - local_11c]        # 0042a4d6
    imul eax, eax, 0x8d                          # 0042a4dd
    add eax, 0x5bb5e9                            # 0042a4e3
    push eax                                     # 0042a4e8
    mov ecx, 0x63786d                            # 0042a4e9
    call FUN_00423f57                            # 0042a4ee
    test eax, eax                                # 0042a4f3
    je.d8 L_0042a509                             # 0042a4f5
    # block 0x0042a4f7: entered by fall-through of je at 0x0042a4f5, 4 instruction(s), calls FUN_004b777d, falls into the block at 0x0042a509
    mov cx, word ptr [ebp - local_11c]           # 0042a4f7
    push ecx                                     # 0042a4fe
    mov ecx, 0x6249a0                            # 0042a4ff
    call FUN_004b777d                            # 0042a504
L_0042a509:
    # block 0x0042a509: entered by je at 0x0042a4f5, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a509
L_0042a50e:
    # block 0x0042a50e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a544 (forward)
    push 0x0                                     # 0042a50e
    movsx edx, word ptr [ebp - local_11c]        # 0042a510
    imul edx, edx, 0x8d                          # 0042a517
    add edx, 0x5bb5e9                            # 0042a51d
    push edx                                     # 0042a523
    mov ecx, 0x63786d                            # 0042a524
    call FUN_00423f57                            # 0042a529
    test eax, eax                                # 0042a52e
    je.d8 L_0042a544                             # 0042a530
    # block 0x0042a532: entered by fall-through of je at 0x0042a530, 4 instruction(s), calls FUN_00455cc3, falls into the block at 0x0042a544
    mov ax, word ptr [ebp - local_11c]           # 0042a532
    push eax                                     # 0042a539
    mov ecx, 0x6249dc                            # 0042a53a
    call FUN_00455cc3                            # 0042a53f
L_0042a544:
    # block 0x0042a544: entered by je at 0x0042a530, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a544
L_0042a549:
    # block 0x0042a549: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a57f (forward)
    push 0x0                                     # 0042a549
    movsx ecx, word ptr [ebp - local_11c]        # 0042a54b
    imul ecx, ecx, 0x8d                          # 0042a552
    add ecx, 0x5bb5e9                            # 0042a558
    push ecx                                     # 0042a55e
    mov ecx, 0x63786d                            # 0042a55f
    call FUN_00423f57                            # 0042a564
    test eax, eax                                # 0042a569
    je.d8 L_0042a57f                             # 0042a56b
    # block 0x0042a56d: entered by fall-through of je at 0x0042a56b, 4 instruction(s), calls FUN_004650db, falls into the block at 0x0042a57f
    mov dx, word ptr [ebp - local_11c]           # 0042a56d
    push edx                                     # 0042a574
    mov ecx, 0x624b50                            # 0042a575
    call FUN_004650db                            # 0042a57a
L_0042a57f:
    # block 0x0042a57f: entered by je at 0x0042a56b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a57f
L_0042a584:
    # block 0x0042a584: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a5b9 (forward)
    push 0x0                                     # 0042a584
    movsx eax, word ptr [ebp - local_11c]        # 0042a586
    imul eax, eax, 0x8d                          # 0042a58d
    add eax, 0x5bb5e9                            # 0042a593
    push eax                                     # 0042a598
    mov ecx, 0x63786d                            # 0042a599
    call FUN_00423f57                            # 0042a59e
    test eax, eax                                # 0042a5a3
    je.d8 L_0042a5b9                             # 0042a5a5
    # block 0x0042a5a7: entered by fall-through of je at 0x0042a5a5, 4 instruction(s), calls FUN_0046f986, falls into the block at 0x0042a5b9
    mov cx, word ptr [ebp - local_11c]           # 0042a5a7
    push ecx                                     # 0042a5ae
    mov ecx, 0x624c2a                            # 0042a5af
    call FUN_0046f986                            # 0042a5b4
L_0042a5b9:
    # block 0x0042a5b9: entered by je at 0x0042a5a5, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a5b9
L_0042a5be:
    # block 0x0042a5be: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a5f4 (forward)
    push 0x0                                     # 0042a5be
    movsx edx, word ptr [ebp - local_11c]        # 0042a5c0
    imul edx, edx, 0x8d                          # 0042a5c7
    add edx, 0x5bb5e9                            # 0042a5cd
    push edx                                     # 0042a5d3
    mov ecx, 0x63786d                            # 0042a5d4
    call FUN_00423f57                            # 0042a5d9
    test eax, eax                                # 0042a5de
    je.d8 L_0042a5f4                             # 0042a5e0
    # block 0x0042a5e2: entered by fall-through of je at 0x0042a5e0, 4 instruction(s), calls FUN_00452576, falls into the block at 0x0042a5f4
    mov ax, word ptr [ebp - local_11c]           # 0042a5e2
    push eax                                     # 0042a5e9
    mov ecx, 0x61d873                            # 0042a5ea
    call FUN_00452576                            # 0042a5ef
L_0042a5f4:
    # block 0x0042a5f4: entered by je at 0x0042a5e0, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a5f4
L_0042a5f9:
    # block 0x0042a5f9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a62f (forward)
    push 0x0                                     # 0042a5f9
    movsx ecx, word ptr [ebp - local_11c]        # 0042a5fb
    imul ecx, ecx, 0x8d                          # 0042a602
    add ecx, 0x5bb5e9                            # 0042a608
    push ecx                                     # 0042a60e
    mov ecx, 0x63786d                            # 0042a60f
    call FUN_00423f57                            # 0042a614
    test eax, eax                                # 0042a619
    je.d8 L_0042a62f                             # 0042a61b
    # block 0x0042a61d: entered by fall-through of je at 0x0042a61b, 4 instruction(s), calls FUN_0047c0f0, falls into the block at 0x0042a62f
    mov dx, word ptr [ebp - local_11c]           # 0042a61d
    push edx                                     # 0042a624
    mov ecx, 0x61e398                            # 0042a625
    call FUN_0047c0f0                            # 0042a62a
L_0042a62f:
    # block 0x0042a62f: entered by je at 0x0042a61b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a62f
L_0042a634:
    # block 0x0042a634: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a669 (forward)
    push 0x0                                     # 0042a634
    movsx eax, word ptr [ebp - local_11c]        # 0042a636
    imul eax, eax, 0x8d                          # 0042a63d
    add eax, 0x5bb5e9                            # 0042a643
    push eax                                     # 0042a648
    mov ecx, 0x63786d                            # 0042a649
    call FUN_00423f57                            # 0042a64e
    test eax, eax                                # 0042a653
    je.d8 L_0042a669                             # 0042a655
    # block 0x0042a657: entered by fall-through of je at 0x0042a655, 4 instruction(s), calls FUN_004bca71, falls into the block at 0x0042a669
    mov cx, word ptr [ebp - local_11c]           # 0042a657
    push ecx                                     # 0042a65e
    mov ecx, 0x61df56                            # 0042a65f
    call FUN_004bca71                            # 0042a664
L_0042a669:
    # block 0x0042a669: entered by je at 0x0042a655, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a669
L_0042a66e:
    # block 0x0042a66e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a6a4 (forward)
    push 0x0                                     # 0042a66e
    movsx edx, word ptr [ebp - local_11c]        # 0042a670
    imul edx, edx, 0x8d                          # 0042a677
    add edx, 0x5bb5e9                            # 0042a67d
    push edx                                     # 0042a683
    mov ecx, 0x63786d                            # 0042a684
    call FUN_00423f57                            # 0042a689
    test eax, eax                                # 0042a68e
    je.d8 L_0042a6a4                             # 0042a690
    # block 0x0042a692: entered by fall-through of je at 0x0042a690, 4 instruction(s), calls FUN_0044da08, falls into the block at 0x0042a6a4
    mov ax, word ptr [ebp - local_11c]           # 0042a692
    push eax                                     # 0042a699
    mov ecx, 0x624cbf                            # 0042a69a
    call FUN_0044da08                            # 0042a69f
L_0042a6a4:
    # block 0x0042a6a4: entered by je at 0x0042a690, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a6a4
L_0042a6a9:
    # block 0x0042a6a9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a6df (forward)
    push 0x0                                     # 0042a6a9
    movsx ecx, word ptr [ebp - local_11c]        # 0042a6ab
    imul ecx, ecx, 0x8d                          # 0042a6b2
    add ecx, 0x5bb5e9                            # 0042a6b8
    push ecx                                     # 0042a6be
    mov ecx, 0x63786d                            # 0042a6bf
    call FUN_00423f57                            # 0042a6c4
    test eax, eax                                # 0042a6c9
    je.d8 L_0042a6df                             # 0042a6cb
    # block 0x0042a6cd: entered by fall-through of je at 0x0042a6cb, 4 instruction(s), calls FUN_00482a08, falls into the block at 0x0042a6df
    mov dx, word ptr [ebp - local_11c]           # 0042a6cd
    push edx                                     # 0042a6d4
    mov ecx, 0x624d12                            # 0042a6d5
    call FUN_00482a08                            # 0042a6da
L_0042a6df:
    # block 0x0042a6df: entered by je at 0x0042a6cb, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a6df
L_0042a6e4:
    # block 0x0042a6e4: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a719 (forward)
    push 0x0                                     # 0042a6e4
    movsx eax, word ptr [ebp - local_11c]        # 0042a6e6
    imul eax, eax, 0x8d                          # 0042a6ed
    add eax, 0x5bb5e9                            # 0042a6f3
    push eax                                     # 0042a6f8
    mov ecx, 0x63786d                            # 0042a6f9
    call FUN_00423f57                            # 0042a6fe
    test eax, eax                                # 0042a703
    je.d8 L_0042a719                             # 0042a705
    # block 0x0042a707: entered by fall-through of je at 0x0042a705, 4 instruction(s), calls FUN_0048f181, falls into the block at 0x0042a719
    mov cx, word ptr [ebp - local_11c]           # 0042a707
    push ecx                                     # 0042a70e
    mov ecx, 0x624dc9                            # 0042a70f
    call FUN_0048f181                            # 0042a714
L_0042a719:
    # block 0x0042a719: entered by je at 0x0042a705, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a719
L_0042a71e:
    # block 0x0042a71e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a754 (forward)
    push 0x0                                     # 0042a71e
    movsx edx, word ptr [ebp - local_11c]        # 0042a720
    imul edx, edx, 0x8d                          # 0042a727
    add edx, 0x5bb5e9                            # 0042a72d
    push edx                                     # 0042a733
    mov ecx, 0x63786d                            # 0042a734
    call FUN_00423f57                            # 0042a739
    test eax, eax                                # 0042a73e
    je.d8 L_0042a754                             # 0042a740
    # block 0x0042a742: entered by fall-through of je at 0x0042a740, 4 instruction(s), calls FUN_004aa81e, falls into the block at 0x0042a754
    mov ax, word ptr [ebp - local_11c]           # 0042a742
    push eax                                     # 0042a749
    mov ecx, 0x630a34                            # 0042a74a
    call FUN_004aa81e                            # 0042a74f
L_0042a754:
    # block 0x0042a754: entered by je at 0x0042a740, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a754
L_0042a759:
    # block 0x0042a759: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a78f (forward)
    push 0x0                                     # 0042a759
    movsx ecx, word ptr [ebp - local_11c]        # 0042a75b
    imul ecx, ecx, 0x8d                          # 0042a762
    add ecx, 0x5bb5e9                            # 0042a768
    push ecx                                     # 0042a76e
    mov ecx, 0x63786d                            # 0042a76f
    call FUN_00423f57                            # 0042a774
    test eax, eax                                # 0042a779
    je.d8 L_0042a78f                             # 0042a77b
    # block 0x0042a77d: entered by fall-through of je at 0x0042a77b, 4 instruction(s), calls FUN_004867bd, falls into the block at 0x0042a78f
    mov dx, word ptr [ebp - local_11c]           # 0042a77d
    push edx                                     # 0042a784
    mov ecx, 0x6252ad                            # 0042a785
    call FUN_004867bd                            # 0042a78a
L_0042a78f:
    # block 0x0042a78f: entered by je at 0x0042a77b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a78f
L_0042a794:
    # block 0x0042a794: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a7c9 (forward)
    push 0x0                                     # 0042a794
    movsx eax, word ptr [ebp - local_11c]        # 0042a796
    imul eax, eax, 0x8d                          # 0042a79d
    add eax, 0x5bb5e9                            # 0042a7a3
    push eax                                     # 0042a7a8
    mov ecx, 0x63786d                            # 0042a7a9
    call FUN_00423f57                            # 0042a7ae
    test eax, eax                                # 0042a7b3
    je.d8 L_0042a7c9                             # 0042a7b5
    # block 0x0042a7b7: entered by fall-through of je at 0x0042a7b5, 4 instruction(s), calls FUN_00480e02, falls into the block at 0x0042a7c9
    mov cx, word ptr [ebp - local_11c]           # 0042a7b7
    push ecx                                     # 0042a7be
    mov ecx, 0x625ee8                            # 0042a7bf
    call FUN_00480e02                            # 0042a7c4
L_0042a7c9:
    # block 0x0042a7c9: entered by je at 0x0042a7b5, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a7c9
L_0042a7ce:
    # block 0x0042a7ce: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a804 (forward)
    push 0x0                                     # 0042a7ce
    movsx edx, word ptr [ebp - local_11c]        # 0042a7d0
    imul edx, edx, 0x8d                          # 0042a7d7
    add edx, 0x5bb5e9                            # 0042a7dd
    push edx                                     # 0042a7e3
    mov ecx, 0x63786d                            # 0042a7e4
    call FUN_00423f57                            # 0042a7e9
    test eax, eax                                # 0042a7ee
    je.d8 L_0042a804                             # 0042a7f0
    # block 0x0042a7f2: entered by fall-through of je at 0x0042a7f0, 4 instruction(s), calls FUN_004a8d28, falls into the block at 0x0042a804
    mov ax, word ptr [ebp - local_11c]           # 0042a7f2
    push eax                                     # 0042a7f9
    mov ecx, 0x627335                            # 0042a7fa
    call FUN_004a8d28                            # 0042a7ff
L_0042a804:
    # block 0x0042a804: entered by je at 0x0042a7f0, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a804
L_0042a809:
    # block 0x0042a809: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a83f (forward)
    push 0x0                                     # 0042a809
    movsx ecx, word ptr [ebp - local_11c]        # 0042a80b
    imul ecx, ecx, 0x8d                          # 0042a812
    add ecx, 0x5bb5e9                            # 0042a818
    push ecx                                     # 0042a81e
    mov ecx, 0x63786d                            # 0042a81f
    call FUN_00423f57                            # 0042a824
    test eax, eax                                # 0042a829
    je.d8 L_0042a83f                             # 0042a82b
    # block 0x0042a82d: entered by fall-through of je at 0x0042a82b, 4 instruction(s), calls FUN_0046cda0, falls into the block at 0x0042a83f
    mov dx, word ptr [ebp - local_11c]           # 0042a82d
    push edx                                     # 0042a834
    mov ecx, 0x628732                            # 0042a835
    call FUN_0046cda0                            # 0042a83a
L_0042a83f:
    # block 0x0042a83f: entered by je at 0x0042a82b, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a83f
L_0042a844:
    # block 0x0042a844: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a879 (forward)
    push 0x0                                     # 0042a844
    movsx eax, word ptr [ebp - local_11c]        # 0042a846
    imul eax, eax, 0x8d                          # 0042a84d
    add eax, 0x5bb5e9                            # 0042a853
    push eax                                     # 0042a858
    mov ecx, 0x63786d                            # 0042a859
    call FUN_00423f57                            # 0042a85e
    test eax, eax                                # 0042a863
    je.d8 L_0042a879                             # 0042a865
    # block 0x0042a867: entered by fall-through of je at 0x0042a865, 4 instruction(s), calls FUN_00467fcd, falls into the block at 0x0042a879
    mov cx, word ptr [ebp - local_11c]           # 0042a867
    push ecx                                     # 0042a86e
    mov ecx, 0x61e65c                            # 0042a86f
    call FUN_00467fcd                            # 0042a874
L_0042a879:
    # block 0x0042a879: entered by je at 0x0042a865, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a879
L_0042a87e:
    # block 0x0042a87e: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a8b4 (forward)
    push 0x0                                     # 0042a87e
    movsx edx, word ptr [ebp - local_11c]        # 0042a880
    imul edx, edx, 0x8d                          # 0042a887
    add edx, 0x5bb5e9                            # 0042a88d
    push edx                                     # 0042a893
    mov ecx, 0x63786d                            # 0042a894
    call FUN_00423f57                            # 0042a899
    test eax, eax                                # 0042a89e
    je.d8 L_0042a8b4                             # 0042a8a0
    # block 0x0042a8a2: entered by fall-through of je at 0x0042a8a0, 4 instruction(s), calls FUN_0047428c, falls into the block at 0x0042a8b4
    mov ax, word ptr [ebp - local_11c]           # 0042a8a2
    push eax                                     # 0042a8a9
    mov ecx, 0x61e95c                            # 0042a8aa
    call FUN_0047428c                            # 0042a8af
L_0042a8b4:
    # block 0x0042a8b4: entered by je at 0x0042a8a0, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a8b4
L_0042a8b9:
    # block 0x0042a8b9: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a8ef (forward)
    push 0x0                                     # 0042a8b9
    movsx ecx, word ptr [ebp - local_11c]        # 0042a8bb
    imul ecx, ecx, 0x8d                          # 0042a8c2
    add ecx, 0x5bb5e9                            # 0042a8c8
    push ecx                                     # 0042a8ce
    mov ecx, 0x63786d                            # 0042a8cf
    call FUN_00423f57                            # 0042a8d4
    test eax, eax                                # 0042a8d9
    je.d8 L_0042a8ef                             # 0042a8db
    # block 0x0042a8dd: entered by fall-through of je at 0x0042a8db, 4 instruction(s), calls FUN_00458e55, falls into the block at 0x0042a8ef
    mov dx, word ptr [ebp - local_11c]           # 0042a8dd
    push edx                                     # 0042a8e4
    mov ecx, 0x61ed7b                            # 0042a8e5
    call FUN_00458e55                            # 0042a8ea
L_0042a8ef:
    # block 0x0042a8ef: entered by je at 0x0042a8db, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d32 L_0042a9a9                           # 0042a8ef
L_0042a8f4:
    # block 0x0042a8f4: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a929 (forward)
    push 0x0                                     # 0042a8f4
    movsx eax, word ptr [ebp - local_11c]        # 0042a8f6
    imul eax, eax, 0x8d                          # 0042a8fd
    add eax, 0x5bb5e9                            # 0042a903
    push eax                                     # 0042a908
    mov ecx, 0x63786d                            # 0042a909
    call FUN_00423f57                            # 0042a90e
    test eax, eax                                # 0042a913
    je.d8 L_0042a929                             # 0042a915
    # block 0x0042a917: entered by fall-through of je at 0x0042a915, 4 instruction(s), calls FUN_004b8e92, falls into the block at 0x0042a929
    mov cx, word ptr [ebp - local_11c]           # 0042a917
    push ecx                                     # 0042a91e
    mov ecx, 0x61ee6e                            # 0042a91f
    call FUN_004b8e92                            # 0042a924
L_0042a929:
    # block 0x0042a929: entered by je at 0x0042a915, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d8 L_0042a9a9                            # 0042a929
L_0042a92b:
    # block 0x0042a92b: entered by switch case, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0042a961 (forward)
    push 0x0                                     # 0042a92b
    movsx edx, word ptr [ebp - local_11c]        # 0042a92d
    imul edx, edx, 0x8d                          # 0042a934
    add edx, 0x5bb5e9                            # 0042a93a
    push edx                                     # 0042a940
    mov ecx, 0x63786d                            # 0042a941
    call FUN_00423f57                            # 0042a946
    test eax, eax                                # 0042a94b
    je.d8 L_0042a961                             # 0042a94d
    # block 0x0042a94f: entered by fall-through of je at 0x0042a94d, 4 instruction(s), calls FUN_0045f0e6, falls into the block at 0x0042a961
    mov ax, word ptr [ebp - local_11c]           # 0042a94f
    push eax                                     # 0042a956
    mov ecx, 0x61f4b1                            # 0042a957
    call FUN_0045f0e6                            # 0042a95c
L_0042a961:
    # block 0x0042a961: entered by je at 0x0042a94d, 1 instruction(s), ends with forward jump to 0x0042a9a9
    jmp.d8 L_0042a9a9                            # 0042a961
L_0042a963:
    # block 0x0042a963: entered by ja at 0x00427b18; switch case, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0042a9a9
    movsx ecx, word ptr [ebp - local_11c]        # 0042a963
    imul ecx, ecx, 0x8d                          # 0042a96a
    {load} xor edx, edx                          # 0042a970
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0042a972
    push edx                                     # 0042a978
    push 0x5456e0                                # 0042a979
    push 0x63888b                                # 0042a97e
    call FUN_0050ca3e                            # 0042a983
    add esp, 0xc                                 # 0042a988
    push 0x63888b                                # 0042a98b
    push 0x5456e8                                # 0042a990
    mov ecx, 0x583979                            # 0042a995
    call FUN_0042639d                            # 0042a99a
    mov ecx, 0x5cf659                            # 0042a99f
    call FUN_004c97b4                            # 0042a9a4
L_0042a9a9:
    # block 0x0042a9a9: entered by jmp at 0x00427b66; jmp at 0x00427b9f; jmp at 0x00427bd8; jmp at 0x00427c10; more, 1 instruction(s), ends with backward jump to 0x00427a66
    jmp.d32 L_00427a66                           # 0042a9a9
L_0042a9ae:
    # block 0x0042a9ae: entered by jge at 0x00427a88; jmp at 0x00427a97, 5 instruction(s), ends with ret
    pop edi                                      # 0042a9ae
    pop esi                                      # 0042a9af
    {load} mov esp, ebp                          # 0042a9b0
    pop ebp                                      # 0042a9b2
    ret                                          # 0042a9b3

# --- data items (not part of the function) -------------------------
.org 0x0042a9b4 - 0x401000
SWTAB_0042a9b4:  # 124 case address(es)
    .long L_00427cfc - .text + 0x401000
    .long L_00427ba4 - .text + 0x401000
    .long L_00427c4e - .text + 0x401000
    .long L_00427b33 - .text + 0x401000
    .long L_00427b6b - .text + 0x401000
    .long L_00427bdd - .text + 0x401000
    .long L_00427c15 - .text + 0x401000
    .long L_00427e11 - .text + 0x401000
    .long L_00427c87 - .text + 0x401000
    .long L_00427cc1 - .text + 0x401000
    .long L_00429324 - .text + 0x401000
    .long L_00427e49 - .text + 0x401000
    .long L_00427e96 - .text + 0x401000
    .long L_00429373 - .text + 0x401000
    .long L_00427eed - .text + 0x401000
    .long L_00427f27 - .text + 0x401000
    .long L_00427f62 - .text + 0x401000
    .long L_00427fd7 - .text + 0x401000
    .long L_00428010 - .text + 0x401000
    .long L_00428049 - .text + 0x401000
    .long L_00428083 - .text + 0x401000
    .long L_00427f9d - .text + 0x401000
    .long L_00428465 - .text + 0x401000
    .long L_0042849f - .text + 0x401000
    .long L_004287cc - .text + 0x401000
    .long L_004284da - .text + 0x401000
    .long L_00428515 - .text + 0x401000
    .long L_0042854f - .text + 0x401000
    .long L_0042858a - .text + 0x401000
    .long L_0042816e - .text + 0x401000
    .long L_0042842c - .text + 0x401000
    .long L_004280be - .text + 0x401000
    .long L_004280f9 - .text + 0x401000
    .long L_00428133 - .text + 0x401000
    .long L_004281d3 - .text + 0x401000
    .long L_00428e32 - .text + 0x401000
    .long L_00428d44 - .text + 0x401000
    .long L_00428d0c - .text + 0x401000
    .long L_004285c5 - .text + 0x401000
    .long L_004285fd - .text + 0x401000
    .long L_0042864b - .text + 0x401000
    .long L_00428692 - .text + 0x401000
    .long L_004286d8 - .text + 0x401000
    .long L_0042875d - .text + 0x401000
    .long L_00428cd3 - .text + 0x401000
    .long L_00429065 - .text + 0x401000
    .long L_004290c0 - .text + 0x401000
    .long L_0042916f - .text + 0x401000
    .long L_004291b6 - .text + 0x401000
    .long L_004291f8 - .text + 0x401000
    .long L_00429275 - .text + 0x401000
    .long L_00428f4a - .text + 0x401000
    .long L_00428f82 - .text + 0x401000
    .long L_00428fbb - .text + 0x401000
    .long L_00428ff4 - .text + 0x401000
    .long L_0042902c - .text + 0x401000
    .long L_00428f11 - .text + 0x401000
    .long L_0042944b - .text + 0x401000
    .long L_00429486 - .text + 0x401000
    .long L_00429596 - .text + 0x401000
    .long L_004295d0 - .text + 0x401000
    .long L_004294c0 - .text + 0x401000
    .long L_0042950b - .text + 0x401000
    .long L_0042955b - .text + 0x401000
    .long L_0042960b - .text + 0x401000
    .long L_0042965a - .text + 0x401000
    .long L_004296a9 - .text + 0x401000
    .long L_004296f8 - .text + 0x401000
    .long L_00429da9 - .text + 0x401000
    .long L_00429747 - .text + 0x401000
    .long L_00429e0c - .text + 0x401000
    .long L_00429782 - .text + 0x401000
    .long L_00429842 - .text + 0x401000
    .long L_00429cfb - .text + 0x401000
    .long L_00429d34 - .text + 0x401000
    .long L_00429d6f - .text + 0x401000
    .long L_00429edc - .text + 0x401000
    .long L_004297be - .text + 0x401000
    .long L_00429f17 - .text + 0x401000
    .long L_0042a66e - .text + 0x401000
    .long L_00429f50 - .text + 0x401000
    .long L_00429f8a - .text + 0x401000
    .long L_00429fc5 - .text + 0x401000
    .long L_0042a000 - .text + 0x401000
    .long L_0042a03a - .text + 0x401000
    .long L_0042a075 - .text + 0x401000
    .long L_0042a0b0 - .text + 0x401000
    .long L_0042a0ea - .text + 0x401000
    .long L_0042a160 - .text + 0x401000
    .long L_0042a125 - .text + 0x401000
    .long L_0042a210 - .text + 0x401000
    .long L_0042a24a - .text + 0x401000
    .long L_0042a285 - .text + 0x401000
    .long L_0042a2c0 - .text + 0x401000
    .long L_0042a3ae - .text + 0x401000
    .long L_0042a339 - .text + 0x401000
    .long L_0042a374 - .text + 0x401000
    .long L_0042a424 - .text + 0x401000
    .long L_0042a45e - .text + 0x401000
    .long L_0042a4d4 - .text + 0x401000
    .long L_0042a584 - .text + 0x401000
    .long L_0042a50e - .text + 0x401000
    .long L_0042a549 - .text + 0x401000
    .long L_0042a2fc - .text + 0x401000
    .long L_0042a19a - .text + 0x401000
    .long L_0042a1d5 - .text + 0x401000
    .long L_0042a3e9 - .text + 0x401000
    .long L_0042a5be - .text + 0x401000
    .long L_0042a6a9 - .text + 0x401000
    .long L_0042a6e4 - .text + 0x401000
    .long L_0042a499 - .text + 0x401000
    .long L_0042a71e - .text + 0x401000
    .long L_0042a759 - .text + 0x401000
    .long L_0042a794 - .text + 0x401000
    .long L_0042a634 - .text + 0x401000
    .long L_0042a5f9 - .text + 0x401000
    .long L_0042a7ce - .text + 0x401000
    .long L_0042a844 - .text + 0x401000
    .long L_0042a87e - .text + 0x401000
    .long L_0042a8b9 - .text + 0x401000
    .long L_0042a809 - .text + 0x401000
    .long L_0042a8f4 - .text + 0x401000
    .long L_0042a92b - .text + 0x401000
    .long L_0042a963 - .text + 0x401000
.org 0x0042aba4 - 0x401000
IDXTAB_0042aba4:  # index table of FUN_00427a50 for the switch jump at 0x00427b2c (237 byte(s))
    .byte 0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 123, 5, 6, 6, 6
    .byte 7, 8, 9, 10, 11, 12, 13, 123, 123, 123, 123, 123, 123, 123, 14, 123
    .byte 123, 123, 123, 15, 16, 123, 123, 123, 123, 17, 18, 19, 20, 123, 123, 21
    .byte 21, 21, 21, 123, 21, 21, 123, 123, 123, 22, 23, 24, 25, 26, 27, 28
    .byte 123, 29, 30, 31, 32, 33, 123, 34, 123, 123, 123, 123, 123, 123, 123, 123
    .byte 123, 123, 123, 123, 123, 123, 35, 36, 37, 37, 38, 39, 40, 41, 42, 43
    .byte 44, 36, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58
    .byte 59, 60, 61, 62, 63, 123, 64, 65, 66, 67, 123, 123, 123, 123, 123, 123
    .byte 123, 123, 123, 123, 123, 123, 123, 123, 123, 68, 69, 70, 71, 123, 72, 73
    .byte 74, 75, 76, 77, 71, 77, 78, 77, 123, 123, 123, 123, 123, 123, 123, 123
    .byte 79, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123
    .byte 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 80, 81
    .byte 82, 83, 84, 85, 123, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96
    .byte 97, 98, 99, 100, 101, 102, 103, 104, 105, 123, 106, 107, 108, 109, 110, 111
    .byte 112, 113, 123, 114, 115, 116, 123, 117, 118, 119, 120, 121, 122
.org 0x0042ac91 - 0x401000
SWTAB_0042ac91:  # 7 case address(es)
    .long L_00428849 - .text + 0x401000
    .long L_00428871 - .text + 0x401000
    .long L_00428896 - .text + 0x401000
    .long L_004288bb - .text + 0x401000
    .long L_004289c2 - .text + 0x401000
    .long L_00428b15 - .text + 0x401000
    .long L_00428b15 - .text + 0x401000
.set SWTAB_0042a9b4_VA, SWTAB_0042a9b4 - .text + 0x401000
.set IDXTAB_0042aba4_VA, IDXTAB_0042aba4 - .text + 0x401000
.set SWTAB_0042ac91_VA, SWTAB_0042ac91 - .text + 0x401000

