# FUN_0051f96d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f96d
# extent:       0x0051f96d-0x0051f9c5 (88 code bytes)
# span:         0x0051f96d-0x0051f9c5 (code 88, tables 0, padding 0)
# sha256:       9c820cd68b026bea628162f5852aad8916e2c042854682d6ec7d831cd8b4894a
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f96d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c, field_18, field_1c, field_68
# callees:      calls FUN_00525d7c, FUN_00525dac, USER32.dll!GetDC, USER32.dll!ReleaseDC; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_00525d7c, .text + (0x00525d7c - 0x401000)
.set FUN_00525dac, .text + (0x00525dac - 0x401000)

.org 0x0051f96d - 0x401000
.globl FUN_0051f96d
FUN_0051f96d:
    # block 0x0051f96d: entry, 13 instruction(s), calls indirect edi, ends with je to 0x0051f993 (forward)
    push ebx                                     # 0051f96d
    push esi                                     # 0051f96e
    push edi                                     # 0051f96f
    mov edi, dword ptr [0x52a498]                # 0051f970
    {load} mov esi, ecx                          # 0051f976
    push 0xb                                     # 0051f978
    call edi                                     # 0051f97a
    push 0xc                                     # 0051f97c
    mov dword ptr [esi + field_8], eax           # 0051f97e
    call edi                                     # 0051f981
    cmp dword ptr [esi + field_68], 0x0          # 0051f983
    mov dword ptr [esi + field_c], eax           # 0051f987
    je.d8 L_0051f993                             # 0051f98a
    # block 0x0051f98c: entered by fall-through of je at 0x0051f98a, 2 instruction(s), calls FUN_00525d7c, ends with forward jump to 0x0051f998
    call FUN_00525d7c                            # 0051f98c
    jmp.d8 L_0051f998                            # 0051f991
L_0051f993:
    # block 0x0051f993: entered by je at 0x0051f98a, 1 instruction(s), calls FUN_00525dac, falls into the block at 0x0051f998
    call FUN_00525dac                            # 0051f993
L_0051f998:
    # block 0x0051f998: entered by jmp at 0x0051f991, 19 instruction(s), calls USER32.dll!GetDC, indirect ebx, USER32.dll!ReleaseDC, ends with ret
    push 0x0                                     # 0051f998
    call dword ptr [0x52a3a4]                    # 0051f99a
    mov ebx, dword ptr [0x52a094]                # 0051f9a0
    {load} mov edi, eax                          # 0051f9a6
    push 0x58                                    # 0051f9a8
    push edi                                     # 0051f9aa
    call ebx                                     # 0051f9ab
    push 0x5a                                    # 0051f9ad
    push edi                                     # 0051f9af
    mov dword ptr [esi + field_18], eax          # 0051f9b0
    call ebx                                     # 0051f9b3
    push edi                                     # 0051f9b5
    push 0x0                                     # 0051f9b6
    mov dword ptr [esi + field_1c], eax          # 0051f9b8
    call dword ptr [0x52a3a8]                    # 0051f9bb
    pop edi                                      # 0051f9c1
    pop esi                                      # 0051f9c2
    pop ebx                                      # 0051f9c3
    ret                                          # 0051f9c4

