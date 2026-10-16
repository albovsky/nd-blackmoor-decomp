# FUN_0043f0a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f0a3
# extent:       0x0043f0a3-0x0043f0fb (88 code bytes)
# span:         0x0043f0a3-0x0043f0fb (code 88, tables 0, padding 0)
# sha256:       8a0b427d8bd216e963bbf65bb4479542e9518f52e17c2a214651fece0be58470
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043f0a3
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x0043f0a3 - 0x401000
.globl FUN_0043f0a3
FUN_0043f0a3:
    # block 0x0043f0a3: entry, 8 instruction(s), ends with forward jump to 0x0043f0c0
    push ebp                                     # 0043f0a3
    {load} mov ebp, esp                          # 0043f0a4
    sub esp, 0x8                                 # 0043f0a6
    push esi                                     # 0043f0a9
    push edi                                     # 0043f0aa
    mov dword ptr [ebp - local_8], ecx           # 0043f0ab
    mov dword ptr [ebp - local_4], 0x0           # 0043f0ae
    jmp.d8 L_0043f0c0                            # 0043f0b5
L_0043f0b7:
    # block 0x0043f0b7: entered by jmp at 0x0043f0f1, 3 instruction(s), falls into the block at 0x0043f0c0
    mov eax, dword ptr [ebp - local_4]           # 0043f0b7
    add eax, 0x1                                 # 0043f0ba
    mov dword ptr [ebp - local_4], eax           # 0043f0bd
L_0043f0c0:
    # block 0x0043f0c0: entered by jmp at 0x0043f0b5, 3 instruction(s), ends with jge to 0x0043f0f3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0043f0c0
    cmp ecx, dword ptr [ebp + arg_10]            # 0043f0c3
    jge.d8 L_0043f0f3                            # 0043f0c6
    # block 0x0043f0c8: entered by fall-through of jge at 0x0043f0c6, 16 instruction(s), ends with backward jump to 0x0043f0b7
    mov ecx, dword ptr [ebp + arg_14]            # 0043f0c8
    mov esi, dword ptr [ebp + arg_c]             # 0043f0cb
    mov edi, dword ptr [ebp + arg_8]             # 0043f0ce
    {load} mov edx, ecx                          # 0043f0d1
    shr ecx, 0x2                                 # 0043f0d3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f0d6
    {load} mov ecx, edx                          # 0043f0d8
    and ecx, 0x3                                 # 0043f0da
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f0dd
    mov eax, dword ptr [ebp + arg_c]             # 0043f0df
    add eax, dword ptr [ebp + arg_18]            # 0043f0e2
    mov dword ptr [ebp + arg_c], eax             # 0043f0e5
    mov ecx, dword ptr [ebp + arg_8]             # 0043f0e8
    add ecx, dword ptr [ebp + arg_1c]            # 0043f0eb
    mov dword ptr [ebp + arg_8], ecx             # 0043f0ee
    jmp.d8 L_0043f0b7                            # 0043f0f1
L_0043f0f3:
    # block 0x0043f0f3: entered by jge at 0x0043f0c6, 5 instruction(s), ends with ret 0x18
    pop edi                                      # 0043f0f3
    pop esi                                      # 0043f0f4
    {load} mov esp, ebp                          # 0043f0f5
    pop ebp                                      # 0043f0f7
    ret 0x18                                     # 0043f0f8

