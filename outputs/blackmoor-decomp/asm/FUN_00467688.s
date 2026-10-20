# FUN_00467688
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467688
# extent:       0x00467688-0x00467740 (184 code bytes)
# span:         0x00467688-0x00467740 (code 184, tables 0, padding 0)
# sha256:       d0554b9a38b3df216f9db2db8d50e9a8f1256d7db785cf6c6abc034120ccd7f8
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dotconnect_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/467688.c.txt, not original source) refers to the data labelled s_Loaded_AT_DOTCONNECT_PUZZLE_acti_0054b820, s_for_SCENE__d__pData_for_ACTION_R_0054b7d8
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_DOTCONNECT_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x00467688 - 0x401000
.globl FUN_00467688
FUN_00467688:
    # block 0x00467688: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004676ef (forward)
    push ebp                                     # 00467688
    {load} mov ebp, esp                          # 00467689
    sub esp, 0x8                                 # 0046768b
    push esi                                     # 0046768e
    push edi                                     # 0046768f
    mov dword ptr [ebp - local_8], ecx           # 00467690
    push 0x408                                   # 00467693
    call FUN_0051dc43                            # 00467698
    add esp, 0x4                                 # 0046769d
    mov dword ptr [ebp - local_4], eax           # 004676a0
    mov eax, dword ptr [ebp + arg_8]             # 004676a3
    mov ecx, dword ptr [ebp - local_4]           # 004676a6
    mov dword ptr [eax], ecx                     # 004676a9
    cmp dword ptr [ebp - local_4], 0x0           # 004676ab
    jne.d8 L_004676ef                            # 004676af
    # block 0x004676b1: entered by fall-through of jne at 0x004676af, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004676ef
    movsx edx, word ptr [0x5c39e3]               # 004676b1
    push edx                                     # 004676b8
    mov eax, dword ptr [0x5bb57b]                # 004676b9
    push eax                                     # 004676be
    push 0x54b7d8                                # 004676bf
    push 0x63888b                                # 004676c4
    call FUN_0050ca3e                            # 004676c9
    add esp, 0x10                                # 004676ce
    push 0x63888b                                # 004676d1
    push 0x54b804                                # 004676d6
    mov ecx, 0x583979                            # 004676db
    call FUN_0042639d                            # 004676e0
    mov ecx, 0x5cf659                            # 004676e5
    call FUN_004c97b4                            # 004676ea
L_004676ef:
    # block 0x004676ef: entered by jne at 0x004676af, 19 instruction(s), ends with je to 0x00467738 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004676ef
    mov esi, dword ptr [ecx]                     # 004676f2
    mov edx, dword ptr [ebp + arg_8]             # 004676f4
    mov edi, dword ptr [edx]                     # 004676f7
    mov ecx, 0x102                               # 004676f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004676fe
    mov eax, dword ptr [ebp + arg_10]            # 00467700
    mov ecx, dword ptr [eax]                     # 00467703
    add ecx, 0x408                               # 00467705
    mov edx, dword ptr [ebp + arg_10]            # 0046770b
    mov dword ptr [edx], ecx                     # 0046770e
    mov eax, dword ptr [ebp + arg_c]             # 00467710
    mov ecx, dword ptr [eax]                     # 00467713
    add ecx, 0x408                               # 00467715
    mov edx, dword ptr [ebp + arg_c]             # 0046771b
    mov dword ptr [edx], ecx                     # 0046771e
    movsx eax, word ptr [0x63a4cd]               # 00467720
    test eax, eax                                # 00467727
    je.d8 L_00467738                             # 00467729
    # block 0x0046772b: entered by fall-through of je at 0x00467729, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00467738
    push 0x54b820                                # 0046772b
    call FUN_0044a2b7                            # 00467730
    add esp, 0x4                                 # 00467735
L_00467738:
    # block 0x00467738: entered by je at 0x00467729, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00467738
    pop esi                                      # 00467739
    {load} mov esp, ebp                          # 0046773a
    pop ebp                                      # 0046773c
    ret 0xc                                      # 0046773d

