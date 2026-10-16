# FUN_0046ab7f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ab7f
# extent:       0x0046ab7f-0x0046b469 (2282 code bytes)
# span:         0x0046ab7f-0x0046b470 (code 2282, tables 0, padding 7)
# sha256:       351508c258b4d4e914adc8798edcd13d81ae8c182c0cd6c21f667be249937b4d
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046ab7f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_a5, field_d5, field_105; [ecx + n] field_95, field_c5, field_f5; [edx + n] field_85, field_b5, field_e5, field_115
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 532 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_85, 0x85  # offset +0x85
.equ field_95, 0x95  # offset +0x95
.equ field_a5, 0xa5  # offset +0xa5
.equ field_b5, 0xb5  # offset +0xb5
.equ field_c5, 0xc5  # offset +0xc5
.equ field_d5, 0xd5  # offset +0xd5
.equ field_e5, 0xe5  # offset +0xe5
.equ field_f5, 0xf5  # offset +0xf5
.equ field_105, 0x105  # offset +0x105
.equ field_115, 0x115  # offset +0x115

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0046ab7f - 0x401000
.globl FUN_0046ab7f
FUN_0046ab7f:
    # block 0x0046ab7f: entry, 5 instruction(s), ends with je to 0x0046abd3 (forward)
    push ebp                                     # 0046ab7f
    {load} mov ebp, esp                          # 0046ab80
    sub esp, 0x14                                # 0046ab82
    cmp dword ptr [0x616c0a], 0x0                # 0046ab85
    je.d8 L_0046abd3                             # 0046ab8c
    # block 0x0046ab8e: entered by fall-through of je at 0x0046ab8c, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046ac0c
    push 0x54ba4c                                # 0046ab8e
    push 0x616c0e                                # 0046ab93
    movsx eax, word ptr [0x616b30]               # 0046ab98
    imul eax, eax, 0x8d                          # 0046ab9f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046aba5
    add ecx, 0x21                                # 0046abab
    push ecx                                     # 0046abae
    mov edx, dword ptr [0x5cf665]                # 0046abaf
    push edx                                     # 0046abb5
    movsx eax, word ptr [0x616b2e]               # 0046abb6
    imul eax, eax, 0x4a                          # 0046abbd
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046abc0
    push ecx                                     # 0046abc6
    mov ecx, 0x5cf659                            # 0046abc7
    call FUN_004c5377                            # 0046abcc
    jmp.d8 L_0046ac0c                            # 0046abd1
L_0046abd3:
    # block 0x0046abd3: entered by je at 0x0046ab8c, 13 instruction(s), calls FUN_004c5377, falls into the block at 0x0046ac0c
    push 0x54ba6c                                # 0046abd3
    push 0x616c0e                                # 0046abd8
    movsx edx, word ptr [0x616b30]               # 0046abdd
    imul edx, edx, 0x8d                          # 0046abe4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046abea
    add eax, 0x31                                # 0046abf0
    push eax                                     # 0046abf3
    mov ecx, dword ptr [0x5cf665]                # 0046abf4
    push ecx                                     # 0046abfa
    mov edx, dword ptr [0x5d15e3]                # 0046abfb
    push edx                                     # 0046ac01
    mov ecx, 0x5cf659                            # 0046ac02
    call FUN_004c5377                            # 0046ac07
L_0046ac0c:
    # block 0x0046ac0c: entered by jmp at 0x0046abd1, 2 instruction(s), ends with forward jump to 0x0046ac20
    mov word ptr [ebp - local_4], 0x0            # 0046ac0c
    jmp.d8 L_0046ac20                            # 0046ac12
L_0046ac14:
    # block 0x0046ac14: entered by jmp at 0x0046b460, 3 instruction(s), falls into the block at 0x0046ac20
    mov ax, word ptr [ebp - local_4]             # 0046ac14
    .insn 0x66, 0x05, 0x0001{:u16}               # 0046ac18
    mov word ptr [ebp - local_4], ax             # 0046ac1c
