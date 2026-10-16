# FUN_00509e50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509e50
# extent:       0x00509e50-0x0050a429 (1497 code bytes)
# span:         0x00509e50-0x0050a440 (code 1497, tables 16, padding 7)
# sha256:       f7f82653da2161c5ef984bd997f0cbfa204c145ae686ae054dcd8b860a96a99c
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509e50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c, field_fc, field_504, field_b20; [ebp + n] field_4, field_80, field_c0, field_100, field_340, field_344, field_34c; [ecx + n] field_4, field_30c, field_504, field_510, field_514, field_518; [edi + n] field_4, field_8, field_a, field_50c, field_518, field_51c, field_720; [edx + n] field_504, field_50c; [esi + n] field_4, field_24, field_40; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 20 more; [scaled index + n] field_50
# callees:      calls FUN_005096c0, FUN_0050bc80, FUN_0050a440, FUN_00503060, FUN_0050a450
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 449 instruction(s), 32 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c
.equ stk_60, 0x60  # offset +0x60
.equ stk_80, 0x80  # offset +0x80
.equ field_80, 0x80  # offset +0x80
.equ stk_84, 0x84  # offset +0x84
.equ stk_94, 0x94  # offset +0x94
.equ stk_a8, 0xa8  # offset +0xa8
.equ field_c0, 0xc0  # offset +0xc0
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ stk_184, 0x184  # offset +0x184
.equ stk_188, 0x188  # offset +0x188
.equ stk_18c, 0x18c  # offset +0x18c
.equ stk_190, 0x190  # offset +0x190
.equ stk_194, 0x194  # offset +0x194
.equ stk_198, 0x198  # offset +0x198
.equ stk_1a0, 0x1a0  # offset +0x1a0
.equ field_30c, 0x30c  # offset +0x30c
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_34c, 0x34c  # offset +0x34c
.equ field_504, 0x504  # offset +0x504
.equ field_50c, 0x50c  # offset +0x50c
.equ field_510, 0x510  # offset +0x510
.equ field_514, 0x514  # offset +0x514
.equ field_518, 0x518  # offset +0x518
.equ field_51c, 0x51c  # offset +0x51c
.equ field_720, 0x720  # offset +0x720
.equ field_b20, 0xb20  # offset +0xb20
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_00503060, .text + (0x00503060 - 0x401000)
.set FUN_005096c0, .text + (0x005096c0 - 0x401000)
.set FUN_0050a440, .text + (0x0050a440 - 0x401000)
.set FUN_0050a450, .text + (0x0050a450 - 0x401000)
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x00509e50 - 0x401000
.globl FUN_00509e50
FUN_00509e50:
    # block 0x00509e50: entry, 21 instruction(s), ends with je to 0x0050a3de (forward)
    sub esp, 0x174                               # 00509e50
    push ebx                                     # 00509e56
    push ebp                                     # 00509e57
    push esi                                     # 00509e58
    mov esi, dword ptr [esp + stk_184]           # 00509e59
    mov ecx, dword ptr [esp + stk_188]           # 00509e60
    push edi                                     # 00509e67
    mov eax, dword ptr [esi + field_40]          # 00509e68
    mov edi, dword ptr [esp + stk_190]           # 00509e6b
    mov ebp, dword ptr [ecx + field_510]         # 00509e72
    mov edx, dword ptr [ecx + field_504]         # 00509e78
    mov eax, dword ptr [eax + field_4]           # 00509e7e
    {load} xor ebx, ebx                          # 00509e81
    {load} cmp edi, ebx                          # 00509e83
    mov dword ptr [esp + stk_14], ebp            # 00509e85
    mov eax, dword ptr [eax + field_1c]          # 00509e89
    mov dword ptr [esp + stk_2c], edx            # 00509e8c
    mov dword ptr [esp + stk_3c], eax            # 00509e90
    mov eax, dword ptr [eax + field_b20]         # 00509e94
    mov dword ptr [esp + stk_34], eax            # 00509e9a
    je.d32 L_0050a3de                            # 00509e9e
    # block 0x00509ea4: entered by fall-through of je at 0x00509e9e, 2 instruction(s), ends with jle to 0x00509f18 (forward)
    {load} cmp edx, ebx                          # 00509ea4
    jle.d8 L_00509f18                            # 00509ea6
    # block 0x00509ea8: entered by fall-through of jle at 0x00509ea6, 2 instruction(s), falls into the block at 0x00509eae
    {load} mov ebx, edi                          # 00509ea8
    mov dword ptr [esp + stk_10], edx            # 00509eaa
L_00509eae:
    # block 0x00509eae: entered by jne at 0x00509f06, 7 instruction(s), ends with ja to 0x00509ef0 (forward)
    mov esi, dword ptr [ebx]                     # 00509eae
    mov eax, dword ptr [ebp + field_340]         # 00509eb0
    {load} mov ecx, esi                          # 00509eb6
    and ecx, 0x7fff                              # 00509eb8
    dec eax                                      # 00509ebe
    cmp eax, 0x3                                 # 00509ebf
    ja.d8 L_00509ef0                             # 00509ec2
    # block 0x00509ec4: entered by fall-through of ja at 0x00509ec2, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x50a42c]
    jmp dword ptr [4*eax + SWTAB_0050a42c_VA]    # 00509ec4
