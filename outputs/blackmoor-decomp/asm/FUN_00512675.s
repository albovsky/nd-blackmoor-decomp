# FUN_00512675
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512675
# extent:       0x00512675-0x005127e5 (368 code bytes)
# span:         0x00512675-0x005127e5 (code 368, tables 0, padding 0)
# sha256:       7c51fd8562b17a5551e3a6d5ca892522c86dc7c9226c93712c984c5a4d8b110a
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512675
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_1c; [edi + n] field_1
# callees:      calls FUN_0051779c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051779c, .text + (0x0051779c - 0x401000)

.org 0x00512675 - 0x401000
.globl FUN_00512675
FUN_00512675:
    # block 0x00512675: entry, 15 instruction(s), ends with je to 0x005126ae (forward)
    push ebp                                     # 00512675
    {load} mov ebp, esp                          # 00512676
    push ecx                                     # 00512678
    push ecx                                     # 00512679
    push ebx                                     # 0051267a
    push esi                                     # 0051267b
    mov esi, dword ptr [0x63cd14]                # 0051267c
    push edi                                     # 00512682
    mov edi, dword ptr [ebp + arg_c]             # 00512683
    {load} xor ebx, ebx                          # 00512686
    mov dword ptr [ebp - local_8], ebx           # 00512688
    mov dword ptr [ebp - local_4], ebx           # 0051268b
    mov al, byte ptr [edi]                       # 0051268e
    cmp al, 0x61                                 # 00512690
    je.d8 L_005126ae                             # 00512692
    # block 0x00512694: entered by fall-through of je at 0x00512692, 2 instruction(s), ends with je to 0x005126a7 (forward)
    cmp al, 0x72                                 # 00512694
    je.d8 L_005126a7                             # 00512696
    # block 0x00512698: entered by fall-through of je at 0x00512696, 2 instruction(s), ends with jne to 0x005127c2 (forward)
    cmp al, 0x77                                 # 00512698
    jne.d32 L_005127c2                           # 0051269a
    # block 0x005126a0: entered by fall-through of jne at 0x0051269a, 2 instruction(s), ends with forward jump to 0x005126b3
    mov ecx, 0x301                               # 005126a0
    jmp.d8 L_005126b3                            # 005126a5
L_005126a7:
    # block 0x005126a7: entered by je at 0x00512696, 3 instruction(s), ends with forward jump to 0x005126b6
    {load} xor ecx, ecx                          # 005126a7
    or esi, 0x1                                  # 005126a9
    jmp.d8 L_005126b6                            # 005126ac
L_005126ae:
    # block 0x005126ae: entered by je at 0x00512692, 1 instruction(s), falls into the block at 0x005126b3
    mov ecx, 0x109                               # 005126ae
L_005126b3:
    # block 0x005126b3: entered by jmp at 0x005126a5, 1 instruction(s), falls into the block at 0x005126b6
    or esi, 0x2                                  # 005126b3
L_005126b6:
    # block 0x005126b6: entered by jmp at 0x005126ac, 2 instruction(s), falls into the block at 0x005126b9
    push 0x1                                     # 005126b6
    pop edx                                      # 005126b8
