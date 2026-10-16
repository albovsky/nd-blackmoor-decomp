# FUN_0052184f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052184f
# extent:       0x0052184f-0x005218ea (155 code bytes)
# span:         0x0052184f-0x005218ea (code 155, tables 0, padding 0)
# sha256:       4c9df518bdbf7f018ad33653c3b2f3a62fffc1ba4088de33a54d37337c99db5d
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052184f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esi + n] field_3c, field_40, field_5c, field_60, field_64, field_68, field_70, field_74, field_78, field_7c, field_84, field_88; [esp + n] stk_14, stk_1c
# callees:      calls FUN_0050f920, FUN_00525371, FUN_0051faaa, FUN_0051e36f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051e36f, .text + (0x0051e36f - 0x401000)
.set FUN_0051faaa, .text + (0x0051faaa - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0052184f - 0x401000
.globl FUN_0052184f
FUN_0052184f:
    # block 0x0052184f: entry, 17 instruction(s), calls FUN_0050f920, ends with je to 0x00521882 (forward)
    push ebx                                     # 0052184f
    push esi                                     # 00521850
    push edi                                     # 00521851
    push 0x28                                    # 00521852
    {load} mov esi, ecx                          # 00521854
    pop ebx                                      # 00521856
    push ebx                                     # 00521857
    push 0x0                                     # 00521858
    lea edi, [esi + field_5c]                    # 0052185a
    push edi                                     # 0052185d
    call FUN_0050f920                            # 0052185e
    mov dword ptr [edi], ebx                     # 00521863
    mov ebx, dword ptr [esp + stk_1c]            # 00521865
    add esp, 0xc                                 # 00521869
    mov dword ptr [esi + field_60], 0x80         # 0052186c
    test ebx, ebx                                # 00521873
    je.d8 L_00521882                             # 00521875
    # block 0x00521877: entered by fall-through of je at 0x00521875, 3 instruction(s), calls FUN_00525371, falls into the block at 0x00521882
    call FUN_00525371                            # 00521877
    mov eax, dword ptr [eax + field_c]           # 0052187c
    mov dword ptr [esi + field_64], eax          # 0052187f
L_00521882:
    # block 0x00521882: entered by je at 0x00521875, 6 instruction(s), ends with je to 0x005218b7 (forward)
    cmp dword ptr [esp + stk_14], 0x0            # 00521882
    mov dword ptr [esi + field_68], ebx          # 00521887
    mov dword ptr [esi + field_74], 0x51dc77     # 0052188a
    mov dword ptr [esi + field_78], esi          # 00521891
    mov dword ptr [esi + field_7c], 0x52178e     # 00521894
    je.d8 L_005218b7                             # 0052189b
    # block 0x0052189d: entered by fall-through of je at 0x0052189b, 7 instruction(s), calls FUN_0051faaa, falls into the block at 0x005218b7
    push dword ptr [esp + stk_14]                # 0052189d
    lea edi, [esi + field_84]                    # 005218a1
    {load} mov ecx, edi                          # 005218a7
    call FUN_0051faaa                            # 005218a9
    mov eax, dword ptr [edi]                     # 005218ae
    or dword ptr [esi + field_60], 0x8           # 005218b0
    mov dword ptr [esi + field_70], eax          # 005218b4
L_005218b7:
    # block 0x005218b7: entered by je at 0x0052189b, 3 instruction(s), calls FUN_0051e36f, ends with je to 0x005218c4 (forward)
    call FUN_0051e36f                            # 005218b7
    test eax, eax                                # 005218bc
    je.d8 L_005218c4                             # 005218be
    # block 0x005218c0: entered by fall-through of je at 0x005218be, 1 instruction(s), falls into the block at 0x005218c4
    or dword ptr [esi + field_60], 0x20          # 005218c0
L_005218c4:
    # block 0x005218c4: entered by je at 0x005218be, 4 instruction(s), ends with jne to 0x005218d4 (forward)
    {load} mov eax, ebx                          # 005218c4
    shr eax, 0x10                                # 005218c6
    test ax, ax                                  # 005218c9
    jne.d8 L_005218d4                            # 005218cc
    # block 0x005218ce: entered by fall-through of jne at 0x005218cc, 2 instruction(s), falls into the block at 0x005218d4
    movzx eax, bx                                # 005218ce
    mov dword ptr [esi + field_3c], eax          # 005218d1
L_005218d4:
    # block 0x005218d4: entered by jne at 0x005218cc, 7 instruction(s), ends with ret 0x8
    mov eax, dword ptr [esi + field_68]          # 005218d4
    mov dword ptr [esi + field_88], 0x1          # 005218d7
    mov dword ptr [esi + field_40], eax          # 005218e1
    pop edi                                      # 005218e4
    pop esi                                      # 005218e5
    pop ebx                                      # 005218e6
    ret 0x8                                      # 005218e7

