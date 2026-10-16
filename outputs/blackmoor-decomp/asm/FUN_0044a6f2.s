# FUN_0044a6f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a6f2
# extent:       0x0044a6f2-0x0044aa79 (903 code bytes)
# span:         0x0044a6f2-0x0044aa79 (code 903, tables 0, padding 0)
# sha256:       1db9ca071363853afdb240c5ca1a035ed520da50434eb075d842eeac35510884
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a6f2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_8, local_c, local_18, local_1c, local_20, local_24, local_28, local_38, local_9c, local_a0
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, KERNEL32.dll!GetComputerNameA, KERNEL32.dll!WritePrivateProfileStringA, FUN_0050ca3e, KERNEL32.dll!GetSystemInfo
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 248 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_38, 0x38  # offset -0x38
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0044a6f2 - 0x401000
.globl FUN_0044a6f2
FUN_0044a6f2:
    # block 0x0044a6f2: entry, 9 instruction(s), ends with je to 0x0044a71c (forward)
    push ebp                                     # 0044a6f2
    {load} mov ebp, esp                          # 0044a6f3
    sub esp, 0xa0                                # 0044a6f5
    push esi                                     # 0044a6fb
    push edi                                     # 0044a6fc
    mov dword ptr [ebp - local_28], 0x10         # 0044a6fd
    movsx eax, word ptr [0x63a4cd]               # 0044a704
    test eax, eax                                # 0044a70b
    je.d8 L_0044a71c                             # 0044a70d
    # block 0x0044a70f: entered by fall-through of je at 0x0044a70d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044a71c
    push 0x548b38                                # 0044a70f
    call FUN_0044a2b7                            # 0044a714
    add esp, 0x4                                 # 0044a719
L_0044a71c:
    # block 0x0044a71c: entered by je at 0x0044a70d, 14 instruction(s), calls KERNEL32.dll!GetComputerNameA, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a771 (forward)
    lea ecx, [ebp - local_28]                    # 0044a71c
    push ecx                                     # 0044a71f
    lea edx, [ebp - local_38]                    # 0044a720
    push edx                                     # 0044a723
    call dword ptr [0x52a264]                    # 0044a724
    push 0x639897                                # 0044a72a
    lea eax, [ebp - local_38]                    # 0044a72f
    push eax                                     # 0044a732
    push 0x548b48                                # 0044a733
    push 0x548b54                                # 0044a738
    call dword ptr [0x52a26c]                    # 0044a73d
    movsx ecx, word ptr [0x63a4cd]               # 0044a743
    test ecx, ecx                                # 0044a74a
    je.d8 L_0044a771                             # 0044a74c
    # block 0x0044a74e: entered by fall-through of je at 0x0044a74c, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a771
    lea edx, [ebp - local_38]                    # 0044a74e
    push edx                                     # 0044a751
    push 0x548b60                                # 0044a752
    push 0x63888b                                # 0044a757
    call FUN_0050ca3e                            # 0044a75c
    add esp, 0xc                                 # 0044a761
    push 0x63888b                                # 0044a764
    call FUN_0044a2b7                            # 0044a769
    add esp, 0x4                                 # 0044a76e
L_0044a771:
    # block 0x0044a771: entered by je at 0x0044a74c, 17 instruction(s), calls KERNEL32.dll!GetSystemInfo, FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a7d9 (forward)
    lea eax, [ebp - local_24]                    # 0044a771
    push eax                                     # 0044a774
    call dword ptr [0x52a268]                    # 0044a775
    mov ecx, dword ptr [ebp - local_24]          # 0044a77b
    push ecx                                     # 0044a77e
    push 0x548b74                                # 0044a77f
    push 0x63888b                                # 0044a784
    call FUN_0050ca3e                            # 0044a789
    add esp, 0xc                                 # 0044a78e
    push 0x639897                                # 0044a791
    push 0x63888b                                # 0044a796
    push 0x548b7c                                # 0044a79b
    push 0x548b84                                # 0044a7a0
    call dword ptr [0x52a26c]                    # 0044a7a5
    movsx edx, word ptr [0x63a4cd]               # 0044a7ab
    test edx, edx                                # 0044a7b2
    je.d8 L_0044a7d9                             # 0044a7b4
    # block 0x0044a7b6: entered by fall-through of je at 0x0044a7b4, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a7d9
    mov eax, dword ptr [ebp - local_24]          # 0044a7b6
    push eax                                     # 0044a7b9
    push 0x548b90                                # 0044a7ba
    push 0x63888b                                # 0044a7bf
    call FUN_0050ca3e                            # 0044a7c4
    add esp, 0xc                                 # 0044a7c9
    push 0x63888b                                # 0044a7cc
    call FUN_0044a2b7                            # 0044a7d1
    add esp, 0x4                                 # 0044a7d6
