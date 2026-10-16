# FUN_00514755
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514755
# extent:       0x00514755-0x00514893 (318 code bytes)
# span:         0x00514755-0x00514893 (code 318, tables 0, padding 0)
# sha256:       574bcee2c9f302b7cb19cd5c464e59d576756ee58a1b965278a723eea52c7d63
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514755
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8; [ecx + n] field_minus_4; [esi + n] field_50, field_54, field_58
# callees:      calls FUN_00510dd3, FUN_00514893, KERNEL32.dll!UnhandledExceptionFilter; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 102 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)
.set FUN_00514893, .text + (0x00514893 - 0x401000)

.org 0x00514755 - 0x401000
.globl FUN_00514755
FUN_00514755:
    # block 0x00514755: entry, 14 instruction(s), calls FUN_00510dd3, FUN_00514893, ends with je to 0x00514886 (forward)
    push ebp                                     # 00514755
    {load} mov ebp, esp                          # 00514756
    push ecx                                     # 00514758
    push ebx                                     # 00514759
    push esi                                     # 0051475a
    call FUN_00510dd3                            # 0051475b
    {load} mov esi, eax                          # 00514760
    push dword ptr [esi + field_50]              # 00514762
    push dword ptr [ebp + arg_8]                 # 00514765
    call FUN_00514893                            # 00514768
    pop ecx                                      # 0051476d
    test eax, eax                                # 0051476e
    pop ecx                                      # 00514770
    je.d32 L_00514886                            # 00514771
    # block 0x00514777: entered by fall-through of je at 0x00514771, 4 instruction(s), ends with je to 0x00514886 (forward)
    mov ebx, dword ptr [eax + field_8]           # 00514777
    test ebx, ebx                                # 0051477a
    mov dword ptr [ebp + arg_8], ebx             # 0051477c
    je.d32 L_00514886                            # 0051477f
    # block 0x00514785: entered by fall-through of je at 0x0051477f, 2 instruction(s), ends with jne to 0x00514796 (forward)
    cmp ebx, 0x5                                 # 00514785
    jne.d8 L_00514796                            # 00514788
    # block 0x0051478a: entered by fall-through of jne at 0x00514788, 4 instruction(s), ends with forward jump to 0x0051488f
    and dword ptr [eax + field_8], 0x0           # 0051478a
    push 0x1                                     # 0051478e
    pop eax                                      # 00514790
    jmp.d32 L_0051488f                           # 00514791
L_00514796:
    # block 0x00514796: entered by jne at 0x00514788, 2 instruction(s), ends with je to 0x00514881 (forward)
    cmp ebx, 0x1                                 # 00514796
    je.d32 L_00514881                            # 00514799
    # block 0x0051479f: entered by fall-through of je at 0x00514799, 7 instruction(s), ends with jne to 0x00514873 (forward)
    mov ecx, dword ptr [esi + field_54]          # 0051479f
    mov dword ptr [ebp - local_4], ecx           # 005147a2
    mov ecx, dword ptr [ebp + arg_c]             # 005147a5
    mov dword ptr [esi + field_54], ecx          # 005147a8
    mov ecx, dword ptr [eax + field_4]           # 005147ab
    cmp ecx, 0x8                                 # 005147ae
    jne.d32 L_00514873                           # 005147b1
    # block 0x005147b7: entered by fall-through of jne at 0x005147b1, 6 instruction(s), ends with jge to 0x005147f1 (forward)
    mov edx, dword ptr [0x568ad0]                # 005147b7
    mov ecx, dword ptr [0x568ad4]                # 005147bd
    {load} add ecx, edx                          # 005147c3
    push edi                                     # 005147c5
    {load} cmp edx, ecx                          # 005147c6
    jge.d8 L_005147f1                            # 005147c8
    # block 0x005147ca: entered by fall-through of jge at 0x005147c8, 2 instruction(s), falls into the block at 0x005147d0
    lea ecx, [edx + 2*edx]                       # 005147ca
    shl ecx, 0x2                                 # 005147cd
L_005147d0:
    # block 0x005147d0: entered by jl at 0x005147ec, 9 instruction(s), ends with jl to 0x005147d0 (backward)
    mov edi, dword ptr [esi + field_50]          # 005147d0
    add ecx, 0xc                                 # 005147d3
    and dword ptr [ecx + edi - field_minus_4], 0x0 # 005147d6
    mov edi, dword ptr [0x568ad0]                # 005147db
    mov ebx, dword ptr [0x568ad4]                # 005147e1
    inc edx                                      # 005147e7
    {load} add ebx, edi                          # 005147e8
    {load} cmp edx, ebx                          # 005147ea
    jl.d8 L_005147d0                             # 005147ec
    # block 0x005147ee: entered by fall-through of jl at 0x005147ec, 1 instruction(s), falls into the block at 0x005147f1
    mov ebx, dword ptr [ebp + arg_8]             # 005147ee
