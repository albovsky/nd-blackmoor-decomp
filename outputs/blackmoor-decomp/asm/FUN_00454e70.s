# FUN_00454e70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454e70
# extent:       0x00454e70-0x00454f29 (185 code bytes)
# span:         0x00454e70-0x00454f29 (code 185, tables 0, padding 0)
# sha256:       d21e8013626e66ca1fa7db88b3da4121724e0e5a98acd5cf6f65d1842bd36486
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_assembly_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/454e70.c.txt, not original source) refers to the data labelled s_Loaded_AT_ASSEMBLY_PUZZLE_action_0054a004, s_for_SCENE__d__pData_for_ACTION_R_00549fbc
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_ASSEMBLY_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x00454e70 - 0x401000
.globl FUN_00454e70
FUN_00454e70:
    # block 0x00454e70: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00454ed7 (forward)
    push ebp                                     # 00454e70
    {load} mov ebp, esp                          # 00454e71
    sub esp, 0x8                                 # 00454e73
    push esi                                     # 00454e76
    push edi                                     # 00454e77
    mov dword ptr [ebp - local_8], ecx           # 00454e78
    push 0xd01                                   # 00454e7b
    call FUN_0051dc43                            # 00454e80
    add esp, 0x4                                 # 00454e85
    mov dword ptr [ebp - local_4], eax           # 00454e88
    mov eax, dword ptr [ebp + arg_8]             # 00454e8b
    mov ecx, dword ptr [ebp - local_4]           # 00454e8e
    mov dword ptr [eax], ecx                     # 00454e91
    cmp dword ptr [ebp - local_4], 0x0           # 00454e93
    jne.d8 L_00454ed7                            # 00454e97
    # block 0x00454e99: entered by fall-through of jne at 0x00454e97, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00454ed7
    movsx edx, word ptr [0x5c39e3]               # 00454e99
    push edx                                     # 00454ea0
    mov eax, dword ptr [0x5bb57b]                # 00454ea1
    push eax                                     # 00454ea6
    push 0x549fbc                                # 00454ea7
    push 0x63888b                                # 00454eac
    call FUN_0050ca3e                            # 00454eb1
    add esp, 0x10                                # 00454eb6
    push 0x63888b                                # 00454eb9
    push 0x549fe8                                # 00454ebe
    mov ecx, 0x583979                            # 00454ec3
    call FUN_0042639d                            # 00454ec8
    mov ecx, 0x5cf659                            # 00454ecd
    call FUN_004c97b4                            # 00454ed2
L_00454ed7:
    # block 0x00454ed7: entered by jne at 0x00454e97, 20 instruction(s), ends with je to 0x00454f21 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00454ed7
    mov esi, dword ptr [ecx]                     # 00454eda
    mov edx, dword ptr [ebp + arg_8]             # 00454edc
    mov edi, dword ptr [edx]                     # 00454edf
    mov ecx, 0x340                               # 00454ee1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00454ee6
    movsb byte ptr es:[edi], byte ptr [esi]      # 00454ee8
    mov eax, dword ptr [ebp + arg_10]            # 00454ee9
    mov ecx, dword ptr [eax]                     # 00454eec
    add ecx, 0xd01                               # 00454eee
    mov edx, dword ptr [ebp + arg_10]            # 00454ef4
    mov dword ptr [edx], ecx                     # 00454ef7
    mov eax, dword ptr [ebp + arg_c]             # 00454ef9
    mov ecx, dword ptr [eax]                     # 00454efc
    add ecx, 0xd01                               # 00454efe
    mov edx, dword ptr [ebp + arg_c]             # 00454f04
    mov dword ptr [edx], ecx                     # 00454f07
    movsx eax, word ptr [0x63a4cd]               # 00454f09
    test eax, eax                                # 00454f10
    je.d8 L_00454f21                             # 00454f12
    # block 0x00454f14: entered by fall-through of je at 0x00454f12, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00454f21
    push 0x54a004                                # 00454f14
    call FUN_0044a2b7                            # 00454f19
    add esp, 0x4                                 # 00454f1e
L_00454f21:
    # block 0x00454f21: entered by je at 0x00454f12, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00454f21
    pop esi                                      # 00454f22
    {load} mov esp, ebp                          # 00454f23
    pop ebp                                      # 00454f25
    ret 0xc                                      # 00454f26

