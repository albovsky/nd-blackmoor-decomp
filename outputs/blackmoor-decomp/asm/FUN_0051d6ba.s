# FUN_0051d6ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d6ba
# extent:       0x0051d6ba-0x0051d6f7 (61 code bytes)
# span:         0x0051d6ba-0x0051d6f7 (code 61, tables 0, padding 0)
# sha256:       fb2c897e2917ad50d2ee28a1f8fc427ffe87313a5f762b8e8f981e1ccf3bb4a6
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d6ba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_34; [edx + n] field_8c; [esi + n] field_1c, field_38; [esp + n] stk_c
# callees:      calls USER32.dll!GetParent, FUN_0051a57e; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)

.org 0x0051d6ba - 0x401000
.globl FUN_0051d6ba
FUN_0051d6ba:
    # block 0x0051d6ba: entry, 4 instruction(s), ends with je to 0x0051d6f3 (forward)
    push esi                                     # 0051d6ba
    {load} mov esi, ecx                          # 0051d6bb
    test esi, esi                                # 0051d6bd
    je.d8 L_0051d6f3                             # 0051d6bf
    # block 0x0051d6c1: entered by fall-through of je at 0x0051d6bf, 2 instruction(s), ends with jne to 0x0051d6f3 (forward)
    cmp dword ptr [esi + field_38], 0x0          # 0051d6c1
    jne.d8 L_0051d6f3                            # 0051d6c5
    # block 0x0051d6c7: entered by fall-through of jne at 0x0051d6c5, 8 instruction(s), calls USER32.dll!GetParent, FUN_0051a57e, ends with je to 0x0051d6f3 (forward)
    push dword ptr [esi + field_1c]              # 0051d6c7
    call dword ptr [0x52a3dc]                    # 0051d6ca
    push eax                                     # 0051d6d0
    mov eax, dword ptr [esp + stk_c]             # 0051d6d1
    lea ecx, [eax + field_4]                     # 0051d6d5
    call FUN_0051a57e                            # 0051d6d8
    test eax, eax                                # 0051d6dd
    je.d8 L_0051d6f3                             # 0051d6df
    # block 0x0051d6e1: entered by fall-through of je at 0x0051d6df, 3 instruction(s), ends with je to 0x0051d6f3 (forward)
    mov eax, dword ptr [eax + field_34]          # 0051d6e1
    test eax, eax                                # 0051d6e4
    je.d8 L_0051d6f3                             # 0051d6e6
    # block 0x0051d6e8: entered by fall-through of je at 0x0051d6e6, 4 instruction(s), calls indirect dword ptr [edx + 0x8c], falls into the block at 0x0051d6f3
    mov edx, dword ptr [eax]                     # 0051d6e8
    push esi                                     # 0051d6ea
    {load} mov ecx, eax                          # 0051d6eb
    call dword ptr [edx + field_8c]              # 0051d6ed
L_0051d6f3:
    # block 0x0051d6f3: entered by je at 0x0051d6bf; jne at 0x0051d6c5; je at 0x0051d6df; je at 0x0051d6e6, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051d6f3
    ret 0x4                                      # 0051d6f4

