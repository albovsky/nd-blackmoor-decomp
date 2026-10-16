# FUN_00510ac9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510ac9
# extent:       0x00510ac9-0x00510c81 (440 code bytes)
# span:         0x00510ac9-0x00510c81 (code 440, tables 0, padding 0)
# sha256:       cae9b92fe796473a6b5d0db98d6f83ed378c1ed7ce61bd74fa626697ee543266
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510ac9
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_10, local_18
# fields:       [eax + n] field_8, field_c; [ebx + n] field_18; [ecx + n] field_4, field_8; [esi + n] field_8, field_14, field_18
# callees:      calls FUN_00516600, FUN_0051661c, FUN_00510cf4, FUN_0050ed50, FUN_00516638, FUN_0050c670, FUN_0050c669, FUN_00510f3b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 164 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510c81
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050c669, .text + (0x0050c669 - 0x401000)
.set FUN_0050c670, .text + (0x0050c670 - 0x401000)
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)
.set FUN_00510cf4, .text + (0x00510cf4 - 0x401000)
.set FUN_00510f3b, .text + (0x00510f3b - 0x401000)
.set FUN_00516600, .text + (0x00516600 - 0x401000)
.set FUN_0051661c, .text + (0x0051661c - 0x401000)
.set FUN_00516638, .text + (0x00516638 - 0x401000)

.org 0x00510ac9 - 0x401000
.globl FUN_00510ac9
FUN_00510ac9:
    # block 0x00510ac9: entry, 17 instruction(s), ends with je to 0x00510c72 (forward)
    push ebp                                     # 00510ac9
    {load} mov ebp, esp                          # 00510aca
    push -0x1                                    # 00510acc
    push 0x5303e8                                # 00510ace
    push 0x511930                                # 00510ad3
    mov eax, dword ptr fs:[0x0]                  # 00510ad8
    push eax                                     # 00510ade
    mov dword ptr fs:[0x0], esp                  # 00510adf
    sub esp, 0xc                                 # 00510ae6
    push ebx                                     # 00510ae9
    push esi                                     # 00510aea
    push edi                                     # 00510aeb
    mov dword ptr [ebp - local_18], esp          # 00510aec
    mov ecx, dword ptr [ebp + arg_10]            # 00510aef
    mov eax, dword ptr [ecx + field_4]           # 00510af2
    test eax, eax                                # 00510af5
    je.d32 L_00510c72                            # 00510af7
    # block 0x00510afd: entered by fall-through of je at 0x00510af7, 2 instruction(s), ends with je to 0x00510c72 (forward)
    cmp byte ptr [eax + field_8], 0x0            # 00510afd
    je.d32 L_00510c72                            # 00510b01
    # block 0x00510b07: entered by fall-through of je at 0x00510b01, 3 instruction(s), ends with je to 0x00510c72 (forward)
    mov eax, dword ptr [ecx + field_8]           # 00510b07
    test eax, eax                                # 00510b0a
    je.d32 L_00510c72                            # 00510b0c
    # block 0x00510b12: entered by fall-through of je at 0x00510b0c, 5 instruction(s), ends with je to 0x00510b66 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00510b12
    lea edi, [eax + edx + field_c]               # 00510b15
    and dword ptr [ebp - local_4], 0x0           # 00510b19
    test byte ptr [ecx], 0x8                     # 00510b1d
    je.d8 L_00510b66                             # 00510b20
    # block 0x00510b22: entered by fall-through of je at 0x00510b20, 8 instruction(s), calls FUN_00516600, ends with je to 0x00510c69 (forward)
    mov esi, dword ptr [ebp + arg_8]             # 00510b22
    push 0x1                                     # 00510b25
    push dword ptr [esi + field_18]              # 00510b27
    call FUN_00516600                            # 00510b2a
    pop ecx                                      # 00510b2f
    pop ecx                                      # 00510b30
    test eax, eax                                # 00510b31
    je.d32 L_00510c69                            # 00510b33
    # block 0x00510b39: entered by fall-through of je at 0x00510b33, 7 instruction(s), calls FUN_0051661c, ends with je to 0x00510c69 (forward)
    push 0x1                                     # 00510b39
    push edi                                     # 00510b3b
    call FUN_0051661c                            # 00510b3c
    pop ecx                                      # 00510b41
    pop ecx                                      # 00510b42
    test eax, eax                                # 00510b43
    je.d32 L_00510c69                            # 00510b45
    # block 0x00510b4b: entered by fall-through of je at 0x00510b45, 5 instruction(s), falls into the block at 0x00510b57
    mov eax, dword ptr [esi + field_18]          # 00510b4b
    mov dword ptr [edi], eax                     # 00510b4e
    mov ecx, dword ptr [ebp + arg_14]            # 00510b50
    add ecx, 0x8                                 # 00510b53
    push ecx                                     # 00510b56
