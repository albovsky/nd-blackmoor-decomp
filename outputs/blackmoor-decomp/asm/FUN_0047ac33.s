# FUN_0047ac33
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ac33
# extent:       0x0047ac33-0x0047b1b3 (1408 code bytes)
# span:         0x0047ac33-0x0047b1d0 (code 1408, tables 24, padding 5)
# sha256:       acb243e0c64adcdf3e45a60723a474053cee6f78a723ed0489707dbffdc143a6
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047ac33
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_21, field_25, field_170; [ecx + n] field_2b, field_170; [edx + n] field_23, field_2c, field_108
# callees:      calls FUN_00479d98, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 351 instruction(s), 12 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
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
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2c, 0x2c  # offset +0x2c
.equ field_108, 0x108  # offset +0x108
.equ field_170, 0x170  # offset +0x170

# --- external targets -----------------------------------------------
.set FUN_00479d98, .text + (0x00479d98 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x0047ac33 - 0x401000
.globl FUN_0047ac33
FUN_0047ac33:
    # block 0x0047ac33: entry, 10 instruction(s), ends with jne to 0x0047aca7 (forward)
    push ebp                                     # 0047ac33
    {load} mov ebp, esp                          # 0047ac34
    sub esp, 0x28                                # 0047ac36
    movsx eax, word ptr [0x621a20]               # 0047ac39
    imul eax, eax, 0x8d                          # 0047ac40
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0047ac46
    mov dword ptr [ebp - local_24], ecx          # 0047ac4c
    movsx edx, word ptr [0x5957bb]               # 0047ac4f
    cmp edx, 0x1                                 # 0047ac56
    jne.d8 L_0047aca7                            # 0047ac59
    # block 0x0047ac5b: entered by fall-through of jne at 0x0047ac59, 21 instruction(s), calls FUN_00479d98, FUN_004c5377, falls into the block at 0x0047aca7
    lea eax, [ebp - local_20]                    # 0047ac5b
    push eax                                     # 0047ac5e
    mov ecx, dword ptr [ebp - local_24]          # 0047ac5f
    add ecx, 0x160                               # 0047ac62
    push ecx                                     # 0047ac68
    mov ecx, 0x621a02                            # 0047ac69
    call FUN_00479d98                            # 0047ac6e
    push 0x54cc20                                # 0047ac73
    lea edx, [ebp - local_20]                    # 0047ac78
    push edx                                     # 0047ac7b
    mov eax, dword ptr [ebp - local_24]          # 0047ac7c
    add eax, 0xf8                                # 0047ac7f
    push eax                                     # 0047ac84
    mov ecx, dword ptr [0x5cf665]                # 0047ac85
    push ecx                                     # 0047ac8b
    movsx edx, word ptr [0x621a1e]               # 0047ac8c
    imul edx, edx, 0x4a                          # 0047ac93
    mov eax, dword ptr [edx + 0x5d1599]          # 0047ac96
    push eax                                     # 0047ac9c
    mov ecx, 0x5cf659                            # 0047ac9d
    call FUN_004c5377                            # 0047aca2
L_0047aca7:
    # block 0x0047aca7: entered by jne at 0x0047ac59, 2 instruction(s), ends with je to 0x0047ad66 (forward)
    cmp dword ptr [0x622f2a], 0x0                # 0047aca7
    je.d32 L_0047ad66                            # 0047acae
    # block 0x0047acb4: entered by fall-through of je at 0x0047acae, 14 instruction(s), calls FUN_00479d98, ends with je to 0x0047ad2a (forward)
    movsx ecx, word ptr [0x622f2e]               # 0047acb4
    sub ecx, 0x1                                 # 0047acbb
    mov word ptr [ebp - local_4], cx             # 0047acbe
    lea edx, [ebp - local_20]                    # 0047acc2
    push edx                                     # 0047acc5
    movsx eax, word ptr [ebp - local_4]          # 0047acc6
    shl eax, 0x4                                 # 0047acca
    mov ecx, dword ptr [ebp - local_24]          # 0047accd
    lea edx, [ecx + eax + field_170]             # 0047acd0
    push edx                                     # 0047acd7
    mov ecx, 0x621a02                            # 0047acd8
    call FUN_00479d98                            # 0047acdd
    cmp dword ptr [0x622f34], 0x0                # 0047ace2
    je.d8 L_0047ad2a                             # 0047ace9
    # block 0x0047aceb: entered by fall-through of je at 0x0047ace9, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047ad66
    push 0x54cc40                                # 0047aceb
    lea eax, [ebp - local_20]                    # 0047acf0
    push eax                                     # 0047acf3
    movsx ecx, word ptr [ebp - local_4]          # 0047acf4
    shl ecx, 0x4                                 # 0047acf8
    mov edx, dword ptr [ebp - local_24]          # 0047acfb
    lea eax, [edx + ecx + field_108]             # 0047acfe
    push eax                                     # 0047ad05
    mov ecx, dword ptr [0x5cf665]                # 0047ad06
    push ecx                                     # 0047ad0c
    movsx edx, word ptr [0x621a1e]               # 0047ad0d
    imul edx, edx, 0x4a                          # 0047ad14
    mov eax, dword ptr [edx + 0x5d1599]          # 0047ad17
    push eax                                     # 0047ad1d
    mov ecx, 0x5cf659                            # 0047ad1e
    call FUN_004c5d4b                            # 0047ad23
    jmp.d8 L_0047ad66                            # 0047ad28
L_0047ad2a:
    # block 0x0047ad2a: entered by je at 0x0047ace9, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x0047ad66
    push 0x54cc70                                # 0047ad2a
    lea ecx, [ebp - local_20]                    # 0047ad2f
    push ecx                                     # 0047ad32
    movsx edx, word ptr [ebp - local_4]          # 0047ad33
    shl edx, 0x4                                 # 0047ad37
    mov eax, dword ptr [ebp - local_24]          # 0047ad3a
    lea ecx, [eax + edx + field_170]             # 0047ad3d
    push ecx                                     # 0047ad44
    mov edx, dword ptr [0x5cf665]                # 0047ad45
    push edx                                     # 0047ad4b
    mov eax, dword ptr [0x5d15e3]                # 0047ad4c
    push eax                                     # 0047ad51
    mov ecx, 0x5cf659                            # 0047ad52
    call FUN_004c5377                            # 0047ad57
    mov dword ptr [0x622f2a], 0x0                # 0047ad5c
L_0047ad66:
    # block 0x0047ad66: entered by je at 0x0047acae; jmp at 0x0047ad28, 2 instruction(s), ends with je to 0x0047ade9 (forward)
    cmp dword ptr [0x622f70], 0x0                # 0047ad66
    je.d8 L_0047ade9                             # 0047ad6d
    # block 0x0047ad6f: entered by fall-through of je at 0x0047ad6d, 27 instruction(s), calls FUN_004c5377, falls into the block at 0x0047ade9
    mov ecx, dword ptr [0x622f6c]                # 0047ad6f
    sub ecx, dword ptr [0x58318a]                # 0047ad75
    mov dword ptr [ebp - local_1c], ecx          # 0047ad7b
    mov edx, dword ptr [0x622f74]                # 0047ad7e
    sub edx, dword ptr [0x58318a]                # 0047ad84
    mov dword ptr [ebp - local_14], edx          # 0047ad8a
    mov eax, dword ptr [0x622f68]                # 0047ad8d
    sub eax, dword ptr [0x583186]                # 0047ad92
    mov dword ptr [ebp - local_20], eax          # 0047ad98
    mov ecx, dword ptr [0x622f70]                # 0047ad9b
    sub ecx, dword ptr [0x583186]                # 0047ada1
    mov dword ptr [ebp - local_18], ecx          # 0047ada7
    push 0x54cc94                                # 0047adaa
    push 0x622f68                                # 0047adaf
    lea edx, [ebp - local_20]                    # 0047adb4
    push edx                                     # 0047adb7
    mov eax, dword ptr [0x5cf665]                # 0047adb8
    push eax                                     # 0047adbd
    mov ecx, dword ptr [0x5d15e3]                # 0047adbe
    push ecx                                     # 0047adc4
    mov ecx, 0x5cf659                            # 0047adc5
    call FUN_004c5377                            # 0047adca
    {load} xor edx, edx                          # 0047adcf
    mov dword ptr [0x622f68], edx                # 0047add1
    mov dword ptr [0x622f6c], edx                # 0047add7
    mov dword ptr [0x622f70], edx                # 0047addd
    mov dword ptr [0x622f74], edx                # 0047ade3
L_0047ade9:
    # block 0x0047ade9: entered by je at 0x0047ad6d, 2 instruction(s), ends with forward jump to 0x0047adfd
    mov word ptr [ebp - local_8], 0x0            # 0047ade9
    jmp.d8 L_0047adfd                            # 0047adef
L_0047adf1:
    # block 0x0047adf1: entered by jmp at 0x0047b0f4, 3 instruction(s), falls into the block at 0x0047adfd
    mov ax, word ptr [ebp - local_8]             # 0047adf1
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047adf5
    mov word ptr [ebp - local_8], ax             # 0047adf9
L_0047adfd:
    # block 0x0047adfd: entered by jmp at 0x0047adef, 5 instruction(s), ends with jge to 0x0047b0f9 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0047adfd
    mov edx, dword ptr [ebp - local_24]          # 0047ae01
    movsx eax, word ptr [edx + field_23]         # 0047ae04
    {load} cmp ecx, eax                          # 0047ae08
    jge.d32 L_0047b0f9                           # 0047ae0a
    # block 0x0047ae10: entered by fall-through of jge at 0x0047ae0a, 2 instruction(s), ends with forward jump to 0x0047ae24
    mov word ptr [ebp - local_10], 0x0           # 0047ae10
    jmp.d8 L_0047ae24                            # 0047ae16
L_0047ae18:
    # block 0x0047ae18: entered by jmp at 0x0047b0ef, 3 instruction(s), falls into the block at 0x0047ae24
    mov cx, word ptr [ebp - local_10]            # 0047ae18
    add cx, 0x1                                  # 0047ae1c
    mov word ptr [ebp - local_10], cx            # 0047ae20
L_0047ae24:
    # block 0x0047ae24: entered by jmp at 0x0047ae16, 5 instruction(s), ends with jge to 0x0047b0f4 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0047ae24
    mov eax, dword ptr [ebp - local_24]          # 0047ae28
    movsx ecx, word ptr [eax + field_21]         # 0047ae2b
    {load} cmp edx, ecx                          # 0047ae2f
    jge.d32 L_0047b0f4                           # 0047ae31
    # block 0x0047ae37: entered by fall-through of jge at 0x0047ae31, 6 instruction(s), ends with je to 0x0047b0ef (forward)
    movsx edx, word ptr [ebp - local_8]          # 0047ae37
    imul edx, edx, 0x2a0                         # 0047ae3b
    movsx eax, word ptr [ebp - local_10]         # 0047ae41
    imul eax, eax, 0x54                          # 0047ae45
    cmp dword ptr [edx + eax + 0x621a2a], 0x0    # 0047ae48
    je.d32 L_0047b0ef                            # 0047ae50
    # block 0x0047ae56: entered by fall-through of je at 0x0047ae50, 12 instruction(s), ends with ja to 0x0047b0ef (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0047ae56
    shl ecx, 0x4                                 # 0047ae5a
    mov edx, dword ptr [ebp - local_24]          # 0047ae5d
    lea eax, [edx + ecx + field_2c]              # 0047ae60
    movsx ecx, word ptr [ebp - local_10]         # 0047ae64
    movsx edx, word ptr [eax + 2*ecx]            # 0047ae68
    mov dword ptr [ebp - local_28], edx          # 0047ae6c
    mov eax, dword ptr [ebp - local_28]          # 0047ae6f
    sub eax, 0x1                                 # 0047ae72
    mov dword ptr [ebp - local_28], eax          # 0047ae75
    cmp dword ptr [ebp - local_28], 0x5          # 0047ae78
    ja.d32 L_0047b0ef                            # 0047ae7c
    # block 0x0047ae82: entered by fall-through of ja at 0x0047ae7c, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x47b1b3]
    mov ecx, dword ptr [ebp - local_28]          # 0047ae82
    jmp dword ptr [4*ecx + SWTAB_0047b1b3_VA]    # 0047ae85
L_0047ae8c:
    # block 0x0047ae8c: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047b0ef
    push 0x54ccc4                                # 0047ae8c
    movsx edx, word ptr [ebp - local_8]          # 0047ae91
    imul edx, edx, 0x2a0                         # 0047ae95
    movsx eax, word ptr [ebp - local_10]         # 0047ae9b
    imul eax, eax, 0x54                          # 0047ae9f
    lea ecx, [edx + eax + 0x621a3e]              # 0047aea2
    push ecx                                     # 0047aea9
    mov edx, dword ptr [ebp - local_24]          # 0047aeaa
    add edx, 0xd8                                # 0047aead
    push edx                                     # 0047aeb3
    mov eax, dword ptr [0x5cf665]                # 0047aeb4
    push eax                                     # 0047aeb9
    movsx ecx, word ptr [0x621a1e]               # 0047aeba
    imul ecx, ecx, 0x4a                          # 0047aec1
    mov edx, dword ptr [ecx + 0x5d1599]          # 0047aec4
    push edx                                     # 0047aeca
    mov ecx, 0x5cf659                            # 0047aecb
    call FUN_004c5d4b                            # 0047aed0
    jmp.d32 L_0047b0ef                           # 0047aed5
L_0047aeda:
    # block 0x0047aeda: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047b0ef
    push 0x54cce0                                # 0047aeda
    movsx eax, word ptr [ebp - local_8]          # 0047aedf
    imul eax, eax, 0x2a0                         # 0047aee3
    movsx ecx, word ptr [ebp - local_10]         # 0047aee9
    imul ecx, ecx, 0x54                          # 0047aeed
    lea edx, [eax + ecx + 0x621a5e]              # 0047aef0
    push edx                                     # 0047aef7
    mov eax, dword ptr [ebp - local_24]          # 0047aef8
    add eax, 0xd8                                # 0047aefb
    push eax                                     # 0047af00
    mov ecx, dword ptr [0x5cf665]                # 0047af01
    push ecx                                     # 0047af07
    movsx edx, word ptr [0x621a1e]               # 0047af08
    imul edx, edx, 0x4a                          # 0047af0f
    mov eax, dword ptr [edx + 0x5d1599]          # 0047af12
    push eax                                     # 0047af18
    mov ecx, 0x5cf659                            # 0047af19
    call FUN_004c5d4b                            # 0047af1e
    jmp.d32 L_0047b0ef                           # 0047af23
L_0047af28:
    # block 0x0047af28: entered by switch case, 37 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047b0ef
    push 0x54ccfc                                # 0047af28
    movsx ecx, word ptr [ebp - local_8]          # 0047af2d
    imul ecx, ecx, 0x2a0                         # 0047af31
    movsx edx, word ptr [ebp - local_10]         # 0047af37
    imul edx, edx, 0x54                          # 0047af3b
    lea eax, [ecx + edx + 0x621a3e]              # 0047af3e
    push eax                                     # 0047af45
    mov ecx, dword ptr [ebp - local_24]          # 0047af46
    add ecx, 0xd8                                # 0047af49
    push ecx                                     # 0047af4f
    mov edx, dword ptr [0x5cf665]                # 0047af50
    push edx                                     # 0047af56
    movsx eax, word ptr [0x621a1e]               # 0047af57
    imul eax, eax, 0x4a                          # 0047af5e
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047af61
    push ecx                                     # 0047af67
    mov ecx, 0x5cf659                            # 0047af68
    call FUN_004c5d4b                            # 0047af6d
    push 0x54cd18                                # 0047af72
    movsx edx, word ptr [ebp - local_8]          # 0047af77
    imul edx, edx, 0x2a0                         # 0047af7b
    movsx eax, word ptr [ebp - local_10]         # 0047af81
    imul eax, eax, 0x54                          # 0047af85
    lea ecx, [edx + eax + 0x621a5e]              # 0047af88
    push ecx                                     # 0047af8f
    mov edx, dword ptr [ebp - local_24]          # 0047af90
    add edx, 0xd8                                # 0047af93
    push edx                                     # 0047af99
    mov eax, dword ptr [0x5cf665]                # 0047af9a
    push eax                                     # 0047af9f
    movsx ecx, word ptr [0x621a1e]               # 0047afa0
    imul ecx, ecx, 0x4a                          # 0047afa7
    mov edx, dword ptr [ecx + 0x5d1599]          # 0047afaa
    push edx                                     # 0047afb0
    mov ecx, 0x5cf659                            # 0047afb1
    call FUN_004c5d4b                            # 0047afb6
    jmp.d32 L_0047b0ef                           # 0047afbb
L_0047afc0:
    # block 0x0047afc0: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047b0ef
    push 0x54cd34                                # 0047afc0
    movsx eax, word ptr [ebp - local_8]          # 0047afc5
    imul eax, eax, 0x2a0                         # 0047afc9
    movsx ecx, word ptr [ebp - local_10]         # 0047afcf
    imul ecx, ecx, 0x54                          # 0047afd3
    lea edx, [eax + ecx + 0x621a4e]              # 0047afd6
    push edx                                     # 0047afdd
    mov eax, dword ptr [ebp - local_24]          # 0047afde
    add eax, 0xe8                                # 0047afe1
    push eax                                     # 0047afe6
    mov ecx, dword ptr [0x5cf665]                # 0047afe7
    push ecx                                     # 0047afed
    movsx edx, word ptr [0x621a1e]               # 0047afee
    imul edx, edx, 0x4a                          # 0047aff5
    mov eax, dword ptr [edx + 0x5d1599]          # 0047aff8
    push eax                                     # 0047affe
    mov ecx, 0x5cf659                            # 0047afff
    call FUN_004c5d4b                            # 0047b004
    jmp.d32 L_0047b0ef                           # 0047b009
L_0047b00e:
    # block 0x0047b00e: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0047b0ef
    push 0x54cd50                                # 0047b00e
    movsx ecx, word ptr [ebp - local_8]          # 0047b013
    imul ecx, ecx, 0x2a0                         # 0047b017
    movsx edx, word ptr [ebp - local_10]         # 0047b01d
    imul edx, edx, 0x54                          # 0047b021
    lea eax, [ecx + edx + 0x621a6e]              # 0047b024
    push eax                                     # 0047b02b
    mov ecx, dword ptr [ebp - local_24]          # 0047b02c
    add ecx, 0xe8                                # 0047b02f
    push ecx                                     # 0047b035
    mov edx, dword ptr [0x5cf665]                # 0047b036
    push edx                                     # 0047b03c
    movsx eax, word ptr [0x621a1e]               # 0047b03d
    imul eax, eax, 0x4a                          # 0047b044
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047b047
    push ecx                                     # 0047b04d
    mov ecx, 0x5cf659                            # 0047b04e
    call FUN_004c5d4b                            # 0047b053
    jmp.d32 L_0047b0ef                           # 0047b058
L_0047b05d:
    # block 0x0047b05d: entered by switch case, 36 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0047b0ef
    push 0x54cd6c                                # 0047b05d
    movsx edx, word ptr [ebp - local_8]          # 0047b062
    imul edx, edx, 0x2a0                         # 0047b066
    movsx eax, word ptr [ebp - local_10]         # 0047b06c
    imul eax, eax, 0x54                          # 0047b070
    lea ecx, [edx + eax + 0x621a4e]              # 0047b073
    push ecx                                     # 0047b07a
    mov edx, dword ptr [ebp - local_24]          # 0047b07b
    add edx, 0xe8                                # 0047b07e
    push edx                                     # 0047b084
    mov eax, dword ptr [0x5cf665]                # 0047b085
    push eax                                     # 0047b08a
    movsx ecx, word ptr [0x621a1e]               # 0047b08b
    imul ecx, ecx, 0x4a                          # 0047b092
    mov edx, dword ptr [ecx + 0x5d1599]          # 0047b095
    push edx                                     # 0047b09b
    mov ecx, 0x5cf659                            # 0047b09c
    call FUN_004c5d4b                            # 0047b0a1
    push 0x54cd88                                # 0047b0a6
    movsx eax, word ptr [ebp - local_8]          # 0047b0ab
    imul eax, eax, 0x2a0                         # 0047b0af
    movsx ecx, word ptr [ebp - local_10]         # 0047b0b5
    imul ecx, ecx, 0x54                          # 0047b0b9
    lea edx, [eax + ecx + 0x621a6e]              # 0047b0bc
    push edx                                     # 0047b0c3
    mov eax, dword ptr [ebp - local_24]          # 0047b0c4
    add eax, 0xe8                                # 0047b0c7
    push eax                                     # 0047b0cc
    mov ecx, dword ptr [0x5cf665]                # 0047b0cd
    push ecx                                     # 0047b0d3
    movsx edx, word ptr [0x621a1e]               # 0047b0d4
    imul edx, edx, 0x4a                          # 0047b0db
    mov eax, dword ptr [edx + 0x5d1599]          # 0047b0de
    push eax                                     # 0047b0e4
    mov ecx, 0x5cf659                            # 0047b0e5
    call FUN_004c5d4b                            # 0047b0ea
L_0047b0ef:
    # block 0x0047b0ef: entered by je at 0x0047ae50; ja at 0x0047ae7c; jmp at 0x0047aed5; jmp at 0x0047af23; more, 1 instruction(s), ends with backward jump to 0x0047ae18
    jmp.d32 L_0047ae18                           # 0047b0ef
L_0047b0f4:
    # block 0x0047b0f4: entered by jge at 0x0047ae31, 1 instruction(s), ends with backward jump to 0x0047adf1
    jmp.d32 L_0047adf1                           # 0047b0f4
L_0047b0f9:
    # block 0x0047b0f9: entered by jge at 0x0047ae0a, 2 instruction(s), ends with je to 0x0047b117 (forward)
    cmp dword ptr [0x622f78], 0x0                # 0047b0f9
    je.d8 L_0047b117                             # 0047b100
    # block 0x0047b102: entered by fall-through of je at 0x0047b100, 2 instruction(s), ends with je to 0x0047b14c (forward)
    cmp dword ptr [0x622f78], 0x0                # 0047b102
    je.d8 L_0047b14c                             # 0047b109
    # block 0x0047b10b: entered by fall-through of je at 0x0047b109, 5 instruction(s), ends with je to 0x0047b14c (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047b10b
    {load} xor edx, edx                          # 0047b10e
    mov dl, byte ptr [ecx + field_2b]            # 0047b110
    test edx, edx                                # 0047b113
    je.d8 L_0047b14c                             # 0047b115
L_0047b117:
    # block 0x0047b117: entered by je at 0x0047b100; fall-through of je at 0x0047b115, 13 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0047b14c
    push 0x54cda4                                # 0047b117
    push 0x622f38                                # 0047b11c
    mov eax, dword ptr [ebp - local_24]          # 0047b121
    add eax, 0xb8                                # 0047b124
    push eax                                     # 0047b129
    mov ecx, dword ptr [0x5cf665]                # 0047b12a
    push ecx                                     # 0047b130
    movsx edx, word ptr [0x621a1e]               # 0047b131
    imul edx, edx, 0x4a                          # 0047b138
    mov eax, dword ptr [edx + 0x5d1599]          # 0047b13b
    push eax                                     # 0047b141
    mov ecx, 0x5cf659                            # 0047b142
    call FUN_004c5d4b                            # 0047b147
L_0047b14c:
    # block 0x0047b14c: entered by je at 0x0047b109; je at 0x0047b115, 2 instruction(s), ends with forward jump to 0x0047b160
    mov word ptr [ebp - local_c], 0x0            # 0047b14c
    jmp.d8 L_0047b160                            # 0047b152
L_0047b154:
    # block 0x0047b154: entered by jmp at 0x0047b1ad, 3 instruction(s), falls into the block at 0x0047b160
    mov cx, word ptr [ebp - local_c]             # 0047b154
    add cx, 0x1                                  # 0047b158
    mov word ptr [ebp - local_c], cx             # 0047b15c
L_0047b160:
    # block 0x0047b160: entered by jmp at 0x0047b152, 5 instruction(s), ends with jge to 0x0047b1af (forward)
    movsx edx, word ptr [ebp - local_c]          # 0047b160
    mov eax, dword ptr [ebp - local_24]          # 0047b164
    movsx ecx, word ptr [eax + field_25]         # 0047b167
    {load} cmp edx, ecx                          # 0047b16b
    jge.d8 L_0047b1af                            # 0047b16d
    # block 0x0047b16f: entered by fall-through of jge at 0x0047b16d, 17 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x0047b154
    push 0x54cdbc                                # 0047b16f
    movsx edx, word ptr [ebp - local_c]          # 0047b174
    shl edx, 0x4                                 # 0047b178
    add edx, 0x622f48                            # 0047b17b
    push edx                                     # 0047b181
    mov eax, dword ptr [ebp - local_24]          # 0047b182
    add eax, 0xc8                                # 0047b185
    push eax                                     # 0047b18a
    mov ecx, dword ptr [0x5cf665]                # 0047b18b
    push ecx                                     # 0047b191
    movsx edx, word ptr [0x621a1e]               # 0047b192
    imul edx, edx, 0x4a                          # 0047b199
    mov eax, dword ptr [edx + 0x5d1599]          # 0047b19c
    push eax                                     # 0047b1a2
    mov ecx, 0x5cf659                            # 0047b1a3
    call FUN_004c5d4b                            # 0047b1a8
    jmp.d8 L_0047b154                            # 0047b1ad
L_0047b1af:
    # block 0x0047b1af: entered by jge at 0x0047b16d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047b1af
    pop ebp                                      # 0047b1b1
    ret                                          # 0047b1b2

# --- data items (not part of the function) -------------------------
.org 0x0047b1b3 - 0x401000
SWTAB_0047b1b3:  # 6 case address(es)
    .long L_0047ae8c - .text + 0x401000
    .long L_0047afc0 - .text + 0x401000
    .long L_0047aeda - .text + 0x401000
    .long L_0047b00e - .text + 0x401000
    .long L_0047af28 - .text + 0x401000
    .long L_0047b05d - .text + 0x401000
.org 0x0047b1cb - 0x401000
PAD_0047b1cb:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc
.set SWTAB_0047b1b3_VA, SWTAB_0047b1b3 - .text + 0x401000

