# FUN_0042dbe1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042dbe1
# extent:       0x0042dbe1-0x0042e006 (1061 code bytes)
# span:         0x0042dbe1-0x0042e006 (code 1061, tables 0, padding 0)
# sha256:       f6ac2f74c7d20b04de7bcbe5e96a21384ad3947cc2e67129e9bb57e0efe75b18
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042dbe1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_2, field_4, field_6, field_a, field_c, field_e, field_16, field_1a, field_1e; [ecx + n] field_2, field_4, field_a, field_c, field_e, field_12, field_16, field_1e; [edx + n] field_4, field_c, field_12, field_16, field_1a, field_1e
# callees:      calls FUN_0042e006
# track-n:      host-adapter: none
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
.set FUN_0042e006, .text + (0x0042e006 - 0x401000)

.org 0x0042dbe1 - 0x401000
.globl FUN_0042dbe1
FUN_0042dbe1:
    # block 0x0042dbe1: entry, 6 instruction(s), ends with jne to 0x0042dca3 (forward)
    push ebp                                     # 0042dbe1
    {load} mov ebp, esp                          # 0042dbe2
    push esi                                     # 0042dbe4
    movsx eax, word ptr [0x5b511a]               # 0042dbe5
    cmp eax, 0x2                                 # 0042dbec
    jne.d32 L_0042dca3                           # 0042dbef
    # block 0x0042dbf5: entered by fall-through of jne at 0x0042dbef, 31 instruction(s), falls into the block at 0x0042dca3
    movsx ecx, word ptr [0x5b5100]               # 0042dbf5
    imul ecx, ecx, 0x8d                          # 0042dbfc
    mov dword ptr [ecx + 0x5bb626], 0x1          # 0042dc02
    movsx edx, word ptr [ebp + arg_8]            # 0042dc0c
    imul edx, edx, 0x42                          # 0042dc10
    movsx eax, word ptr [0x5b5100]               # 0042dc13
    imul eax, eax, 0x8d                          # 0042dc1a
    mov ecx, dword ptr [0x5b5120]                # 0042dc20
    mov dx, word ptr [ecx + edx + field_12]      # 0042dc26
    mov word ptr [eax + 0x5bb62a], dx            # 0042dc2b
    movsx eax, word ptr [ebp + arg_8]            # 0042dc32
    imul eax, eax, 0x42                          # 0042dc36
    movsx ecx, word ptr [0x5b5100]               # 0042dc39
    imul ecx, ecx, 0x8d                          # 0042dc40
    mov edx, dword ptr [0x5b5120]                # 0042dc46
    mov ax, word ptr [edx + eax + field_16]      # 0042dc4c
    mov word ptr [ecx + 0x5bb62c], ax            # 0042dc51
    movsx ecx, word ptr [ebp + arg_8]            # 0042dc58
    imul ecx, ecx, 0x42                          # 0042dc5c
    movsx edx, word ptr [0x5b5100]               # 0042dc5f
    imul edx, edx, 0x8d                          # 0042dc66
    mov eax, dword ptr [0x5b5120]                # 0042dc6c
    mov cx, word ptr [eax + ecx + field_1a]      # 0042dc71
    mov word ptr [edx + 0x5bb62e], cx            # 0042dc76
    movsx edx, word ptr [ebp + arg_8]            # 0042dc7d
    imul edx, edx, 0x42                          # 0042dc81
    movsx eax, word ptr [0x5b5100]               # 0042dc84
    imul eax, eax, 0x8d                          # 0042dc8b
    mov ecx, dword ptr [0x5b5120]                # 0042dc91
    mov dx, word ptr [ecx + edx + field_1e]      # 0042dc97
    mov word ptr [eax + 0x5bb630], dx            # 0042dc9c
