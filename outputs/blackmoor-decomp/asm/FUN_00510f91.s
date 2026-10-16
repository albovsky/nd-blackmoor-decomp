# FUN_00510f91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510f91
# extent:       0x00510f91-0x005110a9 (280 code bytes)
# span:         0x00510f91-0x005110a9 (code 280, tables 0, padding 0)
# sha256:       490fcf0868cfef7bde1f4f7a660d69c8a3e7b4c15d740e1c84f07e7d15a209a1
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510f91
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1, field_4; [esi + n] field_4, field_8, field_c, field_10, field_18
# callees:      calls FUN_005166ab, FUN_00516667, FUN_005132c9, FUN_00512178
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 106 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00512178, .text + (0x00512178 - 0x401000)
.set FUN_005132c9, .text + (0x005132c9 - 0x401000)
.set FUN_00516667, .text + (0x00516667 - 0x401000)
.set FUN_005166ab, .text + (0x005166ab - 0x401000)

.org 0x00510f91 - 0x401000
.globl FUN_00510f91
FUN_00510f91:
    # block 0x00510f91: entry, 9 instruction(s), ends with je to 0x0051109d (forward)
    push ebp                                     # 00510f91
    {load} mov ebp, esp                          # 00510f92
    push ebx                                     # 00510f94
    push esi                                     # 00510f95
    mov esi, dword ptr [ebp + arg_c]             # 00510f96
    mov eax, dword ptr [esi + field_c]           # 00510f99
    mov ebx, dword ptr [esi + field_10]          # 00510f9c
    test al, -0x7e                               # 00510f9f
    je.d32 L_0051109d                            # 00510fa1
    # block 0x00510fa7: entered by fall-through of je at 0x00510fa1, 2 instruction(s), ends with jne to 0x0051109d (forward)
    test al, 0x40                                # 00510fa7
    jne.d32 L_0051109d                           # 00510fa9
    # block 0x00510faf: entered by fall-through of jne at 0x00510fa9, 2 instruction(s), ends with je to 0x00510fc9 (forward)
    test al, 0x1                                 # 00510faf
    je.d8 L_00510fc9                             # 00510fb1
    # block 0x00510fb3: entered by fall-through of je at 0x00510fb1, 3 instruction(s), ends with je to 0x0051109d (forward)
    and dword ptr [esi + field_4], 0x0           # 00510fb3
    test al, 0x10                                # 00510fb7
    je.d32 L_0051109d                            # 00510fb9
    # block 0x00510fbf: entered by fall-through of je at 0x00510fb9, 4 instruction(s), falls into the block at 0x00510fc9
    mov ecx, dword ptr [esi + field_8]           # 00510fbf
    and al, -0x2                                 # 00510fc2
    mov dword ptr [esi], ecx                     # 00510fc4
    mov dword ptr [esi + field_c], eax           # 00510fc6
L_00510fc9:
    # block 0x00510fc9: entered by je at 0x00510fb1, 8 instruction(s), ends with jne to 0x00511003 (forward)
    mov eax, dword ptr [esi + field_c]           # 00510fc9
    and dword ptr [esi + field_4], 0x0           # 00510fcc
    and dword ptr [ebp + arg_c], 0x0             # 00510fd0
    and al, -0x11                                # 00510fd4
    or al, 0x2                                   # 00510fd6
    test ax, 0x10c                               # 00510fd8
    mov dword ptr [esi + field_c], eax           # 00510fdc
    jne.d8 L_00511003                            # 00510fdf
    # block 0x00510fe1: entered by fall-through of jne at 0x00510fdf, 2 instruction(s), ends with je to 0x00510ff1 (forward)
    cmp esi, 0x568450                            # 00510fe1
    je.d8 L_00510ff1                             # 00510fe7
    # block 0x00510fe9: entered by fall-through of je at 0x00510fe7, 2 instruction(s), ends with jne to 0x00510ffc (forward)
    cmp esi, 0x568470                            # 00510fe9
    jne.d8 L_00510ffc                            # 00510fef
L_00510ff1:
    # block 0x00510ff1: entered by je at 0x00510fe7; fall-through of jne at 0x00510fef, 5 instruction(s), calls FUN_005166ab, ends with jne to 0x00511003 (forward)
    push ebx                                     # 00510ff1
    call FUN_005166ab                            # 00510ff2
    test eax, eax                                # 00510ff7
    pop ecx                                      # 00510ff9
    jne.d8 L_00511003                            # 00510ffa
L_00510ffc:
    # block 0x00510ffc: entered by jne at 0x00510fef; fall-through of jne at 0x00510ffa, 3 instruction(s), calls FUN_00516667, falls into the block at 0x00511003
    push esi                                     # 00510ffc
    call FUN_00516667                            # 00510ffd
    pop ecx                                      # 00511002
