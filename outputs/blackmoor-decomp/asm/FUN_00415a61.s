# FUN_00415a61
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415a61
# extent:       0x00415a61-0x00415aea (137 code bytes)
# span:         0x00415a61-0x00415aea (code 137, tables 0, padding 0)
# sha256:       c36dcecdab43a94924de73d0dc5c06b51c0089e8132aee1d364f2cb3b8358c92
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_chunk_compression_type_dispatcher
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/415a61.c.txt, not original source) refers to the data labelled s_Invalid_compression_type__d_in_c_00541e08
# name-note:    Calls FUN_00415aea when the chunk compression type byte is 2; otherwise reports Invalid compression type and aborts.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20; [ecx + n] field_20
# callees:      calls FUN_00415aea, FUN_00415011, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_00415aea, .text + (0x00415aea - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00415a61 - 0x401000
.globl FUN_00415a61
FUN_00415a61:
    # block 0x00415a61: entry, 9 instruction(s), ends with je to 0x00415a7b (forward)
    push ebp                                     # 00415a61
    {load} mov ebp, esp                          # 00415a62
    sub esp, 0x8                                 # 00415a64
    mov dword ptr [ebp - local_4], ecx           # 00415a67
    mov eax, dword ptr [ebp + arg_8]             # 00415a6a
    mov cl, byte ptr [eax + field_20]            # 00415a6d
    mov byte ptr [ebp - local_8], cl             # 00415a70
    cmp byte ptr [ebp - local_8], 0x2            # 00415a73
    je.d8 L_00415a7b                             # 00415a77
    # block 0x00415a79: entered by fall-through of je at 0x00415a77, 1 instruction(s), ends with forward jump to 0x00415a92
    jmp.d8 L_00415a92                            # 00415a79
L_00415a7b:
    # block 0x00415a7b: entered by je at 0x00415a77, 9 instruction(s), calls FUN_00415aea, ends with forward jump to 0x00415ae4
    mov edx, dword ptr [ebp + arg_10]            # 00415a7b
    push edx                                     # 00415a7e
    mov ax, word ptr [ebp + arg_c]               # 00415a7f
    push eax                                     # 00415a83
    mov ecx, dword ptr [ebp + arg_8]             # 00415a84
    push ecx                                     # 00415a87
    mov ecx, dword ptr [ebp - local_4]           # 00415a88
    call FUN_00415aea                            # 00415a8b
    jmp.d8 L_00415ae4                            # 00415a90
L_00415a92:
    # block 0x00415a92: entered by jmp at 0x00415a79, 22 instruction(s), calls FUN_00415011, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00415ae4
    mov edx, dword ptr [ebp + arg_8]             # 00415a92
    push edx                                     # 00415a95
    mov ecx, dword ptr [ebp - local_4]           # 00415a96
    call FUN_00415011                            # 00415a99
    mov eax, dword ptr [ebp + arg_8]             # 00415a9e
    add eax, 0x151                               # 00415aa1
    push eax                                     # 00415aa6
    mov ecx, dword ptr [ebp + arg_8]             # 00415aa7
    {load} xor edx, edx                          # 00415aaa
    mov dl, byte ptr [ecx + field_20]            # 00415aac
    push edx                                     # 00415aaf
    push 0x541e08                                # 00415ab0
    push 0x63888b                                # 00415ab5
    call FUN_0050ca3e                            # 00415aba
    add esp, 0x10                                # 00415abf
    push 0x0                                     # 00415ac2
    push 0x0                                     # 00415ac4
    push 0x63888b                                # 00415ac6
    call FUN_0052139c                            # 00415acb
    mov dword ptr [0x63a58a], 0x4                # 00415ad0
    mov ecx, 0x5cf659                            # 00415ada
    call FUN_004c97b4                            # 00415adf
L_00415ae4:
    # block 0x00415ae4: entered by jmp at 0x00415a90, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00415ae4
    pop ebp                                      # 00415ae6
    ret 0xc                                      # 00415ae7

