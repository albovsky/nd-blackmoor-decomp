# FUN_005235a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005235a3
# extent:       0x005235a3-0x00523677 (212 code bytes)
# span:         0x005235a3-0x00523677 (code 212, tables 0, padding 0)
# sha256:       4d1cdde5c7d5bfe8a0766ed4c5319fa623288645e4116a24d49f33ec50ea0c67
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005235a3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_c0, field_e4, field_e8; [edi + n] field_1c; [esi + n] field_24
# callees:      calls FUN_0051ab4b, FUN_0051d526, FUN_0051c174, USER32.dll!SendMessageA, FUN_00522ed0, FUN_0052398b; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 83 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_c0, 0xc0  # offset +0xc0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_00522ed0, .text + (0x00522ed0 - 0x401000)
.set FUN_0052398b, .text + (0x0052398b - 0x401000)

.org 0x005235a3 - 0x401000
.globl FUN_005235a3
FUN_005235a3:
    # block 0x005235a3: entry, 10 instruction(s), calls FUN_0051ab4b, FUN_0051d526, ends with je to 0x005235c1 (forward)
    push ebp                                     # 005235a3
    {load} mov ebp, esp                          # 005235a4
    push ebx                                     # 005235a6
    push esi                                     # 005235a7
    {load} mov ebx, ecx                          # 005235a8
    call FUN_0051ab4b                            # 005235aa
    {load} mov ecx, ebx                          # 005235af
    call FUN_0051d526                            # 005235b1
    test eax, 0x40000000                         # 005235b6
    je.d8 L_005235c1                             # 005235bb
    # block 0x005235bd: entered by fall-through of je at 0x005235bb, 2 instruction(s), ends with forward jump to 0x005235ca
    {load} mov esi, ebx                          # 005235bd
    jmp.d8 L_005235ca                            # 005235bf
L_005235c1:
    # block 0x005235c1: entered by je at 0x005235bb, 3 instruction(s), calls FUN_0051c174, falls into the block at 0x005235ca
    {load} mov ecx, ebx                          # 005235c1
    call FUN_0051c174                            # 005235c3
    {load} mov esi, eax                          # 005235c8
L_005235ca:
    # block 0x005235ca: entered by jmp at 0x005235bf, 4 instruction(s), ends with je to 0x005235d6 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 005235ca
    push edi                                     # 005235ce
    mov edi, dword ptr [ebp + arg_c]             # 005235cf
    je.d8 L_005235d6                             # 005235d2
    # block 0x005235d4: entered by fall-through of je at 0x005235d2, 1 instruction(s), falls into the block at 0x005235d6
    {load} mov edi, ebx                          # 005235d4
L_005235d6:
    # block 0x005235d6: entered by je at 0x005235d2, 2 instruction(s), ends with je to 0x005235ff (forward)
    {load} cmp esi, edi                          # 005235d6
    je.d8 L_005235ff                             # 005235d8
    # block 0x005235da: entered by fall-through of je at 0x005235d8, 4 instruction(s), calls FUN_0051c174, ends with jne to 0x005235fb (forward)
    {load} mov ecx, edi                          # 005235da
    call FUN_0051c174                            # 005235dc
    {load} cmp esi, eax                          # 005235e1
    jne.d8 L_005235fb                            # 005235e3
    # block 0x005235e5: entered by fall-through of jne at 0x005235e3, 7 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x005235ff (forward)
    push 0x0                                     # 005235e5
    push 0x40                                    # 005235e7
    push 0x36d                                   # 005235e9
    push dword ptr [edi + field_1c]              # 005235ee
    call dword ptr [0x52a4c8]                    # 005235f1
    test eax, eax                                # 005235f7
    jne.d8 L_005235ff                            # 005235f9
L_005235fb:
    # block 0x005235fb: entered by jne at 0x005235e3; fall-through of jne at 0x005235f9, 2 instruction(s), ends with forward jump to 0x00523602
    {load} xor eax, eax                          # 005235fb
    jmp.d8 L_00523602                            # 005235fd
