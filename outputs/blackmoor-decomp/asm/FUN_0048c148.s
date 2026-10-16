# FUN_0048c148
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048c148
# extent:       0x0048c148-0x0048c1c0 (120 code bytes)
# span:         0x0048c148-0x0048c1c0 (code 120, tables 0, padding 0)
# sha256:       2b105ddd7273f114a0822a0ff60de71c6ccbc25f7f9803be13d0dd0c9fad1de7
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048c148
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_28, field_34, field_46; [ecx + n] field_28, field_50; [edx + n] field_1c, field_26, field_40
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_34, 0x34  # offset +0x34
.equ field_40, 0x40  # offset +0x40
.equ field_46, 0x46  # offset +0x46
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------

.org 0x0048c148 - 0x401000
.globl FUN_0048c148
FUN_0048c148:
    # block 0x0048c148: entry, 9 instruction(s), ends with je to 0x0048c1bc (forward)
    push ebp                                     # 0048c148
    {load} mov ebp, esp                          # 0048c149
    push ecx                                     # 0048c14b
    mov dword ptr [ebp - local_4], ecx           # 0048c14c
    mov eax, dword ptr [ebp - local_4]           # 0048c14f
    {load} xor ecx, ecx                          # 0048c152
    mov cl, byte ptr [eax + field_46]            # 0048c154
    test ecx, ecx                                # 0048c157
    je.d8 L_0048c1bc                             # 0048c159
    # block 0x0048c15b: entered by fall-through of je at 0x0048c159, 5 instruction(s), ends with jne to 0x0048c1bc (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048c15b
    movsx eax, word ptr [edx + field_26]         # 0048c15e
    imul eax, eax, 0x8d                          # 0048c162
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0048c168
    jne.d8 L_0048c1bc                            # 0048c16f
    # block 0x0048c171: entered by fall-through of jne at 0x0048c16f, 2 instruction(s), ends with jne to 0x0048c1bc (forward)
    cmp dword ptr [0x5c39e5], 0x27a7             # 0048c171
    jne.d8 L_0048c1bc                            # 0048c17b
    # block 0x0048c17d: entered by fall-through of jne at 0x0048c17b, 7 instruction(s), ends with je to 0x0048c1bc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048c17d
    movsx edx, word ptr [ecx + field_28]         # 0048c180
    mov eax, dword ptr [ebp - local_4]           # 0048c184
    {load} xor ecx, ecx                          # 0048c187
    mov cl, byte ptr [eax + edx + field_34]      # 0048c189
    test ecx, ecx                                # 0048c18d
    je.d8 L_0048c1bc                             # 0048c18f
    # block 0x0048c191: entered by fall-through of je at 0x0048c18f, 5 instruction(s), ends with jne to 0x0048c1a9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048c191
    {load} xor eax, eax                          # 0048c194
    mov al, byte ptr [edx + field_40]            # 0048c196
    test eax, eax                                # 0048c199
    jne.d8 L_0048c1a9                            # 0048c19b
    # block 0x0048c19d: entered by fall-through of jne at 0x0048c19b, 3 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0048c1a9
    call dword ptr [0x52a23c]                    # 0048c19d
    mov ecx, dword ptr [ebp - local_4]           # 0048c1a3
    mov dword ptr [ecx + field_50], eax          # 0048c1a6
L_0048c1a9:
    # block 0x0048c1a9: entered by jne at 0x0048c19b, 6 instruction(s), falls into the block at 0x0048c1bc
    mov edx, dword ptr [ebp - local_4]           # 0048c1a9
    mov eax, dword ptr [ebp - local_4]           # 0048c1ac
    mov cl, byte ptr [eax + field_28]            # 0048c1af
    mov byte ptr [edx + field_1c], cl            # 0048c1b2
    mov edx, dword ptr [ebp - local_4]           # 0048c1b5
    mov byte ptr [edx + field_40], 0x1           # 0048c1b8
L_0048c1bc:
    # block 0x0048c1bc: entered by je at 0x0048c159; jne at 0x0048c16f; jne at 0x0048c17b; je at 0x0048c18f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048c1bc
    pop ebp                                      # 0048c1be
    ret                                          # 0048c1bf

