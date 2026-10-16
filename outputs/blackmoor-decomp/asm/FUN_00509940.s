# FUN_00509940
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509940
# extent:       0x00509940-0x00509b39 (505 code bytes)
# span:         0x00509940-0x00509b40 (code 505, tables 0, padding 7)
# sha256:       9e5e5ba4890a81096e007e14665a4849f91d91eb914b5170b1f333a87ac3670e
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509940
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4, field_minus_10, field_minus_14, field_minus_18, field_minus_1c, field_minus_20, field_minus_24; [ebp + n] field_minus_20; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_38, stk_40, stk_44 and 3 more
# callees:      calls FUN_0050e19e, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 164 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_24, 0x24  # offset -0x24
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_38, 0x38  # offset +0x38
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)

.org 0x00509940 - 0x401000
.globl FUN_00509940
FUN_00509940:
    # block 0x00509940: entry, 27 instruction(s), ends with jle to 0x005099e7 (forward)
    sub esp, 0x2c                                # 00509940
    push ebx                                     # 00509943
    push ebp                                     # 00509944
    mov ebp, dword ptr [esp + stk_38]            # 00509945
    push esi                                     # 00509949
    push edi                                     # 0050994a
    {load} xor ecx, ecx                          # 0050994b
    {disp8} mov eax, dword ptr [ebp]             # 0050994d
    {load} xor edx, edx                          # 00509950
    mov dword ptr [esp + stk_38], eax            # 00509952
    mov eax, dword ptr [esp + stk_44]            # 00509956
    {load} xor esi, esi                          # 0050995a
    {load} xor edi, edi                          # 0050995c
    lea eax, [eax + 8*eax]                       # 0050995e
    {load} xor ebx, ebx                          # 00509961
    mov dword ptr [esp + stk_10], ecx            # 00509963
    mov dword ptr [esp + stk_14], edx            # 00509967
    mov eax, dword ptr [ebp + 4*eax - field_minus_20] # 0050996b
    mov ebp, dword ptr [esp + stk_44]            # 0050996f
    test ebp, ebp                                # 00509973
    mov dword ptr [esp + stk_18], esi            # 00509975
    mov dword ptr [esp + stk_28], ecx            # 00509979
    mov dword ptr [esp + stk_1c], edi            # 0050997d
    mov dword ptr [esp + stk_30], ecx            # 00509981
    mov dword ptr [esp + stk_20], ebx            # 00509985
    mov dword ptr [esp + stk_24], eax            # 00509989
    jle.d8 L_005099e7                            # 0050998d
    # block 0x0050998f: entered by fall-through of jle at 0x0050998d, 3 instruction(s), falls into the block at 0x0050999a
    mov eax, dword ptr [esp + stk_40]            # 0050998f
    mov dword ptr [esp + stk_44], ebp            # 00509993
    add eax, 0xc                                 # 00509997
L_0050999a:
    # block 0x0050999a: entered by jne at 0x005099cd, 19 instruction(s), ends with jne to 0x0050999a (backward)
    mov ebp, dword ptr [eax - field_minus_4]     # 0050999a
    add eax, 0x24                                # 0050999d
    {load} add ecx, ebp                          # 005099a0
    mov ebp, dword ptr [eax - field_minus_24]    # 005099a2
    {load} add edx, ebp                          # 005099a5
    mov ebp, dword ptr [eax - field_minus_20]    # 005099a7
    {load} add esi, ebp                          # 005099aa
    mov ebp, dword ptr [eax - field_minus_1c]    # 005099ac
    add dword ptr [esp + stk_28], ebp            # 005099af
    mov ebp, dword ptr [eax - field_minus_18]    # 005099b3
    {load} add edi, ebp                          # 005099b6
    mov ebp, dword ptr [eax - field_minus_14]    # 005099b8
    add dword ptr [esp + stk_30], ebp            # 005099bb
    mov ebp, dword ptr [eax - field_minus_10]    # 005099bf
    {load} add ebx, ebp                          # 005099c2
    mov ebp, dword ptr [esp + stk_44]            # 005099c4
    dec ebp                                      # 005099c8
    mov dword ptr [esp + stk_44], ebp            # 005099c9
    jne.d8 L_0050999a                            # 005099cd
    # block 0x005099cf: entered by fall-through of jne at 0x005099cd, 6 instruction(s), falls into the block at 0x005099e7
    mov eax, dword ptr [esp + stk_24]            # 005099cf
    mov dword ptr [esp + stk_20], ebx            # 005099d3
    mov dword ptr [esp + stk_1c], edi            # 005099d7
    mov dword ptr [esp + stk_18], esi            # 005099db
    mov dword ptr [esp + stk_14], edx            # 005099df
    mov dword ptr [esp + stk_10], ecx            # 005099e3
