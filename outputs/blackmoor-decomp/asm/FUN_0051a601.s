# FUN_0051a601
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a601
# extent:       0x0051a601-0x0051a643 (66 code bytes)
# span:         0x0051a601-0x0051a643 (code 66, tables 0, padding 0)
# sha256:       1adc54a0e55a46a1f447e55d044230799d9b107e5f20dfd032b634f572353b6b
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a601
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_4, field_8; [esp + n] stk_c
# callees:      calls FUN_0051a533
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051a533, .text + (0x0051a533 - 0x401000)

.org 0x0051a601 - 0x401000
.globl FUN_0051a601
FUN_0051a601:
    # block 0x0051a601: entry, 5 instruction(s), ends with je to 0x0051a63c (forward)
    push esi                                     # 0051a601
    mov esi, dword ptr [ecx + field_4]           # 0051a602
    test esi, esi                                # 0051a605
    push edi                                     # 0051a607
    je.d8 L_0051a63c                             # 0051a608
    # block 0x0051a60a: entered by fall-through of je at 0x0051a608, 7 instruction(s), falls into the block at 0x0051a61e
    mov edi, dword ptr [esp + stk_c]             # 0051a60a
    {load} xor edx, edx                          # 0051a60e
    {load} mov eax, edi                          # 0051a610
    shr eax, 0x4                                 # 0051a612
    div dword ptr [ecx + field_8]                # 0051a615
    mov eax, dword ptr [esi + 4*edx]             # 0051a618
    lea edx, [esi + 4*edx]                       # 0051a61b
L_0051a61e:
    # block 0x0051a61e: entered by jmp at 0x0051a62b, 2 instruction(s), ends with je to 0x0051a63c (forward)
    test eax, eax                                # 0051a61e
    je.d8 L_0051a63c                             # 0051a620
    # block 0x0051a622: entered by fall-through of je at 0x0051a620, 2 instruction(s), ends with je to 0x0051a62d (forward)
    cmp dword ptr [eax + field_4], edi           # 0051a622
    je.d8 L_0051a62d                             # 0051a625
    # block 0x0051a627: entered by fall-through of je at 0x0051a625, 3 instruction(s), ends with backward jump to 0x0051a61e
    {load} mov edx, eax                          # 0051a627
    mov eax, dword ptr [eax]                     # 0051a629
    jmp.d8 L_0051a61e                            # 0051a62b
L_0051a62d:
    # block 0x0051a62d: entered by je at 0x0051a625, 7 instruction(s), calls FUN_0051a533, ends with forward jump to 0x0051a63e
    mov esi, dword ptr [eax]                     # 0051a62d
    push eax                                     # 0051a62f
    mov dword ptr [edx], esi                     # 0051a630
    call FUN_0051a533                            # 0051a632
    push 0x1                                     # 0051a637
    pop eax                                      # 0051a639
    jmp.d8 L_0051a63e                            # 0051a63a
L_0051a63c:
    # block 0x0051a63c: entered by je at 0x0051a608; je at 0x0051a620, 1 instruction(s), falls into the block at 0x0051a63e
    {load} xor eax, eax                          # 0051a63c
L_0051a63e:
    # block 0x0051a63e: entered by jmp at 0x0051a63a, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051a63e
    pop esi                                      # 0051a63f
    ret 0x4                                      # 0051a640

