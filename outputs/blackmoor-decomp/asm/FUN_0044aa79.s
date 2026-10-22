# FUN_0044aa79
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044aa79
# extent:       0x0044aa79-0x0044ac3a (449 code bytes)
# span:         0x0044aa79-0x0044ac3a (code 449, tables 0, padding 0)
# sha256:       cd6bb11c3f61b3d94c071523a29081d61a3523695593122201307ab73562cc1a
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44aa79_lifted
# naming:       native port src/original_methods_fl40.c:m44aa79_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 134/134 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_18, local_1c, local_20, local_28, local_30, local_34, local_3c, local_40 and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!CreateFileA, FUN_004264e8, KERNEL32.dll!GetFileTime, KERNEL32.dll!CloseHandle, KERNEL32.dll!FileTimeToLocalFileTime, KERNEL32.dll!FileTimeToDosDateTime, FUN_0050ca3e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44aa79_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 134 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_28, 0x28  # offset -0x28
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0044aa79 - 0x401000
.globl FUN_0044aa79
FUN_0044aa79:
    # block 0x0044aa79: entry, 24 instruction(s), calls KERNEL32.dll!CreateFileA, ends with jne to 0x0044aad4 (forward)
    push ebp                                     # 0044aa79
    {load} mov ebp, esp                          # 0044aa7a
    sub esp, 0x44                                # 0044aa7c
    push edi                                     # 0044aa7f
    movsx ecx, word ptr [ebp + arg_c]            # 0044aa80
    {load} xor eax, eax                          # 0044aa84
    mov edi, dword ptr [ebp + arg_8]             # 0044aa86
    {load} mov edx, ecx                          # 0044aa89
    shr ecx, 0x2                                 # 0044aa8b
    rep stosd dword ptr es:[edi], eax            # 0044aa8e
    {load} mov ecx, edx                          # 0044aa90
    and ecx, 0x3                                 # 0044aa92
    rep stosb byte ptr es:[edi], al              # 0044aa95
    push 0x0                                     # 0044aa97
    push 0x80                                    # 0044aa99
    push 0x3                                     # 0044aa9e
    push 0x0                                     # 0044aaa0
    push 0x1                                     # 0044aaa2
    push 0x80000000                              # 0044aaa4
    push 0x63999b                                # 0044aaa9
    call dword ptr [0x52a2bc]                    # 0044aaae
    mov dword ptr [ebp - local_40], eax          # 0044aab4
    cmp dword ptr [ebp - local_40], -0x1         # 0044aab7
    jne.d8 L_0044aad4                            # 0044aabb
    # block 0x0044aabd: entered by fall-through of jne at 0x0044aabb, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x0044ac35
    push 0x548ce8                                # 0044aabd
    mov ecx, 0x583979                            # 0044aac2
    call FUN_004264e8                            # 0044aac7
    mov eax, dword ptr [ebp + arg_8]             # 0044aacc
    jmp.d32 L_0044ac35                           # 0044aacf
L_0044aad4:
    # block 0x0044aad4: entered by jne at 0x0044aabb, 11 instruction(s), calls KERNEL32.dll!GetFileTime, ends with jne to 0x0044ab0f (forward)
    lea eax, [ebp - local_3c]                    # 0044aad4
    push eax                                     # 0044aad7
    lea ecx, [ebp - local_30]                    # 0044aad8
    push ecx                                     # 0044aadb
    lea edx, [ebp - local_18]                    # 0044aadc
    push edx                                     # 0044aadf
    mov eax, dword ptr [ebp - local_40]          # 0044aae0
    push eax                                     # 0044aae3
    call dword ptr [0x52a258]                    # 0044aae4
    test eax, eax                                # 0044aaea
    jne.d8 L_0044ab0f                            # 0044aaec
    # block 0x0044aaee: entered by fall-through of jne at 0x0044aaec, 8 instruction(s), calls KERNEL32.dll!CloseHandle, FUN_004264e8, ends with forward jump to 0x0044ac35
    mov ecx, dword ptr [ebp - local_40]          # 0044aaee
    push ecx                                     # 0044aaf1
    call dword ptr [0x52a2b8]                    # 0044aaf2
    push 0x548d18                                # 0044aaf8
    mov ecx, 0x583979                            # 0044aafd
    call FUN_004264e8                            # 0044ab02
    mov eax, dword ptr [ebp + arg_8]             # 0044ab07
    jmp.d32 L_0044ac35                           # 0044ab0a
