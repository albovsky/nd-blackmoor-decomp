# FUN_0051c3e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c3e5
# extent:       0x0051c3e5-0x0051c47f (154 code bytes)
# span:         0x0051c3e5-0x0051c47f (code 154, tables 0, padding 0)
# sha256:       483f09b2994e409cf1787e2ca1711170401cdb74129689ca3f96c3847307770a
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c3e5
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_8, local_10
# fields:       [esi + n] field_4, field_8, field_c
# callees:      calls USER32.dll!GetParent, USER32.dll!GetWindowRect, USER32.dll!EqualRect, USER32.dll!DeferWindowPos, USER32.dll!SetWindowPos; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 69 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0051c3e5 - 0x401000
.globl FUN_0051c3e5
FUN_0051c3e5:
    # block 0x0051c3e5: entry, 13 instruction(s), calls USER32.dll!GetParent, ends with je to 0x0051c407 (forward)
    push ebp                                     # 0051c3e5
    {load} mov ebp, esp                          # 0051c3e6
    sub esp, 0x10                                # 0051c3e8
    push ebx                                     # 0051c3eb
    mov ebx, dword ptr [ebp + arg_c]             # 0051c3ec
    push esi                                     # 0051c3ef
    push edi                                     # 0051c3f0
    push ebx                                     # 0051c3f1
    call dword ptr [0x52a3dc]                    # 0051c3f2
    mov edi, dword ptr [ebp + arg_8]             # 0051c3f8
    mov dword ptr [ebp + arg_c], eax             # 0051c3fb
    test edi, edi                                # 0051c3fe
    je.d8 L_0051c407                             # 0051c400
    # block 0x0051c402: entered by fall-through of je at 0x0051c400, 2 instruction(s), ends with je to 0x0051c478 (forward)
    cmp dword ptr [edi], 0x0                     # 0051c402
    je.d8 L_0051c478                             # 0051c405
L_0051c407:
    # block 0x0051c407: entered by je at 0x0051c400; fall-through of je at 0x0051c405, 20 instruction(s), calls USER32.dll!GetWindowRect, indirect esi, USER32.dll!EqualRect, ends with jne to 0x0051c478 (forward)
    lea eax, [ebp - local_10]                    # 0051c407
    push eax                                     # 0051c40a
    push ebx                                     # 0051c40b
    call dword ptr [0x52a46c]                    # 0051c40c
    mov esi, dword ptr [0x52a47c]                # 0051c412
    lea eax, [ebp - local_10]                    # 0051c418
    push eax                                     # 0051c41b
    push dword ptr [ebp + arg_c]                 # 0051c41c
    call esi                                     # 0051c41f
    lea eax, [ebp - local_8]                     # 0051c421
    push eax                                     # 0051c424
    push dword ptr [ebp + arg_c]                 # 0051c425
    call esi                                     # 0051c428
    mov esi, dword ptr [ebp + arg_10]            # 0051c42a
    lea eax, [ebp - local_10]                    # 0051c42d
    push esi                                     # 0051c430
    push eax                                     # 0051c431
    call dword ptr [0x52a4b0]                    # 0051c432
    test eax, eax                                # 0051c438
    jne.d8 L_0051c478                            # 0051c43a
    # block 0x0051c43c: entered by fall-through of jne at 0x0051c43a, 6 instruction(s), ends with je to 0x0051c464 (forward)
    mov eax, dword ptr [esi + field_4]           # 0051c43c
    mov ecx, dword ptr [esi]                     # 0051c43f
    mov edx, dword ptr [esi + field_c]           # 0051c441
    push 0x14                                    # 0051c444
    test edi, edi                                # 0051c446
    je.d8 L_0051c464                             # 0051c448
    # block 0x0051c44a: entered by fall-through of je at 0x0051c448, 13 instruction(s), calls USER32.dll!DeferWindowPos, ends with forward jump to 0x0051c478
    {load} sub edx, eax                          # 0051c44a
    push edx                                     # 0051c44c
    mov edx, dword ptr [esi + field_8]           # 0051c44d
    {load} sub edx, ecx                          # 0051c450
    push edx                                     # 0051c452
    push eax                                     # 0051c453
    push ecx                                     # 0051c454
    push 0x0                                     # 0051c455
    push ebx                                     # 0051c457
    push dword ptr [edi]                         # 0051c458
    call dword ptr [0x52a2f4]                    # 0051c45a
    mov dword ptr [edi], eax                     # 0051c460
    jmp.d8 L_0051c478                            # 0051c462
L_0051c464:
    # block 0x0051c464: entered by je at 0x0051c448, 10 instruction(s), calls USER32.dll!SetWindowPos, falls into the block at 0x0051c478
    {load} sub edx, eax                          # 0051c464
    push edx                                     # 0051c466
    mov edx, dword ptr [esi + field_8]           # 0051c467
    {load} sub edx, ecx                          # 0051c46a
    push edx                                     # 0051c46c
    push eax                                     # 0051c46d
    push ecx                                     # 0051c46e
    push 0x0                                     # 0051c46f
    push ebx                                     # 0051c471
    call dword ptr [0x52a45c]                    # 0051c472
L_0051c478:
    # block 0x0051c478: entered by je at 0x0051c405; jne at 0x0051c43a; jmp at 0x0051c462, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0051c478
    pop esi                                      # 0051c479
    pop ebx                                      # 0051c47a
    leave                                        # 0051c47b
    ret 0xc                                      # 0051c47c

