# FUN_00448084
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448084
# extent:       0x00448084-0x00448186 (258 code bytes)
# span:         0x00448084-0x00448186 (code 258, tables 0, padding 0)
# sha256:       d23370d2ff3c4fa63addcd89102b7cb0b5dca0a9ca8c0d617373b2c294e878f9
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m448084_lifted
# naming:       native port src/original_methods_fl40.c:m448084_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 10 seeds; oracle 79/79 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1e, field_2c; [ecx + n] field_2a
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m448084_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 79 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00448084 - 0x401000
.globl FUN_00448084
FUN_00448084:
    # block 0x00448084: entry, 9 instruction(s), ends with je to 0x0044817e (forward)
    push ebp                                     # 00448084
    {load} mov ebp, esp                          # 00448085
    sub esp, 0x14                                # 00448087
    push esi                                     # 0044808a
    push edi                                     # 0044808b
    mov dword ptr [ebp - local_14], ecx          # 0044808c
    mov eax, dword ptr [ebp - local_14]          # 0044808f
    cmp dword ptr [eax + field_1e], 0x0          # 00448092
    je.d32 L_0044817e                            # 00448096
    # block 0x0044809c: entered by fall-through of je at 0x00448096, 24 instruction(s), calls FUN_0051dc43, ends with jne to 0x00448131 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044809c
    mov edx, dword ptr [ecx]                     # 0044809f
    mov dword ptr [ebp - local_4], edx           # 004480a1
    mov dword ptr [ebp - local_c], 0x7           # 004480a4
    mov eax, dword ptr [ebp - local_4]           # 004480ab
    add eax, 0x7                                 # 004480ae
    mov dword ptr [ebp - local_8], eax           # 004480b1
    mov ecx, dword ptr [ebp - local_8]           # 004480b4
    movsx edx, word ptr [ecx + field_2a]         # 004480b7
    imul edx, edx, 0x12                          # 004480bb
    mov eax, dword ptr [ebp - local_c]           # 004480be
    lea ecx, [eax + edx + field_2c]              # 004480c1
    mov dword ptr [ebp - local_c], ecx           # 004480c5
    mov edx, dword ptr [ebp - local_c]           # 004480c8
    push edx                                     # 004480cb
    call FUN_0051dc43                            # 004480cc
    add esp, 0x4                                 # 004480d1
    mov dword ptr [ebp - local_10], eax          # 004480d4
    movsx eax, word ptr [0x5c39e3]               # 004480d7
    imul eax, eax, 0x8d                          # 004480de
    mov ecx, dword ptr [ebp - local_10]          # 004480e4
    mov dword ptr [eax + 0x5bb5e5], ecx          # 004480e7
    cmp dword ptr [ebp - local_10], 0x0          # 004480ed
    jne.d8 L_00448131                            # 004480f1
    # block 0x004480f3: entered by fall-through of jne at 0x004480f1, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00448131
    movsx edx, word ptr [0x5c39e3]               # 004480f3
    push edx                                     # 004480fa
    mov eax, dword ptr [0x5bb57b]                # 004480fb
    push eax                                     # 00448100
    push 0x5486c0                                # 00448101
    push 0x63888b                                # 00448106
    call FUN_0050ca3e                            # 0044810b
    add esp, 0x10                                # 00448110
    push 0x63888b                                # 00448113
    push 0x5486ec                                # 00448118
    mov ecx, 0x583979                            # 0044811d
    call FUN_0042639d                            # 00448122
    mov ecx, 0x5cf659                            # 00448127
    call FUN_004c97b4                            # 0044812c
L_00448131:
    # block 0x00448131: entered by jne at 0x004480f1, 24 instruction(s), ends with je to 0x0044817e (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00448131
    mov edx, dword ptr [ebp + arg_c]             # 00448134
    mov esi, dword ptr [edx]                     # 00448137
    mov eax, dword ptr [ebp + arg_8]             # 00448139
    mov edi, dword ptr [eax]                     # 0044813c
    {load} mov edx, ecx                          # 0044813e
    shr ecx, 0x2                                 # 00448140
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00448143
    {load} mov ecx, edx                          # 00448145
    and ecx, 0x3                                 # 00448147
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044814a
    mov eax, dword ptr [ebp + arg_10]            # 0044814c
    mov ecx, dword ptr [eax]                     # 0044814f
    add ecx, dword ptr [ebp - local_c]           # 00448151
    mov edx, dword ptr [ebp + arg_10]            # 00448154
    mov dword ptr [edx], ecx                     # 00448157
    mov eax, dword ptr [ebp + arg_c]             # 00448159
    mov ecx, dword ptr [eax]                     # 0044815c
    add ecx, dword ptr [ebp - local_c]           # 0044815e
    mov edx, dword ptr [ebp + arg_c]             # 00448161
    mov dword ptr [edx], ecx                     # 00448164
    movsx eax, word ptr [0x63a4cd]               # 00448166
    test eax, eax                                # 0044816d
    je.d8 L_0044817e                             # 0044816f
    # block 0x00448171: entered by fall-through of je at 0x0044816f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044817e
    push 0x548708                                # 00448171
    call FUN_0044a2b7                            # 00448176
    add esp, 0x4                                 # 0044817b
L_0044817e:
    # block 0x0044817e: entered by je at 0x00448096; je at 0x0044816f, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044817e
    pop esi                                      # 0044817f
    {load} mov esp, ebp                          # 00448180
    pop ebp                                      # 00448182
    ret 0xc                                      # 00448183

