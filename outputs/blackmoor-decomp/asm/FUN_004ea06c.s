# FUN_004ea06c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea06c
# extent:       0x004ea06c-0x004ea1cb (351 code bytes)
# span:         0x004ea06c-0x004ea1cb (code 351, tables 0, padding 0)
# sha256:       f6aa62744639b799a56390c9a86098b21c19b3708c1f1255023ce25c0ded2ba2
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action79_remove_item
# naming:       native port src/action_family_79_runtime.c:action79_remove_item (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Native is action79_remove_item. RT-13 oracle 1554 and RT-19 3646 cases, 0 mismatches. Gaps: out-of-model inputs rejected natively.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_822e; [ecx + n] field_822e, field_8316; [edx + n] field_822e, field_828a, field_8316
# callees:      calls FUN_004e812f
# track-n:      outputs/blackmoor-decomp/src/action_family_78_runtime.c:action78_visit (function ledger class native_oracle_verified; also remove_item; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 88 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_822e, 0x822e  # offset +0x822e
.equ field_828a, 0x828a  # offset +0x828a
.equ field_8316, 0x8316  # offset +0x8316

# --- external targets -----------------------------------------------
.set FUN_004e812f, .text + (0x004e812f - 0x401000)

.org 0x004ea06c - 0x401000
.globl FUN_004ea06c
FUN_004ea06c:
    # block 0x004ea06c: entry, 10 instruction(s), ends with forward jump to 0x004ea0a2
    push ebp                                     # 004ea06c
    {load} mov ebp, esp                          # 004ea06d
    sub esp, 0x8                                 # 004ea06f
    push esi                                     # 004ea072
    push edi                                     # 004ea073
    mov dword ptr [ebp - local_8], ecx           # 004ea074
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ea077
    mov eax, dword ptr [ebp - local_8]           # 004ea07e
    mov dword ptr [eax + field_822e], 0x0        # 004ea081
    jmp.d8 L_004ea0a2                            # 004ea08b
L_004ea08d:
    # block 0x004ea08d: entered by jmp at 0x004ea0db, 5 instruction(s), falls into the block at 0x004ea0a2
    mov ecx, dword ptr [ebp - local_8]           # 004ea08d
    mov edx, dword ptr [ecx + field_822e]        # 004ea090
    add edx, 0x1                                 # 004ea096
    mov eax, dword ptr [ebp - local_8]           # 004ea099
    mov dword ptr [eax + field_822e], edx        # 004ea09c
L_004ea0a2:
    # block 0x004ea0a2: entered by jmp at 0x004ea08b, 4 instruction(s), ends with jge to 0x004ea0dd (forward)
    movsx ecx, word ptr [0x583a2b]               # 004ea0a2
    mov edx, dword ptr [ebp - local_8]           # 004ea0a9
    cmp dword ptr [edx + field_822e], ecx        # 004ea0ac
    jge.d8 L_004ea0dd                            # 004ea0b2
    # block 0x004ea0b4: entered by fall-through of jge at 0x004ea0b2, 6 instruction(s), ends with jne to 0x004ea0db (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ea0b4
    mov ecx, dword ptr [eax + field_822e]        # 004ea0b7
    movsx edx, word ptr [2*ecx + 0x583a31]       # 004ea0bd
    movsx eax, word ptr [ebp + arg_8]            # 004ea0c5
    {load} cmp edx, eax                          # 004ea0c9
    jne.d8 L_004ea0db                            # 004ea0cb
    # block 0x004ea0cd: entered by fall-through of jne at 0x004ea0cb, 4 instruction(s), ends with forward jump to 0x004ea0dd
    mov ecx, dword ptr [ebp - local_8]           # 004ea0cd
    mov edx, dword ptr [ecx + field_822e]        # 004ea0d0
    mov dword ptr [ebp - local_4], edx           # 004ea0d6
    jmp.d8 L_004ea0dd                            # 004ea0d9
L_004ea0db:
    # block 0x004ea0db: entered by jne at 0x004ea0cb, 1 instruction(s), ends with backward jump to 0x004ea08d
    jmp.d8 L_004ea08d                            # 004ea0db
L_004ea0dd:
    # block 0x004ea0dd: entered by jge at 0x004ea0b2; jmp at 0x004ea0d9, 2 instruction(s), ends with jne to 0x004ea0e8 (forward)
    cmp dword ptr [ebp - local_4], -0x1          # 004ea0dd
    jne.d8 L_004ea0e8                            # 004ea0e1
    # block 0x004ea0e3: entered by fall-through of jne at 0x004ea0e1, 1 instruction(s), ends with forward jump to 0x004ea1c3
    jmp.d32 L_004ea1c3                           # 004ea0e3
