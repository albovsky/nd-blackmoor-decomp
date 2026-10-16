# FUN_0046ea16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ea16
# extent:       0x0046ea16-0x0046ebbd (423 code bytes)
# span:         0x0046ea16-0x0046ebbd (code 423, tables 0, padding 0)
# sha256:       543822934fa8a1c6a759f7681d51fd33f42b39c0cdd672946c4354e94e5aa85f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046ea16
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_46, field_52; [ecx + n] field_24, field_5f; [edx + n] field_4, field_8, field_c, field_1e
# callees:      calls FUN_0046ebbd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 105 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_46, 0x46  # offset +0x46
.equ field_52, 0x52  # offset +0x52
.equ field_5f, 0x5f  # offset +0x5f

# --- external targets -----------------------------------------------
.set FUN_0046ebbd, .text + (0x0046ebbd - 0x401000)

.org 0x0046ea16 - 0x401000
.globl FUN_0046ea16
FUN_0046ea16:
    # block 0x0046ea16: entry, 7 instruction(s), ends with je to 0x0046ebb5 (forward)
    push ebp                                     # 0046ea16
    {load} mov ebp, esp                          # 0046ea17
    sub esp, 0xc                                 # 0046ea19
    mov dword ptr [ebp - local_c], ecx           # 0046ea1c
    mov eax, dword ptr [ebp - local_c]           # 0046ea1f
    cmp dword ptr [eax + field_46], 0x0          # 0046ea22
    je.d32 L_0046ebb5                            # 0046ea26
    # block 0x0046ea2c: entered by fall-through of je at 0x0046ea26, 3 instruction(s), ends with jne to 0x0046ebb5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046ea2c
    cmp dword ptr [ecx + field_5f], 0x0          # 0046ea2f
    jne.d32 L_0046ebb5                           # 0046ea33
    # block 0x0046ea39: entered by fall-through of jne at 0x0046ea33, 25 instruction(s), calls FUN_0046ebbd, ends with je to 0x0046eae5 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046ea39
    movsx eax, word ptr [edx + field_1e]         # 0046ea3c
    imul eax, eax, 0x8d                          # 0046ea40
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046ea46
    mov dword ptr [ebp - local_4], ecx           # 0046ea4c
    mov edx, dword ptr [ebp - local_4]           # 0046ea4f
    add edx, 0xf23                               # 0046ea52
    sub esp, 0x10                                # 0046ea58
    {load} mov eax, esp                          # 0046ea5b
    mov ecx, dword ptr [edx]                     # 0046ea5d
    mov dword ptr [eax], ecx                     # 0046ea5f
    mov ecx, dword ptr [edx + field_4]           # 0046ea61
    mov dword ptr [eax + field_4], ecx           # 0046ea64
    mov ecx, dword ptr [edx + field_8]           # 0046ea67
    mov dword ptr [eax + field_8], ecx           # 0046ea6a
    mov edx, dword ptr [edx + field_c]           # 0046ea6d
    mov dword ptr [eax + field_c], edx           # 0046ea70
    movsx eax, word ptr [ebp + arg_c]            # 0046ea73
    push eax                                     # 0046ea77
    movsx ecx, word ptr [ebp + arg_8]            # 0046ea78
    push ecx                                     # 0046ea7c
    mov ecx, dword ptr [ebp - local_c]           # 0046ea7d
    call FUN_0046ebbd                            # 0046ea80
    test eax, eax                                # 0046ea85
    je.d8 L_0046eae5                             # 0046ea87
    # block 0x0046ea89: entered by fall-through of je at 0x0046ea87, 14 instruction(s), ends with forward jump to 0x0046ebb7
    mov dword ptr [0x5c39e5], 0x27c3             # 0046ea89
    mov dword ptr [0x5b44f0], 0x9                # 0046ea93
    mov dword ptr [0x5b44f4], 0x1                # 0046ea9d
    mov edx, dword ptr [0x5d0377]                # 0046eaa7
    mov dword ptr [0x5d162d], edx                # 0046eaad
    mov eax, dword ptr [0x5b44f0]                # 0046eab3
    shl eax, 0x5                                 # 0046eab8
    mov ecx, dword ptr [0x5b44f4]                # 0046eabb
    shl ecx, 0x4                                 # 0046eac1
    lea edx, [eax + ecx + 0x5b160c]              # 0046eac4
    mov dword ptr [0x5d1631], edx                # 0046eacb
    mov dword ptr [0x5d1639], 0x1                # 0046ead1
    mov eax, 0x1                                 # 0046eadb
    jmp.d32 L_0046ebb7                           # 0046eae0
