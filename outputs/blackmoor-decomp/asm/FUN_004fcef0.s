# FUN_004fcef0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcef0
# extent:       0x004fcef0-0x004fcfe8 (248 code bytes)
# span:         0x004fcef0-0x004fcff0 (code 248, tables 0, padding 8)
# sha256:       f0d138a8e9cf9a70728bed4479b2aa81d62f1b6c5bd53ecb1eb41bd44312028c
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcef0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_18, field_34, field_38, field_3c, field_40, field_44, field_48, field_4c, field_74, field_1da, field_242, field_2b6; [esp + n] stk_8
# callees:      calls FUN_004fef10, FUN_004ff310, FUN_0050b330, FUN_004fe700, FUN_004fe660, FUN_0050e936, FUN_0050b4d0; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 95 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_74, 0x74  # offset +0x74
.equ field_1da, 0x1da  # offset +0x1da
.equ field_242, 0x242  # offset +0x242
.equ field_2b6, 0x2b6  # offset +0x2b6

# --- external targets -----------------------------------------------
.set FUN_004fe660, .text + (0x004fe660 - 0x401000)
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_004fef10, .text + (0x004fef10 - 0x401000)
.set FUN_004ff310, .text + (0x004ff310 - 0x401000)
.set FUN_0050b330, .text + (0x0050b330 - 0x401000)
.set FUN_0050b4d0, .text + (0x0050b4d0 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004fcef0 - 0x401000
.globl FUN_004fcef0
FUN_004fcef0:
    # block 0x004fcef0: entry, 4 instruction(s), ends with je to 0x004fcfe4 (forward)
    push edi                                     # 004fcef0
    mov edi, dword ptr [esp + stk_8]             # 004fcef1
    test edi, edi                                # 004fcef5
    je.d32 L_004fcfe4                            # 004fcef7
    # block 0x004fcefd: entered by fall-through of je at 0x004fcef7, 13 instruction(s), calls FUN_004fef10, FUN_004ff310, FUN_0050b330, ends with je to 0x004fcf7d (forward)
    lea eax, [edi + field_242]                   # 004fcefd
    push eax                                     # 004fcf03
    call FUN_004fef10                            # 004fcf04
    lea ecx, [edi + field_1da]                   # 004fcf09
    push ecx                                     # 004fcf0f
    call FUN_004ff310                            # 004fcf10
    lea edx, [edi + field_74]                    # 004fcf15
    push edx                                     # 004fcf18
    call FUN_0050b330                            # 004fcf19
    mov eax, dword ptr [edi + field_48]          # 004fcf1e
    add esp, 0xc                                 # 004fcf21
    test eax, eax                                # 004fcf24
    je.d8 L_004fcf7d                             # 004fcf26
    # block 0x004fcf28: entered by fall-through of je at 0x004fcf26, 3 instruction(s), ends with je to 0x004fcf7d (forward)
    mov eax, dword ptr [edi + field_34]          # 004fcf28
    test eax, eax                                # 004fcf2b
    je.d8 L_004fcf7d                             # 004fcf2d
    # block 0x004fcf2f: entered by fall-through of je at 0x004fcf2d, 4 instruction(s), ends with jle to 0x004fcf67 (forward)
    push ebp                                     # 004fcf2f
    {load} xor ebp, ebp                          # 004fcf30
    test eax, eax                                # 004fcf32
    jle.d8 L_004fcf67                            # 004fcf34
    # block 0x004fcf36: entered by fall-through of jle at 0x004fcf34, 4 instruction(s), falls into the block at 0x004fcf3c
    push ebx                                     # 004fcf36
    push esi                                     # 004fcf37
    {load} xor ebx, ebx                          # 004fcf38
    {load} xor esi, esi                          # 004fcf3a
L_004fcf3c:
    # block 0x004fcf3c: entered by jl at 0x004fcf63, 16 instruction(s), calls FUN_004fe700, FUN_004fe660, ends with jl to 0x004fcf3c (backward)
    mov ecx, dword ptr [edi + field_48]          # 004fcf3c
    {load} mov eax, esi                          # 004fcf3f
    {load} add eax, ecx                          # 004fcf41
    push eax                                     # 004fcf43
    call FUN_004fe700                            # 004fcf44
    mov ecx, dword ptr [edi + field_4c]          # 004fcf49
    {load} add ecx, ebx                          # 004fcf4c
    push ecx                                     # 004fcf4e
    call FUN_004fe660                            # 004fcf4f
    mov eax, dword ptr [edi + field_34]          # 004fcf54
    add esp, 0x8                                 # 004fcf57
    inc ebp                                      # 004fcf5a
    add esi, 0x20                                # 004fcf5b
    add ebx, 0x10                                # 004fcf5e
    {load} cmp ebp, eax                          # 004fcf61
    jl.d8 L_004fcf3c                             # 004fcf63
    # block 0x004fcf65: entered by fall-through of jl at 0x004fcf63, 2 instruction(s), falls into the block at 0x004fcf67
    pop esi                                      # 004fcf65
    pop ebx                                      # 004fcf66
L_004fcf67:
    # block 0x004fcf67: entered by jle at 0x004fcf34, 8 instruction(s), calls FUN_0050e936, falls into the block at 0x004fcf7d
    mov edx, dword ptr [edi + field_48]          # 004fcf67
    push edx                                     # 004fcf6a
    call FUN_0050e936                            # 004fcf6b
    mov eax, dword ptr [edi + field_4c]          # 004fcf70
    push eax                                     # 004fcf73
    call FUN_0050e936                            # 004fcf74
    add esp, 0x8                                 # 004fcf79
    pop ebp                                      # 004fcf7c
L_004fcf7d:
    # block 0x004fcf7d: entered by je at 0x004fcf26; je at 0x004fcf2d, 3 instruction(s), ends with je to 0x004fcf8d (forward)
    mov eax, dword ptr [edi + field_3c]          # 004fcf7d
    test eax, eax                                # 004fcf80
    je.d8 L_004fcf8d                             # 004fcf82
    # block 0x004fcf84: entered by fall-through of je at 0x004fcf82, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fcf8d
    push eax                                     # 004fcf84
    call FUN_0050e936                            # 004fcf85
    add esp, 0x4                                 # 004fcf8a
L_004fcf8d:
    # block 0x004fcf8d: entered by je at 0x004fcf82, 3 instruction(s), ends with je to 0x004fcf9d (forward)
    mov eax, dword ptr [edi + field_44]          # 004fcf8d
    test eax, eax                                # 004fcf90
    je.d8 L_004fcf9d                             # 004fcf92
    # block 0x004fcf94: entered by fall-through of je at 0x004fcf92, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fcf9d
    push eax                                     # 004fcf94
    call FUN_0050e936                            # 004fcf95
    add esp, 0x4                                 # 004fcf9a
L_004fcf9d:
    # block 0x004fcf9d: entered by je at 0x004fcf92, 3 instruction(s), ends with je to 0x004fcfad (forward)
    mov eax, dword ptr [edi + field_40]          # 004fcf9d
    test eax, eax                                # 004fcfa0
    je.d8 L_004fcfad                             # 004fcfa2
    # block 0x004fcfa4: entered by fall-through of je at 0x004fcfa2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fcfad
    push eax                                     # 004fcfa4
    call FUN_0050e936                            # 004fcfa5
    add esp, 0x4                                 # 004fcfaa
L_004fcfad:
    # block 0x004fcfad: entered by je at 0x004fcfa2, 3 instruction(s), ends with je to 0x004fcfbd (forward)
    mov eax, dword ptr [edi + field_38]          # 004fcfad
    test eax, eax                                # 004fcfb0
    je.d8 L_004fcfbd                             # 004fcfb2
    # block 0x004fcfb4: entered by fall-through of je at 0x004fcfb2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fcfbd
    push eax                                     # 004fcfb4
    call FUN_0050e936                            # 004fcfb5
    add esp, 0x4                                 # 004fcfba
L_004fcfbd:
    # block 0x004fcfbd: entered by je at 0x004fcfb2, 7 instruction(s), calls FUN_0050b4d0, ends with je to 0x004fcfd9 (forward)
    lea ecx, [edi + field_18]                    # 004fcfbd
    push ecx                                     # 004fcfc0
    call FUN_0050b4d0                            # 004fcfc1
    mov eax, dword ptr [edi]                     # 004fcfc6
    add esp, 0x4                                 # 004fcfc8
    test eax, eax                                # 004fcfcb
    je.d8 L_004fcfd9                             # 004fcfcd
    # block 0x004fcfcf: entered by fall-through of je at 0x004fcfcd, 3 instruction(s), calls indirect dword ptr [edi + 0x2b6], falls into the block at 0x004fcfd9
    push eax                                     # 004fcfcf
    call dword ptr [edi + field_2b6]             # 004fcfd0
    add esp, 0x4                                 # 004fcfd6
L_004fcfd9:
    # block 0x004fcfd9: entered by je at 0x004fcfcd, 4 instruction(s), falls into the block at 0x004fcfe4
    mov ecx, 0xaf                                # 004fcfd9
    {load} xor eax, eax                          # 004fcfde
    rep stosd dword ptr es:[edi], eax            # 004fcfe0
    stosw word ptr es:[edi], ax                  # 004fcfe2
L_004fcfe4:
    # block 0x004fcfe4: entered by je at 0x004fcef7, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 004fcfe4
    pop edi                                      # 004fcfe6
    ret                                          # 004fcfe7

# --- data items (not part of the function) -------------------------
.org 0x004fcfe8 - 0x401000
PAD_004fcfe8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

