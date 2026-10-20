# FUN_004f6cdc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6cdc
# extent:       0x004f6cdc-0x004f6ef4 (536 code bytes)
# span:         0x004f6cdc-0x004f6ef4 (code 536, tables 0, padding 0)
# sha256:       206cc5c712e3dadcf61cfc307b2ae56da41c55993a12e6615b3780f8d4ee1c21
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_start_with_frame_sync
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:375 says "0x4f6cdc(channel, frames, param): start the sound with frame sync."
# name-note:    Starts the sound with frame sync for a channel, frames and parameter.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_176, field_182, field_28f, field_2e1, field_3be, field_3c2; [ecx + n] field_17a, field_186, field_2ed, field_3be, field_3c2; [edx + n] field_144, field_162, field_176, field_17e, field_3be, field_3c2, field_3ce
# callees:      calls FUN_004f709c, FUN_0050ce04, FUN_004f6334, FUN_004f6059, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 132 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_144, 0x144  # offset +0x144
.equ field_162, 0x162  # offset +0x162
.equ field_176, 0x176  # offset +0x176
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_186, 0x186  # offset +0x186
.equ field_28f, 0x28f  # offset +0x28f
.equ field_2e1, 0x2e1  # offset +0x2e1
.equ field_2ed, 0x2ed  # offset +0x2ed
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004f6cdc - 0x401000
.globl FUN_004f6cdc
FUN_004f6cdc:
    # block 0x004f6cdc: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f6d4a (forward)
    push ebp                                     # 004f6cdc
    {load} mov ebp, esp                          # 004f6cdd
    sub esp, 0x20                                # 004f6cdf
    mov dword ptr [ebp - local_8], ecx           # 004f6ce2
    mov eax, dword ptr [ebp - local_8]           # 004f6ce5
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6ce8
    mov ecx, dword ptr [ebp + arg_8]             # 004f6cf2
    imul ecx, ecx, 0x5bb                         # 004f6cf5
    mov edx, dword ptr [ebp - local_8]           # 004f6cfb
    mov eax, dword ptr [edx + field_3ce]         # 004f6cfe
    {load} add eax, ecx                          # 004f6d04
    mov dword ptr [ebp - local_4], eax           # 004f6d06
    mov ecx, dword ptr [ebp - local_8]           # 004f6d09
    mov dword ptr [ecx + field_3be], 0x1         # 004f6d0c
    mov ecx, dword ptr [ebp - local_8]           # 004f6d16
    call FUN_004f709c                            # 004f6d19
    test eax, eax                                # 004f6d1e
    jne.d8 L_004f6d4a                            # 004f6d20
    # block 0x004f6d22: entered by fall-through of jne at 0x004f6d20, 7 instruction(s), ends with forward jump to 0x004f6eee
    mov edx, dword ptr [ebp - local_8]           # 004f6d22
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f6d25
    mov eax, dword ptr [ebp - local_8]           # 004f6d2f
    mov dword ptr [eax + field_3be], 0x0         # 004f6d32
    mov ecx, dword ptr [ebp - local_8]           # 004f6d3c
    mov eax, dword ptr [ecx + field_3be]         # 004f6d3f
    jmp.d32 L_004f6eee                           # 004f6d45
L_004f6d4a:
    # block 0x004f6d4a: entered by jne at 0x004f6d20, 3 instruction(s), ends with je to 0x004f6d62 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f6d4a
    cmp dword ptr [edx + field_162], 0x0         # 004f6d4d
    je.d8 L_004f6d62                             # 004f6d54
    # block 0x004f6d56: entered by fall-through of je at 0x004f6d54, 3 instruction(s), ends with jne to 0x004f6d8a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f6d56
    cmp dword ptr [eax + field_28f], 0x0         # 004f6d59
    jne.d8 L_004f6d8a                            # 004f6d60