L_0046ac20:
    # block 0x0046ac20: entered by jmp at 0x0046ac12, 3 instruction(s), ends with jge to 0x0046b465 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046ac20
    cmp ecx, 0x6                                 # 0046ac24
    jge.d32 L_0046b465                           # 0046ac27
    # block 0x0046ac2d: entered by fall-through of jge at 0x0046ac27, 6 instruction(s), ends with jne to 0x0046ac94 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0046ac2d
    fld dword ptr [4*edx + 0x5919dc]             # 0046ac31
    fcomp qword ptr [0x52d2a8]                   # 0046ac38
    fnstsw ax                                    # 0046ac3e
    test ah, 0x1                                 # 0046ac40
    jne.d8 L_0046ac94                            # 0046ac43
    # block 0x0046ac45: entered by fall-through of jne at 0x0046ac43, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046ace5
    push 0x54ba8c                                # 0046ac45
    movsx eax, word ptr [ebp - local_4]          # 0046ac4a
    imul eax, eax, 0xa0                          # 0046ac4e
    add eax, 0x616c1e                            # 0046ac54
    push eax                                     # 0046ac59
    movsx ecx, word ptr [0x616b30]               # 0046ac5a
    imul ecx, ecx, 0x8d                          # 0046ac61
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046ac67
    add edx, 0x75                                # 0046ac6d
    push edx                                     # 0046ac70
    mov eax, dword ptr [0x5cf665]                # 0046ac71
    push eax                                     # 0046ac76
    movsx ecx, word ptr [0x616b2e]               # 0046ac77
    imul ecx, ecx, 0x4a                          # 0046ac7e
    mov edx, dword ptr [ecx + 0x5d1599]          # 0046ac81
    push edx                                     # 0046ac87
    mov ecx, 0x5cf659                            # 0046ac88
    call FUN_004c5377                            # 0046ac8d
    jmp.d8 L_0046ace5                            # 0046ac92
L_0046ac94:
    # block 0x0046ac94: entered by jne at 0x0046ac43, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046ace5
    push 0x54baa4                                # 0046ac94
    movsx eax, word ptr [ebp - local_4]          # 0046ac99
    imul eax, eax, 0xa0                          # 0046ac9d
    add eax, 0x616c1e                            # 0046aca3
    push eax                                     # 0046aca8
    movsx ecx, word ptr [0x616b30]               # 0046aca9
    imul ecx, ecx, 0x8d                          # 0046acb0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046acb6
    movsx eax, word ptr [ebp - local_4]          # 0046acbc
    imul eax, eax, 0xa0                          # 0046acc0
    lea ecx, [edx + eax + field_85]              # 0046acc6
    push ecx                                     # 0046accd
    mov edx, dword ptr [0x5cf665]                # 0046acce
    push edx                                     # 0046acd4
    mov eax, dword ptr [0x5d15e3]                # 0046acd5
    push eax                                     # 0046acda
    mov ecx, 0x5cf659                            # 0046acdb
    call FUN_004c5377                            # 0046ace0
L_0046ace5:
    # block 0x0046ace5: entered by jmp at 0x0046ac92, 6 instruction(s), ends with jne to 0x0046ad4e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046ace5
    fld dword ptr [4*ecx + 0x5919dc]             # 0046ace9
    fcomp qword ptr [0x52d2a0]                   # 0046acf0
    fnstsw ax                                    # 0046acf6
    test ah, 0x1                                 # 0046acf8
    jne.d8 L_0046ad4e                            # 0046acfb
    # block 0x0046acfd: entered by fall-through of jne at 0x0046acfb, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046ada1
    push 0x54bab8                                # 0046acfd
    movsx edx, word ptr [ebp - local_4]          # 0046ad02
    imul edx, edx, 0xa0                          # 0046ad06
    add edx, 0x616c2e                            # 0046ad0c
    push edx                                     # 0046ad12
    movsx eax, word ptr [0x616b30]               # 0046ad13
    imul eax, eax, 0x8d                          # 0046ad1a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046ad20
    add ecx, 0x75                                # 0046ad26
    push ecx                                     # 0046ad29
    mov edx, dword ptr [0x5cf665]                # 0046ad2a
    push edx                                     # 0046ad30
    movsx eax, word ptr [0x616b2e]               # 0046ad31
    imul eax, eax, 0x4a                          # 0046ad38
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046ad3b
    push ecx                                     # 0046ad41
    mov ecx, 0x5cf659                            # 0046ad42
    call FUN_004c5377                            # 0046ad47
    jmp.d8 L_0046ada1                            # 0046ad4c
