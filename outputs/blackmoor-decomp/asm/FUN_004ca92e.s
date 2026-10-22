# FUN_004ca92e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ca92e
# extent:       0x004ca92e-0x004cae86 (1368 code bytes)
# span:         0x004ca92e-0x004cae90 (code 1368, tables 0, padding 10)
# sha256:       73a9e9bb42288acd2ad648c7e517ab92b2d0a61544a9e3099e5ed484ceab7d60
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ca92e_lifted
# naming:       native port src/original_methods_fl39d.c:m4ca92e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (13 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_14, field_50, field_5c, field_16c; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_40, field_58, field_16c; [edx + n] field_4, field_8, field_10, field_14, field_3c, field_54, field_16c
# callees:      calls FUN_0044a2b7, FUN_0050ca3e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ca92e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 387 instruction(s), 40 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_16c, 0x16c  # offset +0x16c

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004ca92e - 0x401000
.globl FUN_004ca92e
FUN_004ca92e:
    # block 0x004ca92e: entry, 9 instruction(s), ends with je to 0x004ca94f (forward)
    push ebp                                     # 004ca92e
    {load} mov ebp, esp                          # 004ca92f
    push ecx                                     # 004ca931
    mov dword ptr [ebp - local_4], ecx           # 004ca932
    mov eax, dword ptr [ebp + arg_8]             # 004ca935
    mov ecx, dword ptr [eax + field_4]           # 004ca938
    and ecx, 0x1                                 # 004ca93b
    test ecx, ecx                                # 004ca93e
    je.d8 L_004ca94f                             # 004ca940
    # block 0x004ca942: entered by fall-through of je at 0x004ca940, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca94f
    push 0x5582dc                                # 004ca942
    call FUN_0044a2b7                            # 004ca947
    add esp, 0x4                                 # 004ca94c
L_004ca94f:
    # block 0x004ca94f: entered by je at 0x004ca940, 5 instruction(s), ends with je to 0x004ca969 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004ca94f
    mov eax, dword ptr [edx + field_4]           # 004ca952
    and eax, 0x2                                 # 004ca955
    test eax, eax                                # 004ca958
    je.d8 L_004ca969                             # 004ca95a
    # block 0x004ca95c: entered by fall-through of je at 0x004ca95a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca969
    push 0x558314                                # 004ca95c
    call FUN_0044a2b7                            # 004ca961
    add esp, 0x4                                 # 004ca966
L_004ca969:
    # block 0x004ca969: entered by je at 0x004ca95a, 5 instruction(s), ends with je to 0x004ca983 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004ca969
    mov edx, dword ptr [ecx + field_4]           # 004ca96c
    and edx, 0x4                                 # 004ca96f
    test edx, edx                                # 004ca972
    je.d8 L_004ca983                             # 004ca974
    # block 0x004ca976: entered by fall-through of je at 0x004ca974, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca983
    push 0x558330                                # 004ca976
    call FUN_0044a2b7                            # 004ca97b
    add esp, 0x4                                 # 004ca980
L_004ca983:
    # block 0x004ca983: entered by je at 0x004ca974, 5 instruction(s), ends with je to 0x004ca99d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004ca983
    mov ecx, dword ptr [eax + field_4]           # 004ca986
    and ecx, 0x8                                 # 004ca989
    test ecx, ecx                                # 004ca98c
    je.d8 L_004ca99d                             # 004ca98e
    # block 0x004ca990: entered by fall-through of je at 0x004ca98e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca99d
    push 0x558348                                # 004ca990
    call FUN_0044a2b7                            # 004ca995
    add esp, 0x4                                 # 004ca99a
L_004ca99d:
    # block 0x004ca99d: entered by je at 0x004ca98e, 5 instruction(s), ends with je to 0x004ca9b7 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004ca99d
    mov eax, dword ptr [edx + field_4]           # 004ca9a0
    and eax, 0x10                                # 004ca9a3
    test eax, eax                                # 004ca9a6
    je.d8 L_004ca9b7                             # 004ca9a8
    # block 0x004ca9aa: entered by fall-through of je at 0x004ca9a8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca9b7
    push 0x558364                                # 004ca9aa
    call FUN_0044a2b7                            # 004ca9af
    add esp, 0x4                                 # 004ca9b4