L_0044a7d9:
    # block 0x0044a7d9: entered by je at 0x0044a7b4, 14 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a837 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0044a7d9
    push ecx                                     # 0044a7dc
    push 0x548ba0                                # 0044a7dd
    push 0x63888b                                # 0044a7e2
    call FUN_0050ca3e                            # 0044a7e7
    add esp, 0xc                                 # 0044a7ec
    push 0x639897                                # 0044a7ef
    push 0x63888b                                # 0044a7f4
    push 0x548ba8                                # 0044a7f9
    push 0x548bb8                                # 0044a7fe
    call dword ptr [0x52a26c]                    # 0044a803
    movsx edx, word ptr [0x63a4cd]               # 0044a809
    test edx, edx                                # 0044a810
    je.d8 L_0044a837                             # 0044a812
    # block 0x0044a814: entered by fall-through of je at 0x0044a812, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a837
    mov eax, dword ptr [ebp - local_1c]          # 0044a814
    push eax                                     # 0044a817
    push 0x548bc4                                # 0044a818
    push 0x63888b                                # 0044a81d
    call FUN_0050ca3e                            # 0044a822
    add esp, 0xc                                 # 0044a827
    push 0x63888b                                # 0044a82a
    call FUN_0044a2b7                            # 0044a82f
    add esp, 0x4                                 # 0044a834
L_0044a837:
    # block 0x0044a837: entered by je at 0x0044a812, 14 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a895 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0044a837
    push ecx                                     # 0044a83a
    push 0x548bdc                                # 0044a83b
    push 0x63888b                                # 0044a840
    call FUN_0050ca3e                            # 0044a845
    add esp, 0xc                                 # 0044a84a
    push 0x639897                                # 0044a84d
    push 0x63888b                                # 0044a852
    push 0x548be4                                # 0044a857
    push 0x548bf4                                # 0044a85c
    call dword ptr [0x52a26c]                    # 0044a861
    movsx edx, word ptr [0x63a4cd]               # 0044a867
    test edx, edx                                # 0044a86e
    je.d8 L_0044a895                             # 0044a870
    # block 0x0044a872: entered by fall-through of je at 0x0044a870, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a895
    mov eax, dword ptr [ebp - local_18]          # 0044a872
    push eax                                     # 0044a875
    push 0x548c00                                # 0044a876
    push 0x63888b                                # 0044a87b
    call FUN_0050ca3e                            # 0044a880
    add esp, 0xc                                 # 0044a885
    push 0x63888b                                # 0044a888
    call FUN_0044a2b7                            # 0044a88d
    add esp, 0x4                                 # 0044a892
L_0044a895:
    # block 0x0044a895: entered by je at 0x0044a870, 14 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a8f3 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0044a895
    push ecx                                     # 0044a898
    push 0x548c18                                # 0044a899
    push 0x63888b                                # 0044a89e
    call FUN_0050ca3e                            # 0044a8a3
    add esp, 0xc                                 # 0044a8a8
    push 0x639897                                # 0044a8ab
    push 0x63888b                                # 0044a8b0
    push 0x548c20                                # 0044a8b5
    push 0x548c2c                                # 0044a8ba
    call dword ptr [0x52a26c]                    # 0044a8bf
    movsx edx, word ptr [0x63a4cd]               # 0044a8c5
    test edx, edx                                # 0044a8cc
    je.d8 L_0044a8f3                             # 0044a8ce
    # block 0x0044a8d0: entered by fall-through of je at 0x0044a8ce, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a8f3
    mov eax, dword ptr [ebp - local_20]          # 0044a8d0
    push eax                                     # 0044a8d3
    push 0x548c38                                # 0044a8d4
    push 0x63888b                                # 0044a8d9
    call FUN_0050ca3e                            # 0044a8de
    add esp, 0xc                                 # 0044a8e3
    push 0x63888b                                # 0044a8e6
    call FUN_0044a2b7                            # 0044a8eb
    add esp, 0x4                                 # 0044a8f0
