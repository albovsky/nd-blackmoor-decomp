# FUN_0051b414
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b414
# extent:       0x0051b414-0x0051b461 (77 code bytes)
# span:         0x0051b414-0x0051b461 (code 77, tables 0, padding 0)
# sha256:       bfca81d533b377da392db02934697eef2eab0c9040c86af4b2d3d07b5122b303
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b414
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_50; [esi + n] field_1c, field_38
# callees:      calls FUN_0051ab72, FUN_0051a57e, USER32.dll!DestroyWindow, FUN_0051ac62; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)
.set FUN_0051ac62, .text + (0x0051ac62 - 0x401000)

.org 0x0051b414 - 0x401000
.globl FUN_0051b414
FUN_0051b414:
    # block 0x0051b414: entry, 4 instruction(s), ends with jne to 0x0051b421 (forward)
    push esi                                     # 0051b414
    {load} mov esi, ecx                          # 0051b415
    cmp dword ptr [esi + field_1c], 0x0          # 0051b417
    jne.d8 L_0051b421                            # 0051b41b
    # block 0x0051b41d: entered by fall-through of jne at 0x0051b41b, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051b41d
    pop esi                                      # 0051b41f
    ret                                          # 0051b420
L_0051b421:
    # block 0x0051b421: entered by jne at 0x0051b41b, 11 instruction(s), calls FUN_0051ab72, FUN_0051a57e, ends with jne to 0x0051b449 (forward)
    push ebx                                     # 0051b421
    push edi                                     # 0051b422
    push 0x0                                     # 0051b423
    call FUN_0051ab72                            # 0051b425
    push dword ptr [esi + field_1c]              # 0051b42a
    lea ecx, [eax + field_4]                     # 0051b42d
    call FUN_0051a57e                            # 0051b430
    mov ecx, dword ptr [esi + field_38]          # 0051b435
    {load} mov edi, eax                          # 0051b438
    test ecx, ecx                                # 0051b43a
    jne.d8 L_0051b449                            # 0051b43c
    # block 0x0051b43e: entered by fall-through of jne at 0x0051b43c, 3 instruction(s), calls USER32.dll!DestroyWindow, ends with forward jump to 0x0051b44e
    push dword ptr [esi + field_1c]              # 0051b43e
    call dword ptr [0x52a414]                    # 0051b441
    jmp.d8 L_0051b44e                            # 0051b447
L_0051b449:
    # block 0x0051b449: entered by jne at 0x0051b43c, 2 instruction(s), calls indirect dword ptr [eax + 0x50], falls into the block at 0x0051b44e
    mov eax, dword ptr [ecx]                     # 0051b449
    call dword ptr [eax + field_50]              # 0051b44b
L_0051b44e:
    # block 0x0051b44e: entered by jmp at 0x0051b447, 3 instruction(s), ends with jne to 0x0051b45b (forward)
    test edi, edi                                # 0051b44e
    {load} mov ebx, eax                          # 0051b450
    jne.d8 L_0051b45b                            # 0051b452
    # block 0x0051b454: entered by fall-through of jne at 0x0051b452, 2 instruction(s), calls FUN_0051ac62, falls into the block at 0x0051b45b
    {load} mov ecx, esi                          # 0051b454
    call FUN_0051ac62                            # 0051b456
L_0051b45b:
    # block 0x0051b45b: entered by jne at 0x0051b452, 5 instruction(s), ends with ret
    {load} mov eax, ebx                          # 0051b45b
    pop edi                                      # 0051b45d
    pop ebx                                      # 0051b45e
    pop esi                                      # 0051b45f
    ret                                          # 0051b460

