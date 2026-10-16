# FUN_00512d28
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512d28
# extent:       0x00512d28-0x00512ee4 (444 code bytes)
# span:         0x00512d28-0x00512ee4 (code 444, tables 0, padding 0)
# sha256:       069fb9c2e3d41d0f43c7e0e95908dd7f019130564e02980c05491a61965c7077
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512d28
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_14, local_16, local_48
# fields:       [eax + n] field_4, field_5, field_8, field_480; [esi + n] field_4, field_5, field_8, field_480
# callees:      calls FUN_0050ea90, FUN_0050e8ed, KERNEL32.dll!GetStartupInfoA, KERNEL32.dll!GetFileType, KERNEL32.dll!GetStdHandle, KERNEL32.dll!SetHandleCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 150 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_14, 0x14  # offset -0x14
.equ local_16, 0x16  # offset -0x16
.equ local_48, 0x48  # offset -0x48
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ field_8, 0x8  # offset +0x8
.equ field_480, 0x480  # offset +0x480

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x00512d28 - 0x401000
.globl FUN_00512d28
FUN_00512d28:
    # block 0x00512d28: entry, 12 instruction(s), calls FUN_0050ea90, ends with jne to 0x00512d4a (forward)
    push ebp                                     # 00512d28
    {load} mov ebp, esp                          # 00512d29
    sub esp, 0x48                                # 00512d2b
    push ebx                                     # 00512d2e
    push esi                                     # 00512d2f
    push edi                                     # 00512d30
    push 0x480                                   # 00512d31
    call FUN_0050ea90                            # 00512d36
    {load} mov esi, eax                          # 00512d3b
    pop ecx                                      # 00512d3d
    test esi, esi                                # 00512d3e
    jne.d8 L_00512d4a                            # 00512d40
    # block 0x00512d42: entered by fall-through of jne at 0x00512d40, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x00512d4a
    push 0x1b                                    # 00512d42
    call FUN_0050e8ed                            # 00512d44
    pop ecx                                      # 00512d49
L_00512d4a:
    # block 0x00512d4a: entered by jne at 0x00512d40, 3 instruction(s), falls into the block at 0x00512d60
    mov dword ptr [0x63cde0], esi                # 00512d4a
    mov dword ptr [0x63cee0], 0x20               # 00512d50
    lea eax, [esi + field_480]                   # 00512d5a
L_00512d60:
    # block 0x00512d60: entered by jmp at 0x00512d80, 2 instruction(s), ends with jae to 0x00512d82 (forward)
    {load} cmp esi, eax                          # 00512d60
    jae.d8 L_00512d82                            # 00512d62
    # block 0x00512d64: entered by fall-through of jae at 0x00512d62, 8 instruction(s), ends with backward jump to 0x00512d60
    and byte ptr [esi + field_4], 0x0            # 00512d64
    or dword ptr [esi], -0x1                     # 00512d68
    and dword ptr [esi + field_8], 0x0           # 00512d6b
    mov byte ptr [esi + field_5], 0xa            # 00512d6f
    mov eax, dword ptr [0x63cde0]                # 00512d73
    add esi, 0x24                                # 00512d78
    add eax, 0x480                               # 00512d7b
    jmp.d8 L_00512d60                            # 00512d80
