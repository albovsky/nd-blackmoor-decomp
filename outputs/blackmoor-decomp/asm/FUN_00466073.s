# FUN_00466073
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00466073
# extent:       0x00466073-0x00466237 (452 code bytes)
# span:         0x00466073-0x00466247 (code 452, tables 16, padding 0)
# sha256:       6b9ad997360ed30002e99fc12e982ff87ad6e932b272391188e33854215f07da
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m466073_click_27d2_27d3
# naming:       native port src/original_methods_fl24b.c:m466073_click_27d2_27d3 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m466073_click_27d2_27d3 (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 396 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_13, local_34, local_38, local_3c, local_40
# fields:       [eax + n] field_1e, field_2a, field_2c, field_3e, field_40, field_41, field_42, field_49; [ecx + n] field_2a, field_2c, field_4e; [edx + n] field_28, field_2a, field_2c, field_3e, field_3f, field_4d
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m466073_click_27d2_27d3 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 127 instruction(s), 9 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_13, 0x13  # offset -0x13
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_1e, 0x1e  # offset +0x1e
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_3e, 0x3e  # offset +0x3e
.equ field_3f, 0x3f  # offset +0x3f
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_42, 0x42  # offset +0x42
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_4e, 0x4e  # offset +0x4e

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00466073 - 0x401000
.globl FUN_00466073
FUN_00466073:
    # block 0x00466073: entry, 14 instruction(s), ends with je to 0x00466231 (forward)
    push ebp                                     # 00466073
    {load} mov ebp, esp                          # 00466074
    sub esp, 0x40                                # 00466076
    push esi                                     # 00466079
    push edi                                     # 0046607a
    mov dword ptr [ebp - local_3c], ecx          # 0046607b
    mov eax, dword ptr [ebp - local_3c]          # 0046607e
    movsx ecx, word ptr [eax + field_1e]         # 00466081
    imul ecx, ecx, 0x8d                          # 00466085
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046608b
    mov dword ptr [ebp - local_38], edx          # 00466091
    mov eax, dword ptr [ebp - local_3c]          # 00466094
    cmp dword ptr [eax + field_49], 0x0          # 00466097
    je.d32 L_00466231                            # 0046609b
    # block 0x004660a1: entered by fall-through of je at 0x0046609b, 5 instruction(s), ends with jne to 0x00466231 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004660a1
    {load} xor edx, edx                          # 004660a4
    mov dl, byte ptr [ecx + field_4e]            # 004660a6
    test edx, edx                                # 004660a9
    jne.d32 L_00466231                           # 004660ab
    # block 0x004660b1: entered by fall-through of jne at 0x004660ab, 5 instruction(s), ends with jne to 0x00466231 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004660b1
    movsx ecx, word ptr [eax + field_1e]         # 004660b4
    imul ecx, ecx, 0x8d                          # 004660b8
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004660be
    jne.d32 L_00466231                           # 004660c5
    # block 0x004660cb: entered by fall-through of jne at 0x004660c5, 2 instruction(s), ends with jne to 0x004660fa (forward)
    cmp dword ptr [0x5c39e5], 0x27d3             # 004660cb
    jne.d8 L_004660fa                            # 004660d5
    # block 0x004660d7: entered by fall-through of jne at 0x004660d5, 7 instruction(s), ends with forward jump to 0x00466231
    mov edx, dword ptr [ebp - local_3c]          # 004660d7
    mov byte ptr [edx + field_4d], 0x1           # 004660da
    mov eax, dword ptr [ebp - local_3c]          # 004660de
    movsx ecx, word ptr [eax + field_1e]         # 004660e1
    imul ecx, ecx, 0x8d                          # 004660e5
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004660eb
    jmp.d32 L_00466231                           # 004660f5
L_004660fa:
    # block 0x004660fa: entered by jne at 0x004660d5, 2 instruction(s), ends with jne to 0x00466231 (forward)
    cmp dword ptr [0x5c39e5], 0x27d2             # 004660fa
    jne.d32 L_00466231                           # 00466104
    # block 0x0046610a: entered by fall-through of jne at 0x00466104, 8 instruction(s), ends with ja to 0x00466206 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0046610a
    movsx eax, word ptr [edx + field_28]         # 0046610d
    mov dword ptr [ebp - local_40], eax          # 00466111
    mov ecx, dword ptr [ebp - local_40]          # 00466114
    sub ecx, 0x1                                 # 00466117
    mov dword ptr [ebp - local_40], ecx          # 0046611a
    cmp dword ptr [ebp - local_40], 0x3          # 0046611d
    ja.d32 L_00466206                            # 00466121
    # block 0x00466127: entered by fall-through of ja at 0x00466121, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x466237]
    mov edx, dword ptr [ebp - local_40]          # 00466127
    jmp dword ptr [4*edx + SWTAB_00466237_VA]    # 0046612a
L_00466131:
    # block 0x00466131: entered by switch case, 17 instruction(s), ends with forward jump to 0x00466206
    mov eax, dword ptr [ebp - local_3c]          # 00466131
    {load} xor ecx, ecx                          # 00466134
    mov cl, byte ptr [eax + field_3e]            # 00466136
    neg ecx                                      # 00466139
    {load} sbb ecx, ecx                          # 0046613b
    inc ecx                                      # 0046613d
    mov edx, dword ptr [ebp - local_3c]          # 0046613e
    mov byte ptr [edx + field_3e], cl            # 00466141
    mov eax, dword ptr [ebp - local_3c]          # 00466144
    mov byte ptr [eax + field_42], 0x1           # 00466147
    mov esi, dword ptr [ebp - local_38]          # 0046614b
    add esi, 0x43e                               # 0046614e
    mov ecx, 0xc                                 # 00466154
    lea edi, [ebp - local_34]                    # 00466159
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046615c
    movsb byte ptr es:[edi], byte ptr [esi]      # 0046615e
    jmp.d32 L_00466206                           # 0046615f
