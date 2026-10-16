# FUN_005236ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005236ae
# extent:       0x005236ae-0x00523743 (149 code bytes)
# span:         0x005236ae-0x00523743 (code 149, tables 0, padding 0)
# sha256:       87dd2c2cb214a1582ee3234c6e11a377d2417105d7604017b1104bb5ac4ed15a
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005236ae
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50; [edi + n] field_1c; [esp + n] stk_c
# callees:      calls FUN_0051c174, FUN_0051ab4b; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)

.org 0x005236ae - 0x401000
.globl FUN_005236ae
FUN_005236ae:
    # block 0x005236ae: entry, 8 instruction(s), calls FUN_0051c174, ends with je to 0x00523737 (forward)
    push esi                                     # 005236ae
    push edi                                     # 005236af
    {load} mov edi, ecx                          # 005236b0
    call FUN_0051c174                            # 005236b2
    mov ecx, dword ptr [esp + stk_c]             # 005236b7
    and ecx, 0xfff0                              # 005236bb
    cmp dword ptr [eax + field_50], 0x0          # 005236c1
    je.d8 L_00523737                             # 005236c5
    # block 0x005236c7: entered by fall-through of je at 0x005236c5, 3 instruction(s), ends with ja to 0x005236e5 (forward)
    mov eax, 0xf040                              # 005236c7
    {load} cmp ecx, eax                          # 005236cc
    ja.d8 L_005236e5                             # 005236ce
    # block 0x005236d0: entered by fall-through of ja at 0x005236ce, 1 instruction(s), ends with je to 0x005236ff (forward)
    je.d8 L_005236ff                             # 005236d0
    # block 0x005236d2: entered by fall-through of je at 0x005236d0, 3 instruction(s), ends with je to 0x005236ff (forward)
    {load} mov eax, ecx                          # 005236d2
    sub eax, 0xf000                              # 005236d4
    je.d8 L_005236ff                             # 005236d9
    # block 0x005236db: entered by fall-through of je at 0x005236d9, 2 instruction(s), ends with je to 0x005236ff (forward)
    sub eax, 0x10                                # 005236db
    je.d8 L_005236ff                             # 005236de
    # block 0x005236e0: entered by fall-through of je at 0x005236de, 2 instruction(s), ends with forward jump to 0x005236f8
    sub eax, 0x10                                # 005236e0
    jmp.d8 L_005236f8                            # 005236e3
L_005236e5:
    # block 0x005236e5: entered by ja at 0x005236ce, 3 instruction(s), ends with je to 0x005236ff (forward)
    {load} mov eax, ecx                          # 005236e5
    sub eax, 0xf050                              # 005236e7
    je.d8 L_005236ff                             # 005236ec
    # block 0x005236ee: entered by fall-through of je at 0x005236ec, 2 instruction(s), ends with je to 0x005236ff (forward)
    sub eax, 0x10                                # 005236ee
    je.d8 L_005236ff                             # 005236f1
    # block 0x005236f3: entered by fall-through of je at 0x005236f1, 1 instruction(s), falls into the block at 0x005236f8
    sub eax, 0xc0                                # 005236f3
L_005236f8:
    # block 0x005236f8: entered by jmp at 0x005236e3, 1 instruction(s), ends with je to 0x005236ff (forward)
    je.d8 L_005236ff                             # 005236f8
    # block 0x005236fa: entered by fall-through of je at 0x005236f8, 2 instruction(s), ends with jne to 0x00523737 (forward)
    sub eax, 0x10                                # 005236fa
    jne.d8 L_00523737                            # 005236fd
L_005236ff:
    # block 0x005236ff: entered by je at 0x005236d0; je at 0x005236d9; je at 0x005236de; je at 0x005236ec; more, 11 instruction(s), calls indirect esi, ends with jne to 0x0052373e (forward)
    add ecx, 0xffff1000                          # 005236ff
    mov esi, dword ptr [0x52a4c8]                # 00523705
    shr ecx, 0x4                                 # 0052370b
    add ecx, 0x1ef00                             # 0052370e
    push ecx                                     # 00523714
    push 0x0                                     # 00523715
    push 0x365                                   # 00523717
    push dword ptr [edi + field_1c]              # 0052371c
    call esi                                     # 0052371f
    test eax, eax                                # 00523721
    jne.d8 L_0052373e                            # 00523723
    # block 0x00523725: entered by fall-through of jne at 0x00523723, 6 instruction(s), calls indirect esi, ends with forward jump to 0x0052373e
    push eax                                     # 00523725
    push 0xe147                                  # 00523726
    push 0x111                                   # 0052372b
    push dword ptr [edi + field_1c]              # 00523730
    call esi                                     # 00523733
    jmp.d8 L_0052373e                            # 00523735
L_00523737:
    # block 0x00523737: entered by je at 0x005236c5; jne at 0x005236fd, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0052373e
    {load} mov ecx, edi                          # 00523737
    call FUN_0051ab4b                            # 00523739
L_0052373e:
    # block 0x0052373e: entered by jne at 0x00523723; jmp at 0x00523735, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0052373e
    pop esi                                      # 0052373f
    ret 0x8                                      # 00523740