L_005099e7:
    # block 0x005099e7: entered by jle at 0x0050998d, 5 instruction(s), ends with jl to 0x00509a27 (forward)
    mov ebp, dword ptr [esp + stk_48]            # 005099e7
    {disp8} mov ebp, dword ptr [ebp]             # 005099eb
    test ebp, ebp                                # 005099ee
    mov dword ptr [esp + stk_44], ebp            # 005099f0
    jl.d8 L_00509a27                             # 005099f4
    # block 0x005099f6: entered by fall-through of jl at 0x005099f4, 16 instruction(s), falls into the block at 0x00509a27
    mov eax, dword ptr [esp + stk_38]            # 005099f6
    {load} add edx, ebp                          # 005099fa
    {load} mov ebp, eax                          # 005099fc
    {load} add ecx, eax                          # 005099fe
    imul ebp, eax                                # 00509a00
    {load} add esi, ebp                          # 00509a03
    mov ebp, dword ptr [esp + stk_44]            # 00509a05
    imul ebp, eax                                # 00509a09
    mov eax, dword ptr [esp + stk_24]            # 00509a0c
    {load} add edi, ebp                          # 00509a10
    inc ebx                                      # 00509a12
    mov dword ptr [esp + stk_10], ecx            # 00509a13
    mov dword ptr [esp + stk_14], edx            # 00509a17
    mov dword ptr [esp + stk_18], esi            # 00509a1b
    mov dword ptr [esp + stk_1c], edi            # 00509a1f
    mov dword ptr [esp + stk_20], ebx            # 00509a23
L_00509a27:
    # block 0x00509a27: entered by jl at 0x005099f4, 4 instruction(s), ends with jl to 0x00509a57 (forward)
    mov ebp, dword ptr [esp + stk_4c]            # 00509a27
    {disp8} mov ebp, dword ptr [ebp]             # 00509a2b
    test ebp, ebp                                # 00509a2e
    jl.d8 L_00509a57                             # 00509a30
    # block 0x00509a32: entered by fall-through of jl at 0x00509a30, 13 instruction(s), falls into the block at 0x00509a57
    {load} add ecx, eax                          # 00509a32
    {load} add edx, ebp                          # 00509a34
    mov dword ptr [esp + stk_10], ecx            # 00509a36
    {load} mov ecx, eax                          # 00509a3a
    imul ecx, eax                                # 00509a3c
    imul ebp, eax                                # 00509a3f
    {load} add esi, ecx                          # 00509a42
    {load} add edi, ebp                          # 00509a44
    inc ebx                                      # 00509a46
    mov dword ptr [esp + stk_14], edx            # 00509a47
    mov dword ptr [esp + stk_18], esi            # 00509a4b
    mov dword ptr [esp + stk_1c], edi            # 00509a4f
    mov dword ptr [esp + stk_20], ebx            # 00509a53