L_0044a8f3:
    # block 0x0044a8f3: entered by je at 0x0044a8ce, 14 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044a951 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044a8f3
    push ecx                                     # 0044a8f6
    push 0x548c4c                                # 0044a8f7
    push 0x63888b                                # 0044a8fc
    call FUN_0050ca3e                            # 0044a901
    add esp, 0xc                                 # 0044a906
    push 0x639897                                # 0044a909
    push 0x63888b                                # 0044a90e
    push 0x548c54                                # 0044a913
    push 0x548c6c                                # 0044a918
    call dword ptr [0x52a26c]                    # 0044a91d
    movsx edx, word ptr [0x63a4cd]               # 0044a923
    test edx, edx                                # 0044a92a
    je.d8 L_0044a951                             # 0044a92c
    # block 0x0044a92e: entered by fall-through of je at 0x0044a92c, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044a951
    mov eax, dword ptr [ebp - local_8]           # 0044a92e
    push eax                                     # 0044a931
    push 0x548c78                                # 0044a932
    push 0x63888b                                # 0044a937
    call FUN_0050ca3e                            # 0044a93c
    add esp, 0xc                                 # 0044a941
    push 0x63888b                                # 0044a944
    call FUN_0044a2b7                            # 0044a949
    add esp, 0x4                                 # 0044a94e
L_0044a951:
    # block 0x0044a951: entered by je at 0x0044a92c, 4 instruction(s), ends with je to 0x0044a980 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044a951
    mov dword ptr [ebp - local_a0], ecx          # 0044a954
    cmp dword ptr [ebp - local_a0], 0x182        # 0044a95a
    je.d8 L_0044a980                             # 0044a964
    # block 0x0044a966: entered by fall-through of je at 0x0044a964, 2 instruction(s), ends with je to 0x0044a9aa (forward)
    cmp dword ptr [ebp - local_a0], 0x1e6        # 0044a966
    je.d8 L_0044a9aa                             # 0044a970
    # block 0x0044a972: entered by fall-through of je at 0x0044a970, 2 instruction(s), ends with je to 0x0044a9d4 (forward)
    cmp dword ptr [ebp - local_a0], 0x24a        # 0044a972
    je.d8 L_0044a9d4                             # 0044a97c
    # block 0x0044a97e: entered by fall-through of je at 0x0044a97c, 1 instruction(s), ends with forward jump to 0x0044a9fe
    jmp.d8 L_0044a9fe                            # 0044a97e
L_0044a980:
    # block 0x0044a980: entered by je at 0x0044a964, 16 instruction(s), ends with forward jump to 0x0044aa26
    mov edi, 0x548c90                            # 0044a980
    lea edx, [ebp - local_9c]                    # 0044a985
    or ecx, -0x1                                 # 0044a98b
    {load} xor eax, eax                          # 0044a98e
    repne scasb al, byte ptr es:[edi]            # 0044a990
    not ecx                                      # 0044a992
    {load} sub edi, ecx                          # 0044a994
    {load} mov esi, edi                          # 0044a996
    {load} mov eax, ecx                          # 0044a998
    {load} mov edi, edx                          # 0044a99a
    shr ecx, 0x2                                 # 0044a99c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a99f
    {load} mov ecx, eax                          # 0044a9a1
    and ecx, 0x3                                 # 0044a9a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a9a6
    jmp.d8 L_0044aa26                            # 0044a9a8
