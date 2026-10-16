# FUN_00525917
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525917
# extent:       0x00525917-0x00525a01 (234 code bytes)
# span:         0x00525917-0x00525a01 (code 234, tables 0, padding 0)
# sha256:       0971c364195ddc015afa56e86b5e5258304c6258efa87ef354d8d30798afbf2b
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525917
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edi + n] field_8, field_c; [esi + n] field_c, field_14, field_1c
# callees:      calls KERNEL32.dll!TlsGetValue, FUN_005256dd, KERNEL32.dll!EnterCriticalSection, FUN_00525684, KERNEL32.dll!LeaveCriticalSection, KERNEL32.dll!LocalAlloc, KERNEL32.dll!LocalReAlloc, FUN_00519cc0, FUN_0050f920, KERNEL32.dll!TlsSetValue
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_00525684, .text + (0x00525684 - 0x401000)
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x00525917 - 0x401000
.globl FUN_00525917
FUN_00525917:
    # block 0x00525917: entry, 12 instruction(s), calls KERNEL32.dll!TlsGetValue, ends with je to 0x00525948 (forward)
    push ebp                                     # 00525917
    {load} mov ebp, esp                          # 00525918
    push ecx                                     # 0052591a
    push ebx                                     # 0052591b
    push esi                                     # 0052591c
    {load} mov esi, ecx                          # 0052591d
    push edi                                     # 0052591f
    push dword ptr [esi]                         # 00525920
    call dword ptr [0x52a0dc]                    # 00525922
    {load} mov edi, eax                          # 00525928
    test edi, edi                                # 0052592a
    je.d8 L_00525948                             # 0052592c
    # block 0x0052592e: entered by fall-through of je at 0x0052592c, 4 instruction(s), ends with jl to 0x005259ee (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0052592e
    lea ebx, [edi + field_8]                     # 00525931
    cmp eax, dword ptr [ebx]                     # 00525934
    jl.d32 L_005259ee                            # 00525936
    # block 0x0052593c: entered by fall-through of jl at 0x00525936, 2 instruction(s), ends with je to 0x005259ee (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 0052593c
    je.d32 L_005259ee                            # 00525940
    # block 0x00525946: entered by fall-through of je at 0x00525940, 1 instruction(s), ends with forward jump to 0x0052598a
    jmp.d8 L_0052598a                            # 00525946
L_00525948:
    # block 0x00525948: entered by je at 0x0052592c, 4 instruction(s), calls FUN_005256dd, ends with je to 0x0052595d (forward)
    push 0x10                                    # 00525948
    call FUN_005256dd                            # 0052594a
    test eax, eax                                # 0052594f
    je.d8 L_0052595d                             # 00525951
    # block 0x00525953: entered by fall-through of je at 0x00525951, 3 instruction(s), ends with forward jump to 0x0052595f
    mov dword ptr [eax], 0x52fe78                # 00525953
    {load} mov edi, eax                          # 00525959
    jmp.d8 L_0052595f                            # 0052595b
L_0052595d:
    # block 0x0052595d: entered by je at 0x00525951, 1 instruction(s), falls into the block at 0x0052595f
    {load} xor edi, edi                          # 0052595d
L_0052595f:
    # block 0x0052595f: entered by jmp at 0x0052595b, 13 instruction(s), calls KERNEL32.dll!EnterCriticalSection, FUN_00525684, KERNEL32.dll!LeaveCriticalSection, falls into the block at 0x0052598a
    and dword ptr [edi + field_8], 0x0           # 0052595f
    and dword ptr [edi + field_c], 0x0           # 00525963
    lea ebx, [edi + field_8]                     # 00525967
    lea eax, [esi + field_1c]                    # 0052596a
    push eax                                     # 0052596d
    mov dword ptr [ebp - local_4], edi           # 0052596e
    call dword ptr [0x52a0d0]                    # 00525971
    push edi                                     # 00525977
    lea ecx, [esi + field_14]                    # 00525978
    call FUN_00525684                            # 0052597b
    lea eax, [esi + field_1c]                    # 00525980
    push eax                                     # 00525983
    call dword ptr [0x52a0c8]                    # 00525984
L_0052598a:
    # block 0x0052598a: entered by jmp at 0x00525946, 3 instruction(s), ends with jne to 0x005259a2 (forward)
    mov eax, dword ptr [edi + field_c]           # 0052598a
    test eax, eax                                # 0052598d
    jne.d8 L_005259a2                            # 0052598f
    # block 0x00525991: entered by fall-through of jne at 0x0052598f, 6 instruction(s), calls KERNEL32.dll!LocalAlloc, ends with forward jump to 0x005259b2
    mov eax, dword ptr [esi + field_c]           # 00525991
    shl eax, 0x2                                 # 00525994
    push eax                                     # 00525997
    push 0x0                                     # 00525998
    call dword ptr [0x52a134]                    # 0052599a
    jmp.d8 L_005259b2                            # 005259a0
L_005259a2:
    # block 0x005259a2: entered by jne at 0x0052598f, 6 instruction(s), calls KERNEL32.dll!LocalReAlloc, falls into the block at 0x005259b2
    mov ecx, dword ptr [esi + field_c]           # 005259a2
    push 0x2                                     # 005259a5
    shl ecx, 0x2                                 # 005259a7
    push ecx                                     # 005259aa
    push eax                                     # 005259ab
    call dword ptr [0x52a0d8]                    # 005259ac
L_005259b2:
    # block 0x005259b2: entered by jmp at 0x005259a0, 3 instruction(s), ends with jne to 0x005259be (forward)
    test eax, eax                                # 005259b2
    mov dword ptr [edi + field_c], eax           # 005259b4
    jne.d8 L_005259be                            # 005259b7
    # block 0x005259b9: entered by fall-through of jne at 0x005259b7, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x005259be
    call FUN_00519cc0                            # 005259b9
L_005259be:
    # block 0x005259be: entered by jne at 0x005259b7, 17 instruction(s), calls FUN_0050f920, KERNEL32.dll!TlsSetValue, falls into the block at 0x005259ee
    mov eax, dword ptr [ebx]                     # 005259be
    {load} mov ecx, eax                          # 005259c0
    imul ecx, ecx, 0x3fffffff                    # 005259c2
    add ecx, dword ptr [esi + field_c]           # 005259c8
    shl ecx, 0x2                                 # 005259cb
    push ecx                                     # 005259ce
    mov ecx, dword ptr [edi + field_c]           # 005259cf
    push 0x0                                     # 005259d2
    lea eax, [ecx + 4*eax]                       # 005259d4
    push eax                                     # 005259d7
    call FUN_0050f920                            # 005259d8
    mov eax, dword ptr [esi + field_c]           # 005259dd
    add esp, 0xc                                 # 005259e0
    mov dword ptr [ebx], eax                     # 005259e3
    push edi                                     # 005259e5
    push dword ptr [esi]                         # 005259e6
    call dword ptr [0x52a0d4]                    # 005259e8
L_005259ee:
    # block 0x005259ee: entered by jl at 0x00525936; je at 0x00525940, 9 instruction(s), ends with ret 0x8
    mov eax, dword ptr [edi + field_c]           # 005259ee
    mov edx, dword ptr [ebp + arg_8]             # 005259f1
    mov ecx, dword ptr [ebp + arg_c]             # 005259f4
    pop edi                                      # 005259f7
    pop esi                                      # 005259f8
    mov dword ptr [eax + 4*edx], ecx             # 005259f9
    pop ebx                                      # 005259fc
    leave                                        # 005259fd
    ret 0x8                                      # 005259fe

