# FUN_0045741d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045741d
# extent:       0x0045741d-0x004574e4 (199 code bytes)
# span:         0x0045741d-0x004574e4 (code 199, tables 0, padding 0)
# sha256:       2564ff7f0b2984cc1e08997bf937f9a501971934451eec2275ad7f081f23217a
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045741d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_42
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_42, 0x42  # offset +0x42

# --- external targets -----------------------------------------------

.org 0x0045741d - 0x401000
.globl FUN_0045741d
FUN_0045741d:
    # block 0x0045741d: entry, 7 instruction(s), ends with jne to 0x00457483 (forward)
    push ebp                                     # 0045741d
    {load} mov ebp, esp                          # 0045741e
    push ecx                                     # 00457420
    mov dword ptr [ebp - local_4], ecx           # 00457421
    movsx eax, word ptr [ebp + arg_8]            # 00457424
    cmp eax, 0x27bd                              # 00457428
    jne.d8 L_00457483                            # 0045742d
    # block 0x0045742f: entered by fall-through of jne at 0x0045742d, 14 instruction(s), ends with forward jump to 0x004574de
    mov ecx, dword ptr [0x5d0377]                # 0045742f
    mov dword ptr [0x5d162d], ecx                # 00457435
    mov dword ptr [0x5b44f0], 0x9                # 0045743b
    mov dword ptr [0x5b44f4], 0x1                # 00457445
    mov edx, dword ptr [0x5b44f0]                # 0045744f
    shl edx, 0x5                                 # 00457455
    mov eax, dword ptr [0x5b44f4]                # 00457458
    shl eax, 0x4                                 # 0045745d
    lea ecx, [edx + eax + 0x5b160c]              # 00457460
    mov dword ptr [0x5d1631], ecx                # 00457467
    mov dword ptr [0x5d1639], 0x1                # 0045746d
    movsx edx, word ptr [ebp + arg_8]            # 00457477
    mov dword ptr [0x5c39e5], edx                # 0045747b
    jmp.d8 L_004574de                            # 00457481
L_00457483:
    # block 0x00457483: entered by jne at 0x0045742d, 16 instruction(s), falls into the block at 0x004574de
    mov dword ptr [0x5b44f0], 0x16               # 00457483
    mov dword ptr [0x5b44f4], 0x1                # 0045748d
    mov eax, dword ptr [0x5d0377]                # 00457497
    mov dword ptr [0x5d162d], eax                # 0045749c
    mov ecx, dword ptr [0x5b44f0]                # 004574a1
    shl ecx, 0x5                                 # 004574a7
    mov edx, dword ptr [0x5b44f4]                # 004574aa
    shl edx, 0x4                                 # 004574b0
    lea eax, [ecx + edx + 0x5b160c]              # 004574b3
    mov dword ptr [0x5d1631], eax                # 004574ba
    mov dword ptr [0x5d1639], 0x1                # 004574bf
    movsx ecx, word ptr [ebp + arg_8]            # 004574c9
    mov dword ptr [0x5c39e5], ecx                # 004574cd
    mov edx, dword ptr [ebp - local_4]           # 004574d3
    mov ax, word ptr [ebp + arg_c]               # 004574d6
    mov word ptr [edx + field_42], ax            # 004574da
L_004574de:
    # block 0x004574de: entered by jmp at 0x00457481, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004574de
    pop ebp                                      # 004574e0
    ret 0x8                                      # 004574e1

