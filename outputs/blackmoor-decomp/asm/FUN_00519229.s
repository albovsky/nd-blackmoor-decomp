# FUN_00519229
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519229
# extent:       0x00519229-0x005192a5 (124 code bytes)
# span:         0x00519229-0x005192a5 (code 124, tables 0, padding 0)
# sha256:       1e6be383606e0c2facf38946a7cbd8fb0991338628b7d25aa810e9957da14ec6
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519229
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_a, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519009
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00519009, .text + (0x00519009 - 0x401000)

.org 0x00519229 - 0x401000
.globl FUN_00519229
FUN_00519229:
    # block 0x00519229: entry, 9 instruction(s), ends with je to 0x005192a2 (forward)
    push ebp                                     # 00519229
    {load} mov ebp, esp                          # 0051922a
    sub esp, 0xc                                 # 0051922c
    push ebx                                     # 0051922f
    mov ebx, 0x568e78                            # 00519230
    {load} xor ecx, ecx                          # 00519235
    sub ebx, 0x60                                # 00519237
    cmp dword ptr [ebp + arg_c], ecx             # 0051923a
    je.d8 L_005192a2                             # 0051923d
    # block 0x0051923f: entered by fall-through of je at 0x0051923d, 1 instruction(s), ends with jge to 0x00519251 (forward)
    jge.d8 L_00519251                            # 0051923f
    # block 0x00519241: entered by fall-through of jge at 0x0051923f, 5 instruction(s), falls into the block at 0x00519251
    mov eax, dword ptr [ebp + arg_c]             # 00519241
    mov ebx, 0x568fd8                            # 00519244
    neg eax                                      # 00519249
    mov dword ptr [ebp + arg_c], eax             # 0051924b
    sub ebx, 0x60                                # 0051924e
L_00519251:
    # block 0x00519251: entered by jge at 0x0051923f, 2 instruction(s), ends with jne to 0x0051925c (forward)
    cmp dword ptr [ebp + arg_10], ecx            # 00519251
    jne.d8 L_0051925c                            # 00519254
    # block 0x00519256: entered by fall-through of jne at 0x00519254, 2 instruction(s), falls into the block at 0x0051925c
    mov eax, dword ptr [ebp + arg_8]             # 00519256
    mov word ptr [eax], cx                       # 00519259
L_0051925c:
    # block 0x0051925c: entered by jne at 0x00519254, 2 instruction(s), ends with je to 0x005192a2 (forward)
    cmp dword ptr [ebp + arg_c], ecx             # 0051925c
    je.d8 L_005192a2                             # 0051925f
    # block 0x00519261: entered by fall-through of je at 0x0051925f, 2 instruction(s), falls into the block at 0x00519263
    push esi                                     # 00519261
    push edi                                     # 00519262
L_00519263:
    # block 0x00519263: entered by jne at 0x0051929e, 6 instruction(s), ends with je to 0x0051929b (forward)
    mov eax, dword ptr [ebp + arg_c]             # 00519263
    add ebx, 0x54                                # 00519266
    sar dword ptr [ebp + arg_c], 0x3             # 00519269
    and eax, 0x7                                 # 0051926d
    {load} cmp eax, ecx                          # 00519270
    je.d8 L_0051929b                             # 00519272
    # block 0x00519274: entered by fall-through of je at 0x00519272, 4 instruction(s), ends with jb to 0x0051928e (forward)
    lea eax, [eax + 2*eax]                       # 00519274
    .insn 0x6681/7, dword ptr [ebx + 4*eax], -32768{:s16} # 00519277
    lea esi, [ebx + 4*eax]                       # 0051927d
    jb.d8 L_0051928e                             # 00519280
    # block 0x00519282: entered by fall-through of jb at 0x00519280, 6 instruction(s), falls into the block at 0x0051928e
    lea edi, [ebp - local_c]                     # 00519282
    movsd dword ptr es:[edi], dword ptr [esi]    # 00519285
    movsd dword ptr es:[edi], dword ptr [esi]    # 00519286
    movsd dword ptr es:[edi], dword ptr [esi]    # 00519287
    dec dword ptr [ebp - local_a]                # 00519288
    lea esi, [ebp - local_c]                     # 0051928b
L_0051928e:
    # block 0x0051928e: entered by jb at 0x00519280, 6 instruction(s), calls FUN_00519009, falls into the block at 0x0051929b
    push esi                                     # 0051928e
    push dword ptr [ebp + arg_8]                 # 0051928f
    call FUN_00519009                            # 00519292
    pop ecx                                      # 00519297
    pop ecx                                      # 00519298
    {load} xor ecx, ecx                          # 00519299
L_0051929b:
    # block 0x0051929b: entered by je at 0x00519272, 2 instruction(s), ends with jne to 0x00519263 (backward)
    cmp dword ptr [ebp + arg_c], ecx             # 0051929b
    jne.d8 L_00519263                            # 0051929e
    # block 0x005192a0: entered by fall-through of jne at 0x0051929e, 2 instruction(s), falls into the block at 0x005192a2
    pop edi                                      # 005192a0
    pop esi                                      # 005192a1
L_005192a2:
    # block 0x005192a2: entered by je at 0x0051923d; je at 0x0051925f, 3 instruction(s), ends with ret
    pop ebx                                      # 005192a2
    leave                                        # 005192a3
    ret                                          # 005192a4

