# FUN_00523c57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523c57
# extent:       0x00523c57-0x00523d68 (273 code bytes)
# span:         0x00523c57-0x00523d68 (code 273, tables 0, padding 0)
# sha256:       986be93f2ceac1f0018203e60f68930964c3e644b4759abe931be9485e90b92d
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523c57
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1c, field_7c, field_d4; [ebx + n] field_24, field_50; [esi + n] field_1c, field_24, field_68, field_90, field_94
# callees:      calls FUN_0051c174, USER32.dll!SendMessageA, USER32.dll!UpdateWindow, USER32.dll!GetParent, FUN_0051abe4, USER32.dll!PostMessageA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00523d68
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_50, 0x50  # offset +0x50
.equ field_68, 0x68  # offset +0x68
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_d4, 0xd4  # offset +0xd4

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)

.org 0x00523c57 - 0x401000
.globl FUN_00523c57
FUN_00523c57:
    # block 0x00523c57: entry, 12 instruction(s), calls FUN_0051c174, ends with je to 0x00523c84 (forward)
    push ebp                                     # 00523c57
    {load} mov ebp, esp                          # 00523c58
    push ebx                                     # 00523c5a
    push esi                                     # 00523c5b
    push edi                                     # 00523c5c
    {load} mov esi, ecx                          # 00523c5d
    call FUN_0051c174                            # 00523c5f
    mov ecx, dword ptr [esi + field_68]          # 00523c64
    mov edi, dword ptr [ebp + arg_8]             # 00523c67
    test ecx, ecx                                # 00523c6a
    {load} mov ebx, eax                          # 00523c6c
    je.d8 L_00523c84                             # 00523c6e
    # block 0x00523c70: entered by fall-through of je at 0x00523c6e, 7 instruction(s), calls indirect dword ptr [eax + 0x7c], ends with jne to 0x00523d61 (forward)
    push dword ptr [ebp + arg_10]                # 00523c70
    mov eax, dword ptr [ecx]                     # 00523c73
    push dword ptr [ebp + arg_c]                 # 00523c75
    push edi                                     # 00523c78
    call dword ptr [eax + field_7c]              # 00523c79
    test eax, eax                                # 00523c7c
    jne.d32 L_00523d61                           # 00523c7e
L_00523c84:
    # block 0x00523c84: entered by je at 0x00523c6e; fall-through of jne at 0x00523c7e, 2 instruction(s), ends with jne to 0x00523cdc (forward)
    cmp dword ptr [ebp + arg_c], 0xffff          # 00523c84
    jne.d8 L_00523cdc                            # 00523c8b
    # block 0x00523c8d: entered by fall-through of jne at 0x00523c8b, 3 instruction(s), ends with jne to 0x00523ca3 (forward)
    and dword ptr [esi + field_24], -0x41        # 00523c8d
    cmp dword ptr [ebx + field_50], 0x0          # 00523c91
    jne.d8 L_00523ca3                            # 00523c95
    # block 0x00523c97: entered by fall-through of jne at 0x00523c95, 2 instruction(s), ends with forward jump to 0x00523cad
    mov dword ptr [esi + field_90], 0xe001       # 00523c97
    jmp.d8 L_00523cad                            # 00523ca1
L_00523ca3:
    # block 0x00523ca3: entered by jne at 0x00523c95, 1 instruction(s), falls into the block at 0x00523cad
    mov dword ptr [esi + field_90], 0xe002       # 00523ca3
L_00523cad:
    # block 0x00523cad: entered by jmp at 0x00523ca1, 10 instruction(s), calls USER32.dll!SendMessageA, indirect dword ptr [eax + 0xd4], ends with je to 0x00523d2e (forward)
    push 0x0                                     # 00523cad
    push dword ptr [esi + field_90]              # 00523caf
    push 0x362                                   # 00523cb5
    push dword ptr [esi + field_1c]              # 00523cba
    call dword ptr [0x52a4c8]                    # 00523cbd
    mov eax, dword ptr [esi]                     # 00523cc3
    {load} mov ecx, esi                          # 00523cc5
    call dword ptr [eax + field_d4]              # 00523cc7
    test eax, eax                                # 00523ccd
    je.d8 L_00523d2e                             # 00523ccf
    # block 0x00523cd1: entered by fall-through of je at 0x00523ccf, 3 instruction(s), calls USER32.dll!UpdateWindow, ends with forward jump to 0x00523d2e
    push dword ptr [eax + field_1c]              # 00523cd1
    call dword ptr [0x52a49c]                    # 00523cd4
    jmp.d8 L_00523d2e                            # 00523cda
