# FUN_0043ee69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ee69
# extent:       0x0043ee69-0x0043eece (101 code bytes)
# span:         0x0043ee69-0x0043eed0 (code 101, tables 0, padding 2)
# sha256:       10f55382a0365c55de3bb603676c8bd2bf47b9f93598562e0721187af8a62a53
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ee69
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051b461
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051b461, .text + (0x0051b461 - 0x401000)

.org 0x0043ee69 - 0x401000
.globl FUN_0043ee69
FUN_0043ee69:
    # block 0x0043ee69: entry, 8 instruction(s), ends with je to 0x0043eead (forward)
    push ebp                                     # 0043ee69
    {load} mov ebp, esp                          # 0043ee6a
    sub esp, 0xc                                 # 0043ee6c
    mov dword ptr [ebp - local_8], ecx           # 0043ee6f
    mov eax, dword ptr [ebp + arg_8]             # 0043ee72
    mov dword ptr [ebp - local_c], eax           # 0043ee75
    cmp dword ptr [ebp - local_c], 0x14          # 0043ee78
    je.d8 L_0043eead                             # 0043ee7c
    # block 0x0043ee7e: entered by fall-through of je at 0x0043ee7c, 2 instruction(s), ends with je to 0x0043ee89 (forward)
    cmp dword ptr [ebp - local_c], 0x112         # 0043ee7e
    je.d8 L_0043ee89                             # 0043ee85
    # block 0x0043ee87: entered by fall-through of je at 0x0043ee85, 1 instruction(s), ends with forward jump to 0x0043eeb4
    jmp.d8 L_0043eeb4                            # 0043ee87
L_0043ee89:
    # block 0x0043ee89: entered by je at 0x0043ee85, 5 instruction(s), ends with je to 0x0043eea7 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0043ee89
    and ecx, 0xfff0                              # 0043ee8c
    mov dword ptr [ebp - local_4], ecx           # 0043ee92
    cmp dword ptr [ebp - local_4], 0xf140        # 0043ee95
    je.d8 L_0043eea7                             # 0043ee9c
    # block 0x0043ee9e: entered by fall-through of je at 0x0043ee9c, 2 instruction(s), ends with jne to 0x0043eeab (forward)
    cmp dword ptr [ebp - local_4], 0xf170        # 0043ee9e
    jne.d8 L_0043eeab                            # 0043eea5
L_0043eea7:
    # block 0x0043eea7: entered by je at 0x0043ee9c; fall-through of jne at 0x0043eea5, 2 instruction(s), ends with forward jump to 0x0043eec8
    {load} xor eax, eax                          # 0043eea7
    jmp.d8 L_0043eec8                            # 0043eea9
L_0043eeab:
    # block 0x0043eeab: entered by jne at 0x0043eea5, 1 instruction(s), ends with forward jump to 0x0043eeb4
    jmp.d8 L_0043eeb4                            # 0043eeab
L_0043eead:
    # block 0x0043eead: entered by je at 0x0043ee7c, 2 instruction(s), ends with forward jump to 0x0043eec8
    mov eax, 0x1                                 # 0043eead
    jmp.d8 L_0043eec8                            # 0043eeb2
L_0043eeb4:
    # block 0x0043eeb4: entered by jmp at 0x0043ee87; jmp at 0x0043eeab, 8 instruction(s), calls FUN_0051b461, falls into the block at 0x0043eec8
    mov edx, dword ptr [ebp + arg_10]            # 0043eeb4
    push edx                                     # 0043eeb7
    mov eax, dword ptr [ebp + arg_c]             # 0043eeb8
    push eax                                     # 0043eebb
    mov ecx, dword ptr [ebp + arg_8]             # 0043eebc
    push ecx                                     # 0043eebf
    mov ecx, dword ptr [ebp - local_8]           # 0043eec0
    call FUN_0051b461                            # 0043eec3
L_0043eec8:
    # block 0x0043eec8: entered by jmp at 0x0043eea9; jmp at 0x0043eeb2, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0043eec8
    pop ebp                                      # 0043eeca
    ret 0xc                                      # 0043eecb

# --- data items (not part of the function) -------------------------
.org 0x0043eece - 0x401000
PAD_0043eece:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

