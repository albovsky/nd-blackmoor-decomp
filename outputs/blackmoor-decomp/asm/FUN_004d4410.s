# FUN_004d4410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4410
# extent:       0x004d4410-0x004d4645 (565 code bytes)
# span:         0x004d4410-0x004d4645 (code 565, tables 0, padding 0)
# sha256:       51860dad2e2be288d744b9146a0ff2c359505f58e0bc64df5e7183d78c295df3
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_credits_scroll_update
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d4410.c.txt, not original source) refers to the data labelled s_pDFSCredits_0055a554, s_trans_pDFSCreditsText_0055a56c
# name-note:    Per-frame credits update: blits pDFSCredits and the scrolled trans_pDFSCreditsText, advances scroll state on a tick timer and loads the next text page.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dadff, FUN_004c5377, KERNEL32.dll!GetTickCount, FUN_004d46b3, FUN_004c5d4b, FUN_004c4c2b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 123 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c4c2b, .text + (0x004c4c2b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004d46b3, .text + (0x004d46b3 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)

.org 0x004d4410 - 0x401000
.globl FUN_004d4410
FUN_004d4410:
    # block 0x004d4410: entry, 11 instruction(s), calls FUN_004dadff, ends with jg to 0x004d446d (forward)
    push ebp                                     # 004d4410
    {load} mov ebp, esp                          # 004d4411
    push ecx                                     # 004d4413
    mov ecx, 0x5830a6                            # 004d4414
    call FUN_004dadff                            # 004d4419
    mov ax, word ptr [0x5b00e9]                  # 004d441e
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d4424
    mov word ptr [0x5b00e9], ax                  # 004d4428
    movsx ecx, word ptr [0x5b00e9]               # 004d442e
    cmp ecx, 0x2                                 # 004d4435
    jg.d8 L_004d446d                             # 004d4438
    # block 0x004d443a: entered by fall-through of jg at 0x004d4438, 3 instruction(s), ends with jle to 0x004d446d (forward)
    movsx edx, word ptr [0x5b00e9]               # 004d443a
    test edx, edx                                # 004d4441
    jle.d8 L_004d446d                            # 004d4443
    # block 0x004d4445: entered by fall-through of jle at 0x004d4443, 10 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d4493
    push 0x55a554                                # 004d4445
    push 0x5b0074                                # 004d444a
    push 0x5b0074                                # 004d444f
    mov eax, dword ptr [0x5cf665]                # 004d4454
    push eax                                     # 004d4459
    mov ecx, dword ptr [0x5d0387]                # 004d445a
    push ecx                                     # 004d4460
    mov ecx, 0x5cf659                            # 004d4461
    call FUN_004c5377                            # 004d4466
    jmp.d8 L_004d4493                            # 004d446b
L_004d446d:
    # block 0x004d446d: entered by jg at 0x004d4438; jle at 0x004d4443, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004d4493
    push 0x55a560                                # 004d446d
    push 0x5b0094                                # 004d4472
    push 0x5b0094                                # 004d4477
    mov edx, dword ptr [0x5cf665]                # 004d447c
    push edx                                     # 004d4482
    mov eax, dword ptr [0x5d0387]                # 004d4483
    push eax                                     # 004d4488
    mov ecx, 0x5cf659                            # 004d4489
    call FUN_004c5377                            # 004d448e
