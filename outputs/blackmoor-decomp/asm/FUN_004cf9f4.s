# FUN_004cf9f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf9f4
# extent:       0x004cf9f4-0x004d00c2 (1742 code bytes)
# span:         0x004cf9f4-0x004d00d2 (code 1742, tables 16, padding 0)
# sha256:       6fcb7a40f64f86eff07574b45064e0735a72bc4817166662d426a7730b4948f8
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf9f4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       9 ebp-relative slot(s): local_40, local_44, local_48, local_4c, local_50, local_54, local_58, local_5c, local_60
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004c5377, FUN_004c5d4b, FUN_0052139c, FUN_004c97b4, FUN_004e11ed, FUN_004e6658, FUN_004de584, FUN_004e7a10, FUN_004e97ad, FUN_004ed71e, FUN_00447c36, FUN_004c4c2b; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 485 instruction(s), 42 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60

# --- external targets -----------------------------------------------
.set FUN_00447c36, .text + (0x00447c36 - 0x401000)
.set FUN_004c4c2b, .text + (0x004c4c2b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004de584, .text + (0x004de584 - 0x401000)
.set FUN_004e11ed, .text + (0x004e11ed - 0x401000)
.set FUN_004e6658, .text + (0x004e6658 - 0x401000)
.set FUN_004e7a10, .text + (0x004e7a10 - 0x401000)
.set FUN_004e97ad, .text + (0x004e97ad - 0x401000)
.set FUN_004ed71e, .text + (0x004ed71e - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004cf9f4 - 0x401000
.globl FUN_004cf9f4
FUN_004cf9f4:
    # block 0x004cf9f4: entry, 12 instruction(s), ends with jl to 0x004cfa1f (forward)
    push ebp                                     # 004cf9f4
    {load} mov ebp, esp                          # 004cf9f5
    sub esp, 0x60                                # 004cf9f7
    push edi                                     # 004cf9fa
    mov ecx, 0x10                                # 004cf9fb
    {load} xor eax, eax                          # 004cfa00
    lea edi, [ebp - local_40]                    # 004cfa02
    rep stosd dword ptr es:[edi], eax            # 004cfa05
    mov eax, dword ptr [0x583204]                # 004cfa07
    mov dword ptr [ebp - local_4c], eax          # 004cfa0c
    cmp dword ptr [ebp - local_4c], 0x2          # 004cfa0f
    jl.d8 L_004cfa1f                             # 004cfa13
    # block 0x004cfa15: entered by fall-through of jl at 0x004cfa13, 2 instruction(s), ends with jle to 0x004cfd4e (forward)
    cmp dword ptr [ebp - local_4c], 0x5          # 004cfa15
    jle.d32 L_004cfd4e                           # 004cfa19
L_004cfa1f:
    # block 0x004cfa1f: entered by jl at 0x004cfa13; fall-through of jle at 0x004cfa19, 3 instruction(s), ends with forward jump to 0x004cfa34
    movsx ecx, word ptr [0x5bb1c4]               # 004cfa1f
    mov dword ptr [ebp - local_44], ecx          # 004cfa26
    jmp.d8 L_004cfa34                            # 004cfa29
L_004cfa2b:
    # block 0x004cfa2b: entered by jmp at 0x004cfb97, 3 instruction(s), falls into the block at 0x004cfa34
    mov edx, dword ptr [ebp - local_44]          # 004cfa2b
    add edx, 0x1                                 # 004cfa2e
    mov dword ptr [ebp - local_44], edx          # 004cfa31
L_004cfa34:
    # block 0x004cfa34: entered by jmp at 0x004cfa29, 2 instruction(s), ends with jg to 0x004cfb9c (forward)
    cmp dword ptr [ebp - local_44], 0xf          # 004cfa34
    jg.d32 L_004cfb9c                            # 004cfa38
    # block 0x004cfa3e: entered by fall-through of jg at 0x004cfa38, 2 instruction(s), ends with forward jump to 0x004cfa50
    mov dword ptr [ebp - local_48], 0x0          # 004cfa3e
    jmp.d8 L_004cfa50                            # 004cfa45
L_004cfa47:
    # block 0x004cfa47: entered by jmp at 0x004cfa96; jmp at 0x004cfb92, 3 instruction(s), falls into the block at 0x004cfa50
    mov eax, dword ptr [ebp - local_48]          # 004cfa47
    add eax, 0x1                                 # 004cfa4a
    mov dword ptr [ebp - local_48], eax          # 004cfa4d
L_004cfa50:
    # block 0x004cfa50: entered by jmp at 0x004cfa45, 2 instruction(s), ends with jg to 0x004cfb97 (forward)
    cmp dword ptr [ebp - local_48], 0x3f         # 004cfa50
    jg.d32 L_004cfb97                            # 004cfa54
    # block 0x004cfa5a: entered by fall-through of jg at 0x004cfa54, 5 instruction(s), ends with jne to 0x004cfa96 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfa5a
    {load} xor edx, edx                          # 004cfa5d
    mov dl, byte ptr [ebp + ecx - local_40]      # 004cfa5f
    test edx, edx                                # 004cfa63
    jne.d8 L_004cfa96                            # 004cfa65
    # block 0x004cfa67: entered by fall-through of jne at 0x004cfa65, 4 instruction(s), ends with je to 0x004cfa96 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cfa67
    imul eax, eax, 0x4a                          # 004cfa6a
    cmp dword ptr [eax + 0x5d15a5], 0x0          # 004cfa6d
    je.d8 L_004cfa96                             # 004cfa74
    # block 0x004cfa76: entered by fall-through of je at 0x004cfa74, 4 instruction(s), ends with je to 0x004cfa96 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfa76
    imul ecx, ecx, 0x4a                          # 004cfa79
    cmp dword ptr [ecx + 0x5d15a9], 0x0          # 004cfa7c
    je.d8 L_004cfa96                             # 004cfa83
    # block 0x004cfa85: entered by fall-through of je at 0x004cfa83, 5 instruction(s), ends with je to 0x004cfa98 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004cfa85
    imul edx, edx, 0x4a                          # 004cfa88
    mov eax, dword ptr [edx + 0x5d1591]          # 004cfa8b
    cmp eax, dword ptr [ebp - local_44]          # 004cfa91
    je.d8 L_004cfa98                             # 004cfa94
L_004cfa96:
    # block 0x004cfa96: entered by jne at 0x004cfa65; je at 0x004cfa74; je at 0x004cfa83; fall-through of je at 0x004cfa94, 1 instruction(s), ends with backward jump to 0x004cfa47
    jmp.d8 L_004cfa47                            # 004cfa96
L_004cfa98:
    # block 0x004cfa98: entered by je at 0x004cfa94, 4 instruction(s), ends with je to 0x004cfabf (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfa98
    imul ecx, ecx, 0x4a                          # 004cfa9b
    cmp dword ptr [ecx + 0x5d1595], 0x0          # 004cfa9e
    je.d8 L_004cfabf                             # 004cfaa5
    # block 0x004cfaa7: entered by fall-through of je at 0x004cfaa5, 7 instruction(s), calls indirect dword ptr [eax + 0x5d1595], ends with forward jump to 0x004cfb8a
    mov edx, dword ptr [ebp - local_48]          # 004cfaa7
    push edx                                     # 004cfaaa
    mov eax, dword ptr [ebp - local_48]          # 004cfaab
    imul eax, eax, 0x4a                          # 004cfaae
    call dword ptr [eax + 0x5d1595]              # 004cfab1
    add esp, 0x4                                 # 004cfab7
    jmp.d32 L_004cfb8a                           # 004cfaba
L_004cfabf:
    # block 0x004cfabf: entered by je at 0x004cfaa5, 13 instruction(s), calls FUN_0050ca3e, ends with je to 0x004cfaf5 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfabf
    push ecx                                     # 004cfac2
    push 0x559e10                                # 004cfac3
    push 0x63888b                                # 004cfac8
    call FUN_0050ca3e                            # 004cfacd
    add esp, 0xc                                 # 004cfad2
    mov edx, dword ptr [ebp - local_48]          # 004cfad5
    imul edx, edx, 0x4a                          # 004cfad8
    {load} xor eax, eax                          # 004cfadb
    mov ax, word ptr [edx + 0x5d15ad]            # 004cfadd
    mov dword ptr [ebp - local_50], eax          # 004cfae4
    cmp dword ptr [ebp - local_50], 0x1          # 004cfae7
    je.d8 L_004cfaf5                             # 004cfaeb
    # block 0x004cfaed: entered by fall-through of je at 0x004cfaeb, 2 instruction(s), ends with je to 0x004cfb34 (forward)
    cmp dword ptr [ebp - local_50], 0x2          # 004cfaed
    je.d8 L_004cfb34                             # 004cfaf1
    # block 0x004cfaf3: entered by fall-through of je at 0x004cfaf1, 1 instruction(s), ends with forward jump to 0x004cfb72
    jmp.d8 L_004cfb72                            # 004cfaf3
L_004cfaf5:
    # block 0x004cfaf5: entered by je at 0x004cfaeb, 18 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004cfb8a
    push 0x63888b                                # 004cfaf5
    mov ecx, dword ptr [ebp - local_48]          # 004cfafa
    imul ecx, ecx, 0x4a                          # 004cfafd
    mov edx, dword ptr [ecx + 0x5d15a1]          # 004cfb00
    push edx                                     # 004cfb06
    mov eax, dword ptr [ebp - local_48]          # 004cfb07
    imul eax, eax, 0x4a                          # 004cfb0a
    mov ecx, dword ptr [eax + 0x5d159d]          # 004cfb0d
    push ecx                                     # 004cfb13
    mov edx, dword ptr [0x5cf665]                # 004cfb14
    push edx                                     # 004cfb1a
    mov eax, dword ptr [ebp - local_48]          # 004cfb1b
    imul eax, eax, 0x4a                          # 004cfb1e
    mov ecx, dword ptr [eax + 0x5d1599]          # 004cfb21
    push ecx                                     # 004cfb27
    mov ecx, 0x5cf659                            # 004cfb28
    call FUN_004c5377                            # 004cfb2d
    jmp.d8 L_004cfb8a                            # 004cfb32
L_004cfb34:
    # block 0x004cfb34: entered by je at 0x004cfaf1, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004cfb8a
    push 0x63888b                                # 004cfb34
    mov edx, dword ptr [ebp - local_48]          # 004cfb39
    imul edx, edx, 0x4a                          # 004cfb3c
    mov eax, dword ptr [edx + 0x5d15a1]          # 004cfb3f
    push eax                                     # 004cfb45
    mov ecx, dword ptr [ebp - local_48]          # 004cfb46
    imul ecx, ecx, 0x4a                          # 004cfb49
    mov edx, dword ptr [ecx + 0x5d159d]          # 004cfb4c
    push edx                                     # 004cfb52
    mov eax, dword ptr [0x5cf665]                # 004cfb53
    push eax                                     # 004cfb58
    mov ecx, dword ptr [ebp - local_48]          # 004cfb59
    imul ecx, ecx, 0x4a                          # 004cfb5c
    mov edx, dword ptr [ecx + 0x5d1599]          # 004cfb5f
    push edx                                     # 004cfb65
    mov ecx, 0x5cf659                            # 004cfb66
    call FUN_004c5d4b                            # 004cfb6b
    jmp.d8 L_004cfb8a                            # 004cfb70
L_004cfb72:
    # block 0x004cfb72: entered by jmp at 0x004cfaf3, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004cfb8a
    push 0x0                                     # 004cfb72
    push 0x0                                     # 004cfb74
    push 0x559e34                                # 004cfb76
    call FUN_0052139c                            # 004cfb7b
    mov ecx, 0x5cf659                            # 004cfb80
    call FUN_004c97b4                            # 004cfb85
L_004cfb8a:
    # block 0x004cfb8a: entered by jmp at 0x004cfaba; jmp at 0x004cfb32; jmp at 0x004cfb70, 3 instruction(s), ends with backward jump to 0x004cfa47
    mov eax, dword ptr [ebp - local_48]          # 004cfb8a
    mov byte ptr [ebp + eax - local_40], 0x1     # 004cfb8d
    jmp.d32 L_004cfa47                           # 004cfb92
L_004cfb97:
    # block 0x004cfb97: entered by jg at 0x004cfa54, 1 instruction(s), ends with backward jump to 0x004cfa2b
    jmp.d32 L_004cfa2b                           # 004cfb97
L_004cfb9c:
    # block 0x004cfb9c: entered by jg at 0x004cfa38, 4 instruction(s), calls FUN_004e11ed, ends with je to 0x004cfbb9 (forward)
    mov ecx, 0x570508                            # 004cfb9c
    call FUN_004e11ed                            # 004cfba1
    cmp dword ptr [0x5bb22a], 0x0                # 004cfba6
    je.d8 L_004cfbb9                             # 004cfbad
    # block 0x004cfbaf: entered by fall-through of je at 0x004cfbad, 2 instruction(s), calls FUN_004e6658, falls into the block at 0x004cfbb9
    mov ecx, 0x57975c                            # 004cfbaf
    call FUN_004e6658                            # 004cfbb4
L_004cfbb9:
    # block 0x004cfbb9: entered by je at 0x004cfbad, 4 instruction(s), ends with je to 0x004cfbcf (forward)
    {load} xor ecx, ecx                          # 004cfbb9
    mov cl, byte ptr [0x5a161f]                  # 004cfbbb
    test ecx, ecx                                # 004cfbc1
    je.d8 L_004cfbcf                             # 004cfbc3
    # block 0x004cfbc5: entered by fall-through of je at 0x004cfbc3, 2 instruction(s), calls FUN_004de584, falls into the block at 0x004cfbcf
    mov ecx, 0x61f864                            # 004cfbc5
    call FUN_004de584                            # 004cfbca
L_004cfbcf:
    # block 0x004cfbcf: entered by je at 0x004cfbc3, 2 instruction(s), ends with forward jump to 0x004cfbe1
    mov dword ptr [ebp - local_44], 0x10         # 004cfbcf
    jmp.d8 L_004cfbe1                            # 004cfbd6
L_004cfbd8:
    # block 0x004cfbd8: entered by jmp at 0x004cfd44, 3 instruction(s), falls into the block at 0x004cfbe1
    mov edx, dword ptr [ebp - local_44]          # 004cfbd8
    add edx, 0x1                                 # 004cfbdb
    mov dword ptr [ebp - local_44], edx          # 004cfbde
L_004cfbe1:
    # block 0x004cfbe1: entered by jmp at 0x004cfbd6, 2 instruction(s), ends with jge to 0x004cfd49 (forward)
    cmp dword ptr [ebp - local_44], 0x15         # 004cfbe1
    jge.d32 L_004cfd49                           # 004cfbe5
    # block 0x004cfbeb: entered by fall-through of jge at 0x004cfbe5, 2 instruction(s), ends with forward jump to 0x004cfbfd
    mov dword ptr [ebp - local_48], 0x0          # 004cfbeb
    jmp.d8 L_004cfbfd                            # 004cfbf2
L_004cfbf4:
    # block 0x004cfbf4: entered by jmp at 0x004cfc43; jmp at 0x004cfd3f, 3 instruction(s), falls into the block at 0x004cfbfd
    mov eax, dword ptr [ebp - local_48]          # 004cfbf4
    add eax, 0x1                                 # 004cfbf7
    mov dword ptr [ebp - local_48], eax          # 004cfbfa
L_004cfbfd:
    # block 0x004cfbfd: entered by jmp at 0x004cfbf2, 2 instruction(s), ends with jg to 0x004cfd44 (forward)
    cmp dword ptr [ebp - local_48], 0x3f         # 004cfbfd
    jg.d32 L_004cfd44                            # 004cfc01
    # block 0x004cfc07: entered by fall-through of jg at 0x004cfc01, 5 instruction(s), ends with jne to 0x004cfc43 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfc07
    {load} xor edx, edx                          # 004cfc0a
    mov dl, byte ptr [ebp + ecx - local_40]      # 004cfc0c
    test edx, edx                                # 004cfc10
    jne.d8 L_004cfc43                            # 004cfc12
    # block 0x004cfc14: entered by fall-through of jne at 0x004cfc12, 4 instruction(s), ends with je to 0x004cfc43 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cfc14
    imul eax, eax, 0x4a                          # 004cfc17
    cmp dword ptr [eax + 0x5d15a5], 0x0          # 004cfc1a
    je.d8 L_004cfc43                             # 004cfc21
    # block 0x004cfc23: entered by fall-through of je at 0x004cfc21, 4 instruction(s), ends with je to 0x004cfc43 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfc23
    imul ecx, ecx, 0x4a                          # 004cfc26
    cmp dword ptr [ecx + 0x5d15a9], 0x0          # 004cfc29
    je.d8 L_004cfc43                             # 004cfc30
    # block 0x004cfc32: entered by fall-through of je at 0x004cfc30, 5 instruction(s), ends with je to 0x004cfc45 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004cfc32
    imul edx, edx, 0x4a                          # 004cfc35
    mov eax, dword ptr [edx + 0x5d1591]          # 004cfc38
    cmp eax, dword ptr [ebp - local_44]          # 004cfc3e
    je.d8 L_004cfc45                             # 004cfc41
L_004cfc43:
    # block 0x004cfc43: entered by jne at 0x004cfc12; je at 0x004cfc21; je at 0x004cfc30; fall-through of je at 0x004cfc41, 1 instruction(s), ends with backward jump to 0x004cfbf4
    jmp.d8 L_004cfbf4                            # 004cfc43
L_004cfc45:
    # block 0x004cfc45: entered by je at 0x004cfc41, 4 instruction(s), ends with je to 0x004cfc6c (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfc45
    imul ecx, ecx, 0x4a                          # 004cfc48
    cmp dword ptr [ecx + 0x5d1595], 0x0          # 004cfc4b
    je.d8 L_004cfc6c                             # 004cfc52
    # block 0x004cfc54: entered by fall-through of je at 0x004cfc52, 7 instruction(s), calls indirect dword ptr [eax + 0x5d1595], ends with forward jump to 0x004cfd37
    mov edx, dword ptr [ebp - local_48]          # 004cfc54
    push edx                                     # 004cfc57
    mov eax, dword ptr [ebp - local_48]          # 004cfc58
    imul eax, eax, 0x4a                          # 004cfc5b
    call dword ptr [eax + 0x5d1595]              # 004cfc5e
    add esp, 0x4                                 # 004cfc64
    jmp.d32 L_004cfd37                           # 004cfc67
L_004cfc6c:
    # block 0x004cfc6c: entered by je at 0x004cfc52, 13 instruction(s), calls FUN_0050ca3e, ends with je to 0x004cfca2 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfc6c
    push ecx                                     # 004cfc6f
    push 0x559e58                                # 004cfc70
    push 0x63888b                                # 004cfc75
    call FUN_0050ca3e                            # 004cfc7a
    add esp, 0xc                                 # 004cfc7f
    mov edx, dword ptr [ebp - local_48]          # 004cfc82
    imul edx, edx, 0x4a                          # 004cfc85
    {load} xor eax, eax                          # 004cfc88
    mov ax, word ptr [edx + 0x5d15ad]            # 004cfc8a
    mov dword ptr [ebp - local_54], eax          # 004cfc91
    cmp dword ptr [ebp - local_54], 0x1          # 004cfc94
    je.d8 L_004cfca2                             # 004cfc98
    # block 0x004cfc9a: entered by fall-through of je at 0x004cfc98, 2 instruction(s), ends with je to 0x004cfce1 (forward)
    cmp dword ptr [ebp - local_54], 0x2          # 004cfc9a
    je.d8 L_004cfce1                             # 004cfc9e
    # block 0x004cfca0: entered by fall-through of je at 0x004cfc9e, 1 instruction(s), ends with forward jump to 0x004cfd1f
    jmp.d8 L_004cfd1f                            # 004cfca0
L_004cfca2:
    # block 0x004cfca2: entered by je at 0x004cfc98, 18 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004cfd37
    push 0x63888b                                # 004cfca2
    mov ecx, dword ptr [ebp - local_48]          # 004cfca7
    imul ecx, ecx, 0x4a                          # 004cfcaa
    mov edx, dword ptr [ecx + 0x5d15a1]          # 004cfcad
    push edx                                     # 004cfcb3
    mov eax, dword ptr [ebp - local_48]          # 004cfcb4
    imul eax, eax, 0x4a                          # 004cfcb7
    mov ecx, dword ptr [eax + 0x5d159d]          # 004cfcba
    push ecx                                     # 004cfcc0
    mov edx, dword ptr [0x5cf665]                # 004cfcc1
    push edx                                     # 004cfcc7
    mov eax, dword ptr [ebp - local_48]          # 004cfcc8
    imul eax, eax, 0x4a                          # 004cfccb
    mov ecx, dword ptr [eax + 0x5d1599]          # 004cfcce
    push ecx                                     # 004cfcd4
    mov ecx, 0x5cf659                            # 004cfcd5
    call FUN_004c5377                            # 004cfcda
    jmp.d8 L_004cfd37                            # 004cfcdf
L_004cfce1:
    # block 0x004cfce1: entered by je at 0x004cfc9e, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004cfd37
    push 0x63888b                                # 004cfce1
    mov edx, dword ptr [ebp - local_48]          # 004cfce6
    imul edx, edx, 0x4a                          # 004cfce9
    mov eax, dword ptr [edx + 0x5d15a1]          # 004cfcec
    push eax                                     # 004cfcf2
    mov ecx, dword ptr [ebp - local_48]          # 004cfcf3
    imul ecx, ecx, 0x4a                          # 004cfcf6
    mov edx, dword ptr [ecx + 0x5d159d]          # 004cfcf9
    push edx                                     # 004cfcff
    mov eax, dword ptr [0x5cf665]                # 004cfd00
    push eax                                     # 004cfd05
    mov ecx, dword ptr [ebp - local_48]          # 004cfd06
    imul ecx, ecx, 0x4a                          # 004cfd09
    mov edx, dword ptr [ecx + 0x5d1599]          # 004cfd0c
    push edx                                     # 004cfd12
    mov ecx, 0x5cf659                            # 004cfd13
    call FUN_004c5d4b                            # 004cfd18
    jmp.d8 L_004cfd37                            # 004cfd1d
L_004cfd1f:
    # block 0x004cfd1f: entered by jmp at 0x004cfca0, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004cfd37
    push 0x0                                     # 004cfd1f
    push 0x0                                     # 004cfd21
    push 0x559e7c                                # 004cfd23
    call FUN_0052139c                            # 004cfd28
    mov ecx, 0x5cf659                            # 004cfd2d
    call FUN_004c97b4                            # 004cfd32
L_004cfd37:
    # block 0x004cfd37: entered by jmp at 0x004cfc67; jmp at 0x004cfcdf; jmp at 0x004cfd1d, 3 instruction(s), ends with backward jump to 0x004cfbf4
    mov eax, dword ptr [ebp - local_48]          # 004cfd37
    mov byte ptr [ebp + eax - local_40], 0x1     # 004cfd3a
    jmp.d32 L_004cfbf4                           # 004cfd3f
L_004cfd44:
    # block 0x004cfd44: entered by jg at 0x004cfc01, 1 instruction(s), ends with backward jump to 0x004cfbd8
    jmp.d32 L_004cfbd8                           # 004cfd44
L_004cfd49:
    # block 0x004cfd49: entered by jge at 0x004cfbe5, 1 instruction(s), ends with forward jump to 0x004d00a9
    jmp.d32 L_004d00a9                           # 004cfd49
L_004cfd4e:
    # block 0x004cfd4e: entered by jle at 0x004cfa19, 3 instruction(s), ends with forward jump to 0x004cfd63
    movsx ecx, word ptr [0x5bb1c4]               # 004cfd4e
    mov dword ptr [ebp - local_44], ecx          # 004cfd55
    jmp.d8 L_004cfd63                            # 004cfd58
L_004cfd5a:
    # block 0x004cfd5a: entered by jmp at 0x004cfec6, 3 instruction(s), falls into the block at 0x004cfd63
    mov edx, dword ptr [ebp - local_44]          # 004cfd5a
    add edx, 0x1                                 # 004cfd5d
    mov dword ptr [ebp - local_44], edx          # 004cfd60
L_004cfd63:
    # block 0x004cfd63: entered by jmp at 0x004cfd58, 2 instruction(s), ends with jg to 0x004cfecb (forward)
    cmp dword ptr [ebp - local_44], 0xf          # 004cfd63
    jg.d32 L_004cfecb                            # 004cfd67
    # block 0x004cfd6d: entered by fall-through of jg at 0x004cfd67, 2 instruction(s), ends with forward jump to 0x004cfd7f
    mov dword ptr [ebp - local_48], 0x0          # 004cfd6d
    jmp.d8 L_004cfd7f                            # 004cfd74
L_004cfd76:
    # block 0x004cfd76: entered by jmp at 0x004cfdc5; jmp at 0x004cfec1, 3 instruction(s), falls into the block at 0x004cfd7f
    mov eax, dword ptr [ebp - local_48]          # 004cfd76
    add eax, 0x1                                 # 004cfd79
    mov dword ptr [ebp - local_48], eax          # 004cfd7c
L_004cfd7f:
    # block 0x004cfd7f: entered by jmp at 0x004cfd74, 2 instruction(s), ends with jg to 0x004cfec6 (forward)
    cmp dword ptr [ebp - local_48], 0x3f         # 004cfd7f
    jg.d32 L_004cfec6                            # 004cfd83
    # block 0x004cfd89: entered by fall-through of jg at 0x004cfd83, 5 instruction(s), ends with jne to 0x004cfdc5 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfd89
    {load} xor edx, edx                          # 004cfd8c
    mov dl, byte ptr [ebp + ecx - local_40]      # 004cfd8e
    test edx, edx                                # 004cfd92
    jne.d8 L_004cfdc5                            # 004cfd94
    # block 0x004cfd96: entered by fall-through of jne at 0x004cfd94, 4 instruction(s), ends with je to 0x004cfdc5 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cfd96
    imul eax, eax, 0x4a                          # 004cfd99
    cmp dword ptr [eax + 0x5d15a5], 0x0          # 004cfd9c
    je.d8 L_004cfdc5                             # 004cfda3
    # block 0x004cfda5: entered by fall-through of je at 0x004cfda3, 4 instruction(s), ends with je to 0x004cfdc5 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfda5
    imul ecx, ecx, 0x4a                          # 004cfda8
    cmp dword ptr [ecx + 0x5d15a9], 0x0          # 004cfdab
    je.d8 L_004cfdc5                             # 004cfdb2
    # block 0x004cfdb4: entered by fall-through of je at 0x004cfdb2, 5 instruction(s), ends with je to 0x004cfdc7 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004cfdb4
    imul edx, edx, 0x4a                          # 004cfdb7
    mov eax, dword ptr [edx + 0x5d1591]          # 004cfdba
    cmp eax, dword ptr [ebp - local_44]          # 004cfdc0
    je.d8 L_004cfdc7                             # 004cfdc3
L_004cfdc5:
    # block 0x004cfdc5: entered by jne at 0x004cfd94; je at 0x004cfda3; je at 0x004cfdb2; fall-through of je at 0x004cfdc3, 1 instruction(s), ends with backward jump to 0x004cfd76
    jmp.d8 L_004cfd76                            # 004cfdc5
L_004cfdc7:
    # block 0x004cfdc7: entered by je at 0x004cfdc3, 4 instruction(s), ends with je to 0x004cfdee (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfdc7
    imul ecx, ecx, 0x4a                          # 004cfdca
    cmp dword ptr [ecx + 0x5d1595], 0x0          # 004cfdcd
    je.d8 L_004cfdee                             # 004cfdd4
    # block 0x004cfdd6: entered by fall-through of je at 0x004cfdd4, 7 instruction(s), calls indirect dword ptr [eax + 0x5d1595], ends with forward jump to 0x004cfeb9
    mov edx, dword ptr [ebp - local_48]          # 004cfdd6
    push edx                                     # 004cfdd9
    mov eax, dword ptr [ebp - local_48]          # 004cfdda
    imul eax, eax, 0x4a                          # 004cfddd
    call dword ptr [eax + 0x5d1595]              # 004cfde0
    add esp, 0x4                                 # 004cfde6
    jmp.d32 L_004cfeb9                           # 004cfde9
L_004cfdee:
    # block 0x004cfdee: entered by je at 0x004cfdd4, 13 instruction(s), calls FUN_0050ca3e, ends with je to 0x004cfe24 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cfdee
    push ecx                                     # 004cfdf1
    push 0x559ea0                                # 004cfdf2
    push 0x63888b                                # 004cfdf7
    call FUN_0050ca3e                            # 004cfdfc
    add esp, 0xc                                 # 004cfe01
    mov edx, dword ptr [ebp - local_48]          # 004cfe04
    imul edx, edx, 0x4a                          # 004cfe07
    {load} xor eax, eax                          # 004cfe0a
    mov ax, word ptr [edx + 0x5d15ad]            # 004cfe0c
    mov dword ptr [ebp - local_58], eax          # 004cfe13
    cmp dword ptr [ebp - local_58], 0x1          # 004cfe16
    je.d8 L_004cfe24                             # 004cfe1a
    # block 0x004cfe1c: entered by fall-through of je at 0x004cfe1a, 2 instruction(s), ends with je to 0x004cfe63 (forward)
    cmp dword ptr [ebp - local_58], 0x2          # 004cfe1c
    je.d8 L_004cfe63                             # 004cfe20
    # block 0x004cfe22: entered by fall-through of je at 0x004cfe20, 1 instruction(s), ends with forward jump to 0x004cfea1
    jmp.d8 L_004cfea1                            # 004cfe22
L_004cfe24:
    # block 0x004cfe24: entered by je at 0x004cfe1a, 18 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004cfeb9
    push 0x63888b                                # 004cfe24
    mov ecx, dword ptr [ebp - local_48]          # 004cfe29
    imul ecx, ecx, 0x4a                          # 004cfe2c
    mov edx, dword ptr [ecx + 0x5d15a1]          # 004cfe2f
    push edx                                     # 004cfe35
    mov eax, dword ptr [ebp - local_48]          # 004cfe36
    imul eax, eax, 0x4a                          # 004cfe39
    mov ecx, dword ptr [eax + 0x5d159d]          # 004cfe3c
    push ecx                                     # 004cfe42
    mov edx, dword ptr [0x5cf665]                # 004cfe43
    push edx                                     # 004cfe49
    mov eax, dword ptr [ebp - local_48]          # 004cfe4a
    imul eax, eax, 0x4a                          # 004cfe4d
    mov ecx, dword ptr [eax + 0x5d1599]          # 004cfe50
    push ecx                                     # 004cfe56
    mov ecx, 0x5cf659                            # 004cfe57
    call FUN_004c5377                            # 004cfe5c
    jmp.d8 L_004cfeb9                            # 004cfe61
L_004cfe63:
    # block 0x004cfe63: entered by je at 0x004cfe20, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004cfeb9
    push 0x63888b                                # 004cfe63
    mov edx, dword ptr [ebp - local_48]          # 004cfe68
    imul edx, edx, 0x4a                          # 004cfe6b
    mov eax, dword ptr [edx + 0x5d15a1]          # 004cfe6e
    push eax                                     # 004cfe74
    mov ecx, dword ptr [ebp - local_48]          # 004cfe75
    imul ecx, ecx, 0x4a                          # 004cfe78
    mov edx, dword ptr [ecx + 0x5d159d]          # 004cfe7b
    push edx                                     # 004cfe81
    mov eax, dword ptr [0x5cf665]                # 004cfe82
    push eax                                     # 004cfe87
    mov ecx, dword ptr [ebp - local_48]          # 004cfe88
    imul ecx, ecx, 0x4a                          # 004cfe8b
    mov edx, dword ptr [ecx + 0x5d1599]          # 004cfe8e
    push edx                                     # 004cfe94
    mov ecx, 0x5cf659                            # 004cfe95
    call FUN_004c5d4b                            # 004cfe9a
    jmp.d8 L_004cfeb9                            # 004cfe9f
L_004cfea1:
    # block 0x004cfea1: entered by jmp at 0x004cfe22, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004cfeb9
    push 0x0                                     # 004cfea1
    push 0x0                                     # 004cfea3
    push 0x559ec4                                # 004cfea5
    call FUN_0052139c                            # 004cfeaa
    mov ecx, 0x5cf659                            # 004cfeaf
    call FUN_004c97b4                            # 004cfeb4
L_004cfeb9:
    # block 0x004cfeb9: entered by jmp at 0x004cfde9; jmp at 0x004cfe61; jmp at 0x004cfe9f, 3 instruction(s), ends with backward jump to 0x004cfd76
    mov eax, dword ptr [ebp - local_48]          # 004cfeb9
    mov byte ptr [ebp + eax - local_40], 0x1     # 004cfebc
    jmp.d32 L_004cfd76                           # 004cfec1
L_004cfec6:
    # block 0x004cfec6: entered by jg at 0x004cfd83, 1 instruction(s), ends with backward jump to 0x004cfd5a
    jmp.d32 L_004cfd5a                           # 004cfec6
L_004cfecb:
    # block 0x004cfecb: entered by jg at 0x004cfd67, 7 instruction(s), ends with ja to 0x004cff2e (forward)
    mov ecx, dword ptr [0x583204]                # 004cfecb
    mov dword ptr [ebp - local_5c], ecx          # 004cfed1
    mov edx, dword ptr [ebp - local_5c]          # 004cfed4
    sub edx, 0x2                                 # 004cfed7
    mov dword ptr [ebp - local_5c], edx          # 004cfeda
    cmp dword ptr [ebp - local_5c], 0x3          # 004cfedd
    ja.d8 L_004cff2e                             # 004cfee1
    # block 0x004cfee3: entered by fall-through of ja at 0x004cfee1, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4d00c2]
    mov eax, dword ptr [ebp - local_5c]          # 004cfee3
    jmp dword ptr [4*eax + SWTAB_004d00c2_VA]    # 004cfee6
L_004cfeed:
    # block 0x004cfeed: entered by switch case, 4 instruction(s), calls FUN_004e7a10, ends with je to 0x004cff0a (forward)
    mov ecx, 0x582711                            # 004cfeed
    call FUN_004e7a10                            # 004cfef2
    cmp dword ptr [0x5bb22a], 0x0                # 004cfef7
    je.d8 L_004cff0a                             # 004cfefe
    # block 0x004cff00: entered by fall-through of je at 0x004cfefe, 2 instruction(s), calls FUN_004e6658, falls into the block at 0x004cff0a
    mov ecx, 0x57975c                            # 004cff00
    call FUN_004e6658                            # 004cff05
L_004cff0a:
    # block 0x004cff0a: entered by je at 0x004cfefe, 1 instruction(s), ends with forward jump to 0x004cff2e
    jmp.d8 L_004cff2e                            # 004cff0a
L_004cff0c:
    # block 0x004cff0c: entered by switch case, 3 instruction(s), calls FUN_004e97ad, ends with forward jump to 0x004cff2e
    mov ecx, 0x571442                            # 004cff0c
    call FUN_004e97ad                            # 004cff11
    jmp.d8 L_004cff2e                            # 004cff16
L_004cff18:
    # block 0x004cff18: entered by switch case, 3 instruction(s), calls FUN_004ed71e, ends with forward jump to 0x004cff2e
    mov ecx, 0x57fd34                            # 004cff18
    call FUN_004ed71e                            # 004cff1d
    jmp.d8 L_004cff2e                            # 004cff22
L_004cff24:
    # block 0x004cff24: entered by switch case, 2 instruction(s), calls FUN_004e6658, falls into the block at 0x004cff2e
    mov ecx, 0x57975c                            # 004cff24
    call FUN_004e6658                            # 004cff29
L_004cff2e:
    # block 0x004cff2e: entered by ja at 0x004cfee1; jmp at 0x004cff0a; jmp at 0x004cff16; jmp at 0x004cff22, 2 instruction(s), ends with forward jump to 0x004cff40
    mov dword ptr [ebp - local_44], 0x10         # 004cff2e
    jmp.d8 L_004cff40                            # 004cff35
L_004cff37:
    # block 0x004cff37: entered by jmp at 0x004d00a4, 3 instruction(s), falls into the block at 0x004cff40
    mov ecx, dword ptr [ebp - local_44]          # 004cff37
    add ecx, 0x1                                 # 004cff3a
    mov dword ptr [ebp - local_44], ecx          # 004cff3d
L_004cff40:
    # block 0x004cff40: entered by jmp at 0x004cff35, 2 instruction(s), ends with jge to 0x004d00a9 (forward)
    cmp dword ptr [ebp - local_44], 0x15         # 004cff40
    jge.d32 L_004d00a9                           # 004cff44
    # block 0x004cff4a: entered by fall-through of jge at 0x004cff44, 2 instruction(s), ends with forward jump to 0x004cff5c
    mov dword ptr [ebp - local_48], 0x0          # 004cff4a
    jmp.d8 L_004cff5c                            # 004cff51
L_004cff53:
    # block 0x004cff53: entered by jmp at 0x004cffa2; jmp at 0x004d009f, 3 instruction(s), falls into the block at 0x004cff5c
    mov edx, dword ptr [ebp - local_48]          # 004cff53
    add edx, 0x1                                 # 004cff56
    mov dword ptr [ebp - local_48], edx          # 004cff59
L_004cff5c:
    # block 0x004cff5c: entered by jmp at 0x004cff51, 2 instruction(s), ends with jg to 0x004d00a4 (forward)
    cmp dword ptr [ebp - local_48], 0x3f         # 004cff5c
    jg.d32 L_004d00a4                            # 004cff60
    # block 0x004cff66: entered by fall-through of jg at 0x004cff60, 5 instruction(s), ends with jne to 0x004cffa2 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cff66
    {load} xor ecx, ecx                          # 004cff69
    mov cl, byte ptr [ebp + eax - local_40]      # 004cff6b
    test ecx, ecx                                # 004cff6f
    jne.d8 L_004cffa2                            # 004cff71
    # block 0x004cff73: entered by fall-through of jne at 0x004cff71, 4 instruction(s), ends with je to 0x004cffa2 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004cff73
    imul edx, edx, 0x4a                          # 004cff76
    cmp dword ptr [edx + 0x5d15a5], 0x0          # 004cff79
    je.d8 L_004cffa2                             # 004cff80
    # block 0x004cff82: entered by fall-through of je at 0x004cff80, 4 instruction(s), ends with je to 0x004cffa2 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cff82
    imul eax, eax, 0x4a                          # 004cff85
    cmp dword ptr [eax + 0x5d15a9], 0x0          # 004cff88
    je.d8 L_004cffa2                             # 004cff8f
    # block 0x004cff91: entered by fall-through of je at 0x004cff8f, 5 instruction(s), ends with je to 0x004cffa4 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004cff91
    imul ecx, ecx, 0x4a                          # 004cff94
    mov edx, dword ptr [ecx + 0x5d1591]          # 004cff97
    cmp edx, dword ptr [ebp - local_44]          # 004cff9d
    je.d8 L_004cffa4                             # 004cffa0
L_004cffa2:
    # block 0x004cffa2: entered by jne at 0x004cff71; je at 0x004cff80; je at 0x004cff8f; fall-through of je at 0x004cffa0, 1 instruction(s), ends with backward jump to 0x004cff53
    jmp.d8 L_004cff53                            # 004cffa2
L_004cffa4:
    # block 0x004cffa4: entered by je at 0x004cffa0, 4 instruction(s), ends with je to 0x004cffcb (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cffa4
    imul eax, eax, 0x4a                          # 004cffa7
    cmp dword ptr [eax + 0x5d1595], 0x0          # 004cffaa
    je.d8 L_004cffcb                             # 004cffb1
    # block 0x004cffb3: entered by fall-through of je at 0x004cffb1, 7 instruction(s), calls indirect dword ptr [edx + 0x5d1595], ends with forward jump to 0x004d0097
    mov ecx, dword ptr [ebp - local_48]          # 004cffb3
    push ecx                                     # 004cffb6
    mov edx, dword ptr [ebp - local_48]          # 004cffb7
    imul edx, edx, 0x4a                          # 004cffba
    call dword ptr [edx + 0x5d1595]              # 004cffbd
    add esp, 0x4                                 # 004cffc3
    jmp.d32 L_004d0097                           # 004cffc6
L_004cffcb:
    # block 0x004cffcb: entered by je at 0x004cffb1, 13 instruction(s), calls FUN_0050ca3e, ends with je to 0x004d0001 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004cffcb
    push eax                                     # 004cffce
    push 0x559ee8                                # 004cffcf
    push 0x63888b                                # 004cffd4
    call FUN_0050ca3e                            # 004cffd9
    add esp, 0xc                                 # 004cffde
    mov ecx, dword ptr [ebp - local_48]          # 004cffe1
    imul ecx, ecx, 0x4a                          # 004cffe4
    {load} xor edx, edx                          # 004cffe7
    mov dx, word ptr [ecx + 0x5d15ad]            # 004cffe9
    mov dword ptr [ebp - local_60], edx          # 004cfff0
    cmp dword ptr [ebp - local_60], 0x1          # 004cfff3
    je.d8 L_004d0001                             # 004cfff7
    # block 0x004cfff9: entered by fall-through of je at 0x004cfff7, 2 instruction(s), ends with je to 0x004d0040 (forward)
    cmp dword ptr [ebp - local_60], 0x2          # 004cfff9
    je.d8 L_004d0040                             # 004cfffd
    # block 0x004cffff: entered by fall-through of je at 0x004cfffd, 1 instruction(s), ends with forward jump to 0x004d007f
    jmp.d8 L_004d007f                            # 004cffff
L_004d0001:
    # block 0x004d0001: entered by je at 0x004cfff7, 18 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d0097
    push 0x63888b                                # 004d0001
    mov eax, dword ptr [ebp - local_48]          # 004d0006
    imul eax, eax, 0x4a                          # 004d0009
    mov ecx, dword ptr [eax + 0x5d15a1]          # 004d000c
    push ecx                                     # 004d0012
    mov edx, dword ptr [ebp - local_48]          # 004d0013
    imul edx, edx, 0x4a                          # 004d0016
    mov eax, dword ptr [edx + 0x5d159d]          # 004d0019
    push eax                                     # 004d001f
    mov ecx, dword ptr [0x5cf665]                # 004d0020
    push ecx                                     # 004d0026
    mov edx, dword ptr [ebp - local_48]          # 004d0027
    imul edx, edx, 0x4a                          # 004d002a
    mov eax, dword ptr [edx + 0x5d1599]          # 004d002d
    push eax                                     # 004d0033
    mov ecx, 0x5cf659                            # 004d0034
    call FUN_004c5377                            # 004d0039
    jmp.d8 L_004d0097                            # 004d003e
L_004d0040:
    # block 0x004d0040: entered by je at 0x004cfffd, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004d0097
    push 0x63888b                                # 004d0040
    mov ecx, dword ptr [ebp - local_48]          # 004d0045
    imul ecx, ecx, 0x4a                          # 004d0048
    mov edx, dword ptr [ecx + 0x5d15a1]          # 004d004b
    push edx                                     # 004d0051
    mov eax, dword ptr [ebp - local_48]          # 004d0052
    imul eax, eax, 0x4a                          # 004d0055
    mov ecx, dword ptr [eax + 0x5d159d]          # 004d0058
    push ecx                                     # 004d005e
    mov edx, dword ptr [0x5cf665]                # 004d005f
    push edx                                     # 004d0065
    mov eax, dword ptr [ebp - local_48]          # 004d0066
    imul eax, eax, 0x4a                          # 004d0069
    mov ecx, dword ptr [eax + 0x5d1599]          # 004d006c
    push ecx                                     # 004d0072
    mov ecx, 0x5cf659                            # 004d0073
    call FUN_004c5d4b                            # 004d0078
    jmp.d8 L_004d0097                            # 004d007d
L_004d007f:
    # block 0x004d007f: entered by jmp at 0x004cffff, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d0097
    push 0x0                                     # 004d007f
    push 0x0                                     # 004d0081
    push 0x559f0c                                # 004d0083
    call FUN_0052139c                            # 004d0088
    mov ecx, 0x5cf659                            # 004d008d
    call FUN_004c97b4                            # 004d0092
L_004d0097:
    # block 0x004d0097: entered by jmp at 0x004cffc6; jmp at 0x004d003e; jmp at 0x004d007d, 3 instruction(s), ends with backward jump to 0x004cff53
    mov edx, dword ptr [ebp - local_48]          # 004d0097
    mov byte ptr [ebp + edx - local_40], 0x1     # 004d009a
    jmp.d32 L_004cff53                           # 004d009f
L_004d00a4:
    # block 0x004d00a4: entered by jg at 0x004cff60, 1 instruction(s), ends with backward jump to 0x004cff37
    jmp.d32 L_004cff37                           # 004d00a4
L_004d00a9:
    # block 0x004d00a9: entered by jmp at 0x004cfd49; jge at 0x004cff44, 8 instruction(s), calls FUN_00447c36, FUN_004c4c2b, ends with ret
    mov ecx, 0x6198d7                            # 004d00a9
    call FUN_00447c36                            # 004d00ae
    mov ecx, 0x5cf659                            # 004d00b3
    call FUN_004c4c2b                            # 004d00b8
    pop edi                                      # 004d00bd
    {load} mov esp, ebp                          # 004d00be
    pop ebp                                      # 004d00c0
    ret                                          # 004d00c1

# --- data items (not part of the function) -------------------------
.org 0x004d00c2 - 0x401000
SWTAB_004d00c2:  # 4 case address(es)
    .long L_004cfeed - .text + 0x401000
    .long L_004cff0c - .text + 0x401000
    .long L_004cff18 - .text + 0x401000
    .long L_004cff24 - .text + 0x401000
.set SWTAB_004d00c2_VA, SWTAB_004d00c2 - .text + 0x401000

