# FUN_004cbb00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cbb00
# extent:       0x004cbb00-0x004cbba9 (169 code bytes)
# span:         0x004cbb00-0x004cbba9 (code 169, tables 0, padding 0)
# sha256:       14caf0364b2924de7b54714f890e2d2c1821ef40da880fc35fe6d602bc55a4b0
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cbb00
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1a, field_21, field_25, field_122; [ecx + n] field_122; [edx + n] field_9, field_1a
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_9, 0x9  # offset +0x9
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_122, 0x122  # offset +0x122

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004cbb00 - 0x401000
.globl FUN_004cbb00
FUN_004cbb00:
    # block 0x004cbb00: entry, 7 instruction(s), ends with jne to 0x004cbb17 (forward)
    push ebp                                     # 004cbb00
    {load} mov ebp, esp                          # 004cbb01
    sub esp, 0x14                                # 004cbb03
    mov dword ptr [ebp - local_14], ecx          # 004cbb06
    mov eax, dword ptr [ebp - local_14]          # 004cbb09
    cmp dword ptr [eax + field_1a], 0x0          # 004cbb0c
    jne.d8 L_004cbb17                            # 004cbb10
    # block 0x004cbb12: entered by fall-through of jne at 0x004cbb10, 1 instruction(s), ends with forward jump to 0x004cbba5
    jmp.d32 L_004cbba5                           # 004cbb12
L_004cbb17:
    # block 0x004cbb17: entered by jne at 0x004cbb10, 2 instruction(s), ends with forward jump to 0x004cbb29
    mov dword ptr [ebp - local_4], 0x0           # 004cbb17
    jmp.d8 L_004cbb29                            # 004cbb1e
L_004cbb20:
    # block 0x004cbb20: entered by jmp at 0x004cbb6c, 3 instruction(s), falls into the block at 0x004cbb29
    mov ecx, dword ptr [ebp - local_4]           # 004cbb20
    add ecx, 0x1                                 # 004cbb23
    mov dword ptr [ebp - local_4], ecx           # 004cbb26
L_004cbb29:
    # block 0x004cbb29: entered by jmp at 0x004cbb1e, 5 instruction(s), ends with jge to 0x004cbb6e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004cbb29
    mov eax, dword ptr [edx + field_1a]          # 004cbb2c
    mov ecx, dword ptr [ebp - local_4]           # 004cbb2f
    cmp ecx, dword ptr [eax + field_21]          # 004cbb32
    jge.d8 L_004cbb6e                            # 004cbb35
    # block 0x004cbb37: entered by fall-through of jge at 0x004cbb35, 17 instruction(s), calls FUN_0051dc6c, ends with backward jump to 0x004cbb20
    mov edx, dword ptr [ebp - local_14]          # 004cbb37
    mov eax, dword ptr [edx + field_1a]          # 004cbb3a
    mov ecx, dword ptr [ebp - local_4]           # 004cbb3d
    imul ecx, ecx, 0xd                           # 004cbb40
    mov edx, dword ptr [eax + field_25]          # 004cbb43
    {load} add edx, ecx                          # 004cbb46
    mov eax, dword ptr [ebp - local_14]          # 004cbb48
    mov dword ptr [eax + field_122], edx         # 004cbb4b
    mov ecx, dword ptr [ebp - local_14]          # 004cbb51
    mov edx, dword ptr [ecx + field_122]         # 004cbb54
    mov eax, dword ptr [edx + field_9]           # 004cbb5a
    mov dword ptr [ebp - local_8], eax           # 004cbb5d
    mov ecx, dword ptr [ebp - local_8]           # 004cbb60
    push ecx                                     # 004cbb63
    call FUN_0051dc6c                            # 004cbb64
    add esp, 0x4                                 # 004cbb69
    jmp.d8 L_004cbb20                            # 004cbb6c
L_004cbb6e:
    # block 0x004cbb6e: entered by jge at 0x004cbb35, 17 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cbba5
    mov edx, dword ptr [ebp - local_14]          # 004cbb6e
    mov eax, dword ptr [edx + field_1a]          # 004cbb71
    mov ecx, dword ptr [eax + field_25]          # 004cbb74
    mov dword ptr [ebp - local_c], ecx           # 004cbb77
    mov edx, dword ptr [ebp - local_c]           # 004cbb7a
    push edx                                     # 004cbb7d
    call FUN_0051dc6c                            # 004cbb7e
    add esp, 0x4                                 # 004cbb83
    mov eax, dword ptr [ebp - local_14]          # 004cbb86
    mov ecx, dword ptr [eax + field_1a]          # 004cbb89
    mov dword ptr [ebp - local_10], ecx          # 004cbb8c
    mov edx, dword ptr [ebp - local_10]          # 004cbb8f
    push edx                                     # 004cbb92
    call FUN_0051dc6c                            # 004cbb93
    add esp, 0x4                                 # 004cbb98
    mov eax, dword ptr [ebp - local_14]          # 004cbb9b
    mov dword ptr [eax + field_1a], 0x0          # 004cbb9e
L_004cbba5:
    # block 0x004cbba5: entered by jmp at 0x004cbb12, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cbba5
    pop ebp                                      # 004cbba7
    ret                                          # 004cbba8

