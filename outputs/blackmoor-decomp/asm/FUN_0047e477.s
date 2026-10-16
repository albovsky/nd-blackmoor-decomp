# FUN_0047e477
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e477
# extent:       0x0047e477-0x0047e52f (184 code bytes)
# span:         0x0047e477-0x0047e52f (code 184, tables 0, padding 0)
# sha256:       888ee3e4f5a034c64efde482dddef980f62045a12bd0158ba99a075772e0288c
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e477
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0047e477 - 0x401000
.globl FUN_0047e477
FUN_0047e477:
    # block 0x0047e477: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047e4de (forward)
    push ebp                                     # 0047e477
    {load} mov ebp, esp                          # 0047e478
    sub esp, 0x8                                 # 0047e47a
    push esi                                     # 0047e47d
    push edi                                     # 0047e47e
    mov dword ptr [ebp - local_8], ecx           # 0047e47f
    push 0xa34                                   # 0047e482
    call FUN_0051dc43                            # 0047e487
    add esp, 0x4                                 # 0047e48c
    mov dword ptr [ebp - local_4], eax           # 0047e48f
    mov eax, dword ptr [ebp + arg_8]             # 0047e492
    mov ecx, dword ptr [ebp - local_4]           # 0047e495
    mov dword ptr [eax], ecx                     # 0047e498
    cmp dword ptr [ebp - local_4], 0x0           # 0047e49a
    jne.d8 L_0047e4de                            # 0047e49e
    # block 0x0047e4a0: entered by fall-through of jne at 0x0047e49e, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047e4de
    movsx edx, word ptr [0x5c39e3]               # 0047e4a0
    push edx                                     # 0047e4a7
    mov eax, dword ptr [0x5bb57b]                # 0047e4a8
    push eax                                     # 0047e4ad
    push 0x54d474                                # 0047e4ae
    push 0x63888b                                # 0047e4b3
    call FUN_0050ca3e                            # 0047e4b8
    add esp, 0x10                                # 0047e4bd
    push 0x63888b                                # 0047e4c0
    push 0x54d4a0                                # 0047e4c5
    mov ecx, 0x583979                            # 0047e4ca
    call FUN_0042639d                            # 0047e4cf
    mov ecx, 0x5cf659                            # 0047e4d4
    call FUN_004c97b4                            # 0047e4d9
L_0047e4de:
    # block 0x0047e4de: entered by jne at 0x0047e49e, 19 instruction(s), ends with je to 0x0047e527 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0047e4de
    mov esi, dword ptr [ecx]                     # 0047e4e1
    mov edx, dword ptr [ebp + arg_8]             # 0047e4e3
    mov edi, dword ptr [edx]                     # 0047e4e6
    mov ecx, 0x28d                               # 0047e4e8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047e4ed
    mov eax, dword ptr [ebp + arg_10]            # 0047e4ef
    mov ecx, dword ptr [eax]                     # 0047e4f2
    add ecx, 0xa34                               # 0047e4f4
    mov edx, dword ptr [ebp + arg_10]            # 0047e4fa
    mov dword ptr [edx], ecx                     # 0047e4fd
    mov eax, dword ptr [ebp + arg_c]             # 0047e4ff
    mov ecx, dword ptr [eax]                     # 0047e502
    add ecx, 0xa34                               # 0047e504
    mov edx, dword ptr [ebp + arg_c]             # 0047e50a
    mov dword ptr [edx], ecx                     # 0047e50d
    movsx eax, word ptr [0x63a4cd]               # 0047e50f
    test eax, eax                                # 0047e516
    je.d8 L_0047e527                             # 0047e518
    # block 0x0047e51a: entered by fall-through of je at 0x0047e518, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047e527
    push 0x54d4bc                                # 0047e51a
    call FUN_0044a2b7                            # 0047e51f
    add esp, 0x4                                 # 0047e524
L_0047e527:
    # block 0x0047e527: entered by je at 0x0047e518, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047e527
    pop esi                                      # 0047e528
    {load} mov esp, ebp                          # 0047e529
    pop ebp                                      # 0047e52b
    ret 0xc                                      # 0047e52c

