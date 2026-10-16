# FUN_0052299d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052299d
# extent:       0x0052299d-0x00522a14 (119 code bytes)
# span:         0x0052299d-0x00522a14 (code 119, tables 0, padding 0)
# sha256:       838ec8d55b9bdee5f8bf41d7a2f7936d039d5c4bb819ffd3802b921900672069
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522953 (+0x4a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052299d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_54, field_e8; [edi + n] field_4; [esi + n] field_1c, field_68; [esp + n] stk_c
# callees:      calls FUN_00521188, FUN_0051b4ac, USER32.dll!TranslateAcceleratorA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00522a14
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_54, 0x54  # offset +0x54
.equ field_68, 0x68  # offset +0x68
.equ field_e8, 0xe8  # offset +0xe8

# --- external targets -----------------------------------------------
.set FUN_0051b4ac, .text + (0x0051b4ac - 0x401000)
.set FUN_00521188, .text + (0x00521188 - 0x401000)

.org 0x0052299d - 0x401000
.globl FUN_0052299d
FUN_0052299d:
    # block 0x0052299d: entry, 7 instruction(s), ends with je to 0x005229b6 (forward)
    push esi                                     # 0052299d
    push edi                                     # 0052299e
    mov edi, dword ptr [esp + stk_c]             # 0052299f
    {load} mov esi, ecx                          # 005229a3
    mov eax, dword ptr [edi + field_4]           # 005229a5
    cmp eax, 0x201                               # 005229a8
    je.d8 L_005229b6                             # 005229ad
    # block 0x005229af: entered by fall-through of je at 0x005229ad, 2 instruction(s), ends with jne to 0x005229bd (forward)
    cmp eax, 0xa1                                # 005229af
    jne.d8 L_005229bd                            # 005229b4
L_005229b6:
    # block 0x005229b6: entered by je at 0x005229ad; fall-through of jne at 0x005229b4, 2 instruction(s), calls FUN_00521188, falls into the block at 0x005229bd
    push dword ptr [edi]                         # 005229b6
    call FUN_00521188                            # 005229b8
L_005229bd:
    # block 0x005229bd: entered by jne at 0x005229b4, 5 instruction(s), calls FUN_0051b4ac, ends with jne to 0x00522a08 (forward)
    push edi                                     # 005229bd
    {load} mov ecx, esi                          # 005229be
    call FUN_0051b4ac                            # 005229c0
    test eax, eax                                # 005229c5
    jne.d8 L_00522a08                            # 005229c7
    # block 0x005229c9: entered by fall-through of jne at 0x005229c7, 3 instruction(s), ends with je to 0x005229da (forward)
    mov ecx, dword ptr [esi + field_68]          # 005229c9
    test ecx, ecx                                # 005229cc
    je.d8 L_005229da                             # 005229ce
    # block 0x005229d0: entered by fall-through of je at 0x005229ce, 5 instruction(s), calls indirect dword ptr [eax + 0x54], ends with jne to 0x00522a08 (forward)
    mov eax, dword ptr [ecx]                     # 005229d0
    push edi                                     # 005229d2
    call dword ptr [eax + field_54]              # 005229d3
    test eax, eax                                # 005229d6
    jne.d8 L_00522a08                            # 005229d8
L_005229da:
    # block 0x005229da: entered by je at 0x005229ce; fall-through of jne at 0x005229d8, 3 instruction(s), ends with jb to 0x00522a0d (forward)
    mov eax, dword ptr [edi + field_4]           # 005229da
    cmp eax, 0x100                               # 005229dd
    jb.d8 L_00522a0d                             # 005229e2
    # block 0x005229e4: entered by fall-through of jb at 0x005229e2, 2 instruction(s), ends with ja to 0x00522a0d (forward)
    cmp eax, 0x108                               # 005229e4
    ja.d8 L_00522a0d                             # 005229e9
    # block 0x005229eb: entered by fall-through of ja at 0x005229e9, 5 instruction(s), calls indirect dword ptr [eax + 0xe8], ends with je to 0x00522a0d (forward)
    mov eax, dword ptr [esi]                     # 005229eb
    {load} mov ecx, esi                          # 005229ed
    call dword ptr [eax + field_e8]              # 005229ef
    test eax, eax                                # 005229f5
    je.d8 L_00522a0d                             # 005229f7
    # block 0x005229f9: entered by fall-through of je at 0x005229f7, 6 instruction(s), calls USER32.dll!TranslateAcceleratorA, ends with je to 0x00522a0d (forward)
    push edi                                     # 005229f9
    push eax                                     # 005229fa
    push dword ptr [esi + field_1c]              # 005229fb
    call dword ptr [0x52a37c]                    # 005229fe
    test eax, eax                                # 00522a04
    je.d8 L_00522a0d                             # 00522a06
L_00522a08:
    # block 0x00522a08: entered by jne at 0x005229c7; jne at 0x005229d8; fall-through of je at 0x00522a06, 3 instruction(s), ends with forward jump to 0x00522a0f
    push 0x1                                     # 00522a08
    pop eax                                      # 00522a0a
    jmp.d8 L_00522a0f                            # 00522a0b
L_00522a0d:
    # block 0x00522a0d: entered by jb at 0x005229e2; ja at 0x005229e9; je at 0x005229f7; je at 0x00522a06, 1 instruction(s), falls into the block at 0x00522a0f
    {load} xor eax, eax                          # 00522a0d
L_00522a0f:
    # block 0x00522a0f: entered by jmp at 0x00522a0b, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00522a0f
    pop esi                                      # 00522a10
    ret 0x4                                      # 00522a11

