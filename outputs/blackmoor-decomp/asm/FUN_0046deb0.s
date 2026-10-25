# FUN_0046deb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046deb0
# extent:       0x0046deb0-0x0046e54e (1694 code bytes)
# span:         0x0046deb0-0x0046e550 (code 1694, tables 0, padding 2)
# sha256:       56a60198f3fc4485182d33705e5a75a3d48d4d32fea50a831f4401e99178b52f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046deb0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_43, field_45, field_47, field_49, field_4f, field_69, field_2e9, field_47a; [ecx + n] field_4d, field_2e9, field_42a; [edx + n] field_4f, field_69, field_1a9, field_429, field_452, field_47a
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 418 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_47, 0x47  # offset +0x47
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_4f, 0x4f  # offset +0x4f
.equ field_69, 0x69  # offset +0x69
.equ field_1a9, 0x1a9  # offset +0x1a9
.equ field_2e9, 0x2e9  # offset +0x2e9
.equ field_429, 0x429  # offset +0x429
.equ field_42a, 0x42a  # offset +0x42a
.equ field_452, 0x452  # offset +0x452
.equ field_47a, 0x47a  # offset +0x47a

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x0046deb0 - 0x401000
.globl FUN_0046deb0
FUN_0046deb0:
    # block 0x0046deb0: entry, 9 instruction(s), ends with jne to 0x0046df39 (forward)
    push ebp                                     # 0046deb0
    {load} mov ebp, esp                          # 0046deb1
    sub esp, 0x18                                # 0046deb3
    movsx eax, word ptr [0x628750]               # 0046deb6
    imul eax, eax, 0x8d                          # 0046debd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046dec3
    mov dword ptr [ebp - local_c], ecx           # 0046dec9
    cmp dword ptr [0x62d162], 0x1                # 0046decc
    jne.d8 L_0046df39                            # 0046ded3
    # block 0x0046ded5: entered by fall-through of jne at 0x0046ded3, 20 instruction(s), calls FUN_004c5377, falls into the block at 0x0046df39
    mov dword ptr [0x62d162], 0x0                # 0046ded5
    push 0x54bdcc                                # 0046dedf
    movsx edx, word ptr [0x62d170]               # 0046dee4
    imul edx, edx, 0x140                         # 0046deeb
    movsx eax, word ptr [0x62d16e]               # 0046def1
    shl eax, 0x4                                 # 0046def8
    lea ecx, [edx + eax + 0x62a052]              # 0046defb
    push ecx                                     # 0046df02
    movsx edx, word ptr [0x62d170]               # 0046df03
    imul edx, edx, 0x140                         # 0046df0a
    movsx eax, word ptr [0x62d16e]               # 0046df10
    shl eax, 0x4                                 # 0046df17
    lea ecx, [edx + eax + 0x628752]              # 0046df1a
    push ecx                                     # 0046df21
    mov edx, dword ptr [0x5cf665]                # 0046df22
    push edx                                     # 0046df28
    mov eax, dword ptr [0x5d15e3]                # 0046df29
    push eax                                     # 0046df2e
    mov ecx, 0x5cf659                            # 0046df2f
    call FUN_004c5377                            # 0046df34
L_0046df39:
    # block 0x0046df39: entered by jne at 0x0046ded3, 2 instruction(s), ends with jne to 0x0046dfa7 (forward)
    cmp dword ptr [0x62d166], 0x1                # 0046df39
    jne.d8 L_0046dfa7                            # 0046df40
    # block 0x0046df42: entered by fall-through of jne at 0x0046df40, 20 instruction(s), calls FUN_004c5377, falls into the block at 0x0046dfa7
    mov dword ptr [0x62d166], 0x0                # 0046df42
    push 0x54bdfc                                # 0046df4c
    movsx ecx, word ptr [0x62d170]               # 0046df51
    imul ecx, ecx, 0xa0                          # 0046df58
    movsx edx, word ptr [0x62d16e]               # 0046df5e
    shl edx, 0x4                                 # 0046df65
    lea eax, [ecx + edx + 0x62bf92]              # 0046df68
    push eax                                     # 0046df6f
    movsx ecx, word ptr [0x62d170]               # 0046df70
    imul ecx, ecx, 0xa0                          # 0046df77
    movsx edx, word ptr [0x62d16e]               # 0046df7d
    shl edx, 0x4                                 # 0046df84
    lea eax, [ecx + edx + 0x62b952]              # 0046df87
    push eax                                     # 0046df8e
    mov ecx, dword ptr [0x5cf665]                # 0046df8f
    push ecx                                     # 0046df95
    mov edx, dword ptr [0x5d15e3]                # 0046df96
    push edx                                     # 0046df9c
    mov ecx, 0x5cf659                            # 0046df9d
    call FUN_004c5377                            # 0046dfa2