L_0042dca3:
    # block 0x0042dca3: entered by jne at 0x0042dbef, 7 instruction(s), ends with jg to 0x0042ddc0 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042dca3
    imul eax, eax, 0x42                          # 0042dca7
    mov ecx, dword ptr [0x5b5120]                # 0042dcaa
    mov edx, dword ptr [ebp + arg_c]             # 0042dcb0
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042dcb3
    cmp eax, dword ptr [edx + field_c]           # 0042dcb7
    jg.d32 L_0042ddc0                            # 0042dcba
    # block 0x0042dcc0: entered by fall-through of jg at 0x0042dcba, 7 instruction(s), ends with jl to 0x0042ddc0 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042dcc0
    imul ecx, ecx, 0x42                          # 0042dcc4
    mov edx, dword ptr [0x5b5120]                # 0042dcc7
    mov eax, dword ptr [ebp + arg_c]             # 0042dccd
    mov ecx, dword ptr [edx + ecx + field_16]    # 0042dcd0
    cmp ecx, dword ptr [eax + field_4]           # 0042dcd4
    jl.d32 L_0042ddc0                            # 0042dcd7
    # block 0x0042dcdd: entered by fall-through of jl at 0x0042dcd7, 50 instruction(s), ends with forward jump to 0x0042dfa0
    movsx edx, word ptr [ebp + arg_8]            # 0042dcdd
    imul edx, edx, 0x42                          # 0042dce1
    mov eax, dword ptr [0x5b5120]                # 0042dce4
    mov ecx, dword ptr [eax + edx + field_6]     # 0042dce9
    mov dword ptr [0x5b5093], ecx                # 0042dced
    movsx edx, word ptr [ebp + arg_8]            # 0042dcf3
    imul edx, edx, 0x42                          # 0042dcf7
    mov eax, dword ptr [0x5b5120]                # 0042dcfa
    mov ecx, dword ptr [eax + edx + field_e]     # 0042dcff
    mov dword ptr [0x5b509b], ecx                # 0042dd03
    movsx edx, word ptr [ebp + arg_8]            # 0042dd09
    imul edx, edx, 0x42                          # 0042dd0d
    mov eax, dword ptr [0x5b5120]                # 0042dd10
    mov ecx, dword ptr [eax + edx + field_2]     # 0042dd15
    mov dword ptr [0x5b508f], ecx                # 0042dd19
    movsx edx, word ptr [ebp + arg_8]            # 0042dd1f
    imul edx, edx, 0x42                          # 0042dd23
    mov eax, dword ptr [0x5b5120]                # 0042dd26
    mov ecx, dword ptr [eax + edx + field_a]     # 0042dd2b
    mov dword ptr [0x5b5097], ecx                # 0042dd2f
    movsx edx, word ptr [ebp + arg_8]            # 0042dd35
    imul edx, edx, 0x42                          # 0042dd39
    mov eax, dword ptr [0x5b5120]                # 0042dd3c
    mov ecx, dword ptr [ebp + arg_c]             # 0042dd41
    mov edx, dword ptr [eax + edx + field_16]    # 0042dd44
    sub edx, dword ptr [ecx + field_4]           # 0042dd48
    add edx, dword ptr [0x58318a]                # 0042dd4b
    mov dword ptr [0x5b50a3], edx                # 0042dd51
    movsx eax, word ptr [ebp + arg_8]            # 0042dd57
    imul eax, eax, 0x42                          # 0042dd5b
    mov ecx, dword ptr [0x5b5120]                # 0042dd5e
    mov edx, dword ptr [ebp + arg_c]             # 0042dd64
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042dd67
    sub eax, dword ptr [edx + field_4]           # 0042dd6b
    add eax, dword ptr [0x58318a]                # 0042dd6e
    mov dword ptr [0x5b50ab], eax                # 0042dd74
    movsx ecx, word ptr [ebp + arg_8]            # 0042dd79
    imul ecx, ecx, 0x42                          # 0042dd7d
    mov edx, dword ptr [0x5b5120]                # 0042dd80
    mov eax, dword ptr [edx + ecx + field_12]    # 0042dd86
    add eax, dword ptr [0x583186]                # 0042dd8a
    mov dword ptr [0x5b509f], eax                # 0042dd90
    movsx ecx, word ptr [ebp + arg_8]            # 0042dd95
    imul ecx, ecx, 0x42                          # 0042dd99
    mov edx, dword ptr [0x5b5120]                # 0042dd9c
    mov eax, dword ptr [edx + ecx + field_1a]    # 0042dda2
    add eax, dword ptr [0x583186]                # 0042dda6
    mov dword ptr [0x5b50a7], eax                # 0042ddac
    mov dword ptr [0x5d19b1], 0x1                # 0042ddb1
    jmp.d32 L_0042dfa0                           # 0042ddbb