L_00512d82:
    # block 0x00512d82: entered by jae at 0x00512d62, 5 instruction(s), calls KERNEL32.dll!GetStartupInfoA, ends with je to 0x00512e68 (forward)
    lea eax, [ebp - local_48]                    # 00512d82
    push eax                                     # 00512d85
    call dword ptr [0x52a144]                    # 00512d86
    cmp word ptr [ebp - local_16], 0x0           # 00512d8c
    je.d32 L_00512e68                            # 00512d91
    # block 0x00512d97: entered by fall-through of je at 0x00512d91, 3 instruction(s), ends with je to 0x00512e68 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00512d97
    test eax, eax                                # 00512d9a
    je.d32 L_00512e68                            # 00512d9c
    # block 0x00512da2: entered by fall-through of je at 0x00512d9c, 7 instruction(s), ends with jl to 0x00512db8 (forward)
    mov edi, dword ptr [eax]                     # 00512da2
    lea ebx, [eax + field_4]                     # 00512da4
    lea eax, [ebx + edi]                         # 00512da7
    mov dword ptr [ebp - local_4], eax           # 00512daa
    mov eax, 0x800                               # 00512dad
    {load} cmp edi, eax                          # 00512db2
    jl.d8 L_00512db8                             # 00512db4
    # block 0x00512db6: entered by fall-through of jl at 0x00512db4, 1 instruction(s), falls into the block at 0x00512db8
    {load} mov edi, eax                          # 00512db6
L_00512db8:
    # block 0x00512db8: entered by jl at 0x00512db4, 2 instruction(s), ends with jge to 0x00512e16 (forward)
    cmp dword ptr [0x63cee0], edi                # 00512db8
    jge.d8 L_00512e16                            # 00512dbe
    # block 0x00512dc0: entered by fall-through of jge at 0x00512dbe, 1 instruction(s), falls into the block at 0x00512dc5
    mov esi, 0x63cde4                            # 00512dc0
L_00512dc5:
    # block 0x00512dc5: entered by jl at 0x00512e0c, 5 instruction(s), calls FUN_0050ea90, ends with je to 0x00512e10 (forward)
    push 0x480                                   # 00512dc5
    call FUN_0050ea90                            # 00512dca
    test eax, eax                                # 00512dcf
    pop ecx                                      # 00512dd1
    je.d8 L_00512e10                             # 00512dd2
    # block 0x00512dd4: entered by fall-through of je at 0x00512dd2, 3 instruction(s), falls into the block at 0x00512de3
    add dword ptr [0x63cee0], 0x20               # 00512dd4
    mov dword ptr [esi], eax                     # 00512ddb
    lea ecx, [eax + field_480]                   # 00512ddd
L_00512de3:
    # block 0x00512de3: entered by jmp at 0x00512e01, 2 instruction(s), ends with jae to 0x00512e03 (forward)
    {load} cmp eax, ecx                          # 00512de3
    jae.d8 L_00512e03                            # 00512de5
    # block 0x00512de7: entered by fall-through of jae at 0x00512de5, 8 instruction(s), ends with backward jump to 0x00512de3
    and byte ptr [eax + field_4], 0x0            # 00512de7
    or dword ptr [eax], -0x1                     # 00512deb
    and dword ptr [eax + field_8], 0x0           # 00512dee
    mov byte ptr [eax + field_5], 0xa            # 00512df2
    mov ecx, dword ptr [esi]                     # 00512df6
    add eax, 0x24                                # 00512df8
    add ecx, 0x480                               # 00512dfb
    jmp.d8 L_00512de3                            # 00512e01
L_00512e03:
    # block 0x00512e03: entered by jae at 0x00512de5, 3 instruction(s), ends with jl to 0x00512dc5 (backward)
    add esi, 0x4                                 # 00512e03
    cmp dword ptr [0x63cee0], edi                # 00512e06
    jl.d8 L_00512dc5                             # 00512e0c
    # block 0x00512e0e: entered by fall-through of jl at 0x00512e0c, 1 instruction(s), ends with forward jump to 0x00512e16
    jmp.d8 L_00512e16                            # 00512e0e
L_00512e10:
    # block 0x00512e10: entered by je at 0x00512dd2, 1 instruction(s), falls into the block at 0x00512e16
    mov edi, dword ptr [0x63cee0]                # 00512e10
L_00512e16:
    # block 0x00512e16: entered by jge at 0x00512dbe; jmp at 0x00512e0e, 3 instruction(s), ends with jle to 0x00512e68 (forward)
    {load} xor esi, esi                          # 00512e16
    test edi, edi                                # 00512e18
    jle.d8 L_00512e68                            # 00512e1a