L_0046dfa7:
    # block 0x0046dfa7: entered by jne at 0x0046df40, 2 instruction(s), ends with jne to 0x0046e00e (forward)
    cmp dword ptr [0x62d16a], 0x1                # 0046dfa7
    jne.d8 L_0046e00e                            # 0046dfae
    # block 0x0046dfb0: entered by fall-through of jne at 0x0046dfae, 20 instruction(s), calls FUN_004c5377, falls into the block at 0x0046e00e
    mov dword ptr [0x62d16a], 0x0                # 0046dfb0
    push 0x54be2c                                # 0046dfba
    movsx eax, word ptr [0x62d170]               # 0046dfbf
    shl eax, 0x5                                 # 0046dfc6
    movsx ecx, word ptr [0x62d16e]               # 0046dfc9
    shl ecx, 0x4                                 # 0046dfd0
    lea edx, [eax + ecx + 0x62cad2]              # 0046dfd3
    push edx                                     # 0046dfda
    movsx eax, word ptr [0x62d170]               # 0046dfdb
    shl eax, 0x5                                 # 0046dfe2
    movsx ecx, word ptr [0x62d16e]               # 0046dfe5
    shl ecx, 0x4                                 # 0046dfec
    lea edx, [eax + ecx + 0x62c5d2]              # 0046dfef
    push edx                                     # 0046dff6
    mov eax, dword ptr [0x5cf665]                # 0046dff7
    push eax                                     # 0046dffc
    mov ecx, dword ptr [0x5d15e3]                # 0046dffd
    push ecx                                     # 0046e003
    mov ecx, 0x5cf659                            # 0046e004
    call FUN_004c5377                            # 0046e009
L_0046e00e:
    # block 0x0046e00e: entered by jne at 0x0046dfae, 2 instruction(s), ends with je to 0x0046e03d (forward)
    cmp dword ptr [0x62d15e], 0x0                # 0046e00e
    je.d8 L_0046e03d                             # 0046e015
    # block 0x0046e017: entered by fall-through of je at 0x0046e015, 9 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046e03d
    push 0x54be5c                                # 0046e017
    push 0x62d136                                # 0046e01c
    push 0x62d116                                # 0046e021
    mov edx, dword ptr [0x5cf665]                # 0046e026
    push edx                                     # 0046e02c
    mov eax, dword ptr [0x5d15e3]                # 0046e02d
    push eax                                     # 0046e032
    mov ecx, 0x5cf659                            # 0046e033
    call FUN_004c5d4b                            # 0046e038
L_0046e03d:
    # block 0x0046e03d: entered by je at 0x0046e015, 2 instruction(s), ends with je to 0x0046e0a6 (forward)
    cmp dword ptr [0x62d15a], 0x0                # 0046e03d
    je.d8 L_0046e0a6                             # 0046e044
    # block 0x0046e046: entered by fall-through of je at 0x0046e044, 2 instruction(s), ends with jne to 0x0046e0a6 (forward)
    cmp dword ptr [0x62d15e], 0x0                # 0046e046
    jne.d8 L_0046e0a6                            # 0046e04d
    # block 0x0046e04f: entered by fall-through of jne at 0x0046e04d, 19 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046e0a6
    push 0x54be90                                # 0046e04f
    push 0x62d136                                # 0046e054
    push 0x62d116                                # 0046e059
    mov ecx, dword ptr [0x5cf665]                # 0046e05e
    push ecx                                     # 0046e064
    mov edx, dword ptr [0x5d15e3]                # 0046e065
    push edx                                     # 0046e06b
    mov ecx, 0x5cf659                            # 0046e06c
    call FUN_004c5d4b                            # 0046e071
    push 0x54bec0                                # 0046e076
    push 0x62d146                                # 0046e07b
    push 0x62d126                                # 0046e080
    mov eax, dword ptr [0x5cf665]                # 0046e085
    push eax                                     # 0046e08a
    mov ecx, dword ptr [0x5d15e3]                # 0046e08b
    push ecx                                     # 0046e091
    mov ecx, 0x5cf659                            # 0046e092
    call FUN_004c5d4b                            # 0046e097
    mov dword ptr [0x62d15a], 0x0                # 0046e09c
