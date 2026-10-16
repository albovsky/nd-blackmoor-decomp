# FUN_005207c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005207c4
# extent:       0x005207c4-0x0052088a (198 code bytes)
# span:         0x005207c4-0x0052088a (code 198, tables 0, padding 0)
# sha256:       a2412ae4351b38b782b2b855149171d59b3e3a0cf1c4ef3dca71027f005d506a
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005207c4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [esp + n] stk_8, stk_14
# callees:      calls FUN_0051ea75, FUN_0050f920, KERNEL32.dll!lstrcpynA, FUN_0050ffdd, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0050ffdd, .text + (0x0050ffdd - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x005207c4 - 0x401000
.globl FUN_005207c4
FUN_005207c4:
    # block 0x005207c4: entry, 20 instruction(s), calls FUN_0051ea75, FUN_0050f920, KERNEL32.dll!lstrcpynA, falls into the block at 0x005207f5
    mov ecx, dword ptr [esp + stk_8]             # 005207c4
    push ebx                                     # 005207c8
    push esi                                     # 005207c9
    mov esi, 0x104                               # 005207ca
    push edi                                     # 005207cf
    push esi                                     # 005207d0
    call FUN_0051ea75                            # 005207d1
    {load} xor ebx, ebx                          # 005207d6
    {load} mov edi, eax                          # 005207d8
    push esi                                     # 005207da
    push ebx                                     # 005207db
    push edi                                     # 005207dc
    call FUN_0050f920                            # 005207dd
    add esp, 0xc                                 # 005207e2
    push esi                                     # 005207e5
    push dword ptr [esp + stk_14]                # 005207e6
    push edi                                     # 005207ea
    call dword ptr [0x52a1d4]                    # 005207eb
    mov cl, byte ptr [edi]                       # 005207f1
    {load} mov eax, edi                          # 005207f3
L_005207f5:
    # block 0x005207f5: entered by jmp at 0x00520819, 2 instruction(s), ends with je to 0x0052081b (forward)
    {load} cmp cl, bl                            # 005207f5
    je.d8 L_0052081b                             # 005207f7
    # block 0x005207f9: entered by fall-through of je at 0x005207f7, 2 instruction(s), ends with je to 0x00520803 (forward)
    cmp cl, 0x5c                                 # 005207f9
    je.d8 L_00520803                             # 005207fc
    # block 0x005207fe: entered by fall-through of je at 0x005207fc, 2 instruction(s), ends with jne to 0x00520810 (forward)
    cmp cl, 0x2f                                 # 005207fe
    jne.d8 L_00520810                            # 00520801
L_00520803:
    # block 0x00520803: entered by je at 0x005207fc; fall-through of jne at 0x00520801, 3 instruction(s), ends with je to 0x0052081b (forward)
    mov cl, byte ptr [eax + field_1]             # 00520803
    cmp cl, 0x5c                                 # 00520806
    je.d8 L_0052081b                             # 00520809
    # block 0x0052080b: entered by fall-through of je at 0x00520809, 2 instruction(s), ends with je to 0x0052081b (forward)
    cmp cl, 0x2f                                 # 0052080b
    je.d8 L_0052081b                             # 0052080e
L_00520810:
    # block 0x00520810: entered by jne at 0x00520801; fall-through of je at 0x0052080e, 5 instruction(s), calls FUN_0050ffdd, ends with backward jump to 0x005207f5
    push eax                                     # 00520810
    call FUN_0050ffdd                            # 00520811
    pop ecx                                      # 00520816
    mov cl, byte ptr [eax]                       # 00520817
    jmp.d8 L_005207f5                            # 00520819
L_0052081b:
    # block 0x0052081b: entered by je at 0x005207f7; je at 0x00520809; je at 0x0052080e, 2 instruction(s), ends with je to 0x0052086d (forward)
    cmp byte ptr [eax], bl                       # 0052081b
    je.d8 L_0052086d                             # 0052081d
    # block 0x0052081f: entered by fall-through of je at 0x0052081d, 2 instruction(s), falls into the block at 0x00520821
    inc eax                                      # 0052081f
    inc eax                                      # 00520820
