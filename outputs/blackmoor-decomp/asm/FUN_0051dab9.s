# FUN_0051dab9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dab9
# extent:       0x0051dab9-0x0051db1b (98 code bytes)
# span:         0x0051dab9-0x0051db1b (code 98, tables 0, padding 0)
# sha256:       ce27ee7f48741b47794637af205595ae7b02f32c3d71a70648bb7f204dd22fb4
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dab9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_8, field_c, field_10, field_14; [esp + n] stk_c, stk_10
# callees:      calls USER32.dll!CheckMenuItem; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x0051dab9 - 0x401000
.globl FUN_0051dab9
FUN_0051dab9:
    # block 0x0051dab9: entry, 6 instruction(s), ends with je to 0x0051dae7 (forward)
    push esi                                     # 0051dab9
    {load} mov esi, ecx                          # 0051daba
    push edi                                     # 0051dabc
    mov eax, dword ptr [esi + field_c]           # 0051dabd
    test eax, eax                                # 0051dac0
    je.d8 L_0051dae7                             # 0051dac2
    # block 0x0051dac4: entered by fall-through of je at 0x0051dac2, 2 instruction(s), ends with jne to 0x0051db16 (forward)
    cmp dword ptr [esi + field_10], 0x0          # 0051dac4
    jne.d8 L_0051db16                            # 0051dac8
    # block 0x0051daca: entered by fall-through of jne at 0x0051dac8, 10 instruction(s), calls USER32.dll!CheckMenuItem, ends with forward jump to 0x0051db16
    mov ecx, dword ptr [esp + stk_c]             # 0051daca
    neg ecx                                      # 0051dace
    {load} sbb ecx, ecx                          # 0051dad0
    and ecx, 0x8                                 # 0051dad2
    or ch, 0x4                                   # 0051dad5
    push ecx                                     # 0051dad8
    push dword ptr [esi + field_8]               # 0051dad9
    push dword ptr [eax + field_4]               # 0051dadc
    call dword ptr [0x52a33c]                    # 0051dadf
    jmp.d8 L_0051db16                            # 0051dae5
L_0051dae7:
    # block 0x0051dae7: entered by je at 0x0051dac2, 9 instruction(s), calls indirect edi, ends with je to 0x0051db16 (forward)
    mov eax, dword ptr [esi + field_14]          # 0051dae7
    mov edi, dword ptr [0x52a4c8]                # 0051daea
    push 0x0                                     # 0051daf0
    push 0x0                                     # 0051daf2
    push 0x87                                    # 0051daf4
    push dword ptr [eax + field_1c]              # 0051daf9
    call edi                                     # 0051dafc
    test ah, 0x20                                # 0051dafe
    je.d8 L_0051db16                             # 0051db01
    # block 0x0051db03: entered by fall-through of je at 0x0051db01, 6 instruction(s), calls indirect edi, falls into the block at 0x0051db16
    mov eax, dword ptr [esi + field_14]          # 0051db03
    push 0x0                                     # 0051db06
    push dword ptr [esp + stk_10]                # 0051db08
    push 0xf1                                    # 0051db0c
    push dword ptr [eax + field_1c]              # 0051db11
    call edi                                     # 0051db14
L_0051db16:
    # block 0x0051db16: entered by jne at 0x0051dac8; jmp at 0x0051dae5; je at 0x0051db01, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051db16
    pop esi                                      # 0051db17
    ret 0x4                                      # 0051db18