L_0046ad4e:
    # block 0x0046ad4e: entered by jne at 0x0046acfb, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046ada1
    push 0x54bad0                                # 0046ad4e
    movsx edx, word ptr [ebp - local_4]          # 0046ad53
    imul edx, edx, 0xa0                          # 0046ad57
    add edx, 0x616c2e                            # 0046ad5d
    push edx                                     # 0046ad63
    movsx eax, word ptr [0x616b30]               # 0046ad64
    imul eax, eax, 0x8d                          # 0046ad6b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046ad71
    movsx edx, word ptr [ebp - local_4]          # 0046ad77
    imul edx, edx, 0xa0                          # 0046ad7b
    lea eax, [ecx + edx + field_95]              # 0046ad81
    push eax                                     # 0046ad88
    mov ecx, dword ptr [0x5cf665]                # 0046ad89
    push ecx                                     # 0046ad8f
    mov edx, dword ptr [0x5d15e3]                # 0046ad90
    push edx                                     # 0046ad96
    mov ecx, 0x5cf659                            # 0046ad97
    call FUN_004c5377                            # 0046ad9c
L_0046ada1:
    # block 0x0046ada1: entered by jmp at 0x0046ad4c, 6 instruction(s), ends with jne to 0x0046ae0a (forward)
    movsx eax, word ptr [ebp - local_4]          # 0046ada1
    fld dword ptr [4*eax + 0x5919dc]             # 0046ada5
    fcomp qword ptr [0x52d298]                   # 0046adac
    fnstsw ax                                    # 0046adb2
    test ah, 0x1                                 # 0046adb4
    jne.d8 L_0046ae0a                            # 0046adb7
    # block 0x0046adb9: entered by fall-through of jne at 0x0046adb7, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046ae5c
    push 0x54bae4                                # 0046adb9
    movsx ecx, word ptr [ebp - local_4]          # 0046adbe
    imul ecx, ecx, 0xa0                          # 0046adc2
    add ecx, 0x616c3e                            # 0046adc8
    push ecx                                     # 0046adce
    movsx edx, word ptr [0x616b30]               # 0046adcf
    imul edx, edx, 0x8d                          # 0046add6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046addc
    add eax, 0x75                                # 0046ade2
    push eax                                     # 0046ade5
    mov ecx, dword ptr [0x5cf665]                # 0046ade6
    push ecx                                     # 0046adec
    movsx edx, word ptr [0x616b2e]               # 0046aded
    imul edx, edx, 0x4a                          # 0046adf4
    mov eax, dword ptr [edx + 0x5d1599]          # 0046adf7
    push eax                                     # 0046adfd
    mov ecx, 0x5cf659                            # 0046adfe
    call FUN_004c5377                            # 0046ae03
    jmp.d8 L_0046ae5c                            # 0046ae08
L_0046ae0a:
    # block 0x0046ae0a: entered by jne at 0x0046adb7, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046ae5c
    push 0x54bafc                                # 0046ae0a
    movsx ecx, word ptr [ebp - local_4]          # 0046ae0f
    imul ecx, ecx, 0xa0                          # 0046ae13
    add ecx, 0x616c3e                            # 0046ae19
    push ecx                                     # 0046ae1f
    movsx edx, word ptr [0x616b30]               # 0046ae20
    imul edx, edx, 0x8d                          # 0046ae27
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046ae2d
    movsx ecx, word ptr [ebp - local_4]          # 0046ae33
    imul ecx, ecx, 0xa0                          # 0046ae37
    lea edx, [eax + ecx + field_a5]              # 0046ae3d
    push edx                                     # 0046ae44
    mov eax, dword ptr [0x5cf665]                # 0046ae45
    push eax                                     # 0046ae4a
    mov ecx, dword ptr [0x5d15e3]                # 0046ae4b
    push ecx                                     # 0046ae51
    mov ecx, 0x5cf659                            # 0046ae52
    call FUN_004c5377                            # 0046ae57
L_0046ae5c:
    # block 0x0046ae5c: entered by jmp at 0x0046ae08, 6 instruction(s), ends with jne to 0x0046aec3 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0046ae5c
    fld dword ptr [4*edx + 0x5919dc]             # 0046ae60
    fcomp qword ptr [0x52d290]                   # 0046ae67
    fnstsw ax                                    # 0046ae6d
    test ah, 0x1                                 # 0046ae6f
    jne.d8 L_0046aec3                            # 0046ae72
    # block 0x0046ae74: entered by fall-through of jne at 0x0046ae72, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046af14
    push 0x54bb10                                # 0046ae74
    movsx eax, word ptr [ebp - local_4]          # 0046ae79
    imul eax, eax, 0xa0                          # 0046ae7d
    add eax, 0x616c4e                            # 0046ae83
    push eax                                     # 0046ae88
    movsx ecx, word ptr [0x616b30]               # 0046ae89
    imul ecx, ecx, 0x8d                          # 0046ae90
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046ae96
    add edx, 0x75                                # 0046ae9c
    push edx                                     # 0046ae9f
    mov eax, dword ptr [0x5cf665]                # 0046aea0
    push eax                                     # 0046aea5
    movsx ecx, word ptr [0x616b2e]               # 0046aea6
    imul ecx, ecx, 0x4a                          # 0046aead
    mov edx, dword ptr [ecx + 0x5d1599]          # 0046aeb0
    push edx                                     # 0046aeb6
    mov ecx, 0x5cf659                            # 0046aeb7
    call FUN_004c5377                            # 0046aebc
    jmp.d8 L_0046af14                            # 0046aec1
