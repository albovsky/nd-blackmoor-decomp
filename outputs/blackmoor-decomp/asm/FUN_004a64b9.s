# FUN_004a64b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a64b9
# extent:       0x004a64b9-0x004a6574 (187 code bytes)
# span:         0x004a64b9-0x004a6574 (code 187, tables 0, padding 0)
# sha256:       65bc92cc125d94460c06bb53e4b4559ecb620306dd7a348033a60e996733fce3
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_safedial_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a64b9.c.txt, not original source) refers to the data labelled s_Loaded_AT_SAFEDIAL_action_record_00550938, s_for_SCENE__d__pData_for_ACTION_R_005508f0
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_SAFEDIAL.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x004a64b9 - 0x401000
.globl FUN_004a64b9
FUN_004a64b9:
    # block 0x004a64b9: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004a6520 (forward)
    push ebp                                     # 004a64b9
    {load} mov ebp, esp                          # 004a64ba
    sub esp, 0x8                                 # 004a64bc
    push esi                                     # 004a64bf
    push edi                                     # 004a64c0
    mov dword ptr [ebp - local_8], ecx           # 004a64c1
    push 0x3d7                                   # 004a64c4
    call FUN_0051dc43                            # 004a64c9
    add esp, 0x4                                 # 004a64ce
    mov dword ptr [ebp - local_4], eax           # 004a64d1
    mov eax, dword ptr [ebp + arg_8]             # 004a64d4
    mov ecx, dword ptr [ebp - local_4]           # 004a64d7
    mov dword ptr [eax], ecx                     # 004a64da
    cmp dword ptr [ebp - local_4], 0x0           # 004a64dc
    jne.d8 L_004a6520                            # 004a64e0
    # block 0x004a64e2: entered by fall-through of jne at 0x004a64e0, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004a6520
    movsx edx, word ptr [0x5c39e3]               # 004a64e2
    push edx                                     # 004a64e9
    mov eax, dword ptr [0x5bb57b]                # 004a64ea
    push eax                                     # 004a64ef
    push 0x5508f0                                # 004a64f0
    push 0x63888b                                # 004a64f5
    call FUN_0050ca3e                            # 004a64fa
    add esp, 0x10                                # 004a64ff
    push 0x63888b                                # 004a6502
    push 0x55091c                                # 004a6507
    mov ecx, 0x583979                            # 004a650c
    call FUN_0042639d                            # 004a6511
    mov ecx, 0x5cf659                            # 004a6516
    call FUN_004c97b4                            # 004a651b
L_004a6520:
    # block 0x004a6520: entered by jne at 0x004a64e0, 21 instruction(s), ends with je to 0x004a656c (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004a6520
    mov esi, dword ptr [ecx]                     # 004a6523
    mov edx, dword ptr [ebp + arg_8]             # 004a6525
    mov edi, dword ptr [edx]                     # 004a6528
    mov ecx, 0xf5                                # 004a652a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a652f
    movsw word ptr es:[edi], word ptr [esi]      # 004a6531
    movsb byte ptr es:[edi], byte ptr [esi]      # 004a6533
    mov eax, dword ptr [ebp + arg_10]            # 004a6534
    mov ecx, dword ptr [eax]                     # 004a6537
    add ecx, 0x3d7                               # 004a6539
    mov edx, dword ptr [ebp + arg_10]            # 004a653f
    mov dword ptr [edx], ecx                     # 004a6542
    mov eax, dword ptr [ebp + arg_c]             # 004a6544
    mov ecx, dword ptr [eax]                     # 004a6547
    add ecx, 0x3d7                               # 004a6549
    mov edx, dword ptr [ebp + arg_c]             # 004a654f
    mov dword ptr [edx], ecx                     # 004a6552
    movsx eax, word ptr [0x63a4cd]               # 004a6554
    test eax, eax                                # 004a655b
    je.d8 L_004a656c                             # 004a655d
    # block 0x004a655f: entered by fall-through of je at 0x004a655d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004a656c
    push 0x550938                                # 004a655f
    call FUN_0044a2b7                            # 004a6564
    add esp, 0x4                                 # 004a6569
L_004a656c:
    # block 0x004a656c: entered by je at 0x004a655d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004a656c
    pop esi                                      # 004a656d
    {load} mov esp, ebp                          # 004a656e
    pop ebp                                      # 004a6570
    ret 0xc                                      # 004a6571