L_00510b57:
    # block 0x00510b57: entered by jmp at 0x00510bbe, 6 instruction(s), calls FUN_00510cf4, ends with forward jump to 0x00510c6e
    push eax                                     # 00510b57
    call FUN_00510cf4                            # 00510b58
    pop ecx                                      # 00510b5d
    pop ecx                                      # 00510b5e
    mov dword ptr [edi], eax                     # 00510b5f
    jmp.d32 L_00510c6e                           # 00510b61
L_00510b66:
    # block 0x00510b66: entered by je at 0x00510b20, 3 instruction(s), ends with je to 0x00510bc0 (forward)
    mov esi, dword ptr [ebp + arg_14]            # 00510b66
    test byte ptr [esi], 0x1                     # 00510b69
    je.d8 L_00510bc0                             # 00510b6c
    # block 0x00510b6e: entered by fall-through of je at 0x00510b6c, 8 instruction(s), calls FUN_00516600, ends with je to 0x00510c69 (forward)
    mov ebx, dword ptr [ebp + arg_8]             # 00510b6e
    push 0x1                                     # 00510b71
    push dword ptr [ebx + field_18]              # 00510b73
    call FUN_00516600                            # 00510b76
    pop ecx                                      # 00510b7b
    pop ecx                                      # 00510b7c
    test eax, eax                                # 00510b7d
    je.d32 L_00510c69                            # 00510b7f
    # block 0x00510b85: entered by fall-through of je at 0x00510b7f, 7 instruction(s), calls FUN_0051661c, ends with je to 0x00510c69 (forward)
    push 0x1                                     # 00510b85
    push edi                                     # 00510b87
    call FUN_0051661c                            # 00510b88
    pop ecx                                      # 00510b8d
    pop ecx                                      # 00510b8e
    test eax, eax                                # 00510b8f
    je.d32 L_00510c69                            # 00510b91
    # block 0x00510b97: entered by fall-through of je at 0x00510b91, 7 instruction(s), calls FUN_0050ed50, ends with jne to 0x00510c6e (forward)
    push dword ptr [esi + field_14]              # 00510b97
    push dword ptr [ebx + field_18]              # 00510b9a
    push edi                                     # 00510b9d
    call FUN_0050ed50                            # 00510b9e
    add esp, 0xc                                 # 00510ba3
    cmp dword ptr [esi + field_14], 0x4          # 00510ba6
    jne.d32 L_00510c6e                           # 00510baa
    # block 0x00510bb0: entered by fall-through of jne at 0x00510baa, 3 instruction(s), ends with je to 0x00510c6e (forward)
    mov eax, dword ptr [edi]                     # 00510bb0
    test eax, eax                                # 00510bb2
    je.d32 L_00510c6e                            # 00510bb4
    # block 0x00510bba: entered by fall-through of je at 0x00510bb4, 3 instruction(s), ends with backward jump to 0x00510b57
    add esi, 0x8                                 # 00510bba
    push esi                                     # 00510bbd
    jmp.d8 L_00510b57                            # 00510bbe
L_00510bc0:
    # block 0x00510bc0: entered by je at 0x00510b6c, 5 instruction(s), ends with jne to 0x00510c08 (forward)
    cmp dword ptr [esi + field_18], 0x0          # 00510bc0
    mov ebx, dword ptr [ebp + arg_8]             # 00510bc4
    push 0x1                                     # 00510bc7
    push dword ptr [ebx + field_18]              # 00510bc9
    jne.d8 L_00510c08                            # 00510bcc
    # block 0x00510bce: entered by fall-through of jne at 0x00510bcc, 5 instruction(s), calls FUN_00516600, ends with je to 0x00510c69 (forward)
    call FUN_00516600                            # 00510bce
    pop ecx                                      # 00510bd3
    pop ecx                                      # 00510bd4
    test eax, eax                                # 00510bd5
    je.d32 L_00510c69                            # 00510bd7
    # block 0x00510bdd: entered by fall-through of je at 0x00510bd7, 7 instruction(s), calls FUN_0051661c, ends with je to 0x00510c69 (forward)
    push 0x1                                     # 00510bdd
    push edi                                     # 00510bdf
    call FUN_0051661c                            # 00510be0
    pop ecx                                      # 00510be5
    pop ecx                                      # 00510be6
    test eax, eax                                # 00510be7
    je.d8 L_00510c69                             # 00510be9
    # block 0x00510beb: entered by fall-through of je at 0x00510be9, 12 instruction(s), calls FUN_00510cf4, FUN_0050ed50, ends with forward jump to 0x00510c6e
    push dword ptr [esi + field_14]              # 00510beb
    add esi, 0x8                                 # 00510bee
    push esi                                     # 00510bf1
    push dword ptr [ebx + field_18]              # 00510bf2
    call FUN_00510cf4                            # 00510bf5
    pop ecx                                      # 00510bfa
    pop ecx                                      # 00510bfb
    push eax                                     # 00510bfc
    push edi                                     # 00510bfd
    call FUN_0050ed50                            # 00510bfe
    add esp, 0xc                                 # 00510c03
    jmp.d8 L_00510c6e                            # 00510c06