L_004ca9b7:
    # block 0x004ca9b7: entered by je at 0x004ca9a8, 5 instruction(s), ends with je to 0x004ca9d4 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004ca9b7
    mov edx, dword ptr [ecx + field_4]           # 004ca9ba
    and edx, 0x8000000                           # 004ca9bd
    test edx, edx                                # 004ca9c3
    je.d8 L_004ca9d4                             # 004ca9c5
    # block 0x004ca9c7: entered by fall-through of je at 0x004ca9c5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca9d4
    push 0x55837c                                # 004ca9c7
    call FUN_0044a2b7                            # 004ca9cc
    add esp, 0x4                                 # 004ca9d1
L_004ca9d4:
    # block 0x004ca9d4: entered by je at 0x004ca9c5, 5 instruction(s), ends with je to 0x004ca9ee (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004ca9d4
    mov ecx, dword ptr [eax + field_4]           # 004ca9d7
    and ecx, 0x40                                # 004ca9da
    test ecx, ecx                                # 004ca9dd
    je.d8 L_004ca9ee                             # 004ca9df
    # block 0x004ca9e1: entered by fall-through of je at 0x004ca9df, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ca9ee
    push 0x558394                                # 004ca9e1
    call FUN_0044a2b7                            # 004ca9e6
    add esp, 0x4                                 # 004ca9eb
L_004ca9ee:
    # block 0x004ca9ee: entered by je at 0x004ca9df, 5 instruction(s), ends with je to 0x004caa0a (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004ca9ee
    mov eax, dword ptr [edx + field_4]           # 004ca9f1
    and eax, 0x10000000                          # 004ca9f4
    test eax, eax                                # 004ca9f9
    je.d8 L_004caa0a                             # 004ca9fb
    # block 0x004ca9fd: entered by fall-through of je at 0x004ca9fb, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa0a
    push 0x5583a4                                # 004ca9fd
    call FUN_0044a2b7                            # 004caa02
    add esp, 0x4                                 # 004caa07
L_004caa0a:
    # block 0x004caa0a: entered by je at 0x004ca9fb, 5 instruction(s), ends with je to 0x004caa27 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004caa0a
    mov edx, dword ptr [ecx + field_4]           # 004caa0d
    and edx, 0x80                                # 004caa10
    test edx, edx                                # 004caa16
    je.d8 L_004caa27                             # 004caa18
    # block 0x004caa1a: entered by fall-through of je at 0x004caa18, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa27
    push 0x558404                                # 004caa1a
    call FUN_0044a2b7                            # 004caa1f
    add esp, 0x4                                 # 004caa24
L_004caa27:
    # block 0x004caa27: entered by je at 0x004caa18, 5 instruction(s), ends with je to 0x004caa44 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004caa27
    mov ecx, dword ptr [eax + field_4]           # 004caa2a
    and ecx, 0x200                               # 004caa2d
    test ecx, ecx                                # 004caa33
    je.d8 L_004caa44                             # 004caa35
    # block 0x004caa37: entered by fall-through of je at 0x004caa35, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa44
    push 0x558418                                # 004caa37
    call FUN_0044a2b7                            # 004caa3c
    add esp, 0x4                                 # 004caa41
L_004caa44:
    # block 0x004caa44: entered by je at 0x004caa35, 5 instruction(s), ends with je to 0x004caa60 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004caa44
    mov eax, dword ptr [edx + field_4]           # 004caa47
    and eax, 0x80000000                          # 004caa4a
    test eax, eax                                # 004caa4f
    je.d8 L_004caa60                             # 004caa51
    # block 0x004caa53: entered by fall-through of je at 0x004caa51, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa60
    push 0x55842c                                # 004caa53
    call FUN_0044a2b7                            # 004caa58
    add esp, 0x4                                 # 004caa5d