L_0042ddc0:
    # block 0x0042ddc0: entered by jg at 0x0042dcba; jl at 0x0042dcd7, 7 instruction(s), ends with jg to 0x0042ddf1 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042ddc0
    imul ecx, ecx, 0x42                          # 0042ddc4
    mov edx, dword ptr [0x5b5120]                # 0042ddc7
    mov eax, dword ptr [ebp + arg_c]             # 0042ddcd
    mov ecx, dword ptr [edx + ecx + field_16]    # 0042ddd0
    cmp ecx, dword ptr [eax + field_c]           # 0042ddd4
    jg.d8 L_0042ddf1                             # 0042ddd7
    # block 0x0042ddd9: entered by fall-through of jg at 0x0042ddd7, 7 instruction(s), ends with jge to 0x0042de2b (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042ddd9
    imul edx, edx, 0x42                          # 0042dddd
    mov eax, dword ptr [0x5b5120]                # 0042dde0
    mov ecx, dword ptr [ebp + arg_c]             # 0042dde5
    mov edx, dword ptr [eax + edx + field_1e]    # 0042dde8
    cmp edx, dword ptr [ecx + field_c]           # 0042ddec
    jge.d8 L_0042de2b                            # 0042ddef
L_0042ddf1:
    # block 0x0042ddf1: entered by jg at 0x0042ddd7; fall-through of jge at 0x0042ddef, 7 instruction(s), ends with jg to 0x0042dfa0 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042ddf1
    imul eax, eax, 0x42                          # 0042ddf5
    mov ecx, dword ptr [0x5b5120]                # 0042ddf8
    mov edx, dword ptr [ebp + arg_c]             # 0042ddfe
    mov eax, dword ptr [ecx + eax + field_16]    # 0042de01
    cmp eax, dword ptr [edx + field_4]           # 0042de05
    jg.d32 L_0042dfa0                            # 0042de08
    # block 0x0042de0e: entered by fall-through of jg at 0x0042de08, 7 instruction(s), ends with jl to 0x0042dfa0 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042de0e
    imul ecx, ecx, 0x42                          # 0042de12
    mov edx, dword ptr [0x5b5120]                # 0042de15
    mov eax, dword ptr [ebp + arg_c]             # 0042de1b
    mov ecx, dword ptr [edx + ecx + field_1e]    # 0042de1e
    cmp ecx, dword ptr [eax + field_4]           # 0042de22
    jl.d32 L_0042dfa0                            # 0042de25
L_0042de2b:
    # block 0x0042de2b: entered by jge at 0x0042ddef; fall-through of jl at 0x0042de25, 7 instruction(s), ends with jge to 0x0042de51 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042de2b
    imul edx, edx, 0x42                          # 0042de2f
    mov eax, dword ptr [0x5b5120]                # 0042de32
    mov ecx, dword ptr [ebp + arg_c]             # 0042de37
    mov edx, dword ptr [eax + edx + field_16]    # 0042de3a
    cmp edx, dword ptr [ecx + field_4]           # 0042de3e
    jge.d8 L_0042de51                            # 0042de41
    # block 0x0042de43: entered by fall-through of jge at 0x0042de41, 4 instruction(s), ends with forward jump to 0x0042de67
    mov eax, dword ptr [ebp + arg_c]             # 0042de43
    mov ecx, dword ptr [eax + field_4]           # 0042de46
    mov dword ptr [0x5b50a3], ecx                # 0042de49
    jmp.d8 L_0042de67                            # 0042de4f