L_004f6d62:
    # block 0x004f6d62: entered by je at 0x004f6d54; fall-through of jne at 0x004f6d60, 7 instruction(s), ends with forward jump to 0x004f6eee
    mov ecx, dword ptr [ebp - local_8]           # 004f6d62
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f6d65
    mov edx, dword ptr [ebp - local_8]           # 004f6d6f
    mov dword ptr [edx + field_3be], 0x0         # 004f6d72
    mov eax, dword ptr [ebp - local_8]           # 004f6d7c
    mov eax, dword ptr [eax + field_3be]         # 004f6d7f
    jmp.d32 L_004f6eee                           # 004f6d85
L_004f6d8a:
    # block 0x004f6d8a: entered by jne at 0x004f6d60, 4 instruction(s), ends with jg to 0x004f6dbf (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004f6d8a
    and ecx, 0xffff                              # 004f6d8d
    test ecx, ecx                                # 004f6d93
    jg.d8 L_004f6dbf                             # 004f6d95
    # block 0x004f6d97: entered by fall-through of jg at 0x004f6d95, 7 instruction(s), ends with forward jump to 0x004f6eee
    mov edx, dword ptr [ebp - local_8]           # 004f6d97
    mov dword ptr [edx + field_3c2], 0x3f8       # 004f6d9a
    mov eax, dword ptr [ebp - local_8]           # 004f6da4
    mov dword ptr [eax + field_3be], 0x0         # 004f6da7
    mov ecx, dword ptr [ebp - local_8]           # 004f6db1
    mov eax, dword ptr [ecx + field_3be]         # 004f6db4
    jmp.d32 L_004f6eee                           # 004f6dba
L_004f6dbf:
    # block 0x004f6dbf: entered by jg at 0x004f6d95, 43 instruction(s), calls FUN_0050ce04, FUN_004f6334, ends with jne to 0x004f6ea2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f6dbf
    {load} xor eax, eax                          # 004f6dc2
    mov ax, word ptr [edx + field_144]           # 004f6dc4
    mov dword ptr [ebp - local_c], eax           # 004f6dcb
    fild dword ptr [ebp - local_c]               # 004f6dce
    fstp dword ptr [ebp - local_10]              # 004f6dd1
    mov ecx, dword ptr [ebp - local_4]           # 004f6dd4
    {load} xor edx, edx                          # 004f6dd7
    mov dx, word ptr [ecx + field_2ed]           # 004f6dd9
    mov dword ptr [ebp - local_14], edx          # 004f6de0
    fild dword ptr [ebp - local_14]              # 004f6de3
    fstp dword ptr [ebp - local_18]              # 004f6de6
    fld dword ptr [ebp - local_10]               # 004f6de9
    fmul dword ptr [ebp - local_18]              # 004f6dec
    mov eax, dword ptr [ebp - local_4]           # 004f6def
    {load} xor ecx, ecx                          # 004f6df2
    mov cx, word ptr [eax + field_2e1]           # 004f6df4
    mov dword ptr [ebp - local_1c], ecx          # 004f6dfb
    fild dword ptr [ebp - local_1c]              # 004f6dfe
    fstp dword ptr [ebp - local_20]              # 004f6e01
    fmul dword ptr [ebp - local_20]              # 004f6e04
    fdiv qword ptr [0x52caa8]                    # 004f6e07
    fdiv qword ptr [0x52e508]                    # 004f6e0d
    call FUN_0050ce04                            # 004f6e13
    mov edx, dword ptr [ebp - local_4]           # 004f6e18
    mov dword ptr [edx + field_176], eax         # 004f6e1b
    mov eax, dword ptr [ebp + arg_c]             # 004f6e21
    and eax, 0xffff                              # 004f6e24
    mov ecx, dword ptr [ebp - local_4]           # 004f6e29
    mov dword ptr [ecx + field_17a], eax         # 004f6e2c
    mov edx, dword ptr [ebp - local_4]           # 004f6e32
    mov dword ptr [edx + field_17e], 0x0         # 004f6e35
    mov eax, dword ptr [ebp - local_4]           # 004f6e3f
    mov dword ptr [eax + field_182], 0x0         # 004f6e42
    mov ecx, dword ptr [ebp - local_4]           # 004f6e4c
    mov edx, dword ptr [ebp + arg_10]            # 004f6e4f
    mov dword ptr [ecx + field_186], edx         # 004f6e52
    mov eax, dword ptr [ebp + arg_8]             # 004f6e58
    push eax                                     # 004f6e5b
    mov ecx, dword ptr [ebp - local_8]           # 004f6e5c
    call FUN_004f6334                            # 004f6e5f
    test eax, eax                                # 004f6e64
    jne.d8 L_004f6ea2                            # 004f6e66
    # block 0x004f6e68: entered by fall-through of jne at 0x004f6e66, 6 instruction(s), calls FUN_004f6059, ends with jne to 0x004f6ea2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f6e68
    push ecx                                     # 004f6e6b
    mov ecx, dword ptr [ebp - local_8]           # 004f6e6c
    call FUN_004f6059                            # 004f6e6f
    test eax, eax                                # 004f6e74
    jne.d8 L_004f6ea2                            # 004f6e76
    # block 0x004f6e78: entered by fall-through of jne at 0x004f6e76, 9 instruction(s), ends with forward jump to 0x004f6eee
    mov edx, dword ptr [ebp - local_8]           # 004f6e78
    mov eax, dword ptr [ebp - local_8]           # 004f6e7b
    mov ecx, dword ptr [eax + field_3c2]         # 004f6e7e
    mov dword ptr [edx + field_3c2], ecx         # 004f6e84
    mov edx, dword ptr [ebp - local_8]           # 004f6e8a
    mov dword ptr [edx + field_3be], 0x0         # 004f6e8d
    mov eax, dword ptr [ebp - local_8]           # 004f6e97
    mov eax, dword ptr [eax + field_3be]         # 004f6e9a
    jmp.d8 L_004f6eee                            # 004f6ea0
