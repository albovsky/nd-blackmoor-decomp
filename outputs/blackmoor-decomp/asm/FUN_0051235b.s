# FUN_0051235b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051235b
# extent:       0x0051235b-0x00512437 (220 code bytes)
# span:         0x0051235b-0x00512437 (code 220, tables 0, padding 0)
# sha256:       fa1d03d9e718e814388c7efee0d806ed1efd1c9380b4ae08b57d5512fc82003a
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051235b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4; [esi + n] field_4, field_8, field_c, field_10, field_18; [esp + n] stk_8
# callees:      calls FUN_00516667, FUN_00512437
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 79 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00512437, .text + (0x00512437 - 0x401000)
.set FUN_00516667, .text + (0x00516667 - 0x401000)

.org 0x0051235b - 0x401000
.globl FUN_0051235b
FUN_0051235b:
    # block 0x0051235b: entry, 5 instruction(s), ends with je to 0x00512432 (forward)
    push esi                                     # 0051235b
    mov esi, dword ptr [esp + stk_8]             # 0051235c
    mov eax, dword ptr [esi + field_c]           # 00512360
    test al, -0x7d                               # 00512363
    je.d32 L_00512432                            # 00512365
    # block 0x0051236b: entered by fall-through of je at 0x00512365, 2 instruction(s), ends with jne to 0x00512432 (forward)
    test al, 0x40                                # 0051236b
    jne.d32 L_00512432                           # 0051236d
    # block 0x00512373: entered by fall-through of jne at 0x0051236d, 2 instruction(s), ends with je to 0x00512381 (forward)
    test al, 0x2                                 # 00512373
    je.d8 L_00512381                             # 00512375
    # block 0x00512377: entered by fall-through of je at 0x00512375, 3 instruction(s), ends with forward jump to 0x00512432
    or al, 0x20                                  # 00512377
    mov dword ptr [esi + field_c], eax           # 00512379
    jmp.d32 L_00512432                           # 0051237c
L_00512381:
    # block 0x00512381: entered by je at 0x00512375, 4 instruction(s), ends with jne to 0x00512395 (forward)
    or al, 0x1                                   # 00512381
    test ax, 0x10c                               # 00512383
    mov dword ptr [esi + field_c], eax           # 00512387
    jne.d8 L_00512395                            # 0051238a
    # block 0x0051238c: entered by fall-through of jne at 0x0051238a, 4 instruction(s), calls FUN_00516667, ends with forward jump to 0x0051239a
    push esi                                     # 0051238c
    call FUN_00516667                            # 0051238d
    pop ecx                                      # 00512392
    jmp.d8 L_0051239a                            # 00512393
L_00512395:
    # block 0x00512395: entered by jne at 0x0051238a, 2 instruction(s), falls into the block at 0x0051239a
    mov eax, dword ptr [esi + field_8]           # 00512395
    mov dword ptr [esi], eax                     # 00512398
L_0051239a:
    # block 0x0051239a: entered by jmp at 0x00512393, 8 instruction(s), calls FUN_00512437, ends with je to 0x00512421 (forward)
    push dword ptr [esi + field_18]              # 0051239a
    push dword ptr [esi + field_8]               # 0051239d
    push dword ptr [esi + field_10]              # 005123a0
    call FUN_00512437                            # 005123a3
    add esp, 0xc                                 # 005123a8
    mov dword ptr [esi + field_4], eax           # 005123ab
    test eax, eax                                # 005123ae
    je.d8 L_00512421                             # 005123b0
    # block 0x005123b2: entered by fall-through of je at 0x005123b0, 2 instruction(s), ends with je to 0x00512421 (forward)
    cmp eax, -0x1                                # 005123b2
    je.d8 L_00512421                             # 005123b5
    # block 0x005123b7: entered by fall-through of je at 0x005123b5, 3 instruction(s), ends with jne to 0x005123f6 (forward)
    mov edx, dword ptr [esi + field_c]           # 005123b7
    test dl, -0x7e                               # 005123ba
    jne.d8 L_005123f6                            # 005123bd
    # block 0x005123bf: entered by fall-through of jne at 0x005123bd, 4 instruction(s), ends with je to 0x005123df (forward)
    mov ecx, dword ptr [esi + field_10]          # 005123bf
    push edi                                     # 005123c2
    cmp ecx, -0x1                                # 005123c3
    je.d8 L_005123df                             # 005123c6
    # block 0x005123c8: entered by fall-through of je at 0x005123c6, 7 instruction(s), ends with forward jump to 0x005123e4
    {load} mov edi, ecx                          # 005123c8
    sar edi, 0x5                                 # 005123ca
    and ecx, 0x1f                                # 005123cd
    mov edi, dword ptr [4*edi + 0x63cde0]        # 005123d0
    lea ecx, [ecx + 8*ecx]                       # 005123d7
    lea edi, [edi + 4*ecx]                       # 005123da
    jmp.d8 L_005123e4                            # 005123dd
