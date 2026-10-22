# FUN_004d3eba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3eba
# extent:       0x004d3eba-0x004d3fa9 (239 code bytes)
# span:         0x004d3eba-0x004d3fa9 (code 239, tables 0, padding 0)
# sha256:       0879be9a8510a303715cc4c3b85f395d40ae6dd706ad418d4609db190c05b663
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3eba
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_324, field_43e, field_444, field_452, field_456; [ecx + n] field_320, field_43e, field_462; [edx + n] field_43e, field_444, field_462
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_320, 0x320  # offset +0x320
.equ field_324, 0x324  # offset +0x324
.equ field_43e, 0x43e  # offset +0x43e
.equ field_444, 0x444  # offset +0x444
.equ field_452, 0x452  # offset +0x452
.equ field_456, 0x456  # offset +0x456
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x004d3eba - 0x401000
.globl FUN_004d3eba
FUN_004d3eba:
    # block 0x004d3eba: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d3fa5 (forward)
    push ebp                                     # 004d3eba
    {load} mov ebp, esp                          # 004d3ebb
    sub esp, 0x8                                 # 004d3ebd
    mov dword ptr [ebp - local_8], ecx           # 004d3ec0
    call dword ptr [0x52a23c]                    # 004d3ec3
    mov dword ptr [ebp - local_4], eax           # 004d3ec9
    mov eax, dword ptr [ebp - local_8]           # 004d3ecc
    mov ecx, dword ptr [ebp - local_4]           # 004d3ecf
    cmp ecx, dword ptr [eax + field_452]         # 004d3ed2
    jbe.d32 L_004d3fa5                           # 004d3ed8
    # block 0x004d3ede: entered by fall-through of jbe at 0x004d3ed8, 3 instruction(s), ends with je to 0x004d3f4e (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d3ede
    cmp dword ptr [edx + field_444], 0x0         # 004d3ee1
    je.d8 L_004d3f4e                             # 004d3ee8
    # block 0x004d3eea: entered by fall-through of je at 0x004d3ee8, 9 instruction(s), ends with jl to 0x004d3f4c (forward)
    mov eax, dword ptr [ebp - local_8]           # 004d3eea
    mov cx, word ptr [eax + field_43e]           # 004d3eed
    add cx, 0x1                                  # 004d3ef4
    mov edx, dword ptr [ebp - local_8]           # 004d3ef8
    mov word ptr [edx + field_43e], cx           # 004d3efb
    mov eax, dword ptr [ebp - local_8]           # 004d3f02
    movsx ecx, word ptr [eax + field_43e]        # 004d3f05
    cmp ecx, 0x7                                 # 004d3f0c
    jl.d8 L_004d3f4c                             # 004d3f0f
    # block 0x004d3f11: entered by fall-through of jl at 0x004d3f0f, 11 instruction(s), falls into the block at 0x004d3f4c
    mov edx, dword ptr [ebp - local_8]           # 004d3f11
    mov word ptr [edx + field_43e], 0x6          # 004d3f14
    mov eax, dword ptr [ebp - local_8]           # 004d3f1d
    mov dword ptr [eax + field_444], 0x0         # 004d3f20
    mov ecx, dword ptr [ebp - local_8]           # 004d3f2a
    mov edx, dword ptr [ebp - local_4]           # 004d3f2d
    add edx, dword ptr [ecx + field_320]         # 004d3f30
    mov eax, dword ptr [ebp - local_8]           # 004d3f36
    mov dword ptr [eax + field_456], edx         # 004d3f39
    mov ecx, dword ptr [ebp - local_8]           # 004d3f3f
    mov dword ptr [ecx + field_462], 0x2         # 004d3f42
L_004d3f4c:
    # block 0x004d3f4c: entered by jl at 0x004d3f0f, 1 instruction(s), ends with forward jump to 0x004d3f8d
    jmp.d8 L_004d3f8d                            # 004d3f4c
L_004d3f4e:
    # block 0x004d3f4e: entered by je at 0x004d3ee8, 9 instruction(s), ends with jge to 0x004d3f8d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d3f4e
    mov ax, word ptr [edx + field_43e]           # 004d3f51
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004d3f58
    mov ecx, dword ptr [ebp - local_8]           # 004d3f5c
    mov word ptr [ecx + field_43e], ax           # 004d3f5f
    mov edx, dword ptr [ebp - local_8]           # 004d3f66
    movsx eax, word ptr [edx + field_43e]        # 004d3f69
    test eax, eax                                # 004d3f70
    jge.d8 L_004d3f8d                            # 004d3f72
    # block 0x004d3f74: entered by fall-through of jge at 0x004d3f72, 4 instruction(s), falls into the block at 0x004d3f8d
    mov ecx, dword ptr [ebp - local_8]           # 004d3f74
    mov word ptr [ecx + field_43e], 0x0          # 004d3f77
    mov edx, dword ptr [ebp - local_8]           # 004d3f80
    mov dword ptr [edx + field_462], 0x3         # 004d3f83
L_004d3f8d:
    # block 0x004d3f8d: entered by jmp at 0x004d3f4c; jge at 0x004d3f72, 6 instruction(s), falls into the block at 0x004d3fa5
    mov eax, dword ptr [ebp - local_8]           # 004d3f8d
    movsx ecx, word ptr [eax + field_324]        # 004d3f90
    mov edx, dword ptr [ebp - local_4]           # 004d3f97
    {load} add edx, ecx                          # 004d3f9a
    mov eax, dword ptr [ebp - local_8]           # 004d3f9c
    mov dword ptr [eax + field_452], edx         # 004d3f9f
L_004d3fa5:
    # block 0x004d3fa5: entered by jbe at 0x004d3ed8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3fa5
    pop ebp                                      # 004d3fa7
    ret                                          # 004d3fa8

