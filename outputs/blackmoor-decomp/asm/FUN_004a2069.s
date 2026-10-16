# FUN_004a2069
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a2069
# extent:       0x004a2069-0x004a2180 (279 code bytes)
# span:         0x004a2069-0x004a2180 (code 279, tables 0, padding 0)
# sha256:       8d3135c7c43e9626225ec0971103bc66c9e8dbf42670c775d54fc3e98d399534
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a2069
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_37, field_54; [ecx + n] field_4, field_54, field_64; [edx + n] field_20, field_37, field_38, field_54
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 98 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_20, 0x20  # offset +0x20
.equ field_37, 0x37  # offset +0x37
.equ field_38, 0x38  # offset +0x38
.equ field_54, 0x54  # offset +0x54
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x004a2069 - 0x401000
.globl FUN_004a2069
FUN_004a2069:
    # block 0x004a2069: entry, 10 instruction(s), ends with je to 0x004a208d (forward)
    push ebp                                     # 004a2069
    {load} mov ebp, esp                          # 004a206a
    sub esp, 0x8                                 # 004a206c
    push edi                                     # 004a206f
    mov dword ptr [ebp - local_4], ecx           # 004a2070
    mov eax, dword ptr [ebp - local_4]           # 004a2073
    mov ecx, dword ptr [eax + field_54]          # 004a2076
    mov dword ptr [ebp - local_8], ecx           # 004a2079
    cmp dword ptr [ebp - local_8], 0x0           # 004a207c
    je.d8 L_004a208d                             # 004a2080
    # block 0x004a2082: entered by fall-through of je at 0x004a2080, 2 instruction(s), ends with je to 0x004a20e7 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004a2082
    je.d8 L_004a20e7                             # 004a2086
    # block 0x004a2088: entered by fall-through of je at 0x004a2086, 1 instruction(s), ends with forward jump to 0x004a2136
    jmp.d32 L_004a2136                           # 004a2088
L_004a208d:
    # block 0x004a208d: entered by je at 0x004a2080, 9 instruction(s), ends with jne to 0x004a20ac (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a208d
    add edi, 0x38                                # 004a2090
    or ecx, -0x1                                 # 004a2093
    {load} xor eax, eax                          # 004a2096
    repne scasb al, byte ptr es:[edi]            # 004a2098
    not ecx                                      # 004a209a
    add ecx, -0x1                                # 004a209c
    test ecx, ecx                                # 004a209f
    jne.d8 L_004a20ac                            # 004a20a1
    # block 0x004a20a3: entered by fall-through of jne at 0x004a20a1, 3 instruction(s), ends with forward jump to 0x004a20e5
    mov edx, dword ptr [ebp - local_4]           # 004a20a3
    mov byte ptr [edx + field_38], 0x2d          # 004a20a6
    jmp.d8 L_004a20e5                            # 004a20aa
L_004a20ac:
    # block 0x004a20ac: entered by jne at 0x004a20a1, 11 instruction(s), ends with je to 0x004a20e5 (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a20ac
    add edi, 0x38                                # 004a20af
    or ecx, -0x1                                 # 004a20b2
    {load} xor eax, eax                          # 004a20b5
    repne scasb al, byte ptr es:[edi]            # 004a20b7
    not ecx                                      # 004a20b9
    add ecx, -0x1                                # 004a20bb
    mov eax, dword ptr [ebp - local_4]           # 004a20be
    movsx ecx, byte ptr [eax + ecx + field_37]   # 004a20c1
    cmp ecx, 0x2d                                # 004a20c6
    je.d8 L_004a20e5                             # 004a20c9
    # block 0x004a20cb: entered by fall-through of je at 0x004a20c9, 9 instruction(s), falls into the block at 0x004a20e5
    mov edi, dword ptr [ebp - local_4]           # 004a20cb
    add edi, 0x38                                # 004a20ce
    or ecx, -0x1                                 # 004a20d1
    {load} xor eax, eax                          # 004a20d4
    repne scasb al, byte ptr es:[edi]            # 004a20d6
    not ecx                                      # 004a20d8
    add ecx, -0x1                                # 004a20da
    mov edx, dword ptr [ebp - local_4]           # 004a20dd
    mov byte ptr [edx + ecx + field_38], 0x2d    # 004a20e0
