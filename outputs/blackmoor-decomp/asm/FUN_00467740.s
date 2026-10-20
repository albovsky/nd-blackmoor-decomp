# FUN_00467740
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467740
# extent:       0x00467740-0x0046793a (506 code bytes)
# span:         0x00467740-0x0046793a (code 506, tables 0, padding 0)
# sha256:       d08fd6db45102db48f388125b3983bdb927ffe3253ee4be6d4eff3b232deabad
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m467740_hit_test
# naming:       native port src/original_methods_fl24b.c:m467740_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m467740_hit_test (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 480 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_8, field_25, field_29, field_1aa; [ecx + n] field_21, field_1aa, field_1ae, field_3f8, field_3fc, field_400, field_404; [edx + n] field_a, field_2d, field_1aa
# callees:      calls FUN_00467b9e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:arm_467740 (function ledger class native_oracle_verified; also m467740_hit_test; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 110 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_3f8, 0x3f8  # offset +0x3f8
.equ field_3fc, 0x3fc  # offset +0x3fc
.equ field_400, 0x400  # offset +0x400
.equ field_404, 0x404  # offset +0x404

# --- external targets -----------------------------------------------
.set FUN_00467b9e, .text + (0x00467b9e - 0x401000)

.org 0x00467740 - 0x401000
.globl FUN_00467740
FUN_00467740:
    # block 0x00467740: entry, 13 instruction(s), ends with je to 0x00467932 (forward)
    push ebp                                     # 00467740
    {load} mov ebp, esp                          # 00467741
    sub esp, 0x8                                 # 00467743
    mov dword ptr [ebp - local_8], ecx           # 00467746
    mov eax, dword ptr [ebp - local_8]           # 00467749
    movsx ecx, word ptr [eax + field_8]          # 0046774c
    imul ecx, ecx, 0x8d                          # 00467750
    mov edx, dword ptr [ebp - local_8]           # 00467756
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00467759
    mov dword ptr [edx + field_1aa], eax         # 0046775f
    mov ecx, dword ptr [ebp - local_8]           # 00467765
    cmp dword ptr [ecx + field_1ae], 0x0         # 00467768
    je.d32 L_00467932                            # 0046776f
    # block 0x00467775: entered by fall-through of je at 0x0046776f, 5 instruction(s), ends with jl to 0x0046782d (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00467775
    mov eax, dword ptr [ebp - local_8]           # 00467779
    mov ecx, dword ptr [eax + field_1aa]         # 0046777c
    cmp edx, dword ptr [ecx + field_3fc]         # 00467782
    jl.d32 L_0046782d                            # 00467788
    # block 0x0046778e: entered by fall-through of jl at 0x00467788, 5 instruction(s), ends with jg to 0x0046782d (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046778e
    mov eax, dword ptr [ebp - local_8]           # 00467792
    mov ecx, dword ptr [eax + field_1aa]         # 00467795
    cmp edx, dword ptr [ecx + field_404]         # 0046779b
    jg.d32 L_0046782d                            # 004677a1
    # block 0x004677a7: entered by fall-through of jg at 0x004677a1, 5 instruction(s), ends with jl to 0x0046782d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004677a7
    mov eax, dword ptr [ebp - local_8]           # 004677ab
    mov ecx, dword ptr [eax + field_1aa]         # 004677ae
    cmp edx, dword ptr [ecx + field_3f8]         # 004677b4
    jl.d8 L_0046782d                             # 004677ba
    # block 0x004677bc: entered by fall-through of jl at 0x004677ba, 5 instruction(s), ends with jg to 0x0046782d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004677bc
    mov eax, dword ptr [ebp - local_8]           # 004677c0
    mov ecx, dword ptr [eax + field_1aa]         # 004677c3
    cmp edx, dword ptr [ecx + field_400]         # 004677c9
    jg.d8 L_0046782d                             # 004677cf
    # block 0x004677d1: entered by fall-through of jg at 0x004677cf, 14 instruction(s), ends with forward jump to 0x00467934
    mov dword ptr [0x5b44f0], 0x9                # 004677d1
    mov dword ptr [0x5b44f4], 0x1                # 004677db
    mov edx, dword ptr [0x5d0377]                # 004677e5
    mov dword ptr [0x5d162d], edx                # 004677eb
    mov eax, dword ptr [0x5b44f0]                # 004677f1
    shl eax, 0x5                                 # 004677f6
    mov ecx, dword ptr [0x5b44f4]                # 004677f9
    shl ecx, 0x4                                 # 004677ff
    lea edx, [eax + ecx + 0x5b160c]              # 00467802
    mov dword ptr [0x5d1631], edx                # 00467809
    mov dword ptr [0x5d1639], 0x1                # 0046780f
    mov dword ptr [0x5c39e5], 0x27ac             # 00467819
    mov eax, 0x1                                 # 00467823
    jmp.d32 L_00467934                           # 00467828
L_0046782d:
    # block 0x0046782d: entered by jl at 0x00467788; jg at 0x004677a1; jl at 0x004677ba; jg at 0x004677cf, 2 instruction(s), ends with forward jump to 0x0046783f
    mov dword ptr [ebp - local_4], 0x0           # 0046782d
    jmp.d8 L_0046783f                            # 00467834
