# FUN_004d8f0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d8f0a
# extent:       0x004d8f0a-0x004d8f8d (131 code bytes)
# span:         0x004d8f0a-0x004d8f8d (code 131, tables 0, padding 0)
# sha256:       b1d01bed2f89d7aba5c2f12a1952bb66debb8f8e4dfad3af0dcda85df8e6f527
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d8f0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_108, field_9804; [ecx + n] field_9804, field_980c; [edx + n] field_980c
# callees:      calls FUN_004d8f8d, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_108, 0x108  # offset +0x108
.equ field_9804, 0x9804  # offset +0x9804
.equ field_980c, 0x980c  # offset +0x980c

# --- external targets -----------------------------------------------
.set FUN_004d8f8d, .text + (0x004d8f8d - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d8f0a - 0x401000
.globl FUN_004d8f0a
FUN_004d8f0a:
    # block 0x004d8f0a: entry, 8 instruction(s), ends with je to 0x004d8f52 (forward)
    push ebp                                     # 004d8f0a
    {load} mov ebp, esp                          # 004d8f0b
    sub esp, 0x10                                # 004d8f0d
    push edi                                     # 004d8f10
    mov dword ptr [ebp - local_10], ecx          # 004d8f11
    mov eax, dword ptr [ebp - local_10]          # 004d8f14
    cmp dword ptr [eax + field_9804], 0x0        # 004d8f17
    je.d8 L_004d8f52                             # 004d8f1e
    # block 0x004d8f20: entered by fall-through of je at 0x004d8f1e, 3 instruction(s), falls into the block at 0x004d8f2c
    mov ecx, dword ptr [ebp - local_10]          # 004d8f20
    mov edx, dword ptr [ecx + field_9804]        # 004d8f23
    mov dword ptr [ebp - local_4], edx           # 004d8f29
L_004d8f2c:
    # block 0x004d8f2c: entered by jmp at 0x004d8f50, 2 instruction(s), ends with je to 0x004d8f52 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004d8f2c
    je.d8 L_004d8f52                             # 004d8f30
    # block 0x004d8f32: entered by fall-through of je at 0x004d8f30, 10 instruction(s), calls FUN_004d8f8d, ends with backward jump to 0x004d8f2c
    mov eax, dword ptr [ebp - local_4]           # 004d8f32
    mov ecx, dword ptr [eax + field_108]         # 004d8f35
    mov dword ptr [ebp - local_8], ecx           # 004d8f3b
    mov edx, dword ptr [ebp - local_4]           # 004d8f3e
    push edx                                     # 004d8f41
    mov ecx, dword ptr [ebp - local_10]          # 004d8f42
    call FUN_004d8f8d                            # 004d8f45
    mov eax, dword ptr [ebp - local_8]           # 004d8f4a
    mov dword ptr [ebp - local_4], eax           # 004d8f4d
    jmp.d8 L_004d8f2c                            # 004d8f50
L_004d8f52:
    # block 0x004d8f52: entered by je at 0x004d8f1e; je at 0x004d8f30, 3 instruction(s), ends with je to 0x004d8f76 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004d8f52
    cmp dword ptr [ecx + field_980c], 0x0        # 004d8f55
    je.d8 L_004d8f76                             # 004d8f5c
    # block 0x004d8f5e: entered by fall-through of je at 0x004d8f5c, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d8f76
    mov edx, dword ptr [ebp - local_10]          # 004d8f5e
    mov eax, dword ptr [edx + field_980c]        # 004d8f61
    mov dword ptr [ebp - local_c], eax           # 004d8f67
    mov ecx, dword ptr [ebp - local_c]           # 004d8f6a
    push ecx                                     # 004d8f6d
    call FUN_0051dc6c                            # 004d8f6e
    add esp, 0x4                                 # 004d8f73
L_004d8f76:
    # block 0x004d8f76: entered by je at 0x004d8f5c, 9 instruction(s), ends with ret
    mov ecx, 0x29                                # 004d8f76
    {load} xor eax, eax                          # 004d8f7b
    mov edi, dword ptr [ebp - local_10]          # 004d8f7d
    add edi, 0x9804                              # 004d8f80
    rep stosd dword ptr es:[edi], eax            # 004d8f86
    pop edi                                      # 004d8f88
    {load} mov esp, ebp                          # 004d8f89
    pop ebp                                      # 004d8f8b
    ret                                          # 004d8f8c

