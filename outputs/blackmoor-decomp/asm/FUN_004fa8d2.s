# FUN_004fa8d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa8d2
# extent:       0x004fa8d2-0x004fa97d (171 code bytes)
# span:         0x004fa8d2-0x004fa980 (code 171, tables 0, padding 3)
# sha256:       ab3b4a3646b4054093301e23390130c71ed102bc4720cde76e76aa6cc3d5918a
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_enumerate_callback
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4fa8d2.c.txt, not original source) refers to the data labelled s_DirectSoundEnumerateCallback_____00560424, s_Primary_Sound_Driver_0056040c
# name-note:    DirectSoundEnumerate callback: accepts the Primary Sound Driver entry or stores a device GUID; logs DirectSoundEnumerateCallback.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fa8d2 - 0x401000
.globl FUN_004fa8d2
FUN_004fa8d2:
    # block 0x004fa8d2: entry, 7 instruction(s), ends with jne to 0x004fa926 (forward)
    push ebp                                     # 004fa8d2
    {load} mov ebp, esp                          # 004fa8d3
    push ecx                                     # 004fa8d5
    push esi                                     # 004fa8d6
    push edi                                     # 004fa8d7
    cmp dword ptr [ebp + arg_8], 0x0             # 004fa8d8
    jne.d8 L_004fa926                            # 004fa8dc
    # block 0x004fa8de: entered by fall-through of jne at 0x004fa8dc, 6 instruction(s), ends with jne to 0x004fa926 (forward)
    mov edi, 0x56040c                            # 004fa8de
    mov esi, dword ptr [ebp + arg_c]             # 004fa8e3
    mov ecx, 0x15                                # 004fa8e6
    {load} xor eax, eax                          # 004fa8eb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004fa8ed
    jne.d8 L_004fa926                            # 004fa8ef
    # block 0x004fa8f1: entered by fall-through of jne at 0x004fa8ef, 3 instruction(s), ends with je to 0x004fa91f (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004fa8f1
    test ecx, ecx                                # 004fa8f8
    je.d8 L_004fa91f                             # 004fa8fa
    # block 0x004fa8fc: entered by fall-through of je at 0x004fa8fa, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fa91f
    mov edx, dword ptr [ebp + arg_c]             # 004fa8fc
    push edx                                     # 004fa8ff
    push 0x560424                                # 004fa900
    push 0x63888b                                # 004fa905
    call FUN_0050ca3e                            # 004fa90a
    add esp, 0xc                                 # 004fa90f
    push 0x63888b                                # 004fa912
    call FUN_0044a2b7                            # 004fa917
    add esp, 0x4                                 # 004fa91c
L_004fa91f:
    # block 0x004fa91f: entered by je at 0x004fa8fa, 2 instruction(s), ends with forward jump to 0x004fa975
    mov eax, 0x1                                 # 004fa91f
    jmp.d8 L_004fa975                            # 004fa924
L_004fa926:
    # block 0x004fa926: entered by jne at 0x004fa8dc; jne at 0x004fa8ef, 2 instruction(s), ends with je to 0x004fa970 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004fa926
    je.d8 L_004fa970                             # 004fa92a
    # block 0x004fa92c: entered by fall-through of je at 0x004fa92a, 8 instruction(s), ends with je to 0x004fa96c (forward)
    mov eax, dword ptr [ebp + arg_14]            # 004fa92c
    mov dword ptr [ebp - local_4], eax           # 004fa92f
    mov ecx, dword ptr [ebp - local_4]           # 004fa932
    mov edx, dword ptr [ebp + arg_8]             # 004fa935
    mov dword ptr [ecx], edx                     # 004fa938
    movsx eax, word ptr [0x63a4cd]               # 004fa93a
    test eax, eax                                # 004fa941
    je.d8 L_004fa96c                             # 004fa943
    # block 0x004fa945: entered by fall-through of je at 0x004fa943, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fa96c
    mov ecx, dword ptr [ebp + arg_10]            # 004fa945
    push ecx                                     # 004fa948
    mov edx, dword ptr [ebp + arg_c]             # 004fa949
    push edx                                     # 004fa94c
    push 0x560478                                # 004fa94d
    push 0x63888b                                # 004fa952
    call FUN_0050ca3e                            # 004fa957
    add esp, 0x10                                # 004fa95c
    push 0x63888b                                # 004fa95f
    call FUN_0044a2b7                            # 004fa964
    add esp, 0x4                                 # 004fa969
L_004fa96c:
    # block 0x004fa96c: entered by je at 0x004fa943, 2 instruction(s), ends with forward jump to 0x004fa975
    {load} xor eax, eax                          # 004fa96c
    jmp.d8 L_004fa975                            # 004fa96e
L_004fa970:
    # block 0x004fa970: entered by je at 0x004fa92a, 1 instruction(s), falls into the block at 0x004fa975
    mov eax, 0x1                                 # 004fa970
L_004fa975:
    # block 0x004fa975: entered by jmp at 0x004fa924; jmp at 0x004fa96e, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004fa975
    pop esi                                      # 004fa976
    {load} mov esp, ebp                          # 004fa977
    pop ebp                                      # 004fa979
    ret 0x10                                     # 004fa97a

# --- data items (not part of the function) -------------------------
.org 0x004fa97d - 0x401000
PAD_004fa97d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

