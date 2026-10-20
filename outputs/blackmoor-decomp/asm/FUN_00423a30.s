# FUN_00423a30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423a30
# extent:       0x00423a30-0x00423aae (126 code bytes)
# span:         0x00423a30-0x00423aae (code 126, tables 0, padding 0)
# sha256:       252b82f254028899a115f8a39228636412d30bdcdc1ebb54ec3929f9ff90077b
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_bud_deleter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/423a30.c.txt, not original source) refers to the data labelled s_CDependency__DeleteBud_____ERROR_00544820
# name-note:    CDependency::DeleteBud: frees the bud pointer and clears it, with an ERROR message if it was already null.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0051dc6c, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00423a30 - 0x401000
.globl FUN_00423a30
FUN_00423a30:
    # block 0x00423a30: entry, 7 instruction(s), ends with jne to 0x00423a55 (forward)
    push ebp                                     # 00423a30
    {load} mov ebp, esp                          # 00423a31
    sub esp, 0x8                                 # 00423a33
    mov dword ptr [ebp - local_8], ecx           # 00423a36
    mov eax, dword ptr [ebp + arg_8]             # 00423a39
    cmp dword ptr [eax], 0x0                     # 00423a3c
    jne.d8 L_00423a55                            # 00423a3f
    # block 0x00423a41: entered by fall-through of jne at 0x00423a3f, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00423aa6
    push 0x544820                                # 00423a41
    push 0x63888b                                # 00423a46
    call FUN_0050ca3e                            # 00423a4b
    add esp, 0x8                                 # 00423a50
    jmp.d8 L_00423aa6                            # 00423a53
L_00423a55:
    # block 0x00423a55: entered by jne at 0x00423a3f, 10 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x00423aa8
    mov ecx, dword ptr [ebp + arg_8]             # 00423a55
    mov edx, dword ptr [ecx]                     # 00423a58
    mov dword ptr [ebp - local_4], edx           # 00423a5a
    mov eax, dword ptr [ebp - local_4]           # 00423a5d
    push eax                                     # 00423a60
    call FUN_0051dc6c                            # 00423a61
    add esp, 0x4                                 # 00423a66
    mov ecx, dword ptr [ebp + arg_8]             # 00423a69
    mov dword ptr [ecx], 0x0                     # 00423a6c
    jmp.d8 L_00423aa8                            # 00423a72
L_00423a74:
    # block 0x00423a74: entered by jmp at 0x00423aa6, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00423a9a (forward)
    push 0x0                                     # 00423a74
    push 0x0                                     # 00423a76
    push 0x63888b                                # 00423a78
    call FUN_0052139c                            # 00423a7d
    movsx edx, word ptr [0x63a4cd]               # 00423a82
    test edx, edx                                # 00423a89
    je.d8 L_00423a9a                             # 00423a8b
    # block 0x00423a8d: entered by fall-through of je at 0x00423a8b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00423a9a
    push 0x63888b                                # 00423a8d
    call FUN_0044a2b7                            # 00423a92
    add esp, 0x4                                 # 00423a97
L_00423a9a:
    # block 0x00423a9a: entered by je at 0x00423a8b, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00423aa8
    mov ecx, 0x5cf659                            # 00423a9a
    call FUN_004c97b4                            # 00423a9f
    jmp.d8 L_00423aa8                            # 00423aa4
L_00423aa6:
    # block 0x00423aa6: entered by jmp at 0x00423a53, 1 instruction(s), ends with backward jump to 0x00423a74
    jmp.d8 L_00423a74                            # 00423aa6
L_00423aa8:
    # block 0x00423aa8: entered by jmp at 0x00423a72; jmp at 0x00423aa4, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00423aa8
    pop ebp                                      # 00423aaa
    ret 0x4                                      # 00423aab

