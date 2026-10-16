# FUN_0044edfb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044edfb
# extent:       0x0044edfb-0x0044efcd (466 code bytes)
# span:         0x0044edfb-0x0044efcd (code 466, tables 0, padding 0)
# sha256:       c04e236320ab23a7b879129454bc1942aa0dba17166032cbbb23582481b4174b
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044edfb
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_26, field_2c, field_30, field_53, field_6b; [ecx + n] field_26, field_28, field_2c, field_30, field_67; [edx + n] field_1e, field_24, field_26, field_30, field_63
# callees:      calls FUN_004f6334, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 128 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_53, 0x53  # offset +0x53
.equ field_63, 0x63  # offset +0x63
.equ field_67, 0x67  # offset +0x67
.equ field_6b, 0x6b  # offset +0x6b

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0044edfb - 0x401000
.globl FUN_0044edfb
FUN_0044edfb:
    # block 0x0044edfb: entry, 14 instruction(s), ends with je to 0x0044efc7 (forward)
    push ebp                                     # 0044edfb
    {load} mov ebp, esp                          # 0044edfc
    sub esp, 0xc                                 # 0044edfe
    push esi                                     # 0044ee01
    push edi                                     # 0044ee02
    mov dword ptr [ebp - local_c], ecx           # 0044ee03
    mov eax, dword ptr [ebp - local_c]           # 0044ee06
    movsx ecx, word ptr [eax + field_1e]         # 0044ee09
    imul ecx, ecx, 0x8d                          # 0044ee0d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044ee13
    mov dword ptr [ebp - local_4], edx           # 0044ee19
    mov eax, dword ptr [ebp - local_c]           # 0044ee1c
    cmp dword ptr [eax + field_6b], 0x0          # 0044ee1f
    je.d32 L_0044efc7                            # 0044ee23
    # block 0x0044ee29: entered by fall-through of je at 0x0044ee23, 3 instruction(s), ends with jne to 0x0044efc7 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044ee29
    cmp dword ptr [ecx + field_2c], 0x0          # 0044ee2c
    jne.d32 L_0044efc7                           # 0044ee30
    # block 0x0044ee36: entered by fall-through of jne at 0x0044ee30, 5 instruction(s), ends with jne to 0x0044efc7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0044ee36
    movsx eax, word ptr [edx + field_1e]         # 0044ee39
    imul eax, eax, 0x8d                          # 0044ee3d
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0044ee43
    jne.d32 L_0044efc7                           # 0044ee4a
    # block 0x0044ee50: entered by fall-through of jne at 0x0044ee4a, 2 instruction(s), ends with jne to 0x0044ee82 (forward)
    cmp dword ptr [0x5c39e5], 0x2787             # 0044ee50
    jne.d8 L_0044ee82                            # 0044ee5a
    # block 0x0044ee5c: entered by fall-through of jne at 0x0044ee5a, 7 instruction(s), ends with forward jump to 0x0044efc7
    mov ecx, dword ptr [ebp - local_c]           # 0044ee5c
    mov dword ptr [ecx + field_67], 0x1          # 0044ee5f
    mov edx, dword ptr [ebp - local_c]           # 0044ee66
    movsx eax, word ptr [edx + field_1e]         # 0044ee69
    imul eax, eax, 0x8d                          # 0044ee6d
    mov dword ptr [eax + 0x5bb632], 0x2          # 0044ee73
    jmp.d32 L_0044efc7                           # 0044ee7d
L_0044ee82:
    # block 0x0044ee82: entered by jne at 0x0044ee5a, 2 instruction(s), ends with jne to 0x0044ef2e (forward)
    cmp dword ptr [0x5c39e5], 0x2786             # 0044ee82
    jne.d32 L_0044ef2e                           # 0044ee8c
    # block 0x0044ee92: entered by fall-through of jne at 0x0044ee8c, 4 instruction(s), ends with jne to 0x0044eec8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044ee92
    movsx edx, word ptr [ecx + field_30]         # 0044ee95
    test edx, edx                                # 0044ee99
    jne.d8 L_0044eec8                            # 0044ee9b
    # block 0x0044ee9d: entered by fall-through of jne at 0x0044ee9b, 13 instruction(s), ends with forward jump to 0x0044ef2c
    mov eax, dword ptr [ebp - local_c]           # 0044ee9d
    mov cx, word ptr [eax + field_26]            # 0044eea0
    sub cx, 0x1                                  # 0044eea4
    mov edx, dword ptr [ebp - local_c]           # 0044eea8
    mov word ptr [edx + field_26], cx            # 0044eeab
    mov esi, dword ptr [ebp - local_4]           # 0044eeaf
    add esi, 0x1be                               # 0044eeb2
    mov edi, dword ptr [ebp - local_c]           # 0044eeb8
    add edi, 0x32                                # 0044eebb
    mov ecx, 0xc                                 # 0044eebe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044eec3
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044eec5
    jmp.d8 L_0044ef2c                            # 0044eec6
L_0044eec8:
    # block 0x0044eec8: entered by jne at 0x0044ee9b, 4 instruction(s), ends with jne to 0x0044eeff (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044eec8
    movsx ecx, word ptr [eax + field_30]         # 0044eecb
    cmp ecx, 0x1                                 # 0044eecf
    jne.d8 L_0044eeff                            # 0044eed2
    # block 0x0044eed4: entered by fall-through of jne at 0x0044eed2, 13 instruction(s), ends with forward jump to 0x0044ef2c
    mov edx, dword ptr [ebp - local_c]           # 0044eed4
    mov ax, word ptr [edx + field_26]            # 0044eed7
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044eedb
    mov ecx, dword ptr [ebp - local_c]           # 0044eedf
    mov word ptr [ecx + field_26], ax            # 0044eee2
    mov esi, dword ptr [ebp - local_4]           # 0044eee6
    add esi, 0x1be                               # 0044eee9
    mov edi, dword ptr [ebp - local_c]           # 0044eeef
    add edi, 0x32                                # 0044eef2
    mov ecx, 0xc                                 # 0044eef5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044eefa
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044eefc
    jmp.d8 L_0044ef2c                            # 0044eefd