L_0046aec3:
    # block 0x0046aec3: entered by jne at 0x0046ae72, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046af14
    push 0x54bb28                                # 0046aec3
    movsx eax, word ptr [ebp - local_4]          # 0046aec8
    imul eax, eax, 0xa0                          # 0046aecc
    add eax, 0x616c4e                            # 0046aed2
    push eax                                     # 0046aed7
    movsx ecx, word ptr [0x616b30]               # 0046aed8
    imul ecx, ecx, 0x8d                          # 0046aedf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046aee5
    movsx eax, word ptr [ebp - local_4]          # 0046aeeb
    imul eax, eax, 0xa0                          # 0046aeef
    lea ecx, [edx + eax + field_b5]              # 0046aef5
    push ecx                                     # 0046aefc
    mov edx, dword ptr [0x5cf665]                # 0046aefd
    push edx                                     # 0046af03
    mov eax, dword ptr [0x5d15e3]                # 0046af04
    push eax                                     # 0046af09
    mov ecx, 0x5cf659                            # 0046af0a
    call FUN_004c5377                            # 0046af0f
L_0046af14:
    # block 0x0046af14: entered by jmp at 0x0046aec1, 6 instruction(s), ends with jne to 0x0046af7d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046af14
    fld dword ptr [4*ecx + 0x5919dc]             # 0046af18
    fcomp qword ptr [0x52cac0]                   # 0046af1f
    fnstsw ax                                    # 0046af25
    test ah, 0x1                                 # 0046af27
    jne.d8 L_0046af7d                            # 0046af2a
    # block 0x0046af2c: entered by fall-through of jne at 0x0046af2a, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046afd0
    push 0x54bb3c                                # 0046af2c
    movsx edx, word ptr [ebp - local_4]          # 0046af31
    imul edx, edx, 0xa0                          # 0046af35
    add edx, 0x616c5e                            # 0046af3b
    push edx                                     # 0046af41
    movsx eax, word ptr [0x616b30]               # 0046af42
    imul eax, eax, 0x8d                          # 0046af49
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046af4f
    add ecx, 0x75                                # 0046af55
    push ecx                                     # 0046af58
    mov edx, dword ptr [0x5cf665]                # 0046af59
    push edx                                     # 0046af5f
    movsx eax, word ptr [0x616b2e]               # 0046af60
    imul eax, eax, 0x4a                          # 0046af67
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046af6a
    push ecx                                     # 0046af70
    mov ecx, 0x5cf659                            # 0046af71
    call FUN_004c5377                            # 0046af76
    jmp.d8 L_0046afd0                            # 0046af7b
L_0046af7d:
    # block 0x0046af7d: entered by jne at 0x0046af2a, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046afd0
    push 0x54bb54                                # 0046af7d
    movsx edx, word ptr [ebp - local_4]          # 0046af82
    imul edx, edx, 0xa0                          # 0046af86
    add edx, 0x616c5e                            # 0046af8c
    push edx                                     # 0046af92
    movsx eax, word ptr [0x616b30]               # 0046af93
    imul eax, eax, 0x8d                          # 0046af9a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046afa0
    movsx edx, word ptr [ebp - local_4]          # 0046afa6
    imul edx, edx, 0xa0                          # 0046afaa
    lea eax, [ecx + edx + field_c5]              # 0046afb0
    push eax                                     # 0046afb7
    mov ecx, dword ptr [0x5cf665]                # 0046afb8
    push ecx                                     # 0046afbe
    mov edx, dword ptr [0x5d15e3]                # 0046afbf
    push edx                                     # 0046afc5
    mov ecx, 0x5cf659                            # 0046afc6
    call FUN_004c5377                            # 0046afcb
