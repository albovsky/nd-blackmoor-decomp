# FUN_00523812
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523812
# extent:       0x00523812-0x005238d5 (195 code bytes)
# span:         0x00523812-0x005238d5 (code 195, tables 0, padding 0)
# sha256:       b8d361d421bec045eb66a2e5eeae25f193ada50c5df8051fd15002a5e5da7c6f
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523812
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_108
# fields:       [eax + n] field_4, field_1c; [esi + n] field_b0, field_b2
# callees:      calls FUN_00525371, USER32.dll!SendMessageA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_108, 0x108  # offset -0x108
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00523812 - 0x401000
.globl FUN_00523812
FUN_00523812:
    # block 0x00523812: entry, 9 instruction(s), calls FUN_00525371, ends with je to 0x005238ce (forward)
    push ebp                                     # 00523812
    {load} mov ebp, esp                          # 00523813
    sub esp, 0x108                               # 00523815
    push esi                                     # 0052381b
    mov dword ptr [ebp - local_4], ecx           # 0052381c
    call FUN_00525371                            # 0052381f
    mov esi, dword ptr [eax + field_4]           # 00523824
    test esi, esi                                # 00523827
    je.d32 L_005238ce                            # 00523829
    # block 0x0052382f: entered by fall-through of je at 0x00523829, 2 instruction(s), ends with je to 0x005238ce (forward)
    cmp word ptr [ebp + arg_c], 0x0              # 0052382f
    je.d32 L_005238ce                            # 00523834
    # block 0x0052383a: entered by fall-through of je at 0x00523834, 4 instruction(s), ends with je to 0x005238ce (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0052383a
    shr ecx, 0x10                                # 0052383d
    test cx, cx                                  # 00523840
    je.d32 L_005238ce                            # 00523843
    # block 0x00523849: entered by fall-through of je at 0x00523843, 3 instruction(s), ends with jne to 0x005238ce (forward)
    mov ax, word ptr [esi + field_b0]            # 00523849
    cmp word ptr [ebp + arg_c], ax               # 00523850
    jne.d8 L_005238ce                            # 00523854
    # block 0x00523856: entered by fall-through of jne at 0x00523854, 2 instruction(s), ends with jne to 0x005238ce (forward)
    cmp cx, word ptr [esi + field_b2]            # 00523856
    jne.d8 L_005238ce                            # 0052385d
    # block 0x0052385f: entered by fall-through of jne at 0x0052385d, 33 instruction(s), calls indirect edi, indirect ebx, USER32.dll!SendMessageA, falls into the block at 0x005238ce
    push ebx                                     # 0052385f
    push edi                                     # 00523860
    mov edi, dword ptr [0x52a22c]                # 00523861
    lea ecx, [ebp - local_108]                   # 00523867
    push 0x103                                   # 0052386d
    push ecx                                     # 00523872
    push eax                                     # 00523873
    call edi                                     # 00523874
    mov ebx, dword ptr [0x52a234]                # 00523876
    lea eax, [ebp - local_108]                   # 0052387c
    push eax                                     # 00523882
    call ebx                                     # 00523883
    lea eax, [ebp - local_108]                   # 00523885
    push 0x103                                   # 0052388b
    push eax                                     # 00523890
    mov ax, word ptr [esi + field_b2]            # 00523891
    push eax                                     # 00523898
    call edi                                     # 00523899
    lea eax, [ebp - local_108]                   # 0052389b
    push eax                                     # 005238a1
    call ebx                                     # 005238a2
    movzx eax, word ptr [esi + field_b2]         # 005238a4
    movzx ecx, word ptr [esi + field_b0]         # 005238ab
    shl eax, 0x10                                # 005238b2
    {load} or eax, ecx                           # 005238b5
    push eax                                     # 005238b7
    mov eax, dword ptr [ebp - local_4]           # 005238b8
    push dword ptr [eax + field_1c]              # 005238bb
    push 0x3e4                                   # 005238be
    push dword ptr [ebp + arg_8]                 # 005238c3
    call dword ptr [0x52a4c8]                    # 005238c6
    pop edi                                      # 005238cc
    pop ebx                                      # 005238cd
L_005238ce:
    # block 0x005238ce: entered by je at 0x00523829; je at 0x00523834; je at 0x00523843; jne at 0x00523854; jne at 0x0052385d, 4 instruction(s), ends with ret 0x8
    {load} xor eax, eax                          # 005238ce
    pop esi                                      # 005238d0
    leave                                        # 005238d1
    ret 0x8                                      # 005238d2

