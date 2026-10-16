# FUN_00518276
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518276
# extent:       0x00518276-0x0051847c (518 code bytes)
# span:         0x00518276-0x0051847c (code 518, tables 0, padding 0)
# sha256:       1e58eaa990fcff7361f49d27ee827a9a10abc982ef6b150f9a9402b6f1c55855
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xada)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518276
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_10, stk_14, stk_16, stk_18, stk_1c, stk_28, stk_2c, stk_2e, stk_30, stk_34, stk_38 and 1 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 142 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051847c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_16, 0x16  # offset +0x16
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_2e, 0x2e  # offset +0x2e
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------

.org 0x00518276 - 0x401000
.globl FUN_00518276
FUN_00518276:
    # block 0x00518276: entry, 7 instruction(s), ends with jne to 0x00518410 (forward)
    push eax                                     # 00518276
    push ebx                                     # 00518277
    push ecx                                     # 00518278
    mov eax, dword ptr [esp + stk_16]            # 00518279
    xor eax, 0x700                               # 0051827d
    test eax, 0x700                              # 00518282
    jne.d32 L_00518410                           # 00518287
    # block 0x0051828d: entered by fall-through of jne at 0x00518287, 4 instruction(s), ends with je to 0x00518410 (forward)
    shr eax, 0xb                                 # 0051828d
    and eax, 0xf                                 # 00518290
    cmp byte ptr [eax + 0x568cec], 0x0           # 00518293
    je.d32 L_00518410                            # 0051829a
    # block 0x005182a0: entered by fall-through of je at 0x0051829a, 4 instruction(s), ends with je to 0x00518410 (forward)
    mov eax, dword ptr [esp + stk_16]            # 005182a0
    and eax, 0x7fff0000                          # 005182a4
    cmp eax, 0x7fff0000                          # 005182a9
    je.d32 L_00518410                            # 005182ae
    # block 0x005182b4: entered by fall-through of je at 0x005182ae, 3 instruction(s), ends with je to 0x00518410 (forward)
    mov eax, dword ptr [esp + stk_2e]            # 005182b4
    and eax, 0x7fff0000                          # 005182b8
    je.d32 L_00518410                            # 005182bd
    # block 0x005182c3: entered by fall-through of je at 0x005182bd, 2 instruction(s), ends with je to 0x00518410 (forward)
    cmp eax, 0x7fff0000                          # 005182c3
    je.d32 L_00518410                            # 005182c8
    # block 0x005182ce: entered by fall-through of je at 0x005182c8, 3 instruction(s), ends with jne to 0x00518410 (forward)
    mov eax, dword ptr [esp + stk_2c]            # 005182ce
    {load} add eax, eax                          # 005182d2
    jne.d32 L_00518410                           # 005182d4
    # block 0x005182da: entered by fall-through of jne at 0x005182d4, 3 instruction(s), ends with jne to 0x00518410 (forward)
    mov eax, dword ptr [esp + stk_14]            # 005182da
    {load} add eax, eax                          # 005182de
    jne.d32 L_00518410                           # 005182e0
    # block 0x005182e6: entered by fall-through of jne at 0x005182e0, 7 instruction(s), ends with ja to 0x0051835e (forward)
    mov eax, dword ptr [esp + stk_18]            # 005182e6
    and eax, 0x7fff                              # 005182ea
    add eax, 0x3f                                # 005182ef
    mov ebx, dword ptr [esp + stk_30]            # 005182f2
    and ebx, 0x7fff                              # 005182f6
    {load} sub ebx, eax                          # 005182fc
    ja.d8 L_0051835e                             # 005182fe
