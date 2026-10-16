# FUN_00522d13
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522d13
# extent:       0x00522d13-0x00522d82 (111 code bytes)
# span:         0x00522d13-0x00522d82 (code 111, tables 0, padding 0)
# sha256:       c7b74888a2d94e9c373bc8f30e980007a09a6f3cc2c9e6ec310f10b4bf767b75
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522d13
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_a0, field_a4
# callees:      calls USER32.dll!IsWindow, USER32.dll!EnableWindow, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00522d13 - 0x401000
.globl FUN_00522d13
FUN_00522d13:
    # block 0x00522d13: entry, 6 instruction(s), ends with je to 0x00522d80 (forward)
    push esi                                     # 00522d13
    {load} mov esi, ecx                          # 00522d14
    mov ecx, dword ptr [esi + field_a0]          # 00522d16
    lea eax, [esi + field_a0]                    # 00522d1c
    test ecx, ecx                                # 00522d22
    je.d8 L_00522d80                             # 00522d24
    # block 0x00522d26: entered by fall-through of je at 0x00522d24, 4 instruction(s), ends with ja to 0x00522d80 (forward)
    dec ecx                                      # 00522d26
    test ecx, ecx                                # 00522d27
    mov dword ptr [eax], ecx                     # 00522d29
    ja.d8 L_00522d80                             # 00522d2b
    # block 0x00522d2d: entered by fall-through of ja at 0x00522d2b, 3 instruction(s), ends with je to 0x00522d80 (forward)
    mov eax, dword ptr [esi + field_a4]          # 00522d2d
    test eax, eax                                # 00522d33
    je.d8 L_00522d80                             # 00522d35
    # block 0x00522d37: entered by fall-through of je at 0x00522d35, 2 instruction(s), ends with je to 0x00522d6d (forward)
    cmp dword ptr [eax], 0x0                     # 00522d37
    je.d8 L_00522d6d                             # 00522d3a
    # block 0x00522d3c: entered by fall-through of je at 0x00522d3a, 2 instruction(s), falls into the block at 0x00522d3f
    push edi                                     # 00522d3c
    {load} xor edi, edi                          # 00522d3d
L_00522d3f:
    # block 0x00522d3f: entered by jne at 0x00522d6a, 4 instruction(s), calls USER32.dll!IsWindow, ends with je to 0x00522d5d (forward)
    push dword ptr [edi + eax]                   # 00522d3f
    call dword ptr [0x52a300]                    # 00522d42
    test eax, eax                                # 00522d48
    je.d8 L_00522d5d                             # 00522d4a
    # block 0x00522d4c: entered by fall-through of je at 0x00522d4a, 4 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x00522d5d
    mov eax, dword ptr [esi + field_a4]          # 00522d4c
    push 0x1                                     # 00522d52
    push dword ptr [eax + edi]                   # 00522d54
    call dword ptr [0x52a4d0]                    # 00522d57
L_00522d5d:
    # block 0x00522d5d: entered by je at 0x00522d4a, 4 instruction(s), ends with jne to 0x00522d3f (backward)
    mov eax, dword ptr [esi + field_a4]          # 00522d5d
    add edi, 0x4                                 # 00522d63
    cmp dword ptr [edi + eax], 0x0               # 00522d66
    jne.d8 L_00522d3f                            # 00522d6a
    # block 0x00522d6c: entered by fall-through of jne at 0x00522d6a, 1 instruction(s), falls into the block at 0x00522d6d
    pop edi                                      # 00522d6c
L_00522d6d:
    # block 0x00522d6d: entered by je at 0x00522d3a, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00522d80
    push dword ptr [esi + field_a4]              # 00522d6d
    call FUN_0051dc6c                            # 00522d73
    and dword ptr [esi + field_a4], 0x0          # 00522d78
    pop ecx                                      # 00522d7f
L_00522d80:
    # block 0x00522d80: entered by je at 0x00522d24; ja at 0x00522d2b; je at 0x00522d35, 2 instruction(s), ends with ret
    pop esi                                      # 00522d80
    ret                                          # 00522d81

