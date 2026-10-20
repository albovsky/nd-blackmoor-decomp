# FUN_004547bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004547bc
# extent:       0x004547bc-0x00454847 (139 code bytes)
# span:         0x004547bc-0x00454847 (code 139, tables 0, padding 0)
# sha256:       87b3c9070046a4e51454369ede5036c1c465c56175aeec2c9b5685bf68c4ba6f
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_arcade_puzzle_buffer_allocator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4547bc.c.txt, not original source) refers to the data labelled s_CArcadePuzzle__AllocateMemory_____00549e28
# name-note:    CArcadePuzzle::AllocateMemory: allocates a zero-filled buffer of the given size, with an error message and abort on failure.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004547bc - 0x401000
.globl FUN_004547bc
FUN_004547bc:
    # block 0x004547bc: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00454828 (forward)
    push ebp                                     # 004547bc
    {load} mov ebp, esp                          # 004547bd
    sub esp, 0x8                                 # 004547bf
    push edi                                     # 004547c2
    mov dword ptr [ebp - local_8], ecx           # 004547c3
    mov eax, dword ptr [ebp + arg_c]             # 004547c6
    push eax                                     # 004547c9
    call FUN_0051dc43                            # 004547ca
    add esp, 0x4                                 # 004547cf
    mov dword ptr [ebp - local_4], eax           # 004547d2
    mov ecx, dword ptr [ebp + arg_8]             # 004547d5
    mov edx, dword ptr [ebp - local_4]           # 004547d8
    mov dword ptr [ecx], edx                     # 004547db
    cmp dword ptr [ebp - local_4], 0x0           # 004547dd
    jne.d8 L_00454828                            # 004547e1
    # block 0x004547e3: entered by fall-through of jne at 0x004547e1, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0045481c (forward)
    push 0x549e28                                # 004547e3
    push 0x63888b                                # 004547e8
    call FUN_0050ca3e                            # 004547ed
    add esp, 0x8                                 # 004547f2
    push 0x63888b                                # 004547f5
    mov ecx, 0x583979                            # 004547fa
    call FUN_004264e8                            # 004547ff
    movsx eax, word ptr [0x63a4cd]               # 00454804
    test eax, eax                                # 0045480b
    je.d8 L_0045481c                             # 0045480d
    # block 0x0045480f: entered by fall-through of je at 0x0045480d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045481c
    push 0x63888b                                # 0045480f
    call FUN_0044a2b7                            # 00454814
    add esp, 0x4                                 # 00454819
L_0045481c:
    # block 0x0045481c: entered by je at 0x0045480d, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00454840
    mov ecx, 0x5cf659                            # 0045481c
    call FUN_004c97b4                            # 00454821
    jmp.d8 L_00454840                            # 00454826
L_00454828:
    # block 0x00454828: entered by jne at 0x004547e1, 10 instruction(s), falls into the block at 0x00454840
    mov ecx, dword ptr [ebp + arg_c]             # 00454828
    {load} xor eax, eax                          # 0045482b
    mov edx, dword ptr [ebp + arg_8]             # 0045482d
    mov edi, dword ptr [edx]                     # 00454830
    {load} mov edx, ecx                          # 00454832
    shr ecx, 0x2                                 # 00454834
    rep stosd dword ptr es:[edi], eax            # 00454837
    {load} mov ecx, edx                          # 00454839
    and ecx, 0x3                                 # 0045483b
    rep stosb byte ptr es:[edi], al              # 0045483e
L_00454840:
    # block 0x00454840: entered by jmp at 0x00454826, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 00454840
    {load} mov esp, ebp                          # 00454841
    pop ebp                                      # 00454843
    ret 0x8                                      # 00454844