L_00466164:
    # block 0x00466164: entered by switch case, 4 instruction(s), ends with jge to 0x00466184 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 00466164
    movsx edx, word ptr [ecx + field_2c]         # 00466167
    cmp edx, 0x3                                 # 0046616b
    jge.d8 L_00466184                            # 0046616e
    # block 0x00466170: entered by fall-through of jge at 0x0046616e, 6 instruction(s), ends with forward jump to 0x00466194
    mov eax, dword ptr [ebp - local_3c]          # 00466170
    mov cx, word ptr [eax + field_2c]            # 00466173
    add cx, 0x1                                  # 00466177
    mov edx, dword ptr [ebp - local_3c]          # 0046617b
    mov word ptr [edx + field_2c], cx            # 0046617e
    jmp.d8 L_00466194                            # 00466182
L_00466184:
    # block 0x00466184: entered by jge at 0x0046616e, 4 instruction(s), falls into the block at 0x00466194
    mov eax, dword ptr [ebp - local_3c]          # 00466184
    mov byte ptr [eax + field_41], 0x1           # 00466187
    mov ecx, dword ptr [ebp - local_3c]          # 0046618b
    mov word ptr [ecx + field_2c], 0x0           # 0046618e
L_00466194:
    # block 0x00466194: entered by jmp at 0x00466182, 7 instruction(s), ends with forward jump to 0x00466206
    mov esi, dword ptr [ebp - local_38]          # 00466194
    add esi, 0x46f                               # 00466197
    mov ecx, 0xc                                 # 0046619d
    lea edi, [ebp - local_34]                    # 004661a2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004661a5
    movsb byte ptr es:[edi], byte ptr [esi]      # 004661a7
    jmp.d8 L_00466206                            # 004661a8
L_004661aa:
    # block 0x004661aa: entered by switch case, 14 instruction(s), ends with forward jump to 0x00466206
    mov edx, dword ptr [ebp - local_3c]          # 004661aa
    mov ax, word ptr [edx + field_2a]            # 004661ad
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004661b1
    mov ecx, dword ptr [ebp - local_3c]          # 004661b5
    mov word ptr [ecx + field_2a], ax            # 004661b8
    mov esi, dword ptr [ebp - local_38]          # 004661bc
    add esi, 0x40d                               # 004661bf
    mov ecx, 0xc                                 # 004661c5
    lea edi, [ebp - local_34]                    # 004661ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004661cd
    movsb byte ptr es:[edi], byte ptr [esi]      # 004661cf
    mov edx, dword ptr [ebp - local_3c]          # 004661d0
    mov byte ptr [edx + field_3f], 0x1           # 004661d3
    jmp.d8 L_00466206                            # 004661d7
L_004661d9:
    # block 0x004661d9: entered by switch case, 13 instruction(s), falls into the block at 0x00466206
    mov eax, dword ptr [ebp - local_3c]          # 004661d9
    mov cx, word ptr [eax + field_2a]            # 004661dc
    add cx, 0x1                                  # 004661e0
    mov edx, dword ptr [ebp - local_3c]          # 004661e4
    mov word ptr [edx + field_2a], cx            # 004661e7
    mov esi, dword ptr [ebp - local_38]          # 004661eb
    add esi, 0x40d                               # 004661ee
    mov ecx, 0xc                                 # 004661f4
    lea edi, [ebp - local_34]                    # 004661f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004661fc
    movsb byte ptr es:[edi], byte ptr [esi]      # 004661fe
    mov eax, dword ptr [ebp - local_3c]          # 004661ff
    mov byte ptr [eax + field_40], 0x1           # 00466202
L_00466206:
    # block 0x00466206: entered by ja at 0x00466121; jmp at 0x0046615f; jmp at 0x004661a8; jmp at 0x004661d7, 2 instruction(s), ends with je to 0x00466231 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 00466206
    je.d8 L_00466231                             # 0046620d
    # block 0x0046620f: entered by fall-through of je at 0x0046620d, 6 instruction(s), ends with je to 0x00466231 (forward)
    mov edi, 0x54b54c                            # 0046620f
    lea esi, [ebp - local_34]                    # 00466214
    mov ecx, 0x9                                 # 00466217
    {load} xor edx, edx                          # 0046621c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046621e
    je.d8 L_00466231                             # 00466220
    # block 0x00466222: entered by fall-through of je at 0x00466220, 4 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00466231
    mov ax, word ptr [ebp - local_13]            # 00466222
    push eax                                     # 00466226
    mov ecx, 0x5c3a67                            # 00466227
    call FUN_004fb2e3                            # 0046622c
L_00466231:
    # block 0x00466231: entered by je at 0x0046609b; jne at 0x004660ab; jne at 0x004660c5; jmp at 0x004660f5; more, 5 instruction(s), ends with ret
    pop edi                                      # 00466231
    pop esi                                      # 00466232
    {load} mov esp, ebp                          # 00466233
    pop ebp                                      # 00466235
    ret                                          # 00466236

# --- data items (not part of the function) -------------------------
.org 0x00466237 - 0x401000
SWTAB_00466237:  # 4 case address(es)
    .long L_00466131 - .text + 0x401000
    .long L_004661aa - .text + 0x401000
    .long L_004661d9 - .text + 0x401000
    .long L_00466164 - .text + 0x401000
.set SWTAB_00466237_VA, SWTAB_00466237 - .text + 0x401000

