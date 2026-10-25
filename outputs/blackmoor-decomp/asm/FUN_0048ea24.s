# FUN_0048ea24
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ea24
# extent:       0x0048ea24-0x0048ec4a (550 code bytes)
# span:         0x0048ea24-0x0048ec4a (code 550, tables 0, padding 0)
# sha256:       a1f51c34bd300dfe492fc4565118c913ac1228c0e74b0749f1ee48de77edbeb7
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ea24_lifted
# naming:       native port src/original_methods_fl41.c:m48ea24_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 25 seeds; oracle: 147/147 instructions, 16/16 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_1e, field_200, field_3fe, field_456; [ecx + n] field_200, field_3fe, field_456, field_466; [edx + n] field_2, field_4, field_200, field_3fe, field_456, field_466, field_minus_1
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m48ea24_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 147 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_200, 0x200  # offset +0x200
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_456, 0x456  # offset +0x456
.equ field_466, 0x466  # offset +0x466

# --- external targets -----------------------------------------------

.org 0x0048ea24 - 0x401000
.globl FUN_0048ea24
FUN_0048ea24:
    # block 0x0048ea24: entry, 15 instruction(s), ends with je to 0x0048ea65 (forward)
    push ebp                                     # 0048ea24
    {load} mov ebp, esp                          # 0048ea25
    sub esp, 0xc                                 # 0048ea27
    push edi                                     # 0048ea2a
    mov dword ptr [ebp - local_8], ecx           # 0048ea2b
    mov eax, dword ptr [ebp - local_8]           # 0048ea2e
    movsx ecx, word ptr [eax + field_1e]         # 0048ea31
    imul ecx, ecx, 0x8d                          # 0048ea35
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048ea3b
    mov dword ptr [ebp - local_4], edx           # 0048ea41
    mov eax, dword ptr [ebp - local_8]           # 0048ea44
    mov ecx, dword ptr [eax + field_456]         # 0048ea47
    mov dword ptr [ebp - local_c], ecx           # 0048ea4d
    cmp dword ptr [ebp - local_c], 0x0           # 0048ea50
    je.d8 L_0048ea65                             # 0048ea54
    # block 0x0048ea56: entered by fall-through of je at 0x0048ea54, 2 instruction(s), ends with je to 0x0048eb40 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 0048ea56
    je.d32 L_0048eb40                            # 0048ea5a
    # block 0x0048ea60: entered by fall-through of je at 0x0048ea5a, 1 instruction(s), ends with forward jump to 0x0048ebf4
    jmp.d32 L_0048ebf4                           # 0048ea60
L_0048ea65:
    # block 0x0048ea65: entered by je at 0x0048ea54, 12 instruction(s), ends with jne to 0x0048eaae (forward)
    mov edx, dword ptr [ebp - local_8]           # 0048ea65
    movsx eax, word ptr [edx + field_3fe]        # 0048ea68
    imul eax, eax, 0x11                          # 0048ea6f
    mov ecx, dword ptr [ebp - local_8]           # 0048ea72
    lea edi, [ecx + eax + field_200]             # 0048ea75
    or ecx, -0x1                                 # 0048ea7c
    {load} xor eax, eax                          # 0048ea7f
    repne scasb al, byte ptr es:[edi]            # 0048ea81
    not ecx                                      # 0048ea83
    add ecx, -0x1                                # 0048ea85
    test ecx, ecx                                # 0048ea88
    jne.d8 L_0048eaae                            # 0048ea8a
    # block 0x0048ea8c: entered by fall-through of jne at 0x0048ea8a, 8 instruction(s), ends with forward jump to 0x0048eb3b
    mov edx, dword ptr [ebp - local_8]           # 0048ea8c
    movsx eax, word ptr [edx + field_3fe]        # 0048ea8f
    imul eax, eax, 0x11                          # 0048ea96
    mov ecx, dword ptr [ebp - local_8]           # 0048ea99
    mov edx, dword ptr [ebp - local_4]           # 0048ea9c
    mov dl, byte ptr [edx + field_4]             # 0048ea9f
    mov byte ptr [ecx + eax + field_200], dl     # 0048eaa2
    jmp.d32 L_0048eb3b                           # 0048eaa9
