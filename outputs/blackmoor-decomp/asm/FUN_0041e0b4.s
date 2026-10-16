# FUN_0041e0b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e0b4
# extent:       0x0041e0b4-0x0041e1e4 (304 code bytes)
# span:         0x0041e0b4-0x0041e1e4 (code 304, tables 0, padding 0)
# sha256:       8b8cd13d302c2c426cac07f36c2fd364da72428c4b2acb83b6e9963ba39a1b55
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041e0b4
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_6, field_68e; [ecx + n] field_68e, field_75a, field_fa1; [edx + n] field_1c, field_696, field_f9b, field_fb5
# callees:      calls FUN_0052139c, FUN_004c97b4, FUN_00417b04
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_load_slot (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 85 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68e, 0x68e  # offset +0x68e
.equ field_696, 0x696  # offset +0x696
.equ field_75a, 0x75a  # offset +0x75a
.equ field_f9b, 0xf9b  # offset +0xf9b
.equ field_fa1, 0xfa1  # offset +0xfa1
.equ field_fb5, 0xfb5  # offset +0xfb5

# --- external targets -----------------------------------------------
.set FUN_00417b04, .text + (0x00417b04 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041e0b4 - 0x401000
.globl FUN_0041e0b4
FUN_0041e0b4:
    # block 0x0041e0b4: entry, 10 instruction(s), ends with jge to 0x0041e0e9 (forward)
    push ebp                                     # 0041e0b4
    {load} mov ebp, esp                          # 0041e0b5
    sub esp, 0xc                                 # 0041e0b7
    mov dword ptr [ebp - local_8], ecx           # 0041e0ba
    mov eax, dword ptr [ebp - local_8]           # 0041e0bd
    movsx ecx, word ptr [eax + field_68e]        # 0041e0c0
    mov edx, dword ptr [ebp - local_8]           # 0041e0c7
    movsx eax, word ptr [edx + field_696]        # 0041e0ca
    {load} cmp ecx, eax                          # 0041e0d1
    jge.d8 L_0041e0e9                            # 0041e0d3
    # block 0x0041e0d5: entered by fall-through of jge at 0x0041e0d3, 6 instruction(s), ends with je to 0x0041e101 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0041e0d5
    imul ecx, ecx, 0x16                          # 0041e0d9
    mov edx, dword ptr [ebp - local_8]           # 0041e0dc
    movsx eax, word ptr [edx + ecx + field_1c]   # 0041e0df
    cmp eax, -0x1                                # 0041e0e4
    je.d8 L_0041e101                             # 0041e0e7
L_0041e0e9:
    # block 0x0041e0e9: entered by jge at 0x0041e0d3; fall-through of je at 0x0041e0e7, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041e101
    push 0x0                                     # 0041e0e9
    push 0x0                                     # 0041e0eb
    push 0x5437fc                                # 0041e0ed
    call FUN_0052139c                            # 0041e0f2
    mov ecx, 0x5cf659                            # 0041e0f7
    call FUN_004c97b4                            # 0041e0fc
L_0041e101:
    # block 0x0041e101: entered by je at 0x0041e0e7, 5 instruction(s), ends with je to 0x0041e121 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041e101
    mov dl, byte ptr [ecx + field_75a]           # 0041e104
    mov byte ptr [ebp - local_c], dl             # 0041e10a
    cmp byte ptr [ebp - local_c], 0x39           # 0041e10d
    je.d8 L_0041e121                             # 0041e111
    # block 0x0041e113: entered by fall-through of je at 0x0041e111, 2 instruction(s), ends with je to 0x0041e121 (forward)
    cmp byte ptr [ebp - local_c], 0x3b           # 0041e113
    je.d8 L_0041e121                             # 0041e117
    # block 0x0041e119: entered by fall-through of je at 0x0041e117, 2 instruction(s), ends with je to 0x0041e121 (forward)
    cmp byte ptr [ebp - local_c], 0x3e           # 0041e119
    je.d8 L_0041e121                             # 0041e11d
    # block 0x0041e11f: entered by fall-through of je at 0x0041e11d, 1 instruction(s), ends with forward jump to 0x0041e19b
    jmp.d8 L_0041e19b                            # 0041e11f
L_0041e121:
    # block 0x0041e121: entered by je at 0x0041e111; je at 0x0041e117; je at 0x0041e11d, 2 instruction(s), ends with forward jump to 0x0041e135
    mov word ptr [ebp - local_4], 0x0            # 0041e121
    jmp.d8 L_0041e135                            # 0041e127
L_0041e129:
    # block 0x0041e129: entered by jmp at 0x0041e197, 3 instruction(s), falls into the block at 0x0041e135
    mov ax, word ptr [ebp - local_4]             # 0041e129
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041e12d
    mov word ptr [ebp - local_4], ax             # 0041e131
L_0041e135:
    # block 0x0041e135: entered by jmp at 0x0041e127, 5 instruction(s), ends with jge to 0x0041e199 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041e135
    mov edx, dword ptr [ebp - local_8]           # 0041e139
    movsx eax, word ptr [edx + field_f9b]        # 0041e13c
    {load} cmp ecx, eax                          # 0041e143
    jge.d8 L_0041e199                            # 0041e145
    # block 0x0041e147: entered by fall-through of jge at 0x0041e145, 23 instruction(s), calls FUN_00417b04, ends with backward jump to 0x0041e129
    movsx ecx, word ptr [ebp + arg_8]            # 0041e147
    imul ecx, ecx, 0x16                          # 0041e14b
    mov edx, dword ptr [ebp - local_8]           # 0041e14e
    lea eax, [edx + ecx + field_1c]              # 0041e151
    movsx ecx, word ptr [ebp - local_4]          # 0041e155
    mov edx, dword ptr [eax + 4*ecx + field_6]   # 0041e159
    push edx                                     # 0041e15d
    movsx eax, word ptr [ebp + arg_c]            # 0041e15e
    imul eax, eax, 0x8c                          # 0041e162
    mov ecx, dword ptr [ebp - local_8]           # 0041e168
    mov edx, dword ptr [ecx + field_fa1]         # 0041e16b
    {load} add edx, eax                          # 0041e171
    movsx eax, word ptr [ebp - local_4]          # 0041e173
    imul eax, eax, 0x21                          # 0041e177
    {load} add edx, eax                          # 0041e17a
    push edx                                     # 0041e17c
    movsx ecx, word ptr [ebp - local_4]          # 0041e17d
    mov edx, dword ptr [ebp - local_8]           # 0041e181
    mov ax, word ptr [edx + 2*ecx + field_fb5]   # 0041e184
    push eax                                     # 0041e18c
    mov ecx, 0x5d2f31                            # 0041e18d
    call FUN_00417b04                            # 0041e192
    jmp.d8 L_0041e129                            # 0041e197
L_0041e199:
    # block 0x0041e199: entered by jge at 0x0041e145, 1 instruction(s), ends with forward jump to 0x0041e1b3
    jmp.d8 L_0041e1b3                            # 0041e199
L_0041e19b:
    # block 0x0041e19b: entered by jmp at 0x0041e11f, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041e1b3
    push 0x0                                     # 0041e19b
    push 0x0                                     # 0041e19d
    push 0x54384c                                # 0041e19f
    call FUN_0052139c                            # 0041e1a4
    mov ecx, 0x5cf659                            # 0041e1a9
    call FUN_004c97b4                            # 0041e1ae
L_0041e1b3:
    # block 0x0041e1b3: entered by jmp at 0x0041e199, 13 instruction(s), ends with ret 0x8
    movsx ecx, word ptr [ebp + arg_8]            # 0041e1b3
    imul ecx, ecx, 0x16                          # 0041e1b7
    mov edx, dword ptr [ebp - local_8]           # 0041e1ba
    mov ax, word ptr [ebp + arg_c]               # 0041e1bd
    mov word ptr [edx + ecx + field_1c], ax      # 0041e1c1
    mov ecx, dword ptr [ebp - local_8]           # 0041e1c6
    mov dx, word ptr [ecx + field_68e]           # 0041e1c9
    add dx, 0x1                                  # 0041e1d0
    mov eax, dword ptr [ebp - local_8]           # 0041e1d4
    mov word ptr [eax + field_68e], dx           # 0041e1d7
    {load} mov esp, ebp                          # 0041e1de
    pop ebp                                      # 0041e1e0
    ret 0x8                                      # 0041e1e1

