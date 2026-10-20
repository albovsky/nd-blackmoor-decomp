# FUN_00464c59
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464c59
# extent:       0x00464c59-0x00464f55 (764 code bytes)
# span:         0x00464c59-0x00464f55 (code 764, tables 0, padding 0)
# sha256:       fb1f838f00c9eb2c9e89eaea4d3369993d58c051dc71dd4508216c7c71068e0e
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m464c59_click_27c9_27cd
# naming:       native port src/original_methods_fl24b.c:m464c59_click_27c9_27cd (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m464c59_click_27c9_27cd (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 600 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_2a, field_2e, field_36, field_8a, field_8c, field_90, field_b8, field_bc and 1 more; [ecx + n] field_1e, field_2a, field_2e, field_32, field_36, field_38, field_61, field_8a, field_90, field_94, field_c1; [edx + n] field_4, field_8, field_c, field_2a, field_36, field_38, field_69, field_6d, field_8a, field_8c, field_d2, field_d4; [esi + n] field_61, field_65
# callees:      calls FUN_00464fff, FUN_004641bb, FUN_00464faa, FUN_00464f55, FUN_00465075
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m464c59_click_27c9_27cd (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 181 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_38, 0x38  # offset +0x38
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_69, 0x69  # offset +0x69
.equ field_6d, 0x6d  # offset +0x6d
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_bd, 0xbd  # offset +0xbd
.equ field_c1, 0xc1  # offset +0xc1
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d4, 0xd4  # offset +0xd4

# --- external targets -----------------------------------------------
.set FUN_004641bb, .text + (0x004641bb - 0x401000)
.set FUN_00464f55, .text + (0x00464f55 - 0x401000)
.set FUN_00464faa, .text + (0x00464faa - 0x401000)
.set FUN_00464fff, .text + (0x00464fff - 0x401000)
.set FUN_00465075, .text + (0x00465075 - 0x401000)

.org 0x00464c59 - 0x401000
.globl FUN_00464c59
FUN_00464c59:
    # block 0x00464c59: entry, 13 instruction(s), ends with je to 0x00464f50 (forward)
    push ebp                                     # 00464c59
    {load} mov ebp, esp                          # 00464c5a
    sub esp, 0x8                                 # 00464c5c
    push esi                                     # 00464c5f
    mov dword ptr [ebp - local_8], ecx           # 00464c60
    mov eax, dword ptr [ebp - local_8]           # 00464c63
    movsx ecx, word ptr [eax + field_1e]         # 00464c66
    imul ecx, ecx, 0x8d                          # 00464c6a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00464c70
    mov dword ptr [ebp - local_4], edx           # 00464c76
    mov eax, dword ptr [ebp - local_8]           # 00464c79
    cmp dword ptr [eax + field_b8], 0x0          # 00464c7c
    je.d32 L_00464f50                            # 00464c83
    # block 0x00464c89: entered by fall-through of je at 0x00464c83, 5 instruction(s), ends with jne to 0x00464f50 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00464c89
    {load} xor edx, edx                          # 00464c8c
    mov dl, byte ptr [ecx + field_c1]            # 00464c8e
    test edx, edx                                # 00464c94
    jne.d32 L_00464f50                           # 00464c96
    # block 0x00464c9c: entered by fall-through of jne at 0x00464c96, 3 instruction(s), ends with jne to 0x00464f50 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464c9c
    cmp dword ptr [eax + field_bd], 0x0          # 00464c9f
    jne.d32 L_00464f50                           # 00464ca6
    # block 0x00464cac: entered by fall-through of jne at 0x00464ca6, 5 instruction(s), ends with jne to 0x00464f50 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00464cac
    movsx edx, word ptr [ecx + field_1e]         # 00464caf
    imul edx, edx, 0x8d                          # 00464cb3
    cmp dword ptr [edx + 0x5bb632], 0x1          # 00464cb9
    jne.d32 L_00464f50                           # 00464cc0
    # block 0x00464cc6: entered by fall-through of jne at 0x00464cc0, 2 instruction(s), ends with jne to 0x00464cf8 (forward)
    cmp dword ptr [0x5c39e5], 0x27cc             # 00464cc6
    jne.d8 L_00464cf8                            # 00464cd0
    # block 0x00464cd2: entered by fall-through of jne at 0x00464cd0, 7 instruction(s), ends with forward jump to 0x00464f50
    mov eax, dword ptr [ebp - local_8]           # 00464cd2
    mov byte ptr [eax + field_bc], 0x1           # 00464cd5
    mov ecx, dword ptr [ebp - local_8]           # 00464cdc
    movsx edx, word ptr [ecx + field_1e]         # 00464cdf
    imul edx, edx, 0x8d                          # 00464ce3
    mov dword ptr [edx + 0x5bb632], 0x2          # 00464ce9
    jmp.d32 L_00464f50                           # 00464cf3
L_00464cf8:
    # block 0x00464cf8: entered by jne at 0x00464cd0, 2 instruction(s), ends with jne to 0x00464d4e (forward)
    cmp dword ptr [0x5c39e5], 0x27cb             # 00464cf8
    jne.d8 L_00464d4e                            # 00464d02
    # block 0x00464d04: entered by fall-through of jne at 0x00464d02, 4 instruction(s), ends with jge to 0x00464d2d (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464d04
    movsx ecx, word ptr [eax + field_8a]         # 00464d07
    cmp ecx, 0x3                                 # 00464d0e
    jge.d8 L_00464d2d                            # 00464d11
    # block 0x00464d13: entered by fall-through of jge at 0x00464d11, 6 instruction(s), ends with forward jump to 0x00464d39
    mov edx, dword ptr [ebp - local_8]           # 00464d13
    mov ax, word ptr [edx + field_8a]            # 00464d16
    .insn 0x66, 0x05, 0x0001{:u16}               # 00464d1d
    mov ecx, dword ptr [ebp - local_8]           # 00464d21
    mov word ptr [ecx + field_8a], ax            # 00464d24
    jmp.d8 L_00464d39                            # 00464d2b
L_00464d2d:
    # block 0x00464d2d: entered by jge at 0x00464d11, 2 instruction(s), falls into the block at 0x00464d39
    mov edx, dword ptr [ebp - local_8]           # 00464d2d
    mov word ptr [edx + field_8a], 0x0           # 00464d30
L_00464d39:
    # block 0x00464d39: entered by jmp at 0x00464d2b, 5 instruction(s), calls FUN_00464fff, FUN_004641bb, ends with forward jump to 0x00464f50
    mov ecx, dword ptr [ebp - local_8]           # 00464d39
    call FUN_00464fff                            # 00464d3c
    mov ecx, dword ptr [ebp - local_8]           # 00464d41
    call FUN_004641bb                            # 00464d44
    jmp.d32 L_00464f50                           # 00464d49
L_00464d4e:
    # block 0x00464d4e: entered by jne at 0x00464d02, 2 instruction(s), ends with jne to 0x00464da3 (forward)
    cmp dword ptr [0x5c39e5], 0x27ca             # 00464d4e
    jne.d8 L_00464da3                            # 00464d58
    # block 0x00464d5a: entered by fall-through of jne at 0x00464d58, 4 instruction(s), ends with jle to 0x00464d82 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464d5a
    movsx ecx, word ptr [eax + field_8a]         # 00464d5d
    test ecx, ecx                                # 00464d64
    jle.d8 L_00464d82                            # 00464d66
    # block 0x00464d68: entered by fall-through of jle at 0x00464d66, 6 instruction(s), ends with forward jump to 0x00464d8e
    mov edx, dword ptr [ebp - local_8]           # 00464d68
    mov ax, word ptr [edx + field_8a]            # 00464d6b
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00464d72
    mov ecx, dword ptr [ebp - local_8]           # 00464d76
    mov word ptr [ecx + field_8a], ax            # 00464d79
    jmp.d8 L_00464d8e                            # 00464d80
L_00464d82:
    # block 0x00464d82: entered by jle at 0x00464d66, 2 instruction(s), falls into the block at 0x00464d8e
    mov edx, dword ptr [ebp - local_8]           # 00464d82
    mov word ptr [edx + field_8a], 0x3           # 00464d85
L_00464d8e:
    # block 0x00464d8e: entered by jmp at 0x00464d80, 5 instruction(s), calls FUN_00464fff, FUN_004641bb, ends with forward jump to 0x00464f50
    mov ecx, dword ptr [ebp - local_8]           # 00464d8e
    call FUN_00464fff                            # 00464d91
    mov ecx, dword ptr [ebp - local_8]           # 00464d96
    call FUN_004641bb                            # 00464d99
    jmp.d32 L_00464f50                           # 00464d9e
L_00464da3:
    # block 0x00464da3: entered by jne at 0x00464d58, 2 instruction(s), ends with jne to 0x00464eb5 (forward)
    cmp dword ptr [0x5c39e5], 0x27c9             # 00464da3
    jne.d32 L_00464eb5                           # 00464dad
    # block 0x00464db3: entered by fall-through of jne at 0x00464dad, 3 instruction(s), ends with je to 0x00464dce (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464db3
    cmp dword ptr [eax + field_2a], 0x0          # 00464db6
    je.d8 L_00464dce                             # 00464dba
    # block 0x00464dbc: entered by fall-through of je at 0x00464dba, 4 instruction(s), calls FUN_00464faa, falls into the block at 0x00464dce
    mov ecx, dword ptr [ebp - local_8]           # 00464dbc
    call FUN_00464faa                            # 00464dbf
    mov ecx, dword ptr [ebp - local_8]           # 00464dc4
    mov dword ptr [ecx + field_2e], 0x1          # 00464dc7
L_00464dce:
    # block 0x00464dce: entered by je at 0x00464dba, 3 instruction(s), ends with je to 0x00464e01 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00464dce
    cmp dword ptr [edx + field_2a], 0x0          # 00464dd1
    je.d8 L_00464e01                             # 00464dd5
    # block 0x00464dd7: entered by fall-through of je at 0x00464dd5, 6 instruction(s), ends with jne to 0x00464e01 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464dd7
    movsx ecx, word ptr [eax + field_36]         # 00464dda
    mov edx, dword ptr [ebp - local_8]           # 00464dde
    movsx eax, word ptr [edx + field_38]         # 00464de1
    {load} cmp ecx, eax                          # 00464de5
    jne.d8 L_00464e01                            # 00464de7
    # block 0x00464de9: entered by fall-through of jne at 0x00464de7, 5 instruction(s), ends with forward jump to 0x00464eb0
    mov ecx, dword ptr [ebp - local_8]           # 00464de9
    mov dword ptr [ecx + field_2a], 0x0          # 00464dec
    mov edx, dword ptr [ebp - local_8]           # 00464df3
    mov word ptr [edx + field_36], 0xffff        # 00464df6
    jmp.d32 L_00464eb0                           # 00464dfc
L_00464e01:
    # block 0x00464e01: entered by je at 0x00464dd5; jne at 0x00464de7, 49 instruction(s), calls FUN_00464f55, falls into the block at 0x00464eb0
    mov eax, dword ptr [ebp - local_8]           # 00464e01
    mov ecx, dword ptr [ebp - local_8]           # 00464e04
    mov dx, word ptr [ecx + field_38]            # 00464e07
    mov word ptr [eax + field_36], dx            # 00464e0b
    mov eax, dword ptr [ebp - local_8]           # 00464e0f
    movsx ecx, word ptr [eax + field_36]         # 00464e12
    shl ecx, 0x5                                 # 00464e16
    mov edx, dword ptr [ebp - local_8]           # 00464e19
    movsx eax, word ptr [edx + field_36]         # 00464e1c
    shl eax, 0x5                                 # 00464e20
    mov edx, dword ptr [ebp - local_4]           # 00464e23
    mov esi, dword ptr [ebp - local_4]           # 00464e26
    mov ecx, dword ptr [edx + ecx + field_69]    # 00464e29
    sub ecx, dword ptr [esi + eax + field_61]    # 00464e2d
    mov edx, dword ptr [ebp - local_8]           # 00464e31
    mov word ptr [edx + field_d2], cx            # 00464e34
    mov eax, dword ptr [ebp - local_8]           # 00464e3b
    movsx ecx, word ptr [eax + field_36]         # 00464e3e
    shl ecx, 0x5                                 # 00464e42
    mov edx, dword ptr [ebp - local_8]           # 00464e45
    movsx eax, word ptr [edx + field_36]         # 00464e48
    shl eax, 0x5                                 # 00464e4c
    mov edx, dword ptr [ebp - local_4]           # 00464e4f
    mov esi, dword ptr [ebp - local_4]           # 00464e52
    mov ecx, dword ptr [edx + ecx + field_6d]    # 00464e55
    sub ecx, dword ptr [esi + eax + field_65]    # 00464e59
    mov edx, dword ptr [ebp - local_8]           # 00464e5d
    mov word ptr [edx + field_d4], cx            # 00464e60
    mov ecx, dword ptr [ebp - local_8]           # 00464e67
    call FUN_00464f55                            # 00464e6a
    mov eax, dword ptr [ebp - local_8]           # 00464e6f
    mov dword ptr [eax + field_2a], 0x1          # 00464e72
    mov ecx, dword ptr [ebp - local_8]           # 00464e79
    mov dword ptr [ecx + field_32], 0x1          # 00464e7c
    mov edx, dword ptr [ebp - local_8]           # 00464e83
    movsx eax, word ptr [edx + field_36]         # 00464e86
    shl eax, 0x5                                 # 00464e8a
    mov ecx, dword ptr [ebp - local_4]           # 00464e8d
    lea edx, [ecx + eax + field_61]              # 00464e90
    mov eax, dword ptr [ebp - local_8]           # 00464e94
    add eax, 0x7a                                # 00464e97
    mov ecx, dword ptr [edx]                     # 00464e9a
    mov dword ptr [eax], ecx                     # 00464e9c
    mov ecx, dword ptr [edx + field_4]           # 00464e9e
    mov dword ptr [eax + field_4], ecx           # 00464ea1
    mov ecx, dword ptr [edx + field_8]           # 00464ea4
    mov dword ptr [eax + field_8], ecx           # 00464ea7
    mov edx, dword ptr [edx + field_c]           # 00464eaa
    mov dword ptr [eax + field_c], edx           # 00464ead
L_00464eb0:
    # block 0x00464eb0: entered by jmp at 0x00464dfc, 1 instruction(s), ends with forward jump to 0x00464f50
    jmp.d32 L_00464f50                           # 00464eb0
L_00464eb5:
    # block 0x00464eb5: entered by jne at 0x00464dad, 2 instruction(s), ends with jne to 0x00464f50 (forward)
    cmp dword ptr [0x5c39e5], 0x27cd             # 00464eb5
    jne.d32 L_00464f50                           # 00464ebf
    # block 0x00464ec5: entered by fall-through of jne at 0x00464ebf, 5 instruction(s), calls FUN_00464faa, ends with je to 0x00464ef5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00464ec5
    call FUN_00464faa                            # 00464ec8
    mov eax, dword ptr [ebp - local_8]           # 00464ecd
    cmp dword ptr [eax + field_8c], 0x0          # 00464ed0
    je.d8 L_00464ef5                             # 00464ed7
    # block 0x00464ed9: entered by fall-through of je at 0x00464ed7, 5 instruction(s), ends with forward jump to 0x00464f0e
    mov ecx, dword ptr [ebp - local_8]           # 00464ed9
    mov dword ptr [ecx + field_90], 0x1          # 00464edc
    mov edx, dword ptr [ebp - local_8]           # 00464ee6
    mov dword ptr [edx + field_8c], 0x0          # 00464ee9
    jmp.d8 L_00464f0e                            # 00464ef3
L_00464ef5:
    # block 0x00464ef5: entered by je at 0x00464ed7, 3 instruction(s), ends with je to 0x00464f0e (forward)
    mov eax, dword ptr [ebp - local_8]           # 00464ef5
    cmp dword ptr [eax + field_90], 0x0          # 00464ef8
    je.d8 L_00464f0e                             # 00464eff
    # block 0x00464f01: entered by fall-through of je at 0x00464eff, 2 instruction(s), falls into the block at 0x00464f0e
    mov ecx, dword ptr [ebp - local_8]           # 00464f01
    mov dword ptr [ecx + field_90], 0x0          # 00464f04
L_00464f0e:
    # block 0x00464f0e: entered by jmp at 0x00464ef3; je at 0x00464eff, 14 instruction(s), calls FUN_004641bb, FUN_00465075, falls into the block at 0x00464f50
    mov edx, dword ptr [ebp - local_8]           # 00464f0e
    movsx eax, word ptr [edx + field_36]         # 00464f11
    mov ecx, dword ptr [ebp - local_8]           # 00464f15
    mov dword ptr [ecx + 4*eax + field_94], 0x1  # 00464f18
    mov edx, dword ptr [ebp - local_8]           # 00464f23
    mov dword ptr [edx + field_2a], 0x0          # 00464f26
    mov ecx, dword ptr [ebp - local_8]           # 00464f2d
    call FUN_004641bb                            # 00464f30
    mov eax, dword ptr [ebp - local_8]           # 00464f35
    mov dword ptr [eax + field_2e], 0x1          # 00464f38
    mov ecx, dword ptr [ebp - local_8]           # 00464f3f
    mov word ptr [ecx + field_36], 0xffff        # 00464f42
    mov ecx, dword ptr [ebp - local_8]           # 00464f48
    call FUN_00465075                            # 00464f4b
L_00464f50:
    # block 0x00464f50: entered by je at 0x00464c83; jne at 0x00464c96; jne at 0x00464ca6; jne at 0x00464cc0; more, 4 instruction(s), ends with ret
    pop esi                                      # 00464f50
    {load} mov esp, ebp                          # 00464f51
    pop ebp                                      # 00464f53
    ret                                          # 00464f54

