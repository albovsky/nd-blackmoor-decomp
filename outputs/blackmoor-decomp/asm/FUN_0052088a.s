# FUN_0052088a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052088a
# extent:       0x0052088a-0x0052094d (195 code bytes)
# span:         0x0052088a-0x0052094d (code 195, tables 0, padding 0)
# sha256:       d3f8bc01e23c1dcb1c4950ebc60c473f427194190ef0196931ed37c9ef7f3b1a
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052088a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_208, local_410, local_618
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!lstrcmpiA, USER32.dll!GetSystemMetrics, KERNEL32.dll!GetThreadLocale, FUN_0050ffdd; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_208, 0x208  # offset -0x208
.equ local_410, 0x410  # offset -0x410
.equ local_618, 0x618  # offset -0x618
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)

.org 0x0052088a - 0x401000
.globl FUN_0052088a
FUN_0052088a:
    # block 0x0052088a: entry, 12 instruction(s), calls KERNEL32.dll!lstrcmpiA, ends with jne to 0x00520949 (forward)
    push ebp                                     # 0052088a
    {load} mov ebp, esp                          # 0052088b
    sub esp, 0x618                               # 0052088d
    push ebx                                     # 00520893
    push esi                                     # 00520894
    push edi                                     # 00520895
    mov edi, dword ptr [ebp + arg_8]             # 00520896
    push dword ptr [ebp + arg_c]                 # 00520899
    push edi                                     # 0052089c
    call dword ptr [0x52a230]                    # 0052089d
    test eax, eax                                # 005208a3
    jne.d32 L_00520949                           # 005208a5
    # block 0x005208ab: entered by fall-through of jne at 0x005208a5, 4 instruction(s), calls USER32.dll!GetSystemMetrics, ends with je to 0x0052093f (forward)
    push 0x2a                                    # 005208ab
    call dword ptr [0x52a498]                    # 005208ad
    test eax, eax                                # 005208b3
    je.d32 L_0052093f                            # 005208b5
    # block 0x005208bb: entered by fall-through of je at 0x005208b5, 8 instruction(s), calls indirect esi, ends with jne to 0x00520949 (forward)
    mov esi, dword ptr [0x52a1f8]                # 005208bb
    push edi                                     # 005208c1
    call esi                                     # 005208c2
    push dword ptr [ebp + arg_c]                 # 005208c4
    {load} mov ebx, eax                          # 005208c7
    call esi                                     # 005208c9
    {load} cmp ebx, eax                          # 005208cb
    jne.d8 L_00520949                            # 005208cd
    # block 0x005208cf: entered by fall-through of jne at 0x005208cd, 27 instruction(s), calls KERNEL32.dll!GetThreadLocale, indirect esi, ends with je to 0x0052093f (forward)
    call dword ptr [0x52a124]                    # 005208cf
    mov esi, dword ptr [0x52a120]                # 005208d5
    {load} mov ebx, eax                          # 005208db
    lea eax, [ebp - local_208]                   # 005208dd
    push eax                                     # 005208e3
    push -0x1                                    # 005208e4
    push edi                                     # 005208e6
    push 0x1                                     # 005208e7
    push ebx                                     # 005208e9
    call esi                                     # 005208ea
    lea eax, [ebp - local_410]                   # 005208ec
    push eax                                     # 005208f2
    push -0x1                                    # 005208f3
    push edi                                     # 005208f5
    push 0x4                                     # 005208f6
    push ebx                                     # 005208f8
    call esi                                     # 005208f9
    lea eax, [ebp - local_618]                   # 005208fb
    push eax                                     # 00520901
    push -0x1                                    # 00520902
    push dword ptr [ebp + arg_c]                 # 00520904
    push 0x1                                     # 00520907
    push ebx                                     # 00520909
    call esi                                     # 0052090a
    cmp byte ptr [edi], 0x0                      # 0052090c
    {load} mov eax, edi                          # 0052090f
    je.d8 L_0052093f                             # 00520911
    # block 0x00520913: entered by fall-through of je at 0x00520911, 1 instruction(s), falls into the block at 0x00520915
    {load} xor esi, esi                          # 00520913
L_00520915:
    # block 0x00520915: entered by jne at 0x0052093d, 2 instruction(s), ends with je to 0x00520931 (forward)
    test byte ptr [ebp + esi - local_410], -0x80 # 00520915
    je.d8 L_00520931                             # 0052091d
    # block 0x0052091f: entered by fall-through of je at 0x0052091d, 3 instruction(s), ends with jne to 0x00520949 (forward)
    mov cx, word ptr [ebp + esi - local_208]     # 0052091f
    cmp cx, word ptr [ebp + esi - local_618]     # 00520927
    jne.d8 L_00520949                            # 0052092f
L_00520931:
    # block 0x00520931: entered by je at 0x0052091d; fall-through of jne at 0x0052092f, 7 instruction(s), calls FUN_0050ffdd, ends with jne to 0x00520915 (backward)
    inc esi                                      # 00520931
    push eax                                     # 00520932
    inc esi                                      # 00520933
    call FUN_0050ffdd                            # 00520934
    cmp byte ptr [eax], 0x0                      # 00520939
    pop ecx                                      # 0052093c
    jne.d8 L_00520915                            # 0052093d
L_0052093f:
    # block 0x0052093f: entered by je at 0x005208b5; je at 0x00520911; fall-through of jne at 0x0052093d, 2 instruction(s), falls into the block at 0x00520942
    push 0x1                                     # 0052093f
    pop eax                                      # 00520941
L_00520942:
    # block 0x00520942: entered by jmp at 0x0052094b, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 00520942
    pop esi                                      # 00520943
    pop ebx                                      # 00520944
    leave                                        # 00520945
    ret 0x8                                      # 00520946
L_00520949:
    # block 0x00520949: entered by jne at 0x005208a5; jne at 0x005208cd; jne at 0x0052092f, 2 instruction(s), ends with backward jump to 0x00520942
    {load} xor eax, eax                          # 00520949
    jmp.d8 L_00520942                            # 0052094b