L_0046afd0:
    # block 0x0046afd0: entered by jmp at 0x0046af7b, 6 instruction(s), ends with jne to 0x0046b039 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0046afd0
    fld dword ptr [4*eax + 0x5919dc]             # 0046afd4
    fcomp qword ptr [0x52d288]                   # 0046afdb
    fnstsw ax                                    # 0046afe1
    test ah, 0x1                                 # 0046afe3
    jne.d8 L_0046b039                            # 0046afe6
    # block 0x0046afe8: entered by fall-through of jne at 0x0046afe6, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046b08b
    push 0x54bb68                                # 0046afe8
    movsx ecx, word ptr [ebp - local_4]          # 0046afed
    imul ecx, ecx, 0xa0                          # 0046aff1
    add ecx, 0x616c6e                            # 0046aff7
    push ecx                                     # 0046affd
    movsx edx, word ptr [0x616b30]               # 0046affe
    imul edx, edx, 0x8d                          # 0046b005
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046b00b
    add eax, 0x75                                # 0046b011
    push eax                                     # 0046b014
    mov ecx, dword ptr [0x5cf665]                # 0046b015
    push ecx                                     # 0046b01b
    movsx edx, word ptr [0x616b2e]               # 0046b01c
    imul edx, edx, 0x4a                          # 0046b023
    mov eax, dword ptr [edx + 0x5d1599]          # 0046b026
    push eax                                     # 0046b02c
    mov ecx, 0x5cf659                            # 0046b02d
    call FUN_004c5377                            # 0046b032
    jmp.d8 L_0046b08b                            # 0046b037
L_0046b039:
    # block 0x0046b039: entered by jne at 0x0046afe6, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b08b
    push 0x54bb80                                # 0046b039
    movsx ecx, word ptr [ebp - local_4]          # 0046b03e
    imul ecx, ecx, 0xa0                          # 0046b042
    add ecx, 0x616c6e                            # 0046b048
    push ecx                                     # 0046b04e
    movsx edx, word ptr [0x616b30]               # 0046b04f
    imul edx, edx, 0x8d                          # 0046b056
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046b05c
    movsx ecx, word ptr [ebp - local_4]          # 0046b062
    imul ecx, ecx, 0xa0                          # 0046b066
    lea edx, [eax + ecx + field_d5]              # 0046b06c
    push edx                                     # 0046b073
    mov eax, dword ptr [0x5cf665]                # 0046b074
    push eax                                     # 0046b079
    mov ecx, dword ptr [0x5d15e3]                # 0046b07a
    push ecx                                     # 0046b080
    mov ecx, 0x5cf659                            # 0046b081
    call FUN_004c5377                            # 0046b086
L_0046b08b:
    # block 0x0046b08b: entered by jmp at 0x0046b037, 6 instruction(s), ends with jne to 0x0046b0f2 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0046b08b
    fld dword ptr [4*edx + 0x5919dc]             # 0046b08f
    fcomp qword ptr [0x52d280]                   # 0046b096
    fnstsw ax                                    # 0046b09c
    test ah, 0x1                                 # 0046b09e
    jne.d8 L_0046b0f2                            # 0046b0a1
    # block 0x0046b0a3: entered by fall-through of jne at 0x0046b0a1, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046b143
    push 0x54bb94                                # 0046b0a3
    movsx eax, word ptr [ebp - local_4]          # 0046b0a8
    imul eax, eax, 0xa0                          # 0046b0ac
    add eax, 0x616c7e                            # 0046b0b2
    push eax                                     # 0046b0b7
    movsx ecx, word ptr [0x616b30]               # 0046b0b8
    imul ecx, ecx, 0x8d                          # 0046b0bf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046b0c5
    add edx, 0x75                                # 0046b0cb
    push edx                                     # 0046b0ce
    mov eax, dword ptr [0x5cf665]                # 0046b0cf
    push eax                                     # 0046b0d4
    movsx ecx, word ptr [0x616b2e]               # 0046b0d5
    imul ecx, ecx, 0x4a                          # 0046b0dc
    mov edx, dword ptr [ecx + 0x5d1599]          # 0046b0df
    push edx                                     # 0046b0e5
    mov ecx, 0x5cf659                            # 0046b0e6
    call FUN_004c5377                            # 0046b0eb
    jmp.d8 L_0046b143                            # 0046b0f0
