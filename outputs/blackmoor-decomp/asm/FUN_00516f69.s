# FUN_00516f69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516f69
# extent:       0x00516f69-0x0051740a (1185 code bytes)
# span:         0x00516f69-0x0051743a (code 1185, tables 48, padding 0)
# sha256:       28dd9778ef6ef54c5adc6759adc0852fab77b211cc55cf235538642c3c21b77a
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516f69
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [ecx + n] field_2, field_6, field_a, field_minus_30; [edi + n] field_minus_1, field_minus_2
# callees:      calls FUN_005118b3, FUN_00518caf, FUN_00519229
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 417 instruction(s), 70 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051743a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_minus_30, 0x30  # offset -0x30
.equ local_36, 0x36  # offset -0x36
.equ local_3a, 0x3a  # offset -0x3a
.equ local_3e, 0x3e  # offset -0x3e
.equ local_40, 0x40  # offset -0x40
.equ local_45, 0x45  # offset -0x45
.equ local_5c, 0x5c  # offset -0x5c
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)
.set FUN_00518caf, .text + (0x00518caf - 0x401000)
.set FUN_00519229, .text + (0x00519229 - 0x401000)

.org 0x00516f69 - 0x401000
.globl FUN_00516f69
FUN_00516f69:
    # block 0x00516f69: entry, 24 instruction(s), falls into the block at 0x00516fa4
    push ebp                                     # 00516f69
    {load} mov ebp, esp                          # 00516f6a
    sub esp, 0x5c                                # 00516f6c
    push ebx                                     # 00516f6f
    push esi                                     # 00516f70
    push edi                                     # 00516f71
    mov edi, dword ptr [ebp + arg_10]            # 00516f72
    lea eax, [ebp - local_5c]                    # 00516f75
    push 0x1                                     # 00516f78
    mov dword ptr [ebp - local_c], eax           # 00516f7a
    {load} xor eax, eax                          # 00516f7d
    pop edx                                      # 00516f7f
    mov dword ptr [ebp - local_28], eax          # 00516f80
    mov dword ptr [ebp - local_18], edx          # 00516f83
    mov dword ptr [ebp - local_4], eax           # 00516f86
    mov dword ptr [ebp - local_10], eax          # 00516f89
    mov dword ptr [ebp - local_24], eax          # 00516f8c
    mov dword ptr [ebp - local_20], eax          # 00516f8f
    mov dword ptr [ebp - local_2c], eax          # 00516f92
    mov dword ptr [ebp - local_30], eax          # 00516f95
    mov dword ptr [ebp - local_1c], eax          # 00516f98
    mov dword ptr [ebp - local_8], eax           # 00516f9b
    mov dword ptr [ebp - local_14], eax          # 00516f9e
    mov dword ptr [ebp + arg_10], edi            # 00516fa1
L_00516fa4:
    # block 0x00516fa4: entered by jmp at 0x00516fbb, 3 instruction(s), ends with je to 0x00516fba (forward)
    mov cl, byte ptr [edi]                       # 00516fa4
    cmp cl, 0x20                                 # 00516fa6
    je.d8 L_00516fba                             # 00516fa9
    # block 0x00516fab: entered by fall-through of je at 0x00516fa9, 2 instruction(s), ends with je to 0x00516fba (forward)
    cmp cl, 0x9                                  # 00516fab
    je.d8 L_00516fba                             # 00516fae
    # block 0x00516fb0: entered by fall-through of je at 0x00516fae, 2 instruction(s), ends with je to 0x00516fba (forward)
    cmp cl, 0xa                                  # 00516fb0
    je.d8 L_00516fba                             # 00516fb3
    # block 0x00516fb5: entered by fall-through of je at 0x00516fb3, 2 instruction(s), ends with jne to 0x00516fbd (forward)
    cmp cl, 0xd                                  # 00516fb5
    jne.d8 L_00516fbd                            # 00516fb8
L_00516fba:
    # block 0x00516fba: entered by je at 0x00516fa9; je at 0x00516fae; je at 0x00516fb3; fall-through of jne at 0x00516fb8, 2 instruction(s), ends with backward jump to 0x00516fa4
    inc edi                                      # 00516fba
    jmp.d8 L_00516fa4                            # 00516fbb
L_00516fbd:
    # block 0x00516fbd: entered by jne at 0x00516fb8, 2 instruction(s), falls into the block at 0x00516fc0
    push 0x4                                     # 00516fbd
    pop esi                                      # 00516fbf
L_00516fc0:
    # block 0x00516fc0: entered by jmp at 0x00517017; jmp at 0x00517020; jmp at 0x0051709e; jmp at 0x005170f9; more, 4 instruction(s), ends with ja to 0x00517243 (forward)
    mov bl, byte ptr [edi]                       # 00516fc0
    inc edi                                      # 00516fc2
    cmp eax, 0xb                                 # 00516fc3
    ja.d32 L_00517243                            # 00516fc6
    # block 0x00516fcc: entered by fall-through of ja at 0x00516fc6, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x51740a]
    jmp dword ptr [4*eax + SWTAB_0051740a_VA]    # 00516fcc
L_00516fd3:
    # block 0x00516fd3: entered by switch case, 2 instruction(s), ends with jl to 0x00516fe4 (forward)
    cmp bl, 0x31                                 # 00516fd3
    jl.d8 L_00516fe4                             # 00516fd6
    # block 0x00516fd8: entered by fall-through of jl at 0x00516fd6, 2 instruction(s), ends with jg to 0x00516fe4 (forward)
    cmp bl, 0x39                                 # 00516fd8
    jg.d8 L_00516fe4                             # 00516fdb
