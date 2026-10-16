# FUN_004f9040
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9040
# extent:       0x004f9040-0x004f9148 (264 code bytes)
# span:         0x004f9040-0x004f9148 (code 264, tables 0, padding 0)
# sha256:       bc6deb9d65f8d10b2a06294c1b79c0ef9575bf87d0477dc543bdafca8c06f2c4
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f9040
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_29b, field_2af, field_2b3, field_2b7, field_3ca, field_3d2; [ecx + n] field_4, field_8, field_29b, field_2af, field_2b7, field_3ca, field_3ce; [edx + n] field_4, field_8, field_50, field_29b, field_2b3, field_2b7, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 74 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_50, 0x50  # offset +0x50
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2b3, 0x2b3  # offset +0x2b3
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f9040 - 0x401000
.globl FUN_004f9040
FUN_004f9040:
    # block 0x004f9040: entry, 15 instruction(s), ends with je to 0x004f9140 (forward)
    push ebp                                     # 004f9040
    {load} mov ebp, esp                          # 004f9041
    sub esp, 0x8                                 # 004f9043
    mov dword ptr [ebp - local_8], ecx           # 004f9046
    mov eax, dword ptr [ebp + arg_8]             # 004f9049
    imul eax, eax, 0x5bb                         # 004f904c
    mov ecx, dword ptr [ebp - local_8]           # 004f9052
    mov edx, dword ptr [ecx + field_3ce]         # 004f9055
    {load} add edx, eax                          # 004f905b
    mov dword ptr [ebp - local_4], edx           # 004f905d
    mov eax, dword ptr [ebp - local_8]           # 004f9060
    mov dword ptr [eax + field_3ca], 0x0         # 004f9063
    mov ecx, dword ptr [ebp - local_4]           # 004f906d
    cmp dword ptr [ecx + field_29b], 0x0         # 004f9070
    je.d32 L_004f9140                            # 004f9077
    # block 0x004f907d: entered by fall-through of je at 0x004f9077, 3 instruction(s), ends with je to 0x004f9090 (forward)
    {load} xor edx, edx                          # 004f907d
    test edx, edx                                # 004f907f
    je.d8 L_004f9090                             # 004f9081
    # block 0x004f9083: entered by fall-through of je at 0x004f9081, 2 instruction(s), falls into the block at 0x004f9090
    mov eax, dword ptr [ebp - local_8]           # 004f9083
    mov dword ptr [eax + field_3d2], 0x1         # 004f9086
L_004f9090:
    # block 0x004f9090: entered by je at 0x004f9081, 46 instruction(s), calls indirect dword ptr [edx + 0x50], ends with jne to 0x004f913c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f9090
    add ecx, 0x2af                               # 004f9093
    mov edx, dword ptr [ebp + arg_c]             # 004f9099
    mov eax, dword ptr [edx]                     # 004f909c
    mov dword ptr [ecx], eax                     # 004f909e
    mov eax, dword ptr [edx + field_4]           # 004f90a0
    mov dword ptr [ecx + field_4], eax           # 004f90a3
    mov edx, dword ptr [edx + field_8]           # 004f90a6
    mov dword ptr [ecx + field_8], edx           # 004f90a9
    mov eax, dword ptr [ebp - local_4]           # 004f90ac
    fld dword ptr [eax + field_2af]              # 004f90af
    .insn 0xdc, 0xc0                             # 004f90b5
    mov ecx, dword ptr [ebp - local_4]           # 004f90b7
    fstp dword ptr [ecx + field_2af]             # 004f90ba
    mov edx, dword ptr [ebp - local_4]           # 004f90c0
    fld dword ptr [edx + field_2b3]              # 004f90c3
    .insn 0xdc, 0xc0                             # 004f90c9
    mov eax, dword ptr [ebp - local_4]           # 004f90cb
    fstp dword ptr [eax + field_2b3]             # 004f90ce
    mov ecx, dword ptr [ebp - local_4]           # 004f90d4
    fld dword ptr [ecx + field_2b7]              # 004f90d7
    .insn 0xdc, 0xc0                             # 004f90dd
    mov edx, dword ptr [ebp - local_4]           # 004f90df
    fstp dword ptr [edx + field_2b7]             # 004f90e2
    push 0x0                                     # 004f90e8
    mov eax, dword ptr [ebp - local_4]           # 004f90ea
    mov ecx, dword ptr [eax + field_2b7]         # 004f90ed
    push ecx                                     # 004f90f3
    mov edx, dword ptr [ebp - local_4]           # 004f90f4
    mov eax, dword ptr [edx + field_2b3]         # 004f90f7
    push eax                                     # 004f90fd
    mov ecx, dword ptr [ebp - local_4]           # 004f90fe
    mov edx, dword ptr [ecx + field_2af]         # 004f9101
    push edx                                     # 004f9107
    mov eax, dword ptr [ebp - local_4]           # 004f9108
    mov ecx, dword ptr [eax + field_29b]         # 004f910b
    mov edx, dword ptr [ebp - local_4]           # 004f9111
    mov eax, dword ptr [edx + field_29b]         # 004f9114
    mov edx, dword ptr [eax]                     # 004f911a
    push ecx                                     # 004f911c
    call dword ptr [edx + field_50]              # 004f911d
    mov ecx, dword ptr [ebp - local_8]           # 004f9120
    mov dword ptr [ecx + field_3ca], eax         # 004f9123
    mov edx, dword ptr [ebp - local_8]           # 004f9129
    cmp dword ptr [edx + field_3ca], 0x0         # 004f912c
    jne.d8 L_004f913c                            # 004f9133
    # block 0x004f9135: entered by fall-through of jne at 0x004f9133, 2 instruction(s), ends with forward jump to 0x004f9142
    mov eax, 0x1                                 # 004f9135
    jmp.d8 L_004f9142                            # 004f913a
L_004f913c:
    # block 0x004f913c: entered by jne at 0x004f9133, 2 instruction(s), ends with forward jump to 0x004f9142
    {load} xor eax, eax                          # 004f913c
    jmp.d8 L_004f9142                            # 004f913e
L_004f9140:
    # block 0x004f9140: entered by je at 0x004f9077, 1 instruction(s), falls into the block at 0x004f9142
    {load} xor eax, eax                          # 004f9140
L_004f9142:
    # block 0x004f9142: entered by jmp at 0x004f913a; jmp at 0x004f913e, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f9142
    pop ebp                                      # 004f9144
    ret 0x8                                      # 004f9145