L_0046b0f2:
    # block 0x0046b0f2: entered by jne at 0x0046b0a1, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b143
    push 0x54bbac                                # 0046b0f2
    movsx eax, word ptr [ebp - local_4]          # 0046b0f7
    imul eax, eax, 0xa0                          # 0046b0fb
    add eax, 0x616c7e                            # 0046b101
    push eax                                     # 0046b106
    movsx ecx, word ptr [0x616b30]               # 0046b107
    imul ecx, ecx, 0x8d                          # 0046b10e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046b114
    movsx eax, word ptr [ebp - local_4]          # 0046b11a
    imul eax, eax, 0xa0                          # 0046b11e
    lea ecx, [edx + eax + field_e5]              # 0046b124
    push ecx                                     # 0046b12b
    mov edx, dword ptr [0x5cf665]                # 0046b12c
    push edx                                     # 0046b132
    mov eax, dword ptr [0x5d15e3]                # 0046b133
    push eax                                     # 0046b138
    mov ecx, 0x5cf659                            # 0046b139
    call FUN_004c5377                            # 0046b13e
L_0046b143:
    # block 0x0046b143: entered by jmp at 0x0046b0f0, 6 instruction(s), ends with jne to 0x0046b1ac (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046b143
    fld dword ptr [4*ecx + 0x5919dc]             # 0046b147
    fcomp qword ptr [0x52d278]                   # 0046b14e
    fnstsw ax                                    # 0046b154
    test ah, 0x1                                 # 0046b156
    jne.d8 L_0046b1ac                            # 0046b159
    # block 0x0046b15b: entered by fall-through of jne at 0x0046b159, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046b1ff
    push 0x54bbc0                                # 0046b15b
    movsx edx, word ptr [ebp - local_4]          # 0046b160
    imul edx, edx, 0xa0                          # 0046b164
    add edx, 0x616c8e                            # 0046b16a
    push edx                                     # 0046b170
    movsx eax, word ptr [0x616b30]               # 0046b171
    imul eax, eax, 0x8d                          # 0046b178
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046b17e
    add ecx, 0x75                                # 0046b184
    push ecx                                     # 0046b187
    mov edx, dword ptr [0x5cf665]                # 0046b188
    push edx                                     # 0046b18e
    movsx eax, word ptr [0x616b2e]               # 0046b18f
    imul eax, eax, 0x4a                          # 0046b196
    mov ecx, dword ptr [eax + 0x5d1599]          # 0046b199
    push ecx                                     # 0046b19f
    mov ecx, 0x5cf659                            # 0046b1a0
    call FUN_004c5377                            # 0046b1a5
    jmp.d8 L_0046b1ff                            # 0046b1aa
L_0046b1ac:
    # block 0x0046b1ac: entered by jne at 0x0046b159, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b1ff
    push 0x54bbd8                                # 0046b1ac
    movsx edx, word ptr [ebp - local_4]          # 0046b1b1
    imul edx, edx, 0xa0                          # 0046b1b5
    add edx, 0x616c8e                            # 0046b1bb
    push edx                                     # 0046b1c1
    movsx eax, word ptr [0x616b30]               # 0046b1c2
    imul eax, eax, 0x8d                          # 0046b1c9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046b1cf
    movsx edx, word ptr [ebp - local_4]          # 0046b1d5
    imul edx, edx, 0xa0                          # 0046b1d9
    lea eax, [ecx + edx + field_f5]              # 0046b1df
    push eax                                     # 0046b1e6
    mov ecx, dword ptr [0x5cf665]                # 0046b1e7
    push ecx                                     # 0046b1ed
    mov edx, dword ptr [0x5d15e3]                # 0046b1ee
    push edx                                     # 0046b1f4
    mov ecx, 0x5cf659                            # 0046b1f5
    call FUN_004c5377                            # 0046b1fa
