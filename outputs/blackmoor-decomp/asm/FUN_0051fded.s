# FUN_0051fded
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fded
# extent:       0x0051fded-0x0051ff07 (282 code bytes)
# span:         0x0051fded-0x0051ff07 (code 282, tables 0, padding 0)
# sha256:       8ba84665f52ea486671a4a14f25d0ac0e057af25937962d2957aea37ea867ad2
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fded
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_50
# fields:       [ebx + n] field_2, field_8, field_c, field_10; [ecx + n] field_3, field_4; [edi + n] field_3; [esi + n] field_2, field_4, field_8
# callees:      calls KERNEL32.dll!GlobalLock, KERNEL32.dll!MultiByteToWideChar, FUN_0051fc70, FUN_0050fdc5, FUN_0050ed50, KERNEL32.dll!GlobalUnlock
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 109 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_50, 0x50  # offset -0x50
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)
.set FUN_0050fdc5, .text + (0x0050fdc5 - 0x401000)
.set FUN_0051fc70, .text + (0x0051fc70 - 0x401000)

.org 0x0051fded - 0x401000
.globl FUN_0051fded
FUN_0051fded:
    # block 0x0051fded: entry, 8 instruction(s), ends with jne to 0x0051fe05 (forward)
    push ebp                                     # 0051fded
    {load} mov ebp, esp                          # 0051fdee
    sub esp, 0x50                                # 0051fdf0
    push edi                                     # 0051fdf3
    {load} xor edi, edi                          # 0051fdf4
    cmp dword ptr [ecx + field_4], edi           # 0051fdf6
    mov dword ptr [ebp - local_8], ecx           # 0051fdf9
    jne.d8 L_0051fe05                            # 0051fdfc
    # block 0x0051fdfe: entered by fall-through of jne at 0x0051fdfc, 2 instruction(s), ends with forward jump to 0x0051ff02
    {load} xor eax, eax                          # 0051fdfe
    jmp.d32 L_0051ff02                           # 0051fe00
L_0051fe05:
    # block 0x0051fe05: entered by jne at 0x0051fdfc, 12 instruction(s), calls KERNEL32.dll!GlobalLock, ends with jne to 0x0051fe2c (forward)
    push ebx                                     # 0051fe05
    push esi                                     # 0051fe06
    push dword ptr [ecx]                         # 0051fe07
    call dword ptr [0x52a204]                    # 0051fe09
    {load} mov ebx, eax                          # 0051fe0f
    {load} xor ecx, ecx                          # 0051fe11
    mov ax, word ptr [ebx + field_2]             # 0051fe13
    .insn 0x66, 0x3d, 0xffff{:u16}               # 0051fe17
    sete cl                                      # 0051fe1b
    .insn 0x66, 0x3d, 0xffff{:u16}               # 0051fe1e
    mov dword ptr [ebp - local_4], ecx           # 0051fe22
    jne.d8 L_0051fe2c                            # 0051fe25
    # block 0x0051fe27: entered by fall-through of jne at 0x0051fe25, 2 instruction(s), ends with forward jump to 0x0051fe2e
    mov eax, dword ptr [ebx + field_c]           # 0051fe27
    jmp.d8 L_0051fe2e                            # 0051fe2a
L_0051fe2c:
    # block 0x0051fe2c: entered by jne at 0x0051fe25, 1 instruction(s), falls into the block at 0x0051fe2e
    mov eax, dword ptr [ebx]                     # 0051fe2c
L_0051fe2e:
    # block 0x0051fe2e: entered by jmp at 0x0051fe2a, 10 instruction(s), ends with je to 0x0051fe4c (forward)
    mov esi, dword ptr [ebp - local_4]           # 0051fe2e
    and eax, 0x40                                # 0051fe31
    neg esi                                      # 0051fe34
    {load} sbb esi, esi                          # 0051fe36
    mov dword ptr [ebp - local_c], eax           # 0051fe38
    and esi, 0x2                                 # 0051fe3b
    inc esi                                      # 0051fe3e
    shl esi                                      # 0051fe3f
    cmp dword ptr [ebp - local_4], edi           # 0051fe41
    je.d8 L_0051fe4c                             # 0051fe44
    # block 0x0051fe46: entered by fall-through of je at 0x0051fe44, 2 instruction(s), ends with forward jump to 0x0051fe4f
    or dword ptr [ebx + field_c], 0x40           # 0051fe46
    jmp.d8 L_0051fe4f                            # 0051fe4a
L_0051fe4c:
    # block 0x0051fe4c: entered by je at 0x0051fe44, 1 instruction(s), falls into the block at 0x0051fe4f
    or dword ptr [ebx], 0x40                     # 0051fe4c
