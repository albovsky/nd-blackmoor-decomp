# FUN_0041db40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041db40
# extent:       0x0041db40-0x0041de29 (745 code bytes)
# span:         0x0041db40-0x0041de29 (code 745, tables 0, padding 0)
# sha256:       7cc75ace8699f28c8bc1b56ac952114d181ab80dd4992372b034bddab8a48c4a
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_conversation_object_release
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:402 says "0x41db40: the object image must not be used again"
# name-note:    Releases the conversation object image after it finishes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_2, field_793, field_795, field_799, field_79b, field_7a1; [ecx + n] field_2, field_793, field_795, field_79b, field_79f, field_7a1; [edx + n] field_2, field_795, field_799, field_79b, field_79f, field_7a1
# callees:      calls FUN_0044a2b7, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase2 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 189 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_793, 0x793  # offset +0x793
.equ field_795, 0x795  # offset +0x795
.equ field_799, 0x799  # offset +0x799
.equ field_79b, 0x79b  # offset +0x79b
.equ field_79f, 0x79f  # offset +0x79f
.equ field_7a1, 0x7a1  # offset +0x7a1

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041db40 - 0x401000
.globl FUN_0041db40
FUN_0041db40:
    # block 0x0041db40: entry, 7 instruction(s), ends with je to 0x0041db61 (forward)
    push ebp                                     # 0041db40
    {load} mov ebp, esp                          # 0041db41
    sub esp, 0x28                                # 0041db43
    mov dword ptr [ebp - local_28], ecx          # 0041db46
    movsx eax, word ptr [0x63a4cd]               # 0041db49
    test eax, eax                                # 0041db50
    je.d8 L_0041db61                             # 0041db52
    # block 0x0041db54: entered by fall-through of je at 0x0041db52, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041db61
    push 0x5437a8                                # 0041db54
    call FUN_0044a2b7                            # 0041db59
    add esp, 0x4                                 # 0041db5e
L_0041db61:
    # block 0x0041db61: entered by je at 0x0041db52, 4 instruction(s), ends with jne to 0x0041db79 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0041db61
    imul ecx, ecx, 0x8d                          # 0041db65
    cmp dword ptr [ecx + 0x5bb5e5], 0x0          # 0041db6b
    jne.d8 L_0041db79                            # 0041db72
    # block 0x0041db74: entered by fall-through of jne at 0x0041db72, 1 instruction(s), ends with forward jump to 0x0041de23
    jmp.d32 L_0041de23                           # 0041db74
L_0041db79:
    # block 0x0041db79: entered by jne at 0x0041db72, 8 instruction(s), ends with jle to 0x0041dc56 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0041db79
    imul edx, edx, 0x8d                          # 0041db7d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0041db83
    mov dword ptr [ebp - local_8], eax           # 0041db89
    mov ecx, dword ptr [ebp - local_8]           # 0041db8c
    movsx edx, word ptr [ecx + field_793]        # 0041db8f
    test edx, edx                                # 0041db96
    jle.d32 L_0041dc56                           # 0041db98
    # block 0x0041db9e: entered by fall-through of jle at 0x0041db98, 3 instruction(s), ends with je to 0x0041dc56 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0041db9e
    cmp dword ptr [eax + field_795], 0x0         # 0041dba1
    je.d32 L_0041dc56                            # 0041dba8
    # block 0x0041dbae: entered by fall-through of je at 0x0041dba8, 2 instruction(s), ends with forward jump to 0x0041dbc2
    mov word ptr [ebp - local_4], 0x0            # 0041dbae
    jmp.d8 L_0041dbc2                            # 0041dbb4
L_0041dbb6:
    # block 0x0041dbb6: entered by jmp at 0x0041dc2f, 3 instruction(s), falls into the block at 0x0041dbc2
    mov cx, word ptr [ebp - local_4]             # 0041dbb6
    add cx, 0x1                                  # 0041dbba
    mov word ptr [ebp - local_4], cx             # 0041dbbe