L_005147f1:
    # block 0x005147f1: entered by jge at 0x005147c8, 4 instruction(s), ends with jne to 0x00514806 (forward)
    mov eax, dword ptr [eax]                     # 005147f1
    mov edi, dword ptr [esi + field_58]          # 005147f3
    cmp eax, 0xc000008e                          # 005147f6
    jne.d8 L_00514806                            # 005147fb
    # block 0x005147fd: entered by fall-through of jne at 0x005147fb, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x83         # 005147fd
    jmp.d8 L_00514864                            # 00514804
L_00514806:
    # block 0x00514806: entered by jne at 0x005147fb, 2 instruction(s), ends with jne to 0x00514816 (forward)
    cmp eax, 0xc0000090                          # 00514806
    jne.d8 L_00514816                            # 0051480b
    # block 0x0051480d: entered by fall-through of jne at 0x0051480b, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x81         # 0051480d
    jmp.d8 L_00514864                            # 00514814
L_00514816:
    # block 0x00514816: entered by jne at 0x0051480b, 2 instruction(s), ends with jne to 0x00514826 (forward)
    cmp eax, 0xc0000091                          # 00514816
    jne.d8 L_00514826                            # 0051481b
    # block 0x0051481d: entered by fall-through of jne at 0x0051481b, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x84         # 0051481d
    jmp.d8 L_00514864                            # 00514824
L_00514826:
    # block 0x00514826: entered by jne at 0x0051481b, 2 instruction(s), ends with jne to 0x00514836 (forward)
    cmp eax, 0xc0000093                          # 00514826
    jne.d8 L_00514836                            # 0051482b
    # block 0x0051482d: entered by fall-through of jne at 0x0051482b, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x85         # 0051482d
    jmp.d8 L_00514864                            # 00514834
L_00514836:
    # block 0x00514836: entered by jne at 0x0051482b, 2 instruction(s), ends with jne to 0x00514846 (forward)
    cmp eax, 0xc000008d                          # 00514836
    jne.d8 L_00514846                            # 0051483b
    # block 0x0051483d: entered by fall-through of jne at 0x0051483b, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x82         # 0051483d
    jmp.d8 L_00514864                            # 00514844
L_00514846:
    # block 0x00514846: entered by jne at 0x0051483b, 2 instruction(s), ends with jne to 0x00514856 (forward)
    cmp eax, 0xc000008f                          # 00514846
    jne.d8 L_00514856                            # 0051484b
    # block 0x0051484d: entered by fall-through of jne at 0x0051484b, 2 instruction(s), ends with forward jump to 0x00514864
    mov dword ptr [esi + field_58], 0x86         # 0051484d
    jmp.d8 L_00514864                            # 00514854
L_00514856:
    # block 0x00514856: entered by jne at 0x0051484b, 2 instruction(s), ends with jne to 0x00514864 (forward)
    cmp eax, 0xc0000092                          # 00514856
    jne.d8 L_00514864                            # 0051485b
    # block 0x0051485d: entered by fall-through of jne at 0x0051485b, 1 instruction(s), falls into the block at 0x00514864
    mov dword ptr [esi + field_58], 0x8a         # 0051485d
L_00514864:
    # block 0x00514864: entered by jmp at 0x00514804; jmp at 0x00514814; jmp at 0x00514824; jmp at 0x00514834; more, 8 instruction(s), calls indirect ebx, ends with forward jump to 0x0051487b
    push dword ptr [esi + field_58]              # 00514864
    push 0x8                                     # 00514867
    call ebx                                     # 00514869
    pop ecx                                      # 0051486b
    mov dword ptr [esi + field_58], edi          # 0051486c
    pop ecx                                      # 0051486f
    pop edi                                      # 00514870
    jmp.d8 L_0051487b                            # 00514871
L_00514873:
    # block 0x00514873: entered by jne at 0x005147b1, 4 instruction(s), calls indirect ebx, falls into the block at 0x0051487b
    and dword ptr [eax + field_8], 0x0           # 00514873
    push ecx                                     # 00514877
    call ebx                                     # 00514878
    pop ecx                                      # 0051487a
L_0051487b:
    # block 0x0051487b: entered by jmp at 0x00514871, 2 instruction(s), falls into the block at 0x00514881
    mov eax, dword ptr [ebp - local_4]           # 0051487b
    mov dword ptr [esi + field_54], eax          # 0051487e
L_00514881:
    # block 0x00514881: entered by je at 0x00514799, 2 instruction(s), ends with forward jump to 0x0051488f
    or eax, -0x1                                 # 00514881
    jmp.d8 L_0051488f                            # 00514884
L_00514886:
    # block 0x00514886: entered by je at 0x00514771; je at 0x0051477f, 2 instruction(s), calls KERNEL32.dll!UnhandledExceptionFilter, falls into the block at 0x0051488f
    push dword ptr [ebp + arg_c]                 # 00514886
    call dword ptr [0x52a180]                    # 00514889
L_0051488f:
    # block 0x0051488f: entered by jmp at 0x00514791; jmp at 0x00514884, 4 instruction(s), ends with ret
    pop esi                                      # 0051488f
    pop ebx                                      # 00514890
    leave                                        # 00514891
    ret                                          # 00514892

