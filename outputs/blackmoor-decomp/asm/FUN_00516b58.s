# FUN_00516b58
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516b58
# extent:       0x00516b58-0x00516be5 (141 code bytes)
# span:         0x00516b58-0x00516be5 (code 141, tables 0, padding 0)
# sha256:       a720cf71fecbf60f172ac90930f62bd2109ea624101fb1d383616a93fef472ee
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516b58
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00516b58 - 0x401000
.globl FUN_00516b58
FUN_00516b58:
    # block 0x00516b58: entry, 24 instruction(s), falls into the block at 0x00516b8e
    push ebp                                     # 00516b58
    {load} mov ebp, esp                          # 00516b59
    sub esp, 0xc                                 # 00516b5b
    mov eax, dword ptr [ebp + arg_c]             # 00516b5e
    push ebx                                     # 00516b61
    push esi                                     # 00516b62
    push edi                                     # 00516b63
    push 0x20                                    # 00516b64
    mov edi, dword ptr [ebp + arg_8]             # 00516b66
    pop ebx                                      # 00516b69
    or esi, -0x1                                 # 00516b6a
    cdq                                          # 00516b6d
    {load} mov ecx, ebx                          # 00516b6e
    mov dword ptr [ebp - local_4], 0x3           # 00516b70
    idiv ecx                                     # 00516b77
    mov dword ptr [ebp - local_c], eax           # 00516b79
    mov eax, dword ptr [ebp + arg_c]             # 00516b7c
    cdq                                          # 00516b7f
    idiv ecx                                     # 00516b80
    and dword ptr [ebp + arg_c], 0x0             # 00516b82
    {load} mov ecx, edx                          # 00516b86
    shl esi, cl                                  # 00516b88
    {load} sub ebx, edx                          # 00516b8a
    not esi                                      # 00516b8c
L_00516b8e:
    # block 0x00516b8e: entered by jne at 0x00516bb0, 15 instruction(s), ends with jne to 0x00516b8e (backward)
    mov eax, dword ptr [edi]                     # 00516b8e
    {load} mov ecx, eax                          # 00516b90
    {load} and ecx, esi                          # 00516b92
    mov dword ptr [ebp - local_8], ecx           # 00516b94
    {load} mov ecx, edx                          # 00516b97
    shr eax, cl                                  # 00516b99
    or eax, dword ptr [ebp + arg_c]              # 00516b9b
    mov dword ptr [edi], eax                     # 00516b9e
    mov eax, dword ptr [ebp - local_8]           # 00516ba0
    {load} mov ecx, ebx                          # 00516ba3
    add edi, 0x4                                 # 00516ba5
    shl eax, cl                                  # 00516ba8
    dec dword ptr [ebp - local_4]                # 00516baa
    mov dword ptr [ebp + arg_c], eax             # 00516bad
    jne.d8 L_00516b8e                            # 00516bb0
    # block 0x00516bb2: entered by fall-through of jne at 0x00516bb0, 7 instruction(s), falls into the block at 0x00516bc0
    mov edi, dword ptr [ebp - local_c]           # 00516bb2
    push 0x2                                     # 00516bb5
    pop ebx                                      # 00516bb7
    {load} mov esi, edi                          # 00516bb8
    push 0x8                                     # 00516bba
    pop ecx                                      # 00516bbc
    shl esi, 0x2                                 # 00516bbd
L_00516bc0:
    # block 0x00516bc0: entered by jns at 0x00516bde, 2 instruction(s), ends with jl to 0x00516bd3 (forward)
    {load} cmp ebx, edi                          # 00516bc0
    jl.d8 L_00516bd3                             # 00516bc2
    # block 0x00516bc4: entered by fall-through of jl at 0x00516bc2, 6 instruction(s), ends with forward jump to 0x00516bda
    mov edx, dword ptr [ebp + arg_8]             # 00516bc4
    {load} mov eax, ecx                          # 00516bc7
    {load} sub eax, esi                          # 00516bc9
    mov eax, dword ptr [eax + edx]               # 00516bcb
    mov dword ptr [ecx + edx], eax               # 00516bce
    jmp.d8 L_00516bda                            # 00516bd1
L_00516bd3:
    # block 0x00516bd3: entered by jl at 0x00516bc2, 2 instruction(s), falls into the block at 0x00516bda
    mov eax, dword ptr [ebp + arg_8]             # 00516bd3
    and dword ptr [ecx + eax], 0x0               # 00516bd6
L_00516bda:
    # block 0x00516bda: entered by jmp at 0x00516bd1, 3 instruction(s), ends with jns to 0x00516bc0 (backward)
    dec ebx                                      # 00516bda
    sub ecx, 0x4                                 # 00516bdb
    jns.d8 L_00516bc0                            # 00516bde
    # block 0x00516be0: entered by fall-through of jns at 0x00516bde, 5 instruction(s), ends with ret
    pop edi                                      # 00516be0
    pop esi                                      # 00516be1
    pop ebx                                      # 00516be2
    leave                                        # 00516be3
    ret                                          # 00516be4

