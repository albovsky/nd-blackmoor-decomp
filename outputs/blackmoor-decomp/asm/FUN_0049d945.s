# FUN_0049d945
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049d945
# extent:       0x0049d945-0x0049e24d (2312 code bytes)
# span:         0x0049d945-0x0049e24d (code 2312, tables 0, padding 0)
# sha256:       2fa1ac46840137ab536210c168376e478a28790b503d594f470e1ed0c2ad371d
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049d945
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       23 ebp-relative slot(s): local_14, local_18, local_1c, local_20, local_24, local_28, local_50, local_54, local_58, local_5c, local_60, local_64 and 11 more
# fields:       [eax + n] field_1c, field_8c, field_180, field_e20, field_e24, field_e28, field_e30, field_e38; [ecx + n] field_1c, field_20, field_2c, field_e18, field_e24, field_e28, field_e34, field_e38; [edx + n] field_1c, field_20, field_2c, field_64, field_b4, field_182, field_184, field_186, field_188, field_e1c, field_e24, field_e28 and 1 more
# callees:      calls FUN_0050cd50, FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, FUN_004c97b4, FUN_004a0ac4, FUN_004a0bbd, FUN_004a0365, FUN_0049f86a, FUN_0049e455, FUN_0049e24d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 599 instruction(s), 38 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_2c, 0x2c  # offset +0x2c
.equ field_64, 0x64  # offset +0x64
.equ field_8c, 0x8c  # offset +0x8c
.equ field_b4, 0xb4  # offset +0xb4
.equ field_180, 0x180  # offset +0x180
.equ field_182, 0x182  # offset +0x182
.equ field_184, 0x184  # offset +0x184
.equ field_186, 0x186  # offset +0x186
.equ field_188, 0x188  # offset +0x188
.equ field_e18, 0xe18  # offset +0xe18
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e24, 0xe24  # offset +0xe24
.equ field_e28, 0xe28  # offset +0xe28
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e34, 0xe34  # offset +0xe34
.equ field_e38, 0xe38  # offset +0xe38

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0049e24d, .text + (0x0049e24d - 0x401000)
.set FUN_0049e455, .text + (0x0049e455 - 0x401000)
.set FUN_0049f86a, .text + (0x0049f86a - 0x401000)
.set FUN_004a0365, .text + (0x004a0365 - 0x401000)
.set FUN_004a0ac4, .text + (0x004a0ac4 - 0x401000)
.set FUN_004a0bbd, .text + (0x004a0bbd - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049d945 - 0x401000
.globl FUN_0049d945
FUN_0049d945:
    # block 0x0049d945: entry, 16 instruction(s), calls FUN_0050cd50, ends with jl to 0x0049d98f (forward)
    push ebp                                     # 0049d945
    {load} mov ebp, esp                          # 0049d946
    sub esp, 0xa0                                # 0049d948
    mov dword ptr [ebp - local_a0], ecx          # 0049d94e
    call FUN_0050cd50                            # 0049d954
    mov ecx, dword ptr [ebp - local_a0]          # 0049d959
    cdq                                          # 0049d95f
    idiv dword ptr [ecx + field_e18]             # 0049d960
    mov dword ptr [ebp - local_54], edx          # 0049d966
    mov edx, dword ptr [ebp - local_54]          # 0049d969
    imul edx, edx, 0x15e                         # 0049d96c
    mov eax, dword ptr [ebp - local_a0]          # 0049d972
    movsx ecx, word ptr [eax + edx + field_180]  # 0049d978
    mov dword ptr [ebp - local_74], ecx          # 0049d980
    cmp dword ptr [ebp - local_74], 0x0          # 0049d983
    jl.d8 L_0049d98f                             # 0049d987
    # block 0x0049d989: entered by fall-through of jl at 0x0049d987, 2 instruction(s), ends with jl to 0x0049d9d9 (forward)
    cmp dword ptr [ebp - local_74], 0x8          # 0049d989
    jl.d8 L_0049d9d9                             # 0049d98d
L_0049d98f:
    # block 0x0049d98f: entered by jl at 0x0049d987; fall-through of jl at 0x0049d98d, 11 instruction(s), calls FUN_0050ca3e, ends with je to 0x0049d9c1 (forward)
    mov edx, dword ptr [ebp - local_54]          # 0049d98f
    push edx                                     # 0049d992
    mov eax, dword ptr [ebp - local_74]          # 0049d993
    push eax                                     # 0049d996
    push 0x54fda4                                # 0049d997
    push 0x63888b                                # 0049d99c
    call FUN_0050ca3e                            # 0049d9a1
    add esp, 0x10                                # 0049d9a6
    movsx ecx, word ptr [0x63a4cd]               # 0049d9a9
    test ecx, ecx                                # 0049d9b0
    je.d8 L_0049d9c1                             # 0049d9b2
    # block 0x0049d9b4: entered by fall-through of je at 0x0049d9b2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0049d9c1
    push 0x63888b                                # 0049d9b4
    call FUN_0044a2b7                            # 0049d9b9
    add esp, 0x4                                 # 0049d9be
L_0049d9c1:
    # block 0x0049d9c1: entered by je at 0x0049d9b2, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049d9d9
    push 0x0                                     # 0049d9c1
    push 0x0                                     # 0049d9c3
    push 0x63888b                                # 0049d9c5
    call FUN_0052139c                            # 0049d9ca
    mov ecx, 0x5cf659                            # 0049d9cf
    call FUN_004c97b4                            # 0049d9d4
L_0049d9d9:
    # block 0x0049d9d9: entered by jl at 0x0049d98d, 3 instruction(s), ends with forward jump to 0x0049d9f5
    mov dword ptr [ebp - local_94], 0x0          # 0049d9d9
    mov dword ptr [ebp - local_5c], 0x0          # 0049d9e3
    jmp.d8 L_0049d9f5                            # 0049d9ea
L_0049d9ec:
    # block 0x0049d9ec: entered by jmp at 0x0049da1e; jmp at 0x0049da70, 3 instruction(s), falls into the block at 0x0049d9f5
    mov edx, dword ptr [ebp - local_5c]          # 0049d9ec
    add edx, 0x1                                 # 0049d9ef
    mov dword ptr [ebp - local_5c], edx          # 0049d9f2
L_0049d9f5:
    # block 0x0049d9f5: entered by jmp at 0x0049d9ea, 2 instruction(s), ends with jge to 0x0049da75 (forward)
    cmp dword ptr [ebp - local_5c], 0xa          # 0049d9f5
    jge.d8 L_0049da75                            # 0049d9f9
    # block 0x0049d9fb: entered by fall-through of jge at 0x0049d9f9, 9 instruction(s), ends with jne to 0x0049da20 (forward)
    mov eax, dword ptr [ebp - local_54]          # 0049d9fb
    imul eax, eax, 0x15e                         # 0049d9fe
    mov ecx, dword ptr [ebp - local_a0]          # 0049da04
    lea edx, [ecx + eax + field_2c]              # 0049da0a
    mov eax, dword ptr [ebp - local_5c]          # 0049da0e
    mov ecx, dword ptr [edx + 4*eax + field_64]  # 0049da11
    mov dword ptr [ebp - local_58], ecx          # 0049da15
    cmp dword ptr [ebp - local_58], -0x1         # 0049da18
    jne.d8 L_0049da20                            # 0049da1c
    # block 0x0049da1e: entered by fall-through of jne at 0x0049da1c, 1 instruction(s), ends with backward jump to 0x0049d9ec
    jmp.d8 L_0049d9ec                            # 0049da1e
L_0049da20:
    # block 0x0049da20: entered by jne at 0x0049da1c, 17 instruction(s), ends with backward jump to 0x0049d9ec
    mov edx, dword ptr [ebp - local_94]          # 0049da20
    mov eax, dword ptr [ebp - local_58]          # 0049da26
    mov dword ptr [ebp + 4*edx - local_50], eax  # 0049da29
    mov ecx, dword ptr [ebp - local_94]          # 0049da2d
    mov edx, dword ptr [ebp + 4*ecx - local_50]  # 0049da33
    and edx, 0xffffff                            # 0049da37
    mov eax, dword ptr [ebp - local_94]          # 0049da3d
    mov dword ptr [ebp + 4*eax - local_50], edx  # 0049da43
    mov ecx, dword ptr [ebp - local_94]          # 0049da47
    mov edx, dword ptr [ebp + 4*ecx - local_50]  # 0049da4d
    or edx, 0x1000000                            # 0049da51
    mov eax, dword ptr [ebp - local_94]          # 0049da57
    mov dword ptr [ebp + 4*eax - local_50], edx  # 0049da5d
    mov ecx, dword ptr [ebp - local_94]          # 0049da61
    add ecx, 0x1                                 # 0049da67
    mov dword ptr [ebp - local_94], ecx          # 0049da6a
    jmp.d32 L_0049d9ec                           # 0049da70
L_0049da75:
    # block 0x0049da75: entered by jge at 0x0049d9f9, 2 instruction(s), ends with jne to 0x0049daac (forward)
    cmp dword ptr [ebp - local_94], 0x0          # 0049da75
    jne.d8 L_0049daac                            # 0049da7c
    # block 0x0049da7e: entered by fall-through of jne at 0x0049da7c, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049daac
    mov edx, dword ptr [ebp - local_54]          # 0049da7e
    push edx                                     # 0049da81
    push 0x54fe0c                                # 0049da82
    push 0x63888b                                # 0049da87
    call FUN_0050ca3e                            # 0049da8c
    add esp, 0xc                                 # 0049da91
    push 0x0                                     # 0049da94
    push 0x0                                     # 0049da96
    push 0x63888b                                # 0049da98
    call FUN_0052139c                            # 0049da9d
    mov ecx, 0x5cf659                            # 0049daa2
    call FUN_004c97b4                            # 0049daa7
L_0049daac:
    # block 0x0049daac: entered by jne at 0x0049da7c, 3 instruction(s), ends with forward jump to 0x0049dac5
    mov dword ptr [ebp - local_70], 0x0          # 0049daac
    mov dword ptr [ebp - local_5c], 0x0          # 0049dab3
    jmp.d8 L_0049dac5                            # 0049daba
L_0049dabc:
    # block 0x0049dabc: entered by jmp at 0x0049dafc; jmp at 0x0049db16, 3 instruction(s), falls into the block at 0x0049dac5
    mov eax, dword ptr [ebp - local_5c]          # 0049dabc
    add eax, 0x1                                 # 0049dabf
    mov dword ptr [ebp - local_5c], eax          # 0049dac2
L_0049dac5:
    # block 0x0049dac5: entered by jmp at 0x0049daba, 2 instruction(s), ends with jge to 0x0049db18 (forward)
    cmp dword ptr [ebp - local_5c], 0xa          # 0049dac5
    jge.d8 L_0049db18                            # 0049dac9
    # block 0x0049dacb: entered by fall-through of jge at 0x0049dac9, 10 instruction(s), ends with jne to 0x0049dafe (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0049dacb
    imul ecx, ecx, 0x15e                         # 0049dace
    mov edx, dword ptr [ebp - local_a0]          # 0049dad4
    lea eax, [edx + ecx + field_2c]              # 0049dada
    mov ecx, dword ptr [ebp - local_5c]          # 0049dade
    mov dx, word ptr [eax + 2*ecx + field_8c]    # 0049dae1
    mov word ptr [ebp - local_90], dx            # 0049dae9
    movsx eax, word ptr [ebp - local_90]         # 0049daf0
    cmp eax, -0x1                                # 0049daf7
    jne.d8 L_0049dafe                            # 0049dafa
    # block 0x0049dafc: entered by fall-through of jne at 0x0049dafa, 1 instruction(s), ends with backward jump to 0x0049dabc
    jmp.d8 L_0049dabc                            # 0049dafc
L_0049dafe:
    # block 0x0049dafe: entered by jne at 0x0049dafa, 7 instruction(s), ends with backward jump to 0x0049dabc
    mov ecx, dword ptr [ebp - local_70]          # 0049dafe
    mov dx, word ptr [ebp - local_90]            # 0049db01
    mov word ptr [ebp + 2*ecx - local_14], dx    # 0049db08
    mov eax, dword ptr [ebp - local_70]          # 0049db0d
    add eax, 0x1                                 # 0049db10
    mov dword ptr [ebp - local_70], eax          # 0049db13
    jmp.d8 L_0049dabc                            # 0049db16
L_0049db18:
    # block 0x0049db18: entered by jge at 0x0049dac9, 2 instruction(s), ends with jne to 0x0049db4c (forward)
    cmp dword ptr [ebp - local_70], 0x0          # 0049db18
    jne.d8 L_0049db4c                            # 0049db1c
    # block 0x0049db1e: entered by fall-through of jne at 0x0049db1c, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049db4c
    mov ecx, dword ptr [ebp - local_54]          # 0049db1e
    push ecx                                     # 0049db21
    push 0x54fe5c                                # 0049db22
    push 0x63888b                                # 0049db27
    call FUN_0050ca3e                            # 0049db2c
    add esp, 0xc                                 # 0049db31
    push 0x0                                     # 0049db34
    push 0x0                                     # 0049db36
    push 0x63888b                                # 0049db38
    call FUN_0052139c                            # 0049db3d
    mov ecx, 0x5cf659                            # 0049db42
    call FUN_004c97b4                            # 0049db47
L_0049db4c:
    # block 0x0049db4c: entered by jne at 0x0049db1c, 3 instruction(s), ends with forward jump to 0x0049db68
    mov dword ptr [ebp - local_98], 0x0          # 0049db4c
    mov dword ptr [ebp - local_5c], 0x0          # 0049db56
    jmp.d8 L_0049db68                            # 0049db5d
L_0049db5f:
    # block 0x0049db5f: entered by jmp at 0x0049db99; jmp at 0x0049dbbc, 3 instruction(s), falls into the block at 0x0049db68
    mov edx, dword ptr [ebp - local_5c]          # 0049db5f
    add edx, 0x1                                 # 0049db62
    mov dword ptr [ebp - local_5c], edx          # 0049db65
L_0049db68:
    # block 0x0049db68: entered by jmp at 0x0049db5d, 2 instruction(s), ends with jge to 0x0049dbbe (forward)
    cmp dword ptr [ebp - local_5c], 0xa          # 0049db68
    jge.d8 L_0049dbbe                            # 0049db6c
    # block 0x0049db6e: entered by fall-through of jge at 0x0049db6c, 10 instruction(s), ends with jne to 0x0049db9b (forward)
    mov eax, dword ptr [ebp - local_54]          # 0049db6e
    imul eax, eax, 0x15e                         # 0049db71
    mov ecx, dword ptr [ebp - local_a0]          # 0049db77
    lea edx, [ecx + eax + field_2c]              # 0049db7d
    mov eax, dword ptr [ebp - local_5c]          # 0049db81
    mov cx, word ptr [edx + 2*eax + field_b4]    # 0049db84
    mov word ptr [ebp - local_18], cx            # 0049db8c
    movsx edx, word ptr [ebp - local_18]         # 0049db90
    cmp edx, -0x1                                # 0049db94
    jne.d8 L_0049db9b                            # 0049db97
    # block 0x0049db99: entered by fall-through of jne at 0x0049db97, 1 instruction(s), ends with backward jump to 0x0049db5f
    jmp.d8 L_0049db5f                            # 0049db99
L_0049db9b:
    # block 0x0049db9b: entered by jne at 0x0049db97, 7 instruction(s), ends with backward jump to 0x0049db5f
    mov eax, dword ptr [ebp - local_98]          # 0049db9b
    mov cx, word ptr [ebp - local_18]            # 0049dba1
    mov word ptr [ebp + 2*eax - local_8c], cx    # 0049dba5
    mov edx, dword ptr [ebp - local_98]          # 0049dbad
    add edx, 0x1                                 # 0049dbb3
    mov dword ptr [ebp - local_98], edx          # 0049dbb6
    jmp.d8 L_0049db5f                            # 0049dbbc
L_0049dbbe:
    # block 0x0049dbbe: entered by jge at 0x0049db6c, 2 instruction(s), ends with jne to 0x0049dbf5 (forward)
    cmp dword ptr [ebp - local_98], 0x0          # 0049dbbe
    jne.d8 L_0049dbf5                            # 0049dbc5
    # block 0x0049dbc7: entered by fall-through of jne at 0x0049dbc5, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049dbf5
    mov eax, dword ptr [ebp - local_54]          # 0049dbc7
    push eax                                     # 0049dbca
    push 0x54feb0                                # 0049dbcb
    push 0x63888b                                # 0049dbd0
    call FUN_0050ca3e                            # 0049dbd5
    add esp, 0xc                                 # 0049dbda
    push 0x0                                     # 0049dbdd
    push 0x0                                     # 0049dbdf
    push 0x63888b                                # 0049dbe1
    call FUN_0052139c                            # 0049dbe6
    mov ecx, 0x5cf659                            # 0049dbeb
    call FUN_004c97b4                            # 0049dbf0
L_0049dbf5:
    # block 0x0049dbf5: entered by jne at 0x0049dbc5, 11 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0049dc2f
    call FUN_0050cd50                            # 0049dbf5
    cdq                                          # 0049dbfa
    idiv dword ptr [ebp - local_94]              # 0049dbfb
    mov dword ptr [ebp - local_64], edx          # 0049dc01
    mov ecx, dword ptr [ebp - local_64]          # 0049dc04
    mov edx, dword ptr [ebp + 4*ecx - local_50]  # 0049dc07
    mov dword ptr [ebp - local_78], edx          # 0049dc0b
    mov eax, dword ptr [ebp + arg_8]             # 0049dc0e
    mov dword ptr [ebp - local_68], eax          # 0049dc11
    mov dword ptr [ebp - local_20], 0x0          # 0049dc14
    jmp.d8 L_0049dc2f                            # 0049dc1b
L_0049dc1d:
    # block 0x0049dc1d: entered by jmp at 0x0049dd00, 6 instruction(s), falls into the block at 0x0049dc2f
    mov ecx, dword ptr [ebp - local_68]          # 0049dc1d
    add ecx, 0x1                                 # 0049dc20
    mov dword ptr [ebp - local_68], ecx          # 0049dc23
    mov edx, dword ptr [ebp - local_20]          # 0049dc26
    add edx, 0x1                                 # 0049dc29
    mov dword ptr [ebp - local_20], edx          # 0049dc2c
L_0049dc2f:
    # block 0x0049dc2f: entered by jmp at 0x0049dc1b, 4 instruction(s), ends with jge to 0x0049dd05 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049dc2f
    mov ecx, dword ptr [ebp - local_20]          # 0049dc35
    cmp ecx, dword ptr [eax + field_e28]         # 0049dc38
    jge.d32 L_0049dd05                           # 0049dc3e
    # block 0x0049dc44: entered by fall-through of jge at 0x0049dc3e, 4 instruction(s), ends with jge to 0x0049dd05 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dc44
    mov eax, dword ptr [ebp - local_68]          # 0049dc4a
    cmp eax, dword ptr [edx + field_20]          # 0049dc4d
    jge.d32 L_0049dd05                           # 0049dc50
    # block 0x0049dc56: entered by fall-through of jge at 0x0049dc50, 4 instruction(s), ends with forward jump to 0x0049dc77
    mov ecx, dword ptr [ebp + arg_c]             # 0049dc56
    mov dword ptr [ebp - local_6c], ecx          # 0049dc59
    mov dword ptr [ebp - local_1c], 0x0          # 0049dc5c
    jmp.d8 L_0049dc77                            # 0049dc63
L_0049dc65:
    # block 0x0049dc65: entered by jmp at 0x0049dcfb, 6 instruction(s), falls into the block at 0x0049dc77
    mov edx, dword ptr [ebp - local_6c]          # 0049dc65
    add edx, 0x1                                 # 0049dc68
    mov dword ptr [ebp - local_6c], edx          # 0049dc6b
    mov eax, dword ptr [ebp - local_1c]          # 0049dc6e
    add eax, 0x1                                 # 0049dc71
    mov dword ptr [ebp - local_1c], eax          # 0049dc74
L_0049dc77:
    # block 0x0049dc77: entered by jmp at 0x0049dc63, 4 instruction(s), ends with jge to 0x0049dd00 (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 0049dc77
    mov edx, dword ptr [ebp - local_1c]          # 0049dc7d
    cmp edx, dword ptr [ecx + field_e24]         # 0049dc80
    jge.d8 L_0049dd00                            # 0049dc86
    # block 0x0049dc88: entered by fall-through of jge at 0x0049dc86, 4 instruction(s), ends with jge to 0x0049dd00 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049dc88
    mov ecx, dword ptr [ebp - local_6c]          # 0049dc8e
    cmp ecx, dword ptr [eax + field_1c]          # 0049dc91
    jge.d8 L_0049dd00                            # 0049dc94
    # block 0x0049dc96: entered by fall-through of jge at 0x0049dc94, 9 instruction(s), ends with jne to 0x0049dcfb (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dc96
    mov eax, dword ptr [ebp - local_68]          # 0049dc9c
    imul eax, dword ptr [edx + field_1c]         # 0049dc9f
    mov ecx, dword ptr [ebp - local_a0]          # 0049dca3
    mov edx, dword ptr [ecx + field_e38]         # 0049dca9
    lea eax, [edx + 4*eax]                       # 0049dcaf
    mov ecx, dword ptr [ebp - local_6c]          # 0049dcb2
    cmp dword ptr [eax + 4*ecx], 0x1             # 0049dcb5
    jne.d8 L_0049dcfb                            # 0049dcb9
    # block 0x0049dcbb: entered by fall-through of jne at 0x0049dcb9, 19 instruction(s), calls FUN_004a0ac4, falls into the block at 0x0049dcfb
    mov edx, dword ptr [ebp - local_a0]          # 0049dcbb
    mov eax, dword ptr [ebp - local_68]          # 0049dcc1
    imul eax, dword ptr [edx + field_1c]         # 0049dcc4
    mov ecx, dword ptr [ebp - local_a0]          # 0049dcc8
    mov edx, dword ptr [ecx + field_e38]         # 0049dcce
    lea eax, [edx + 4*eax]                       # 0049dcd4
    mov ecx, dword ptr [ebp - local_6c]          # 0049dcd7
    mov edx, dword ptr [ebp - local_78]          # 0049dcda
    mov dword ptr [eax + 4*ecx], edx             # 0049dcdd
    mov eax, dword ptr [ebp + arg_10]            # 0049dce0
    push eax                                     # 0049dce3
    mov ecx, dword ptr [ebp - local_74]          # 0049dce4
    push ecx                                     # 0049dce7
    mov edx, dword ptr [ebp - local_6c]          # 0049dce8
    push edx                                     # 0049dceb
    mov eax, dword ptr [ebp - local_68]          # 0049dcec
    push eax                                     # 0049dcef
    mov ecx, dword ptr [ebp - local_a0]          # 0049dcf0
    call FUN_004a0ac4                            # 0049dcf6
L_0049dcfb:
    # block 0x0049dcfb: entered by jne at 0x0049dcb9, 1 instruction(s), ends with backward jump to 0x0049dc65
    jmp.d32 L_0049dc65                           # 0049dcfb
L_0049dd00:
    # block 0x0049dd00: entered by jge at 0x0049dc86; jge at 0x0049dc94, 1 instruction(s), ends with backward jump to 0x0049dc1d
    jmp.d32 L_0049dc1d                           # 0049dd00
L_0049dd05:
    # block 0x0049dd05: entered by jge at 0x0049dc3e; jge at 0x0049dc50, 11 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0049dd3f
    call FUN_0050cd50                            # 0049dd05
    cdq                                          # 0049dd0a
    idiv dword ptr [ebp - local_94]              # 0049dd0b
    mov dword ptr [ebp - local_64], edx          # 0049dd11
    mov ecx, dword ptr [ebp - local_64]          # 0049dd14
    mov edx, dword ptr [ebp + 4*ecx - local_50]  # 0049dd17
    mov dword ptr [ebp - local_78], edx          # 0049dd1b
    mov eax, dword ptr [ebp + arg_8]             # 0049dd1e
    mov dword ptr [ebp - local_68], eax          # 0049dd21
    mov dword ptr [ebp - local_20], 0x0          # 0049dd24
    jmp.d8 L_0049dd3f                            # 0049dd2b
L_0049dd2d:
    # block 0x0049dd2d: entered by jmp at 0x0049de1c, 6 instruction(s), falls into the block at 0x0049dd3f
    mov ecx, dword ptr [ebp - local_68]          # 0049dd2d
    add ecx, 0x1                                 # 0049dd30
    mov dword ptr [ebp - local_68], ecx          # 0049dd33
    mov edx, dword ptr [ebp - local_20]          # 0049dd36
    add edx, 0x1                                 # 0049dd39
    mov dword ptr [ebp - local_20], edx          # 0049dd3c
L_0049dd3f:
    # block 0x0049dd3f: entered by jmp at 0x0049dd2b, 4 instruction(s), ends with jge to 0x0049de21 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049dd3f
    mov ecx, dword ptr [ebp - local_20]          # 0049dd45
    cmp ecx, dword ptr [eax + field_e28]         # 0049dd48
    jge.d32 L_0049de21                           # 0049dd4e
    # block 0x0049dd54: entered by fall-through of jge at 0x0049dd4e, 4 instruction(s), ends with jge to 0x0049de21 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dd54
    mov eax, dword ptr [ebp - local_68]          # 0049dd5a
    cmp eax, dword ptr [edx + field_20]          # 0049dd5d
    jge.d32 L_0049de21                           # 0049dd60
    # block 0x0049dd66: entered by fall-through of jge at 0x0049dd60, 6 instruction(s), ends with forward jump to 0x0049dd93
    mov ecx, dword ptr [ebp - local_a0]          # 0049dd66
    mov edx, dword ptr [ebp + arg_c]             # 0049dd6c
    add edx, dword ptr [ecx + field_e24]         # 0049dd6f
    mov dword ptr [ebp - local_6c], edx          # 0049dd75
    mov dword ptr [ebp - local_1c], 0x0          # 0049dd78
    jmp.d8 L_0049dd93                            # 0049dd7f
L_0049dd81:
    # block 0x0049dd81: entered by jmp at 0x0049de17, 6 instruction(s), falls into the block at 0x0049dd93
    mov eax, dword ptr [ebp - local_6c]          # 0049dd81
    add eax, 0x1                                 # 0049dd84
    mov dword ptr [ebp - local_6c], eax          # 0049dd87
    mov ecx, dword ptr [ebp - local_1c]          # 0049dd8a
    add ecx, 0x1                                 # 0049dd8d
    mov dword ptr [ebp - local_1c], ecx          # 0049dd90
L_0049dd93:
    # block 0x0049dd93: entered by jmp at 0x0049dd7f, 4 instruction(s), ends with jge to 0x0049de1c (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dd93
    mov eax, dword ptr [ebp - local_1c]          # 0049dd99
    cmp eax, dword ptr [edx + field_e24]         # 0049dd9c
    jge.d8 L_0049de1c                            # 0049dda2
    # block 0x0049dda4: entered by fall-through of jge at 0x0049dda2, 4 instruction(s), ends with jge to 0x0049de1c (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 0049dda4
    mov edx, dword ptr [ebp - local_6c]          # 0049ddaa
    cmp edx, dword ptr [ecx + field_1c]          # 0049ddad
    jge.d8 L_0049de1c                            # 0049ddb0
    # block 0x0049ddb2: entered by fall-through of jge at 0x0049ddb0, 9 instruction(s), ends with jne to 0x0049de17 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049ddb2
    mov ecx, dword ptr [ebp - local_68]          # 0049ddb8
    imul ecx, dword ptr [eax + field_1c]         # 0049ddbb
    mov edx, dword ptr [ebp - local_a0]          # 0049ddbf
    mov eax, dword ptr [edx + field_e38]         # 0049ddc5
    lea ecx, [eax + 4*ecx]                       # 0049ddcb
    mov edx, dword ptr [ebp - local_6c]          # 0049ddce
    cmp dword ptr [ecx + 4*edx], 0x1             # 0049ddd1
    jne.d8 L_0049de17                            # 0049ddd5
    # block 0x0049ddd7: entered by fall-through of jne at 0x0049ddd5, 19 instruction(s), calls FUN_004a0ac4, falls into the block at 0x0049de17
    mov eax, dword ptr [ebp - local_a0]          # 0049ddd7
    mov ecx, dword ptr [ebp - local_68]          # 0049dddd
    imul ecx, dword ptr [eax + field_1c]         # 0049dde0
    mov edx, dword ptr [ebp - local_a0]          # 0049dde4
    mov eax, dword ptr [edx + field_e38]         # 0049ddea
    lea ecx, [eax + 4*ecx]                       # 0049ddf0
    mov edx, dword ptr [ebp - local_6c]          # 0049ddf3
    mov eax, dword ptr [ebp - local_78]          # 0049ddf6
    mov dword ptr [ecx + 4*edx], eax             # 0049ddf9
    mov ecx, dword ptr [ebp + arg_10]            # 0049ddfc
    push ecx                                     # 0049ddff
    mov edx, dword ptr [ebp - local_74]          # 0049de00
    push edx                                     # 0049de03
    mov eax, dword ptr [ebp - local_6c]          # 0049de04
    push eax                                     # 0049de07
    mov ecx, dword ptr [ebp - local_68]          # 0049de08
    push ecx                                     # 0049de0b
    mov ecx, dword ptr [ebp - local_a0]          # 0049de0c
    call FUN_004a0ac4                            # 0049de12
L_0049de17:
    # block 0x0049de17: entered by jne at 0x0049ddd5, 1 instruction(s), ends with backward jump to 0x0049dd81
    jmp.d32 L_0049dd81                           # 0049de17
L_0049de1c:
    # block 0x0049de1c: entered by jge at 0x0049dda2; jge at 0x0049ddb0, 1 instruction(s), ends with backward jump to 0x0049dd2d
    jmp.d32 L_0049dd2d                           # 0049de1c
L_0049de21:
    # block 0x0049de21: entered by jge at 0x0049dd4e; jge at 0x0049dd60, 13 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0049de67
    call FUN_0050cd50                            # 0049de21
    cdq                                          # 0049de26
    idiv dword ptr [ebp - local_94]              # 0049de27
    mov dword ptr [ebp - local_64], edx          # 0049de2d
    mov edx, dword ptr [ebp - local_64]          # 0049de30
    mov eax, dword ptr [ebp + 4*edx - local_50]  # 0049de33
    mov dword ptr [ebp - local_78], eax          # 0049de37
    mov ecx, dword ptr [ebp - local_a0]          # 0049de3a
    mov edx, dword ptr [ebp + arg_8]             # 0049de40
    add edx, dword ptr [ecx + field_e28]         # 0049de43
    mov dword ptr [ebp - local_68], edx          # 0049de49
    mov dword ptr [ebp - local_20], 0x0          # 0049de4c
    jmp.d8 L_0049de67                            # 0049de53
L_0049de55:
    # block 0x0049de55: entered by jmp at 0x0049df38, 6 instruction(s), falls into the block at 0x0049de67
    mov eax, dword ptr [ebp - local_68]          # 0049de55
    add eax, 0x1                                 # 0049de58
    mov dword ptr [ebp - local_68], eax          # 0049de5b
    mov ecx, dword ptr [ebp - local_20]          # 0049de5e
    add ecx, 0x1                                 # 0049de61
    mov dword ptr [ebp - local_20], ecx          # 0049de64
L_0049de67:
    # block 0x0049de67: entered by jmp at 0x0049de53, 4 instruction(s), ends with jge to 0x0049df3d (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049de67
    mov eax, dword ptr [ebp - local_20]          # 0049de6d
    cmp eax, dword ptr [edx + field_e28]         # 0049de70
    jge.d32 L_0049df3d                           # 0049de76
    # block 0x0049de7c: entered by fall-through of jge at 0x0049de76, 4 instruction(s), ends with jge to 0x0049df3d (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 0049de7c
    mov edx, dword ptr [ebp - local_68]          # 0049de82
    cmp edx, dword ptr [ecx + field_20]          # 0049de85
    jge.d32 L_0049df3d                           # 0049de88
    # block 0x0049de8e: entered by fall-through of jge at 0x0049de88, 4 instruction(s), ends with forward jump to 0x0049deaf
    mov eax, dword ptr [ebp + arg_c]             # 0049de8e
    mov dword ptr [ebp - local_6c], eax          # 0049de91
    mov dword ptr [ebp - local_1c], 0x0          # 0049de94
    jmp.d8 L_0049deaf                            # 0049de9b
L_0049de9d:
    # block 0x0049de9d: entered by jmp at 0x0049df33, 6 instruction(s), falls into the block at 0x0049deaf
    mov ecx, dword ptr [ebp - local_6c]          # 0049de9d
    add ecx, 0x1                                 # 0049dea0
    mov dword ptr [ebp - local_6c], ecx          # 0049dea3
    mov edx, dword ptr [ebp - local_1c]          # 0049dea6
    add edx, 0x1                                 # 0049dea9
    mov dword ptr [ebp - local_1c], edx          # 0049deac
L_0049deaf:
    # block 0x0049deaf: entered by jmp at 0x0049de9b, 4 instruction(s), ends with jge to 0x0049df38 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049deaf
    mov ecx, dword ptr [ebp - local_1c]          # 0049deb5
    cmp ecx, dword ptr [eax + field_e24]         # 0049deb8
    jge.d8 L_0049df38                            # 0049debe
    # block 0x0049dec0: entered by fall-through of jge at 0x0049debe, 4 instruction(s), ends with jge to 0x0049df38 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dec0
    mov eax, dword ptr [ebp - local_6c]          # 0049dec6
    cmp eax, dword ptr [edx + field_1c]          # 0049dec9
    jge.d8 L_0049df38                            # 0049decc
    # block 0x0049dece: entered by fall-through of jge at 0x0049decc, 9 instruction(s), ends with jne to 0x0049df33 (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 0049dece
    mov edx, dword ptr [ebp - local_68]          # 0049ded4
    imul edx, dword ptr [ecx + field_1c]         # 0049ded7
    mov eax, dword ptr [ebp - local_a0]          # 0049dedb
    mov ecx, dword ptr [eax + field_e38]         # 0049dee1
    lea edx, [ecx + 4*edx]                       # 0049dee7
    mov eax, dword ptr [ebp - local_6c]          # 0049deea
    cmp dword ptr [edx + 4*eax], 0x1             # 0049deed
    jne.d8 L_0049df33                            # 0049def1
    # block 0x0049def3: entered by fall-through of jne at 0x0049def1, 19 instruction(s), calls FUN_004a0ac4, falls into the block at 0x0049df33
    mov ecx, dword ptr [ebp - local_a0]          # 0049def3
    mov edx, dword ptr [ebp - local_68]          # 0049def9
    imul edx, dword ptr [ecx + field_1c]         # 0049defc
    mov eax, dword ptr [ebp - local_a0]          # 0049df00
    mov ecx, dword ptr [eax + field_e38]         # 0049df06
    lea edx, [ecx + 4*edx]                       # 0049df0c
    mov eax, dword ptr [ebp - local_6c]          # 0049df0f
    mov ecx, dword ptr [ebp - local_78]          # 0049df12
    mov dword ptr [edx + 4*eax], ecx             # 0049df15
    mov edx, dword ptr [ebp + arg_10]            # 0049df18
    push edx                                     # 0049df1b
    mov eax, dword ptr [ebp - local_74]          # 0049df1c
    push eax                                     # 0049df1f
    mov ecx, dword ptr [ebp - local_6c]          # 0049df20
    push ecx                                     # 0049df23
    mov edx, dword ptr [ebp - local_68]          # 0049df24
    push edx                                     # 0049df27
    mov ecx, dword ptr [ebp - local_a0]          # 0049df28
    call FUN_004a0ac4                            # 0049df2e
L_0049df33:
    # block 0x0049df33: entered by jne at 0x0049def1, 1 instruction(s), ends with backward jump to 0x0049de9d
    jmp.d32 L_0049de9d                           # 0049df33
L_0049df38:
    # block 0x0049df38: entered by jge at 0x0049debe; jge at 0x0049decc, 1 instruction(s), ends with backward jump to 0x0049de55
    jmp.d32 L_0049de55                           # 0049df38
L_0049df3d:
    # block 0x0049df3d: entered by jge at 0x0049de76; jge at 0x0049de88, 13 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0049df83
    call FUN_0050cd50                            # 0049df3d
    cdq                                          # 0049df42
    idiv dword ptr [ebp - local_94]              # 0049df43
    mov dword ptr [ebp - local_64], edx          # 0049df49
    mov eax, dword ptr [ebp - local_64]          # 0049df4c
    mov ecx, dword ptr [ebp + 4*eax - local_50]  # 0049df4f
    mov dword ptr [ebp - local_78], ecx          # 0049df53
    mov edx, dword ptr [ebp - local_a0]          # 0049df56
    mov eax, dword ptr [ebp + arg_8]             # 0049df5c
    add eax, dword ptr [edx + field_e28]         # 0049df5f
    mov dword ptr [ebp - local_68], eax          # 0049df65
    mov dword ptr [ebp - local_20], 0x0          # 0049df68
    jmp.d8 L_0049df83                            # 0049df6f
L_0049df71:
    # block 0x0049df71: entered by jmp at 0x0049e060, 6 instruction(s), falls into the block at 0x0049df83
    mov ecx, dword ptr [ebp - local_68]          # 0049df71
    add ecx, 0x1                                 # 0049df74
    mov dword ptr [ebp - local_68], ecx          # 0049df77
    mov edx, dword ptr [ebp - local_20]          # 0049df7a
    add edx, 0x1                                 # 0049df7d
    mov dword ptr [ebp - local_20], edx          # 0049df80
L_0049df83:
    # block 0x0049df83: entered by jmp at 0x0049df6f, 4 instruction(s), ends with jge to 0x0049e065 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049df83
    mov ecx, dword ptr [ebp - local_20]          # 0049df89
    cmp ecx, dword ptr [eax + field_e28]         # 0049df8c
    jge.d32 L_0049e065                           # 0049df92
    # block 0x0049df98: entered by fall-through of jge at 0x0049df92, 4 instruction(s), ends with jge to 0x0049e065 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049df98
    mov eax, dword ptr [ebp - local_68]          # 0049df9e
    cmp eax, dword ptr [edx + field_20]          # 0049dfa1
    jge.d32 L_0049e065                           # 0049dfa4
    # block 0x0049dfaa: entered by fall-through of jge at 0x0049dfa4, 6 instruction(s), ends with forward jump to 0x0049dfd7
    mov ecx, dword ptr [ebp - local_a0]          # 0049dfaa
    mov edx, dword ptr [ebp + arg_c]             # 0049dfb0
    add edx, dword ptr [ecx + field_e24]         # 0049dfb3
    mov dword ptr [ebp - local_6c], edx          # 0049dfb9
    mov dword ptr [ebp - local_1c], 0x0          # 0049dfbc
    jmp.d8 L_0049dfd7                            # 0049dfc3
L_0049dfc5:
    # block 0x0049dfc5: entered by jmp at 0x0049e05b, 6 instruction(s), falls into the block at 0x0049dfd7
    mov eax, dword ptr [ebp - local_6c]          # 0049dfc5
    add eax, 0x1                                 # 0049dfc8
    mov dword ptr [ebp - local_6c], eax          # 0049dfcb
    mov ecx, dword ptr [ebp - local_1c]          # 0049dfce
    add ecx, 0x1                                 # 0049dfd1
    mov dword ptr [ebp - local_1c], ecx          # 0049dfd4
L_0049dfd7:
    # block 0x0049dfd7: entered by jmp at 0x0049dfc3, 4 instruction(s), ends with jge to 0x0049e060 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049dfd7
    mov eax, dword ptr [ebp - local_1c]          # 0049dfdd
    cmp eax, dword ptr [edx + field_e24]         # 0049dfe0
    jge.d8 L_0049e060                            # 0049dfe6
    # block 0x0049dfe8: entered by fall-through of jge at 0x0049dfe6, 4 instruction(s), ends with jge to 0x0049e060 (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 0049dfe8
    mov edx, dword ptr [ebp - local_6c]          # 0049dfee
    cmp edx, dword ptr [ecx + field_1c]          # 0049dff1
    jge.d8 L_0049e060                            # 0049dff4
    # block 0x0049dff6: entered by fall-through of jge at 0x0049dff4, 9 instruction(s), ends with jne to 0x0049e05b (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049dff6
    mov ecx, dword ptr [ebp - local_68]          # 0049dffc
    imul ecx, dword ptr [eax + field_1c]         # 0049dfff
    mov edx, dword ptr [ebp - local_a0]          # 0049e003
    mov eax, dword ptr [edx + field_e38]         # 0049e009
    lea ecx, [eax + 4*ecx]                       # 0049e00f
    mov edx, dword ptr [ebp - local_6c]          # 0049e012
    cmp dword ptr [ecx + 4*edx], 0x1             # 0049e015
    jne.d8 L_0049e05b                            # 0049e019
    # block 0x0049e01b: entered by fall-through of jne at 0x0049e019, 19 instruction(s), calls FUN_004a0ac4, falls into the block at 0x0049e05b
    mov eax, dword ptr [ebp - local_a0]          # 0049e01b
    mov ecx, dword ptr [ebp - local_68]          # 0049e021
    imul ecx, dword ptr [eax + field_1c]         # 0049e024
    mov edx, dword ptr [ebp - local_a0]          # 0049e028
    mov eax, dword ptr [edx + field_e38]         # 0049e02e
    lea ecx, [eax + 4*ecx]                       # 0049e034
    mov edx, dword ptr [ebp - local_6c]          # 0049e037
    mov eax, dword ptr [ebp - local_78]          # 0049e03a
    mov dword ptr [ecx + 4*edx], eax             # 0049e03d
    mov ecx, dword ptr [ebp + arg_10]            # 0049e040
    push ecx                                     # 0049e043
    mov edx, dword ptr [ebp - local_74]          # 0049e044
    push edx                                     # 0049e047
    mov eax, dword ptr [ebp - local_6c]          # 0049e048
    push eax                                     # 0049e04b
    mov ecx, dword ptr [ebp - local_68]          # 0049e04c
    push ecx                                     # 0049e04f
    mov ecx, dword ptr [ebp - local_a0]          # 0049e050
    call FUN_004a0ac4                            # 0049e056
L_0049e05b:
    # block 0x0049e05b: entered by jne at 0x0049e019, 1 instruction(s), ends with backward jump to 0x0049dfc5
    jmp.d32 L_0049dfc5                           # 0049e05b
L_0049e060:
    # block 0x0049e060: entered by jge at 0x0049dfe6; jge at 0x0049dff4, 1 instruction(s), ends with backward jump to 0x0049df71
    jmp.d32 L_0049df71                           # 0049e060
L_0049e065:
    # block 0x0049e065: entered by jge at 0x0049df92; jge at 0x0049dfa4, 18 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0049e0bf
    call FUN_0050cd50                            # 0049e065
    cdq                                          # 0049e06a
    idiv dword ptr [ebp - local_70]              # 0049e06b
    mov dword ptr [ebp - local_24], edx          # 0049e06e
    call FUN_0050cd50                            # 0049e071
    cdq                                          # 0049e076
    idiv dword ptr [ebp - local_98]              # 0049e077
    mov dword ptr [ebp - local_60], edx          # 0049e07d
    mov edx, dword ptr [ebp - local_24]          # 0049e080
    mov ax, word ptr [ebp + 2*edx - local_14]    # 0049e083
    mov word ptr [ebp - local_28], ax            # 0049e088
    mov ecx, dword ptr [ebp - local_60]          # 0049e08c
    mov dx, word ptr [ebp + 2*ecx - local_8c]    # 0049e08f
    mov word ptr [ebp - local_9c], dx            # 0049e097
    mov eax, dword ptr [ebp + arg_8]             # 0049e09e
    mov dword ptr [ebp - local_68], eax          # 0049e0a1
    mov dword ptr [ebp - local_20], 0x0          # 0049e0a4
    jmp.d8 L_0049e0bf                            # 0049e0ab
L_0049e0ad:
    # block 0x0049e0ad: entered by jmp at 0x0049e177, 6 instruction(s), falls into the block at 0x0049e0bf
    mov ecx, dword ptr [ebp - local_68]          # 0049e0ad
    add ecx, 0x1                                 # 0049e0b0
    mov dword ptr [ebp - local_68], ecx          # 0049e0b3
    mov edx, dword ptr [ebp - local_20]          # 0049e0b6
    add edx, 0x1                                 # 0049e0b9
    mov dword ptr [ebp - local_20], edx          # 0049e0bc
L_0049e0bf:
    # block 0x0049e0bf: entered by jmp at 0x0049e0ab, 4 instruction(s), ends with jge to 0x0049e17c (forward)
    mov eax, dword ptr [ebp - local_a0]          # 0049e0bf
    mov ecx, dword ptr [ebp - local_20]          # 0049e0c5
    cmp ecx, dword ptr [eax + field_e20]         # 0049e0c8
    jge.d32 L_0049e17c                           # 0049e0ce
    # block 0x0049e0d4: entered by fall-through of jge at 0x0049e0ce, 4 instruction(s), ends with forward jump to 0x0049e0f5
    mov edx, dword ptr [ebp + arg_c]             # 0049e0d4
    mov dword ptr [ebp - local_6c], edx          # 0049e0d7
    mov dword ptr [ebp - local_1c], 0x0          # 0049e0da
    jmp.d8 L_0049e0f5                            # 0049e0e1
L_0049e0e3:
    # block 0x0049e0e3: entered by jmp at 0x0049e172, 6 instruction(s), falls into the block at 0x0049e0f5
    mov eax, dword ptr [ebp - local_6c]          # 0049e0e3
    add eax, 0x1                                 # 0049e0e6
    mov dword ptr [ebp - local_6c], eax          # 0049e0e9
    mov ecx, dword ptr [ebp - local_1c]          # 0049e0ec
    add ecx, 0x1                                 # 0049e0ef
    mov dword ptr [ebp - local_1c], ecx          # 0049e0f2
L_0049e0f5:
    # block 0x0049e0f5: entered by jmp at 0x0049e0e1, 4 instruction(s), ends with jge to 0x0049e177 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049e0f5
    mov eax, dword ptr [ebp - local_1c]          # 0049e0fb
    cmp eax, dword ptr [edx + field_e1c]         # 0049e0fe
    jge.d8 L_0049e177                            # 0049e104
    # block 0x0049e106: entered by fall-through of jge at 0x0049e104, 29 instruction(s), calls FUN_004a0bbd, ends with backward jump to 0x0049e0e3
    mov ecx, dword ptr [ebp - local_a0]          # 0049e106
    mov edx, dword ptr [ebp - local_68]          # 0049e10c
    imul edx, dword ptr [ecx + field_1c]         # 0049e10f
    mov eax, dword ptr [ebp - local_a0]          # 0049e113
    mov ecx, dword ptr [eax + field_e30]         # 0049e119
    lea edx, [ecx + 2*edx]                       # 0049e11f
    mov eax, dword ptr [ebp - local_6c]          # 0049e122
    mov cx, word ptr [ebp - local_28]            # 0049e125
    mov word ptr [edx + 2*eax], cx               # 0049e129
    mov edx, dword ptr [ebp - local_a0]          # 0049e12d
    mov eax, dword ptr [ebp - local_68]          # 0049e133
    imul eax, dword ptr [edx + field_1c]         # 0049e136
    mov ecx, dword ptr [ebp - local_a0]          # 0049e13a
    mov edx, dword ptr [ecx + field_e34]         # 0049e140
    lea eax, [edx + 2*eax]                       # 0049e146
    mov ecx, dword ptr [ebp - local_6c]          # 0049e149
    mov dx, word ptr [ebp - local_9c]            # 0049e14c
    mov word ptr [eax + 2*ecx], dx               # 0049e153
    mov eax, dword ptr [ebp + arg_10]            # 0049e157
    push eax                                     # 0049e15a
    mov ecx, dword ptr [ebp - local_74]          # 0049e15b
    push ecx                                     # 0049e15e
    mov edx, dword ptr [ebp - local_6c]          # 0049e15f
    push edx                                     # 0049e162
    mov eax, dword ptr [ebp - local_68]          # 0049e163
    push eax                                     # 0049e166
    mov ecx, dword ptr [ebp - local_a0]          # 0049e167
    call FUN_004a0bbd                            # 0049e16d
    jmp.d32 L_0049e0e3                           # 0049e172
L_0049e177:
    # block 0x0049e177: entered by jge at 0x0049e104, 1 instruction(s), ends with backward jump to 0x0049e0ad
    jmp.d32 L_0049e0ad                           # 0049e177
L_0049e17c:
    # block 0x0049e17c: entered by jge at 0x0049e0ce, 6 instruction(s), ends with jle to 0x0049e1ae (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0049e17c
    imul ecx, ecx, 0x15e                         # 0049e17f
    mov edx, dword ptr [ebp - local_a0]          # 0049e185
    movsx eax, word ptr [edx + ecx + field_184]  # 0049e18b
    test eax, eax                                # 0049e193
    jle.d8 L_0049e1ae                            # 0049e195
    # block 0x0049e197: entered by fall-through of jle at 0x0049e195, 8 instruction(s), calls FUN_004a0365, falls into the block at 0x0049e1ae
    mov ecx, dword ptr [ebp + arg_c]             # 0049e197
    push ecx                                     # 0049e19a
    mov edx, dword ptr [ebp + arg_8]             # 0049e19b
    push edx                                     # 0049e19e
    mov eax, dword ptr [ebp - local_54]          # 0049e19f
    push eax                                     # 0049e1a2
    mov ecx, dword ptr [ebp - local_a0]          # 0049e1a3
    call FUN_004a0365                            # 0049e1a9
L_0049e1ae:
    # block 0x0049e1ae: entered by jle at 0x0049e195, 6 instruction(s), ends with jle to 0x0049e1e0 (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0049e1ae
    imul ecx, ecx, 0x15e                         # 0049e1b1
    mov edx, dword ptr [ebp - local_a0]          # 0049e1b7
    movsx eax, word ptr [edx + ecx + field_186]  # 0049e1bd
    test eax, eax                                # 0049e1c5
    jle.d8 L_0049e1e0                            # 0049e1c7
    # block 0x0049e1c9: entered by fall-through of jle at 0x0049e1c7, 8 instruction(s), calls FUN_0049f86a, falls into the block at 0x0049e1e0
    mov ecx, dword ptr [ebp + arg_c]             # 0049e1c9
    push ecx                                     # 0049e1cc
    mov edx, dword ptr [ebp + arg_8]             # 0049e1cd
    push edx                                     # 0049e1d0
    mov eax, dword ptr [ebp - local_54]          # 0049e1d1
    push eax                                     # 0049e1d4
    mov ecx, dword ptr [ebp - local_a0]          # 0049e1d5
    call FUN_0049f86a                            # 0049e1db
L_0049e1e0:
    # block 0x0049e1e0: entered by jle at 0x0049e1c7, 6 instruction(s), ends with jle to 0x0049e212 (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0049e1e0
    imul ecx, ecx, 0x15e                         # 0049e1e3
    mov edx, dword ptr [ebp - local_a0]          # 0049e1e9
    movsx eax, word ptr [edx + ecx + field_188]  # 0049e1ef
    test eax, eax                                # 0049e1f7
    jle.d8 L_0049e212                            # 0049e1f9
    # block 0x0049e1fb: entered by fall-through of jle at 0x0049e1f9, 8 instruction(s), calls FUN_0049e455, falls into the block at 0x0049e212
    mov ecx, dword ptr [ebp + arg_c]             # 0049e1fb
    push ecx                                     # 0049e1fe
    mov edx, dword ptr [ebp + arg_8]             # 0049e1ff
    push edx                                     # 0049e202
    mov eax, dword ptr [ebp - local_54]          # 0049e203
    push eax                                     # 0049e206
    mov ecx, dword ptr [ebp - local_a0]          # 0049e207
    call FUN_0049e455                            # 0049e20d
L_0049e212:
    # block 0x0049e212: entered by jle at 0x0049e1f9, 6 instruction(s), ends with je to 0x0049e244 (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0049e212
    imul ecx, ecx, 0x15e                         # 0049e215
    mov edx, dword ptr [ebp - local_a0]          # 0049e21b
    movsx eax, word ptr [edx + ecx + field_182]  # 0049e221
    test eax, eax                                # 0049e229
    je.d8 L_0049e244                             # 0049e22b
    # block 0x0049e22d: entered by fall-through of je at 0x0049e22b, 8 instruction(s), calls FUN_0049e24d, falls into the block at 0x0049e244
    mov ecx, dword ptr [ebp + arg_10]            # 0049e22d
    push ecx                                     # 0049e230
    mov edx, dword ptr [ebp + arg_c]             # 0049e231
    push edx                                     # 0049e234
    mov eax, dword ptr [ebp + arg_8]             # 0049e235
    push eax                                     # 0049e238
    mov ecx, dword ptr [ebp - local_a0]          # 0049e239
    call FUN_0049e24d                            # 0049e23f
L_0049e244:
    # block 0x0049e244: entered by je at 0x0049e22b, 4 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp - local_54]          # 0049e244
    {load} mov esp, ebp                          # 0049e247
    pop ebp                                      # 0049e249
    ret 0xc                                      # 0049e24a

