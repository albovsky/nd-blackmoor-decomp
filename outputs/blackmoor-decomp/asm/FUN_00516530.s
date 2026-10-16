# FUN_00516530
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516530
# extent:       0x00516530-0x00516600 (208 code bytes)
# span:         0x00516530-0x00516600 (code 208, tables 0, padding 0)
# sha256:       e6af09f84ddc920c21c56a52ba89bb6f2b2f43bf0db2a874f605dfdb9ca98a65
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516530
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_8
# callees:      calls FUN_00512c18, FUN_00512f53, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 88 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00512f53, .text + (0x00512f53 - 0x401000)

.org 0x00516530 - 0x401000
.globl FUN_00516530
FUN_00516530:
    # block 0x00516530: entry, 10 instruction(s), ends with jne to 0x00516583 (forward)
    push ebp                                     # 00516530
    {load} mov ebp, esp                          # 00516531
    push edi                                     # 00516533
    push esi                                     # 00516534
    push ebx                                     # 00516535
    mov esi, dword ptr [ebp + arg_c]             # 00516536
    mov edi, dword ptr [ebp + arg_8]             # 00516539
    lea eax, [0x63cb14]                          # 0051653c
    cmp dword ptr [eax + field_8], 0x0           # 00516542
    jne.d8 L_00516583                            # 00516546
    # block 0x00516548: entered by fall-through of jne at 0x00516546, 2 instruction(s), falls into the block at 0x0051654c
    mov al, -0x1                                 # 00516548
    {load} mov edi, edi                          # 0051654a
L_0051654c:
    # block 0x0051654c: entered by je at 0x00516558; je at 0x00516578, 2 instruction(s), ends with je to 0x0051657e (forward)
    {load} or al, al                             # 0051654c
    je.d8 L_0051657e                             # 0051654e
    # block 0x00516550: entered by fall-through of je at 0x0051654e, 6 instruction(s), ends with je to 0x0051654c (backward)
    mov al, byte ptr [esi]                       # 00516550
    inc esi                                      # 00516552
    mov ah, byte ptr [edi]                       # 00516553
    inc edi                                      # 00516555
    {store} cmp ah, al                           # 00516556
    je.d8 L_0051654c                             # 00516558
    # block 0x0051655a: entered by fall-through of je at 0x00516558, 15 instruction(s), ends with je to 0x0051654c (backward)
    sub al, 0x41                                 # 0051655a
    cmp al, 0x1a                                 # 0051655c
    {load} sbb cl, cl                            # 0051655e
    and cl, 0x20                                 # 00516560
    {load} add al, cl                            # 00516563
    add al, 0x41                                 # 00516565
    {load} xchg ah, al                           # 00516567
    sub al, 0x41                                 # 00516569
    cmp al, 0x1a                                 # 0051656b
    {load} sbb cl, cl                            # 0051656d
    and cl, 0x20                                 # 0051656f
    {load} add al, cl                            # 00516572
    add al, 0x41                                 # 00516574
    {store} cmp al, ah                           # 00516576
    je.d8 L_0051654c                             # 00516578
    # block 0x0051657a: entered by fall-through of je at 0x00516578, 2 instruction(s), falls into the block at 0x0051657e
    {load} sbb al, al                            # 0051657a
    sbb al, -0x1                                 # 0051657c
L_0051657e:
    # block 0x0051657e: entered by je at 0x0051654e, 2 instruction(s), ends with forward jump to 0x005165fb
    movsx eax, al                                # 0051657e
    jmp.d8 L_005165fb                            # 00516581
L_00516583:
    # block 0x00516583: entered by jne at 0x00516546, 4 instruction(s), ends with jg to 0x00516597 (forward)
    lock                                         # 00516583
    inc dword ptr [0x63cee8]                     # 00516584
    cmp dword ptr [0x63cee4], 0x0                # 0051658a
    jg.d8 L_00516597                             # 00516591
    # block 0x00516593: entered by fall-through of jg at 0x00516591, 2 instruction(s), ends with forward jump to 0x005165ac
    push 0x0                                     # 00516593
    jmp.d8 L_005165ac                            # 00516595
L_00516597:
    # block 0x00516597: entered by jg at 0x00516591, 5 instruction(s), calls FUN_00512c18, falls into the block at 0x005165ac
    lock                                         # 00516597
    dec dword ptr [0x63cee8]                     # 00516598
    push 0x13                                    # 0051659e
    call FUN_00512c18                            # 005165a0
    mov dword ptr [esp], 0x1                     # 005165a5
L_005165ac:
    # block 0x005165ac: entered by jmp at 0x00516595, 3 instruction(s), falls into the block at 0x005165b4
    mov eax, 0xff                                # 005165ac
    {load} xor ebx, ebx                          # 005165b1
    nop                                          # 005165b3
L_005165b4:
    # block 0x005165b4: entered by je at 0x005165c0; je at 0x005165d8, 2 instruction(s), ends with je to 0x005165df (forward)
    {load} or al, al                             # 005165b4
    je.d8 L_005165df                             # 005165b6
    # block 0x005165b8: entered by fall-through of je at 0x005165b6, 6 instruction(s), ends with je to 0x005165b4 (backward)
    mov al, byte ptr [esi]                       # 005165b8
    inc esi                                      # 005165ba
    mov bl, byte ptr [edi]                       # 005165bb
    inc edi                                      # 005165bd
    {store} cmp al, bl                           # 005165be
    je.d8 L_005165b4                             # 005165c0
    # block 0x005165c2: entered by fall-through of je at 0x005165c0, 9 instruction(s), calls FUN_00512f53, ends with je to 0x005165b4 (backward)
    push eax                                     # 005165c2
    push ebx                                     # 005165c3
    call FUN_00512f53                            # 005165c4
    {load} mov ebx, eax                          # 005165c9
    add esp, 0x4                                 # 005165cb
    call FUN_00512f53                            # 005165ce
    add esp, 0x4                                 # 005165d3
    {store} cmp bl, al                           # 005165d6
    je.d8 L_005165b4                             # 005165d8
    # block 0x005165da: entered by fall-through of je at 0x005165d8, 2 instruction(s), falls into the block at 0x005165df
    {load} sbb eax, eax                          # 005165da
    sbb eax, -0x1                                # 005165dc
L_005165df:
    # block 0x005165df: entered by je at 0x005165b6, 4 instruction(s), ends with jne to 0x005165ef (forward)
    {load} mov ebx, eax                          # 005165df
    pop eax                                      # 005165e1
    {load} or eax, eax                           # 005165e2
    jne.d8 L_005165ef                            # 005165e4
    # block 0x005165e6: entered by fall-through of jne at 0x005165e4, 3 instruction(s), ends with forward jump to 0x005165f9
    lock                                         # 005165e6
    dec dword ptr [0x63cee8]                     # 005165e7
    jmp.d8 L_005165f9                            # 005165ed
L_005165ef:
    # block 0x005165ef: entered by jne at 0x005165e4, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x005165f9
    push 0x13                                    # 005165ef
    call FUN_00512c79                            # 005165f1
    add esp, 0x4                                 # 005165f6
L_005165f9:
    # block 0x005165f9: entered by jmp at 0x005165ed, 1 instruction(s), falls into the block at 0x005165fb
    {load} mov eax, ebx                          # 005165f9
L_005165fb:
    # block 0x005165fb: entered by jmp at 0x00516581, 5 instruction(s), ends with ret
    pop ebx                                      # 005165fb
    pop esi                                      # 005165fc
    pop edi                                      # 005165fd
    leave                                        # 005165fe
    ret                                          # 005165ff