L_004caa60:
    # block 0x004caa60: entered by je at 0x004caa51, 5 instruction(s), ends with je to 0x004caa7d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004caa60
    mov edx, dword ptr [ecx + field_4]           # 004caa63
    and edx, 0x400                               # 004caa66
    test edx, edx                                # 004caa6c
    je.d8 L_004caa7d                             # 004caa6e
    # block 0x004caa70: entered by fall-through of je at 0x004caa6e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa7d
    push 0x558488                                # 004caa70
    call FUN_0044a2b7                            # 004caa75
    add esp, 0x4                                 # 004caa7a
L_004caa7d:
    # block 0x004caa7d: entered by je at 0x004caa6e, 5 instruction(s), ends with je to 0x004caa9a (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004caa7d
    mov ecx, dword ptr [eax + field_4]           # 004caa80
    and ecx, 0x2000000                           # 004caa83
    test ecx, ecx                                # 004caa89
    je.d8 L_004caa9a                             # 004caa8b
    # block 0x004caa8d: entered by fall-through of je at 0x004caa8b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caa9a
    push 0x5584bc                                # 004caa8d
    call FUN_0044a2b7                            # 004caa92
    add esp, 0x4                                 # 004caa97
L_004caa9a:
    # block 0x004caa9a: entered by je at 0x004caa8b, 5 instruction(s), ends with je to 0x004caab6 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004caa9a
    mov eax, dword ptr [edx + field_4]           # 004caa9d
    and eax, 0x800                               # 004caaa0
    test eax, eax                                # 004caaa5
    je.d8 L_004caab6                             # 004caaa7
    # block 0x004caaa9: entered by fall-through of je at 0x004caaa7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caab6
    push 0x5584f0                                # 004caaa9
    call FUN_0044a2b7                            # 004caaae
    add esp, 0x4                                 # 004caab3
L_004caab6:
    # block 0x004caab6: entered by je at 0x004caaa7, 5 instruction(s), ends with je to 0x004caad3 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004caab6
    mov edx, dword ptr [ecx + field_4]           # 004caab9
    and edx, 0x8000                              # 004caabc
    test edx, edx                                # 004caac2
    je.d8 L_004caad3                             # 004caac4
    # block 0x004caac6: entered by fall-through of je at 0x004caac4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caad3
    push 0x558528                                # 004caac6
    call FUN_0044a2b7                            # 004caacb
    add esp, 0x4                                 # 004caad0
L_004caad3:
    # block 0x004caad3: entered by je at 0x004caac4, 5 instruction(s), ends with je to 0x004caaf0 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004caad3
    mov ecx, dword ptr [eax + field_4]           # 004caad6
    and ecx, 0x20000                             # 004caad9
    test ecx, ecx                                # 004caadf
    je.d8 L_004caaf0                             # 004caae1
    # block 0x004caae3: entered by fall-through of je at 0x004caae1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004caaf0
    push 0x55853c                                # 004caae3
    call FUN_0044a2b7                            # 004caae8
    add esp, 0x4                                 # 004caaed
L_004caaf0:
    # block 0x004caaf0: entered by je at 0x004caae1, 5 instruction(s), ends with je to 0x004cab0c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004caaf0
    mov eax, dword ptr [edx + field_4]           # 004caaf3
    and eax, 0x100000                            # 004caaf6
    test eax, eax                                # 004caafb
    je.d8 L_004cab0c                             # 004caafd
    # block 0x004caaff: entered by fall-through of je at 0x004caafd, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab0c
    push 0x558554                                # 004caaff
    call FUN_0044a2b7                            # 004cab04
    add esp, 0x4                                 # 004cab09
L_004cab0c:
    # block 0x004cab0c: entered by je at 0x004caafd, 5 instruction(s), ends with je to 0x004cab29 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cab0c
    mov edx, dword ptr [ecx + field_4]           # 004cab0f
    and edx, 0x800000                            # 004cab12
    test edx, edx                                # 004cab18
    je.d8 L_004cab29                             # 004cab1a
    # block 0x004cab1c: entered by fall-through of je at 0x004cab1a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab29
    push 0x558598                                # 004cab1c
    call FUN_0044a2b7                            # 004cab21
    add esp, 0x4                                 # 004cab26
