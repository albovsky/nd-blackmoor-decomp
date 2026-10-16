# FUN_00447eaf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447eaf
# extent:       0x00447eaf-0x00448084 (469 code bytes)
# span:         0x00447eaf-0x00448084 (code 469, tables 0, padding 0)
# sha256:       6e07476c2fcc244615b58bfab104aae06f8744fd896327568717dbeb6bba23f0
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447eaf
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1e, field_33, field_aa; [ecx + n] field_35, field_aa; [edx + n] field_29, field_2b
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 151 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_aa, 0xaa  # offset +0xaa

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00447eaf - 0x401000
.globl FUN_00447eaf
FUN_00447eaf:
    # block 0x00447eaf: entry, 9 instruction(s), ends with je to 0x0044807c (forward)
    push ebp                                     # 00447eaf
    {load} mov ebp, esp                          # 00447eb0
    sub esp, 0x18                                # 00447eb2
    push esi                                     # 00447eb5
    push edi                                     # 00447eb6
    mov dword ptr [ebp - local_18], ecx          # 00447eb7
    mov eax, dword ptr [ebp - local_18]          # 00447eba
    cmp dword ptr [eax + field_1e], 0x0          # 00447ebd
    je.d32 L_0044807c                            # 00447ec1
    # block 0x00447ec7: entered by fall-through of je at 0x00447ec1, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00447f24 (forward)
    push 0xabc                                   # 00447ec7
    call FUN_0051dc43                            # 00447ecc
    add esp, 0x4                                 # 00447ed1
    mov dword ptr [ebp - local_14], eax          # 00447ed4
    mov ecx, dword ptr [ebp + arg_8]             # 00447ed7
    mov edx, dword ptr [ebp - local_14]          # 00447eda
    mov dword ptr [ecx], edx                     # 00447edd
    cmp dword ptr [ebp - local_14], 0x0          # 00447edf
    jne.d8 L_00447f24                            # 00447ee3
    # block 0x00447ee5: entered by fall-through of jne at 0x00447ee3, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00447f24
    movsx eax, word ptr [0x5c39e3]               # 00447ee5
    push eax                                     # 00447eec
    mov ecx, dword ptr [0x5bb57b]                # 00447eed
    push ecx                                     # 00447ef3
    push 0x548640                                # 00447ef4
    push 0x63888b                                # 00447ef9
    call FUN_0050ca3e                            # 00447efe
    add esp, 0x10                                # 00447f03
    push 0x63888b                                # 00447f06
    push 0x54866c                                # 00447f0b
    mov ecx, 0x583979                            # 00447f10
    call FUN_0042639d                            # 00447f15
    mov ecx, 0x5cf659                            # 00447f1a
    call FUN_004c97b4                            # 00447f1f
L_00447f24:
    # block 0x00447f24: entered by jne at 0x00447ee3, 42 instruction(s), ends with jne to 0x00447fb5 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00447f24
    mov eax, dword ptr [edx]                     # 00447f27
    mov dword ptr [ebp - local_c], eax           # 00447f29
    mov ecx, dword ptr [ebp - local_c]           # 00447f2c
    add ecx, 0x2                                 # 00447f2f
    mov dword ptr [ebp - local_8], ecx           # 00447f32
    mov edx, dword ptr [ebp - local_8]           # 00447f35
    mov dword ptr [ebp - local_4], edx           # 00447f38
    mov eax, dword ptr [ebp + arg_c]             # 00447f3b
    mov ecx, dword ptr [eax]                     # 00447f3e
    mov edx, dword ptr [ebp - local_c]           # 00447f40
    mov ax, word ptr [ecx]                       # 00447f43
    mov word ptr [edx], ax                       # 00447f46
    mov ecx, dword ptr [ebp + arg_c]             # 00447f49
    mov edx, dword ptr [ecx]                     # 00447f4c
    add edx, 0x2                                 # 00447f4e
    mov eax, dword ptr [ebp + arg_c]             # 00447f51
    mov dword ptr [eax], edx                     # 00447f54
    mov ecx, dword ptr [ebp + arg_10]            # 00447f56
    mov edx, dword ptr [ecx]                     # 00447f59
    add edx, 0x2                                 # 00447f5b
    mov eax, dword ptr [ebp + arg_10]            # 00447f5e
    mov dword ptr [eax], edx                     # 00447f61
    mov ecx, dword ptr [ebp + arg_c]             # 00447f63
    mov esi, dword ptr [ecx]                     # 00447f66
    mov ecx, 0x2b                                # 00447f68
    mov edi, dword ptr [ebp - local_4]           # 00447f6d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00447f70
    mov edx, dword ptr [ebp + arg_c]             # 00447f72
    mov eax, dword ptr [edx]                     # 00447f75
    add eax, 0xac                                # 00447f77
    mov ecx, dword ptr [ebp + arg_c]             # 00447f7c
    mov dword ptr [ecx], eax                     # 00447f7f
    mov edx, dword ptr [ebp + arg_10]            # 00447f81
    mov eax, dword ptr [edx]                     # 00447f84
    add eax, 0xac                                # 00447f86
    mov ecx, dword ptr [ebp + arg_10]            # 00447f8b
    mov dword ptr [ecx], eax                     # 00447f8e
    mov edx, dword ptr [ebp - local_4]           # 00447f90
    movsx eax, word ptr [edx + field_29]         # 00447f93
    cmp eax, 0x2                                 # 00447f97
    jne.d8 L_00447fb5                            # 00447f9a
    # block 0x00447f9c: entered by fall-through of jne at 0x00447f9a, 8 instruction(s), ends with forward jump to 0x00447fc0
    mov ecx, dword ptr [ebp - local_4]           # 00447f9c
    movsx edx, word ptr [ecx + field_35]         # 00447f9f
    mov eax, dword ptr [ebp - local_4]           # 00447fa3
    movsx ecx, word ptr [eax + field_33]         # 00447fa6
    {load} sub edx, ecx                          # 00447faa
    add edx, 0x1                                 # 00447fac
    mov word ptr [ebp - local_10], dx            # 00447faf
    jmp.d8 L_00447fc0                            # 00447fb3
