# FUN_0050b500
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b500
# extent:       0x0050b500-0x0050b57a (122 code bytes)
# span:         0x0050b500-0x0050b580 (code 122, tables 0, padding 6)
# sha256:       0c2c025314cf774eaa17583ecc566d6cc19217636ab76a1c35f79a8ef4db4fc8
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b500
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1000; [esi + n] field_4, field_8, field_c; [esp + n] stk_8, stk_c
# callees:      calls FUN_0050ed50, FUN_0050ebca, FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_1000, 0x1000  # offset +0x1000

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)

.org 0x0050b500 - 0x401000
.globl FUN_0050b500
FUN_0050b500:
    # block 0x0050b500: entry, 5 instruction(s), ends with je to 0x0050b52e (forward)
    push esi                                     # 0050b500
    mov esi, dword ptr [esp + stk_8]             # 0050b501
    mov eax, dword ptr [esi + field_c]           # 0050b505
    test eax, eax                                # 0050b508
    je.d8 L_0050b52e                             # 0050b50a
    # block 0x0050b50c: entered by fall-through of je at 0x0050b50a, 5 instruction(s), ends with jle to 0x0050b527 (forward)
    mov edx, dword ptr [esi + field_8]           # 0050b50c
    {load} sub edx, eax                          # 0050b50f
    test edx, edx                                # 0050b511
    mov dword ptr [esi + field_8], edx           # 0050b513
    jle.d8 L_0050b527                            # 0050b516
    # block 0x0050b518: entered by fall-through of jle at 0x0050b516, 7 instruction(s), calls FUN_0050ed50, falls into the block at 0x0050b527
    mov ecx, dword ptr [esi]                     # 0050b518
    push edx                                     # 0050b51a
    {load} add eax, ecx                          # 0050b51b
    push eax                                     # 0050b51d
    push ecx                                     # 0050b51e
    call FUN_0050ed50                            # 0050b51f
    add esp, 0xc                                 # 0050b524
L_0050b527:
    # block 0x0050b527: entered by jle at 0x0050b516, 1 instruction(s), falls into the block at 0x0050b52e
    mov dword ptr [esi + field_c], 0x0           # 0050b527
L_0050b52e:
    # block 0x0050b52e: entered by je at 0x0050b50a, 6 instruction(s), ends with jle to 0x0050b571 (forward)
    mov eax, dword ptr [esi + field_8]           # 0050b52e
    mov edx, dword ptr [esi + field_4]           # 0050b531
    mov ecx, dword ptr [esp + stk_c]             # 0050b534
    {load} sub edx, eax                          # 0050b538
    {load} cmp ecx, edx                          # 0050b53a
    jle.d8 L_0050b571                            # 0050b53c
    # block 0x0050b53e: entered by fall-through of jle at 0x0050b53c, 6 instruction(s), ends with je to 0x0050b563 (forward)
    push edi                                     # 0050b53e
    lea edi, [eax + ecx + field_1000]            # 0050b53f
    mov eax, dword ptr [esi]                     # 0050b546
    push edi                                     # 0050b548
    test eax, eax                                # 0050b549
    je.d8 L_0050b563                             # 0050b54b
    # block 0x0050b54d: entered by fall-through of je at 0x0050b54b, 10 instruction(s), calls FUN_0050ebca, ends with ret
    push eax                                     # 0050b54d
    call FUN_0050ebca                            # 0050b54e
    mov ecx, dword ptr [esi + field_8]           # 0050b553
    add esp, 0x8                                 # 0050b556
    mov dword ptr [esi + field_4], edi           # 0050b559
    mov dword ptr [esi], eax                     # 0050b55c
    pop edi                                      # 0050b55e
    {load} add eax, ecx                          # 0050b55f
    pop esi                                      # 0050b561
    ret                                          # 0050b562
L_0050b563:
    # block 0x0050b563: entered by je at 0x0050b54b, 5 instruction(s), calls FUN_0050ea90, falls into the block at 0x0050b571
    call FUN_0050ea90                            # 0050b563
    add esp, 0x4                                 # 0050b568
    mov dword ptr [esi + field_4], edi           # 0050b56b
    mov dword ptr [esi], eax                     # 0050b56e
    pop edi                                      # 0050b570
L_0050b571:
    # block 0x0050b571: entered by jle at 0x0050b53c, 5 instruction(s), ends with ret
    mov eax, dword ptr [esi]                     # 0050b571
    mov ecx, dword ptr [esi + field_8]           # 0050b573
    {load} add eax, ecx                          # 0050b576
    pop esi                                      # 0050b578
    ret                                          # 0050b579

# --- data items (not part of the function) -------------------------
.org 0x0050b57a - 0x401000
PAD_0050b57a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

