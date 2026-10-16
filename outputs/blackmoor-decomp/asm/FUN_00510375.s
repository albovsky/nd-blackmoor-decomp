# FUN_00510375
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510375
# extent:       0x00510375-0x005104fa (389 code bytes)
# span:         0x00510375-0x005104fa (code 389, tables 0, padding 0)
# sha256:       536cffdcd6a639aba6eb5ef79d13d6efb3ca1e956105a25eb658d069e9086023
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510375
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       7 ebp-relative slot(s): local_d, local_e, local_14, local_114, local_214, local_314, local_514
# fields:       [edx + n] field_minus_1
# callees:      calls KERNEL32.dll!GetCPInfo, FUN_00515e1e, FUN_005129a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_d, 0xd  # offset -0xd
.equ local_e, 0xe  # offset -0xe
.equ local_14, 0x14  # offset -0x14
.equ local_114, 0x114  # offset -0x114
.equ local_214, 0x214  # offset -0x214
.equ local_314, 0x314  # offset -0x314
.equ local_514, 0x514  # offset -0x514

# --- external targets -----------------------------------------------
.set FUN_005129a0, .text + (0x005129a0 - 0x401000)
.set FUN_00515e1e, .text + (0x00515e1e - 0x401000)

.org 0x00510375 - 0x401000
.globl FUN_00510375
FUN_00510375:
    # block 0x00510375: entry, 10 instruction(s), calls KERNEL32.dll!GetCPInfo, ends with jne to 0x005104ae (forward)
    push ebp                                     # 00510375
    {load} mov ebp, esp                          # 00510376
    sub esp, 0x514                               # 00510378
    lea eax, [ebp - local_14]                    # 0051037e
    push esi                                     # 00510381
    push eax                                     # 00510382
    push dword ptr [0x63df04]                    # 00510383
    call dword ptr [0x52a0e8]                    # 00510389
    cmp eax, 0x1                                 # 0051038f
    jne.d32 L_005104ae                           # 00510392
    # block 0x00510398: entered by fall-through of jne at 0x00510392, 2 instruction(s), falls into the block at 0x0051039f
    {load} xor eax, eax                          # 00510398
    mov esi, 0x100                               # 0051039a
L_0051039f:
    # block 0x0051039f: entered by jb at 0x005103a9, 4 instruction(s), ends with jb to 0x0051039f (backward)
    mov byte ptr [ebp + eax - local_114], al     # 0051039f
    inc eax                                      # 005103a6
    {load} cmp eax, esi                          # 005103a7
    jb.d8 L_0051039f                             # 005103a9
    # block 0x005103ab: entered by fall-through of jb at 0x005103a9, 4 instruction(s), ends with je to 0x005103f0 (forward)
    mov al, byte ptr [ebp - local_e]             # 005103ab
    mov byte ptr [ebp - local_114], 0x20         # 005103ae
    test al, al                                  # 005103b5
    je.d8 L_005103f0                             # 005103b7
    # block 0x005103b9: entered by fall-through of je at 0x005103b7, 3 instruction(s), falls into the block at 0x005103be
    push ebx                                     # 005103b9
    push edi                                     # 005103ba
    lea edx, [ebp - local_d]                     # 005103bb
L_005103be:
    # block 0x005103be: entered by jne at 0x005103ec, 4 instruction(s), ends with ja to 0x005103e5 (forward)
    movzx ecx, byte ptr [edx]                    # 005103be
    movzx eax, al                                # 005103c1
    {load} cmp eax, ecx                          # 005103c4
    ja.d8 L_005103e5                             # 005103c6
    # block 0x005103c8: entered by fall-through of ja at 0x005103c6, 10 instruction(s), falls into the block at 0x005103e5
    {load} sub ecx, eax                          # 005103c8
    lea edi, [ebp + eax - local_114]             # 005103ca
    inc ecx                                      # 005103d1
    mov eax, 0x20202020                          # 005103d2
    {load} mov ebx, ecx                          # 005103d7
    shr ecx, 0x2                                 # 005103d9
    rep stosd dword ptr es:[edi], eax            # 005103dc
    {load} mov ecx, ebx                          # 005103de
    and ecx, 0x3                                 # 005103e0
    rep stosb byte ptr es:[edi], al              # 005103e3