L_0046e0a6:
    # block 0x0046e0a6: entered by je at 0x0046e044; jne at 0x0046e04d, 2 instruction(s), ends with forward jump to 0x0046e0b8
    mov dword ptr [ebp - local_8], 0x0           # 0046e0a6
    jmp.d8 L_0046e0b8                            # 0046e0ad
L_0046e0af:
    # block 0x0046e0af: entered by jmp at 0x0046e1ee, 3 instruction(s), falls into the block at 0x0046e0b8
    mov edx, dword ptr [ebp - local_8]           # 0046e0af
    add edx, 0x1                                 # 0046e0b2
    mov dword ptr [ebp - local_8], edx           # 0046e0b5
L_0046e0b8:
    # block 0x0046e0b8: entered by jmp at 0x0046e0ad, 4 instruction(s), ends with jge to 0x0046e1f3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e0b8
    movsx ecx, word ptr [eax + field_43]         # 0046e0bb
    cmp dword ptr [ebp - local_8], ecx           # 0046e0bf
    jge.d32 L_0046e1f3                           # 0046e0c2
    # block 0x0046e0c8: entered by fall-through of jge at 0x0046e0c2, 2 instruction(s), ends with forward jump to 0x0046e0da
    mov dword ptr [ebp - local_14], 0x0          # 0046e0c8
    jmp.d8 L_0046e0da                            # 0046e0cf
L_0046e0d1:
    # block 0x0046e0d1: entered by jmp at 0x0046e1e9, 3 instruction(s), falls into the block at 0x0046e0da
    mov edx, dword ptr [ebp - local_14]          # 0046e0d1
    add edx, 0x1                                 # 0046e0d4
    mov dword ptr [ebp - local_14], edx          # 0046e0d7
L_0046e0da:
    # block 0x0046e0da: entered by jmp at 0x0046e0cf, 4 instruction(s), ends with jge to 0x0046e1ee (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e0da
    movsx ecx, word ptr [eax + field_45]         # 0046e0dd
    cmp dword ptr [ebp - local_14], ecx          # 0046e0e1
    jge.d32 L_0046e1ee                           # 0046e0e4
    # block 0x0046e0ea: entered by fall-through of jge at 0x0046e0e4, 2 instruction(s), ends with forward jump to 0x0046e0fc
    mov dword ptr [ebp - local_18], 0x0          # 0046e0ea
    jmp.d8 L_0046e0fc                            # 0046e0f1
L_0046e0f3:
    # block 0x0046e0f3: entered by jmp at 0x0046e1e4, 3 instruction(s), falls into the block at 0x0046e0fc
    mov edx, dword ptr [ebp - local_18]          # 0046e0f3
    add edx, 0x1                                 # 0046e0f6
    mov dword ptr [ebp - local_18], edx          # 0046e0f9
