# FUN_0045879e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045879e
# extent:       0x0045879e-0x004588ad (271 code bytes)
# span:         0x0045879e-0x004588ad (code 271, tables 0, padding 0)
# sha256:       5bbc473b88c51ec484308305fd6137206841c716099755dd6e88870959409556
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045879e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_26, field_4f7; [edx + n] field_20, field_9d
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_20, 0x20  # offset +0x20
.equ field_26, 0x26  # offset +0x26
.equ field_9d, 0x9d  # offset +0x9d
.equ field_4f7, 0x4f7  # offset +0x4f7

# --- external targets -----------------------------------------------

.org 0x0045879e - 0x401000
.globl FUN_0045879e
FUN_0045879e:
    # block 0x0045879e: entry, 12 instruction(s), ends with je to 0x00458856 (forward)
    push ebp                                     # 0045879e
    {load} mov ebp, esp                          # 0045879f
    sub esp, 0x8                                 # 004587a1
    mov dword ptr [ebp - local_8], ecx           # 004587a4
    mov eax, dword ptr [ebp - local_8]           # 004587a7
    movsx ecx, word ptr [eax + field_26]         # 004587aa
    imul ecx, ecx, 0x8d                          # 004587ae
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004587b4
    mov dword ptr [ebp - local_4], edx           # 004587ba
    movsx eax, word ptr [ebp + arg_8]            # 004587bd
    cmp eax, 0x279f                              # 004587c1
    je.d32 L_00458856                            # 004587c6
    # block 0x004587cc: entered by fall-through of je at 0x004587c6, 5 instruction(s), ends with jne to 0x004587ed (forward)
    mov ecx, dword ptr [0x5d0377]                # 004587cc
    mov dword ptr [0x5d162d], ecx                # 004587d2
    mov edx, dword ptr [ebp - local_8]           # 004587d8
    cmp dword ptr [edx + field_20], 0x5          # 004587db
    jne.d8 L_004587ed                            # 004587df
    # block 0x004587e1: entered by fall-through of jne at 0x004587df, 2 instruction(s), ends with forward jump to 0x004587fd
    mov dword ptr [0x5b44f0], 0x0                # 004587e1
    jmp.d8 L_004587fd                            # 004587eb
L_004587ed:
    # block 0x004587ed: entered by jne at 0x004587df, 3 instruction(s), falls into the block at 0x004587fd
    mov eax, dword ptr [ebp - local_4]           # 004587ed
    movsx ecx, word ptr [eax + field_4f7]        # 004587f0
    mov dword ptr [0x5b44f0], ecx                # 004587f7
L_004587fd:
    # block 0x004587fd: entered by jmp at 0x004587eb, 5 instruction(s), ends with je to 0x00458818 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004587fd
    {load} xor eax, eax                          # 00458800
    mov al, byte ptr [edx + field_9d]            # 00458802
    test eax, eax                                # 00458808
    je.d8 L_00458818                             # 0045880a
    # block 0x0045880c: entered by fall-through of je at 0x0045880a, 2 instruction(s), ends with forward jump to 0x00458822
    mov dword ptr [0x5b44f4], 0x0                # 0045880c
    jmp.d8 L_00458822                            # 00458816
L_00458818:
    # block 0x00458818: entered by je at 0x0045880a, 1 instruction(s), falls into the block at 0x00458822
    mov dword ptr [0x5b44f4], 0x1                # 00458818
L_00458822:
    # block 0x00458822: entered by jmp at 0x00458816, 10 instruction(s), ends with forward jump to 0x004588a7
    mov ecx, dword ptr [0x5b44f0]                # 00458822
    shl ecx, 0x5                                 # 00458828
    mov edx, dword ptr [0x5b44f4]                # 0045882b
    shl edx, 0x4                                 # 00458831
    lea eax, [ecx + edx + 0x5b160c]              # 00458834
    mov dword ptr [0x5d1631], eax                # 0045883b
    mov dword ptr [0x5d1639], 0x1                # 00458840
    movsx ecx, word ptr [ebp + arg_8]            # 0045884a
    mov dword ptr [0x5c39e5], ecx                # 0045884e
    jmp.d8 L_004588a7                            # 00458854
L_00458856:
    # block 0x00458856: entered by je at 0x004587c6, 13 instruction(s), falls into the block at 0x004588a7
    mov dword ptr [0x5b44f0], 0x9                # 00458856
    mov dword ptr [0x5b44f4], 0x1                # 00458860
    mov edx, dword ptr [0x5d0377]                # 0045886a
    mov dword ptr [0x5d162d], edx                # 00458870
    mov eax, dword ptr [0x5b44f0]                # 00458876
    shl eax, 0x5                                 # 0045887b
    mov ecx, dword ptr [0x5b44f4]                # 0045887e
    shl ecx, 0x4                                 # 00458884
    lea edx, [eax + ecx + 0x5b160c]              # 00458887
    mov dword ptr [0x5d1631], edx                # 0045888e
    mov dword ptr [0x5d1639], 0x1                # 00458894
    movsx eax, word ptr [ebp + arg_8]            # 0045889e
    mov dword ptr [0x5c39e5], eax                # 004588a2
L_004588a7:
    # block 0x004588a7: entered by jmp at 0x00458854, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004588a7
    pop ebp                                      # 004588a9
    ret 0x4                                      # 004588aa

