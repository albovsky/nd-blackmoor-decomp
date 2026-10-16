# FUN_005011b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005011b0
# extent:       0x005011b0-0x0050124f (159 code bytes)
# span:         0x005011b0-0x00501250 (code 159, tables 0, padding 1)
# sha256:       ef17a4f6b5b28ba498e4e54d095298372a75d2e8aab9449ec107f12c07b8a216
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005011b0
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_c
# fields:       [eax + n] field_4; [ecx + n] field_8, field_minus_4; [edi + n] field_minus_4; [esi + n] field_4, field_8, field_10, field_28
# callees:      calls FUN_0050c920, FUN_00501250, FUN_00501400
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 68 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00501250, .text + (0x00501250 - 0x401000)
.set FUN_00501400, .text + (0x00501400 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x005011b0 - 0x401000
.globl FUN_005011b0
FUN_005011b0:
    # block 0x005011b0: entry, 20 instruction(s), calls FUN_0050c920, ends with jle to 0x005011f6 (forward)
    push ebp                                     # 005011b0
    {load} mov ebp, esp                          # 005011b1
    push ebx                                     # 005011b3
    push esi                                     # 005011b4
    mov esi, dword ptr [ebp + arg_8]             # 005011b5
    push edi                                     # 005011b8
    mov edi, dword ptr [esi + field_28]          # 005011b9
    mov ebx, dword ptr [esi]                     # 005011bc
    lea eax, [4*edi]                             # 005011be
    add eax, 0x3                                 # 005011c5
    and al, -0x4                                 # 005011c8
    call FUN_0050c920                            # 005011ca
    mov eax, dword ptr [esi + field_4]           # 005011cf
    {load} mov edx, esp                          # 005011d2
    fld dword ptr [ebp + arg_18]                 # 005011d4
    fadd dword ptr [eax + field_4]               # 005011d7
    {load} xor eax, eax                          # 005011da
    mov dword ptr [ebp + arg_8], edx             # 005011dc
    test edi, edi                                # 005011df
    jle.d8 L_005011f6                            # 005011e1
    # block 0x005011e3: entered by fall-through of jle at 0x005011e1, 1 instruction(s), falls into the block at 0x005011e5
    {load} mov ecx, edx                          # 005011e3
L_005011e5:
    # block 0x005011e5: entered by jl at 0x005011f4, 6 instruction(s), ends with jl to 0x005011e5 (backward)
    mov dword ptr [ecx], 0xc61c3c00              # 005011e5
    mov edi, dword ptr [esi + field_28]          # 005011eb
    inc eax                                      # 005011ee
    add ecx, 0x4                                 # 005011ef
    {load} cmp eax, edi                          # 005011f2
    jl.d8 L_005011e5                             # 005011f4
L_005011f6:
    # block 0x005011f6: entered by jle at 0x005011e1; fall-through of jl at 0x005011f4, 5 instruction(s), ends with je to 0x00501208 (forward)
    mov ecx, dword ptr [esi + field_4]           # 005011f6
    fcom dword ptr [ecx + field_8]               # 005011f9
    fnstsw ax                                    # 005011fc
    test ah, 0x1                                 # 005011fe
    je.d8 L_00501208                             # 00501201
    # block 0x00501203: entered by fall-through of je at 0x00501201, 2 instruction(s), falls into the block at 0x00501208
    fstp st(0)                                   # 00501203
    fld dword ptr [ecx + field_8]                # 00501205
L_00501208:
    # block 0x00501208: entered by je at 0x00501201, 4 instruction(s), ends with jle to 0x00501223 (forward)
    mov edi, dword ptr [ebp + arg_10]            # 00501208
    {load} xor eax, eax                          # 0050120b
    test ebx, ebx                                # 0050120d
    jle.d8 L_00501223                            # 0050120f
L_00501211:
    # block 0x00501211: entered by jl at 0x00501221; fall-through of jle at 0x0050120f, 7 instruction(s), ends with jl to 0x00501211 (backward)
    mov ecx, dword ptr [esi + field_10]          # 00501211
    inc eax                                      # 00501214
    fld st(0)                                    # 00501215
    fadd dword ptr [ecx + 4*eax - field_minus_4] # 00501217
    {load} cmp eax, ebx                          # 0050121b
    fstp dword ptr [edi + 4*eax - field_minus_4] # 0050121d
    jl.d8 L_00501211                             # 00501221
L_00501223:
    # block 0x00501223: entered by jle at 0x0050120f; fall-through of jl at 0x00501221, 23 instruction(s), calls FUN_00501250, FUN_00501400, ends with ret
    mov eax, dword ptr [ebp + arg_14]            # 00501223
    mov ecx, dword ptr [ebp + arg_c]             # 00501226
    push eax                                     # 00501229
    push edx                                     # 0050122a
    mov edx, dword ptr [esi + field_8]           # 0050122b
    push edi                                     # 0050122e
    push ecx                                     # 0050122f
    push edx                                     # 00501230
    push esi                                     # 00501231
    fstp st(0)                                   # 00501232
    call FUN_00501250                            # 00501234
    mov eax, dword ptr [ebp + arg_8]             # 00501239
    push edi                                     # 0050123c
    push eax                                     # 0050123d
    push esi                                     # 0050123e
    call FUN_00501400                            # 0050123f
    add esp, 0x24                                # 00501244
    lea esp, [ebp - local_c]                     # 00501247
    pop edi                                      # 0050124a
    pop esi                                      # 0050124b
    pop ebx                                      # 0050124c
    pop ebp                                      # 0050124d
    ret                                          # 0050124e

# --- data items (not part of the function) -------------------------
.org 0x0050124f - 0x401000
PAD_0050124f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

