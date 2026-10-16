# FUN_0042caa8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042caa8
# extent:       0x0042caa8-0x0042cecd (1061 code bytes)
# span:         0x0042caa8-0x0042cecd (code 1061, tables 0, padding 0)
# sha256:       339940d243f4701dceb67cc550ba9f5966635ae23fca1ee2458a20bc4a14dd93
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042caa8
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_2, field_4, field_6, field_a, field_c, field_e, field_16, field_1a, field_1e; [ecx + n] field_2, field_4, field_a, field_c, field_e, field_12, field_16, field_1e; [edx + n] field_4, field_c, field_12, field_16, field_1a, field_1e
# callees:      calls FUN_0042cecd
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:secondary_tick (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 240 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e

# --- external targets -----------------------------------------------
.set FUN_0042cecd, .text + (0x0042cecd - 0x401000)

.org 0x0042caa8 - 0x401000
.globl FUN_0042caa8
FUN_0042caa8:
    # block 0x0042caa8: entry, 6 instruction(s), ends with jne to 0x0042cb6a (forward)
    push ebp                                     # 0042caa8
    {load} mov ebp, esp                          # 0042caa9
    push esi                                     # 0042caab
    movsx eax, word ptr [0x5b4ea3]               # 0042caac
    cmp eax, 0x2                                 # 0042cab3
    jne.d32 L_0042cb6a                           # 0042cab6
    # block 0x0042cabc: entered by fall-through of jne at 0x0042cab6, 31 instruction(s), falls into the block at 0x0042cb6a
    movsx ecx, word ptr [0x5b4e89]               # 0042cabc
    imul ecx, ecx, 0x8d                          # 0042cac3
    mov dword ptr [ecx + 0x5bb626], 0x1          # 0042cac9
    movsx edx, word ptr [ebp + arg_8]            # 0042cad3
    imul edx, edx, 0x42                          # 0042cad7
    movsx eax, word ptr [0x5b4e89]               # 0042cada
    imul eax, eax, 0x8d                          # 0042cae1
    mov ecx, dword ptr [0x5b4ea9]                # 0042cae7
    mov dx, word ptr [ecx + edx + field_12]      # 0042caed
    mov word ptr [eax + 0x5bb62a], dx            # 0042caf2
    movsx eax, word ptr [ebp + arg_8]            # 0042caf9
    imul eax, eax, 0x42                          # 0042cafd
    movsx ecx, word ptr [0x5b4e89]               # 0042cb00
    imul ecx, ecx, 0x8d                          # 0042cb07
    mov edx, dword ptr [0x5b4ea9]                # 0042cb0d
    mov ax, word ptr [edx + eax + field_16]      # 0042cb13
    mov word ptr [ecx + 0x5bb62c], ax            # 0042cb18
    movsx ecx, word ptr [ebp + arg_8]            # 0042cb1f
    imul ecx, ecx, 0x42                          # 0042cb23
    movsx edx, word ptr [0x5b4e89]               # 0042cb26
    imul edx, edx, 0x8d                          # 0042cb2d
    mov eax, dword ptr [0x5b4ea9]                # 0042cb33
    mov cx, word ptr [eax + ecx + field_1a]      # 0042cb38
    mov word ptr [edx + 0x5bb62e], cx            # 0042cb3d
    movsx edx, word ptr [ebp + arg_8]            # 0042cb44
    imul edx, edx, 0x42                          # 0042cb48
    movsx eax, word ptr [0x5b4e89]               # 0042cb4b
    imul eax, eax, 0x8d                          # 0042cb52
    mov ecx, dword ptr [0x5b4ea9]                # 0042cb58
    mov dx, word ptr [ecx + edx + field_1e]      # 0042cb5e
    mov word ptr [eax + 0x5bb630], dx            # 0042cb63
L_0042cb6a:
    # block 0x0042cb6a: entered by jne at 0x0042cab6, 7 instruction(s), ends with jg to 0x0042cc87 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042cb6a
    imul eax, eax, 0x42                          # 0042cb6e
    mov ecx, dword ptr [0x5b4ea9]                # 0042cb71
    mov edx, dword ptr [ebp + arg_c]             # 0042cb77
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042cb7a
    cmp eax, dword ptr [edx + field_c]           # 0042cb7e
    jg.d32 L_0042cc87                            # 0042cb81
    # block 0x0042cb87: entered by fall-through of jg at 0x0042cb81, 7 instruction(s), ends with jl to 0x0042cc87 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042cb87
    imul ecx, ecx, 0x42                          # 0042cb8b
    mov edx, dword ptr [0x5b4ea9]                # 0042cb8e
    mov eax, dword ptr [ebp + arg_c]             # 0042cb94
    mov ecx, dword ptr [edx + ecx + field_16]    # 0042cb97
    cmp ecx, dword ptr [eax + field_4]           # 0042cb9b
    jl.d32 L_0042cc87                            # 0042cb9e
    # block 0x0042cba4: entered by fall-through of jl at 0x0042cb9e, 50 instruction(s), ends with forward jump to 0x0042ce67
    movsx edx, word ptr [ebp + arg_8]            # 0042cba4
    imul edx, edx, 0x42                          # 0042cba8
    mov eax, dword ptr [0x5b4ea9]                # 0042cbab
    mov ecx, dword ptr [eax + edx + field_6]     # 0042cbb0
    mov dword ptr [0x5b4e1c], ecx                # 0042cbb4
    movsx edx, word ptr [ebp + arg_8]            # 0042cbba
    imul edx, edx, 0x42                          # 0042cbbe
    mov eax, dword ptr [0x5b4ea9]                # 0042cbc1
    mov ecx, dword ptr [eax + edx + field_e]     # 0042cbc6
    mov dword ptr [0x5b4e24], ecx                # 0042cbca
    movsx edx, word ptr [ebp + arg_8]            # 0042cbd0
    imul edx, edx, 0x42                          # 0042cbd4
    mov eax, dword ptr [0x5b4ea9]                # 0042cbd7
    mov ecx, dword ptr [eax + edx + field_2]     # 0042cbdc
    mov dword ptr [0x5b4e18], ecx                # 0042cbe0
    movsx edx, word ptr [ebp + arg_8]            # 0042cbe6
    imul edx, edx, 0x42                          # 0042cbea
    mov eax, dword ptr [0x5b4ea9]                # 0042cbed
    mov ecx, dword ptr [eax + edx + field_a]     # 0042cbf2
    mov dword ptr [0x5b4e20], ecx                # 0042cbf6
    movsx edx, word ptr [ebp + arg_8]            # 0042cbfc
    imul edx, edx, 0x42                          # 0042cc00
    mov eax, dword ptr [0x5b4ea9]                # 0042cc03
    mov ecx, dword ptr [ebp + arg_c]             # 0042cc08
    mov edx, dword ptr [eax + edx + field_16]    # 0042cc0b
    sub edx, dword ptr [ecx + field_4]           # 0042cc0f
    add edx, dword ptr [0x58318a]                # 0042cc12
    mov dword ptr [0x5b4e2c], edx                # 0042cc18
    movsx eax, word ptr [ebp + arg_8]            # 0042cc1e
    imul eax, eax, 0x42                          # 0042cc22
    mov ecx, dword ptr [0x5b4ea9]                # 0042cc25
    mov edx, dword ptr [ebp + arg_c]             # 0042cc2b
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042cc2e
    sub eax, dword ptr [edx + field_4]           # 0042cc32
    add eax, dword ptr [0x58318a]                # 0042cc35
    mov dword ptr [0x5b4e34], eax                # 0042cc3b
    movsx ecx, word ptr [ebp + arg_8]            # 0042cc40
    imul ecx, ecx, 0x42                          # 0042cc44
    mov edx, dword ptr [0x5b4ea9]                # 0042cc47
    mov eax, dword ptr [edx + ecx + field_12]    # 0042cc4d
    add eax, dword ptr [0x583186]                # 0042cc51
    mov dword ptr [0x5b4e28], eax                # 0042cc57
    movsx ecx, word ptr [ebp + arg_8]            # 0042cc5c
    imul ecx, ecx, 0x42                          # 0042cc60
    mov edx, dword ptr [0x5b4ea9]                # 0042cc63
    mov eax, dword ptr [edx + ecx + field_1a]    # 0042cc69
    add eax, dword ptr [0x583186]                # 0042cc6d
    mov dword ptr [0x5b4e30], eax                # 0042cc73
    mov dword ptr [0x5d1967], 0x1                # 0042cc78
    jmp.d32 L_0042ce67                           # 0042cc82
L_0042cc87:
    # block 0x0042cc87: entered by jg at 0x0042cb81; jl at 0x0042cb9e, 7 instruction(s), ends with jg to 0x0042ccb8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042cc87
    imul ecx, ecx, 0x42                          # 0042cc8b
    mov edx, dword ptr [0x5b4ea9]                # 0042cc8e
    mov eax, dword ptr [ebp + arg_c]             # 0042cc94
    mov ecx, dword ptr [edx + ecx + field_16]    # 0042cc97
    cmp ecx, dword ptr [eax + field_c]           # 0042cc9b
    jg.d8 L_0042ccb8                             # 0042cc9e
    # block 0x0042cca0: entered by fall-through of jg at 0x0042cc9e, 7 instruction(s), ends with jge to 0x0042ccf2 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042cca0
    imul edx, edx, 0x42                          # 0042cca4
    mov eax, dword ptr [0x5b4ea9]                # 0042cca7
    mov ecx, dword ptr [ebp + arg_c]             # 0042ccac
    mov edx, dword ptr [eax + edx + field_1e]    # 0042ccaf
    cmp edx, dword ptr [ecx + field_c]           # 0042ccb3
    jge.d8 L_0042ccf2                            # 0042ccb6
L_0042ccb8:
    # block 0x0042ccb8: entered by jg at 0x0042cc9e; fall-through of jge at 0x0042ccb6, 7 instruction(s), ends with jg to 0x0042ce67 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042ccb8
    imul eax, eax, 0x42                          # 0042ccbc
    mov ecx, dword ptr [0x5b4ea9]                # 0042ccbf
    mov edx, dword ptr [ebp + arg_c]             # 0042ccc5
    mov eax, dword ptr [ecx + eax + field_16]    # 0042ccc8
    cmp eax, dword ptr [edx + field_4]           # 0042cccc
    jg.d32 L_0042ce67                            # 0042cccf
    # block 0x0042ccd5: entered by fall-through of jg at 0x0042cccf, 7 instruction(s), ends with jl to 0x0042ce67 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042ccd5
    imul ecx, ecx, 0x42                          # 0042ccd9
    mov edx, dword ptr [0x5b4ea9]                # 0042ccdc
    mov eax, dword ptr [ebp + arg_c]             # 0042cce2
    mov ecx, dword ptr [edx + ecx + field_1e]    # 0042cce5
    cmp ecx, dword ptr [eax + field_4]           # 0042cce9
    jl.d32 L_0042ce67                            # 0042ccec
L_0042ccf2:
    # block 0x0042ccf2: entered by jge at 0x0042ccb6; fall-through of jl at 0x0042ccec, 7 instruction(s), ends with jge to 0x0042cd18 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042ccf2
    imul edx, edx, 0x42                          # 0042ccf6
    mov eax, dword ptr [0x5b4ea9]                # 0042ccf9
    mov ecx, dword ptr [ebp + arg_c]             # 0042ccfe
    mov edx, dword ptr [eax + edx + field_16]    # 0042cd01
    cmp edx, dword ptr [ecx + field_4]           # 0042cd05
    jge.d8 L_0042cd18                            # 0042cd08
    # block 0x0042cd0a: entered by fall-through of jge at 0x0042cd08, 4 instruction(s), ends with forward jump to 0x0042cd2e
    mov eax, dword ptr [ebp + arg_c]             # 0042cd0a
    mov ecx, dword ptr [eax + field_4]           # 0042cd0d
    mov dword ptr [0x5b4e2c], ecx                # 0042cd10
    jmp.d8 L_0042cd2e                            # 0042cd16
L_0042cd18:
    # block 0x0042cd18: entered by jge at 0x0042cd08, 5 instruction(s), falls into the block at 0x0042cd2e
    movsx edx, word ptr [ebp + arg_8]            # 0042cd18
    imul edx, edx, 0x42                          # 0042cd1c
    mov eax, dword ptr [0x5b4ea9]                # 0042cd1f
    mov ecx, dword ptr [eax + edx + field_16]    # 0042cd24
    mov dword ptr [0x5b4e2c], ecx                # 0042cd28
L_0042cd2e:
    # block 0x0042cd2e: entered by jmp at 0x0042cd16, 7 instruction(s), ends with jle to 0x0042cd54 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042cd2e
    imul edx, edx, 0x42                          # 0042cd32
    mov eax, dword ptr [0x5b4ea9]                # 0042cd35
    mov ecx, dword ptr [ebp + arg_c]             # 0042cd3a
    mov edx, dword ptr [eax + edx + field_1e]    # 0042cd3d
    cmp edx, dword ptr [ecx + field_c]           # 0042cd41
    jle.d8 L_0042cd54                            # 0042cd44
    # block 0x0042cd46: entered by fall-through of jle at 0x0042cd44, 4 instruction(s), ends with forward jump to 0x0042cd6a
    mov eax, dword ptr [ebp + arg_c]             # 0042cd46
    mov ecx, dword ptr [eax + field_c]           # 0042cd49
    mov dword ptr [0x5b4e34], ecx                # 0042cd4c
    jmp.d8 L_0042cd6a                            # 0042cd52
L_0042cd54:
    # block 0x0042cd54: entered by jle at 0x0042cd44, 5 instruction(s), falls into the block at 0x0042cd6a
    movsx edx, word ptr [ebp + arg_8]            # 0042cd54
    imul edx, edx, 0x42                          # 0042cd58
    mov eax, dword ptr [0x5b4ea9]                # 0042cd5b
    mov ecx, dword ptr [eax + edx + field_1e]    # 0042cd60
    mov dword ptr [0x5b4e34], ecx                # 0042cd64
L_0042cd6a:
    # block 0x0042cd6a: entered by jmp at 0x0042cd52, 55 instruction(s), falls into the block at 0x0042ce67
    movsx edx, word ptr [ebp + arg_8]            # 0042cd6a
    imul edx, edx, 0x42                          # 0042cd6e
    movsx eax, word ptr [ebp + arg_8]            # 0042cd71
    imul eax, eax, 0x42                          # 0042cd75
    mov ecx, dword ptr [0x5b4ea9]                # 0042cd78
    mov esi, dword ptr [0x5b4e2c]                # 0042cd7e
    sub esi, dword ptr [ecx + eax + field_16]    # 0042cd84
    mov eax, dword ptr [0x5b4ea9]                # 0042cd88
    mov ecx, dword ptr [eax + edx + field_6]     # 0042cd8d
    {load} add ecx, esi                          # 0042cd91
    mov dword ptr [0x5b4e1c], ecx                # 0042cd93
    movsx edx, word ptr [ebp + arg_8]            # 0042cd99
    imul edx, edx, 0x42                          # 0042cd9d
    movsx eax, word ptr [ebp + arg_8]            # 0042cda0
    imul eax, eax, 0x42                          # 0042cda4
    mov ecx, dword ptr [0x5b4ea9]                # 0042cda7
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042cdad
    sub eax, dword ptr [0x5b4e34]                # 0042cdb1
    mov ecx, dword ptr [0x5b4ea9]                # 0042cdb7
    mov edx, dword ptr [ecx + edx + field_e]     # 0042cdbd
    {load} sub edx, eax                          # 0042cdc1
    mov dword ptr [0x5b4e24], edx                # 0042cdc3
    movsx eax, word ptr [ebp + arg_8]            # 0042cdc9
    imul eax, eax, 0x42                          # 0042cdcd
    mov ecx, dword ptr [0x5b4ea9]                # 0042cdd0
    mov edx, dword ptr [ecx + eax + field_2]     # 0042cdd6
    mov dword ptr [0x5b4e18], edx                # 0042cdda
    movsx eax, word ptr [ebp + arg_8]            # 0042cde0
    imul eax, eax, 0x42                          # 0042cde4
    mov ecx, dword ptr [0x5b4ea9]                # 0042cde7
    mov edx, dword ptr [ecx + eax + field_a]     # 0042cded
    mov dword ptr [0x5b4e20], edx                # 0042cdf1
    mov eax, dword ptr [ebp + arg_c]             # 0042cdf7
    mov ecx, dword ptr [0x5b4e2c]                # 0042cdfa
    sub ecx, dword ptr [eax + field_4]           # 0042ce00
    add ecx, dword ptr [0x58318a]                # 0042ce03
    mov dword ptr [0x5b4e2c], ecx                # 0042ce09
    mov edx, dword ptr [ebp + arg_c]             # 0042ce0f
    mov eax, dword ptr [0x5b4e34]                # 0042ce12
    sub eax, dword ptr [edx + field_4]           # 0042ce17
    add eax, dword ptr [0x58318a]                # 0042ce1a
    mov dword ptr [0x5b4e34], eax                # 0042ce20
    movsx ecx, word ptr [ebp + arg_8]            # 0042ce25
    imul ecx, ecx, 0x42                          # 0042ce29
    mov edx, dword ptr [0x5b4ea9]                # 0042ce2c
    mov eax, dword ptr [edx + ecx + field_12]    # 0042ce32
    add eax, dword ptr [0x583186]                # 0042ce36
    mov dword ptr [0x5b4e28], eax                # 0042ce3c
    movsx ecx, word ptr [ebp + arg_8]            # 0042ce41
    imul ecx, ecx, 0x42                          # 0042ce45
    mov edx, dword ptr [0x5b4ea9]                # 0042ce48
    mov eax, dword ptr [edx + ecx + field_1a]    # 0042ce4e
    add eax, dword ptr [0x583186]                # 0042ce52
    mov dword ptr [0x5b4e30], eax                # 0042ce58
    mov dword ptr [0x5d1967], 0x1                # 0042ce5d
L_0042ce67:
    # block 0x0042ce67: entered by jmp at 0x0042cc82; jg at 0x0042cccf; jl at 0x0042ccec, 15 instruction(s), ends with jne to 0x0042ceca (forward)
    mov ecx, dword ptr [0x5b4e2c]                # 0042ce67
    sub ecx, dword ptr [0x58318a]                # 0042ce6d
    mov dword ptr [0x5b4e5c], ecx                # 0042ce73
    mov edx, dword ptr [0x5b4e34]                # 0042ce79
    sub edx, dword ptr [0x58318a]                # 0042ce7f
    mov dword ptr [0x5b4e64], edx                # 0042ce85
    mov eax, dword ptr [0x5b4e28]                # 0042ce8b
    sub eax, dword ptr [0x583186]                # 0042ce90
    mov dword ptr [0x5b4e58], eax                # 0042ce96
    mov ecx, dword ptr [0x5b4e30]                # 0042ce9b
    sub ecx, dword ptr [0x583186]                # 0042cea1
    mov dword ptr [0x5b4e60], ecx                # 0042cea7
    movsx edx, word ptr [0x5b4e8b]               # 0042cead
    cmp edx, 0x2                                 # 0042ceb4
    jne.d8 L_0042ceca                            # 0042ceb7
    # block 0x0042ceb9: entered by fall-through of jne at 0x0042ceb7, 6 instruction(s), calls FUN_0042cecd, falls into the block at 0x0042ceca
    mov eax, dword ptr [ebp + arg_c]             # 0042ceb9
    push eax                                     # 0042cebc
    mov cx, word ptr [ebp + arg_8]               # 0042cebd
    push ecx                                     # 0042cec1
    call FUN_0042cecd                            # 0042cec2
    add esp, 0x8                                 # 0042cec7
L_0042ceca:
    # block 0x0042ceca: entered by jne at 0x0042ceb7, 3 instruction(s), ends with ret
    pop esi                                      # 0042ceca
    pop ebp                                      # 0042cecb
    ret                                          # 0042cecc

