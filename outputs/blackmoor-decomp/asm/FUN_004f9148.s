# FUN_004f9148
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9148
# extent:       0x004f9148-0x004f9234 (236 code bytes)
# span:         0x004f9148-0x004f9234 (code 236, tables 0, padding 0)
# sha256:       ae75d6ac57b930085e8309b005ba88a830754f05e7ca7589479a43cfd63268b2
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f9148
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_50, field_29b, field_2b3, field_2b7, field_3ca, field_3d2; [ecx + n] field_29b, field_2af, field_2b3, field_2b7, field_3ca, field_3ce; [edx + n] field_2af, field_2b7, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_50, 0x50  # offset +0x50
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2b3, 0x2b3  # offset +0x2b3
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f9148 - 0x401000
.globl FUN_004f9148
FUN_004f9148:
    # block 0x004f9148: entry, 15 instruction(s), ends with je to 0x004f922c (forward)
    push ebp                                     # 004f9148
    {load} mov ebp, esp                          # 004f9149
    sub esp, 0x8                                 # 004f914b
    mov dword ptr [ebp - local_8], ecx           # 004f914e
    mov eax, dword ptr [ebp + arg_8]             # 004f9151
    imul eax, eax, 0x5bb                         # 004f9154
    mov ecx, dword ptr [ebp - local_8]           # 004f915a
    mov edx, dword ptr [ecx + field_3ce]         # 004f915d
    {load} add edx, eax                          # 004f9163
    mov dword ptr [ebp - local_4], edx           # 004f9165
    mov eax, dword ptr [ebp - local_8]           # 004f9168
    mov dword ptr [eax + field_3ca], 0x0         # 004f916b
    mov ecx, dword ptr [ebp - local_4]           # 004f9175
    cmp dword ptr [ecx + field_29b], 0x0         # 004f9178
    je.d32 L_004f922c                            # 004f917f
    # block 0x004f9185: entered by fall-through of je at 0x004f917f, 3 instruction(s), ends with je to 0x004f9198 (forward)
    {load} xor edx, edx                          # 004f9185
    test edx, edx                                # 004f9187
    je.d8 L_004f9198                             # 004f9189
    # block 0x004f918b: entered by fall-through of je at 0x004f9189, 2 instruction(s), falls into the block at 0x004f9198
    mov eax, dword ptr [ebp - local_8]           # 004f918b
    mov dword ptr [eax + field_3d2], 0x1         # 004f918e
L_004f9198:
    # block 0x004f9198: entered by je at 0x004f9189, 37 instruction(s), calls indirect dword ptr [eax + 0x50], ends with jne to 0x004f9228 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f9198
    fld dword ptr [ecx + field_2af]              # 004f919b
    .insn 0xdc, 0xc0                             # 004f91a1
    mov edx, dword ptr [ebp - local_4]           # 004f91a3
    fstp dword ptr [edx + field_2af]             # 004f91a6
    mov eax, dword ptr [ebp - local_4]           # 004f91ac
    fld dword ptr [eax + field_2b3]              # 004f91af
    .insn 0xdc, 0xc0                             # 004f91b5
    mov ecx, dword ptr [ebp - local_4]           # 004f91b7
    fstp dword ptr [ecx + field_2b3]             # 004f91ba
    mov edx, dword ptr [ebp - local_4]           # 004f91c0
    fld dword ptr [edx + field_2b7]              # 004f91c3
    .insn 0xdc, 0xc0                             # 004f91c9
    mov eax, dword ptr [ebp - local_4]           # 004f91cb
    fstp dword ptr [eax + field_2b7]             # 004f91ce
    push 0x0                                     # 004f91d4
    mov ecx, dword ptr [ebp - local_4]           # 004f91d6
    mov edx, dword ptr [ecx + field_2b7]         # 004f91d9
    push edx                                     # 004f91df
    mov eax, dword ptr [ebp - local_4]           # 004f91e0
    mov ecx, dword ptr [eax + field_2b3]         # 004f91e3
    push ecx                                     # 004f91e9
    mov edx, dword ptr [ebp - local_4]           # 004f91ea
    mov eax, dword ptr [edx + field_2af]         # 004f91ed
    push eax                                     # 004f91f3
    mov ecx, dword ptr [ebp - local_4]           # 004f91f4
    mov edx, dword ptr [ecx + field_29b]         # 004f91f7
    mov eax, dword ptr [ebp - local_4]           # 004f91fd
    mov ecx, dword ptr [eax + field_29b]         # 004f9200
    mov eax, dword ptr [ecx]                     # 004f9206
    push edx                                     # 004f9208
    call dword ptr [eax + field_50]              # 004f9209
    mov ecx, dword ptr [ebp - local_8]           # 004f920c
    mov dword ptr [ecx + field_3ca], eax         # 004f920f
    mov edx, dword ptr [ebp - local_8]           # 004f9215
    cmp dword ptr [edx + field_3ca], 0x0         # 004f9218
    jne.d8 L_004f9228                            # 004f921f
    # block 0x004f9221: entered by fall-through of jne at 0x004f921f, 2 instruction(s), ends with forward jump to 0x004f922e
    mov eax, 0x1                                 # 004f9221
    jmp.d8 L_004f922e                            # 004f9226
L_004f9228:
    # block 0x004f9228: entered by jne at 0x004f921f, 2 instruction(s), ends with forward jump to 0x004f922e
    {load} xor eax, eax                          # 004f9228
    jmp.d8 L_004f922e                            # 004f922a
L_004f922c:
    # block 0x004f922c: entered by je at 0x004f917f, 1 instruction(s), falls into the block at 0x004f922e
    {load} xor eax, eax                          # 004f922c
L_004f922e:
    # block 0x004f922e: entered by jmp at 0x004f9226; jmp at 0x004f922a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f922e
    pop ebp                                      # 004f9230
    ret 0x4                                      # 004f9231