L_0046b1ff:
    # block 0x0046b1ff: entered by jmp at 0x0046b1aa, 6 instruction(s), ends with jne to 0x0046b268 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0046b1ff
    fld dword ptr [4*eax + 0x5919dc]             # 0046b203
    fcomp qword ptr [0x52d270]                   # 0046b20a
    fnstsw ax                                    # 0046b210
    test ah, 0x1                                 # 0046b212
    jne.d8 L_0046b268                            # 0046b215
    # block 0x0046b217: entered by fall-through of jne at 0x0046b215, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046b2ba
    push 0x54bbec                                # 0046b217
    movsx ecx, word ptr [ebp - local_4]          # 0046b21c
    imul ecx, ecx, 0xa0                          # 0046b220
    add ecx, 0x616c9e                            # 0046b226
    push ecx                                     # 0046b22c
    movsx edx, word ptr [0x616b30]               # 0046b22d
    imul edx, edx, 0x8d                          # 0046b234
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046b23a
    add eax, 0x75                                # 0046b240
    push eax                                     # 0046b243
    mov ecx, dword ptr [0x5cf665]                # 0046b244
    push ecx                                     # 0046b24a
    movsx edx, word ptr [0x616b2e]               # 0046b24b
    imul edx, edx, 0x4a                          # 0046b252
    mov eax, dword ptr [edx + 0x5d1599]          # 0046b255
    push eax                                     # 0046b25b
    mov ecx, 0x5cf659                            # 0046b25c
    call FUN_004c5377                            # 0046b261
    jmp.d8 L_0046b2ba                            # 0046b266
L_0046b268:
    # block 0x0046b268: entered by jne at 0x0046b215, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b2ba
    push 0x54bc04                                # 0046b268
    movsx ecx, word ptr [ebp - local_4]          # 0046b26d
    imul ecx, ecx, 0xa0                          # 0046b271
    add ecx, 0x616c9e                            # 0046b277
    push ecx                                     # 0046b27d
    movsx edx, word ptr [0x616b30]               # 0046b27e
    imul edx, edx, 0x8d                          # 0046b285
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046b28b
    movsx ecx, word ptr [ebp - local_4]          # 0046b291
    imul ecx, ecx, 0xa0                          # 0046b295
    lea edx, [eax + ecx + field_105]             # 0046b29b
    push edx                                     # 0046b2a2
    mov eax, dword ptr [0x5cf665]                # 0046b2a3
    push eax                                     # 0046b2a8
    mov ecx, dword ptr [0x5d15e3]                # 0046b2a9
    push ecx                                     # 0046b2af
    mov ecx, 0x5cf659                            # 0046b2b0
    call FUN_004c5377                            # 0046b2b5
L_0046b2ba:
    # block 0x0046b2ba: entered by jmp at 0x0046b266, 6 instruction(s), ends with jne to 0x0046b321 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0046b2ba
    fld dword ptr [4*edx + 0x5919dc]             # 0046b2be
    fcomp qword ptr [0x52c598]                   # 0046b2c5
    fnstsw ax                                    # 0046b2cb
    test ah, 0x1                                 # 0046b2cd
    jne.d8 L_0046b321                            # 0046b2d0
    # block 0x0046b2d2: entered by fall-through of jne at 0x0046b2d0, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0046b372
    push 0x54bc18                                # 0046b2d2
    movsx eax, word ptr [ebp - local_4]          # 0046b2d7
    imul eax, eax, 0xa0                          # 0046b2db
    add eax, 0x616cae                            # 0046b2e1
    push eax                                     # 0046b2e6
    movsx ecx, word ptr [0x616b30]               # 0046b2e7
    imul ecx, ecx, 0x8d                          # 0046b2ee
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046b2f4
    add edx, 0x75                                # 0046b2fa
    push edx                                     # 0046b2fd
    mov eax, dword ptr [0x5cf665]                # 0046b2fe
    push eax                                     # 0046b303
    movsx ecx, word ptr [0x616b2e]               # 0046b304
    imul ecx, ecx, 0x4a                          # 0046b30b
    mov edx, dword ptr [ecx + 0x5d1599]          # 0046b30e
    push edx                                     # 0046b314
    mov ecx, 0x5cf659                            # 0046b315
    call FUN_004c5377                            # 0046b31a
    jmp.d8 L_0046b372                            # 0046b31f
L_0046b321:
    # block 0x0046b321: entered by jne at 0x0046b2d0, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b372
    push 0x54bc30                                # 0046b321
    movsx eax, word ptr [ebp - local_4]          # 0046b326
    imul eax, eax, 0xa0                          # 0046b32a
    add eax, 0x616cae                            # 0046b330
    push eax                                     # 0046b335
    movsx ecx, word ptr [0x616b30]               # 0046b336
    imul ecx, ecx, 0x8d                          # 0046b33d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046b343
    movsx eax, word ptr [ebp - local_4]          # 0046b349
    imul eax, eax, 0xa0                          # 0046b34d
    lea ecx, [edx + eax + field_115]             # 0046b353
    push ecx                                     # 0046b35a
    mov edx, dword ptr [0x5cf665]                # 0046b35b
    push edx                                     # 0046b361
    mov eax, dword ptr [0x5d15e3]                # 0046b362
    push eax                                     # 0046b367
    mov ecx, 0x5cf659                            # 0046b368
    call FUN_004c5377                            # 0046b36d