L_00512e1c:
    # block 0x00512e1c: entered by jl at 0x00512e66; fall-through of jle at 0x00512e1a, 4 instruction(s), ends with je to 0x00512e5e (forward)
    mov eax, dword ptr [ebp - local_4]           # 00512e1c
    mov ecx, dword ptr [eax]                     # 00512e1f
    cmp ecx, -0x1                                # 00512e21
    je.d8 L_00512e5e                             # 00512e24
    # block 0x00512e26: entered by fall-through of je at 0x00512e24, 3 instruction(s), ends with je to 0x00512e5e (forward)
    mov al, byte ptr [ebx]                       # 00512e26
    test al, 0x1                                 # 00512e28
    je.d8 L_00512e5e                             # 00512e2a
    # block 0x00512e2c: entered by fall-through of je at 0x00512e2a, 2 instruction(s), ends with jne to 0x00512e3b (forward)
    test al, 0x8                                 # 00512e2c
    jne.d8 L_00512e3b                            # 00512e2e
    # block 0x00512e30: entered by fall-through of jne at 0x00512e2e, 4 instruction(s), calls KERNEL32.dll!GetFileType, ends with je to 0x00512e5e (forward)
    push ecx                                     # 00512e30
    call dword ptr [0x52a17c]                    # 00512e31
    test eax, eax                                # 00512e37
    je.d8 L_00512e5e                             # 00512e39
L_00512e3b:
    # block 0x00512e3b: entered by jne at 0x00512e2e; fall-through of je at 0x00512e39, 12 instruction(s), falls into the block at 0x00512e5e
    {load} mov ecx, esi                          # 00512e3b
    {load} mov eax, esi                          # 00512e3d
    sar ecx, 0x5                                 # 00512e3f
    and eax, 0x1f                                # 00512e42
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00512e45
    lea eax, [eax + 8*eax]                       # 00512e4c
    lea eax, [ecx + 4*eax]                       # 00512e4f
    mov ecx, dword ptr [ebp - local_4]           # 00512e52
    mov ecx, dword ptr [ecx]                     # 00512e55
    mov dword ptr [eax], ecx                     # 00512e57
    mov cl, byte ptr [ebx]                       # 00512e59
    mov byte ptr [eax + field_4], cl             # 00512e5b
L_00512e5e:
    # block 0x00512e5e: entered by je at 0x00512e24; je at 0x00512e2a; je at 0x00512e39, 5 instruction(s), ends with jl to 0x00512e1c (backward)
    add dword ptr [ebp - local_4], 0x4           # 00512e5e
    inc esi                                      # 00512e62
    inc ebx                                      # 00512e63
    {load} cmp esi, edi                          # 00512e64
    jl.d8 L_00512e1c                             # 00512e66
L_00512e68:
    # block 0x00512e68: entered by je at 0x00512d91; je at 0x00512d9c; jle at 0x00512e1a; fall-through of jl at 0x00512e66, 1 instruction(s), falls into the block at 0x00512e6a
    {load} xor ebx, ebx                          # 00512e68
L_00512e6a:
    # block 0x00512e6a: entered by jl at 0x00512ed1, 5 instruction(s), ends with jne to 0x00512ec9 (forward)
    mov ecx, dword ptr [0x63cde0]                # 00512e6a
    lea eax, [ebx + 8*ebx]                       # 00512e70
    cmp dword ptr [ecx + 4*eax], -0x1            # 00512e73
    lea esi, [ecx + 4*eax]                       # 00512e77
    jne.d8 L_00512ec9                            # 00512e7a
    # block 0x00512e7c: entered by fall-through of jne at 0x00512e7a, 3 instruction(s), ends with jne to 0x00512e89 (forward)
    test ebx, ebx                                # 00512e7c
    mov byte ptr [esi + field_4], -0x7f          # 00512e7e
    jne.d8 L_00512e89                            # 00512e82
    # block 0x00512e84: entered by fall-through of jne at 0x00512e82, 3 instruction(s), ends with forward jump to 0x00512e93
    push -0xa                                    # 00512e84
    pop eax                                      # 00512e86
    jmp.d8 L_00512e93                            # 00512e87
