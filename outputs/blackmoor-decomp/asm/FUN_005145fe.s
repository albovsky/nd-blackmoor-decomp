# FUN_005145fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005145fe
# extent:       0x005145fe-0x005146bf (193 code bytes)
# span:         0x005145fe-0x005146bf (code 193, tables 0, padding 0)
# sha256:       3ffd66b98b4f3b00bfdd8b3d970cc505f545cfecbcf7b7eaade9a6ddaf76a30d
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005145fe
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_b, arg_c, arg_e, arg_f, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051457b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_b, 0xb  # offset +0xb
.equ arg_c, 0xc  # offset +0xc
.equ arg_e, 0xe  # offset +0xe
.equ arg_f, 0xf  # offset +0xf
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051457b, .text + (0x0051457b - 0x401000)

.org 0x005145fe - 0x401000
.globl FUN_005145fe
FUN_005145fe:
    # block 0x005145fe: entry, 10 instruction(s), ends with jne to 0x0051461e (forward)
    push ebp                                     # 005145fe
    {load} mov ebp, esp                          # 005145ff
    push ecx                                     # 00514601
    push ecx                                     # 00514602
    fld qword ptr [ebp + arg_8]                  # 00514603
    fcomp qword ptr [0x52c7b0]                   # 00514606
    push esi                                     # 0051460c
    fnstsw ax                                    # 0051460d
    sahf                                         # 0051460f
    jne.d8 L_0051461e                            # 00514610
    # block 0x00514612: entered by fall-through of jne at 0x00514610, 4 instruction(s), ends with forward jump to 0x005146b4
    fldz                                         # 00514612
    {load} xor esi, esi                          # 00514614
    fstp qword ptr [ebp - local_8]               # 00514616
    jmp.d32 L_005146b4                           # 00514619
L_0051461e:
    # block 0x0051461e: entered by jne at 0x00514610, 3 instruction(s), ends with jne to 0x0051468d (forward)
    {load} xor ecx, ecx                          # 0051461e
    test word ptr [ebp + arg_e], 0x7ff0          # 00514620
    jne.d8 L_0051468d                            # 00514626
    # block 0x00514628: entered by fall-through of jne at 0x00514626, 2 instruction(s), ends with jne to 0x00514636 (forward)
    test dword ptr [ebp + arg_c], 0xfffff        # 00514628
    jne.d8 L_00514636                            # 0051462f
    # block 0x00514631: entered by fall-through of jne at 0x0051462f, 2 instruction(s), ends with je to 0x0051468d (forward)
    cmp dword ptr [ebp + arg_8], ecx             # 00514631
    je.d8 L_0051468d                             # 00514634
L_00514636:
    # block 0x00514636: entered by jne at 0x0051462f; fall-through of je at 0x00514634, 6 instruction(s), ends with jae to 0x0051464e (forward)
    fld qword ptr [ebp + arg_8]                  # 00514636
    fcomp qword ptr [0x52c7b0]                   # 00514639
    mov esi, 0xfffffc03                          # 0051463f
    fnstsw ax                                    # 00514644
    sahf                                         # 00514646
    jae.d8 L_0051464e                            # 00514647
    # block 0x00514649: entered by fall-through of jae at 0x00514647, 3 instruction(s), ends with forward jump to 0x00514650
    push 0x1                                     # 00514649
    pop eax                                      # 0051464b
    jmp.d8 L_00514650                            # 0051464c
L_0051464e:
    # block 0x0051464e: entered by jae at 0x00514647, 1 instruction(s), falls into the block at 0x00514650
    {load} xor eax, eax                          # 0051464e
L_00514650:
    # block 0x00514650: entered by jmp at 0x0051464c; jmp at 0x00514667, 2 instruction(s), ends with jne to 0x00514669 (forward)
    test byte ptr [ebp + arg_e], 0x10            # 00514650
    jne.d8 L_00514669                            # 00514654
    # block 0x00514656: entered by fall-through of jne at 0x00514654, 3 instruction(s), ends with je to 0x00514663 (forward)
    shl dword ptr [ebp + arg_c]                  # 00514656
    test byte ptr [ebp + arg_b], -0x80           # 00514659
    je.d8 L_00514663                             # 0051465d
    # block 0x0051465f: entered by fall-through of je at 0x0051465d, 1 instruction(s), falls into the block at 0x00514663
    or dword ptr [ebp + arg_c], 0x1              # 0051465f
L_00514663:
    # block 0x00514663: entered by je at 0x0051465d, 3 instruction(s), ends with backward jump to 0x00514650
    shl dword ptr [ebp + arg_8]                  # 00514663
    dec esi                                      # 00514666
    jmp.d8 L_00514650                            # 00514667
L_00514669:
    # block 0x00514669: entered by jne at 0x00514654, 3 instruction(s), ends with je to 0x00514677 (forward)
    .insn 0x6681/4, dword ptr [ebp + arg_e], -17{:s16} # 00514669
    {load} cmp eax, ecx                          # 0051466f
    je.d8 L_00514677                             # 00514671
    # block 0x00514673: entered by fall-through of je at 0x00514671, 1 instruction(s), falls into the block at 0x00514677
    or byte ptr [ebp + arg_f], -0x80             # 00514673
L_00514677:
    # block 0x00514677: entered by je at 0x00514671, 9 instruction(s), calls FUN_0051457b, ends with forward jump to 0x005146b4
    fld qword ptr [ebp + arg_8]                  # 00514677
    push ecx                                     # 0051467a
    push ecx                                     # 0051467b
    push ecx                                     # 0051467c
    fstp qword ptr [esp]                         # 0051467d
    call FUN_0051457b                            # 00514680
    fstp qword ptr [ebp - local_8]               # 00514685
    add esp, 0xc                                 # 00514688
    jmp.d8 L_005146b4                            # 0051468b
L_0051468d:
    # block 0x0051468d: entered by jne at 0x00514626; je at 0x00514634, 13 instruction(s), calls FUN_0051457b, falls into the block at 0x005146b4
    fld qword ptr [ebp + arg_8]                  # 0051468d
    push ecx                                     # 00514690
    push ecx                                     # 00514691
    push ecx                                     # 00514692
    fstp qword ptr [esp]                         # 00514693
    call FUN_0051457b                            # 00514696
    mov eax, dword ptr [ebp + arg_e]             # 0051469b
    add esp, 0xc                                 # 0051469e
    fstp qword ptr [ebp - local_8]               # 005146a1
    shr eax, 0x4                                 # 005146a4
    .insn 0x66, 0x25, 0x07ff{:u16}               # 005146a7
    movsx esi, ax                                # 005146ab
    sub esi, 0x3fe                               # 005146ae
L_005146b4:
    # block 0x005146b4: entered by jmp at 0x00514619; jmp at 0x0051468b, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp + arg_10]            # 005146b4
    fld qword ptr [ebp - local_8]                # 005146b7
    mov dword ptr [eax], esi                     # 005146ba
    pop esi                                      # 005146bc
    leave                                        # 005146bd
    ret                                          # 005146be