L_004ea0e8:
    # block 0x004ea0e8: entered by jne at 0x004ea0e1, 5 instruction(s), ends with forward jump to 0x004ea119
    mov eax, dword ptr [ebp - local_8]           # 004ea0e8
    mov dword ptr [eax + field_822e], 0x0        # 004ea0eb
    mov ecx, dword ptr [ebp - local_8]           # 004ea0f5
    mov dword ptr [ecx + field_8316], 0x0        # 004ea0f8
    jmp.d8 L_004ea119                            # 004ea102
L_004ea104:
    # block 0x004ea104: entered by jmp at 0x004ea173, 5 instruction(s), falls into the block at 0x004ea119
    mov edx, dword ptr [ebp - local_8]           # 004ea104
    mov eax, dword ptr [edx + field_822e]        # 004ea107
    add eax, 0x1                                 # 004ea10d
    mov ecx, dword ptr [ebp - local_8]           # 004ea110
    mov dword ptr [ecx + field_822e], eax        # 004ea113
L_004ea119:
    # block 0x004ea119: entered by jmp at 0x004ea102, 4 instruction(s), ends with jge to 0x004ea175 (forward)
    movsx edx, word ptr [0x583a2b]               # 004ea119
    mov eax, dword ptr [ebp - local_8]           # 004ea120
    cmp dword ptr [eax + field_822e], edx        # 004ea123
    jge.d8 L_004ea175                            # 004ea129
    # block 0x004ea12b: entered by fall-through of jge at 0x004ea129, 4 instruction(s), ends with je to 0x004ea173 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ea12b
    mov edx, dword ptr [ecx + field_822e]        # 004ea12e
    cmp edx, dword ptr [ebp - local_4]           # 004ea134
    je.d8 L_004ea173                             # 004ea137
    # block 0x004ea139: entered by fall-through of je at 0x004ea137, 12 instruction(s), falls into the block at 0x004ea173
    mov eax, dword ptr [ebp - local_8]           # 004ea139
    mov ecx, dword ptr [eax + field_822e]        # 004ea13c
    mov edx, dword ptr [ebp - local_8]           # 004ea142
    mov eax, dword ptr [edx + field_8316]        # 004ea145
    mov edx, dword ptr [ebp - local_8]           # 004ea14b
    mov cx, word ptr [2*ecx + 0x583a31]          # 004ea14e
    mov word ptr [edx + 2*eax + field_828a], cx  # 004ea156
    mov edx, dword ptr [ebp - local_8]           # 004ea15e
    mov eax, dword ptr [edx + field_8316]        # 004ea161
    add eax, 0x1                                 # 004ea167
    mov ecx, dword ptr [ebp - local_8]           # 004ea16a
    mov dword ptr [ecx + field_8316], eax        # 004ea16d
L_004ea173:
    # block 0x004ea173: entered by je at 0x004ea137, 1 instruction(s), ends with backward jump to 0x004ea104
    jmp.d8 L_004ea104                            # 004ea173
L_004ea175:
    # block 0x004ea175: entered by jge at 0x004ea129, 19 instruction(s), calls FUN_004e812f, falls into the block at 0x004ea1c3
    mov edx, dword ptr [ebp - local_8]           # 004ea175
    mov ax, word ptr [edx + field_8316]          # 004ea178
    mov word ptr [0x583a2b], ax                  # 004ea17f
    mov ecx, dword ptr [ebp - local_8]           # 004ea185
    mov ecx, dword ptr [ecx + field_8316]        # 004ea188
    shl ecx                                      # 004ea18e
    mov esi, dword ptr [ebp - local_8]           # 004ea190
    add esi, 0x828a                              # 004ea193
    mov edi, 0x583a31                            # 004ea199
    {load} mov edx, ecx                          # 004ea19e
    shr ecx, 0x2                                 # 004ea1a0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ea1a3
    {load} mov ecx, edx                          # 004ea1a5
    and ecx, 0x3                                 # 004ea1a7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ea1aa
    movsx eax, word ptr [ebp + arg_8]            # 004ea1ac
    mov dword ptr [4*eax + 0x583bd5], 0x0        # 004ea1b0
    mov ecx, dword ptr [ebp - local_8]           # 004ea1bb
    call FUN_004e812f                            # 004ea1be
L_004ea1c3:
    # block 0x004ea1c3: entered by jmp at 0x004ea0e3, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004ea1c3
    pop esi                                      # 004ea1c4
    {load} mov esp, ebp                          # 004ea1c5
    pop ebp                                      # 004ea1c7
    ret 0x4                                      # 004ea1c8

