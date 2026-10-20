# FUN_004d2c20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d2c20
# extent:       0x004d2c20-0x004d3073 (1107 code bytes)
# span:         0x004d2c20-0x004d3073 (code 1107, tables 0, padding 0)
# sha256:       a3a64815176d5fedc00262247ba11a5e2f9050a406b46c38f3b4f013a2bd0016
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d2c20
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_3f, field_43, field_4f, field_55, field_57, field_c3, field_c7, field_cb, field_cf, field_minus_1, field_minus_41; [ecx + n] field_3f, field_43, field_51, field_53, field_c3, field_c7, field_cb, field_cf; [edx + n] field_2, field_3f, field_43, field_c3, field_c7, field_cb, field_cf, field_minus_1, field_minus_30, field_minus_61
# callees:      calls FUN_0052139c, FUN_004c97b4, FUN_004d214b, FUN_0050d651, FUN_0050d67f, FUN_0050d6a7, FUN_0050d6cf, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a76_render (function ledger class candidate_port; also native_a76_view_origin, native_ae4_alloc_slot, native_af5_alloc_slot; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 296 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_minus_30, 0x30  # offset -0x30
.equ field_minus_41, 0x41  # offset -0x41
.equ field_minus_61, 0x61  # offset -0x61
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_4f, 0x4f  # offset +0x4f
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_55, 0x55  # offset +0x55
.equ field_57, 0x57  # offset +0x57
.equ field_c3, 0xc3  # offset +0xc3
.equ field_c7, 0xc7  # offset +0xc7
.equ field_cb, 0xcb  # offset +0xcb
.equ field_cf, 0xcf  # offset +0xcf