L_0041dbc2:
    # block 0x0041dbc2: entered by jmp at 0x0041dbb4, 5 instruction(s), ends with jge to 0x0041dc31 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041dbc2
    mov eax, dword ptr [ebp - local_8]           # 0041dbc6
    movsx ecx, word ptr [eax + field_793]        # 0041dbc9
    {load} cmp edx, ecx                          # 0041dbd0
    jge.d8 L_0041dc31                            # 0041dbd2
    # block 0x0041dbd4: entered by fall-through of jge at 0x0041dbd2, 7 instruction(s), ends with jle to 0x0041dc2f (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041dbd4
    imul edx, edx, 0x1d1                         # 0041dbd8
    mov eax, dword ptr [ebp - local_8]           # 0041dbde
    mov ecx, dword ptr [eax + field_795]         # 0041dbe1
    movsx edx, word ptr [ecx + edx]              # 0041dbe7
    test edx, edx                                # 0041dbeb
    jle.d8 L_0041dc2f                            # 0041dbed
    # block 0x0041dbef: entered by fall-through of jle at 0x0041dbed, 6 instruction(s), ends with je to 0x0041dc2f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041dbef
    imul eax, eax, 0x1d1                         # 0041dbf3
    mov ecx, dword ptr [ebp - local_8]           # 0041dbf9
    mov edx, dword ptr [ecx + field_795]         # 0041dbfc
    cmp dword ptr [edx + eax + field_2], 0x0     # 0041dc02
    je.d8 L_0041dc2f                             # 0041dc07
    # block 0x0041dc09: entered by fall-through of je at 0x0041dc07, 10 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041dc2f
    movsx eax, word ptr [ebp - local_4]          # 0041dc09
    imul eax, eax, 0x1d1                         # 0041dc0d
    mov ecx, dword ptr [ebp - local_8]           # 0041dc13
    mov edx, dword ptr [ecx + field_795]         # 0041dc16
    mov eax, dword ptr [edx + eax + field_2]     # 0041dc1c
    mov dword ptr [ebp - local_c], eax           # 0041dc20
    mov ecx, dword ptr [ebp - local_c]           # 0041dc23
    push ecx                                     # 0041dc26
    call FUN_0051dc6c                            # 0041dc27
    add esp, 0x4                                 # 0041dc2c
L_0041dc2f:
    # block 0x0041dc2f: entered by jle at 0x0041dbed; je at 0x0041dc07, 1 instruction(s), ends with backward jump to 0x0041dbb6
    jmp.d8 L_0041dbb6                            # 0041dc2f
L_0041dc31:
    # block 0x0041dc31: entered by jge at 0x0041dbd2, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041dc56
    mov edx, dword ptr [ebp - local_8]           # 0041dc31
    mov eax, dword ptr [edx + field_795]         # 0041dc34
    mov dword ptr [ebp - local_10], eax          # 0041dc3a
    mov ecx, dword ptr [ebp - local_10]          # 0041dc3d
    push ecx                                     # 0041dc40
    call FUN_0051dc6c                            # 0041dc41
    add esp, 0x4                                 # 0041dc46
    mov edx, dword ptr [ebp - local_8]           # 0041dc49
    mov dword ptr [edx + field_795], 0x0         # 0041dc4c
L_0041dc56:
    # block 0x0041dc56: entered by jle at 0x0041db98; je at 0x0041dba8, 4 instruction(s), ends with jle to 0x0041dd17 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0041dc56
    movsx ecx, word ptr [eax + field_799]        # 0041dc59
    test ecx, ecx                                # 0041dc60
    jle.d32 L_0041dd17                           # 0041dc62
    # block 0x0041dc68: entered by fall-through of jle at 0x0041dc62, 3 instruction(s), ends with je to 0x0041dd17 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041dc68
    cmp dword ptr [edx + field_79b], 0x0         # 0041dc6b
    je.d32 L_0041dd17                            # 0041dc72
    # block 0x0041dc78: entered by fall-through of je at 0x0041dc72, 2 instruction(s), ends with forward jump to 0x0041dc8c
    mov word ptr [ebp - local_4], 0x0            # 0041dc78
    jmp.d8 L_0041dc8c                            # 0041dc7e
L_0041dc80:
    # block 0x0041dc80: entered by jmp at 0x0041dcf0, 3 instruction(s), falls into the block at 0x0041dc8c
    mov ax, word ptr [ebp - local_4]             # 0041dc80
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041dc84
    mov word ptr [ebp - local_4], ax             # 0041dc88
L_0041dc8c:
    # block 0x0041dc8c: entered by jmp at 0x0041dc7e, 5 instruction(s), ends with jge to 0x0041dcf2 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041dc8c
    mov edx, dword ptr [ebp - local_8]           # 0041dc90
    movsx eax, word ptr [edx + field_799]        # 0041dc93
    {load} cmp ecx, eax                          # 0041dc9a
    jge.d8 L_0041dcf2                            # 0041dc9c
    # block 0x0041dc9e: entered by fall-through of jge at 0x0041dc9c, 7 instruction(s), ends with jle to 0x0041dcf0 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041dc9e
    imul ecx, ecx, 0x1c                          # 0041dca2
    mov edx, dword ptr [ebp - local_8]           # 0041dca5
    mov eax, dword ptr [edx + field_79b]         # 0041dca8
    movsx ecx, word ptr [eax + ecx]              # 0041dcae
    test ecx, ecx                                # 0041dcb2
    jle.d8 L_0041dcf0                            # 0041dcb4
    # block 0x0041dcb6: entered by fall-through of jle at 0x0041dcb4, 6 instruction(s), ends with je to 0x0041dcf0 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041dcb6
    imul edx, edx, 0x1c                          # 0041dcba
    mov eax, dword ptr [ebp - local_8]           # 0041dcbd
    mov ecx, dword ptr [eax + field_79b]         # 0041dcc0
    cmp dword ptr [ecx + edx + field_2], 0x0     # 0041dcc6
    je.d8 L_0041dcf0                             # 0041dccb
    # block 0x0041dccd: entered by fall-through of je at 0x0041dccb, 10 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041dcf0
    movsx edx, word ptr [ebp - local_4]          # 0041dccd
    imul edx, edx, 0x1c                          # 0041dcd1
    mov eax, dword ptr [ebp - local_8]           # 0041dcd4
    mov ecx, dword ptr [eax + field_79b]         # 0041dcd7
    mov edx, dword ptr [ecx + edx + field_2]     # 0041dcdd
    mov dword ptr [ebp - local_14], edx          # 0041dce1
    mov eax, dword ptr [ebp - local_14]          # 0041dce4
    push eax                                     # 0041dce7
    call FUN_0051dc6c                            # 0041dce8
    add esp, 0x4                                 # 0041dced
L_0041dcf0:
    # block 0x0041dcf0: entered by jle at 0x0041dcb4; je at 0x0041dccb, 1 instruction(s), ends with backward jump to 0x0041dc80
    jmp.d8 L_0041dc80                            # 0041dcf0
L_0041dcf2:
    # block 0x0041dcf2: entered by jge at 0x0041dc9c, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041dd17
    mov ecx, dword ptr [ebp - local_8]           # 0041dcf2
    mov edx, dword ptr [ecx + field_79b]         # 0041dcf5
    mov dword ptr [ebp - local_18], edx          # 0041dcfb
    mov eax, dword ptr [ebp - local_18]          # 0041dcfe
    push eax                                     # 0041dd01
    call FUN_0051dc6c                            # 0041dd02
    add esp, 0x4                                 # 0041dd07
    mov ecx, dword ptr [ebp - local_8]           # 0041dd0a
    mov dword ptr [ecx + field_79b], 0x0         # 0041dd0d
L_0041dd17:
    # block 0x0041dd17: entered by jle at 0x0041dc62; je at 0x0041dc72, 4 instruction(s), ends with jle to 0x0041ddd8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041dd17
    movsx eax, word ptr [edx + field_79f]        # 0041dd1a
    test eax, eax                                # 0041dd21
    jle.d32 L_0041ddd8                           # 0041dd23
    # block 0x0041dd29: entered by fall-through of jle at 0x0041dd23, 3 instruction(s), ends with je to 0x0041ddd8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041dd29
    cmp dword ptr [ecx + field_7a1], 0x0         # 0041dd2c
    je.d32 L_0041ddd8                            # 0041dd33
    # block 0x0041dd39: entered by fall-through of je at 0x0041dd33, 2 instruction(s), ends with forward jump to 0x0041dd4d
    mov word ptr [ebp - local_4], 0x0            # 0041dd39
    jmp.d8 L_0041dd4d                            # 0041dd3f
L_0041dd41:
    # block 0x0041dd41: entered by jmp at 0x0041ddb1, 3 instruction(s), falls into the block at 0x0041dd4d
    mov dx, word ptr [ebp - local_4]             # 0041dd41
    add dx, 0x1                                  # 0041dd45
    mov word ptr [ebp - local_4], dx             # 0041dd49
