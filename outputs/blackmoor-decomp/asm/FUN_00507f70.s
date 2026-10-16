# FUN_00507f70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507f70
# extent:       0x00507f70-0x00507fc1 (81 code bytes)
# span:         0x00507f70-0x00507fd0 (code 81, tables 0, padding 15)
# sha256:       9c7958adcdcd706f0a0e822507d7c285d80cc5f67d8ffe3125ce93cf314ec25f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507c30 (+0x340)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507f70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_18, stk_1c, stk_20, stk_34
# callees:      calls FUN_00507fd0, FUN_00503060
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_00503060, .text + (0x00503060 - 0x401000)
.set FUN_00507fd0, .text + (0x00507fd0 - 0x401000)

.org 0x00507f70 - 0x401000
.globl FUN_00507f70
FUN_00507f70:
    # block 0x00507f70: entry, 10 instruction(s), ends with jle to 0x00507fbc (forward)
    mov eax, dword ptr [esp + stk_c]             # 00507f70
    push ebx                                     # 00507f74
    push edi                                     # 00507f75
    mov edi, dword ptr [esp + stk_18]            # 00507f76
    cdq                                          # 00507f7a
    mov ecx, dword ptr [edi]                     # 00507f7b
    {load} xor ebx, ebx                          # 00507f7d
    idiv ecx                                     # 00507f7f
    test eax, eax                                # 00507f81
    jle.d8 L_00507fbc                            # 00507f83
    # block 0x00507f85: entered by fall-through of jle at 0x00507f83, 6 instruction(s), falls into the block at 0x00507f94
    push ebp                                     # 00507f85
    push esi                                     # 00507f86
    mov esi, dword ptr [esp + stk_18]            # 00507f87
    {load} mov ebp, eax                          # 00507f8b
    shl ecx, 0x2                                 # 00507f8d
    mov dword ptr [esp + stk_20], ecx            # 00507f90
L_00507f94:
    # block 0x00507f94: entered by jne at 0x00507fb3, 14 instruction(s), calls FUN_00507fd0, FUN_00503060, ends with jne to 0x00507f94 (backward)
    push esi                                     # 00507f94
    push edi                                     # 00507f95
    call FUN_00507fd0                            # 00507f96
    mov edx, dword ptr [esp + stk_1c]            # 00507f9b
    push edx                                     # 00507f9f
    push eax                                     # 00507fa0
    push edi                                     # 00507fa1
    call FUN_00503060                            # 00507fa2
    mov ecx, dword ptr [esp + stk_34]            # 00507fa7
    add esp, 0x14                                # 00507fab
    {load} add ebx, eax                          # 00507fae
    {load} add esi, ecx                          # 00507fb0
    dec ebp                                      # 00507fb2
    jne.d8 L_00507f94                            # 00507fb3
    # block 0x00507fb5: entered by fall-through of jne at 0x00507fb3, 6 instruction(s), ends with ret
    pop esi                                      # 00507fb5
    pop ebp                                      # 00507fb6
    {load} mov eax, ebx                          # 00507fb7
    pop edi                                      # 00507fb9
    pop ebx                                      # 00507fba
    ret                                          # 00507fbb
L_00507fbc:
    # block 0x00507fbc: entered by jle at 0x00507f83, 4 instruction(s), ends with ret
    {load} mov eax, ebx                          # 00507fbc
    pop edi                                      # 00507fbe
    pop ebx                                      # 00507fbf
    ret                                          # 00507fc0

# --- data items (not part of the function) -------------------------
.org 0x00507fc1 - 0x401000
PAD_00507fc1:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

