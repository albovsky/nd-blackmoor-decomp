# FUN_0048ec4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ec4a
# extent:       0x0048ec4a-0x0048ef40 (758 code bytes)
# span:         0x0048ec4a-0x0048ef40 (code 758, tables 0, padding 0)
# sha256:       55fc9e77126d909e7f7fa8d5f9a9aa9b6bcaeba704fce9456e8763f867565a8e
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048ec4a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_30, local_34, local_38, local_3c, local_40 and 4 more
# fields:       [eax + n] field_1, field_10, field_1e, field_b2, field_fe, field_200, field_3fe, field_4e2; [ecx + n] field_1, field_10, field_200, field_3fe; [edx + n] field_4, field_b2, field_fe, field_3fe, field_46a, field_minus_1
# callees:      calls FUN_0050d0bc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 216 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_41, 0x41  # offset -0x41
.equ local_42, 0x42  # offset -0x42
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_b2, 0xb2  # offset +0xb2
.equ field_fe, 0xfe  # offset +0xfe
.equ field_200, 0x200  # offset +0x200
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_46a, 0x46a  # offset +0x46a
.equ field_4e2, 0x4e2  # offset +0x4e2

# --- external targets -----------------------------------------------
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)

.org 0x0048ec4a - 0x401000
.globl FUN_0048ec4a
FUN_0048ec4a:
    # block 0x0048ec4a: entry, 37 instruction(s), ends with jne to 0x0048ed05 (forward)
    push ebp                                     # 0048ec4a
    {load} mov ebp, esp                          # 0048ec4b
    sub esp, 0x4c                                # 0048ec4d
    push esi                                     # 0048ec50
    push edi                                     # 0048ec51
    mov dword ptr [ebp - local_38], ecx          # 0048ec52
    mov eax, dword ptr [ebp - local_38]          # 0048ec55
    movsx ecx, word ptr [eax + field_1e]         # 0048ec58
    imul ecx, ecx, 0x8d                          # 0048ec5c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048ec62
    mov dword ptr [ebp - local_1c], edx          # 0048ec68
    {load} xor eax, eax                          # 0048ec6b
    mov dword ptr [ebp - local_18], eax          # 0048ec6d
    mov dword ptr [ebp - local_14], eax          # 0048ec70
    mov dword ptr [ebp - local_10], eax          # 0048ec73
    mov dword ptr [ebp - local_c], eax           # 0048ec76
    mov byte ptr [ebp - local_8], al             # 0048ec79
    mov ecx, dword ptr [ebp - local_38]          # 0048ec7c
    movsx edx, word ptr [ecx + field_3fe]        # 0048ec7f
    imul edx, edx, 0x11                          # 0048ec86
    mov eax, dword ptr [ebp - local_38]          # 0048ec89
    lea edx, [eax + edx + field_200]             # 0048ec8c
    mov eax, dword ptr [ebp - local_38]          # 0048ec93
    movsx ecx, word ptr [eax + field_3fe]        # 0048ec96
    imul ecx, ecx, 0x11                          # 0048ec9d
    mov eax, dword ptr [ebp - local_38]          # 0048eca0
    lea edi, [eax + ecx + field_200]             # 0048eca3
    or ecx, -0x1                                 # 0048ecaa
    {load} xor eax, eax                          # 0048ecad
    repne scasb al, byte ptr es:[edi]            # 0048ecaf
    not ecx                                      # 0048ecb1
    add ecx, -0x1                                # 0048ecb3
    movsx ecx, byte ptr [edx + ecx - field_minus_1] # 0048ecb6
    mov edx, dword ptr [ebp - local_1c]          # 0048ecbb
    movsx eax, byte ptr [edx + field_4]          # 0048ecbe
    {load} cmp ecx, eax                          # 0048ecc2
    jne.d8 L_0048ed05                            # 0048ecc4
    # block 0x0048ecc6: entered by fall-through of jne at 0x0048ecc4, 16 instruction(s), falls into the block at 0x0048ed05
    mov ecx, dword ptr [ebp - local_38]          # 0048ecc6
    movsx edx, word ptr [ecx + field_3fe]        # 0048ecc9
    imul edx, edx, 0x11                          # 0048ecd0
    mov eax, dword ptr [ebp - local_38]          # 0048ecd3
    lea edx, [eax + edx + field_200]             # 0048ecd6
    mov eax, dword ptr [ebp - local_38]          # 0048ecdd
    movsx ecx, word ptr [eax + field_3fe]        # 0048ece0
    imul ecx, ecx, 0x11                          # 0048ece7
    mov eax, dword ptr [ebp - local_38]          # 0048ecea
    lea edi, [eax + ecx + field_200]             # 0048eced
    or ecx, -0x1                                 # 0048ecf4
    {load} xor eax, eax                          # 0048ecf7
    repne scasb al, byte ptr es:[edi]            # 0048ecf9
    not ecx                                      # 0048ecfb
    add ecx, -0x1                                # 0048ecfd
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048ed00
L_0048ed05:
    # block 0x0048ed05: entered by jne at 0x0048ecc4, 27 instruction(s), calls FUN_0050d0bc, ends with forward jump to 0x0048ed65
    mov ecx, dword ptr [ebp - local_38]          # 0048ed05
    movsx edx, word ptr [ecx + field_3fe]        # 0048ed08
    imul edx, edx, 0x11                          # 0048ed0f
    mov eax, dword ptr [ebp - local_38]          # 0048ed12
    lea ecx, [eax + edx + field_200]             # 0048ed15
    {load} mov edi, ecx                          # 0048ed1c
    lea edx, [ebp - local_18]                    # 0048ed1e
    or ecx, -0x1                                 # 0048ed21
    {load} xor eax, eax                          # 0048ed24
    repne scasb al, byte ptr es:[edi]            # 0048ed26
    not ecx                                      # 0048ed28
    {load} sub edi, ecx                          # 0048ed2a
    {load} mov esi, edi                          # 0048ed2c
    {load} mov eax, ecx                          # 0048ed2e
    {load} mov edi, edx                          # 0048ed30
    shr ecx, 0x2                                 # 0048ed32
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048ed35
    {load} mov ecx, eax                          # 0048ed37
    and ecx, 0x3                                 # 0048ed39
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048ed3c
    lea ecx, [ebp - local_18]                    # 0048ed3e
    push ecx                                     # 0048ed41
    call FUN_0050d0bc                            # 0048ed42
    add esp, 0x4                                 # 0048ed47
    mov dword ptr [ebp - local_34], 0x0          # 0048ed4a
    mov word ptr [ebp - local_4], 0x0            # 0048ed51
    jmp.d8 L_0048ed65                            # 0048ed57
