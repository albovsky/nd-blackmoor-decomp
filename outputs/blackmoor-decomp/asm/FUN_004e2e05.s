# FUN_004e2e05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2e05
# extent:       0x004e2e05-0x004e2faa (421 code bytes)
# span:         0x004e2e05-0x004e2faa (code 421, tables 0, padding 0)
# sha256:       403e9dd3794e6b312cddbc0aabc5064fc7e5ad46ba84e3180fc34098e605ec25
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2e05_copy_state
# naming:       native port src/original_methods_fl30d.c:m4e2e05_copy_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Copies count*0x29 bytes and the two compare-selected string groups into the 0x5a1e54 globals; bad count is a native rejection; all instructions and jump directions executed. See tasks/fl30d-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_13e1, field_1406, field_1471; [ecx + n] field_13df, field_1404; [edx + n] field_1408
# callees:      calls FUN_004e3ade
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30d.c:m4e2e05_copy_state (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 117 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_13df, 0x13df  # offset +0x13df
.equ field_13e1, 0x13e1  # offset +0x13e1
.equ field_1404, 0x1404  # offset +0x1404
.equ field_1406, 0x1406  # offset +0x1406
.equ field_1408, 0x1408  # offset +0x1408
.equ field_1471, 0x1471  # offset +0x1471

# --- external targets -----------------------------------------------
.set FUN_004e3ade, .text + (0x004e3ade - 0x401000)

.org 0x004e2e05 - 0x401000
.globl FUN_004e2e05
FUN_004e2e05:
    # block 0x004e2e05: entry, 32 instruction(s), calls FUN_004e3ade, ends with je to 0x004e2f11 (forward)
    push ebp                                     # 004e2e05
    {load} mov ebp, esp                          # 004e2e06
    push ecx                                     # 004e2e08
    push esi                                     # 004e2e09
    push edi                                     # 004e2e0a
    mov dword ptr [ebp - local_4], ecx           # 004e2e0b
    mov dword ptr [0x5a1e54], 0x0                # 004e2e0e
    mov dword ptr [0x5a1e58], 0x0                # 004e2e18
    mov eax, dword ptr [ebp - local_4]           # 004e2e22
    movsx ecx, word ptr [eax + field_1471]       # 004e2e25
    imul ecx, ecx, 0x29                          # 004e2e2c
    mov esi, dword ptr [ebp - local_4]           # 004e2e2f
    add esi, 0x457b                              # 004e2e32
    mov edi, 0x5a1e62                            # 004e2e38
    {load} mov edx, ecx                          # 004e2e3d
    shr ecx, 0x2                                 # 004e2e3f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e2e42
    {load} mov ecx, edx                          # 004e2e44
    and ecx, 0x3                                 # 004e2e46
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e2e49
    mov eax, dword ptr [ebp - local_4]           # 004e2e4b
    mov cx, word ptr [eax + field_1471]          # 004e2e4e
    mov word ptr [0x5a1e5c], cx                  # 004e2e55
    mov ecx, dword ptr [ebp - local_4]           # 004e2e5c
    call FUN_004e3ade                            # 004e2e5f
    mov edi, 0x63a9e4                            # 004e2e64
    mov esi, dword ptr [ebp - local_4]           # 004e2e69
    add esi, 0x139d                              # 004e2e6c
    mov ecx, 0x1                                 # 004e2e72
    {load} xor edx, edx                          # 004e2e77
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e2e79
    je.d32 L_004e2f11                            # 004e2e7b
    # block 0x004e2e81: entered by fall-through of je at 0x004e2e7b, 43 instruction(s), ends with forward jump to 0x004e2f1a
    mov word ptr [0x5a1e5e], 0x1                 # 004e2e81
    mov eax, dword ptr [ebp - local_4]           # 004e2e8a
    add eax, 0x139d                              # 004e2e8d
    {load} mov edi, eax                          # 004e2e92
    mov edx, 0x5a2664                            # 004e2e94
    or ecx, -0x1                                 # 004e2e99
    {load} xor eax, eax                          # 004e2e9c
    repne scasb al, byte ptr es:[edi]            # 004e2e9e
    not ecx                                      # 004e2ea0
    {load} sub edi, ecx                          # 004e2ea2
    {load} mov esi, edi                          # 004e2ea4
    {load} mov eax, ecx                          # 004e2ea6
    {load} mov edi, edx                          # 004e2ea8
    shr ecx, 0x2                                 # 004e2eaa
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e2ead
    {load} mov ecx, eax                          # 004e2eaf
    and ecx, 0x3                                 # 004e2eb1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e2eb4
    mov ecx, dword ptr [ebp - local_4]           # 004e2eb6
    add ecx, 0x13be                              # 004e2eb9
    {load} mov edi, ecx                          # 004e2ebf
    mov edx, 0x5a2685                            # 004e2ec1
    or ecx, -0x1                                 # 004e2ec6
    {load} xor eax, eax                          # 004e2ec9
    repne scasb al, byte ptr es:[edi]            # 004e2ecb
    not ecx                                      # 004e2ecd
    {load} sub edi, ecx                          # 004e2ecf
    {load} mov esi, edi                          # 004e2ed1
    {load} mov eax, ecx                          # 004e2ed3
    {load} mov edi, edx                          # 004e2ed5
    shr ecx, 0x2                                 # 004e2ed7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e2eda
    {load} mov ecx, eax                          # 004e2edc
    and ecx, 0x3                                 # 004e2ede
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e2ee1
    mov ecx, dword ptr [ebp - local_4]           # 004e2ee3
    mov dx, word ptr [ecx + field_13df]          # 004e2ee6
    mov word ptr [0x5a26a6], dx                  # 004e2eed
    mov eax, dword ptr [ebp - local_4]           # 004e2ef4
    mov cx, word ptr [eax + field_13e1]          # 004e2ef7
    mov word ptr [0x5a26a8], cx                  # 004e2efe
    mov dword ptr [0x5a26aa], 0x0                # 004e2f05
    jmp.d8 L_004e2f1a                            # 004e2f0f
L_004e2f11:
    # block 0x004e2f11: entered by je at 0x004e2e7b, 1 instruction(s), falls into the block at 0x004e2f1a
    mov word ptr [0x5a1e5e], 0x0                 # 004e2f11
L_004e2f1a:
    # block 0x004e2f1a: entered by jmp at 0x004e2f0f, 7 instruction(s), ends with je to 0x004e2f9b (forward)
    mov edi, 0x63a9e8                            # 004e2f1a
    mov esi, dword ptr [ebp - local_4]           # 004e2f1f
    add esi, 0x13e3                              # 004e2f22
    mov ecx, 0x1                                 # 004e2f28
    {load} xor edx, edx                          # 004e2f2d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e2f2f
    je.d8 L_004e2f9b                             # 004e2f31
    # block 0x004e2f33: entered by fall-through of je at 0x004e2f31, 28 instruction(s), ends with forward jump to 0x004e2fa4
    mov word ptr [0x5a1e60], 0x1                 # 004e2f33
    mov eax, dword ptr [ebp - local_4]           # 004e2f3c
    add eax, 0x13e3                              # 004e2f3f
    {load} mov edi, eax                          # 004e2f44
    mov edx, 0x5a434c                            # 004e2f46
    or ecx, -0x1                                 # 004e2f4b
    {load} xor eax, eax                          # 004e2f4e
    repne scasb al, byte ptr es:[edi]            # 004e2f50
    not ecx                                      # 004e2f52
    {load} sub edi, ecx                          # 004e2f54
    {load} mov esi, edi                          # 004e2f56
    {load} mov eax, ecx                          # 004e2f58
    {load} mov edi, edx                          # 004e2f5a
    shr ecx, 0x2                                 # 004e2f5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e2f5f
    {load} mov ecx, eax                          # 004e2f61
    and ecx, 0x3                                 # 004e2f63
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e2f66
    mov ecx, dword ptr [ebp - local_4]           # 004e2f68
    movsx edx, word ptr [ecx + field_1404]       # 004e2f6b
    mov dword ptr [0x5a4371], edx                # 004e2f72
    mov eax, dword ptr [ebp - local_4]           # 004e2f78
    mov cx, word ptr [eax + field_1406]          # 004e2f7b
    mov word ptr [0x5a436d], cx                  # 004e2f82
    mov edx, dword ptr [ebp - local_4]           # 004e2f89
    mov ax, word ptr [edx + field_1408]          # 004e2f8c
    mov word ptr [0x5a436f], ax                  # 004e2f93
    jmp.d8 L_004e2fa4                            # 004e2f99
L_004e2f9b:
    # block 0x004e2f9b: entered by je at 0x004e2f31, 1 instruction(s), falls into the block at 0x004e2fa4
    mov word ptr [0x5a1e60], 0x0                 # 004e2f9b
L_004e2fa4:
    # block 0x004e2fa4: entered by jmp at 0x004e2f99, 5 instruction(s), ends with ret
    pop edi                                      # 004e2fa4
    pop esi                                      # 004e2fa5
    {load} mov esp, ebp                          # 004e2fa6
    pop ebp                                      # 004e2fa8
    ret                                          # 004e2fa9

