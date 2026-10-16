# FUN_00501b70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501b70
# extent:       0x00501b70-0x00501c33 (195 code bytes)
# span:         0x00501b70-0x00501c40 (code 195, tables 0, padding 13)
# sha256:       188bd93c28896406e0a6e24f70cde2c47f1556f473491b11a4307da54659a362
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501b70
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_18
# fields:       [eax + n] field_4; [edi + n] field_1fc, field_200
# callees:      calls FUN_0050c920, FUN_0050f085
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 78 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1fc, 0x1fc  # offset +0x1fc
.equ field_200, 0x200  # offset +0x200

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050f085, .text + (0x0050f085 - 0x401000)

.org 0x00501b70 - 0x401000
.globl FUN_00501b70
FUN_00501b70:
    # block 0x00501b70: entry, 22 instruction(s), calls FUN_0050c920, ends with jge to 0x00501c29 (forward)
    push ebp                                     # 00501b70
    {load} mov ebp, esp                          # 00501b71
    sub esp, 0xc                                 # 00501b73
    mov eax, dword ptr [ebp + arg_8]             # 00501b76
    push ebx                                     # 00501b79
    push esi                                     # 00501b7a
    push edi                                     # 00501b7b
    mov edi, dword ptr [eax + field_4]           # 00501b7c
    mov ecx, dword ptr [eax]                     # 00501b7f
    mov dword ptr [ebp + arg_8], ecx             # 00501b81
    mov esi, dword ptr [edi + field_200]         # 00501b84
    lea eax, [4*esi]                             # 00501b8a
    add eax, 0x3                                 # 00501b91
    and al, -0x4                                 # 00501b94
    call FUN_0050c920                            # 00501b96
    mov edi, dword ptr [edi + field_1fc]         # 00501b9b
    mov eax, dword ptr [ebp + arg_8]             # 00501ba1
    {load} mov ebx, esp                          # 00501ba4
    {load} cmp edi, eax                          # 00501ba6
    mov dword ptr [ebp - local_8], ebx           # 00501ba8
    mov dword ptr [ebp - local_c], edi           # 00501bab
    jge.d8 L_00501c29                            # 00501bae
    # block 0x00501bb0: entered by fall-through of jge at 0x00501bae, 1 instruction(s), ends with forward jump to 0x00501bb5
    jmp.d8 L_00501bb5                            # 00501bb0
L_00501bb2:
    # block 0x00501bb2: entered by jl at 0x00501c27, 1 instruction(s), falls into the block at 0x00501bb5
    mov eax, dword ptr [ebp + arg_8]             # 00501bb2
L_00501bb5:
    # block 0x00501bb5: entered by jmp at 0x00501bb0, 3 instruction(s), ends with jle to 0x00501bc0 (forward)
    lea edx, [edi + esi]                         # 00501bb5
    {load} cmp edx, eax                          # 00501bb8
    jle.d8 L_00501bc0                            # 00501bba
    # block 0x00501bbc: entered by fall-through of jle at 0x00501bba, 2 instruction(s), falls into the block at 0x00501bc0
    {load} mov esi, eax                          # 00501bbc
    {load} sub esi, edi                          # 00501bbe
L_00501bc0:
    # block 0x00501bc0: entered by jle at 0x00501bba, 2 instruction(s), ends with jle to 0x00501bd9 (forward)
    test esi, esi                                # 00501bc0
    jle.d8 L_00501bd9                            # 00501bc2
    # block 0x00501bc4: entered by fall-through of jle at 0x00501bc2, 4 instruction(s), falls into the block at 0x00501bce
    mov eax, dword ptr [ebp + arg_c]             # 00501bc4
    {load} mov ecx, ebx                          # 00501bc7
    {load} mov edx, esi                          # 00501bc9
    lea eax, [eax + 4*edi]                       # 00501bcb
L_00501bce:
    # block 0x00501bce: entered by jne at 0x00501bd7, 5 instruction(s), ends with jne to 0x00501bce (backward)
    mov dword ptr [ecx], eax                     # 00501bce
    add eax, 0x4                                 # 00501bd0
    add ecx, 0x4                                 # 00501bd3
    dec edx                                      # 00501bd6
    jne.d8 L_00501bce                            # 00501bd7
L_00501bd9:
    # block 0x00501bd9: entered by jle at 0x00501bc2; fall-through of jne at 0x00501bd7, 8 instruction(s), calls FUN_0050f085, ends with jle to 0x00501c20 (forward)
    push 0x501b40                                # 00501bd9
    push 0x4                                     # 00501bde
    push esi                                     # 00501be0
    push ebx                                     # 00501be1
    call FUN_0050f085                            # 00501be2
    add esp, 0x10                                # 00501be7
    test esi, esi                                # 00501bea
    jle.d8 L_00501c20                            # 00501bec
    # block 0x00501bee: entered by fall-through of jle at 0x00501bec, 2 instruction(s), falls into the block at 0x00501bf3
    {load} xor ecx, ecx                          # 00501bee
    mov dword ptr [ebp - local_4], esi           # 00501bf0
L_00501bf3:
    # block 0x00501bf3: entered by jne at 0x00501c1e, 17 instruction(s), ends with jne to 0x00501bf3 (backward)
    mov edx, dword ptr [ebp - local_c]           # 00501bf3
    {load} mov eax, ecx                          # 00501bf6
    shl edx, 0x2                                 # 00501bf8
    {load} sub eax, edx                          # 00501bfb
    mov edx, dword ptr [ecx + ebx]               # 00501bfd
    mov ebx, dword ptr [ebp + arg_c]             # 00501c00
    add ecx, 0x4                                 # 00501c03
    {load} sub edx, ebx                          # 00501c06
    mov ebx, dword ptr [ebp + arg_10]            # 00501c08
    lea eax, [eax + 4*edi]                       # 00501c0b
    sar edx, 0x2                                 # 00501c0e
    mov dword ptr [eax + ebx], edx               # 00501c11
    mov eax, dword ptr [ebp - local_4]           # 00501c14
    mov ebx, dword ptr [ebp - local_8]           # 00501c17
    dec eax                                      # 00501c1a
    mov dword ptr [ebp - local_4], eax           # 00501c1b
    jne.d8 L_00501bf3                            # 00501c1e
L_00501c20:
    # block 0x00501c20: entered by jle at 0x00501bec; fall-through of jne at 0x00501c1e, 4 instruction(s), ends with jl to 0x00501bb2 (backward)
    mov eax, dword ptr [ebp + arg_8]             # 00501c20
    {load} add edi, esi                          # 00501c23
    {load} cmp edi, eax                          # 00501c25
    jl.d8 L_00501bb2                             # 00501c27
L_00501c29:
    # block 0x00501c29: entered by jge at 0x00501bae; fall-through of jl at 0x00501c27, 7 instruction(s), ends with ret
    lea esp, [ebp - local_18]                    # 00501c29
    pop edi                                      # 00501c2c
    pop esi                                      # 00501c2d
    pop ebx                                      # 00501c2e
    {load} mov esp, ebp                          # 00501c2f
    pop ebp                                      # 00501c31
    ret                                          # 00501c32

# --- data items (not part of the function) -------------------------
.org 0x00501c33 - 0x401000
PAD_00501c33:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