L_0046e0fc:
    # block 0x0046e0fc: entered by jmp at 0x0046e0f1, 4 instruction(s), ends with jge to 0x0046e1e9 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e0fc
    movsx ecx, word ptr [eax + field_4f]         # 0046e0ff
    cmp dword ptr [ebp - local_18], ecx          # 0046e103
    jge.d32 L_0046e1e9                           # 0046e106
    # block 0x0046e10c: entered by fall-through of jge at 0x0046e106, 4 instruction(s), ends with jne to 0x0046e1e4 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0046e10c
    shl edx, 0x4                                 # 0046e10f
    cmp dword ptr [edx + 0x62cfd2], 0x1          # 0046e112
    jne.d32 L_0046e1e4                           # 0046e119
    # block 0x0046e11f: entered by fall-through of jne at 0x0046e119, 5 instruction(s), ends with jne to 0x0046e187 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0046e11f
    shl eax, 0x4                                 # 0046e122
    movsx ecx, word ptr [eax + 0x62cfda]         # 0046e125
    cmp ecx, dword ptr [ebp - local_8]           # 0046e12c
    jne.d8 L_0046e187                            # 0046e12f
    # block 0x0046e131: entered by fall-through of jne at 0x0046e12f, 5 instruction(s), ends with jne to 0x0046e187 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0046e131
    shl edx, 0x4                                 # 0046e134
    movsx eax, word ptr [edx + 0x62cfdc]         # 0046e137
    cmp eax, dword ptr [ebp - local_14]          # 0046e13e
    jne.d8 L_0046e187                            # 0046e141
    # block 0x0046e143: entered by fall-through of jne at 0x0046e141, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0046e1e4
    push 0x54bef0                                # 0046e143
    mov ecx, dword ptr [ebp - local_8]           # 0046e148
    imul ecx, ecx, 0x140                         # 0046e14b
    mov edx, dword ptr [ebp - local_14]          # 0046e151
    shl edx, 0x4                                 # 0046e154
    lea eax, [ecx + edx + 0x62a052]              # 0046e157
    push eax                                     # 0046e15e
    mov ecx, dword ptr [ebp - local_18]          # 0046e15f
    shl ecx, 0x4                                 # 0046e162
    mov edx, dword ptr [ebp - local_c]           # 0046e165
    lea eax, [edx + ecx + field_69]              # 0046e168
    push eax                                     # 0046e16c
    mov ecx, dword ptr [0x5cf665]                # 0046e16d
    push ecx                                     # 0046e173
    mov edx, dword ptr [0x62d172]                # 0046e174
    push edx                                     # 0046e17a
    mov ecx, 0x5cf659                            # 0046e17b
    call FUN_004c5d4b                            # 0046e180
    jmp.d8 L_0046e1e4                            # 0046e185
L_0046e187:
    # block 0x0046e187: entered by jne at 0x0046e12f; jne at 0x0046e141, 2 instruction(s), ends with je to 0x0046e1e4 (forward)
    cmp dword ptr [0x62d156], 0x0                # 0046e187
    je.d8 L_0046e1e4                             # 0046e18e
    # block 0x0046e190: entered by fall-through of je at 0x0046e18e, 20 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046e1e4
    push 0x54bf10                                # 0046e190
    mov eax, dword ptr [ebp - local_8]           # 0046e195
    imul eax, eax, 0x140                         # 0046e198
    mov ecx, dword ptr [ebp - local_14]          # 0046e19e
    shl ecx, 0x4                                 # 0046e1a1
    lea edx, [eax + ecx + 0x62a052]              # 0046e1a4
    push edx                                     # 0046e1ab
    mov eax, dword ptr [ebp - local_8]           # 0046e1ac
    imul eax, eax, 0x140                         # 0046e1af
    mov ecx, dword ptr [ebp - local_14]          # 0046e1b5
    shl ecx, 0x4                                 # 0046e1b8
    lea edx, [eax + ecx + 0x628752]              # 0046e1bb
    push edx                                     # 0046e1c2
    mov eax, dword ptr [0x5cf665]                # 0046e1c3
    push eax                                     # 0046e1c8
    mov ecx, dword ptr [0x5d15e3]                # 0046e1c9
    push ecx                                     # 0046e1cf
    mov ecx, 0x5cf659                            # 0046e1d0
    call FUN_004c5d4b                            # 0046e1d5
    mov dword ptr [0x62d156], 0x0                # 0046e1da
L_0046e1e4:
    # block 0x0046e1e4: entered by jne at 0x0046e119; jmp at 0x0046e185; je at 0x0046e18e, 1 instruction(s), ends with backward jump to 0x0046e0f3
    jmp.d32 L_0046e0f3                           # 0046e1e4
L_0046e1e9:
    # block 0x0046e1e9: entered by jge at 0x0046e106, 1 instruction(s), ends with backward jump to 0x0046e0d1
    jmp.d32 L_0046e0d1                           # 0046e1e9
L_0046e1ee:
    # block 0x0046e1ee: entered by jge at 0x0046e0e4, 1 instruction(s), ends with backward jump to 0x0046e0af
    jmp.d32 L_0046e0af                           # 0046e1ee
L_0046e1f3:
    # block 0x0046e1f3: entered by jge at 0x0046e0c2, 2 instruction(s), ends with forward jump to 0x0046e205
    mov dword ptr [ebp - local_8], 0x0           # 0046e1f3
    jmp.d8 L_0046e205                            # 0046e1fa
