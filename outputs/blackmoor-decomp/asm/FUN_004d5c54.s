# FUN_004d5c54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5c54
# extent:       0x004d5c54-0x004d5f91 (829 code bytes)
# span:         0x004d5c54-0x004d5f91 (code 829, tables 0, padding 0)
# sha256:       cbef36e287ae9e710a850f25477cd70675fdad4e4686518ae65ac934f88c426f
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_load_save_screen_init
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d5c54.c.txt, not original source) refers to the data labelled s_DF_LOADSAVE_first_page_Surface_0055a660, s_LOAD_SAVE_0055a730, s_Load_Save_Text_Slot_0055a700
# name-note:    Loads the LOADSAVE surfaces (first page, non-first page, overlay, save confirmation, text slots) from CIFTREE and sets up the LOAD_SAVE render descriptor.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_293, field_94d6, field_94da, field_94de, field_94e2, field_950a, field_9522, field_9526, field_952a and 7 more; [ecx + n] field_28b, field_297, field_950a, field_9526, field_952a, field_952e, field_972c, field_9730, field_9734, field_9738, field_98a8; [edx + n] field_4, field_8, field_c, field_28f, field_94d6, field_94da, field_94de, field_94e2, field_950a, field_9522, field_952e, field_9724 and 4 more
# callees:      calls FUN_004c2790, FUN_004c2a8d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 214 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_28b, 0x28b  # offset +0x28b
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_94d6, 0x94d6  # offset +0x94d6
.equ field_94da, 0x94da  # offset +0x94da
.equ field_94de, 0x94de  # offset +0x94de
.equ field_94e2, 0x94e2  # offset +0x94e2
.equ field_950a, 0x950a  # offset +0x950a
.equ field_9522, 0x9522  # offset +0x9522
.equ field_9526, 0x9526  # offset +0x9526
.equ field_952a, 0x952a  # offset +0x952a
.equ field_952e, 0x952e  # offset +0x952e
.equ field_9724, 0x9724  # offset +0x9724
.equ field_9728, 0x9728  # offset +0x9728
.equ field_972c, 0x972c  # offset +0x972c
.equ field_9730, 0x9730  # offset +0x9730
.equ field_9734, 0x9734  # offset +0x9734
.equ field_9738, 0x9738  # offset +0x9738
.equ field_973c, 0x973c  # offset +0x973c
.equ field_9740, 0x9740  # offset +0x9740
.equ field_98a8, 0x98a8  # offset +0x98a8

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)

.org 0x004d5c54 - 0x401000
.globl FUN_004d5c54
FUN_004d5c54:
    # block 0x004d5c54: entry, 9 instruction(s), ends with jne to 0x004d5c8f (forward)
    push ebp                                     # 004d5c54
    {load} mov ebp, esp                          # 004d5c55
    push ecx                                     # 004d5c57
    push esi                                     # 004d5c58
    push edi                                     # 004d5c59
    mov dword ptr [ebp - local_4], ecx           # 004d5c5a
    mov eax, dword ptr [ebp - local_4]           # 004d5c5d
    cmp dword ptr [eax + field_94d6], 0x0        # 004d5c60
    jne.d8 L_004d5c8f                            # 004d5c67
    # block 0x004d5c69: entered by fall-through of jne at 0x004d5c67, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004d5c8f
    push 0x55a660                                # 004d5c69
    push 0x6                                     # 004d5c6e
    mov ecx, dword ptr [ebp - local_4]           # 004d5c70
    add ecx, 0x8                                 # 004d5c73
    push ecx                                     # 004d5c76
    push 0x55a680                                # 004d5c77
    mov ecx, 0x5cf659                            # 004d5c7c
    call FUN_004c2790                            # 004d5c81
    mov edx, dword ptr [ebp - local_4]           # 004d5c86
    mov dword ptr [edx + field_94d6], eax        # 004d5c89
L_004d5c8f:
    # block 0x004d5c8f: entered by jne at 0x004d5c67, 3 instruction(s), ends with jne to 0x004d5cc1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5c8f
    cmp dword ptr [eax + field_94da], 0x0        # 004d5c92
    jne.d8 L_004d5cc1                            # 004d5c99
    # block 0x004d5c9b: entered by fall-through of jne at 0x004d5c99, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004d5cc1
    push 0x55a688                                # 004d5c9b
    push 0x6                                     # 004d5ca0
    mov ecx, dword ptr [ebp - local_4]           # 004d5ca2
    add ecx, 0x29                                # 004d5ca5
    push ecx                                     # 004d5ca8
    push 0x55a6ac                                # 004d5ca9
    mov ecx, 0x5cf659                            # 004d5cae
    call FUN_004c2790                            # 004d5cb3
    mov edx, dword ptr [ebp - local_4]           # 004d5cb8
    mov dword ptr [edx + field_94da], eax        # 004d5cbb
