# FUN_00525dce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525dce
# extent:       0x00525dce-0x00525e69 (155 code bytes)
# span:         0x00525dce-0x00525e69 (code 155, tables 0, padding 0)
# sha256:       fa247227232a28fd626f1fc1abe9f6d8dae6ab4baf71f56e16b0271e6a6f95b5
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525dce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_10, field_14, field_24, field_3c, field_40, field_44, field_50, field_54, field_58, field_5c, field_60, field_64 and 1 more
# callees:      calls KERNEL32.dll!GetVersion, KERNEL32.dll!GetProcessVersion, FUN_0051f96d, FUN_0051f929; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0051f929, .text + (0x0051f929 - 0x401000)
.set FUN_0051f96d, .text + (0x0051f96d - 0x401000)

.org 0x00525dce - 0x401000
.globl FUN_00525dce
FUN_00525dce:
    # block 0x00525dce: entry, 28 instruction(s), calls KERNEL32.dll!GetVersion, ends with je to 0x00525e21 (forward)
    push ebx                                     # 00525dce
    push esi                                     # 00525dcf
    push edi                                     # 00525dd0
    {load} mov esi, ecx                          # 00525dd1
    call dword ptr [0x52a224]                    # 00525dd3
    {load} xor ecx, ecx                          # 00525dd9
    push 0x1                                     # 00525ddb
    {load} mov cl, ah                            # 00525ddd
    movzx edx, al                                # 00525ddf
    movzx ecx, cl                                # 00525de2
    shl edx, 0x8                                 # 00525de5
    {load} add ecx, edx                          # 00525de8
    mov dword ptr [esi + field_54], ecx          # 00525dea
    {load} mov ecx, eax                          # 00525ded
    shr ecx, 0x1f                                # 00525def
    cmp al, 0x4                                  # 00525df2
    mov dword ptr [esi + field_58], ecx          # 00525df4
    {load} sbb eax, eax                          # 00525df7
    pop ecx                                      # 00525df9
    inc eax                                      # 00525dfa
    {load} xor ebx, ebx                          # 00525dfb
    {load} sub ecx, eax                          # 00525dfd
    {load} cmp eax, ebx                          # 00525dff
    mov dword ptr [esi + field_5c], eax          # 00525e01
    mov dword ptr [esi + field_60], ecx          # 00525e04
    mov dword ptr [esi + field_64], eax          # 00525e07
    mov dword ptr [esi + field_68], ebx          # 00525e0a
    je.d8 L_00525e21                             # 00525e0d
    # block 0x00525e0f: entered by fall-through of je at 0x00525e0d, 6 instruction(s), calls KERNEL32.dll!GetProcessVersion, falls into the block at 0x00525e21
    push ebx                                     # 00525e0f
    call dword ptr [0x52a0e4]                    # 00525e10
    cmp eax, 0x40000                             # 00525e16
    {load} sbb eax, eax                          # 00525e1b
    inc eax                                      # 00525e1d
    mov dword ptr [esi + field_68], eax          # 00525e1e
L_00525e21:
    # block 0x00525e21: entered by je at 0x00525e0d, 27 instruction(s), calls FUN_0051f96d, FUN_0051f929, indirect edi, ends with ret
    {load} mov ecx, esi                          # 00525e21
    call FUN_0051f96d                            # 00525e23
    {load} mov ecx, esi                          # 00525e28
    mov dword ptr [esi + field_24], ebx          # 00525e2a
    call FUN_0051f929                            # 00525e2d
    mov edi, dword ptr [0x52a4a4]                # 00525e32
    push 0x7f02                                  # 00525e38
    push ebx                                     # 00525e3d
    call edi                                     # 00525e3e
    push 0x7f00                                  # 00525e40
    push ebx                                     # 00525e45
    mov dword ptr [esi + field_3c], eax          # 00525e46
    call edi                                     # 00525e49
    mov dword ptr [esi + field_40], eax          # 00525e4b
    {load} xor eax, eax                          # 00525e4e
    cmp dword ptr [esi + field_5c], ebx          # 00525e50
    mov dword ptr [esi + field_50], ebx          # 00525e53
    mov dword ptr [esi + field_44], ebx          # 00525e56
    pop edi                                      # 00525e59
    setne al                                     # 00525e5a
    inc eax                                      # 00525e5d
    mov dword ptr [esi + field_10], eax          # 00525e5e
    mov dword ptr [esi + field_14], eax          # 00525e61
    {load} mov eax, esi                          # 00525e64
    pop esi                                      # 00525e66
    pop ebx                                      # 00525e67
    ret                                          # 00525e68

