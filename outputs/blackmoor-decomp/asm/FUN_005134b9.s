# FUN_005134b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005134b9
# extent:       0x005134b9-0x00513546 (141 code bytes)
# span:         0x005134b9-0x00513546 (code 141, tables 0, padding 0)
# sha256:       675b324cd170f6b19826c3b2c3d744e931311907a4d7192ea0fa1150c73f902b
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005134b9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10, field_14, field_18; [esp + n] stk_8
# callees:      calls FUN_005166ab, FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_005166ab, .text + (0x005166ab - 0x401000)

.org 0x005134b9 - 0x401000
.globl FUN_005134b9
FUN_005134b9:
    # block 0x005134b9: entry, 7 instruction(s), calls FUN_005166ab, ends with je to 0x00513542 (forward)
    push esi                                     # 005134b9
    mov esi, dword ptr [esp + stk_8]             # 005134ba
    push dword ptr [esi + field_10]              # 005134be
    call FUN_005166ab                            # 005134c1
    test eax, eax                                # 005134c6
    pop ecx                                      # 005134c8
    je.d8 L_00513542                             # 005134c9
    # block 0x005134cb: entered by fall-through of je at 0x005134c9, 2 instruction(s), ends with jne to 0x005134d7 (forward)
    cmp esi, 0x568450                            # 005134cb
    jne.d8 L_005134d7                            # 005134d1
    # block 0x005134d3: entered by fall-through of jne at 0x005134d1, 2 instruction(s), ends with forward jump to 0x005134e2
    {load} xor eax, eax                          # 005134d3
    jmp.d8 L_005134e2                            # 005134d5
L_005134d7:
    # block 0x005134d7: entered by jne at 0x005134d1, 2 instruction(s), ends with jne to 0x00513542 (forward)
    cmp esi, 0x568470                            # 005134d7
    jne.d8 L_00513542                            # 005134dd
    # block 0x005134df: entered by fall-through of jne at 0x005134dd, 2 instruction(s), falls into the block at 0x005134e2
    push 0x1                                     # 005134df
    pop eax                                      # 005134e1
L_005134e2:
    # block 0x005134e2: entered by jmp at 0x005134d5, 3 instruction(s), ends with jne to 0x00513542 (forward)
    inc dword ptr [0x63ca9c]                     # 005134e2
    test word ptr [esi + field_c], 0x10c         # 005134e8
    jne.d8 L_00513542                            # 005134ee
    # block 0x005134f0: entered by fall-through of jne at 0x005134ee, 6 instruction(s), ends with jne to 0x00513528 (forward)
    cmp dword ptr [4*eax + 0x63cb34], 0x0        # 005134f0
    push ebx                                     # 005134f8
    push edi                                     # 005134f9
    lea edi, [4*eax + 0x63cb34]                  # 005134fa
    mov ebx, 0x1000                              # 00513501
    jne.d8 L_00513528                            # 00513506
    # block 0x00513508: entered by fall-through of jne at 0x00513506, 6 instruction(s), calls FUN_0050ea90, ends with jne to 0x00513528 (forward)
    push ebx                                     # 00513508
    call FUN_0050ea90                            # 00513509
    test eax, eax                                # 0051350e
    pop ecx                                      # 00513510
    mov dword ptr [edi], eax                     # 00513511
    jne.d8 L_00513528                            # 00513513
    # block 0x00513515: entered by fall-through of jne at 0x00513513, 8 instruction(s), ends with forward jump to 0x00513535
    lea eax, [esi + field_14]                    # 00513515
    push 0x2                                     # 00513518
    mov dword ptr [esi + field_8], eax           # 0051351a
    mov dword ptr [esi], eax                     # 0051351d
    pop eax                                      # 0051351f
    mov dword ptr [esi + field_18], eax          # 00513520
    mov dword ptr [esi + field_4], eax           # 00513523
    jmp.d8 L_00513535                            # 00513526
L_00513528:
    # block 0x00513528: entered by jne at 0x00513506; jne at 0x00513513, 5 instruction(s), falls into the block at 0x00513535
    mov edi, dword ptr [edi]                     # 00513528
    mov dword ptr [esi + field_18], ebx          # 0051352a
    mov dword ptr [esi + field_8], edi           # 0051352d
    mov dword ptr [esi], edi                     # 00513530
    mov dword ptr [esi + field_4], ebx           # 00513532
L_00513535:
    # block 0x00513535: entered by jmp at 0x00513526, 7 instruction(s), ends with ret
    .insn 0x6681/1, dword ptr [esi + field_c], 4354{:s16} # 00513535
    push 0x1                                     # 0051353b
    pop eax                                      # 0051353d
    pop edi                                      # 0051353e
    pop ebx                                      # 0051353f
    pop esi                                      # 00513540
    ret                                          # 00513541
L_00513542:
    # block 0x00513542: entered by je at 0x005134c9; jne at 0x005134dd; jne at 0x005134ee, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00513542
    pop esi                                      # 00513544
    ret                                          # 00513545

