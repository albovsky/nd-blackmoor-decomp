# FUN_0051e2e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e2e7
# extent:       0x0051e2e7-0x0051e36f (136 code bytes)
# span:         0x0051e2e7-0x0051e36f (code 136, tables 0, padding 0)
# sha256:       ba4c992f26ccaf808dab581b69135dbc75f2446b6b004bacfa80cf690780c6e2
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e2e7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_cc, field_1038; [edi + n] field_1c; [edx + n] field_20; [esi + n] field_1c, field_25, field_40, field_4c, field_58
# callees:      calls FUN_00525371, FUN_0051e2a0, FUN_0051ab4b, USER32.dll!GetNextDlgTabItem, FUN_0051abe4, FUN_0051d699; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_25, 0x25  # offset +0x25
.equ field_40, 0x40  # offset +0x40
.equ field_4c, 0x4c  # offset +0x4c
.equ field_58, 0x58  # offset +0x58
.equ field_cc, 0xcc  # offset +0xcc
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051d699, .text + (0x0051d699 - 0x401000)
.set FUN_0051e2a0, .text + (0x0051e2a0 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e2e7 - 0x401000
.globl FUN_0051e2e7
FUN_0051e2e7:
    # block 0x0051e2e7: entry, 9 instruction(s), calls indirect dword ptr [eax + 0xcc], FUN_00525371, ends with je to 0x0051e335 (forward)
    push esi                                     # 0051e2e7
    {load} mov esi, ecx                          # 0051e2e8
    push edi                                     # 0051e2ea
    mov eax, dword ptr [esi]                     # 0051e2eb
    call dword ptr [eax + field_cc]              # 0051e2ed
    call FUN_00525371                            # 0051e2f3
    mov ecx, dword ptr [eax + field_1038]        # 0051e2f8
    test ecx, ecx                                # 0051e2fe
    je.d8 L_0051e335                             # 0051e300
    # block 0x0051e302: entered by fall-through of je at 0x0051e300, 3 instruction(s), ends with je to 0x0051e335 (forward)
    mov eax, dword ptr [esi + field_58]          # 0051e302
    test eax, eax                                # 0051e305
    je.d8 L_0051e335                             # 0051e307
    # block 0x0051e309: entered by fall-through of je at 0x0051e307, 3 instruction(s), ends with je to 0x0051e31a (forward)
    mov edx, dword ptr [esi + field_4c]          # 0051e309
    test edx, edx                                # 0051e30c
    je.d8 L_0051e31a                             # 0051e30e
    # block 0x0051e310: entered by fall-through of je at 0x0051e30e, 6 instruction(s), calls indirect dword ptr [edi + 0x1c], ends with forward jump to 0x0051e324
    mov edi, dword ptr [ecx]                     # 0051e310
    push eax                                     # 0051e312
    push edx                                     # 0051e313
    push esi                                     # 0051e314
    call dword ptr [edi + field_1c]              # 0051e315
    jmp.d8 L_0051e324                            # 0051e318
L_0051e31a:
    # block 0x0051e31a: entered by je at 0x0051e30e, 5 instruction(s), calls indirect dword ptr [edx + 0x20], falls into the block at 0x0051e324
    mov edx, dword ptr [ecx]                     # 0051e31a
    push eax                                     # 0051e31c
    push dword ptr [esi + field_40]              # 0051e31d
    push esi                                     # 0051e320
    call dword ptr [edx + field_20]              # 0051e321
L_0051e324:
    # block 0x0051e324: entered by jmp at 0x0051e318, 2 instruction(s), ends with jne to 0x0051e335 (forward)
    test eax, eax                                # 0051e324
    jne.d8 L_0051e335                            # 0051e326
    # block 0x0051e328: entered by fall-through of jne at 0x0051e326, 5 instruction(s), calls FUN_0051e2a0, ends with forward jump to 0x0051e36a
    push -0x1                                    # 0051e328
    {load} mov ecx, esi                          # 0051e32a
    call FUN_0051e2a0                            # 0051e32c
    {load} xor eax, eax                          # 0051e331
    jmp.d8 L_0051e36a                            # 0051e333
L_0051e335:
    # block 0x0051e335: entered by je at 0x0051e300; je at 0x0051e307; jne at 0x0051e326, 5 instruction(s), calls FUN_0051ab4b, ends with je to 0x0051e368 (forward)
    {load} mov ecx, esi                          # 0051e335
    call FUN_0051ab4b                            # 0051e337
    {load} mov edi, eax                          # 0051e33c
    test edi, edi                                # 0051e33e
    je.d8 L_0051e368                             # 0051e340
    # block 0x0051e342: entered by fall-through of je at 0x0051e340, 2 instruction(s), ends with je to 0x0051e368 (forward)
    test byte ptr [esi + field_25], 0x1          # 0051e342
    je.d8 L_0051e368                             # 0051e346
    # block 0x0051e348: entered by fall-through of je at 0x0051e346, 8 instruction(s), calls USER32.dll!GetNextDlgTabItem, FUN_0051abe4, ends with je to 0x0051e368 (forward)
    push 0x0                                     # 0051e348
    push 0x0                                     # 0051e34a
    push dword ptr [esi + field_1c]              # 0051e34c
    call dword ptr [0x52a334]                    # 0051e34f
    push eax                                     # 0051e355
    call FUN_0051abe4                            # 0051e356
    test eax, eax                                # 0051e35b
    je.d8 L_0051e368                             # 0051e35d
    # block 0x0051e35f: entered by fall-through of je at 0x0051e35d, 3 instruction(s), calls FUN_0051d699, falls into the block at 0x0051e368
    {load} mov ecx, eax                          # 0051e35f
    call FUN_0051d699                            # 0051e361
    {load} xor edi, edi                          # 0051e366
L_0051e368:
    # block 0x0051e368: entered by je at 0x0051e340; je at 0x0051e346; je at 0x0051e35d, 1 instruction(s), falls into the block at 0x0051e36a
    {load} mov eax, edi                          # 0051e368
L_0051e36a:
    # block 0x0051e36a: entered by jmp at 0x0051e333, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0051e36a
    pop esi                                      # 0051e36b
    ret 0x8                                      # 0051e36c

