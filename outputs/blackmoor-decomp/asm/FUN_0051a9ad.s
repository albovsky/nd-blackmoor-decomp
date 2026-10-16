# FUN_0051a9ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a9ad
# extent:       0x0051a9ad-0x0051aa23 (118 code bytes)
# span:         0x0051a9ad-0x0051aa23 (code 118, tables 0, padding 0)
# sha256:       d72c49acff2d0dcbc0bde0bd0431d25b7ca2aab2fe747b0d68bbe54f48cce7c7
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a9ad
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1c; [esi + n] field_1c
# callees:      calls FUN_0051c14c, USER32.dll!GetLastActivePopup, FUN_0051abe4, USER32.dll!GetForegroundWindow, FUN_0051d657, USER32.dll!SetForegroundWindow
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)

.org 0x0051a9ad - 0x401000
.globl FUN_0051a9ad
FUN_0051a9ad:
    # block 0x0051a9ad: entry, 5 instruction(s), ends with jne to 0x0051aa1c (forward)
    push ebp                                     # 0051a9ad
    {load} mov ebp, esp                          # 0051a9ae
    cmp dword ptr [ebp + arg_c], -0x2            # 0051a9b0
    push esi                                     # 0051a9b4
    jne.d8 L_0051aa1c                            # 0051a9b5
    # block 0x0051a9b7: entered by fall-through of jne at 0x0051a9b5, 2 instruction(s), ends with je to 0x0051a9d2 (forward)
    cmp dword ptr [ebp + arg_10], 0x201          # 0051a9b7
    je.d8 L_0051a9d2                             # 0051a9be
    # block 0x0051a9c0: entered by fall-through of je at 0x0051a9be, 2 instruction(s), ends with je to 0x0051a9d2 (forward)
    cmp dword ptr [ebp + arg_10], 0x207          # 0051a9c0
    je.d8 L_0051a9d2                             # 0051a9c7
    # block 0x0051a9c9: entered by fall-through of je at 0x0051a9c7, 2 instruction(s), ends with jne to 0x0051aa1c (forward)
    cmp dword ptr [ebp + arg_10], 0x204          # 0051a9c9
    jne.d8 L_0051aa1c                            # 0051a9d0
L_0051a9d2:
    # block 0x0051a9d2: entered by je at 0x0051a9be; je at 0x0051a9c7; fall-through of jne at 0x0051a9d0, 4 instruction(s), calls FUN_0051c14c, ends with je to 0x0051aa1c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0051a9d2
    call FUN_0051c14c                            # 0051a9d5
    test eax, eax                                # 0051a9da
    je.d8 L_0051aa1c                             # 0051a9dc
    # block 0x0051a9de: entered by fall-through of je at 0x0051a9dc, 7 instruction(s), calls USER32.dll!GetLastActivePopup, FUN_0051abe4, ends with je to 0x0051aa1c (forward)
    push dword ptr [eax + field_1c]              # 0051a9de
    call dword ptr [0x52a444]                    # 0051a9e1
    push eax                                     # 0051a9e7
    call FUN_0051abe4                            # 0051a9e8
    {load} mov esi, eax                          # 0051a9ed
    test esi, esi                                # 0051a9ef
    je.d8 L_0051aa1c                             # 0051a9f1
    # block 0x0051a9f3: entered by fall-through of je at 0x0051a9f1, 5 instruction(s), calls USER32.dll!GetForegroundWindow, FUN_0051abe4, ends with je to 0x0051aa1c (forward)
    call dword ptr [0x52a448]                    # 0051a9f3
    push eax                                     # 0051a9f9
    call FUN_0051abe4                            # 0051a9fa
    {load} cmp esi, eax                          # 0051a9ff
    je.d8 L_0051aa1c                             # 0051aa01
    # block 0x0051aa03: entered by fall-through of je at 0x0051aa01, 4 instruction(s), calls FUN_0051d657, ends with je to 0x0051aa1c (forward)
    {load} mov ecx, esi                          # 0051aa03
    call FUN_0051d657                            # 0051aa05
    test eax, eax                                # 0051aa0a
    je.d8 L_0051aa1c                             # 0051aa0c
    # block 0x0051aa0e: entered by fall-through of je at 0x0051aa0c, 5 instruction(s), calls USER32.dll!SetForegroundWindow, ends with forward jump to 0x0051aa1e
    push dword ptr [esi + field_1c]              # 0051aa0e
    call dword ptr [0x52a44c]                    # 0051aa11
    push 0x1                                     # 0051aa17
    pop eax                                      # 0051aa19
    jmp.d8 L_0051aa1e                            # 0051aa1a
L_0051aa1c:
    # block 0x0051aa1c: entered by jne at 0x0051a9b5; jne at 0x0051a9d0; je at 0x0051a9dc; je at 0x0051a9f1; more, 1 instruction(s), falls into the block at 0x0051aa1e
    {load} xor eax, eax                          # 0051aa1c
L_0051aa1e:
    # block 0x0051aa1e: entered by jmp at 0x0051aa1a, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 0051aa1e
    pop ebp                                      # 0051aa1f
    ret 0xc                                      # 0051aa20