L_0048eaae:
    # block 0x0048eaae: entered by jne at 0x0048ea8a, 20 instruction(s), ends with je to 0x0048eb3b (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048eaae
    movsx ecx, word ptr [eax + field_3fe]        # 0048eab1
    imul ecx, ecx, 0x11                          # 0048eab8
    mov edx, dword ptr [ebp - local_8]           # 0048eabb
    lea edx, [edx + ecx + field_200]             # 0048eabe
    mov eax, dword ptr [ebp - local_8]           # 0048eac5
    movsx ecx, word ptr [eax + field_3fe]        # 0048eac8
    imul ecx, ecx, 0x11                          # 0048eacf
    mov eax, dword ptr [ebp - local_8]           # 0048ead2
    lea edi, [eax + ecx + field_200]             # 0048ead5
    or ecx, -0x1                                 # 0048eadc
    {load} xor eax, eax                          # 0048eadf
    repne scasb al, byte ptr es:[edi]            # 0048eae1
    not ecx                                      # 0048eae3
    add ecx, -0x1                                # 0048eae5
    movsx ecx, byte ptr [edx + ecx - field_minus_1] # 0048eae8
    mov edx, dword ptr [ebp - local_4]           # 0048eaed
    movsx eax, byte ptr [edx + field_4]          # 0048eaf0
    {load} cmp ecx, eax                          # 0048eaf4
    je.d8 L_0048eb3b                             # 0048eaf6
    # block 0x0048eaf8: entered by fall-through of je at 0x0048eaf6, 18 instruction(s), falls into the block at 0x0048eb3b
    mov ecx, dword ptr [ebp - local_8]           # 0048eaf8
    movsx edx, word ptr [ecx + field_3fe]        # 0048eafb
    imul edx, edx, 0x11                          # 0048eb02
    mov eax, dword ptr [ebp - local_8]           # 0048eb05
    lea edx, [eax + edx + field_200]             # 0048eb08
    mov eax, dword ptr [ebp - local_8]           # 0048eb0f
    movsx ecx, word ptr [eax + field_3fe]        # 0048eb12
    imul ecx, ecx, 0x11                          # 0048eb19
    mov eax, dword ptr [ebp - local_8]           # 0048eb1c
    lea edi, [eax + ecx + field_200]             # 0048eb1f
    or ecx, -0x1                                 # 0048eb26
    {load} xor eax, eax                          # 0048eb29
    repne scasb al, byte ptr es:[edi]            # 0048eb2b
    not ecx                                      # 0048eb2d
    add ecx, -0x1                                # 0048eb2f
    mov eax, dword ptr [ebp - local_4]           # 0048eb32
    mov al, byte ptr [eax + field_4]             # 0048eb35
    mov byte ptr [edx + ecx], al                 # 0048eb38
L_0048eb3b:
    # block 0x0048eb3b: entered by jmp at 0x0048eaa9; je at 0x0048eaf6, 1 instruction(s), ends with forward jump to 0x0048ebf4
    jmp.d32 L_0048ebf4                           # 0048eb3b
