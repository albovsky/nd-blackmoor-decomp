# FUN_0051384a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051384a
# extent:       0x0051384a-0x0051397b (305 code bytes)
# span:         0x0051384a-0x0051397b (code 305, tables 0, padding 0)
# sha256:       326072a4d3ee173c7b0f57ff2e1606951362f5d7fa5744b41f4adcbad4824f6f
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051384a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_10, field_minus_76, field_minus_7e, field_minus_86, field_minus_8a, field_minus_8e, field_minus_90, field_minus_94, field_minus_a4, field_minus_2c8, field_minus_2ca and 1 more; [ebx + n] field_c, field_e
# callees:      calls FUN_005187fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_76, 0x76  # offset -0x76
.equ field_minus_7e, 0x7e  # offset -0x7e
.equ field_minus_86, 0x86  # offset -0x86
.equ field_minus_8a, 0x8a  # offset -0x8a
.equ field_minus_8e, 0x8e  # offset -0x8e
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_94, 0x94  # offset -0x94
.equ field_minus_a4, 0xa4  # offset -0xa4
.equ field_minus_2c8, 0x2c8  # offset -0x2c8
.equ field_minus_2ca, 0x2ca  # offset -0x2ca
.equ field_minus_2d0, 0x2d0  # offset -0x2d0
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005187fb, .text + (0x005187fb - 0x401000)

.org 0x0051384a - 0x401000
.globl FUN_0051384a
FUN_0051384a:
    # block 0x0051384a: entry, 2 instruction(s), ends with jne to 0x0051389f (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0051384a
    jne.d8 L_0051389f                            # 00513851
    # block 0x00513853: entered by fall-through of jne at 0x00513851, 4 instruction(s), ends with je to 0x0051387d (forward)
    fst qword ptr [ebp - field_minus_2d0]        # 00513853
    mov al, byte ptr [ebp - field_minus_90]      # 00513859
    {load} or al, al                             # 0051385f
    je.d8 L_0051387d                             # 00513861
    # block 0x00513863: entered by fall-through of je at 0x00513861, 2 instruction(s), ends with je to 0x005138a7 (forward)
    cmp al, -0x1                                 # 00513863
    je.d8 L_005138a7                             # 00513865
    # block 0x00513867: entered by fall-through of je at 0x00513865, 2 instruction(s), ends with je to 0x005138a7 (forward)
    cmp al, -0x2                                 # 00513867
    je.d8 L_005138a7                             # 00513869
    # block 0x0051386b: entered by fall-through of je at 0x00513869, 2 instruction(s), ends with je to 0x0051389f (forward)
    {load} or al, al                             # 0051386b
    je.d8 L_0051389f                             # 0051386d
    # block 0x0051386f: entered by fall-through of je at 0x0051386d, 3 instruction(s), ends with forward jump to 0x00513919
    movsx eax, al                                # 0051386f
    mov dword ptr [ebp - field_minus_8e], eax    # 00513872
    jmp.d32 L_00513919                           # 00513878
L_0051387d:
    # block 0x0051387d: entered by je at 0x00513861; jmp at 0x005138bd, 3 instruction(s), ends with jne to 0x0051389f (forward)
    mov ax, word ptr [ebp - field_minus_a4]      # 0051387d
    and ax, 0x20                                 # 00513884
    jne.d8 L_0051389f                            # 00513888
    # block 0x0051388a: entered by fall-through of jne at 0x00513888, 4 instruction(s), ends with je to 0x0051389f (forward)
    wait                                         # 0051388a
    fnstsw ax                                    # 0051388b
    and ax, 0x20                                 # 0051388d
    je.d8 L_0051389f                             # 00513891
    # block 0x00513893: entered by fall-through of je at 0x00513891, 2 instruction(s), ends with forward jump to 0x00513919
    mov dword ptr [ebp - field_minus_8e], 0x8    # 00513893
    jmp.d8 L_00513919                            # 0051389d
L_0051389f:
    # block 0x0051389f: entered by jne at 0x00513851; je at 0x0051386d; jne at 0x00513888; je at 0x00513891; more, 3 instruction(s), ends with ret
    fldcw word ptr [ebp - field_minus_a4]        # 0051389f
    wait                                         # 005138a5
    ret                                          # 005138a6
L_005138a7:
    # block 0x005138a7: entered by je at 0x00513865; je at 0x00513869, 4 instruction(s), ends with je to 0x005138bf (forward)
    mov ax, word ptr [ebp - field_minus_2ca]     # 005138a7
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 005138ae
    {load} or ax, ax                             # 005138b2
    je.d8 L_005138bf                             # 005138b5
    # block 0x005138b7: entered by fall-through of je at 0x005138b5, 2 instruction(s), ends with je to 0x005138ed (forward)
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 005138b7
    je.d8 L_005138ed                             # 005138bb
    # block 0x005138bd: entered by fall-through of je at 0x005138bb, 1 instruction(s), ends with backward jump to 0x0051387d
    jmp.d8 L_0051387d                            # 005138bd