L_00518300:
    # block 0x00518300: entered by jmp at 0x0051835c; fall-through of ja at 0x005182fe, 7 instruction(s), ends with js to 0x00518410 (forward)
    mov eax, dword ptr [esp + stk_18]            # 00518300
    and eax, 0x7fff                              # 00518304
    add eax, 0xa                                 # 00518309
    mov ebx, dword ptr [esp + stk_30]            # 0051830c
    and ebx, 0x7fff                              # 00518310
    {load} sub ebx, eax                          # 00518316
    js.d32 L_00518410                            # 00518318
    # block 0x0051831e: entered by fall-through of js at 0x00518318, 20 instruction(s), ends with backward jump to 0x00518300
    fld tbyte ptr [esp + stk_28]                 # 0051831e
    mov eax, dword ptr [esp + stk_18]            # 00518322
    mov ebx, dword ptr [esp + stk_30]            # 00518326
    and ebx, 0x7fff                              # 0051832a
    {load} mov ecx, ebx                          # 00518330
    {load} sub ebx, eax                          # 00518332
    and ebx, 0x7                                 # 00518334
    or ebx, 0x4                                  # 00518337
    {load} sub ecx, ebx                          # 0051833a
    {load} mov ebx, eax                          # 0051833c
    and ebx, 0x8000                              # 0051833e
    {load} or ecx, ebx                           # 00518344
    mov dword ptr [esp + stk_18], ecx            # 00518346
    fld tbyte ptr [esp + stk_10]                 # 0051834a
    mov dword ptr [esp + stk_18], eax            # 0051834e
    fxch st(1)                                   # 00518352
    fprem                                        # 00518354
    fstp tbyte ptr [esp + stk_28]                # 00518356
    fstp st(0)                                   # 0051835a
    jmp.d8 L_00518300                            # 0051835c
L_0051835e:
    # block 0x0051835e: entered by ja at 0x005182fe, 2 instruction(s), ends with jne to 0x0051836e (forward)
    test edx, 0x2                                # 0051835e
    jne.d8 L_0051836e                            # 00518364
    # block 0x00518366: entered by fall-through of jne at 0x00518364, 2 instruction(s), falls into the block at 0x0051836e
    fld tbyte ptr [esp + stk_10]                 # 00518366
    fstp tbyte ptr [esp + stk_1c]                # 0051836a
L_0051836e:
    # block 0x0051836e: entered by jne at 0x00518364, 24 instruction(s), falls into the block at 0x005183c8
    fnstcw word ptr [esp + stk_34]               # 0051836e
    mov eax, dword ptr [esp + stk_34]            # 00518372
    or eax, 0x33f                                # 00518376
    mov dword ptr [esp + stk_38], eax            # 0051837b
    fldcw word ptr [esp + stk_38]                # 0051837f
    mov eax, dword ptr [esp + stk_18]            # 00518383
    and eax, 0x7fff                              # 00518387
    mov ebx, dword ptr [esp + stk_30]            # 0051838c
    and ebx, 0x7fff                              # 00518390
    {load} sub ebx, eax                          # 00518396
    and ebx, 0x3f                                # 00518398
    or ebx, 0x20                                 # 0051839b
    add ebx, 0x1                                 # 0051839e
    {load} mov ecx, ebx                          # 005183a1
    mov eax, dword ptr [esp + stk_18]            # 005183a3
    mov ebx, dword ptr [esp + stk_30]            # 005183a7
    and ebx, 0x7fff                              # 005183ab
    and eax, 0x8000                              # 005183b1
    {load} or ebx, eax                           # 005183b6
    mov dword ptr [esp + stk_18], ebx            # 005183b8
    fld tbyte ptr [esp + stk_10]                 # 005183bc
    fabs                                         # 005183c0
    fld tbyte ptr [esp + stk_28]                 # 005183c2
    fabs                                         # 005183c6
L_005183c8:
    # block 0x005183c8: entered by jne at 0x005183e2, 4 instruction(s), ends with jne to 0x005183d5 (forward)
    fcom st(1)                                   # 005183c8
    fnstsw ax                                    # 005183ca
    and eax, 0x100                               # 005183cc
    jne.d8 L_005183d5                            # 005183d1
    # block 0x005183d3: entered by fall-through of jne at 0x005183d1, 1 instruction(s), falls into the block at 0x005183d5
    fsub st, st(1)                               # 005183d3
