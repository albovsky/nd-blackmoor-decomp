# FUN_0041fd08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041fd08
# extent:       0x0041fd08-0x0042028e (1414 code bytes)
# span:         0x0041fd08-0x0042028e (code 1414, tables 0, padding 0)
# sha256:       e481afb28154f6f93827ab22edf3b57637b80a7ab6e5fa575bc1638940cb1cf7
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         replace_response
# naming:       native port src/action_family_3f_runtime.c:replace_response (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Extracted from build_list case 1: drop the same-text entry, then append (30 limit). Static, so the original's other callers are not routed here. Text compare is convo3f_text_equal; no whole-function receipt, so tests-only.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_1b8, field_1c4, field_1cf, field_7d9, field_7fc, field_800, field_80a, field_80e, field_ea5, field_f21; [ecx + n] field_1ba, field_1be, field_1c8, field_1cc, field_7fe, field_802, field_810, field_ea5, field_f21; [edx + n] field_1bc, field_1c0, field_1ce, field_7d9, field_7fa, field_806, field_811, field_ea5, field_f21; [esi + n] field_7fa, field_7fc, field_7fe, field_800, field_802, field_806, field_80a, field_80e, field_810, field_811
# callees:      calls FUN_0051ea75, FUN_0050d550, FUN_0051eac4, FUN_0050ca3e, FUN_004264e8
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:copy_name_cstr (function ledger class native_tests_only; also replace_response; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 346 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1cf, 0x1cf  # offset +0x1cf
.equ field_7d9, 0x7d9  # offset +0x7d9
.equ field_7fa, 0x7fa  # offset +0x7fa
.equ field_7fc, 0x7fc  # offset +0x7fc
.equ field_7fe, 0x7fe  # offset +0x7fe
.equ field_800, 0x800  # offset +0x800
.equ field_802, 0x802  # offset +0x802
.equ field_806, 0x806  # offset +0x806
.equ field_80a, 0x80a  # offset +0x80a
.equ field_80e, 0x80e  # offset +0x80e
.equ field_810, 0x810  # offset +0x810
.equ field_811, 0x811  # offset +0x811
.equ field_ea5, 0xea5  # offset +0xea5
.equ field_f21, 0xf21  # offset +0xf21

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050d550, .text + (0x0050d550 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x0041fd08 - 0x401000
.globl FUN_0041fd08
FUN_0041fd08:
    # block 0x0041fd08: entry, 8 instruction(s), ends with forward jump to 0x0041fd27
    push ebp                                     # 0041fd08
    {load} mov ebp, esp                          # 0041fd09
    sub esp, 0x1c                                # 0041fd0b
    push esi                                     # 0041fd0e
    push edi                                     # 0041fd0f
    mov dword ptr [ebp - local_1c], ecx          # 0041fd10
    mov word ptr [ebp - local_4], 0x0            # 0041fd13
    jmp.d8 L_0041fd27                            # 0041fd19
L_0041fd1b:
    # block 0x0041fd1b: entered by jmp at 0x0042002e, 3 instruction(s), falls into the block at 0x0041fd27
    mov ax, word ptr [ebp - local_4]             # 0041fd1b
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041fd1f
    mov word ptr [ebp - local_4], ax             # 0041fd23
L_0041fd27:
    # block 0x0041fd27: entered by jmp at 0x0041fd19, 5 instruction(s), ends with jge to 0x00420033 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041fd27
    mov edx, dword ptr [ebp - local_1c]          # 0041fd2b
    movsx eax, word ptr [edx + field_f21]        # 0041fd2e
    {load} cmp ecx, eax                          # 0041fd35
    jge.d32 L_00420033                           # 0041fd37
    # block 0x0041fd3d: entered by fall-through of jge at 0x0041fd37, 16 instruction(s), calls FUN_0051ea75, FUN_0050d550, ends with jne to 0x00420019 (forward)
    push 0x190                                   # 0041fd3d
    movsx ecx, word ptr [ebp - local_4]          # 0041fd42
    mov edx, dword ptr [ebp - local_1c]          # 0041fd46
    lea ecx, [edx + 4*ecx + field_ea5]           # 0041fd49
    call FUN_0051ea75                            # 0041fd50
    mov dword ptr [ebp - local_14], eax          # 0041fd55
    push 0x190                                   # 0041fd58
    mov eax, dword ptr [ebp + arg_8]             # 0041fd5d
    add eax, 0x6                                 # 0041fd60
    push eax                                     # 0041fd63
    mov ecx, dword ptr [ebp - local_14]          # 0041fd64
    push ecx                                     # 0041fd67
    call FUN_0050d550                            # 0041fd68
    add esp, 0xc                                 # 0041fd6d
    test eax, eax                                # 0041fd70
    jne.d32 L_00420019                           # 0041fd72
    # block 0x0041fd78: entered by fall-through of jne at 0x0041fd72, 11 instruction(s), calls FUN_0051eac4, ends with forward jump to 0x0041fdba
    push -0x1                                    # 0041fd78
    movsx edx, word ptr [ebp - local_4]          # 0041fd7a
    mov eax, dword ptr [ebp - local_1c]          # 0041fd7e
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fd81
    call FUN_0051eac4                            # 0041fd88
    mov cx, word ptr [ebp - local_4]             # 0041fd8d
    mov word ptr [ebp - local_10], cx            # 0041fd91
    movsx edx, word ptr [ebp - local_10]         # 0041fd95
    add edx, 0x1                                 # 0041fd99
    mov word ptr [ebp - local_18], dx            # 0041fd9c
    jmp.d8 L_0041fdba                            # 0041fda0
L_0041fda2:
    # block 0x0041fda2: entered by jmp at 0x0041ffe0, 6 instruction(s), falls into the block at 0x0041fdba
    mov ax, word ptr [ebp - local_18]            # 0041fda2
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041fda6
    mov word ptr [ebp - local_18], ax            # 0041fdaa
    mov cx, word ptr [ebp - local_10]            # 0041fdae
    add cx, 0x1                                  # 0041fdb2
    mov word ptr [ebp - local_10], cx            # 0041fdb6
L_0041fdba:
    # block 0x0041fdba: entered by jmp at 0x0041fda0, 5 instruction(s), ends with jge to 0x0041ffe5 (forward)
    movsx edx, word ptr [ebp - local_18]         # 0041fdba
    mov eax, dword ptr [ebp - local_1c]          # 0041fdbe
    movsx ecx, word ptr [eax + field_f21]        # 0041fdc1
    {load} cmp edx, ecx                          # 0041fdc8
    jge.d32 L_0041ffe5                           # 0041fdca
    # block 0x0041fdd0: entered by fall-through of jge at 0x0041fdca, 130 instruction(s), calls FUN_0051ea75, FUN_0051eac4, ends with backward jump to 0x0041fda2
    push 0x190                                   # 0041fdd0
    movsx edx, word ptr [ebp - local_10]         # 0041fdd5
    mov eax, dword ptr [ebp - local_1c]          # 0041fdd9
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fddc
    call FUN_0051ea75                            # 0041fde3
    mov dword ptr [ebp - local_c], eax           # 0041fde8
    push 0x190                                   # 0041fdeb
    movsx ecx, word ptr [ebp - local_18]         # 0041fdf0
    mov edx, dword ptr [ebp - local_1c]          # 0041fdf4
    lea ecx, [edx + 4*ecx + field_ea5]           # 0041fdf7
    call FUN_0051ea75                            # 0041fdfe
    mov dword ptr [ebp - local_8], eax           # 0041fe03
    mov ecx, 0x64                                # 0041fe06
    mov esi, dword ptr [ebp - local_8]           # 0041fe0b
    mov edi, dword ptr [ebp - local_c]           # 0041fe0e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041fe11
    push -0x1                                    # 0041fe13
    movsx eax, word ptr [ebp - local_10]         # 0041fe15
    mov ecx, dword ptr [ebp - local_1c]          # 0041fe19
    lea ecx, [ecx + 4*eax + field_ea5]           # 0041fe1c
    call FUN_0051eac4                            # 0041fe23
    push -0x1                                    # 0041fe28
    movsx edx, word ptr [ebp - local_18]         # 0041fe2a
    mov eax, dword ptr [ebp - local_1c]          # 0041fe2e
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fe31
    call FUN_0051eac4                            # 0041fe38
    movsx ecx, word ptr [ebp - local_18]         # 0041fe3d
    imul ecx, ecx, 0x3a                          # 0041fe41
    movsx edx, word ptr [ebp - local_10]         # 0041fe44
    imul edx, edx, 0x3a                          # 0041fe48
    mov eax, dword ptr [ebp - local_1c]          # 0041fe4b
    mov esi, dword ptr [ebp - local_1c]          # 0041fe4e
    mov cx, word ptr [esi + ecx + field_800]     # 0041fe51
    mov word ptr [eax + edx + field_800], cx     # 0041fe59
    movsx edx, word ptr [ebp - local_18]         # 0041fe61
    imul edx, edx, 0x3a                          # 0041fe65
    movsx eax, word ptr [ebp - local_10]         # 0041fe68
    imul eax, eax, 0x3a                          # 0041fe6c
    mov ecx, dword ptr [ebp - local_1c]          # 0041fe6f
    mov esi, dword ptr [ebp - local_1c]          # 0041fe72
    mov dx, word ptr [esi + edx + field_7fe]     # 0041fe75
    mov word ptr [ecx + eax + field_7fe], dx     # 0041fe7d
    movsx eax, word ptr [ebp - local_18]         # 0041fe85
    imul eax, eax, 0x3a                          # 0041fe89
    movsx ecx, word ptr [ebp - local_10]         # 0041fe8c
    imul ecx, ecx, 0x3a                          # 0041fe90
    mov edx, dword ptr [ebp - local_1c]          # 0041fe93
    mov esi, dword ptr [ebp - local_1c]          # 0041fe96
    mov ax, word ptr [esi + eax + field_7fa]     # 0041fe99
    mov word ptr [edx + ecx + field_7fa], ax     # 0041fea1
    movsx ecx, word ptr [ebp - local_18]         # 0041fea9
    imul ecx, ecx, 0x3a                          # 0041fead
    movsx edx, word ptr [ebp - local_10]         # 0041feb0
    imul edx, edx, 0x3a                          # 0041feb4
    mov eax, dword ptr [ebp - local_1c]          # 0041feb7
    mov esi, dword ptr [ebp - local_1c]          # 0041feba
    mov cx, word ptr [esi + ecx + field_7fc]     # 0041febd
    mov word ptr [eax + edx + field_7fc], cx     # 0041fec5
    movsx edx, word ptr [ebp - local_18]         # 0041fecd
    imul edx, edx, 0x3a                          # 0041fed1
    movsx eax, word ptr [ebp - local_10]         # 0041fed4
    imul eax, eax, 0x3a                          # 0041fed8
    mov ecx, dword ptr [ebp - local_1c]          # 0041fedb
    mov esi, dword ptr [ebp - local_1c]          # 0041fede
    mov edx, dword ptr [esi + edx + field_802]   # 0041fee1
    mov dword ptr [ecx + eax + field_802], edx   # 0041fee8
    movsx eax, word ptr [ebp - local_18]         # 0041feef
    imul eax, eax, 0x3a                          # 0041fef3
    movsx ecx, word ptr [ebp - local_10]         # 0041fef6
    imul ecx, ecx, 0x3a                          # 0041fefa
    mov edx, dword ptr [ebp - local_1c]          # 0041fefd
    mov esi, dword ptr [ebp - local_1c]          # 0041ff00
    mov eax, dword ptr [esi + eax + field_806]   # 0041ff03
    mov dword ptr [edx + ecx + field_806], eax   # 0041ff0a
    movsx ecx, word ptr [ebp - local_18]         # 0041ff11
    imul ecx, ecx, 0x3a                          # 0041ff15
    movsx edx, word ptr [ebp - local_10]         # 0041ff18
    imul edx, edx, 0x3a                          # 0041ff1c
    mov eax, dword ptr [ebp - local_1c]          # 0041ff1f
    mov esi, dword ptr [ebp - local_1c]          # 0041ff22
    mov ecx, dword ptr [esi + ecx + field_80a]   # 0041ff25
    mov dword ptr [eax + edx + field_80a], ecx   # 0041ff2c
    movsx edx, word ptr [ebp - local_18]         # 0041ff33
    imul edx, edx, 0x3a                          # 0041ff37
    mov eax, dword ptr [ebp - local_1c]          # 0041ff3a
    lea ecx, [eax + edx + field_7d9]             # 0041ff3d
    {load} mov edi, ecx                          # 0041ff44
    movsx edx, word ptr [ebp - local_10]         # 0041ff46
    imul edx, edx, 0x3a                          # 0041ff4a
    mov eax, dword ptr [ebp - local_1c]          # 0041ff4d
    lea ecx, [eax + edx + field_7d9]             # 0041ff50
    {load} mov edx, ecx                          # 0041ff57
    or ecx, -0x1                                 # 0041ff59
    {load} xor eax, eax                          # 0041ff5c
    repne scasb al, byte ptr es:[edi]            # 0041ff5e
    not ecx                                      # 0041ff60
    {load} sub edi, ecx                          # 0041ff62
    {load} mov esi, edi                          # 0041ff64
    {load} mov eax, ecx                          # 0041ff66
    {load} mov edi, edx                          # 0041ff68
    shr ecx, 0x2                                 # 0041ff6a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ff6d
    {load} mov ecx, eax                          # 0041ff6f
    and ecx, 0x3                                 # 0041ff71
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041ff74
    movsx ecx, word ptr [ebp - local_18]         # 0041ff76
    imul ecx, ecx, 0x3a                          # 0041ff7a
    movsx edx, word ptr [ebp - local_10]         # 0041ff7d
    imul edx, edx, 0x3a                          # 0041ff81
    mov eax, dword ptr [ebp - local_1c]          # 0041ff84
    mov esi, dword ptr [ebp - local_1c]          # 0041ff87
    mov cx, word ptr [esi + ecx + field_80e]     # 0041ff8a
    mov word ptr [eax + edx + field_80e], cx     # 0041ff92
    movsx edx, word ptr [ebp - local_18]         # 0041ff9a
    imul edx, edx, 0x3a                          # 0041ff9e
    movsx eax, word ptr [ebp - local_10]         # 0041ffa1
    imul eax, eax, 0x3a                          # 0041ffa5
    mov ecx, dword ptr [ebp - local_1c]          # 0041ffa8
    mov esi, dword ptr [ebp - local_1c]          # 0041ffab
    mov dl, byte ptr [esi + edx + field_810]     # 0041ffae
    mov byte ptr [ecx + eax + field_810], dl     # 0041ffb5
    movsx eax, word ptr [ebp - local_18]         # 0041ffbc
    imul eax, eax, 0x3a                          # 0041ffc0
    movsx ecx, word ptr [ebp - local_10]         # 0041ffc3
    imul ecx, ecx, 0x3a                          # 0041ffc7
    mov edx, dword ptr [ebp - local_1c]          # 0041ffca
    mov esi, dword ptr [ebp - local_1c]          # 0041ffcd
    mov ax, word ptr [esi + eax + field_811]     # 0041ffd0
    mov word ptr [edx + ecx + field_811], ax     # 0041ffd8
    jmp.d32 L_0041fda2                           # 0041ffe0
L_0041ffe5:
    # block 0x0041ffe5: entered by jge at 0x0041fdca, 9 instruction(s), ends with jge to 0x00420017 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0041ffe5
    mov dx, word ptr [ecx + field_f21]           # 0041ffe8
    sub dx, 0x1                                  # 0041ffef
    mov eax, dword ptr [ebp - local_1c]          # 0041fff3
    mov word ptr [eax + field_f21], dx           # 0041fff6
    mov ecx, dword ptr [ebp - local_1c]          # 0041fffd
    movsx edx, word ptr [ecx + field_f21]        # 00420000
    test edx, edx                                # 00420007
    jge.d8 L_00420017                            # 00420009
    # block 0x0042000b: entered by fall-through of jge at 0x00420009, 2 instruction(s), falls into the block at 0x00420017
    mov eax, dword ptr [ebp - local_1c]          # 0042000b
    mov word ptr [eax + field_f21], 0x0          # 0042000e
L_00420017:
    # block 0x00420017: entered by jge at 0x00420009, 1 instruction(s), ends with forward jump to 0x00420033
    jmp.d8 L_00420033                            # 00420017
L_00420019:
    # block 0x00420019: entered by jne at 0x0041fd72, 6 instruction(s), calls FUN_0051eac4, ends with backward jump to 0x0041fd1b
    push -0x1                                    # 00420019
    movsx ecx, word ptr [ebp - local_4]          # 0042001b
    mov edx, dword ptr [ebp - local_1c]          # 0042001f
    lea ecx, [edx + 4*ecx + field_ea5]           # 00420022
    call FUN_0051eac4                            # 00420029
    jmp.d32 L_0041fd1b                           # 0042002e
L_00420033:
    # block 0x00420033: entered by jge at 0x0041fd37; jmp at 0x00420017, 3 instruction(s), ends with je to 0x0042007f (forward)
    movsx eax, word ptr [0x63a4cd]               # 00420033
    test eax, eax                                # 0042003a
    je.d8 L_0042007f                             # 0042003c
    # block 0x0042003e: entered by fall-through of je at 0x0042003c, 5 instruction(s), ends with jle to 0x0042007f (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0042003e
    movsx edx, word ptr [ecx + field_f21]        # 00420041
    add edx, 0x1                                 # 00420048
    cmp edx, 0x1e                                # 0042004b
    jle.d8 L_0042007f                            # 0042004e
    # block 0x00420050: entered by fall-through of jle at 0x0042004e, 11 instruction(s), calls FUN_0050ca3e, FUN_004264e8, falls into the block at 0x0042007f
    mov eax, dword ptr [ebp - local_1c]          # 00420050
    movsx ecx, word ptr [eax + field_f21]        # 00420053
    add ecx, 0x1                                 # 0042005a
    push ecx                                     # 0042005d
    push 0x543ac0                                # 0042005e
    push 0x63888b                                # 00420063
    call FUN_0050ca3e                            # 00420068
    add esp, 0xc                                 # 0042006d
    push 0x63888b                                # 00420070
    mov ecx, 0x583979                            # 00420075
    call FUN_004264e8                            # 0042007a
L_0042007f:
    # block 0x0042007f: entered by je at 0x0042003c; jle at 0x0042004e, 5 instruction(s), ends with jg to 0x00420286 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 0042007f
    movsx eax, word ptr [edx + field_f21]        # 00420082
    add eax, 0x1                                 # 00420089
    cmp eax, 0x1e                                # 0042008c
    jg.d32 L_00420286                            # 0042008f
    # block 0x00420095: entered by fall-through of jg at 0x0042008f, 115 instruction(s), calls FUN_0051ea75, FUN_0051eac4, falls into the block at 0x00420286
    push 0x190                                   # 00420095
    mov ecx, dword ptr [ebp - local_1c]          # 0042009a
    movsx edx, word ptr [ecx + field_f21]        # 0042009d
    mov eax, dword ptr [ebp - local_1c]          # 004200a4
    lea ecx, [eax + 4*edx + field_ea5]           # 004200a7
    call FUN_0051ea75                            # 004200ae
    mov dword ptr [ebp - local_14], eax          # 004200b3
    mov esi, dword ptr [ebp + arg_8]             # 004200b6
    add esi, 0x6                                 # 004200b9
    mov ecx, 0x64                                # 004200bc
    mov edi, dword ptr [ebp - local_14]          # 004200c1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004200c4
    push -0x1                                    # 004200c6
    mov ecx, dword ptr [ebp - local_1c]          # 004200c8
    movsx edx, word ptr [ecx + field_f21]        # 004200cb
    mov eax, dword ptr [ebp - local_1c]          # 004200d2
    lea ecx, [eax + 4*edx + field_ea5]           # 004200d5
    call FUN_0051eac4                            # 004200dc
    mov ecx, dword ptr [ebp - local_1c]          # 004200e1
    movsx edx, word ptr [ecx + field_f21]        # 004200e4
    imul edx, edx, 0x3a                          # 004200eb
    mov eax, dword ptr [ebp - local_1c]          # 004200ee
    mov ecx, dword ptr [ebp + arg_8]             # 004200f1
    mov cx, word ptr [ecx + field_1be]           # 004200f4
    mov word ptr [eax + edx + field_800], cx     # 004200fb
    mov edx, dword ptr [ebp - local_1c]          # 00420103
    movsx eax, word ptr [edx + field_f21]        # 00420106
    imul eax, eax, 0x3a                          # 0042010d
    mov ecx, dword ptr [ebp - local_1c]          # 00420110
    mov edx, dword ptr [ebp + arg_8]             # 00420113
    mov dx, word ptr [edx + field_1bc]           # 00420116
    mov word ptr [ecx + eax + field_7fe], dx     # 0042011d
    mov eax, dword ptr [ebp - local_1c]          # 00420125
    movsx ecx, word ptr [eax + field_f21]        # 00420128
    imul ecx, ecx, 0x3a                          # 0042012f
    mov edx, dword ptr [ebp - local_1c]          # 00420132
    mov eax, dword ptr [ebp + arg_8]             # 00420135
    mov ax, word ptr [eax + field_1b8]           # 00420138
    mov word ptr [edx + ecx + field_7fa], ax     # 0042013f
    mov ecx, dword ptr [ebp - local_1c]          # 00420147
    movsx edx, word ptr [ecx + field_f21]        # 0042014a
    imul edx, edx, 0x3a                          # 00420151
    mov eax, dword ptr [ebp - local_1c]          # 00420154
    mov ecx, dword ptr [ebp + arg_8]             # 00420157
    mov cx, word ptr [ecx + field_1ba]           # 0042015a
    mov word ptr [eax + edx + field_7fc], cx     # 00420161
    mov edx, dword ptr [ebp - local_1c]          # 00420169
    movsx eax, word ptr [edx + field_f21]        # 0042016c
    imul eax, eax, 0x3a                          # 00420173
    mov ecx, dword ptr [ebp - local_1c]          # 00420176
    mov edx, dword ptr [ebp + arg_8]             # 00420179
    mov edx, dword ptr [edx + field_1c0]         # 0042017c
    mov dword ptr [ecx + eax + field_802], edx   # 00420182
    mov eax, dword ptr [ebp - local_1c]          # 00420189
    movsx ecx, word ptr [eax + field_f21]        # 0042018c
    imul ecx, ecx, 0x3a                          # 00420193
    mov edx, dword ptr [ebp - local_1c]          # 00420196
    mov eax, dword ptr [ebp + arg_8]             # 00420199
    mov eax, dword ptr [eax + field_1c4]         # 0042019c
    mov dword ptr [edx + ecx + field_806], eax   # 004201a2
    mov ecx, dword ptr [ebp - local_1c]          # 004201a9
    movsx edx, word ptr [ecx + field_f21]        # 004201ac
    imul edx, edx, 0x3a                          # 004201b3
    mov eax, dword ptr [ebp - local_1c]          # 004201b6
    mov ecx, dword ptr [ebp + arg_8]             # 004201b9
    mov ecx, dword ptr [ecx + field_1c8]         # 004201bc
    mov dword ptr [eax + edx + field_80a], ecx   # 004201c2
    mov edx, dword ptr [ebp + arg_8]             # 004201c9
    add edx, 0x196                               # 004201cc
    {load} mov edi, edx                          # 004201d2
    mov eax, dword ptr [ebp - local_1c]          # 004201d4
    movsx ecx, word ptr [eax + field_f21]        # 004201d7
    imul ecx, ecx, 0x3a                          # 004201de
    mov edx, dword ptr [ebp - local_1c]          # 004201e1
    lea eax, [edx + ecx + field_7d9]             # 004201e4
    {load} mov edx, eax                          # 004201eb
    or ecx, -0x1                                 # 004201ed
    {load} xor eax, eax                          # 004201f0
    repne scasb al, byte ptr es:[edi]            # 004201f2
    not ecx                                      # 004201f4
    {load} sub edi, ecx                          # 004201f6
    {load} mov esi, edi                          # 004201f8
    {load} mov eax, ecx                          # 004201fa
    {load} mov edi, edx                          # 004201fc
    shr ecx, 0x2                                 # 004201fe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00420201
    {load} mov ecx, eax                          # 00420203
    and ecx, 0x3                                 # 00420205
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00420208
    mov ecx, dword ptr [ebp - local_1c]          # 0042020a
    movsx edx, word ptr [ecx + field_f21]        # 0042020d
    imul edx, edx, 0x3a                          # 00420214
    mov eax, dword ptr [ebp - local_1c]          # 00420217
    mov ecx, dword ptr [ebp + arg_8]             # 0042021a
    mov cx, word ptr [ecx + field_1cc]           # 0042021d
    mov word ptr [eax + edx + field_80e], cx     # 00420224
    mov edx, dword ptr [ebp - local_1c]          # 0042022c
    movsx eax, word ptr [edx + field_f21]        # 0042022f
    imul eax, eax, 0x3a                          # 00420236
    mov ecx, dword ptr [ebp - local_1c]          # 00420239
    mov edx, dword ptr [ebp + arg_8]             # 0042023c
    mov dl, byte ptr [edx + field_1ce]           # 0042023f
    mov byte ptr [ecx + eax + field_810], dl     # 00420245
    mov eax, dword ptr [ebp - local_1c]          # 0042024c
    movsx ecx, word ptr [eax + field_f21]        # 0042024f
    imul ecx, ecx, 0x3a                          # 00420256
    mov edx, dword ptr [ebp - local_1c]          # 00420259
    mov eax, dword ptr [ebp + arg_8]             # 0042025c
    mov ax, word ptr [eax + field_1cf]           # 0042025f
    mov word ptr [edx + ecx + field_811], ax     # 00420266
    mov ecx, dword ptr [ebp - local_1c]          # 0042026e
    mov dx, word ptr [ecx + field_f21]           # 00420271
    add dx, 0x1                                  # 00420278
    mov eax, dword ptr [ebp - local_1c]          # 0042027c
    mov word ptr [eax + field_f21], dx           # 0042027f
L_00420286:
    # block 0x00420286: entered by jg at 0x0042008f, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00420286
    pop esi                                      # 00420287
    {load} mov esp, ebp                          # 00420288
    pop ebp                                      # 0042028a
    ret 0x4                                      # 0042028b

