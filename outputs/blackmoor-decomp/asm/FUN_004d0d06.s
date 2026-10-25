# FUN_004d0d06
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0d06
# extent:       0x004d0d06-0x004d1898 (2962 code bytes)
# span:         0x004d0d06-0x004d1898 (code 2962, tables 0, padding 0)
# sha256:       110677ed38dc152d10f6a312b183027a58b9a277c765a6a07dfe33607987bf2e
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d0d06
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_38
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004d3836, FUN_0044aa79, FUN_0050ca3e, FUN_004c924d, FUN_004d2c20, FUN_004d36ed, FUN_004c92c5, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 670 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_38, 0x38  # offset -0x38

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044aa79, .text + (0x0044aa79 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004d0d06 - 0x401000
.globl FUN_004d0d06
FUN_004d0d06:
    # block 0x004d0d06: entry, 7 instruction(s), ends with je to 0x004d0d25 (forward)
    push ebp                                     # 004d0d06
    {load} mov ebp, esp                          # 004d0d07
    sub esp, 0x38                                # 004d0d09
    push esi                                     # 004d0d0c
    movsx eax, word ptr [0x5bb218]               # 004d0d0d
    test eax, eax                                # 004d0d14
    je.d8 L_004d0d25                             # 004d0d16
    # block 0x004d0d18: entered by fall-through of je at 0x004d0d16, 2 instruction(s), ends with je to 0x004d1348 (forward)
    cmp dword ptr [0x63a988], 0x0                # 004d0d18
    je.d32 L_004d1348                            # 004d0d1f
L_004d0d25:
    # block 0x004d0d25: entered by je at 0x004d0d16; fall-through of je at 0x004d0d1f, 2 instruction(s), ends with jne to 0x004d118f (forward)
    cmp dword ptr [0x63a980], 0x0                # 004d0d25
    jne.d32 L_004d118f                           # 004d0d2c
    # block 0x004d0d32: entered by fall-through of jne at 0x004d0d2c, 256 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004d3836, FUN_0044aa79, FUN_0050ca3e, FUN_004c924d, FUN_004d2c20, ends with forward jump to 0x004d1343
    mov dword ptr [0x63a988], 0x1                # 004d0d32
    call dword ptr [0x52a23c]                    # 004d0d3c
    movsx ecx, word ptr [0x5b026c]               # 004d0d42
    {load} add eax, ecx                          # 004d0d49
    mov dword ptr [0x63a978], eax                # 004d0d4b
    movsx edx, word ptr [0x5b0268]               # 004d0d50
    imul edx, edx, 0x1d0                         # 004d0d57
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0d5d
    imul eax, eax, 0x5                           # 004d0d64
    mov word ptr [ebp - local_4], ax             # 004d0d67
    mov eax, dword ptr [0x583192]                # 004d0d6b
    sub eax, dword ptr [0x58318a]                # 004d0d70
    add eax, 0x1                                 # 004d0d76
    movsx ecx, word ptr [ebp - local_4]          # 004d0d79
    {load} sub eax, ecx                          # 004d0d7d
    cdq                                          # 004d0d7f
    {load} sub eax, edx                          # 004d0d80
    sar eax                                      # 004d0d82
    add eax, dword ptr [0x58318a]                # 004d0d84
    mov word ptr [0x63a970], ax                  # 004d0d8a
    movsx ecx, word ptr [0x63a970]               # 004d0d90
    movsx edx, word ptr [0x5b0268]               # 004d0d97
    imul edx, edx, 0x1d0                         # 004d0d9e
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0da4
    {load} add ecx, eax                          # 004d0dab
    movsx edx, word ptr [0x5b0268]               # 004d0dad
    imul edx, edx, 0x1d0                         # 004d0db4
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0dba
    cdq                                          # 004d0dc1
    {load} sub eax, edx                          # 004d0dc2
    sar eax                                      # 004d0dc4
    {load} add ecx, eax                          # 004d0dc6
    mov word ptr [0x63a972], cx                  # 004d0dc8
    movsx ecx, word ptr [0x63a972]               # 004d0dcf
    movsx edx, word ptr [0x5b0268]               # 004d0dd6
    imul edx, edx, 0x1d0                         # 004d0ddd
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0de3
    {load} add ecx, eax                          # 004d0dea
    movsx edx, word ptr [0x5b0268]               # 004d0dec
    imul edx, edx, 0x1d0                         # 004d0df3
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0df9
    cdq                                          # 004d0e00
    {load} sub eax, edx                          # 004d0e01
    sar eax                                      # 004d0e03
    {load} add ecx, eax                          # 004d0e05
    mov word ptr [0x63a974], cx                  # 004d0e07
    movsx ecx, word ptr [0x63a974]               # 004d0e0e
    movsx edx, word ptr [0x5b0268]               # 004d0e15
    imul edx, edx, 0x1d0                         # 004d0e1c
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0e22
    {load} add ecx, eax                          # 004d0e29
    movsx edx, word ptr [0x5b0268]               # 004d0e2b
    imul edx, edx, 0x1d0                         # 004d0e32
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d0e38
    cdq                                          # 004d0e3f
    {load} sub eax, edx                          # 004d0e40
    sar eax                                      # 004d0e42
    {load} add ecx, eax                          # 004d0e44
    mov word ptr [0x63a976], cx                  # 004d0e46
    mov esi, dword ptr [0x58318e]                # 004d0e4d
    sub esi, dword ptr [0x583186]                # 004d0e53
    add esi, 0x1                                 # 004d0e59
    movsx eax, word ptr [0x5b0268]               # 004d0e5c
    imul eax, eax, 0x1d0                         # 004d0e63
    add eax, 0x5adb3a                            # 004d0e69
    push eax                                     # 004d0e6e
    movsx ecx, word ptr [0x5b0268]               # 004d0e6f
    imul ecx, ecx, 0x7f3                         # 004d0e76
    add ecx, 0x5a4c24                            # 004d0e7c
    push ecx                                     # 004d0e82
    push 0x5b0113                                # 004d0e83
    call FUN_004d3836                            # 004d0e88
    add esp, 0xc                                 # 004d0e8d
    movsx edx, ax                                # 004d0e90
    {load} sub esi, edx                          # 004d0e93
    {load} mov eax, esi                          # 004d0e95
    cdq                                          # 004d0e97
    {load} sub eax, edx                          # 004d0e98
    sar eax                                      # 004d0e9a
    add eax, dword ptr [0x583186]                # 004d0e9c
    mov word ptr [0x63a968], ax                  # 004d0ea2
    mov esi, dword ptr [0x58318e]                # 004d0ea8
    sub esi, dword ptr [0x583186]                # 004d0eae
    add esi, 0x1                                 # 004d0eb4
    movsx eax, word ptr [0x5b0268]               # 004d0eb7
    imul eax, eax, 0x1d0                         # 004d0ebe
    add eax, 0x5adb3a                            # 004d0ec4
    push eax                                     # 004d0ec9
    movsx ecx, word ptr [0x5b0268]               # 004d0eca
    imul ecx, ecx, 0x7f3                         # 004d0ed1
    add ecx, 0x5a4c24                            # 004d0ed7
    push ecx                                     # 004d0edd
    push 0x5b0131                                # 004d0ede
    call FUN_004d3836                            # 004d0ee3
    add esp, 0xc                                 # 004d0ee8
    movsx edx, ax                                # 004d0eeb
    {load} sub esi, edx                          # 004d0eee
    {load} mov eax, esi                          # 004d0ef0
    cdq                                          # 004d0ef2
    {load} sub eax, edx                          # 004d0ef3
    sar eax                                      # 004d0ef5
    add eax, dword ptr [0x583186]                # 004d0ef7
    mov word ptr [0x63a96a], ax                  # 004d0efd
    mov esi, dword ptr [0x58318e]                # 004d0f03
    sub esi, dword ptr [0x583186]                # 004d0f09
    add esi, 0x1                                 # 004d0f0f
    movsx eax, word ptr [0x5b0268]               # 004d0f12
    imul eax, eax, 0x1d0                         # 004d0f19
    add eax, 0x5adb3a                            # 004d0f1f
    push eax                                     # 004d0f24
    movsx ecx, word ptr [0x5b0268]               # 004d0f25
    imul ecx, ecx, 0x7f3                         # 004d0f2c
    add ecx, 0x5a4c24                            # 004d0f32
    push ecx                                     # 004d0f38
    push 0x5b014f                                # 004d0f39
    call FUN_004d3836                            # 004d0f3e
    add esp, 0xc                                 # 004d0f43
    movsx edx, ax                                # 004d0f46
    {load} sub esi, edx                          # 004d0f49
    {load} mov eax, esi                          # 004d0f4b
    cdq                                          # 004d0f4d
    {load} sub eax, edx                          # 004d0f4e
    sar eax                                      # 004d0f50
    add eax, dword ptr [0x583186]                # 004d0f52
    mov word ptr [0x63a96c], ax                  # 004d0f58
    movsx eax, word ptr [0x5bb224]               # 004d0f5e
    mov ecx, dword ptr [4*eax + 0x559dac]        # 004d0f65
    push ecx                                     # 004d0f6c
    movsx edx, word ptr [0x5bb222]               # 004d0f6d
    push edx                                     # 004d0f74
    movsx eax, word ptr [0x5bb220]               # 004d0f75
    push eax                                     # 004d0f7c
    movsx ecx, word ptr [0x5bb21e]               # 004d0f7d
    push ecx                                     # 004d0f84
    push 0x32                                    # 004d0f85
    lea edx, [ebp - local_38]                    # 004d0f87
    push edx                                     # 004d0f8a
    call FUN_0044aa79                            # 004d0f8b
    add esp, 0x8                                 # 004d0f90
    push eax                                     # 004d0f93
    push 0x55a13c                                # 004d0f94
    push 0x63a904                                # 004d0f99
    call FUN_0050ca3e                            # 004d0f9e
    add esp, 0x1c                                # 004d0fa3
    mov esi, dword ptr [0x58318e]                # 004d0fa6
    sub esi, dword ptr [0x583186]                # 004d0fac
    add esi, 0x1                                 # 004d0fb2
    movsx eax, word ptr [0x5b0268]               # 004d0fb5
    imul eax, eax, 0x1d0                         # 004d0fbc
    add eax, 0x5adb3a                            # 004d0fc2
    push eax                                     # 004d0fc7
    movsx ecx, word ptr [0x5b0268]               # 004d0fc8
    imul ecx, ecx, 0x7f3                         # 004d0fcf
    add ecx, 0x5a4c24                            # 004d0fd5
    push ecx                                     # 004d0fdb
    push 0x63a904                                # 004d0fdc
    call FUN_004d3836                            # 004d0fe1
    add esp, 0xc                                 # 004d0fe6
    movsx edx, ax                                # 004d0fe9
    {load} sub esi, edx                          # 004d0fec
    {load} mov eax, esi                          # 004d0fee
    cdq                                          # 004d0ff0
    {load} sub eax, edx                          # 004d0ff1
    sar eax                                      # 004d0ff3
    add eax, dword ptr [0x583186]                # 004d0ff5
    mov word ptr [0x63a96e], ax                  # 004d0ffb
    mov ax, word ptr [0x5b0268]                  # 004d1001
    push eax                                     # 004d1007
    mov ecx, 0x5cf659                            # 004d1008
    call FUN_004c924d                            # 004d100d
    push 0x1                                     # 004d1012
    mov ecx, dword ptr [0x5cf665]                # 004d1014
    push ecx                                     # 004d101a
    movsx edx, word ptr [0x5b0268]               # 004d101b
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d1022
    push eax                                     # 004d1029
    mov cx, word ptr [0x63a970]                  # 004d102a
    push ecx                                     # 004d1031
    mov dx, word ptr [0x63a968]                  # 004d1032
    push edx                                     # 004d1039
    movsx eax, word ptr [0x5b0268]               # 004d103a
    imul eax, eax, 0x1d0                         # 004d1041
    add eax, 0x5adb3a                            # 004d1047
    push eax                                     # 004d104c
    movsx ecx, word ptr [0x5b0268]               # 004d104d
    imul ecx, ecx, 0x7f3                         # 004d1054
    add ecx, 0x5a4c24                            # 004d105a
    push ecx                                     # 004d1060
    push 0x5b0113                                # 004d1061
    call FUN_004d2c20                            # 004d1066
    add esp, 0x20                                # 004d106b
    push 0x1                                     # 004d106e
    mov edx, dword ptr [0x5cf665]                # 004d1070
    push edx                                     # 004d1076
    movsx eax, word ptr [0x5b0268]               # 004d1077
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d107e
    push ecx                                     # 004d1085
    mov dx, word ptr [0x63a972]                  # 004d1086
    push edx                                     # 004d108d
    mov ax, word ptr [0x63a96a]                  # 004d108e
    push eax                                     # 004d1094
    movsx ecx, word ptr [0x5b0268]               # 004d1095
    imul ecx, ecx, 0x1d0                         # 004d109c
    add ecx, 0x5adb3a                            # 004d10a2
    push ecx                                     # 004d10a8
    movsx edx, word ptr [0x5b0268]               # 004d10a9
    imul edx, edx, 0x7f3                         # 004d10b0
    add edx, 0x5a4c24                            # 004d10b6
    push edx                                     # 004d10bc
    push 0x5b0131                                # 004d10bd
    call FUN_004d2c20                            # 004d10c2
    add esp, 0x20                                # 004d10c7
    push 0x1                                     # 004d10ca
    mov eax, dword ptr [0x5cf665]                # 004d10cc
    push eax                                     # 004d10d1
    movsx ecx, word ptr [0x5b0268]               # 004d10d2
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d10d9
    push edx                                     # 004d10e0
    mov ax, word ptr [0x63a974]                  # 004d10e1
    push eax                                     # 004d10e7
    mov cx, word ptr [0x63a96c]                  # 004d10e8
    push ecx                                     # 004d10ef
    movsx edx, word ptr [0x5b0268]               # 004d10f0
    imul edx, edx, 0x1d0                         # 004d10f7
    add edx, 0x5adb3a                            # 004d10fd
    push edx                                     # 004d1103
    movsx eax, word ptr [0x5b0268]               # 004d1104
    imul eax, eax, 0x7f3                         # 004d110b
    add eax, 0x5a4c24                            # 004d1111
    push eax                                     # 004d1116
    push 0x5b014f                                # 004d1117
    call FUN_004d2c20                            # 004d111c
    add esp, 0x20                                # 004d1121
    push 0x1                                     # 004d1124
    mov ecx, dword ptr [0x5cf665]                # 004d1126
    push ecx                                     # 004d112c
    movsx edx, word ptr [0x5b0268]               # 004d112d
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d1134
    push eax                                     # 004d113b
    mov cx, word ptr [0x63a976]                  # 004d113c
    push ecx                                     # 004d1143
    mov dx, word ptr [0x63a96e]                  # 004d1144
    push edx                                     # 004d114b
    movsx eax, word ptr [0x5b0268]               # 004d114c
    imul eax, eax, 0x1d0                         # 004d1153
    add eax, 0x5adb3a                            # 004d1159
    push eax                                     # 004d115e
    movsx ecx, word ptr [0x5b0268]               # 004d115f
    imul ecx, ecx, 0x7f3                         # 004d1166
    add ecx, 0x5a4c24                            # 004d116c
    push ecx                                     # 004d1172
    push 0x63a904                                # 004d1173
    call FUN_004d2c20                            # 004d1178
    add esp, 0x20                                # 004d117d
    mov dword ptr [0x63a980], 0x1                # 004d1180
    jmp.d32 L_004d1343                           # 004d118a
L_004d118f:
    # block 0x004d118f: entered by jne at 0x004d0d2c, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d11d7 (forward)
    call dword ptr [0x52a23c]                    # 004d118f
    cmp eax, dword ptr [0x63a978]                # 004d1195
    jbe.d8 L_004d11d7                            # 004d119b
    # block 0x004d119d: entered by fall-through of jbe at 0x004d119b, 9 instruction(s), calls FUN_004d36ed, FUN_004c92c5, ends with forward jump to 0x004d1343
    call FUN_004d36ed                            # 004d119d
    mov dx, word ptr [0x5b0268]                  # 004d11a2
    push edx                                     # 004d11a9
    mov ecx, 0x5cf659                            # 004d11aa
    call FUN_004c92c5                            # 004d11af
    mov dword ptr [0x5d17ab], 0x0                # 004d11b4
    mov dword ptr [0x63a980], 0x0                # 004d11be
    mov dword ptr [0x63a988], 0x0                # 004d11c8
    jmp.d32 L_004d1343                           # 004d11d2
L_004d11d7:
    # block 0x004d11d7: entered by jbe at 0x004d119b, 84 instruction(s), calls FUN_004d2c20, falls into the block at 0x004d1343
    push 0x1                                     # 004d11d7
    mov eax, dword ptr [0x5cf665]                # 004d11d9
    push eax                                     # 004d11de
    movsx ecx, word ptr [0x5b0268]               # 004d11df
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d11e6
    push edx                                     # 004d11ed
    mov ax, word ptr [0x63a970]                  # 004d11ee
    push eax                                     # 004d11f4
    mov cx, word ptr [0x63a968]                  # 004d11f5
    push ecx                                     # 004d11fc
    movsx edx, word ptr [0x5b0268]               # 004d11fd
    imul edx, edx, 0x1d0                         # 004d1204
    add edx, 0x5adb3a                            # 004d120a
    push edx                                     # 004d1210
    movsx eax, word ptr [0x5b0268]               # 004d1211
    imul eax, eax, 0x7f3                         # 004d1218
    add eax, 0x5a4c24                            # 004d121e
    push eax                                     # 004d1223
    push 0x5b0113                                # 004d1224
    call FUN_004d2c20                            # 004d1229
    add esp, 0x20                                # 004d122e
    push 0x1                                     # 004d1231
    mov ecx, dword ptr [0x5cf665]                # 004d1233
    push ecx                                     # 004d1239
    movsx edx, word ptr [0x5b0268]               # 004d123a
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d1241
    push eax                                     # 004d1248
    mov cx, word ptr [0x63a972]                  # 004d1249
    push ecx                                     # 004d1250
    mov dx, word ptr [0x63a96a]                  # 004d1251
    push edx                                     # 004d1258
    movsx eax, word ptr [0x5b0268]               # 004d1259
    imul eax, eax, 0x1d0                         # 004d1260
    add eax, 0x5adb3a                            # 004d1266
    push eax                                     # 004d126b
    movsx ecx, word ptr [0x5b0268]               # 004d126c
    imul ecx, ecx, 0x7f3                         # 004d1273
    add ecx, 0x5a4c24                            # 004d1279
    push ecx                                     # 004d127f
    push 0x5b0131                                # 004d1280
    call FUN_004d2c20                            # 004d1285
    add esp, 0x20                                # 004d128a
    push 0x1                                     # 004d128d
    mov edx, dword ptr [0x5cf665]                # 004d128f
    push edx                                     # 004d1295
    movsx eax, word ptr [0x5b0268]               # 004d1296
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d129d
    push ecx                                     # 004d12a4
    mov dx, word ptr [0x63a974]                  # 004d12a5
    push edx                                     # 004d12ac
    mov ax, word ptr [0x63a96c]                  # 004d12ad
    push eax                                     # 004d12b3
    movsx ecx, word ptr [0x5b0268]               # 004d12b4
    imul ecx, ecx, 0x1d0                         # 004d12bb
    add ecx, 0x5adb3a                            # 004d12c1
    push ecx                                     # 004d12c7
    movsx edx, word ptr [0x5b0268]               # 004d12c8
    imul edx, edx, 0x7f3                         # 004d12cf
    add edx, 0x5a4c24                            # 004d12d5
    push edx                                     # 004d12db
    push 0x5b014f                                # 004d12dc
    call FUN_004d2c20                            # 004d12e1
    add esp, 0x20                                # 004d12e6
    push 0x1                                     # 004d12e9
    mov eax, dword ptr [0x5cf665]                # 004d12eb
    push eax                                     # 004d12f0
    movsx ecx, word ptr [0x5b0268]               # 004d12f1
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d12f8
    push edx                                     # 004d12ff
    mov ax, word ptr [0x63a976]                  # 004d1300
    push eax                                     # 004d1306
    mov cx, word ptr [0x63a96e]                  # 004d1307
    push ecx                                     # 004d130e
    movsx edx, word ptr [0x5b0268]               # 004d130f
    imul edx, edx, 0x1d0                         # 004d1316
    add edx, 0x5adb3a                            # 004d131c
    push edx                                     # 004d1322
    movsx eax, word ptr [0x5b0268]               # 004d1323
    imul eax, eax, 0x7f3                         # 004d132a
    add eax, 0x5a4c24                            # 004d1330
    push eax                                     # 004d1335
    push 0x63a904                                # 004d1336
    call FUN_004d2c20                            # 004d133b
    add esp, 0x20                                # 004d1340
L_004d1343:
    # block 0x004d1343: entered by jmp at 0x004d118a; jmp at 0x004d11d2, 1 instruction(s), ends with forward jump to 0x004d1893
    jmp.d32 L_004d1893                           # 004d1343
L_004d1348:
    # block 0x004d1348: entered by je at 0x004d0d1f, 2 instruction(s), ends with jne to 0x004d1717 (forward)
    cmp dword ptr [0x63a984], 0x0                # 004d1348
    jne.d32 L_004d1717                           # 004d134f
    # block 0x004d1355: entered by fall-through of jne at 0x004d134f, 6 instruction(s), ends with jl to 0x004d1377 (forward)
    mov cl, byte ptr [0x5b6047]                  # 004d1355
    add cl, 0x1                                  # 004d135b
    mov byte ptr [0x5b6047], cl                  # 004d135e
    movsx edx, byte ptr [0x5b6047]               # 004d1364
    cmp edx, 0x14                                # 004d136b
    jl.d8 L_004d1377                             # 004d136e
    # block 0x004d1370: entered by fall-through of jl at 0x004d136e, 1 instruction(s), falls into the block at 0x004d1377
    mov byte ptr [0x5b6047], 0x0                 # 004d1370
L_004d1377:
    # block 0x004d1377: entered by jl at 0x004d136e, 3 instruction(s), ends with je to 0x004d13a9 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004d1377
    test eax, eax                                # 004d137e
    je.d8 L_004d13a9                             # 004d1380
    # block 0x004d1382: entered by fall-through of je at 0x004d1380, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004d13a9
    movsx ecx, byte ptr [0x5b6047]               # 004d1382
    push ecx                                     # 004d1389
    push 0x55a154                                # 004d138a
    push 0x63888b                                # 004d138f
    call FUN_0050ca3e                            # 004d1394
    add esp, 0xc                                 # 004d1399
    push 0x63888b                                # 004d139c
    call FUN_0044a2b7                            # 004d13a1
    add esp, 0x4                                 # 004d13a6
L_004d13a9:
    # block 0x004d13a9: entered by je at 0x004d1380, 198 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004d3836, FUN_004c924d, FUN_004d2c20, ends with forward jump to 0x004d1893
    call dword ptr [0x52a23c]                    # 004d13a9
    movsx edx, word ptr [0x5b026c]               # 004d13af
    {load} add eax, edx                          # 004d13b6
    mov dword ptr [0x63a900], eax                # 004d13b8
    movsx eax, word ptr [0x5b026a]               # 004d13bd
    imul eax, eax, 0x1d0                         # 004d13c4
    movsx ecx, word ptr [eax + 0x5adb3c]         # 004d13ca
    shl ecx, 0x2                                 # 004d13d1
    mov word ptr [ebp - local_4], cx             # 004d13d4
    mov eax, dword ptr [0x583192]                # 004d13d8
    sub eax, dword ptr [0x58318a]                # 004d13dd
    add eax, 0x1                                 # 004d13e3
    movsx edx, word ptr [ebp - local_4]          # 004d13e6
    {load} sub eax, edx                          # 004d13ea
    cdq                                          # 004d13ec
    {load} sub eax, edx                          # 004d13ed
    sar eax                                      # 004d13ef
    add eax, dword ptr [0x58318a]                # 004d13f1
    mov word ptr [0x63a970], ax                  # 004d13f7
    movsx ecx, word ptr [0x63a970]               # 004d13fd
    movsx edx, word ptr [0x5b026a]               # 004d1404
    imul edx, edx, 0x1d0                         # 004d140b
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d1411
    {load} add ecx, eax                          # 004d1418
    movsx edx, word ptr [0x5b026a]               # 004d141a
    imul edx, edx, 0x1d0                         # 004d1421
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d1427
    cdq                                          # 004d142e
    {load} sub eax, edx                          # 004d142f
    sar eax                                      # 004d1431
    {load} add ecx, eax                          # 004d1433
    mov word ptr [0x63a972], cx                  # 004d1435
    movsx ecx, word ptr [0x63a972]               # 004d143c
    movsx edx, word ptr [0x5b026a]               # 004d1443
    imul edx, edx, 0x1d0                         # 004d144a
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d1450
    {load} add ecx, eax                          # 004d1457
    movsx edx, word ptr [0x5b026a]               # 004d1459
    imul edx, edx, 0x1d0                         # 004d1460
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d1466
    cdq                                          # 004d146d
    {load} sub eax, edx                          # 004d146e
    sar eax                                      # 004d1470
    {load} add ecx, eax                          # 004d1472
    mov word ptr [0x63a974], cx                  # 004d1474
    mov esi, dword ptr [0x58318e]                # 004d147b
    sub esi, dword ptr [0x583186]                # 004d1481
    add esi, 0x1                                 # 004d1487
    movsx eax, word ptr [0x5b026a]               # 004d148a
    imul eax, eax, 0x1d0                         # 004d1491
    add eax, 0x5adb3a                            # 004d1497
    push eax                                     # 004d149c
    movsx ecx, word ptr [0x5b026a]               # 004d149d
    imul ecx, ecx, 0x7f3                         # 004d14a4
    add ecx, 0x5a4c24                            # 004d14aa
    push ecx                                     # 004d14b0
    movsx edx, byte ptr [0x5b6047]               # 004d14b1
    imul edx, edx, 0xb4                          # 004d14b8
    add edx, 0x5b5237                            # 004d14be
    push edx                                     # 004d14c4
    call FUN_004d3836                            # 004d14c5
    add esp, 0xc                                 # 004d14ca
    movsx eax, ax                                # 004d14cd
    {load} sub esi, eax                          # 004d14d0
    {load} mov eax, esi                          # 004d14d2
    cdq                                          # 004d14d4
    {load} sub eax, edx                          # 004d14d5
    sar eax                                      # 004d14d7
    add eax, dword ptr [0x583186]                # 004d14d9
    mov word ptr [0x63a968], ax                  # 004d14df
    mov esi, dword ptr [0x58318e]                # 004d14e5
    sub esi, dword ptr [0x583186]                # 004d14eb
    add esi, 0x1                                 # 004d14f1
    movsx ecx, word ptr [0x5b026a]               # 004d14f4
    imul ecx, ecx, 0x1d0                         # 004d14fb
    add ecx, 0x5adb3a                            # 004d1501
    push ecx                                     # 004d1507
    movsx edx, word ptr [0x5b026a]               # 004d1508
    imul edx, edx, 0x7f3                         # 004d150f
    add edx, 0x5a4c24                            # 004d1515
    push edx                                     # 004d151b
    movsx eax, byte ptr [0x5b6047]               # 004d151c
    imul eax, eax, 0xb4                          # 004d1523
    add eax, 0x5b5273                            # 004d1529
    push eax                                     # 004d152e
    call FUN_004d3836                            # 004d152f
    add esp, 0xc                                 # 004d1534
    movsx ecx, ax                                # 004d1537
    {load} sub esi, ecx                          # 004d153a
    {load} mov eax, esi                          # 004d153c
    cdq                                          # 004d153e
    {load} sub eax, edx                          # 004d153f
    sar eax                                      # 004d1541
    add eax, dword ptr [0x583186]                # 004d1543
    mov word ptr [0x63a96a], ax                  # 004d1549
    mov esi, dword ptr [0x58318e]                # 004d154f
    sub esi, dword ptr [0x583186]                # 004d1555
    add esi, 0x1                                 # 004d155b
    movsx edx, word ptr [0x5b026a]               # 004d155e
    imul edx, edx, 0x1d0                         # 004d1565
    add edx, 0x5adb3a                            # 004d156b
    push edx                                     # 004d1571
    movsx eax, word ptr [0x5b026a]               # 004d1572
    imul eax, eax, 0x7f3                         # 004d1579
    add eax, 0x5a4c24                            # 004d157f
    push eax                                     # 004d1584
    movsx ecx, byte ptr [0x5b6047]               # 004d1585
    imul ecx, ecx, 0xb4                          # 004d158c
    add ecx, 0x5b52af                            # 004d1592
    push ecx                                     # 004d1598
    call FUN_004d3836                            # 004d1599
    add esp, 0xc                                 # 004d159e
    movsx edx, ax                                # 004d15a1
    {load} sub esi, edx                          # 004d15a4
    {load} mov eax, esi                          # 004d15a6
    cdq                                          # 004d15a8
    {load} sub eax, edx                          # 004d15a9
    sar eax                                      # 004d15ab
    add eax, dword ptr [0x583186]                # 004d15ad
    mov word ptr [0x63a96c], ax                  # 004d15b3
    mov ax, word ptr [0x5b026a]                  # 004d15b9
    push eax                                     # 004d15bf
    mov ecx, 0x5cf659                            # 004d15c0
    call FUN_004c924d                            # 004d15c5
    push 0x1                                     # 004d15ca
    mov ecx, dword ptr [0x5cf665]                # 004d15cc
    push ecx                                     # 004d15d2
    movsx edx, word ptr [0x5b026a]               # 004d15d3
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d15da
    push eax                                     # 004d15e1
    mov cx, word ptr [0x63a970]                  # 004d15e2
    push ecx                                     # 004d15e9
    mov dx, word ptr [0x63a968]                  # 004d15ea
    push edx                                     # 004d15f1
    movsx eax, word ptr [0x5b026a]               # 004d15f2
    imul eax, eax, 0x1d0                         # 004d15f9
    add eax, 0x5adb3a                            # 004d15ff
    push eax                                     # 004d1604
    movsx ecx, word ptr [0x5b026a]               # 004d1605
    imul ecx, ecx, 0x7f3                         # 004d160c
    add ecx, 0x5a4c24                            # 004d1612
    push ecx                                     # 004d1618
    movsx edx, byte ptr [0x5b6047]               # 004d1619
    imul edx, edx, 0xb4                          # 004d1620
    add edx, 0x5b5237                            # 004d1626
    push edx                                     # 004d162c
    call FUN_004d2c20                            # 004d162d
    add esp, 0x20                                # 004d1632
    push 0x1                                     # 004d1635
    mov eax, dword ptr [0x5cf665]                # 004d1637
    push eax                                     # 004d163c
    movsx ecx, word ptr [0x5b026a]               # 004d163d
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d1644
    push edx                                     # 004d164b
    mov ax, word ptr [0x63a972]                  # 004d164c
    push eax                                     # 004d1652
    mov cx, word ptr [0x63a96a]                  # 004d1653
    push ecx                                     # 004d165a
    movsx edx, word ptr [0x5b026a]               # 004d165b
    imul edx, edx, 0x1d0                         # 004d1662
    add edx, 0x5adb3a                            # 004d1668
    push edx                                     # 004d166e
    movsx eax, word ptr [0x5b026a]               # 004d166f
    imul eax, eax, 0x7f3                         # 004d1676
    add eax, 0x5a4c24                            # 004d167c
    push eax                                     # 004d1681
    movsx ecx, byte ptr [0x5b6047]               # 004d1682
    imul ecx, ecx, 0xb4                          # 004d1689
    add ecx, 0x5b5273                            # 004d168f
    push ecx                                     # 004d1695
    call FUN_004d2c20                            # 004d1696
    add esp, 0x20                                # 004d169b
    push 0x1                                     # 004d169e
    mov edx, dword ptr [0x5cf665]                # 004d16a0
    push edx                                     # 004d16a6
    movsx eax, word ptr [0x5b026a]               # 004d16a7
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d16ae
    push ecx                                     # 004d16b5
    mov dx, word ptr [0x63a974]                  # 004d16b6
    push edx                                     # 004d16bd
    mov ax, word ptr [0x63a96c]                  # 004d16be
    push eax                                     # 004d16c4
    movsx ecx, word ptr [0x5b026a]               # 004d16c5
    imul ecx, ecx, 0x1d0                         # 004d16cc
    add ecx, 0x5adb3a                            # 004d16d2
    push ecx                                     # 004d16d8
    movsx edx, word ptr [0x5b026a]               # 004d16d9
    imul edx, edx, 0x7f3                         # 004d16e0
    add edx, 0x5a4c24                            # 004d16e6
    push edx                                     # 004d16ec
    movsx eax, byte ptr [0x5b6047]               # 004d16ed
    imul eax, eax, 0xb4                          # 004d16f4
    add eax, 0x5b52af                            # 004d16fa
    push eax                                     # 004d16ff
    call FUN_004d2c20                            # 004d1700
    add esp, 0x20                                # 004d1705
    mov dword ptr [0x63a984], 0x1                # 004d1708
    jmp.d32 L_004d1893                           # 004d1712
L_004d1717:
    # block 0x004d1717: entered by jne at 0x004d134f, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d1755 (forward)
    call dword ptr [0x52a23c]                    # 004d1717
    cmp eax, dword ptr [0x63a900]                # 004d171d
    jbe.d8 L_004d1755                            # 004d1723
    # block 0x004d1725: entered by fall-through of jbe at 0x004d1723, 8 instruction(s), calls FUN_004d36ed, FUN_004c92c5, ends with forward jump to 0x004d1893
    call FUN_004d36ed                            # 004d1725
    mov cx, word ptr [0x5b026a]                  # 004d172a
    push ecx                                     # 004d1731
    mov ecx, 0x5cf659                            # 004d1732
    call FUN_004c92c5                            # 004d1737
    mov dword ptr [0x5d17ab], 0x0                # 004d173c
    mov dword ptr [0x63a984], 0x0                # 004d1746
    jmp.d32 L_004d1893                           # 004d1750
L_004d1755:
    # block 0x004d1755: entered by jbe at 0x004d1723, 72 instruction(s), calls FUN_004d2c20, falls into the block at 0x004d1893
    push 0x1                                     # 004d1755
    mov edx, dword ptr [0x5cf665]                # 004d1757
    push edx                                     # 004d175d
    movsx eax, word ptr [0x5b026a]               # 004d175e
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d1765
    push ecx                                     # 004d176c
    mov dx, word ptr [0x63a970]                  # 004d176d
    push edx                                     # 004d1774
    mov ax, word ptr [0x63a968]                  # 004d1775
    push eax                                     # 004d177b
    movsx ecx, word ptr [0x5b026a]               # 004d177c
    imul ecx, ecx, 0x1d0                         # 004d1783
    add ecx, 0x5adb3a                            # 004d1789
    push ecx                                     # 004d178f
    movsx edx, word ptr [0x5b026a]               # 004d1790
    imul edx, edx, 0x7f3                         # 004d1797
    add edx, 0x5a4c24                            # 004d179d
    push edx                                     # 004d17a3
    movsx eax, byte ptr [0x5b6047]               # 004d17a4
    imul eax, eax, 0xb4                          # 004d17ab
    add eax, 0x5b5237                            # 004d17b1
    push eax                                     # 004d17b6
    call FUN_004d2c20                            # 004d17b7
    add esp, 0x20                                # 004d17bc
    push 0x1                                     # 004d17bf
    mov ecx, dword ptr [0x5cf665]                # 004d17c1
    push ecx                                     # 004d17c7
    movsx edx, word ptr [0x5b026a]               # 004d17c8
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d17cf
    push eax                                     # 004d17d6
    mov cx, word ptr [0x63a972]                  # 004d17d7
    push ecx                                     # 004d17de
    mov dx, word ptr [0x63a96a]                  # 004d17df
    push edx                                     # 004d17e6
    movsx eax, word ptr [0x5b026a]               # 004d17e7
    imul eax, eax, 0x1d0                         # 004d17ee
    add eax, 0x5adb3a                            # 004d17f4
    push eax                                     # 004d17f9
    movsx ecx, word ptr [0x5b026a]               # 004d17fa
    imul ecx, ecx, 0x7f3                         # 004d1801
    add ecx, 0x5a4c24                            # 004d1807
    push ecx                                     # 004d180d
    movsx edx, byte ptr [0x5b6047]               # 004d180e
    imul edx, edx, 0xb4                          # 004d1815
    add edx, 0x5b5273                            # 004d181b
    push edx                                     # 004d1821
    call FUN_004d2c20                            # 004d1822
    add esp, 0x20                                # 004d1827
    push 0x1                                     # 004d182a
    mov eax, dword ptr [0x5cf665]                # 004d182c
    push eax                                     # 004d1831
    movsx ecx, word ptr [0x5b026a]               # 004d1832
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d1839
    push edx                                     # 004d1840
    mov ax, word ptr [0x63a974]                  # 004d1841
    push eax                                     # 004d1847
    mov cx, word ptr [0x63a96c]                  # 004d1848
    push ecx                                     # 004d184f
    movsx edx, word ptr [0x5b026a]               # 004d1850
    imul edx, edx, 0x1d0                         # 004d1857
    add edx, 0x5adb3a                            # 004d185d
    push edx                                     # 004d1863
    movsx eax, word ptr [0x5b026a]               # 004d1864
    imul eax, eax, 0x7f3                         # 004d186b
    add eax, 0x5a4c24                            # 004d1871
    push eax                                     # 004d1876
    movsx ecx, byte ptr [0x5b6047]               # 004d1877
    imul ecx, ecx, 0xb4                          # 004d187e
    add ecx, 0x5b52af                            # 004d1884
    push ecx                                     # 004d188a
    call FUN_004d2c20                            # 004d188b
    add esp, 0x20                                # 004d1890
L_004d1893:
    # block 0x004d1893: entered by jmp at 0x004d1343; jmp at 0x004d1712; jmp at 0x004d1750, 4 instruction(s), ends with ret
    pop esi                                      # 004d1893
    {load} mov esp, ebp                          # 004d1894
    pop ebp                                      # 004d1896
    ret                                          # 004d1897