L_004d4493:
    # block 0x004d4493: entered by jmp at 0x004d446b, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004d45fa (forward)
    call dword ptr [0x52a23c]                    # 004d4493
    cmp eax, dword ptr [0x5b00eb]                # 004d4499
    jb.d32 L_004d45fa                            # 004d449f
    # block 0x004d44a5: entered by fall-through of jb at 0x004d449f, 4 instruction(s), ends with je to 0x004d44c9 (forward)
    mov ecx, dword ptr [0x5b010f]                # 004d44a5
    mov dword ptr [ebp - local_4], ecx           # 004d44ab
    cmp dword ptr [ebp - local_4], 0x0           # 004d44ae
    je.d8 L_004d44c9                             # 004d44b2
    # block 0x004d44b4: entered by fall-through of je at 0x004d44b2, 2 instruction(s), ends with je to 0x004d4532 (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 004d44b4
    je.d8 L_004d4532                             # 004d44b8
    # block 0x004d44ba: entered by fall-through of je at 0x004d44b8, 2 instruction(s), ends with je to 0x004d459a (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 004d44ba
    je.d32 L_004d459a                            # 004d44be
    # block 0x004d44c4: entered by fall-through of je at 0x004d44be, 1 instruction(s), ends with forward jump to 0x004d45e6
    jmp.d32 L_004d45e6                           # 004d44c4
L_004d44c9:
    # block 0x004d44c9: entered by je at 0x004d44b2, 7 instruction(s), ends with jle to 0x004d4500 (forward)
    movsx edx, word ptr [0x5b00b6]               # 004d44c9
    mov eax, dword ptr [0x5b00fb]                # 004d44d0
    {load} add eax, edx                          # 004d44d5
    mov dword ptr [0x5b00fb], eax                # 004d44d7
    mov ecx, dword ptr [0x5b00fb]                # 004d44dc
    cmp ecx, dword ptr [0x5b00b0]                # 004d44e2
    jle.d8 L_004d4500                            # 004d44e8
    # block 0x004d44ea: entered by fall-through of jle at 0x004d44e8, 3 instruction(s), falls into the block at 0x004d4500
    mov edx, dword ptr [0x5b00b0]                # 004d44ea
    mov dword ptr [0x5b00fb], edx                # 004d44f0
    mov dword ptr [0x5b010f], 0x1                # 004d44f6
L_004d4500:
    # block 0x004d4500: entered by jle at 0x004d44e8, 7 instruction(s), ends with jge to 0x004d452d (forward)
    movsx eax, word ptr [0x5b00b6]               # 004d4500
    mov ecx, dword ptr [0x5b0103]                # 004d4507
    {load} sub ecx, eax                          # 004d450d
    mov dword ptr [0x5b0103], ecx                # 004d450f
    mov edx, dword ptr [0x5b0103]                # 004d4515
    cmp edx, dword ptr [0x5b0098]                # 004d451b
    jge.d8 L_004d452d                            # 004d4521
    # block 0x004d4523: entered by fall-through of jge at 0x004d4521, 2 instruction(s), falls into the block at 0x004d452d
    mov eax, dword ptr [0x5b0098]                # 004d4523
    mov dword ptr [0x5b0103], eax                # 004d4528
L_004d452d:
    # block 0x004d452d: entered by jge at 0x004d4521, 1 instruction(s), ends with forward jump to 0x004d45e6
    jmp.d32 L_004d45e6                           # 004d452d
L_004d4532:
    # block 0x004d4532: entered by je at 0x004d44b8, 11 instruction(s), ends with jle to 0x004d4598 (forward)
    movsx ecx, word ptr [0x5b00b6]               # 004d4532
    mov edx, dword ptr [0x5b00fb]                # 004d4539
    {load} add edx, ecx                          # 004d453f
    mov dword ptr [0x5b00fb], edx                # 004d4541
    movsx eax, word ptr [0x5b00b6]               # 004d4547
    mov ecx, dword ptr [0x5b00f3]                # 004d454e
    {load} add ecx, eax                          # 004d4554
    mov dword ptr [0x5b00f3], ecx                # 004d4556
    mov edx, dword ptr [0x5b00fb]                # 004d455c
    cmp edx, dword ptr [0x5b0090]                # 004d4562
    jle.d8 L_004d4598                            # 004d4568
    # block 0x004d456a: entered by fall-through of jle at 0x004d4568, 8 instruction(s), falls into the block at 0x004d4598
    mov eax, dword ptr [0x5b0090]                # 004d456a
    mov dword ptr [0x5b00fb], eax                # 004d456f
    mov ecx, dword ptr [0x5b00b0]                # 004d4574
    sub ecx, dword ptr [0x5b00a8]                # 004d457a
    mov edx, dword ptr [0x5b00fb]                # 004d4580
    {load} sub edx, ecx                          # 004d4586
    mov dword ptr [0x5b00f3], edx                # 004d4588
    mov dword ptr [0x5b010f], 0x2                # 004d458e