L_004a20e5:
    # block 0x004a20e5: entered by jmp at 0x004a20aa; je at 0x004a20c9, 1 instruction(s), ends with forward jump to 0x004a2136
    jmp.d8 L_004a2136                            # 004a20e5
L_004a20e7:
    # block 0x004a20e7: entered by je at 0x004a2086, 9 instruction(s), ends with jbe to 0x004a2136 (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a20e7
    add edi, 0x38                                # 004a20ea
    or ecx, -0x1                                 # 004a20ed
    {load} xor eax, eax                          # 004a20f0
    repne scasb al, byte ptr es:[edi]            # 004a20f2
    not ecx                                      # 004a20f4
    add ecx, -0x1                                # 004a20f6
    test ecx, ecx                                # 004a20f9
    jbe.d8 L_004a2136                            # 004a20fb
    # block 0x004a20fd: entered by fall-through of jbe at 0x004a20fb, 11 instruction(s), ends with jne to 0x004a2136 (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a20fd
    add edi, 0x38                                # 004a2100
    or ecx, -0x1                                 # 004a2103
    {load} xor eax, eax                          # 004a2106
    repne scasb al, byte ptr es:[edi]            # 004a2108
    not ecx                                      # 004a210a
    add ecx, -0x1                                # 004a210c
    mov eax, dword ptr [ebp - local_4]           # 004a210f
    movsx ecx, byte ptr [eax + ecx + field_37]   # 004a2112
    cmp ecx, 0x2d                                # 004a2117
    jne.d8 L_004a2136                            # 004a211a
    # block 0x004a211c: entered by fall-through of jne at 0x004a211a, 9 instruction(s), falls into the block at 0x004a2136
    mov edi, dword ptr [ebp - local_4]           # 004a211c
    add edi, 0x38                                # 004a211f
    or ecx, -0x1                                 # 004a2122
    {load} xor eax, eax                          # 004a2125
    repne scasb al, byte ptr es:[edi]            # 004a2127
    not ecx                                      # 004a2129
    add ecx, -0x1                                # 004a212b
    mov edx, dword ptr [ebp - local_4]           # 004a212e
    mov byte ptr [edx + ecx + field_37], 0x0     # 004a2131
L_004a2136:
    # block 0x004a2136: entered by jmp at 0x004a2088; jmp at 0x004a20e5; jbe at 0x004a20fb; jne at 0x004a211a, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004a217b (forward)
    call dword ptr [0x52a23c]                    # 004a2136
    mov ecx, dword ptr [ebp - local_4]           # 004a213c
    cmp eax, dword ptr [ecx + field_64]          # 004a213f
    jb.d8 L_004a217b                             # 004a2142
    # block 0x004a2144: entered by fall-through of jb at 0x004a2142, 3 instruction(s), ends with jne to 0x004a2159 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a2144
    cmp dword ptr [edx + field_54], 0x0          # 004a2147
    jne.d8 L_004a2159                            # 004a214b
    # block 0x004a214d: entered by fall-through of jne at 0x004a214b, 3 instruction(s), ends with forward jump to 0x004a2163
    mov eax, dword ptr [ebp - local_4]           # 004a214d
    mov dword ptr [eax + field_54], 0x1          # 004a2150
    jmp.d8 L_004a2163                            # 004a2157
L_004a2159:
    # block 0x004a2159: entered by jne at 0x004a214b, 2 instruction(s), falls into the block at 0x004a2163
    mov ecx, dword ptr [ebp - local_4]           # 004a2159
    mov dword ptr [ecx + field_54], 0x0          # 004a215c
L_004a2163:
    # block 0x004a2163: entered by jmp at 0x004a2157, 7 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004a217b
    call dword ptr [0x52a23c]                    # 004a2163
    mov edx, dword ptr [ebp - local_4]           # 004a2169
    mov ecx, dword ptr [edx + field_20]          # 004a216c
    movsx edx, word ptr [ecx + field_4]          # 004a216f
    {load} add eax, edx                          # 004a2173
    mov ecx, dword ptr [ebp - local_4]           # 004a2175
    mov dword ptr [ecx + field_64], eax          # 004a2178
L_004a217b:
    # block 0x004a217b: entered by jb at 0x004a2142, 4 instruction(s), ends with ret
    pop edi                                      # 004a217b
    {load} mov esp, ebp                          # 004a217c
    pop ebp                                      # 004a217e
    ret                                          # 004a217f