L_005123df:
    # block 0x005123df: entered by je at 0x005123c6, 1 instruction(s), falls into the block at 0x005123e4
    mov edi, 0x568880                            # 005123df
L_005123e4:
    # block 0x005123e4: entered by jmp at 0x005123dd, 5 instruction(s), ends with jne to 0x005123f6 (forward)
    mov cl, byte ptr [edi + field_4]             # 005123e4
    pop edi                                      # 005123e7
    and cl, -0x7e                                # 005123e8
    cmp cl, -0x7e                                # 005123eb
    jne.d8 L_005123f6                            # 005123ee
    # block 0x005123f0: entered by fall-through of jne at 0x005123ee, 2 instruction(s), falls into the block at 0x005123f6
    or dh, 0x20                                  # 005123f0
    mov dword ptr [esi + field_c], edx           # 005123f3
L_005123f6:
    # block 0x005123f6: entered by jne at 0x005123bd; jne at 0x005123ee, 2 instruction(s), ends with jne to 0x00512413 (forward)
    cmp dword ptr [esi + field_18], 0x200        # 005123f6
    jne.d8 L_00512413                            # 005123fd
    # block 0x005123ff: entered by fall-through of jne at 0x005123fd, 3 instruction(s), ends with je to 0x00512413 (forward)
    mov ecx, dword ptr [esi + field_c]           # 005123ff
    test cl, 0x8                                 # 00512402
    je.d8 L_00512413                             # 00512405
    # block 0x00512407: entered by fall-through of je at 0x00512405, 2 instruction(s), ends with jne to 0x00512413 (forward)
    test ch, 0x4                                 # 00512407
    jne.d8 L_00512413                            # 0051240a
    # block 0x0051240c: entered by fall-through of jne at 0x0051240a, 1 instruction(s), falls into the block at 0x00512413
    mov dword ptr [esi + field_18], 0x1000       # 0051240c
L_00512413:
    # block 0x00512413: entered by jne at 0x005123fd; je at 0x00512405; jne at 0x0051240a, 8 instruction(s), ends with ret
    mov ecx, dword ptr [esi]                     # 00512413
    dec eax                                      # 00512415
    mov dword ptr [esi + field_4], eax           # 00512416
    movzx eax, byte ptr [ecx]                    # 00512419
    inc ecx                                      # 0051241c
    mov dword ptr [esi], ecx                     # 0051241d
    pop esi                                      # 0051241f
    ret                                          # 00512420
L_00512421:
    # block 0x00512421: entered by je at 0x005123b0; je at 0x005123b5, 6 instruction(s), falls into the block at 0x00512432
    neg eax                                      # 00512421
    {load} sbb eax, eax                          # 00512423
    and eax, 0x10                                # 00512425
    add eax, 0x10                                # 00512428
    or dword ptr [esi + field_c], eax            # 0051242b
    and dword ptr [esi + field_4], 0x0           # 0051242e
L_00512432:
    # block 0x00512432: entered by je at 0x00512365; jne at 0x0051236d; jmp at 0x0051237c, 3 instruction(s), ends with ret
    or eax, -0x1                                 # 00512432
    pop esi                                      # 00512435
    ret                                          # 00512436