L_004d4598:
    # block 0x004d4598: entered by jle at 0x004d4568, 1 instruction(s), ends with forward jump to 0x004d45e6
    jmp.d8 L_004d45e6                            # 004d4598
L_004d459a:
    # block 0x004d459a: entered by je at 0x004d44be, 8 instruction(s), ends with jl to 0x004d45d1 (forward)
    movsx eax, word ptr [0x5b00b6]               # 004d459a
    mov ecx, dword ptr [0x5b00f3]                # 004d45a1
    {load} add ecx, eax                          # 004d45a7
    mov dword ptr [0x5b00f3], ecx                # 004d45a9
    mov edx, dword ptr [0x5b0090]                # 004d45af
    sub edx, 0x1                                 # 004d45b5
    cmp dword ptr [0x5b00f3], edx                # 004d45b8
    jl.d8 L_004d45d1                             # 004d45be
    # block 0x004d45c0: entered by fall-through of jl at 0x004d45be, 3 instruction(s), calls FUN_004d46b3, ends with forward jump to 0x004d4641
    call FUN_004d46b3                            # 004d45c0
    mov dword ptr [0x5b010f], 0x0                # 004d45c5
    jmp.d8 L_004d4641                            # 004d45cf
L_004d45d1:
    # block 0x004d45d1: entered by jl at 0x004d45be, 4 instruction(s), falls into the block at 0x004d45e6
    movsx eax, word ptr [0x5b00b6]               # 004d45d1
    mov ecx, dword ptr [0x5b010b]                # 004d45d8
    {load} sub ecx, eax                          # 004d45de
    mov dword ptr [0x5b010b], ecx                # 004d45e0
L_004d45e6:
    # block 0x004d45e6: entered by jmp at 0x004d44c4; jmp at 0x004d452d; jmp at 0x004d4598, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004d45fa
    call dword ptr [0x52a23c]                    # 004d45e6
    movsx edx, word ptr [0x5b00b4]               # 004d45ec
    {load} add eax, edx                          # 004d45f3
    mov dword ptr [0x5b00eb], eax                # 004d45f5
L_004d45fa:
    # block 0x004d45fa: entered by jb at 0x004d449f, 13 instruction(s), calls FUN_004c5d4b, ends with jne to 0x004d4637 (forward)
    push 0x55a56c                                # 004d45fa
    push 0x5b00ff                                # 004d45ff
    push 0x5b00ef                                # 004d4604
    mov eax, dword ptr [0x5cf665]                # 004d4609
    push eax                                     # 004d460e
    mov ecx, dword ptr [0x5d038b]                # 004d460f
    push ecx                                     # 004d4615
    mov ecx, 0x5cf659                            # 004d4616
    call FUN_004c5d4b                            # 004d461b
    {load} xor edx, edx                          # 004d4620
    mov dl, byte ptr [0x58321d]                  # 004d4622
    cmp edx, 0x1                                 # 004d4628
    jne.d8 L_004d4637                            # 004d462b
    # block 0x004d462d: entered by fall-through of jne at 0x004d462b, 1 instruction(s), falls into the block at 0x004d4637
    mov dword ptr [0x583991], 0x4                # 004d462d
L_004d4637:
    # block 0x004d4637: entered by jne at 0x004d462b, 2 instruction(s), calls FUN_004c4c2b, falls into the block at 0x004d4641
    mov ecx, 0x5cf659                            # 004d4637
    call FUN_004c4c2b                            # 004d463c
L_004d4641:
    # block 0x004d4641: entered by jmp at 0x004d45cf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d4641
    pop ebp                                      # 004d4643
    ret                                          # 004d4644

