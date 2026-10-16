# FUN_0051ff98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ff98
# extent:       0x0051ff98-0x00520069 (209 code bytes)
# span:         0x0051ff98-0x00520069 (code 209, tables 0, padding 0)
# sha256:       75ca41999c78cc2c2296635a4df5a7accb6d75e413a93a91e517bc58cbb3da4c
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ff98
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [edi + n] field_1, field_2; [esi + n] field_5
# callees:      calls KERNEL32.dll!lstrlenA, FUN_0052658e, FUN_0050ffdd, KERNEL32.dll!lstrcpyA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 84 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)
.set FUN_0052658e, .text + (0x0052658e - 0x401000)

.org 0x0051ff98 - 0x401000
.globl FUN_0051ff98
FUN_0051ff98:
    # block 0x0051ff98: entry, 22 instruction(s), calls KERNEL32.dll!lstrlenA, FUN_0052658e, ends with jge to 0x00520062 (forward)
    push ebp                                     # 0051ff98
    {load} mov ebp, esp                          # 0051ff99
    push ecx                                     # 0051ff9b
    push ebx                                     # 0051ff9c
    push esi                                     # 0051ff9d
    push edi                                     # 0051ff9e
    mov edi, dword ptr [ebp + arg_8]             # 0051ff9f
    push edi                                     # 0051ffa2
    call dword ptr [0x52a1f8]                    # 0051ffa3
    push 0x0                                     # 0051ffa9
    push 0x0                                     # 0051ffab
    push edi                                     # 0051ffad
    {load} mov ebx, eax                          # 0051ffae
    call FUN_0052658e                            # 0051ffb0
    dec eax                                      # 0051ffb5
    {load} mov esi, ebx                          # 0051ffb6
    {load} sub esi, eax                          # 0051ffb8
    cmp dword ptr [ebp + arg_c], ebx             # 0051ffba
    mov dword ptr [ebp + arg_8], eax             # 0051ffbd
    lea ecx, [esi + edi]                         # 0051ffc0
    mov dword ptr [ebp - local_4], ecx           # 0051ffc3
    jge.d32 L_00520062                           # 0051ffc6
    # block 0x0051ffcc: entered by fall-through of jge at 0x0051ffc6, 2 instruction(s), ends with jge to 0x0051ffdf (forward)
    cmp dword ptr [ebp + arg_c], eax             # 0051ffcc
    jge.d8 L_0051ffdf                            # 0051ffcf
    # block 0x0051ffd1: entered by fall-through of jge at 0x0051ffcf, 2 instruction(s), ends with jne to 0x0051ffdc (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0051ffd1
    jne.d8 L_0051ffdc                            # 0051ffd5
    # block 0x0051ffd7: entered by fall-through of jne at 0x0051ffd5, 1 instruction(s), falls into the block at 0x0051ffdc
    mov ecx, 0x63c418                            # 0051ffd7
L_0051ffdc:
    # block 0x0051ffdc: entered by jne at 0x0051ffd5, 2 instruction(s), ends with forward jump to 0x00520023
    push ecx                                     # 0051ffdc
    jmp.d8 L_00520023                            # 0051ffdd
L_0051ffdf:
    # block 0x0051ffdf: entered by jge at 0x0051ffcf, 3 instruction(s), ends with jne to 0x0051fffd (forward)
    cmp byte ptr [edi], 0x5c                     # 0051ffdf
    lea ebx, [edi + field_2]                     # 0051ffe2
    jne.d8 L_0051fffd                            # 0051ffe5
    # block 0x0051ffe7: entered by fall-through of jne at 0x0051ffe5, 2 instruction(s), ends with jne to 0x0051fffd (forward)
    cmp byte ptr [edi + field_1], 0x5c           # 0051ffe7
    jne.d8 L_0051fffd                            # 0051ffeb
L_0051ffed:
    # block 0x0051ffed: entered by jmp at 0x0051fffb; fall-through of jne at 0x0051ffeb, 2 instruction(s), ends with je to 0x0051fffd (forward)
    cmp byte ptr [ebx], 0x5c                     # 0051ffed
    je.d8 L_0051fffd                             # 0051fff0
    # block 0x0051fff2: entered by fall-through of je at 0x0051fff0, 5 instruction(s), calls FUN_0050ffdd, ends with backward jump to 0x0051ffed
    push ebx                                     # 0051fff2
    call FUN_0050ffdd                            # 0051fff3
    pop ecx                                      # 0051fff8
    {load} mov ebx, eax                          # 0051fff9
    jmp.d8 L_0051ffed                            # 0051fffb
