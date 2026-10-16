# FUN_004adb6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004adb6c
# extent:       0x004adb6c-0x004ae178 (1548 code bytes)
# span:         0x004adb6c-0x004ae178 (code 1548, tables 0, padding 0)
# sha256:       16948badd70ec5b9f851e802be7f805c83259bac5053c5efb9bf1898ce369aa3
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004adb6c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 4 more
# fields:       [eax + n] field_4, field_c, field_10, field_14, field_18, field_1c, field_20, field_22, field_24, field_c17, field_c35, field_minus_1; [ecx + n] field_4, field_8, field_c, field_10, field_12, field_16, field_1a, field_1e, field_20, field_22, field_23, field_24 and 5 more; [edx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_14, field_1c, field_20, field_22, field_23 and 4 more
# callees:      calls FUN_004c2a8d, FUN_004c51a5, FUN_004ae4d7, FUN_004ae495, FUN_0051dc43, FUN_0050ca3e, FUN_004c7070, FUN_004c71f9, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 481 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_44, 0x44  # offset +0x44
.equ field_6e, 0x6e  # offset +0x6e
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c35, 0xc35  # offset +0xc35

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ae495, .text + (0x004ae495 - 0x401000)
.set FUN_004ae4d7, .text + (0x004ae4d7 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c7070, .text + (0x004c7070 - 0x401000)
.set FUN_004c71f9, .text + (0x004c71f9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004adb6c - 0x401000
.globl FUN_004adb6c
FUN_004adb6c:
    # block 0x004adb6c: entry, 173 instruction(s), calls FUN_004c2a8d, FUN_004c51a5, FUN_004ae4d7, FUN_004ae495, FUN_0051dc43, ends with jne to 0x004addbe (forward)
    push ebp                                     # 004adb6c
    {load} mov ebp, esp                          # 004adb6d
    sub esp, 0x40                                # 004adb6f
    push esi                                     # 004adb72
    push edi                                     # 004adb73
    mov dword ptr [ebp - local_40], ecx          # 004adb74
    mov eax, dword ptr [ebp + arg_8]             # 004adb77
    imul eax, eax, 0xc7                          # 004adb7a
    mov ecx, dword ptr [ebp - local_40]          # 004adb80
    lea edx, [ecx + eax + field_6e]              # 004adb83
    mov dword ptr [ebp - local_34], edx          # 004adb87
    mov eax, dword ptr [ebp - local_40]          # 004adb8a
    mov ecx, dword ptr [eax + field_c17]         # 004adb8d
    mov edx, dword ptr [ebp + arg_8]             # 004adb93
    shl edx, 0x5                                 # 004adb96
    lea eax, [ecx + edx + field_44]              # 004adb99
    mov dword ptr [ebp - local_24], eax          # 004adb9d
    mov byte ptr [ebp - local_c], 0x0            # 004adba0
    mov ecx, dword ptr [ebp - local_34]          # 004adba4
    mov word ptr [ecx], 0x0                      # 004adba7
    mov edx, dword ptr [ebp - local_34]          # 004adbac
    mov al, byte ptr [ebp - local_c]             # 004adbaf
    mov byte ptr [edx + field_26], al            # 004adbb2
    mov ecx, dword ptr [ebp - local_c]           # 004adbb5
    and ecx, 0xff                                # 004adbb8
    imul ecx, ecx, 0x28                          # 004adbbe
    mov edx, dword ptr [ebp - local_34]          # 004adbc1
    lea eax, [edx + ecx + field_27]              # 004adbc4
    mov dword ptr [ebp - local_2c], eax          # 004adbc8
    mov ecx, dword ptr [ebp - local_24]          # 004adbcb
    add ecx, 0x10                                # 004adbce
    mov edx, dword ptr [ebp - local_34]          # 004adbd1
    add edx, 0x2                                 # 004adbd4
    mov eax, dword ptr [ecx]                     # 004adbd7
    mov dword ptr [edx], eax                     # 004adbd9
    mov eax, dword ptr [ecx + field_4]           # 004adbdb
    mov dword ptr [edx + field_4], eax           # 004adbde
    mov eax, dword ptr [ecx + field_8]           # 004adbe1
    mov dword ptr [edx + field_8], eax           # 004adbe4
    mov ecx, dword ptr [ecx + field_c]           # 004adbe7
    mov dword ptr [edx + field_c], ecx           # 004adbea
    mov edx, dword ptr [ebp - local_34]          # 004adbed
    mov eax, dword ptr [edx + field_6]           # 004adbf0
    add eax, dword ptr [0x58318a]                # 004adbf3
    mov ecx, dword ptr [ebp - local_34]          # 004adbf9
    mov dword ptr [ecx + field_16], eax          # 004adbfc
    mov edx, dword ptr [ebp - local_34]          # 004adbff
    mov eax, dword ptr [edx + field_e]           # 004adc02
    add eax, dword ptr [0x58318a]                # 004adc05
    mov ecx, dword ptr [ebp - local_34]          # 004adc0b
    mov dword ptr [ecx + field_1e], eax          # 004adc0e
    mov edx, dword ptr [ebp - local_34]          # 004adc11
    mov eax, dword ptr [edx + field_2]           # 004adc14
    add eax, dword ptr [0x583186]                # 004adc17
    mov ecx, dword ptr [ebp - local_34]          # 004adc1d
    mov dword ptr [ecx + field_12], eax          # 004adc20
    mov edx, dword ptr [ebp - local_34]          # 004adc23
    mov eax, dword ptr [edx + field_a]           # 004adc26
    add eax, dword ptr [0x583186]                # 004adc29
    mov ecx, dword ptr [ebp - local_34]          # 004adc2f
    mov dword ptr [ecx + field_1a], eax          # 004adc32
    mov edx, dword ptr [ebp - local_24]          # 004adc35
    mov eax, dword ptr [ebp - local_24]          # 004adc38
    mov ecx, dword ptr [edx + field_8]           # 004adc3b
    sub ecx, dword ptr [eax]                     # 004adc3e
    add ecx, 0x1                                 # 004adc40
    mov edx, dword ptr [ebp - local_2c]          # 004adc43
    mov word ptr [edx + field_20], cx            # 004adc46
    mov eax, dword ptr [ebp - local_2c]          # 004adc4a
    mov cx, word ptr [eax + field_20]            # 004adc4d
    mov word ptr [ebp - local_28], cx            # 004adc51
    mov edx, dword ptr [ebp - local_24]          # 004adc55
    mov eax, dword ptr [ebp - local_24]          # 004adc58
    mov ecx, dword ptr [edx + field_c]           # 004adc5b
    sub ecx, dword ptr [eax + field_4]           # 004adc5e
    add ecx, 0x1                                 # 004adc61
    mov edx, dword ptr [ebp - local_2c]          # 004adc64
    mov word ptr [edx + field_22], cx            # 004adc67
    mov eax, dword ptr [ebp - local_2c]          # 004adc6b
    mov cx, word ptr [eax + field_22]            # 004adc6e
    mov word ptr [ebp - local_20], cx            # 004adc72
    push 0x5511f8                                # 004adc76
    push 0x6                                     # 004adc7b
    mov dx, word ptr [ebp - local_20]            # 004adc7d
    push edx                                     # 004adc81
    mov ax, word ptr [ebp - local_28]            # 004adc82
    push eax                                     # 004adc86
    mov ecx, 0x5cf659                            # 004adc87
    call FUN_004c2a8d                            # 004adc8c
    mov ecx, dword ptr [ebp - local_2c]          # 004adc91
    mov dword ptr [ecx], eax                     # 004adc94
    push 0x551234                                # 004adc96
    push 0x6                                     # 004adc9b
    mov dx, word ptr [ebp - local_20]            # 004adc9d
    push edx                                     # 004adca1
    mov ax, word ptr [ebp - local_28]            # 004adca2
    push eax                                     # 004adca6
    mov ecx, 0x5cf659                            # 004adca7
    call FUN_004c2a8d                            # 004adcac
    mov ecx, dword ptr [ebp - local_2c]          # 004adcb1
    mov dword ptr [ecx + field_4], eax           # 004adcb4
    mov edx, dword ptr [ebp - local_2c]          # 004adcb7
    mov eax, dword ptr [edx]                     # 004adcba
    mov dword ptr [ebp - local_14], eax          # 004adcbc
    mov ecx, dword ptr [ebp - local_2c]          # 004adcbf
    mov edx, dword ptr [ecx + field_4]           # 004adcc2
    mov dword ptr [ebp - local_4], edx           # 004adcc5
    mov eax, dword ptr [ebp - local_2c]          # 004adcc8
    mov dword ptr [eax + field_c], 0x0           # 004adccb
    mov ecx, dword ptr [ebp - local_2c]          # 004adcd2
    mov dword ptr [ecx + field_10], 0x0          # 004adcd5
    movsx edx, word ptr [ebp - local_20]         # 004adcdc
    mov eax, dword ptr [ebp - local_2c]          # 004adce0
    mov ecx, dword ptr [eax + field_10]          # 004adce3
    lea edx, [ecx + edx - field_minus_1]         # 004adce6
    mov eax, dword ptr [ebp - local_2c]          # 004adcea
    mov dword ptr [eax + field_18], edx          # 004adced
    movsx ecx, word ptr [ebp - local_28]         # 004adcf0
    mov edx, dword ptr [ebp - local_2c]          # 004adcf4
    mov eax, dword ptr [edx + field_c]           # 004adcf7
    lea ecx, [eax + ecx - field_minus_1]         # 004adcfa
    mov edx, dword ptr [ebp - local_2c]          # 004adcfe
    mov dword ptr [edx + field_14], ecx          # 004add01
    push 0x551270                                # 004add04
    mov eax, dword ptr [ebp - local_2c]          # 004add09
    add eax, 0xc                                 # 004add0c
    push eax                                     # 004add0f
    mov ecx, dword ptr [ebp - local_24]          # 004add10
    push ecx                                     # 004add13
    mov edx, dword ptr [ebp - local_14]          # 004add14
    push edx                                     # 004add17
    mov eax, dword ptr [ebp - local_40]          # 004add18
    mov ecx, dword ptr [eax + field_c35]         # 004add1b
    push ecx                                     # 004add21
    mov ecx, 0x5cf659                            # 004add22
    call FUN_004c51a5                            # 004add27
    push 0x5512b0                                # 004add2c
    mov edx, dword ptr [ebp - local_2c]          # 004add31
    add edx, 0xc                                 # 004add34
    push edx                                     # 004add37
    mov eax, dword ptr [ebp - local_24]          # 004add38
    push eax                                     # 004add3b
    mov ecx, dword ptr [ebp - local_4]           # 004add3c
    push ecx                                     # 004add3f
    mov edx, dword ptr [ebp - local_40]          # 004add40
    mov eax, dword ptr [edx + field_c35]         # 004add43
    push eax                                     # 004add49
    mov ecx, 0x5cf659                            # 004add4a
    call FUN_004c51a5                            # 004add4f
    mov ecx, dword ptr [ebp - local_4]           # 004add54
    push ecx                                     # 004add57
    mov ecx, dword ptr [ebp - local_40]          # 004add58
    call FUN_004ae4d7                            # 004add5b
    mov edx, dword ptr [ebp + arg_8]             # 004add60
    push edx                                     # 004add63
    mov ecx, dword ptr [ebp - local_40]          # 004add64
    call FUN_004ae495                            # 004add67
    movsx eax, word ptr [ebp - local_28]         # 004add6c
    movsx ecx, word ptr [ebp - local_20]         # 004add70
    imul eax, ecx                                # 004add74
    mov edx, dword ptr [ebp - local_2c]          # 004add77
    mov dword ptr [edx + field_24], eax          # 004add7a
    mov eax, dword ptr [ebp - local_2c]          # 004add7d
    mov ecx, dword ptr [eax + field_24]          # 004add80
    push ecx                                     # 004add83
    call FUN_0051dc43                            # 004add84
    add esp, 0x4                                 # 004add89
    mov dword ptr [ebp - local_38], eax          # 004add8c
    mov edx, dword ptr [ebp - local_2c]          # 004add8f
    mov eax, dword ptr [ebp - local_38]          # 004add92
    mov dword ptr [edx + field_1c], eax          # 004add95
    cmp dword ptr [ebp - local_38], 0x0          # 004add98
    jne.d8 L_004addbe                            # 004add9c
    # block 0x004add9e: entered by fall-through of jne at 0x004add9c, 9 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004ae16e
    mov ecx, dword ptr [ebp + arg_8]             # 004add9e
    push ecx                                     # 004adda1
    push 0x5512f0                                # 004adda2
    mov edx, dword ptr [ebp - local_40]          # 004adda7
    add edx, 0xd39                               # 004addaa
    push edx                                     # 004addb0
    call FUN_0050ca3e                            # 004addb1
    add esp, 0xc                                 # 004addb6
    jmp.d32 L_004ae16e                           # 004addb9
L_004addbe:
    # block 0x004addbe: entered by jne at 0x004add9c, 21 instruction(s), ends with forward jump to 0x004ade11
    mov eax, dword ptr [ebp - local_2c]          # 004addbe
    mov ecx, dword ptr [eax + field_1c]          # 004addc1
    mov dword ptr [ebp - local_30], ecx          # 004addc4
    mov edx, dword ptr [ebp - local_2c]          # 004addc7
    mov ecx, dword ptr [edx + field_24]          # 004addca
    {load} xor eax, eax                          # 004addcd
    mov edi, dword ptr [ebp - local_30]          # 004addcf
    {load} mov edx, ecx                          # 004addd2
    shr ecx, 0x2                                 # 004addd4
    rep stosd dword ptr es:[edi], eax            # 004addd7
    {load} mov ecx, edx                          # 004addd9
    and ecx, 0x3                                 # 004adddb
    rep stosb byte ptr es:[edi], al              # 004addde
    mov al, byte ptr [ebp + arg_8]               # 004adde0
    mov byte ptr [ebp - local_18], al            # 004adde3
    mov cl, byte ptr [ebp - local_18]            # 004adde6
    or cl, 0x20                                  # 004adde9
    mov byte ptr [ebp - local_18], cl            # 004addec
    mov dword ptr [ebp - local_1c], 0x0          # 004addef
    mov dword ptr [ebp - local_10], 0x0          # 004addf6
    jmp.d8 L_004ade11                            # 004addfd
L_004addff:
    # block 0x004addff: entered by jmp at 0x004ade42, 6 instruction(s), falls into the block at 0x004ade11
    mov edx, dword ptr [ebp - local_1c]          # 004addff
    add edx, 0x1                                 # 004ade02
    mov dword ptr [ebp - local_1c], edx          # 004ade05
    mov eax, dword ptr [ebp - local_10]          # 004ade08
    add eax, 0x2                                 # 004ade0b
    mov dword ptr [ebp - local_10], eax          # 004ade0e
L_004ade11:
    # block 0x004ade11: entered by jmp at 0x004addfd, 4 instruction(s), ends with jge to 0x004ade44 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004ade11
    mov edx, dword ptr [ebp - local_1c]          # 004ade14
    cmp edx, dword ptr [ecx + field_24]          # 004ade17
    jge.d8 L_004ade44                            # 004ade1a
    # block 0x004ade1c: entered by fall-through of jge at 0x004ade1a, 9 instruction(s), ends with je to 0x004ade42 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004ade1c
    mov ecx, dword ptr [eax]                     # 004ade1f
    mov edx, dword ptr [ebp - local_10]          # 004ade21
    {load} xor eax, eax                          # 004ade24
    mov ax, word ptr [ecx + edx]                 # 004ade26
    {load} xor ecx, ecx                          # 004ade2a
    mov cx, word ptr [0x5d2f29]                  # 004ade2c
    {load} cmp eax, ecx                          # 004ade33
    je.d8 L_004ade42                             # 004ade35
    # block 0x004ade37: entered by fall-through of je at 0x004ade35, 4 instruction(s), falls into the block at 0x004ade42
    mov edx, dword ptr [ebp - local_30]          # 004ade37
    add edx, dword ptr [ebp - local_1c]          # 004ade3a
    mov al, byte ptr [ebp - local_18]            # 004ade3d
    mov byte ptr [edx], al                       # 004ade40
L_004ade42:
    # block 0x004ade42: entered by je at 0x004ade35, 1 instruction(s), ends with backward jump to 0x004addff
    jmp.d8 L_004addff                            # 004ade42
L_004ade44:
    # block 0x004ade44: entered by jge at 0x004ade1a, 2 instruction(s), ends with forward jump to 0x004ade53
    mov byte ptr [ebp - local_c], 0x1            # 004ade44
    jmp.d8 L_004ade53                            # 004ade48
L_004ade4a:
    # block 0x004ade4a: entered by jmp at 0x004ae109, 3 instruction(s), falls into the block at 0x004ade53
    mov cl, byte ptr [ebp - local_c]             # 004ade4a
    add cl, 0x1                                  # 004ade4d
    mov byte ptr [ebp - local_c], cl             # 004ade50
L_004ade53:
    # block 0x004ade53: entered by jmp at 0x004ade48, 4 instruction(s), ends with jge to 0x004ae10e (forward)
    mov edx, dword ptr [ebp - local_c]           # 004ade53
    and edx, 0xff                                # 004ade56
    cmp edx, 0x4                                 # 004ade5c
    jge.d32 L_004ae10e                           # 004ade5f
    # block 0x004ade65: entered by fall-through of jge at 0x004ade5f, 150 instruction(s), calls FUN_0050ca3e, FUN_004c2a8d, FUN_004c7070, FUN_0051dc43, ends with jne to 0x004ae071 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 004ade65
    mov dword ptr [ebp - local_8], eax           # 004ade68
    mov ecx, dword ptr [ebp - local_c]           # 004ade6b
    and ecx, 0xff                                # 004ade6e
    imul ecx, ecx, 0x28                          # 004ade74
    mov edx, dword ptr [ebp - local_34]          # 004ade77
    lea eax, [edx + ecx + field_27]              # 004ade7a
    mov dword ptr [ebp - local_2c], eax          # 004ade7e
    mov ecx, dword ptr [ebp - local_c]           # 004ade81
    and ecx, 0xff                                # 004ade84
    push ecx                                     # 004ade8a
    push 0x551328                                # 004ade8b
    mov edx, dword ptr [ebp - local_40]          # 004ade90
    add edx, 0xd39                               # 004ade93
    push edx                                     # 004ade99
    call FUN_0050ca3e                            # 004ade9a
    add esp, 0xc                                 # 004ade9f
    mov eax, dword ptr [ebp - local_40]          # 004adea2
    add eax, 0xd39                               # 004adea5
    push eax                                     # 004adeaa
    push 0x6                                     # 004adeab
    mov cx, word ptr [ebp - local_20]            # 004adead
    push ecx                                     # 004adeb1
    mov dx, word ptr [ebp - local_28]            # 004adeb2
    push edx                                     # 004adeb6
    mov ecx, 0x5cf659                            # 004adeb7
    call FUN_004c2a8d                            # 004adebc
    mov ecx, dword ptr [ebp - local_2c]          # 004adec1
    mov dword ptr [ecx], eax                     # 004adec4
    mov edx, dword ptr [ebp - local_c]           # 004adec6
    and edx, 0xff                                # 004adec9
    push edx                                     # 004adecf
    push 0x551364                                # 004aded0
    mov eax, dword ptr [ebp - local_40]          # 004aded5
    add eax, 0xd39                               # 004aded8
    push eax                                     # 004adedd
    call FUN_0050ca3e                            # 004adede
    add esp, 0xc                                 # 004adee3
    mov ecx, dword ptr [ebp - local_40]          # 004adee6
    add ecx, 0xd39                               # 004adee9
    push ecx                                     # 004adeef
    push 0x6                                     # 004adef0
    mov dx, word ptr [ebp - local_20]            # 004adef2
    push edx                                     # 004adef6
    mov ax, word ptr [ebp - local_28]            # 004adef7
    push eax                                     # 004adefb
    mov ecx, 0x5cf659                            # 004adefc
    call FUN_004c2a8d                            # 004adf01
    mov ecx, dword ptr [ebp - local_2c]          # 004adf06
    mov dword ptr [ecx + field_4], eax           # 004adf09
    mov edx, dword ptr [ebp - local_2c]          # 004adf0c
    mov eax, dword ptr [edx]                     # 004adf0f
    mov dword ptr [ebp - local_14], eax          # 004adf11
    mov ecx, dword ptr [ebp - local_2c]          # 004adf14
    mov edx, dword ptr [ecx + field_4]           # 004adf17
    mov dword ptr [ebp - local_4], edx           # 004adf1a
    mov eax, dword ptr [ebp - local_8]           # 004adf1d
    mov ecx, dword ptr [eax]                     # 004adf20
    mov ecx, dword ptr [ecx + field_23]          # 004adf22
    mov edx, dword ptr [ebp - local_8]           # 004adf25
    mov eax, dword ptr [edx]                     # 004adf28
    mov esi, dword ptr [eax]                     # 004adf2a
    mov edx, dword ptr [ebp - local_14]          # 004adf2c
    mov edi, dword ptr [edx]                     # 004adf2f
    {load} mov eax, ecx                          # 004adf31
    shr ecx, 0x2                                 # 004adf33
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004adf36
    {load} mov ecx, eax                          # 004adf38
    and ecx, 0x3                                 # 004adf3a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004adf3d
    mov ecx, dword ptr [ebp - local_8]           # 004adf3f
    mov edx, dword ptr [ecx + field_4]           # 004adf42
    mov ecx, dword ptr [edx + field_23]          # 004adf45
    mov eax, dword ptr [ebp - local_8]           # 004adf48
    mov edx, dword ptr [eax + field_4]           # 004adf4b
    mov esi, dword ptr [edx]                     # 004adf4e
    mov eax, dword ptr [ebp - local_4]           # 004adf50
    mov edi, dword ptr [eax]                     # 004adf53
    {load} mov edx, ecx                          # 004adf55
    shr ecx, 0x2                                 # 004adf57
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004adf5a
    {load} mov ecx, edx                          # 004adf5c
    and ecx, 0x3                                 # 004adf5e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004adf61
    mov eax, dword ptr [ebp - local_c]           # 004adf63
    and eax, 0xff                                # 004adf66
    push eax                                     # 004adf6b
    push 0x5513a0                                # 004adf6c
    mov ecx, dword ptr [ebp - local_40]          # 004adf71
    add ecx, 0xd39                               # 004adf74
    push ecx                                     # 004adf7a
    call FUN_0050ca3e                            # 004adf7b
    add esp, 0xc                                 # 004adf80
    mov edx, dword ptr [ebp - local_40]          # 004adf83
    add edx, 0xd39                               # 004adf86
    push edx                                     # 004adf8c
    mov eax, dword ptr [ebp - local_14]          # 004adf8d
    push eax                                     # 004adf90
    mov ecx, 0x5cf659                            # 004adf91
    call FUN_004c7070                            # 004adf96
    mov ecx, dword ptr [ebp - local_c]           # 004adf9b
    and ecx, 0xff                                # 004adf9e
    push ecx                                     # 004adfa4
    push 0x5513e4                                # 004adfa5
    mov edx, dword ptr [ebp - local_40]          # 004adfaa
    add edx, 0xd39                               # 004adfad
    push edx                                     # 004adfb3
    call FUN_0050ca3e                            # 004adfb4
    add esp, 0xc                                 # 004adfb9
    mov eax, dword ptr [ebp - local_40]          # 004adfbc
    add eax, 0xd39                               # 004adfbf
    push eax                                     # 004adfc4
    mov ecx, dword ptr [ebp - local_4]           # 004adfc5
    push ecx                                     # 004adfc8
    mov ecx, 0x5cf659                            # 004adfc9
    call FUN_004c7070                            # 004adfce
    mov edx, dword ptr [ebp - local_2c]          # 004adfd3
    mov dword ptr [edx + field_c], 0x0           # 004adfd6
    mov eax, dword ptr [ebp - local_2c]          # 004adfdd
    mov dword ptr [eax + field_10], 0x0          # 004adfe0
    mov ecx, dword ptr [ebp - local_14]          # 004adfe7
    movsx edx, word ptr [ecx + field_2d]         # 004adfea
    mov eax, dword ptr [ebp - local_2c]          # 004adfee
    mov ecx, dword ptr [eax + field_10]          # 004adff1
    lea edx, [ecx + edx - field_minus_1]         # 004adff4
    mov eax, dword ptr [ebp - local_2c]          # 004adff8
    mov dword ptr [eax + field_18], edx          # 004adffb
    mov ecx, dword ptr [ebp - local_14]          # 004adffe
    movsx edx, word ptr [ecx + field_2b]         # 004ae001
    mov eax, dword ptr [ebp - local_2c]          # 004ae005
    mov ecx, dword ptr [eax + field_c]           # 004ae008
    lea edx, [ecx + edx - field_minus_1]         # 004ae00b
    mov eax, dword ptr [ebp - local_2c]          # 004ae00f
    mov dword ptr [eax + field_14], edx          # 004ae012
    movsx ecx, word ptr [ebp - local_28]         # 004ae015
    movsx edx, word ptr [ebp - local_20]         # 004ae019
    imul ecx, edx                                # 004ae01d
    mov eax, dword ptr [ebp - local_2c]          # 004ae020
    mov dword ptr [eax + field_24], ecx          # 004ae023
    mov ecx, dword ptr [ebp - local_2c]          # 004ae026
    mov edx, dword ptr [ecx + field_24]          # 004ae029
    push edx                                     # 004ae02c
    call FUN_0051dc43                            # 004ae02d
    add esp, 0x4                                 # 004ae032
    mov dword ptr [ebp - local_3c], eax          # 004ae035
    mov eax, dword ptr [ebp - local_2c]          # 004ae038
    mov ecx, dword ptr [ebp - local_3c]          # 004ae03b
    mov dword ptr [eax + field_1c], ecx          # 004ae03e
    cmp dword ptr [ebp - local_3c], 0x0          # 004ae041
    jne.d8 L_004ae071                            # 004ae045
    # block 0x004ae047: entered by fall-through of jne at 0x004ae045, 12 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004ae16c
    mov edx, dword ptr [ebp - local_c]           # 004ae047
    and edx, 0xff                                # 004ae04a
    push edx                                     # 004ae050
    mov eax, dword ptr [ebp + arg_8]             # 004ae051
    push eax                                     # 004ae054
    push 0x551428                                # 004ae055
    mov ecx, dword ptr [ebp - local_40]          # 004ae05a
    add ecx, 0xd39                               # 004ae05d
    push ecx                                     # 004ae063
    call FUN_0050ca3e                            # 004ae064
    add esp, 0x10                                # 004ae069
    jmp.d32 L_004ae16c                           # 004ae06c
L_004ae071:
    # block 0x004ae071: entered by jne at 0x004ae045, 49 instruction(s), calls FUN_0050ca3e, FUN_004c71f9, ends with backward jump to 0x004ade4a
    mov edx, dword ptr [ebp - local_2c]          # 004ae071
    mov eax, dword ptr [edx + field_1c]          # 004ae074
    mov dword ptr [ebp - local_30], eax          # 004ae077
    mov ecx, dword ptr [ebp - local_2c]          # 004ae07a
    mov ecx, dword ptr [ecx + field_24]          # 004ae07d
    mov edx, dword ptr [ebp - local_8]           # 004ae080
    mov esi, dword ptr [edx + field_1c]          # 004ae083
    mov edi, dword ptr [ebp - local_30]          # 004ae086
    {load} mov eax, ecx                          # 004ae089
    shr ecx, 0x2                                 # 004ae08b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ae08e
    {load} mov ecx, eax                          # 004ae090
    and ecx, 0x3                                 # 004ae092
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ae095
    mov ecx, dword ptr [ebp - local_2c]          # 004ae097
    mov dx, word ptr [ebp - local_28]            # 004ae09a
    mov word ptr [ecx + field_20], dx            # 004ae09e
    mov eax, dword ptr [ebp - local_2c]          # 004ae0a2
    mov cx, word ptr [ebp - local_20]            # 004ae0a5
    mov word ptr [eax + field_22], cx            # 004ae0a9
    mov edx, dword ptr [ebp - local_c]           # 004ae0ad
    and edx, 0xff                                # 004ae0b0
    push edx                                     # 004ae0b6
    push 0x551460                                # 004ae0b7
    mov eax, dword ptr [ebp - local_40]          # 004ae0bc
    add eax, 0xd39                               # 004ae0bf
    push eax                                     # 004ae0c4
    call FUN_0050ca3e                            # 004ae0c5
    add esp, 0xc                                 # 004ae0ca
    mov ecx, dword ptr [ebp - local_40]          # 004ae0cd
    add ecx, 0xd39                               # 004ae0d0
    push ecx                                     # 004ae0d6
    mov edx, dword ptr [ebp - local_2c]          # 004ae0d7
    add edx, 0x22                                # 004ae0da
    push edx                                     # 004ae0dd
    mov eax, dword ptr [ebp - local_2c]          # 004ae0de
    add eax, 0x20                                # 004ae0e1
    push eax                                     # 004ae0e4
    mov ecx, dword ptr [ebp - local_30]          # 004ae0e5
    push ecx                                     # 004ae0e8
    mov ecx, 0x5cf659                            # 004ae0e9
    call FUN_004c71f9                            # 004ae0ee
    mov edx, dword ptr [ebp - local_2c]          # 004ae0f3
    mov ax, word ptr [edx + field_20]            # 004ae0f6
    mov word ptr [ebp - local_28], ax            # 004ae0fa
    mov ecx, dword ptr [ebp - local_2c]          # 004ae0fe
    mov dx, word ptr [ecx + field_22]            # 004ae101
    mov word ptr [ebp - local_20], dx            # 004ae105
    jmp.d32 L_004ade4a                           # 004ae109
L_004ae10e:
    # block 0x004ae10e: entered by jge at 0x004ade5f, 1 instruction(s), ends with forward jump to 0x004ae170
    jmp.d8 L_004ae170                            # 004ae10e
L_004ae110:
    # block 0x004ae110: entered by jmp at 0x004ae16c; jmp at 0x004ae16e, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004ae160 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ae110
    add eax, 0xd39                               # 004ae113
    push eax                                     # 004ae118
    push 0x55149c                                # 004ae119
    mov ecx, dword ptr [ebp - local_40]          # 004ae11e
    add ecx, 0xc39                               # 004ae121
    push ecx                                     # 004ae127
    call FUN_0050ca3e                            # 004ae128
    add esp, 0xc                                 # 004ae12d
    push 0x0                                     # 004ae130
    push 0x0                                     # 004ae132
    mov edx, dword ptr [ebp - local_40]          # 004ae134
    add edx, 0xc39                               # 004ae137
    push edx                                     # 004ae13d
    call FUN_0052139c                            # 004ae13e
    movsx eax, word ptr [0x63a4cd]               # 004ae143
    test eax, eax                                # 004ae14a
    je.d8 L_004ae160                             # 004ae14c
    # block 0x004ae14e: entered by fall-through of je at 0x004ae14c, 5 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ae160
    mov ecx, dword ptr [ebp - local_40]          # 004ae14e
    add ecx, 0xc39                               # 004ae151
    push ecx                                     # 004ae157
    call FUN_0044a2b7                            # 004ae158
    add esp, 0x4                                 # 004ae15d
L_004ae160:
    # block 0x004ae160: entered by je at 0x004ae14c, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ae170
    mov ecx, 0x5cf659                            # 004ae160
    call FUN_004c97b4                            # 004ae165
    jmp.d8 L_004ae170                            # 004ae16a
L_004ae16c:
    # block 0x004ae16c: entered by jmp at 0x004ae06c, 1 instruction(s), ends with backward jump to 0x004ae110
    jmp.d8 L_004ae110                            # 004ae16c
L_004ae16e:
    # block 0x004ae16e: entered by jmp at 0x004addb9, 1 instruction(s), ends with backward jump to 0x004ae110
    jmp.d8 L_004ae110                            # 004ae16e
L_004ae170:
    # block 0x004ae170: entered by jmp at 0x004ae10e; jmp at 0x004ae16a, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004ae170
    pop esi                                      # 004ae171
    {load} mov esp, ebp                          # 004ae172
    pop ebp                                      # 004ae174
    ret 0x4                                      # 004ae175

