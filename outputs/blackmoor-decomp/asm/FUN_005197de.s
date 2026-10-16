# FUN_005197de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005197de
# extent:       0x005197de-0x00519965 (391 code bytes)
# span:         0x005197de-0x00519965 (code 391, tables 0, padding 0)
# sha256:       2a95e7c5e62788c4225ded90df65b4b401ea2fcedb73715f7cde61ff303315c3
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005197de
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [edi + n] field_4; [esi + n] field_1; [scaled index + n] field_8
# callees:      calls FUN_0050fde2, FUN_005199bd, FUN_00519492, FUN_0050ea90, FUN_00519965, FUN_0050e936, FUN_0050ebca, FUN_00511f30, FUN_005128b0, KERNEL32.dll!SetEnvironmentVariableA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 155 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)
.set FUN_0050fde2, .text + (0x0050fde2 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_00519492, .text + (0x00519492 - 0x401000)
.set FUN_00519965, .text + (0x00519965 - 0x401000)
.set FUN_005199bd, .text + (0x005199bd - 0x401000)

.org 0x005197de - 0x401000
.globl FUN_005197de
FUN_005197de:
    # block 0x005197de: entry, 10 instruction(s), ends with je to 0x00519842 (forward)
    push ebp                                     # 005197de
    {load} mov ebp, esp                          # 005197df
    push ecx                                     # 005197e1
    push ecx                                     # 005197e2
    push ebx                                     # 005197e3
    push esi                                     # 005197e4
    push edi                                     # 005197e5
    {load} xor edi, edi                          # 005197e6
    cmp dword ptr [ebp + arg_8], edi             # 005197e8
    je.d8 L_00519842                             # 005197eb
    # block 0x005197ed: entered by fall-through of je at 0x005197eb, 9 instruction(s), calls FUN_0050fde2, ends with je to 0x00519842 (forward)
    push 0x3d                                    # 005197ed
    push dword ptr [ebp + arg_8]                 # 005197ef
    call FUN_0050fde2                            # 005197f2
    {load} mov esi, eax                          # 005197f7
    pop ecx                                      # 005197f9
    {load} cmp esi, edi                          # 005197fa
    pop ecx                                      # 005197fc
    mov dword ptr [ebp - local_8], esi           # 005197fd
    je.d8 L_00519842                             # 00519800
    # block 0x00519802: entered by fall-through of je at 0x00519800, 2 instruction(s), ends with je to 0x00519842 (forward)
    cmp dword ptr [ebp + arg_8], esi             # 00519802
    je.d8 L_00519842                             # 00519805
    # block 0x00519807: entered by fall-through of je at 0x00519805, 6 instruction(s), ends with jne to 0x00519828 (forward)
    mov eax, dword ptr [0x63ca2c]                # 00519807
    {load} xor ebx, ebx                          # 0051980c
    cmp byte ptr [esi + field_1], bl             # 0051980e
    sete bl                                      # 00519811
    cmp eax, dword ptr [0x63ca30]                # 00519814
    jne.d8 L_00519828                            # 0051981a
    # block 0x0051981c: entered by fall-through of jne at 0x0051981a, 4 instruction(s), calls FUN_005199bd, falls into the block at 0x00519828
    push eax                                     # 0051981c
    call FUN_005199bd                            # 0051981d
    pop ecx                                      # 00519822
    mov dword ptr [0x63ca2c], eax                # 00519823
L_00519828:
    # block 0x00519828: entered by jne at 0x0051981a, 2 instruction(s), ends with jne to 0x00519880 (forward)
    {load} cmp eax, edi                          # 00519828
    jne.d8 L_00519880                            # 0051982a
    # block 0x0051982c: entered by fall-through of jne at 0x0051982a, 2 instruction(s), ends with je to 0x0051984a (forward)
    cmp dword ptr [ebp + arg_c], edi             # 0051982c
    je.d8 L_0051984a                             # 0051982f
    # block 0x00519831: entered by fall-through of je at 0x0051982f, 2 instruction(s), ends with je to 0x0051984a (forward)
    cmp dword ptr [0x63ca34], edi                # 00519831
    je.d8 L_0051984a                             # 00519837
    # block 0x00519839: entered by fall-through of je at 0x00519837, 3 instruction(s), calls FUN_00519492, ends with je to 0x00519880 (forward)
    call FUN_00519492                            # 00519839
    test eax, eax                                # 0051983e
    je.d8 L_00519880                             # 00519840
L_00519842:
    # block 0x00519842: entered by je at 0x005197eb; je at 0x00519800; je at 0x00519805; je at 0x00519861; more, 1 instruction(s), falls into the block at 0x00519845
    or eax, -0x1                                 # 00519842
L_00519845:
    # block 0x00519845: entered by jmp at 0x00519960, 5 instruction(s), ends with ret
    pop edi                                      # 00519845
    pop esi                                      # 00519846
    pop ebx                                      # 00519847
    leave                                        # 00519848
    ret                                          # 00519849
L_0051984a:
    # block 0x0051984a: entered by je at 0x0051982f; je at 0x00519837, 2 instruction(s), ends with jne to 0x0051995e (forward)
    {load} cmp ebx, edi                          # 0051984a
    jne.d32 L_0051995e                           # 0051984c
    # block 0x00519852: entered by fall-through of jne at 0x0051984c, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x00519842 (backward)
    push 0x4                                     # 00519852
    call FUN_0050ea90                            # 00519854
    {load} cmp eax, edi                          # 00519859
    pop ecx                                      # 0051985b
    mov dword ptr [0x63ca2c], eax                # 0051985c
    je.d8 L_00519842                             # 00519861
    # block 0x00519863: entered by fall-through of je at 0x00519861, 3 instruction(s), ends with jne to 0x00519880 (forward)
    mov dword ptr [eax], edi                     # 00519863
    cmp dword ptr [0x63ca34], edi                # 00519865
    jne.d8 L_00519880                            # 0051986b
    # block 0x0051986d: entered by fall-through of jne at 0x0051986b, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x00519842 (backward)
    push 0x4                                     # 0051986d
    call FUN_0050ea90                            # 0051986f
    {load} cmp eax, edi                          # 00519874
    pop ecx                                      # 00519876
    mov dword ptr [0x63ca34], eax                # 00519877
    je.d8 L_00519842                             # 0051987c
    # block 0x0051987e: entered by fall-through of je at 0x0051987c, 1 instruction(s), falls into the block at 0x00519880
    mov dword ptr [eax], edi                     # 0051987e
L_00519880:
    # block 0x00519880: entered by jne at 0x0051982a; je at 0x00519840; jne at 0x0051986b, 11 instruction(s), calls FUN_00519965, ends with jl to 0x005198e0 (forward)
    sub esi, dword ptr [ebp + arg_8]             # 00519880
    mov edi, dword ptr [0x63ca2c]                # 00519883
    mov dword ptr [ebp - local_4], edi           # 00519889
    push esi                                     # 0051988c
    push dword ptr [ebp + arg_8]                 # 0051988d
    call FUN_00519965                            # 00519890
    {load} mov esi, eax                          # 00519895
    pop ecx                                      # 00519897
    test esi, esi                                # 00519898
    pop ecx                                      # 0051989a
    jl.d8 L_005198e0                             # 0051989b
    # block 0x0051989d: entered by fall-through of jl at 0x0051989b, 2 instruction(s), ends with je to 0x005198e0 (forward)
    cmp dword ptr [edi], 0x0                     # 0051989d
    je.d8 L_005198e0                             # 005198a0
    # block 0x005198a2: entered by fall-through of je at 0x005198a0, 2 instruction(s), ends with je to 0x005198d8 (forward)
    test ebx, ebx                                # 005198a2
    je.d8 L_005198d8                             # 005198a4
    # block 0x005198a6: entered by fall-through of je at 0x005198a4, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x005198b2
    push dword ptr [edi + 4*esi]                 # 005198a6
    lea edi, [edi + 4*esi]                       # 005198a9
    call FUN_0050e936                            # 005198ac
    pop ecx                                      # 005198b1
L_005198b2:
    # block 0x005198b2: entered by jmp at 0x005198c0, 2 instruction(s), ends with je to 0x005198c2 (forward)
    cmp dword ptr [edi], 0x0                     # 005198b2
    je.d8 L_005198c2                             # 005198b5
    # block 0x005198b7: entered by fall-through of je at 0x005198b5, 5 instruction(s), ends with backward jump to 0x005198b2
    mov eax, dword ptr [edi + field_4]           # 005198b7
    inc esi                                      # 005198ba
    mov dword ptr [edi], eax                     # 005198bb
    add edi, 0x4                                 # 005198bd
    jmp.d8 L_005198b2                            # 005198c0
L_005198c2:
    # block 0x005198c2: entered by je at 0x005198b5, 9 instruction(s), calls FUN_0050ebca, ends with je to 0x00519912 (forward)
    {load} mov eax, esi                          # 005198c2
    shl eax, 0x2                                 # 005198c4
    push eax                                     # 005198c7
    push dword ptr [ebp - local_4]               # 005198c8
    call FUN_0050ebca                            # 005198cb
    pop ecx                                      # 005198d0
    test eax, eax                                # 005198d1
    pop ecx                                      # 005198d3
    je.d8 L_00519912                             # 005198d4
    # block 0x005198d6: entered by fall-through of je at 0x005198d4, 1 instruction(s), ends with forward jump to 0x0051990d
    jmp.d8 L_0051990d                            # 005198d6
L_005198d8:
    # block 0x005198d8: entered by je at 0x005198a4, 3 instruction(s), ends with forward jump to 0x00519912
    mov eax, dword ptr [ebp + arg_8]             # 005198d8
    mov dword ptr [edi + 4*esi], eax             # 005198db
    jmp.d8 L_00519912                            # 005198de
L_005198e0:
    # block 0x005198e0: entered by jl at 0x0051989b; je at 0x005198a0, 2 instruction(s), ends with jne to 0x0051995e (forward)
    test ebx, ebx                                # 005198e0
    jne.d8 L_0051995e                            # 005198e2
    # block 0x005198e4: entered by fall-through of jne at 0x005198e2, 2 instruction(s), ends with jge to 0x005198ea (forward)
    test esi, esi                                # 005198e4
    jge.d8 L_005198ea                            # 005198e6
    # block 0x005198e8: entered by fall-through of jge at 0x005198e6, 1 instruction(s), falls into the block at 0x005198ea
    neg esi                                      # 005198e8
L_005198ea:
    # block 0x005198ea: entered by jge at 0x005198e6, 8 instruction(s), calls FUN_0050ebca, ends with je to 0x00519842 (backward)
    lea eax, [4*esi + field_8]                   # 005198ea
    push eax                                     # 005198f1
    push edi                                     # 005198f2
    call FUN_0050ebca                            # 005198f3
    pop ecx                                      # 005198f8
    test eax, eax                                # 005198f9
    pop ecx                                      # 005198fb
    je.d32 L_00519842                            # 005198fc
    # block 0x00519902: entered by fall-through of je at 0x005198fc, 3 instruction(s), falls into the block at 0x0051990d
    mov ecx, dword ptr [ebp + arg_8]             # 00519902
    mov dword ptr [eax + 4*esi], ecx             # 00519905
    and dword ptr [eax + 4*esi + field_4], 0x0   # 00519908
L_0051990d:
    # block 0x0051990d: entered by jmp at 0x005198d6, 1 instruction(s), falls into the block at 0x00519912
    mov dword ptr [0x63ca2c], eax                # 0051990d
L_00519912:
    # block 0x00519912: entered by je at 0x005198d4; jmp at 0x005198de, 2 instruction(s), ends with je to 0x0051995e (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 00519912
    je.d8 L_0051995e                             # 00519916
    # block 0x00519918: entered by fall-through of je at 0x00519916, 11 instruction(s), calls FUN_00511f30, FUN_0050ea90, ends with je to 0x0051995e (forward)
    push dword ptr [ebp + arg_8]                 # 00519918
    call FUN_00511f30                            # 0051991b
    inc eax                                      # 00519920
    inc eax                                      # 00519921
    push eax                                     # 00519922
    call FUN_0050ea90                            # 00519923
    {load} mov esi, eax                          # 00519928
    pop ecx                                      # 0051992a
    test esi, esi                                # 0051992b
    pop ecx                                      # 0051992d
    je.d8 L_0051995e                             # 0051992e
    # block 0x00519930: entered by fall-through of je at 0x0051992e, 20 instruction(s), calls FUN_005128b0, KERNEL32.dll!SetEnvironmentVariableA, FUN_0050e936, falls into the block at 0x0051995e
    push dword ptr [ebp + arg_8]                 # 00519930
    push esi                                     # 00519933
    call FUN_005128b0                            # 00519934
    {load} mov eax, esi                          # 00519939
    pop ecx                                      # 0051993b
    sub eax, dword ptr [ebp + arg_8]             # 0051993c
    pop ecx                                      # 0051993f
    add eax, dword ptr [ebp - local_8]           # 00519940
    and byte ptr [eax], 0x0                      # 00519943
    inc eax                                      # 00519946
    neg ebx                                      # 00519947
    {load} sbb ebx, ebx                          # 00519949
    not ebx                                      # 0051994b
    {load} and ebx, eax                          # 0051994d
    push ebx                                     # 0051994f
    push esi                                     # 00519950
    call dword ptr [0x52a1c8]                    # 00519951
    push esi                                     # 00519957
    call FUN_0050e936                            # 00519958
    pop ecx                                      # 0051995d
L_0051995e:
    # block 0x0051995e: entered by jne at 0x0051984c; jne at 0x005198e2; je at 0x00519916; je at 0x0051992e, 2 instruction(s), ends with backward jump to 0x00519845
    {load} xor eax, eax                          # 0051995e
    jmp.d32 L_00519845                           # 00519960