L_0046e1fc:
    # block 0x0046e1fc: entered by jmp at 0x0046e33e, 3 instruction(s), falls into the block at 0x0046e205
    mov edx, dword ptr [ebp - local_8]           # 0046e1fc
    add edx, 0x1                                 # 0046e1ff
    mov dword ptr [ebp - local_8], edx           # 0046e202
L_0046e205:
    # block 0x0046e205: entered by jmp at 0x0046e1fa, 4 instruction(s), ends with jge to 0x0046e343 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e205
    movsx ecx, word ptr [eax + field_47]         # 0046e208
    cmp dword ptr [ebp - local_8], ecx           # 0046e20c
    jge.d32 L_0046e343                           # 0046e20f
    # block 0x0046e215: entered by fall-through of jge at 0x0046e20f, 2 instruction(s), ends with forward jump to 0x0046e227
    mov dword ptr [ebp - local_14], 0x0          # 0046e215
    jmp.d8 L_0046e227                            # 0046e21c
L_0046e21e:
    # block 0x0046e21e: entered by jmp at 0x0046e339, 3 instruction(s), falls into the block at 0x0046e227
    mov edx, dword ptr [ebp - local_14]          # 0046e21e
    add edx, 0x1                                 # 0046e221
    mov dword ptr [ebp - local_14], edx          # 0046e224
L_0046e227:
    # block 0x0046e227: entered by jmp at 0x0046e21c, 4 instruction(s), ends with jge to 0x0046e33e (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e227
    movsx ecx, word ptr [eax + field_49]         # 0046e22a
    cmp dword ptr [ebp - local_14], ecx          # 0046e22e
    jge.d32 L_0046e33e                           # 0046e231
    # block 0x0046e237: entered by fall-through of jge at 0x0046e231, 2 instruction(s), ends with forward jump to 0x0046e249
    mov dword ptr [ebp - local_18], 0x0          # 0046e237
    jmp.d8 L_0046e249                            # 0046e23e
L_0046e240:
    # block 0x0046e240: entered by jmp at 0x0046e334, 3 instruction(s), falls into the block at 0x0046e249
    mov edx, dword ptr [ebp - local_18]          # 0046e240
    add edx, 0x1                                 # 0046e243
    mov dword ptr [ebp - local_18], edx          # 0046e246
L_0046e249:
    # block 0x0046e249: entered by jmp at 0x0046e23e, 4 instruction(s), ends with jge to 0x0046e339 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e249
    movsx ecx, word ptr [eax + field_4f]         # 0046e24c
    cmp dword ptr [ebp - local_18], ecx          # 0046e250
    jge.d32 L_0046e339                           # 0046e253
    # block 0x0046e259: entered by fall-through of jge at 0x0046e253, 4 instruction(s), ends with jne to 0x0046e334 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0046e259
    shl edx, 0x4                                 # 0046e25c
    cmp dword ptr [edx + 0x62cfd6], 0x1          # 0046e25f
    jne.d32 L_0046e334                           # 0046e266
    # block 0x0046e26c: entered by fall-through of jne at 0x0046e266, 5 instruction(s), ends with jne to 0x0046e2d7 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0046e26c
    shl eax, 0x4                                 # 0046e26f
    movsx ecx, word ptr [eax + 0x62cfde]         # 0046e272
    cmp ecx, dword ptr [ebp - local_8]           # 0046e279
    jne.d8 L_0046e2d7                            # 0046e27c
    # block 0x0046e27e: entered by fall-through of jne at 0x0046e27c, 5 instruction(s), ends with jne to 0x0046e2d7 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0046e27e
    shl edx, 0x4                                 # 0046e281
    movsx eax, word ptr [edx + 0x62cfe0]         # 0046e284
    cmp eax, dword ptr [ebp - local_14]          # 0046e28b
    jne.d8 L_0046e2d7                            # 0046e28e
    # block 0x0046e290: entered by fall-through of jne at 0x0046e28e, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0046e334
    push 0x54bf38                                # 0046e290
    mov ecx, dword ptr [ebp - local_8]           # 0046e295
    imul ecx, ecx, 0xa0                          # 0046e298
    mov edx, dword ptr [ebp - local_14]          # 0046e29e
    shl edx, 0x4                                 # 0046e2a1
    lea eax, [ecx + edx + 0x62bf92]              # 0046e2a4
    push eax                                     # 0046e2ab
    mov ecx, dword ptr [ebp - local_18]          # 0046e2ac
    shl ecx, 0x4                                 # 0046e2af
    mov edx, dword ptr [ebp - local_c]           # 0046e2b2
    lea eax, [edx + ecx + field_1a9]             # 0046e2b5
    push eax                                     # 0046e2bc
    mov ecx, dword ptr [0x5cf665]                # 0046e2bd
    push ecx                                     # 0046e2c3
    mov edx, dword ptr [0x62d176]                # 0046e2c4
    push edx                                     # 0046e2ca
    mov ecx, 0x5cf659                            # 0046e2cb
    call FUN_004c5d4b                            # 0046e2d0
    jmp.d8 L_0046e334                            # 0046e2d5
