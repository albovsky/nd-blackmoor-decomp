# FUN_0049d039
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049d039
# extent:       0x0049d039-0x0049d1be (389 code bytes)
# span:         0x0049d039-0x0049d1be (code 389, tables 0, padding 0)
# sha256:       0febb897051aa27c0cf4fb7ad095c03f58c02f6675e9539c6b3bc38fb00d6502
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49d039_lifted
# naming:       native port src/original_methods_fl41.c:m49d039_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 11 seeds; oracle: 97/97 instructions, 16/16 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_e38; [ecx + n] field_4, field_8, field_1c, field_e38; [edx + n] field_1c, field_e38, field_minus_4, field_minus_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m49d039_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 97 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_e38, 0xe38  # offset +0xe38

# --- external targets -----------------------------------------------

.org 0x0049d039 - 0x401000
.globl FUN_0049d039
FUN_0049d039:
    # block 0x0049d039: entry, 13 instruction(s), ends with jne to 0x0049d09b (forward)
    push ebp                                     # 0049d039
    {load} mov ebp, esp                          # 0049d03a
    push ecx                                     # 0049d03c
    mov dword ptr [ebp - local_4], ecx           # 0049d03d
    mov eax, dword ptr [ebp - local_4]           # 0049d040
    mov ecx, dword ptr [0x6329c9]                # 0049d043
    imul ecx, dword ptr [eax + field_1c]         # 0049d049
    mov edx, dword ptr [ebp - local_4]           # 0049d04d
    mov eax, dword ptr [edx + field_e38]         # 0049d050
    lea ecx, [eax + 4*ecx]                       # 0049d056
    mov edx, dword ptr [0x6329cd]                # 0049d059
    cmp dword ptr [ecx + 4*edx + field_4], 0x0   # 0049d05f
    jne.d8 L_0049d09b                            # 0049d064
    # block 0x0049d066: entered by fall-through of jne at 0x0049d064, 9 instruction(s), ends with jne to 0x0049d09b (forward)
    mov eax, dword ptr [ebp - local_4]           # 0049d066
    mov ecx, dword ptr [0x6329c9]                # 0049d069
    imul ecx, dword ptr [eax + field_1c]         # 0049d06f
    mov edx, dword ptr [ebp - local_4]           # 0049d073
    mov eax, dword ptr [edx + field_e38]         # 0049d076
    lea ecx, [eax + 4*ecx]                       # 0049d07c
    mov edx, dword ptr [0x6329cd]                # 0049d07f
    cmp dword ptr [ecx + 4*edx + field_8], 0x0   # 0049d085
    jne.d8 L_0049d09b                            # 0049d08a
    # block 0x0049d08c: entered by fall-through of jne at 0x0049d08a, 3 instruction(s), ends with forward jump to 0x0049d1ba
    mov eax, dword ptr [0x6329a9]                # 0049d08c
    mov dword ptr [0x6329d1], eax                # 0049d091
    jmp.d32 L_0049d1ba                           # 0049d096
L_0049d09b:
    # block 0x0049d09b: entered by jne at 0x0049d064; jne at 0x0049d08a, 10 instruction(s), ends with jne to 0x0049d0fa (forward)
    mov ecx, dword ptr [0x6329c9]                # 0049d09b
    sub ecx, 0x1                                 # 0049d0a1
    mov edx, dword ptr [ebp - local_4]           # 0049d0a4
    imul ecx, dword ptr [edx + field_1c]         # 0049d0a7
    mov eax, dword ptr [ebp - local_4]           # 0049d0ab
    mov edx, dword ptr [eax + field_e38]         # 0049d0ae
    lea eax, [edx + 4*ecx]                       # 0049d0b4
    mov ecx, dword ptr [0x6329cd]                # 0049d0b7
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049d0bd
    jne.d8 L_0049d0fa                            # 0049d0c1
    # block 0x0049d0c3: entered by fall-through of jne at 0x0049d0c1, 10 instruction(s), ends with jne to 0x0049d0fa (forward)
    mov edx, dword ptr [0x6329c9]                # 0049d0c3
    sub edx, 0x2                                 # 0049d0c9
    mov eax, dword ptr [ebp - local_4]           # 0049d0cc
    imul edx, dword ptr [eax + field_1c]         # 0049d0cf
    mov ecx, dword ptr [ebp - local_4]           # 0049d0d3
    mov eax, dword ptr [ecx + field_e38]         # 0049d0d6
    lea ecx, [eax + 4*edx]                       # 0049d0dc
    mov edx, dword ptr [0x6329cd]                # 0049d0df
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049d0e5
    jne.d8 L_0049d0fa                            # 0049d0e9
    # block 0x0049d0eb: entered by fall-through of jne at 0x0049d0e9, 3 instruction(s), ends with forward jump to 0x0049d1ba
    mov eax, dword ptr [0x6329b1]                # 0049d0eb
    mov dword ptr [0x6329d1], eax                # 0049d0f0
    jmp.d32 L_0049d1ba                           # 0049d0f5