L_0042de51:
    # block 0x0042de51: entered by jge at 0x0042de41, 5 instruction(s), falls into the block at 0x0042de67
    movsx edx, word ptr [ebp + arg_8]            # 0042de51
    imul edx, edx, 0x42                          # 0042de55
    mov eax, dword ptr [0x5b5120]                # 0042de58
    mov ecx, dword ptr [eax + edx + field_16]    # 0042de5d
    mov dword ptr [0x5b50a3], ecx                # 0042de61
L_0042de67:
    # block 0x0042de67: entered by jmp at 0x0042de4f, 7 instruction(s), ends with jle to 0x0042de8d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042de67
    imul edx, edx, 0x42                          # 0042de6b
    mov eax, dword ptr [0x5b5120]                # 0042de6e
    mov ecx, dword ptr [ebp + arg_c]             # 0042de73
    mov edx, dword ptr [eax + edx + field_1e]    # 0042de76
    cmp edx, dword ptr [ecx + field_c]           # 0042de7a
    jle.d8 L_0042de8d                            # 0042de7d
    # block 0x0042de7f: entered by fall-through of jle at 0x0042de7d, 4 instruction(s), ends with forward jump to 0x0042dea3
    mov eax, dword ptr [ebp + arg_c]             # 0042de7f
    mov ecx, dword ptr [eax + field_c]           # 0042de82
    mov dword ptr [0x5b50ab], ecx                # 0042de85
    jmp.d8 L_0042dea3                            # 0042de8b
L_0042de8d:
    # block 0x0042de8d: entered by jle at 0x0042de7d, 5 instruction(s), falls into the block at 0x0042dea3
    movsx edx, word ptr [ebp + arg_8]            # 0042de8d
    imul edx, edx, 0x42                          # 0042de91
    mov eax, dword ptr [0x5b5120]                # 0042de94
    mov ecx, dword ptr [eax + edx + field_1e]    # 0042de99
    mov dword ptr [0x5b50ab], ecx                # 0042de9d
