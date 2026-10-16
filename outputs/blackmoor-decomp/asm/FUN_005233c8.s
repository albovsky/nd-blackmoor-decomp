# FUN_005233c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005233c8
# extent:       0x005233c8-0x0052341b (83 code bytes)
# span:         0x005233c8-0x0052341b (code 83, tables 0, padding 0)
# sha256:       6efd506966ad4d72f7ae2b2f2196638eef47a3dfba011eb892afb6aee4064cc2
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005233c8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_1c, field_44
# callees:      calls FUN_00523ef2, USER32.dll!GetMenu, USER32.dll!SetMenu, FUN_00525371, USER32.dll!WinHelpA, FUN_0051b2d3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052341b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_44, 0x44  # offset +0x44

# --- external targets -----------------------------------------------
.set FUN_0051b2d3, .text + (0x0051b2d3 - 0x401000)
.set FUN_00523ef2, .text + (0x00523ef2 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x005233c8 - 0x401000
.globl FUN_005233c8
FUN_005233c8:
    # block 0x005233c8: entry, 6 instruction(s), calls FUN_00523ef2, ends with je to 0x005233f1 (forward)
    push esi                                     # 005233c8
    push edi                                     # 005233c9
    {load} mov esi, ecx                          # 005233ca
    call FUN_00523ef2                            # 005233cc
    cmp dword ptr [esi + field_44], 0x0          # 005233d1
    je.d8 L_005233f1                             # 005233d5
    # block 0x005233d7: entered by fall-through of je at 0x005233d5, 5 instruction(s), calls USER32.dll!GetMenu, ends with je to 0x005233f1 (forward)
    push dword ptr [esi + field_1c]              # 005233d7
    mov edi, dword ptr [esi + field_44]          # 005233da
    call dword ptr [0x52a3f4]                    # 005233dd
    {load} cmp eax, edi                          # 005233e3
    je.d8 L_005233f1                             # 005233e5
    # block 0x005233e7: entered by fall-through of je at 0x005233e5, 3 instruction(s), calls USER32.dll!SetMenu, falls into the block at 0x005233f1
    push edi                                     # 005233e7
    push dword ptr [esi + field_1c]              # 005233e8
    call dword ptr [0x52a390]                    # 005233eb
L_005233f1:
    # block 0x005233f1: entered by je at 0x005233d5; je at 0x005233e5, 4 instruction(s), calls FUN_00525371, ends with je to 0x00523411 (forward)
    call FUN_00525371                            # 005233f1
    mov eax, dword ptr [eax + field_4]           # 005233f6
    test eax, eax                                # 005233f9
    je.d8 L_00523411                             # 005233fb
    # block 0x005233fd: entered by fall-through of je at 0x005233fb, 2 instruction(s), ends with jne to 0x00523411 (forward)
    cmp dword ptr [eax + field_1c], esi          # 005233fd
    jne.d8 L_00523411                            # 00523400
    # block 0x00523402: entered by fall-through of jne at 0x00523400, 5 instruction(s), calls USER32.dll!WinHelpA, falls into the block at 0x00523411
    push 0x0                                     # 00523402
    push 0x2                                     # 00523404
    push 0x0                                     # 00523406
    push dword ptr [esi + field_1c]              # 00523408
    call dword ptr [0x52a3e4]                    # 0052340b
L_00523411:
    # block 0x00523411: entered by je at 0x005233fb; jne at 0x00523400, 5 instruction(s), calls FUN_0051b2d3, ends with ret
    {load} mov ecx, esi                          # 00523411
    call FUN_0051b2d3                            # 00523413
    pop edi                                      # 00523418
    pop esi                                      # 00523419
    ret                                          # 0052341a

