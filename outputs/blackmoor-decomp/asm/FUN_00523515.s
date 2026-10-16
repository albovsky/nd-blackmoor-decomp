# FUN_00523515
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523515
# extent:       0x00523515-0x005235a3 (142 code bytes)
# span:         0x00523515-0x005235a3 (code 142, tables 0, padding 0)
# sha256:       aa216b676cd0809a69b0e9b97c1eaba665c23729b073a3cfc54884ffbddcddf2
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005233c8 (+0x14d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523515
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c, field_c0, field_f0; [edx + n] field_58, field_e4; [esi + n] field_1c, field_68; [esp + n] stk_10
# callees:      calls FUN_0051c72d, FUN_0051ec6f, FUN_0052398b, USER32.dll!PostMessageA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_58, 0x58  # offset +0x58
.equ field_68, 0x68  # offset +0x68
.equ field_c0, 0xc0  # offset +0xc0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_f0, 0xf0  # offset +0xf0

# --- external targets -----------------------------------------------
.set FUN_0051c72d, .text + (0x0051c72d - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_0052398b, .text + (0x0052398b - 0x401000)

.org 0x00523515 - 0x401000
.globl FUN_00523515
FUN_00523515:
    # block 0x00523515: entry, 13 instruction(s), calls FUN_0051c72d, indirect dword ptr [eax + 0xf0], ends with je to 0x00523552 (forward)
    push esi                                     # 00523515
    push edi                                     # 00523516
    push dword ptr [esp + stk_10]                # 00523517
    mov edi, dword ptr [esp + stk_10]            # 0052351b
    {load} mov esi, ecx                          # 0052351f
    push edi                                     # 00523521
    call FUN_0051c72d                            # 00523522
    mov eax, dword ptr [esi]                     # 00523527
    {load} mov ecx, esi                          # 00523529
    call dword ptr [eax + field_f0]              # 0052352b
    mov ecx, dword ptr [esi + field_68]          # 00523531
    test ecx, ecx                                # 00523534
    je.d8 L_00523552                             # 00523536
    # block 0x00523538: entered by fall-through of je at 0x00523536, 2 instruction(s), ends with je to 0x0052354a (forward)
    test di, di                                  # 00523538
    je.d8 L_0052354a                             # 0052353b
    # block 0x0052353d: entered by fall-through of je at 0x0052353b, 3 instruction(s), ends with jne to 0x0052354a (forward)
    shr edi, 0x10                                # 0052353d
    test di, di                                  # 00523540
    jne.d8 L_0052354a                            # 00523543
    # block 0x00523545: entered by fall-through of jne at 0x00523543, 3 instruction(s), ends with forward jump to 0x0052354c
    push 0x1                                     # 00523545
    pop eax                                      # 00523547
    jmp.d8 L_0052354c                            # 00523548
L_0052354a:
    # block 0x0052354a: entered by je at 0x0052353b; jne at 0x00523543, 1 instruction(s), falls into the block at 0x0052354c
    {load} xor eax, eax                          # 0052354a
L_0052354c:
    # block 0x0052354c: entered by jmp at 0x00523548, 3 instruction(s), calls indirect dword ptr [edx + 0x58], falls into the block at 0x00523552
    mov edx, dword ptr [ecx]                     # 0052354c
    push eax                                     # 0052354e
    call dword ptr [edx + field_58]              # 0052354f
L_00523552:
    # block 0x00523552: entered by je at 0x00523536, 3 instruction(s), calls FUN_0051ec6f, ends with jne to 0x0052358a (forward)
    call FUN_0051ec6f                            # 00523552
    cmp dword ptr [eax + field_1c], esi          # 00523557
    jne.d8 L_0052358a                            # 0052355a
    # block 0x0052355c: entered by fall-through of jne at 0x0052355a, 4 instruction(s), calls FUN_0052398b, ends with jne to 0x0052357c (forward)
    {load} mov ecx, esi                          # 0052355c
    call FUN_0052398b                            # 0052355e
    test eax, eax                                # 00523563
    jne.d8 L_0052357c                            # 00523565
    # block 0x00523567: entered by fall-through of jne at 0x00523565, 7 instruction(s), calls indirect dword ptr [eax + 0xc0], FUN_0052398b, ends with je to 0x0052358a (forward)
    mov eax, dword ptr [esi]                     # 00523567
    {load} mov ecx, esi                          # 00523569
    call dword ptr [eax + field_c0]              # 0052356b
    {load} mov ecx, eax                          # 00523571
    call FUN_0052398b                            # 00523573
    test eax, eax                                # 00523578
    je.d8 L_0052358a                             # 0052357a
L_0052357c:
    # block 0x0052357c: entered by jne at 0x00523565; fall-through of je at 0x0052357a, 6 instruction(s), calls indirect dword ptr [edx + 0xe4], falls into the block at 0x0052358a
    mov edx, dword ptr [eax]                     # 0052357c
    push eax                                     # 0052357e
    push eax                                     # 0052357f
    push 0x0                                     # 00523580
    {load} mov ecx, eax                          # 00523582
    call dword ptr [edx + field_e4]              # 00523584
L_0052358a:
    # block 0x0052358a: entered by jne at 0x0052355a; je at 0x0052357a, 9 instruction(s), calls USER32.dll!PostMessageA, ends with ret 0x8
    push 0x0                                     # 0052358a
    push 0x0                                     # 0052358c
    push 0x36a                                   # 0052358e
    push dword ptr [esi + field_1c]              # 00523593
    call dword ptr [0x52a31c]                    # 00523596
    pop edi                                      # 0052359c
    {load} xor eax, eax                          # 0052359d
    pop esi                                      # 0052359f
    ret 0x8                                      # 005235a0

