# FUN_00484935
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484935
# extent:       0x00484935-0x00484ac0 (395 code bytes)
# span:         0x00484935-0x00484ac0 (code 395, tables 0, padding 0)
# sha256:       5eea9362fc92307b461fc2ac854f414992eba0b1233a8e84eb0023ba0382b022
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         set_layer
# naming:       native port src/action_family_ea_runtime.c:set_layer (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with set_layer (last-match-wins layer table). Native hits[20] overflows like the original beyond 20 pieces; body validation prevents it (K2, unreachable).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_30, local_34, local_38, local_3c, local_3e
# fields:       [eax + n] field_26, field_56; [ecx + n] field_21, field_28, field_57; [edx + n] field_21
# callees:      calls FUN_00484762
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:set_layer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 118 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_3e, 0x3e  # offset -0x3e
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_56, 0x56  # offset +0x56
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------
.set FUN_00484762, .text + (0x00484762 - 0x401000)

.org 0x00484935 - 0x401000
.globl FUN_00484935
FUN_00484935:
    # block 0x00484935: entry, 21 instruction(s), ends with je to 0x004849c6 (forward)
    push ebp                                     # 00484935
    {load} mov ebp, esp                          # 00484936
    sub esp, 0x40                                # 00484938
    push edi                                     # 0048493b
    mov dword ptr [ebp - local_3c], ecx          # 0048493c
    mov word ptr [ebp - local_4], 0x0            # 0048493f
    mov eax, dword ptr [ebp - local_3c]          # 00484945
    movsx ecx, word ptr [eax + field_26]         # 00484948
    imul ecx, ecx, 0x8d                          # 0048494c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00484952
    mov dword ptr [ebp - local_34], edx          # 00484958
    movsx eax, word ptr [ebp + arg_8]            # 0048495b
    imul eax, eax, 0x85                          # 0048495f
    mov ecx, dword ptr [ebp - local_3c]          # 00484965
    lea edx, [ecx + eax + field_28]              # 00484968
    mov dword ptr [ebp - local_38], edx          # 0048496c
    mov eax, dword ptr [ebp - local_34]          # 0048496f
    {load} xor ecx, ecx                          # 00484972
    mov cl, byte ptr [eax + field_56]            # 00484974
    test ecx, ecx                                # 00484977
    je.d8 L_004849c6                             # 00484979
    # block 0x0048497b: entered by fall-through of je at 0x00484979, 2 instruction(s), ends with forward jump to 0x0048498f
    mov word ptr [ebp - local_8], 0x0            # 0048497b
    jmp.d8 L_0048498f                            # 00484981
L_00484983:
    # block 0x00484983: entered by jmp at 0x004849bf, 3 instruction(s), falls into the block at 0x0048498f
    mov dx, word ptr [ebp - local_8]             # 00484983
    add dx, 0x1                                  # 00484987
    mov word ptr [ebp - local_8], dx             # 0048498b
L_0048498f:
    # block 0x0048498f: entered by jmp at 0x00484981, 5 instruction(s), ends with jge to 0x004849c1 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048498f
    mov ecx, dword ptr [ebp - local_34]          # 00484993
    movsx edx, word ptr [ecx + field_21]         # 00484996
    {load} cmp eax, edx                          # 0048499a
    jge.d8 L_004849c1                            # 0048499c
    # block 0x0048499e: entered by fall-through of jge at 0x0048499c, 7 instruction(s), ends with jne to 0x004849bf (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048499e
    mov ecx, dword ptr [ebp - local_34]          # 004849a2
    movsx edx, word ptr [ecx + 2*eax + field_57] # 004849a5
    movsx eax, word ptr [ebp + arg_8]            # 004849aa
    add eax, 0x1                                 # 004849ae
    {load} cmp edx, eax                          # 004849b1
    jne.d8 L_004849bf                            # 004849b3
    # block 0x004849b5: entered by fall-through of jne at 0x004849b3, 3 instruction(s), falls into the block at 0x004849bf
    mov ecx, dword ptr [ebp - local_38]          # 004849b5
    mov dx, word ptr [ebp - local_8]             # 004849b8
    mov word ptr [ecx], dx                       # 004849bc
L_004849bf:
    # block 0x004849bf: entered by jne at 0x004849b3, 1 instruction(s), ends with backward jump to 0x00484983
    jmp.d8 L_00484983                            # 004849bf
L_004849c1:
    # block 0x004849c1: entered by jge at 0x0048499c, 1 instruction(s), ends with forward jump to 0x00484ab9
    jmp.d32 L_00484ab9                           # 004849c1
L_004849c6:
    # block 0x004849c6: entered by je at 0x00484979, 6 instruction(s), ends with forward jump to 0x004849e7
    mov ecx, 0xa                                 # 004849c6
    or eax, -0x1                                 # 004849cb
    lea edi, [ebp - local_30]                    # 004849ce
    rep stosd dword ptr es:[edi], eax            # 004849d1
    mov word ptr [ebp - local_8], 0x0            # 004849d3
    jmp.d8 L_004849e7                            # 004849d9
L_004849db:
    # block 0x004849db: entered by jmp at 0x00484a02; jmp at 0x00484a33, 3 instruction(s), falls into the block at 0x004849e7
    mov ax, word ptr [ebp - local_8]             # 004849db
    .insn 0x66, 0x05, 0x0001{:u16}               # 004849df
    mov word ptr [ebp - local_8], ax             # 004849e3