L_0046b372:
    # block 0x0046b372: entered by jmp at 0x0046b31f, 3 instruction(s), ends with je to 0x0046b3c7 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046b372
    cmp dword ptr [4*ecx + 0x616b92], 0x0        # 0046b376
    je.d8 L_0046b3c7                             # 0046b37e
    # block 0x0046b380: entered by fall-through of je at 0x0046b37e, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x0046b3c7
    push 0x54bc44                                # 0046b380
    movsx edx, word ptr [ebp - local_4]          # 0046b385
    shl edx, 0x4                                 # 0046b389
    add edx, 0x616baa                            # 0046b38c
    push edx                                     # 0046b392
    movsx eax, word ptr [ebp - local_4]          # 0046b393
    shl eax, 0x4                                 # 0046b397
    add eax, 0x616b32                            # 0046b39a
    push eax                                     # 0046b39f
    mov ecx, dword ptr [0x5cf665]                # 0046b3a0
    push ecx                                     # 0046b3a6
    mov edx, dword ptr [0x5d15e3]                # 0046b3a7
    push edx                                     # 0046b3ad
    mov ecx, 0x5cf659                            # 0046b3ae
    call FUN_004c5377                            # 0046b3b3
    movsx eax, word ptr [ebp - local_4]          # 0046b3b8
    mov dword ptr [4*eax + 0x616b92], 0x0        # 0046b3bc
L_0046b3c7:
    # block 0x0046b3c7: entered by je at 0x0046b37e, 37 instruction(s), calls FUN_004c5377, ends with backward jump to 0x0046ac14
    movsx ecx, word ptr [ebp - local_4]          # 0046b3c7
    shl ecx, 0x4                                 # 0046b3cb
    mov edx, dword ptr [ecx + 0x616ad2]          # 0046b3ce
    add edx, dword ptr [0x58318a]                # 0046b3d4
    mov dword ptr [ebp - local_10], edx          # 0046b3da
    movsx eax, word ptr [ebp - local_4]          # 0046b3dd
    shl eax, 0x4                                 # 0046b3e1
    mov ecx, dword ptr [eax + 0x616ada]          # 0046b3e4
    add ecx, dword ptr [0x58318a]                # 0046b3ea
    mov dword ptr [ebp - local_8], ecx           # 0046b3f0
    movsx edx, word ptr [ebp - local_4]          # 0046b3f3
    shl edx, 0x4                                 # 0046b3f7
    mov eax, dword ptr [edx + 0x616ace]          # 0046b3fa
    add eax, dword ptr [0x583186]                # 0046b400
    mov dword ptr [ebp - local_14], eax          # 0046b406
    movsx ecx, word ptr [ebp - local_4]          # 0046b409
    shl ecx, 0x4                                 # 0046b40d
    mov edx, dword ptr [ecx + 0x616ad6]          # 0046b410
    add edx, dword ptr [0x583186]                # 0046b416
    mov dword ptr [ebp - local_c], edx           # 0046b41c
    push 0x54bc60                                # 0046b41f
    lea eax, [ebp - local_14]                    # 0046b424
    push eax                                     # 0046b427
    movsx ecx, word ptr [0x616b30]               # 0046b428
    imul ecx, ecx, 0x8d                          # 0046b42f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046b435
    add edx, 0x41                                # 0046b43b
    push edx                                     # 0046b43e
    mov eax, dword ptr [0x5cf665]                # 0046b43f
    push eax                                     # 0046b444
    movsx ecx, word ptr [0x616b2e]               # 0046b445
    imul ecx, ecx, 0x4a                          # 0046b44c
    mov edx, dword ptr [ecx + 0x5d1599]          # 0046b44f
    push edx                                     # 0046b455
    mov ecx, 0x5cf659                            # 0046b456
    call FUN_004c5377                            # 0046b45b
    jmp.d32 L_0046ac14                           # 0046b460
L_0046b465:
    # block 0x0046b465: entered by jge at 0x0046ac27, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046b465
    pop ebp                                      # 0046b467
    ret                                          # 0046b468

# --- data items (not part of the function) -------------------------
.org 0x0046b469 - 0x401000
PAD_0046b469:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