L_004cab29:
    # block 0x004cab29: entered by je at 0x004cab1a, 5 instruction(s), ends with je to 0x004cab46 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cab29
    mov ecx, dword ptr [eax + field_8]           # 004cab2c
    and ecx, 0x100000                            # 004cab2f
    test ecx, ecx                                # 004cab35
    je.d8 L_004cab46                             # 004cab37
    # block 0x004cab39: entered by fall-through of je at 0x004cab37, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab46
    push 0x5585dc                                # 004cab39
    call FUN_0044a2b7                            # 004cab3e
    add esp, 0x4                                 # 004cab43
L_004cab46:
    # block 0x004cab46: entered by je at 0x004cab37, 5 instruction(s), ends with je to 0x004cab62 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cab46
    mov eax, dword ptr [edx + field_8]           # 004cab49
    and eax, 0x800000                            # 004cab4c
    test eax, eax                                # 004cab51
    je.d8 L_004cab62                             # 004cab53
    # block 0x004cab55: entered by fall-through of je at 0x004cab53, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab62
    push 0x5585f8                                # 004cab55
    call FUN_0044a2b7                            # 004cab5a
    add esp, 0x4                                 # 004cab5f
L_004cab62:
    # block 0x004cab62: entered by je at 0x004cab53, 5 instruction(s), ends with je to 0x004cab7f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cab62
    mov edx, dword ptr [ecx + field_8]           # 004cab65
    and edx, 0x80000                             # 004cab68
    test edx, edx                                # 004cab6e
    je.d8 L_004cab7f                             # 004cab70
    # block 0x004cab72: entered by fall-through of je at 0x004cab70, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab7f
    push 0x558614                                # 004cab72
    call FUN_0044a2b7                            # 004cab77
    add esp, 0x4                                 # 004cab7c
L_004cab7f:
    # block 0x004cab7f: entered by je at 0x004cab70, 5 instruction(s), ends with je to 0x004cab99 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cab7f
    mov ecx, dword ptr [eax + field_8]           # 004cab82
    and ecx, 0x1                                 # 004cab85
    test ecx, ecx                                # 004cab88
    je.d8 L_004cab99                             # 004cab8a
    # block 0x004cab8c: entered by fall-through of je at 0x004cab8a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cab99
    push 0x558668                                # 004cab8c
    call FUN_0044a2b7                            # 004cab91
    add esp, 0x4                                 # 004cab96
L_004cab99:
    # block 0x004cab99: entered by je at 0x004cab8a, 5 instruction(s), ends with je to 0x004cabb5 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cab99
    mov eax, dword ptr [edx + field_8]           # 004cab9c
    and eax, 0x80                                # 004cab9f
    test eax, eax                                # 004caba4
    je.d8 L_004cabb5                             # 004caba6
    # block 0x004caba8: entered by fall-through of je at 0x004caba6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cabb5
    push 0x55869c                                # 004caba8
    call FUN_0044a2b7                            # 004cabad
    add esp, 0x4                                 # 004cabb2
L_004cabb5:
    # block 0x004cabb5: entered by je at 0x004caba6, 5 instruction(s), ends with je to 0x004cabd2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cabb5
    mov edx, dword ptr [ecx + field_8]           # 004cabb8
    and edx, 0x200                               # 004cabbb
    test edx, edx                                # 004cabc1
    je.d8 L_004cabd2                             # 004cabc3
    # block 0x004cabc5: entered by fall-through of je at 0x004cabc3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cabd2
    push 0x5586bc                                # 004cabc5
    call FUN_0044a2b7                            # 004cabca
    add esp, 0x4                                 # 004cabcf
L_004cabd2:
    # block 0x004cabd2: entered by je at 0x004cabc3, 5 instruction(s), ends with je to 0x004cabef (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cabd2
    mov ecx, dword ptr [eax + field_8]           # 004cabd5
    and ecx, 0x20000                             # 004cabd8
    test ecx, ecx                                # 004cabde
    je.d8 L_004cabef                             # 004cabe0
    # block 0x004cabe2: entered by fall-through of je at 0x004cabe0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cabef
    push 0x5586d8                                # 004cabe2
    call FUN_0044a2b7                            # 004cabe7
    add esp, 0x4                                 # 004cabec
