# FUN_00512c8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512c8e
# extent:       0x00512c8e-0x00512d28 (154 code bytes)
# span:         0x00512c8e-0x00512d28 (code 154, tables 0, padding 0)
# sha256:       8218314a6bca25515f9eee59868e498afde2ad5343f56cb1f6c3003a8453ad41
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512c8e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [edi + n] field_minus_1, field_minus_2; [edx + n] field_1
# callees:      calls FUN_0050d960, FUN_00512c18, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 69 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00512c8e - 0x401000
.globl FUN_00512c8e
FUN_00512c8e:
    # block 0x00512c8e: entry, 7 instruction(s), ends with jne to 0x00512cb2 (forward)
    push ebp                                     # 00512c8e
    {load} mov ebp, esp                          # 00512c8f
    cmp dword ptr [0x63df1c], 0x0                # 00512c91
    push edi                                     # 00512c98
    mov edi, dword ptr [ebp + arg_8]             # 00512c99
    mov dword ptr [ebp + arg_8], edi             # 00512c9c
    jne.d8 L_00512cb2                            # 00512c9f
    # block 0x00512ca1: entered by fall-through of jne at 0x00512c9f, 6 instruction(s), calls FUN_0050d960, ends with forward jump to 0x00512d25
    push dword ptr [ebp + arg_10]                # 00512ca1
    push dword ptr [ebp + arg_c]                 # 00512ca4
    push edi                                     # 00512ca7
    call FUN_0050d960                            # 00512ca8
    add esp, 0xc                                 # 00512cad
    jmp.d8 L_00512d25                            # 00512cb0
L_00512cb2:
    # block 0x00512cb2: entered by jne at 0x00512c9f, 7 instruction(s), calls FUN_00512c18, ends with je to 0x00512cff (forward)
    push esi                                     # 00512cb2
    push 0x19                                    # 00512cb3
    call FUN_00512c18                            # 00512cb5
    mov edx, dword ptr [ebp + arg_10]            # 00512cba
    pop ecx                                      # 00512cbd
    test edx, edx                                # 00512cbe
    je.d8 L_00512cff                             # 00512cc0
    # block 0x00512cc2: entered by fall-through of je at 0x00512cc0, 1 instruction(s), falls into the block at 0x00512cc5
    mov ecx, dword ptr [ebp + arg_c]             # 00512cc2
L_00512cc5:
    # block 0x00512cc5: entered by jne at 0x00512cf1, 6 instruction(s), ends with je to 0x00512ce9 (forward)
    mov al, byte ptr [ecx]                       # 00512cc5
    dec edx                                      # 00512cc7
    movzx esi, al                                # 00512cc8
    test byte ptr [esi + 0x63e021], 0x4          # 00512ccb
    mov byte ptr [edi], al                       # 00512cd2
    je.d8 L_00512ce9                             # 00512cd4
    # block 0x00512cd6: entered by fall-through of je at 0x00512cd4, 4 instruction(s), ends with je to 0x00512cf5 (forward)
    inc edi                                      # 00512cd6
    inc ecx                                      # 00512cd7
    test edx, edx                                # 00512cd8
    je.d8 L_00512cf5                             # 00512cda
    # block 0x00512cdc: entered by fall-through of je at 0x00512cda, 7 instruction(s), ends with je to 0x00512cfb (forward)
    mov al, byte ptr [ecx]                       # 00512cdc
    dec edx                                      # 00512cde
    mov byte ptr [edi], al                       # 00512cdf
    inc edi                                      # 00512ce1
    inc ecx                                      # 00512ce2
    test al, al                                  # 00512ce3
    je.d8 L_00512cfb                             # 00512ce5
    # block 0x00512ce7: entered by fall-through of je at 0x00512ce5, 1 instruction(s), ends with forward jump to 0x00512cef
    jmp.d8 L_00512cef                            # 00512ce7
L_00512ce9:
    # block 0x00512ce9: entered by je at 0x00512cd4, 4 instruction(s), ends with je to 0x00512cff (forward)
    inc edi                                      # 00512ce9
    inc ecx                                      # 00512cea
    test al, al                                  # 00512ceb
    je.d8 L_00512cff                             # 00512ced
L_00512cef:
    # block 0x00512cef: entered by jmp at 0x00512ce7; fall-through of je at 0x00512ced, 2 instruction(s), ends with jne to 0x00512cc5 (backward)
    test edx, edx                                # 00512cef
    jne.d8 L_00512cc5                            # 00512cf1
    # block 0x00512cf3: entered by fall-through of jne at 0x00512cf1, 1 instruction(s), ends with forward jump to 0x00512cff
    jmp.d8 L_00512cff                            # 00512cf3
L_00512cf5:
    # block 0x00512cf5: entered by je at 0x00512cda, 2 instruction(s), ends with forward jump to 0x00512cff
    and byte ptr [edi - field_minus_1], 0x0      # 00512cf5
    jmp.d8 L_00512cff                            # 00512cf9
L_00512cfb:
    # block 0x00512cfb: entered by je at 0x00512ce5, 1 instruction(s), falls into the block at 0x00512cff
    and byte ptr [edi - field_minus_2], 0x0      # 00512cfb
L_00512cff:
    # block 0x00512cff: entered by je at 0x00512cc0; je at 0x00512ced; jmp at 0x00512cf3; jmp at 0x00512cf9, 5 instruction(s), ends with je to 0x00512d1a (forward)
    {load} mov eax, edx                          # 00512cff
    dec edx                                      # 00512d01
    test eax, eax                                # 00512d02
    pop esi                                      # 00512d04
    je.d8 L_00512d1a                             # 00512d05
    # block 0x00512d07: entered by fall-through of je at 0x00512d05, 8 instruction(s), falls into the block at 0x00512d1a
    lea ecx, [edx + field_1]                     # 00512d07
    {load} xor eax, eax                          # 00512d0a
    {load} mov edx, ecx                          # 00512d0c
    shr ecx, 0x2                                 # 00512d0e
    rep stosd dword ptr es:[edi], eax            # 00512d11
    {load} mov ecx, edx                          # 00512d13
    and ecx, 0x3                                 # 00512d15
    rep stosb byte ptr es:[edi], al              # 00512d18
L_00512d1a:
    # block 0x00512d1a: entered by je at 0x00512d05, 4 instruction(s), calls FUN_00512c79, falls into the block at 0x00512d25
    push 0x19                                    # 00512d1a
    call FUN_00512c79                            # 00512d1c
    mov eax, dword ptr [ebp + arg_8]             # 00512d21
    pop ecx                                      # 00512d24
L_00512d25:
    # block 0x00512d25: entered by jmp at 0x00512cb0, 3 instruction(s), ends with ret
    pop edi                                      # 00512d25
    pop ebp                                      # 00512d26
    ret                                          # 00512d27