L_005126b9:
    # block 0x005126b9: entered by jmp at 0x00512700; jmp at 0x00512715; jmp at 0x0051271f; jmp at 0x00512735; more, 4 instruction(s), ends with je to 0x005127a8 (forward)
    mov al, byte ptr [edi + field_1]             # 005126b9
    inc edi                                      # 005126bc
    {load} cmp al, bl                            # 005126bd
    je.d32 L_005127a8                            # 005126bf
    # block 0x005126c5: entered by fall-through of je at 0x005126bf, 2 instruction(s), ends with je to 0x005127a8 (forward)
    {load} cmp edx, ebx                          # 005126c5
    je.d32 L_005127a8                            # 005126c7
    # block 0x005126cd: entered by fall-through of je at 0x005126c7, 3 instruction(s), ends with jg to 0x00512747 (forward)
    movsx eax, al                                # 005126cd
    cmp eax, 0x54                                # 005126d0
    jg.d8 L_00512747                             # 005126d3
    # block 0x005126d5: entered by fall-through of jg at 0x005126d3, 1 instruction(s), ends with je to 0x00512737 (forward)
    je.d8 L_00512737                             # 005126d5
    # block 0x005126d7: entered by fall-through of je at 0x005126d5, 2 instruction(s), ends with je to 0x00512721 (forward)
    sub eax, 0x2b                                # 005126d7
    je.d8 L_00512721                             # 005126da
    # block 0x005126dc: entered by fall-through of je at 0x005126da, 2 instruction(s), ends with je to 0x00512717 (forward)
    sub eax, 0x19                                # 005126dc
    je.d8 L_00512717                             # 005126df
    # block 0x005126e1: entered by fall-through of je at 0x005126df, 2 instruction(s), ends with je to 0x00512702 (forward)
    sub eax, 0xe                                 # 005126e1
    je.d8 L_00512702                             # 005126e4
    # block 0x005126e6: entered by fall-through of je at 0x005126e4, 2 instruction(s), ends with jne to 0x00512799 (forward)
    dec eax                                      # 005126e6
    jne.d32 L_00512799                           # 005126e7
    # block 0x005126ed: entered by fall-through of jne at 0x005126e7, 2 instruction(s), ends with jne to 0x00512799 (forward)
    cmp dword ptr [ebp - local_4], ebx           # 005126ed
    jne.d32 L_00512799                           # 005126f0
    # block 0x005126f6: entered by fall-through of jne at 0x005126f0, 3 instruction(s), ends with backward jump to 0x005126b9
    mov dword ptr [ebp - local_4], 0x1           # 005126f6
    or ecx, 0x20                                 # 005126fd
    jmp.d8 L_005126b9                            # 00512700
L_00512702:
    # block 0x00512702: entered by je at 0x005126e4, 2 instruction(s), ends with jne to 0x00512799 (forward)
    cmp dword ptr [ebp - local_4], ebx           # 00512702
    jne.d32 L_00512799                           # 00512705
    # block 0x0051270b: entered by fall-through of jne at 0x00512705, 3 instruction(s), ends with backward jump to 0x005126b9
    mov dword ptr [ebp - local_4], 0x1           # 0051270b
    or ecx, 0x10                                 # 00512712
    jmp.d8 L_005126b9                            # 00512715
L_00512717:
    # block 0x00512717: entered by je at 0x005126df, 2 instruction(s), ends with jne to 0x00512799 (forward)
    test cl, 0x40                                # 00512717
    jne.d8 L_00512799                            # 0051271a
    # block 0x0051271c: entered by fall-through of jne at 0x0051271a, 2 instruction(s), ends with backward jump to 0x005126b9
    or ecx, 0x40                                 # 0051271c
    jmp.d8 L_005126b9                            # 0051271f
L_00512721:
    # block 0x00512721: entered by je at 0x005126da, 2 instruction(s), ends with jne to 0x00512799 (forward)
    test cl, 0x2                                 # 00512721
    jne.d8 L_00512799                            # 00512724
    # block 0x00512726: entered by fall-through of jne at 0x00512724, 5 instruction(s), ends with backward jump to 0x005126b9
    and ecx, -0x2                                # 00512726
    and esi, -0x4                                # 00512729
    or ecx, 0x2                                  # 0051272c
    or esi, 0x80                                 # 0051272f
    jmp.d8 L_005126b9                            # 00512735
L_00512737:
    # block 0x00512737: entered by je at 0x005126d5, 3 instruction(s), ends with jne to 0x00512799 (forward)
    mov eax, 0x1000                              # 00512737
    test eax, ecx                                # 0051273c
    jne.d8 L_00512799                            # 0051273e
    # block 0x00512740: entered by fall-through of jne at 0x0051273e, 2 instruction(s), ends with backward jump to 0x005126b9
    {load} or ecx, eax                           # 00512740
    jmp.d32 L_005126b9                           # 00512742
L_00512747:
    # block 0x00512747: entered by jg at 0x005126d3, 2 instruction(s), ends with je to 0x00512794 (forward)
    sub eax, 0x62                                # 00512747
    je.d8 L_00512794                             # 0051274a
    # block 0x0051274c: entered by fall-through of je at 0x0051274a, 2 instruction(s), ends with je to 0x0051277d (forward)
    dec eax                                      # 0051274c
    je.d8 L_0051277d                             # 0051274d
    # block 0x0051274f: entered by fall-through of je at 0x0051274d, 2 instruction(s), ends with je to 0x00512766 (forward)
    sub eax, 0xb                                 # 0051274f
    je.d8 L_00512766                             # 00512752
    # block 0x00512754: entered by fall-through of je at 0x00512752, 2 instruction(s), ends with jne to 0x00512799 (forward)
    sub eax, 0x6                                 # 00512754
    jne.d8 L_00512799                            # 00512757
    # block 0x00512759: entered by fall-through of jne at 0x00512757, 2 instruction(s), ends with jne to 0x00512799 (forward)
    test ch, -0x40                               # 00512759
    jne.d8 L_00512799                            # 0051275c
    # block 0x0051275e: entered by fall-through of jne at 0x0051275c, 2 instruction(s), ends with backward jump to 0x005126b9
    or ch, 0x40                                  # 0051275e
    jmp.d32 L_005126b9                           # 00512761