L_0048ed59:
    # block 0x0048ed59: entered by jmp at 0x0048ee80, 3 instruction(s), falls into the block at 0x0048ed65
    mov dx, word ptr [ebp - local_4]             # 0048ed59
    add dx, 0x1                                  # 0048ed5d
    mov word ptr [ebp - local_4], dx             # 0048ed61
L_0048ed65:
    # block 0x0048ed65: entered by jmp at 0x0048ed57, 3 instruction(s), ends with jge to 0x0048ee85 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0048ed65
    cmp eax, 0x3                                 # 0048ed69
    jge.d32 L_0048ee85                           # 0048ed6c
    # block 0x0048ed72: entered by fall-through of jge at 0x0048ed6c, 15 instruction(s), ends with jbe to 0x0048ee80 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 0048ed72
    movsx edx, word ptr [ecx + field_3fe]        # 0048ed75
    imul edx, edx, 0xd0                          # 0048ed7c
    mov eax, dword ptr [ebp - local_1c]          # 0048ed82
    lea ecx, [eax + edx + field_b2]              # 0048ed85
    movsx edx, word ptr [ebp - local_4]          # 0048ed8c
    imul edx, edx, 0x14                          # 0048ed90
    lea edi, [ecx + edx + field_10]              # 0048ed93
    or ecx, -0x1                                 # 0048ed97
    {load} xor eax, eax                          # 0048ed9a
    repne scasb al, byte ptr es:[edi]            # 0048ed9c
    not ecx                                      # 0048ed9e
    add ecx, -0x1                                # 0048eda0
    test ecx, ecx                                # 0048eda3
    jbe.d32 L_0048ee80                           # 0048eda5
    # block 0x0048edab: entered by fall-through of jbe at 0x0048eda5, 31 instruction(s), calls FUN_0050d0bc, falls into the block at 0x0048ee0a
    mov eax, dword ptr [ebp - local_38]          # 0048edab
    movsx ecx, word ptr [eax + field_3fe]        # 0048edae
    imul ecx, ecx, 0xd0                          # 0048edb5
    mov edx, dword ptr [ebp - local_1c]          # 0048edbb
    lea eax, [edx + ecx + field_b2]              # 0048edbe
    movsx ecx, word ptr [ebp - local_4]          # 0048edc5
    imul ecx, ecx, 0x14                          # 0048edc9
    lea edx, [eax + ecx + field_10]              # 0048edcc
    {load} mov edi, edx                          # 0048edd0
    lea edx, [ebp - local_30]                    # 0048edd2
    or ecx, -0x1                                 # 0048edd5
    {load} xor eax, eax                          # 0048edd8
    repne scasb al, byte ptr es:[edi]            # 0048edda
    not ecx                                      # 0048eddc
    {load} sub edi, ecx                          # 0048edde
    {load} mov esi, edi                          # 0048ede0
    {load} mov eax, ecx                          # 0048ede2
    {load} mov edi, edx                          # 0048ede4
    shr ecx, 0x2                                 # 0048ede6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048ede9
    {load} mov ecx, eax                          # 0048edeb
    and ecx, 0x3                                 # 0048eded
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048edf0
    lea ecx, [ebp - local_30]                    # 0048edf2
    push ecx                                     # 0048edf5
    call FUN_0050d0bc                            # 0048edf6
    add esp, 0x4                                 # 0048edfb
    lea edx, [ebp - local_18]                    # 0048edfe
    mov dword ptr [ebp - local_3c], edx          # 0048ee01
    lea eax, [ebp - local_30]                    # 0048ee04
    mov dword ptr [ebp - local_40], eax          # 0048ee07
