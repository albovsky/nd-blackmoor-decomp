# FUN_004a8697
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a8697
# extent:       0x004a8697-0x004a8818 (385 code bytes)
# span:         0x004a8697-0x004a8818 (code 385, tables 0, padding 0)
# sha256:       8900cac91fa783cb427b73deb144129df22dfb7c3441dd93bda79f54fe0993be
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a8697_lifted
# naming:       native port src/original_methods_fl41.c:m4a8697_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 24 seeds; oracle: 73/73 instructions, 6/6 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_e7c; [ecx + n] field_44a; [edx + n] field_e7a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a8697_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 73 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_44a, 0x44a  # offset +0x44a
.equ field_e7a, 0xe7a  # offset +0xe7a
.equ field_e7c, 0xe7c  # offset +0xe7c

# --- external targets -----------------------------------------------

.org 0x004a8697 - 0x401000
.globl FUN_004a8697
FUN_004a8697:
    # block 0x004a8697: entry, 12 instruction(s), ends with jne to 0x004a871c (forward)
    push ebp                                     # 004a8697
    {load} mov ebp, esp                          # 004a8698
    sub esp, 0x8                                 # 004a869a
    mov dword ptr [ebp - local_8], ecx           # 004a869d
    mov eax, dword ptr [ebp - local_8]           # 004a86a0
    movsx ecx, word ptr [eax + field_1e]         # 004a86a3
    imul ecx, ecx, 0x8d                          # 004a86a7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a86ad
    mov dword ptr [ebp - local_4], edx           # 004a86b3
    movsx eax, word ptr [ebp + arg_8]            # 004a86b6
    cmp eax, 0x279a                              # 004a86ba
    jne.d8 L_004a871c                            # 004a86bf
    # block 0x004a86c1: entered by fall-through of jne at 0x004a86bf, 15 instruction(s), ends with forward jump to 0x004a8812
    mov ecx, dword ptr [ebp - local_4]           # 004a86c1
    movsx edx, word ptr [ecx + field_44a]        # 004a86c4
    mov dword ptr [0x5b44f0], edx                # 004a86cb
    mov dword ptr [0x5b44f4], 0x1                # 004a86d1
    mov eax, dword ptr [0x5d0377]                # 004a86db
    mov dword ptr [0x5d162d], eax                # 004a86e0
    mov ecx, dword ptr [0x5b44f0]                # 004a86e5
    shl ecx, 0x5                                 # 004a86eb
    mov edx, dword ptr [0x5b44f4]                # 004a86ee
    shl edx, 0x4                                 # 004a86f4
    lea eax, [ecx + edx + 0x5b160c]              # 004a86f7
    mov dword ptr [0x5d1631], eax                # 004a86fe
    mov dword ptr [0x5d1639], 0x1                # 004a8703
    mov dword ptr [0x5c39e5], 0x279a             # 004a870d
    jmp.d32 L_004a8812                           # 004a8717
L_004a871c:
    # block 0x004a871c: entered by jne at 0x004a86bf, 3 instruction(s), ends with jne to 0x004a8798 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a871c
    cmp ecx, 0x2798                              # 004a8720
    jne.d8 L_004a8798                            # 004a8726
    # block 0x004a8728: entered by fall-through of jne at 0x004a8726, 19 instruction(s), ends with forward jump to 0x004a8812
    mov dword ptr [0x5b44f0], 0x13               # 004a8728
    mov dword ptr [0x5b44f4], 0x1                # 004a8732
    mov edx, dword ptr [0x5d0377]                # 004a873c
    mov dword ptr [0x5d162d], edx                # 004a8742
    mov eax, dword ptr [0x5b44f0]                # 004a8748
    shl eax, 0x5                                 # 004a874d
    mov ecx, dword ptr [0x5b44f4]                # 004a8750
    shl ecx, 0x4                                 # 004a8756
    lea edx, [eax + ecx + 0x5b160c]              # 004a8759
    mov dword ptr [0x5d1631], edx                # 004a8760
    mov dword ptr [0x5d1639], 0x1                # 004a8766
    mov dword ptr [0x5c39e5], 0x2798             # 004a8770
    mov eax, dword ptr [ebp - local_8]           # 004a877a
    mov cx, word ptr [ebp + arg_10]              # 004a877d
    mov word ptr [eax + field_e7c], cx           # 004a8781
    mov edx, dword ptr [ebp - local_8]           # 004a8788
    mov ax, word ptr [ebp + arg_c]               # 004a878b
    mov word ptr [edx + field_e7a], ax           # 004a878f
    jmp.d8 L_004a8812                            # 004a8796
L_004a8798:
    # block 0x004a8798: entered by jne at 0x004a8726, 3 instruction(s), ends with jne to 0x004a8812 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a8798
    cmp ecx, 0x2799                              # 004a879c
    jne.d8 L_004a8812                            # 004a87a2
    # block 0x004a87a4: entered by fall-through of jne at 0x004a87a2, 18 instruction(s), falls into the block at 0x004a8812
    mov dword ptr [0x5b44f0], 0x20               # 004a87a4
    mov dword ptr [0x5b44f4], 0x1                # 004a87ae
    mov edx, dword ptr [0x5d0377]                # 004a87b8
    mov dword ptr [0x5d162d], edx                # 004a87be
    mov eax, dword ptr [0x5b44f0]                # 004a87c4
    shl eax, 0x5                                 # 004a87c9
    mov ecx, dword ptr [0x5b44f4]                # 004a87cc
    shl ecx, 0x4                                 # 004a87d2
    lea edx, [eax + ecx + 0x5b160c]              # 004a87d5
    mov dword ptr [0x5d1631], edx                # 004a87dc
    mov dword ptr [0x5d1639], 0x1                # 004a87e2
    mov dword ptr [0x5c39e5], 0x2799             # 004a87ec
    mov eax, dword ptr [ebp - local_8]           # 004a87f6
    mov cx, word ptr [ebp + arg_10]              # 004a87f9
    mov word ptr [eax + field_e7c], cx           # 004a87fd
    mov edx, dword ptr [ebp - local_8]           # 004a8804
    mov ax, word ptr [ebp + arg_c]               # 004a8807
    mov word ptr [edx + field_e7a], ax           # 004a880b
L_004a8812:
    # block 0x004a8812: entered by jmp at 0x004a8717; jmp at 0x004a8796; jne at 0x004a87a2, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004a8812
    pop ebp                                      # 004a8814
    ret 0xc                                      # 004a8815

