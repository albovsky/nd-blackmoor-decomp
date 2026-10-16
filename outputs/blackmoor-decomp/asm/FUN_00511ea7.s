# FUN_00511ea7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511ea7
# extent:       0x00511ea7-0x00511f26 (127 code bytes)
# span:         0x00511ea7-0x00511f30 (code 127, tables 0, padding 10)
# sha256:       bd10dbb766a9db3a79268212495388478a48e38400a70f8e5ed50d73cddf5e02
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511ea7
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_18
# fields:       [eax + n] field_4, field_10
# callees:      calls FUN_00516f69, FUN_00516d51
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00516d51, .text + (0x00516d51 - 0x401000)
.set FUN_00516f69, .text + (0x00516f69 - 0x401000)

.org 0x00511ea7 - 0x401000
.globl FUN_00511ea7
FUN_00511ea7:
    # block 0x00511ea7: entry, 22 instruction(s), calls FUN_00516f69, ends with je to 0x00511edf (forward)
    push ebp                                     # 00511ea7
    {load} mov ebp, esp                          # 00511ea8
    sub esp, 0x18                                # 00511eaa
    push ebx                                     # 00511ead
    push esi                                     # 00511eae
    {load} xor esi, esi                          # 00511eaf
    push edi                                     # 00511eb1
    push esi                                     # 00511eb2
    push esi                                     # 00511eb3
    push esi                                     # 00511eb4
    push esi                                     # 00511eb5
    push dword ptr [ebp + arg_c]                 # 00511eb6
    lea eax, [ebp - local_4]                     # 00511eb9
    {load} xor edi, edi                          # 00511ebc
    push eax                                     # 00511ebe
    lea eax, [ebp - local_18]                    # 00511ebf
    push eax                                     # 00511ec2
    call FUN_00516f69                            # 00511ec3
    {load} mov ebx, eax                          # 00511ec8
    add esp, 0x1c                                # 00511eca
    test bl, 0x4                                 # 00511ecd
    je.d8 L_00511edf                             # 00511ed0
    # block 0x00511ed2: entered by fall-through of je at 0x00511ed0, 4 instruction(s), ends with forward jump to 0x00511f0d
    mov edi, 0x200                               # 00511ed2
    mov dword ptr [ebp - local_c], esi           # 00511ed7
    mov dword ptr [ebp - local_8], esi           # 00511eda
    jmp.d8 L_00511f0d                            # 00511edd
L_00511edf:
    # block 0x00511edf: entered by je at 0x00511ed0, 9 instruction(s), calls FUN_00516d51, ends with jne to 0x00511ef8 (forward)
    lea eax, [ebp - local_c]                     # 00511edf
    push eax                                     # 00511ee2
    lea eax, [ebp - local_18]                    # 00511ee3
    push eax                                     # 00511ee6
    call FUN_00516d51                            # 00511ee7
    pop ecx                                      # 00511eec
    test bl, 0x2                                 # 00511eed
    pop ecx                                      # 00511ef0
    jne.d8 L_00511ef8                            # 00511ef1
    # block 0x00511ef3: entered by fall-through of jne at 0x00511ef1, 2 instruction(s), ends with jne to 0x00511efd (forward)
    cmp eax, 0x1                                 # 00511ef3
    jne.d8 L_00511efd                            # 00511ef6
L_00511ef8:
    # block 0x00511ef8: entered by jne at 0x00511ef1; fall-through of jne at 0x00511ef6, 1 instruction(s), falls into the block at 0x00511efd
    mov edi, 0x80                                # 00511ef8
L_00511efd:
    # block 0x00511efd: entered by jne at 0x00511ef6, 2 instruction(s), ends with jne to 0x00511f07 (forward)
    test bl, 0x1                                 # 00511efd
    jne.d8 L_00511f07                            # 00511f00
    # block 0x00511f02: entered by fall-through of jne at 0x00511f00, 2 instruction(s), ends with jne to 0x00511f0d (forward)
    cmp eax, 0x2                                 # 00511f02
    jne.d8 L_00511f0d                            # 00511f05
L_00511f07:
    # block 0x00511f07: entered by jne at 0x00511f00; fall-through of jne at 0x00511f05, 1 instruction(s), falls into the block at 0x00511f0d
    or edi, 0x100                                # 00511f07
L_00511f0d:
    # block 0x00511f0d: entered by jmp at 0x00511edd; jne at 0x00511f05, 12 instruction(s), ends with ret
    mov eax, dword ptr [ebp + arg_8]             # 00511f0d
    mov ecx, dword ptr [ebp - local_4]           # 00511f10
    sub ecx, dword ptr [ebp + arg_c]             # 00511f13
    fld qword ptr [ebp - local_c]                # 00511f16
    mov dword ptr [eax], edi                     # 00511f19
    pop edi                                      # 00511f1b
    fstp qword ptr [eax + field_10]              # 00511f1c
    pop esi                                      # 00511f1f
    mov dword ptr [eax + field_4], ecx           # 00511f20
    pop ebx                                      # 00511f23
    leave                                        # 00511f24
    ret                                          # 00511f25

# --- data items (not part of the function) -------------------------
.org 0x00511f26 - 0x401000
PAD_00511f26:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