L_00509ecb:
    # block 0x00509ecb: entered by switch case, 2 instruction(s), ends with forward jump to 0x00509ef0
    sar ecx, 0x2                                 # 00509ecb
    jmp.d8 L_00509ef0                            # 00509ece
L_00509ed0:
    # block 0x00509ed0: entered by switch case, 2 instruction(s), ends with forward jump to 0x00509ef0
    sar ecx, 0x3                                 # 00509ed0
    jmp.d8 L_00509ef0                            # 00509ed3
L_00509ed5:
    # block 0x00509ed5: entered by switch case, 9 instruction(s), ends with forward jump to 0x00509ef0
    mov eax, 0x2aaaaaab                          # 00509ed5
    imul ecx                                     # 00509eda
    sar edx                                      # 00509edc
    {load} mov ecx, edx                          # 00509ede
    shr ecx, 0x1f                                # 00509ee0
    {load} add edx, ecx                          # 00509ee3
    {load} mov ecx, edx                          # 00509ee5
    mov edx, dword ptr [esp + stk_2c]            # 00509ee7
    jmp.d8 L_00509ef0                            # 00509eeb
L_00509eed:
    # block 0x00509eed: entered by switch case, 1 instruction(s), falls into the block at 0x00509ef0
    sar ecx, 0x4                                 # 00509eed
L_00509ef0:
    # block 0x00509ef0: entered by ja at 0x00509ec2; jmp at 0x00509ece; jmp at 0x00509ed3; jmp at 0x00509eeb, 8 instruction(s), ends with jne to 0x00509eae (backward)
    mov eax, dword ptr [esp + stk_10]            # 00509ef0
    and esi, 0x8000                              # 00509ef4
    {load} or esi, ecx                           # 00509efa
    mov dword ptr [ebx], esi                     # 00509efc
    add ebx, 0x4                                 # 00509efe
    dec eax                                      # 00509f01
    mov dword ptr [esp + stk_10], eax            # 00509f02
    jne.d8 L_00509eae                            # 00509f06
    # block 0x00509f08: entered by fall-through of jne at 0x00509f06, 3 instruction(s), falls into the block at 0x00509f18
    mov esi, dword ptr [esp + stk_188]           # 00509f08
    mov ecx, dword ptr [esp + stk_18c]           # 00509f0f
    {load} xor ebx, ebx                          # 00509f16
L_00509f18:
    # block 0x00509f18: entered by jle at 0x00509ea6, 6 instruction(s), ends with jle to 0x0050a053 (forward)
    mov eax, dword ptr [edi]                     # 00509f18
    cmp edx, 0x2                                 # 00509f1a
    mov dword ptr [esp + stk_80], eax            # 00509f1d
    mov eax, dword ptr [edi + field_4]           # 00509f24
    mov dword ptr [esp + stk_84], eax            # 00509f27
    jle.d32 L_0050a053                           # 00509f2e
    # block 0x00509f34: entered by fall-through of jle at 0x00509f2e, 10 instruction(s), falls into the block at 0x00509f5f
    lea eax, [ebp + field_34c]                   # 00509f34
    lea ebx, [edi + field_8]                     # 00509f3a
    mov dword ptr [esp + stk_18], eax            # 00509f3d
    lea eax, [ecx + field_30c]                   # 00509f41
    lea ecx, [esp + stk_80]                      # 00509f47
    mov dword ptr [esp + stk_24], eax            # 00509f4e
    {load} sub ecx, edi                          # 00509f52
    add edx, -0x2                                # 00509f54
    mov dword ptr [esp + stk_10], ecx            # 00509f57
    mov dword ptr [esp + stk_28], edx            # 00509f5b
L_00509f5f:
    # block 0x00509f5f: entered by jne at 0x0050a044, 20 instruction(s), calls FUN_005096c0, ends with jne to 0x0050a00e (forward)
    mov esi, dword ptr [eax + field_fc]          # 00509f5f
    mov edi, dword ptr [eax]                     # 00509f65
    mov edx, dword ptr [esp + stk_190]           # 00509f67
    mov eax, dword ptr [ebp + 4*esi + field_344] # 00509f6e
    mov ecx, dword ptr [ebp + 4*edi + field_344] # 00509f75
    mov ebp, dword ptr [esp + stk_18]            # 00509f7c
    mov edx, dword ptr [edx + 4*esi]             # 00509f80
    {disp8} mov ebp, dword ptr [ebp]             # 00509f83
    push ebp                                     # 00509f86
    mov ebp, dword ptr [esp + stk_194]           # 00509f87
    {disp8} mov ebp, dword ptr [ebp + 4*edi]     # 00509f8e
    push ebp                                     # 00509f92
    push edx                                     # 00509f93
    push ecx                                     # 00509f94
    push eax                                     # 00509f95
    call FUN_005096c0                            # 00509f96
    mov ecx, dword ptr [ebx]                     # 00509f9b
    add esp, 0x14                                # 00509f9d
    test ch, -0x80                               # 00509fa0
    jne.d8 L_0050a00e                            # 00509fa3
    # block 0x00509fa5: entered by fall-through of jne at 0x00509fa3, 2 instruction(s), ends with je to 0x0050a00e (forward)
    {load} cmp eax, ecx                          # 00509fa5
    je.d8 L_0050a00e                             # 00509fa7
    # block 0x00509fa9: entered by fall-through of je at 0x00509fa7, 5 instruction(s), ends with jl to 0x00509fbe (forward)
    mov edx, dword ptr [esp + stk_18c]           # 00509fa9
    mov edx, dword ptr [edx + field_50c]         # 00509fb0
    {load} sub edx, eax                          # 00509fb6
    {load} cmp edx, eax                          # 00509fb8
    jl.d8 L_00509fbe                             # 00509fba
    # block 0x00509fbc: entered by fall-through of jl at 0x00509fba, 1 instruction(s), falls into the block at 0x00509fbe
    {load} mov edx, eax                          # 00509fbc