L_0048ee0a:
    # block 0x0048ee0a: entered by jne at 0x0048ee3c, 6 instruction(s), ends with jne to 0x0048ee47 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 0048ee0a
    mov dl, byte ptr [ecx]                       # 0048ee0d
    mov byte ptr [ebp - local_41], dl            # 0048ee0f
    mov eax, dword ptr [ebp - local_3c]          # 0048ee12
    cmp dl, byte ptr [eax]                       # 0048ee15
    jne.d8 L_0048ee47                            # 0048ee17
    # block 0x0048ee19: entered by fall-through of jne at 0x0048ee17, 2 instruction(s), ends with je to 0x0048ee3e (forward)
    cmp byte ptr [ebp - local_41], 0x0           # 0048ee19
    je.d8 L_0048ee3e                             # 0048ee1d
    # block 0x0048ee1f: entered by fall-through of je at 0x0048ee1d, 6 instruction(s), ends with jne to 0x0048ee47 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 0048ee1f
    mov dl, byte ptr [ecx + field_1]             # 0048ee22
    mov byte ptr [ebp - local_42], dl            # 0048ee25
    mov eax, dword ptr [ebp - local_3c]          # 0048ee28
    cmp dl, byte ptr [eax + field_1]             # 0048ee2b
    jne.d8 L_0048ee47                            # 0048ee2e
    # block 0x0048ee30: entered by fall-through of jne at 0x0048ee2e, 4 instruction(s), ends with jne to 0x0048ee0a (backward)
    add dword ptr [ebp - local_40], 0x2          # 0048ee30
    add dword ptr [ebp - local_3c], 0x2          # 0048ee34
    cmp byte ptr [ebp - local_42], 0x0           # 0048ee38
    jne.d8 L_0048ee0a                            # 0048ee3c
L_0048ee3e:
    # block 0x0048ee3e: entered by je at 0x0048ee1d; fall-through of jne at 0x0048ee3c, 2 instruction(s), ends with forward jump to 0x0048ee4f
    mov dword ptr [ebp - local_48], 0x0          # 0048ee3e
    jmp.d8 L_0048ee4f                            # 0048ee45
L_0048ee47:
    # block 0x0048ee47: entered by jne at 0x0048ee17; jne at 0x0048ee2e, 3 instruction(s), falls into the block at 0x0048ee4f
    {load} sbb ecx, ecx                          # 0048ee47
    sbb ecx, -0x1                                # 0048ee49
    mov dword ptr [ebp - local_48], ecx          # 0048ee4c
L_0048ee4f:
    # block 0x0048ee4f: entered by jmp at 0x0048ee45, 4 instruction(s), ends with jne to 0x0048ee80 (forward)
    mov edx, dword ptr [ebp - local_48]          # 0048ee4f
    mov dword ptr [ebp - local_4c], edx          # 0048ee52
    cmp dword ptr [ebp - local_4c], 0x0          # 0048ee55
    jne.d8 L_0048ee80                            # 0048ee59
    # block 0x0048ee5b: entered by fall-through of jne at 0x0048ee59, 6 instruction(s), falls into the block at 0x0048ee80
    mov dword ptr [ebp - local_34], 0x1          # 0048ee5b
    mov eax, dword ptr [ebp - local_38]          # 0048ee62
    movsx ecx, word ptr [eax + field_3fe]        # 0048ee65
    mov edx, dword ptr [ebp - local_38]          # 0048ee6c
    mov dword ptr [edx + 4*ecx + field_46a], 0x1 # 0048ee6f
    mov word ptr [ebp - local_4], 0x3            # 0048ee7a
