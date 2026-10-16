# FUN_0051de51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051de51
# extent:       0x0051de51-0x0051dfda (393 code bytes)
# span:         0x0051de51-0x0051dfda (code 393, tables 0, padding 0)
# sha256:       300db9ea502b7f7b6727a88acfa50ad54c011c093e4f1cd9edf06320741c1e7c
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051de51
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_10, field_1c, field_b4, field_1038; [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_10, field_minus_14, field_minus_18, field_minus_1c, field_minus_20, field_minus_24, field_minus_28, field_minus_34 and 1 more; [esi + n] field_24, field_2c
# callees:      calls FUN_0050f978, FUN_00525371, FUN_0051d0b9, FUN_0051fd7e, USER32.dll!GetSystemMetrics, FUN_0050da98, FUN_0051fbcd, FUN_0051ff07, FUN_0051fc6a, FUN_0051fc5c, KERNEL32.dll!GlobalLock, FUN_0051b097, USER32.dll!CreateDialogIndirectParamA, FUN_0051e7ba, tail jump FUN_0051dff7; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 127 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28
.equ field_minus_34, 0x34  # offset -0x34
.equ field_minus_40, 0x40  # offset -0x40
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_b4, 0xb4  # offset +0xb4
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_0050da98, .text + (0x0050da98 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_0051d0b9, .text + (0x0051d0b9 - 0x401000)
.set FUN_0051dff7, .text + (0x0051dff7 - 0x401000)
.set LOC_0051e066, .text + (0x0051e066 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051fbcd, .text + (0x0051fbcd - 0x401000)
.set FUN_0051fc5c, .text + (0x0051fc5c - 0x401000)
.set FUN_0051fc6a, .text + (0x0051fc6a - 0x401000)
.set FUN_0051fd7e, .text + (0x0051fd7e - 0x401000)
.set FUN_0051ff07, .text + (0x0051ff07 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051de51 - 0x401000
.globl FUN_0051de51
FUN_0051de51:
    # block 0x0051de51: entry, 12 instruction(s), calls FUN_0050f978, ends with jne to 0x0051de7b (forward)
    mov eax, 0x528d40                            # 0051de51
    call FUN_0050f978                            # 0051de56
    sub esp, 0x34                                # 0051de5b
    push ebx                                     # 0051de5e
    push esi                                     # 0051de5f
    {load} xor ebx, ebx                          # 0051de60
    push edi                                     # 0051de62
    cmp dword ptr [ebp + field_10], ebx          # 0051de63
    {load} mov esi, ecx                          # 0051de66
    mov dword ptr [ebp - field_minus_10], esp    # 0051de68
    mov dword ptr [ebp - field_minus_24], esi    # 0051de6b
    jne.d8 L_0051de7b                            # 0051de6e
    # block 0x0051de70: entered by fall-through of jne at 0x0051de6e, 3 instruction(s), calls FUN_00525371, falls into the block at 0x0051de7b
    call FUN_00525371                            # 0051de70
    mov eax, dword ptr [eax + field_8]           # 0051de75
    mov dword ptr [ebp + field_10], eax          # 0051de78
L_0051de7b:
    # block 0x0051de7b: entered by jne at 0x0051de6e, 12 instruction(s), calls FUN_00525371, FUN_0051d0b9, ends with je to 0x0051dece (forward)
    call FUN_00525371                            # 0051de7b
    mov edi, dword ptr [eax + field_1038]        # 0051de80
    push 0x10                                    # 0051de86
    mov dword ptr [ebp - field_minus_28], edi    # 0051de88
    mov dword ptr [ebp - field_minus_14], ebx    # 0051de8b
    mov dword ptr [ebp - field_minus_18], ebx    # 0051de8e
    mov dword ptr [ebp - field_minus_4], ebx     # 0051de91
    call FUN_0051d0b9                            # 0051de94
    push 0x3c000                                 # 0051de99
    call FUN_0051d0b9                            # 0051de9e
    {load} cmp edi, ebx                          # 0051dea3
    je.d8 L_0051dece                             # 0051dea5
    # block 0x0051dea7: entered by fall-through of je at 0x0051dea5, 7 instruction(s), calls indirect dword ptr [eax + 0xb4], ends with je to 0x0051e066 (forward)
    mov eax, dword ptr [esi]                     # 0051dea7
    lea ecx, [ebp - field_minus_34]              # 0051dea9
    push ecx                                     # 0051deac
    {load} mov ecx, esi                          # 0051dead
    call dword ptr [eax + field_b4]              # 0051deaf
    {load} cmp eax, ebx                          # 0051deb5
    je.d32 LOC_0051e066                          # 0051deb7
    # block 0x0051debd: entered by fall-through of je at 0x0051deb7, 7 instruction(s), calls indirect dword ptr [eax + 0x10], falls into the block at 0x0051dece
    push dword ptr [ebp + field_8]               # 0051debd
    mov eax, dword ptr [edi]                     # 0051dec0
    lea ecx, [ebp - field_minus_34]              # 0051dec2
    push ecx                                     # 0051dec5
    {load} mov ecx, edi                          # 0051dec6
    call dword ptr [eax + field_10]              # 0051dec8
    mov dword ptr [ebp + field_8], eax           # 0051decb
L_0051dece:
    # block 0x0051dece: entered by je at 0x0051dea5, 2 instruction(s), ends with je to 0x0051e066 (forward)
    cmp dword ptr [ebp + field_8], ebx           # 0051dece
    je.d32 LOC_0051e066                          # 0051ded1
    # block 0x0051ded7: entered by fall-through of je at 0x0051ded1, 17 instruction(s), calls FUN_0051fd7e, ends with jne to 0x0051df59 (forward)
    mov eax, dword ptr [0x5679b0]                # 0051ded7
    mov dword ptr [ebp - field_minus_1c], eax    # 0051dedc
    lea eax, [ebp - field_minus_20]              # 0051dedf
    mov byte ptr [ebp - field_minus_4], 0x1      # 0051dee2
    push eax                                     # 0051dee6
    lea eax, [ebp - field_minus_1c]              # 0051dee7
    push eax                                     # 0051deea
    mov dword ptr [ebp - field_minus_20], ebx    # 0051deeb
    push dword ptr [ebp + field_8]               # 0051deee
    call FUN_0051fd7e                            # 0051def1
    add esp, 0xc                                 # 0051def6
    {load} xor ecx, ecx                          # 0051def9
    {load} cmp eax, ebx                          # 0051defb
    sete cl                                      # 0051defd
    {load} mov eax, ecx                          # 0051df00
    {load} cmp eax, ebx                          # 0051df02
    jne.d8 L_0051df59                            # 0051df04
    # block 0x0051df06: entered by fall-through of jne at 0x0051df04, 4 instruction(s), calls USER32.dll!GetSystemMetrics, ends with je to 0x0051df9b (forward)
    push 0x2a                                    # 0051df06
    call dword ptr [0x52a498]                    # 0051df08
    test eax, eax                                # 0051df0e
    je.d32 L_0051df9b                            # 0051df10
    # block 0x0051df16: entered by fall-through of je at 0x0051df10, 7 instruction(s), calls FUN_0050da98, ends with je to 0x0051df4f (forward)
    push 0x52f384                                # 0051df16
    push dword ptr [ebp - field_minus_1c]        # 0051df1b
    call FUN_0050da98                            # 0051df1e
    pop ecx                                      # 0051df23
    test eax, eax                                # 0051df24
    pop ecx                                      # 0051df26
    je.d8 L_0051df4f                             # 0051df27
    # block 0x0051df29: entered by fall-through of je at 0x0051df27, 7 instruction(s), calls FUN_0050da98, ends with je to 0x0051df4f (forward)
    push 0x52f374                                # 0051df29
    push dword ptr [ebp - field_minus_1c]        # 0051df2e
    call FUN_0050da98                            # 0051df31
    pop ecx                                      # 0051df36
    test eax, eax                                # 0051df37
    pop ecx                                      # 0051df39
    je.d8 L_0051df4f                             # 0051df3a
    # block 0x0051df3c: entered by fall-through of je at 0x0051df3a, 7 instruction(s), calls FUN_0050da98, ends with jne to 0x0051df9b (forward)
    push 0x52f36c                                # 0051df3c
    push dword ptr [ebp - field_minus_1c]        # 0051df41
    call FUN_0050da98                            # 0051df44
    pop ecx                                      # 0051df49
    test eax, eax                                # 0051df4a
    pop ecx                                      # 0051df4c
    jne.d8 L_0051df9b                            # 0051df4d
L_0051df4f:
    # block 0x0051df4f: entered by je at 0x0051df27; je at 0x0051df3a; fall-through of jne at 0x0051df4d, 2 instruction(s), ends with jne to 0x0051df59 (forward)
    cmp word ptr [ebp - field_minus_20], 0x8     # 0051df4f
    jne.d8 L_0051df59                            # 0051df54
    # block 0x0051df56: entered by fall-through of jne at 0x0051df54, 1 instruction(s), falls into the block at 0x0051df59
    mov dword ptr [ebp - field_minus_20], ebx    # 0051df56
L_0051df59:
    # block 0x0051df59: entered by jne at 0x0051df04; jne at 0x0051df54, 15 instruction(s), calls FUN_0051fbcd, FUN_0051ff07, FUN_0051fc6a, FUN_0051fc5c, ends with je to 0x0051df9b (forward)
    push dword ptr [ebp + field_8]               # 0051df59
    lea ecx, [ebp - field_minus_40]              # 0051df5c
    call FUN_0051fbcd                            # 0051df5f
    push dword ptr [ebp - field_minus_20]        # 0051df64
    lea ecx, [ebp - field_minus_40]              # 0051df67
    mov byte ptr [ebp - field_minus_4], 0x2      # 0051df6a
    call FUN_0051ff07                            # 0051df6e
    lea ecx, [ebp - field_minus_40]              # 0051df73
    call FUN_0051fc6a                            # 0051df76
    lea ecx, [ebp - field_minus_40]              # 0051df7b
    mov dword ptr [ebp - field_minus_14], eax    # 0051df7e
    mov byte ptr [ebp - field_minus_4], 0x1      # 0051df81
    call FUN_0051fc5c                            # 0051df85
    cmp dword ptr [ebp - field_minus_14], ebx    # 0051df8a
    je.d8 L_0051df9b                             # 0051df8d
    # block 0x0051df8f: entered by fall-through of je at 0x0051df8d, 3 instruction(s), calls KERNEL32.dll!GlobalLock, falls into the block at 0x0051df9b
    push dword ptr [ebp - field_minus_14]        # 0051df8f
    call dword ptr [0x52a204]                    # 0051df92
    mov dword ptr [ebp + field_8], eax           # 0051df98
L_0051df9b:
    # block 0x0051df9b: entered by je at 0x0051df10; jne at 0x0051df4d; je at 0x0051df8d, 7 instruction(s), calls FUN_0051b097, ends with jne to 0x0051dfb4 (forward)
    or dword ptr [esi + field_2c], -0x1          # 0051df9b
    or dword ptr [esi + field_24], 0x10          # 0051df9f
    push esi                                     # 0051dfa3
    call FUN_0051b097                            # 0051dfa4
    mov eax, dword ptr [ebp + field_c]           # 0051dfa9
    {load} cmp eax, ebx                          # 0051dfac
    jne.d8 L_0051dfb4                            # 0051dfae
    # block 0x0051dfb0: entered by fall-through of jne at 0x0051dfae, 2 instruction(s), ends with forward jump to 0x0051dfb7
    {load} xor eax, eax                          # 0051dfb0
    jmp.d8 L_0051dfb7                            # 0051dfb2
L_0051dfb4:
    # block 0x0051dfb4: entered by jne at 0x0051dfae, 1 instruction(s), falls into the block at 0x0051dfb7
    mov eax, dword ptr [eax + field_1c]          # 0051dfb4
L_0051dfb7:
    # block 0x0051dfb7: entered by jmp at 0x0051dfb2, 11 instruction(s), calls USER32.dll!CreateDialogIndirectParamA, FUN_0051e7ba, ends with forward jump to 0x0051dff7
    push ebx                                     # 0051dfb7
    push 0x51dc77                                # 0051dfb8
    push eax                                     # 0051dfbd
    push dword ptr [ebp + field_8]               # 0051dfbe
    push dword ptr [ebp + field_10]              # 0051dfc1
    call dword ptr [0x52a35c]                    # 0051dfc4
    lea ecx, [ebp - field_minus_1c]              # 0051dfca
    mov dword ptr [ebp - field_minus_18], eax    # 0051dfcd
    mov byte ptr [ebp - field_minus_4], bl       # 0051dfd0
    call FUN_0051e7ba                            # 0051dfd3
    jmp.d8 . + (31)  # -> FUN_0051dff7           # 0051dfd8

