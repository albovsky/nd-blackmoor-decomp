# FUN_0051f482
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f482
# extent:       0x0051f482-0x0051f4ec (106 code bytes)
# span:         0x0051f482-0x0051f4ec (code 106, tables 0, padding 0)
# sha256:       0f533a2a258119f3e3857aba65f22468469671470f76b6fb1a63f0ca521dde59
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f482
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_10, field_14; [edx + n] field_88; [esi + n] field_80
# callees:      calls FUN_0051ef5c; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_80, 0x80  # offset +0x80
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_0051ef5c, .text + (0x0051ef5c - 0x401000)

.org 0x0051f482 - 0x401000
.globl FUN_0051f482
FUN_0051f482:
    # block 0x0051f482: entry, 8 instruction(s), ends with jg to 0x0051f4d1 (forward)
    push ebp                                     # 0051f482
    {load} mov ebp, esp                          # 0051f483
    push esi                                     # 0051f485
    push edi                                     # 0051f486
    mov edi, dword ptr [ebp + arg_8]             # 0051f487
    {load} mov esi, ecx                          # 0051f48a
    test edi, edi                                # 0051f48c
    jg.d8 L_0051f4d1                             # 0051f48e
    # block 0x0051f490: entered by fall-through of jg at 0x0051f48e, 6 instruction(s), calls FUN_0051ef5c, ends with je to 0x0051f4de (forward)
    push edi                                     # 0051f490
    call FUN_0051ef5c                            # 0051f491
    mov ecx, dword ptr [esi + field_80]          # 0051f496
    and dword ptr [ebp + arg_8], 0x0             # 0051f49c
    test ecx, ecx                                # 0051f4a0
    je.d8 L_0051f4de                             # 0051f4a2
    # block 0x0051f4a4: entered by fall-through of je at 0x0051f4a2, 5 instruction(s), calls indirect dword ptr [eax + 0x10], ends with je to 0x0051f4de (forward)
    mov eax, dword ptr [ecx]                     # 0051f4a4
    call dword ptr [eax + field_10]              # 0051f4a6
    test eax, eax                                # 0051f4a9
    mov dword ptr [ebp + arg_8], eax             # 0051f4ab
    je.d8 L_0051f4de                             # 0051f4ae
L_0051f4b0:
    # block 0x0051f4b0: entered by jne at 0x0051f4cd; fall-through of je at 0x0051f4ae, 10 instruction(s), calls indirect dword ptr [eax + 0x14], indirect dword ptr [edx + 0x88], ends with jne to 0x0051f4b0 (backward)
    mov ecx, dword ptr [esi + field_80]          # 0051f4b0
    lea edx, [ebp + arg_8]                       # 0051f4b6
    push edx                                     # 0051f4b9
    mov eax, dword ptr [ecx]                     # 0051f4ba
    call dword ptr [eax + field_14]              # 0051f4bc
    mov edx, dword ptr [eax]                     # 0051f4bf
    {load} mov ecx, eax                          # 0051f4c1
    call dword ptr [edx + field_88]              # 0051f4c3
    cmp dword ptr [ebp + arg_8], 0x0             # 0051f4c9
    jne.d8 L_0051f4b0                            # 0051f4cd
    # block 0x0051f4cf: entered by fall-through of jne at 0x0051f4cd, 1 instruction(s), ends with forward jump to 0x0051f4de
    jmp.d8 L_0051f4de                            # 0051f4cf
L_0051f4d1:
    # block 0x0051f4d1: entered by jg at 0x0051f48e, 2 instruction(s), ends with jne to 0x0051f4de (forward)
    cmp edi, 0x1                                 # 0051f4d1
    jne.d8 L_0051f4de                            # 0051f4d4
    # block 0x0051f4d6: entered by fall-through of jne at 0x0051f4d4, 3 instruction(s), calls FUN_0051ef5c, falls into the block at 0x0051f4de
    push edi                                     # 0051f4d6
    {load} mov ecx, esi                          # 0051f4d7
    call FUN_0051ef5c                            # 0051f4d9
L_0051f4de:
    # block 0x0051f4de: entered by je at 0x0051f4a2; je at 0x0051f4ae; jmp at 0x0051f4cf; jne at 0x0051f4d4, 7 instruction(s), ends with ret 0x4
    {load} xor eax, eax                          # 0051f4de
    cmp edi, 0x1                                 # 0051f4e0
    pop edi                                      # 0051f4e3
    pop esi                                      # 0051f4e4
    setl al                                      # 0051f4e5
    pop ebp                                      # 0051f4e8
    ret 0x4                                      # 0051f4e9

