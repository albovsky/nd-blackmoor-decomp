# FUN_004d335c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d335c
# extent:       0x004d335c-0x004d341d (193 code bytes)
# span:         0x004d335c-0x004d341d (code 193, tables 0, padding 0)
# sha256:       8c4ffd46267c0f730fffb6cdea65760e97d6160fdceb1be93d8c13028ba2bba9
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d335c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee673, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004d335c - 0x401000
.globl FUN_004d335c
FUN_004d335c:
    # block 0x004d335c: entry, 25 instruction(s), calls FUN_004ee673, FUN_0050ce04, ends with jge to 0x004d33cb (forward)
    push ebp                                     # 004d335c
    {load} mov ebp, esp                          # 004d335d
    sub esp, 0x10                                # 004d335f
    movsx eax, word ptr [ebp + arg_8]            # 004d3362
    push eax                                     # 004d3366
    mov ecx, 0x582711                            # 004d3367
    call FUN_004ee673                            # 004d336c
    movsx ecx, word ptr [ebp + arg_8]            # 004d3371
    mov dword ptr [ebp - local_4], ecx           # 004d3375
    fild dword ptr [ebp - local_4]               # 004d3378
    fstp dword ptr [ebp - local_8]               # 004d337b
    fld dword ptr [ebp - local_8]                # 004d337e
    fdiv dword ptr [0x52cbec]                    # 004d3381
    fstp dword ptr [0x5b0a78]                    # 004d3387
    movsx edx, word ptr [0x5b0a7c]               # 004d338d
    mov dword ptr [ebp - local_c], edx           # 004d3394
    fild dword ptr [ebp - local_c]               # 004d3397
    fstp dword ptr [ebp - local_10]              # 004d339a
    fld dword ptr [0x5b0a78]                     # 004d339d
    fmul dword ptr [ebp - local_10]              # 004d33a3
    call FUN_0050ce04                            # 004d33a6
    mov dword ptr [0x5b0a82], eax                # 004d33ab
    mov eax, dword ptr [0x5b0a82]                # 004d33b0
    cmp eax, dword ptr [0x5b0a26]                # 004d33b5
    jge.d8 L_004d33cb                            # 004d33bb
    # block 0x004d33bd: entered by fall-through of jge at 0x004d33bb, 3 instruction(s), ends with forward jump to 0x004d3400
    mov ecx, dword ptr [0x5b0a26]                # 004d33bd
    mov dword ptr [0x5b0a82], ecx                # 004d33c3
    jmp.d8 L_004d3400                            # 004d33c9
L_004d33cb:
    # block 0x004d33cb: entered by jge at 0x004d33bb, 6 instruction(s), ends with jle to 0x004d3400 (forward)
    mov edx, dword ptr [0x5b0a1e]                # 004d33cb
    sub edx, dword ptr [0x5b0a16]                # 004d33d1
    mov eax, dword ptr [0x5b0a82]                # 004d33d7
    {load} add eax, edx                          # 004d33dc
    cmp eax, dword ptr [0x5b0a2e]                # 004d33de
    jle.d8 L_004d3400                            # 004d33e4
    # block 0x004d33e6: entered by fall-through of jle at 0x004d33e4, 5 instruction(s), falls into the block at 0x004d3400
    mov ecx, dword ptr [0x5b0a1e]                # 004d33e6
    sub ecx, dword ptr [0x5b0a16]                # 004d33ec
    mov edx, dword ptr [0x5b0a2e]                # 004d33f2
    {load} sub edx, ecx                          # 004d33f8
    mov dword ptr [0x5b0a82], edx                # 004d33fa
L_004d3400:
    # block 0x004d3400: entered by jmp at 0x004d33c9; jle at 0x004d33e4, 8 instruction(s), ends with ret
    mov eax, dword ptr [0x5b0a1e]                # 004d3400
    sub eax, dword ptr [0x5b0a16]                # 004d3405
    mov ecx, dword ptr [0x5b0a82]                # 004d340b
    {load} add ecx, eax                          # 004d3411
    mov dword ptr [0x5b0a8a], ecx                # 004d3413
    {load} mov esp, ebp                          # 004d3419
    pop ebp                                      # 004d341b
    ret                                          # 004d341c