L_004d5cc1:
    # block 0x004d5cc1: entered by jne at 0x004d5c99, 3 instruction(s), ends with jne to 0x004d5cf3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5cc1
    cmp dword ptr [eax + field_94de], 0x0        # 004d5cc4
    jne.d8 L_004d5cf3                            # 004d5ccb
    # block 0x004d5ccd: entered by fall-through of jne at 0x004d5ccb, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004d5cf3
    push 0x55a6b4                                # 004d5ccd
    push 0x6                                     # 004d5cd2
    mov ecx, dword ptr [ebp - local_4]           # 004d5cd4
    add ecx, 0x4a                                # 004d5cd7
    push ecx                                     # 004d5cda
    push 0x55a6d0                                # 004d5cdb
    mov ecx, 0x5cf659                            # 004d5ce0
    call FUN_004c2790                            # 004d5ce5
    mov edx, dword ptr [ebp - local_4]           # 004d5cea
    mov dword ptr [edx + field_94de], eax        # 004d5ced
L_004d5cf3:
    # block 0x004d5cf3: entered by jne at 0x004d5ccb, 3 instruction(s), ends with jne to 0x004d5d28 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5cf3
    cmp dword ptr [eax + field_950a], 0x0        # 004d5cf6
    jne.d8 L_004d5d28                            # 004d5cfd
    # block 0x004d5cff: entered by fall-through of jne at 0x004d5cfd, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004d5d28
    push 0x55a6d8                                # 004d5cff
    push 0x6                                     # 004d5d04
    mov ecx, dword ptr [ebp - local_4]           # 004d5d06
    add ecx, 0x2ce                               # 004d5d09
    push ecx                                     # 004d5d0f
    push 0x55a6f8                                # 004d5d10
    mov ecx, 0x5cf659                            # 004d5d15
    call FUN_004c2790                            # 004d5d1a
    mov edx, dword ptr [ebp - local_4]           # 004d5d1f
    mov dword ptr [edx + field_950a], eax        # 004d5d22
L_004d5d28:
    # block 0x004d5d28: entered by jne at 0x004d5cfd, 26 instruction(s), ends with forward jump to 0x004d5dae
    mov eax, dword ptr [ebp - local_4]           # 004d5d28
    mov ecx, dword ptr [ebp - local_4]           # 004d5d2b
    mov edx, dword ptr [eax + field_293]         # 004d5d2e
    sub edx, dword ptr [ecx + field_28b]         # 004d5d34
    add edx, 0x1                                 # 004d5d3a
    mov eax, dword ptr [ebp - local_4]           # 004d5d3d
    mov dword ptr [eax + field_9522], edx        # 004d5d40
    mov ecx, dword ptr [ebp - local_4]           # 004d5d46
    mov edx, dword ptr [ebp - local_4]           # 004d5d49
    mov eax, dword ptr [ecx + field_297]         # 004d5d4c
    sub eax, dword ptr [edx + field_28f]         # 004d5d52
    add eax, 0x1                                 # 004d5d58
    mov ecx, dword ptr [ebp - local_4]           # 004d5d5b
    mov dword ptr [ecx + field_9526], eax        # 004d5d5e
    mov edx, dword ptr [ebp - local_4]           # 004d5d64
    mov eax, dword ptr [edx + field_9522]        # 004d5d67
    shl eax                                      # 004d5d6d
    mov ecx, dword ptr [ebp - local_4]           # 004d5d6f
    mov dword ptr [ecx + field_952a], eax        # 004d5d72
    mov edx, dword ptr [ebp - local_4]           # 004d5d78
    mov eax, dword ptr [ebp - local_4]           # 004d5d7b
    mov ecx, dword ptr [eax + field_9526]        # 004d5d7e
    mov dword ptr [edx + field_952e], ecx        # 004d5d84
    mov edx, dword ptr [ebp - local_4]           # 004d5d8a
    mov dword ptr [edx + field_98a8], 0x0        # 004d5d8d
    jmp.d8 L_004d5dae                            # 004d5d97
