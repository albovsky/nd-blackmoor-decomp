# FUN_0051c9d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c9d3
# extent:       0x0051c9d3-0x0051ca36 (99 code bytes)
# span:         0x0051c9d3-0x0051ca36 (code 99, tables 0, padding 0)
# sha256:       c4b5a49a943b041625fba426f06950ba827cf947f6858b2d6c228b5cfcdc4645
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c9d3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [edi + n] field_1c; [esi + n] field_4, field_8
# callees:      calls FUN_0051c4ec, FUN_00525bd1, FUN_0051ca36, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)
.set FUN_0051ca36, .text + (0x0051ca36 - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x0051c9d3 - 0x401000
.globl FUN_0051c9d3
FUN_0051c9d3:
    # block 0x0051c9d3: entry, 13 instruction(s), calls FUN_0051c4ec, ends with je to 0x0051c9f2 (forward)
    push ebp                                     # 0051c9d3
    {load} mov ebp, esp                          # 0051c9d4
    push ebx                                     # 0051c9d6
    push esi                                     # 0051c9d7
    push edi                                     # 0051c9d8
    mov edi, dword ptr [ebp + arg_c]             # 0051c9d9
    {load} mov ebx, ecx                          # 0051c9dc
    lea eax, [ebp + arg_c]                       # 0051c9de
    push eax                                     # 0051c9e1
    {load} mov ecx, edi                          # 0051c9e2
    call FUN_0051c4ec                            # 0051c9e4
    test eax, eax                                # 0051c9e9
    je.d8 L_0051c9f2                             # 0051c9eb
    # block 0x0051c9ed: entered by fall-through of je at 0x0051c9eb, 2 instruction(s), ends with forward jump to 0x0051ca2f
    mov eax, dword ptr [ebp + arg_c]             # 0051c9ed
    jmp.d8 L_0051ca2f                            # 0051c9f0
L_0051c9f2:
    # block 0x0051c9f2: entered by je at 0x0051c9eb, 6 instruction(s), calls FUN_00525bd1, ends with je to 0x0051ca0a (forward)
    push 0x5249a0                                # 0051c9f2
    mov ecx, 0x63c41c                            # 0051c9f7
    call FUN_00525bd1                            # 0051c9fc
    test edi, edi                                # 0051ca01
    {load} mov esi, eax                          # 0051ca03
    je.d8 L_0051ca0a                             # 0051ca05
    # block 0x0051ca07: entered by fall-through of je at 0x0051ca05, 1 instruction(s), falls into the block at 0x0051ca0a
    mov edi, dword ptr [edi + field_1c]          # 0051ca07
L_0051ca0a:
    # block 0x0051ca0a: entered by je at 0x0051ca05, 9 instruction(s), calls FUN_0051ca36, ends with jne to 0x0051ca2c (forward)
    push dword ptr [esi + field_8]               # 0051ca0a
    mov eax, dword ptr [ebp + arg_8]             # 0051ca0d
    push dword ptr [esi + field_4]               # 0051ca10
    push dword ptr [ebp + arg_10]                # 0051ca13
    push edi                                     # 0051ca16
    push dword ptr [eax + field_4]               # 0051ca17
    call FUN_0051ca36                            # 0051ca1a
    test eax, eax                                # 0051ca1f
    jne.d8 L_0051ca2c                            # 0051ca21
    # block 0x0051ca23: entered by fall-through of jne at 0x0051ca21, 3 instruction(s), calls FUN_0051ab4b, ends with forward jump to 0x0051ca2f
    {load} mov ecx, ebx                          # 0051ca23
    call FUN_0051ab4b                            # 0051ca25
    jmp.d8 L_0051ca2f                            # 0051ca2a
L_0051ca2c:
    # block 0x0051ca2c: entered by jne at 0x0051ca21, 1 instruction(s), falls into the block at 0x0051ca2f
    mov eax, dword ptr [esi + field_4]           # 0051ca2c
L_0051ca2f:
    # block 0x0051ca2f: entered by jmp at 0x0051c9f0; jmp at 0x0051ca2a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0051ca2f
    pop esi                                      # 0051ca30
    pop ebx                                      # 0051ca31
    pop ebp                                      # 0051ca32
    ret 0xc                                      # 0051ca33