L_004cabef:
    # block 0x004cabef: entered by je at 0x004cabe0, 5 instruction(s), ends with je to 0x004cac0b (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cabef
    mov eax, dword ptr [edx + field_8]           # 004cabf2
    and eax, 0x1000                              # 004cabf5
    test eax, eax                                # 004cabfa
    je.d8 L_004cac0b                             # 004cabfc
    # block 0x004cabfe: entered by fall-through of je at 0x004cabfc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac0b
    push 0x5586f0                                # 004cabfe
    call FUN_0044a2b7                            # 004cac03
    add esp, 0x4                                 # 004cac08
L_004cac0b:
    # block 0x004cac0b: entered by je at 0x004cabfc, 5 instruction(s), ends with je to 0x004cac25 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cac0b
    mov edx, dword ptr [ecx + field_c]           # 004cac0e
    and edx, 0x1                                 # 004cac11
    test edx, edx                                # 004cac14
    je.d8 L_004cac25                             # 004cac16
    # block 0x004cac18: entered by fall-through of je at 0x004cac16, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac25
    push 0x558708                                # 004cac18
    call FUN_0044a2b7                            # 004cac1d
    add esp, 0x4                                 # 004cac22
L_004cac25:
    # block 0x004cac25: entered by je at 0x004cac16, 5 instruction(s), ends with je to 0x004cac42 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cac25
    mov ecx, dword ptr [eax + field_c]           # 004cac28
    and ecx, 0x200                               # 004cac2b
    test ecx, ecx                                # 004cac31
    je.d8 L_004cac42                             # 004cac33
    # block 0x004cac35: entered by fall-through of je at 0x004cac33, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac42
    push 0x558720                                # 004cac35
    call FUN_0044a2b7                            # 004cac3a
    add esp, 0x4                                 # 004cac3f
L_004cac42:
    # block 0x004cac42: entered by je at 0x004cac33, 5 instruction(s), ends with je to 0x004cac5c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cac42
    mov eax, dword ptr [edx + field_10]          # 004cac45
    and eax, 0x1                                 # 004cac48
    test eax, eax                                # 004cac4b
    je.d8 L_004cac5c                             # 004cac4d
    # block 0x004cac4f: entered by fall-through of je at 0x004cac4d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac5c
    push 0x558734                                # 004cac4f
    call FUN_0044a2b7                            # 004cac54
    add esp, 0x4                                 # 004cac59
L_004cac5c:
    # block 0x004cac5c: entered by je at 0x004cac4d, 5 instruction(s), ends with je to 0x004cac76 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cac5c
    mov edx, dword ptr [ecx + field_10]          # 004cac5f
    and edx, 0x4                                 # 004cac62
    test edx, edx                                # 004cac65
    je.d8 L_004cac76                             # 004cac67
    # block 0x004cac69: entered by fall-through of je at 0x004cac67, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac76
    push 0x558774                                # 004cac69
    call FUN_0044a2b7                            # 004cac6e
    add esp, 0x4                                 # 004cac73
L_004cac76:
    # block 0x004cac76: entered by je at 0x004cac67, 5 instruction(s), ends with je to 0x004cac90 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cac76
    mov ecx, dword ptr [eax + field_14]          # 004cac79
    and ecx, 0x2                                 # 004cac7c
    test ecx, ecx                                # 004cac7f
    je.d8 L_004cac90                             # 004cac81
    # block 0x004cac83: entered by fall-through of je at 0x004cac81, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cac90
    push 0x5587bc                                # 004cac83
    call FUN_0044a2b7                            # 004cac88
    add esp, 0x4                                 # 004cac8d
L_004cac90:
    # block 0x004cac90: entered by je at 0x004cac81, 5 instruction(s), ends with je to 0x004cacaa (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cac90
    mov eax, dword ptr [edx + field_14]          # 004cac93
    and eax, 0x8                                 # 004cac96
    test eax, eax                                # 004cac99
    je.d8 L_004cacaa                             # 004cac9b
    # block 0x004cac9d: entered by fall-through of je at 0x004cac9b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cacaa
    push 0x55880c                                # 004cac9d
    call FUN_0044a2b7                            # 004caca2
    add esp, 0x4                                 # 004caca7