L_0048ee80:
    # block 0x0048ee80: entered by jbe at 0x0048eda5; jne at 0x0048ee59, 1 instruction(s), ends with backward jump to 0x0048ed59
    jmp.d32 L_0048ed59                           # 0048ee80
L_0048ee85:
    # block 0x0048ee85: entered by jge at 0x0048ed6c, 2 instruction(s), ends with je to 0x0048ef38 (forward)
    cmp dword ptr [ebp - local_34], 0x0          # 0048ee85
    je.d32 L_0048ef38                            # 0048ee89
    # block 0x0048ee8f: entered by fall-through of je at 0x0048ee89, 7 instruction(s), ends with je to 0x0048eed5 (forward)
    mov eax, dword ptr [ebp - local_38]          # 0048ee8f
    movsx ecx, word ptr [eax + field_3fe]        # 0048ee92
    imul ecx, ecx, 0xd0                          # 0048ee99
    mov edx, dword ptr [ebp - local_1c]          # 0048ee9f
    movsx eax, word ptr [edx + ecx + field_fe]   # 0048eea2
    cmp eax, -0x1                                # 0048eeaa
    je.d8 L_0048eed5                             # 0048eead
    # block 0x0048eeaf: entered by fall-through of je at 0x0048eead, 6 instruction(s), falls into the block at 0x0048eed5
    mov ecx, dword ptr [ebp - local_38]          # 0048eeaf
    movsx edx, word ptr [ecx + field_3fe]        # 0048eeb2
    imul edx, edx, 0xd0                          # 0048eeb9
    mov eax, dword ptr [ebp - local_1c]          # 0048eebf
    movsx ecx, word ptr [eax + edx + field_fe]   # 0048eec2
    mov dword ptr [4*ecx + 0x585801], 0x1        # 0048eeca
L_0048eed5:
    # block 0x0048eed5: entered by je at 0x0048eead, 29 instruction(s), ends with forward jump to 0x0048ef3a
    mov edx, dword ptr [ebp - local_38]          # 0048eed5
    movsx eax, word ptr [edx + field_3fe]        # 0048eed8
    imul eax, eax, 0x11                          # 0048eedf
    mov ecx, dword ptr [ebp - local_38]          # 0048eee2
    lea edx, [ecx + eax + field_200]             # 0048eee5
    {load} mov edi, edx                          # 0048eeec
    mov eax, dword ptr [ebp - local_38]          # 0048eeee
    movsx ecx, word ptr [eax + field_4e2]        # 0048eef1
    imul ecx, ecx, 0x204                         # 0048eef8
    mov edx, dword ptr [ebp - local_38]          # 0048eefe
    movsx eax, word ptr [edx + field_3fe]        # 0048ef01
    imul eax, eax, 0x11                          # 0048ef08
    lea ecx, [ecx + eax + 0x591b22]              # 0048ef0b
    {load} mov edx, ecx                          # 0048ef12
    or ecx, -0x1                                 # 0048ef14
    {load} xor eax, eax                          # 0048ef17
    repne scasb al, byte ptr es:[edi]            # 0048ef19
    not ecx                                      # 0048ef1b
    {load} sub edi, ecx                          # 0048ef1d
    {load} mov esi, edi                          # 0048ef1f
    {load} mov eax, ecx                          # 0048ef21
    {load} mov edi, edx                          # 0048ef23
    shr ecx, 0x2                                 # 0048ef25
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048ef28
    {load} mov ecx, eax                          # 0048ef2a
    and ecx, 0x3                                 # 0048ef2c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048ef2f
    mov eax, 0x1                                 # 0048ef31
    jmp.d8 L_0048ef3a                            # 0048ef36
L_0048ef38:
    # block 0x0048ef38: entered by je at 0x0048ee89, 1 instruction(s), falls into the block at 0x0048ef3a
    {load} xor eax, eax                          # 0048ef38
L_0048ef3a:
    # block 0x0048ef3a: entered by jmp at 0x0048ef36, 5 instruction(s), ends with ret
    pop edi                                      # 0048ef3a
    pop esi                                      # 0048ef3b
    {load} mov esp, ebp                          # 0048ef3c
    pop ebp                                      # 0048ef3e
    ret                                          # 0048ef3f

