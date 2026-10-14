# FUN_004ff9a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff9a0
# extent:       0x004ff9a0-0x004ff9f8 (88 code bytes)
# span:         0x004ff9a0-0x004ffa00 (code 88, tables 0, padding 8)
# sha256:       e2c8bc41563de52349dc8a8131115483ac2dae1ebb690a12cd12622717ae3ac8
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
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

# --- external targets -----------------------------------------------

.org 0x004ff9a0 - 0x401000
.globl FUN_004ff9a0
FUN_004ff9a0:
    # block 0x004ff9a0: <unfilled>
    mov ecx, dword ptr [esp + 0x4]               # 004ff9a0
    push esi                                     # 004ff9a4
    mov eax, dword ptr [ecx + 0x18]              # 004ff9a5
    mov edx, dword ptr [ecx + 0x4]               # 004ff9a8
    cmp eax, -0x1                                # 004ff9ab
    jle.d8 L_004ff9f4                            # 004ff9ae
    # block 0x004ff9b0: <unfilled>
    cmp eax, dword ptr [ecx + 0x14]              # 004ff9b0
    jge.d8 L_004ff9f4                            # 004ff9b3
    # block 0x004ff9b5: <unfilled>
    mov esi, dword ptr [esp + 0xc]               # 004ff9b5
    test esi, esi                                # 004ff9b9
    je.d8 L_004ff9ea                             # 004ff9bb
    # block 0x004ff9bd: <unfilled>
    push edi                                     # 004ff9bd
    mov edi, dword ptr [edx + 0x4]               # 004ff9be
    {load} xor eax, eax                          # 004ff9c1
    test edi, edi                                # 004ff9c3
    jle.d8 L_004ff9e4                            # 004ff9c5
    # block 0x004ff9c7: <unfilled>
    push ebx                                     # 004ff9c7
L_004ff9c8:
    # block 0x004ff9c8: <unfilled>
    mov edi, dword ptr [ecx + 0x8]               # 004ff9c8
    mov ebx, dword ptr [ecx + 0x18]              # 004ff9cb
    mov edi, dword ptr [edi + 4*eax]             # 004ff9ce
    inc eax                                      # 004ff9d1
    lea edi, [edi + 4*ebx]                       # 004ff9d2
    mov ebx, dword ptr [ecx + 0xc]               # 004ff9d5
    mov dword ptr [ebx + 4*eax - 0x4], edi       # 004ff9d8
    mov edi, dword ptr [edx + 0x4]               # 004ff9dc
    {load} cmp eax, edi                          # 004ff9df
    jl.d8 L_004ff9c8                             # 004ff9e1
    # block 0x004ff9e3: <unfilled>
    pop ebx                                      # 004ff9e3
L_004ff9e4:
    # block 0x004ff9e4: <unfilled>
    mov eax, dword ptr [ecx + 0xc]               # 004ff9e4
    pop edi                                      # 004ff9e7
    mov dword ptr [esi], eax                     # 004ff9e8
L_004ff9ea:
    # block 0x004ff9ea: <unfilled>
    mov eax, dword ptr [ecx + 0x14]              # 004ff9ea
    mov edx, dword ptr [ecx + 0x18]              # 004ff9ed
    {load} sub eax, edx                          # 004ff9f0
    pop esi                                      # 004ff9f2
    ret                                          # 004ff9f3
L_004ff9f4:
    # block 0x004ff9f4: <unfilled>
    {load} xor eax, eax                          # 004ff9f4
    pop esi                                      # 004ff9f6
    ret                                          # 004ff9f7

# --- data items (not part of the function) -------------------------
.org 0x004ff9f8 - 0x401000
PAD_004ff9f8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90