L_0041dd4d:
    # block 0x0041dd4d: entered by jmp at 0x0041dd3f, 5 instruction(s), ends with jge to 0x0041ddb3 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041dd4d
    mov ecx, dword ptr [ebp - local_8]           # 0041dd51
    movsx edx, word ptr [ecx + field_79f]        # 0041dd54
    {load} cmp eax, edx                          # 0041dd5b
    jge.d8 L_0041ddb3                            # 0041dd5d
    # block 0x0041dd5f: entered by fall-through of jge at 0x0041dd5d, 7 instruction(s), ends with jle to 0x0041ddb1 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041dd5f
    imul eax, eax, 0xa                           # 0041dd63
    mov ecx, dword ptr [ebp - local_8]           # 0041dd66
    mov edx, dword ptr [ecx + field_7a1]         # 0041dd69
    movsx eax, word ptr [edx + eax]              # 0041dd6f
    test eax, eax                                # 0041dd73
    jle.d8 L_0041ddb1                            # 0041dd75
    # block 0x0041dd77: entered by fall-through of jle at 0x0041dd75, 6 instruction(s), ends with je to 0x0041ddb1 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041dd77
    imul ecx, ecx, 0xa                           # 0041dd7b
    mov edx, dword ptr [ebp - local_8]           # 0041dd7e
    mov eax, dword ptr [edx + field_7a1]         # 0041dd81
    cmp dword ptr [eax + ecx + field_2], 0x0     # 0041dd87
    je.d8 L_0041ddb1                             # 0041dd8c
    # block 0x0041dd8e: entered by fall-through of je at 0x0041dd8c, 10 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041ddb1
    movsx ecx, word ptr [ebp - local_4]          # 0041dd8e
    imul ecx, ecx, 0xa                           # 0041dd92
    mov edx, dword ptr [ebp - local_8]           # 0041dd95
    mov eax, dword ptr [edx + field_7a1]         # 0041dd98
    mov ecx, dword ptr [eax + ecx + field_2]     # 0041dd9e
    mov dword ptr [ebp - local_1c], ecx          # 0041dda2
    mov edx, dword ptr [ebp - local_1c]          # 0041dda5
    push edx                                     # 0041dda8
    call FUN_0051dc6c                            # 0041dda9
    add esp, 0x4                                 # 0041ddae
L_0041ddb1:
    # block 0x0041ddb1: entered by jle at 0x0041dd75; je at 0x0041dd8c, 1 instruction(s), ends with backward jump to 0x0041dd41
    jmp.d8 L_0041dd41                            # 0041ddb1
L_0041ddb3:
    # block 0x0041ddb3: entered by jge at 0x0041dd5d, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041ddd8
    mov eax, dword ptr [ebp - local_8]           # 0041ddb3
    mov ecx, dword ptr [eax + field_7a1]         # 0041ddb6
    mov dword ptr [ebp - local_20], ecx          # 0041ddbc
    mov edx, dword ptr [ebp - local_20]          # 0041ddbf
    push edx                                     # 0041ddc2
    call FUN_0051dc6c                            # 0041ddc3
    add esp, 0x4                                 # 0041ddc8
    mov eax, dword ptr [ebp - local_8]           # 0041ddcb
    mov dword ptr [eax + field_7a1], 0x0         # 0041ddce
L_0041ddd8:
    # block 0x0041ddd8: entered by jle at 0x0041dd23; je at 0x0041dd33, 14 instruction(s), calls FUN_0051dc6c, ends with je to 0x0041de23 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0041ddd8
    imul ecx, ecx, 0x8d                          # 0041dddc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0041dde2
    mov dword ptr [ebp - local_24], edx          # 0041dde8
    mov eax, dword ptr [ebp - local_24]          # 0041ddeb
    push eax                                     # 0041ddee
    call FUN_0051dc6c                            # 0041ddef
    add esp, 0x4                                 # 0041ddf4
    movsx ecx, word ptr [ebp + arg_8]            # 0041ddf7
    imul ecx, ecx, 0x8d                          # 0041ddfb
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 0041de01
    movsx edx, word ptr [0x63a4cd]               # 0041de0b
    test edx, edx                                # 0041de12
    je.d8 L_0041de23                             # 0041de14
    # block 0x0041de16: entered by fall-through of je at 0x0041de14, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041de23
    push 0x5437d4                                # 0041de16
    call FUN_0044a2b7                            # 0041de1b
    add esp, 0x4                                 # 0041de20
L_0041de23:
    # block 0x0041de23: entered by jmp at 0x0041db74; je at 0x0041de14, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041de23
    pop ebp                                      # 0041de25
    ret 0x4                                      # 0041de26

