# FUN_00466247
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00466247
# extent:       0x00466247-0x004662d8 (145 code bytes)
# span:         0x00466247-0x004662d8 (code 145, tables 0, padding 0)
# sha256:       dbfe205ba337f96f8210022dc7c7870751b2cd0091cc2dd3e5a91881f3b5034f
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00466247
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_45; [ecx + n] field_2e, field_42, field_4e, field_3cc; [edx + n] field_50, field_4ea
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m466247_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2e, 0x2e  # offset +0x2e
.equ field_42, 0x42  # offset +0x42
.equ field_45, 0x45  # offset +0x45
.equ field_4e, 0x4e  # offset +0x4e
.equ field_50, 0x50  # offset +0x50
.equ field_3cc, 0x3cc  # offset +0x3cc
.equ field_4ea, 0x4ea  # offset +0x4ea

# --- external targets -----------------------------------------------

.org 0x00466247 - 0x401000
.globl FUN_00466247
FUN_00466247:
    # block 0x00466247: entry, 11 instruction(s), ends with forward jump to 0x00466278
    push ebp                                     # 00466247
    {load} mov ebp, esp                          # 00466248
    sub esp, 0xc                                 # 0046624a
    mov dword ptr [ebp - local_c], ecx           # 0046624d
    mov eax, dword ptr [ebp - local_c]           # 00466250
    movsx ecx, word ptr [eax + field_1e]         # 00466253
    imul ecx, ecx, 0x8d                          # 00466257
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046625d
    mov dword ptr [ebp - local_8], edx           # 00466263
    mov dword ptr [ebp - local_4], 0x0           # 00466266
    jmp.d8 L_00466278                            # 0046626d
L_0046626f:
    # block 0x0046626f: entered by jmp at 0x004662a3, 3 instruction(s), falls into the block at 0x00466278
    mov eax, dword ptr [ebp - local_4]           # 0046626f
    add eax, 0x1                                 # 00466272
    mov dword ptr [ebp - local_4], eax           # 00466275
L_00466278:
    # block 0x00466278: entered by jmp at 0x0046626d, 4 instruction(s), ends with jge to 0x004662a5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00466278
    movsx edx, word ptr [ecx + field_42]         # 0046627b
    cmp dword ptr [ebp - local_4], edx           # 0046627f
    jge.d8 L_004662a5                            # 00466282
    # block 0x00466284: entered by fall-through of jge at 0x00466282, 8 instruction(s), ends with je to 0x004662a3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00466284
    mov ecx, dword ptr [ebp - local_c]           # 00466287
    movsx edx, word ptr [ecx + 2*eax + field_2e] # 0046628a
    mov eax, dword ptr [ebp - local_4]           # 0046628f
    mov ecx, dword ptr [ebp - local_8]           # 00466292
    movsx eax, word ptr [ecx + 2*eax + field_3cc] # 00466295
    {load} cmp edx, eax                          # 0046629d
    je.d8 L_004662a3                             # 0046629f
    # block 0x004662a1: entered by fall-through of je at 0x0046629f, 1 instruction(s), ends with forward jump to 0x004662d4
    jmp.d8 L_004662d4                            # 004662a1
L_004662a3:
    # block 0x004662a3: entered by je at 0x0046629f, 1 instruction(s), ends with backward jump to 0x0046626f
    jmp.d8 L_0046626f                            # 004662a3
L_004662a5:
    # block 0x004662a5: entered by jge at 0x00466282, 11 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004662d4
    mov ecx, dword ptr [ebp - local_c]           # 004662a5
    mov byte ptr [ecx + field_4e], 0x1           # 004662a8
    call dword ptr [0x52a23c]                    # 004662ac
    mov edx, dword ptr [ebp - local_8]           # 004662b2
    movsx ecx, word ptr [edx + field_4ea]        # 004662b5
    imul ecx, ecx, 0x3e8                         # 004662bc
    {load} add eax, ecx                          # 004662c2
    mov edx, dword ptr [ebp - local_c]           # 004662c4
    mov dword ptr [edx + field_50], eax          # 004662c7
    mov eax, dword ptr [ebp - local_c]           # 004662ca
    mov dword ptr [eax + field_45], 0x2          # 004662cd
L_004662d4:
    # block 0x004662d4: entered by jmp at 0x004662a1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004662d4
    pop ebp                                      # 004662d6
    ret                                          # 004662d7

