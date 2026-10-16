# FUN_004ebd85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ebd85
# extent:       0x004ebd85-0x004ebe90 (267 code bytes)
# span:         0x004ebd85-0x004ebe90 (code 267, tables 0, padding 0)
# sha256:       1039f1f050a4224193bad085995be1047c8082417c51febc48ebcc53496a18eb
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ebd85
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_ca0, field_ca8, field_fc6, field_fd6; [ecx + n] field_ca0, field_fc6; [edx + n] field_985, field_fc6, field_fd2
# callees:      calls FUN_004ee2a9, FUN_004e22fd, FUN_004ebe90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_985, 0x985  # offset +0x985
.equ field_ca0, 0xca0  # offset +0xca0
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_fd2, 0xfd2  # offset +0xfd2
.equ field_fd6, 0xfd6  # offset +0xfd6

# --- external targets -----------------------------------------------
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004ebe90, .text + (0x004ebe90 - 0x401000)
.set FUN_004ee2a9, .text + (0x004ee2a9 - 0x401000)

.org 0x004ebd85 - 0x401000
.globl FUN_004ebd85
FUN_004ebd85:
    # block 0x004ebd85: entry, 7 instruction(s), ends with je to 0x004ebda9 (forward)
    push ebp                                     # 004ebd85
    {load} mov ebp, esp                          # 004ebd86
    push ecx                                     # 004ebd88
    mov dword ptr [ebp - local_4], ecx           # 004ebd89
    mov eax, dword ptr [ebp - local_4]           # 004ebd8c
    cmp dword ptr [eax + field_ca0], 0x2         # 004ebd8f
    je.d8 L_004ebda9                             # 004ebd96
    # block 0x004ebd98: entered by fall-through of je at 0x004ebd96, 3 instruction(s), ends with je to 0x004ebda9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ebd98
    cmp dword ptr [ecx + field_ca0], 0x3         # 004ebd9b
    je.d8 L_004ebda9                             # 004ebda2
    # block 0x004ebda4: entered by fall-through of je at 0x004ebda2, 1 instruction(s), ends with forward jump to 0x004ebe8c
    jmp.d32 L_004ebe8c                           # 004ebda4
L_004ebda9:
    # block 0x004ebda9: entered by je at 0x004ebd96; je at 0x004ebda2, 4 instruction(s), calls FUN_004ee2a9, ends with je to 0x004ebdba (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ebda9
    call FUN_004ee2a9                            # 004ebdac
    test eax, eax                                # 004ebdb1
    je.d8 L_004ebdba                             # 004ebdb3
    # block 0x004ebdb5: entered by fall-through of je at 0x004ebdb3, 1 instruction(s), ends with forward jump to 0x004ebe8c
    jmp.d32 L_004ebe8c                           # 004ebdb5
L_004ebdba:
    # block 0x004ebdba: entered by je at 0x004ebdb3, 17 instruction(s), ends with forward jump to 0x004ebe26
    mov edx, dword ptr [0x5b44f0]                # 004ebdba
    shl edx, 0x4                                 # 004ebdc0
    mov eax, dword ptr [0x5b44f4]                # 004ebdc3
    mov ecx, dword ptr [0x583102]                # 004ebdc8
    add ecx, dword ptr [edx + 8*eax + 0x5b30cc]  # 004ebdce
    mov edx, dword ptr [ebp - local_4]           # 004ebdd5
    mov dword ptr [edx + field_fd2], ecx         # 004ebdd8
    mov eax, dword ptr [0x5b44f0]                # 004ebdde
    shl eax, 0x4                                 # 004ebde3
    mov ecx, dword ptr [0x5b44f4]                # 004ebde6
    mov edx, dword ptr [0x583106]                # 004ebdec
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004ebdf2
    mov eax, dword ptr [ebp - local_4]           # 004ebdf9
    mov dword ptr [eax + field_fd6], edx         # 004ebdfc
    mov ecx, dword ptr [ebp - local_4]           # 004ebe02
    mov dword ptr [ecx + field_fc6], 0x0         # 004ebe05
    jmp.d8 L_004ebe26                            # 004ebe0f
L_004ebe11:
    # block 0x004ebe11: entered by jmp at 0x004ebe82, 5 instruction(s), falls into the block at 0x004ebe26
    mov edx, dword ptr [ebp - local_4]           # 004ebe11
    mov eax, dword ptr [edx + field_fc6]         # 004ebe14
    add eax, 0x1                                 # 004ebe1a
    mov ecx, dword ptr [ebp - local_4]           # 004ebe1d
    mov dword ptr [ecx + field_fc6], eax         # 004ebe20
L_004ebe26:
    # block 0x004ebe26: entered by jmp at 0x004ebe0f, 3 instruction(s), ends with jge to 0x004ebe84 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ebe26
    cmp dword ptr [edx + field_fc6], 0x2         # 004ebe29
    jge.d8 L_004ebe84                            # 004ebe30
    # block 0x004ebe32: entered by fall-through of jge at 0x004ebe30, 6 instruction(s), ends with je to 0x004ebe82 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ebe32
    mov ecx, dword ptr [eax + field_fc6]         # 004ebe35
    imul ecx, ecx, 0xf7                          # 004ebe3b
    mov edx, dword ptr [ebp - local_4]           # 004ebe41
    cmp dword ptr [edx + ecx + field_985], 0x0   # 004ebe44
    je.d8 L_004ebe82                             # 004ebe4c
    # block 0x004ebe4e: entered by fall-through of je at 0x004ebe4c, 12 instruction(s), calls FUN_004e22fd, falls into the block at 0x004ebe82
    mov eax, dword ptr [ebp - local_4]           # 004ebe4e
    mov cx, word ptr [eax + field_fd6]           # 004ebe51
    push ecx                                     # 004ebe58
    mov edx, dword ptr [ebp - local_4]           # 004ebe59
    mov ax, word ptr [edx + field_fd2]           # 004ebe5c
    push eax                                     # 004ebe63
    mov ecx, dword ptr [ebp - local_4]           # 004ebe64
    mov edx, dword ptr [ecx + field_fc6]         # 004ebe67
    imul edx, edx, 0x18f                         # 004ebe6d
    mov eax, dword ptr [ebp - local_4]           # 004ebe73
    lea ecx, [eax + edx + field_ca8]             # 004ebe76
    call FUN_004e22fd                            # 004ebe7d
L_004ebe82:
    # block 0x004ebe82: entered by je at 0x004ebe4c, 1 instruction(s), ends with backward jump to 0x004ebe11
    jmp.d8 L_004ebe11                            # 004ebe82
L_004ebe84:
    # block 0x004ebe84: entered by jge at 0x004ebe30, 2 instruction(s), calls FUN_004ebe90, falls into the block at 0x004ebe8c
    mov ecx, dword ptr [ebp - local_4]           # 004ebe84
    call FUN_004ebe90                            # 004ebe87
L_004ebe8c:
    # block 0x004ebe8c: entered by jmp at 0x004ebda4; jmp at 0x004ebdb5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ebe8c
    pop ebp                                      # 004ebe8e
    ret                                          # 004ebe8f

