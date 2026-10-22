# FUN_0044a488
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a488
# extent:       0x0044a488-0x0044a554 (204 code bytes)
# span:         0x0044a488-0x0044a554 (code 204, tables 0, padding 0)
# sha256:       1031c1b4a6c1accead016b620dfe9d67cd6121a72aae7e18c7670ed83c7c70d0
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a488
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d8e0, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0044a488 - 0x401000
.globl FUN_0044a488
FUN_0044a488:
    # block 0x0044a488: entry, 18 instruction(s), ends with ja to 0x0044a511 (forward)
    push ebp                                     # 0044a488
    {load} mov ebp, esp                          # 0044a489
    push -0x1                                    # 0044a48b
    push 0x527f4c                                # 0044a48d
    mov eax, dword ptr fs:[0x0]                  # 0044a492
    push eax                                     # 0044a498
    mov dword ptr fs:[0x0], esp                  # 0044a499
    sub esp, 0x8                                 # 0044a4a0
    push edi                                     # 0044a4a3
    mov dword ptr [ebp - local_4], 0x0           # 0044a4a4
    mov edi, dword ptr [ebp + arg_8]             # 0044a4ab
    or ecx, -0x1                                 # 0044a4ae
    {load} xor eax, eax                          # 0044a4b1
    repne scasb al, byte ptr es:[edi]            # 0044a4b3
    not ecx                                      # 0044a4b5
    add ecx, -0x1                                # 0044a4b7
    cmp ecx, 0x8                                 # 0044a4ba
    ja.d8 L_0044a511                             # 0044a4bd
    # block 0x0044a4bf: entered by fall-through of ja at 0x0044a4bd, 8 instruction(s), ends with je to 0x0044a511 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0044a4bf
    or ecx, -0x1                                 # 0044a4c2
    {load} xor eax, eax                          # 0044a4c5
    repne scasb al, byte ptr es:[edi]            # 0044a4c7
    not ecx                                      # 0044a4c9
    add ecx, -0x1                                # 0044a4cb
    test ecx, ecx                                # 0044a4ce
    je.d8 L_0044a511                             # 0044a4d0
    # block 0x0044a4d2: entered by fall-through of je at 0x0044a4d0, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a511 (forward)
    push 0x548ae8                                # 0044a4d2
    mov eax, dword ptr [ebp + arg_8]             # 0044a4d7
    push eax                                     # 0044a4da
    call FUN_0050d8e0                            # 0044a4db
    add esp, 0x8                                 # 0044a4e0
    test eax, eax                                # 0044a4e3
    jne.d8 L_0044a511                            # 0044a4e5
    # block 0x0044a4e7: entered by fall-through of jne at 0x0044a4e5, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a511 (forward)
    push 0x548aec                                # 0044a4e7
    mov ecx, dword ptr [ebp + arg_8]             # 0044a4ec
    push ecx                                     # 0044a4ef
    call FUN_0050d8e0                            # 0044a4f0
    add esp, 0x8                                 # 0044a4f5
    test eax, eax                                # 0044a4f8
    jne.d8 L_0044a511                            # 0044a4fa
    # block 0x0044a4fc: entered by fall-through of jne at 0x0044a4fa, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0044a52c (forward)
    push 0x548af0                                # 0044a4fc
    mov edx, dword ptr [ebp + arg_8]             # 0044a501
    push edx                                     # 0044a504
    call FUN_0050d8e0                            # 0044a505
    add esp, 0x8                                 # 0044a50a
    test eax, eax                                # 0044a50d
    je.d8 L_0044a52c                             # 0044a50f
L_0044a511:
    # block 0x0044a511: entered by ja at 0x0044a4bd; je at 0x0044a4d0; jne at 0x0044a4e5; jne at 0x0044a4fa; more, 6 instruction(s), calls FUN_0051e7ba, ends with forward jump to 0x0044a545
    mov dword ptr [ebp - local_10], 0x0          # 0044a511
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044a518
    lea ecx, [ebp + arg_8]                       # 0044a51f
    call FUN_0051e7ba                            # 0044a522
    mov eax, dword ptr [ebp - local_10]          # 0044a527
    jmp.d8 L_0044a545                            # 0044a52a
L_0044a52c:
    # block 0x0044a52c: entered by je at 0x0044a50f, 5 instruction(s), calls FUN_0051e7ba, falls into the block at 0x0044a545
    mov dword ptr [ebp - local_14], 0x1          # 0044a52c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044a533
    lea ecx, [ebp + arg_8]                       # 0044a53a
    call FUN_0051e7ba                            # 0044a53d
    mov eax, dword ptr [ebp - local_14]          # 0044a542
L_0044a545:
    # block 0x0044a545: entered by jmp at 0x0044a52a, 6 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0044a545
    mov dword ptr fs:[0x0], ecx                  # 0044a548
    pop edi                                      # 0044a54f
    {load} mov esp, ebp                          # 0044a550
    pop ebp                                      # 0044a552
    ret                                          # 0044a553