L_00520821:
    # block 0x00520821: entered by jmp at 0x00520838, 3 instruction(s), ends with je to 0x0052083a (forward)
    mov cl, byte ptr [eax]                       # 00520821
    {load} cmp cl, bl                            # 00520823
    je.d8 L_0052083a                             # 00520825
    # block 0x00520827: entered by fall-through of je at 0x00520825, 2 instruction(s), ends with je to 0x0052083a (forward)
    cmp cl, 0x5c                                 # 00520827
    je.d8 L_0052083a                             # 0052082a
    # block 0x0052082c: entered by fall-through of je at 0x0052082a, 2 instruction(s), ends with je to 0x0052083a (forward)
    cmp cl, 0x2f                                 # 0052082c
    je.d8 L_0052083a                             # 0052082f
    # block 0x00520831: entered by fall-through of je at 0x0052082f, 4 instruction(s), calls FUN_0050ffdd, ends with backward jump to 0x00520821
    push eax                                     # 00520831
    call FUN_0050ffdd                            # 00520832
    pop ecx                                      # 00520837
    jmp.d8 L_00520821                            # 00520838
L_0052083a:
    # block 0x0052083a: entered by je at 0x00520825; je at 0x0052082a; je at 0x0052082f, 2 instruction(s), ends with je to 0x00520845 (forward)
    cmp byte ptr [eax], bl                       # 0052083a
    je.d8 L_00520845                             # 0052083c
L_0052083e:
    # block 0x0052083e: entered by jne at 0x00520853; fall-through of je at 0x0052083c, 3 instruction(s), calls FUN_0050ffdd, falls into the block at 0x00520845
    push eax                                     # 0052083e
    call FUN_0050ffdd                            # 0052083f
    pop ecx                                      # 00520844
L_00520845:
    # block 0x00520845: entered by je at 0x0052083c, 3 instruction(s), ends with je to 0x00520855 (forward)
    mov cl, byte ptr [eax]                       # 00520845
    {load} cmp cl, bl                            # 00520847
    je.d8 L_00520855                             # 00520849
    # block 0x0052084b: entered by fall-through of je at 0x00520849, 2 instruction(s), ends with je to 0x00520855 (forward)
    cmp cl, 0x5c                                 # 0052084b
    je.d8 L_00520855                             # 0052084e
    # block 0x00520850: entered by fall-through of je at 0x0052084e, 2 instruction(s), ends with jne to 0x0052083e (backward)
    cmp cl, 0x2f                                 # 00520850
    jne.d8 L_0052083e                            # 00520853
L_00520855:
    # block 0x00520855: entered by je at 0x00520849; je at 0x0052084e; je at 0x00520873; je at 0x00520878; more, 2 instruction(s), ends with je to 0x0052085c (forward)
    cmp byte ptr [eax], bl                       # 00520855
    je.d8 L_0052085c                             # 00520857
    # block 0x00520859: entered by fall-through of je at 0x00520857, 1 instruction(s), falls into the block at 0x0052085c
    mov byte ptr [eax + field_1], bl             # 00520859
L_0052085c:
    # block 0x0052085c: entered by je at 0x00520857, 7 instruction(s), calls FUN_0051eac4, ends with ret 0x8
    mov ecx, dword ptr [esp + stk_14]            # 0052085c
    push -0x1                                    # 00520860
    call FUN_0051eac4                            # 00520862
    pop edi                                      # 00520867
    pop esi                                      # 00520868
    pop ebx                                      # 00520869
    ret 0x8                                      # 0052086a
L_0052086d:
    # block 0x0052086d: entered by je at 0x0052081d, 2 instruction(s), falls into the block at 0x00520871
    mov cl, byte ptr [edi]                       # 0052086d
    {load} mov eax, edi                          # 0052086f
L_00520871:
    # block 0x00520871: entered by jmp at 0x00520888, 2 instruction(s), ends with je to 0x00520855 (backward)
    {load} cmp cl, bl                            # 00520871
    je.d8 L_00520855                             # 00520873
    # block 0x00520875: entered by fall-through of je at 0x00520873, 2 instruction(s), ends with je to 0x00520855 (backward)
    cmp cl, 0x5c                                 # 00520875
    je.d8 L_00520855                             # 00520878
    # block 0x0052087a: entered by fall-through of je at 0x00520878, 2 instruction(s), ends with je to 0x00520855 (backward)
    cmp cl, 0x2f                                 # 0052087a
    je.d8 L_00520855                             # 0052087d
    # block 0x0052087f: entered by fall-through of je at 0x0052087d, 5 instruction(s), calls FUN_0050ffdd, ends with backward jump to 0x00520871
    push eax                                     # 0052087f
    call FUN_0050ffdd                            # 00520880
    pop ecx                                      # 00520885
    mov cl, byte ptr [eax]                       # 00520886
    jmp.d8 L_00520871                            # 00520888

