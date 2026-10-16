# FUN_005128c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005128c0
# extent:       0x005128c0-0x005129a0 (224 code bytes)
# span:         0x005128c0-0x005129a0 (code 224, tables 0, padding 0)
# sha256:       1983be947d7c0e54d60eb69cb4a53a60bdda9a2e1f5aa53979a2328e6e0be248
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005128c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_minus_1, field_minus_2, field_minus_3, field_minus_4; [edi + n] field_2; [esp + n] stk_4, stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 84 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_3, 0x3  # offset -0x3
.equ field_minus_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x005128c0 - 0x401000
.globl FUN_005128c0
FUN_005128c0:
    # block 0x005128c0: entry, 4 instruction(s), ends with je to 0x005128dc (forward)
    mov ecx, dword ptr [esp + stk_4]             # 005128c0
    push edi                                     # 005128c4
    test ecx, 0x3                                # 005128c5
    je.d8 L_005128dc                             # 005128cb
L_005128cd:
    # block 0x005128cd: entered by jne at 0x005128da; fall-through of je at 0x005128cb, 4 instruction(s), ends with je to 0x0051290f (forward)
    mov al, byte ptr [ecx]                       # 005128cd
    inc ecx                                      # 005128cf
    test al, al                                  # 005128d0
    je.d8 L_0051290f                             # 005128d2
    # block 0x005128d4: entered by fall-through of je at 0x005128d2, 2 instruction(s), ends with jne to 0x005128cd (backward)
    test ecx, 0x3                                # 005128d4
    jne.d8 L_005128cd                            # 005128da
L_005128dc:
    # block 0x005128dc: entered by je at 0x005128cb; je at 0x005128f2; jmp at 0x0051290d; fall-through of jne at 0x005128da, 8 instruction(s), ends with je to 0x005128dc (backward)
    mov eax, dword ptr [ecx]                     # 005128dc
    mov edx, 0x7efefeff                          # 005128de
    {load} add edx, eax                          # 005128e3
    xor eax, -0x1                                # 005128e5
    {load} xor eax, edx                          # 005128e8
    add ecx, 0x4                                 # 005128ea
    test eax, 0x81010100                         # 005128ed
    je.d8 L_005128dc                             # 005128f2
    # block 0x005128f4: entered by fall-through of je at 0x005128f2, 3 instruction(s), ends with je to 0x0051291e (forward)
    mov eax, dword ptr [ecx - field_minus_4]     # 005128f4
    test al, al                                  # 005128f7
    je.d8 L_0051291e                             # 005128f9
    # block 0x005128fb: entered by fall-through of je at 0x005128f9, 2 instruction(s), ends with je to 0x00512919 (forward)
    test ah, ah                                  # 005128fb
    je.d8 L_00512919                             # 005128fd
    # block 0x005128ff: entered by fall-through of je at 0x005128fd, 2 instruction(s), ends with je to 0x00512914 (forward)
    test eax, 0xff0000                           # 005128ff
    je.d8 L_00512914                             # 00512904
    # block 0x00512906: entered by fall-through of je at 0x00512904, 2 instruction(s), ends with je to 0x0051290f (forward)
    test eax, 0xff000000                         # 00512906
    je.d8 L_0051290f                             # 0051290b
    # block 0x0051290d: entered by fall-through of je at 0x0051290b, 1 instruction(s), ends with backward jump to 0x005128dc
    jmp.d8 L_005128dc                            # 0051290d
L_0051290f:
    # block 0x0051290f: entered by je at 0x005128d2; je at 0x0051290b, 2 instruction(s), ends with forward jump to 0x00512921
    lea edi, [ecx - field_minus_1]               # 0051290f
    jmp.d8 L_00512921                            # 00512912
L_00512914:
    # block 0x00512914: entered by je at 0x00512904, 2 instruction(s), ends with forward jump to 0x00512921
    lea edi, [ecx - field_minus_2]               # 00512914
    jmp.d8 L_00512921                            # 00512917
L_00512919:
    # block 0x00512919: entered by je at 0x005128fd, 2 instruction(s), ends with forward jump to 0x00512921
    lea edi, [ecx - field_minus_3]               # 00512919
    jmp.d8 L_00512921                            # 0051291c
L_0051291e:
    # block 0x0051291e: entered by je at 0x005128f9, 1 instruction(s), falls into the block at 0x00512921
    lea edi, [ecx - field_minus_4]               # 0051291e