L_0048eb40:
    # block 0x0048eb40: entered by je at 0x0048ea5a, 12 instruction(s), ends with jbe to 0x0048ebf4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048eb40
    movsx edx, word ptr [ecx + field_3fe]        # 0048eb43
    imul edx, edx, 0x11                          # 0048eb4a
    mov eax, dword ptr [ebp - local_8]           # 0048eb4d
    lea edi, [eax + edx + field_200]             # 0048eb50
    or ecx, -0x1                                 # 0048eb57
    {load} xor eax, eax                          # 0048eb5a
    repne scasb al, byte ptr es:[edi]            # 0048eb5c
    not ecx                                      # 0048eb5e
    add ecx, -0x1                                # 0048eb60
    test ecx, ecx                                # 0048eb63
    jbe.d32 L_0048ebf4                           # 0048eb65
    # block 0x0048eb6b: entered by fall-through of jbe at 0x0048eb65, 20 instruction(s), ends with jne to 0x0048ebf4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048eb6b
    movsx edx, word ptr [ecx + field_3fe]        # 0048eb6e
    imul edx, edx, 0x11                          # 0048eb75
    mov eax, dword ptr [ebp - local_8]           # 0048eb78
    lea edx, [eax + edx + field_200]             # 0048eb7b
    mov eax, dword ptr [ebp - local_8]           # 0048eb82
    movsx ecx, word ptr [eax + field_3fe]        # 0048eb85
    imul ecx, ecx, 0x11                          # 0048eb8c
    mov eax, dword ptr [ebp - local_8]           # 0048eb8f
    lea edi, [eax + ecx + field_200]             # 0048eb92
    or ecx, -0x1                                 # 0048eb99
    {load} xor eax, eax                          # 0048eb9c
    repne scasb al, byte ptr es:[edi]            # 0048eb9e
    not ecx                                      # 0048eba0
    add ecx, -0x1                                # 0048eba2
    movsx ecx, byte ptr [edx + ecx - field_minus_1] # 0048eba5
    mov edx, dword ptr [ebp - local_4]           # 0048ebaa
    movsx eax, byte ptr [edx + field_4]          # 0048ebad
    {load} cmp ecx, eax                          # 0048ebb1
    jne.d8 L_0048ebf4                            # 0048ebb3
    # block 0x0048ebb5: entered by fall-through of jne at 0x0048ebb3, 16 instruction(s), falls into the block at 0x0048ebf4
    mov ecx, dword ptr [ebp - local_8]           # 0048ebb5
    movsx edx, word ptr [ecx + field_3fe]        # 0048ebb8
    imul edx, edx, 0x11                          # 0048ebbf
    mov eax, dword ptr [ebp - local_8]           # 0048ebc2
    lea edx, [eax + edx + field_200]             # 0048ebc5
    mov eax, dword ptr [ebp - local_8]           # 0048ebcc
    movsx ecx, word ptr [eax + field_3fe]        # 0048ebcf
    imul ecx, ecx, 0x11                          # 0048ebd6
    mov eax, dword ptr [ebp - local_8]           # 0048ebd9
    lea edi, [eax + ecx + field_200]             # 0048ebdc
    or ecx, -0x1                                 # 0048ebe3
    {load} xor eax, eax                          # 0048ebe6
    repne scasb al, byte ptr es:[edi]            # 0048ebe8
    not ecx                                      # 0048ebea
    add ecx, -0x1                                # 0048ebec
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048ebef
L_0048ebf4:
    # block 0x0048ebf4: entered by jmp at 0x0048ea60; jmp at 0x0048eb3b; jbe at 0x0048eb65; jne at 0x0048ebb3, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048ec45 (forward)
    call dword ptr [0x52a23c]                    # 0048ebf4
    mov ecx, dword ptr [ebp - local_8]           # 0048ebfa
    cmp eax, dword ptr [ecx + field_466]         # 0048ebfd
    jb.d8 L_0048ec45                             # 0048ec03
    # block 0x0048ec05: entered by fall-through of jb at 0x0048ec03, 3 instruction(s), ends with jne to 0x0048ec20 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0048ec05
    cmp dword ptr [edx + field_456], 0x0         # 0048ec08
    jne.d8 L_0048ec20                            # 0048ec0f
    # block 0x0048ec11: entered by fall-through of jne at 0x0048ec0f, 3 instruction(s), ends with forward jump to 0x0048ec2d
    mov eax, dword ptr [ebp - local_8]           # 0048ec11
    mov dword ptr [eax + field_456], 0x1         # 0048ec14
    jmp.d8 L_0048ec2d                            # 0048ec1e
L_0048ec20:
    # block 0x0048ec20: entered by jne at 0x0048ec0f, 2 instruction(s), falls into the block at 0x0048ec2d
    mov ecx, dword ptr [ebp - local_8]           # 0048ec20
    mov dword ptr [ecx + field_456], 0x0         # 0048ec23
L_0048ec2d:
    # block 0x0048ec2d: entered by jmp at 0x0048ec1e, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0048ec45
    call dword ptr [0x52a23c]                    # 0048ec2d
    mov edx, dword ptr [ebp - local_4]           # 0048ec33
    movsx ecx, word ptr [edx + field_2]          # 0048ec36
    {load} add eax, ecx                          # 0048ec3a
    mov edx, dword ptr [ebp - local_8]           # 0048ec3c
    mov dword ptr [edx + field_466], eax         # 0048ec3f
L_0048ec45:
    # block 0x0048ec45: entered by jb at 0x0048ec03, 4 instruction(s), ends with ret
    pop edi                                      # 0048ec45
    {load} mov esp, ebp                          # 0048ec46
    pop ebp                                      # 0048ec48
    ret                                          # 0048ec49