L_00516fdd:
    # block 0x00516fdd: entered by jle at 0x0051702d; jle at 0x00517081; fall-through of jg at 0x00516fdb, 2 instruction(s), ends with forward jump to 0x00517201
    push 0x3                                     # 00516fdd
    jmp.d32 L_00517201                           # 00516fdf
L_00516fe4:
    # block 0x00516fe4: entered by jl at 0x00516fd6; jg at 0x00516fdb, 2 instruction(s), ends with jne to 0x00516ff3 (forward)
    cmp bl, byte ptr [0x568410]                  # 00516fe4
    jne.d8 L_00516ff3                            # 00516fea
L_00516fec:
    # block 0x00516fec: entered by je at 0x0051708d; fall-through of jne at 0x00516fea, 2 instruction(s), ends with forward jump to 0x00517239
    push 0x5                                     # 00516fec
    jmp.d32 L_00517239                           # 00516fee
L_00516ff3:
    # block 0x00516ff3: entered by jne at 0x00516fea, 3 instruction(s), ends with je to 0x00517019 (forward)
    movsx eax, bl                                # 00516ff3
    sub eax, 0x2b                                # 00516ff6
    je.d8 L_00517019                             # 00516ff9
    # block 0x00516ffb: entered by fall-through of je at 0x00516ff9, 3 instruction(s), ends with je to 0x0051700d (forward)
    dec eax                                      # 00516ffb
    dec eax                                      # 00516ffc
    je.d8 L_0051700d                             # 00516ffd
    # block 0x00516fff: entered by fall-through of je at 0x00516ffd, 2 instruction(s), ends with jne to 0x005172dc (forward)
    sub eax, 0x3                                 # 00516fff
    jne.d32 L_005172dc                           # 00517002
    # block 0x00517008: entered by fall-through of jne at 0x00517002, 1 instruction(s), ends with forward jump to 0x0051709c
    jmp.d32 L_0051709c                           # 00517008
L_0051700d:
    # block 0x0051700d: entered by je at 0x00516ffd, 4 instruction(s), ends with backward jump to 0x00516fc0
    push 0x2                                     # 0051700d
    mov dword ptr [ebp - local_28], 0x8000       # 0051700f
    pop eax                                      # 00517016
    jmp.d8 L_00516fc0                            # 00517017
L_00517019:
    # block 0x00517019: entered by je at 0x00516ff9, 4 instruction(s), ends with backward jump to 0x00516fc0
    and dword ptr [ebp - local_28], 0x0          # 00517019
    push 0x2                                     # 0051701d
    pop eax                                      # 0051701f
    jmp.d8 L_00516fc0                            # 00517020
L_00517022:
    # block 0x00517022: entered by switch case, 3 instruction(s), ends with jl to 0x0051702f (forward)
    cmp bl, 0x31                                 # 00517022
    mov dword ptr [ebp - local_10], edx          # 00517025
    jl.d8 L_0051702f                             # 00517028
    # block 0x0051702a: entered by fall-through of jl at 0x00517028, 2 instruction(s), ends with jle to 0x00516fdd (backward)
    cmp bl, 0x39                                 # 0051702a
    jle.d8 L_00516fdd                            # 0051702d
L_0051702f:
    # block 0x0051702f: entered by jl at 0x00517028; fall-through of jle at 0x0051702d, 2 instruction(s), ends with je to 0x005170f7 (forward)
    cmp bl, byte ptr [0x568410]                  # 0051702f
    je.d32 L_005170f7                            # 00517035
    # block 0x0051703b: entered by fall-through of je at 0x00517035, 2 instruction(s), ends with je to 0x00517071 (forward)
    cmp bl, 0x2b                                 # 0051703b
    je.d8 L_00517071                             # 0051703e
    # block 0x00517040: entered by fall-through of je at 0x0051703e, 2 instruction(s), ends with je to 0x00517071 (forward)
    cmp bl, 0x2d                                 # 00517040
    je.d8 L_00517071                             # 00517043
    # block 0x00517045: entered by fall-through of je at 0x00517043, 2 instruction(s), ends with je to 0x0051709c (forward)
    cmp bl, 0x30                                 # 00517045
    je.d8 L_0051709c                             # 00517048
L_0051704a:
    # block 0x0051704a: entered by jmp at 0x00517170; fall-through of je at 0x00517048, 2 instruction(s), ends with jle to 0x005172dc (forward)
    cmp bl, 0x43                                 # 0051704a
    jle.d32 L_005172dc                           # 0051704d
    # block 0x00517053: entered by fall-through of jle at 0x0051704d, 2 instruction(s), ends with jle to 0x0051706a (forward)
    cmp bl, 0x45                                 # 00517053
    jle.d8 L_0051706a                            # 00517056
    # block 0x00517058: entered by fall-through of jle at 0x00517056, 2 instruction(s), ends with jle to 0x005172dc (forward)
    cmp bl, 0x63                                 # 00517058
    jle.d32 L_005172dc                           # 0051705b
    # block 0x00517061: entered by fall-through of jle at 0x0051705b, 2 instruction(s), ends with jg to 0x005172dc (forward)
    cmp bl, 0x65                                 # 00517061
    jg.d32 L_005172dc                            # 00517064
L_0051706a:
    # block 0x0051706a: entered by jle at 0x00517056; fall-through of jg at 0x00517064, 2 instruction(s), ends with forward jump to 0x00517239
    push 0x6                                     # 0051706a
    jmp.d32 L_00517239                           # 0051706c
L_00517071:
    # block 0x00517071: entered by je at 0x0051703e; je at 0x00517043; je at 0x00517161; je at 0x0051716a, 3 instruction(s), ends with forward jump to 0x00517239
    dec edi                                      # 00517071
    push 0xb                                     # 00517072
    jmp.d32 L_00517239                           # 00517074
