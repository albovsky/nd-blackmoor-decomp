# FUN_0050aeb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050aeb0
# extent:       0x0050aeb0-0x0050b021 (369 code bytes)
# span:         0x0050aeb0-0x0050b030 (code 369, tables 0, padding 15)
# sha256:       4feeff0566ceb37acfc53dac32641755b4e9ed56dde66e5509b8c6c7cbfb354f
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050aeb0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esp + n] stk_c, stk_14, stk_18, stk_1c, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_3c, stk_40
# callees:      calls FUN_0050b030, FUN_0050f65d, FUN_0050b0d0, FUN_0050b080, FUN_0050b0e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 119 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------
.set FUN_0050b030, .text + (0x0050b030 - 0x401000)
.set FUN_0050b080, .text + (0x0050b080 - 0x401000)
.set FUN_0050b0d0, .text + (0x0050b0d0 - 0x401000)
.set FUN_0050b0e0, .text + (0x0050b0e0 - 0x401000)
.set FUN_0050f65d, .text + (0x0050f65d - 0x401000)

.org 0x0050aeb0 - 0x401000
.globl FUN_0050aeb0
FUN_0050aeb0:
    # block 0x0050aeb0: entry, 10 instruction(s), ends with jle to 0x0050aee5 (forward)
    sub esp, 0xc                                 # 0050aeb0
    fild dword ptr [esp + stk_1c]                # 0050aeb3
    push ebx                                     # 0050aeb7
    mov ebx, dword ptr [esp + stk_28]            # 0050aeb8
    push esi                                     # 0050aebc
    push edi                                     # 0050aebd
    fdivr dword ptr [0x52e624]                   # 0050aebe
    test ebx, ebx                                # 0050aec4
    fstp dword ptr [esp + stk_c]                 # 0050aec6
    jle.d8 L_0050aee5                            # 0050aeca
    # block 0x0050aecc: entered by fall-through of jle at 0x0050aeca, 2 instruction(s), falls into the block at 0x0050aed2
    mov esi, dword ptr [esp + stk_2c]            # 0050aecc
    {load} mov edi, ebx                          # 0050aed0
L_0050aed2:
    # block 0x0050aed2: entered by jne at 0x0050aee3, 8 instruction(s), calls FUN_0050b030, ends with jne to 0x0050aed2 (backward)
    mov eax, dword ptr [esi]                     # 0050aed2
    push eax                                     # 0050aed4
    call FUN_0050b030                            # 0050aed5
    fstp dword ptr [esi]                         # 0050aeda
    add esp, 0x4                                 # 0050aedc
    add esi, 0x4                                 # 0050aedf
    dec edi                                      # 0050aee2
    jne.d8 L_0050aed2                            # 0050aee3
L_0050aee5:
    # block 0x0050aee5: entered by jle at 0x0050aeca; fall-through of jne at 0x0050aee3, 4 instruction(s), ends with jle to 0x0050b01a (forward)
    mov eax, dword ptr [esp + stk_24]            # 0050aee5
    {load} xor esi, esi                          # 0050aee9
    test eax, eax                                # 0050aeeb
    jle.d32 L_0050b01a                           # 0050aeed
    # block 0x0050aef3: entered by fall-through of jle at 0x0050aeed, 6 instruction(s), falls into the block at 0x0050af04
    {load} mov eax, ebx                          # 0050aef3
    mov ebx, dword ptr [esp + stk_1c]            # 0050aef5
    sar eax                                      # 0050aef9
    push ebp                                     # 0050aefb
    mov ebp, dword ptr [esp + stk_24]            # 0050aefc
    mov dword ptr [esp + stk_14], eax            # 0050af00
L_0050af04:
    # block 0x0050af04: entered by jl at 0x0050b013, 15 instruction(s), calls FUN_0050b030, falls into the block at 0x0050af44
    {disp8} mov edi, dword ptr [ebp + 4*esi]     # 0050af04
    push ecx                                     # 0050af08
    mov dword ptr [esp + stk_30], edi            # 0050af09
    mov dword ptr [esp + stk_28], 0x3f3504f3     # 0050af0d
    fild dword ptr [esp + stk_30]                # 0050af15
    mov dword ptr [esp + stk_24], 0x3f3504f3     # 0050af19
    fmul dword ptr [esp + stk_14]                # 0050af21
    fstp dword ptr [esp]                         # 0050af25
    call FUN_0050b030                            # 0050af28
    fstp dword ptr [esp + stk_30]                # 0050af2d
    fld dword ptr [esp + stk_24]                 # 0050af31
    mov eax, dword ptr [esp + stk_34]            # 0050af35
    mov ecx, dword ptr [esp + stk_18]            # 0050af39
    fld dword ptr [esp + stk_28]                 # 0050af3d
    add esp, 0x4                                 # 0050af41
