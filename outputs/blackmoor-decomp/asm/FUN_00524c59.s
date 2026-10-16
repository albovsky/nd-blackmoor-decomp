# FUN_00524c59
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524c59
# extent:       0x00524c59-0x00524d43 (234 code bytes)
# span:         0x00524c59-0x00524d43 (code 234, tables 0, padding 0)
# sha256:       a0db1e6daa6bb6869d6d46ad88f86bf58f93a2725a0993a591e907e50d5db63a
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524c59
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_8, field_minus_4, field_minus_c, field_minus_10; [ebx + n] field_4, field_1070; [esi + n] field_28, field_2c, field_68, field_70, field_78, field_7c, field_80, field_84, field_88, field_8c, field_90, field_94 and 10 more
# callees:      calls FUN_0050f978, FUN_00524b5f, FUN_0050ffb2, FUN_00525371, FUN_00525b0f, KERNEL32.dll!GetCurrentThread, KERNEL32.dll!GetCurrentThreadId
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_68, 0x68  # offset +0x68
.equ field_70, 0x70  # offset +0x70
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_1070, 0x1070  # offset +0x1070

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0050ffb2, .text + (0x0050ffb2 - 0x401000)
.set FUN_00524b5f, .text + (0x00524b5f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x00524c59 - 0x401000
.globl FUN_00524c59
FUN_00524c59:
    # block 0x00524c59: entry, 14 instruction(s), calls FUN_0050f978, FUN_00524b5f, ends with je to 0x00524c8f (forward)
    mov eax, 0x528e58                            # 00524c59
    call FUN_0050f978                            # 00524c5e
    push ecx                                     # 00524c63
    push ebx                                     # 00524c64
    push esi                                     # 00524c65
    {load} mov esi, ecx                          # 00524c66
    push edi                                     # 00524c68
    mov dword ptr [ebp - field_minus_10], esi    # 00524c69
    call FUN_00524b5f                            # 00524c6c
    {load} xor edi, edi                          # 00524c71
    mov dword ptr [esi], 0x52f514                # 00524c73
    cmp dword ptr [ebp + field_8], edi           # 00524c79
    mov dword ptr [ebp - field_minus_4], edi     # 00524c7c
    je.d8 L_00524c8f                             # 00524c7f
    # block 0x00524c81: entered by fall-through of je at 0x00524c7f, 5 instruction(s), calls FUN_0050ffb2, ends with forward jump to 0x00524c92
    push dword ptr [ebp + field_8]               # 00524c81
    call FUN_0050ffb2                            # 00524c84
    pop ecx                                      # 00524c89
    mov dword ptr [esi + field_78], eax          # 00524c8a
    jmp.d8 L_00524c92                            # 00524c8d
L_00524c8f:
    # block 0x00524c8f: entered by je at 0x00524c7f, 1 instruction(s), falls into the block at 0x00524c92
    mov dword ptr [esi + field_78], edi          # 00524c8f
L_00524c92:
    # block 0x00524c92: entered by jmp at 0x00524c8d, 38 instruction(s), calls FUN_00525371, FUN_00525b0f, KERNEL32.dll!GetCurrentThread, KERNEL32.dll!GetCurrentThreadId, ends with ret 0x4
    call FUN_00525371                            # 00524c92
    {load} mov ebx, eax                          # 00524c97
    push 0x524bd4                                # 00524c99
    lea ecx, [ebx + field_1070]                  # 00524c9e
    call FUN_00525b0f                            # 00524ca4
    mov dword ptr [eax + field_4], esi           # 00524ca9
    call dword ptr [0x52a1e0]                    # 00524cac
    mov dword ptr [esi + field_28], eax          # 00524cb2
    call dword ptr [0x52a2a0]                    # 00524cb5
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524cbb
    mov dword ptr [esi + field_2c], eax          # 00524cbe
    mov dword ptr [ebx + field_4], esi           # 00524cc1
    mov dword ptr [esi + field_68], edi          # 00524cc4
    mov dword ptr [esi + field_8c], edi          # 00524cc7
    mov dword ptr [esi + field_90], edi          # 00524ccd
    mov dword ptr [esi + field_7c], edi          # 00524cd3
    mov dword ptr [esi + field_88], edi          # 00524cd6
    mov dword ptr [esi + field_a8], edi          # 00524cdc
    mov dword ptr [esi + field_80], edi          # 00524ce2
    mov word ptr [esi + field_b2], di            # 00524ce8
    mov word ptr [esi + field_b0], di            # 00524cef
    mov dword ptr [esi + field_70], edi          # 00524cf6
    mov dword ptr [esi + field_ac], edi          # 00524cf9
    mov dword ptr [esi + field_a0], edi          # 00524cff
    mov dword ptr [esi + field_a4], edi          # 00524d05
    mov dword ptr [esi + field_94], edi          # 00524d0b
    mov dword ptr [esi + field_98], edi          # 00524d11
    mov dword ptr [esi + field_b4], edi          # 00524d17
    mov dword ptr [esi + field_bc], edi          # 00524d1d
    mov dword ptr [esi + field_84], edi          # 00524d23
    mov dword ptr [esi + field_b8], 0x200        # 00524d29
    {load} mov eax, esi                          # 00524d33
    pop edi                                      # 00524d35
    pop esi                                      # 00524d36
    pop ebx                                      # 00524d37
    mov dword ptr fs:[0x0], ecx                  # 00524d38
    leave                                        # 00524d3f
    ret 0x4                                      # 00524d40

