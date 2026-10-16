# FUN_005244f6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005244f6
# extent:       0x005244f6-0x00524565 (111 code bytes)
# span:         0x005244f6-0x00524565 (code 111, tables 0, padding 0)
# sha256:       69d37e4af1f5c059356e3d07511be77b797c3eab6798c4823bb265ff7c3b8d74
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005244f6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_e0, field_e4; [edx + n] field_c8; [esi + n] field_1c, field_90, field_94, field_a8, field_b8
# callees:      calls USER32.dll!UpdateWindow, FUN_00523edb; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00524565
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_a8, 0xa8  # offset +0xa8
.equ field_b8, 0xb8  # offset +0xb8
.equ field_c8, 0xc8  # offset +0xc8
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4

# --- external targets -----------------------------------------------
.set FUN_00523edb, .text + (0x00523edb - 0x401000)

.org 0x005244f6 - 0x401000
.globl FUN_005244f6
FUN_005244f6:
    # block 0x005244f6: entry, 4 instruction(s), ends with je to 0x00524510 (forward)
    push esi                                     # 005244f6
    {load} mov esi, ecx                          # 005244f7
    test byte ptr [esi + field_b8], 0x1          # 005244f9
    je.d8 L_00524510                             # 00524500
    # block 0x00524502: entered by fall-through of je at 0x00524500, 3 instruction(s), calls indirect dword ptr [eax + 0xe4], falls into the block at 0x00524510
    mov eax, dword ptr [esi]                     # 00524502
    push dword ptr [esi + field_a8]              # 00524504
    call dword ptr [eax + field_e4]              # 0052450a
L_00524510:
    # block 0x00524510: entered by je at 0x00524500, 2 instruction(s), ends with je to 0x00524525 (forward)
    test byte ptr [esi + field_b8], 0x2          # 00524510
    je.d8 L_00524525                             # 00524517
    # block 0x00524519: entered by fall-through of je at 0x00524517, 4 instruction(s), calls indirect dword ptr [eax + 0xe0], falls into the block at 0x00524525
    mov eax, dword ptr [esi]                     # 00524519
    push 0x1                                     # 0052451b
    {load} mov ecx, esi                          # 0052451d
    call dword ptr [eax + field_e0]              # 0052451f
L_00524525:
    # block 0x00524525: entered by je at 0x00524517, 3 instruction(s), ends with je to 0x00524546 (forward)
    mov eax, dword ptr [esi + field_b8]          # 00524525
    test al, 0x8                                 # 0052452b
    je.d8 L_00524546                             # 0052452d
    # block 0x0052452f: entered by fall-through of je at 0x0052452d, 7 instruction(s), calls indirect dword ptr [edx + 0xc8], USER32.dll!UpdateWindow, falls into the block at 0x00524546
    mov edx, dword ptr [esi]                     # 0052452f
    and eax, 0x4                                 # 00524531
    push eax                                     # 00524534
    {load} mov ecx, esi                          # 00524535
    call dword ptr [edx + field_c8]              # 00524537
    push dword ptr [esi + field_1c]              # 0052453d
    call dword ptr [0x52a49c]                    # 00524540
L_00524546:
    # block 0x00524546: entered by je at 0x0052452d, 3 instruction(s), ends with je to 0x0052455c (forward)
    mov eax, dword ptr [esi + field_90]          # 00524546
    cmp eax, dword ptr [esi + field_94]          # 0052454c
    je.d8 L_0052455c                             # 00524552
    # block 0x00524554: entered by fall-through of je at 0x00524552, 3 instruction(s), calls FUN_00523edb, falls into the block at 0x0052455c
    push eax                                     # 00524554
    {load} mov ecx, esi                          # 00524555
    call FUN_00523edb                            # 00524557
L_0052455c:
    # block 0x0052455c: entered by je at 0x00524552, 3 instruction(s), ends with ret
    and dword ptr [esi + field_b8], 0x0          # 0052455c
    pop esi                                      # 00524563
    ret                                          # 00524564

