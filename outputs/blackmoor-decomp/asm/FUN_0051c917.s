# FUN_0051c917
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c917
# extent:       0x0051c917-0x0051c941 (42 code bytes)
# span:         0x0051c917-0x0051c941 (code 42, tables 0, padding 0)
# sha256:       98dc35f373eee80af4e65dc67bd6185e5652dc6d1a19b8f0205e0b4f23457653
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c917
# arguments:    1 ebp-relative stack slot(s) referenced: arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4
# callees:      calls FUN_0051c519, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)

.org 0x0051c917 - 0x401000
.globl FUN_0051c917
FUN_0051c917:
    # block 0x0051c917: entry, 11 instruction(s), calls FUN_0051c519, ends with je to 0x0051c935 (forward)
    push ebp                                     # 0051c917
    {load} mov ebp, esp                          # 0051c918
    lea eax, [ebp + arg_c]                       # 0051c91a
    push esi                                     # 0051c91d
    push eax                                     # 0051c91e
    mov eax, dword ptr [ebp + arg_c]             # 0051c91f
    {load} mov esi, ecx                          # 0051c922
    push dword ptr [eax + field_4]               # 0051c924
    call FUN_0051c519                            # 0051c927
    test eax, eax                                # 0051c92c
    je.d8 L_0051c935                             # 0051c92e
    # block 0x0051c930: entered by fall-through of je at 0x0051c92e, 2 instruction(s), ends with forward jump to 0x0051c93c
    mov eax, dword ptr [ebp + arg_c]             # 0051c930
    jmp.d8 L_0051c93c                            # 0051c933
L_0051c935:
    # block 0x0051c935: entered by je at 0x0051c92e, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051c93c
    {load} mov ecx, esi                          # 0051c935
    call FUN_0051ab4b                            # 0051c937
L_0051c93c:
    # block 0x0051c93c: entered by jmp at 0x0051c933, 3 instruction(s), ends with ret 0x8
    pop esi                                      # 0051c93c
    pop ebp                                      # 0051c93d
    ret 0x8                                      # 0051c93e