L_0046eae5:
    # block 0x0046eae5: entered by je at 0x0046ea87, 6 instruction(s), ends with forward jump to 0x0046eb05
    mov eax, dword ptr [ebp - local_4]           # 0046eae5
    add eax, 0x23c                               # 0046eae8
    mov ecx, dword ptr [ebp - local_c]           # 0046eaed
    mov dword ptr [ecx + field_24], eax          # 0046eaf0
    mov dword ptr [ebp - local_8], 0x0           # 0046eaf3
    jmp.d8 L_0046eb05                            # 0046eafa
L_0046eafc:
    # block 0x0046eafc: entered by jmp at 0x0046ebb0, 3 instruction(s), falls into the block at 0x0046eb05
    mov edx, dword ptr [ebp - local_8]           # 0046eafc
    add edx, 0x1                                 # 0046eaff
    mov dword ptr [ebp - local_8], edx           # 0046eb02
L_0046eb05:
    # block 0x0046eb05: entered by jmp at 0x0046eafa, 2 instruction(s), ends with jge to 0x0046ebb5 (forward)
    cmp dword ptr [ebp - local_8], 0x10          # 0046eb05
    jge.d32 L_0046ebb5                           # 0046eb09
    # block 0x0046eb0f: entered by fall-through of jge at 0x0046eb09, 23 instruction(s), calls FUN_0046ebbd, ends with je to 0x0046ebb0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046eb0f
    shl eax, 0x4                                 # 0046eb12
    mov ecx, dword ptr [ebp - local_c]           # 0046eb15
    mov edx, dword ptr [ecx + field_24]          # 0046eb18
    {load} add edx, eax                          # 0046eb1b
    sub esp, 0x10                                # 0046eb1d
    {load} mov eax, esp                          # 0046eb20
    mov ecx, dword ptr [edx]                     # 0046eb22
    mov dword ptr [eax], ecx                     # 0046eb24
    mov ecx, dword ptr [edx + field_4]           # 0046eb26
    mov dword ptr [eax + field_4], ecx           # 0046eb29
    mov ecx, dword ptr [edx + field_8]           # 0046eb2c
    mov dword ptr [eax + field_8], ecx           # 0046eb2f
    mov edx, dword ptr [edx + field_c]           # 0046eb32
    mov dword ptr [eax + field_c], edx           # 0046eb35
    movsx eax, word ptr [ebp + arg_c]            # 0046eb38
    push eax                                     # 0046eb3c
    movsx ecx, word ptr [ebp + arg_8]            # 0046eb3d
    push ecx                                     # 0046eb41
    mov ecx, dword ptr [ebp - local_c]           # 0046eb42
    call FUN_0046ebbd                            # 0046eb45
    test eax, eax                                # 0046eb4a
    je.d8 L_0046ebb0                             # 0046eb4c
    # block 0x0046eb4e: entered by fall-through of je at 0x0046eb4c, 17 instruction(s), ends with forward jump to 0x0046ebb7
    mov dword ptr [0x5b44f0], 0x16               # 0046eb4e
    mov dword ptr [0x5b44f4], 0x1                # 0046eb58
    mov edx, dword ptr [0x5d0377]                # 0046eb62
    mov dword ptr [0x5d162d], edx                # 0046eb68
    mov eax, dword ptr [0x5b44f0]                # 0046eb6e
    shl eax, 0x5                                 # 0046eb73
    mov ecx, dword ptr [0x5b44f4]                # 0046eb76
    shl ecx, 0x4                                 # 0046eb7c
    lea edx, [eax + ecx + 0x5b160c]              # 0046eb7f
    mov dword ptr [0x5d1631], edx                # 0046eb86
    mov dword ptr [0x5d1639], 0x1                # 0046eb8c
    mov dword ptr [0x5c39e5], 0x27c2             # 0046eb96
    mov eax, dword ptr [ebp - local_c]           # 0046eba0
    mov cl, byte ptr [ebp - local_8]             # 0046eba3
    mov byte ptr [eax + field_52], cl            # 0046eba6
    mov eax, 0x1                                 # 0046eba9
    jmp.d8 L_0046ebb7                            # 0046ebae
L_0046ebb0:
    # block 0x0046ebb0: entered by je at 0x0046eb4c, 1 instruction(s), ends with backward jump to 0x0046eafc
    jmp.d32 L_0046eafc                           # 0046ebb0
L_0046ebb5:
    # block 0x0046ebb5: entered by je at 0x0046ea26; jne at 0x0046ea33; jge at 0x0046eb09, 1 instruction(s), falls into the block at 0x0046ebb7
    {load} xor eax, eax                          # 0046ebb5
L_0046ebb7:
    # block 0x0046ebb7: entered by jmp at 0x0046eae0; jmp at 0x0046ebae, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0046ebb7
    pop ebp                                      # 0046ebb9
    ret 0x8                                      # 0046ebba