L_004d5d99:
    # block 0x004d5d99: entered by jmp at 0x004d5e0a, 5 instruction(s), falls into the block at 0x004d5dae
    mov eax, dword ptr [ebp - local_4]           # 004d5d99
    mov ecx, dword ptr [eax + field_98a8]        # 004d5d9c
    add ecx, 0x1                                 # 004d5da2
    mov edx, dword ptr [ebp - local_4]           # 004d5da5
    mov dword ptr [edx + field_98a8], ecx        # 004d5da8
L_004d5dae:
    # block 0x004d5dae: entered by jmp at 0x004d5d97, 3 instruction(s), ends with jge to 0x004d5e0c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5dae
    cmp dword ptr [eax + field_98a8], 0xa        # 004d5db1
    jge.d8 L_004d5e0c                            # 004d5db8
    # block 0x004d5dba: entered by fall-through of jge at 0x004d5db8, 5 instruction(s), ends with jne to 0x004d5e0a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d5dba
    mov edx, dword ptr [ecx + field_98a8]        # 004d5dbd
    mov eax, dword ptr [ebp - local_4]           # 004d5dc3
    cmp dword ptr [eax + 4*edx + field_94e2], 0x0 # 004d5dc6
    jne.d8 L_004d5e0a                            # 004d5dce
    # block 0x004d5dd0: entered by fall-through of jne at 0x004d5dce, 14 instruction(s), calls FUN_004c2a8d, falls into the block at 0x004d5e0a
    push 0x55a700                                # 004d5dd0
    push 0x8                                     # 004d5dd5
    mov ecx, dword ptr [ebp - local_4]           # 004d5dd7
    mov dx, word ptr [ecx + field_952e]          # 004d5dda
    push edx                                     # 004d5de1
    mov eax, dword ptr [ebp - local_4]           # 004d5de2
    mov cx, word ptr [eax + field_952a]          # 004d5de5
    push ecx                                     # 004d5dec
    mov ecx, 0x5cf659                            # 004d5ded
    call FUN_004c2a8d                            # 004d5df2
    mov edx, dword ptr [ebp - local_4]           # 004d5df7
    mov ecx, dword ptr [edx + field_98a8]        # 004d5dfa
    mov edx, dword ptr [ebp - local_4]           # 004d5e00
    mov dword ptr [edx + 4*ecx + field_94e2], eax # 004d5e03
L_004d5e0a:
    # block 0x004d5e0a: entered by jne at 0x004d5dce, 1 instruction(s), ends with backward jump to 0x004d5d99
    jmp.d8 L_004d5d99                            # 004d5e0a
L_004d5e0c:
    # block 0x004d5e0c: entered by jge at 0x004d5db8, 2 instruction(s), ends with jne to 0x004d5e35 (forward)
    cmp dword ptr [0x5d0377], 0x0                # 004d5e0c
    jne.d8 L_004d5e35                            # 004d5e13
    # block 0x004d5e15: entered by fall-through of jne at 0x004d5e13, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004d5e35
    push 0x55a714                                # 004d5e15
    push 0x6                                     # 004d5e1a
    push 0x5b06aa                                # 004d5e1c
    push 0x55a728                                # 004d5e21
    mov ecx, 0x5cf659                            # 004d5e26
    call FUN_004c2790                            # 004d5e2b
    mov dword ptr [0x5d0377], eax                # 004d5e30
