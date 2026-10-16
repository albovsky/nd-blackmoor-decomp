# FUN_00518caf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518caf
# extent:       0x00518caf-0x00518d76 (199 code bytes)
# span:         0x00518caf-0x00518d76 (code 199, tables 0, padding 0)
# sha256:       322d469e098681b4a4855f2bd0c58102722573a61e08131a39c22c68f9eec60c
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518caf
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [ebx + n] field_4, field_8, field_a
# callees:      calls FUN_00518c54, FUN_00518bf6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 76 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00518bf6, .text + (0x00518bf6 - 0x401000)
.set FUN_00518c54, .text + (0x00518c54 - 0x401000)

.org 0x00518caf - 0x401000
.globl FUN_00518caf
FUN_00518caf:
    # block 0x00518caf: entry, 14 instruction(s), ends with jbe to 0x00518d23 (forward)
    push ebp                                     # 00518caf
    {load} mov ebp, esp                          # 00518cb0
    sub esp, 0x10                                # 00518cb2
    mov eax, dword ptr [ebp + arg_c]             # 00518cb5
    push ebx                                     # 00518cb8
    mov ebx, dword ptr [ebp + arg_10]            # 00518cb9
    {load} xor edx, edx                          # 00518cbc
    {load} cmp eax, edx                          # 00518cbe
    push esi                                     # 00518cc0
    mov dword ptr [ebp - local_4], 0x404e        # 00518cc1
    mov dword ptr [ebx], edx                     # 00518cc8
    mov dword ptr [ebx + field_4], edx           # 00518cca
    mov dword ptr [ebx + field_8], edx           # 00518ccd
    jbe.d8 L_00518d23                            # 00518cd0
    # block 0x00518cd2: entered by fall-through of jbe at 0x00518cd0, 2 instruction(s), falls into the block at 0x00518cd6
    push edi                                     # 00518cd2
    mov dword ptr [ebp + arg_10], eax            # 00518cd3
L_00518cd6:
    # block 0x00518cd6: entered by jne at 0x00518d1e, 28 instruction(s), calls FUN_00518c54, FUN_00518bf6, ends with jne to 0x00518cd6 (backward)
    {load} mov esi, ebx                          # 00518cd6
    lea edi, [ebp - local_10]                    # 00518cd8
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518cdb
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518cdc
    push ebx                                     # 00518cdd
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518cde
    call FUN_00518c54                            # 00518cdf
    push ebx                                     # 00518ce4
    call FUN_00518c54                            # 00518ce5
    lea eax, [ebp - local_10]                    # 00518cea
    push eax                                     # 00518ced
    push ebx                                     # 00518cee
    call FUN_00518bf6                            # 00518cef
    push ebx                                     # 00518cf4
    call FUN_00518c54                            # 00518cf5
    mov eax, dword ptr [ebp + arg_8]             # 00518cfa
    and dword ptr [ebp - local_c], 0x0           # 00518cfd
    and dword ptr [ebp - local_8], 0x0           # 00518d01
    movsx eax, byte ptr [eax]                    # 00518d05
    mov dword ptr [ebp - local_10], eax          # 00518d08
    lea eax, [ebp - local_10]                    # 00518d0b
    push eax                                     # 00518d0e
    push ebx                                     # 00518d0f
    call FUN_00518bf6                            # 00518d10
    add esp, 0x1c                                # 00518d15
    inc dword ptr [ebp + arg_8]                  # 00518d18
    dec dword ptr [ebp + arg_10]                 # 00518d1b
    jne.d8 L_00518cd6                            # 00518d1e
    # block 0x00518d20: entered by fall-through of jne at 0x00518d1e, 2 instruction(s), falls into the block at 0x00518d23
    {load} xor edx, edx                          # 00518d20
    pop edi                                      # 00518d22
L_00518d23:
    # block 0x00518d23: entered by jbe at 0x00518cd0; jmp at 0x00518d4e, 2 instruction(s), ends with jne to 0x00518d50 (forward)
    cmp dword ptr [ebx + field_8], edx           # 00518d23
    jne.d8 L_00518d50                            # 00518d26
    # block 0x00518d28: entered by fall-through of jne at 0x00518d26, 14 instruction(s), ends with backward jump to 0x00518d23
    mov ecx, dword ptr [ebx + field_4]           # 00518d28
    {load} mov eax, ecx                          # 00518d2b
    shr eax, 0x10                                # 00518d2d
    mov dword ptr [ebx + field_8], eax           # 00518d30
    mov eax, dword ptr [ebx]                     # 00518d33
    {load} mov esi, eax                          # 00518d35
    shr esi, 0x10                                # 00518d37
    shl ecx, 0x10                                # 00518d3a
    {load} or esi, ecx                           # 00518d3d
    shl eax, 0x10                                # 00518d3f
    add dword ptr [ebp - local_4], 0xfff0        # 00518d42
    mov dword ptr [ebx + field_4], esi           # 00518d49
    mov dword ptr [ebx], eax                     # 00518d4c
    jmp.d8 L_00518d23                            # 00518d4e
L_00518d50:
    # block 0x00518d50: entered by jne at 0x00518d26, 1 instruction(s), falls into the block at 0x00518d55
    mov esi, 0x8000                              # 00518d50
L_00518d55:
    # block 0x00518d55: entered by jmp at 0x00518d68, 2 instruction(s), ends with jne to 0x00518d6a (forward)
    test dword ptr [ebx + field_8], esi          # 00518d55
    jne.d8 L_00518d6a                            # 00518d58
    # block 0x00518d5a: entered by fall-through of jne at 0x00518d58, 5 instruction(s), calls FUN_00518c54, ends with backward jump to 0x00518d55
    push ebx                                     # 00518d5a
    call FUN_00518c54                            # 00518d5b
    add dword ptr [ebp - local_4], 0xffff        # 00518d60
    pop ecx                                      # 00518d67
    jmp.d8 L_00518d55                            # 00518d68
L_00518d6a:
    # block 0x00518d6a: entered by jne at 0x00518d58, 6 instruction(s), ends with ret
    mov ax, word ptr [ebp - local_4]             # 00518d6a
    pop esi                                      # 00518d6e
    mov word ptr [ebx + field_a], ax             # 00518d6f
    pop ebx                                      # 00518d73
    leave                                        # 00518d74
    ret                                          # 00518d75