L_00511003:
    # block 0x00511003: entered by jne at 0x00510fdf; jne at 0x00510ffa, 3 instruction(s), ends with je to 0x00511073 (forward)
    test word ptr [esi + field_c], 0x108         # 00511003
    push edi                                     # 00511009
    je.d8 L_00511073                             # 0051100a
    # block 0x0051100c: entered by fall-through of je at 0x0051100a, 10 instruction(s), ends with jle to 0x00511033 (forward)
    mov eax, dword ptr [esi + field_8]           # 0051100c
    mov edi, dword ptr [esi]                     # 0051100f
    {load} sub edi, eax                          # 00511011
    lea ecx, [eax + field_1]                     # 00511013
    mov dword ptr [esi], ecx                     # 00511016
    mov ecx, dword ptr [esi + field_18]          # 00511018
    dec ecx                                      # 0051101b
    test edi, edi                                # 0051101c
    mov dword ptr [esi + field_4], ecx           # 0051101e
    jle.d8 L_00511033                            # 00511021
    # block 0x00511023: entered by fall-through of jle at 0x00511021, 7 instruction(s), calls FUN_005132c9, ends with forward jump to 0x00511069
    push edi                                     # 00511023
    push eax                                     # 00511024
    push ebx                                     # 00511025
    call FUN_005132c9                            # 00511026
    add esp, 0xc                                 # 0051102b
    mov dword ptr [ebp + arg_c], eax             # 0051102e
    jmp.d8 L_00511069                            # 00511031
L_00511033:
    # block 0x00511033: entered by jle at 0x00511021, 2 instruction(s), ends with je to 0x00511051 (forward)
    cmp ebx, -0x1                                # 00511033
    je.d8 L_00511051                             # 00511036
    # block 0x00511038: entered by fall-through of je at 0x00511036, 8 instruction(s), ends with forward jump to 0x00511056
    {load} mov ecx, ebx                          # 00511038
    {load} mov eax, ebx                          # 0051103a
    sar ecx, 0x5                                 # 0051103c
    and eax, 0x1f                                # 0051103f
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00511042
    lea eax, [eax + 8*eax]                       # 00511049
    lea eax, [ecx + 4*eax]                       # 0051104c
    jmp.d8 L_00511056                            # 0051104f
L_00511051:
    # block 0x00511051: entered by je at 0x00511036, 1 instruction(s), falls into the block at 0x00511056
    mov eax, 0x568880                            # 00511051
L_00511056:
    # block 0x00511056: entered by jmp at 0x0051104f, 2 instruction(s), ends with je to 0x00511069 (forward)
    test byte ptr [eax + field_4], 0x20          # 00511056
    je.d8 L_00511069                             # 0051105a
    # block 0x0051105c: entered by fall-through of je at 0x0051105a, 5 instruction(s), calls FUN_00512178, falls into the block at 0x00511069
    push 0x2                                     # 0051105c
    push 0x0                                     # 0051105e
    push ebx                                     # 00511060
    call FUN_00512178                            # 00511061
    add esp, 0xc                                 # 00511066
L_00511069:
    # block 0x00511069: entered by jmp at 0x00511031; je at 0x0051105a, 4 instruction(s), ends with forward jump to 0x00511087
    mov eax, dword ptr [esi + field_8]           # 00511069
    mov cl, byte ptr [ebp + arg_8]               # 0051106c
    mov byte ptr [eax], cl                       # 0051106f
    jmp.d8 L_00511087                            # 00511071
L_00511073:
    # block 0x00511073: entered by je at 0x0051100a, 9 instruction(s), calls FUN_005132c9, falls into the block at 0x00511087
    push 0x1                                     # 00511073
    lea eax, [ebp + arg_8]                       # 00511075
    pop edi                                      # 00511078
    push edi                                     # 00511079
    push eax                                     # 0051107a
    push ebx                                     # 0051107b
    call FUN_005132c9                            # 0051107c
    add esp, 0xc                                 # 00511081
    mov dword ptr [ebp + arg_c], eax             # 00511084
L_00511087:
    # block 0x00511087: entered by jmp at 0x00511071, 3 instruction(s), ends with je to 0x00511093 (forward)
    cmp dword ptr [ebp + arg_c], edi             # 00511087
    pop edi                                      # 0051108a
    je.d8 L_00511093                             # 0051108b
    # block 0x0051108d: entered by fall-through of je at 0x0051108b, 2 instruction(s), ends with forward jump to 0x005110a2
    or dword ptr [esi + field_c], 0x20           # 0051108d
    jmp.d8 L_005110a2                            # 00511091
L_00511093:
    # block 0x00511093: entered by je at 0x0051108b, 3 instruction(s), ends with forward jump to 0x005110a5
    mov eax, dword ptr [ebp + arg_8]             # 00511093
    and eax, 0xff                                # 00511096
    jmp.d8 L_005110a5                            # 0051109b
L_0051109d:
    # block 0x0051109d: entered by je at 0x00510fa1; jne at 0x00510fa9; je at 0x00510fb9, 2 instruction(s), falls into the block at 0x005110a2
    or al, 0x20                                  # 0051109d
    mov dword ptr [esi + field_c], eax           # 0051109f
L_005110a2:
    # block 0x005110a2: entered by jmp at 0x00511091, 1 instruction(s), falls into the block at 0x005110a5
    or eax, -0x1                                 # 005110a2
L_005110a5:
    # block 0x005110a5: entered by jmp at 0x0051109b, 4 instruction(s), ends with ret
    pop esi                                      # 005110a5
    pop ebx                                      # 005110a6
    pop ebp                                      # 005110a7
    ret                                          # 005110a8

