# FUN_00512f53
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512f53
# extent:       0x00512f53-0x0051301e (203 code bytes)
# span:         0x00512f53-0x00513020 (code 203, tables 0, padding 2)
# sha256:       050cd26c675f4bf6073347007092e43391df03d5d0210e8137c0f182388116c0
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512f53
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_9, arg_a; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_3, local_4
# fields:       [edx + n] field_1
# callees:      calls FUN_005118b3, FUN_005129a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513020
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_3, 0x3  # offset -0x3
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_9, 0x9  # offset +0x9
.equ arg_a, 0xa  # offset +0xa

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)
.set FUN_005129a0, .text + (0x005129a0 - 0x401000)

.org 0x00512f53 - 0x401000
.globl FUN_00512f53
FUN_00512f53:
    # block 0x00512f53: entry, 8 instruction(s), ends with jne to 0x00512f80 (forward)
    push ebp                                     # 00512f53
    {load} mov ebp, esp                          # 00512f54
    push ecx                                     # 00512f56
    cmp dword ptr [0x63cb1c], 0x0                # 00512f57
    push ebx                                     # 00512f5e
    push esi                                     # 00512f5f
    push edi                                     # 00512f60
    jne.d8 L_00512f80                            # 00512f61
    # block 0x00512f63: entered by fall-through of jne at 0x00512f61, 3 instruction(s), ends with jl to 0x00513019 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00512f63
    cmp eax, 0x41                                # 00512f66
    jl.d32 L_00513019                            # 00512f69
    # block 0x00512f6f: entered by fall-through of jl at 0x00512f69, 2 instruction(s), ends with jg to 0x00513019 (forward)
    cmp eax, 0x5a                                # 00512f6f
    jg.d32 L_00513019                            # 00512f72
    # block 0x00512f78: entered by fall-through of jg at 0x00512f72, 2 instruction(s), ends with forward jump to 0x00513019
    add eax, 0x20                                # 00512f78
    jmp.d32 L_00513019                           # 00512f7b
L_00512f80:
    # block 0x00512f80: entered by jne at 0x00512f61, 6 instruction(s), ends with jge to 0x00512fb4 (forward)
    mov ebx, dword ptr [ebp + arg_8]             # 00512f80
    mov edi, 0x100                               # 00512f83
    push 0x1                                     # 00512f88
    {load} cmp ebx, edi                          # 00512f8a
    pop esi                                      # 00512f8c
    jge.d8 L_00512fb4                            # 00512f8d
    # block 0x00512f8f: entered by fall-through of jge at 0x00512f8d, 2 instruction(s), ends with jle to 0x00512fa2 (forward)
    cmp dword ptr [0x56840c], esi                # 00512f8f
    jle.d8 L_00512fa2                            # 00512f95
    # block 0x00512f97: entered by fall-through of jle at 0x00512f95, 6 instruction(s), calls FUN_005118b3, ends with forward jump to 0x00512fac
    push esi                                     # 00512f97
    push ebx                                     # 00512f98
    call FUN_005118b3                            # 00512f99
    pop ecx                                      # 00512f9e
    pop ecx                                      # 00512f9f
    jmp.d8 L_00512fac                            # 00512fa0
L_00512fa2:
    # block 0x00512fa2: entered by jle at 0x00512f95, 3 instruction(s), falls into the block at 0x00512fac
    mov eax, dword ptr [0x568200]                # 00512fa2
    mov al, byte ptr [eax + 2*ebx]               # 00512fa7
    {load} and eax, esi                          # 00512faa
L_00512fac:
    # block 0x00512fac: entered by jmp at 0x00512fa0, 2 instruction(s), ends with jne to 0x00512fb4 (forward)
    test eax, eax                                # 00512fac
    jne.d8 L_00512fb4                            # 00512fae
L_00512fb0:
    # block 0x00512fb0: entered by je at 0x00513000; fall-through of jne at 0x00512fae, 2 instruction(s), ends with forward jump to 0x00513019
    {load} mov eax, ebx                          # 00512fb0
    jmp.d8 L_00513019                            # 00512fb2
L_00512fb4:
    # block 0x00512fb4: entered by jge at 0x00512f8d; jne at 0x00512fae, 6 instruction(s), ends with je to 0x00512fd8 (forward)
    mov edx, dword ptr [0x568200]                # 00512fb4
    {load} mov eax, ebx                          # 00512fba
    sar eax, 0x8                                 # 00512fbc
    movzx ecx, al                                # 00512fbf
    test byte ptr [edx + 2*ecx + field_1], -0x80 # 00512fc2
    je.d8 L_00512fd8                             # 00512fc7
    # block 0x00512fc9: entered by fall-through of je at 0x00512fc7, 6 instruction(s), ends with forward jump to 0x00512fe1
    and byte ptr [ebp + arg_a], 0x0              # 00512fc9
    push 0x2                                     # 00512fcd
    mov byte ptr [ebp + arg_8], al               # 00512fcf
    mov byte ptr [ebp + arg_9], bl               # 00512fd2
    pop eax                                      # 00512fd5
    jmp.d8 L_00512fe1                            # 00512fd6
L_00512fd8:
    # block 0x00512fd8: entered by je at 0x00512fc7, 3 instruction(s), falls into the block at 0x00512fe1
    and byte ptr [ebp + arg_9], 0x0              # 00512fd8
    mov byte ptr [ebp + arg_8], bl               # 00512fdc
    {load} mov eax, esi                          # 00512fdf
L_00512fe1:
    # block 0x00512fe1: entered by jmp at 0x00512fd6, 14 instruction(s), calls FUN_005129a0, ends with je to 0x00512fb0 (backward)
    push esi                                     # 00512fe1
    push 0x0                                     # 00512fe2
    lea ecx, [ebp - local_4]                     # 00512fe4
    push 0x3                                     # 00512fe7
    push ecx                                     # 00512fe9
    push eax                                     # 00512fea
    lea eax, [ebp + arg_8]                       # 00512feb
    push eax                                     # 00512fee
    push edi                                     # 00512fef
    push dword ptr [0x63cb1c]                    # 00512ff0
    call FUN_005129a0                            # 00512ff6
    add esp, 0x20                                # 00512ffb
    test eax, eax                                # 00512ffe
    je.d8 L_00512fb0                             # 00513000
    # block 0x00513002: entered by fall-through of je at 0x00513000, 2 instruction(s), ends with jne to 0x0051300c (forward)
    {load} cmp eax, esi                          # 00513002
    jne.d8 L_0051300c                            # 00513004
    # block 0x00513006: entered by fall-through of jne at 0x00513004, 2 instruction(s), ends with forward jump to 0x00513019
    movzx eax, byte ptr [ebp - local_4]          # 00513006
    jmp.d8 L_00513019                            # 0051300a
L_0051300c:
    # block 0x0051300c: entered by jne at 0x00513004, 4 instruction(s), falls into the block at 0x00513019
    movzx eax, byte ptr [ebp - local_3]          # 0051300c
    movzx ecx, byte ptr [ebp - local_4]          # 00513010
    shl eax, 0x8                                 # 00513014
    {load} or eax, ecx                           # 00513017
L_00513019:
    # block 0x00513019: entered by jl at 0x00512f69; jg at 0x00512f72; jmp at 0x00512f7b; jmp at 0x00512fb2; more, 5 instruction(s), ends with ret
    pop edi                                      # 00513019
    pop esi                                      # 0051301a
    pop ebx                                      # 0051301b
    leave                                        # 0051301c
    ret                                          # 0051301d

# --- data items (not part of the function) -------------------------
.org 0x0051301e - 0x401000
PAD_0051301e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

