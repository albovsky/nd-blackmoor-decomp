# FUN_0047bb56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047bb56
# extent:       0x0047bb56-0x0047c049 (1267 code bytes)
# span:         0x0047bb56-0x0047c049 (code 1267, tables 0, padding 0)
# sha256:       c26588c3a2ebd95a356d4793fab16636ab9f5b6693b2c8fc016e5de047ced077
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047bb56
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_8, field_c, field_14, field_18, field_34, field_280, field_284, field_288, field_298, field_2a0, field_2a4, field_2ac and 2 more; [ecx + n] field_c, field_14, field_1c, field_280, field_284, field_28c, field_294, field_2a0, field_2a4, field_2ac, field_2b4, field_33d and 2 more; [edx + n] field_4, field_c, field_14, field_18, field_20, field_30, field_38, field_280, field_284, field_288, field_290, field_298 and 8 more; [esi + n] field_14
# callees:      calls FUN_0051dc6c, FUN_0047d1c3, FUN_0050ce04, FUN_0047c049, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 334 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_294, 0x294  # offset +0x294
.equ field_298, 0x298  # offset +0x298
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_335, 0x335  # offset +0x335
.equ field_339, 0x339  # offset +0x339
.equ field_33d, 0x33d  # offset +0x33d
.equ field_346, 0x346  # offset +0x346
.equ field_347, 0x347  # offset +0x347
.equ field_353, 0x353  # offset +0x353
.equ field_357, 0x357  # offset +0x357

