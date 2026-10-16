# FUN_0050c8a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c8a0
# extent:       0x0050c8a0-0x0050c91b (123 code bytes)
# span:         0x0050c8a0-0x0050c920 (code 123, tables 0, padding 5)
# sha256:       4686c2d542f2888817f0927fe10af25af3f52ea07ed5226080cb6319da4895ca
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c8a0
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8; [ebx + n] field_4; [edi + n] field_c, field_10
# callees:      calls FUN_00510f3b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00510f3b, .text + (0x00510f3b - 0x401000)

.org 0x0050c8a0 - 0x401000
.globl FUN_0050c8a0
FUN_0050c8a0:
    # block 0x0050c8a0: entry, 14 instruction(s), ends with jl to 0x0050c8f7 (forward)
    push ebp                                     # 0050c8a0
    {load} mov ebp, esp                          # 0050c8a1
    push ecx                                     # 0050c8a3
    push ebx                                     # 0050c8a4
    push esi                                     # 0050c8a5
    cmp dword ptr [ebp + arg_c], 0x0             # 0050c8a6
    push edi                                     # 0050c8aa
    mov edi, dword ptr [ebp + arg_8]             # 0050c8ab
    mov esi, dword ptr [edi + field_c]           # 0050c8ae
    mov ebx, dword ptr [edi + field_10]          # 0050c8b1
    {load} mov eax, esi                          # 0050c8b4
    mov dword ptr [ebp + arg_8], esi             # 0050c8b6
    mov dword ptr [ebp - local_4], eax           # 0050c8b9
    jl.d8 L_0050c8f7                             # 0050c8bc
L_0050c8be:
    # block 0x0050c8be: entered by jge at 0x0050c8f2; fall-through of jl at 0x0050c8bc, 2 instruction(s), ends with jne to 0x0050c8c8 (forward)
    cmp esi, -0x1                                # 0050c8be
    jne.d8 L_0050c8c8                            # 0050c8c1
    # block 0x0050c8c3: entered by fall-through of jne at 0x0050c8c1, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x0050c8c8
    call FUN_00510f3b                            # 0050c8c3
L_0050c8c8:
    # block 0x0050c8c8: entered by jne at 0x0050c8c1, 6 instruction(s), ends with jge to 0x0050c8dd (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0050c8c8
    dec esi                                      # 0050c8cb
    lea eax, [esi + 4*esi]                       # 0050c8cc
    cmp dword ptr [ebx + 4*eax + field_4], ecx   # 0050c8cf
    lea eax, [ebx + 4*eax]                       # 0050c8d3
    jge.d8 L_0050c8dd                            # 0050c8d6
    # block 0x0050c8d8: entered by fall-through of jge at 0x0050c8d6, 2 instruction(s), ends with jle to 0x0050c8e2 (forward)
    cmp ecx, dword ptr [eax + field_8]           # 0050c8d8
    jle.d8 L_0050c8e2                            # 0050c8db
L_0050c8dd:
    # block 0x0050c8dd: entered by jge at 0x0050c8d6; fall-through of jle at 0x0050c8db, 2 instruction(s), ends with jne to 0x0050c8ee (forward)
    cmp esi, -0x1                                # 0050c8dd
    jne.d8 L_0050c8ee                            # 0050c8e0
L_0050c8e2:
    # block 0x0050c8e2: entered by jle at 0x0050c8db; fall-through of jne at 0x0050c8e0, 4 instruction(s), falls into the block at 0x0050c8ee
    mov eax, dword ptr [ebp + arg_8]             # 0050c8e2
    dec dword ptr [ebp + arg_c]                  # 0050c8e5
    mov dword ptr [ebp - local_4], eax           # 0050c8e8
    mov dword ptr [ebp + arg_8], esi             # 0050c8eb
L_0050c8ee:
    # block 0x0050c8ee: entered by jne at 0x0050c8e0, 2 instruction(s), ends with jge to 0x0050c8be (backward)
    cmp dword ptr [ebp + arg_c], 0x0             # 0050c8ee
    jge.d8 L_0050c8be                            # 0050c8f2
    # block 0x0050c8f4: entered by fall-through of jge at 0x0050c8f2, 1 instruction(s), falls into the block at 0x0050c8f7
    mov eax, dword ptr [ebp - local_4]           # 0050c8f4
L_0050c8f7:
    # block 0x0050c8f7: entered by jl at 0x0050c8bc, 7 instruction(s), ends with ja to 0x0050c90b (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 0050c8f7
    inc esi                                      # 0050c8fa
    mov dword ptr [ecx], esi                     # 0050c8fb
    mov ecx, dword ptr [ebp + arg_18]            # 0050c8fd
    mov dword ptr [ecx], eax                     # 0050c900
    cmp eax, dword ptr [edi + field_c]           # 0050c902
    ja.d8 L_0050c90b                             # 0050c905
    # block 0x0050c907: entered by fall-through of ja at 0x0050c905, 2 instruction(s), ends with jbe to 0x0050c910 (forward)
    {load} cmp esi, eax                          # 0050c907
    jbe.d8 L_0050c910                            # 0050c909
L_0050c90b:
    # block 0x0050c90b: entered by ja at 0x0050c905; fall-through of jbe at 0x0050c909, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x0050c910
    call FUN_00510f3b                            # 0050c90b
L_0050c910:
    # block 0x0050c910: entered by jbe at 0x0050c909, 7 instruction(s), ends with ret
    lea eax, [esi + 4*esi]                       # 0050c910
    pop edi                                      # 0050c913
    pop esi                                      # 0050c914
    lea eax, [ebx + 4*eax]                       # 0050c915
    pop ebx                                      # 0050c918
    leave                                        # 0050c919
    ret                                          # 0050c91a

# --- data items (not part of the function) -------------------------
.org 0x0050c91b - 0x401000
PAD_0050c91b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

