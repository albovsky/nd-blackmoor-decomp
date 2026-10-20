# FUN_004db993
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db993
# extent:       0x004db993-0x004dbb13 (384 code bytes)
# span:         0x004db993-0x004dbb13 (code 384, tables 0, padding 0)
# sha256:       139830af414afb3c475a212431a0a47d478ec5334ec6c7d1c1a5b4de3a01e39a
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db993
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_8, local_c
# fields:       [eax + n] field_4, field_14, field_18, field_28, field_2c; [ecx + n] field_14, field_18, field_24, field_minus_1; [edx + n] field_14, field_18, field_30, field_minus_1
# callees:      calls FUN_004dae88, FUN_004daeb5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m4edfaf_centre_rect (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 95 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004db993 - 0x401000
.globl FUN_004db993
FUN_004db993:
    # block 0x004db993: entry, 29 instruction(s), calls FUN_004dae88, FUN_004daeb5, ends with jl to 0x004dba5b (forward)
    push ebp                                     # 004db993
    {load} mov ebp, esp                          # 004db994
    sub esp, 0xc                                 # 004db996
    mov dword ptr [ebp - local_c], ecx           # 004db999
    mov eax, dword ptr [ebp + arg_c]             # 004db99c
    push eax                                     # 004db99f
    mov ecx, dword ptr [ebp + arg_8]             # 004db9a0
    push ecx                                     # 004db9a3
    mov ecx, 0x5830a6                            # 004db9a4
    call FUN_004dae88                            # 004db9a9
    lea edx, [ebp - local_8]                     # 004db9ae
    push edx                                     # 004db9b1
    mov ecx, 0x5830a6                            # 004db9b2
    call FUN_004daeb5                            # 004db9b7
    mov ecx, dword ptr [eax]                     # 004db9bc
    mov edx, dword ptr [eax + field_4]           # 004db9be
    mov eax, dword ptr [ebp - local_c]           # 004db9c1
    mov dword ptr [eax + field_14], ecx          # 004db9c4
    mov dword ptr [eax + field_18], edx          # 004db9c7
    mov ecx, dword ptr [ebp - local_c]           # 004db9ca
    mov edx, dword ptr [ecx + field_14]          # 004db9cd
    mov dword ptr [0x5c3a53], edx                # 004db9d0
    mov eax, dword ptr [ebp - local_c]           # 004db9d6
    mov ecx, dword ptr [eax + field_18]          # 004db9d9
    mov dword ptr [0x5c3a57], ecx                # 004db9dc
    mov edx, dword ptr [ebp - local_c]           # 004db9e2
    mov eax, dword ptr [edx + field_14]          # 004db9e5
    cmp eax, dword ptr [0x5b377c]                # 004db9e8
    jl.d8 L_004dba5b                             # 004db9ee
    # block 0x004db9f0: entered by fall-through of jl at 0x004db9ee, 4 instruction(s), ends with jg to 0x004dba5b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004db9f0
    mov edx, dword ptr [ecx + field_14]          # 004db9f3
    cmp edx, dword ptr [0x5b3784]                # 004db9f6
    jg.d8 L_004dba5b                             # 004db9fc
    # block 0x004db9fe: entered by fall-through of jg at 0x004db9fc, 4 instruction(s), ends with jl to 0x004dba5b (forward)
    mov eax, dword ptr [ebp - local_c]           # 004db9fe
    mov ecx, dword ptr [eax + field_18]          # 004dba01
    cmp ecx, dword ptr [0x5b3780]                # 004dba04
    jl.d8 L_004dba5b                             # 004dba0a
    # block 0x004dba0c: entered by fall-through of jl at 0x004dba0a, 4 instruction(s), ends with jg to 0x004dba5b (forward)
    mov edx, dword ptr [ebp - local_c]           # 004dba0c
    mov eax, dword ptr [edx + field_18]          # 004dba0f
    cmp eax, dword ptr [0x5b3788]                # 004dba12
    jg.d8 L_004dba5b                             # 004dba18
    # block 0x004dba1a: entered by fall-through of jg at 0x004dba18, 3 instruction(s), ends with jne to 0x004dba3e (forward)
    movsx ecx, word ptr [0x583a29]               # 004dba1a
    cmp ecx, -0x1                                # 004dba21
    jne.d8 L_004dba3e                            # 004dba24
    # block 0x004dba26: entered by fall-through of jne at 0x004dba24, 4 instruction(s), ends with forward jump to 0x004dba59
    mov dword ptr [0x5b44f0], 0x0                # 004dba26
    mov edx, dword ptr [0x5d0377]                # 004dba30
    mov dword ptr [0x5d162d], edx                # 004dba36
    jmp.d8 L_004dba59                            # 004dba3c
