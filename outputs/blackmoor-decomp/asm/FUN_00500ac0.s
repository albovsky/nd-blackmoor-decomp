# FUN_00500ac0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500ac0
# extent:       0x00500ac0-0x00500ba5 (229 code bytes)
# span:         0x00500ac0-0x00500bb0 (code 229, tables 0, padding 11)
# sha256:       0be552ad2ecb9c3ef02507231d06b2d9b653bb990f801cec2beaa2b8b0423740
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500ac0
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_10
# fields:       [eax + n] field_4, field_18, field_minus_4; [ecx + n] field_4, field_80; [edi + n] field_minus_4; [edx + n] field_18, field_150, field_minus_4
# callees:      calls FUN_0050c920, FUN_00500bb0, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18
.equ field_80, 0x80  # offset +0x80
.equ field_150, 0x150  # offset +0x150

# --- external targets -----------------------------------------------
.set FUN_00500bb0, .text + (0x00500bb0 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00500ac0 - 0x401000
.globl FUN_00500ac0
FUN_00500ac0:
    # block 0x00500ac0: entry, 27 instruction(s), calls FUN_0050c920, FUN_00500bb0, ends with jle to 0x00500b2b (forward)
    push ebp                                     # 00500ac0
    {load} mov ebp, esp                          # 00500ac1
    push ecx                                     # 00500ac3
    mov eax, dword ptr [ebp + arg_8]             # 00500ac4
    push ebx                                     # 00500ac7
    push esi                                     # 00500ac8
    push edi                                     # 00500ac9
    mov esi, dword ptr [eax]                     # 00500aca
    lea eax, [4*esi]                             # 00500acc
    add eax, 0x3                                 # 00500ad3
    and al, -0x4                                 # 00500ad6
    call FUN_0050c920                            # 00500ad8
    mov edx, dword ptr [ebp + arg_8]             # 00500add
    mov edi, dword ptr [ebp + arg_10]            # 00500ae0
    mov ecx, dword ptr [ebp + arg_c]             # 00500ae3
    {load} mov ebx, esp                          # 00500ae6
    mov eax, dword ptr [edx + field_18]          # 00500ae8
    push -0x1                                    # 00500aeb
    push 0x430c0000                              # 00500aed
    push edi                                     # 00500af2
    push ecx                                     # 00500af3
    push eax                                     # 00500af4
    push esi                                     # 00500af5
    call FUN_00500bb0                            # 00500af6
    add esp, 0x18                                # 00500afb
    test esi, esi                                # 00500afe
    jle.d8 L_00500b2b                            # 00500b00
    # block 0x00500b02: entered by fall-through of jle at 0x00500b00, 7 instruction(s), falls into the block at 0x00500b13
    mov ecx, dword ptr [ebp + arg_c]             # 00500b02
    {load} mov edx, ebx                          # 00500b05
    {load} sub ecx, edi                          # 00500b07
    {load} sub edx, edi                          # 00500b09
    {load} mov eax, edi                          # 00500b0b
    mov dword ptr [ebp - local_4], edx           # 00500b0d
    mov dword ptr [ebp + arg_10], esi            # 00500b10
L_00500b13:
    # block 0x00500b13: entered by jne at 0x00500b29, 9 instruction(s), ends with jne to 0x00500b13 (backward)
    fld dword ptr [ecx + eax]                    # 00500b13
    fsub dword ptr [eax]                         # 00500b16
    mov edx, dword ptr [ebp - local_4]           # 00500b18
    add eax, 0x4                                 # 00500b1b
    fstp dword ptr [edx + eax - field_minus_4]   # 00500b1e
    mov edx, dword ptr [ebp + arg_10]            # 00500b22
    dec edx                                      # 00500b25
    mov dword ptr [ebp + arg_10], edx            # 00500b26
    jne.d8 L_00500b13                            # 00500b29
L_00500b2b:
    # block 0x00500b2b: entered by jle at 0x00500b00; fall-through of jne at 0x00500b29, 14 instruction(s), calls FUN_00500bb0, ends with jle to 0x00500b9b (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00500b2b
    mov ecx, dword ptr [eax + field_4]           # 00500b2e
    mov eax, dword ptr [eax + field_18]          # 00500b31
    mov edx, dword ptr [ecx + field_80]          # 00500b34
    push edx                                     # 00500b3a
    push 0x0                                     # 00500b3b
    push edi                                     # 00500b3d
    push ebx                                     # 00500b3e
    push eax                                     # 00500b3f
    push esi                                     # 00500b40
    call FUN_00500bb0                            # 00500b41
    add esp, 0x18                                # 00500b46
    test esi, esi                                # 00500b49
    jle.d8 L_00500b9b                            # 00500b4b
    # block 0x00500b4d: entered by fall-through of jle at 0x00500b4b, 4 instruction(s), falls into the block at 0x00500b56
    mov ecx, dword ptr [ebp + arg_c]             # 00500b4d
    {load} mov eax, ebx                          # 00500b50
    {load} sub ecx, ebx                          # 00500b52
    {load} mov edx, esi                          # 00500b54
L_00500b56:
    # block 0x00500b56: entered by jne at 0x00500b62, 6 instruction(s), ends with jne to 0x00500b56 (backward)
    fld dword ptr [ecx + eax]                    # 00500b56
    fsub dword ptr [eax]                         # 00500b59
    add eax, 0x4                                 # 00500b5b
    dec edx                                      # 00500b5e
    fstp dword ptr [eax - field_minus_4]         # 00500b5f
    jne.d8 L_00500b56                            # 00500b62
    # block 0x00500b64: entered by fall-through of jne at 0x00500b62, 2 instruction(s), ends with jle to 0x00500b9b (forward)
    test esi, esi                                # 00500b64
    jle.d8 L_00500b9b                            # 00500b66
    # block 0x00500b68: entered by fall-through of jle at 0x00500b66, 1 instruction(s), falls into the block at 0x00500b6a
    {load} sub ebx, edi                          # 00500b68
L_00500b6a:
    # block 0x00500b6a: entered by jne at 0x00500b99, 5 instruction(s), calls FUN_0050ce04, ends with jl to 0x00500b81 (forward)
    fld dword ptr [edi]                          # 00500b6a
    fadd qword ptr [0x52cac0]                    # 00500b6c
    call FUN_0050ce04                            # 00500b72
    cmp eax, 0x28                                # 00500b77
    jl.d8 L_00500b81                             # 00500b7a
    # block 0x00500b7c: entered by fall-through of jl at 0x00500b7a, 1 instruction(s), falls into the block at 0x00500b81
    mov eax, 0x27                                # 00500b7c
L_00500b81:
    # block 0x00500b81: entered by jl at 0x00500b7a, 8 instruction(s), ends with jne to 0x00500b6a (backward)
    mov ecx, dword ptr [ebp + arg_8]             # 00500b81
    add edi, 0x4                                 # 00500b84
    dec esi                                      # 00500b87
    mov edx, dword ptr [ecx + field_4]           # 00500b88
    fld dword ptr [edx + 4*eax + field_150]      # 00500b8b
    fadd dword ptr [edi + ebx - field_minus_4]   # 00500b92
    fstp dword ptr [edi - field_minus_4]         # 00500b96
    jne.d8 L_00500b6a                            # 00500b99
L_00500b9b:
    # block 0x00500b9b: entered by jle at 0x00500b4b; jle at 0x00500b66; fall-through of jne at 0x00500b99, 7 instruction(s), ends with ret
    lea esp, [ebp - local_10]                    # 00500b9b
    pop edi                                      # 00500b9e
    pop esi                                      # 00500b9f
    pop ebx                                      # 00500ba0
    {load} mov esp, ebp                          # 00500ba1
    pop ebp                                      # 00500ba3
    ret                                          # 00500ba4

# --- data items (not part of the function) -------------------------
.org 0x00500ba5 - 0x401000
PAD_00500ba5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