L_00509fbe:
    # block 0x00509fbe: entered by jl at 0x00509fba, 2 instruction(s), ends with jns to 0x00509fdc (forward)
    {load} sub ecx, eax                          # 00509fbe
    jns.d8 L_00509fdc                            # 00509fc0
    # block 0x00509fc2: entered by fall-through of jns at 0x00509fc0, 4 instruction(s), ends with jge to 0x00509fd1 (forward)
    {load} mov eax, edx                          # 00509fc2
    neg eax                                      # 00509fc4
    {load} cmp ecx, eax                          # 00509fc6
    jge.d8 L_00509fd1                            # 00509fc8
    # block 0x00509fca: entered by fall-through of jge at 0x00509fc8, 4 instruction(s), ends with forward jump to 0x00509fe6
    {load} sub edx, ecx                          # 00509fca
    dec edx                                      # 00509fcc
    {load} mov ecx, edx                          # 00509fcd
    jmp.d8 L_00509fe6                            # 00509fcf
L_00509fd1:
    # block 0x00509fd1: entered by jge at 0x00509fc8, 5 instruction(s), ends with forward jump to 0x00509fe6
    {load} add ecx, ecx                          # 00509fd1
    or edx, -0x1                                 # 00509fd3
    {load} sub edx, ecx                          # 00509fd6
    {load} mov ecx, edx                          # 00509fd8
    jmp.d8 L_00509fe6                            # 00509fda
L_00509fdc:
    # block 0x00509fdc: entered by jns at 0x00509fc0, 2 instruction(s), ends with jl to 0x00509fe4 (forward)
    {load} cmp ecx, edx                          # 00509fdc
    jl.d8 L_00509fe4                             # 00509fde
    # block 0x00509fe0: entered by fall-through of jl at 0x00509fde, 2 instruction(s), ends with forward jump to 0x00509fe6
    {load} add ecx, edx                          # 00509fe0
    jmp.d8 L_00509fe6                            # 00509fe2
L_00509fe4:
    # block 0x00509fe4: entered by jl at 0x00509fde, 1 instruction(s), falls into the block at 0x00509fe6
    shl ecx                                      # 00509fe4
L_00509fe6:
    # block 0x00509fe6: entered by jmp at 0x00509fcf; jmp at 0x00509fda; jmp at 0x00509fe2, 10 instruction(s), ends with forward jump to 0x0050a01e
    mov eax, dword ptr [esp + stk_10]            # 00509fe6
    mov dword ptr [eax + ebx], ecx               # 00509fea
    mov eax, dword ptr [esp + stk_190]           # 00509fed
    mov edx, dword ptr [eax + 4*esi]             # 00509ff4
    and edx, 0x7fff                              # 00509ff7
    mov dword ptr [eax + 4*esi], edx             # 00509ffd
    mov ecx, dword ptr [eax + 4*edi]             # 0050a000
    and ecx, 0x7fff                              # 0050a003
    mov dword ptr [eax + 4*edi], ecx             # 0050a009
    jmp.d8 L_0050a01e                            # 0050a00c
L_0050a00e:
    # block 0x0050a00e: entered by jne at 0x00509fa3; je at 0x00509fa7, 4 instruction(s), falls into the block at 0x0050a01e
    mov ecx, dword ptr [esp + stk_10]            # 0050a00e
    or ah, -0x80                                 # 0050a012
    mov dword ptr [ebx], eax                     # 0050a015
    mov dword ptr [ecx + ebx], 0x0               # 0050a017
L_0050a01e:
    # block 0x0050a01e: entered by jmp at 0x0050a00c, 12 instruction(s), ends with jne to 0x00509f5f (backward)
    mov eax, dword ptr [esp + stk_24]            # 0050a01e
    mov esi, dword ptr [esp + stk_18]            # 0050a022
    mov ecx, dword ptr [esp + stk_28]            # 0050a026
    mov ebp, dword ptr [esp + stk_14]            # 0050a02a
    add eax, 0x4                                 # 0050a02e
    add esi, 0x4                                 # 0050a031
    add ebx, 0x4                                 # 0050a034
    dec ecx                                      # 0050a037
    mov dword ptr [esp + stk_24], eax            # 0050a038
    mov dword ptr [esp + stk_18], esi            # 0050a03c
    mov dword ptr [esp + stk_28], ecx            # 0050a040
    jne.d32 L_00509f5f                           # 0050a044
    # block 0x0050a04a: entered by fall-through of jne at 0x0050a044, 2 instruction(s), falls into the block at 0x0050a053
    mov esi, dword ptr [esp + stk_188]           # 0050a04a
    {load} xor ebx, ebx                          # 0050a051
