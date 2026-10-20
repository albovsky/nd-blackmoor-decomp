# FUN_004c46d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c46d1
# extent:       0x004c46d1-0x004c47e6 (277 code bytes)
# span:         0x004c46d1-0x004c47e6 (code 277, tables 0, padding 0)
# sha256:       ac45a124fd35580944a274838fa7ab3d1656e9aac16540b2f624814a95d60f17
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c46d1_fill_surface
# naming:       native port src/original_methods_fl29a.c:m4c46d1_fill_surface (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Builds the 16-bit colour from three masked, optionally byte-shifted components with 32-bit shifts modulo 32 and fills w*h words of the surface buffer; every instruction and jump direction executed. See tasks/fl29a-handoff.md.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_2b, field_38c6, field_38c8, field_38c9, field_38ca; [ecx + n] field_38c0, field_38c1, field_38c2, field_38c4; [edx + n] field_2d, field_38c5
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29a.c:m4c46d1_fill_surface (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 88 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_38c0, 0x38c0  # offset +0x38c0
.equ field_38c1, 0x38c1  # offset +0x38c1
.equ field_38c2, 0x38c2  # offset +0x38c2
.equ field_38c4, 0x38c4  # offset +0x38c4
.equ field_38c5, 0x38c5  # offset +0x38c5
.equ field_38c6, 0x38c6  # offset +0x38c6
.equ field_38c8, 0x38c8  # offset +0x38c8
.equ field_38c9, 0x38c9  # offset +0x38c9
.equ field_38ca, 0x38ca  # offset +0x38ca

# --- external targets -----------------------------------------------

.org 0x004c46d1 - 0x401000
.globl FUN_004c46d1
FUN_004c46d1:
    # block 0x004c46d1: entry, 23 instruction(s), ends with je to 0x004c4726 (forward)
    push ebp                                     # 004c46d1
    {load} mov ebp, esp                          # 004c46d2
    sub esp, 0xc                                 # 004c46d4
    push ebx                                     # 004c46d7
    mov dword ptr [ebp - local_c], ecx           # 004c46d8
    mov word ptr [ebp - local_8], 0x0            # 004c46db
    mov eax, dword ptr [ebp - local_c]           # 004c46e1
    mov cl, byte ptr [ebp + arg_c]               # 004c46e4
    and cl, byte ptr [eax + field_38c6]          # 004c46e7
    mov byte ptr [ebp + arg_c], cl               # 004c46ed
    mov edx, dword ptr [ebp - local_c]           # 004c46f0
    mov al, byte ptr [ebp + arg_10]              # 004c46f3
    and al, byte ptr [edx + field_38c5]          # 004c46f6
    mov byte ptr [ebp + arg_10], al              # 004c46fc
    mov ecx, dword ptr [ebp - local_c]           # 004c46ff
    mov dl, byte ptr [ebp + arg_14]              # 004c4702
    and dl, byte ptr [ecx + field_38c4]          # 004c4705
    mov byte ptr [ebp + arg_14], dl              # 004c470b
    mov eax, dword ptr [ebp - local_c]           # 004c470e
    {load} xor ecx, ecx                          # 004c4711
    mov cl, byte ptr [eax + field_38ca]          # 004c4713
    cmp ecx, 0x5                                 # 004c4719
    je.d8 L_004c4726                             # 004c471c
    # block 0x004c471e: entered by fall-through of je at 0x004c471c, 3 instruction(s), falls into the block at 0x004c4726
    mov dl, byte ptr [ebp + arg_c]               # 004c471e
    shl dl                                       # 004c4721
    mov byte ptr [ebp + arg_c], dl               # 004c4723
L_004c4726:
    # block 0x004c4726: entered by je at 0x004c471c, 5 instruction(s), ends with je to 0x004c473e (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c4726
    {load} xor ecx, ecx                          # 004c4729
    mov cl, byte ptr [eax + field_38c9]          # 004c472b
    cmp ecx, 0x5                                 # 004c4731
    je.d8 L_004c473e                             # 004c4734
    # block 0x004c4736: entered by fall-through of je at 0x004c4734, 3 instruction(s), falls into the block at 0x004c473e
    mov dl, byte ptr [ebp + arg_10]              # 004c4736
    shl dl                                       # 004c4739
    mov byte ptr [ebp + arg_10], dl              # 004c473b
L_004c473e:
    # block 0x004c473e: entered by je at 0x004c4734, 5 instruction(s), ends with je to 0x004c4756 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c473e
    {load} xor ecx, ecx                          # 004c4741
    mov cl, byte ptr [eax + field_38c8]          # 004c4743
    cmp ecx, 0x5                                 # 004c4749
    je.d8 L_004c4756                             # 004c474c
    # block 0x004c474e: entered by fall-through of je at 0x004c474c, 3 instruction(s), falls into the block at 0x004c4756
    mov dl, byte ptr [ebp + arg_14]              # 004c474e
    shl dl                                       # 004c4751
    mov byte ptr [ebp + arg_14], dl              # 004c4753
L_004c4756:
    # block 0x004c4756: entered by je at 0x004c474c, 26 instruction(s), ends with forward jump to 0x004c47b7
    mov eax, dword ptr [ebp + arg_c]             # 004c4756
    and eax, 0xff                                # 004c4759
    mov ecx, dword ptr [ebp - local_c]           # 004c475e
    {load} xor edx, edx                          # 004c4761
    mov dl, byte ptr [ecx + field_38c2]          # 004c4763
    {load} mov ecx, edx                          # 004c4769
    shl eax, cl                                  # 004c476b
    mov edx, dword ptr [ebp + arg_10]            # 004c476d
    and edx, 0xff                                # 004c4770
    mov ecx, dword ptr [ebp - local_c]           # 004c4776
    {load} xor ebx, ebx                          # 004c4779
    mov bl, byte ptr [ecx + field_38c1]          # 004c477b
    {load} mov ecx, ebx                          # 004c4781
    shl edx, cl                                  # 004c4783
    {load} or eax, edx                           # 004c4785
    mov edx, dword ptr [ebp + arg_14]            # 004c4787
    and edx, 0xff                                # 004c478a
    mov ecx, dword ptr [ebp - local_c]           # 004c4790
    {load} xor ebx, ebx                          # 004c4793
    mov bl, byte ptr [ecx + field_38c0]          # 004c4795
    {load} mov ecx, ebx                          # 004c479b
    shl edx, cl                                  # 004c479d
    {load} or eax, edx                           # 004c479f
    mov word ptr [ebp - local_8], ax             # 004c47a1
    mov dword ptr [ebp - local_4], 0x0           # 004c47a5
    jmp.d8 L_004c47b7                            # 004c47ac
L_004c47ae:
    # block 0x004c47ae: entered by jmp at 0x004c47dd, 3 instruction(s), falls into the block at 0x004c47b7
    mov edx, dword ptr [ebp - local_4]           # 004c47ae
    add edx, 0x1                                 # 004c47b1
    mov dword ptr [ebp - local_4], edx           # 004c47b4
L_004c47b7:
    # block 0x004c47b7: entered by jmp at 0x004c47ac, 7 instruction(s), ends with jge to 0x004c47df (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004c47b7
    movsx ecx, word ptr [eax + field_2b]         # 004c47ba
    mov edx, dword ptr [ebp + arg_8]             # 004c47be
    movsx eax, word ptr [edx + field_2d]         # 004c47c1
    imul ecx, eax                                # 004c47c5
    cmp dword ptr [ebp - local_4], ecx           # 004c47c8
    jge.d8 L_004c47df                            # 004c47cb
    # block 0x004c47cd: entered by fall-through of jge at 0x004c47cb, 6 instruction(s), ends with backward jump to 0x004c47ae
    mov ecx, dword ptr [ebp + arg_8]             # 004c47cd
    mov edx, dword ptr [ecx]                     # 004c47d0
    mov eax, dword ptr [ebp - local_4]           # 004c47d2
    mov cx, word ptr [ebp - local_8]             # 004c47d5
    mov word ptr [edx + 2*eax], cx               # 004c47d9
    jmp.d8 L_004c47ae                            # 004c47dd
L_004c47df:
    # block 0x004c47df: entered by jge at 0x004c47cb, 4 instruction(s), ends with ret 0x10
    pop ebx                                      # 004c47df
    {load} mov esp, ebp                          # 004c47e0
    pop ebp                                      # 004c47e2
    ret 0x10                                     # 004c47e3

