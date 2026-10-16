# FUN_00511928
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511928
# extent:       0x00511928-0x005119ed (197 code bytes)
# span:         0x00511928-0x005119ed (code 197, tables 0, padding 0)
# sha256:       26ed5d7b62aaf52bf9be69bfa65020a7f881618e7060494422438a75b52b02ad
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005118b3 (+0x75)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511928
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_8; [ebx + n] field_8, field_c, field_10, field_minus_4; [edi + n] field_4, field_8
# callees:      calls FUN_0050c950, FUN_0050c992, FUN_0050ca26; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 79 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050c950, .text + (0x0050c950 - 0x401000)
.set FUN_0050c992, .text + (0x0050c992 - 0x401000)
.set FUN_0050ca26, .text + (0x0050ca26 - 0x401000)

.org 0x00511928 - 0x401000
.globl FUN_00511928
FUN_00511928:
    # block 0x00511928: entry, 18 instruction(s), ends with jne to 0x005119d0 (forward)
    push esi                                     # 00511928
    inc ebx                                      # 00511929
    xor dh, byte ptr [eax]                       # 0051192a
    pop eax                                      # 0051192c
    inc ebx                                      # 0051192d
    xor byte ptr [eax], dh                       # 0051192e
    push ebp                                     # 00511930
    {load} mov ebp, esp                          # 00511931
    sub esp, 0x8                                 # 00511933
    push ebx                                     # 00511936
    push esi                                     # 00511937
    push edi                                     # 00511938
    push ebp                                     # 00511939
    cld                                          # 0051193a
    mov ebx, dword ptr [ebp + field_c]           # 0051193b
    mov eax, dword ptr [ebp + field_8]           # 0051193e
    test dword ptr [eax + field_4], 0x6          # 00511941
    jne.d32 L_005119d0                           # 00511948
    # block 0x0051194e: entered by fall-through of jne at 0x00511948, 7 instruction(s), falls into the block at 0x00511963
    mov dword ptr [ebp - field_minus_8], eax     # 0051194e
    mov eax, dword ptr [ebp + field_10]          # 00511951
    mov dword ptr [ebp - field_minus_4], eax     # 00511954
    lea eax, [ebp - field_minus_8]               # 00511957
    mov dword ptr [ebx - field_minus_4], eax     # 0051195a
    mov esi, dword ptr [ebx + field_c]           # 0051195d
    mov edi, dword ptr [ebx + field_8]           # 00511960
L_00511963:
    # block 0x00511963: entered by jmp at 0x005119c0, 2 instruction(s), ends with je to 0x005119c9 (forward)
    cmp esi, -0x1                                # 00511963
    je.d8 L_005119c9                             # 00511966
    # block 0x00511968: entered by fall-through of je at 0x00511966, 3 instruction(s), ends with je to 0x005119b7 (forward)
    lea ecx, [esi + 2*esi]                       # 00511968
    cmp dword ptr [edi + 4*ecx + field_4], 0x0   # 0051196b
    je.d8 L_005119b7                             # 00511970
    # block 0x00511972: entered by fall-through of je at 0x00511970, 9 instruction(s), calls indirect dword ptr [edi + 4*ecx + 0x4], ends with je to 0x005119b7 (forward)
    push esi                                     # 00511972
    push ebp                                     # 00511973
    lea ebp, [ebx + field_10]                    # 00511974
    call dword ptr [edi + 4*ecx + field_4]       # 00511977
    pop ebp                                      # 0051197b
    pop esi                                      # 0051197c
    mov ebx, dword ptr [ebp + field_c]           # 0051197d
    {load} or eax, eax                           # 00511980
    je.d8 L_005119b7                             # 00511982
    # block 0x00511984: entered by fall-through of je at 0x00511982, 1 instruction(s), ends with js to 0x005119c2 (forward)
    js.d8 L_005119c2                             # 00511984
    # block 0x00511986: entered by fall-through of js at 0x00511984, 16 instruction(s), calls FUN_0050c950, FUN_0050c992, FUN_0050ca26, indirect dword ptr [edi + 4*ecx + 0x8], falls into the block at 0x005119b7
    mov edi, dword ptr [ebx + field_8]           # 00511986
    push ebx                                     # 00511989
    call FUN_0050c950                            # 0051198a
    add esp, 0x4                                 # 0051198f
    lea ebp, [ebx + field_10]                    # 00511992
    push esi                                     # 00511995
    push ebx                                     # 00511996
    call FUN_0050c992                            # 00511997
    add esp, 0x8                                 # 0051199c
    lea ecx, [esi + 2*esi]                       # 0051199f
    push 0x1                                     # 005119a2
    mov eax, dword ptr [edi + 4*ecx + field_8]   # 005119a4
    call FUN_0050ca26                            # 005119a8
    mov eax, dword ptr [edi + 4*ecx]             # 005119ad
    mov dword ptr [ebx + field_c], eax           # 005119b0
    call dword ptr [edi + 4*ecx + field_8]       # 005119b3
L_005119b7:
    # block 0x005119b7: entered by je at 0x00511970; je at 0x00511982, 4 instruction(s), ends with backward jump to 0x00511963
    mov edi, dword ptr [ebx + field_8]           # 005119b7
    lea ecx, [esi + 2*esi]                       # 005119ba
    mov esi, dword ptr [edi + 4*ecx]             # 005119bd
    jmp.d8 L_00511963                            # 005119c0
L_005119c2:
    # block 0x005119c2: entered by js at 0x00511984, 2 instruction(s), ends with forward jump to 0x005119e5
    mov eax, 0x0                                 # 005119c2
    jmp.d8 L_005119e5                            # 005119c7
L_005119c9:
    # block 0x005119c9: entered by je at 0x00511966, 2 instruction(s), ends with forward jump to 0x005119e5
    mov eax, 0x1                                 # 005119c9
    jmp.d8 L_005119e5                            # 005119ce
L_005119d0:
    # block 0x005119d0: entered by jne at 0x00511948, 8 instruction(s), calls FUN_0050c992, falls into the block at 0x005119e5
    push ebp                                     # 005119d0
    lea ebp, [ebx + field_10]                    # 005119d1
    push -0x1                                    # 005119d4
    push ebx                                     # 005119d6
    call FUN_0050c992                            # 005119d7
    add esp, 0x8                                 # 005119dc
    pop ebp                                      # 005119df
    mov eax, 0x1                                 # 005119e0
L_005119e5:
    # block 0x005119e5: entered by jmp at 0x005119c7; jmp at 0x005119ce, 7 instruction(s), ends with ret
    pop ebp                                      # 005119e5
    pop edi                                      # 005119e6
    pop esi                                      # 005119e7
    pop ebx                                      # 005119e8
    {load} mov esp, ebp                          # 005119e9
    pop ebp                                      # 005119eb
    ret                                          # 005119ec