L_00512766:
    # block 0x00512766: entered by je at 0x00512752, 2 instruction(s), ends with jne to 0x00512799 (forward)
    cmp dword ptr [ebp - local_8], ebx           # 00512766
    jne.d8 L_00512799                            # 00512769
    # block 0x0051276b: entered by fall-through of jne at 0x00512769, 3 instruction(s), ends with backward jump to 0x005126b9
    mov dword ptr [ebp - local_8], 0x1           # 0051276b
    and esi, 0xffffbfff                          # 00512772
    jmp.d32 L_005126b9                           # 00512778
L_0051277d:
    # block 0x0051277d: entered by je at 0x0051274d, 2 instruction(s), ends with jne to 0x00512799 (forward)
    cmp dword ptr [ebp - local_8], ebx           # 0051277d
    jne.d8 L_00512799                            # 00512780
    # block 0x00512782: entered by fall-through of jne at 0x00512780, 3 instruction(s), ends with backward jump to 0x005126b9
    mov dword ptr [ebp - local_8], 0x1           # 00512782
    or esi, 0x4000                               # 00512789
    jmp.d32 L_005126b9                           # 0051278f
L_00512794:
    # block 0x00512794: entered by je at 0x0051274a, 2 instruction(s), ends with je to 0x005127a0 (forward)
    test ch, -0x40                               # 00512794
    je.d8 L_005127a0                             # 00512797
L_00512799:
    # block 0x00512799: entered by jne at 0x005126e7; jne at 0x005126f0; jne at 0x00512705; jne at 0x0051271a; more, 2 instruction(s), ends with backward jump to 0x005126b9
    {load} xor edx, edx                          # 00512799
    jmp.d32 L_005126b9                           # 0051279b
L_005127a0:
    # block 0x005127a0: entered by je at 0x00512797, 2 instruction(s), ends with backward jump to 0x005126b9
    or ch, -0x80                                 # 005127a0
    jmp.d32 L_005126b9                           # 005127a3
L_005127a8:
    # block 0x005127a8: entered by je at 0x005126bf; je at 0x005126c7, 9 instruction(s), calls FUN_0051779c, ends with jge to 0x005127c6 (forward)
    push 0x1a4                                   # 005127a8
    push dword ptr [ebp + arg_10]                # 005127ad
    push ecx                                     # 005127b0
    push dword ptr [ebp + arg_8]                 # 005127b1
    call FUN_0051779c                            # 005127b4
    {load} mov ecx, eax                          # 005127b9
    add esp, 0x10                                # 005127bb
    {load} cmp ecx, ebx                          # 005127be
    jge.d8 L_005127c6                            # 005127c0
L_005127c2:
    # block 0x005127c2: entered by jne at 0x0051269a; fall-through of jge at 0x005127c0, 2 instruction(s), ends with forward jump to 0x005127e0
    {load} xor eax, eax                          # 005127c2
    jmp.d8 L_005127e0                            # 005127c4
L_005127c6:
    # block 0x005127c6: entered by jge at 0x005127c0, 8 instruction(s), falls into the block at 0x005127e0
    mov eax, dword ptr [ebp + arg_14]            # 005127c6
    inc dword ptr [0x63ca9c]                     # 005127c9
    mov dword ptr [eax + field_c], esi           # 005127cf
    mov dword ptr [eax + field_4], ebx           # 005127d2
    mov dword ptr [eax], ebx                     # 005127d5
    mov dword ptr [eax + field_8], ebx           # 005127d7
    mov dword ptr [eax + field_1c], ebx          # 005127da
    mov dword ptr [eax + field_10], ecx          # 005127dd
L_005127e0:
    # block 0x005127e0: entered by jmp at 0x005127c4, 5 instruction(s), ends with ret
    pop edi                                      # 005127e0
    pop esi                                      # 005127e1
    pop ebx                                      # 005127e2
    leave                                        # 005127e3
    ret                                          # 005127e4

