# FUN_00523677
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523677
# extent:       0x00523677-0x005236ae (55 code bytes)
# span:         0x00523677-0x005236ae (code 55, tables 0, padding 0)
# sha256:       d3a2ebfe5c4e09057383638b3e69130f0f3f0b1843120cb512ab378f7f7a7576
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523677
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_a0; [esi + n] field_24; [esp + n] stk_c
# callees:      calls FUN_0051d657; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_24, 0x24  # offset +0x24
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)

.org 0x00523677 - 0x401000
.globl FUN_00523677
FUN_00523677:
    # block 0x00523677: entry, 5 instruction(s), ends with je to 0x00523686 (forward)
    push esi                                     # 00523677
    {load} mov esi, ecx                          # 00523678
    push edi                                     # 0052367a
    test byte ptr [esi + field_24], 0x20         # 0052367b
    je.d8 L_00523686                             # 0052367f
    # block 0x00523681: entered by fall-through of je at 0x0052367f, 3 instruction(s), ends with forward jump to 0x0052368a
    push 0x1                                     # 00523681
    pop edi                                      # 00523683
    jmp.d8 L_0052368a                            # 00523684
L_00523686:
    # block 0x00523686: entered by je at 0x0052367f, 1 instruction(s), falls into the block at 0x0052368a
    mov edi, dword ptr [esp + stk_c]             # 00523686
L_0052368a:
    # block 0x0052368a: entered by jmp at 0x00523684, 4 instruction(s), calls FUN_0051d657, ends with jne to 0x00523697 (forward)
    {load} mov ecx, esi                          # 0052368a
    call FUN_0051d657                            # 0052368c
    test eax, eax                                # 00523691
    jne.d8 L_00523697                            # 00523693
    # block 0x00523695: entered by fall-through of jne at 0x00523693, 1 instruction(s), falls into the block at 0x00523697
    {load} xor edi, edi                          # 00523695
L_00523697:
    # block 0x00523697: entered by jne at 0x00523693, 9 instruction(s), calls indirect dword ptr [eax + 0xa0], ends with ret 0x4
    mov eax, dword ptr [esi]                     # 00523697
    push 0x0                                     # 00523699
    push edi                                     # 0052369b
    push 0x86                                    # 0052369c
    {load} mov ecx, esi                          # 005236a1
    call dword ptr [eax + field_a0]              # 005236a3
    pop edi                                      # 005236a9
    pop esi                                      # 005236aa
    ret 0x4                                      # 005236ab

