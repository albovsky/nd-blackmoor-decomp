# FUN_0044a177
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a177
# extent:       0x0044a177-0x0044a2b7 (320 code bytes)
# span:         0x0044a177-0x0044a2b7 (code 320, tables 0, padding 0)
# sha256:       e6dc6dbc64120609b10c66a2c477186fc9fb23dc706e3ab2ec708798c5308fda
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a177
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_34, local_35, local_38, local_3c, local_40, local_44, local_45, local_46, local_4c, local_50
# fields:       [eax + n] field_1; [edx + n] field_1
# callees:      calls FUN_0050cd72, FUN_0044a116, FUN_0050d0a9, FUN_0050de76, FUN_0050de14, FUN_0050cb1b, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 102 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_34, 0x34  # offset -0x34
.equ local_35, 0x35  # offset -0x35
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_45, 0x45  # offset -0x45
.equ local_46, 0x46  # offset -0x46
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ field_1, 0x1  # offset +0x1

# --- external targets -----------------------------------------------
.set FUN_0044a116, .text + (0x0044a116 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050de14, .text + (0x0050de14 - 0x401000)
.set FUN_0050de76, .text + (0x0050de76 - 0x401000)

.org 0x0044a177 - 0x401000
.globl FUN_0044a177
FUN_0044a177:
    # block 0x0044a177: entry, 17 instruction(s), calls FUN_0050cd72, FUN_0044a116, ends with jne to 0x0044a1bc (forward)
    push ebp                                     # 0044a177
    {load} mov ebp, esp                          # 0044a178
    sub esp, 0x50                                # 0044a17a
    push edi                                     # 0044a17d
    push 0x548ab0                                # 0044a17e
    push 0x5b0172                                # 0044a183
    push 0x63a2c5                                # 0044a188
    push 0x639dab                                # 0044a18d
    push 0x63888b                                # 0044a192
    call FUN_0050cd72                            # 0044a197
    add esp, 0x14                                # 0044a19c
    push 0x639dab                                # 0044a19f
    call FUN_0044a116                            # 0044a1a4
    add esp, 0x4                                 # 0044a1a9
    and eax, 0xff                                # 0044a1ac
    test eax, eax                                # 0044a1b1
    jne.d8 L_0044a1bc                            # 0044a1b3
    # block 0x0044a1b5: entered by fall-through of jne at 0x0044a1b3, 2 instruction(s), ends with forward jump to 0x0044a2b2
    mov al, 0x64                                 # 0044a1b5
    jmp.d32 L_0044a2b2                           # 0044a1b7
L_0044a1bc:
    # block 0x0044a1bc: entered by jne at 0x0044a1b3, 7 instruction(s), calls FUN_0050d0a9, ends with jne to 0x0044a1de (forward)
    push 0x548ab8                                # 0044a1bc
    push 0x63888b                                # 0044a1c1
    call FUN_0050d0a9                            # 0044a1c6
    add esp, 0x8                                 # 0044a1cb
    mov dword ptr [ebp - local_38], eax          # 0044a1ce
    cmp dword ptr [ebp - local_38], 0x0          # 0044a1d1
    jne.d8 L_0044a1de                            # 0044a1d5
    # block 0x0044a1d7: entered by fall-through of jne at 0x0044a1d5, 2 instruction(s), ends with forward jump to 0x0044a2b2
    mov al, 0x64                                 # 0044a1d7
    jmp.d32 L_0044a2b2                           # 0044a1d9
L_0044a1de:
    # block 0x0044a1de: entered by jne at 0x0044a1d5, 40 instruction(s), calls FUN_0050de76, FUN_0050de14, FUN_0050cb1b, FUN_0050cee4, falls into the block at 0x0044a25a
    mov eax, dword ptr [ebp - local_38]          # 0044a1de
    push eax                                     # 0044a1e1
    call FUN_0050de76                            # 0044a1e2
    add esp, 0x4                                 # 0044a1e7
    mov ecx, dword ptr [ebp - local_38]          # 0044a1ea
    push ecx                                     # 0044a1ed
    push 0x5                                     # 0044a1ee
    push 0x63888b                                # 0044a1f0
    call FUN_0050de14                            # 0044a1f5
    add esp, 0xc                                 # 0044a1fa
    push 0x63888b                                # 0044a1fd
    call FUN_0050cb1b                            # 0044a202
    add esp, 0x4                                 # 0044a207
    mov byte ptr [ebp - local_3c], al            # 0044a20a
    mov ecx, 0xc                                 # 0044a20d
    {load} xor eax, eax                          # 0044a212
    lea edi, [ebp - local_34]                    # 0044a214
    rep stosd dword ptr es:[edi], eax            # 0044a217
    stosw word ptr es:[edi], ax                  # 0044a219
    mov edx, dword ptr [ebp - local_38]          # 0044a21b
    push edx                                     # 0044a21e
    push 0x31                                    # 0044a21f
    lea eax, [ebp - local_34]                    # 0044a221
    push eax                                     # 0044a224
    call FUN_0050de14                            # 0044a225
    add esp, 0xc                                 # 0044a22a
    lea edi, [ebp - local_34]                    # 0044a22d
    or ecx, -0x1                                 # 0044a230
    {load} xor eax, eax                          # 0044a233
    repne scasb al, byte ptr es:[edi]            # 0044a235
    not ecx                                      # 0044a237
    add ecx, -0x1                                # 0044a239
    mov byte ptr [ebp + ecx - local_35], 0x0     # 0044a23c
    mov ecx, dword ptr [ebp - local_38]          # 0044a241
    push ecx                                     # 0044a244
    call FUN_0050cee4                            # 0044a245
    add esp, 0x4                                 # 0044a24a
    mov dword ptr [ebp - local_40], 0x5b017c     # 0044a24d
    lea edx, [ebp - local_34]                    # 0044a254
    mov dword ptr [ebp - local_44], edx          # 0044a257
L_0044a25a:
    # block 0x0044a25a: entered by jne at 0x0044a28c, 6 instruction(s), ends with jne to 0x0044a297 (forward)
    mov eax, dword ptr [ebp - local_44]          # 0044a25a
    mov cl, byte ptr [eax]                       # 0044a25d
    mov byte ptr [ebp - local_45], cl            # 0044a25f
    mov edx, dword ptr [ebp - local_40]          # 0044a262
    cmp cl, byte ptr [edx]                       # 0044a265
    jne.d8 L_0044a297                            # 0044a267
    # block 0x0044a269: entered by fall-through of jne at 0x0044a267, 2 instruction(s), ends with je to 0x0044a28e (forward)
    cmp byte ptr [ebp - local_45], 0x0           # 0044a269
    je.d8 L_0044a28e                             # 0044a26d
    # block 0x0044a26f: entered by fall-through of je at 0x0044a26d, 6 instruction(s), ends with jne to 0x0044a297 (forward)
    mov eax, dword ptr [ebp - local_44]          # 0044a26f
    mov cl, byte ptr [eax + field_1]             # 0044a272
    mov byte ptr [ebp - local_46], cl            # 0044a275
    mov edx, dword ptr [ebp - local_40]          # 0044a278
    cmp cl, byte ptr [edx + field_1]             # 0044a27b
    jne.d8 L_0044a297                            # 0044a27e
    # block 0x0044a280: entered by fall-through of jne at 0x0044a27e, 4 instruction(s), ends with jne to 0x0044a25a (backward)
    add dword ptr [ebp - local_44], 0x2          # 0044a280
    add dword ptr [ebp - local_40], 0x2          # 0044a284
    cmp byte ptr [ebp - local_46], 0x0           # 0044a288
    jne.d8 L_0044a25a                            # 0044a28c
L_0044a28e:
    # block 0x0044a28e: entered by je at 0x0044a26d; fall-through of jne at 0x0044a28c, 2 instruction(s), ends with forward jump to 0x0044a29f
    mov dword ptr [ebp - local_4c], 0x0          # 0044a28e
    jmp.d8 L_0044a29f                            # 0044a295
L_0044a297:
    # block 0x0044a297: entered by jne at 0x0044a267; jne at 0x0044a27e, 3 instruction(s), falls into the block at 0x0044a29f
    {load} sbb eax, eax                          # 0044a297
    sbb eax, -0x1                                # 0044a299
    mov dword ptr [ebp - local_4c], eax          # 0044a29c
L_0044a29f:
    # block 0x0044a29f: entered by jmp at 0x0044a295, 4 instruction(s), ends with jne to 0x0044a2b0 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 0044a29f
    mov dword ptr [ebp - local_50], ecx          # 0044a2a2
    cmp dword ptr [ebp - local_50], 0x0          # 0044a2a5
    jne.d8 L_0044a2b0                            # 0044a2a9
    # block 0x0044a2ab: entered by fall-through of jne at 0x0044a2a9, 2 instruction(s), ends with forward jump to 0x0044a2b2
    mov al, byte ptr [ebp - local_3c]            # 0044a2ab
    jmp.d8 L_0044a2b2                            # 0044a2ae
L_0044a2b0:
    # block 0x0044a2b0: entered by jne at 0x0044a2a9, 1 instruction(s), falls into the block at 0x0044a2b2
    mov al, 0x64                                 # 0044a2b0
L_0044a2b2:
    # block 0x0044a2b2: entered by jmp at 0x0044a1b7; jmp at 0x0044a1d9; jmp at 0x0044a2ae, 4 instruction(s), ends with ret
    pop edi                                      # 0044a2b2
    {load} mov esp, ebp                          # 0044a2b3
    pop ebp                                      # 0044a2b5
    ret                                          # 0044a2b6