L_004849e7:
    # block 0x004849e7: entered by jmp at 0x004849d9, 5 instruction(s), ends with jge to 0x00484a35 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004849e7
    mov edx, dword ptr [ebp - local_34]          # 004849eb
    movsx eax, word ptr [edx + field_21]         # 004849ee
    {load} cmp ecx, eax                          # 004849f2
    jge.d8 L_00484a35                            # 004849f4
    # block 0x004849f6: entered by fall-through of jge at 0x004849f4, 4 instruction(s), ends with jne to 0x00484a04 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004849f6
    movsx edx, word ptr [ebp + arg_8]            # 004849fa
    {load} cmp ecx, edx                          # 004849fe
    jne.d8 L_00484a04                            # 00484a00
    # block 0x00484a02: entered by fall-through of jne at 0x00484a00, 1 instruction(s), ends with backward jump to 0x004849db
    jmp.d8 L_004849db                            # 00484a02
L_00484a04:
    # block 0x00484a04: entered by jne at 0x00484a00, 8 instruction(s), calls FUN_00484762, ends with je to 0x00484a33 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00484a04
    push eax                                     # 00484a08
    movsx ecx, word ptr [ebp + arg_8]            # 00484a09
    push ecx                                     # 00484a0d
    mov ecx, dword ptr [ebp - local_3c]          # 00484a0e
    call FUN_00484762                            # 00484a11
    test eax, eax                                # 00484a16
    je.d8 L_00484a33                             # 00484a18
    # block 0x00484a1a: entered by fall-through of je at 0x00484a18, 6 instruction(s), falls into the block at 0x00484a33
    movsx edx, word ptr [ebp - local_4]          # 00484a1a
    mov ax, word ptr [ebp - local_8]             # 00484a1e
    mov word ptr [ebp + 2*edx - local_30], ax    # 00484a22
    mov cx, word ptr [ebp - local_4]             # 00484a27
    add cx, 0x1                                  # 00484a2b
    mov word ptr [ebp - local_4], cx             # 00484a2f
L_00484a33:
    # block 0x00484a33: entered by je at 0x00484a18, 1 instruction(s), ends with backward jump to 0x004849db
    jmp.d8 L_004849db                            # 00484a33
L_00484a35:
    # block 0x00484a35: entered by jge at 0x004849f4, 2 instruction(s), ends with forward jump to 0x00484a49
    mov word ptr [ebp - local_8], 0x0            # 00484a35
    jmp.d8 L_00484a49                            # 00484a3b
L_00484a3d:
    # block 0x00484a3d: entered by jmp at 0x00484aa7, 3 instruction(s), falls into the block at 0x00484a49
    mov dx, word ptr [ebp - local_8]             # 00484a3d
    add dx, 0x1                                  # 00484a41
    mov word ptr [ebp - local_8], dx             # 00484a45
L_00484a49:
    # block 0x00484a49: entered by jmp at 0x00484a3b, 4 instruction(s), ends with jge to 0x00484aa9 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00484a49
    movsx ecx, word ptr [ebp - local_4]          # 00484a4d
    {load} cmp eax, ecx                          # 00484a51
    jge.d8 L_00484aa9                            # 00484a53
    # block 0x00484a55: entered by fall-through of jge at 0x00484a53, 9 instruction(s), ends with jle to 0x00484a82 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00484a55
    movsx eax, word ptr [edx]                    # 00484a58
    movsx ecx, word ptr [ebp - local_8]          # 00484a5b
    movsx edx, word ptr [ebp + 2*ecx - local_30] # 00484a5f
    imul edx, edx, 0x85                          # 00484a64
    mov ecx, dword ptr [ebp - local_3c]          # 00484a6a
    movsx edx, word ptr [ecx + edx + field_28]   # 00484a6d
    {load} cmp eax, edx                          # 00484a72
    jle.d8 L_00484a82                            # 00484a74
    # block 0x00484a76: entered by fall-through of jle at 0x00484a74, 4 instruction(s), ends with forward jump to 0x00484a9d
    mov eax, dword ptr [ebp - local_38]          # 00484a76
    mov cx, word ptr [eax]                       # 00484a79
    mov word ptr [ebp - local_3e], cx            # 00484a7c
    jmp.d8 L_00484a9d                            # 00484a80
L_00484a82:
    # block 0x00484a82: entered by jle at 0x00484a74, 6 instruction(s), falls into the block at 0x00484a9d
    movsx edx, word ptr [ebp - local_8]          # 00484a82
    movsx eax, word ptr [ebp + 2*edx - local_30] # 00484a86
    imul eax, eax, 0x85                          # 00484a8b
    mov ecx, dword ptr [ebp - local_3c]          # 00484a91
    mov dx, word ptr [ecx + eax + field_28]      # 00484a94
    mov word ptr [ebp - local_3e], dx            # 00484a99
L_00484a9d:
    # block 0x00484a9d: entered by jmp at 0x00484a80, 4 instruction(s), ends with backward jump to 0x00484a3d
    mov eax, dword ptr [ebp - local_38]          # 00484a9d
    mov cx, word ptr [ebp - local_3e]            # 00484aa0
    mov word ptr [eax], cx                       # 00484aa4
    jmp.d8 L_00484a3d                            # 00484aa7
L_00484aa9:
    # block 0x00484aa9: entered by jge at 0x00484a53, 5 instruction(s), falls into the block at 0x00484ab9
    mov edx, dword ptr [ebp - local_38]          # 00484aa9
    mov ax, word ptr [edx]                       # 00484aac
    .insn 0x66, 0x05, 0x0001{:u16}               # 00484aaf
    mov ecx, dword ptr [ebp - local_38]          # 00484ab3
    mov word ptr [ecx], ax                       # 00484ab6
L_00484ab9:
    # block 0x00484ab9: entered by jmp at 0x004849c1, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 00484ab9
    {load} mov esp, ebp                          # 00484aba
    pop ebp                                      # 00484abc
    ret 0x4                                      # 00484abd