L_00512e89:
    # block 0x00512e89: entered by jne at 0x00512e82, 5 instruction(s), falls into the block at 0x00512e93
    {load} mov eax, ebx                          # 00512e89
    dec eax                                      # 00512e8b
    neg eax                                      # 00512e8c
    {load} sbb eax, eax                          # 00512e8e
    add eax, -0xb                                # 00512e90
L_00512e93:
    # block 0x00512e93: entered by jmp at 0x00512e87, 5 instruction(s), calls KERNEL32.dll!GetStdHandle, ends with je to 0x00512eb8 (forward)
    push eax                                     # 00512e93
    call dword ptr [0x52a178]                    # 00512e94
    {load} mov edi, eax                          # 00512e9a
    cmp edi, -0x1                                # 00512e9c
    je.d8 L_00512eb8                             # 00512e9f
    # block 0x00512ea1: entered by fall-through of je at 0x00512e9f, 4 instruction(s), calls KERNEL32.dll!GetFileType, ends with je to 0x00512eb8 (forward)
    push edi                                     # 00512ea1
    call dword ptr [0x52a17c]                    # 00512ea2
    test eax, eax                                # 00512ea8
    je.d8 L_00512eb8                             # 00512eaa
    # block 0x00512eac: entered by fall-through of je at 0x00512eaa, 4 instruction(s), ends with jne to 0x00512ebe (forward)
    and eax, 0xff                                # 00512eac
    mov dword ptr [esi], edi                     # 00512eb1
    cmp eax, 0x2                                 # 00512eb3
    jne.d8 L_00512ebe                            # 00512eb6
L_00512eb8:
    # block 0x00512eb8: entered by je at 0x00512e9f; je at 0x00512eaa; fall-through of jne at 0x00512eb6, 2 instruction(s), ends with forward jump to 0x00512ecd
    or byte ptr [esi + field_4], 0x40            # 00512eb8
    jmp.d8 L_00512ecd                            # 00512ebc
L_00512ebe:
    # block 0x00512ebe: entered by jne at 0x00512eb6, 2 instruction(s), ends with jne to 0x00512ecd (forward)
    cmp eax, 0x3                                 # 00512ebe
    jne.d8 L_00512ecd                            # 00512ec1
    # block 0x00512ec3: entered by fall-through of jne at 0x00512ec1, 2 instruction(s), ends with forward jump to 0x00512ecd
    or byte ptr [esi + field_4], 0x8             # 00512ec3
    jmp.d8 L_00512ecd                            # 00512ec7
L_00512ec9:
    # block 0x00512ec9: entered by jne at 0x00512e7a, 1 instruction(s), falls into the block at 0x00512ecd
    or byte ptr [esi + field_4], -0x80           # 00512ec9
L_00512ecd:
    # block 0x00512ecd: entered by jmp at 0x00512ebc; jne at 0x00512ec1; jmp at 0x00512ec7, 3 instruction(s), ends with jl to 0x00512e6a (backward)
    inc ebx                                      # 00512ecd
    cmp ebx, 0x3                                 # 00512ece
    jl.d8 L_00512e6a                             # 00512ed1
    # block 0x00512ed3: entered by fall-through of jl at 0x00512ed1, 7 instruction(s), calls KERNEL32.dll!SetHandleCount, ends with ret
    push dword ptr [0x63cee0]                    # 00512ed3
    call dword ptr [0x52a174]                    # 00512ed9
    pop edi                                      # 00512edf
    pop esi                                      # 00512ee0
    pop ebx                                      # 00512ee1
    leave                                        # 00512ee2
    ret                                          # 00512ee3

