# FUN_0051faaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051faaa
# extent:       0x0051faaa-0x0051fb2e (132 code bytes)
# span:         0x0051faaa-0x0051fb2e (code 132, tables 0, padding 0)
# sha256:       14b39bc7bb96204d50ceb34b0c8871ee6e4fa4769ad930d2b60a888a592bbab8
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051faaa
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_104
# fields:       [edi + n] field_minus_1
# callees:      calls FUN_0051fb2e, FUN_0051e8f7, FUN_0051ea75, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_104, 0x104  # offset -0x104
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_0051fb2e, .text + (0x0051fb2e - 0x401000)

.org 0x0051faaa - 0x401000
.globl FUN_0051faaa
FUN_0051faaa:
    # block 0x0051faaa: entry, 17 instruction(s), calls FUN_0051fb2e, ends with jbe to 0x0051faf0 (forward)
    push ebp                                     # 0051faaa
    {load} mov ebp, esp                          # 0051faab
    sub esp, 0x104                               # 0051faad
    push esi                                     # 0051fab3
    mov esi, 0x100                               # 0051fab4
    push edi                                     # 0051fab9
    lea eax, [ebp - local_104]                   # 0051faba
    push esi                                     # 0051fac0
    push eax                                     # 0051fac1
    push dword ptr [ebp + arg_8]                 # 0051fac2
    mov dword ptr [ebp - local_4], ecx           # 0051fac5
    call FUN_0051fb2e                            # 0051fac8
    {load} mov edi, eax                          # 0051facd
    {load} mov eax, esi                          # 0051facf
    {load} sub eax, edi                          # 0051fad1
    cmp eax, 0x2                                 # 0051fad3
    jbe.d8 L_0051faf0                            # 0051fad6
    # block 0x0051fad8: entered by fall-through of jbe at 0x0051fad6, 8 instruction(s), calls FUN_0051e8f7, ends with forward jump to 0x0051fb28
    mov ecx, dword ptr [ebp - local_4]           # 0051fad8
    lea eax, [ebp - local_104]                   # 0051fadb
    push eax                                     # 0051fae1
    call FUN_0051e8f7                            # 0051fae2
    {load} xor eax, eax                          # 0051fae7
    test edi, edi                                # 0051fae9
    setg al                                      # 0051faeb
    jmp.d8 L_0051fb28                            # 0051faee
L_0051faf0:
    # block 0x0051faf0: entered by jbe at 0x0051fad6, 2 instruction(s), falls into the block at 0x0051faf3
    push ebx                                     # 0051faf0
    {load} mov edi, esi                          # 0051faf1
L_0051faf3:
    # block 0x0051faf3: entered by jle at 0x0051fb14, 14 instruction(s), calls FUN_0051ea75, FUN_0051fb2e, ends with jle to 0x0051faf3 (backward)
    mov ecx, dword ptr [ebp - local_4]           # 0051faf3
    {load} add edi, esi                          # 0051faf6
    push edi                                     # 0051faf8
    lea eax, [edi - field_minus_1]               # 0051faf9
    push eax                                     # 0051fafc
    call FUN_0051ea75                            # 0051fafd
    push eax                                     # 0051fb02
    push dword ptr [ebp + arg_8]                 # 0051fb03
    call FUN_0051fb2e                            # 0051fb06
    {load} mov ebx, eax                          # 0051fb0b
    {load} mov eax, edi                          # 0051fb0d
    {load} sub eax, ebx                          # 0051fb0f
    cmp eax, 0x2                                 # 0051fb11
    jle.d8 L_0051faf3                            # 0051fb14
    # block 0x0051fb16: entered by fall-through of jle at 0x0051fb14, 7 instruction(s), calls FUN_0051eac4, falls into the block at 0x0051fb28
    mov ecx, dword ptr [ebp - local_4]           # 0051fb16
    push -0x1                                    # 0051fb19
    call FUN_0051eac4                            # 0051fb1b
    {load} xor eax, eax                          # 0051fb20
    test ebx, ebx                                # 0051fb22
    setg al                                      # 0051fb24
    pop ebx                                      # 0051fb27
L_0051fb28:
    # block 0x0051fb28: entered by jmp at 0x0051faee, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0051fb28
    pop esi                                      # 0051fb29
    leave                                        # 0051fb2a
    ret 0x4                                      # 0051fb2b

