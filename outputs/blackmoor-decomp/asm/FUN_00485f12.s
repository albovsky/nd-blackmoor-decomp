# FUN_00485f12
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00485f12
# extent:       0x00485f12-0x00485fb6 (164 code bytes)
# span:         0x00485f12-0x00485fb6 (code 164, tables 0, padding 0)
# sha256:       45433610cb358442f3fafa12020499d743a8936f8953521a61676289147a49a7
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00485f12
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_26; [ecx + n] field_bc9; [edx + n] field_b73, field_b87
# callees:      calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 46 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_26, 0x26  # offset +0x26
.equ field_b73, 0xb73  # offset +0xb73
.equ field_b87, 0xb87  # offset +0xb87
.equ field_bc9, 0xbc9  # offset +0xbc9

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x00485f12 - 0x401000
.globl FUN_00485f12
FUN_00485f12:
    # block 0x00485f12: entry, 18 instruction(s), ends with je to 0x00485fb0 (forward)
    push ebp                                     # 00485f12
    {load} mov ebp, esp                          # 00485f13
    sub esp, 0x8                                 # 00485f15
    push esi                                     # 00485f18
    push edi                                     # 00485f19
    mov dword ptr [ebp - local_8], ecx           # 00485f1a
    mov eax, dword ptr [ebp - local_8]           # 00485f1d
    movsx ecx, word ptr [eax + field_26]         # 00485f20
    imul ecx, ecx, 0x8d                          # 00485f24
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00485f2a
    mov dword ptr [ebp - local_4], edx           # 00485f30
    mov edi, 0x54db78                            # 00485f33
    mov esi, dword ptr [ebp - local_4]           # 00485f38
    add esi, 0x676                               # 00485f3b
    mov ecx, 0x9                                 # 00485f41
    {load} xor eax, eax                          # 00485f46
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485f48
    je.d8 L_00485fb0                             # 00485f4a
    # block 0x00485f4c: entered by fall-through of je at 0x00485f4a, 23 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00485fb0
    mov esi, dword ptr [ebp - local_4]           # 00485f4c
    add esi, 0x676                               # 00485f4f
    mov edi, dword ptr [ebp - local_8]           # 00485f55
    add edi, 0xb52                               # 00485f58
    mov ecx, 0xc                                 # 00485f5e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00485f63
    movsb byte ptr es:[edi], byte ptr [esi]      # 00485f65
    mov ecx, dword ptr [ebp - local_8]           # 00485f66
    add ecx, 0xb52                               # 00485f69
    push ecx                                     # 00485f6f
    mov ecx, 0x5c3a67                            # 00485f70
    call FUN_004fb77a                            # 00485f75
    mov edx, dword ptr [ebp - local_8]           # 00485f7a
    mov ax, word ptr [edx + field_b73]           # 00485f7d
    push eax                                     # 00485f84
    mov ecx, 0x5c3a67                            # 00485f85
    call FUN_004fb2e3                            # 00485f8a
    call dword ptr [0x52a23c]                    # 00485f8f
    add eax, 0x12c                               # 00485f95
    mov ecx, dword ptr [ebp - local_8]           # 00485f9a
    mov dword ptr [ecx + field_bc9], eax         # 00485f9d
    mov edx, dword ptr [ebp - local_8]           # 00485fa3
    mov dword ptr [edx + field_b87], 0x0         # 00485fa6
L_00485fb0:
    # block 0x00485fb0: entered by je at 0x00485f4a, 5 instruction(s), ends with ret
    pop edi                                      # 00485fb0
    pop esi                                      # 00485fb1
    {load} mov esp, ebp                          # 00485fb2
    pop ebp                                      # 00485fb4
    ret                                          # 00485fb5