L_0050af44:
    # block 0x0050af44: entered by jne at 0x0050af59, 9 instruction(s), ends with jne to 0x0050af44 (backward)
    fld dword ptr [eax]                          # 0050af44
    fsub dword ptr [esp + stk_2c]                # 0050af46
    add eax, 0x8                                 # 0050af4a
    dec ecx                                      # 0050af4d
    fmulp st(2), st                              # 0050af4e
    fld dword ptr [eax - field_minus_4]          # 0050af50
    fsub dword ptr [esp + stk_2c]                # 0050af53
    fmulp st(1), st                              # 0050af57
    jne.d8 L_0050af44                            # 0050af59
    # block 0x0050af5b: entered by fall-through of jne at 0x0050af59, 4 instruction(s), ends with je to 0x0050af84 (forward)
    mov cl, byte ptr [esp + stk_34]              # 0050af5b
    fstp dword ptr [esp + stk_24]                # 0050af5f
    test cl, 0x1                                 # 0050af63
    je.d8 L_0050af84                             # 0050af66
    # block 0x0050af68: entered by fall-through of je at 0x0050af66, 9 instruction(s), ends with forward jump to 0x0050af9c
    fld dword ptr [eax]                          # 0050af68
    fsub dword ptr [esp + stk_2c]                # 0050af6a
    fmulp st(1), st                              # 0050af6e
    fld st(0)                                    # 0050af70
    fmulp st(1), st                              # 0050af72
    fld dword ptr [esp + stk_2c]                 # 0050af74
    fmul dword ptr [esp + stk_2c]                # 0050af78
    fsubr dword ptr [0x52cbf4]                   # 0050af7c
    jmp.d8 L_0050af9c                            # 0050af82
L_0050af84:
    # block 0x0050af84: entered by je at 0x0050af66, 6 instruction(s), falls into the block at 0x0050af9c
    fld dword ptr [esp + stk_2c]                 # 0050af84
    fadd dword ptr [0x52cbf4]                    # 0050af88
    fmul st, st(1)                               # 0050af8e
    fmulp st(1), st                              # 0050af90
    fld dword ptr [0x52cbf4]                     # 0050af92
    fsub dword ptr [esp + stk_2c]                # 0050af98
L_0050af9c:
    # block 0x0050af9c: entered by jmp at 0x0050af82, 30 instruction(s), calls FUN_0050f65d, FUN_0050b0d0, FUN_0050b080, FUN_0050b0e0, falls into the block at 0x0050affd
    fmul dword ptr [esp + stk_24]                # 0050af9c
    lea ecx, [esp + stk_18]                      # 0050afa0
    push ecx                                     # 0050afa4
    fmul dword ptr [esp + stk_28]                # 0050afa5
    fxch st(1)                                   # 0050afa9
    sub esp, 0x8                                 # 0050afab
    fadd st, st(1)                               # 0050afae
    fstp qword ptr [esp]                         # 0050afb0
    fstp st(0)                                   # 0050afb3
    call FUN_0050f65d                            # 0050afb5
    mov edx, dword ptr [esp + stk_24]            # 0050afba
    mov eax, dword ptr [esp + stk_40]            # 0050afbe
    fstp dword ptr [esp + stk_2c]                # 0050afc2
    {load} add edx, eax                          # 0050afc6
    push edx                                     # 0050afc8
    call FUN_0050b0d0                            # 0050afc9
    mov ecx, dword ptr [esp + stk_30]            # 0050afce
    fstp dword ptr [esp + stk_3c]                # 0050afd2
    push ecx                                     # 0050afd6
    call FUN_0050b080                            # 0050afd7
    fmul dword ptr [esp + stk_40]                # 0050afdc
    add esp, 0x10                                # 0050afe0
    fmul dword ptr [esp + stk_3c]                # 0050afe3
    fsub dword ptr [esp + stk_40]                # 0050afe7
    fstp dword ptr [esp]                         # 0050afeb
    call FUN_0050b0e0                            # 0050afee
    {load} mov ecx, ebp                          # 0050aff3
    add esp, 0x4                                 # 0050aff5
    lea eax, [ebx + 4*esi]                       # 0050aff8
    {load} sub ecx, ebx                          # 0050affb
L_0050affd:
    # block 0x0050affd: entered by je at 0x0050b00b, 7 instruction(s), ends with je to 0x0050affd (backward)
    fld st(0)                                    # 0050affd
    fmul dword ptr [eax]                         # 0050afff
    add eax, 0x4                                 # 0050b001
    inc esi                                      # 0050b004
    fstp dword ptr [eax - field_minus_4]         # 0050b005
    cmp dword ptr [ecx + eax], edi               # 0050b008
    je.d8 L_0050affd                             # 0050b00b
    # block 0x0050b00d: entered by fall-through of je at 0x0050b00b, 3 instruction(s), ends with jl to 0x0050af04 (backward)
    cmp esi, dword ptr [esp + stk_28]            # 0050b00d
    fstp st(0)                                   # 0050b011
    jl.d32 L_0050af04                            # 0050b013
    # block 0x0050b019: entered by fall-through of jl at 0x0050b013, 1 instruction(s), falls into the block at 0x0050b01a
    pop ebp                                      # 0050b019
L_0050b01a:
    # block 0x0050b01a: entered by jle at 0x0050aeed, 5 instruction(s), ends with ret
    pop edi                                      # 0050b01a
    pop esi                                      # 0050b01b
    pop ebx                                      # 0050b01c
    add esp, 0xc                                 # 0050b01d
    ret                                          # 0050b020

# --- data items (not part of the function) -------------------------
.org 0x0050b021 - 0x401000
PAD_0050b021:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

