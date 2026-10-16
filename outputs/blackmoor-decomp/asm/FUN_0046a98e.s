# FUN_0046a98e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046a98e
# extent:       0x0046a98e-0x0046ab6f (481 code bytes)
# span:         0x0046a98e-0x0046ab6f (code 481, tables 0, padding 0)
# sha256:       7789b50d0651b5eb8b195264b43d41f86cb58f7e22d11a3d79ab3a0a50cbcd41
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046a98e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_24, field_41, field_49, field_4d, field_7e; [ecx + n] field_1c, field_45, field_4d, field_51, field_53, field_7e, field_530; [edx + n] field_20, field_28, field_45, field_49, field_7e
# callees:      calls FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_7e, 0x7e  # offset +0x7e
.equ field_530, 0x530  # offset +0x530

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x0046a98e - 0x401000
.globl FUN_0046a98e
FUN_0046a98e:
    # block 0x0046a98e: entry, 7 instruction(s), ends with forward jump to 0x0046a9ac
    push ebp                                     # 0046a98e
    {load} mov ebp, esp                          # 0046a98f
    sub esp, 0x20                                # 0046a991
    push esi                                     # 0046a994
    mov dword ptr [ebp - local_10], ecx          # 0046a995
    mov word ptr [ebp - local_c], 0x0            # 0046a998
    jmp.d8 L_0046a9ac                            # 0046a99e
L_0046a9a0:
    # block 0x0046a9a0: entered by jmp at 0x0046ab65, 3 instruction(s), falls into the block at 0x0046a9ac
    mov ax, word ptr [ebp - local_c]             # 0046a9a0
    .insn 0x66, 0x05, 0x0001{:u16}               # 0046a9a4
    mov word ptr [ebp - local_c], ax             # 0046a9a8