L_00512921:
    # block 0x00512921: entered by jmp at 0x00512912; jmp at 0x00512917; jmp at 0x0051291c, 3 instruction(s), ends with je to 0x00512946 (forward)
    mov ecx, dword ptr [esp + stk_c]             # 00512921
    test ecx, 0x3                                # 00512925
    je.d8 L_00512946                             # 0051292b
L_0051292d:
    # block 0x0051292d: entered by jne at 0x0051293d; fall-through of je at 0x0051292b, 4 instruction(s), ends with je to 0x00512998 (forward)
    mov dl, byte ptr [ecx]                       # 0051292d
    inc ecx                                      # 0051292f
    test dl, dl                                  # 00512930
    je.d8 L_00512998                             # 00512932
    # block 0x00512934: entered by fall-through of je at 0x00512932, 4 instruction(s), ends with jne to 0x0051292d (backward)
    mov byte ptr [edi], dl                       # 00512934
    inc edi                                      # 00512936
    test ecx, 0x3                                # 00512937
    jne.d8 L_0051292d                            # 0051293d
    # block 0x0051293f: entered by fall-through of jne at 0x0051293d, 1 instruction(s), ends with forward jump to 0x00512946
    jmp.d8 L_00512946                            # 0051293f
L_00512941:
    # block 0x00512941: entered by je at 0x0051295e; jmp at 0x00512978, 2 instruction(s), falls into the block at 0x00512946
    mov dword ptr [edi], edx                     # 00512941
    add edi, 0x4                                 # 00512943
L_00512946:
    # block 0x00512946: entered by je at 0x0051292b; jmp at 0x0051293f, 9 instruction(s), ends with je to 0x00512941 (backward)
    mov edx, 0x7efefeff                          # 00512946
    mov eax, dword ptr [ecx]                     # 0051294b
    {load} add edx, eax                          # 0051294d
    xor eax, -0x1                                # 0051294f
    {load} xor eax, edx                          # 00512952
    mov edx, dword ptr [ecx]                     # 00512954
    add ecx, 0x4                                 # 00512956
    test eax, 0x81010100                         # 00512959
    je.d8 L_00512941                             # 0051295e
    # block 0x00512960: entered by fall-through of je at 0x0051295e, 2 instruction(s), ends with je to 0x00512998 (forward)
    test dl, dl                                  # 00512960
    je.d8 L_00512998                             # 00512962
    # block 0x00512964: entered by fall-through of je at 0x00512962, 2 instruction(s), ends with je to 0x0051298f (forward)
    test dh, dh                                  # 00512964
    je.d8 L_0051298f                             # 00512966
    # block 0x00512968: entered by fall-through of je at 0x00512966, 2 instruction(s), ends with je to 0x00512982 (forward)
    test edx, 0xff0000                           # 00512968
    je.d8 L_00512982                             # 0051296e
    # block 0x00512970: entered by fall-through of je at 0x0051296e, 2 instruction(s), ends with je to 0x0051297a (forward)
    test edx, 0xff000000                         # 00512970
    je.d8 L_0051297a                             # 00512976
    # block 0x00512978: entered by fall-through of je at 0x00512976, 1 instruction(s), ends with backward jump to 0x00512941
    jmp.d8 L_00512941                            # 00512978
L_0051297a:
    # block 0x0051297a: entered by je at 0x00512976, 4 instruction(s), ends with ret
    mov dword ptr [edi], edx                     # 0051297a
    mov eax, dword ptr [esp + stk_8]             # 0051297c
    pop edi                                      # 00512980
    ret                                          # 00512981
L_00512982:
    # block 0x00512982: entered by je at 0x0051296e, 5 instruction(s), ends with ret
    mov word ptr [edi], dx                       # 00512982
    mov eax, dword ptr [esp + stk_8]             # 00512985
    mov byte ptr [edi + field_2], 0x0            # 00512989
    pop edi                                      # 0051298d
    ret                                          # 0051298e
L_0051298f:
    # block 0x0051298f: entered by je at 0x00512966, 4 instruction(s), ends with ret
    mov word ptr [edi], dx                       # 0051298f
    mov eax, dword ptr [esp + stk_8]             # 00512992
    pop edi                                      # 00512996
    ret                                          # 00512997
L_00512998:
    # block 0x00512998: entered by je at 0x00512932; je at 0x00512962, 4 instruction(s), ends with ret
    mov byte ptr [edi], dl                       # 00512998
    mov eax, dword ptr [esp + stk_8]             # 0051299a
    pop edi                                      # 0051299e
    ret                                          # 0051299f