L_0046e2d7:
    # block 0x0046e2d7: entered by jne at 0x0046e27c; jne at 0x0046e28e, 2 instruction(s), ends with je to 0x0046e334 (forward)
    cmp dword ptr [0x62d156], 0x0                # 0046e2d7
    je.d8 L_0046e334                             # 0046e2de
    # block 0x0046e2e0: entered by fall-through of je at 0x0046e2de, 20 instruction(s), calls FUN_004c5377, falls into the block at 0x0046e334
    push 0x54bf58                                # 0046e2e0
    mov eax, dword ptr [ebp - local_8]           # 0046e2e5
    imul eax, eax, 0xa0                          # 0046e2e8
    mov ecx, dword ptr [ebp - local_14]          # 0046e2ee
    shl ecx, 0x4                                 # 0046e2f1
    lea edx, [eax + ecx + 0x62bf92]              # 0046e2f4
    push edx                                     # 0046e2fb
    mov eax, dword ptr [ebp - local_8]           # 0046e2fc
    imul eax, eax, 0xa0                          # 0046e2ff
    mov ecx, dword ptr [ebp - local_14]          # 0046e305
    shl ecx, 0x4                                 # 0046e308
    lea edx, [eax + ecx + 0x62b952]              # 0046e30b
    push edx                                     # 0046e312
    mov eax, dword ptr [0x5cf665]                # 0046e313
    push eax                                     # 0046e318
    mov ecx, dword ptr [0x5d15e3]                # 0046e319
    push ecx                                     # 0046e31f
    mov ecx, 0x5cf659                            # 0046e320
    call FUN_004c5377                            # 0046e325
    mov dword ptr [0x62d156], 0x0                # 0046e32a
L_0046e334:
    # block 0x0046e334: entered by jne at 0x0046e266; jmp at 0x0046e2d5; je at 0x0046e2de, 1 instruction(s), ends with backward jump to 0x0046e240
    jmp.d32 L_0046e240                           # 0046e334
L_0046e339:
    # block 0x0046e339: entered by jge at 0x0046e253, 1 instruction(s), ends with backward jump to 0x0046e21e
    jmp.d32 L_0046e21e                           # 0046e339
L_0046e33e:
    # block 0x0046e33e: entered by jge at 0x0046e231, 1 instruction(s), ends with backward jump to 0x0046e1fc
    jmp.d32 L_0046e1fc                           # 0046e33e
L_0046e343:
    # block 0x0046e343: entered by jge at 0x0046e20f, 5 instruction(s), ends with jne to 0x0046e50e (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046e343
    {load} xor eax, eax                          # 0046e346
    mov al, byte ptr [edx + field_429]           # 0046e348
    cmp eax, 0x1                                 # 0046e34e
    jne.d32 L_0046e50e                           # 0046e351
    # block 0x0046e357: entered by fall-through of jne at 0x0046e351, 2 instruction(s), ends with forward jump to 0x0046e369
    mov dword ptr [ebp - local_18], 0x0          # 0046e357
    jmp.d8 L_0046e369                            # 0046e35e
L_0046e360:
    # block 0x0046e360: entered by jmp at 0x0046e509, 3 instruction(s), falls into the block at 0x0046e369
    mov ecx, dword ptr [ebp - local_18]          # 0046e360
    add ecx, 0x1                                 # 0046e363
    mov dword ptr [ebp - local_18], ecx          # 0046e366
