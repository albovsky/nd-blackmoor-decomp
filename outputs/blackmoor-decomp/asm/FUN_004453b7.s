# FUN_004453b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004453b7
# extent:       0x004453b7-0x0044550b (340 code bytes)
# span:         0x004453b7-0x0044551b (code 340, tables 16, padding 0)
# sha256:       48c0f42f928ec5aed0ec25bb10088615658b730a15d3443ca03003690aa23389
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_nnm90_record_builder
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4453b7.c.txt, not original source) refers to the data labelled s_NNM90_00548198
# name-note:    Picks a random variant of 4, fills a record with the NNM90 string and id 0x56e-0x571 via FUN_0043f210, then passes it to FUN_0041fd08.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 82 instruction(s), 2 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_42, 0x42  # offset -0x42
.equ local_1d2, 0x1d2  # offset -0x1d2
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004453b7 - 0x401000
.globl FUN_004453b7
FUN_004453b7:
    # block 0x004453b7: entry, 8 instruction(s), calls FUN_0050cd50, ends with jns to 0x004453d3 (forward)
    push ebp                                     # 004453b7
    {load} mov ebp, esp                          # 004453b8
    sub esp, 0x1dc                               # 004453ba
    push esi                                     # 004453c0
    push edi                                     # 004453c1
    call FUN_0050cd50                            # 004453c2
    and eax, 0x80000003                          # 004453c7
    jns.d8 L_004453d3                            # 004453cc
    # block 0x004453ce: entered by fall-through of jns at 0x004453cc, 3 instruction(s), falls into the block at 0x004453d3
    dec eax                                      # 004453ce
    or eax, -0x4                                 # 004453cf
    inc eax                                      # 004453d2
L_004453d3:
    # block 0x004453d3: entered by jns at 0x004453cc, 29 instruction(s), calls FUN_0043f210, ends with ja to 0x004454f4 (forward)
    mov word ptr [ebp - local_4], ax             # 004453d3
    push 0x548198                                # 004453d7
    push 0x63a824                                # 004453dc
    lea eax, [ebp - local_1d2]                   # 004453e1
    push eax                                     # 004453e7
    call FUN_0043f210                            # 004453e8
    add esp, 0xc                                 # 004453ed
    mov edi, 0x5481a0                            # 004453f0
    lea edx, [ebp - local_42]                    # 004453f5
    or ecx, -0x1                                 # 004453f8
    {load} xor eax, eax                          # 004453fb
    repne scasb al, byte ptr es:[edi]            # 004453fd
    not ecx                                      # 004453ff
    {load} sub edi, ecx                          # 00445401
    {load} mov esi, edi                          # 00445403
    {load} mov eax, ecx                          # 00445405
    {load} mov edi, edx                          # 00445407
    shr ecx, 0x2                                 # 00445409
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044540c
    {load} mov ecx, eax                          # 0044540e
    and ecx, 0x3                                 # 00445410
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445413
    mov dword ptr [ebp - local_18], 0x0          # 00445415
    mov dword ptr [ebp - local_14], 0x0          # 0044541c
    mov dword ptr [ebp - local_10], 0x1          # 00445423
    movsx ecx, word ptr [ebp - local_4]          # 0044542a
    mov dword ptr [ebp - local_1dc], ecx         # 0044542e
    cmp dword ptr [ebp - local_1dc], 0x3         # 00445434
    ja.d32 L_004454f4                            # 0044543b
    # block 0x00445441: entered by fall-through of ja at 0x0044543b, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x44550b]
    mov edx, dword ptr [ebp - local_1dc]         # 00445441
    jmp dword ptr [4*edx + SWTAB_0044550b_VA]    # 00445447
L_0044544e:
    # block 0x0044544e: entered by switch case, 8 instruction(s), ends with forward jump to 0x004454f4
    mov word ptr [ebp - local_20], 0x56e         # 0044544e
    mov word ptr [ebp - local_1e], 0x0           # 00445454
    mov word ptr [ebp - local_1c], 0x0           # 0044545a
    mov word ptr [ebp - local_1a], 0x1           # 00445460
    mov word ptr [ebp - local_c], 0xffff         # 00445466
    mov byte ptr [ebp - local_a], 0x0            # 0044546c
    mov word ptr [ebp - local_9], 0x2            # 00445470
    jmp.d8 L_004454f4                            # 00445476
L_00445478:
    # block 0x00445478: entered by switch case, 8 instruction(s), ends with forward jump to 0x004454f4
    mov word ptr [ebp - local_20], 0x56f         # 00445478
    mov word ptr [ebp - local_1e], 0x0           # 0044547e
    mov word ptr [ebp - local_1c], 0x0           # 00445484
    mov word ptr [ebp - local_1a], 0x1           # 0044548a
    mov word ptr [ebp - local_c], 0xffff         # 00445490
    mov byte ptr [ebp - local_a], 0x0            # 00445496
    mov word ptr [ebp - local_9], 0x2            # 0044549a
    jmp.d8 L_004454f4                            # 004454a0
L_004454a2:
    # block 0x004454a2: entered by switch case, 8 instruction(s), ends with forward jump to 0x004454f4
    mov word ptr [ebp - local_20], 0x570         # 004454a2
    mov word ptr [ebp - local_1e], 0x0           # 004454a8
    mov word ptr [ebp - local_1c], 0x0           # 004454ae
    mov word ptr [ebp - local_1a], 0x1           # 004454b4
    mov word ptr [ebp - local_c], 0xffff         # 004454ba
    mov byte ptr [ebp - local_a], 0x0            # 004454c0
    mov word ptr [ebp - local_9], 0x2            # 004454c4
    jmp.d8 L_004454f4                            # 004454ca
L_004454cc:
    # block 0x004454cc: entered by switch case, 7 instruction(s), falls into the block at 0x004454f4
    mov word ptr [ebp - local_20], 0x571         # 004454cc
    mov word ptr [ebp - local_1e], 0x0           # 004454d2
    mov word ptr [ebp - local_1c], 0x0           # 004454d8
    mov word ptr [ebp - local_1a], 0x1           # 004454de
    mov word ptr [ebp - local_c], 0xffff         # 004454e4
    mov byte ptr [ebp - local_a], 0x0            # 004454ea
    mov word ptr [ebp - local_9], 0x2            # 004454ee
L_004454f4:
    # block 0x004454f4: entered by ja at 0x0044543b; jmp at 0x00445476; jmp at 0x004454a0; jmp at 0x004454ca, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea eax, [ebp - local_1d8]                   # 004454f4
    push eax                                     # 004454fa
    mov ecx, 0x6177e8                            # 004454fb
    call FUN_0041fd08                            # 00445500
    pop edi                                      # 00445505
    pop esi                                      # 00445506
    {load} mov esp, ebp                          # 00445507
    pop ebp                                      # 00445509
    ret                                          # 0044550a

# --- data items (not part of the function) -------------------------
.org 0x0044550b - 0x401000
SWTAB_0044550b:  # 4 case address(es)
    .long L_0044544e - .text + 0x401000
    .long L_00445478 - .text + 0x401000
    .long L_004454a2 - .text + 0x401000
    .long L_004454cc - .text + 0x401000
.set SWTAB_0044550b_VA, SWTAB_0044550b - .text + 0x401000

