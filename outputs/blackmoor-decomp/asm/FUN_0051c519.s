# FUN_0051c519
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c519
# extent:       0x0051c519-0x0051c5bd (164 code bytes)
# span:         0x0051c519-0x0051c5bd (code 164, tables 0, padding 0)
# sha256:       ed7d2d1f78582715ad0e415f88605816f3611c98b1e912d584c4768603c93f1c
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c519
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_20, field_34; [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10, field_minus_2c, field_minus_48
# callees:      calls FUN_0050f978, FUN_0051ab72, FUN_0051a57e, USER32.dll!GetParent, FUN_0051a801, FUN_0051c4ec, FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_2c, 0x2c  # offset -0x2c
.equ field_minus_48, 0x48  # offset -0x48
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051a801, .text + (0x0051a801 - 0x401000)
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)

.org 0x0051c519 - 0x401000
.globl FUN_0051c519
FUN_0051c519:
    # block 0x0051c519: entry, 9 instruction(s), calls FUN_0050f978, FUN_0051ab72, ends with je to 0x0051c59f (forward)
    mov eax, 0x528bcc                            # 0051c519
    call FUN_0050f978                            # 0051c51e
    sub esp, 0x3c                                # 0051c523
    push esi                                     # 0051c526
    push edi                                     # 0051c527
    push 0x0                                     # 0051c528
    call FUN_0051ab72                            # 0051c52a
    test eax, eax                                # 0051c52f
    je.d8 L_0051c59f                             # 0051c531
    # block 0x0051c533: entered by fall-through of je at 0x0051c531, 7 instruction(s), calls FUN_0051a57e, ends with jne to 0x0051c5a3 (forward)
    mov edi, dword ptr [ebp + field_8]           # 0051c533
    lea esi, [eax + field_4]                     # 0051c536
    push edi                                     # 0051c539
    {load} mov ecx, esi                          # 0051c53a
    call FUN_0051a57e                            # 0051c53c
    test eax, eax                                # 0051c541
    jne.d8 L_0051c5a3                            # 0051c543
    # block 0x0051c545: entered by fall-through of jne at 0x0051c543, 7 instruction(s), calls USER32.dll!GetParent, FUN_0051a57e, ends with je to 0x0051c59f (forward)
    push edi                                     # 0051c545
    call dword ptr [0x52a3dc]                    # 0051c546
    push eax                                     # 0051c54c
    {load} mov ecx, esi                          # 0051c54d
    call FUN_0051a57e                            # 0051c54f
    test eax, eax                                # 0051c554
    je.d8 L_0051c59f                             # 0051c556
    # block 0x0051c558: entered by fall-through of je at 0x0051c556, 3 instruction(s), ends with je to 0x0051c59f (forward)
    mov eax, dword ptr [eax + field_34]          # 0051c558
    test eax, eax                                # 0051c55b
    je.d8 L_0051c59f                             # 0051c55d
    # block 0x0051c55f: entered by fall-through of je at 0x0051c55d, 6 instruction(s), calls FUN_0051a57e, ends with je to 0x0051c59f (forward)
    push edi                                     # 0051c55f
    lea ecx, [eax + field_20]                    # 0051c560
    call FUN_0051a57e                            # 0051c563
    {load} mov esi, eax                          # 0051c568
    test esi, esi                                # 0051c56a
    je.d8 L_0051c59f                             # 0051c56c
    # block 0x0051c56e: entered by fall-through of je at 0x0051c56c, 15 instruction(s), calls FUN_0051a801, FUN_0051c4ec, FUN_0051b257, ends with forward jump to 0x0051c5ad
    push edi                                     # 0051c56e
    lea ecx, [ebp - field_minus_48]              # 0051c56f
    call FUN_0051a801                            # 0051c572
    push dword ptr [ebp + field_c]               # 0051c577
    and dword ptr [ebp - field_minus_4], 0x0     # 0051c57a
    lea ecx, [ebp - field_minus_48]              # 0051c57e
    mov dword ptr [ebp - field_minus_10], esi    # 0051c581
    call FUN_0051c4ec                            # 0051c584
    and dword ptr [ebp - field_minus_2c], 0x0    # 0051c589
    or dword ptr [ebp - field_minus_4], -0x1     # 0051c58d
    lea ecx, [ebp - field_minus_48]              # 0051c591
    {load} mov esi, eax                          # 0051c594
    call FUN_0051b257                            # 0051c596
    {load} mov eax, esi                          # 0051c59b
    jmp.d8 L_0051c5ad                            # 0051c59d
L_0051c59f:
    # block 0x0051c59f: entered by je at 0x0051c531; je at 0x0051c556; je at 0x0051c55d; je at 0x0051c56c, 2 instruction(s), ends with forward jump to 0x0051c5ad
    {load} xor eax, eax                          # 0051c59f
    jmp.d8 L_0051c5ad                            # 0051c5a1
L_0051c5a3:
    # block 0x0051c5a3: entered by jne at 0x0051c543, 3 instruction(s), calls FUN_0051c4ec, falls into the block at 0x0051c5ad
    push dword ptr [ebp + field_c]               # 0051c5a3
    {load} mov ecx, eax                          # 0051c5a6
    call FUN_0051c4ec                            # 0051c5a8
L_0051c5ad:
    # block 0x0051c5ad: entered by jmp at 0x0051c59d; jmp at 0x0051c5a1, 6 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051c5ad
    pop edi                                      # 0051c5b0
    pop esi                                      # 0051c5b1
    mov dword ptr fs:[0x0], ecx                  # 0051c5b2
    leave                                        # 0051c5b9
    ret 0x8                                      # 0051c5ba

