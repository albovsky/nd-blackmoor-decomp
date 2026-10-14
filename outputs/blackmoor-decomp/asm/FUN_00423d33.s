# FUN_00423d33
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423d33
# extent:       0x00423d33-0x00423da2 (111 code bytes)
# span:         0x00423d33-0x00423da2 (code 111, tables 0, padding 0)
# sha256:       b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
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
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)
.set FUN_00423da2, .text + (0x00423da2 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00423d33 - 0x401000
.globl FUN_00423d33
FUN_00423d33:
    # block 0x00423d33: <unfilled>
    push ebp                                     # 00423d33
    {load} mov ebp, esp                          # 00423d34
    push ecx                                     # 00423d36
    mov dword ptr [ebp - local_4], ecx           # 00423d37
    mov eax, dword ptr [ebp + arg_8]             # 00423d3a
    cmp dword ptr [eax + 0x34], 0x0              # 00423d3d
    jne.d8 L_00423d4e                            # 00423d41
    # block 0x00423d43: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 00423d43
    mov dword ptr [ecx], 0x1                     # 00423d46
    jmp.d8 L_00423d9c                            # 00423d4c
L_00423d4e:
    # block 0x00423d4e: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 00423d4e
    mov dword ptr [edx], 0x0                     # 00423d51
    movsx eax, word ptr [0x63a4cd]               # 00423d57
    test eax, eax                                # 00423d5e
    je.d8 L_00423d88                             # 00423d60
    # block 0x00423d62: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 00423d62
    mov edx, dword ptr [ecx + 0x8]               # 00423d65
    push edx                                     # 00423d68
    push 0x54488c                                # 00423d69
    push 0x63888b                                # 00423d6e
    call FUN_0050ca3e                            # 00423d73
    add esp, 0xc                                 # 00423d78
    push 0x63888b                                # 00423d7b
    call FUN_0044a2b7                            # 00423d80
    add esp, 0x4                                 # 00423d85
L_00423d88:
    # block 0x00423d88: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 00423d88
    call FUN_004234c8                            # 00423d8b
    mov eax, dword ptr [ebp + arg_8]             # 00423d90
    push eax                                     # 00423d93
    mov ecx, dword ptr [ebp - local_4]           # 00423d94
    call FUN_00423da2                            # 00423d97
L_00423d9c:
    # block 0x00423d9c: <unfilled>
    {load} mov esp, ebp                          # 00423d9c
    pop ebp                                      # 00423d9e
    ret 0x4                                      # 00423d9f