L_0046e369:
    # block 0x0046e369: entered by jmp at 0x0046e35e, 4 instruction(s), ends with jge to 0x0046e50e (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046e369
    movsx eax, word ptr [edx + field_4f]         # 0046e36c
    cmp dword ptr [ebp - local_18], eax          # 0046e370
    jge.d32 L_0046e50e                           # 0046e373
    # block 0x0046e379: entered by fall-through of jge at 0x0046e373, 22 instruction(s), ends with jne to 0x0046e47a (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0046e379
    mov edx, dword ptr [ebp - local_c]           # 0046e37c
    movsx eax, word ptr [edx + 2*ecx + field_47a] # 0046e37f
    shl eax                                      # 0046e387
    mov ecx, dword ptr [ebp - local_c]           # 0046e389
    movsx ecx, word ptr [ecx + field_4d]         # 0046e38c
    cdq                                          # 0046e390
    idiv ecx                                     # 0046e391
    mov dword ptr [ebp - local_10], eax          # 0046e393
    mov edx, dword ptr [ebp - local_18]          # 0046e396
    mov eax, dword ptr [ebp - local_c]           # 0046e399
    movsx eax, word ptr [eax + 2*edx + field_47a] # 0046e39c
    shl eax                                      # 0046e3a4
    mov ecx, dword ptr [ebp - local_c]           # 0046e3a6
    movsx ecx, word ptr [ecx + field_4d]         # 0046e3a9
    cdq                                          # 0046e3ad
    idiv ecx                                     # 0046e3ae
    mov dword ptr [ebp - local_4], edx           # 0046e3b0
    mov edx, dword ptr [ebp - local_18]          # 0046e3b3
    shl edx, 0x4                                 # 0046e3b6
    cmp dword ptr [edx + 0x62cfd2], 0x1          # 0046e3b9
    jne.d32 L_0046e47a                           # 0046e3c0
    # block 0x0046e3c6: entered by fall-through of jne at 0x0046e3c0, 46 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0046e509
    push 0x54bf80                                # 0046e3c6
    mov eax, dword ptr [ebp - local_10]          # 0046e3cb
    shl eax, 0x5                                 # 0046e3ce
    mov ecx, dword ptr [ebp - local_4]           # 0046e3d1
    shl ecx, 0x4                                 # 0046e3d4
    lea edx, [eax + ecx + 0x62cad2]              # 0046e3d7
    push edx                                     # 0046e3de
    mov eax, dword ptr [ebp - local_18]          # 0046e3df
    shl eax, 0x4                                 # 0046e3e2
    movsx ecx, word ptr [eax + 0x62cfdc]         # 0046e3e5
    mov edx, dword ptr [ebp - local_c]           # 0046e3ec
    movsx eax, word ptr [edx + 2*ecx + field_452] # 0046e3ef
    shl eax, 0x4                                 # 0046e3f7
    mov ecx, dword ptr [ebp - local_c]           # 0046e3fa
    lea edx, [ecx + eax + field_2e9]             # 0046e3fd
    push edx                                     # 0046e404
    mov eax, dword ptr [0x5cf665]                # 0046e405
    push eax                                     # 0046e40a
    mov ecx, dword ptr [0x62d172]                # 0046e40b
    push ecx                                     # 0046e411
    mov ecx, 0x5cf659                            # 0046e412
    call FUN_004c5d4b                            # 0046e417
    push 0x54bfac                                # 0046e41c
    mov edx, dword ptr [ebp - local_10]          # 0046e421
    shl edx, 0x5                                 # 0046e424
    mov eax, dword ptr [ebp - local_4]           # 0046e427
    add eax, 0x1                                 # 0046e42a
    shl eax, 0x4                                 # 0046e42d
    lea ecx, [edx + eax + 0x62cad2]              # 0046e430
    push ecx                                     # 0046e437
    mov edx, dword ptr [ebp - local_18]          # 0046e438
    shl edx, 0x4                                 # 0046e43b
    movsx eax, word ptr [edx + 0x62cfda]         # 0046e43e
    mov ecx, dword ptr [ebp - local_c]           # 0046e445
    movsx edx, word ptr [ecx + 2*eax + field_42a] # 0046e448
    shl edx, 0x4                                 # 0046e450
    mov eax, dword ptr [ebp - local_c]           # 0046e453
    lea ecx, [eax + edx + field_2e9]             # 0046e456
    push ecx                                     # 0046e45d
    mov edx, dword ptr [0x5cf665]                # 0046e45e
    push edx                                     # 0046e464
    mov eax, dword ptr [0x62d172]                # 0046e465
    push eax                                     # 0046e46a
    mov ecx, 0x5cf659                            # 0046e46b
    call FUN_004c5d4b                            # 0046e470
    jmp.d32 L_0046e509                           # 0046e475
