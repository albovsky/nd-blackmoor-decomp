# FUN_004a3beb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3beb
# extent:       0x004a3beb-0x004a3f40 (853 code bytes)
# span:         0x004a3beb-0x004a3f40 (code 853, tables 0, padding 0)
# sha256:       45ff1fe0951cce5a11b47e48c935cf45b3577cf65bbab0ba730013ec99138a2a
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3beb
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_230, field_234, field_238, field_23c, field_240, field_244, field_248, field_24c, field_250, field_254, field_272, field_288 and 1 more; [ecx + n] field_218, field_21c, field_220, field_224, field_228, field_22c, field_230, field_234, field_238, field_23c, field_240, field_244 and 5 more; [edx + n] field_228, field_22c, field_230, field_234, field_248, field_24c, field_250, field_254, field_280, field_284, field_830, field_832
# callees:      calls FUN_004a3aec
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25b.c:m4a3f40_hit_test (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 197 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_218, 0x218  # offset +0x218
.equ field_21c, 0x21c  # offset +0x21c
.equ field_220, 0x220  # offset +0x220
.equ field_224, 0x224  # offset +0x224
.equ field_228, 0x228  # offset +0x228
.equ field_22c, 0x22c  # offset +0x22c
.equ field_230, 0x230  # offset +0x230
.equ field_234, 0x234  # offset +0x234
.equ field_238, 0x238  # offset +0x238
.equ field_23c, 0x23c  # offset +0x23c
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254
.equ field_272, 0x272  # offset +0x272
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_830, 0x830  # offset +0x830
.equ field_832, 0x832  # offset +0x832
.equ field_834, 0x834  # offset +0x834
.equ field_836, 0x836  # offset +0x836

# --- external targets -----------------------------------------------
.set FUN_004a3aec, .text + (0x004a3aec - 0x401000)

.org 0x004a3beb - 0x401000
.globl FUN_004a3beb
FUN_004a3beb:
    # block 0x004a3beb: entry, 27 instruction(s), ends with je to 0x004a3db3 (forward)
    push ebp                                     # 004a3beb
    {load} mov ebp, esp                          # 004a3bec
    sub esp, 0xc                                 # 004a3bee
    mov dword ptr [ebp - local_c], ecx           # 004a3bf1
    mov eax, dword ptr [ebp - local_c]           # 004a3bf4
    mov ecx, dword ptr [ebp - local_c]           # 004a3bf7
    mov eax, dword ptr [eax + field_288]         # 004a3bfa
    sub eax, dword ptr [ecx + field_280]         # 004a3c00
    cdq                                          # 004a3c06
    {load} sub eax, edx                          # 004a3c07
    sar eax                                      # 004a3c09
    mov edx, dword ptr [ebp - local_c]           # 004a3c0b
    add eax, dword ptr [edx + field_280]         # 004a3c0e
    mov dword ptr [ebp - local_8], eax           # 004a3c14
    mov eax, dword ptr [ebp - local_c]           # 004a3c17
    mov ecx, dword ptr [ebp - local_c]           # 004a3c1a
    mov eax, dword ptr [eax + field_28c]         # 004a3c1d
    sub eax, dword ptr [ecx + field_284]         # 004a3c23
    cdq                                          # 004a3c29
    {load} sub eax, edx                          # 004a3c2a
    sar eax                                      # 004a3c2c
    mov edx, dword ptr [ebp - local_c]           # 004a3c2e
    add eax, dword ptr [edx + field_284]         # 004a3c31
    mov dword ptr [ebp - local_4], eax           # 004a3c37
    mov eax, dword ptr [ebp - local_c]           # 004a3c3a
    cmp dword ptr [eax + field_272], 0x0         # 004a3c3d
    je.d32 L_004a3db3                            # 004a3c44
    # block 0x004a3c4a: entered by fall-through of je at 0x004a3c44, 81 instruction(s), calls FUN_004a3aec, ends with forward jump to 0x004a3f3c
    mov ecx, dword ptr [ebp - local_c]           # 004a3c4a
    mov edx, dword ptr [ebp - local_c]           # 004a3c4d
    mov eax, dword ptr [edx + field_22c]         # 004a3c50
    mov dword ptr [ecx + field_21c], eax         # 004a3c56
    mov ecx, dword ptr [ebp - local_c]           # 004a3c5c
    mov edx, dword ptr [ebp - local_c]           # 004a3c5f
    mov eax, dword ptr [edx + field_234]         # 004a3c62
    mov dword ptr [ecx + field_224], eax         # 004a3c68
    mov ecx, dword ptr [ebp - local_c]           # 004a3c6e
    mov edx, dword ptr [ebp - local_c]           # 004a3c71
    mov eax, dword ptr [edx + field_228]         # 004a3c74
    mov dword ptr [ecx + field_218], eax         # 004a3c7a
    mov ecx, dword ptr [ebp - local_c]           # 004a3c80
    mov edx, dword ptr [ebp - local_c]           # 004a3c83
    mov eax, dword ptr [edx + field_230]         # 004a3c86
    mov dword ptr [ecx + field_220], eax         # 004a3c8c
    mov ecx, dword ptr [ebp - local_c]           # 004a3c92
    mov edx, dword ptr [ebp - local_c]           # 004a3c95
    mov eax, dword ptr [edx + field_24c]         # 004a3c98
    mov dword ptr [ecx + field_23c], eax         # 004a3c9e
    mov ecx, dword ptr [ebp - local_c]           # 004a3ca4
    mov edx, dword ptr [ebp - local_c]           # 004a3ca7
    mov eax, dword ptr [edx + field_254]         # 004a3caa
    mov dword ptr [ecx + field_244], eax         # 004a3cb0
    mov ecx, dword ptr [ebp - local_c]           # 004a3cb6
    mov edx, dword ptr [ebp - local_c]           # 004a3cb9
    mov eax, dword ptr [edx + field_248]         # 004a3cbc
    mov dword ptr [ecx + field_238], eax         # 004a3cc2
    mov ecx, dword ptr [ebp - local_c]           # 004a3cc8
    mov edx, dword ptr [ebp - local_c]           # 004a3ccb
    mov eax, dword ptr [edx + field_250]         # 004a3cce
    mov dword ptr [ecx + field_240], eax         # 004a3cd4
    mov ecx, dword ptr [ebp - local_c]           # 004a3cda
    movsx edx, word ptr [ecx + field_836]        # 004a3cdd
    mov eax, dword ptr [ebp - local_4]           # 004a3ce4
    {load} sub eax, edx                          # 004a3ce7
    mov ecx, dword ptr [ebp - local_c]           # 004a3ce9
    mov dword ptr [ecx + field_22c], eax         # 004a3cec
    mov edx, dword ptr [ebp - local_c]           # 004a3cf2
    movsx eax, word ptr [edx + field_832]        # 004a3cf5
    mov ecx, dword ptr [ebp - local_c]           # 004a3cfc
    mov edx, dword ptr [ecx + field_22c]         # 004a3cff
    {load} add edx, eax                          # 004a3d05
    mov eax, dword ptr [ebp - local_c]           # 004a3d07
    mov dword ptr [eax + field_234], edx         # 004a3d0a
    mov ecx, dword ptr [ebp - local_c]           # 004a3d10
    movsx edx, word ptr [ecx + field_834]        # 004a3d13
    mov eax, dword ptr [ebp - local_8]           # 004a3d1a
    {load} sub eax, edx                          # 004a3d1d
    mov ecx, dword ptr [ebp - local_c]           # 004a3d1f
    mov dword ptr [ecx + field_228], eax         # 004a3d22
    mov edx, dword ptr [ebp - local_c]           # 004a3d28
    movsx eax, word ptr [edx + field_830]        # 004a3d2b
    mov ecx, dword ptr [ebp - local_c]           # 004a3d32
    mov edx, dword ptr [ecx + field_228]         # 004a3d35
    {load} add edx, eax                          # 004a3d3b
    mov eax, dword ptr [ebp - local_c]           # 004a3d3d
    mov dword ptr [eax + field_230], edx         # 004a3d40
    mov ecx, dword ptr [ebp - local_c]           # 004a3d46
    call FUN_004a3aec                            # 004a3d49
    mov ecx, dword ptr [ebp - local_c]           # 004a3d4e
    mov edx, dword ptr [ecx + field_22c]         # 004a3d51
    add edx, dword ptr [0x58318a]                # 004a3d57
    mov eax, dword ptr [ebp - local_c]           # 004a3d5d
    mov dword ptr [eax + field_24c], edx         # 004a3d60
    mov ecx, dword ptr [ebp - local_c]           # 004a3d66
    mov edx, dword ptr [ecx + field_234]         # 004a3d69
    add edx, dword ptr [0x58318a]                # 004a3d6f
    mov eax, dword ptr [ebp - local_c]           # 004a3d75
    mov dword ptr [eax + field_254], edx         # 004a3d78
    mov ecx, dword ptr [ebp - local_c]           # 004a3d7e
    mov edx, dword ptr [ecx + field_228]         # 004a3d81
    add edx, dword ptr [0x583186]                # 004a3d87
    mov eax, dword ptr [ebp - local_c]           # 004a3d8d
    mov dword ptr [eax + field_248], edx         # 004a3d90
    mov ecx, dword ptr [ebp - local_c]           # 004a3d96
    mov edx, dword ptr [ecx + field_230]         # 004a3d99
    add edx, dword ptr [0x583186]                # 004a3d9f
    mov eax, dword ptr [ebp - local_c]           # 004a3da5
    mov dword ptr [eax + field_250], edx         # 004a3da8
    jmp.d32 L_004a3f3c                           # 004a3dae
L_004a3db3:
    # block 0x004a3db3: entered by je at 0x004a3c44, 86 instruction(s), calls FUN_004a3aec, falls into the block at 0x004a3f3c
    mov ecx, dword ptr [ebp - local_c]           # 004a3db3
    movsx edx, word ptr [ecx + field_836]        # 004a3db6
    mov eax, dword ptr [ebp - local_4]           # 004a3dbd
    {load} sub eax, edx                          # 004a3dc0
    mov ecx, dword ptr [ebp - local_c]           # 004a3dc2
    mov dword ptr [ecx + field_22c], eax         # 004a3dc5
    mov edx, dword ptr [ebp - local_c]           # 004a3dcb
    movsx eax, word ptr [edx + field_832]        # 004a3dce
    mov ecx, dword ptr [ebp - local_c]           # 004a3dd5
    mov edx, dword ptr [ecx + field_22c]         # 004a3dd8
    {load} add edx, eax                          # 004a3dde
    mov eax, dword ptr [ebp - local_c]           # 004a3de0
    mov dword ptr [eax + field_234], edx         # 004a3de3
    mov ecx, dword ptr [ebp - local_c]           # 004a3de9
    movsx edx, word ptr [ecx + field_834]        # 004a3dec
    mov eax, dword ptr [ebp - local_8]           # 004a3df3
    {load} sub eax, edx                          # 004a3df6
    mov ecx, dword ptr [ebp - local_c]           # 004a3df8
    mov dword ptr [ecx + field_228], eax         # 004a3dfb
    mov edx, dword ptr [ebp - local_c]           # 004a3e01
    movsx eax, word ptr [edx + field_830]        # 004a3e04
    mov ecx, dword ptr [ebp - local_c]           # 004a3e0b
    mov edx, dword ptr [ecx + field_228]         # 004a3e0e
    {load} add edx, eax                          # 004a3e14
    mov eax, dword ptr [ebp - local_c]           # 004a3e16
    mov dword ptr [eax + field_230], edx         # 004a3e19
    mov ecx, dword ptr [ebp - local_c]           # 004a3e1f
    call FUN_004a3aec                            # 004a3e22
    mov ecx, dword ptr [ebp - local_c]           # 004a3e27
    mov edx, dword ptr [ebp - local_c]           # 004a3e2a
    mov eax, dword ptr [edx + field_22c]         # 004a3e2d
    mov dword ptr [ecx + field_21c], eax         # 004a3e33
    mov ecx, dword ptr [ebp - local_c]           # 004a3e39
    mov edx, dword ptr [ebp - local_c]           # 004a3e3c
    mov eax, dword ptr [edx + field_234]         # 004a3e3f
    mov dword ptr [ecx + field_224], eax         # 004a3e45
    mov ecx, dword ptr [ebp - local_c]           # 004a3e4b
    mov edx, dword ptr [ebp - local_c]           # 004a3e4e
    mov eax, dword ptr [edx + field_228]         # 004a3e51
    mov dword ptr [ecx + field_218], eax         # 004a3e57
    mov ecx, dword ptr [ebp - local_c]           # 004a3e5d
    mov edx, dword ptr [ebp - local_c]           # 004a3e60
    mov eax, dword ptr [edx + field_230]         # 004a3e63
    mov dword ptr [ecx + field_220], eax         # 004a3e69
    mov ecx, dword ptr [ebp - local_c]           # 004a3e6f
    mov edx, dword ptr [ecx + field_22c]         # 004a3e72
    add edx, dword ptr [0x58318a]                # 004a3e78
    mov eax, dword ptr [ebp - local_c]           # 004a3e7e
    mov dword ptr [eax + field_24c], edx         # 004a3e81
    mov ecx, dword ptr [ebp - local_c]           # 004a3e87
    mov edx, dword ptr [ecx + field_234]         # 004a3e8a
    add edx, dword ptr [0x58318a]                # 004a3e90
    mov eax, dword ptr [ebp - local_c]           # 004a3e96
    mov dword ptr [eax + field_254], edx         # 004a3e99
    mov ecx, dword ptr [ebp - local_c]           # 004a3e9f
    mov edx, dword ptr [ecx + field_228]         # 004a3ea2
    add edx, dword ptr [0x583186]                # 004a3ea8
    mov eax, dword ptr [ebp - local_c]           # 004a3eae
    mov dword ptr [eax + field_248], edx         # 004a3eb1
    mov ecx, dword ptr [ebp - local_c]           # 004a3eb7
    mov edx, dword ptr [ecx + field_230]         # 004a3eba
    add edx, dword ptr [0x583186]                # 004a3ec0
    mov eax, dword ptr [ebp - local_c]           # 004a3ec6
    mov dword ptr [eax + field_250], edx         # 004a3ec9
    mov ecx, dword ptr [ebp - local_c]           # 004a3ecf
    mov edx, dword ptr [ecx + field_21c]         # 004a3ed2
    add edx, dword ptr [0x58318a]                # 004a3ed8
    mov eax, dword ptr [ebp - local_c]           # 004a3ede
    mov dword ptr [eax + field_23c], edx         # 004a3ee1
    mov ecx, dword ptr [ebp - local_c]           # 004a3ee7
    mov edx, dword ptr [ecx + field_224]         # 004a3eea
    add edx, dword ptr [0x58318a]                # 004a3ef0
    mov eax, dword ptr [ebp - local_c]           # 004a3ef6
    mov dword ptr [eax + field_244], edx         # 004a3ef9
    mov ecx, dword ptr [ebp - local_c]           # 004a3eff
    mov edx, dword ptr [ecx + field_218]         # 004a3f02
    add edx, dword ptr [0x583186]                # 004a3f08
    mov eax, dword ptr [ebp - local_c]           # 004a3f0e
    mov dword ptr [eax + field_238], edx         # 004a3f11
    mov ecx, dword ptr [ebp - local_c]           # 004a3f17
    mov edx, dword ptr [ecx + field_220]         # 004a3f1a
    add edx, dword ptr [0x583186]                # 004a3f20
    mov eax, dword ptr [ebp - local_c]           # 004a3f26
    mov dword ptr [eax + field_240], edx         # 004a3f29
    mov ecx, dword ptr [ebp - local_c]           # 004a3f2f
    mov dword ptr [ecx + field_272], 0x1         # 004a3f32
L_004a3f3c:
    # block 0x004a3f3c: entered by jmp at 0x004a3dae, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a3f3c
    pop ebp                                      # 004a3f3e
    ret                                          # 004a3f3f