L_00510c08:
    # block 0x00510c08: entered by jne at 0x00510bcc, 5 instruction(s), calls FUN_00516600, ends with je to 0x00510c69 (forward)
    call FUN_00516600                            # 00510c08
    pop ecx                                      # 00510c0d
    pop ecx                                      # 00510c0e
    test eax, eax                                # 00510c0f
    je.d8 L_00510c69                             # 00510c11
    # block 0x00510c13: entered by fall-through of je at 0x00510c11, 7 instruction(s), calls FUN_0051661c, ends with je to 0x00510c69 (forward)
    push 0x1                                     # 00510c13
    push edi                                     # 00510c15
    call FUN_0051661c                            # 00510c16
    pop ecx                                      # 00510c1b
    pop ecx                                      # 00510c1c
    test eax, eax                                # 00510c1d
    je.d8 L_00510c69                             # 00510c1f
    # block 0x00510c21: entered by fall-through of je at 0x00510c1f, 5 instruction(s), calls FUN_00516638, ends with je to 0x00510c69 (forward)
    push dword ptr [esi + field_18]              # 00510c21
    call FUN_00516638                            # 00510c24
    pop ecx                                      # 00510c29
    test eax, eax                                # 00510c2a
    je.d8 L_00510c69                             # 00510c2c
    # block 0x00510c2e: entered by fall-through of je at 0x00510c2c, 2 instruction(s), ends with je to 0x00510c4f (forward)
    test byte ptr [esi], 0x4                     # 00510c2e
    je.d8 L_00510c4f                             # 00510c31
    # block 0x00510c33: entered by fall-through of je at 0x00510c31, 12 instruction(s), calls FUN_00510cf4, FUN_0050c670, ends with forward jump to 0x00510c6e
    push 0x1                                     # 00510c33
    lea eax, [esi + field_8]                     # 00510c35
    push eax                                     # 00510c38
    push dword ptr [ebx + field_18]              # 00510c39
    call FUN_00510cf4                            # 00510c3c
    pop ecx                                      # 00510c41
    pop ecx                                      # 00510c42
    push eax                                     # 00510c43
    push dword ptr [esi + field_18]              # 00510c44
    push edi                                     # 00510c47
    call FUN_0050c670                            # 00510c48
    jmp.d8 L_00510c6e                            # 00510c4d
L_00510c4f:
    # block 0x00510c4f: entered by je at 0x00510c31, 11 instruction(s), calls FUN_00510cf4, FUN_0050c669, ends with forward jump to 0x00510c6e
    lea eax, [esi + field_8]                     # 00510c4f
    push eax                                     # 00510c52
    push dword ptr [ebx + field_18]              # 00510c53
    call FUN_00510cf4                            # 00510c56
    pop ecx                                      # 00510c5b
    pop ecx                                      # 00510c5c
    push eax                                     # 00510c5d
    push dword ptr [esi + field_18]              # 00510c5e
    push edi                                     # 00510c61
    call FUN_0050c669                            # 00510c62
    jmp.d8 L_00510c6e                            # 00510c67
L_00510c69:
    # block 0x00510c69: entered by je at 0x00510b33; je at 0x00510b45; je at 0x00510b7f; je at 0x00510b91; more, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x00510c6e
    call FUN_00510f3b                            # 00510c69
L_00510c6e:
    # block 0x00510c6e: entered by jmp at 0x00510b61; jne at 0x00510baa; je at 0x00510bb4; jmp at 0x00510c06; more, 1 instruction(s), falls into the block at 0x00510c72
    or dword ptr [ebp - local_4], -0x1           # 00510c6e
L_00510c72:
    # block 0x00510c72: entered by je at 0x00510af7; je at 0x00510b01; je at 0x00510b0c, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_10]          # 00510c72
    mov dword ptr fs:[0x0], ecx                  # 00510c75
    pop edi                                      # 00510c7c
    pop esi                                      # 00510c7d
    pop ebx                                      # 00510c7e
    leave                                        # 00510c7f
    ret                                          # 00510c80