L_0046e47a:
    # block 0x0046e47a: entered by jne at 0x0046e3c0, 40 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046e509
    push 0x54bfdc                                # 0046e47a
    mov ecx, dword ptr [ebp - local_10]          # 0046e47f
    shl ecx, 0x5                                 # 0046e482
    mov edx, dword ptr [ebp - local_4]           # 0046e485
    shl edx, 0x4                                 # 0046e488
    lea eax, [ecx + edx + 0x62cad2]              # 0046e48b
    push eax                                     # 0046e492
    mov ecx, dword ptr [ebp - local_10]          # 0046e493
    shl ecx, 0x5                                 # 0046e496
    mov edx, dword ptr [ebp - local_4]           # 0046e499
    shl edx, 0x4                                 # 0046e49c
    lea eax, [ecx + edx + 0x62c5d2]              # 0046e49f
    push eax                                     # 0046e4a6
    mov ecx, dword ptr [0x5cf665]                # 0046e4a7
    push ecx                                     # 0046e4ad
    mov edx, dword ptr [0x5d15e3]                # 0046e4ae
    push edx                                     # 0046e4b4
    mov ecx, 0x5cf659                            # 0046e4b5
    call FUN_004c5d4b                            # 0046e4ba
    push 0x54c00c                                # 0046e4bf
    mov eax, dword ptr [ebp - local_10]          # 0046e4c4
    shl eax, 0x5                                 # 0046e4c7
    mov ecx, dword ptr [ebp - local_4]           # 0046e4ca
    add ecx, 0x1                                 # 0046e4cd
    shl ecx, 0x4                                 # 0046e4d0
    lea edx, [eax + ecx + 0x62cad2]              # 0046e4d3
    push edx                                     # 0046e4da
    mov eax, dword ptr [ebp - local_10]          # 0046e4db
    shl eax, 0x5                                 # 0046e4de
    mov ecx, dword ptr [ebp - local_4]           # 0046e4e1
    add ecx, 0x1                                 # 0046e4e4
    shl ecx, 0x4                                 # 0046e4e7
    lea edx, [eax + ecx + 0x62c5d2]              # 0046e4ea
    push edx                                     # 0046e4f1
    mov eax, dword ptr [0x5cf665]                # 0046e4f2
    push eax                                     # 0046e4f7
    mov ecx, dword ptr [0x5d15e3]                # 0046e4f8
    push ecx                                     # 0046e4fe
    mov ecx, 0x5cf659                            # 0046e4ff
    call FUN_004c5d4b                            # 0046e504
L_0046e509:
    # block 0x0046e509: entered by jmp at 0x0046e475, 1 instruction(s), ends with backward jump to 0x0046e360
    jmp.d32 L_0046e360                           # 0046e509
L_0046e50e:
    # block 0x0046e50e: entered by jne at 0x0046e351; jge at 0x0046e373, 2 instruction(s), ends with je to 0x0046e54a (forward)
    cmp dword ptr [0x62d15e], 0x0                # 0046e50e
    je.d8 L_0046e54a                             # 0046e515
    # block 0x0046e517: entered by fall-through of je at 0x0046e515, 13 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0046e54a
    push 0x54c038                                # 0046e517
    push 0x62d146                                # 0046e51c
    movsx edx, word ptr [0x62d112]               # 0046e521
    shl edx, 0x4                                 # 0046e528
    mov eax, dword ptr [ebp - local_c]           # 0046e52b
    lea ecx, [eax + edx + field_69]              # 0046e52e
    push ecx                                     # 0046e532
    mov edx, dword ptr [0x5cf665]                # 0046e533
    push edx                                     # 0046e539
    mov eax, dword ptr [0x62d172]                # 0046e53a
    push eax                                     # 0046e53f
    mov ecx, 0x5cf659                            # 0046e540
    call FUN_004c5d4b                            # 0046e545
L_0046e54a:
    # block 0x0046e54a: entered by je at 0x0046e515, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046e54a
    pop ebp                                      # 0046e54c
    ret                                          # 0046e54d

# --- data items (not part of the function) -------------------------
.org 0x0046e54e - 0x401000
PAD_0046e54e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