L_00517079:
    # block 0x00517079: entered by switch case, 2 instruction(s), ends with jl to 0x00517087 (forward)
    cmp bl, 0x31                                 # 00517079
    jl.d8 L_00517087                             # 0051707c
    # block 0x0051707e: entered by fall-through of jl at 0x0051707c, 2 instruction(s), ends with jle to 0x00516fdd (backward)
    cmp bl, 0x39                                 # 0051707e
    jle.d32 L_00516fdd                           # 00517081
L_00517087:
    # block 0x00517087: entered by jl at 0x0051707c; fall-through of jle at 0x00517081, 2 instruction(s), ends with je to 0x00516fec (backward)
    cmp bl, byte ptr [0x568410]                  # 00517087
    je.d32 L_00516fec                            # 0051708d
    # block 0x00517093: entered by fall-through of je at 0x0051708d, 2 instruction(s), ends with jne to 0x00517251 (forward)
    cmp bl, 0x30                                 # 00517093
    jne.d32 L_00517251                           # 00517096
L_0051709c:
    # block 0x0051709c: entered by jmp at 0x00517008; je at 0x00517048; fall-through of jne at 0x00517096, 2 instruction(s), ends with backward jump to 0x00516fc0
    {load} mov eax, edx                          # 0051709c
    jmp.d32 L_00516fc0                           # 0051709e
L_005170a3:
    # block 0x005170a3: entered by switch case, 1 instruction(s), falls into the block at 0x005170a6
    mov dword ptr [ebp - local_10], edx          # 005170a3
L_005170a6:
    # block 0x005170a6: entered by jmp at 0x005170ed, 2 instruction(s), ends with jle to 0x005170bf (forward)
    cmp dword ptr [0x56840c], edx                # 005170a6
    jle.d8 L_005170bf                            # 005170ac
    # block 0x005170ae: entered by fall-through of jle at 0x005170ac, 9 instruction(s), calls FUN_005118b3, ends with forward jump to 0x005170cd
    movzx eax, bl                                # 005170ae
    push esi                                     # 005170b1
    push eax                                     # 005170b2
    call FUN_005118b3                            # 005170b3
    pop ecx                                      # 005170b8
    pop ecx                                      # 005170b9
    push 0x1                                     # 005170ba
    pop edx                                      # 005170bc
    jmp.d8 L_005170cd                            # 005170bd
L_005170bf:
    # block 0x005170bf: entered by jle at 0x005170ac, 4 instruction(s), falls into the block at 0x005170cd
    mov ecx, dword ptr [0x568200]                # 005170bf
    movzx eax, bl                                # 005170c5
    mov al, byte ptr [ecx + 2*eax]               # 005170c8
    {load} and eax, esi                          # 005170cb
L_005170cd:
    # block 0x005170cd: entered by jmp at 0x005170bd, 2 instruction(s), ends with je to 0x005170ef (forward)
    test eax, eax                                # 005170cd
    je.d8 L_005170ef                             # 005170cf
    # block 0x005170d1: entered by fall-through of je at 0x005170cf, 2 instruction(s), ends with jae to 0x005170e7 (forward)
    cmp dword ptr [ebp - local_4], 0x19          # 005170d1
    jae.d8 L_005170e7                            # 005170d5
    # block 0x005170d7: entered by fall-through of jae at 0x005170d5, 6 instruction(s), ends with forward jump to 0x005170ea
    mov eax, dword ptr [ebp - local_c]           # 005170d7
    inc dword ptr [ebp - local_4]                # 005170da
    sub bl, 0x30                                 # 005170dd
    inc dword ptr [ebp - local_c]                # 005170e0
    mov byte ptr [eax], bl                       # 005170e3
    jmp.d8 L_005170ea                            # 005170e5
L_005170e7:
    # block 0x005170e7: entered by jae at 0x005170d5, 1 instruction(s), falls into the block at 0x005170ea
    inc dword ptr [ebp - local_8]                # 005170e7
L_005170ea:
    # block 0x005170ea: entered by jmp at 0x005170e5, 3 instruction(s), ends with backward jump to 0x005170a6
    mov bl, byte ptr [edi]                       # 005170ea
    inc edi                                      # 005170ec
    jmp.d8 L_005170a6                            # 005170ed
L_005170ef:
    # block 0x005170ef: entered by je at 0x005170cf, 2 instruction(s), ends with jne to 0x0051715e (forward)
    cmp bl, byte ptr [0x568410]                  # 005170ef
    jne.d8 L_0051715e                            # 005170f5
L_005170f7:
    # block 0x005170f7: entered by je at 0x00517035; fall-through of jne at 0x005170f5, 2 instruction(s), ends with backward jump to 0x00516fc0
    {load} mov eax, esi                          # 005170f7
    jmp.d32 L_00516fc0                           # 005170f9
L_005170fe:
    # block 0x005170fe: entered by switch case, 4 instruction(s), ends with jne to 0x00517117 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 005170fe
    mov dword ptr [ebp - local_10], edx          # 00517102
    mov dword ptr [ebp - local_24], edx          # 00517105
    jne.d8 L_00517117                            # 00517108
L_0051710a:
    # block 0x0051710a: entered by jmp at 0x00517115; fall-through of jne at 0x00517108, 2 instruction(s), ends with jne to 0x00517117 (forward)
    cmp bl, 0x30                                 # 0051710a
    jne.d8 L_00517117                            # 0051710d
    # block 0x0051710f: entered by fall-through of jne at 0x0051710d, 4 instruction(s), ends with backward jump to 0x0051710a
    dec dword ptr [ebp - local_8]                # 0051710f
    mov bl, byte ptr [edi]                       # 00517112
    inc edi                                      # 00517114
    jmp.d8 L_0051710a                            # 00517115