L_004cacaa:
    # block 0x004cacaa: entered by je at 0x004cac9b, 5 instruction(s), ends with je to 0x004cacc4 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cacaa
    mov edx, dword ptr [ecx + field_14]          # 004cacad
    and edx, 0x40                                # 004cacb0
    test edx, edx                                # 004cacb3
    je.d8 L_004cacc4                             # 004cacb5
    # block 0x004cacb7: entered by fall-through of je at 0x004cacb5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cacc4
    push 0x558850                                # 004cacb7
    call FUN_0044a2b7                            # 004cacbc
    add esp, 0x4                                 # 004cacc1
L_004cacc4:
    # block 0x004cacc4: entered by je at 0x004cacb5, 5 instruction(s), ends with je to 0x004cace1 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cacc4
    mov ecx, dword ptr [eax + field_14]          # 004cacc7
    and ecx, 0x100                               # 004cacca
    test ecx, ecx                                # 004cacd0
    je.d8 L_004cace1                             # 004cacd2
    # block 0x004cacd4: entered by fall-through of je at 0x004cacd2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cace1
    push 0x5588a0                                # 004cacd4
    call FUN_0044a2b7                            # 004cacd9
    add esp, 0x4                                 # 004cacde
L_004cace1:
    # block 0x004cace1: entered by je at 0x004cacd2, 5 instruction(s), ends with je to 0x004cad00 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cace1
    mov eax, dword ptr [edx + field_16c]         # 004cace4
    and eax, 0x2000                              # 004cacea
    test eax, eax                                # 004cacef
    je.d8 L_004cad00                             # 004cacf1
    # block 0x004cacf3: entered by fall-through of je at 0x004cacf1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad00
    push 0x5588e4                                # 004cacf3
    call FUN_0044a2b7                            # 004cacf8
    add esp, 0x4                                 # 004cacfd
L_004cad00:
    # block 0x004cad00: entered by je at 0x004cacf1, 5 instruction(s), ends with je to 0x004cad1d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cad00
    mov edx, dword ptr [ecx + field_16c]         # 004cad03
    and edx, 0x40                                # 004cad09
    test edx, edx                                # 004cad0c
    je.d8 L_004cad1d                             # 004cad0e
    # block 0x004cad10: entered by fall-through of je at 0x004cad0e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad1d
    push 0x558924                                # 004cad10
    call FUN_0044a2b7                            # 004cad15
    add esp, 0x4                                 # 004cad1a
L_004cad1d:
    # block 0x004cad1d: entered by je at 0x004cad0e, 5 instruction(s), ends with je to 0x004cad3d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cad1d
    mov ecx, dword ptr [eax + field_16c]         # 004cad20
    and ecx, 0x200                               # 004cad26
    test ecx, ecx                                # 004cad2c
    je.d8 L_004cad3d                             # 004cad2e
    # block 0x004cad30: entered by fall-through of je at 0x004cad2e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad3d
    push 0x558968                                # 004cad30
    call FUN_0044a2b7                            # 004cad35
    add esp, 0x4                                 # 004cad3a
L_004cad3d:
    # block 0x004cad3d: entered by je at 0x004cad2e, 5 instruction(s), ends with je to 0x004cad5c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004cad3d
    mov eax, dword ptr [edx + field_16c]         # 004cad40
    and eax, 0x800                               # 004cad46
    test eax, eax                                # 004cad4b
    je.d8 L_004cad5c                             # 004cad4d
    # block 0x004cad4f: entered by fall-through of je at 0x004cad4d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad5c
    push 0x5589a8                                # 004cad4f
    call FUN_0044a2b7                            # 004cad54
    add esp, 0x4                                 # 004cad59
L_004cad5c:
    # block 0x004cad5c: entered by je at 0x004cad4d, 5 instruction(s), ends with je to 0x004cad7c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004cad5c
    mov edx, dword ptr [ecx + field_16c]         # 004cad5f
    and edx, 0x4000                              # 004cad65
    test edx, edx                                # 004cad6b
    je.d8 L_004cad7c                             # 004cad6d
    # block 0x004cad6f: entered by fall-through of je at 0x004cad6d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad7c
    push 0x5589f4                                # 004cad6f
    call FUN_0044a2b7                            # 004cad74
    add esp, 0x4                                 # 004cad79