L_005103e5:
    # block 0x005103e5: entered by ja at 0x005103c6, 5 instruction(s), ends with jne to 0x005103be (backward)
    inc edx                                      # 005103e5
    inc edx                                      # 005103e6
    mov al, byte ptr [edx - field_minus_1]       # 005103e7
    test al, al                                  # 005103ea
    jne.d8 L_005103be                            # 005103ec
    # block 0x005103ee: entered by fall-through of jne at 0x005103ec, 2 instruction(s), falls into the block at 0x005103f0
    pop edi                                      # 005103ee
    pop ebx                                      # 005103ef
L_005103f0:
    # block 0x005103f0: entered by je at 0x005103b7, 35 instruction(s), calls FUN_00515e1e, FUN_005129a0, falls into the block at 0x0051046b
    push 0x0                                     # 005103f0
    lea eax, [ebp - local_514]                   # 005103f2
    push dword ptr [0x63e124]                    # 005103f8
    push dword ptr [0x63df04]                    # 005103fe
    push eax                                     # 00510404
    lea eax, [ebp - local_114]                   # 00510405
    push esi                                     # 0051040b
    push eax                                     # 0051040c
    push 0x1                                     # 0051040d
    call FUN_00515e1e                            # 0051040f
    push 0x0                                     # 00510414
    lea eax, [ebp - local_214]                   # 00510416
    push dword ptr [0x63df04]                    # 0051041c
    push esi                                     # 00510422
    push eax                                     # 00510423
    lea eax, [ebp - local_114]                   # 00510424
    push esi                                     # 0051042a
    push eax                                     # 0051042b
    push esi                                     # 0051042c
    push dword ptr [0x63e124]                    # 0051042d
    call FUN_005129a0                            # 00510433
    push 0x0                                     # 00510438
    lea eax, [ebp - local_314]                   # 0051043a
    push dword ptr [0x63df04]                    # 00510440
    push esi                                     # 00510446
    push eax                                     # 00510447
    lea eax, [ebp - local_114]                   # 00510448
    push esi                                     # 0051044e
    push eax                                     # 0051044f
    push 0x200                                   # 00510450
    push dword ptr [0x63e124]                    # 00510455
    call FUN_005129a0                            # 0051045b
    add esp, 0x5c                                # 00510460
    {load} xor eax, eax                          # 00510463
    lea ecx, [ebp - local_514]                   # 00510465
L_0051046b:
    # block 0x0051046b: entered by jb at 0x005104aa, 3 instruction(s), ends with je to 0x00510489 (forward)
    mov dx, word ptr [ecx]                       # 0051046b
    test dl, 0x1                                 # 0051046e
    je.d8 L_00510489                             # 00510471
    # block 0x00510473: entered by fall-through of je at 0x00510471, 2 instruction(s), falls into the block at 0x00510481
    or byte ptr [eax + 0x63e021], 0x10           # 00510473
    mov dl, byte ptr [ebp + eax - local_214]     # 0051047a
L_00510481:
    # block 0x00510481: entered by jmp at 0x0051049c, 2 instruction(s), ends with forward jump to 0x005104a5
    mov byte ptr [eax + 0x63df20], dl            # 00510481
    jmp.d8 L_005104a5                            # 00510487
L_00510489:
    # block 0x00510489: entered by je at 0x00510471, 2 instruction(s), ends with je to 0x0051049e (forward)
    test dl, 0x2                                 # 00510489
    je.d8 L_0051049e                             # 0051048c
    # block 0x0051048e: entered by fall-through of je at 0x0051048c, 3 instruction(s), ends with backward jump to 0x00510481
    or byte ptr [eax + 0x63e021], 0x20           # 0051048e
    mov dl, byte ptr [ebp + eax - local_314]     # 00510495
    jmp.d8 L_00510481                            # 0051049c