L_00517117:
    # block 0x00517117: entered by jne at 0x00517108; jne at 0x0051710d; jmp at 0x0051715c, 2 instruction(s), ends with jle to 0x00517130 (forward)
    cmp dword ptr [0x56840c], edx                # 00517117
    jle.d8 L_00517130                            # 0051711d
    # block 0x0051711f: entered by fall-through of jle at 0x0051711d, 9 instruction(s), calls FUN_005118b3, ends with forward jump to 0x0051713e
    movzx eax, bl                                # 0051711f
    push esi                                     # 00517122
    push eax                                     # 00517123
    call FUN_005118b3                            # 00517124
    pop ecx                                      # 00517129
    pop ecx                                      # 0051712a
    push 0x1                                     # 0051712b
    pop edx                                      # 0051712d
    jmp.d8 L_0051713e                            # 0051712e
L_00517130:
    # block 0x00517130: entered by jle at 0x0051711d, 4 instruction(s), falls into the block at 0x0051713e
    mov ecx, dword ptr [0x568200]                # 00517130
    movzx eax, bl                                # 00517136
    mov al, byte ptr [ecx + 2*eax]               # 00517139
    {load} and eax, esi                          # 0051713c
L_0051713e:
    # block 0x0051713e: entered by jmp at 0x0051712e, 2 instruction(s), ends with je to 0x0051715e (forward)
    test eax, eax                                # 0051713e
    je.d8 L_0051715e                             # 00517140
    # block 0x00517142: entered by fall-through of je at 0x00517140, 2 instruction(s), ends with jae to 0x00517159 (forward)
    cmp dword ptr [ebp - local_4], 0x19          # 00517142
    jae.d8 L_00517159                            # 00517146
    # block 0x00517148: entered by fall-through of jae at 0x00517146, 6 instruction(s), falls into the block at 0x00517159
    mov eax, dword ptr [ebp - local_c]           # 00517148
    inc dword ptr [ebp - local_4]                # 0051714b
    sub bl, 0x30                                 # 0051714e
    inc dword ptr [ebp - local_c]                # 00517151
    dec dword ptr [ebp - local_8]                # 00517154
    mov byte ptr [eax], bl                       # 00517157
L_00517159:
    # block 0x00517159: entered by jae at 0x00517146, 3 instruction(s), ends with backward jump to 0x00517117
    mov bl, byte ptr [edi]                       # 00517159
    inc edi                                      # 0051715b
    jmp.d8 L_00517117                            # 0051715c
L_0051715e:
    # block 0x0051715e: entered by jne at 0x005170f5; je at 0x00517140, 2 instruction(s), ends with je to 0x00517071 (backward)
    cmp bl, 0x2b                                 # 0051715e
    je.d32 L_00517071                            # 00517161
    # block 0x00517167: entered by fall-through of je at 0x00517161, 2 instruction(s), ends with je to 0x00517071 (backward)
    cmp bl, 0x2d                                 # 00517167
    je.d32 L_00517071                            # 0051716a
    # block 0x00517170: entered by fall-through of je at 0x0051716a, 1 instruction(s), ends with backward jump to 0x0051704a
    jmp.d32 L_0051704a                           # 00517170
L_00517175:
    # block 0x00517175: entered by switch case, 3 instruction(s), ends with jle to 0x00517191 (forward)
    cmp dword ptr [0x56840c], edx                # 00517175
    mov dword ptr [ebp - local_24], edx          # 0051717b
    jle.d8 L_00517191                            # 0051717e
    # block 0x00517180: entered by fall-through of jle at 0x0051717e, 9 instruction(s), calls FUN_005118b3, ends with forward jump to 0x0051719f
    movzx eax, bl                                # 00517180
    push esi                                     # 00517183
    push eax                                     # 00517184
    call FUN_005118b3                            # 00517185
    pop ecx                                      # 0051718a
    pop ecx                                      # 0051718b
    push 0x1                                     # 0051718c
    pop edx                                      # 0051718e
    jmp.d8 L_0051719f                            # 0051718f
L_00517191:
    # block 0x00517191: entered by jle at 0x0051717e, 4 instruction(s), falls into the block at 0x0051719f
    mov ecx, dword ptr [0x568200]                # 00517191
    movzx eax, bl                                # 00517197
    mov al, byte ptr [ecx + 2*eax]               # 0051719a
    {load} and eax, esi                          # 0051719d
L_0051719f:
    # block 0x0051719f: entered by jmp at 0x0051718f, 2 instruction(s), ends with je to 0x00517251 (forward)
    test eax, eax                                # 0051719f
    je.d32 L_00517251                            # 005171a1
    # block 0x005171a7: entered by fall-through of je at 0x005171a1, 2 instruction(s), ends with forward jump to 0x00517202
    {load} mov eax, esi                          # 005171a7
    jmp.d8 L_00517202                            # 005171a9
L_005171ab:
    # block 0x005171ab: entered by switch case, 4 instruction(s), ends with jl to 0x005171bb (forward)
    lea ecx, [edi - field_minus_2]               # 005171ab
    cmp bl, 0x31                                 # 005171ae
    mov dword ptr [ebp + arg_10], ecx            # 005171b1
    jl.d8 L_005171bb                             # 005171b4
    # block 0x005171b6: entered by fall-through of jl at 0x005171b4, 2 instruction(s), ends with jle to 0x005171ff (forward)
    cmp bl, 0x39                                 # 005171b6
    jle.d8 L_005171ff                            # 005171b9