L_0042dea3:
    # block 0x0042dea3: entered by jmp at 0x0042de8b, 55 instruction(s), falls into the block at 0x0042dfa0
    movsx edx, word ptr [ebp + arg_8]            # 0042dea3
    imul edx, edx, 0x42                          # 0042dea7
    movsx eax, word ptr [ebp + arg_8]            # 0042deaa
    imul eax, eax, 0x42                          # 0042deae
    mov ecx, dword ptr [0x5b5120]                # 0042deb1
    mov esi, dword ptr [0x5b50a3]                # 0042deb7
    sub esi, dword ptr [ecx + eax + field_16]    # 0042debd
    mov eax, dword ptr [0x5b5120]                # 0042dec1
    mov ecx, dword ptr [eax + edx + field_6]     # 0042dec6
    {load} add ecx, esi                          # 0042deca
    mov dword ptr [0x5b5093], ecx                # 0042decc
    movsx edx, word ptr [ebp + arg_8]            # 0042ded2
    imul edx, edx, 0x42                          # 0042ded6
    movsx eax, word ptr [ebp + arg_8]            # 0042ded9
    imul eax, eax, 0x42                          # 0042dedd
    mov ecx, dword ptr [0x5b5120]                # 0042dee0
    mov eax, dword ptr [ecx + eax + field_1e]    # 0042dee6
    sub eax, dword ptr [0x5b50ab]                # 0042deea
    mov ecx, dword ptr [0x5b5120]                # 0042def0
    mov edx, dword ptr [ecx + edx + field_e]     # 0042def6
    {load} sub edx, eax                          # 0042defa
    mov dword ptr [0x5b509b], edx                # 0042defc
    movsx eax, word ptr [ebp + arg_8]            # 0042df02
    imul eax, eax, 0x42                          # 0042df06
    mov ecx, dword ptr [0x5b5120]                # 0042df09
    mov edx, dword ptr [ecx + eax + field_2]     # 0042df0f
    mov dword ptr [0x5b508f], edx                # 0042df13
    movsx eax, word ptr [ebp + arg_8]            # 0042df19
    imul eax, eax, 0x42                          # 0042df1d
    mov ecx, dword ptr [0x5b5120]                # 0042df20
    mov edx, dword ptr [ecx + eax + field_a]     # 0042df26
    mov dword ptr [0x5b5097], edx                # 0042df2a
    mov eax, dword ptr [ebp + arg_c]             # 0042df30
    mov ecx, dword ptr [0x5b50a3]                # 0042df33
    sub ecx, dword ptr [eax + field_4]           # 0042df39
    add ecx, dword ptr [0x58318a]                # 0042df3c
    mov dword ptr [0x5b50a3], ecx                # 0042df42
    mov edx, dword ptr [ebp + arg_c]             # 0042df48
    mov eax, dword ptr [0x5b50ab]                # 0042df4b
    sub eax, dword ptr [edx + field_4]           # 0042df50
    add eax, dword ptr [0x58318a]                # 0042df53
    mov dword ptr [0x5b50ab], eax                # 0042df59
    movsx ecx, word ptr [ebp + arg_8]            # 0042df5e
    imul ecx, ecx, 0x42                          # 0042df62
    mov edx, dword ptr [0x5b5120]                # 0042df65
    mov eax, dword ptr [edx + ecx + field_12]    # 0042df6b
    add eax, dword ptr [0x583186]                # 0042df6f
    mov dword ptr [0x5b509f], eax                # 0042df75
    movsx ecx, word ptr [ebp + arg_8]            # 0042df7a
    imul ecx, ecx, 0x42                          # 0042df7e
    mov edx, dword ptr [0x5b5120]                # 0042df81
    mov eax, dword ptr [edx + ecx + field_1a]    # 0042df87
    add eax, dword ptr [0x583186]                # 0042df8b
    mov dword ptr [0x5b50a7], eax                # 0042df91
    mov dword ptr [0x5d19b1], 0x1                # 0042df96
L_0042dfa0:
    # block 0x0042dfa0: entered by jmp at 0x0042ddbb; jg at 0x0042de08; jl at 0x0042de25, 15 instruction(s), ends with jne to 0x0042e003 (forward)
    mov ecx, dword ptr [0x5b50a3]                # 0042dfa0
    sub ecx, dword ptr [0x58318a]                # 0042dfa6
    mov dword ptr [0x5b50d3], ecx                # 0042dfac
    mov edx, dword ptr [0x5b50ab]                # 0042dfb2
    sub edx, dword ptr [0x58318a]                # 0042dfb8
    mov dword ptr [0x5b50db], edx                # 0042dfbe
    mov eax, dword ptr [0x5b509f]                # 0042dfc4
    sub eax, dword ptr [0x583186]                # 0042dfc9
    mov dword ptr [0x5b50cf], eax                # 0042dfcf
    mov ecx, dword ptr [0x5b50a7]                # 0042dfd4
    sub ecx, dword ptr [0x583186]                # 0042dfda
    mov dword ptr [0x5b50d7], ecx                # 0042dfe0
    movsx edx, word ptr [0x5b5102]               # 0042dfe6
    cmp edx, 0x2                                 # 0042dfed
    jne.d8 L_0042e003                            # 0042dff0
    # block 0x0042dff2: entered by fall-through of jne at 0x0042dff0, 6 instruction(s), calls FUN_0042e006, falls into the block at 0x0042e003
    mov eax, dword ptr [ebp + arg_c]             # 0042dff2
    push eax                                     # 0042dff5
    mov cx, word ptr [ebp + arg_8]               # 0042dff6
    push ecx                                     # 0042dffa
    call FUN_0042e006                            # 0042dffb
    add esp, 0x8                                 # 0042e000
L_0042e003:
    # block 0x0042e003: entered by jne at 0x0042dff0, 3 instruction(s), ends with ret
    pop esi                                      # 0042e003
    pop ebp                                      # 0042e004
    ret                                          # 0042e005

