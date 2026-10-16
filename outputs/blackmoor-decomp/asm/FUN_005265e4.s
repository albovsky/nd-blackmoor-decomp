# FUN_005265e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005265e4
# extent:       0x005265e4-0x005267ed (521 code bytes)
# span:         0x005265e4-0x005267ed (code 521, tables 0, padding 0)
# sha256:       a9c7c53501246ae1daf9f9c35a572ae92905954c61a7c616739e5479f45d9119
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005265e4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c; [ebp + n] field_8, field_b, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_60, field_minus_bc, field_minus_104, field_minus_160; [edi + n] field_94, field_98; [esi + n] field_2, field_4, field_6
# callees:      calls FUN_0050f978, KERNEL32.dll!GlobalLock, FUN_00519cdf, FUN_00519f30, FUN_005211ff, FUN_00519e77, FUN_00519eb4, FUN_0051e7ba, FUN_00519ef2, FUN_0051de13; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 152 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005267ed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_60, 0x60  # offset -0x60
.equ field_minus_bc, 0xbc  # offset -0xbc
.equ field_minus_104, 0x104  # offset -0x104
.equ field_minus_160, 0x160  # offset -0x160
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_b, 0xb  # offset +0xb
.equ field_c, 0xc  # offset +0xc
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00519cdf, .text + (0x00519cdf - 0x401000)
.set FUN_00519e77, .text + (0x00519e77 - 0x401000)
.set FUN_00519eb4, .text + (0x00519eb4 - 0x401000)
.set FUN_00519ef2, .text + (0x00519ef2 - 0x401000)
.set FUN_00519f30, .text + (0x00519f30 - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_005211ff, .text + (0x005211ff - 0x401000)

.org 0x005265e4 - 0x401000
.globl FUN_005265e4
FUN_005265e4:
    # block 0x005265e4: entry, 10 instruction(s), calls FUN_0050f978, ends with jne to 0x0052676e (forward)
    mov eax, 0x528e1a                            # 005265e4
    call FUN_0050f978                            # 005265e9
    sub esp, 0x154                               # 005265ee
    push ebx                                     # 005265f4
    {load} xor ebx, ebx                          # 005265f5
    cmp dword ptr [ebp + field_8], ebx           # 005265f7
    push esi                                     # 005265fa
    push edi                                     # 005265fb
    {load} mov edi, ecx                          # 005265fc
    jne.d32 L_0052676e                           # 005265fe
    # block 0x00526604: entered by fall-through of jne at 0x005265fe, 3 instruction(s), ends with je to 0x0052676e (forward)
    mov eax, dword ptr [edi + field_98]          # 00526604
    {load} cmp eax, ebx                          # 0052660a
    je.d32 L_0052676e                            # 0052660c
    # block 0x00526612: entered by fall-through of je at 0x0052660c, 5 instruction(s), calls KERNEL32.dll!GlobalLock, ends with je to 0x005267dc (forward)
    push eax                                     # 00526612
    call dword ptr [0x52a204]                    # 00526613
    {load} mov esi, eax                          # 00526619
    test byte ptr [esi + field_6], 0x1           # 0052661b
    je.d32 L_005267dc                            # 0052661f
    # block 0x00526625: entered by fall-through of je at 0x0052661f, 11 instruction(s), calls FUN_00519cdf, FUN_00519f30, ends with jne to 0x0052667c (forward)
    push ebx                                     # 00526625
    push 0x14000c                                # 00526626
    push 0x1                                     # 0052662b
    lea ecx, [ebp - field_minus_bc]              # 0052662d
    call FUN_00519cdf                            # 00526633
    lea ecx, [ebp - field_minus_bc]              # 00526638
    mov dword ptr [ebp - field_minus_4], ebx     # 0052663e
    call FUN_00519f30                            # 00526641
    mov eax, dword ptr [ebp - field_minus_60]    # 00526646
    cmp dword ptr [eax + field_c], ebx           # 00526649
    jne.d8 L_0052667c                            # 0052664c
    # block 0x0052664e: entered by fall-through of jne at 0x0052664c, 4 instruction(s), ends with je to 0x00526664 (forward)
    mov eax, dword ptr [edi + field_94]          # 0052664e
    lea esi, [edi + field_94]                    # 00526654
    {load} cmp eax, ebx                          # 0052665a
    je.d8 L_00526664                             # 0052665c
    # block 0x0052665e: entered by fall-through of je at 0x0052665c, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00526664
    push eax                                     # 0052665e
    call FUN_005211ff                            # 0052665f
L_00526664:
    # block 0x00526664: entered by je at 0x0052665c, 5 instruction(s), calls FUN_005211ff, ends with forward jump to 0x00526762
    push dword ptr [edi + field_98]              # 00526664
    call FUN_005211ff                            # 0052666a
    mov dword ptr [esi], ebx                     # 0052666f
    mov dword ptr [edi + field_98], ebx          # 00526671
    jmp.d32 L_00526762                           # 00526677
L_0052667c:
    # block 0x0052667c: entered by jne at 0x0052664c, 13 instruction(s), calls FUN_00519e77, indirect ebx, ends with jne to 0x005266fc (forward)
    lea eax, [ebp - field_minus_10]              # 0052667c
    lea ecx, [ebp - field_minus_bc]              # 0052667f
    push eax                                     # 00526685
    call FUN_00519e77                            # 00526686
    push dword ptr [eax]                         # 0052668b
    mov ebx, dword ptr [0x52a1e4]                # 0052668d
    movzx eax, word ptr [esi]                    # 00526693
    {load} add eax, esi                          # 00526696
    mov byte ptr [ebp - field_minus_4], 0x1      # 00526698
    push eax                                     # 0052669c
    call ebx                                     # 0052669d
    test eax, eax                                # 0052669f
    jne.d8 L_005266fc                            # 005266a1
    # block 0x005266a3: entered by fall-through of jne at 0x005266a1, 15 instruction(s), calls FUN_00519eb4, indirect ebx, FUN_0051e7ba, ends with jne to 0x005266fc (forward)
    lea eax, [ebp - field_minus_14]              # 005266a3
    lea ecx, [ebp - field_minus_bc]              # 005266a6
    push eax                                     # 005266ac
    call FUN_00519eb4                            # 005266ad
    push dword ptr [eax]                         # 005266b2
    movzx eax, word ptr [esi + field_2]          # 005266b4
    {load} add eax, esi                          # 005266b8
    push eax                                     # 005266ba
    call ebx                                     # 005266bb
    test eax, eax                                # 005266bd
    lea ecx, [ebp - field_minus_14]              # 005266bf
    setne byte ptr [ebp + field_b]               # 005266c2
    call FUN_0051e7ba                            # 005266c6
    cmp byte ptr [ebp + field_b], 0x0            # 005266cb
    jne.d8 L_005266fc                            # 005266cf
    # block 0x005266d1: entered by fall-through of jne at 0x005266cf, 15 instruction(s), calls FUN_00519ef2, indirect ebx, FUN_0051e7ba, ends with je to 0x005266fe (forward)
    lea eax, [ebp - field_minus_18]              # 005266d1
    lea ecx, [ebp - field_minus_bc]              # 005266d4
    push eax                                     # 005266da
    call FUN_00519ef2                            # 005266db
    push dword ptr [eax]                         # 005266e0
    movzx eax, word ptr [esi + field_4]          # 005266e2
    {load} add eax, esi                          # 005266e6
    push eax                                     # 005266e8
    call ebx                                     # 005266e9
    test eax, eax                                # 005266eb
    lea ecx, [ebp - field_minus_18]              # 005266ed
    setne bl                                     # 005266f0
    call FUN_0051e7ba                            # 005266f3
    test bl, bl                                  # 005266f8
    je.d8 L_005266fe                             # 005266fa
L_005266fc:
    # block 0x005266fc: entered by jne at 0x005266a1; jne at 0x005266cf; fall-through of je at 0x005266fa, 1 instruction(s), falls into the block at 0x005266fe
    mov bl, 0x1                                  # 005266fc
L_005266fe:
    # block 0x005266fe: entered by je at 0x005266fa, 5 instruction(s), calls FUN_0051e7ba, ends with je to 0x00526742 (forward)
    and byte ptr [ebp - field_minus_4], 0x0      # 005266fe
    lea ecx, [ebp - field_minus_10]              # 00526702
    call FUN_0051e7ba                            # 00526705
    test bl, bl                                  # 0052670a
    je.d8 L_00526742                             # 0052670c
    # block 0x0052670e: entered by fall-through of je at 0x0052670c, 4 instruction(s), ends with je to 0x00526724 (forward)
    mov eax, dword ptr [edi + field_94]          # 0052670e
    lea esi, [edi + field_94]                    # 00526714
    test eax, eax                                # 0052671a
    je.d8 L_00526724                             # 0052671c
    # block 0x0052671e: entered by fall-through of je at 0x0052671c, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00526724
    push eax                                     # 0052671e
    call FUN_005211ff                            # 0052671f
L_00526724:
    # block 0x00526724: entered by je at 0x0052671c, 8 instruction(s), calls FUN_005211ff, ends with forward jump to 0x00526762
    push dword ptr [edi + field_98]              # 00526724
    call FUN_005211ff                            # 0052672a
    mov eax, dword ptr [ebp - field_minus_60]    # 0052672f
    mov ecx, dword ptr [eax + field_8]           # 00526732
    mov dword ptr [esi], ecx                     # 00526735
    mov eax, dword ptr [eax + field_c]           # 00526737
    mov dword ptr [edi + field_98], eax          # 0052673a
    jmp.d8 L_00526762                            # 00526740
L_00526742:
    # block 0x00526742: entered by je at 0x0052670c, 4 instruction(s), ends with je to 0x00526752 (forward)
    mov eax, dword ptr [ebp - field_minus_60]    # 00526742
    mov eax, dword ptr [eax + field_8]           # 00526745
    test eax, eax                                # 00526748
    je.d8 L_00526752                             # 0052674a
    # block 0x0052674c: entered by fall-through of je at 0x0052674a, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00526752
    push eax                                     # 0052674c
    call FUN_005211ff                            # 0052674d
L_00526752:
    # block 0x00526752: entered by je at 0x0052674a, 4 instruction(s), ends with je to 0x00526762 (forward)
    mov eax, dword ptr [ebp - field_minus_60]    # 00526752
    mov eax, dword ptr [eax + field_c]           # 00526755
    test eax, eax                                # 00526758
    je.d8 L_00526762                             # 0052675a
    # block 0x0052675c: entered by fall-through of je at 0x0052675a, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00526762
    push eax                                     # 0052675c
    call FUN_005211ff                            # 0052675d
L_00526762:
    # block 0x00526762: entered by jmp at 0x00526677; jmp at 0x00526740; je at 0x0052675a, 3 instruction(s), ends with forward jump to 0x005267d7
    or dword ptr [ebp - field_minus_4], -0x1     # 00526762
    lea ecx, [ebp - field_minus_bc]              # 00526766
    jmp.d8 L_005267d7                            # 0052676c
L_0052676e:
    # block 0x0052676e: entered by jne at 0x005265fe; je at 0x0052660c, 11 instruction(s), calls FUN_00519cdf, FUN_00519f30, ends with je to 0x005267a3 (forward)
    push ebx                                     # 0052676e
    push 0x14000c                                # 0052676f
    push 0x1                                     # 00526774
    lea ecx, [ebp - field_minus_160]             # 00526776
    call FUN_00519cdf                            # 0052677c
    lea ecx, [ebp - field_minus_160]             # 00526781
    mov dword ptr [ebp - field_minus_4], 0x2     # 00526787
    call FUN_00519f30                            # 0052678e
    mov eax, dword ptr [edi + field_94]          # 00526793
    {load} cmp eax, ebx                          # 00526799
    je.d8 L_005267a3                             # 0052679b
    # block 0x0052679d: entered by fall-through of je at 0x0052679b, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x005267a3
    push eax                                     # 0052679d
    call FUN_005211ff                            # 0052679e
L_005267a3:
    # block 0x005267a3: entered by je at 0x0052679b, 4 instruction(s), ends with je to 0x005267b9 (forward)
    mov eax, dword ptr [edi + field_98]          # 005267a3
    lea esi, [edi + field_98]                    # 005267a9
    {load} cmp eax, ebx                          # 005267af
    je.d8 L_005267b9                             # 005267b1
    # block 0x005267b3: entered by fall-through of je at 0x005267b1, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x005267b9
    push eax                                     # 005267b3
    call FUN_005211ff                            # 005267b4
L_005267b9:
    # block 0x005267b9: entered by je at 0x005267b1, 7 instruction(s), falls into the block at 0x005267d7
    mov eax, dword ptr [ebp - field_minus_104]   # 005267b9
    or dword ptr [ebp - field_minus_4], -0x1     # 005267bf
    mov ecx, dword ptr [eax + field_8]           # 005267c3
    mov dword ptr [edi + field_94], ecx          # 005267c6
    mov eax, dword ptr [eax + field_c]           # 005267cc
    mov dword ptr [esi], eax                     # 005267cf
    lea ecx, [ebp - field_minus_160]             # 005267d1
L_005267d7:
    # block 0x005267d7: entered by jmp at 0x0052676c, 1 instruction(s), calls FUN_0051de13, falls into the block at 0x005267dc
    call FUN_0051de13                            # 005267d7
L_005267dc:
    # block 0x005267dc: entered by je at 0x0052661f, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 005267dc
    pop edi                                      # 005267df
    pop esi                                      # 005267e0
    pop ebx                                      # 005267e1
    mov dword ptr fs:[0x0], ecx                  # 005267e2
    leave                                        # 005267e9
    ret 0x4                                      # 005267ea

