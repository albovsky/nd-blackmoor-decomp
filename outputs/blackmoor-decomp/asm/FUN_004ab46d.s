# FUN_004ab46d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab46d
# extent:       0x004ab46d-0x004ab528 (187 code bytes)
# span:         0x004ab46d-0x004ab528 (code 187, tables 0, padding 0)
# sha256:       ac9216a51749a6337c87d1ac9fa8080ba41a892df04f95734ffef85995f11cc5
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab46d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004ab46d - 0x401000
.globl FUN_004ab46d
FUN_004ab46d:
    # block 0x004ab46d: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004ab4d4 (forward)
    push ebp                                     # 004ab46d
    {load} mov ebp, esp                          # 004ab46e
    sub esp, 0x8                                 # 004ab470
    push esi                                     # 004ab473
    push edi                                     # 004ab474
    mov dword ptr [ebp - local_8], ecx           # 004ab475
    push 0xbbf                                   # 004ab478
    call FUN_0051dc43                            # 004ab47d
    add esp, 0x4                                 # 004ab482
    mov dword ptr [ebp - local_4], eax           # 004ab485
    mov eax, dword ptr [ebp + arg_8]             # 004ab488
    mov ecx, dword ptr [ebp - local_4]           # 004ab48b
    mov dword ptr [eax], ecx                     # 004ab48e
    cmp dword ptr [ebp - local_4], 0x0           # 004ab490
    jne.d8 L_004ab4d4                            # 004ab494
    # block 0x004ab496: entered by fall-through of jne at 0x004ab494, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004ab4d4
    movsx edx, word ptr [0x5c39e3]               # 004ab496
    push edx                                     # 004ab49d
    mov eax, dword ptr [0x5bb57b]                # 004ab49e
    push eax                                     # 004ab4a3
    push 0x550f40                                # 004ab4a4
    push 0x63888b                                # 004ab4a9
    call FUN_0050ca3e                            # 004ab4ae
    add esp, 0x10                                # 004ab4b3
    push 0x63888b                                # 004ab4b6
    push 0x550f6c                                # 004ab4bb
    mov ecx, 0x583979                            # 004ab4c0
    call FUN_0042639d                            # 004ab4c5
    mov ecx, 0x5cf659                            # 004ab4ca
    call FUN_004c97b4                            # 004ab4cf
L_004ab4d4:
    # block 0x004ab4d4: entered by jne at 0x004ab494, 21 instruction(s), ends with je to 0x004ab520 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004ab4d4
    mov esi, dword ptr [ecx]                     # 004ab4d7
    mov edx, dword ptr [ebp + arg_8]             # 004ab4d9
    mov edi, dword ptr [edx]                     # 004ab4dc
    mov ecx, 0x2ef                               # 004ab4de
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ab4e3
    movsw word ptr es:[edi], word ptr [esi]      # 004ab4e5
    movsb byte ptr es:[edi], byte ptr [esi]      # 004ab4e7
    mov eax, dword ptr [ebp + arg_10]            # 004ab4e8
    mov ecx, dword ptr [eax]                     # 004ab4eb
    add ecx, 0xbbf                               # 004ab4ed
    mov edx, dword ptr [ebp + arg_10]            # 004ab4f3
    mov dword ptr [edx], ecx                     # 004ab4f6
    mov eax, dword ptr [ebp + arg_c]             # 004ab4f8
    mov ecx, dword ptr [eax]                     # 004ab4fb
    add ecx, 0xbbf                               # 004ab4fd
    mov edx, dword ptr [ebp + arg_c]             # 004ab503
    mov dword ptr [edx], ecx                     # 004ab506
    movsx eax, word ptr [0x63a4cd]               # 004ab508
    test eax, eax                                # 004ab50f
    je.d8 L_004ab520                             # 004ab511
    # block 0x004ab513: entered by fall-through of je at 0x004ab511, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ab520
    push 0x550f88                                # 004ab513
    call FUN_0044a2b7                            # 004ab518
    add esp, 0x4                                 # 004ab51d
L_004ab520:
    # block 0x004ab520: entered by je at 0x004ab511, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004ab520
    pop esi                                      # 004ab521
    {load} mov esp, ebp                          # 004ab522
    pop ebp                                      # 004ab524
    ret 0xc                                      # 004ab525