L_004dba3e:
    # block 0x004dba3e: entered by jne at 0x004dba24, 5 instruction(s), falls into the block at 0x004dba59
    movsx eax, word ptr [0x583a29]               # 004dba3e
    add eax, 0x25                                # 004dba45
    mov dword ptr [0x5b44f0], eax                # 004dba48
    mov ecx, dword ptr [0x571ad3]                # 004dba4d
    mov dword ptr [0x5d162d], ecx                # 004dba53
L_004dba59:
    # block 0x004dba59: entered by jmp at 0x004dba3c, 1 instruction(s), ends with forward jump to 0x004dba71
    jmp.d8 L_004dba71                            # 004dba59
L_004dba5b:
    # block 0x004dba5b: entered by jl at 0x004db9ee; jg at 0x004db9fc; jl at 0x004dba0a; jg at 0x004dba18, 3 instruction(s), falls into the block at 0x004dba71
    mov dword ptr [0x5b44f0], 0x4                # 004dba5b
    mov edx, dword ptr [0x5d0377]                # 004dba65
    mov dword ptr [0x5d162d], edx                # 004dba6b
L_004dba71:
    # block 0x004dba71: entered by jmp at 0x004dba59, 38 instruction(s), ends with ret 0x8
    mov dword ptr [0x5b44f4], 0x0                # 004dba71
    mov eax, dword ptr [ebp - local_c]           # 004dba7b
    mov ecx, dword ptr [0x583106]                # 004dba7e
    mov dword ptr [eax + field_28], ecx          # 004dba84
    mov edx, dword ptr [ebp - local_c]           # 004dba87
    mov eax, dword ptr [0x58310e]                # 004dba8a
    mov dword ptr [edx + field_30], eax          # 004dba8f
    mov ecx, dword ptr [ebp - local_c]           # 004dba92
    mov edx, dword ptr [0x583102]                # 004dba95
    mov dword ptr [ecx + field_24], edx          # 004dba9b
    mov eax, dword ptr [ebp - local_c]           # 004dba9e
    mov ecx, dword ptr [0x58310a]                # 004dbaa1
    mov dword ptr [eax + field_2c], ecx          # 004dbaa7
    mov edx, dword ptr [ebp - local_c]           # 004dbaaa
    mov eax, dword ptr [edx + field_18]          # 004dbaad
    mov dword ptr [0x583106], eax                # 004dbab0
    mov ecx, dword ptr [0x5b44f4]                # 004dbab5
    shl ecx, 0x2                                 # 004dbabb
    mov edx, dword ptr [0x5b44f0]                # 004dbabe
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004dbac4
    mov ecx, dword ptr [ebp - local_c]           # 004dbacc
    mov edx, dword ptr [ecx + field_18]          # 004dbacf
    lea eax, [edx + eax - field_minus_1]         # 004dbad2
    mov dword ptr [0x58310e], eax                # 004dbad6
    mov ecx, dword ptr [ebp - local_c]           # 004dbadb
    mov edx, dword ptr [ecx + field_14]          # 004dbade
    mov dword ptr [0x583102], edx                # 004dbae1
    mov eax, dword ptr [0x5b44f4]                # 004dbae7
    shl eax, 0x2                                 # 004dbaec
    mov ecx, dword ptr [0x5b44f0]                # 004dbaef
    movsx edx, word ptr [eax + 8*ecx + 0x5b3790] # 004dbaf5
    mov eax, dword ptr [ebp - local_c]           # 004dbafd
    mov ecx, dword ptr [eax + field_14]          # 004dbb00
    lea edx, [ecx + edx - field_minus_1]         # 004dbb03
    mov dword ptr [0x58310a], edx                # 004dbb07
    {load} mov esp, ebp                          # 004dbb0d
    pop ebp                                      # 004dbb0f
    ret 0x8                                      # 004dbb10

