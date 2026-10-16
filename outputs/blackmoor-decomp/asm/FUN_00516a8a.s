# FUN_00516a8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516a8a
# extent:       0x00516a8a-0x00516b16 (140 code bytes)
# span:         0x00516a8a-0x00516b16 (code 140, tables 0, padding 0)
# sha256:       e065cbfd5dbd2f677fe10182ba33647aa56cbbaf97ab15d0df40401beb7bd4c7
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516a8a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_minus_1; [edi + n] field_1
# callees:      calls FUN_005169eb, FUN_00516a34
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_005169eb, .text + (0x005169eb - 0x401000)
.set FUN_00516a34, .text + (0x00516a34 - 0x401000)

.org 0x00516a8a - 0x401000
.globl FUN_00516a8a
FUN_00516a8a:
    # block 0x00516a8a: entry, 35 instruction(s), ends with je to 0x00516aee (forward)
    push ebp                                     # 00516a8a
    {load} mov ebp, esp                          # 00516a8b
    push ecx                                     # 00516a8d
    push ecx                                     # 00516a8e
    mov eax, dword ptr [ebp + arg_c]             # 00516a8f
    push ebx                                     # 00516a92
    push esi                                     # 00516a93
    push edi                                     # 00516a94
    lea edi, [eax - field_minus_1]               # 00516a95
    push 0x20                                    # 00516a98
    pop ecx                                      # 00516a9a
    and dword ptr [ebp - local_4], 0x0           # 00516a9b
    lea ebx, [edi + field_1]                     # 00516a9f
    push 0x20                                    # 00516aa2
    {load} mov eax, ebx                          # 00516aa4
    pop esi                                      # 00516aa6
    cdq                                          # 00516aa7
    idiv ecx                                     # 00516aa8
    push 0x1f                                    # 00516aaa
    {load} mov ecx, eax                          # 00516aac
    {load} mov eax, ebx                          # 00516aae
    cdq                                          # 00516ab0
    idiv esi                                     # 00516ab1
    mov eax, dword ptr [ebp + arg_8]             # 00516ab3
    pop esi                                      # 00516ab6
    push 0x1                                     # 00516ab7
    mov dword ptr [ebp - local_8], ecx           # 00516ab9
    lea eax, [eax + 4*ecx]                       # 00516abc
    mov dword ptr [ebp + arg_c], eax             # 00516abf
    {load} sub esi, edx                          # 00516ac2
    pop edx                                      # 00516ac4
    {load} mov ecx, esi                          # 00516ac5
    shl edx, cl                                  # 00516ac7
    test dword ptr [eax], edx                    # 00516ac9
    je.d8 L_00516aee                             # 00516acb
    # block 0x00516acd: entered by fall-through of je at 0x00516acb, 8 instruction(s), calls FUN_005169eb, ends with jne to 0x00516aeb (forward)
    inc ebx                                      # 00516acd
    push ebx                                     # 00516ace
    push dword ptr [ebp + arg_8]                 # 00516acf
    call FUN_005169eb                            # 00516ad2
    pop ecx                                      # 00516ad7
    test eax, eax                                # 00516ad8
    pop ecx                                      # 00516ada
    jne.d8 L_00516aeb                            # 00516adb
    # block 0x00516add: entered by fall-through of jne at 0x00516adb, 6 instruction(s), calls FUN_00516a34, falls into the block at 0x00516aeb
    push edi                                     # 00516add
    push dword ptr [ebp + arg_8]                 # 00516ade
    call FUN_00516a34                            # 00516ae1
    pop ecx                                      # 00516ae6
    mov dword ptr [ebp - local_4], eax           # 00516ae7
    pop ecx                                      # 00516aea
L_00516aeb:
    # block 0x00516aeb: entered by jne at 0x00516adb, 1 instruction(s), falls into the block at 0x00516aee
    mov eax, dword ptr [ebp + arg_c]             # 00516aeb
L_00516aee:
    # block 0x00516aee: entered by je at 0x00516acb, 10 instruction(s), ends with jge to 0x00516b0e (forward)
    or edx, -0x1                                 # 00516aee
    {load} mov ecx, esi                          # 00516af1
    shl edx, cl                                  # 00516af3
    push 0x3                                     # 00516af5
    pop ecx                                      # 00516af7
    and dword ptr [eax], edx                     # 00516af8
    mov eax, dword ptr [ebp - local_8]           # 00516afa
    inc eax                                      # 00516afd
    {load} cmp eax, ecx                          # 00516afe
    jge.d8 L_00516b0e                            # 00516b00
    # block 0x00516b02: entered by fall-through of jge at 0x00516b00, 5 instruction(s), falls into the block at 0x00516b0e
    mov edx, dword ptr [ebp + arg_8]             # 00516b02
    {load} sub ecx, eax                          # 00516b05
    lea edi, [edx + 4*eax]                       # 00516b07
    {load} xor eax, eax                          # 00516b0a
    rep stosd dword ptr es:[edi], eax            # 00516b0c
L_00516b0e:
    # block 0x00516b0e: entered by jge at 0x00516b00, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_4]           # 00516b0e
    pop edi                                      # 00516b11
    pop esi                                      # 00516b12
    pop ebx                                      # 00516b13
    leave                                        # 00516b14
    ret                                          # 00516b15

