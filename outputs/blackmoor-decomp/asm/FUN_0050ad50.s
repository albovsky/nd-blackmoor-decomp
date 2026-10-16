# FUN_0050ad50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ad50
# extent:       0x0050ad50-0x0050aeac (348 code bytes)
# span:         0x0050ad50-0x0050aeb0 (code 348, tables 0, padding 4)
# sha256:       b3a0dfb9d8cd6f6131bb4912217cf676fa3dcf41c11a3dcc0ed827d3c5dfc9df
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ad50
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1c, field_40; [ecx + n] field_minus_1, field_minus_4; [edi + n] field_8, field_c; [edx + n] field_4; [esp + n] stk_10, stk_14, stk_18, stk_20, stk_24; [scaled index + n] field_4
# callees:      calls FUN_0050ea90, FUN_0050e19e, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 113 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050ad50 - 0x401000
.globl FUN_0050ad50
FUN_0050ad50:
    # block 0x0050ad50: entry, 14 instruction(s), ends with jne to 0x0050aea5 (forward)
    push ebp                                     # 0050ad50
    {load} mov ebp, esp                          # 0050ad51
    and esp, -0x8                                # 0050ad53
    sub esp, 0x14                                # 0050ad56
    mov eax, dword ptr [ebp + arg_8]             # 0050ad59
    push ebx                                     # 0050ad5c
    push esi                                     # 0050ad5d
    push edi                                     # 0050ad5e
    mov edi, dword ptr [ebp + arg_10]            # 0050ad5f
    mov ebx, dword ptr [eax + field_1c]          # 0050ad62
    mov dword ptr [esp + stk_14], ebx            # 0050ad65
    mov ecx, dword ptr [edi + field_8]           # 0050ad69
    cmp dword ptr [ecx + 4*ebx], 0x0             # 0050ad6c
    jne.d32 L_0050aea5                           # 0050ad70
    # block 0x0050ad76: entered by fall-through of jne at 0x0050ad70, 44 instruction(s), calls FUN_0050ea90, ends with jle to 0x0050ae90 (forward)
    mov edx, dword ptr [eax + field_40]          # 0050ad76
    mov eax, dword ptr [edx + field_4]           # 0050ad79
    mov ecx, dword ptr [eax + field_1c]          # 0050ad7c
    mov eax, dword ptr [ecx + 4*ebx]             # 0050ad7f
    cdq                                          # 0050ad82
    {load} sub eax, edx                          # 0050ad83
    mov edx, dword ptr [ebp + arg_c]             # 0050ad85
    {load} mov esi, eax                          # 0050ad88
    fild dword ptr [edx + field_4]               # 0050ad8a
    sar esi                                      # 0050ad8d
    mov dword ptr [esp + stk_18], esi            # 0050ad8f
    fmul dword ptr [0x52cd14]                    # 0050ad93
    lea eax, [4*esi + field_4]                   # 0050ad99
    push eax                                     # 0050ada0
    fld st(0)                                    # 0050ada1
    fild dword ptr [edi]                         # 0050ada3
    fld st(1)                                    # 0050ada5
    fmul st, st(2)                               # 0050ada7
    fmul dword ptr [0x52e5a8]                    # 0050ada9
    fld1                                         # 0050adaf
    fpatan                                       # 0050adb1
    fmul qword ptr [0x52e5a0]                    # 0050adb3
    fld st(3)                                    # 0050adb9
    fmul dword ptr [0x52e598]                    # 0050adbb
    fld1                                         # 0050adc1
    fpatan                                       # 0050adc3
    fmul qword ptr [0x52e590]                    # 0050adc5
    faddp st(1), st                              # 0050adcb
    fxch st(3)                                   # 0050adcd
    fmul dword ptr [0x52e588]                    # 0050adcf
    faddp st(3), st                              # 0050add5
    fxch st(2)                                   # 0050add7
    fdivp st(2), st                              # 0050add9
    fxch st(1)                                   # 0050addb
    fstp dword ptr [esp + stk_20]                # 0050addd
    fstp st(0)                                   # 0050ade1
    call FUN_0050ea90                            # 0050ade3
    mov ecx, dword ptr [edi + field_8]           # 0050ade8
    add esp, 0x4                                 # 0050adeb
    mov dword ptr [ecx + 4*ebx], eax             # 0050adee
    {load} xor ebx, ebx                          # 0050adf1
    test esi, esi                                # 0050adf3
    mov dword ptr [esp + stk_10], ebx            # 0050adf5
    jle.d32 L_0050ae90                           # 0050adf9
    # block 0x0050adff: entered by fall-through of jle at 0x0050adf9, 2 instruction(s), falls into the block at 0x0050ae07
    fild dword ptr [esp + stk_18]                # 0050adff
    fstp dword ptr [esp + stk_18]                # 0050ae03
