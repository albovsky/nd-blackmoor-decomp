# FUN_00514c2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514c2b
# extent:       0x00514c2b-0x00514d5d (306 code bytes)
# span:         0x00514c2b-0x00514d5d (code 306, tables 0, padding 0)
# sha256:       13bd1def89168b3890b1e68c701e5ebf015f3a80a3d81476ca746b4a97055731
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514c2b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_24, stk_34
# callees:      calls KERNEL32.dll!GetEnvironmentStrings, FUN_0050ea90, FUN_0050e936, KERNEL32.dll!FreeEnvironmentStringsW, FUN_0050fa90, KERNEL32.dll!FreeEnvironmentStringsA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 132 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_24, 0x24  # offset +0x24
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)

.org 0x00514c2b - 0x401000
.globl FUN_00514c2b
FUN_00514c2b:
    # block 0x00514c2b: entry, 13 instruction(s), ends with jne to 0x00514c79 (forward)
    push ecx                                     # 00514c2b
    push ecx                                     # 00514c2c
    mov eax, dword ptr [0x63cc40]                # 00514c2d
    push ebx                                     # 00514c32
    push ebp                                     # 00514c33
    mov ebp, dword ptr [0x52a190]                # 00514c34
    push esi                                     # 00514c3a
    push edi                                     # 00514c3b
    {load} xor ebx, ebx                          # 00514c3c
    {load} xor esi, esi                          # 00514c3e
    {load} xor edi, edi                          # 00514c40
    {load} cmp eax, ebx                          # 00514c42
    jne.d8 L_00514c79                            # 00514c44
    # block 0x00514c46: entered by fall-through of jne at 0x00514c44, 4 instruction(s), calls indirect ebp, ends with je to 0x00514c5a (forward)
    call ebp                                     # 00514c46
    {load} mov esi, eax                          # 00514c48
    {load} cmp esi, ebx                          # 00514c4a
    je.d8 L_00514c5a                             # 00514c4c
    # block 0x00514c4e: entered by fall-through of je at 0x00514c4c, 2 instruction(s), ends with forward jump to 0x00514c82
    mov dword ptr [0x63cc40], 0x1                # 00514c4e
    jmp.d8 L_00514c82                            # 00514c58
L_00514c5a:
    # block 0x00514c5a: entered by je at 0x00514c4c, 4 instruction(s), calls KERNEL32.dll!GetEnvironmentStrings, ends with je to 0x00514d54 (forward)
    call dword ptr [0x52a18c]                    # 00514c5a
    {load} mov edi, eax                          # 00514c60
    {load} cmp edi, ebx                          # 00514c62
    je.d32 L_00514d54                            # 00514c64
    # block 0x00514c6a: entered by fall-through of je at 0x00514c64, 2 instruction(s), ends with forward jump to 0x00514d08
    mov dword ptr [0x63cc40], 0x2                # 00514c6a
    jmp.d32 L_00514d08                           # 00514c74
L_00514c79:
    # block 0x00514c79: entered by jne at 0x00514c44, 2 instruction(s), ends with jne to 0x00514d03 (forward)
    cmp eax, 0x1                                 # 00514c79
    jne.d32 L_00514d03                           # 00514c7c
L_00514c82:
    # block 0x00514c82: entered by jmp at 0x00514c58; fall-through of jne at 0x00514c7c, 2 instruction(s), ends with jne to 0x00514c92 (forward)
    {load} cmp esi, ebx                          # 00514c82
    jne.d8 L_00514c92                            # 00514c84
    # block 0x00514c86: entered by fall-through of jne at 0x00514c84, 4 instruction(s), calls indirect ebp, ends with je to 0x00514d54 (forward)
    call ebp                                     # 00514c86
    {load} mov esi, eax                          # 00514c88
    {load} cmp esi, ebx                          # 00514c8a
    je.d32 L_00514d54                            # 00514c8c
L_00514c92:
    # block 0x00514c92: entered by jne at 0x00514c84; fall-through of je at 0x00514c8c, 3 instruction(s), ends with je to 0x00514ca7 (forward)
    cmp word ptr [esi], bx                       # 00514c92
    {load} mov eax, esi                          # 00514c95
    je.d8 L_00514ca7                             # 00514c97