L_0051fffd:
    # block 0x0051fffd: entered by jne at 0x0051ffe5; jne at 0x0051ffeb; je at 0x0051fff0, 2 instruction(s), ends with jle to 0x00520010 (forward)
    cmp esi, 0x3                                 # 0051fffd
    jle.d8 L_00520010                            # 00520000
L_00520002:
    # block 0x00520002: entered by jne at 0x0052000e; fall-through of jle at 0x00520000, 6 instruction(s), calls FUN_0050ffdd, ends with jne to 0x00520002 (backward)
    push ebx                                     # 00520002
    call FUN_0050ffdd                            # 00520003
    {load} mov ebx, eax                          # 00520008
    pop ecx                                      # 0052000a
    cmp byte ptr [ebx], 0x5c                     # 0052000b
    jne.d8 L_00520002                            # 0052000e
L_00520010:
    # block 0x00520010: entered by jle at 0x00520000; fall-through of jne at 0x0052000e, 6 instruction(s), ends with jge to 0x0052002c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00520010
    {load} mov esi, ebx                          # 00520013
    {load} sub esi, edi                          # 00520015
    lea eax, [esi + eax + field_5]               # 00520017
    cmp dword ptr [ebp + arg_c], eax             # 0052001b
    jge.d8 L_0052002c                            # 0052001e
    # block 0x00520020: entered by fall-through of jge at 0x0052001e, 1 instruction(s), falls into the block at 0x00520023
    push dword ptr [ebp - local_4]               # 00520020
L_00520023:
    # block 0x00520023: entered by jmp at 0x0051ffdd, 3 instruction(s), calls KERNEL32.dll!lstrcpyA, ends with forward jump to 0x00520062
    push edi                                     # 00520023
    call dword ptr [0x52a244]                    # 00520024
    jmp.d8 L_00520062                            # 0052002a
L_0052002c:
    # block 0x0052002c: entered by jge at 0x0052001e; jmp at 0x0052004a, 5 instruction(s), calls KERNEL32.dll!lstrlenA, ends with jle to 0x0052004c (forward)
    push ebx                                     # 0052002c
    call dword ptr [0x52a1f8]                    # 0052002d
    lea eax, [eax + esi + field_4]               # 00520033
    cmp eax, dword ptr [ebp + arg_c]             # 00520037
    jle.d8 L_0052004c                            # 0052003a
L_0052003c:
    # block 0x0052003c: entered by jne at 0x00520048; fall-through of jle at 0x0052003a, 6 instruction(s), calls FUN_0050ffdd, ends with jne to 0x0052003c (backward)
    push ebx                                     # 0052003c
    call FUN_0050ffdd                            # 0052003d
    {load} mov ebx, eax                          # 00520042
    pop ecx                                      # 00520044
    cmp byte ptr [ebx], 0x5c                     # 00520045
    jne.d8 L_0052003c                            # 00520048
    # block 0x0052004a: entered by fall-through of jne at 0x00520048, 1 instruction(s), ends with backward jump to 0x0052002c
    jmp.d8 L_0052002c                            # 0052004a
L_0052004c:
    # block 0x0052004c: entered by jle at 0x0052003a, 8 instruction(s), calls indirect esi, falls into the block at 0x00520062
    and byte ptr [esi + edi], 0x0                # 0052004c
    mov esi, dword ptr [0x52a228]                # 00520050
    push 0x5300d0                                # 00520056
    push edi                                     # 0052005b
    call esi                                     # 0052005c
    push ebx                                     # 0052005e
    push edi                                     # 0052005f
    call esi                                     # 00520060
L_00520062:
    # block 0x00520062: entered by jge at 0x0051ffc6; jmp at 0x0052002a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00520062
    pop esi                                      # 00520063
    pop ebx                                      # 00520064
    leave                                        # 00520065
    ret 0xc                                      # 00520066