L_004d5e35:
    # block 0x004d5e35: entered by jne at 0x004d5e13, 93 instruction(s), ends with ret
    mov dword ptr [0x5d2eb7], 0x1                # 004d5e35
    mov dword ptr [0x5d2ebb], 0x4d999b           # 004d5e3f
    mov dword ptr [0x5d2ebf], 0x0                # 004d5e49
    mov dword ptr [0x5d2ec3], 0x0                # 004d5e53
    mov dword ptr [0x5d2ec7], 0x0                # 004d5e5d
    mov dword ptr [0x5d2ecb], 0x0                # 004d5e67
    mov dword ptr [0x5d2ecf], 0x1                # 004d5e71
    mov word ptr [0x5d2ed3], 0x0                 # 004d5e7b
    mov edi, 0x55a730                            # 004d5e84
    mov edx, 0x5d2ed9                            # 004d5e89
    or ecx, -0x1                                 # 004d5e8e
    {load} xor eax, eax                          # 004d5e91
    repne scasb al, byte ptr es:[edi]            # 004d5e93
    not ecx                                      # 004d5e95
    {load} sub edi, ecx                          # 004d5e97
    {load} mov esi, edi                          # 004d5e99
    {load} mov eax, ecx                          # 004d5e9b
    {load} mov edi, edx                          # 004d5e9d
    shr ecx, 0x2                                 # 004d5e9f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d5ea2
    {load} mov ecx, eax                          # 004d5ea4
    and ecx, 0x3                                 # 004d5ea6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d5ea9
    mov ecx, dword ptr [ebp - local_4]           # 004d5eab
    mov edx, dword ptr [ecx + field_950a]        # 004d5eae
    add edx, 0x35                                # 004d5eb4
    mov eax, dword ptr [ebp - local_4]           # 004d5eb7
    add eax, 0x9724                              # 004d5eba
    mov ecx, dword ptr [edx]                     # 004d5ebf
    mov dword ptr [eax], ecx                     # 004d5ec1
    mov ecx, dword ptr [edx + field_4]           # 004d5ec3
    mov dword ptr [eax + field_4], ecx           # 004d5ec6
    mov ecx, dword ptr [edx + field_8]           # 004d5ec9
    mov dword ptr [eax + field_8], ecx           # 004d5ecc
    mov edx, dword ptr [edx + field_c]           # 004d5ecf
    mov dword ptr [eax + field_c], edx           # 004d5ed2
    movsx eax, word ptr [0x63988b]               # 004d5ed5
    add eax, 0x1                                 # 004d5edc
    cdq                                          # 004d5edf
    {load} sub eax, edx                          # 004d5ee0
    {load} mov ecx, eax                          # 004d5ee2
    sar ecx                                      # 004d5ee4
    mov edx, dword ptr [ebp - local_4]           # 004d5ee6
    mov eax, dword ptr [ebp - local_4]           # 004d5ee9
    mov edx, dword ptr [edx + field_972c]        # 004d5eec
    sub edx, dword ptr [eax + field_9724]        # 004d5ef2
    {load} mov eax, edx                          # 004d5ef8
    cdq                                          # 004d5efa
    {load} sub eax, edx                          # 004d5efb
    sar eax                                      # 004d5efd
    {load} sub ecx, eax                          # 004d5eff
    mov eax, dword ptr [ebp - local_4]           # 004d5f01
    mov dword ptr [eax + field_9734], ecx        # 004d5f04
    movsx eax, word ptr [0x63988d]               # 004d5f0a
    add eax, 0x1                                 # 004d5f11
    cdq                                          # 004d5f14
    {load} sub eax, edx                          # 004d5f15
    {load} mov ecx, eax                          # 004d5f17
    sar ecx                                      # 004d5f19
    mov edx, dword ptr [ebp - local_4]           # 004d5f1b
    mov eax, dword ptr [ebp - local_4]           # 004d5f1e
    mov edx, dword ptr [edx + field_9730]        # 004d5f21
    sub edx, dword ptr [eax + field_9728]        # 004d5f27
    {load} mov eax, edx                          # 004d5f2d
    cdq                                          # 004d5f2f
    {load} sub eax, edx                          # 004d5f30
    sar eax                                      # 004d5f32
    {load} sub ecx, eax                          # 004d5f34
    mov eax, dword ptr [ebp - local_4]           # 004d5f36
    mov dword ptr [eax + field_9738], ecx        # 004d5f39
    mov ecx, dword ptr [ebp - local_4]           # 004d5f3f
    mov edx, dword ptr [ebp - local_4]           # 004d5f42
    mov eax, dword ptr [ecx + field_972c]        # 004d5f45
    sub eax, dword ptr [edx + field_9724]        # 004d5f4b
    mov ecx, dword ptr [ebp - local_4]           # 004d5f51
    mov edx, dword ptr [ecx + field_9734]        # 004d5f54
    {load} add edx, eax                          # 004d5f5a
    mov eax, dword ptr [ebp - local_4]           # 004d5f5c
    mov dword ptr [eax + field_973c], edx        # 004d5f5f
    mov ecx, dword ptr [ebp - local_4]           # 004d5f65
    mov edx, dword ptr [ebp - local_4]           # 004d5f68
    mov eax, dword ptr [ecx + field_9730]        # 004d5f6b
    sub eax, dword ptr [edx + field_9728]        # 004d5f71
    mov ecx, dword ptr [ebp - local_4]           # 004d5f77
    mov edx, dword ptr [ecx + field_9738]        # 004d5f7a
    {load} add edx, eax                          # 004d5f80
    mov eax, dword ptr [ebp - local_4]           # 004d5f82
    mov dword ptr [eax + field_9740], edx        # 004d5f85
    pop edi                                      # 004d5f8b
    pop esi                                      # 004d5f8c
    {load} mov esp, ebp                          # 004d5f8d
    pop ebp                                      # 004d5f8f
    ret                                          # 004d5f90