L_004f6ea2:
    # block 0x004f6ea2: entered by jne at 0x004f6e66; jne at 0x004f6e76, 3 instruction(s), ends with je to 0x004f6ee5 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f6ea2
    test ecx, ecx                                # 004f6ea9
    je.d8 L_004f6ee5                             # 004f6eab
    # block 0x004f6ead: entered by fall-through of je at 0x004f6eab, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f6ee5
    mov edx, dword ptr [ebp + arg_10]            # 004f6ead
    push edx                                     # 004f6eb0
    mov eax, dword ptr [ebp - local_4]           # 004f6eb1
    mov ecx, dword ptr [eax + field_176]         # 004f6eb4
    push ecx                                     # 004f6eba
    mov edx, dword ptr [ebp - local_4]           # 004f6ebb
    add edx, 0x4                                 # 004f6ebe
    push edx                                     # 004f6ec1
    mov eax, dword ptr [ebp + arg_8]             # 004f6ec2
    push eax                                     # 004f6ec5
    push 0x55e938                                # 004f6ec6
    push 0x63888b                                # 004f6ecb
    call FUN_0050ca3e                            # 004f6ed0
    add esp, 0x18                                # 004f6ed5
    push 0x63888b                                # 004f6ed8
    call FUN_0044a2b7                            # 004f6edd
    add esp, 0x4                                 # 004f6ee2
L_004f6ee5:
    # block 0x004f6ee5: entered by je at 0x004f6eab, 2 instruction(s), falls into the block at 0x004f6eee
    mov ecx, dword ptr [ebp - local_8]           # 004f6ee5
    mov eax, dword ptr [ecx + field_3be]         # 004f6ee8
L_004f6eee:
    # block 0x004f6eee: entered by jmp at 0x004f6d45; jmp at 0x004f6d85; jmp at 0x004f6dba; jmp at 0x004f6ea0, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004f6eee
    pop ebp                                      # 004f6ef0
    ret 0xc                                      # 004f6ef1

