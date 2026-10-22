# FUN_0051b461
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b461
# extent:       0x0051b461-0x0051b4a8 (71 code bytes)
# span:         0x0051b461-0x0051b4a8 (code 71, tables 0, padding 0)
# sha256:       ed97bf83161ef587988d0fe39da5ee1861f1e4b64d5284197633cce172f37634
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b461
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_80; [esi + n] field_1c, field_28
# callees:      calls USER32.dll!DefWindowProcA, USER32.dll!CallWindowProcA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0051b4a8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_28, 0x28  # offset +0x28
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x0051b461 - 0x401000
.globl FUN_0051b461
FUN_0051b461:
    # block 0x0051b461: entry, 7 instruction(s), ends with jne to 0x0051b490 (forward)
    push ebp                                     # 0051b461
    {load} mov ebp, esp                          # 0051b462
    push esi                                     # 0051b464
    {load} mov esi, ecx                          # 0051b465
    mov eax, dword ptr [esi + field_28]          # 0051b467
    test eax, eax                                # 0051b46a
    jne.d8 L_0051b490                            # 0051b46c
    # block 0x0051b46e: entered by fall-through of jne at 0x0051b46c, 5 instruction(s), calls indirect dword ptr [eax + 0x80], ends with jne to 0x0051b490 (forward)
    mov eax, dword ptr [esi]                     # 0051b46e
    call dword ptr [eax + field_80]              # 0051b470
    mov eax, dword ptr [eax]                     # 0051b476
    test eax, eax                                # 0051b478
    jne.d8 L_0051b490                            # 0051b47a
    # block 0x0051b47c: entered by fall-through of jne at 0x0051b47a, 6 instruction(s), calls USER32.dll!DefWindowProcA, ends with forward jump to 0x0051b4a3
    push dword ptr [ebp + arg_10]                # 0051b47c
    push dword ptr [ebp + arg_c]                 # 0051b47f
    push dword ptr [ebp + arg_8]                 # 0051b482
    push dword ptr [esi + field_1c]              # 0051b485
    call dword ptr [0x52a410]                    # 0051b488
    jmp.d8 L_0051b4a3                            # 0051b48e
L_0051b490:
    # block 0x0051b490: entered by jne at 0x0051b46c; jne at 0x0051b47a, 6 instruction(s), calls USER32.dll!CallWindowProcA, falls into the block at 0x0051b4a3
    push dword ptr [ebp + arg_10]                # 0051b490
    push dword ptr [ebp + arg_c]                 # 0051b493
    push dword ptr [ebp + arg_8]                 # 0051b496
    push dword ptr [esi + field_1c]              # 0051b499
    push eax                                     # 0051b49c
    call dword ptr [0x52a434]                    # 0051b49d
L_0051b4a3:
    # block 0x0051b4a3: entered by jmp at 0x0051b48e, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 0051b4a3
    pop ebp                                      # 0051b4a4
    ret 0xc                                      # 0051b4a5

