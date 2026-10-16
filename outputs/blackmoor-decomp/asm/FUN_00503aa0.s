# FUN_00503aa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503aa0
# extent:       0x00503aa0-0x00503b73 (211 code bytes)
# span:         0x00503aa0-0x00503b80 (code 211, tables 0, padding 13)
# sha256:       fa158748a167a5ba2a4c7633ab95208d8760984648afec22fe88f94325056560
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503aa0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8, field_14, field_30, field_34, field_38, field_60, field_64; [esp + n] stk_8
# callees:      calls FUN_0050e936, FUN_0050bc20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 84 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------
.set FUN_0050bc20, .text + (0x0050bc20 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00503aa0 - 0x401000
.globl FUN_00503aa0
FUN_00503aa0:
    # block 0x00503aa0: entry, 4 instruction(s), ends with je to 0x00503b71 (forward)
    push edi                                     # 00503aa0
    mov edi, dword ptr [esp + stk_8]             # 00503aa1
    test edi, edi                                # 00503aa5
    je.d32 L_00503b71                            # 00503aa7
    # block 0x00503aad: entered by fall-through of je at 0x00503aa7, 3 instruction(s), ends with je to 0x00503abc (forward)
    mov eax, dword ptr [edi]                     # 00503aad
    test eax, eax                                # 00503aaf
    je.d8 L_00503abc                             # 00503ab1
    # block 0x00503ab3: entered by fall-through of je at 0x00503ab1, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503abc
    push eax                                     # 00503ab3
    call FUN_0050e936                            # 00503ab4
    add esp, 0x4                                 # 00503ab9
L_00503abc:
    # block 0x00503abc: entered by je at 0x00503ab1, 3 instruction(s), ends with je to 0x00503acc (forward)
    mov eax, dword ptr [edi + field_4]           # 00503abc
    test eax, eax                                # 00503abf
    je.d8 L_00503acc                             # 00503ac1
    # block 0x00503ac3: entered by fall-through of je at 0x00503ac1, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503acc
    push eax                                     # 00503ac3
    call FUN_0050e936                            # 00503ac4
    add esp, 0x4                                 # 00503ac9
L_00503acc:
    # block 0x00503acc: entered by je at 0x00503ac1, 3 instruction(s), ends with je to 0x00503adc (forward)
    mov eax, dword ptr [edi + field_14]          # 00503acc
    test eax, eax                                # 00503acf
    je.d8 L_00503adc                             # 00503ad1
    # block 0x00503ad3: entered by fall-through of je at 0x00503ad1, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503adc
    push eax                                     # 00503ad3
    call FUN_0050e936                            # 00503ad4
    add esp, 0x4                                 # 00503ad9
L_00503adc:
    # block 0x00503adc: entered by je at 0x00503ad1, 3 instruction(s), ends with je to 0x00503aec (forward)
    mov eax, dword ptr [edi + field_30]          # 00503adc
    test eax, eax                                # 00503adf
    je.d8 L_00503aec                             # 00503ae1
    # block 0x00503ae3: entered by fall-through of je at 0x00503ae1, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503aec
    push eax                                     # 00503ae3
    call FUN_0050e936                            # 00503ae4
    add esp, 0x4                                 # 00503ae9
L_00503aec:
    # block 0x00503aec: entered by je at 0x00503ae1, 3 instruction(s), ends with je to 0x00503afc (forward)
    mov eax, dword ptr [edi + field_34]          # 00503aec
    test eax, eax                                # 00503aef
    je.d8 L_00503afc                             # 00503af1
    # block 0x00503af3: entered by fall-through of je at 0x00503af1, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503afc
    push eax                                     # 00503af3
    call FUN_0050e936                            # 00503af4
    add esp, 0x4                                 # 00503af9
L_00503afc:
    # block 0x00503afc: entered by je at 0x00503af1, 3 instruction(s), ends with je to 0x00503b0c (forward)
    mov eax, dword ptr [edi + field_38]          # 00503afc
    test eax, eax                                # 00503aff
    je.d8 L_00503b0c                             # 00503b01
    # block 0x00503b03: entered by fall-through of je at 0x00503b01, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503b0c
    push eax                                     # 00503b03
    call FUN_0050e936                            # 00503b04
    add esp, 0x4                                 # 00503b09
L_00503b0c:
    # block 0x00503b0c: entered by je at 0x00503b01, 3 instruction(s), ends with je to 0x00503b58 (forward)
    mov ecx, dword ptr [edi + field_60]          # 00503b0c
    test ecx, ecx                                # 00503b0f
    je.d8 L_00503b58                             # 00503b11
    # block 0x00503b13: entered by fall-through of je at 0x00503b11, 4 instruction(s), ends with jne to 0x00503b26 (forward)
    mov eax, dword ptr [edi + field_8]           # 00503b13
    push esi                                     # 00503b16
    test eax, eax                                # 00503b17
    jne.d8 L_00503b26                            # 00503b19
    # block 0x00503b1b: entered by fall-through of jne at 0x00503b19, 4 instruction(s), calls FUN_0050bc20, ends with forward jump to 0x00503b4b
    push ecx                                     # 00503b1b
    call FUN_0050bc20                            # 00503b1c
    add esp, 0x4                                 # 00503b21
    jmp.d8 L_00503b4b                            # 00503b24
L_00503b26:
    # block 0x00503b26: entered by jne at 0x00503b19, 3 instruction(s), ends with jle to 0x00503b4b (forward)
    {load} xor esi, esi                          # 00503b26
    test eax, eax                                # 00503b28
    jle.d8 L_00503b4b                            # 00503b2a
    # block 0x00503b2c: entered by fall-through of jle at 0x00503b2a, 2 instruction(s), falls into the block at 0x00503b2f
    push ebx                                     # 00503b2c
    {load} xor ebx, ebx                          # 00503b2d
L_00503b2f:
    # block 0x00503b2f: entered by jl at 0x00503b48, 11 instruction(s), calls FUN_0050bc20, ends with jl to 0x00503b2f (backward)
    mov edx, dword ptr [edi + field_60]          # 00503b2f
    {load} mov eax, ebx                          # 00503b32
    {load} add eax, edx                          # 00503b34
    push eax                                     # 00503b36
    call FUN_0050bc20                            # 00503b37
    mov eax, dword ptr [edi + field_8]           # 00503b3c
    add esp, 0x4                                 # 00503b3f
    inc esi                                      # 00503b42
    add ebx, 0x14                                # 00503b43
    {load} cmp esi, eax                          # 00503b46
    jl.d8 L_00503b2f                             # 00503b48
    # block 0x00503b4a: entered by fall-through of jl at 0x00503b48, 1 instruction(s), falls into the block at 0x00503b4b
    pop ebx                                      # 00503b4a
L_00503b4b:
    # block 0x00503b4b: entered by jmp at 0x00503b24; jle at 0x00503b2a, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x00503b58
    mov ecx, dword ptr [edi + field_60]          # 00503b4b
    push ecx                                     # 00503b4e
    call FUN_0050e936                            # 00503b4f
    add esp, 0x4                                 # 00503b54
    pop esi                                      # 00503b57
L_00503b58:
    # block 0x00503b58: entered by je at 0x00503b11, 3 instruction(s), ends with je to 0x00503b68 (forward)
    mov eax, dword ptr [edi + field_64]          # 00503b58
    test eax, eax                                # 00503b5b
    je.d8 L_00503b68                             # 00503b5d
    # block 0x00503b5f: entered by fall-through of je at 0x00503b5d, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00503b68
    push eax                                     # 00503b5f
    call FUN_0050e936                            # 00503b60
    add esp, 0x4                                 # 00503b65
L_00503b68:
    # block 0x00503b68: entered by je at 0x00503b5d, 3 instruction(s), falls into the block at 0x00503b71
    mov ecx, 0x1a                                # 00503b68
    {load} xor eax, eax                          # 00503b6d
    rep stosd dword ptr es:[edi], eax            # 00503b6f
L_00503b71:
    # block 0x00503b71: entered by je at 0x00503aa7, 2 instruction(s), ends with ret
    pop edi                                      # 00503b71
    ret                                          # 00503b72

# --- data items (not part of the function) -------------------------
.org 0x00503b73 - 0x401000
PAD_00503b73:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