L_0044ab0f:
    # block 0x0044ab0f: entered by jne at 0x0044aaec, 17 instruction(s), calls KERNEL32.dll!FileTimeToLocalFileTime, KERNEL32.dll!FileTimeToDosDateTime, ends with jne to 0x0044ab62 (forward)
    lea edx, [ebp - local_28]                    # 0044ab0f
    push edx                                     # 0044ab12
    lea eax, [ebp - local_3c]                    # 0044ab13
    push eax                                     # 0044ab16
    call dword ptr [0x52a25c]                    # 0044ab17
    mov word ptr [ebp - local_44], 0x0           # 0044ab1d
    mov cx, word ptr [ebp - local_44]            # 0044ab23
    mov word ptr [ebp - local_10], cx            # 0044ab27
    lea edx, [ebp - local_44]                    # 0044ab2b
    push edx                                     # 0044ab2e
    lea eax, [ebp - local_10]                    # 0044ab2f
    push eax                                     # 0044ab32
    lea ecx, [ebp - local_28]                    # 0044ab33
    push ecx                                     # 0044ab36
    call dword ptr [0x52a260]                    # 0044ab37
    test eax, eax                                # 0044ab3d
    jne.d8 L_0044ab62                            # 0044ab3f
    # block 0x0044ab41: entered by fall-through of jne at 0x0044ab3f, 8 instruction(s), calls KERNEL32.dll!CloseHandle, FUN_004264e8, ends with forward jump to 0x0044ac35
    mov edx, dword ptr [ebp - local_40]          # 0044ab41
    push edx                                     # 0044ab44
    call dword ptr [0x52a2b8]                    # 0044ab45
    push 0x548d44                                # 0044ab4b
    mov ecx, 0x583979                            # 0044ab50
    call FUN_004264e8                            # 0044ab55
    mov eax, dword ptr [ebp + arg_8]             # 0044ab5a
    jmp.d32 L_0044ac35                           # 0044ab5d
L_0044ab62:
    # block 0x0044ab62: entered by jne at 0x0044ab3f, 57 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!CloseHandle, falls into the block at 0x0044ac35
    mov eax, dword ptr [ebp - local_10]          # 0044ab62
    and eax, 0xffff                              # 0044ab65
    and eax, 0xfe00                              # 0044ab6a
    sar eax, 0x9                                 # 0044ab6f
    add eax, 0x7bc                               # 0044ab72
    mov word ptr [ebp - local_4], ax             # 0044ab77
    mov ecx, dword ptr [ebp - local_10]          # 0044ab7b
    and ecx, 0xffff                              # 0044ab7e
    and ecx, 0x1e0                               # 0044ab84
    sar ecx, 0x5                                 # 0044ab8a
    mov word ptr [ebp - local_20], cx            # 0044ab8d
    mov edx, dword ptr [ebp - local_10]          # 0044ab91
    and edx, 0xffff                              # 0044ab94
    and edx, 0x1f                                # 0044ab9a
    mov word ptr [ebp - local_c], dx             # 0044ab9d
    mov eax, dword ptr [ebp - local_44]          # 0044aba1
    and eax, 0xffff                              # 0044aba4
    and eax, 0xf800                              # 0044aba9
    sar eax, 0xb                                 # 0044abae
    mov word ptr [ebp - local_1c], ax            # 0044abb1
    mov ecx, dword ptr [ebp - local_44]          # 0044abb5
    and ecx, 0xffff                              # 0044abb8
    and ecx, 0x7e0                               # 0044abbe
    sar ecx, 0x5                                 # 0044abc4
    mov word ptr [ebp - local_8], cx             # 0044abc7
    mov edx, dword ptr [ebp - local_44]          # 0044abcb
    and edx, 0xffff                              # 0044abce
    and edx, 0x1f                                # 0044abd4
    shl edx                                      # 0044abd7
    mov word ptr [ebp - local_34], dx            # 0044abd9
    mov eax, dword ptr [ebp - local_34]          # 0044abdd
    and eax, 0xffff                              # 0044abe0
    push eax                                     # 0044abe5
    mov ecx, dword ptr [ebp - local_8]           # 0044abe6
    and ecx, 0xffff                              # 0044abe9
    push ecx                                     # 0044abef
    mov edx, dword ptr [ebp - local_1c]          # 0044abf0
    and edx, 0xffff                              # 0044abf3
    push edx                                     # 0044abf9
    mov eax, dword ptr [ebp - local_4]           # 0044abfa
    and eax, 0xffff                              # 0044abfd
    push eax                                     # 0044ac02
    mov ecx, dword ptr [ebp - local_c]           # 0044ac03
    and ecx, 0xffff                              # 0044ac06
    push ecx                                     # 0044ac0c
    mov edx, dword ptr [ebp - local_20]          # 0044ac0d
    and edx, 0xffff                              # 0044ac10
    push edx                                     # 0044ac16
    push 0x548d7c                                # 0044ac17
    mov eax, dword ptr [ebp + arg_8]             # 0044ac1c
    push eax                                     # 0044ac1f
    call FUN_0050ca3e                            # 0044ac20
    add esp, 0x20                                # 0044ac25
    mov ecx, dword ptr [ebp - local_40]          # 0044ac28
    push ecx                                     # 0044ac2b
    call dword ptr [0x52a2b8]                    # 0044ac2c
    mov eax, dword ptr [ebp + arg_8]             # 0044ac32
L_0044ac35:
    # block 0x0044ac35: entered by jmp at 0x0044aacf; jmp at 0x0044ab0a; jmp at 0x0044ab5d, 4 instruction(s), ends with ret
    pop edi                                      # 0044ac35
    {load} mov esp, ebp                          # 0044ac36
    pop ebp                                      # 0044ac38
    ret                                          # 0044ac39