L_005235ff:
    # block 0x005235ff: entered by je at 0x005235d8; jne at 0x005235f9, 2 instruction(s), falls into the block at 0x00523602
    push 0x1                                     # 005235ff
    pop eax                                      # 00523601
L_00523602:
    # block 0x00523602: entered by jmp at 0x005235fd, 5 instruction(s), ends with je to 0x00523614 (forward)
    and dword ptr [esi + field_24], -0x21        # 00523602
    mov ecx, dword ptr [esi + field_24]          # 00523606
    test eax, eax                                # 00523609
    pop edi                                      # 0052360b
    je.d8 L_00523614                             # 0052360c
    # block 0x0052360e: entered by fall-through of je at 0x0052360c, 2 instruction(s), falls into the block at 0x00523614
    or ecx, 0x20                                 # 0052360e
    mov dword ptr [esi + field_24], ecx          # 00523611
L_00523614:
    # block 0x00523614: entered by je at 0x0052360c, 12 instruction(s), calls FUN_00522ed0, FUN_0052398b, ends with jne to 0x00523649 (forward)
    neg eax                                      # 00523614
    {load} sbb eax, eax                          # 00523616
    {load} mov ecx, ebx                          # 00523618
    and al, -0x4                                 # 0052361a
    add eax, 0x8                                 # 0052361c
    push eax                                     # 0052361f
    call FUN_00522ed0                            # 00523620
    {load} mov ecx, ebx                          # 00523625
    call FUN_0052398b                            # 00523627
    {load} mov esi, eax                          # 0052362c
    test esi, esi                                # 0052362e
    jne.d8 L_00523649                            # 00523630
    # block 0x00523632: entered by fall-through of jne at 0x00523630, 8 instruction(s), calls indirect dword ptr [eax + 0xc0], FUN_0052398b, ends with je to 0x00523671 (forward)
    mov eax, dword ptr [ebx]                     # 00523632
    {load} mov ecx, ebx                          # 00523634
    call dword ptr [eax + field_c0]              # 00523636
    {load} mov ecx, eax                          # 0052363c
    call FUN_0052398b                            # 0052363e
    {load} mov esi, eax                          # 00523643
    test esi, esi                                # 00523645
    je.d8 L_00523671                             # 00523647
L_00523649:
    # block 0x00523649: entered by jne at 0x00523630; fall-through of je at 0x00523647, 2 instruction(s), ends with je to 0x00523663 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00523649
    je.d8 L_00523663                             # 0052364d
    # block 0x0052364f: entered by fall-through of je at 0x0052364d, 2 instruction(s), ends with jne to 0x00523663 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0052364f
    jne.d8 L_00523663                            # 00523653
    # block 0x00523655: entered by fall-through of jne at 0x00523653, 6 instruction(s), calls indirect dword ptr [eax + 0xe4], falls into the block at 0x00523663
    mov eax, dword ptr [esi]                     # 00523655
    push esi                                     # 00523657
    push esi                                     # 00523658
    push 0x1                                     # 00523659
    {load} mov ecx, esi                          # 0052365b
    call dword ptr [eax + field_e4]              # 0052365d
L_00523663:
    # block 0x00523663: entered by je at 0x0052364d; jne at 0x00523653, 5 instruction(s), calls indirect dword ptr [eax + 0xe8], falls into the block at 0x00523671
    mov eax, dword ptr [esi]                     # 00523663
    push ebx                                     # 00523665
    push dword ptr [ebp + arg_8]                 # 00523666
    {load} mov ecx, esi                          # 00523669
    call dword ptr [eax + field_e8]              # 0052366b
L_00523671:
    # block 0x00523671: entered by je at 0x00523647, 4 instruction(s), ends with ret 0xc
    pop esi                                      # 00523671
    pop ebx                                      # 00523672
    pop ebp                                      # 00523673
    ret 0xc                                      # 00523674