L_0051fe4f:
    # block 0x0051fe4f: entered by jmp at 0x0051fe4a, 18 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, FUN_0051fc70, ends with je to 0x0051fe89 (forward)
    lea eax, [ebp - local_50]                    # 0051fe4f
    push 0x20                                    # 0051fe52
    push eax                                     # 0051fe54
    push -0x1                                    # 0051fe55
    push dword ptr [ebp + arg_8]                 # 0051fe57
    push edi                                     # 0051fe5a
    push edi                                     # 0051fe5b
    call dword ptr [0x52a1f0]                    # 0051fe5c
    lea eax, [esi + 2*eax]                       # 0051fe62
    push ebx                                     # 0051fe65
    mov dword ptr [ebp + arg_8], eax             # 0051fe66
    call FUN_0051fc70                            # 0051fe69
    pop ecx                                      # 0051fe6e
    {load} mov edi, eax                          # 0051fe6f
    {load} xor ecx, ecx                          # 0051fe71
    mov dword ptr [ebp - local_10], edi          # 0051fe73
    cmp dword ptr [ebp - local_c], ecx           # 0051fe76
    je.d8 L_0051fe89                             # 0051fe79
    # block 0x0051fe7b: entered by fall-through of je at 0x0051fe79, 5 instruction(s), calls FUN_0050fdc5, falls into the block at 0x0051fe89
    lea eax, [edi + esi]                         # 0051fe7b
    push eax                                     # 0051fe7e
    call FUN_0050fdc5                            # 0051fe7f
    pop ecx                                      # 0051fe84
    lea ecx, [esi + 2*eax + field_2]             # 0051fe85
L_0051fe89:
    # block 0x0051fe89: entered by je at 0x0051fe79, 8 instruction(s), ends with je to 0x0051fea8 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0051fe89
    lea eax, [ecx + edi + field_3]               # 0051fe8c
    and al, -0x4                                 # 0051fe90
    lea edi, [edi + edx + field_3]               # 0051fe92
    mov dword ptr [ebp - local_c], eax           # 0051fe96
    and edi, -0x4                                # 0051fe99
    cmp dword ptr [ebp - local_4], 0x0           # 0051fe9c
    je.d8 L_0051fea8                             # 0051fea0
    # block 0x0051fea2: entered by fall-through of je at 0x0051fea0, 2 instruction(s), ends with forward jump to 0x0051feac
    mov dx, word ptr [ebx + field_10]            # 0051fea2
    jmp.d8 L_0051feac                            # 0051fea6
L_0051fea8:
    # block 0x0051fea8: entered by je at 0x0051fea0, 1 instruction(s), falls into the block at 0x0051feac
    mov dx, word ptr [ebx + field_8]             # 0051fea8
L_0051feac:
    # block 0x0051feac: entered by jmp at 0x0051fea6, 2 instruction(s), ends with je to 0x0051fec9 (forward)
    cmp dword ptr [ebp + arg_8], ecx             # 0051feac
    je.d8 L_0051fec9                             # 0051feaf
    # block 0x0051feb1: entered by fall-through of je at 0x0051feaf, 2 instruction(s), ends with jbe to 0x0051fec9 (forward)
    test dx, dx                                  # 0051feb1
    jbe.d8 L_0051fec9                            # 0051feb4
    # block 0x0051feb6: entered by fall-through of jbe at 0x0051feb4, 8 instruction(s), calls FUN_0050ed50, falls into the block at 0x0051fec9
    mov ecx, dword ptr [ebp - local_8]           # 0051feb6
    {load} sub ebx, eax                          # 0051feb9
    add ebx, dword ptr [ecx + field_4]           # 0051febb
    push ebx                                     # 0051febe
    push eax                                     # 0051febf
    push edi                                     # 0051fec0
    call FUN_0050ed50                            # 0051fec1
    add esp, 0xc                                 # 0051fec6
L_0051fec9:
    # block 0x0051fec9: entered by je at 0x0051feaf; jbe at 0x0051feb4, 22 instruction(s), calls FUN_0050ed50, KERNEL32.dll!GlobalUnlock, falls into the block at 0x0051ff02
    mov eax, dword ptr [ebp + arg_8]             # 0051fec9
    mov ecx, dword ptr [ebp - local_10]          # 0051fecc
    mov dx, word ptr [ebp + arg_c]               # 0051fecf
    {load} sub eax, esi                          # 0051fed3
    push eax                                     # 0051fed5
    mov word ptr [ecx], dx                       # 0051fed6
    lea eax, [ebp - local_50]                    # 0051fed9
    {load} add ecx, esi                          # 0051fedc
    push eax                                     # 0051fede
    push ecx                                     # 0051fedf
    call FUN_0050ed50                            # 0051fee0
    mov esi, dword ptr [ebp - local_8]           # 0051fee5
    sub edi, dword ptr [ebp - local_c]           # 0051fee8
    add esp, 0xc                                 # 0051feeb
    push dword ptr [esi]                         # 0051feee
    add dword ptr [esi + field_4], edi           # 0051fef0
    call dword ptr [0x52a208]                    # 0051fef3
    and dword ptr [esi + field_8], 0x0           # 0051fef9
    push 0x1                                     # 0051fefd
    pop eax                                      # 0051feff
    pop esi                                      # 0051ff00
    pop ebx                                      # 0051ff01
L_0051ff02:
    # block 0x0051ff02: entered by jmp at 0x0051fe00, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0051ff02
    leave                                        # 0051ff03
    ret 0x8                                      # 0051ff04