L_004cad7c:
    # block 0x004cad7c: entered by je at 0x004cad6d, 5 instruction(s), ends with je to 0x004cad9c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004cad7c
    mov ecx, dword ptr [eax + field_16c]         # 004cad7f
    and ecx, 0x20000                             # 004cad85
    test ecx, ecx                                # 004cad8b
    je.d8 L_004cad9c                             # 004cad8d
    # block 0x004cad8f: entered by fall-through of je at 0x004cad8d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cad9c
    push 0x558a34                                # 004cad8f
    call FUN_0044a2b7                            # 004cad94
    add esp, 0x4                                 # 004cad99
L_004cad9c:
    # block 0x004cad9c: entered by je at 0x004cad8d, 63 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with ret 0x4
    mov edx, dword ptr [ebp + arg_8]             # 004cad9c
    mov eax, dword ptr [edx + field_3c]          # 004cad9f
    push eax                                     # 004cada2
    push 0x558a68                                # 004cada3
    push 0x63888b                                # 004cada8
    call FUN_0050ca3e                            # 004cadad
    add esp, 0xc                                 # 004cadb2
    push 0x63888b                                # 004cadb5
    call FUN_0044a2b7                            # 004cadba
    add esp, 0x4                                 # 004cadbf
    mov ecx, dword ptr [ebp + arg_8]             # 004cadc2
    mov edx, dword ptr [ecx + field_40]          # 004cadc5
    push edx                                     # 004cadc8
    push 0x558a84                                # 004cadc9
    push 0x63888b                                # 004cadce
    call FUN_0050ca3e                            # 004cadd3
    add esp, 0xc                                 # 004cadd8
    push 0x63888b                                # 004caddb
    call FUN_0044a2b7                            # 004cade0
    add esp, 0x4                                 # 004cade5
    mov eax, dword ptr [ebp + arg_8]             # 004cade8
    mov ecx, dword ptr [eax + field_50]          # 004cadeb
    push ecx                                     # 004cadee
    push 0x558aa4                                # 004cadef
    push 0x63888b                                # 004cadf4
    call FUN_0050ca3e                            # 004cadf9
    add esp, 0xc                                 # 004cadfe
    push 0x63888b                                # 004cae01
    call FUN_0044a2b7                            # 004cae06
    add esp, 0x4                                 # 004cae0b
    mov edx, dword ptr [ebp + arg_8]             # 004cae0e
    mov eax, dword ptr [edx + field_54]          # 004cae11
    push eax                                     # 004cae14
    push 0x558ac4                                # 004cae15
    push 0x63888b                                # 004cae1a
    call FUN_0050ca3e                            # 004cae1f
    add esp, 0xc                                 # 004cae24
    push 0x63888b                                # 004cae27
    call FUN_0044a2b7                            # 004cae2c
    add esp, 0x4                                 # 004cae31
    mov ecx, dword ptr [ebp + arg_8]             # 004cae34
    mov edx, dword ptr [ecx + field_58]          # 004cae37
    push edx                                     # 004cae3a
    push 0x558ae0                                # 004cae3b
    push 0x63888b                                # 004cae40
    call FUN_0050ca3e                            # 004cae45
    add esp, 0xc                                 # 004cae4a
    push 0x63888b                                # 004cae4d
    call FUN_0044a2b7                            # 004cae52
    add esp, 0x4                                 # 004cae57
    mov eax, dword ptr [ebp + arg_8]             # 004cae5a
    mov ecx, dword ptr [eax + field_5c]          # 004cae5d
    push ecx                                     # 004cae60
    push 0x558b00                                # 004cae61
    push 0x63888b                                # 004cae66
    call FUN_0050ca3e                            # 004cae6b
    add esp, 0xc                                 # 004cae70
    push 0x63888b                                # 004cae73
    call FUN_0044a2b7                            # 004cae78
    add esp, 0x4                                 # 004cae7d
    {load} mov esp, ebp                          # 004cae80
    pop ebp                                      # 004cae82
    ret 0x4                                      # 004cae83

# --- data items (not part of the function) -------------------------
.org 0x004cae86 - 0x401000
PAD_004cae86:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