# --- external targets -----------------------------------------------
.set FUN_0047c049, .text + (0x0047c049 - 0x401000)
.set FUN_0047d1c3, .text + (0x0047d1c3 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047bb56 - 0x401000
.globl FUN_0047bb56
FUN_0047bb56:
    # block 0x0047bb56: entry, 8 instruction(s), ends with je to 0x0047bb88 (forward)
    push ebp                                     # 0047bb56
    {load} mov ebp, esp                          # 0047bb57
    sub esp, 0x48                                # 0047bb59
    push esi                                     # 0047bb5c
    mov dword ptr [ebp - local_24], ecx          # 0047bb5d
    mov eax, dword ptr [ebp - local_24]          # 0047bb60
    cmp dword ptr [eax + field_14], 0x0          # 0047bb63
    je.d8 L_0047bb88                             # 0047bb67
    # block 0x0047bb69: entered by fall-through of je at 0x0047bb67, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047bb88
    mov ecx, dword ptr [ebp - local_24]          # 0047bb69
    mov edx, dword ptr [ecx + field_14]          # 0047bb6c
    mov dword ptr [ebp - local_1c], edx          # 0047bb6f
    mov eax, dword ptr [ebp - local_1c]          # 0047bb72
    push eax                                     # 0047bb75
    call FUN_0051dc6c                            # 0047bb76
    add esp, 0x4                                 # 0047bb7b
    mov ecx, dword ptr [ebp - local_24]          # 0047bb7e
    mov dword ptr [ecx + field_14], 0x0          # 0047bb81
L_0047bb88:
    # block 0x0047bb88: entered by je at 0x0047bb67, 3 instruction(s), ends with je to 0x0047bbb0 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bb88
    cmp dword ptr [edx + field_18], 0x0          # 0047bb8b
    je.d8 L_0047bbb0                             # 0047bb8f
    # block 0x0047bb91: entered by fall-through of je at 0x0047bb8f, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047bbb0
    mov eax, dword ptr [ebp - local_24]          # 0047bb91
    mov ecx, dword ptr [eax + field_18]          # 0047bb94
    mov dword ptr [ebp - local_20], ecx          # 0047bb97
    mov edx, dword ptr [ebp - local_20]          # 0047bb9a
    push edx                                     # 0047bb9d
    call FUN_0051dc6c                            # 0047bb9e
    add esp, 0x4                                 # 0047bba3
    mov eax, dword ptr [ebp - local_24]          # 0047bba6
    mov dword ptr [eax + field_18], 0x0          # 0047bba9
L_0047bbb0:
    # block 0x0047bbb0: entered by je at 0x0047bb8f, 16 instruction(s), calls FUN_0047d1c3, ends with forward jump to 0x0047bc04
    mov ecx, dword ptr [ebp - local_24]          # 0047bbb0
    mov dword ptr [ecx + field_1c], 0x0          # 0047bbb3
    mov edx, dword ptr [ebp - local_24]          # 0047bbba
    mov dword ptr [edx + field_20], 0x0          # 0047bbbd
    mov eax, dword ptr [ebp - local_24]          # 0047bbc4
    mov ecx, dword ptr [eax + field_284]         # 0047bbc7
    imul ecx, ecx, 0xc                           # 0047bbcd
    push ecx                                     # 0047bbd0
    mov edx, dword ptr [ebp - local_24]          # 0047bbd1
    add edx, 0x14                                # 0047bbd4
    push edx                                     # 0047bbd7
    mov ecx, dword ptr [ebp - local_24]          # 0047bbd8
    call FUN_0047d1c3                            # 0047bbdb
    mov eax, dword ptr [ebp - local_24]          # 0047bbe0
    mov dword ptr [eax + field_2ac], 0x0         # 0047bbe3
    jmp.d8 L_0047bc04                            # 0047bbed
L_0047bbef:
    # block 0x0047bbef: entered by jmp at 0x0047bc65, 5 instruction(s), falls into the block at 0x0047bc04
    mov ecx, dword ptr [ebp - local_24]          # 0047bbef
    mov edx, dword ptr [ecx + field_2ac]         # 0047bbf2
    add edx, 0x1                                 # 0047bbf8
    mov eax, dword ptr [ebp - local_24]          # 0047bbfb
    mov dword ptr [eax + field_2ac], edx         # 0047bbfe
L_0047bc04:
    # block 0x0047bc04: entered by jmp at 0x0047bbed, 5 instruction(s), ends with jge to 0x0047bc67 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047bc04
    mov edx, dword ptr [ebp - local_24]          # 0047bc07
    mov eax, dword ptr [ecx + field_2ac]         # 0047bc0a
    cmp eax, dword ptr [edx + field_284]         # 0047bc10
    jge.d8 L_0047bc67                            # 0047bc16
    # block 0x0047bc18: entered by fall-through of jge at 0x0047bc16, 19 instruction(s), ends with backward jump to 0x0047bbef
    mov ecx, dword ptr [ebp - local_24]          # 0047bc18
    mov edx, dword ptr [ecx + field_2ac]         # 0047bc1b
    imul edx, edx, 0xc                           # 0047bc21
    mov eax, dword ptr [ebp - local_24]          # 0047bc24
    mov ecx, dword ptr [eax + field_14]          # 0047bc27
    mov dword ptr [ecx + edx], 0xffffffff        # 0047bc2a
    mov edx, dword ptr [ebp - local_24]          # 0047bc31
    mov eax, dword ptr [edx + field_2ac]         # 0047bc34
    imul eax, eax, 0xc                           # 0047bc3a
    mov ecx, dword ptr [ebp - local_24]          # 0047bc3d
    mov edx, dword ptr [ecx + field_14]          # 0047bc40
    mov dword ptr [edx + eax + field_4], 0x0     # 0047bc43
    mov eax, dword ptr [ebp - local_24]          # 0047bc4b
    mov ecx, dword ptr [eax + field_2ac]         # 0047bc4e
    imul ecx, ecx, 0xc                           # 0047bc54
    mov edx, dword ptr [ebp - local_24]          # 0047bc57
    mov eax, dword ptr [edx + field_14]          # 0047bc5a
    mov dword ptr [eax + ecx + field_8], 0x0     # 0047bc5d
    jmp.d8 L_0047bbef                            # 0047bc65
L_0047bc67:
    # block 0x0047bc67: entered by jge at 0x0047bc16, 24 instruction(s), calls FUN_0050ce04, ends with jle to 0x0047bcd8 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047bc67
    mov edx, dword ptr [ecx + field_c]           # 0047bc6a
    mov eax, dword ptr [ebp - local_24]          # 0047bc6d
    mov ecx, dword ptr [eax + field_c]           # 0047bc70
    mov edx, dword ptr [edx + field_353]         # 0047bc73
    imul edx, dword ptr [ecx + field_357]        # 0047bc79
    mov eax, dword ptr [ebp - local_24]          # 0047bc80
    mov dword ptr [eax + field_288], edx         # 0047bc83
    mov ecx, dword ptr [ebp - local_24]          # 0047bc89
    mov edx, dword ptr [ecx + field_c]           # 0047bc8c
    fild dword ptr [edx + field_335]             # 0047bc8f
    fstp dword ptr [ebp - local_28]              # 0047bc95
    fld dword ptr [ebp - local_28]               # 0047bc98
    fdiv dword ptr [0x52cbec]                    # 0047bc9b
    mov eax, dword ptr [ebp - local_24]          # 0047bca1
    fild dword ptr [eax + field_288]             # 0047bca4
    fstp dword ptr [ebp - local_2c]              # 0047bcaa
    fmul dword ptr [ebp - local_2c]              # 0047bcad
    call FUN_0050ce04                            # 0047bcb0
    mov ecx, dword ptr [ebp - local_24]          # 0047bcb5
    mov dword ptr [ecx + field_2a4], eax         # 0047bcb8
    mov edx, dword ptr [ebp - local_24]          # 0047bcbe
    cmp dword ptr [edx + field_2a4], 0x4         # 0047bcc1
    jle.d8 L_0047bcd8                            # 0047bcc8
    # block 0x0047bcca: entered by fall-through of jle at 0x0047bcc8, 4 instruction(s), ends with forward jump to 0x0047bcdf
    mov eax, dword ptr [ebp - local_24]          # 0047bcca
    mov ecx, dword ptr [eax + field_2a4]         # 0047bccd
    mov dword ptr [ebp - local_30], ecx          # 0047bcd3
    jmp.d8 L_0047bcdf                            # 0047bcd6
L_0047bcd8:
    # block 0x0047bcd8: entered by jle at 0x0047bcc8, 1 instruction(s), falls into the block at 0x0047bcdf
    mov dword ptr [ebp - local_30], 0x4          # 0047bcd8
L_0047bcdf:
    # block 0x0047bcdf: entered by jmp at 0x0047bcd6, 8 instruction(s), ends with jge to 0x0047bd0d (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bcdf
    mov eax, dword ptr [ebp - local_30]          # 0047bce2
    mov dword ptr [edx + field_2a4], eax         # 0047bce5
    mov ecx, dword ptr [ebp - local_24]          # 0047bceb
    mov edx, dword ptr [ebp - local_24]          # 0047bcee
    mov eax, dword ptr [ecx + field_2a4]         # 0047bcf1
    cmp eax, dword ptr [edx + field_288]         # 0047bcf7
    jge.d8 L_0047bd0d                            # 0047bcfd
    # block 0x0047bcff: entered by fall-through of jge at 0x0047bcfd, 4 instruction(s), ends with forward jump to 0x0047bd19
    mov ecx, dword ptr [ebp - local_24]          # 0047bcff
    mov edx, dword ptr [ecx + field_2a4]         # 0047bd02
    mov dword ptr [ebp - local_34], edx          # 0047bd08
    jmp.d8 L_0047bd19                            # 0047bd0b
L_0047bd0d:
    # block 0x0047bd0d: entered by jge at 0x0047bcfd, 3 instruction(s), falls into the block at 0x0047bd19
    mov eax, dword ptr [ebp - local_24]          # 0047bd0d
    mov ecx, dword ptr [eax + field_288]         # 0047bd10
    mov dword ptr [ebp - local_34], ecx          # 0047bd16
L_0047bd19:
    # block 0x0047bd19: entered by jmp at 0x0047bd0b, 16 instruction(s), calls FUN_0047d1c3, ends with jne to 0x0047bd67 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bd19
    mov eax, dword ptr [ebp - local_34]          # 0047bd1c
    mov dword ptr [edx + field_2a4], eax         # 0047bd1f
    mov ecx, dword ptr [ebp - local_24]          # 0047bd25
    mov edx, dword ptr [ecx + field_2a4]         # 0047bd28
    shl edx, 0x2                                 # 0047bd2e
    push edx                                     # 0047bd31
    mov eax, dword ptr [ebp - local_24]          # 0047bd32
    add eax, 0x18                                # 0047bd35
    push eax                                     # 0047bd38
    mov ecx, dword ptr [ebp - local_24]          # 0047bd39
    call FUN_0047d1c3                            # 0047bd3c
    mov ecx, dword ptr [ebp - local_24]          # 0047bd41
    mov edx, dword ptr [ecx + field_c]           # 0047bd44
    cmp dword ptr [edx + field_339], -0x1        # 0047bd47
    jne.d8 L_0047bd67                            # 0047bd4e
    # block 0x0047bd50: entered by fall-through of jne at 0x0047bd4e, 6 instruction(s), ends with forward jump to 0x0047bd9c
    mov eax, dword ptr [ebp - local_24]          # 0047bd50
    mov ecx, dword ptr [eax + field_c]           # 0047bd53
    mov edx, dword ptr [ebp - local_24]          # 0047bd56
    mov eax, dword ptr [ecx + field_33d]         # 0047bd59
    mov dword ptr [edx + field_2a0], eax         # 0047bd5f
    jmp.d8 L_0047bd9c                            # 0047bd65
L_0047bd67:
    # block 0x0047bd67: entered by jne at 0x0047bd4e, 13 instruction(s), calls FUN_0050ce04, falls into the block at 0x0047bd9c
    mov ecx, dword ptr [ebp - local_24]          # 0047bd67
    mov edx, dword ptr [ecx + field_c]           # 0047bd6a
    fild dword ptr [edx + field_339]             # 0047bd6d
    fstp dword ptr [ebp - local_38]              # 0047bd73
    fld dword ptr [ebp - local_38]               # 0047bd76
    fdiv dword ptr [0x52cbec]                    # 0047bd79
    mov eax, dword ptr [ebp - local_24]          # 0047bd7f
    fild dword ptr [eax + field_298]             # 0047bd82
    fstp dword ptr [ebp - local_3c]              # 0047bd88
    fmul dword ptr [ebp - local_3c]              # 0047bd8b
    call FUN_0050ce04                            # 0047bd8e
    mov ecx, dword ptr [ebp - local_24]          # 0047bd93
    mov dword ptr [ecx + field_2a0], eax         # 0047bd96
L_0047bd9c:
    # block 0x0047bd9c: entered by jmp at 0x0047bd65, 3 instruction(s), ends with jle to 0x0047bdb6 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bd9c
    cmp dword ptr [edx + field_2a0], 0x2         # 0047bd9f
    jle.d8 L_0047bdb6                            # 0047bda6
    # block 0x0047bda8: entered by fall-through of jle at 0x0047bda6, 4 instruction(s), ends with forward jump to 0x0047bdbd
    mov eax, dword ptr [ebp - local_24]          # 0047bda8
    mov ecx, dword ptr [eax + field_2a0]         # 0047bdab
    mov dword ptr [ebp - local_40], ecx          # 0047bdb1
    jmp.d8 L_0047bdbd                            # 0047bdb4
L_0047bdb6:
    # block 0x0047bdb6: entered by jle at 0x0047bda6, 1 instruction(s), falls into the block at 0x0047bdbd
    mov dword ptr [ebp - local_40], 0x2          # 0047bdb6
L_0047bdbd:
    # block 0x0047bdbd: entered by jmp at 0x0047bdb4, 8 instruction(s), ends with jge to 0x0047bdeb (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bdbd
    mov eax, dword ptr [ebp - local_40]          # 0047bdc0
    mov dword ptr [edx + field_2a0], eax         # 0047bdc3
    mov ecx, dword ptr [ebp - local_24]          # 0047bdc9
    mov edx, dword ptr [ebp - local_24]          # 0047bdcc
    mov eax, dword ptr [ecx + field_2a0]         # 0047bdcf
    cmp eax, dword ptr [edx + field_298]         # 0047bdd5
    jge.d8 L_0047bdeb                            # 0047bddb
    # block 0x0047bddd: entered by fall-through of jge at 0x0047bddb, 4 instruction(s), ends with forward jump to 0x0047bdf7
    mov ecx, dword ptr [ebp - local_24]          # 0047bddd
    mov edx, dword ptr [ecx + field_2a0]         # 0047bde0
    mov dword ptr [ebp - local_44], edx          # 0047bde6
    jmp.d8 L_0047bdf7                            # 0047bde9
L_0047bdeb:
    # block 0x0047bdeb: entered by jge at 0x0047bddb, 3 instruction(s), falls into the block at 0x0047bdf7
    mov eax, dword ptr [ebp - local_24]          # 0047bdeb
    mov ecx, dword ptr [eax + field_298]         # 0047bdee
    mov dword ptr [ebp - local_44], ecx          # 0047bdf4
L_0047bdf7:
    # block 0x0047bdf7: entered by jmp at 0x0047bde9, 11 instruction(s), ends with jne to 0x0047be39 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047bdf7
    mov eax, dword ptr [ebp - local_44]          # 0047bdfa
    mov dword ptr [edx + field_2a0], eax         # 0047bdfd
    mov ecx, dword ptr [ebp - local_24]          # 0047be03
    mov dword ptr [ecx + field_294], 0x0         # 0047be06
    mov edx, dword ptr [ebp - local_24]          # 0047be10
    mov dword ptr [edx + field_290], 0x0         # 0047be13
    mov eax, dword ptr [ebp - local_24]          # 0047be1d
    mov ecx, dword ptr [eax + field_c]           # 0047be20
    cmp dword ptr [ecx + field_347], 0x1         # 0047be23
    jne.d8 L_0047be39                            # 0047be2a
    # block 0x0047be2c: entered by fall-through of jne at 0x0047be2a, 3 instruction(s), falls into the block at 0x0047be39
    mov edx, dword ptr [ebp - local_24]          # 0047be2c
    mov eax, dword ptr [edx + field_c]           # 0047be2f
    mov byte ptr [eax + field_346], 0x0          # 0047be32
L_0047be39:
    # block 0x0047be39: entered by jne at 0x0047be2a, 6 instruction(s), ends with je to 0x0047be53 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047be39
    mov edx, dword ptr [ecx + field_c]           # 0047be3c
    mov al, byte ptr [edx + field_346]           # 0047be3f
    mov byte ptr [ebp - local_48], al            # 0047be45
    cmp byte ptr [ebp - local_48], 0x0           # 0047be48
    je.d8 L_0047be53                             # 0047be4c
    # block 0x0047be4e: entered by fall-through of je at 0x0047be4c, 1 instruction(s), ends with forward jump to 0x0047bf6f
    jmp.d32 L_0047bf6f                           # 0047be4e
L_0047be53:
    # block 0x0047be53: entered by je at 0x0047be4c, 2 instruction(s), ends with forward jump to 0x0047be65
    mov dword ptr [ebp - local_10], 0x0          # 0047be53
    jmp.d8 L_0047be65                            # 0047be5a
L_0047be5c:
    # block 0x0047be5c: entered by jmp at 0x0047bf65, 3 instruction(s), falls into the block at 0x0047be65
    mov ecx, dword ptr [ebp - local_10]          # 0047be5c
    add ecx, 0x1                                 # 0047be5f
    mov dword ptr [ebp - local_10], ecx          # 0047be62
L_0047be65:
    # block 0x0047be65: entered by jmp at 0x0047be5a, 5 instruction(s), ends with jge to 0x0047bf6a (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047be65
    mov eax, dword ptr [edx + field_c]           # 0047be68
    mov ecx, dword ptr [ebp - local_10]          # 0047be6b
    cmp ecx, dword ptr [eax + field_347]         # 0047be6e
    jge.d32 L_0047bf6a                           # 0047be74
    # block 0x0047be7a: entered by fall-through of jge at 0x0047be74, 2 instruction(s), ends with forward jump to 0x0047be8c
    mov dword ptr [ebp - local_c], 0x0           # 0047be7a
    jmp.d8 L_0047be8c                            # 0047be81
L_0047be83:
    # block 0x0047be83: entered by jmp at 0x0047becf; jmp at 0x0047bf60, 3 instruction(s), falls into the block at 0x0047be8c
    mov edx, dword ptr [ebp - local_c]           # 0047be83
    add edx, 0x1                                 # 0047be86
    mov dword ptr [ebp - local_c], edx           # 0047be89
L_0047be8c:
    # block 0x0047be8c: entered by jmp at 0x0047be81, 4 instruction(s), ends with jge to 0x0047bf65 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0047be8c
    mov ecx, dword ptr [ebp - local_c]           # 0047be8f
    cmp ecx, dword ptr [eax + field_280]         # 0047be92
    jge.d32 L_0047bf65                           # 0047be98
    # block 0x0047be9e: entered by fall-through of jge at 0x0047be98, 13 instruction(s), ends with je to 0x0047bed1 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047be9e
    mov eax, dword ptr [ebp - local_10]          # 0047bea1
    imul eax, dword ptr [edx + field_280]        # 0047bea4
    add eax, dword ptr [ebp - local_c]           # 0047beab
    mov ecx, dword ptr [ebp - local_24]          # 0047beae
    mov dword ptr [ecx + field_2b4], eax         # 0047beb1
    mov edx, dword ptr [ebp - local_24]          # 0047beb7
    mov eax, dword ptr [edx + field_2b4]         # 0047beba
    imul eax, eax, 0xc                           # 0047bec0
    mov ecx, dword ptr [ebp - local_24]          # 0047bec3
    mov edx, dword ptr [ecx + field_14]          # 0047bec6
    cmp dword ptr [edx + eax], -0x1              # 0047bec9
    je.d8 L_0047bed1                             # 0047becd
    # block 0x0047becf: entered by fall-through of je at 0x0047becd, 1 instruction(s), ends with backward jump to 0x0047be83
    jmp.d8 L_0047be83                            # 0047becf
L_0047bed1:
    # block 0x0047bed1: entered by je at 0x0047becd, 13 instruction(s), calls FUN_0047c049, falls into the block at 0x0047bf05
    mov ecx, dword ptr [ebp - local_24]          # 0047bed1
    call FUN_0047c049                            # 0047bed4
    mov ecx, dword ptr [ebp - local_24]          # 0047bed9
    mov edx, dword ptr [ecx + field_2b4]         # 0047bedc
    imul edx, edx, 0xc                           # 0047bee2
    mov ecx, dword ptr [ebp - local_24]          # 0047bee5
    mov ecx, dword ptr [ecx + field_14]          # 0047bee8
    mov dword ptr [ecx + edx], eax               # 0047beeb
    mov dword ptr [ebp - local_8], 0x0           # 0047beee
    mov edx, dword ptr [ebp - local_24]          # 0047bef5
    mov eax, dword ptr [ebp - local_10]          # 0047bef8
    imul eax, dword ptr [edx + field_280]        # 0047befb
    mov dword ptr [ebp - local_4], eax           # 0047bf02
L_0047bf05:
    # block 0x0047bf05: entered by je at 0x0047bf37, 12 instruction(s), calls FUN_0050cd50, ends with jne to 0x0047bf33 (forward)
    call FUN_0050cd50                            # 0047bf05
    mov ecx, dword ptr [ebp - local_24]          # 0047bf0a
    cdq                                          # 0047bf0d
    idiv dword ptr [ecx + field_280]             # 0047bf0e
    mov dword ptr [ebp - local_18], edx          # 0047bf14
    mov edx, dword ptr [ebp - local_4]           # 0047bf17
    add edx, dword ptr [ebp - local_18]          # 0047bf1a
    imul edx, edx, 0xc                           # 0047bf1d
    mov eax, dword ptr [ebp - local_24]          # 0047bf20
    mov ecx, dword ptr [eax + field_14]          # 0047bf23
    cmp dword ptr [ecx + edx], -0x1              # 0047bf26
    jne.d8 L_0047bf33                            # 0047bf2a
    # block 0x0047bf2c: entered by fall-through of jne at 0x0047bf2a, 1 instruction(s), falls into the block at 0x0047bf33
    mov dword ptr [ebp - local_8], 0x1           # 0047bf2c
L_0047bf33:
    # block 0x0047bf33: entered by jne at 0x0047bf2a, 2 instruction(s), ends with je to 0x0047bf05 (backward)
    cmp dword ptr [ebp - local_8], 0x0           # 0047bf33
    je.d8 L_0047bf05                             # 0047bf37
    # block 0x0047bf39: entered by fall-through of je at 0x0047bf37, 13 instruction(s), ends with backward jump to 0x0047be83
    mov edx, dword ptr [ebp - local_24]          # 0047bf39
    mov eax, dword ptr [edx + field_2b4]         # 0047bf3c
    imul eax, eax, 0xc                           # 0047bf42
    mov ecx, dword ptr [ebp - local_24]          # 0047bf45
    mov edx, dword ptr [ecx + field_14]          # 0047bf48
    mov ecx, dword ptr [ebp - local_4]           # 0047bf4b
    add ecx, dword ptr [ebp - local_18]          # 0047bf4e
    imul ecx, ecx, 0xc                           # 0047bf51
    mov esi, dword ptr [ebp - local_24]          # 0047bf54
    mov esi, dword ptr [esi + field_14]          # 0047bf57
    mov edx, dword ptr [edx + eax]               # 0047bf5a
    mov dword ptr [esi + ecx], edx               # 0047bf5d
    jmp.d32 L_0047be83                           # 0047bf60
L_0047bf65:
    # block 0x0047bf65: entered by jge at 0x0047be98, 1 instruction(s), ends with backward jump to 0x0047be5c
    jmp.d32 L_0047be5c                           # 0047bf65
L_0047bf6a:
    # block 0x0047bf6a: entered by jge at 0x0047be74, 1 instruction(s), ends with forward jump to 0x0047c019
    jmp.d32 L_0047c019                           # 0047bf6a
L_0047bf6f:
    # block 0x0047bf6f: entered by jmp at 0x0047be4e, 2 instruction(s), ends with forward jump to 0x0047bf81
    mov dword ptr [ebp - local_14], 0x0          # 0047bf6f
    jmp.d8 L_0047bf81                            # 0047bf76
L_0047bf78:
    # block 0x0047bf78: entered by jmp at 0x0047bfa5; jmp at 0x0047c014, 3 instruction(s), falls into the block at 0x0047bf81
    mov eax, dword ptr [ebp - local_14]          # 0047bf78
    add eax, 0x1                                 # 0047bf7b
    mov dword ptr [ebp - local_14], eax          # 0047bf7e
L_0047bf81:
    # block 0x0047bf81: entered by jmp at 0x0047bf76, 4 instruction(s), ends with jge to 0x0047c019 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047bf81
    mov edx, dword ptr [ebp - local_14]          # 0047bf84
    cmp edx, dword ptr [ecx + field_284]         # 0047bf87
    jge.d32 L_0047c019                           # 0047bf8d
    # block 0x0047bf93: entered by fall-through of jge at 0x0047bf8d, 6 instruction(s), ends with je to 0x0047bfa7 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0047bf93
    imul eax, eax, 0xc                           # 0047bf96
    mov ecx, dword ptr [ebp - local_24]          # 0047bf99
    mov edx, dword ptr [ecx + field_14]          # 0047bf9c
    cmp dword ptr [edx + eax], -0x1              # 0047bf9f
    je.d8 L_0047bfa7                             # 0047bfa3
    # block 0x0047bfa5: entered by fall-through of je at 0x0047bfa3, 1 instruction(s), ends with backward jump to 0x0047bf78
    jmp.d8 L_0047bf78                            # 0047bfa5
L_0047bfa7:
    # block 0x0047bfa7: entered by je at 0x0047bfa3, 8 instruction(s), calls FUN_0047c049, falls into the block at 0x0047bfc5
    mov ecx, dword ptr [ebp - local_24]          # 0047bfa7
    call FUN_0047c049                            # 0047bfaa
    mov ecx, dword ptr [ebp - local_14]          # 0047bfaf
    imul ecx, ecx, 0xc                           # 0047bfb2
    mov edx, dword ptr [ebp - local_24]          # 0047bfb5
    mov edx, dword ptr [edx + field_14]          # 0047bfb8
    mov dword ptr [edx + ecx], eax               # 0047bfbb
    mov dword ptr [ebp - local_8], 0x0           # 0047bfbe
L_0047bfc5:
    # block 0x0047bfc5: entered by je at 0x0047bff4, 11 instruction(s), calls FUN_0050cd50, ends with jne to 0x0047bff0 (forward)
    call FUN_0050cd50                            # 0047bfc5
    mov ecx, dword ptr [ebp - local_24]          # 0047bfca
    cdq                                          # 0047bfcd
    idiv dword ptr [ecx + field_284]             # 0047bfce
    mov dword ptr [ebp - local_18], edx          # 0047bfd4
    mov edx, dword ptr [ebp - local_18]          # 0047bfd7
    imul edx, edx, 0xc                           # 0047bfda
    mov eax, dword ptr [ebp - local_24]          # 0047bfdd
    mov ecx, dword ptr [eax + field_14]          # 0047bfe0
    cmp dword ptr [ecx + edx], -0x1              # 0047bfe3
    jne.d8 L_0047bff0                            # 0047bfe7
    # block 0x0047bfe9: entered by fall-through of jne at 0x0047bfe7, 1 instruction(s), falls into the block at 0x0047bff0
    mov dword ptr [ebp - local_8], 0x1           # 0047bfe9
L_0047bff0:
    # block 0x0047bff0: entered by jne at 0x0047bfe7, 2 instruction(s), ends with je to 0x0047bfc5 (backward)
    cmp dword ptr [ebp - local_8], 0x0           # 0047bff0
    je.d8 L_0047bfc5                             # 0047bff4
    # block 0x0047bff6: entered by fall-through of je at 0x0047bff4, 11 instruction(s), ends with backward jump to 0x0047bf78
    mov edx, dword ptr [ebp - local_14]          # 0047bff6
    imul edx, edx, 0xc                           # 0047bff9
    mov eax, dword ptr [ebp - local_24]          # 0047bffc
    mov ecx, dword ptr [eax + field_14]          # 0047bfff
    mov eax, dword ptr [ebp - local_18]          # 0047c002
    imul eax, eax, 0xc                           # 0047c005
    mov esi, dword ptr [ebp - local_24]          # 0047c008
    mov esi, dword ptr [esi + field_14]          # 0047c00b
    mov ecx, dword ptr [ecx + edx]               # 0047c00e
    mov dword ptr [esi + eax], ecx               # 0047c011
    jmp.d32 L_0047bf78                           # 0047c014
L_0047c019:
    # block 0x0047c019: entered by jmp at 0x0047bf6a; jge at 0x0047bf8d, 12 instruction(s), ends with ret
    mov edx, dword ptr [ebp - local_24]          # 0047c019
    mov dword ptr [edx + field_38], 0x0          # 0047c01c
    mov eax, dword ptr [ebp - local_24]          # 0047c023
    mov dword ptr [eax + field_34], 0x0          # 0047c026
    mov ecx, dword ptr [ebp - local_24]          # 0047c02d
    mov dword ptr [ecx + field_28c], 0x0         # 0047c030
    mov edx, dword ptr [ebp - local_24]          # 0047c03a
    mov dword ptr [edx + field_30], 0x1          # 0047c03d
    pop esi                                      # 0047c044
    {load} mov esp, ebp                          # 0047c045
    pop ebp                                      # 0047c047
    ret                                          # 0047c048