L_0050a053:
    # block 0x0050a053: entered by jle at 0x00509f2e, 44 instruction(s), calls FUN_0050bc80, FUN_0050a440, ends with jle to 0x0050a2f9 (forward)
    lea eax, [esi + field_4]                     # 0050a053
    push 0x1                                     # 0050a056
    push 0x1                                     # 0050a058
    push eax                                     # 0050a05a
    mov dword ptr [esp + stk_24], eax            # 0050a05b
    call FUN_0050bc80                            # 0050a05f
    mov edi, dword ptr [esp + stk_198]           # 0050a064
    mov edx, dword ptr [edi + field_51c]         # 0050a06b
    inc edx                                      # 0050a071
    mov dword ptr [edi + field_51c], edx         # 0050a072
    mov edx, dword ptr [edi + field_50c]         # 0050a078
    dec edx                                      # 0050a07e
    push edx                                     # 0050a07f
    call FUN_0050a440                            # 0050a080
    mov ecx, dword ptr [edi + field_518]         # 0050a085
    shl eax                                      # 0050a08b
    {load} add ecx, eax                          # 0050a08d
    mov eax, dword ptr [edi + field_50c]         # 0050a08f
    dec eax                                      # 0050a095
    mov dword ptr [edi + field_518], ecx         # 0050a096
    push eax                                     # 0050a09c
    call FUN_0050a440                            # 0050a09d
    mov ecx, dword ptr [esp + stk_94]            # 0050a0a2
    mov edx, dword ptr [esp + stk_2c]            # 0050a0a9
    push eax                                     # 0050a0ad
    push ecx                                     # 0050a0ae
    push edx                                     # 0050a0af
    call FUN_0050bc80                            # 0050a0b0
    mov eax, dword ptr [edi + field_50c]         # 0050a0b5
    dec eax                                      # 0050a0bb
    push eax                                     # 0050a0bc
    call FUN_0050a440                            # 0050a0bd
    mov ecx, dword ptr [esp + stk_a8]            # 0050a0c2
    mov edx, dword ptr [esp + stk_3c]            # 0050a0c9
    push eax                                     # 0050a0cd
    push ecx                                     # 0050a0ce
    push edx                                     # 0050a0cf
    call FUN_0050bc80                            # 0050a0d0
    {disp8} mov eax, dword ptr [ebp]             # 0050a0d5
    add esp, 0x30                                # 0050a0d8
    {load} cmp eax, ebx                          # 0050a0db
    mov dword ptr [esp + stk_2c], ebx            # 0050a0dd
    mov dword ptr [esp + stk_20], 0x2            # 0050a0e1
    jle.d32 L_0050a2f9                           # 0050a0e9
    # block 0x0050a0ef: entered by fall-through of jle at 0x0050a0e9, 2 instruction(s), falls into the block at 0x0050a0f6
    lea eax, [ebp + field_4]                     # 0050a0ef
    mov dword ptr [esp + stk_10], eax            # 0050a0f2
L_0050a0f6:
    # block 0x0050a0f6: entered by jl at 0x0050a2ec, 21 instruction(s), ends with je to 0x0050a24e (forward)
    mov ecx, dword ptr [esp + stk_10]            # 0050a0f6
    mov esi, 0x1                                 # 0050a0fa
    mov dword ptr [esp + stk_40], ebx            # 0050a0ff
    mov dword ptr [esp + stk_44], ebx            # 0050a103
    mov edi, dword ptr [ecx]                     # 0050a107
    mov dword ptr [esp + stk_48], ebx            # 0050a109
    mov dword ptr [esp + stk_1c], edi            # 0050a10d
    mov dword ptr [esp + stk_4c], ebx            # 0050a111
    mov ecx, dword ptr [ebp + 4*edi + field_c0]  # 0050a115
    mov edx, dword ptr [ebp + 4*edi + field_80]  # 0050a11c
    shl esi, cl                                  # 0050a123
    {load} cmp ecx, ebx                          # 0050a125
    mov dword ptr [esp + stk_24], edx            # 0050a127
    mov dword ptr [esp + stk_38], ecx            # 0050a12b
    mov dword ptr [esp + stk_50], ebx            # 0050a12f
    mov dword ptr [esp + stk_54], ebx            # 0050a133
    mov dword ptr [esp + stk_58], ebx            # 0050a137
    mov dword ptr [esp + stk_5c], ebx            # 0050a13b
    mov dword ptr [esp + stk_28], ebx            # 0050a13f
    mov dword ptr [esp + stk_30], ebx            # 0050a143
    je.d32 L_0050a24e                            # 0050a147
    # block 0x0050a14d: entered by fall-through of je at 0x0050a147, 2 instruction(s), ends with jle to 0x0050a198 (forward)
    {load} cmp esi, ebx                          # 0050a14d
    jle.d8 L_0050a198                            # 0050a14f
    # block 0x0050a151: entered by fall-through of jle at 0x0050a14f, 5 instruction(s), falls into the block at 0x0050a161
    lea eax, [edi + field_a]                     # 0050a151
    lea edx, [esp + stk_60]                      # 0050a154
    shl eax, 0x5                                 # 0050a158
    {load} add eax, ebp                          # 0050a15b
    mov dword ptr [esp + stk_14], esi            # 0050a15d
