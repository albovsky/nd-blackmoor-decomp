# FUN_004e9c2f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9c2f
# extent:       0x004e9c2f-0x004e9cdf (176 code bytes)
# span:         0x004e9c2f-0x004e9cdf (code 176, tables 0, padding 0)
# sha256:       b4fe565c0bd41b0405be18cf2bf0665cf880c627fc85a66ed6fb38839d1bac41
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_action_78_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_78_runtime.h:15 says "Loader: 0x40e56a -> 0x4e9c2f copies a six-byte object (one dword, one word)"
# name-note:    Loader of action 0x78 that copies a six-byte object (one dword, one word).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_4; [edx + n] field_4
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004e9c2f - 0x401000
.globl FUN_004e9c2f
FUN_004e9c2f:
    # block 0x004e9c2f: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9c91 (forward)
    push ebp                                     # 004e9c2f
    {load} mov ebp, esp                          # 004e9c30
    sub esp, 0x8                                 # 004e9c32
    mov dword ptr [ebp - local_8], ecx           # 004e9c35
    push 0x6                                     # 004e9c38
    call FUN_0051dc43                            # 004e9c3a
    add esp, 0x4                                 # 004e9c3f
    mov dword ptr [ebp - local_4], eax           # 004e9c42
    mov eax, dword ptr [ebp + arg_8]             # 004e9c45
    mov ecx, dword ptr [ebp - local_4]           # 004e9c48
    mov dword ptr [eax], ecx                     # 004e9c4b
    cmp dword ptr [ebp - local_4], 0x0           # 004e9c4d
    jne.d8 L_004e9c91                            # 004e9c51
    # block 0x004e9c53: entered by fall-through of jne at 0x004e9c51, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9c91
    movsx edx, word ptr [0x5c39e3]               # 004e9c53
    push edx                                     # 004e9c5a
    mov eax, dword ptr [0x5bb57b]                # 004e9c5b
    push eax                                     # 004e9c60
    push 0x55c934                                # 004e9c61
    push 0x63888b                                # 004e9c66
    call FUN_0050ca3e                            # 004e9c6b
    add esp, 0x10                                # 004e9c70
    push 0x63888b                                # 004e9c73
    push 0x55c960                                # 004e9c78
    mov ecx, 0x583979                            # 004e9c7d
    call FUN_0042639d                            # 004e9c82
    mov ecx, 0x5cf659                            # 004e9c87
    call FUN_004c97b4                            # 004e9c8c
L_004e9c91:
    # block 0x004e9c91: entered by jne at 0x004e9c51, 21 instruction(s), ends with je to 0x004e9cd9 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004e9c91
    mov edx, dword ptr [ecx]                     # 004e9c94
    mov eax, dword ptr [ebp + arg_8]             # 004e9c96
    mov ecx, dword ptr [eax]                     # 004e9c99
    mov eax, dword ptr [edx]                     # 004e9c9b
    mov dword ptr [ecx], eax                     # 004e9c9d
    mov dx, word ptr [edx + field_4]             # 004e9c9f
    mov word ptr [ecx + field_4], dx             # 004e9ca3
    mov eax, dword ptr [ebp + arg_10]            # 004e9ca7
    mov ecx, dword ptr [eax]                     # 004e9caa
    add ecx, 0x6                                 # 004e9cac
    mov edx, dword ptr [ebp + arg_10]            # 004e9caf
    mov dword ptr [edx], ecx                     # 004e9cb2
    mov eax, dword ptr [ebp + arg_c]             # 004e9cb4
    mov ecx, dword ptr [eax]                     # 004e9cb7
    add ecx, 0x6                                 # 004e9cb9
    mov edx, dword ptr [ebp + arg_c]             # 004e9cbc
    mov dword ptr [edx], ecx                     # 004e9cbf
    movsx eax, word ptr [0x63a4cd]               # 004e9cc1
    test eax, eax                                # 004e9cc8
    je.d8 L_004e9cd9                             # 004e9cca
    # block 0x004e9ccc: entered by fall-through of je at 0x004e9cca, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9cd9
    push 0x55c97c                                # 004e9ccc
    call FUN_0044a2b7                            # 004e9cd1
    add esp, 0x4                                 # 004e9cd6
L_004e9cd9:
    # block 0x004e9cd9: entered by je at 0x004e9cca, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e9cd9
    pop ebp                                      # 004e9cdb
    ret 0xc                                      # 004e9cdc

