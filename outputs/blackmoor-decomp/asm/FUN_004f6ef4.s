# FUN_004f6ef4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6ef4
# extent:       0x004f6ef4-0x004f709c (424 code bytes)
# span:         0x004f6ef4-0x004f709c (code 424, tables 0, padding 0)
# sha256:       c68cffc7ff7cab44a5e0d8cd127ab4c68bdb9252eabd15c6983dcc5062bd4e74
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f6ef4_advance_record
# naming:       native port src/original_methods_fl28b.c:m4f6ef4_advance_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Advances a record: the guard chain with its three store/return arms, the n == -1 trace arm and the single-precision x87 quotient through the real __ftol with two signed clamps; fully executed. See tasks/fl28b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_17a, field_17e, field_182, field_28f, field_3c2; [ecx + n] field_17e, field_3c2; [edx + n] field_162, field_176, field_17a, field_182, field_3ce
# callees:      calls FUN_004f709c, FUN_004f6334, FUN_004f81fa, FUN_0050ca3e, FUN_0044a2b7, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m4f6ef4_advance_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 116 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ field_162, 0x162  # offset +0x162
.equ field_176, 0x176  # offset +0x176
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f81fa, .text + (0x004f81fa - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004f6ef4 - 0x401000
.globl FUN_004f6ef4
FUN_004f6ef4:
    # block 0x004f6ef4: entry, 17 instruction(s), calls FUN_004f709c, ends with jne to 0x004f6f49 (forward)
    push ebp                                     # 004f6ef4
    {load} mov ebp, esp                          # 004f6ef5
    sub esp, 0x20                                # 004f6ef7
    mov dword ptr [ebp - local_10], ecx          # 004f6efa
    mov eax, dword ptr [ebp - local_10]          # 004f6efd
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6f00
    mov ecx, dword ptr [ebp + arg_8]             # 004f6f0a
    imul ecx, ecx, 0x5bb                         # 004f6f0d
    mov edx, dword ptr [ebp - local_10]          # 004f6f13
    mov eax, dword ptr [edx + field_3ce]         # 004f6f16
    {load} add eax, ecx                          # 004f6f1c
    mov dword ptr [ebp - local_c], eax           # 004f6f1e
    mov dword ptr [ebp - local_8], 0x0           # 004f6f21
    mov ecx, dword ptr [ebp - local_10]          # 004f6f28
    call FUN_004f709c                            # 004f6f2b
    test eax, eax                                # 004f6f30
    jne.d8 L_004f6f49                            # 004f6f32
    # block 0x004f6f34: entered by fall-through of jne at 0x004f6f32, 4 instruction(s), ends with forward jump to 0x004f7096
    mov ecx, dword ptr [ebp - local_10]          # 004f6f34
    mov dword ptr [ecx + field_3c2], 0x3ea       # 004f6f37
    or eax, -0x1                                 # 004f6f41
    jmp.d32 L_004f7096                           # 004f6f44
L_004f6f49:
    # block 0x004f6f49: entered by jne at 0x004f6f32, 3 instruction(s), ends with je to 0x004f6f61 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004f6f49
    cmp dword ptr [edx + field_162], 0x0         # 004f6f4c
    je.d8 L_004f6f61                             # 004f6f53
    # block 0x004f6f55: entered by fall-through of je at 0x004f6f53, 3 instruction(s), ends with jne to 0x004f6f76 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f6f55
    cmp dword ptr [eax + field_28f], 0x0         # 004f6f58
    jne.d8 L_004f6f76                            # 004f6f5f
L_004f6f61:
    # block 0x004f6f61: entered by je at 0x004f6f53; fall-through of jne at 0x004f6f5f, 4 instruction(s), ends with forward jump to 0x004f7096
    mov ecx, dword ptr [ebp - local_10]          # 004f6f61
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f6f64
    or eax, -0x1                                 # 004f6f6e
    jmp.d32 L_004f7096                           # 004f6f71
L_004f6f76:
    # block 0x004f6f76: entered by jne at 0x004f6f5f, 6 instruction(s), calls FUN_004f6334, ends with je to 0x004f701a (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004f6f76
    push edx                                     # 004f6f79
    mov ecx, dword ptr [ebp - local_10]          # 004f6f7a
    call FUN_004f6334                            # 004f6f7d
    test eax, eax                                # 004f6f82
    je.d32 L_004f701a                            # 004f6f84
    # block 0x004f6f8a: entered by fall-through of je at 0x004f6f84, 7 instruction(s), calls FUN_004f81fa, ends with jne to 0x004f6fe9 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f6f8a
    push eax                                     # 004f6f8d
    mov ecx, dword ptr [ebp - local_10]          # 004f6f8e
    call FUN_004f81fa                            # 004f6f91
    mov dword ptr [ebp - local_4], eax           # 004f6f96
    cmp dword ptr [ebp - local_4], -0x1          # 004f6f99
    jne.d8 L_004f6fe9                            # 004f6f9d
    # block 0x004f6f9f: entered by fall-through of jne at 0x004f6f9d, 3 instruction(s), ends with je to 0x004f6fd4 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f6f9f
    test ecx, ecx                                # 004f6fa6
    je.d8 L_004f6fd4                             # 004f6fa8
    # block 0x004f6faa: entered by fall-through of je at 0x004f6fa8, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f6fd4
    mov edx, dword ptr [ebp - local_c]           # 004f6faa
    add edx, 0x4                                 # 004f6fad
    push edx                                     # 004f6fb0
    mov eax, dword ptr [ebp + arg_8]             # 004f6fb1
    push eax                                     # 004f6fb4
    push 0x55e994                                # 004f6fb5
    push 0x63888b                                # 004f6fba
    call FUN_0050ca3e                            # 004f6fbf
    add esp, 0x10                                # 004f6fc4
    push 0x63888b                                # 004f6fc7
    call FUN_0044a2b7                            # 004f6fcc
    add esp, 0x4                                 # 004f6fd1
L_004f6fd4:
    # block 0x004f6fd4: entered by je at 0x004f6fa8, 4 instruction(s), ends with forward jump to 0x004f7096
    mov ecx, dword ptr [ebp - local_10]          # 004f6fd4
    mov dword ptr [ecx + field_3c2], 0x410       # 004f6fd7
    or eax, -0x1                                 # 004f6fe1
    jmp.d32 L_004f7096                           # 004f6fe4
L_004f6fe9:
    # block 0x004f6fe9: entered by jne at 0x004f6f9d, 2 instruction(s), ends with jle to 0x004f7011 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004f6fe9
    jle.d8 L_004f7011                            # 004f6fed
    # block 0x004f6fef: entered by fall-through of jle at 0x004f6fed, 10 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004f7018
    fild dword ptr [ebp - local_4]               # 004f6fef
    fstp dword ptr [ebp - local_14]              # 004f6ff2
    mov edx, dword ptr [ebp - local_c]           # 004f6ff5
    fild dword ptr [edx + field_176]             # 004f6ff8
    fstp dword ptr [ebp - local_18]              # 004f6ffe
    fld dword ptr [ebp - local_14]               # 004f7001
    fdiv dword ptr [ebp - local_18]              # 004f7004
    call FUN_0050ce04                            # 004f7007
    mov dword ptr [ebp - local_8], eax           # 004f700c
    jmp.d8 L_004f7018                            # 004f700f
L_004f7011:
    # block 0x004f7011: entered by jle at 0x004f6fed, 1 instruction(s), falls into the block at 0x004f7018
    mov dword ptr [ebp - local_8], 0x0           # 004f7011
L_004f7018:
    # block 0x004f7018: entered by jmp at 0x004f700f, 1 instruction(s), ends with forward jump to 0x004f701f
    jmp.d8 L_004f701f                            # 004f7018
L_004f701a:
    # block 0x004f701a: entered by je at 0x004f6f84, 2 instruction(s), ends with forward jump to 0x004f7096
    or eax, -0x1                                 # 004f701a
    jmp.d8 L_004f7096                            # 004f701d
L_004f701f:
    # block 0x004f701f: entered by jmp at 0x004f7018, 4 instruction(s), ends with jle to 0x004f7035 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f701f
    mov ecx, dword ptr [ebp - local_8]           # 004f7022
    cmp ecx, dword ptr [eax + field_182]         # 004f7025
    jle.d8 L_004f7035                            # 004f702b
    # block 0x004f702d: entered by fall-through of jle at 0x004f702b, 3 instruction(s), ends with forward jump to 0x004f7041
    mov edx, dword ptr [ebp - local_8]           # 004f702d
    mov dword ptr [ebp - local_1c], edx          # 004f7030
    jmp.d8 L_004f7041                            # 004f7033
L_004f7035:
    # block 0x004f7035: entered by jle at 0x004f702b, 3 instruction(s), falls into the block at 0x004f7041
    mov eax, dword ptr [ebp - local_c]           # 004f7035
    mov ecx, dword ptr [eax + field_182]         # 004f7038
    mov dword ptr [ebp - local_1c], ecx          # 004f703e
L_004f7041:
    # block 0x004f7041: entered by jmp at 0x004f7033, 7 instruction(s), ends with jge to 0x004f7069 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004f7041
    mov dword ptr [ebp - local_8], edx           # 004f7044
    mov eax, dword ptr [ebp - local_c]           # 004f7047
    mov ecx, dword ptr [eax + field_17a]         # 004f704a
    sub ecx, 0x1                                 # 004f7050
    cmp ecx, dword ptr [ebp - local_8]           # 004f7053
    jge.d8 L_004f7069                            # 004f7056
    # block 0x004f7058: entered by fall-through of jge at 0x004f7056, 5 instruction(s), ends with forward jump to 0x004f706f
    mov edx, dword ptr [ebp - local_c]           # 004f7058
    mov eax, dword ptr [edx + field_17a]         # 004f705b
    sub eax, 0x1                                 # 004f7061
    mov dword ptr [ebp - local_20], eax          # 004f7064
    jmp.d8 L_004f706f                            # 004f7067
L_004f7069:
    # block 0x004f7069: entered by jge at 0x004f7056, 2 instruction(s), falls into the block at 0x004f706f
    mov ecx, dword ptr [ebp - local_8]           # 004f7069
    mov dword ptr [ebp - local_20], ecx          # 004f706c
L_004f706f:
    # block 0x004f706f: entered by jmp at 0x004f7067, 10 instruction(s), falls into the block at 0x004f7096
    mov edx, dword ptr [ebp - local_20]          # 004f706f
    mov dword ptr [ebp - local_8], edx           # 004f7072
    mov eax, dword ptr [ebp - local_c]           # 004f7075
    mov ecx, dword ptr [ebp - local_8]           # 004f7078
    mov dword ptr [eax + field_17e], ecx         # 004f707b
    mov edx, dword ptr [ebp - local_c]           # 004f7081
    mov eax, dword ptr [ebp - local_8]           # 004f7084
    mov dword ptr [edx + field_182], eax         # 004f7087
    mov ecx, dword ptr [ebp - local_c]           # 004f708d
    mov eax, dword ptr [ecx + field_17e]         # 004f7090
L_004f7096:
    # block 0x004f7096: entered by jmp at 0x004f6f44; jmp at 0x004f6f71; jmp at 0x004f6fe4; jmp at 0x004f701d, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f7096
    pop ebp                                      # 004f7098
    ret 0x4                                      # 004f7099