L_0050a161:
    # block 0x0050a161: entered by jne at 0x0050a192, 3 instruction(s), ends with jge to 0x0050a16f (forward)
    mov ecx, dword ptr [eax]                     # 0050a161
    {load} cmp ecx, ebx                          # 0050a163
    jge.d8 L_0050a16f                            # 0050a165
    # block 0x0050a167: entered by fall-through of jge at 0x0050a165, 2 instruction(s), ends with forward jump to 0x0050a183
    mov dword ptr [edx], 0x1                     # 0050a167
    jmp.d8 L_0050a183                            # 0050a16d
L_0050a16f:
    # block 0x0050a16f: entered by jge at 0x0050a165, 5 instruction(s), falls into the block at 0x0050a183
    mov edi, dword ptr [esp + stk_3c]            # 0050a16f
    mov ecx, dword ptr [edi + 4*ecx + field_720] # 0050a173
    mov edi, dword ptr [esp + stk_1c]            # 0050a17a
    mov ecx, dword ptr [ecx + field_4]           # 0050a17e
    mov dword ptr [edx], ecx                     # 0050a181
L_0050a183:
    # block 0x0050a183: entered by jmp at 0x0050a16d, 6 instruction(s), ends with jne to 0x0050a161 (backward)
    mov ecx, dword ptr [esp + stk_14]            # 0050a183
    add eax, 0x4                                 # 0050a187
    add edx, 0x4                                 # 0050a18a
    dec ecx                                      # 0050a18d
    mov dword ptr [esp + stk_14], ecx            # 0050a18e
    jne.d8 L_0050a161                            # 0050a192
    # block 0x0050a194: entered by fall-through of jne at 0x0050a192, 1 instruction(s), falls into the block at 0x0050a198
    mov edx, dword ptr [esp + stk_24]            # 0050a194
L_0050a198:
    # block 0x0050a198: entered by jle at 0x0050a14f, 2 instruction(s), ends with jle to 0x0050a20e (forward)
    {load} cmp edx, ebx                          # 0050a198
    jle.d8 L_0050a20e                            # 0050a19a
    # block 0x0050a19c: entered by fall-through of jle at 0x0050a19a, 5 instruction(s), falls into the block at 0x0050a1b3
    mov eax, dword ptr [esp + stk_20]            # 0050a19c
    lea ebx, [esp + stk_40]                      # 0050a1a0
    mov dword ptr [esp + stk_1c], edx            # 0050a1a4
    lea ecx, [esp + 4*eax + stk_80]              # 0050a1a8
    mov dword ptr [esp + stk_14], ecx            # 0050a1af
L_0050a1b3:
    # block 0x0050a1b3: entered by jne at 0x0050a20a, 3 instruction(s), ends with jle to 0x0050a1d3 (forward)
    {load} xor eax, eax                          # 0050a1b3
    test esi, esi                                # 0050a1b5
    jle.d8 L_0050a1d3                            # 0050a1b7
    # block 0x0050a1b9: entered by fall-through of jle at 0x0050a1b7, 3 instruction(s), falls into the block at 0x0050a1c3
    mov edx, dword ptr [esp + stk_14]            # 0050a1b9
    mov ecx, dword ptr [edx]                     # 0050a1bd
    lea edx, [esp + stk_60]                      # 0050a1bf
L_0050a1c3:
    # block 0x0050a1c3: entered by jl at 0x0050a1cd, 2 instruction(s), ends with jl to 0x0050a1d1 (forward)
    cmp ecx, dword ptr [edx]                     # 0050a1c3
    jl.d8 L_0050a1d1                             # 0050a1c5
    # block 0x0050a1c7: entered by fall-through of jl at 0x0050a1c5, 4 instruction(s), ends with jl to 0x0050a1c3 (backward)
    inc eax                                      # 0050a1c7
    add edx, 0x4                                 # 0050a1c8
    {load} cmp eax, esi                          # 0050a1cb
    jl.d8 L_0050a1c3                             # 0050a1cd
    # block 0x0050a1cf: entered by fall-through of jl at 0x0050a1cd, 1 instruction(s), ends with forward jump to 0x0050a1d3
    jmp.d8 L_0050a1d3                            # 0050a1cf
L_0050a1d1:
    # block 0x0050a1d1: entered by jl at 0x0050a1c5, 1 instruction(s), falls into the block at 0x0050a1d3
    mov dword ptr [ebx], eax                     # 0050a1d1