L_005171bb:
    # block 0x005171bb: entered by jl at 0x005171b4; fall-through of jle at 0x005171b9, 3 instruction(s), ends with je to 0x00517237 (forward)
    movsx eax, bl                                # 005171bb
    sub eax, 0x2b                                # 005171be
    je.d8 L_00517237                             # 005171c1
    # block 0x005171c3: entered by fall-through of je at 0x005171c1, 3 instruction(s), ends with je to 0x0051722b (forward)
    dec eax                                      # 005171c3
    dec eax                                      # 005171c4
    je.d8 L_0051722b                             # 005171c5
    # block 0x005171c7: entered by fall-through of je at 0x005171c5, 2 instruction(s), ends with jne to 0x005172df (forward)
    sub eax, 0x3                                 # 005171c7
    jne.d32 L_005172df                           # 005171ca
L_005171d0:
    # block 0x005171d0: entered by jmp at 0x0051720d; fall-through of jne at 0x005171ca, 2 instruction(s), ends with forward jump to 0x00517239
    push 0x8                                     # 005171d0
    jmp.d8 L_00517239                            # 005171d2
L_005171d4:
    # block 0x005171d4: entered by switch case, 1 instruction(s), falls into the block at 0x005171d7
    mov dword ptr [ebp - local_20], edx          # 005171d4
L_005171d7:
    # block 0x005171d7: entered by jmp at 0x005171df, 2 instruction(s), ends with jne to 0x005171e1 (forward)
    cmp bl, 0x30                                 # 005171d7
    jne.d8 L_005171e1                            # 005171da
    # block 0x005171dc: entered by fall-through of jne at 0x005171da, 3 instruction(s), ends with backward jump to 0x005171d7
    mov bl, byte ptr [edi]                       # 005171dc
    inc edi                                      # 005171de
    jmp.d8 L_005171d7                            # 005171df
L_005171e1:
    # block 0x005171e1: entered by jne at 0x005171da, 2 instruction(s), ends with jl to 0x005172dc (forward)
    cmp bl, 0x31                                 # 005171e1
    jl.d32 L_005172dc                            # 005171e4
    # block 0x005171ea: entered by fall-through of jl at 0x005171e4, 2 instruction(s), ends with jg to 0x005172dc (forward)
    cmp bl, 0x39                                 # 005171ea
    jg.d32 L_005172dc                            # 005171ed
    # block 0x005171f3: entered by fall-through of jg at 0x005171ed, 1 instruction(s), ends with forward jump to 0x005171ff
    jmp.d8 L_005171ff                            # 005171f3
L_005171f5:
    # block 0x005171f5: entered by switch case, 2 instruction(s), ends with jl to 0x00517208 (forward)
    cmp bl, 0x31                                 # 005171f5
    jl.d8 L_00517208                             # 005171f8
    # block 0x005171fa: entered by fall-through of jl at 0x005171f8, 2 instruction(s), ends with jg to 0x00517208 (forward)
    cmp bl, 0x39                                 # 005171fa
    jg.d8 L_00517208                             # 005171fd
L_005171ff:
    # block 0x005171ff: entered by jle at 0x005171b9; jmp at 0x005171f3; fall-through of jg at 0x005171fd, 1 instruction(s), falls into the block at 0x00517201
    push 0x9                                     # 005171ff
L_00517201:
    # block 0x00517201: entered by jmp at 0x00516fdf, 1 instruction(s), falls into the block at 0x00517202
    pop eax                                      # 00517201
L_00517202:
    # block 0x00517202: entered by jmp at 0x005171a9, 2 instruction(s), ends with backward jump to 0x00516fc0
    dec edi                                      # 00517202
    jmp.d32 L_00516fc0                           # 00517203
L_00517208:
    # block 0x00517208: entered by jl at 0x005171f8; jg at 0x005171fd, 2 instruction(s), ends with jne to 0x00517251 (forward)
    cmp bl, 0x30                                 # 00517208
    jne.d8 L_00517251                            # 0051720b
    # block 0x0051720d: entered by fall-through of jne at 0x0051720b, 1 instruction(s), ends with backward jump to 0x005171d0
    jmp.d8 L_005171d0                            # 0051720d
L_0051720f:
    # block 0x0051720f: entered by switch case, 2 instruction(s), ends with je to 0x0051723f (forward)
    cmp dword ptr [ebp + arg_20], 0x0            # 0051720f
    je.d8 L_0051723f                             # 00517213
    # block 0x00517215: entered by fall-through of je at 0x00517213, 5 instruction(s), ends with je to 0x00517237 (forward)
    movsx eax, bl                                # 00517215
    lea ecx, [edi - field_minus_1]               # 00517218
    sub eax, 0x2b                                # 0051721b
    mov dword ptr [ebp + arg_10], ecx            # 0051721e
    je.d8 L_00517237                             # 00517221
    # block 0x00517223: entered by fall-through of je at 0x00517221, 3 instruction(s), ends with jne to 0x005172df (forward)
    dec eax                                      # 00517223
    dec eax                                      # 00517224
    jne.d32 L_005172df                           # 00517225
L_0051722b:
    # block 0x0051722b: entered by je at 0x005171c5; fall-through of jne at 0x00517225, 4 instruction(s), ends with backward jump to 0x00516fc0
    or dword ptr [ebp - local_18], -0x1          # 0051722b
    push 0x7                                     # 0051722f
    pop eax                                      # 00517231
    jmp.d32 L_00516fc0                           # 00517232
L_00517237:
    # block 0x00517237: entered by je at 0x005171c1; je at 0x00517221, 1 instruction(s), falls into the block at 0x00517239
    push 0x7                                     # 00517237