L_00514c99:
    # block 0x00514c99: entered by jne at 0x00514c9e; jne at 0x00514ca5; fall-through of je at 0x00514c97, 4 instruction(s), ends with jne to 0x00514c99 (backward)
    inc eax                                      # 00514c99
    inc eax                                      # 00514c9a
    cmp word ptr [eax], bx                       # 00514c9b
    jne.d8 L_00514c99                            # 00514c9e
    # block 0x00514ca0: entered by fall-through of jne at 0x00514c9e, 4 instruction(s), ends with jne to 0x00514c99 (backward)
    inc eax                                      # 00514ca0
    inc eax                                      # 00514ca1
    cmp word ptr [eax], bx                       # 00514ca2
    jne.d8 L_00514c99                            # 00514ca5
L_00514ca7:
    # block 0x00514ca7: entered by je at 0x00514c97; fall-through of jne at 0x00514ca5, 17 instruction(s), calls indirect edi, ends with je to 0x00514cf8 (forward)
    {load} sub eax, esi                          # 00514ca7
    mov edi, dword ptr [0x52a1f4]                # 00514ca9
    sar eax                                      # 00514caf
    push ebx                                     # 00514cb1
    push ebx                                     # 00514cb2
    inc eax                                      # 00514cb3
    push ebx                                     # 00514cb4
    push ebx                                     # 00514cb5
    push eax                                     # 00514cb6
    push esi                                     # 00514cb7
    push ebx                                     # 00514cb8
    push ebx                                     # 00514cb9
    mov dword ptr [esp + stk_34], eax            # 00514cba
    call edi                                     # 00514cbe
    {load} mov ebp, eax                          # 00514cc0
    {load} cmp ebp, ebx                          # 00514cc2
    je.d8 L_00514cf8                             # 00514cc4
    # block 0x00514cc6: entered by fall-through of je at 0x00514cc4, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x00514cf8 (forward)
    push ebp                                     # 00514cc6
    call FUN_0050ea90                            # 00514cc7
    {load} cmp eax, ebx                          # 00514ccc
    pop ecx                                      # 00514cce
    mov dword ptr [esp + stk_10], eax            # 00514ccf
    je.d8 L_00514cf8                             # 00514cd3
    # block 0x00514cd5: entered by fall-through of je at 0x00514cd3, 11 instruction(s), calls indirect edi, ends with jne to 0x00514cf4 (forward)
    push ebx                                     # 00514cd5
    push ebx                                     # 00514cd6
    push ebp                                     # 00514cd7
    push eax                                     # 00514cd8
    push dword ptr [esp + stk_24]                # 00514cd9
    push esi                                     # 00514cdd
    push ebx                                     # 00514cde
    push ebx                                     # 00514cdf
    call edi                                     # 00514ce0
    test eax, eax                                # 00514ce2
    jne.d8 L_00514cf4                            # 00514ce4
    # block 0x00514ce6: entered by fall-through of jne at 0x00514ce4, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x00514cf4
    push dword ptr [esp + stk_10]                # 00514ce6
    call FUN_0050e936                            # 00514cea
    pop ecx                                      # 00514cef
    mov dword ptr [esp + stk_10], ebx            # 00514cf0
L_00514cf4:
    # block 0x00514cf4: entered by jne at 0x00514ce4, 1 instruction(s), falls into the block at 0x00514cf8
    mov ebx, dword ptr [esp + stk_10]            # 00514cf4
L_00514cf8:
    # block 0x00514cf8: entered by je at 0x00514cc4; je at 0x00514cd3, 4 instruction(s), calls KERNEL32.dll!FreeEnvironmentStringsW, ends with forward jump to 0x00514d56
    push esi                                     # 00514cf8
    call dword ptr [0x52a188]                    # 00514cf9
    {load} mov eax, ebx                          # 00514cff
    jmp.d8 L_00514d56                            # 00514d01
L_00514d03:
    # block 0x00514d03: entered by jne at 0x00514c7c, 2 instruction(s), ends with jne to 0x00514d54 (forward)
    cmp eax, 0x2                                 # 00514d03
    jne.d8 L_00514d54                            # 00514d06