L_0050a1d3:
    # block 0x0050a1d3: entered by jle at 0x0050a1b7; jmp at 0x0050a1cf, 18 instruction(s), ends with jne to 0x0050a1b3 (backward)
    mov eax, dword ptr [ebx]                     # 0050a1d3
    mov ecx, dword ptr [esp + stk_30]            # 0050a1d5
    shl eax, cl                                  # 0050a1d9
    mov ecx, dword ptr [esp + stk_28]            # 0050a1db
    mov edx, dword ptr [esp + stk_14]            # 0050a1df
    add edx, 0x4                                 # 0050a1e3
    add ebx, 0x4                                 # 0050a1e6
    mov dword ptr [esp + stk_14], edx            # 0050a1e9
    {load} or ecx, eax                           # 0050a1ed
    mov eax, dword ptr [esp + stk_30]            # 0050a1ef
    mov dword ptr [esp + stk_28], ecx            # 0050a1f3
    mov ecx, dword ptr [esp + stk_38]            # 0050a1f7
    {load} add eax, ecx                          # 0050a1fb
    mov dword ptr [esp + stk_30], eax            # 0050a1fd
    mov eax, dword ptr [esp + stk_1c]            # 0050a201
    dec eax                                      # 0050a205
    mov dword ptr [esp + stk_1c], eax            # 0050a206
    jne.d8 L_0050a1b3                            # 0050a20a
    # block 0x0050a20c: entered by fall-through of jne at 0x0050a20a, 1 instruction(s), falls into the block at 0x0050a20e
    {load} xor ebx, ebx                          # 0050a20c
L_0050a20e:
    # block 0x0050a20e: entered by jle at 0x0050a19a, 17 instruction(s), calls FUN_00503060, falls into the block at 0x0050a24e
    mov edx, dword ptr [esp + stk_18]            # 0050a20e
    mov eax, dword ptr [esp + stk_28]            # 0050a212
    push edx                                     # 0050a216
    push eax                                     # 0050a217
    mov eax, dword ptr [ebp + 4*edi + field_100] # 0050a218
    lea ecx, [eax + 4*eax]                       # 0050a21f
    lea edx, [eax + 2*ecx]                       # 0050a222
    mov eax, dword ptr [esp + stk_3c]            # 0050a225
    lea ecx, [eax + 4*edx]                       # 0050a229
    push ecx                                     # 0050a22c
    call FUN_00503060                            # 0050a22d
    mov ecx, dword ptr [esp + stk_198]           # 0050a232
    add esp, 0xc                                 # 0050a239
    mov edx, dword ptr [ecx + field_514]         # 0050a23c
    {load} add edx, eax                          # 0050a242
    mov dword ptr [ecx + field_514], edx         # 0050a244
    mov edx, dword ptr [esp + stk_24]            # 0050a24a
L_0050a24e:
    # block 0x0050a24e: entered by je at 0x0050a147, 2 instruction(s), ends with jle to 0x0050a2c9 (forward)
    {load} cmp edx, ebx                          # 0050a24e
    jle.d8 L_0050a2c9                            # 0050a250
    # block 0x0050a252: entered by fall-through of jle at 0x0050a250, 5 instruction(s), falls into the block at 0x0050a26c
    mov eax, dword ptr [esp + stk_20]            # 0050a252
    lea edi, [8*edi + field_50]                  # 0050a256
    lea esi, [esp + stk_40]                      # 0050a25d
    mov dword ptr [esp + stk_1c], edx            # 0050a261
    lea ebx, [esp + 4*eax + stk_80]              # 0050a265
L_0050a26c:
    # block 0x0050a26c: entered by jne at 0x0050a2c5, 6 instruction(s), ends with jl to 0x0050a2b6 (forward)
    mov eax, dword ptr [esi]                     # 0050a26c
    {load} mov ecx, edi                          # 0050a26e
    {load} add ecx, eax                          # 0050a270
    {disp8} mov eax, dword ptr [ebp + 4*ecx]     # 0050a272
    test eax, eax                                # 0050a276
    jl.d8 L_0050a2b6                             # 0050a278
    # block 0x0050a27a: entered by fall-through of jl at 0x0050a278, 7 instruction(s), ends with jge to 0x0050a2b6 (forward)
    lea ecx, [eax + 4*eax]                       # 0050a27a
    lea eax, [eax + 2*ecx]                       # 0050a27d
    mov ecx, dword ptr [esp + stk_34]            # 0050a280
    lea eax, [ecx + 4*eax]                       # 0050a284
    mov ecx, dword ptr [ebx]                     # 0050a287
    cmp ecx, dword ptr [eax + field_4]           # 0050a289
    jge.d8 L_0050a2b6                            # 0050a28c
    # block 0x0050a28e: entered by fall-through of jge at 0x0050a28c, 11 instruction(s), calls FUN_00503060, falls into the block at 0x0050a2b6
    mov edx, dword ptr [esp + stk_18]            # 0050a28e
    push edx                                     # 0050a292
    push ecx                                     # 0050a293
    push eax                                     # 0050a294
    call FUN_00503060                            # 0050a295
    mov ecx, dword ptr [esp + stk_198]           # 0050a29a
    add esp, 0xc                                 # 0050a2a1
    mov edx, dword ptr [ecx + field_518]         # 0050a2a4
    {load} add edx, eax                          # 0050a2aa
    mov dword ptr [ecx + field_518], edx         # 0050a2ac
    mov edx, dword ptr [esp + stk_24]            # 0050a2b2