L_00517239:
    # block 0x00517239: entered by jmp at 0x00516fee; jmp at 0x0051706c; jmp at 0x00517074; jmp at 0x005171d2, 2 instruction(s), ends with backward jump to 0x00516fc0
    pop eax                                      # 00517239
    jmp.d32 L_00516fc0                           # 0051723a
L_0051723f:
    # block 0x0051723f: entered by je at 0x00517213, 3 instruction(s), falls into the block at 0x00517243
    push 0xa                                     # 0051723f
    dec edi                                      # 00517241
    pop eax                                      # 00517242
L_00517243:
    # block 0x00517243: entered by ja at 0x00516fc6; switch case, 2 instruction(s), ends with je to 0x005172e1 (forward)
    cmp eax, 0xa                                 # 00517243
    je.d32 L_005172e1                            # 00517246
    # block 0x0051724c: entered by fall-through of je at 0x00517246, 1 instruction(s), ends with backward jump to 0x00516fc0
    jmp.d32 L_00516fc0                           # 0051724c
L_00517251:
    # block 0x00517251: entered by jne at 0x00517096; je at 0x005171a1; jne at 0x0051720b, 2 instruction(s), ends with forward jump to 0x005172e1
    mov edi, dword ptr [ebp + arg_10]            # 00517251
    jmp.d32 L_005172e1                           # 00517254
L_00517259:
    # block 0x00517259: entered by switch case, 2 instruction(s), falls into the block at 0x00517262
    mov dword ptr [ebp - local_20], 0x1          # 00517259
    {load} xor esi, esi                          # 00517260
L_00517262:
    # block 0x00517262: entered by jmp at 0x005172a2, 2 instruction(s), ends with jle to 0x0051727a (forward)
    cmp dword ptr [0x56840c], 0x1                # 00517262
    jle.d8 L_0051727a                            # 00517269
    # block 0x0051726b: entered by fall-through of jle at 0x00517269, 7 instruction(s), calls FUN_005118b3, ends with forward jump to 0x00517289
    movzx eax, bl                                # 0051726b
    push 0x4                                     # 0051726e
    push eax                                     # 00517270
    call FUN_005118b3                            # 00517271
    pop ecx                                      # 00517276
    pop ecx                                      # 00517277
    jmp.d8 L_00517289                            # 00517278
L_0051727a:
    # block 0x0051727a: entered by jle at 0x00517269, 4 instruction(s), falls into the block at 0x00517289
    mov ecx, dword ptr [0x568200]                # 0051727a
    movzx eax, bl                                # 00517280
    mov al, byte ptr [ecx + 2*eax]               # 00517283
    and eax, 0x4                                 # 00517286
L_00517289:
    # block 0x00517289: entered by jmp at 0x00517278, 2 instruction(s), ends with je to 0x005172a9 (forward)
    test eax, eax                                # 00517289
    je.d8 L_005172a9                             # 0051728b
    # block 0x0051728d: entered by fall-through of je at 0x0051728b, 5 instruction(s), ends with jg to 0x005172a4 (forward)
    movsx ecx, bl                                # 0051728d
    lea eax, [esi + 4*esi]                       # 00517290
    lea esi, [ecx + 2*eax - field_minus_30]      # 00517293
    cmp esi, 0x1450                              # 00517297
    jg.d8 L_005172a4                             # 0051729d
    # block 0x0051729f: entered by fall-through of jg at 0x0051729d, 3 instruction(s), ends with backward jump to 0x00517262
    mov bl, byte ptr [edi]                       # 0051729f
    inc edi                                      # 005172a1
    jmp.d8 L_00517262                            # 005172a2
L_005172a4:
    # block 0x005172a4: entered by jg at 0x0051729d, 1 instruction(s), falls into the block at 0x005172a9
    mov esi, 0x1451                              # 005172a4
L_005172a9:
    # block 0x005172a9: entered by je at 0x0051728b, 1 instruction(s), falls into the block at 0x005172ac
    mov dword ptr [ebp - local_1c], esi          # 005172a9
L_005172ac:
    # block 0x005172ac: entered by jmp at 0x005172da, 2 instruction(s), ends with jle to 0x005172c4 (forward)
    cmp dword ptr [0x56840c], 0x1                # 005172ac
    jle.d8 L_005172c4                            # 005172b3
    # block 0x005172b5: entered by fall-through of jle at 0x005172b3, 7 instruction(s), calls FUN_005118b3, ends with forward jump to 0x005172d3
    movzx eax, bl                                # 005172b5
    push 0x4                                     # 005172b8
    push eax                                     # 005172ba
    call FUN_005118b3                            # 005172bb
    pop ecx                                      # 005172c0
    pop ecx                                      # 005172c1
    jmp.d8 L_005172d3                            # 005172c2
L_005172c4:
    # block 0x005172c4: entered by jle at 0x005172b3, 4 instruction(s), falls into the block at 0x005172d3
    mov ecx, dword ptr [0x568200]                # 005172c4
    movzx eax, bl                                # 005172ca
    mov al, byte ptr [ecx + 2*eax]               # 005172cd
    and eax, 0x4                                 # 005172d0
L_005172d3:
    # block 0x005172d3: entered by jmp at 0x005172c2, 2 instruction(s), ends with je to 0x005172dc (forward)
    test eax, eax                                # 005172d3
    je.d8 L_005172dc                             # 005172d5
    # block 0x005172d7: entered by fall-through of je at 0x005172d5, 3 instruction(s), ends with backward jump to 0x005172ac
    mov bl, byte ptr [edi]                       # 005172d7
    inc edi                                      # 005172d9
    jmp.d8 L_005172ac                            # 005172da