L_0044eeff:
    # block 0x0044eeff: entered by jne at 0x0044eed2, 4 instruction(s), ends with jne to 0x0044ef2c (forward)
    mov edx, dword ptr [ebp - local_c]           # 0044eeff
    movsx eax, word ptr [edx + field_30]         # 0044ef02
    cmp eax, 0x2                                 # 0044ef06
    jne.d8 L_0044ef2c                            # 0044ef09
    # block 0x0044ef0b: entered by fall-through of jne at 0x0044ef09, 9 instruction(s), falls into the block at 0x0044ef2c
    mov ecx, dword ptr [ebp - local_c]           # 0044ef0b
    mov dword ptr [ecx + field_28], 0x1          # 0044ef0e
    mov esi, dword ptr [ebp - local_4]           # 0044ef15
    add esi, 0x1ef                               # 0044ef18
    mov edi, dword ptr [ebp - local_c]           # 0044ef1e
    add edi, 0x32                                # 0044ef21
    mov ecx, 0xc                                 # 0044ef24
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044ef29
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044ef2b
L_0044ef2c:
    # block 0x0044ef2c: entered by jmp at 0x0044eec6; jmp at 0x0044eefd; jne at 0x0044ef09, 1 instruction(s), ends with forward jump to 0x0044ef5f
    jmp.d8 L_0044ef5f                            # 0044ef2c
L_0044ef2e:
    # block 0x0044ef2e: entered by jne at 0x0044ee8c, 2 instruction(s), ends with jne to 0x0044ef5f (forward)
    cmp dword ptr [0x5c39e5], 0x2785             # 0044ef2e
    jne.d8 L_0044ef5f                            # 0044ef38
    # block 0x0044ef3a: entered by fall-through of jne at 0x0044ef38, 11 instruction(s), falls into the block at 0x0044ef5f
    mov edx, dword ptr [ebp - local_c]           # 0044ef3a
    mov eax, dword ptr [ebp - local_c]           # 0044ef3d
    mov cx, word ptr [eax + field_30]            # 0044ef40
    mov word ptr [edx + field_24], cx            # 0044ef44
    mov esi, dword ptr [ebp - local_4]           # 0044ef48
    add esi, 0x18d                               # 0044ef4b
    mov edi, dword ptr [ebp - local_c]           # 0044ef51
    add edi, 0x32                                # 0044ef54
    mov ecx, 0xc                                 # 0044ef57
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044ef5c
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044ef5e
L_0044ef5f:
    # block 0x0044ef5f: entered by jmp at 0x0044ef2c; jne at 0x0044ef38, 2 instruction(s), ends with je to 0x0044efc7 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0044ef5f
    je.d8 L_0044efc7                             # 0044ef66
    # block 0x0044ef68: entered by fall-through of je at 0x0044ef66, 7 instruction(s), ends with je to 0x0044efc7 (forward)
    mov edi, 0x549824                            # 0044ef68
    mov esi, dword ptr [ebp - local_c]           # 0044ef6d
    add esi, 0x32                                # 0044ef70
    mov ecx, 0x9                                 # 0044ef73
    {load} xor edx, edx                          # 0044ef78
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044ef7a
    je.d8 L_0044efc7                             # 0044ef7c
    # block 0x0044ef7e: entered by fall-through of je at 0x0044ef7c, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0044efc7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044ef7e
    movsx ecx, word ptr [eax + field_53]         # 0044ef81
    mov dword ptr [ebp - local_8], ecx           # 0044ef85
    mov edx, dword ptr [ebp - local_8]           # 0044ef88
    push edx                                     # 0044ef8b
    mov ecx, 0x5cf1eb                            # 0044ef8c
    call FUN_004f6334                            # 0044ef91
    test eax, eax                                # 0044ef96
    jne.d8 L_0044efc7                            # 0044ef98
    # block 0x0044ef9a: entered by fall-through of jne at 0x0044ef98, 11 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x0044efc7
    mov eax, dword ptr [ebp - local_c]           # 0044ef9a
    mov cx, word ptr [eax + field_53]            # 0044ef9d
    push ecx                                     # 0044efa1
    mov ecx, 0x5c3a67                            # 0044efa2
    call FUN_004fb2e3                            # 0044efa7
    call dword ptr [0x52a23c]                    # 0044efac
    add eax, 0xfa                                # 0044efb2
    mov edx, dword ptr [ebp - local_c]           # 0044efb7
    mov dword ptr [edx + field_63], eax          # 0044efba
    mov eax, dword ptr [ebp - local_c]           # 0044efbd
    mov dword ptr [eax + field_2c], 0x1          # 0044efc0
L_0044efc7:
    # block 0x0044efc7: entered by je at 0x0044ee23; jne at 0x0044ee30; jne at 0x0044ee4a; jmp at 0x0044ee7d; more, 5 instruction(s), ends with ret
    pop edi                                      # 0044efc7
    pop esi                                      # 0044efc8
    {load} mov esp, ebp                          # 0044efc9
    pop ebp                                      # 0044efcb
    ret                                          # 0044efcc