L_0050a2b6:
    # block 0x0050a2b6: entered by jl at 0x0050a278; jge at 0x0050a28c, 6 instruction(s), ends with jne to 0x0050a26c (backward)
    mov eax, dword ptr [esp + stk_1c]            # 0050a2b6
    add esi, 0x4                                 # 0050a2ba
    add ebx, 0x4                                 # 0050a2bd
    dec eax                                      # 0050a2c0
    mov dword ptr [esp + stk_1c], eax            # 0050a2c1
    jne.d8 L_0050a26c                            # 0050a2c5
    # block 0x0050a2c7: entered by fall-through of jne at 0x0050a2c5, 1 instruction(s), falls into the block at 0x0050a2c9
    {load} xor ebx, ebx                          # 0050a2c7
L_0050a2c9:
    # block 0x0050a2c9: entered by jle at 0x0050a250, 12 instruction(s), ends with jl to 0x0050a0f6 (backward)
    mov edi, dword ptr [esp + stk_20]            # 0050a2c9
    mov eax, dword ptr [esp + stk_2c]            # 0050a2cd
    {disp8} mov ecx, dword ptr [ebp]             # 0050a2d1
    {load} add edi, edx                          # 0050a2d4
    mov edx, dword ptr [esp + stk_10]            # 0050a2d6
    inc eax                                      # 0050a2da
    add edx, 0x4                                 # 0050a2db
    {load} cmp eax, ecx                          # 0050a2de
    mov dword ptr [esp + stk_20], edi            # 0050a2e0
    mov dword ptr [esp + stk_2c], eax            # 0050a2e4
    mov dword ptr [esp + stk_10], edx            # 0050a2e8
    jl.d32 L_0050a0f6                            # 0050a2ec
    # block 0x0050a2f2: entered by fall-through of jl at 0x0050a2ec, 1 instruction(s), falls into the block at 0x0050a2f9
    mov esi, dword ptr [esp + stk_188]           # 0050a2f2
L_0050a2f9:
    # block 0x0050a2f9: entered by jle at 0x0050a0e9, 9 instruction(s), ends with jle to 0x0050a399 (forward)
    mov eax, dword ptr [esp + stk_190]           # 0050a2f9
    mov ecx, dword ptr [ebp + field_340]         # 0050a300
    mov edx, 0x1                                 # 0050a306
    {load} xor edi, edi                          # 0050a30b
    imul ecx, dword ptr [eax]                    # 0050a30d
    mov eax, dword ptr [esp + stk_18c]           # 0050a310
    mov dword ptr [esp + stk_20], edx            # 0050a317
    cmp dword ptr [eax + field_504], edx         # 0050a31b
    jle.d8 L_0050a399                            # 0050a321
    # block 0x0050a323: entered by fall-through of jle at 0x0050a321, 2 instruction(s), falls into the block at 0x0050a32c
    add eax, 0x108                               # 0050a323
    mov dword ptr [esp + stk_10], eax            # 0050a328
L_0050a32c:
    # block 0x0050a32c: entered by jl at 0x0050a390, 8 instruction(s), ends with jne to 0x0050a36f (forward)
    mov edx, dword ptr [esp + stk_10]            # 0050a32c
    mov eax, dword ptr [esp + stk_190]           # 0050a330
    mov edx, dword ptr [edx]                     # 0050a337
    mov esi, dword ptr [eax + 4*edx]             # 0050a339
    {load} mov eax, esi                          # 0050a33c
    and eax, 0x7fff                              # 0050a33e
    {load} cmp eax, esi                          # 0050a343
    jne.d8 L_0050a36f                            # 0050a345
    # block 0x0050a347: entered by fall-through of jne at 0x0050a345, 13 instruction(s), calls FUN_0050a450, falls into the block at 0x0050a36f
    mov esi, dword ptr [ebp + field_340]         # 0050a347
    mov edi, dword ptr [ebp + 4*edx + field_344] # 0050a34d
    imul esi, eax                                # 0050a354
    mov edx, dword ptr [esp + stk_194]           # 0050a357
    push edx                                     # 0050a35e
    push esi                                     # 0050a35f
    push ecx                                     # 0050a360
    push edi                                     # 0050a361
    push ebx                                     # 0050a362
    call FUN_0050a450                            # 0050a363
    add esp, 0x14                                # 0050a368
    {load} mov ebx, edi                          # 0050a36b
    {load} mov ecx, esi                          # 0050a36d
