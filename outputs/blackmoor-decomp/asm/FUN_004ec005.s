# FUN_004ec005
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec005
# extent:       0x004ec005-0x004ec087 (130 code bytes)
# span:         0x004ec005-0x004ec087 (code 130, tables 0, padding 0)
# sha256:       9eeb00be34f71cf365eac9825263c41cccdfa1b0b37303712ddb99ae0249074f
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_notebook_load_chunk
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ec005.c.txt, not original source) refers to the data labelled s_CNotebook__LoadChunk_____TotalCh_0055cc48
# name-note:    Copies a 0x60b-byte chunk into the CNotebook object and reports a LoadChunk error if the supplied total size is smaller.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004ec005 - 0x401000
.globl FUN_004ec005
FUN_004ec005:
    # block 0x004ec005: entry, 23 instruction(s), ends with jle to 0x004ec07f (forward)
    push ebp                                     # 004ec005
    {load} mov ebp, esp                          # 004ec006
    sub esp, 0x8                                 # 004ec008
    push esi                                     # 004ec00b
    push edi                                     # 004ec00c
    mov dword ptr [ebp - local_8], ecx           # 004ec00d
    mov dword ptr [ebp - local_4], 0x0           # 004ec010
    mov edi, dword ptr [ebp - local_8]           # 004ec017
    add edi, 0x695                               # 004ec01a
    mov ecx, 0x182                               # 004ec020
    mov esi, dword ptr [ebp + arg_8]             # 004ec025
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec028
    movsw word ptr es:[edi], word ptr [esi]      # 004ec02a
    movsb byte ptr es:[edi], byte ptr [esi]      # 004ec02c
    mov eax, dword ptr [ebp + arg_8]             # 004ec02d
    add eax, 0x60b                               # 004ec030
    mov dword ptr [ebp + arg_8], eax             # 004ec035
    mov ecx, dword ptr [ebp - local_4]           # 004ec038
    add ecx, 0x60b                               # 004ec03b
    mov dword ptr [ebp - local_4], ecx           # 004ec041
    mov edx, dword ptr [ebp - local_4]           # 004ec044
    cmp edx, dword ptr [ebp + arg_c]             # 004ec047
    jle.d8 L_004ec07f                            # 004ec04a
    # block 0x004ec04c: entered by fall-through of jle at 0x004ec04a, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004ec07f
    mov eax, dword ptr [ebp + arg_c]             # 004ec04c
    push eax                                     # 004ec04f
    mov ecx, dword ptr [ebp - local_4]           # 004ec050
    push ecx                                     # 004ec053
    push 0x55cc48                                # 004ec054
    push 0x63888b                                # 004ec059
    call FUN_0050ca3e                            # 004ec05e
    add esp, 0x10                                # 004ec063
    push 0x63888b                                # 004ec066
    mov ecx, 0x583979                            # 004ec06b
    call FUN_004264e8                            # 004ec070
    mov ecx, 0x5cf659                            # 004ec075
    call FUN_004c97b4                            # 004ec07a
L_004ec07f:
    # block 0x004ec07f: entered by jle at 0x004ec04a, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004ec07f
    pop esi                                      # 004ec080
    {load} mov esp, ebp                          # 004ec081
    pop ebp                                      # 004ec083
    ret 0x8                                      # 004ec084

