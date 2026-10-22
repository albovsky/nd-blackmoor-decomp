# FUN_0046cc8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046cc8b
# extent:       0x0046cc8b-0x0046cda0 (277 code bytes)
# span:         0x0046cc8b-0x0046cda0 (code 277, tables 0, padding 0)
# sha256:       2ae68db450cc66f10d3ef56073a2b3ed667db09372201c6e73f189995cb1e5e4
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046cc8b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1e, field_4f, field_4cc, field_48a0, field_48aa; [ecx + n] field_4ca, field_4a59; [edx + n] field_28, field_4cc, field_48a8, field_4a55
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25c.c:m46c6a9_click_27e2_27ea (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 71 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_1e, 0x1e  # offset +0x1e
.equ field_28, 0x28  # offset +0x28
.equ field_4f, 0x4f  # offset +0x4f
.equ field_4ca, 0x4ca  # offset +0x4ca
.equ field_4cc, 0x4cc  # offset +0x4cc
.equ field_48a0, 0x48a0  # offset +0x48a0
.equ field_48a8, 0x48a8  # offset +0x48a8
.equ field_48aa, 0x48aa  # offset +0x48aa
.equ field_4a55, 0x4a55  # offset +0x4a55
.equ field_4a59, 0x4a59  # offset +0x4a59

# --- external targets -----------------------------------------------

.org 0x0046cc8b - 0x401000
.globl FUN_0046cc8b
FUN_0046cc8b:
    # block 0x0046cc8b: entry, 11 instruction(s), ends with forward jump to 0x0046ccbc
    push ebp                                     # 0046cc8b
    {load} mov ebp, esp                          # 0046cc8c
    sub esp, 0x14                                # 0046cc8e
    mov dword ptr [ebp - local_14], ecx          # 0046cc91
    mov eax, dword ptr [ebp - local_14]          # 0046cc94
    movsx ecx, word ptr [eax + field_1e]         # 0046cc97
    imul ecx, ecx, 0x8d                          # 0046cc9b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046cca1
    mov dword ptr [ebp - local_4], edx           # 0046cca7
    mov dword ptr [ebp - local_c], 0x0           # 0046ccaa
    jmp.d8 L_0046ccbc                            # 0046ccb1
L_0046ccb3:
    # block 0x0046ccb3: entered by jmp at 0x0046cd97, 3 instruction(s), falls into the block at 0x0046ccbc
    mov eax, dword ptr [ebp - local_c]           # 0046ccb3
    add eax, 0x1                                 # 0046ccb6
    mov dword ptr [ebp - local_c], eax           # 0046ccb9
L_0046ccbc:
    # block 0x0046ccbc: entered by jmp at 0x0046ccb1, 4 instruction(s), ends with jge to 0x0046cd9c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046ccbc
    movsx edx, word ptr [ecx + field_4ca]        # 0046ccbf
    cmp dword ptr [ebp - local_c], edx           # 0046ccc6
    jge.d32 L_0046cd9c                           # 0046ccc9
    # block 0x0046cccf: entered by fall-through of jge at 0x0046ccc9, 2 instruction(s), falls into the block at 0x0046ccdd
    mov dword ptr [ebp - local_8], 0x1           # 0046cccf
    mov dword ptr [ebp - local_10], 0x0          # 0046ccd6
L_0046ccdd:
    # block 0x0046ccdd: entered by jmp at 0x0046cd73, 2 instruction(s), ends with jne to 0x0046cd78 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0046ccdd
    jne.d32 L_0046cd78                           # 0046cce1
    # block 0x0046cce7: entered by fall-through of jne at 0x0046cce1, 4 instruction(s), ends with jge to 0x0046cd78 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046cce7
    movsx ecx, word ptr [eax + field_4f]         # 0046ccea
    cmp dword ptr [ebp - local_10], ecx          # 0046ccee
    jge.d32 L_0046cd78                           # 0046ccf1
    # block 0x0046ccf7: entered by fall-through of jge at 0x0046ccf1, 5 instruction(s), ends with je to 0x0046cd63 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046ccf7
    shl edx, 0x4                                 # 0046ccfa
    mov eax, dword ptr [ebp - local_14]          # 0046ccfd
    cmp dword ptr [eax + edx + field_48a0], 0x0  # 0046cd00
    je.d8 L_0046cd63                             # 0046cd08
    # block 0x0046cd0a: entered by fall-through of je at 0x0046cd08, 12 instruction(s), ends with jne to 0x0046cd63 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046cd0a
    shl ecx, 0x4                                 # 0046cd0d
    mov edx, dword ptr [ebp - local_14]          # 0046cd10
    movsx eax, word ptr [edx + ecx + field_48a8] # 0046cd13
    mov ecx, dword ptr [ebp - local_c]           # 0046cd1b
    imul ecx, ecx, 0x50                          # 0046cd1e
    mov edx, dword ptr [ebp - local_4]           # 0046cd21
    lea ecx, [edx + ecx + field_4cc]             # 0046cd24
    mov edx, dword ptr [ebp - local_10]          # 0046cd2b
    movsx ecx, word ptr [ecx + 2*edx]            # 0046cd2e
    {load} cmp eax, ecx                          # 0046cd32
    jne.d8 L_0046cd63                            # 0046cd34
    # block 0x0046cd36: entered by fall-through of jne at 0x0046cd34, 12 instruction(s), ends with je to 0x0046cd6a (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046cd36
    shl edx, 0x4                                 # 0046cd39
    mov eax, dword ptr [ebp - local_14]          # 0046cd3c
    movsx ecx, word ptr [eax + edx + field_48aa] # 0046cd3f
    mov edx, dword ptr [ebp - local_c]           # 0046cd47
    imul edx, edx, 0x50                          # 0046cd4a
    mov eax, dword ptr [ebp - local_4]           # 0046cd4d
    lea edx, [eax + edx + field_4cc]             # 0046cd50
    mov eax, dword ptr [ebp - local_10]          # 0046cd57
    movsx edx, word ptr [edx + 2*eax + field_28] # 0046cd5a
    {load} cmp ecx, edx                          # 0046cd5f
    je.d8 L_0046cd6a                             # 0046cd61
L_0046cd63:
    # block 0x0046cd63: entered by je at 0x0046cd08; jne at 0x0046cd34; fall-through of je at 0x0046cd61, 1 instruction(s), falls into the block at 0x0046cd6a
    mov dword ptr [ebp - local_8], 0x0           # 0046cd63
L_0046cd6a:
    # block 0x0046cd6a: entered by je at 0x0046cd61, 4 instruction(s), ends with backward jump to 0x0046ccdd
    mov eax, dword ptr [ebp - local_10]          # 0046cd6a
    add eax, 0x1                                 # 0046cd6d
    mov dword ptr [ebp - local_10], eax          # 0046cd70
    jmp.d32 L_0046ccdd                           # 0046cd73
L_0046cd78:
    # block 0x0046cd78: entered by jne at 0x0046cce1; jge at 0x0046ccf1, 2 instruction(s), ends with jne to 0x0046cd97 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0046cd78
    jne.d8 L_0046cd97                            # 0046cd7c
    # block 0x0046cd7e: entered by fall-through of jne at 0x0046cd7c, 5 instruction(s), ends with forward jump to 0x0046cd9c
    mov ecx, dword ptr [ebp - local_14]          # 0046cd7e
    mov byte ptr [ecx + field_4a59], 0x1         # 0046cd81
    mov edx, dword ptr [ebp - local_14]          # 0046cd88
    mov dword ptr [edx + field_4a55], 0x2        # 0046cd8b
    jmp.d8 L_0046cd9c                            # 0046cd95
L_0046cd97:
    # block 0x0046cd97: entered by jne at 0x0046cd7c, 1 instruction(s), ends with backward jump to 0x0046ccb3
    jmp.d32 L_0046ccb3                           # 0046cd97
L_0046cd9c:
    # block 0x0046cd9c: entered by jge at 0x0046ccc9; jmp at 0x0046cd95, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046cd9c
    pop ebp                                      # 0046cd9e
    ret                                          # 0046cd9f

