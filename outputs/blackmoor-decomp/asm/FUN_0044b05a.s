# FUN_0044b05a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b05a
# extent:       0x0044b05a-0x0044b102 (168 code bytes)
# span:         0x0044b05a-0x0044b102 (code 168, tables 0, padding 0)
# sha256:       374753d398eef735ddfcbd5e04242f9807fd28a0a8a8110c20103dac4e68115c
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044b05a
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44b05a_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0044b05a - 0x401000
.globl FUN_0044b05a
FUN_0044b05a:
    # block 0x0044b05a: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044b0bc (forward)
    push ebp                                     # 0044b05a
    {load} mov ebp, esp                          # 0044b05b
    sub esp, 0x8                                 # 0044b05d
    mov dword ptr [ebp - local_8], ecx           # 0044b060
    push 0x4                                     # 0044b063
    call FUN_0051dc43                            # 0044b065
    add esp, 0x4                                 # 0044b06a
    mov dword ptr [ebp - local_4], eax           # 0044b06d
    mov eax, dword ptr [ebp + arg_8]             # 0044b070
    mov ecx, dword ptr [ebp - local_4]           # 0044b073
    mov dword ptr [eax], ecx                     # 0044b076
    cmp dword ptr [ebp - local_4], 0x0           # 0044b078
    jne.d8 L_0044b0bc                            # 0044b07c
    # block 0x0044b07e: entered by fall-through of jne at 0x0044b07c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044b0bc
    movsx edx, word ptr [0x5c39e3]               # 0044b07e
    push edx                                     # 0044b085
    mov eax, dword ptr [0x5bb57b]                # 0044b086
    push eax                                     # 0044b08b
    push 0x548ec0                                # 0044b08c
    push 0x63888b                                # 0044b091
    call FUN_0050ca3e                            # 0044b096
    add esp, 0x10                                # 0044b09b
    push 0x63888b                                # 0044b09e
    push 0x548eec                                # 0044b0a3
    mov ecx, 0x583979                            # 0044b0a8
    call FUN_0042639d                            # 0044b0ad
    mov ecx, 0x5cf659                            # 0044b0b2
    call FUN_004c97b4                            # 0044b0b7
L_0044b0bc:
    # block 0x0044b0bc: entered by jne at 0x0044b07c, 19 instruction(s), ends with je to 0x0044b0fc (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044b0bc
    mov edx, dword ptr [ecx]                     # 0044b0bf
    mov eax, dword ptr [ebp + arg_8]             # 0044b0c1
    mov ecx, dword ptr [eax]                     # 0044b0c4
    mov edx, dword ptr [edx]                     # 0044b0c6
    mov dword ptr [ecx], edx                     # 0044b0c8
    mov eax, dword ptr [ebp + arg_10]            # 0044b0ca
    mov ecx, dword ptr [eax]                     # 0044b0cd
    add ecx, 0x4                                 # 0044b0cf
    mov edx, dword ptr [ebp + arg_10]            # 0044b0d2
    mov dword ptr [edx], ecx                     # 0044b0d5
    mov eax, dword ptr [ebp + arg_c]             # 0044b0d7
    mov ecx, dword ptr [eax]                     # 0044b0da
    add ecx, 0x4                                 # 0044b0dc
    mov edx, dword ptr [ebp + arg_c]             # 0044b0df
    mov dword ptr [edx], ecx                     # 0044b0e2
    movsx eax, word ptr [0x63a4cd]               # 0044b0e4
    test eax, eax                                # 0044b0eb
    je.d8 L_0044b0fc                             # 0044b0ed
    # block 0x0044b0ef: entered by fall-through of je at 0x0044b0ed, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044b0fc
    push 0x548f08                                # 0044b0ef
    call FUN_0044a2b7                            # 0044b0f4
    add esp, 0x4                                 # 0044b0f9
L_0044b0fc:
    # block 0x0044b0fc: entered by je at 0x0044b0ed, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0044b0fc
    pop ebp                                      # 0044b0fe
    ret 0xc                                      # 0044b0ff

