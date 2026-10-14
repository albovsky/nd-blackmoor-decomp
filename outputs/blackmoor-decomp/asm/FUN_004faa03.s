# FUN_004faa03
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004faa03
# extent:       0x004faa03-0x004fad50 (845 code bytes)
# span:         0x004faa03-0x004fad50 (code 845, tables 0, padding 0)
# sha256:       491e2d51e5c4cdd959f82393271b57b982ad2c983fb73b8084345cdc2c4c02bf
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f2710, .text + (0x004f2710 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004faa03 - 0x401000
.globl FUN_004faa03
FUN_004faa03:
    # block 0x004faa03: <unfilled>
    push ebp                                     # 004faa03
    {load} mov ebp, esp                          # 004faa04
    sub esp, 0x8                                 # 004faa06
    mov dword ptr [ebp - local_8], ecx           # 004faa09
    mov ecx, 0x5cf1eb                            # 004faa0c
    call FUN_004f709c                            # 004faa11
    test eax, eax                                # 004faa16
    je.d8 L_004faa1f                             # 004faa18
    # block 0x004faa1a: <unfilled>
    jmp.d32 L_004fad4a                           # 004faa1a
L_004faa1f:
    # block 0x004faa1f: <unfilled>
    movsx eax, word ptr [0x63a4cd]               # 004faa1f
    test eax, eax                                # 004faa26
    je.d8 L_004faa37                             # 004faa28
    # block 0x004faa2a: <unfilled>
    push 0x56051c                                # 004faa2a
    call FUN_0044a2b7                            # 004faa2f
    add esp, 0x4                                 # 004faa34
L_004faa37:
    # block 0x004faa37: <unfilled>
    mov dword ptr [ebp - local_4], 0x0           # 004faa37
    jmp.d8 L_004faa49                            # 004faa3e
L_004faa40:
    # block 0x004faa40: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004faa40
    add ecx, 0x1                                 # 004faa43
    mov dword ptr [ebp - local_4], ecx           # 004faa46
L_004faa49:
    # block 0x004faa49: <unfilled>
    cmp dword ptr [ebp - local_4], 0x20          # 004faa49
    jge.d32 L_004fabd3                           # 004faa4d
    # block 0x004faa53: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004faa53
    imul edx, edx, 0x5bb                         # 004faa56
    mov eax, dword ptr [ebp - local_8]           # 004faa5c
    mov word ptr [eax + edx + 0x132], 0x0        # 004faa5f
    mov ecx, dword ptr [ebp - local_4]           # 004faa69
    imul ecx, ecx, 0x5bb                         # 004faa6c
    mov edx, dword ptr [ebp - local_8]           # 004faa72
    mov word ptr [edx + ecx + 0x10c], 0x3        # 004faa75
    mov eax, dword ptr [ebp - local_4]           # 004faa7f
    imul eax, eax, 0x5bb                         # 004faa82
    mov ecx, dword ptr [ebp - local_8]           # 004faa88
    mov dword ptr [ecx + eax + 0x12c], 0x0       # 004faa8b
    mov edx, dword ptr [ebp - local_4]           # 004faa96
    imul edx, edx, 0x5bb                         # 004faa99
    mov eax, dword ptr [ebp - local_8]           # 004faa9f
    mov dword ptr [eax + edx + 0x28b], 0x0       # 004faaa2
    mov ecx, dword ptr [ebp - local_4]           # 004faaad
    imul ecx, ecx, 0x5bb                         # 004faab0
    mov edx, dword ptr [ebp - local_8]           # 004faab6
    mov eax, dword ptr [ebp - local_4]           # 004faab9
    mov dword ptr [edx + ecx + 0x4], eax         # 004faabc
    mov ecx, dword ptr [ebp - local_4]           # 004faac0
    imul ecx, ecx, 0x5bb                         # 004faac3
    mov edx, dword ptr [ebp - local_8]           # 004faac9
    mov byte ptr [edx + ecx + 0x8], 0x0          # 004faacc
    mov eax, dword ptr [ebp - local_4]           # 004faad1
    imul eax, eax, 0x5bb                         # 004faad4
    mov ecx, dword ptr [ebp - local_8]           # 004faada
    mov dword ptr [ecx + eax + 0x293], 0x0       # 004faadd
    mov edx, dword ptr [ebp - local_4]           # 004faae8
    imul edx, edx, 0x5bb                         # 004faaeb
    mov eax, dword ptr [ebp - local_8]           # 004faaf1
    mov dword ptr [eax + edx + 0x29f], 0x0       # 004faaf4
    mov ecx, dword ptr [ebp - local_4]           # 004faaff
    imul ecx, ecx, 0x5bb                         # 004fab02
    mov edx, dword ptr [ebp - local_8]           # 004fab08
    mov dword ptr [edx + ecx + 0x15a], 0x0       # 004fab0b
    mov eax, dword ptr [ebp - local_4]           # 004fab16
    imul eax, eax, 0x5bb                         # 004fab19
    mov ecx, dword ptr [ebp - local_8]           # 004fab1f
    mov dword ptr [ecx + eax + 0x166], 0x0       # 004fab22
    mov edx, dword ptr [ebp - local_4]           # 004fab2d
    imul edx, edx, 0x5bb                         # 004fab30
    mov eax, dword ptr [ebp - local_8]           # 004fab36
    mov dword ptr [eax + edx + 0x156], 0x0       # 004fab39
    mov ecx, dword ptr [ebp - local_4]           # 004fab44
    imul ecx, ecx, 0x5bb                         # 004fab47
    mov edx, dword ptr [ebp - local_8]           # 004fab4d
    mov dword ptr [edx + ecx + 0x172], 0x0       # 004fab50
    mov eax, dword ptr [ebp - local_4]           # 004fab5b
    imul eax, eax, 0x5bb                         # 004fab5e
    mov ecx, dword ptr [ebp - local_8]           # 004fab64
    mov dword ptr [ecx + eax + 0x176], 0x0       # 004fab67
    mov edx, dword ptr [ebp - local_4]           # 004fab72
    imul edx, edx, 0x5bb                         # 004fab75
    mov eax, dword ptr [ebp - local_8]           # 004fab7b
    mov dword ptr [eax + edx + 0x15e], 0x0       # 004fab7e
    mov ecx, dword ptr [ebp - local_4]           # 004fab89
    imul ecx, ecx, 0x5bb                         # 004fab8c
    mov edx, dword ptr [ebp - local_8]           # 004fab92
    mov dword ptr [edx + ecx + 0x297], 0x0       # 004fab95
    mov eax, dword ptr [ebp - local_4]           # 004faba0
    imul eax, eax, 0x5bb                         # 004faba3
    mov ecx, dword ptr [ebp - local_8]           # 004faba9
    mov dword ptr [ecx + eax + 0x29b], 0x0       # 004fabac
    mov edx, dword ptr [ebp - local_4]           # 004fabb7
    imul edx, edx, 0x5bb                         # 004fabba
    mov eax, dword ptr [ebp - local_8]           # 004fabc0
    mov dword ptr [eax + edx + 0x28f], 0x0       # 004fabc3
    jmp.d32 L_004faa40                           # 004fabce
L_004fabd3:
    # block 0x004fabd3: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004fabd3
    add ecx, 0x4                                 # 004fabd6
    push ecx                                     # 004fabd9
    mov edx, dword ptr [ebp + arg_8]             # 004fabda
    push edx                                     # 004fabdd
    mov ecx, 0x5cf1eb                            # 004fabde
    call FUN_004f2710                            # 004fabe3
    test eax, eax                                # 004fabe8
    jne.d8 L_004fac26                            # 004fabea
    # block 0x004fabec: <unfilled>
    movsx eax, word ptr [0x63a4cd]               # 004fabec
    test eax, eax                                # 004fabf3
    je.d8 L_004fac21                             # 004fabf5
    # block 0x004fabf7: <unfilled>
    mov ecx, 0x5cf1eb                            # 004fabf7
    call FUN_004fa2a8                            # 004fabfc
    push eax                                     # 004fac01
    push 0x560540                                # 004fac02
    push 0x63888b                                # 004fac07
    call FUN_0050ca3e                            # 004fac0c
    add esp, 0xc                                 # 004fac11
    push 0x63888b                                # 004fac14
    call FUN_0044a2b7                            # 004fac19
    add esp, 0x4                                 # 004fac1e
L_004fac21:
    # block 0x004fac21: <unfilled>
    jmp.d32 L_004fad4a                           # 004fac21
L_004fac26:
    # block 0x004fac26: <unfilled>
    mov dword ptr [ebp - local_4], 0x0           # 004fac26
    jmp.d8 L_004fac38                            # 004fac2d
L_004fac2f:
    # block 0x004fac2f: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004fac2f
    add ecx, 0x1                                 # 004fac32
    mov dword ptr [ebp - local_4], ecx           # 004fac35
L_004fac38:
    # block 0x004fac38: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004fac38
    movsx eax, word ptr [2*edx + 0x5604dc]       # 004fac3b
    cmp eax, -0x1                                # 004fac43
    je.d8 L_004fac68                             # 004fac46
    # block 0x004fac48: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004fac48
    movsx edx, word ptr [2*ecx + 0x5604dc]       # 004fac4b
    imul edx, edx, 0x5bb                         # 004fac53
    mov eax, dword ptr [ebp - local_8]           # 004fac59
    mov word ptr [eax + edx + 0x10c], 0x0        # 004fac5c
    jmp.d8 L_004fac2f                            # 004fac66
L_004fac68:
    # block 0x004fac68: <unfilled>
    mov dword ptr [ebp - local_4], 0x0           # 004fac68
    jmp.d8 L_004fac7a                            # 004fac6f
L_004fac71:
    # block 0x004fac71: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004fac71
    add ecx, 0x1                                 # 004fac74
    mov dword ptr [ebp - local_4], ecx           # 004fac77
L_004fac7a:
    # block 0x004fac7a: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004fac7a
    movsx eax, word ptr [2*edx + 0x5604e4]       # 004fac7d
    cmp eax, -0x1                                # 004fac85
    je.d8 L_004facaa                             # 004fac88
    # block 0x004fac8a: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004fac8a
    movsx edx, word ptr [2*ecx + 0x5604e4]       # 004fac8d
    imul edx, edx, 0x5bb                         # 004fac95
    mov eax, dword ptr [ebp - local_8]           # 004fac9b
    mov word ptr [eax + edx + 0x10c], 0x1        # 004fac9e
    jmp.d8 L_004fac71                            # 004faca8
L_004facaa:
    # block 0x004facaa: <unfilled>
    mov dword ptr [ebp - local_4], 0x0           # 004facaa
    jmp.d8 L_004facbc                            # 004facb1
L_004facb3:
    # block 0x004facb3: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004facb3
    add ecx, 0x1                                 # 004facb6
    mov dword ptr [ebp - local_4], ecx           # 004facb9
L_004facbc:
    # block 0x004facbc: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004facbc
    movsx eax, word ptr [2*edx + 0x5604f4]       # 004facbf
    cmp eax, -0x1                                # 004facc7
    je.d8 L_004facec                             # 004facca
    # block 0x004faccc: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004faccc
    movsx edx, word ptr [2*ecx + 0x5604f4]       # 004faccf
    imul edx, edx, 0x5bb                         # 004facd7
    mov eax, dword ptr [ebp - local_8]           # 004facdd
    mov word ptr [eax + edx + 0x10c], 0x2        # 004face0
    jmp.d8 L_004facb3                            # 004facea
L_004facec:
    # block 0x004facec: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004facec
    mov dword ptr [ecx + 0x5e3f], 0x0            # 004facef
    mov edx, dword ptr [ebp - local_8]           # 004facf9
    mov word ptr [edx + 0x5cbc], 0x3             # 004facfc
    mov eax, dword ptr [ebp - local_8]           # 004fad05
    mov word ptr [eax + 0x5ce0], 0x1             # 004fad08
    mov ecx, dword ptr [ebp - local_8]           # 004fad11
    mov dword ptr [ecx + 0x5d1a], 0x1            # 004fad14
    mov edx, dword ptr [ebp - local_8]           # 004fad1e
    mov dword ptr [edx + 0x5ce4], 0x0            # 004fad21
    push 0x1                                     # 004fad2b
    push 0x0                                     # 004fad2d
    push 0x0                                     # 004fad2f
    push 0x560570                                # 004fad31
    push 0x10                                    # 004fad36
    mov ecx, dword ptr [ebp - local_8]           # 004fad38
    call FUN_004fc62d                            # 004fad3b
    push 0x10                                    # 004fad40
    mov ecx, dword ptr [ebp - local_8]           # 004fad42
    call FUN_004fb2e3                            # 004fad45
L_004fad4a:
    # block 0x004fad4a: <unfilled>
    {load} mov esp, ebp                          # 004fad4a
    pop ebp                                      # 004fad4c
    ret 0x4                                      # 004fad4d