L_005138bf:
    # block 0x005138bf: entered by je at 0x005138b5, 12 instruction(s), ends with jae to 0x00513919 (forward)
    mov dword ptr [ebp - field_minus_8e], 0x4    # 005138bf
    fld qword ptr [0x530528]                     # 005138c9
    fxch st(1)                                   # 005138cf
    fscale                                       # 005138d1
    fstp st(1)                                   # 005138d3
    fld st(0)                                    # 005138d5
    fabs                                         # 005138d7
    fcomp qword ptr [0x530518]                   # 005138d9
    wait                                         # 005138df
    fnstsw ax                                    # 005138e0
    sahf                                         # 005138e2
    jae.d8 L_00513919                            # 005138e3
    # block 0x005138e5: entered by fall-through of jae at 0x005138e3, 2 instruction(s), ends with forward jump to 0x00513919
    fmul qword ptr [0x530538]                    # 005138e5
    jmp.d8 L_00513919                            # 005138eb
L_005138ed:
    # block 0x005138ed: entered by je at 0x005138bb, 12 instruction(s), ends with jbe to 0x00513919 (forward)
    mov dword ptr [ebp - field_minus_8e], 0x3    # 005138ed
    fld qword ptr [0x530520]                     # 005138f7
    fxch st(1)                                   # 005138fd
    fscale                                       # 005138ff
    fstp st(1)                                   # 00513901
    fld st(0)                                    # 00513903
    fabs                                         # 00513905
    fcomp qword ptr [0x530510]                   # 00513907
    wait                                         # 0051390d
    fnstsw ax                                    # 0051390e
    sahf                                         # 00513910
    jbe.d8 L_00513919                            # 00513911
    # block 0x00513913: entered by fall-through of jbe at 0x00513911, 1 instruction(s), falls into the block at 0x00513919
    fmul qword ptr [0x530530]                    # 00513913
L_00513919:
    # block 0x00513919: entered by jmp at 0x00513878; jmp at 0x0051389d; jae at 0x005138e3; jmp at 0x005138eb; more, 7 instruction(s), ends with jne to 0x0051394b (forward)
    push esi                                     # 00513919
    push edi                                     # 0051391a
    mov ebx, dword ptr [ebp - field_minus_94]    # 0051391b
    inc ebx                                      # 00513921
    mov dword ptr [ebp - field_minus_8a], ebx    # 00513922
    test byte ptr [ebp - field_minus_2c8], 0x1   # 00513928
    jne.d8 L_0051394b                            # 0051392f
    # block 0x00513931: entered by fall-through of jne at 0x0051392f, 7 instruction(s), ends with je to 0x0051394b (forward)
    cld                                          # 00513931
    lea esi, [ebp + field_8]                     # 00513932
    lea edi, [ebp - field_minus_86]              # 00513935
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051393b
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051393c
    cmp byte ptr [ebx + field_c], 0x1            # 0051393d
    je.d8 L_0051394b                             # 00513941
    # block 0x00513943: entered by fall-through of je at 0x00513941, 4 instruction(s), falls into the block at 0x0051394b
    lea esi, [ebp + field_10]                    # 00513943
    lea edi, [ebp - field_minus_7e]              # 00513946
    movsd dword ptr es:[edi], dword ptr [esi]    # 00513949
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051394a
L_0051394b:
    # block 0x0051394b: entered by jne at 0x0051392f; je at 0x00513941, 15 instruction(s), calls FUN_005187fb, ends with backward jump to 0x0051389f
    fstp qword ptr [ebp - field_minus_76]        # 0051394b
    lea eax, [ebp - field_minus_8e]              # 0051394e
    lea ebx, [ebp - field_minus_a4]              # 00513954
    push ebx                                     # 0051395a
    push eax                                     # 0051395b
    mov ebx, dword ptr [ebp - field_minus_94]    # 0051395c
    mov al, byte ptr [ebx + field_e]             # 00513962
    movsx eax, al                                # 00513965
    push eax                                     # 00513968
    call FUN_005187fb                            # 00513969
    add esp, 0xc                                 # 0051396e
    pop edi                                      # 00513971
    pop esi                                      # 00513972
    fld qword ptr [ebp - field_minus_76]         # 00513973
    jmp.d32 L_0051389f                           # 00513976