L_00447fb5:
    # block 0x00447fb5: entered by jne at 0x00447f9a, 3 instruction(s), falls into the block at 0x00447fc0
    mov edx, dword ptr [ebp - local_4]           # 00447fb5
    mov ax, word ptr [edx + field_2b]            # 00447fb8
    mov word ptr [ebp - local_10], ax            # 00447fbc
L_00447fc0:
    # block 0x00447fc0: entered by jmp at 0x00447fb3, 58 instruction(s), ends with je to 0x0044807c (forward)
    movsx ecx, word ptr [ebp - local_10]         # 00447fc0
    shl ecx, 0x4                                 # 00447fc4
    mov edx, dword ptr [ebp + arg_c]             # 00447fc7
    mov esi, dword ptr [edx]                     # 00447fca
    mov edi, dword ptr [ebp - local_8]           # 00447fcc
    add edi, 0xac                                # 00447fcf
    {load} mov eax, ecx                          # 00447fd5
    shr ecx, 0x2                                 # 00447fd7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00447fda
    {load} mov ecx, eax                          # 00447fdc
    and ecx, 0x3                                 # 00447fde
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00447fe1
    movsx ecx, word ptr [ebp - local_10]         # 00447fe3
    shl ecx, 0x4                                 # 00447fe7
    mov edx, dword ptr [ebp + arg_c]             # 00447fea
    mov eax, dword ptr [edx]                     # 00447fed
    {load} add eax, ecx                          # 00447fef
    mov ecx, dword ptr [ebp + arg_c]             # 00447ff1
    mov dword ptr [ecx], eax                     # 00447ff4
    movsx edx, word ptr [ebp - local_10]         # 00447ff6
    shl edx, 0x4                                 # 00447ffa
    mov eax, dword ptr [ebp + arg_10]            # 00447ffd
    mov ecx, dword ptr [eax]                     # 00448000
    {load} add ecx, edx                          # 00448002
    mov edx, dword ptr [ebp + arg_10]            # 00448004
    mov dword ptr [edx], ecx                     # 00448007
    mov eax, dword ptr [ebp - local_4]           # 00448009
    movsx ecx, word ptr [eax + field_aa]         # 0044800c
    imul ecx, ecx, 0x26                          # 00448013
    mov edx, dword ptr [ebp + arg_c]             # 00448016
    mov esi, dword ptr [edx]                     # 00448019
    mov edi, dword ptr [ebp - local_8]           # 0044801b
    add edi, 0x6ec                               # 0044801e
    {load} mov eax, ecx                          # 00448024
    shr ecx, 0x2                                 # 00448026
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00448029
    {load} mov ecx, eax                          # 0044802b
    and ecx, 0x3                                 # 0044802d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00448030
    mov ecx, dword ptr [ebp - local_4]           # 00448032
    movsx edx, word ptr [ecx + field_aa]         # 00448035
    imul edx, edx, 0x26                          # 0044803c
    mov eax, dword ptr [ebp + arg_c]             # 0044803f
    mov ecx, dword ptr [eax]                     # 00448042
    {load} add ecx, edx                          # 00448044
    mov edx, dword ptr [ebp + arg_c]             # 00448046
    mov dword ptr [edx], ecx                     # 00448049
    mov eax, dword ptr [ebp - local_4]           # 0044804b
    movsx ecx, word ptr [eax + field_aa]         # 0044804e
    imul ecx, ecx, 0x26                          # 00448055
    mov edx, dword ptr [ebp + arg_10]            # 00448058
    mov eax, dword ptr [edx]                     # 0044805b
    {load} add eax, ecx                          # 0044805d
    mov ecx, dword ptr [ebp + arg_10]            # 0044805f
    mov dword ptr [ecx], eax                     # 00448062
    movsx edx, word ptr [0x63a4cd]               # 00448064
    test edx, edx                                # 0044806b
    je.d8 L_0044807c                             # 0044806d
    # block 0x0044806f: entered by fall-through of je at 0x0044806d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044807c
    push 0x548688                                # 0044806f
    call FUN_0044a2b7                            # 00448074
    add esp, 0x4                                 # 00448079
L_0044807c:
    # block 0x0044807c: entered by je at 0x00447ec1; je at 0x0044806d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044807c
    pop esi                                      # 0044807d
    {load} mov esp, ebp                          # 0044807e
    pop ebp                                      # 00448080
    ret 0xc                                      # 00448081