L_005172dc:
    # block 0x005172dc: entered by jne at 0x00517002; jle at 0x0051704d; jle at 0x0051705b; jg at 0x00517064; more, 2 instruction(s), ends with forward jump to 0x005172e1
    dec edi                                      # 005172dc
    jmp.d8 L_005172e1                            # 005172dd
L_005172df:
    # block 0x005172df: entered by jne at 0x005171ca; jne at 0x00517225, 1 instruction(s), falls into the block at 0x005172e1
    {load} mov edi, ecx                          # 005172df
L_005172e1:
    # block 0x005172e1: entered by je at 0x00517246; jmp at 0x00517254; jmp at 0x005172dd, 4 instruction(s), ends with je to 0x005173c9 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 005172e1
    cmp dword ptr [ebp - local_10], 0x0          # 005172e4
    mov dword ptr [eax], edi                     # 005172e8
    je.d32 L_005173c9                            # 005172ea
    # block 0x005172f0: entered by fall-through of je at 0x005172ea, 4 instruction(s), ends with jbe to 0x0051730d (forward)
    push 0x18                                    # 005172f0
    pop eax                                      # 005172f2
    cmp dword ptr [ebp - local_4], eax           # 005172f3
    jbe.d8 L_0051730d                            # 005172f6
    # block 0x005172f8: entered by fall-through of jbe at 0x005172f6, 2 instruction(s), ends with jl to 0x00517301 (forward)
    cmp byte ptr [ebp - local_45], 0x5           # 005172f8
    jl.d8 L_00517301                             # 005172fc
    # block 0x005172fe: entered by fall-through of jl at 0x005172fc, 1 instruction(s), falls into the block at 0x00517301
    inc byte ptr [ebp - local_45]                # 005172fe
L_00517301:
    # block 0x00517301: entered by jl at 0x005172fc, 5 instruction(s), ends with forward jump to 0x00517310
    mov dword ptr [ebp - local_4], eax           # 00517301
    mov eax, dword ptr [ebp - local_c]           # 00517304
    dec eax                                      # 00517307
    inc dword ptr [ebp - local_8]                # 00517308
    jmp.d8 L_00517310                            # 0051730b
L_0051730d:
    # block 0x0051730d: entered by jbe at 0x005172f6, 1 instruction(s), falls into the block at 0x00517310
    mov eax, dword ptr [ebp - local_c]           # 0051730d
L_00517310:
    # block 0x00517310: entered by jmp at 0x0051730b, 2 instruction(s), ends with jbe to 0x005173bf (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00517310
    jbe.d32 L_005173bf                           # 00517314
L_0051731a:
    # block 0x0051731a: entered by jmp at 0x00517326; fall-through of jbe at 0x00517314, 3 instruction(s), ends with jne to 0x00517328 (forward)
    dec eax                                      # 0051731a
    cmp byte ptr [eax], 0x0                      # 0051731b
    jne.d8 L_00517328                            # 0051731e
    # block 0x00517320: entered by fall-through of jne at 0x0051731e, 3 instruction(s), ends with backward jump to 0x0051731a
    dec dword ptr [ebp - local_4]                # 00517320
    inc dword ptr [ebp - local_8]                # 00517323
    jmp.d8 L_0051731a                            # 00517326
L_00517328:
    # block 0x00517328: entered by jne at 0x0051731e, 11 instruction(s), calls FUN_00518caf, ends with jge to 0x00517347 (forward)
    lea eax, [ebp - local_40]                    # 00517328
    push eax                                     # 0051732b
    lea eax, [ebp - local_5c]                    # 0051732c
    push dword ptr [ebp - local_4]               # 0051732f
    push eax                                     # 00517332
    call FUN_00518caf                            # 00517333
    mov eax, dword ptr [ebp - local_1c]          # 00517338
    {load} xor ecx, ecx                          # 0051733b
    add esp, 0xc                                 # 0051733d
    cmp dword ptr [ebp - local_18], ecx          # 00517340
    jge.d8 L_00517347                            # 00517343
    # block 0x00517345: entered by fall-through of jge at 0x00517343, 1 instruction(s), falls into the block at 0x00517347
    neg eax                                      # 00517345
L_00517347:
    # block 0x00517347: entered by jge at 0x00517343, 3 instruction(s), ends with jne to 0x00517352 (forward)
    add eax, dword ptr [ebp - local_8]           # 00517347
    cmp dword ptr [ebp - local_20], ecx          # 0051734a
    jne.d8 L_00517352                            # 0051734d
    # block 0x0051734f: entered by fall-through of jne at 0x0051734d, 1 instruction(s), falls into the block at 0x00517352
    add eax, dword ptr [ebp + arg_18]            # 0051734f
L_00517352:
    # block 0x00517352: entered by jne at 0x0051734d, 2 instruction(s), ends with jne to 0x0051735a (forward)
    cmp dword ptr [ebp - local_24], ecx          # 00517352
    jne.d8 L_0051735a                            # 00517355
    # block 0x00517357: entered by fall-through of jne at 0x00517355, 1 instruction(s), falls into the block at 0x0051735a
    sub eax, dword ptr [ebp + arg_1c]            # 00517357
L_0051735a:
    # block 0x0051735a: entered by jne at 0x00517355, 2 instruction(s), ends with jle to 0x00517391 (forward)
    cmp eax, 0x1450                              # 0051735a
    jle.d8 L_00517391                            # 0051735f
    # block 0x00517361: entered by fall-through of jle at 0x0051735f, 1 instruction(s), falls into the block at 0x00517368
    mov dword ptr [ebp - local_2c], 0x1          # 00517361