L_0051049e:
    # block 0x0051049e: entered by je at 0x0051048c, 1 instruction(s), falls into the block at 0x005104a5
    and byte ptr [eax + 0x63df20], 0x0           # 0051049e
L_005104a5:
    # block 0x005104a5: entered by jmp at 0x00510487, 5 instruction(s), ends with jb to 0x0051046b (backward)
    inc eax                                      # 005104a5
    inc ecx                                      # 005104a6
    inc ecx                                      # 005104a7
    {load} cmp eax, esi                          # 005104a8
    jb.d8 L_0051046b                             # 005104aa
    # block 0x005104ac: entered by fall-through of jb at 0x005104aa, 1 instruction(s), ends with forward jump to 0x005104f7
    jmp.d8 L_005104f7                            # 005104ac
L_005104ae:
    # block 0x005104ae: entered by jne at 0x00510392, 2 instruction(s), falls into the block at 0x005104b5
    {load} xor eax, eax                          # 005104ae
    mov esi, 0x100                               # 005104b0
L_005104b5:
    # block 0x005104b5: entered by jb at 0x005104f5, 2 instruction(s), ends with jb to 0x005104d3 (forward)
    cmp eax, 0x41                                # 005104b5
    jb.d8 L_005104d3                             # 005104b8
    # block 0x005104ba: entered by fall-through of jb at 0x005104b8, 2 instruction(s), ends with ja to 0x005104d3 (forward)
    cmp eax, 0x5a                                # 005104ba
    ja.d8 L_005104d3                             # 005104bd
    # block 0x005104bf: entered by fall-through of ja at 0x005104bd, 3 instruction(s), falls into the block at 0x005104cb
    or byte ptr [eax + 0x63e021], 0x10           # 005104bf
    {load} mov cl, al                            # 005104c6
    add cl, 0x20                                 # 005104c8
L_005104cb:
    # block 0x005104cb: entered by jmp at 0x005104e9, 2 instruction(s), ends with forward jump to 0x005104f2
    mov byte ptr [eax + 0x63df20], cl            # 005104cb
    jmp.d8 L_005104f2                            # 005104d1
L_005104d3:
    # block 0x005104d3: entered by jb at 0x005104b8; ja at 0x005104bd, 2 instruction(s), ends with jb to 0x005104eb (forward)
    cmp eax, 0x61                                # 005104d3
    jb.d8 L_005104eb                             # 005104d6
    # block 0x005104d8: entered by fall-through of jb at 0x005104d6, 2 instruction(s), ends with ja to 0x005104eb (forward)
    cmp eax, 0x7a                                # 005104d8
    ja.d8 L_005104eb                             # 005104db
    # block 0x005104dd: entered by fall-through of ja at 0x005104db, 4 instruction(s), ends with backward jump to 0x005104cb
    or byte ptr [eax + 0x63e021], 0x20           # 005104dd
    {load} mov cl, al                            # 005104e4
    sub cl, 0x20                                 # 005104e6
    jmp.d8 L_005104cb                            # 005104e9
L_005104eb:
    # block 0x005104eb: entered by jb at 0x005104d6; ja at 0x005104db, 1 instruction(s), falls into the block at 0x005104f2
    and byte ptr [eax + 0x63df20], 0x0           # 005104eb
L_005104f2:
    # block 0x005104f2: entered by jmp at 0x005104d1, 3 instruction(s), ends with jb to 0x005104b5 (backward)
    inc eax                                      # 005104f2
    {load} cmp eax, esi                          # 005104f3
    jb.d8 L_005104b5                             # 005104f5
L_005104f7:
    # block 0x005104f7: entered by jmp at 0x005104ac; fall-through of jb at 0x005104f5, 3 instruction(s), ends with ret
    pop esi                                      # 005104f7
    leave                                        # 005104f8
    ret                                          # 005104f9

