# FUN_0052341b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052341b
# extent:       0x0052341b-0x005234c3 (168 code bytes)
# span:         0x0052341b-0x005234c3 (code 168, tables 0, padding 0)
# sha256:       b52a4498a907ff18e8cb594639da3fadc63aba70b1ef433045d7a3258833386f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005233c8 (+0x53)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052341b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_8, field_c, field_10, field_14, field_minus_4, field_minus_c, field_minus_10, field_minus_14; [edx + n] field_c; [esi + n] field_c4
# callees:      calls FUN_0050f978, FUN_0052513f, FUN_0052398b, FUN_0051d862, FUN_00525371; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005234c3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_c4, 0xc4  # offset +0xc4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051d862, .text + (0x0051d862 - 0x401000)
.set FUN_0052398b, .text + (0x0052398b - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0052341b - 0x401000
.globl FUN_0052341b
FUN_0052341b:
    # block 0x0052341b: entry, 19 instruction(s), calls FUN_0050f978, FUN_0052513f, FUN_0052398b, ends with je to 0x00523470 (forward)
    mov eax, 0x528f58                            # 0052341b
    call FUN_0050f978                            # 00523420
    push ecx                                     # 00523425
    push ecx                                     # 00523426
    push ebx                                     # 00523427
    push esi                                     # 00523428
    push edi                                     # 00523429
    {load} mov edi, ecx                          # 0052342a
    call FUN_0052513f                            # 0052342c
    {load} mov esi, eax                          # 00523431
    mov dword ptr [ebp - field_minus_10], esi    # 00523433
    mov ebx, dword ptr [esi + field_c4]          # 00523436
    mov dword ptr [esi + field_c4], edi          # 0052343c
    mov dword ptr [ebp - field_minus_14], ebx    # 00523442
    and dword ptr [ebp - field_minus_4], 0x0     # 00523445
    {load} mov ecx, edi                          # 00523449
    call FUN_0052398b                            # 0052344b
    test eax, eax                                # 00523450
    je.d8 L_00523470                             # 00523452
    # block 0x00523454: entered by fall-through of je at 0x00523452, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x00523470 (forward)
    push dword ptr [ebp + field_14]              # 00523454
    mov edx, dword ptr [eax]                     # 00523457
    {load} mov ecx, eax                          # 00523459
    push dword ptr [ebp + field_10]              # 0052345b
    push dword ptr [ebp + field_c]               # 0052345e
    push dword ptr [ebp + field_8]               # 00523461
    call dword ptr [edx + field_c]               # 00523464
    test eax, eax                                # 00523467
    je.d8 L_00523470                             # 00523469
L_0052346b:
    # block 0x0052346b: entered by jne at 0x00523485; jne at 0x005234a8; fall-through of je at 0x00523469, 3 instruction(s), ends with forward jump to 0x005234ac
    push 0x1                                     # 0052346b
    pop eax                                      # 0052346d
    jmp.d8 L_005234ac                            # 0052346e
L_00523470:
    # block 0x00523470: entered by je at 0x00523452; je at 0x00523469, 8 instruction(s), calls FUN_0051d862, ends with jne to 0x0052346b (backward)
    push dword ptr [ebp + field_14]              # 00523470
    {load} mov ecx, edi                          # 00523473
    push dword ptr [ebp + field_10]              # 00523475
    push dword ptr [ebp + field_c]               # 00523478
    push dword ptr [ebp + field_8]               # 0052347b
    call FUN_0051d862                            # 0052347e
    test eax, eax                                # 00523483
    jne.d8 L_0052346b                            # 00523485
    # block 0x00523487: entered by fall-through of jne at 0x00523485, 4 instruction(s), calls FUN_00525371, ends with je to 0x005234aa (forward)
    call FUN_00525371                            # 00523487
    mov eax, dword ptr [eax + field_4]           # 0052348c
    test eax, eax                                # 0052348f
    je.d8 L_005234aa                             # 00523491
    # block 0x00523493: entered by fall-through of je at 0x00523491, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with jne to 0x0052346b (backward)
    push dword ptr [ebp + field_14]              # 00523493
    mov edx, dword ptr [eax]                     # 00523496
    {load} mov ecx, eax                          # 00523498
    push dword ptr [ebp + field_10]              # 0052349a
    push dword ptr [ebp + field_c]               # 0052349d
    push dword ptr [ebp + field_8]               # 005234a0
    call dword ptr [edx + field_c]               # 005234a3
    test eax, eax                                # 005234a6
    jne.d8 L_0052346b                            # 005234a8
L_005234aa:
    # block 0x005234aa: entered by je at 0x00523491; fall-through of jne at 0x005234a8, 1 instruction(s), falls into the block at 0x005234ac
    {load} xor eax, eax                          # 005234aa
L_005234ac:
    # block 0x005234ac: entered by jmp at 0x0052346e, 8 instruction(s), ends with ret 0x10
    mov ecx, dword ptr [ebp - field_minus_c]     # 005234ac
    mov dword ptr [esi + field_c4], ebx          # 005234af
    pop edi                                      # 005234b5
    pop esi                                      # 005234b6
    pop ebx                                      # 005234b7
    mov dword ptr fs:[0x0], ecx                  # 005234b8
    leave                                        # 005234bf
    ret 0x10                                     # 005234c0

