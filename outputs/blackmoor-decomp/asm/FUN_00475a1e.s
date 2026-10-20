# FUN_00475a1e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475a1e
# extent:       0x00475a1e-0x00475bef (465 code bytes)
# span:         0x00475a1e-0x00475bef (code 465, tables 0, padding 0)
# sha256:       022a3fc4f5992e9ca800848093f18a171b1402f6290de281942902b46fc9454b
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fill
# naming:       native port src/action_family_e4_runtime.c:fill (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    fill matches the original loops (rows body+0x42, cols +0x44), the all/single-cell gate, the rand % (kinds-1) retry against upper then left neighbour, kind/rect/present/matched stores and the call to the cell rect;
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_22, field_30, field_44; [ecx + n] field_2, field_30; [edx + n] field_1, field_30, field_42, field_46
# callees:      calls FUN_0050cd50, FUN_00475bef
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 127 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_22, 0x22  # offset +0x22
.equ field_30, 0x30  # offset +0x30
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_46, 0x46  # offset +0x46

# --- external targets -----------------------------------------------
.set FUN_00475bef, .text + (0x00475bef - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x00475a1e - 0x401000
.globl FUN_00475a1e
FUN_00475a1e:
    # block 0x00475a1e: entry, 11 instruction(s), ends with forward jump to 0x00475a51
    push ebp                                     # 00475a1e
    {load} mov ebp, esp                          # 00475a1f
    sub esp, 0x18                                # 00475a21
    mov dword ptr [ebp - local_18], ecx          # 00475a24
    mov eax, dword ptr [ebp - local_18]          # 00475a27
    movsx ecx, word ptr [eax + field_22]         # 00475a2a
    imul ecx, ecx, 0x8d                          # 00475a2e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00475a34
    mov dword ptr [ebp - local_4], edx           # 00475a3a
    mov word ptr [ebp - local_c], 0x0            # 00475a3d
    jmp.d8 L_00475a51                            # 00475a43
L_00475a45:
    # block 0x00475a45: entered by jmp at 0x00475be4, 3 instruction(s), falls into the block at 0x00475a51
    mov ax, word ptr [ebp - local_c]             # 00475a45
    .insn 0x66, 0x05, 0x0001{:u16}               # 00475a49
    mov word ptr [ebp - local_c], ax             # 00475a4d
L_00475a51:
    # block 0x00475a51: entered by jmp at 0x00475a43, 5 instruction(s), ends with jge to 0x00475be9 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00475a51
    mov edx, dword ptr [ebp - local_4]           # 00475a55
    movsx eax, word ptr [edx + field_42]         # 00475a58
    {load} cmp ecx, eax                          # 00475a5c
    jge.d32 L_00475be9                           # 00475a5e
    # block 0x00475a64: entered by fall-through of jge at 0x00475a5e, 2 instruction(s), ends with forward jump to 0x00475a78
    mov word ptr [ebp - local_14], 0x0           # 00475a64
    jmp.d8 L_00475a78                            # 00475a6a
L_00475a6c:
    # block 0x00475a6c: entered by jmp at 0x00475bdf, 3 instruction(s), falls into the block at 0x00475a78
    mov cx, word ptr [ebp - local_14]            # 00475a6c
    add cx, 0x1                                  # 00475a70
    mov word ptr [ebp - local_14], cx            # 00475a74
L_00475a78:
    # block 0x00475a78: entered by jmp at 0x00475a6a, 5 instruction(s), ends with jge to 0x00475be4 (forward)
    movsx edx, word ptr [ebp - local_14]         # 00475a78
    mov eax, dword ptr [ebp - local_4]           # 00475a7c
    movsx ecx, word ptr [eax + field_44]         # 00475a7f
    {load} cmp edx, ecx                          # 00475a83
    jge.d32 L_00475be4                           # 00475a85
    # block 0x00475a8b: entered by fall-through of jge at 0x00475a85, 4 instruction(s), ends with jne to 0x00475ab8 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00475a8b
    and edx, 0xff                                # 00475a8e
    test edx, edx                                # 00475a94
    jne.d8 L_00475ab8                            # 00475a96
    # block 0x00475a98: entered by fall-through of jne at 0x00475a96, 4 instruction(s), ends with jne to 0x00475bdf (forward)
    movsx eax, word ptr [ebp + arg_10]           # 00475a98
    movsx ecx, word ptr [ebp - local_14]         # 00475a9c
    {load} cmp eax, ecx                          # 00475aa0
    jne.d32 L_00475bdf                           # 00475aa2
    # block 0x00475aa8: entered by fall-through of jne at 0x00475aa2, 4 instruction(s), ends with jne to 0x00475bdf (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00475aa8
    movsx eax, word ptr [ebp - local_c]          # 00475aac
    {load} cmp edx, eax                          # 00475ab0
    jne.d32 L_00475bdf                           # 00475ab2
L_00475ab8:
    # block 0x00475ab8: entered by jne at 0x00475a96; fall-through of jne at 0x00475ab2, 1 instruction(s), falls into the block at 0x00475abc
    mov byte ptr [ebp - local_8], 0x1            # 00475ab8
L_00475abc:
    # block 0x00475abc: entered by jmp at 0x00475b51, 4 instruction(s), ends with je to 0x00475b56 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00475abc
    and ecx, 0xff                                # 00475abf
    test ecx, ecx                                # 00475ac5
    je.d32 L_00475b56                            # 00475ac7
    # block 0x00475acd: entered by fall-through of je at 0x00475ac7, 11 instruction(s), calls FUN_0050cd50, ends with jle to 0x00475b1d (forward)
    mov byte ptr [ebp - local_8], 0x0            # 00475acd
    call FUN_0050cd50                            # 00475ad1
    mov edx, dword ptr [ebp - local_4]           # 00475ad6
    movsx ecx, word ptr [edx + field_46]         # 00475ad9
    sub ecx, 0x1                                 # 00475add
    cdq                                          # 00475ae0
    idiv ecx                                     # 00475ae1
    mov word ptr [ebp - local_10], dx            # 00475ae3
    movsx edx, word ptr [ebp - local_c]          # 00475ae7
    test edx, edx                                # 00475aeb
    jle.d8 L_00475b1d                            # 00475aed
    # block 0x00475aef: entered by fall-through of jle at 0x00475aed, 11 instruction(s), ends with jne to 0x00475b1d (forward)
    movsx eax, word ptr [ebp - local_10]         # 00475aef
    movsx ecx, word ptr [ebp - local_c]          # 00475af3
    sub ecx, 0x1                                 # 00475af7
    imul ecx, ecx, 0xc8                          # 00475afa
    mov edx, dword ptr [ebp - local_18]          # 00475b00
    lea ecx, [edx + ecx + field_30]              # 00475b03
    movsx edx, word ptr [ebp - local_14]         # 00475b07
    imul edx, edx, 0x14                          # 00475b0b
    movsx ecx, word ptr [ecx + edx + field_2]    # 00475b0e
    {load} cmp eax, ecx                          # 00475b13
    jne.d8 L_00475b1d                            # 00475b15
    # block 0x00475b17: entered by fall-through of jne at 0x00475b15, 2 instruction(s), ends with forward jump to 0x00475b51
    mov byte ptr [ebp - local_8], 0x1            # 00475b17
    jmp.d8 L_00475b51                            # 00475b1b
L_00475b1d:
    # block 0x00475b1d: entered by jle at 0x00475aed; jne at 0x00475b15, 3 instruction(s), ends with jle to 0x00475b51 (forward)
    movsx edx, word ptr [ebp - local_14]         # 00475b1d
    test edx, edx                                # 00475b21
    jle.d8 L_00475b51                            # 00475b23
    # block 0x00475b25: entered by fall-through of jle at 0x00475b23, 11 instruction(s), ends with jne to 0x00475b51 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00475b25
    movsx ecx, word ptr [ebp - local_c]          # 00475b29
    imul ecx, ecx, 0xc8                          # 00475b2d
    mov edx, dword ptr [ebp - local_18]          # 00475b33
    lea ecx, [edx + ecx + field_30]              # 00475b36
    movsx edx, word ptr [ebp - local_14]         # 00475b3a
    sub edx, 0x1                                 # 00475b3e
    imul edx, edx, 0x14                          # 00475b41
    movsx ecx, word ptr [ecx + edx + field_2]    # 00475b44
    {load} cmp eax, ecx                          # 00475b49
    jne.d8 L_00475b51                            # 00475b4b
    # block 0x00475b4d: entered by fall-through of jne at 0x00475b4b, 1 instruction(s), falls into the block at 0x00475b51
    mov byte ptr [ebp - local_8], 0x1            # 00475b4d
L_00475b51:
    # block 0x00475b51: entered by jmp at 0x00475b1b; jle at 0x00475b23; jne at 0x00475b4b, 1 instruction(s), ends with backward jump to 0x00475abc
    jmp.d32 L_00475abc                           # 00475b51
L_00475b56:
    # block 0x00475b56: entered by je at 0x00475ac7, 36 instruction(s), calls FUN_00475bef, falls into the block at 0x00475bdf
    movsx edx, word ptr [ebp - local_c]          # 00475b56
    imul edx, edx, 0xc8                          # 00475b5a
    mov eax, dword ptr [ebp - local_18]          # 00475b60
    lea ecx, [eax + edx + field_30]              # 00475b63
    movsx edx, word ptr [ebp - local_14]         # 00475b67
    imul edx, edx, 0x14                          # 00475b6b
    mov ax, word ptr [ebp - local_10]            # 00475b6e
    mov word ptr [ecx + edx + field_2], ax       # 00475b72
    movsx ecx, word ptr [ebp - local_c]          # 00475b77
    imul ecx, ecx, 0xc8                          # 00475b7b
    mov edx, dword ptr [ebp - local_18]          # 00475b81
    lea eax, [edx + ecx + field_30]              # 00475b84
    movsx ecx, word ptr [ebp - local_14]         # 00475b88
    imul ecx, ecx, 0x14                          # 00475b8c
    lea edx, [eax + ecx + field_4]               # 00475b8f
    push edx                                     # 00475b93
    mov ax, word ptr [ebp - local_14]            # 00475b94
    push eax                                     # 00475b98
    mov cx, word ptr [ebp - local_c]             # 00475b99
    push ecx                                     # 00475b9d
    mov ecx, dword ptr [ebp - local_18]          # 00475b9e
    call FUN_00475bef                            # 00475ba1
    movsx edx, word ptr [ebp - local_c]          # 00475ba6
    imul edx, edx, 0xc8                          # 00475baa
    mov eax, dword ptr [ebp - local_18]          # 00475bb0
    lea ecx, [eax + edx + field_30]              # 00475bb3
    movsx edx, word ptr [ebp - local_14]         # 00475bb7
    imul edx, edx, 0x14                          # 00475bbb
    mov byte ptr [ecx + edx], 0x1                # 00475bbe
    movsx eax, word ptr [ebp - local_c]          # 00475bc2
    imul eax, eax, 0xc8                          # 00475bc6
    mov ecx, dword ptr [ebp - local_18]          # 00475bcc
    lea edx, [ecx + eax + field_30]              # 00475bcf
    movsx eax, word ptr [ebp - local_14]         # 00475bd3
    imul eax, eax, 0x14                          # 00475bd7
    mov byte ptr [edx + eax + field_1], 0x0      # 00475bda
L_00475bdf:
    # block 0x00475bdf: entered by jne at 0x00475aa2; jne at 0x00475ab2, 1 instruction(s), ends with backward jump to 0x00475a6c
    jmp.d32 L_00475a6c                           # 00475bdf
L_00475be4:
    # block 0x00475be4: entered by jge at 0x00475a85, 1 instruction(s), ends with backward jump to 0x00475a45
    jmp.d32 L_00475a45                           # 00475be4
L_00475be9:
    # block 0x00475be9: entered by jge at 0x00475a5e, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00475be9
    pop ebp                                      # 00475beb
    ret 0xc                                      # 00475bec

