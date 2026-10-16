# FUN_0045b4ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b4ae
# extent:       0x0045b4ae-0x0045b568 (186 code bytes)
# span:         0x0045b4ae-0x0045b568 (code 186, tables 0, padding 0)
# sha256:       deb606e9ba087b3e85a16b377b66dae04cd1738b35d6f61032cd6343a635ffd6
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b4ae
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0045b4ae - 0x401000
.globl FUN_0045b4ae
FUN_0045b4ae:
    # block 0x0045b4ae: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0045b515 (forward)
    push ebp                                     # 0045b4ae
    {load} mov ebp, esp                          # 0045b4af
    sub esp, 0x8                                 # 0045b4b1
    push esi                                     # 0045b4b4
    push edi                                     # 0045b4b5
    mov dword ptr [ebp - local_8], ecx           # 0045b4b6
    push 0xb8e                                   # 0045b4b9
    call FUN_0051dc43                            # 0045b4be
    add esp, 0x4                                 # 0045b4c3
    mov dword ptr [ebp - local_4], eax           # 0045b4c6
    mov eax, dword ptr [ebp + arg_8]             # 0045b4c9
    mov ecx, dword ptr [ebp - local_4]           # 0045b4cc
    mov dword ptr [eax], ecx                     # 0045b4cf
    cmp dword ptr [ebp - local_4], 0x0           # 0045b4d1
    jne.d8 L_0045b515                            # 0045b4d5
    # block 0x0045b4d7: entered by fall-through of jne at 0x0045b4d5, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0045b515
    movsx edx, word ptr [0x5c39e3]               # 0045b4d7
    push edx                                     # 0045b4de
    mov eax, dword ptr [0x5bb57b]                # 0045b4df
    push eax                                     # 0045b4e4
    push 0x54aae4                                # 0045b4e5
    push 0x63888b                                # 0045b4ea
    call FUN_0050ca3e                            # 0045b4ef
    add esp, 0x10                                # 0045b4f4
    push 0x63888b                                # 0045b4f7
    push 0x54ab10                                # 0045b4fc
    mov ecx, 0x583979                            # 0045b501
    call FUN_0042639d                            # 0045b506
    mov ecx, 0x5cf659                            # 0045b50b
    call FUN_004c97b4                            # 0045b510
L_0045b515:
    # block 0x0045b515: entered by jne at 0x0045b4d5, 20 instruction(s), ends with je to 0x0045b560 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0045b515
    mov esi, dword ptr [ecx]                     # 0045b518
    mov edx, dword ptr [ebp + arg_8]             # 0045b51a
    mov edi, dword ptr [edx]                     # 0045b51d
    mov ecx, 0x2e3                               # 0045b51f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045b524
    movsw word ptr es:[edi], word ptr [esi]      # 0045b526
    mov eax, dword ptr [ebp + arg_10]            # 0045b528
    mov ecx, dword ptr [eax]                     # 0045b52b
    add ecx, 0xb8e                               # 0045b52d
    mov edx, dword ptr [ebp + arg_10]            # 0045b533
    mov dword ptr [edx], ecx                     # 0045b536
    mov eax, dword ptr [ebp + arg_c]             # 0045b538
    mov ecx, dword ptr [eax]                     # 0045b53b
    add ecx, 0xb8e                               # 0045b53d
    mov edx, dword ptr [ebp + arg_c]             # 0045b543
    mov dword ptr [edx], ecx                     # 0045b546
    movsx eax, word ptr [0x63a4cd]               # 0045b548
    test eax, eax                                # 0045b54f
    je.d8 L_0045b560                             # 0045b551
    # block 0x0045b553: entered by fall-through of je at 0x0045b551, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045b560
    push 0x54ab2c                                # 0045b553
    call FUN_0044a2b7                            # 0045b558
    add esp, 0x4                                 # 0045b55d
L_0045b560:
    # block 0x0045b560: entered by je at 0x0045b551, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0045b560
    pop esi                                      # 0045b561
    {load} mov esp, ebp                          # 0045b562
    pop ebp                                      # 0045b564
    ret 0xc                                      # 0045b565