L_0050a36f:
    # block 0x0050a36f: entered by jne at 0x0050a345, 9 instruction(s), ends with jl to 0x0050a32c (backward)
    mov edx, dword ptr [esp + stk_10]            # 0050a36f
    mov eax, dword ptr [esp + stk_20]            # 0050a373
    add edx, 0x4                                 # 0050a377
    inc eax                                      # 0050a37a
    mov dword ptr [esp + stk_10], edx            # 0050a37b
    mov edx, dword ptr [esp + stk_18c]           # 0050a37f
    mov dword ptr [esp + stk_20], eax            # 0050a386
    cmp eax, dword ptr [edx + field_504]         # 0050a38a
    jl.d8 L_0050a32c                             # 0050a390
    # block 0x0050a392: entered by fall-through of jl at 0x0050a390, 1 instruction(s), falls into the block at 0x0050a399
    mov esi, dword ptr [esp + stk_188]           # 0050a392
L_0050a399:
    # block 0x0050a399: entered by jle at 0x0050a321, 7 instruction(s), ends with jge to 0x0050a3c3 (forward)
    mov eax, dword ptr [esi + field_24]          # 0050a399
    {load} mov ebx, edi                          # 0050a39c
    cdq                                          # 0050a39e
    {load} sub eax, edx                          # 0050a39f
    sar eax                                      # 0050a3a1
    {load} cmp edi, eax                          # 0050a3a3
    jge.d8 L_0050a3c3                            # 0050a3a5
    # block 0x0050a3a7: entered by fall-through of jge at 0x0050a3a5, 2 instruction(s), falls into the block at 0x0050a3b1
    mov eax, dword ptr [esp + stk_194]           # 0050a3a7
    lea edi, [eax + 4*edi]                       # 0050a3ae
L_0050a3b1:
    # block 0x0050a3b1: entered by jl at 0x0050a3c1, 9 instruction(s), ends with jl to 0x0050a3b1 (backward)
    mov dword ptr [edi], ecx                     # 0050a3b1
    mov eax, dword ptr [esi + field_24]          # 0050a3b3
    cdq                                          # 0050a3b6
    {load} sub eax, edx                          # 0050a3b7
    inc ebx                                      # 0050a3b9
    sar eax                                      # 0050a3ba
    add edi, 0x4                                 # 0050a3bc
    {load} cmp ebx, eax                          # 0050a3bf
    jl.d8 L_0050a3b1                             # 0050a3c1
L_0050a3c3:
    # block 0x0050a3c3: entered by jge at 0x0050a3a5; fall-through of jl at 0x0050a3c1, 10 instruction(s), ends with ret
    mov eax, dword ptr [0x63aa1c]                # 0050a3c3
    pop edi                                      # 0050a3c8
    inc eax                                      # 0050a3c9
    pop esi                                      # 0050a3ca
    mov dword ptr [0x63aa1c], eax                # 0050a3cb
    pop ebp                                      # 0050a3d0
    mov eax, 0x1                                 # 0050a3d1
    pop ebx                                      # 0050a3d6
    add esp, 0x174                               # 0050a3d7
    ret                                          # 0050a3dd
L_0050a3de:
    # block 0x0050a3de: entered by je at 0x00509e9e, 30 instruction(s), calls FUN_0050bc80, ends with ret
    push 0x1                                     # 0050a3de
    lea ecx, [esi + field_4]                     # 0050a3e0
    push ebx                                     # 0050a3e3
    push ecx                                     # 0050a3e4
    call FUN_0050bc80                            # 0050a3e5
    mov eax, dword ptr [esi + field_24]          # 0050a3ea
    mov edi, dword ptr [esp + stk_1a0]           # 0050a3ed
    cdq                                          # 0050a3f4
    {load} sub eax, edx                          # 0050a3f5
    add esp, 0xc                                 # 0050a3f7
    {load} mov ecx, eax                          # 0050a3fa
    {load} xor eax, eax                          # 0050a3fc
    sar ecx                                      # 0050a3fe
    shl ecx, 0x2                                 # 0050a400
    {load} mov edx, ecx                          # 0050a403
    shr ecx, 0x2                                 # 0050a405
    rep stosd dword ptr es:[edi], eax            # 0050a408
    {load} mov ecx, edx                          # 0050a40a
    and ecx, 0x3                                 # 0050a40c
    rep stosb byte ptr es:[edi], al              # 0050a40f
    mov eax, dword ptr [0x63aa1c]                # 0050a411
    pop edi                                      # 0050a416
    inc eax                                      # 0050a417
    pop esi                                      # 0050a418
    mov dword ptr [0x63aa1c], eax                # 0050a419
    pop ebp                                      # 0050a41e
    {load} xor eax, eax                          # 0050a41f
    pop ebx                                      # 0050a421
    add esp, 0x174                               # 0050a422
    ret                                          # 0050a428

# --- data items (not part of the function) -------------------------
.org 0x0050a429 - 0x401000
PAD_0050a429:  # 3 byte(s) of alignment instructions
    {disp8} lea ecx, [ecx]
.org 0x0050a42c - 0x401000
SWTAB_0050a42c:  # 4 case address(es)
    .long L_00509ecb - .text + 0x401000
    .long L_00509ed0 - .text + 0x401000
    .long L_00509ed5 - .text + 0x401000
    .long L_00509eed - .text + 0x401000
.org 0x0050a43c - 0x401000
PAD_0050a43c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90
.set SWTAB_0050a42c_VA, SWTAB_0050a42c - .text + 0x401000