L_0049d0fa:
    # block 0x0049d0fa: entered by jne at 0x0049d0c1; jne at 0x0049d0e9, 9 instruction(s), ends with jne to 0x0049d152 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0049d0fa
    mov edx, dword ptr [0x6329c9]                # 0049d0fd
    imul edx, dword ptr [ecx + field_1c]         # 0049d103
    mov eax, dword ptr [ebp - local_4]           # 0049d107
    mov ecx, dword ptr [eax + field_e38]         # 0049d10a
    lea edx, [ecx + 4*edx]                       # 0049d110
    mov eax, dword ptr [0x6329cd]                # 0049d113
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 0049d118
    jne.d8 L_0049d152                            # 0049d11d
    # block 0x0049d11f: entered by fall-through of jne at 0x0049d11d, 9 instruction(s), ends with jne to 0x0049d152 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0049d11f
    mov edx, dword ptr [0x6329c9]                # 0049d122
    imul edx, dword ptr [ecx + field_1c]         # 0049d128
    mov eax, dword ptr [ebp - local_4]           # 0049d12c
    mov ecx, dword ptr [eax + field_e38]         # 0049d12f
    lea edx, [ecx + 4*edx]                       # 0049d135
    mov eax, dword ptr [0x6329cd]                # 0049d138
    cmp dword ptr [edx + 4*eax - field_minus_8], 0x0 # 0049d13d
    jne.d8 L_0049d152                            # 0049d142
    # block 0x0049d144: entered by fall-through of jne at 0x0049d142, 3 instruction(s), ends with forward jump to 0x0049d1ba
    mov ecx, dword ptr [0x6329b9]                # 0049d144
    mov dword ptr [0x6329d1], ecx                # 0049d14a
    jmp.d8 L_0049d1ba                            # 0049d150
L_0049d152:
    # block 0x0049d152: entered by jne at 0x0049d11d; jne at 0x0049d142, 10 instruction(s), ends with jne to 0x0049d1ae (forward)
    mov edx, dword ptr [0x6329c9]                # 0049d152
    add edx, 0x1                                 # 0049d158
    mov eax, dword ptr [ebp - local_4]           # 0049d15b
    imul edx, dword ptr [eax + field_1c]         # 0049d15e
    mov ecx, dword ptr [ebp - local_4]           # 0049d162
    mov eax, dword ptr [ecx + field_e38]         # 0049d165
    lea ecx, [eax + 4*edx]                       # 0049d16b
    mov edx, dword ptr [0x6329cd]                # 0049d16e
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049d174
    jne.d8 L_0049d1ae                            # 0049d178
    # block 0x0049d17a: entered by fall-through of jne at 0x0049d178, 10 instruction(s), ends with jne to 0x0049d1ae (forward)
    mov eax, dword ptr [0x6329c9]                # 0049d17a
    add eax, 0x2                                 # 0049d17f
    mov ecx, dword ptr [ebp - local_4]           # 0049d182
    imul eax, dword ptr [ecx + field_1c]         # 0049d185
    mov edx, dword ptr [ebp - local_4]           # 0049d189
    mov ecx, dword ptr [edx + field_e38]         # 0049d18c
    lea edx, [ecx + 4*eax]                       # 0049d192
    mov eax, dword ptr [0x6329cd]                # 0049d195
    cmp dword ptr [edx + 4*eax], 0x0             # 0049d19a
    jne.d8 L_0049d1ae                            # 0049d19e
    # block 0x0049d1a0: entered by fall-through of jne at 0x0049d19e, 3 instruction(s), ends with forward jump to 0x0049d1ba
    mov ecx, dword ptr [0x6329bd]                # 0049d1a0
    mov dword ptr [0x6329d1], ecx                # 0049d1a6
    jmp.d8 L_0049d1ba                            # 0049d1ac
L_0049d1ae:
    # block 0x0049d1ae: entered by jne at 0x0049d178; jne at 0x0049d19e, 2 instruction(s), falls into the block at 0x0049d1ba
    mov edx, dword ptr [0x6329ad]                # 0049d1ae
    mov dword ptr [0x6329d1], edx                # 0049d1b4
L_0049d1ba:
    # block 0x0049d1ba: entered by jmp at 0x0049d096; jmp at 0x0049d0f5; jmp at 0x0049d150; jmp at 0x0049d1ac, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0049d1ba
    pop ebp                                      # 0049d1bc
    ret                                          # 0049d1bd

