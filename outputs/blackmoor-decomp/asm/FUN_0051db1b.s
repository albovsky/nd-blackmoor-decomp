# FUN_0051db1b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051db1b
# extent:       0x0051db1b-0x0051db71 (86 code bytes)
# span:         0x0051db1b-0x0051db71 (code 86, tables 0, padding 0)
# sha256:       d2a0ff909d07ea96dcbeb6ac09961e2d22f0a58eed874fc834bf4a9a05735e2b
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051db1b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_8, field_c, field_10; [esp + n] stk_c
# callees:      calls FUN_00524a01, USER32.dll!SetMenuItemBitmaps; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00524a01, .text + (0x00524a01 - 0x401000)

.org 0x0051db1b - 0x401000
.globl FUN_0051db1b
FUN_0051db1b:
    # block 0x0051db1b: entry, 13 instruction(s), calls indirect dword ptr [eax + 0x4], ends with je to 0x0051db6c (forward)
    push esi                                     # 0051db1b
    push edi                                     # 0051db1c
    {load} mov esi, ecx                          # 0051db1d
    {load} xor edi, edi                          # 0051db1f
    {load} xor ecx, ecx                          # 0051db21
    cmp dword ptr [esp + stk_c], edi             # 0051db23
    mov eax, dword ptr [esi]                     # 0051db27
    setne cl                                     # 0051db29
    push ecx                                     # 0051db2c
    {load} mov ecx, esi                          # 0051db2d
    call dword ptr [eax + field_4]               # 0051db2f
    cmp dword ptr [esi + field_c], edi           # 0051db32
    je.d8 L_0051db6c                             # 0051db35
    # block 0x0051db37: entered by fall-through of je at 0x0051db35, 2 instruction(s), ends with jne to 0x0051db6c (forward)
    cmp dword ptr [esi + field_10], edi          # 0051db37
    jne.d8 L_0051db6c                            # 0051db3a
    # block 0x0051db3c: entered by fall-through of jne at 0x0051db3a, 2 instruction(s), ends with jne to 0x0051db51 (forward)
    cmp dword ptr [0x63c798], edi                # 0051db3c
    jne.d8 L_0051db51                            # 0051db42
    # block 0x0051db44: entered by fall-through of jne at 0x0051db42, 3 instruction(s), calls FUN_00524a01, ends with je to 0x0051db6c (forward)
    call FUN_00524a01                            # 0051db44
    cmp dword ptr [0x63c798], edi                # 0051db49
    je.d8 L_0051db6c                             # 0051db4f
L_0051db51:
    # block 0x0051db51: entered by jne at 0x0051db42; fall-through of je at 0x0051db4f, 7 instruction(s), calls USER32.dll!SetMenuItemBitmaps, falls into the block at 0x0051db6c
    push dword ptr [0x63c798]                    # 0051db51
    mov eax, dword ptr [esi + field_c]           # 0051db57
    push edi                                     # 0051db5a
    push 0x400                                   # 0051db5b
    push dword ptr [esi + field_8]               # 0051db60
    push dword ptr [eax + field_4]               # 0051db63
    call dword ptr [0x52a340]                    # 0051db66
L_0051db6c:
    # block 0x0051db6c: entered by je at 0x0051db35; jne at 0x0051db3a; je at 0x0051db4f, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051db6c
    pop esi                                      # 0051db6d
    ret 0x4                                      # 0051db6e