# --- external targets -----------------------------------------------
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d214b, .text + (0x004d214b - 0x401000)
.set FUN_0050d651, .text + (0x0050d651 - 0x401000)
.set FUN_0050d67f, .text + (0x0050d67f - 0x401000)
.set FUN_0050d6a7, .text + (0x0050d6a7 - 0x401000)
.set FUN_0050d6cf, .text + (0x0050d6cf - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004d2c20 - 0x401000
.globl FUN_004d2c20
FUN_004d2c20:
    # block 0x004d2c20: entry, 6 instruction(s), ends with je to 0x004d2c55 (forward)
    push ebp                                     # 004d2c20
    {load} mov ebp, esp                          # 004d2c21
    sub esp, 0x18                                # 004d2c23
    movsx eax, word ptr [0x63a4cd]               # 004d2c26
    test eax, eax                                # 004d2c2d
    je.d8 L_004d2c55                             # 004d2c2f
    # block 0x004d2c31: entered by fall-through of je at 0x004d2c2f, 2 instruction(s), ends with je to 0x004d2c3d (forward)
    cmp dword ptr [ebp + arg_1c], 0x0            # 004d2c31
    je.d8 L_004d2c3d                             # 004d2c35
    # block 0x004d2c37: entered by fall-through of je at 0x004d2c35, 2 instruction(s), ends with jne to 0x004d2c55 (forward)
    cmp dword ptr [ebp + arg_20], 0x0            # 004d2c37
    jne.d8 L_004d2c55                            # 004d2c3b
L_004d2c3d:
    # block 0x004d2c3d: entered by je at 0x004d2c35; fall-through of jne at 0x004d2c3b, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d2c55
    push 0x0                                     # 004d2c3d
    push 0x0                                     # 004d2c3f
    push 0x55a344                                # 004d2c41
    call FUN_0052139c                            # 004d2c46
    mov ecx, 0x5cf659                            # 004d2c4b
    call FUN_004c97b4                            # 004d2c50
L_004d2c55:
    # block 0x004d2c55: entered by je at 0x004d2c2f; jne at 0x004d2c3b, 9 instruction(s), ends with forward jump to 0x004d2c8e
    movsx ecx, word ptr [ebp + arg_18]           # 004d2c55
    mov dword ptr [0x63a8ec], ecx                # 004d2c59
    mov dword ptr [0x63a8e4], 0x0                # 004d2c5f
    movsx edx, word ptr [ebp + arg_14]           # 004d2c69
    mov dword ptr [0x63a8e0], edx                # 004d2c6d
    mov dword ptr [0x63a8e8], 0x0                # 004d2c73
    mov eax, dword ptr [ebp + arg_8]             # 004d2c7d
    mov dword ptr [ebp - local_18], eax          # 004d2c80
    jmp.d8 L_004d2c8e                            # 004d2c83
L_004d2c85:
    # block 0x004d2c85: entered by jmp at 0x004d2fcf; jmp at 0x004d3065, 3 instruction(s), falls into the block at 0x004d2c8e
    mov ecx, dword ptr [ebp + arg_8]             # 004d2c85
    add ecx, 0x1                                 # 004d2c88
    mov dword ptr [ebp + arg_8], ecx             # 004d2c8b
L_004d2c8e:
    # block 0x004d2c8e: entered by jmp at 0x004d2c83, 4 instruction(s), ends with je to 0x004d306a (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d2c8e
    movsx eax, byte ptr [edx]                    # 004d2c91
    test eax, eax                                # 004d2c94
    je.d32 L_004d306a                            # 004d2c96
    # block 0x004d2c9c: entered by fall-through of je at 0x004d2c96, 11 instruction(s), calls FUN_004d214b, ends with je to 0x004d2d3b (forward)
    lea ecx, [ebp - local_14]                    # 004d2c9c
    push ecx                                     # 004d2c9f
    mov edx, dword ptr [ebp + arg_c]             # 004d2ca0
    push edx                                     # 004d2ca3
    mov eax, dword ptr [ebp + arg_8]             # 004d2ca4
    mov cl, byte ptr [eax]                       # 004d2ca7
    push ecx                                     # 004d2ca9
    call FUN_004d214b                            # 004d2caa
    add esp, 0xc                                 # 004d2caf
    test eax, eax                                # 004d2cb2
    je.d32 L_004d2d3b                            # 004d2cb4
    # block 0x004d2cba: entered by fall-through of je at 0x004d2cb4, 33 instruction(s), ends with forward jump to 0x004d2fd4
    movsx edx, word ptr [ebp - local_14]         # 004d2cba
    shl edx, 0x4                                 # 004d2cbe
    movsx eax, word ptr [ebp + arg_24]           # 004d2cc1
    mov ecx, dword ptr [ebp + arg_c]             # 004d2cc5
    mov edx, dword ptr [ecx + edx + field_c7]    # 004d2cc8
    mov ecx, dword ptr [ebp + arg_c]             # 004d2ccf
    add edx, dword ptr [ecx + 8*eax + field_43]  # 004d2cd2
    mov dword ptr [ebp - local_c], edx           # 004d2cd6
    movsx edx, word ptr [ebp - local_14]         # 004d2cd9
    shl edx, 0x4                                 # 004d2cdd
    movsx eax, word ptr [ebp + arg_24]           # 004d2ce0
    mov ecx, dword ptr [ebp + arg_c]             # 004d2ce4
    mov edx, dword ptr [ecx + edx + field_cf]    # 004d2ce7
    mov ecx, dword ptr [ebp + arg_c]             # 004d2cee
    add edx, dword ptr [ecx + 8*eax + field_43]  # 004d2cf1
    mov dword ptr [ebp - local_4], edx           # 004d2cf5
    movsx edx, word ptr [ebp - local_14]         # 004d2cf8
    shl edx, 0x4                                 # 004d2cfc
    movsx eax, word ptr [ebp + arg_24]           # 004d2cff
    mov ecx, dword ptr [ebp + arg_c]             # 004d2d03
    mov edx, dword ptr [ecx + edx + field_c3]    # 004d2d06
    mov ecx, dword ptr [ebp + arg_c]             # 004d2d0d
    add edx, dword ptr [ecx + 8*eax + field_3f]  # 004d2d10
    mov dword ptr [ebp - local_10], edx          # 004d2d14
    movsx edx, word ptr [ebp - local_14]         # 004d2d17
    shl edx, 0x4                                 # 004d2d1b
    movsx eax, word ptr [ebp + arg_24]           # 004d2d1e
    mov ecx, dword ptr [ebp + arg_c]             # 004d2d22
    mov edx, dword ptr [ecx + edx + field_cb]    # 004d2d25
    mov ecx, dword ptr [ebp + arg_c]             # 004d2d2c
    add edx, dword ptr [ecx + 8*eax + field_3f]  # 004d2d2f
    mov dword ptr [ebp - local_8], edx           # 004d2d33
    jmp.d32 L_004d2fd4                           # 004d2d36
L_004d2d3b:
    # block 0x004d2d3b: entered by je at 0x004d2cb4, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d2e12 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d2d3b
    movsx eax, byte ptr [edx]                    # 004d2d3e
    push eax                                     # 004d2d41
    call FUN_0050d651                            # 004d2d42
    add esp, 0x4                                 # 004d2d47
    test eax, eax                                # 004d2d4a
    je.d32 L_004d2e12                            # 004d2d4c
    # block 0x004d2d52: entered by fall-through of je at 0x004d2d4c, 7 instruction(s), calls FUN_0050d67f, ends with je to 0x004d2e12 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d2d52
    movsx edx, byte ptr [ecx]                    # 004d2d55
    push edx                                     # 004d2d58
    call FUN_0050d67f                            # 004d2d59
    add esp, 0x4                                 # 004d2d5e
    test eax, eax                                # 004d2d61
    je.d32 L_004d2e12                            # 004d2d63
    # block 0x004d2d69: entered by fall-through of je at 0x004d2d63, 5 instruction(s), ends with jge to 0x004d2e12 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d2d69
    {load} xor ecx, ecx                          # 004d2d6c
    mov cl, byte ptr [eax]                       # 004d2d6e
    cmp ecx, 0x80                                # 004d2d70
    jge.d32 L_004d2e12                           # 004d2d76
    # block 0x004d2d7c: entered by fall-through of jge at 0x004d2d76, 39 instruction(s), ends with forward jump to 0x004d2fd4
    mov edx, dword ptr [ebp + arg_8]             # 004d2d7c
    movsx eax, byte ptr [edx]                    # 004d2d7f
    mov ecx, dword ptr [ebp + arg_c]             # 004d2d82
    movsx edx, word ptr [ecx + field_53]         # 004d2d85
    lea eax, [eax + edx - field_minus_41]        # 004d2d89
    mov word ptr [ebp - local_14], ax            # 004d2d8d
    movsx ecx, word ptr [ebp - local_14]         # 004d2d91
    shl ecx, 0x4                                 # 004d2d95
    movsx edx, word ptr [ebp + arg_24]           # 004d2d98
    mov eax, dword ptr [ebp + arg_c]             # 004d2d9c
    mov ecx, dword ptr [eax + ecx + field_c7]    # 004d2d9f
    mov eax, dword ptr [ebp + arg_c]             # 004d2da6
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d2da9
    mov dword ptr [ebp - local_c], ecx           # 004d2dad
    movsx ecx, word ptr [ebp - local_14]         # 004d2db0
    shl ecx, 0x4                                 # 004d2db4
    movsx edx, word ptr [ebp + arg_24]           # 004d2db7
    mov eax, dword ptr [ebp + arg_c]             # 004d2dbb
    mov ecx, dword ptr [eax + ecx + field_cf]    # 004d2dbe
    mov eax, dword ptr [ebp + arg_c]             # 004d2dc5
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d2dc8
    mov dword ptr [ebp - local_4], ecx           # 004d2dcc
    movsx ecx, word ptr [ebp - local_14]         # 004d2dcf
    shl ecx, 0x4                                 # 004d2dd3
    movsx edx, word ptr [ebp + arg_24]           # 004d2dd6
    mov eax, dword ptr [ebp + arg_c]             # 004d2dda
    mov ecx, dword ptr [eax + ecx + field_c3]    # 004d2ddd
    mov eax, dword ptr [ebp + arg_c]             # 004d2de4
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d2de7
    mov dword ptr [ebp - local_10], ecx          # 004d2deb
    movsx ecx, word ptr [ebp - local_14]         # 004d2dee
    shl ecx, 0x4                                 # 004d2df2
    movsx edx, word ptr [ebp + arg_24]           # 004d2df5
    mov eax, dword ptr [ebp + arg_c]             # 004d2df9
    mov ecx, dword ptr [eax + ecx + field_cb]    # 004d2dfc
    mov eax, dword ptr [ebp + arg_c]             # 004d2e03
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d2e06
    mov dword ptr [ebp - local_8], ecx           # 004d2e0a
    jmp.d32 L_004d2fd4                           # 004d2e0d
L_004d2e12:
    # block 0x004d2e12: entered by je at 0x004d2d4c; je at 0x004d2d63; jge at 0x004d2d76, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d2ee8 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d2e12
    movsx edx, byte ptr [ecx]                    # 004d2e15
    push edx                                     # 004d2e18
    call FUN_0050d651                            # 004d2e19
    add esp, 0x4                                 # 004d2e1e
    test eax, eax                                # 004d2e21
    je.d32 L_004d2ee8                            # 004d2e23
    # block 0x004d2e29: entered by fall-through of je at 0x004d2e23, 7 instruction(s), calls FUN_0050d6a7, ends with je to 0x004d2ee8 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d2e29
    movsx ecx, byte ptr [eax]                    # 004d2e2c
    push ecx                                     # 004d2e2f
    call FUN_0050d6a7                            # 004d2e30
    add esp, 0x4                                 # 004d2e35
    test eax, eax                                # 004d2e38
    je.d32 L_004d2ee8                            # 004d2e3a
    # block 0x004d2e40: entered by fall-through of je at 0x004d2e3a, 5 instruction(s), ends with jge to 0x004d2ee8 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d2e40
    {load} xor eax, eax                          # 004d2e43
    mov al, byte ptr [edx]                       # 004d2e45
    cmp eax, 0x80                                # 004d2e47
    jge.d32 L_004d2ee8                           # 004d2e4c
    # block 0x004d2e52: entered by fall-through of jge at 0x004d2e4c, 39 instruction(s), ends with forward jump to 0x004d2fd4
    mov ecx, dword ptr [ebp + arg_8]             # 004d2e52
    movsx edx, byte ptr [ecx]                    # 004d2e55
    mov eax, dword ptr [ebp + arg_c]             # 004d2e58
    movsx ecx, word ptr [eax + field_55]         # 004d2e5b
    lea edx, [edx + ecx - field_minus_61]        # 004d2e5f
    mov word ptr [ebp - local_14], dx            # 004d2e63
    movsx eax, word ptr [ebp - local_14]         # 004d2e67
    shl eax, 0x4                                 # 004d2e6b
    movsx ecx, word ptr [ebp + arg_24]           # 004d2e6e
    mov edx, dword ptr [ebp + arg_c]             # 004d2e72
    mov eax, dword ptr [edx + eax + field_c7]    # 004d2e75
    mov edx, dword ptr [ebp + arg_c]             # 004d2e7c
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d2e7f
    mov dword ptr [ebp - local_c], eax           # 004d2e83
    movsx eax, word ptr [ebp - local_14]         # 004d2e86
    shl eax, 0x4                                 # 004d2e8a
    movsx ecx, word ptr [ebp + arg_24]           # 004d2e8d
    mov edx, dword ptr [ebp + arg_c]             # 004d2e91
    mov eax, dword ptr [edx + eax + field_cf]    # 004d2e94
    mov edx, dword ptr [ebp + arg_c]             # 004d2e9b
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d2e9e
    mov dword ptr [ebp - local_4], eax           # 004d2ea2
    movsx eax, word ptr [ebp - local_14]         # 004d2ea5
    shl eax, 0x4                                 # 004d2ea9
    movsx ecx, word ptr [ebp + arg_24]           # 004d2eac
    mov edx, dword ptr [ebp + arg_c]             # 004d2eb0
    mov eax, dword ptr [edx + eax + field_c3]    # 004d2eb3
    mov edx, dword ptr [ebp + arg_c]             # 004d2eba
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d2ebd
    mov dword ptr [ebp - local_10], eax          # 004d2ec1
    movsx eax, word ptr [ebp - local_14]         # 004d2ec4
    shl eax, 0x4                                 # 004d2ec8
    movsx ecx, word ptr [ebp + arg_24]           # 004d2ecb
    mov edx, dword ptr [ebp + arg_c]             # 004d2ecf
    mov eax, dword ptr [edx + eax + field_cb]    # 004d2ed2
    mov edx, dword ptr [ebp + arg_c]             # 004d2ed9
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d2edc
    mov dword ptr [ebp - local_8], eax           # 004d2ee0
    jmp.d32 L_004d2fd4                           # 004d2ee3
L_004d2ee8:
    # block 0x004d2ee8: entered by je at 0x004d2e23; je at 0x004d2e3a; jge at 0x004d2e4c, 7 instruction(s), calls FUN_0050d6cf, ends with je to 0x004d2fa4 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d2ee8
    movsx ecx, byte ptr [eax]                    # 004d2eeb
    push ecx                                     # 004d2eee
    call FUN_0050d6cf                            # 004d2eef
    add esp, 0x4                                 # 004d2ef4
    test eax, eax                                # 004d2ef7
    je.d32 L_004d2fa4                            # 004d2ef9
    # block 0x004d2eff: entered by fall-through of je at 0x004d2ef9, 5 instruction(s), ends with jge to 0x004d2fa4 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d2eff
    {load} xor eax, eax                          # 004d2f02
    mov al, byte ptr [edx]                       # 004d2f04
    cmp eax, 0x80                                # 004d2f06
    jge.d32 L_004d2fa4                           # 004d2f0b
    # block 0x004d2f11: entered by fall-through of jge at 0x004d2f0b, 39 instruction(s), ends with forward jump to 0x004d2fd4
    mov ecx, dword ptr [ebp + arg_8]             # 004d2f11
    movsx edx, byte ptr [ecx]                    # 004d2f14
    mov eax, dword ptr [ebp + arg_c]             # 004d2f17
    movsx ecx, word ptr [eax + field_57]         # 004d2f1a
    lea edx, [edx + ecx - field_minus_30]        # 004d2f1e
    mov word ptr [ebp - local_14], dx            # 004d2f22
    movsx eax, word ptr [ebp - local_14]         # 004d2f26
    shl eax, 0x4                                 # 004d2f2a
    movsx ecx, word ptr [ebp + arg_24]           # 004d2f2d
    mov edx, dword ptr [ebp + arg_c]             # 004d2f31
    mov eax, dword ptr [edx + eax + field_c7]    # 004d2f34
    mov edx, dword ptr [ebp + arg_c]             # 004d2f3b
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d2f3e
    mov dword ptr [ebp - local_c], eax           # 004d2f42
    movsx eax, word ptr [ebp - local_14]         # 004d2f45
    shl eax, 0x4                                 # 004d2f49
    movsx ecx, word ptr [ebp + arg_24]           # 004d2f4c
    mov edx, dword ptr [ebp + arg_c]             # 004d2f50
    mov eax, dword ptr [edx + eax + field_cf]    # 004d2f53
    mov edx, dword ptr [ebp + arg_c]             # 004d2f5a
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d2f5d
    mov dword ptr [ebp - local_4], eax           # 004d2f61
    movsx eax, word ptr [ebp - local_14]         # 004d2f64
    shl eax, 0x4                                 # 004d2f68
    movsx ecx, word ptr [ebp + arg_24]           # 004d2f6b
    mov edx, dword ptr [ebp + arg_c]             # 004d2f6f
    mov eax, dword ptr [edx + eax + field_c3]    # 004d2f72
    mov edx, dword ptr [ebp + arg_c]             # 004d2f79
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d2f7c
    mov dword ptr [ebp - local_10], eax          # 004d2f80
    movsx eax, word ptr [ebp - local_14]         # 004d2f83
    shl eax, 0x4                                 # 004d2f87
    movsx ecx, word ptr [ebp + arg_24]           # 004d2f8a
    mov edx, dword ptr [ebp + arg_c]             # 004d2f8e
    mov eax, dword ptr [edx + eax + field_cb]    # 004d2f91
    mov edx, dword ptr [ebp + arg_c]             # 004d2f98
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d2f9b
    mov dword ptr [ebp - local_8], eax           # 004d2f9f
    jmp.d8 L_004d2fd4                            # 004d2fa2
L_004d2fa4:
    # block 0x004d2fa4: entered by je at 0x004d2ef9; jge at 0x004d2f0b, 11 instruction(s), ends with backward jump to 0x004d2c85
    mov eax, dword ptr [ebp + arg_c]             # 004d2fa4
    movsx ecx, word ptr [eax + field_4f]         # 004d2fa7
    mov edx, dword ptr [0x63a8e0]                # 004d2fab
    {load} add edx, ecx                          # 004d2fb1
    mov dword ptr [0x63a8e0], edx                # 004d2fb3
    mov eax, dword ptr [ebp + arg_c]             # 004d2fb9
    movsx ecx, word ptr [eax + field_4f]         # 004d2fbc
    mov edx, dword ptr [0x63a8e0]                # 004d2fc0
    lea eax, [edx + ecx - field_minus_1]         # 004d2fc6
    mov dword ptr [0x63a8e8], eax                # 004d2fca
    jmp.d32 L_004d2c85                           # 004d2fcf
L_004d2fd4:
    # block 0x004d2fd4: entered by jmp at 0x004d2d36; jmp at 0x004d2e0d; jmp at 0x004d2ee3; jmp at 0x004d2fa2, 38 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004d2c85
    movsx ecx, word ptr [ebp - local_14]         # 004d2fd4
    mov edx, dword ptr [ebp + arg_10]            # 004d2fd8
    movsx eax, word ptr [edx + 4*ecx + field_2]  # 004d2fdb
    mov ecx, dword ptr [0x63a8ec]                # 004d2fe0
    {load} sub ecx, eax                          # 004d2fe6
    add ecx, 0x1                                 # 004d2fe8
    mov dword ptr [0x63a8e4], ecx                # 004d2feb
    movsx edx, word ptr [ebp - local_14]         # 004d2ff1
    mov eax, dword ptr [ebp + arg_10]            # 004d2ff5
    movsx ecx, word ptr [eax + 4*edx]            # 004d2ff8
    mov edx, dword ptr [0x63a8e0]                # 004d2ffc
    lea eax, [edx + ecx - field_minus_1]         # 004d3002
    mov dword ptr [0x63a8e8], eax                # 004d3006
    push 0x55a37c                                # 004d300b
    push 0x63a8e0                                # 004d3010
    lea ecx, [ebp - local_10]                    # 004d3015
    push ecx                                     # 004d3018
    mov edx, dword ptr [ebp + arg_20]            # 004d3019
    push edx                                     # 004d301c
    mov eax, dword ptr [ebp + arg_1c]            # 004d301d
    push eax                                     # 004d3020
    mov ecx, 0x5cf659                            # 004d3021
    call FUN_004c5d4b                            # 004d3026
    movsx ecx, word ptr [ebp - local_14]         # 004d302b
    mov edx, dword ptr [ebp + arg_10]            # 004d302f
    movsx eax, word ptr [edx + 4*ecx]            # 004d3032
    mov ecx, dword ptr [ebp + arg_c]             # 004d3036
    movsx edx, word ptr [ecx + field_51]         # 004d3039
    add edx, dword ptr [0x63a8e0]                # 004d303d
    {load} add edx, eax                          # 004d3043
    mov dword ptr [0x63a8e0], edx                # 004d3045
    movsx eax, word ptr [ebp - local_14]         # 004d304b
    mov ecx, dword ptr [ebp + arg_10]            # 004d304f
    movsx edx, word ptr [ecx + 4*eax]            # 004d3052
    mov eax, dword ptr [0x63a8e0]                # 004d3056
    lea ecx, [eax + edx - field_minus_1]         # 004d305b
    mov dword ptr [0x63a8e8], ecx                # 004d305f
    jmp.d32 L_004d2c85                           # 004d3065
L_004d306a:
    # block 0x004d306a: entered by je at 0x004d2c96, 4 instruction(s), ends with ret
    mov eax, 0x63a8e0                            # 004d306a
    {load} mov esp, ebp                          # 004d306f
    pop ebp                                      # 004d3071
    ret                                          # 004d3072