L_00467836:
    # block 0x00467836: entered by jmp at 0x0046792d, 3 instruction(s), falls into the block at 0x0046783f
    mov eax, dword ptr [ebp - local_4]           # 00467836
    add eax, 0x1                                 # 00467839
    mov dword ptr [ebp - local_4], eax           # 0046783c
L_0046783f:
    # block 0x0046783f: entered by jmp at 0x00467834, 2 instruction(s), ends with jge to 0x00467932 (forward)
    cmp dword ptr [ebp - local_4], 0x11          # 0046783f
    jge.d32 L_00467932                           # 00467843
    # block 0x00467849: entered by fall-through of jge at 0x00467843, 7 instruction(s), ends with jl to 0x0046792d (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00467849
    mov edx, dword ptr [ebp - local_8]           # 0046784d
    mov eax, dword ptr [edx + field_1aa]         # 00467850
    mov edx, dword ptr [ebp - local_4]           # 00467856
    shl edx, 0x4                                 # 00467859
    cmp ecx, dword ptr [eax + edx + field_25]    # 0046785c
    jl.d32 L_0046792d                            # 00467860
    # block 0x00467866: entered by fall-through of jl at 0x00467860, 7 instruction(s), ends with jg to 0x0046792d (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00467866
    mov ecx, dword ptr [ebp - local_8]           # 0046786a
    mov edx, dword ptr [ecx + field_1aa]         # 0046786d
    mov ecx, dword ptr [ebp - local_4]           # 00467873
    shl ecx, 0x4                                 # 00467876
    cmp eax, dword ptr [edx + ecx + field_2d]    # 00467879
    jg.d32 L_0046792d                            # 0046787d
    # block 0x00467883: entered by fall-through of jg at 0x0046787d, 7 instruction(s), ends with jl to 0x0046792d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00467883
    mov eax, dword ptr [ebp - local_8]           # 00467887
    mov ecx, dword ptr [eax + field_1aa]         # 0046788a
    mov eax, dword ptr [ebp - local_4]           # 00467890
    shl eax, 0x4                                 # 00467893
    cmp edx, dword ptr [ecx + eax + field_21]    # 00467896
    jl.d32 L_0046792d                            # 0046789a
    # block 0x004678a0: entered by fall-through of jl at 0x0046789a, 7 instruction(s), ends with jg to 0x0046792d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004678a0
    mov edx, dword ptr [ebp - local_8]           # 004678a4
    mov eax, dword ptr [edx + field_1aa]         # 004678a7
    mov edx, dword ptr [ebp - local_4]           # 004678ad
    shl edx, 0x4                                 # 004678b0
    cmp ecx, dword ptr [eax + edx + field_29]    # 004678b3
    jg.d8 L_0046792d                             # 004678b7
    # block 0x004678b9: entered by fall-through of jg at 0x004678b7, 6 instruction(s), calls FUN_00467b9e, ends with jne to 0x0046792d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004678b9
    push eax                                     # 004678bc
    mov ecx, dword ptr [ebp - local_8]           # 004678bd
    call FUN_00467b9e                            # 004678c0
    test eax, eax                                # 004678c5
    jne.d8 L_0046792d                            # 004678c7
    # block 0x004678c9: entered by fall-through of jne at 0x004678c7, 17 instruction(s), ends with forward jump to 0x00467934
    mov dword ptr [0x5b44f0], 0x0                # 004678c9
    mov dword ptr [0x5b44f4], 0x1                # 004678d3
    mov ecx, dword ptr [0x5d0377]                # 004678dd
    mov dword ptr [0x5d162d], ecx                # 004678e3
    mov edx, dword ptr [0x5b44f0]                # 004678e9
    shl edx, 0x5                                 # 004678ef
    mov eax, dword ptr [0x5b44f4]                # 004678f2
    shl eax, 0x4                                 # 004678f7
    lea ecx, [edx + eax + 0x5b160c]              # 004678fa
    mov dword ptr [0x5d1631], ecx                # 00467901
    mov dword ptr [0x5d1639], 0x1                # 00467907
    mov dword ptr [0x5c39e5], 0x27ab             # 00467911
    mov edx, dword ptr [ebp - local_8]           # 0046791b
    mov ax, word ptr [ebp - local_4]             # 0046791e
    mov word ptr [edx + field_a], ax             # 00467922
    mov eax, 0x1                                 # 00467926
    jmp.d8 L_00467934                            # 0046792b
L_0046792d:
    # block 0x0046792d: entered by jl at 0x00467860; jg at 0x0046787d; jl at 0x0046789a; jg at 0x004678b7; jne at 0x004678c7, 1 instruction(s), ends with backward jump to 0x00467836
    jmp.d32 L_00467836                           # 0046792d
L_00467932:
    # block 0x00467932: entered by je at 0x0046776f; jge at 0x00467843, 1 instruction(s), falls into the block at 0x00467934
    {load} xor eax, eax                          # 00467932
L_00467934:
    # block 0x00467934: entered by jmp at 0x00467828; jmp at 0x0046792b, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00467934
    pop ebp                                      # 00467936
    ret 0x8                                      # 00467937