L_00514d08:
    # block 0x00514d08: entered by jmp at 0x00514c74; fall-through of jne at 0x00514d06, 2 instruction(s), ends with jne to 0x00514d18 (forward)
    {load} cmp edi, ebx                          # 00514d08
    jne.d8 L_00514d18                            # 00514d0a
    # block 0x00514d0c: entered by fall-through of jne at 0x00514d0a, 4 instruction(s), calls KERNEL32.dll!GetEnvironmentStrings, ends with je to 0x00514d54 (forward)
    call dword ptr [0x52a18c]                    # 00514d0c
    {load} mov edi, eax                          # 00514d12
    {load} cmp edi, ebx                          # 00514d14
    je.d8 L_00514d54                             # 00514d16
L_00514d18:
    # block 0x00514d18: entered by jne at 0x00514d0a; fall-through of je at 0x00514d16, 3 instruction(s), ends with je to 0x00514d28 (forward)
    cmp byte ptr [edi], bl                       # 00514d18
    {load} mov eax, edi                          # 00514d1a
    je.d8 L_00514d28                             # 00514d1c
L_00514d1e:
    # block 0x00514d1e: entered by jne at 0x00514d21; jne at 0x00514d26; fall-through of je at 0x00514d1c, 3 instruction(s), ends with jne to 0x00514d1e (backward)
    inc eax                                      # 00514d1e
    cmp byte ptr [eax], bl                       # 00514d1f
    jne.d8 L_00514d1e                            # 00514d21
    # block 0x00514d23: entered by fall-through of jne at 0x00514d21, 3 instruction(s), ends with jne to 0x00514d1e (backward)
    inc eax                                      # 00514d23
    cmp byte ptr [eax], bl                       # 00514d24
    jne.d8 L_00514d1e                            # 00514d26
L_00514d28:
    # block 0x00514d28: entered by je at 0x00514d1c; fall-through of jne at 0x00514d26, 9 instruction(s), calls FUN_0050ea90, ends with jne to 0x00514d3e (forward)
    {load} sub eax, edi                          # 00514d28
    inc eax                                      # 00514d2a
    {load} mov ebp, eax                          # 00514d2b
    push ebp                                     # 00514d2d
    call FUN_0050ea90                            # 00514d2e
    {load} mov esi, eax                          # 00514d33
    pop ecx                                      # 00514d35
    {load} cmp esi, ebx                          # 00514d36
    jne.d8 L_00514d3e                            # 00514d38
    # block 0x00514d3a: entered by fall-through of jne at 0x00514d38, 2 instruction(s), ends with forward jump to 0x00514d49
    {load} xor esi, esi                          # 00514d3a
    jmp.d8 L_00514d49                            # 00514d3c
L_00514d3e:
    # block 0x00514d3e: entered by jne at 0x00514d38, 5 instruction(s), calls FUN_0050fa90, falls into the block at 0x00514d49
    push ebp                                     # 00514d3e
    push edi                                     # 00514d3f
    push esi                                     # 00514d40
    call FUN_0050fa90                            # 00514d41
    add esp, 0xc                                 # 00514d46
L_00514d49:
    # block 0x00514d49: entered by jmp at 0x00514d3c, 4 instruction(s), calls KERNEL32.dll!FreeEnvironmentStringsA, ends with forward jump to 0x00514d56
    push edi                                     # 00514d49
    call dword ptr [0x52a184]                    # 00514d4a
    {load} mov eax, esi                          # 00514d50
    jmp.d8 L_00514d56                            # 00514d52
L_00514d54:
    # block 0x00514d54: entered by je at 0x00514c64; je at 0x00514c8c; jne at 0x00514d06; je at 0x00514d16, 1 instruction(s), falls into the block at 0x00514d56
    {load} xor eax, eax                          # 00514d54
L_00514d56:
    # block 0x00514d56: entered by jmp at 0x00514d01; jmp at 0x00514d52, 7 instruction(s), ends with ret
    pop edi                                      # 00514d56
    pop esi                                      # 00514d57
    pop ebp                                      # 00514d58
    pop ebx                                      # 00514d59
    pop ecx                                      # 00514d5a
    pop ecx                                      # 00514d5b
    ret                                          # 00514d5c