L_00523cdc:
    # block 0x00523cdc: entered by jne at 0x00523c8b, 2 instruction(s), ends with je to 0x00523d23 (forward)
    test edi, edi                                # 00523cdc
    je.d8 L_00523d23                             # 00523cde
    # block 0x00523ce0: entered by fall-through of je at 0x00523cde, 2 instruction(s), ends with jne to 0x00523d23 (forward)
    test word ptr [ebp + arg_c], 0x810           # 00523ce0
    jne.d8 L_00523d23                            # 00523ce6
    # block 0x00523ce8: entered by fall-through of jne at 0x00523ce6, 2 instruction(s), ends with jb to 0x00523d0f (forward)
    cmp edi, 0xf000                              # 00523ce8
    jb.d8 L_00523d0f                             # 00523cee
    # block 0x00523cf0: entered by fall-through of jb at 0x00523cee, 2 instruction(s), ends with jae to 0x00523d0f (forward)
    cmp edi, 0xf1f0                              # 00523cf0
    jae.d8 L_00523d0f                            # 00523cf6
    # block 0x00523cf8: entered by fall-through of jae at 0x00523cf6, 3 instruction(s), falls into the block at 0x00523d07
    add edi, 0xffff1000                          # 00523cf8
    shr edi, 0x4                                 # 00523cfe
    add edi, 0xef00                              # 00523d01
L_00523d07:
    # block 0x00523d07: entered by jb at 0x00523d15, 2 instruction(s), ends with forward jump to 0x00523d2a
    mov dword ptr [esi + field_90], edi          # 00523d07
    jmp.d8 L_00523d2a                            # 00523d0d
L_00523d0f:
    # block 0x00523d0f: entered by jb at 0x00523cee; jae at 0x00523cf6, 2 instruction(s), ends with jb to 0x00523d07 (backward)
    cmp edi, 0xff00                              # 00523d0f
    jb.d8 L_00523d07                             # 00523d15
    # block 0x00523d17: entered by fall-through of jb at 0x00523d15, 2 instruction(s), ends with forward jump to 0x00523d2a
    mov dword ptr [esi + field_90], 0xef1f       # 00523d17
    jmp.d8 L_00523d2a                            # 00523d21
L_00523d23:
    # block 0x00523d23: entered by je at 0x00523cde; jne at 0x00523ce6, 1 instruction(s), falls into the block at 0x00523d2a
    and dword ptr [esi + field_90], 0x0          # 00523d23
L_00523d2a:
    # block 0x00523d2a: entered by jmp at 0x00523d0d; jmp at 0x00523d21, 1 instruction(s), falls into the block at 0x00523d2e
    or dword ptr [ebx + field_24], 0x40          # 00523d2a
L_00523d2e:
    # block 0x00523d2e: entered by je at 0x00523ccf; jmp at 0x00523cda, 3 instruction(s), ends with je to 0x00523d61 (forward)
    mov eax, dword ptr [esi + field_90]          # 00523d2e
    cmp eax, dword ptr [esi + field_94]          # 00523d34
    je.d8 L_00523d61                             # 00523d3a
    # block 0x00523d3c: entered by fall-through of je at 0x00523d3a, 6 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, ends with je to 0x00523d61 (forward)
    push dword ptr [esi + field_1c]              # 00523d3c
    call dword ptr [0x52a3dc]                    # 00523d3f
    push eax                                     # 00523d45
    call FUN_0051abe4                            # 00523d46
    test eax, eax                                # 00523d4b
    je.d8 L_00523d61                             # 00523d4d
    # block 0x00523d4f: entered by fall-through of je at 0x00523d4d, 5 instruction(s), calls USER32.dll!PostMessageA, falls into the block at 0x00523d61
    push 0x0                                     # 00523d4f
    push 0x0                                     # 00523d51
    push 0x36a                                   # 00523d53
    push dword ptr [esi + field_1c]              # 00523d58
    call dword ptr [0x52a31c]                    # 00523d5b
L_00523d61:
    # block 0x00523d61: entered by jne at 0x00523c7e; je at 0x00523d3a; je at 0x00523d4d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00523d61
    pop esi                                      # 00523d62
    pop ebx                                      # 00523d63
    pop ebp                                      # 00523d64
    ret 0xc                                      # 00523d65

