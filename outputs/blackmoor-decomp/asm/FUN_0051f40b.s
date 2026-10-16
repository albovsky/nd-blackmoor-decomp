# FUN_0051f40b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f40b
# extent:       0x0051f40b-0x0051f482 (119 code bytes)
# span:         0x0051f40b-0x0051f482 (code 119, tables 0, padding 0)
# sha256:       38961c2f91cd20274a20695824217f00f937c87d3322dff634774005d17a4ab2
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051f3d4 (+0x37)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f40b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10; [edx + n] field_4, field_c; [esp + n] stk_8, stk_c, stk_10
# callees:      calls FUN_0051f599, FUN_0051f13f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051f13f, .text + (0x0051f13f - 0x401000)
.set FUN_0051f599, .text + (0x0051f599 - 0x401000)

.org 0x0051f40b - 0x401000
.globl FUN_0051f40b
FUN_0051f40b:
    # block 0x0051f40b: entry, 6 instruction(s), ends with je to 0x0051f474 (forward)
    mov edx, dword ptr [esp + stk_8]             # 0051f40b
    push esi                                     # 0051f40f
    mov eax, dword ptr [edx + field_4]           # 0051f410
    {load} mov esi, eax                          # 0051f413
    dec esi                                      # 0051f415
    je.d8 L_0051f474                             # 0051f416
    # block 0x0051f418: entered by fall-through of je at 0x0051f416, 2 instruction(s), ends with je to 0x0051f474 (forward)
    sub esi, 0xe                                 # 0051f418
    je.d8 L_0051f474                             # 0051f41b
    # block 0x0051f41d: entered by fall-through of je at 0x0051f41b, 6 instruction(s), ends with jne to 0x0051f436 (forward)
    push ebx                                     # 0051f41d
    {load} xor ebx, ebx                          # 0051f41e
    push edi                                     # 0051f420
    cmp eax, 0x111                               # 0051f421
    mov edi, 0xf108                              # 0051f426
    jne.d8 L_0051f436                            # 0051f42b
    # block 0x0051f42d: entered by fall-through of jne at 0x0051f42b, 2 instruction(s), ends with jne to 0x0051f433 (forward)
    cmp dword ptr [edx + field_c], ebx           # 0051f42d
    jne.d8 L_0051f433                            # 0051f430
    # block 0x0051f432: entered by fall-through of jne at 0x0051f430, 1 instruction(s), falls into the block at 0x0051f433
    inc edi                                      # 0051f432
L_0051f433:
    # block 0x0051f433: entered by jne at 0x0051f430, 2 instruction(s), falls into the block at 0x0051f436
    push 0x1                                     # 0051f433
    pop ebx                                      # 0051f435
L_0051f436:
    # block 0x0051f436: entered by jne at 0x0051f42b, 6 instruction(s), calls FUN_0051f599, ends with je to 0x0051f454 (forward)
    mov esi, dword ptr [esp + stk_10]            # 0051f436
    push 0x52fdf0                                # 0051f43a
    {load} mov ecx, esi                          # 0051f43f
    call FUN_0051f599                            # 0051f441
    test eax, eax                                # 0051f446
    je.d8 L_0051f454                             # 0051f448
    # block 0x0051f44a: entered by fall-through of je at 0x0051f448, 4 instruction(s), ends with forward jump to 0x0051f469
    mov eax, dword ptr [esi]                     # 0051f44a
    push edi                                     # 0051f44c
    push 0x1030                                  # 0051f44d
    jmp.d8 L_0051f469                            # 0051f452
L_0051f454:
    # block 0x0051f454: entered by je at 0x0051f448, 5 instruction(s), calls FUN_0051f599, ends with jne to 0x0051f46e (forward)
    push 0x52fc28                                # 0051f454
    {load} mov ecx, esi                          # 0051f459
    call FUN_0051f599                            # 0051f45b
    test eax, eax                                # 0051f460
    jne.d8 L_0051f46e                            # 0051f462
    # block 0x0051f464: entered by fall-through of jne at 0x0051f462, 3 instruction(s), falls into the block at 0x0051f469
    mov eax, dword ptr [esi]                     # 0051f464
    push edi                                     # 0051f466
    push 0x10                                    # 0051f467
L_0051f469:
    # block 0x0051f469: entered by jmp at 0x0051f452, 2 instruction(s), calls indirect dword ptr [eax + 0x10], falls into the block at 0x0051f46e
    {load} mov ecx, esi                          # 0051f469
    call dword ptr [eax + field_10]              # 0051f46b
L_0051f46e:
    # block 0x0051f46e: entered by jne at 0x0051f462, 4 instruction(s), ends with forward jump to 0x0051f47e
    {load} mov eax, ebx                          # 0051f46e
    pop edi                                      # 0051f470
    pop ebx                                      # 0051f471
    jmp.d8 L_0051f47e                            # 0051f472
L_0051f474:
    # block 0x0051f474: entered by je at 0x0051f416; je at 0x0051f41b, 3 instruction(s), calls FUN_0051f13f, falls into the block at 0x0051f47e
    push edx                                     # 0051f474
    push dword ptr [esp + stk_c]                 # 0051f475
    call FUN_0051f13f                            # 0051f479
L_0051f47e:
    # block 0x0051f47e: entered by jmp at 0x0051f472, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051f47e
    ret 0x8                                      # 0051f47f