L_00509a57:
    # block 0x00509a57: entered by jl at 0x00509a30, 54 instruction(s), calls FUN_0050e19e, FUN_0050ce04, ends with jle to 0x00509b0c (forward)
    fild dword ptr [esp + stk_10]                # 00509a57
    fild dword ptr [esp + stk_14]                # 00509a5b
    fild dword ptr [esp + stk_18]                # 00509a5f
    sub esp, 0x8                                 # 00509a63
    fstp qword ptr [esp + stk_38]                # 00509a66
    fild dword ptr [esp + stk_24]                # 00509a6a
    fild dword ptr [esp + stk_28]                # 00509a6e
    fld st(0)                                    # 00509a72
    fmul qword ptr [esp + stk_38]                # 00509a74
    fld st(4)                                    # 00509a78
    fmul st, st(5)                               # 00509a7a
    fsubp st(1), st                              # 00509a7c
    fdivr qword ptr [0x52c598]                   # 00509a7e
    fld qword ptr [esp + stk_38]                 # 00509a84
    fmul st, st(4)                               # 00509a88
    fld st(3)                                    # 00509a8a
    fmul st, st(6)                               # 00509a8c
    fsubp st(1), st                              # 00509a8e
    fmul st, st(1)                               # 00509a90
    fstp qword ptr [esp + stk_30]                # 00509a92
    fxch st(1)                                   # 00509a96
    fmul st, st(2)                               # 00509a98
    fxch st(3)                                   # 00509a9a
    fmul st, st(4)                               # 00509a9c
    fsubp st(3), st                              # 00509a9e
    fxch st(2)                                   # 00509aa0
    fmul st, st(2)                               # 00509aa2
    fstp qword ptr [esp + stk_38]                # 00509aa4
    fxch st(1)                                   # 00509aa8
    fstp st(0)                                   # 00509aaa
    fstp st(0)                                   # 00509aac
    fstp st(0)                                   # 00509aae
    fild dword ptr [esp + stk_40]                # 00509ab0
    fmul qword ptr [esp + stk_38]                # 00509ab4
    fadd qword ptr [esp + stk_30]                # 00509ab8
    fadd qword ptr [0x52cac0]                    # 00509abc
    fstp qword ptr [esp]                         # 00509ac2
    call FUN_0050e19e                            # 00509ac5
    call FUN_0050ce04                            # 00509aca
    fild dword ptr [esp + stk_2c]                # 00509acf
    mov esi, dword ptr [esp + stk_50]            # 00509ad3
    fmul qword ptr [esp + stk_38]                # 00509ad7
    mov dword ptr [esi], eax                     # 00509adb
    fadd qword ptr [esp + stk_30]                # 00509add
    fadd qword ptr [0x52cac0]                    # 00509ae1
    fstp qword ptr [esp]                         # 00509ae7
    call FUN_0050e19e                            # 00509aea
    add esp, 0x8                                 # 00509aef
    call FUN_0050ce04                            # 00509af2
    mov ecx, dword ptr [esp + stk_4c]            # 00509af7
    mov dword ptr [ecx], eax                     # 00509afb
    mov eax, dword ptr [esi]                     # 00509afd
    cmp eax, 0x3ff                               # 00509aff
    jle.d8 L_00509b0c                            # 00509b04
    # block 0x00509b06: entered by fall-through of jle at 0x00509b04, 1 instruction(s), falls into the block at 0x00509b0c
    mov dword ptr [esi], 0x3ff                   # 00509b06
L_00509b0c:
    # block 0x00509b0c: entered by jle at 0x00509b04, 2 instruction(s), ends with jle to 0x00509b1a (forward)
    cmp dword ptr [ecx], 0x3ff                   # 00509b0c
    jle.d8 L_00509b1a                            # 00509b12
    # block 0x00509b14: entered by fall-through of jle at 0x00509b12, 1 instruction(s), falls into the block at 0x00509b1a
    mov dword ptr [ecx], 0x3ff                   # 00509b14
L_00509b1a:
    # block 0x00509b1a: entered by jle at 0x00509b12, 2 instruction(s), ends with jge to 0x00509b25 (forward)
    cmp dword ptr [esi], 0x0                     # 00509b1a
    jge.d8 L_00509b25                            # 00509b1d
    # block 0x00509b1f: entered by fall-through of jge at 0x00509b1d, 1 instruction(s), falls into the block at 0x00509b25
    mov dword ptr [esi], 0x0                     # 00509b1f
L_00509b25:
    # block 0x00509b25: entered by jge at 0x00509b1d, 7 instruction(s), ends with jge to 0x00509b35 (forward)
    mov eax, dword ptr [ecx]                     # 00509b25
    pop edi                                      # 00509b27
    pop esi                                      # 00509b28
    pop ebp                                      # 00509b29
    test eax, eax                                # 00509b2a
    pop ebx                                      # 00509b2c
    jge.d8 L_00509b35                            # 00509b2d
    # block 0x00509b2f: entered by fall-through of jge at 0x00509b2d, 1 instruction(s), falls into the block at 0x00509b35
    mov dword ptr [ecx], 0x0                     # 00509b2f
L_00509b35:
    # block 0x00509b35: entered by jge at 0x00509b2d, 2 instruction(s), ends with ret
    add esp, 0x2c                                # 00509b35
    ret                                          # 00509b38

# --- data items (not part of the function) -------------------------
.org 0x00509b39 - 0x401000
PAD_00509b39:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