L_00517368:
    # block 0x00517368: entered by jmp at 0x0051739f, 4 instruction(s), falls into the block at 0x00517374
    mov ebx, dword ptr [ebp + arg_10]            # 00517368
    mov esi, dword ptr [ebp + arg_10]            # 0051736b
    mov eax, dword ptr [ebp + arg_10]            # 0051736e
    mov edx, dword ptr [ebp + arg_10]            # 00517371
L_00517374:
    # block 0x00517374: entered by jmp at 0x005173bd; jmp at 0x005173c7, 2 instruction(s), ends with je to 0x005173da (forward)
    cmp dword ptr [ebp - local_2c], 0x0          # 00517374
    je.d8 L_005173da                             # 00517378
    # block 0x0051737a: entered by fall-through of je at 0x00517378, 6 instruction(s), ends with forward jump to 0x005173ef
    {load} xor ebx, ebx                          # 0051737a
    mov eax, 0x7fff                              # 0051737c
    mov esi, 0x80000000                          # 00517381
    {load} xor edx, edx                          # 00517386
    mov dword ptr [ebp - local_14], 0x2          # 00517388
    jmp.d8 L_005173ef                            # 0051738f
L_00517391:
    # block 0x00517391: entered by jle at 0x0051735f, 2 instruction(s), ends with jge to 0x005173a1 (forward)
    cmp eax, 0xffffebb0                          # 00517391
    jge.d8 L_005173a1                            # 00517396
    # block 0x00517398: entered by fall-through of jge at 0x00517396, 2 instruction(s), ends with backward jump to 0x00517368
    mov dword ptr [ebp - local_30], 0x1          # 00517398
    jmp.d8 L_00517368                            # 0051739f
L_005173a1:
    # block 0x005173a1: entered by jge at 0x00517396, 11 instruction(s), calls FUN_00519229, ends with backward jump to 0x00517374
    push dword ptr [ebp + arg_14]                # 005173a1
    push eax                                     # 005173a4
    lea eax, [ebp - local_40]                    # 005173a5
    push eax                                     # 005173a8
    call FUN_00519229                            # 005173a9
    mov edx, dword ptr [ebp - local_40]          # 005173ae
    mov ebx, dword ptr [ebp - local_3e]          # 005173b1
    mov esi, dword ptr [ebp - local_3a]          # 005173b4
    mov eax, dword ptr [ebp - local_36]          # 005173b7
    add esp, 0xc                                 # 005173ba
    jmp.d8 L_00517374                            # 005173bd
L_005173bf:
    # block 0x005173bf: entered by jbe at 0x00517314, 5 instruction(s), ends with backward jump to 0x00517374
    {load} xor edx, edx                          # 005173bf
    {load} xor eax, eax                          # 005173c1
    {load} xor esi, esi                          # 005173c3
    {load} xor ebx, ebx                          # 005173c5
    jmp.d8 L_00517374                            # 005173c7
L_005173c9:
    # block 0x005173c9: entered by je at 0x005172ea, 6 instruction(s), ends with forward jump to 0x005173ef
    {load} xor edx, edx                          # 005173c9
    {load} xor eax, eax                          # 005173cb
    {load} xor esi, esi                          # 005173cd
    {load} xor ebx, ebx                          # 005173cf
    mov dword ptr [ebp - local_14], 0x4          # 005173d1
    jmp.d8 L_005173ef                            # 005173d8
L_005173da:
    # block 0x005173da: entered by je at 0x00517378, 2 instruction(s), ends with je to 0x005173ef (forward)
    cmp dword ptr [ebp - local_30], 0x0          # 005173da
    je.d8 L_005173ef                             # 005173de
    # block 0x005173e0: entered by fall-through of je at 0x005173de, 5 instruction(s), falls into the block at 0x005173ef
    {load} xor edx, edx                          # 005173e0
    {load} xor eax, eax                          # 005173e2
    {load} xor esi, esi                          # 005173e4
    {load} xor ebx, ebx                          # 005173e6
    mov dword ptr [ebp - local_14], 0x1          # 005173e8
L_005173ef:
    # block 0x005173ef: entered by jmp at 0x0051738f; jmp at 0x005173d8; je at 0x005173de, 12 instruction(s), ends with ret
    mov ecx, dword ptr [ebp + arg_8]             # 005173ef
    or eax, dword ptr [ebp - local_28]           # 005173f2
    pop edi                                      # 005173f5
    mov dword ptr [ecx + field_6], esi           # 005173f6
    mov dword ptr [ecx + field_2], ebx           # 005173f9
    mov word ptr [ecx + field_a], ax             # 005173fc
    mov eax, dword ptr [ebp - local_14]          # 00517400
    pop esi                                      # 00517403
    mov word ptr [ecx], dx                       # 00517404
    pop ebx                                      # 00517407
    leave                                        # 00517408
    ret                                          # 00517409

# --- data items (not part of the function) -------------------------
.org 0x0051740a - 0x401000
SWTAB_0051740a:  # 12 case address(es)
    .long L_00516fd3 - .text + 0x401000
    .long L_00517022 - .text + 0x401000
    .long L_00517079 - .text + 0x401000
    .long L_005170a3 - .text + 0x401000
    .long L_005170fe - .text + 0x401000
    .long L_00517175 - .text + 0x401000
    .long L_005171ab - .text + 0x401000
    .long L_005171f5 - .text + 0x401000
    .long L_005171d4 - .text + 0x401000
    .long L_00517259 - .text + 0x401000
    .long L_00517243 - .text + 0x401000
    .long L_0051720f - .text + 0x401000
.set SWTAB_0051740a_VA, SWTAB_0051740a - .text + 0x401000

