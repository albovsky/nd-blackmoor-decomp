# FUN_0047d682
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d682
# extent:       0x0047d682-0x0047d734 (178 code bytes)
# span:         0x0047d682-0x0047d734 (code 178, tables 0, padding 0)
# sha256:       4fa0047a537adc56e6c0a98a1e9ba10ef739898d0949e19e244b148814b2ed90
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_d9_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d9_runtime.h:17 says "0x47d682 loader (0x40b34a): copies the 0x23 typed body"
# name-note:    Loader for raw 0xd9 rows: copies the 0x23-byte typed body into a fresh row allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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

.org 0x0047d682 - 0x401000
.globl FUN_0047d682
FUN_0047d682:
    # block 0x0047d682: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047d6e6 (forward)
    push ebp                                     # 0047d682
    {load} mov ebp, esp                          # 0047d683
    sub esp, 0x8                                 # 0047d685
    push esi                                     # 0047d688
    push edi                                     # 0047d689
    mov dword ptr [ebp - local_8], ecx           # 0047d68a
    push 0x23                                    # 0047d68d
    call FUN_0051dc43                            # 0047d68f
    add esp, 0x4                                 # 0047d694
    mov dword ptr [ebp - local_4], eax           # 0047d697
    mov eax, dword ptr [ebp + arg_8]             # 0047d69a
    mov ecx, dword ptr [ebp - local_4]           # 0047d69d
    mov dword ptr [eax], ecx                     # 0047d6a0
    cmp dword ptr [ebp - local_4], 0x0           # 0047d6a2
    jne.d8 L_0047d6e6                            # 0047d6a6
    # block 0x0047d6a8: entered by fall-through of jne at 0x0047d6a6, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047d6e6
    movsx edx, word ptr [0x5c39e3]               # 0047d6a8
    push edx                                     # 0047d6af
    mov eax, dword ptr [0x5bb57b]                # 0047d6b0
    push eax                                     # 0047d6b5
    push 0x54d244                                # 0047d6b6
    push 0x63888b                                # 0047d6bb
    call FUN_0050ca3e                            # 0047d6c0
    add esp, 0x10                                # 0047d6c5
    push 0x63888b                                # 0047d6c8
    push 0x54d270                                # 0047d6cd
    mov ecx, 0x583979                            # 0047d6d2
    call FUN_0042639d                            # 0047d6d7
    mov ecx, 0x5cf659                            # 0047d6dc
    call FUN_004c97b4                            # 0047d6e1
L_0047d6e6:
    # block 0x0047d6e6: entered by jne at 0x0047d6a6, 21 instruction(s), ends with je to 0x0047d72c (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0047d6e6
    mov esi, dword ptr [ecx]                     # 0047d6e9
    mov edx, dword ptr [ebp + arg_8]             # 0047d6eb
    mov edi, dword ptr [edx]                     # 0047d6ee
    mov ecx, 0x8                                 # 0047d6f0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047d6f5
    movsw word ptr es:[edi], word ptr [esi]      # 0047d6f7
    movsb byte ptr es:[edi], byte ptr [esi]      # 0047d6f9
    mov eax, dword ptr [ebp + arg_10]            # 0047d6fa
    mov ecx, dword ptr [eax]                     # 0047d6fd
    add ecx, 0x23                                # 0047d6ff
    mov edx, dword ptr [ebp + arg_10]            # 0047d702
    mov dword ptr [edx], ecx                     # 0047d705
    mov eax, dword ptr [ebp + arg_c]             # 0047d707
    mov ecx, dword ptr [eax]                     # 0047d70a
    add ecx, 0x23                                # 0047d70c
    mov edx, dword ptr [ebp + arg_c]             # 0047d70f
    mov dword ptr [edx], ecx                     # 0047d712
    movsx eax, word ptr [0x63a4cd]               # 0047d714
    test eax, eax                                # 0047d71b
    je.d8 L_0047d72c                             # 0047d71d
    # block 0x0047d71f: entered by fall-through of je at 0x0047d71d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047d72c
    push 0x54d28c                                # 0047d71f
    call FUN_0044a2b7                            # 0047d724
    add esp, 0x4                                 # 0047d729
L_0047d72c:
    # block 0x0047d72c: entered by je at 0x0047d71d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047d72c
    pop esi                                      # 0047d72d
    {load} mov esp, ebp                          # 0047d72e
    pop ebp                                      # 0047d730
    ret 0xc                                      # 0047d731

