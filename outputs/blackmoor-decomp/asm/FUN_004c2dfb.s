# FUN_004c2dfb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2dfb
# extent:       0x004c2dfb-0x004c2e5b (96 code bytes)
# span:         0x004c2dfb-0x004c2e5b (code 96, tables 0, padding 0)
# sha256:       6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c2dfb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [edx + n] field_55
# callees:      calls FUN_004c2e5b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_55, 0x55  # offset +0x55

# --- external targets -----------------------------------------------
.set FUN_004c2e5b, .text + (0x004c2e5b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c2dfb - 0x401000
.globl FUN_004c2dfb
FUN_004c2dfb:
    # block 0x004c2dfb: entry, 7 instruction(s), ends with jne to 0x004c2e0e (forward)
    push ebp                                     # 004c2dfb
    {load} mov ebp, esp                          # 004c2dfc
    sub esp, 0x8                                 # 004c2dfe
    mov dword ptr [ebp - local_8], ecx           # 004c2e01
    mov eax, dword ptr [ebp + arg_8]             # 004c2e04
    cmp dword ptr [eax], 0x0                     # 004c2e07
    jne.d8 L_004c2e0e                            # 004c2e0a
    # block 0x004c2e0c: entered by fall-through of jne at 0x004c2e0a, 1 instruction(s), ends with forward jump to 0x004c2e55
    jmp.d8 L_004c2e55                            # 004c2e0c
L_004c2e0e:
    # block 0x004c2e0e: entered by jne at 0x004c2e0a, 6 instruction(s), ends with jne to 0x004c2e2d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004c2e0e
    mov edx, dword ptr [ecx]                     # 004c2e11
    mov eax, dword ptr [edx + field_55]          # 004c2e13
    and eax, 0x1                                 # 004c2e16
    test eax, eax                                # 004c2e19
    jne.d8 L_004c2e2d                            # 004c2e1b
    # block 0x004c2e1d: entered by fall-through of jne at 0x004c2e1b, 6 instruction(s), calls FUN_004c2e5b, ends with forward jump to 0x004c2e38
    mov ecx, dword ptr [ebp + arg_8]             # 004c2e1d
    mov edx, dword ptr [ecx]                     # 004c2e20
    push edx                                     # 004c2e22
    mov ecx, dword ptr [ebp - local_8]           # 004c2e23
    call FUN_004c2e5b                            # 004c2e26
    jmp.d8 L_004c2e38                            # 004c2e2b
L_004c2e2d:
    # block 0x004c2e2d: entered by jne at 0x004c2e1b, 3 instruction(s), falls into the block at 0x004c2e38
    mov eax, dword ptr [ebp + arg_8]             # 004c2e2d
    mov ecx, dword ptr [eax]                     # 004c2e30
    mov dword ptr [ecx], 0x0                     # 004c2e32
L_004c2e38:
    # block 0x004c2e38: entered by jmp at 0x004c2e2b, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c2e55
    mov edx, dword ptr [ebp + arg_8]             # 004c2e38
    mov eax, dword ptr [edx]                     # 004c2e3b
    mov dword ptr [ebp - local_4], eax           # 004c2e3d
    mov ecx, dword ptr [ebp - local_4]           # 004c2e40
    push ecx                                     # 004c2e43
    call FUN_0051dc6c                            # 004c2e44
    add esp, 0x4                                 # 004c2e49
    mov edx, dword ptr [ebp + arg_8]             # 004c2e4c
    mov dword ptr [edx], 0x0                     # 004c2e4f
L_004c2e55:
    # block 0x004c2e55: entered by jmp at 0x004c2e0c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c2e55
    pop ebp                                      # 004c2e57
    ret 0x4                                      # 004c2e58

