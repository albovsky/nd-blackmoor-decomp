# FUN_0043f04b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f04b
# extent:       0x0043f04b-0x0043f0a3 (88 code bytes)
# span:         0x0043f04b-0x0043f0a3 (code 88, tables 0, padding 0)
# sha256:       e005ddcc9f3e34a119142937bb379f199dae47b29b705fa05e05e753a2001a39
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043f04b
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
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

# --- external targets -----------------------------------------------

.org 0x0043f04b - 0x401000
.globl FUN_0043f04b
FUN_0043f04b:
    # block 0x0043f04b: entry, 8 instruction(s), ends with forward jump to 0x0043f068
    push ebp                                     # 0043f04b
    {load} mov ebp, esp                          # 0043f04c
    sub esp, 0x8                                 # 0043f04e
    push esi                                     # 0043f051
    push edi                                     # 0043f052
    mov dword ptr [ebp - local_8], ecx           # 0043f053
    mov dword ptr [ebp - local_4], 0x0           # 0043f056
    jmp.d8 L_0043f068                            # 0043f05d
L_0043f05f:
    # block 0x0043f05f: entered by jmp at 0x0043f099, 3 instruction(s), falls into the block at 0x0043f068
    mov eax, dword ptr [ebp - local_4]           # 0043f05f
    add eax, 0x1                                 # 0043f062
    mov dword ptr [ebp - local_4], eax           # 0043f065
L_0043f068:
    # block 0x0043f068: entered by jmp at 0x0043f05d, 3 instruction(s), ends with jge to 0x0043f09b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0043f068
    cmp ecx, dword ptr [ebp + arg_10]            # 0043f06b
    jge.d8 L_0043f09b                            # 0043f06e
    # block 0x0043f070: entered by fall-through of jge at 0x0043f06e, 16 instruction(s), ends with backward jump to 0x0043f05f
    mov ecx, dword ptr [ebp + arg_14]            # 0043f070
    mov esi, dword ptr [ebp + arg_c]             # 0043f073
    mov edi, dword ptr [ebp + arg_8]             # 0043f076
    {load} mov edx, ecx                          # 0043f079
    shr ecx, 0x2                                 # 0043f07b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f07e
    {load} mov ecx, edx                          # 0043f080
    and ecx, 0x3                                 # 0043f082
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f085
    mov eax, dword ptr [ebp + arg_c]             # 0043f087
    add eax, dword ptr [ebp + arg_18]            # 0043f08a
    mov dword ptr [ebp + arg_c], eax             # 0043f08d
    mov ecx, dword ptr [ebp + arg_8]             # 0043f090
    add ecx, dword ptr [ebp + arg_14]            # 0043f093
    mov dword ptr [ebp + arg_8], ecx             # 0043f096
    jmp.d8 L_0043f05f                            # 0043f099
L_0043f09b:
    # block 0x0043f09b: entered by jge at 0x0043f06e, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 0043f09b
    pop esi                                      # 0043f09c
    {load} mov esp, ebp                          # 0043f09d
    pop ebp                                      # 0043f09f
    ret 0x14                                     # 0043f0a0