L_005183d5:
    # block 0x005183d5: entered by jne at 0x005183d1, 5 instruction(s), ends with jne to 0x005183c8 (backward)
    fxch st(1)                                   # 005183d5
    fmul qword ptr [0x568d1c]                    # 005183d7
    fxch st(1)                                   # 005183dd
    sub ecx, 0x1                                 # 005183df
    jne.d8 L_005183c8                            # 005183e2
    # block 0x005183e4: entered by fall-through of jne at 0x005183e2, 11 instruction(s), ends with je to 0x0051841a (forward)
    mov ebx, dword ptr [esp + stk_30]            # 005183e4
    fstp tbyte ptr [esp + stk_28]                # 005183e8
    fstp st(0)                                   # 005183ec
    fld tbyte ptr [esp + stk_1c]                 # 005183ee
    fld tbyte ptr [0x568d24]                     # 005183f2
    fprem                                        # 005183f8
    fstp st(0)                                   # 005183fa
    fld tbyte ptr [esp + stk_28]                 # 005183fc
    fldcw word ptr [esp + stk_34]                # 00518400
    and ebx, 0x8000                              # 00518404
    je.d8 L_0051841a                             # 0051840a
    # block 0x0051840c: entered by fall-through of je at 0x0051840a, 2 instruction(s), ends with forward jump to 0x0051841a
    fchs                                         # 0051840c
    jmp.d8 L_0051841a                            # 0051840e
L_00518410:
    # block 0x00518410: entered by jne at 0x00518287; je at 0x0051829a; je at 0x005182ae; je at 0x005182bd; more, 3 instruction(s), falls into the block at 0x0051841a
    fld tbyte ptr [esp + stk_10]                 # 00518410
    fld tbyte ptr [esp + stk_28]                 # 00518414
    fprem                                        # 00518418
L_0051841a:
    # block 0x0051841a: entered by je at 0x0051840a; jmp at 0x0051840e, 2 instruction(s), ends with je to 0x00518478 (forward)
    test edx, 0x3                                # 0051841a
    je.d8 L_00518478                             # 00518420
    # block 0x00518422: entered by fall-through of je at 0x00518420, 3 instruction(s), ends with je to 0x0051844d (forward)
    fnstsw word ptr [esp + stk_3c]               # 00518422
    test edx, 0x1                                # 00518426
    je.d8 L_0051844d                             # 0051842c
    # block 0x0051842e: entered by fall-through of je at 0x0051842c, 7 instruction(s), falls into the block at 0x0051844d
    fnstcw word ptr [esp + stk_34]               # 0051842e
    mov eax, dword ptr [esp + stk_34]            # 00518432
    or eax, 0x300                                # 00518436
    mov dword ptr [esp + stk_38], eax            # 0051843b
    fldcw word ptr [esp + stk_38]                # 0051843f
    fmul qword ptr [0x568d0c]                    # 00518443
    fldcw word ptr [esp + stk_34]                # 00518449
L_0051844d:
    # block 0x0051844d: entered by je at 0x0051842c, 12 instruction(s), falls into the block at 0x00518478
    mov eax, dword ptr [esp + stk_3c]            # 0051844d
    fxch st(1)                                   # 00518451
    fstp st(0)                                   # 00518453
    fld tbyte ptr [esp + stk_1c]                 # 00518455
    fxch st(1)                                   # 00518459
    and eax, 0x4300                              # 0051845b
    sub esp, 0x1c                                # 00518460
    fnstenv [esp]                                # 00518463
    and dword ptr [esp + stk_4], 0xbcff          # 00518466
    or dword ptr [esp + stk_4], eax              # 0051846e
    fldenv [esp]                                 # 00518472
    add esp, 0x1c                                # 00518475
L_00518478:
    # block 0x00518478: entered by je at 0x00518420, 4 instruction(s), ends with ret
    pop ecx                                      # 00518478
    pop ebx                                      # 00518479
    pop eax                                      # 0051847a
    ret                                          # 0051847b

