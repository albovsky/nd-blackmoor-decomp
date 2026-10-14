# FUN_00433bd2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433bd2
# extent:       0x00433bd2-0x00433c51 (127 code bytes)
# span:         0x00433bd2-0x00433c60 (code 127, tables 0, padding 15)
# sha256:       db8c89e9e4980d3c69054cb2fb40ccb3f9adfc9abdf1d99fb730e40fc3c7b8a0
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x00433bd2 - 0x401000
.globl FUN_00433bd2
FUN_00433bd2:
    # block 0x00433bd2: <unfilled>
    push ebp                                     # 00433bd2
    {load} mov ebp, esp                          # 00433bd3
    push ecx                                     # 00433bd5
    push esi                                     # 00433bd6
    push edi                                     # 00433bd7
    cmp dword ptr [ebp + arg_8], 0x0             # 00433bd8
    jne.d8 L_00433be0                            # 00433bdc
    # block 0x00433bde: <unfilled>
    jmp.d8 L_00433c4b                            # 00433bde
L_00433be0:
    # block 0x00433be0: <unfilled>
    mov ecx, 0x41                                # 00433be0
    {load} xor eax, eax                          # 00433be5
    mov edi, dword ptr [ebp + arg_8]             # 00433be7
    rep stosd dword ptr es:[edi], eax            # 00433bea
    stosw word ptr es:[edi], ax                  # 00433bec
    mov dword ptr [ebp - local_4], 0x0           # 00433bee
    jmp.d8 L_00433c00                            # 00433bf5
L_00433bf7:
    # block 0x00433bf7: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 00433bf7
    add eax, 0x1                                 # 00433bfa
    mov dword ptr [ebp - local_4], eax           # 00433bfd
L_00433c00:
    # block 0x00433c00: <unfilled>
    cmp dword ptr [ebp - local_4], 0xa           # 00433c00
    jge.d8 L_00433c18                            # 00433c04
    # block 0x00433c06: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 00433c06
    mov edx, dword ptr [ebp + arg_8]             # 00433c09
    mov word ptr [edx + 4*ecx + 0xde], 0xffff    # 00433c0c
    jmp.d8 L_00433bf7                            # 00433c16
L_00433c18:
    # block 0x00433c18: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 00433c18
    mov dword ptr [eax], 0x0                     # 00433c1b
    mov edi, 0x545dd4                            # 00433c21
    mov ecx, dword ptr [ebp + arg_8]             # 00433c26
    add ecx, 0x28                                # 00433c29
    {load} mov edx, ecx                          # 00433c2c
    or ecx, -0x1                                 # 00433c2e
    {load} xor eax, eax                          # 00433c31
    repne scasb al, byte ptr es:[edi]            # 00433c33
    not ecx                                      # 00433c35
    {load} sub edi, ecx                          # 00433c37
    {load} mov esi, edi                          # 00433c39
    {load} mov eax, ecx                          # 00433c3b
    {load} mov edi, edx                          # 00433c3d
    shr ecx, 0x2                                 # 00433c3f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00433c42
    {load} mov ecx, eax                          # 00433c44
    and ecx, 0x3                                 # 00433c46
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00433c49
L_00433c4b:
    # block 0x00433c4b: <unfilled>
    pop edi                                      # 00433c4b
    pop esi                                      # 00433c4c
    {load} mov esp, ebp                          # 00433c4d
    pop ebp                                      # 00433c4f
    ret                                          # 00433c50

# --- data items (not part of the function) -------------------------
.org 0x00433c51 - 0x401000
PAD_00433c51:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc
