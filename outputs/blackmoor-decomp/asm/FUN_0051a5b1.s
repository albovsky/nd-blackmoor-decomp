# FUN_0051a5b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a5b1
# extent:       0x0051a5b1-0x0051a601 (80 code bytes)
# span:         0x0051a5b1-0x0051a601 (code 80, tables 0, padding 0)
# sha256:       87f4a73aface852d48a722f3a9349866e283c67c819263b1bda8a3e3ed1dbd51
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a5b1
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [esi + n] field_4, field_8
# callees:      calls FUN_0051a54c, FUN_0051a44d, FUN_0051a4e6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051a44d, .text + (0x0051a44d - 0x401000)
.set FUN_0051a4e6, .text + (0x0051a4e6 - 0x401000)
.set FUN_0051a54c, .text + (0x0051a54c - 0x401000)

.org 0x0051a5b1 - 0x401000
.globl FUN_0051a5b1
FUN_0051a5b1:
    # block 0x0051a5b1: entry, 12 instruction(s), calls FUN_0051a54c, ends with jne to 0x0051a5f8 (forward)
    push ebp                                     # 0051a5b1
    {load} mov ebp, esp                          # 0051a5b2
    push esi                                     # 0051a5b4
    push edi                                     # 0051a5b5
    mov edi, dword ptr [ebp + arg_8]             # 0051a5b6
    lea eax, [ebp + arg_8]                       # 0051a5b9
    push eax                                     # 0051a5bc
    {load} mov esi, ecx                          # 0051a5bd
    push edi                                     # 0051a5bf
    call FUN_0051a54c                            # 0051a5c0
    test eax, eax                                # 0051a5c5
    jne.d8 L_0051a5f8                            # 0051a5c7
    # block 0x0051a5c9: entered by fall-through of jne at 0x0051a5c7, 2 instruction(s), ends with jne to 0x0051a5da (forward)
    cmp dword ptr [esi + field_4], eax           # 0051a5c9
    jne.d8 L_0051a5da                            # 0051a5cc
    # block 0x0051a5ce: entered by fall-through of jne at 0x0051a5cc, 4 instruction(s), calls FUN_0051a44d, falls into the block at 0x0051a5da
    push 0x1                                     # 0051a5ce
    {load} mov ecx, esi                          # 0051a5d0
    push dword ptr [esi + field_8]               # 0051a5d2
    call FUN_0051a44d                            # 0051a5d5
L_0051a5da:
    # block 0x0051a5da: entered by jne at 0x0051a5cc, 10 instruction(s), calls FUN_0051a4e6, falls into the block at 0x0051a5f8
    {load} mov ecx, esi                          # 0051a5da
    call FUN_0051a4e6                            # 0051a5dc
    mov dword ptr [eax + field_4], edi           # 0051a5e1
    mov ecx, dword ptr [esi + field_4]           # 0051a5e4
    mov edx, dword ptr [ebp + arg_8]             # 0051a5e7
    mov ecx, dword ptr [ecx + 4*edx]             # 0051a5ea
    mov dword ptr [eax], ecx                     # 0051a5ed
    mov ecx, dword ptr [esi + field_4]           # 0051a5ef
    mov edx, dword ptr [ebp + arg_8]             # 0051a5f2
    mov dword ptr [ecx + 4*edx], eax             # 0051a5f5
L_0051a5f8:
    # block 0x0051a5f8: entered by jne at 0x0051a5c7, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0051a5f8
    add eax, 0x8                                 # 0051a5f9
    pop esi                                      # 0051a5fc
    pop ebp                                      # 0051a5fd
    ret 0x4                                      # 0051a5fe

