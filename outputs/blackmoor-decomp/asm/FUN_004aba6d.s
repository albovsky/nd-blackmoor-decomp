# FUN_004aba6d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aba6d
# extent:       0x004aba6d-0x004ac363 (2294 code bytes)
# span:         0x004aba6d-0x004ac37f (code 2294, tables 28, padding 0)
# sha256:       202f46f68fe22cbbce9e232724f9bd620668b73985057a79f04e1183aa0c39b0
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aba6d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_1c, field_24, field_28, field_32, field_36, field_38, field_3b, field_3c, field_48, field_54 and 12 more; [ecx + n] field_1c, field_1e, field_20, field_25, field_2a, field_32, field_34, field_38, field_3a, field_3c, field_48, field_58 and 14 more; [edx + n] field_4, field_8, field_1c, field_1e, field_25, field_2e, field_32, field_34, field_36, field_38, field_3c, field_48 and 11 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004ab85a, FUN_004ab9fa, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004ab3dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 574 instruction(s), 37 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_34, 0x34  # offset +0x34
.equ field_36, 0x36  # offset +0x36
.equ field_38, 0x38  # offset +0x38
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3c, 0x3c  # offset +0x3c
.equ field_48, 0x48  # offset +0x48
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_59, 0x59  # offset +0x59
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_21f, 0x21f  # offset +0x21f
.equ field_aa9, 0xaa9  # offset +0xaa9
.equ field_b09, 0xb09  # offset +0xb09
.equ field_b4a, 0xb4a  # offset +0xb4a
.equ field_b4c, 0xb4c  # offset +0xb4c
.equ field_b4e, 0xb4e  # offset +0xb4e
.equ field_b50, 0xb50  # offset +0xb50
.equ field_b52, 0xb52  # offset +0xb52
.equ field_b56, 0xb56  # offset +0xb56
.equ field_b5a, 0xb5a  # offset +0xb5a
.equ field_b5e, 0xb5e  # offset +0xb5e
.equ field_b60, 0xb60  # offset +0xb60
.equ field_b62, 0xb62  # offset +0xb62
.equ field_b86, 0xb86  # offset +0xb86
.equ field_b96, 0xb96  # offset +0xb96
.equ field_b98, 0xb98  # offset +0xb98
.equ field_b9a, 0xb9a  # offset +0xb9a
.equ field_b9c, 0xb9c  # offset +0xb9c
.equ field_b9e, 0xb9e  # offset +0xb9e
.equ field_ba2, 0xba2  # offset +0xba2
.equ field_ba6, 0xba6  # offset +0xba6
.equ field_baa, 0xbaa  # offset +0xbaa
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bae, 0xbae  # offset +0xbae

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004ab3dc, .text + (0x004ab3dc - 0x401000)
.set FUN_004ab85a, .text + (0x004ab85a - 0x401000)
.set FUN_004ab9fa, .text + (0x004ab9fa - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004aba6d - 0x401000
.globl FUN_004aba6d
FUN_004aba6d:
    # block 0x004aba6d: entry, 16 instruction(s), ends with je to 0x004ababd (forward)
    push ebp                                     # 004aba6d
    {load} mov ebp, esp                          # 004aba6e
    sub esp, 0x14                                # 004aba70
    push esi                                     # 004aba73
    push edi                                     # 004aba74
    mov dword ptr [ebp - local_c], ecx           # 004aba75
    movsx eax, word ptr [ebp + arg_8]            # 004aba78
    imul eax, eax, 0x8d                          # 004aba7c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004aba82
    mov dword ptr [ebp - local_4], ecx           # 004aba88
    movsx edx, word ptr [ebp + arg_8]            # 004aba8b
    imul edx, edx, 0x8d                          # 004aba8f
    mov eax, dword ptr [edx + 0x5bb632]          # 004aba95
    mov dword ptr [ebp - local_10], eax          # 004aba9b
    cmp dword ptr [ebp - local_10], 0x0          # 004aba9e
    je.d8 L_004ababd                             # 004abaa2
    # block 0x004abaa4: entered by fall-through of je at 0x004abaa2, 2 instruction(s), ends with je to 0x004abd2d (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004abaa4
    je.d32 L_004abd2d                            # 004abaa8
    # block 0x004abaae: entered by fall-through of je at 0x004abaa8, 2 instruction(s), ends with je to 0x004ac0a9 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004abaae
    je.d32 L_004ac0a9                            # 004abab2
    # block 0x004abab8: entered by fall-through of je at 0x004abab2, 1 instruction(s), ends with forward jump to 0x004ac35b
    jmp.d32 L_004ac35b                           # 004abab8
L_004ababd:
    # block 0x004ababd: entered by je at 0x004abaa2, 85 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x004abc32 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004ababd
    mov dx, word ptr [ebp + arg_8]               # 004abac0
    mov word ptr [ecx + field_1e], dx            # 004abac4
    mov eax, dword ptr [ebp - local_c]           # 004abac8
    mov dword ptr [eax + field_54], 0x1          # 004abacb
    mov dword ptr [0x5bb1ca], 0x1                # 004abad2
    mov ecx, 0x571442                            # 004abadc
    call FUN_004e8d96                            # 004abae1
    mov ecx, dword ptr [ebp - local_c]           # 004abae6
    mov word ptr [ecx + field_32], 0xffff        # 004abae9
    mov edx, dword ptr [ebp - local_c]           # 004abaef
    mov word ptr [edx + field_34], 0x0           # 004abaf2
    mov eax, dword ptr [ebp - local_c]           # 004abaf8
    mov word ptr [eax + field_36], 0x0           # 004abafb
    mov ecx, dword ptr [ebp - local_c]           # 004abb01
    mov word ptr [ecx + field_38], 0x0           # 004abb04
    {load} xor edx, edx                          # 004abb0a
    mov eax, dword ptr [ebp - local_c]           # 004abb0c
    add eax, 0x3c                                # 004abb0f
    mov dword ptr [eax], edx                     # 004abb12
    mov dword ptr [eax + field_4], edx           # 004abb14
    mov dword ptr [eax + field_8], edx           # 004abb17
    {load} xor ecx, ecx                          # 004abb1a
    mov edx, dword ptr [ebp - local_c]           # 004abb1c
    add edx, 0x48                                # 004abb1f
    mov dword ptr [edx], ecx                     # 004abb22
    mov dword ptr [edx + field_4], ecx           # 004abb24
    mov dword ptr [edx + field_8], ecx           # 004abb27
    call FUN_004d39f9                            # 004abb2a
    mov ecx, dword ptr [ebp - local_c]           # 004abb2f
    mov word ptr [ecx + field_1c], ax            # 004abb32
    mov edx, dword ptr [ebp - local_c]           # 004abb36
    movsx eax, word ptr [edx + field_1c]         # 004abb39
    imul eax, eax, 0x4a                          # 004abb3d
    mov dword ptr [eax + 0x5d1591], 0xa          # 004abb40
    mov ecx, dword ptr [ebp - local_c]           # 004abb4a
    movsx edx, word ptr [ecx + field_1c]         # 004abb4d
    imul edx, edx, 0x4a                          # 004abb51
    mov dword ptr [edx + 0x5d1595], 0x4ac498     # 004abb54
    mov eax, dword ptr [ebp - local_c]           # 004abb5e
    movsx ecx, word ptr [eax + field_1c]         # 004abb61
    imul ecx, ecx, 0x4a                          # 004abb65
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004abb68
    mov edx, dword ptr [ebp - local_c]           # 004abb72
    movsx eax, word ptr [edx + field_1c]         # 004abb75
    imul eax, eax, 0x4a                          # 004abb79
    mov dword ptr [eax + 0x5d159d], 0x0          # 004abb7c
    mov ecx, dword ptr [ebp - local_c]           # 004abb86
    movsx edx, word ptr [ecx + field_1c]         # 004abb89
    imul edx, edx, 0x4a                          # 004abb8d
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004abb90
    mov eax, dword ptr [ebp - local_c]           # 004abb9a
    movsx ecx, word ptr [eax + field_1c]         # 004abb9d
    imul ecx, ecx, 0x4a                          # 004abba1
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004abba4
    mov edx, dword ptr [ebp - local_c]           # 004abbae
    movsx eax, word ptr [edx + field_1c]         # 004abbb1
    imul eax, eax, 0x4a                          # 004abbb5
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004abbb8
    mov ecx, dword ptr [ebp - local_c]           # 004abbc2
    movsx edx, word ptr [ecx + field_1c]         # 004abbc5
    imul edx, edx, 0x4a                          # 004abbc9
    mov word ptr [edx + 0x5d15ad], 0x0           # 004abbcc
    mov edi, 0x550fd0                            # 004abbd5
    mov eax, dword ptr [ebp - local_c]           # 004abbda
    movsx ecx, word ptr [eax + field_1c]         # 004abbdd
    imul ecx, ecx, 0x4a                          # 004abbe1
    add ecx, 0x5d15b3                            # 004abbe4
    {load} mov edx, ecx                          # 004abbea
    or ecx, -0x1                                 # 004abbec
    {load} xor eax, eax                          # 004abbef
    repne scasb al, byte ptr es:[edi]            # 004abbf1
    not ecx                                      # 004abbf3
    {load} sub edi, ecx                          # 004abbf5
    {load} mov esi, edi                          # 004abbf7
    {load} mov eax, ecx                          # 004abbf9
    {load} mov edi, edx                          # 004abbfb
    shr ecx, 0x2                                 # 004abbfd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004abc00
    {load} mov ecx, eax                          # 004abc02
    and ecx, 0x3                                 # 004abc04
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004abc07
    mov ecx, dword ptr [ebp - local_c]           # 004abc09
    cmp dword ptr [ecx + field_20], 0x0          # 004abc0c
    jne.d8 L_004abc32                            # 004abc10
    # block 0x004abc12: entered by fall-through of jne at 0x004abc10, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004abc32
    push 0x550fe8                                # 004abc12
    push 0x6                                     # 004abc17
    mov edx, dword ptr [ebp - local_4]           # 004abc19
    push edx                                     # 004abc1c
    push 0x551000                                # 004abc1d
    mov ecx, 0x5cf659                            # 004abc22
    call FUN_004c2790                            # 004abc27
    mov ecx, dword ptr [ebp - local_c]           # 004abc2c
    mov dword ptr [ecx + field_20], eax          # 004abc2f
L_004abc32:
    # block 0x004abc32: entered by jne at 0x004abc10, 13 instruction(s), ends with je to 0x004abc75 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004abc32
    movsx eax, word ptr [edx + field_1c]         # 004abc35
    imul eax, eax, 0x4a                          # 004abc39
    mov ecx, dword ptr [ebp - local_c]           # 004abc3c
    mov edx, dword ptr [ecx + field_20]          # 004abc3f
    mov dword ptr [eax + 0x5d1599], edx          # 004abc42
    mov edi, 0x551008                            # 004abc48
    mov esi, dword ptr [ebp - local_4]           # 004abc4d
    add esi, 0xab7                               # 004abc50
    mov ecx, 0x9                                 # 004abc56
    {load} xor eax, eax                          # 004abc5b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004abc5d
    je.d8 L_004abc75                             # 004abc5f
    # block 0x004abc61: entered by fall-through of je at 0x004abc5f, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004abc75
    mov ecx, dword ptr [ebp - local_4]           # 004abc61
    add ecx, 0xab7                               # 004abc64
    push ecx                                     # 004abc6a
    mov ecx, 0x5c3a67                            # 004abc6b
    call FUN_004fb77a                            # 004abc70
L_004abc75:
    # block 0x004abc75: entered by je at 0x004abc5f, 7 instruction(s), ends with je to 0x004abca1 (forward)
    mov edi, 0x551014                            # 004abc75
    mov esi, dword ptr [ebp - local_4]           # 004abc7a
    add esi, 0xae8                               # 004abc7d
    mov ecx, 0x9                                 # 004abc83
    {load} xor edx, edx                          # 004abc88
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004abc8a
    je.d8 L_004abca1                             # 004abc8c
    # block 0x004abc8e: entered by fall-through of je at 0x004abc8c, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004abca1
    mov eax, dword ptr [ebp - local_4]           # 004abc8e
    add eax, 0xae8                               # 004abc91
    push eax                                     # 004abc96
    mov ecx, 0x5c3a67                            # 004abc97
    call FUN_004fb77a                            # 004abc9c
L_004abca1:
    # block 0x004abca1: entered by je at 0x004abc8c, 7 instruction(s), ends with je to 0x004abccd (forward)
    mov edi, 0x551020                            # 004abca1
    mov esi, dword ptr [ebp - local_4]           # 004abca6
    add esi, 0xb19                               # 004abca9
    mov ecx, 0x9                                 # 004abcaf
    {load} xor edx, edx                          # 004abcb4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004abcb6
    je.d8 L_004abccd                             # 004abcb8
    # block 0x004abcba: entered by fall-through of je at 0x004abcb8, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004abccd
    mov eax, dword ptr [ebp - local_4]           # 004abcba
    add eax, 0xb19                               # 004abcbd
    push eax                                     # 004abcc2
    mov ecx, 0x5c3a67                            # 004abcc3
    call FUN_004fb77a                            # 004abcc8
L_004abccd:
    # block 0x004abccd: entered by je at 0x004abcb8, 7 instruction(s), ends with je to 0x004abcf9 (forward)
    mov edi, 0x55102c                            # 004abccd
    mov esi, dword ptr [ebp - local_4]           # 004abcd2
    add esi, 0xb65                               # 004abcd5
    mov ecx, 0x9                                 # 004abcdb
    {load} xor edx, edx                          # 004abce0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004abce2
    je.d8 L_004abcf9                             # 004abce4
    # block 0x004abce6: entered by fall-through of je at 0x004abce4, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004abcf9
    mov eax, dword ptr [ebp - local_4]           # 004abce6
    add eax, 0xb65                               # 004abce9
    push eax                                     # 004abcee
    mov ecx, 0x5c3a67                            # 004abcef
    call FUN_004fb77a                            # 004abcf4
L_004abcf9:
    # block 0x004abcf9: entered by je at 0x004abce4, 11 instruction(s), ends with forward jump to 0x004ac35b
    mov ecx, dword ptr [ebp - local_c]           # 004abcf9
    mov byte ptr [ecx + field_59], 0x0           # 004abcfc
    mov edx, dword ptr [ebp - local_c]           # 004abd00
    mov byte ptr [edx + field_58], 0x0           # 004abd03
    mov eax, dword ptr [ebp - local_c]           # 004abd07
    mov dword ptr [eax + field_5e], 0x0          # 004abd0a
    mov ecx, dword ptr [ebp - local_c]           # 004abd11
    movsx edx, word ptr [ecx + field_1e]         # 004abd14
    imul edx, edx, 0x8d                          # 004abd18
    mov dword ptr [edx + 0x5bb632], 0x1          # 004abd1e
    jmp.d32 L_004ac35b                           # 004abd28
L_004abd2d:
    # block 0x004abd2d: entered by je at 0x004abaa8, 5 instruction(s), ends with ja to 0x004ac0a4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004abd2d
    mov ecx, dword ptr [eax + field_5e]          # 004abd30
    mov dword ptr [ebp - local_14], ecx          # 004abd33
    cmp dword ptr [ebp - local_14], 0x6          # 004abd36
    ja.d32 L_004ac0a4                            # 004abd3a
    # block 0x004abd40: entered by fall-through of ja at 0x004abd3a, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4ac363]
    mov edx, dword ptr [ebp - local_14]          # 004abd40
    jmp dword ptr [4*edx + SWTAB_004ac363_VA]    # 004abd43
L_004abd4a:
    # block 0x004abd4a: entered by switch case, 3 instruction(s), ends with je to 0x004abdb5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004abd4a
    cmp dword ptr [eax + field_24], 0x0          # 004abd4d
    je.d8 L_004abdb5                             # 004abd51
    # block 0x004abd53: entered by fall-through of je at 0x004abd51, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004abdb3 (forward)
    call dword ptr [0x52a23c]                    # 004abd53
    mov ecx, dword ptr [ebp - local_c]           # 004abd59
    cmp eax, dword ptr [ecx + field_2a]          # 004abd5c
    jbe.d8 L_004abdb3                            # 004abd5f
    # block 0x004abd61: entered by fall-through of jbe at 0x004abd5f, 6 instruction(s), ends with jne to 0x004abdb3 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004abd61
    mov dword ptr [edx + field_2e], 0x0          # 004abd64
    mov eax, dword ptr [ebp - local_c]           # 004abd6b
    movsx ecx, word ptr [eax + field_28]         # 004abd6e
    cmp ecx, 0x27ce                              # 004abd72
    jne.d8 L_004abdb3                            # 004abd78
    # block 0x004abd7a: entered by fall-through of jne at 0x004abd78, 15 instruction(s), calls FUN_004ab85a, falls into the block at 0x004abdb3
    mov edx, dword ptr [ebp - local_c]           # 004abd7a
    mov dword ptr [edx + field_5e], 0x4          # 004abd7d
    mov eax, dword ptr [ebp - local_c]           # 004abd84
    mov byte ptr [eax + field_3b], 0x1           # 004abd87
    mov ecx, dword ptr [ebp - local_c]           # 004abd8b
    movsx edx, word ptr [ecx + field_32]         # 004abd8e
    mov eax, dword ptr [ebp - local_c]           # 004abd92
    mov cx, word ptr [eax + 2*edx + field_3c]    # 004abd95
    push ecx                                     # 004abd9a
    mov ecx, dword ptr [ebp - local_c]           # 004abd9b
    call FUN_004ab85a                            # 004abd9e
    mov edx, dword ptr [ebp - local_c]           # 004abda3
    mov word ptr [edx + field_36], ax            # 004abda6
    mov eax, dword ptr [ebp - local_c]           # 004abdaa
    mov word ptr [eax + field_38], 0x0           # 004abdad
L_004abdb3:
    # block 0x004abdb3: entered by jbe at 0x004abd5f; jne at 0x004abd78, 1 instruction(s), ends with forward jump to 0x004abdd5
    jmp.d8 L_004abdd5                            # 004abdb3
L_004abdb5:
    # block 0x004abdb5: entered by je at 0x004abd51, 5 instruction(s), ends with je to 0x004abdcd (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004abdb5
    {load} xor edx, edx                          # 004abdb8
    mov dl, byte ptr [ecx + field_59]            # 004abdba
    test edx, edx                                # 004abdbd
    je.d8 L_004abdcd                             # 004abdbf
    # block 0x004abdc1: entered by fall-through of je at 0x004abdbf, 3 instruction(s), ends with forward jump to 0x004abdd5
    mov eax, dword ptr [ebp - local_c]           # 004abdc1
    mov dword ptr [eax + field_5e], 0x1          # 004abdc4
    jmp.d8 L_004abdd5                            # 004abdcb
L_004abdcd:
    # block 0x004abdcd: entered by je at 0x004abdbf, 2 instruction(s), calls FUN_004ab9fa, falls into the block at 0x004abdd5
    mov ecx, dword ptr [ebp - local_c]           # 004abdcd
    call FUN_004ab9fa                            # 004abdd0
L_004abdd5:
    # block 0x004abdd5: entered by jmp at 0x004abdb3; jmp at 0x004abdcb, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d32 L_004ac0a4                           # 004abdd5
L_004abdda:
    # block 0x004abdda: entered by switch case, 7 instruction(s), ends with jge to 0x004abe1f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004abdda
    movsx edx, word ptr [ecx + field_34]         # 004abddd
    mov eax, dword ptr [ebp - local_4]           # 004abde1
    movsx ecx, word ptr [eax + field_21f]        # 004abde4
    sub ecx, 0x1                                 # 004abdeb
    {load} cmp edx, ecx                          # 004abdee
    jge.d8 L_004abe1f                            # 004abdf0
    # block 0x004abdf2: entered by fall-through of jge at 0x004abdf0, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004abe82
    mov edx, dword ptr [ebp - local_c]           # 004abdf2
    mov ax, word ptr [edx + field_34]            # 004abdf5
    .insn 0x66, 0x05, 0x0001{:u16}               # 004abdf9
    mov ecx, dword ptr [ebp - local_c]           # 004abdfd
    mov word ptr [ecx + field_34], ax            # 004abe00
    call dword ptr [0x52a23c]                    # 004abe04
    add eax, 0x64                                # 004abe0a
    mov edx, dword ptr [ebp - local_c]           # 004abe0d
    mov dword ptr [edx + field_5a], eax          # 004abe10
    mov eax, dword ptr [ebp - local_c]           # 004abe13
    mov dword ptr [eax + field_5e], 0x3          # 004abe16
    jmp.d8 L_004abe82                            # 004abe1d
L_004abe1f:
    # block 0x004abe1f: entered by jge at 0x004abdf0, 10 instruction(s), ends with jge to 0x004abe68 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004abe1f
    mov word ptr [ecx + field_34], 0x0           # 004abe22
    mov edx, dword ptr [ebp - local_c]           # 004abe28
    mov dword ptr [edx + field_5a], 0x0          # 004abe2b
    mov eax, dword ptr [ebp - local_c]           # 004abe32
    movsx ecx, word ptr [eax + field_32]         # 004abe35
    mov edx, dword ptr [ebp - local_c]           # 004abe39
    movsx eax, word ptr [edx + 2*ecx + field_3c] # 004abe3c
    cmp eax, 0x6                                 # 004abe41
    jge.d8 L_004abe68                            # 004abe44
    # block 0x004abe46: entered by fall-through of jge at 0x004abe44, 9 instruction(s), falls into the block at 0x004abe68
    mov ecx, dword ptr [ebp - local_c]           # 004abe46
    movsx edx, word ptr [ecx + field_32]         # 004abe49
    mov eax, dword ptr [ebp - local_c]           # 004abe4d
    mov cx, word ptr [eax + 2*edx + field_3c]    # 004abe50
    add cx, 0x1                                  # 004abe55
    mov edx, dword ptr [ebp - local_c]           # 004abe59
    movsx eax, word ptr [edx + field_32]         # 004abe5c
    mov edx, dword ptr [ebp - local_c]           # 004abe60
    mov word ptr [edx + 2*eax + field_3c], cx    # 004abe63
L_004abe68:
    # block 0x004abe68: entered by jge at 0x004abe44, 6 instruction(s), falls into the block at 0x004abe82
    mov eax, dword ptr [ebp - local_c]           # 004abe68
    mov dword ptr [eax + field_5e], 0x0          # 004abe6b
    mov ecx, dword ptr [ebp - local_c]           # 004abe72
    mov byte ptr [ecx + field_3a], 0x0           # 004abe75
    mov edx, dword ptr [ebp - local_c]           # 004abe79
    mov word ptr [edx + field_32], 0xffff        # 004abe7c
L_004abe82:
    # block 0x004abe82: entered by jmp at 0x004abe1d, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d32 L_004ac0a4                           # 004abe82
L_004abe87:
    # block 0x004abe87: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004abe9f (forward)
    call dword ptr [0x52a23c]                    # 004abe87
    mov ecx, dword ptr [ebp - local_c]           # 004abe8d
    cmp eax, dword ptr [ecx + field_5a]          # 004abe90
    jb.d8 L_004abe9f                             # 004abe93
    # block 0x004abe95: entered by fall-through of jb at 0x004abe93, 2 instruction(s), falls into the block at 0x004abe9f
    mov edx, dword ptr [ebp - local_c]           # 004abe95
    mov dword ptr [edx + field_5e], 0x2          # 004abe98
L_004abe9f:
    # block 0x004abe9f: entered by jb at 0x004abe93, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d32 L_004ac0a4                           # 004abe9f
L_004abea4:
    # block 0x004abea4: entered by switch case, 9 instruction(s), ends with jge to 0x004abfbb (forward)
    mov eax, dword ptr [ebp - local_c]           # 004abea4
    movsx ecx, word ptr [eax + field_38]         # 004abea7
    mov edx, dword ptr [ebp - local_c]           # 004abeab
    movsx eax, word ptr [edx + field_36]         # 004abeae
    mov edx, dword ptr [ebp - local_4]           # 004abeb2
    movsx edx, word ptr [edx + field_25]         # 004abeb5
    imul eax, edx                                # 004abeb9
    {load} cmp ecx, eax                          # 004abebc
    jge.d32 L_004abfbb                           # 004abebe
    # block 0x004abec4: entered by fall-through of jge at 0x004abebe, 12 instruction(s), ends with je to 0x004abf04 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004abec4
    mov cx, word ptr [eax + field_38]            # 004abec7
    add cx, 0x1                                  # 004abecb
    mov edx, dword ptr [ebp - local_c]           # 004abecf
    mov word ptr [edx + field_38], cx            # 004abed2
    mov edi, 0x551038                            # 004abed6
    mov esi, dword ptr [ebp - local_4]           # 004abedb
    add esi, 0xae8                               # 004abede
    mov ecx, 0x9                                 # 004abee4
    {load} xor eax, eax                          # 004abee9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004abeeb
    je.d8 L_004abf04                             # 004abeed
    # block 0x004abeef: entered by fall-through of je at 0x004abeed, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004abf04
    mov ecx, dword ptr [ebp - local_4]           # 004abeef
    mov dx, word ptr [ecx + field_b09]           # 004abef2
    push edx                                     # 004abef9
    mov ecx, 0x5c3a67                            # 004abefa
    call FUN_004fb2e3                            # 004abeff
L_004abf04:
    # block 0x004abf04: entered by je at 0x004abeed, 15 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004abf82 (forward)
    call dword ptr [0x52a23c]                    # 004abf04
    mov ecx, dword ptr [ebp - local_4]           # 004abf0a
    movsx edx, word ptr [ecx + field_aa9]        # 004abf0d
    imul edx, edx, 0xc8                          # 004abf14
    {load} add eax, edx                          # 004abf1a
    mov ecx, dword ptr [ebp - local_c]           # 004abf1c
    mov dword ptr [ecx + field_5a], eax          # 004abf1f
    mov edx, dword ptr [ebp - local_c]           # 004abf22
    mov dword ptr [edx + field_5e], 0x5          # 004abf25
    mov eax, dword ptr [ebp - local_c]           # 004abf2c
    movsx ecx, word ptr [eax + field_32]         # 004abf2f
    mov edx, dword ptr [ebp - local_c]           # 004abf33
    movsx eax, word ptr [edx + 2*ecx + field_48] # 004abf36
    test eax, eax                                # 004abf3b
    je.d8 L_004abf82                             # 004abf3d
    # block 0x004abf3f: entered by fall-through of je at 0x004abf3d, 9 instruction(s), ends with jne to 0x004abf82 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004abf3f
    movsx edx, word ptr [ecx + field_32]         # 004abf42
    mov eax, dword ptr [ebp - local_c]           # 004abf46
    movsx eax, word ptr [eax + 2*edx + field_48] # 004abf49
    cdq                                          # 004abf4e
    mov ecx, 0x6                                 # 004abf4f
    idiv ecx                                     # 004abf54
    test edx, edx                                # 004abf56
    jne.d8 L_004abf82                            # 004abf58
    # block 0x004abf5a: entered by fall-through of jne at 0x004abf58, 8 instruction(s), ends with jne to 0x004abf82 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004abf5a
    movsx eax, word ptr [edx + field_38]         # 004abf5d
    mov ecx, dword ptr [ebp - local_4]           # 004abf61
    movsx ecx, word ptr [ecx + field_25]         # 004abf64
    cdq                                          # 004abf68
    idiv ecx                                     # 004abf69
    test edx, edx                                # 004abf6b
    jne.d8 L_004abf82                            # 004abf6d
    # block 0x004abf6f: entered by fall-through of jne at 0x004abf6d, 5 instruction(s), ends with forward jump to 0x004abfb9
    mov edx, dword ptr [ebp - local_c]           # 004abf6f
    movsx eax, word ptr [edx + field_32]         # 004abf72
    mov ecx, dword ptr [ebp - local_c]           # 004abf76
    mov word ptr [ecx + 2*eax + field_48], 0x0   # 004abf79
    jmp.d8 L_004abfb9                            # 004abf80
L_004abf82:
    # block 0x004abf82: entered by je at 0x004abf3d; jne at 0x004abf58; jne at 0x004abf6d, 8 instruction(s), ends with jne to 0x004abfb9 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004abf82
    movsx eax, word ptr [edx + field_38]         # 004abf85
    mov ecx, dword ptr [ebp - local_4]           # 004abf89
    movsx ecx, word ptr [ecx + field_25]         # 004abf8c
    cdq                                          # 004abf90
    idiv ecx                                     # 004abf91
    test edx, edx                                # 004abf93
    jne.d8 L_004abfb9                            # 004abf95
    # block 0x004abf97: entered by fall-through of jne at 0x004abf95, 9 instruction(s), falls into the block at 0x004abfb9
    mov edx, dword ptr [ebp - local_c]           # 004abf97
    movsx eax, word ptr [edx + field_32]         # 004abf9a
    mov ecx, dword ptr [ebp - local_c]           # 004abf9e
    mov dx, word ptr [ecx + 2*eax + field_48]    # 004abfa1
    add dx, 0x1                                  # 004abfa6
    mov eax, dword ptr [ebp - local_c]           # 004abfaa
    movsx ecx, word ptr [eax + field_32]         # 004abfad
    mov eax, dword ptr [ebp - local_c]           # 004abfb1
    mov word ptr [eax + 2*ecx + field_48], dx    # 004abfb4
L_004abfb9:
    # block 0x004abfb9: entered by jmp at 0x004abf80; jne at 0x004abf95, 1 instruction(s), ends with forward jump to 0x004abfe6
    jmp.d8 L_004abfe6                            # 004abfb9
L_004abfbb:
    # block 0x004abfbb: entered by jge at 0x004abebe, 9 instruction(s), falls into the block at 0x004abfe6
    mov ecx, dword ptr [ebp - local_c]           # 004abfbb
    mov dword ptr [ecx + field_5e], 0x0          # 004abfbe
    mov edx, dword ptr [ebp - local_c]           # 004abfc5
    movsx eax, word ptr [edx + field_32]         # 004abfc8
    mov ecx, dword ptr [ebp - local_c]           # 004abfcc
    mov word ptr [ecx + 2*eax + field_3c], 0x0   # 004abfcf
    mov byte ptr [0x61d6fc], 0x0                 # 004abfd6
    mov edx, dword ptr [ebp - local_c]           # 004abfdd
    mov word ptr [edx + field_32], 0xffff        # 004abfe0
L_004abfe6:
    # block 0x004abfe6: entered by jmp at 0x004abfb9, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d32 L_004ac0a4                           # 004abfe6
L_004abfeb:
    # block 0x004abfeb: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004ac003 (forward)
    call dword ptr [0x52a23c]                    # 004abfeb
    mov ecx, dword ptr [ebp - local_c]           # 004abff1
    cmp eax, dword ptr [ecx + field_5a]          # 004abff4
    jb.d8 L_004ac003                             # 004abff7
    # block 0x004abff9: entered by fall-through of jb at 0x004abff7, 2 instruction(s), falls into the block at 0x004ac003
    mov edx, dword ptr [ebp - local_c]           # 004abff9
    mov dword ptr [edx + field_5e], 0x4          # 004abffc
L_004ac003:
    # block 0x004ac003: entered by jb at 0x004abff7, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d32 L_004ac0a4                           # 004ac003
L_004ac008:
    # block 0x004ac008: entered by switch case, 7 instruction(s), ends with je to 0x004ac042 (forward)
    mov edi, 0x551044                            # 004ac008
    mov esi, dword ptr [ebp - local_4]           # 004ac00d
    add esi, 0xb65                               # 004ac010
    mov ecx, 0x9                                 # 004ac016
    {load} xor eax, eax                          # 004ac01b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ac01d
    je.d8 L_004ac042                             # 004ac01f
    # block 0x004ac021: entered by fall-through of je at 0x004ac01f, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004ac059
    mov ecx, dword ptr [ebp - local_4]           # 004ac021
    mov dx, word ptr [ecx + field_b86]           # 004ac024
    push edx                                     # 004ac02b
    mov ecx, 0x5c3a67                            # 004ac02c
    call FUN_004fb2e3                            # 004ac031
    mov eax, dword ptr [ebp - local_c]           # 004ac036
    mov dword ptr [eax + field_5e], 0x6          # 004ac039
    jmp.d8 L_004ac059                            # 004ac040
L_004ac042:
    # block 0x004ac042: entered by je at 0x004ac01f, 4 instruction(s), falls into the block at 0x004ac059
    mov ecx, dword ptr [ebp - local_c]           # 004ac042
    movsx edx, word ptr [ecx + field_1e]         # 004ac045
    imul edx, edx, 0x8d                          # 004ac049
    mov dword ptr [edx + 0x5bb632], 0x2          # 004ac04f
L_004ac059:
    # block 0x004ac059: entered by jmp at 0x004ac040, 1 instruction(s), ends with forward jump to 0x004ac0a4
    jmp.d8 L_004ac0a4                            # 004ac059
L_004ac05b:
    # block 0x004ac05b: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004ac0a4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ac05b
    movsx ecx, word ptr [eax + field_b86]        # 004ac05e
    mov dword ptr [ebp - local_8], ecx           # 004ac065
    mov edx, dword ptr [ebp - local_8]           # 004ac068
    push edx                                     # 004ac06b
    mov ecx, 0x5cf1eb                            # 004ac06c
    call FUN_004f6334                            # 004ac071
    test eax, eax                                # 004ac076
    jne.d8 L_004ac0a4                            # 004ac078
    # block 0x004ac07a: entered by fall-through of jne at 0x004ac078, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004ac0a4
    mov eax, dword ptr [ebp - local_4]           # 004ac07a
    add eax, 0xb65                               # 004ac07d
    push eax                                     # 004ac082
    mov ecx, 0x5c3a67                            # 004ac083
    call FUN_004fba69                            # 004ac088
    mov ecx, dword ptr [ebp - local_c]           # 004ac08d
    movsx edx, word ptr [ecx + field_1e]         # 004ac090
    imul edx, edx, 0x8d                          # 004ac094
    mov dword ptr [edx + 0x5bb632], 0x2          # 004ac09a
L_004ac0a4:
    # block 0x004ac0a4: entered by ja at 0x004abd3a; jmp at 0x004abdd5; jmp at 0x004abe82; jmp at 0x004abe9f; more, 1 instruction(s), ends with forward jump to 0x004ac35b
    jmp.d32 L_004ac35b                           # 004ac0a4
L_004ac0a9:
    # block 0x004ac0a9: entered by je at 0x004abab2, 8 instruction(s), ends with je to 0x004ac0e0 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004ac0a9
    mov edi, 0x551050                            # 004ac0b3
    mov esi, dword ptr [ebp - local_4]           # 004ac0b8
    add esi, 0xab7                               # 004ac0bb
    mov ecx, 0x9                                 # 004ac0c1
    {load} xor eax, eax                          # 004ac0c6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ac0c8
    je.d8 L_004ac0e0                             # 004ac0ca
    # block 0x004ac0cc: entered by fall-through of je at 0x004ac0ca, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004ac0e0
    mov ecx, dword ptr [ebp - local_4]           # 004ac0cc
    add ecx, 0xab7                               # 004ac0cf
    push ecx                                     # 004ac0d5
    mov ecx, 0x5c3a67                            # 004ac0d6
    call FUN_004fba69                            # 004ac0db
L_004ac0e0:
    # block 0x004ac0e0: entered by je at 0x004ac0ca, 7 instruction(s), ends with je to 0x004ac10c (forward)
    mov edi, 0x55105c                            # 004ac0e0
    mov esi, dword ptr [ebp - local_4]           # 004ac0e5
    add esi, 0xae8                               # 004ac0e8
    mov ecx, 0x9                                 # 004ac0ee
    {load} xor edx, edx                          # 004ac0f3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ac0f5
    je.d8 L_004ac10c                             # 004ac0f7
    # block 0x004ac0f9: entered by fall-through of je at 0x004ac0f7, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004ac10c
    mov eax, dword ptr [ebp - local_4]           # 004ac0f9
    add eax, 0xae8                               # 004ac0fc
    push eax                                     # 004ac101
    mov ecx, 0x5c3a67                            # 004ac102
    call FUN_004fba69                            # 004ac107
L_004ac10c:
    # block 0x004ac10c: entered by je at 0x004ac0f7, 7 instruction(s), ends with je to 0x004ac138 (forward)
    mov edi, 0x551068                            # 004ac10c
    mov esi, dword ptr [ebp - local_4]           # 004ac111
    add esi, 0xb19                               # 004ac114
    mov ecx, 0x9                                 # 004ac11a
    {load} xor edx, edx                          # 004ac11f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ac121
    je.d8 L_004ac138                             # 004ac123
    # block 0x004ac125: entered by fall-through of je at 0x004ac123, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004ac138
    mov eax, dword ptr [ebp - local_4]           # 004ac125
    add eax, 0xb19                               # 004ac128
    push eax                                     # 004ac12d
    mov ecx, 0x5c3a67                            # 004ac12e
    call FUN_004fba69                            # 004ac133
L_004ac138:
    # block 0x004ac138: entered by je at 0x004ac123, 7 instruction(s), ends with je to 0x004ac164 (forward)
    mov edi, 0x551074                            # 004ac138
    mov esi, dword ptr [ebp - local_4]           # 004ac13d
    add esi, 0xb65                               # 004ac140
    mov ecx, 0x9                                 # 004ac146
    {load} xor edx, edx                          # 004ac14b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ac14d
    je.d8 L_004ac164                             # 004ac14f
    # block 0x004ac151: entered by fall-through of je at 0x004ac14f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004ac164
    mov eax, dword ptr [ebp - local_4]           # 004ac151
    add eax, 0xb65                               # 004ac154
    push eax                                     # 004ac159
    mov ecx, 0x5c3a67                            # 004ac15a
    call FUN_004fba69                            # 004ac15f
L_004ac164:
    # block 0x004ac164: entered by je at 0x004ac14f, 5 instruction(s), ends with je to 0x004ac256 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004ac164
    {load} xor edx, edx                          # 004ac167
    mov dl, byte ptr [ecx + field_58]            # 004ac169
    test edx, edx                                # 004ac16c
    je.d32 L_004ac256                            # 004ac16e
    # block 0x004ac174: entered by fall-through of je at 0x004ac16e, 4 instruction(s), ends with je to 0x004ac226 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ac174
    movsx ecx, word ptr [eax + field_b96]        # 004ac177
    cmp ecx, 0x270f                              # 004ac17e
    je.d32 L_004ac226                            # 004ac184
    # block 0x004ac18a: entered by fall-through of je at 0x004ac184, 25 instruction(s), ends with jne to 0x004ac212 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ac18a
    movsx eax, word ptr [edx + field_b96]        # 004ac18d
    mov dword ptr [0x5bb57b], eax                # 004ac194
    mov ecx, dword ptr [ebp - local_4]           # 004ac199
    mov dx, word ptr [ecx + field_b98]           # 004ac19c
    mov word ptr [0x5bb599], dx                  # 004ac1a3
    mov eax, dword ptr [ebp - local_4]           # 004ac1aa
    mov cx, word ptr [eax + field_b9a]           # 004ac1ad
    mov word ptr [0x5bb595], cx                  # 004ac1b4
    mov edx, dword ptr [ebp - local_4]           # 004ac1bb
    mov ax, word ptr [edx + field_b9c]           # 004ac1be
    mov word ptr [0x5c39ff], ax                  # 004ac1c5
    mov ecx, dword ptr [ebp - local_4]           # 004ac1cb
    mov edx, dword ptr [ecx + field_b9e]         # 004ac1ce
    mov dword ptr [0x5bb59b], edx                # 004ac1d4
    mov eax, dword ptr [ebp - local_4]           # 004ac1da
    mov ecx, dword ptr [eax + field_ba2]         # 004ac1dd
    mov dword ptr [0x5bb59f], ecx                # 004ac1e3
    mov edx, dword ptr [ebp - local_4]           # 004ac1e9
    mov eax, dword ptr [edx + field_ba6]         # 004ac1ec
    mov dword ptr [0x5bb5a3], eax                # 004ac1f2
    mov ecx, dword ptr [ebp - local_4]           # 004ac1f7
    movsx edx, word ptr [ecx + field_baa]        # 004ac1fa
    cmp edx, 0x1                                 # 004ac201
    jne.d8 L_004ac212                            # 004ac204
    # block 0x004ac206: entered by fall-through of jne at 0x004ac204, 2 instruction(s), ends with forward jump to 0x004ac21c
    mov dword ptr [0x5bb1ca], 0x0                # 004ac206
    jmp.d8 L_004ac21c                            # 004ac210
L_004ac212:
    # block 0x004ac212: entered by jne at 0x004ac204, 1 instruction(s), falls into the block at 0x004ac21c
    mov dword ptr [0x5bb1ca], 0x1                # 004ac212
L_004ac21c:
    # block 0x004ac21c: entered by jmp at 0x004ac210, 1 instruction(s), falls into the block at 0x004ac226
    mov dword ptr [0x583999], 0x4                # 004ac21c
L_004ac226:
    # block 0x004ac226: entered by je at 0x004ac184, 4 instruction(s), ends with je to 0x004ac251 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ac226
    movsx ecx, word ptr [eax + field_bac]        # 004ac229
    cmp ecx, -0x1                                # 004ac230
    je.d8 L_004ac251                             # 004ac233
    # block 0x004ac235: entered by fall-through of je at 0x004ac233, 6 instruction(s), falls into the block at 0x004ac251
    mov edx, dword ptr [ebp - local_4]           # 004ac235
    {load} xor eax, eax                          # 004ac238
    mov al, byte ptr [edx + field_bae]           # 004ac23a
    mov ecx, dword ptr [ebp - local_4]           # 004ac240
    movsx edx, word ptr [ecx + field_bac]        # 004ac243
    mov dword ptr [4*edx + 0x585801], eax        # 004ac24a
L_004ac251:
    # block 0x004ac251: entered by je at 0x004ac233, 1 instruction(s), ends with forward jump to 0x004ac343
    jmp.d32 L_004ac343                           # 004ac251
L_004ac256:
    # block 0x004ac256: entered by je at 0x004ac16e, 5 instruction(s), ends with je to 0x004ac343 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004ac256
    {load} xor ecx, ecx                          # 004ac259
    mov cl, byte ptr [eax + field_59]            # 004ac25b
    test ecx, ecx                                # 004ac25e
    je.d32 L_004ac343                            # 004ac260
    # block 0x004ac266: entered by fall-through of je at 0x004ac260, 4 instruction(s), ends with je to 0x004ac318 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ac266
    movsx eax, word ptr [edx + field_b4a]        # 004ac269
    cmp eax, 0x270f                              # 004ac270
    je.d32 L_004ac318                            # 004ac275
    # block 0x004ac27b: entered by fall-through of je at 0x004ac275, 25 instruction(s), ends with jne to 0x004ac304 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ac27b
    movsx edx, word ptr [ecx + field_b4a]        # 004ac27e
    mov dword ptr [0x5bb57b], edx                # 004ac285
    mov eax, dword ptr [ebp - local_4]           # 004ac28b
    mov cx, word ptr [eax + field_b4c]           # 004ac28e
    mov word ptr [0x5bb599], cx                  # 004ac295
    mov edx, dword ptr [ebp - local_4]           # 004ac29c
    mov ax, word ptr [edx + field_b4e]           # 004ac29f
    mov word ptr [0x5bb595], ax                  # 004ac2a6
    mov ecx, dword ptr [ebp - local_4]           # 004ac2ac
    mov dx, word ptr [ecx + field_b50]           # 004ac2af
    mov word ptr [0x5c39ff], dx                  # 004ac2b6
    mov eax, dword ptr [ebp - local_4]           # 004ac2bd
    mov ecx, dword ptr [eax + field_b52]         # 004ac2c0
    mov dword ptr [0x5bb59b], ecx                # 004ac2c6
    mov edx, dword ptr [ebp - local_4]           # 004ac2cc
    mov eax, dword ptr [edx + field_b56]         # 004ac2cf
    mov dword ptr [0x5bb59f], eax                # 004ac2d5
    mov ecx, dword ptr [ebp - local_4]           # 004ac2da
    mov edx, dword ptr [ecx + field_b5a]         # 004ac2dd
    mov dword ptr [0x5bb5a3], edx                # 004ac2e3
    mov eax, dword ptr [ebp - local_4]           # 004ac2e9
    movsx ecx, word ptr [eax + field_b5e]        # 004ac2ec
    cmp ecx, 0x1                                 # 004ac2f3
    jne.d8 L_004ac304                            # 004ac2f6
    # block 0x004ac2f8: entered by fall-through of jne at 0x004ac2f6, 2 instruction(s), ends with forward jump to 0x004ac30e
    mov dword ptr [0x5bb1ca], 0x0                # 004ac2f8
    jmp.d8 L_004ac30e                            # 004ac302
L_004ac304:
    # block 0x004ac304: entered by jne at 0x004ac2f6, 1 instruction(s), falls into the block at 0x004ac30e
    mov dword ptr [0x5bb1ca], 0x1                # 004ac304
L_004ac30e:
    # block 0x004ac30e: entered by jmp at 0x004ac302, 1 instruction(s), falls into the block at 0x004ac318
    mov dword ptr [0x583999], 0x4                # 004ac30e
L_004ac318:
    # block 0x004ac318: entered by je at 0x004ac275, 4 instruction(s), ends with je to 0x004ac343 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ac318
    movsx eax, word ptr [edx + field_b60]        # 004ac31b
    cmp eax, -0x1                                # 004ac322
    je.d8 L_004ac343                             # 004ac325
    # block 0x004ac327: entered by fall-through of je at 0x004ac325, 6 instruction(s), falls into the block at 0x004ac343
    mov ecx, dword ptr [ebp - local_4]           # 004ac327
    {load} xor edx, edx                          # 004ac32a
    mov dl, byte ptr [ecx + field_b62]           # 004ac32c
    mov eax, dword ptr [ebp - local_4]           # 004ac332
    movsx ecx, word ptr [eax + field_b60]        # 004ac335
    mov dword ptr [4*ecx + 0x585801], edx        # 004ac33c
L_004ac343:
    # block 0x004ac343: entered by jmp at 0x004ac251; je at 0x004ac260; je at 0x004ac325, 7 instruction(s), calls FUN_0042ba3a, FUN_004ab3dc, falls into the block at 0x004ac35b
    mov edx, dword ptr [ebp - local_c]           # 004ac343
    mov ax, word ptr [edx + field_1e]            # 004ac346
    push eax                                     # 004ac34a
    call FUN_0042ba3a                            # 004ac34b
    add esp, 0x4                                 # 004ac350
    mov ecx, dword ptr [ebp - local_c]           # 004ac353
    call FUN_004ab3dc                            # 004ac356
L_004ac35b:
    # block 0x004ac35b: entered by jmp at 0x004abab8; jmp at 0x004abd28; jmp at 0x004ac0a4, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004ac35b
    pop esi                                      # 004ac35c
    {load} mov esp, ebp                          # 004ac35d
    pop ebp                                      # 004ac35f
    ret 0x4                                      # 004ac360

# --- data items (not part of the function) -------------------------
.org 0x004ac363 - 0x401000
SWTAB_004ac363:  # 7 case address(es)
    .long L_004abd4a - .text + 0x401000
    .long L_004ac008 - .text + 0x401000
    .long L_004abdda - .text + 0x401000
    .long L_004abe87 - .text + 0x401000
    .long L_004abea4 - .text + 0x401000
    .long L_004abfeb - .text + 0x401000
    .long L_004ac05b - .text + 0x401000
.set SWTAB_004ac363_VA, SWTAB_004ac363 - .text + 0x401000