L_0046a9ac:
    # block 0x0046a9ac: entered by jmp at 0x0046a99e, 3 instruction(s), ends with jge to 0x0046ab6a (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0046a9ac
    cmp ecx, 0x6                                 # 0046a9b0
    jge.d32 L_0046ab6a                           # 0046a9b3
    # block 0x0046a9b9: entered by fall-through of jge at 0x0046a9b3, 107 instruction(s), calls FUN_0050ce04, ends with backward jump to 0x0046a9a0
    movsx edx, word ptr [ebp - local_c]          # 0046a9b9
    movsx eax, word ptr [ebp - local_c]          # 0046a9bd
    mov ecx, dword ptr [ebp - local_10]          # 0046a9c1
    fld dword ptr [4*edx + 0x5919dc]             # 0046a9c4
    fmul dword ptr [ecx + 4*eax + field_530]     # 0046a9cb
    call FUN_0050ce04                            # 0046a9d2
    mov word ptr [ebp - local_8], ax             # 0046a9d7
    mov edx, dword ptr [ebp - local_10]          # 0046a9db
    movsx eax, word ptr [edx + field_7e]         # 0046a9de
    imul eax, eax, 0x8d                          # 0046a9e2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a9e8
    movsx edx, word ptr [ebp - local_c]          # 0046a9ee
    imul edx, edx, 0x6                           # 0046a9f2
    movsx eax, word ptr [ecx + edx + field_53]   # 0046a9f5
    movsx ecx, word ptr [ebp - local_8]          # 0046a9fa
    {load} sub eax, ecx                          # 0046a9fe
    mov word ptr [ebp - local_4], ax             # 0046aa00
    mov edx, dword ptr [ebp - local_10]          # 0046aa04
    movsx eax, word ptr [edx + field_7e]         # 0046aa07
    imul eax, eax, 0x8d                          # 0046aa0b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046aa11
    movsx edx, word ptr [ebp - local_c]          # 0046aa17
    imul edx, edx, 0x6                           # 0046aa1b
    movsx esi, word ptr [ecx + edx + field_51]   # 0046aa1e
    mov eax, dword ptr [ebp - local_10]          # 0046aa23
    movsx ecx, word ptr [eax + field_7e]         # 0046aa26
    imul ecx, ecx, 0x8d                          # 0046aa2a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046aa30
    mov eax, dword ptr [ebp - local_10]          # 0046aa36
    movsx ecx, word ptr [eax + field_7e]         # 0046aa39
    imul ecx, ecx, 0x8d                          # 0046aa3d
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0046aa43
    mov ecx, dword ptr [edx + field_49]          # 0046aa49
    sub ecx, dword ptr [eax + field_41]          # 0046aa4c
    mov dword ptr [ebp - local_14], ecx          # 0046aa4f
    fild dword ptr [ebp - local_14]              # 0046aa52
    fstp dword ptr [ebp - local_18]              # 0046aa55
    fld dword ptr [ebp - local_18]               # 0046aa58
    fdiv qword ptr [0x52c678]                    # 0046aa5b
    call FUN_0050ce04                            # 0046aa61
    movsx edx, ax                                # 0046aa66
    {load} sub esi, edx                          # 0046aa69
    movsx eax, word ptr [ebp - local_c]          # 0046aa6b
    shl eax, 0x4                                 # 0046aa6f
    mov ecx, dword ptr [ebp - local_10]          # 0046aa72
    mov dword ptr [ecx + eax + field_1c], esi    # 0046aa75
    movsx edx, word ptr [ebp - local_c]          # 0046aa79
    shl edx, 0x4                                 # 0046aa7d
    mov eax, dword ptr [ebp - local_10]          # 0046aa80
    movsx ecx, word ptr [eax + field_7e]         # 0046aa83
    imul ecx, ecx, 0x8d                          # 0046aa87
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0046aa8d
    mov ecx, dword ptr [ebp - local_10]          # 0046aa93
    mov edx, dword ptr [ecx + edx + field_1c]    # 0046aa96
    add edx, dword ptr [eax + field_49]          # 0046aa9a
    mov eax, dword ptr [ebp - local_10]          # 0046aa9d
    movsx ecx, word ptr [eax + field_7e]         # 0046aaa0
    imul ecx, ecx, 0x8d                          # 0046aaa4
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0046aaaa
    sub edx, dword ptr [eax + field_41]          # 0046aab0
    movsx ecx, word ptr [ebp - local_c]          # 0046aab3
    shl ecx, 0x4                                 # 0046aab7
    mov eax, dword ptr [ebp - local_10]          # 0046aaba
    mov dword ptr [eax + ecx + field_24], edx    # 0046aabd
    movsx esi, word ptr [ebp - local_4]          # 0046aac1
    mov ecx, dword ptr [ebp - local_10]          # 0046aac5
    movsx edx, word ptr [ecx + field_7e]         # 0046aac8
    imul edx, edx, 0x8d                          # 0046aacc
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046aad2
    mov ecx, dword ptr [ebp - local_10]          # 0046aad8
    movsx edx, word ptr [ecx + field_7e]         # 0046aadb
    imul edx, edx, 0x8d                          # 0046aadf
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 0046aae5
    mov edx, dword ptr [eax + field_4d]          # 0046aaeb
    sub edx, dword ptr [ecx + field_45]          # 0046aaee
    mov dword ptr [ebp - local_1c], edx          # 0046aaf1
    fild dword ptr [ebp - local_1c]              # 0046aaf4
    fstp dword ptr [ebp - local_20]              # 0046aaf7
    fld dword ptr [ebp - local_20]               # 0046aafa
    fdiv qword ptr [0x52c678]                    # 0046aafd
    call FUN_0050ce04                            # 0046ab03
    movsx eax, ax                                # 0046ab08
    {load} sub esi, eax                          # 0046ab0b
    movsx ecx, word ptr [ebp - local_c]          # 0046ab0d
    shl ecx, 0x4                                 # 0046ab11
    mov edx, dword ptr [ebp - local_10]          # 0046ab14
    mov dword ptr [edx + ecx + field_20], esi    # 0046ab17
    movsx eax, word ptr [ebp - local_c]          # 0046ab1b
    shl eax, 0x4                                 # 0046ab1f
    mov ecx, dword ptr [ebp - local_10]          # 0046ab22
    movsx edx, word ptr [ecx + field_7e]         # 0046ab25
    imul edx, edx, 0x8d                          # 0046ab29
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 0046ab2f
    mov edx, dword ptr [ebp - local_10]          # 0046ab35
    movsx edx, word ptr [edx + field_7e]         # 0046ab38
    imul edx, edx, 0x8d                          # 0046ab3c
    mov edx, dword ptr [edx + 0x5bb5e5]          # 0046ab42
    mov ecx, dword ptr [ecx + field_4d]          # 0046ab48
    sub ecx, dword ptr [edx + field_45]          # 0046ab4b
    mov edx, dword ptr [ebp - local_10]          # 0046ab4e
    mov eax, dword ptr [edx + eax + field_20]    # 0046ab51
    {load} add eax, ecx                          # 0046ab55
    movsx ecx, word ptr [ebp - local_c]          # 0046ab57
    shl ecx, 0x4                                 # 0046ab5b
    mov edx, dword ptr [ebp - local_10]          # 0046ab5e
    mov dword ptr [edx + ecx + field_28], eax    # 0046ab61
    jmp.d32 L_0046a9a0                           # 0046ab65
L_0046ab6a:
    # block 0x0046ab6a: entered by jge at 0x0046a9b3, 4 instruction(s), ends with ret
    pop esi                                      # 0046ab6a
    {load} mov esp, ebp                          # 0046ab6b
    pop ebp                                      # 0046ab6d
    ret                                          # 0046ab6e