L_0050ae07:
    # block 0x0050ae07: entered by jl at 0x0050ae8a, 33 instruction(s), calls FUN_0050e19e, FUN_0050ce04, ends with jl to 0x0050ae75 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 0050ae07
    sub esp, 0x8                                 # 0050ae0a
    fild dword ptr [edx + field_4]               # 0050ae0d
    fmul dword ptr [0x52cd14]                    # 0050ae10
    fdiv dword ptr [esp + stk_20]                # 0050ae16
    fimul dword ptr [esp + stk_18]               # 0050ae1a
    fld st(0)                                    # 0050ae1e
    fld st(0)                                    # 0050ae20
    fmul st, st(1)                               # 0050ae22
    fmul dword ptr [0x52e5a8]                    # 0050ae24
    fld1                                         # 0050ae2a
    fpatan                                       # 0050ae2c
    fmul qword ptr [0x52e5a0]                    # 0050ae2e
    fld st(2)                                    # 0050ae34
    fmul dword ptr [0x52e598]                    # 0050ae36
    fld1                                         # 0050ae3c
    fpatan                                       # 0050ae3e
    fmul qword ptr [0x52e590]                    # 0050ae40
    faddp st(1), st                              # 0050ae46
    fxch st(2)                                   # 0050ae48
    fmul dword ptr [0x52e588]                    # 0050ae4a
    faddp st(2), st                              # 0050ae50
    fld dword ptr [esp + stk_24]                 # 0050ae52
    fmulp st(2), st                              # 0050ae56
    fxch st(1)                                   # 0050ae58
    fstp qword ptr [esp]                         # 0050ae5a
    fstp st(0)                                   # 0050ae5d
    call FUN_0050e19e                            # 0050ae5f
    add esp, 0x8                                 # 0050ae64
    call FUN_0050ce04                            # 0050ae67
    mov ecx, dword ptr [edi]                     # 0050ae6c
    {load} cmp eax, ecx                          # 0050ae6e
    jl.d8 L_0050ae75                             # 0050ae70
    # block 0x0050ae72: entered by fall-through of jl at 0x0050ae70, 1 instruction(s), falls into the block at 0x0050ae75
    lea eax, [ecx - field_minus_1]               # 0050ae72
L_0050ae75:
    # block 0x0050ae75: entered by jl at 0x0050ae70, 8 instruction(s), ends with jl to 0x0050ae07 (backward)
    mov ecx, dword ptr [edi + field_8]           # 0050ae75
    mov edx, dword ptr [esp + stk_14]            # 0050ae78
    inc ebx                                      # 0050ae7c
    mov ecx, dword ptr [ecx + 4*edx]             # 0050ae7d
    {load} cmp ebx, esi                          # 0050ae80
    mov dword ptr [esp + stk_10], ebx            # 0050ae82
    mov dword ptr [ecx + 4*ebx - field_minus_4], eax # 0050ae86
    jl.d32 L_0050ae07                            # 0050ae8a
L_0050ae90:
    # block 0x0050ae90: entered by jle at 0x0050adf9; fall-through of jl at 0x0050ae8a, 5 instruction(s), falls into the block at 0x0050aea5
    mov edx, dword ptr [edi + field_8]           # 0050ae90
    mov eax, dword ptr [esp + stk_14]            # 0050ae93
    mov ecx, dword ptr [edx + 4*eax]             # 0050ae97
    mov dword ptr [ecx + 4*ebx], 0xffffffff      # 0050ae9a
    mov dword ptr [edi + 4*eax + field_c], esi   # 0050aea1
L_0050aea5:
    # block 0x0050aea5: entered by jne at 0x0050ad70, 6 instruction(s), ends with ret
    pop edi                                      # 0050aea5
    pop esi                                      # 0050aea6
    pop ebx                                      # 0050aea7
    {load} mov esp, ebp                          # 0050aea8
    pop ebp                                      # 0050aeaa
    ret                                          # 0050aeab

# --- data items (not part of the function) -------------------------
.org 0x0050aeac - 0x401000
PAD_0050aeac:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