L_0044a9aa:
    # block 0x0044a9aa: entered by je at 0x0044a970, 16 instruction(s), ends with forward jump to 0x0044aa26
    mov edi, 0x548c94                            # 0044a9aa
    lea edx, [ebp - local_9c]                    # 0044a9af
    or ecx, -0x1                                 # 0044a9b5
    {load} xor eax, eax                          # 0044a9b8
    repne scasb al, byte ptr es:[edi]            # 0044a9ba
    not ecx                                      # 0044a9bc
    {load} sub edi, ecx                          # 0044a9be
    {load} mov esi, edi                          # 0044a9c0
    {load} mov eax, ecx                          # 0044a9c2
    {load} mov edi, edx                          # 0044a9c4
    shr ecx, 0x2                                 # 0044a9c6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a9c9
    {load} mov ecx, eax                          # 0044a9cb
    and ecx, 0x3                                 # 0044a9cd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a9d0
    jmp.d8 L_0044aa26                            # 0044a9d2
L_0044a9d4:
    # block 0x0044a9d4: entered by je at 0x0044a97c, 16 instruction(s), ends with forward jump to 0x0044aa26
    mov edi, 0x548c98                            # 0044a9d4
    lea edx, [ebp - local_9c]                    # 0044a9d9
    or ecx, -0x1                                 # 0044a9df
    {load} xor eax, eax                          # 0044a9e2
    repne scasb al, byte ptr es:[edi]            # 0044a9e4
    not ecx                                      # 0044a9e6
    {load} sub edi, ecx                          # 0044a9e8
    {load} mov esi, edi                          # 0044a9ea
    {load} mov eax, ecx                          # 0044a9ec
    {load} mov edi, edx                          # 0044a9ee
    shr ecx, 0x2                                 # 0044a9f0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a9f3
    {load} mov ecx, eax                          # 0044a9f5
    and ecx, 0x3                                 # 0044a9f7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a9fa
    jmp.d8 L_0044aa26                            # 0044a9fc
L_0044a9fe:
    # block 0x0044a9fe: entered by jmp at 0x0044a97e, 15 instruction(s), falls into the block at 0x0044aa26
    mov edi, 0x548ca0                            # 0044a9fe
    lea edx, [ebp - local_9c]                    # 0044aa03
    or ecx, -0x1                                 # 0044aa09
    {load} xor eax, eax                          # 0044aa0c
    repne scasb al, byte ptr es:[edi]            # 0044aa0e
    not ecx                                      # 0044aa10
    {load} sub edi, ecx                          # 0044aa12
    {load} mov esi, edi                          # 0044aa14
    {load} mov eax, ecx                          # 0044aa16
    {load} mov edi, edx                          # 0044aa18
    shr ecx, 0x2                                 # 0044aa1a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044aa1d
    {load} mov ecx, eax                          # 0044aa1f
    and ecx, 0x3                                 # 0044aa21
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044aa24
L_0044aa26:
    # block 0x0044aa26: entered by jmp at 0x0044a9a8; jmp at 0x0044a9d2; jmp at 0x0044a9fc, 9 instruction(s), calls KERNEL32.dll!WritePrivateProfileStringA, ends with je to 0x0044aa73 (forward)
    push 0x639897                                # 0044aa26
    lea ecx, [ebp - local_9c]                    # 0044aa2b
    push ecx                                     # 0044aa31
    push 0x548cb8                                # 0044aa32
    push 0x548cc8                                # 0044aa37
    call dword ptr [0x52a26c]                    # 0044aa3c
    movsx edx, word ptr [0x63a4cd]               # 0044aa42
    test edx, edx                                # 0044aa49
    je.d8 L_0044aa73                             # 0044aa4b
    # block 0x0044aa4d: entered by fall-through of je at 0x0044aa4b, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044aa73
    lea eax, [ebp - local_9c]                    # 0044aa4d
    push eax                                     # 0044aa53
    push 0x548cd4                                # 0044aa54
    push 0x63888b                                # 0044aa59
    call FUN_0050ca3e                            # 0044aa5e
    add esp, 0xc                                 # 0044aa63
    push 0x63888b                                # 0044aa66
    call FUN_0044a2b7                            # 0044aa6b
    add esp, 0x4                                 # 0044aa70
L_0044aa73:
    # block 0x0044aa73: entered by je at 0x0044aa4b, 5 instruction(s), ends with ret
    pop edi                                      # 0044aa73
    pop esi                                      # 0044aa74
    {load} mov esp, ebp                          # 0044aa75
    pop ebp                                      # 0044aa77
    ret                                          # 0044aa78

