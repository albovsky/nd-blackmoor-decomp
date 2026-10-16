# FUN_004c1451
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c1451
# extent:       0x004c1451-0x004c1572 (289 code bytes)
# span:         0x004c1451-0x004c1572 (code 289, tables 0, padding 0)
# sha256:       eb41cb922143865c5bebd7e34e048239357803cd1442e9f986444f2f864062ce
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c1451
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_c
# callees:      calls FUN_00525371, USER32.dll!LoadIconA, GDI32.dll!GetStockObject, USER32.dll!LoadCursorA, FUN_0051b7c1, FUN_0051dc43, FUN_004264e8, FUN_004c97b4, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051b7c1, .text + (0x0051b7c1 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x004c1451 - 0x401000
.globl FUN_004c1451
FUN_004c1451:
    # block 0x004c1451: entry, 47 instruction(s), calls FUN_00525371, USER32.dll!LoadIconA, GDI32.dll!GetStockObject, USER32.dll!LoadCursorA, FUN_0051b7c..., ends with jne to 0x004c14fc (forward)
    push ebp                                     # 004c1451
    {load} mov ebp, esp                          # 004c1452
    sub esp, 0x18                                # 004c1454
    push esi                                     # 004c1457
    push edi                                     # 004c1458
    mov dword ptr [ebp - local_18], ecx          # 004c1459
    call FUN_00525371                            # 004c145c
    mov eax, dword ptr [eax + field_c]           # 004c1461
    mov dword ptr [ebp - local_10], eax          # 004c1464
    call FUN_00525371                            # 004c1467
    mov ecx, dword ptr [eax + field_c]           # 004c146c
    mov dword ptr [ebp - local_14], ecx          # 004c146f
    push 0x80                                    # 004c1472
    mov edx, dword ptr [ebp - local_10]          # 004c1477
    push edx                                     # 004c147a
    call dword ptr [0x52a4a0]                    # 004c147b
    push eax                                     # 004c1481
    push 0x4                                     # 004c1482
    call dword ptr [0x52a0ac]                    # 004c1484
    push eax                                     # 004c148a
    push 0x99                                    # 004c148b
    mov eax, dword ptr [ebp - local_14]          # 004c1490
    push eax                                     # 004c1493
    call dword ptr [0x52a4a4]                    # 004c1494
    push eax                                     # 004c149a
    push 0x8b                                    # 004c149b
    call FUN_0051b7c1                            # 004c14a0
    mov dword ptr [ebp - local_4], eax           # 004c14a5
    mov edi, dword ptr [ebp - local_4]           # 004c14a8
    or ecx, -0x1                                 # 004c14ab
    {load} xor eax, eax                          # 004c14ae
    repne scasb al, byte ptr es:[edi]            # 004c14b0
    not ecx                                      # 004c14b2
    add ecx, -0x1                                # 004c14b4
    mov dword ptr [ebp - local_8], ecx           # 004c14b7
    mov ecx, dword ptr [ebp - local_8]           # 004c14ba
    add ecx, 0x1                                 # 004c14bd
    mov dword ptr [ebp - local_8], ecx           # 004c14c0
    mov edx, dword ptr [ebp - local_8]           # 004c14c3
    push edx                                     # 004c14c6
    call FUN_0051dc43                            # 004c14c7
    add esp, 0x4                                 # 004c14cc
    mov dword ptr [ebp - local_c], eax           # 004c14cf
    mov eax, dword ptr [ebp - local_c]           # 004c14d2
    mov dword ptr [0x570448], eax                # 004c14d5
    cmp dword ptr [0x570448], 0x0                # 004c14da
    jne.d8 L_004c14fc                            # 004c14e1
    # block 0x004c14e3: entered by fall-through of jne at 0x004c14e1, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c156c
    push 0x552cd4                                # 004c14e3
    mov ecx, 0x583979                            # 004c14e8
    call FUN_004264e8                            # 004c14ed
    mov ecx, dword ptr [ebp - local_18]          # 004c14f2
    call FUN_004c97b4                            # 004c14f5
    jmp.d8 L_004c156c                            # 004c14fa
L_004c14fc:
    # block 0x004c14fc: entered by jne at 0x004c14e1, 27 instruction(s), ends with je to 0x004c156c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c14fc
    {load} xor eax, eax                          # 004c14ff
    mov edi, dword ptr [0x570448]                # 004c1501
    {load} mov edx, ecx                          # 004c1507
    shr ecx, 0x2                                 # 004c1509
    rep stosd dword ptr es:[edi], eax            # 004c150c
    {load} mov ecx, edx                          # 004c150e
    and ecx, 0x3                                 # 004c1510
    rep stosb byte ptr es:[edi], al              # 004c1513
    mov edi, dword ptr [ebp - local_4]           # 004c1515
    mov edx, dword ptr [0x570448]                # 004c1518
    or ecx, -0x1                                 # 004c151e
    {load} xor eax, eax                          # 004c1521
    repne scasb al, byte ptr es:[edi]            # 004c1523
    not ecx                                      # 004c1525
    {load} sub edi, ecx                          # 004c1527
    {load} mov esi, edi                          # 004c1529
    {load} mov eax, ecx                          # 004c152b
    {load} mov edi, edx                          # 004c152d
    shr ecx, 0x2                                 # 004c152f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c1532
    {load} mov ecx, eax                          # 004c1534
    and ecx, 0x3                                 # 004c1536
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c1539
    movsx ecx, word ptr [0x63a4cd]               # 004c153b
    test ecx, ecx                                # 004c1542
    je.d8 L_004c156c                             # 004c1544
    # block 0x004c1546: entered by fall-through of je at 0x004c1544, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c156c
    mov edx, dword ptr [0x570448]                # 004c1546
    push edx                                     # 004c154c
    push 0x552d2c                                # 004c154d
    push 0x63888b                                # 004c1552
    call FUN_0050ca3e                            # 004c1557
    add esp, 0xc                                 # 004c155c
    push 0x63888b                                # 004c155f
    call FUN_0044a2b7                            # 004c1564
    add esp, 0x4                                 # 004c1569
L_004c156c:
    # block 0x004c156c: entered by jmp at 0x004c14fa; je at 0x004c1544, 5 instruction(s), ends with ret
    pop edi                                      # 004c156c
    pop esi                                      # 004c156d
    {load} mov esp, ebp                          # 004c156e
    pop ebp                                      # 004c1570
    ret                                          # 004c1571

