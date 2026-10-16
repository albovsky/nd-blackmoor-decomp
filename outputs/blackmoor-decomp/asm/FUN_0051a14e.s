# FUN_0051a14e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a14e
# extent:       0x0051a14e-0x0051a267 (281 code bytes)
# span:         0x0051a14e-0x0051a267 (code 281, tables 0, padding 0)
# sha256:       da78d2e16b3a4a96dc05f5806ec36fccaa625b7640de75cc1254aca5c7886b13
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a14e
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [esi + n] field_4, field_8, field_c, field_10
# callees:      calls FUN_0051dc6c, FUN_0051dc43, FUN_0050f920, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 111 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a14e - 0x401000
.globl FUN_0051a14e
FUN_0051a14e:
    # block 0x0051a14e: entry, 9 instruction(s), ends with je to 0x0051a161 (forward)
    push ebp                                     # 0051a14e
    {load} mov ebp, esp                          # 0051a14f
    mov eax, dword ptr [ebp + arg_c]             # 0051a151
    push ebx                                     # 0051a154
    push esi                                     # 0051a155
    cmp eax, -0x1                                # 0051a156
    push edi                                     # 0051a159
    {load} mov esi, ecx                          # 0051a15a
    je.d8 L_0051a161                             # 0051a15c
    # block 0x0051a15e: entered by fall-through of je at 0x0051a15c, 1 instruction(s), falls into the block at 0x0051a161
    mov dword ptr [esi + field_10], eax          # 0051a15e
L_0051a161:
    # block 0x0051a161: entered by je at 0x0051a15c, 4 instruction(s), ends with jne to 0x0051a181 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0051a161
    {load} xor ebx, ebx                          # 0051a164
    {load} cmp edi, ebx                          # 0051a166
    jne.d8 L_0051a181                            # 0051a168
    # block 0x0051a16a: entered by fall-through of jne at 0x0051a168, 7 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x0051a260
    push dword ptr [esi + field_4]               # 0051a16a
    call FUN_0051dc6c                            # 0051a16d
    pop ecx                                      # 0051a172
    mov dword ptr [esi + field_4], ebx           # 0051a173
    mov dword ptr [esi + field_c], ebx           # 0051a176
    mov dword ptr [esi + field_8], ebx           # 0051a179
    jmp.d32 L_0051a260                           # 0051a17c
L_0051a181:
    # block 0x0051a181: entered by jne at 0x0051a168, 3 instruction(s), ends with jne to 0x0051a1ad (forward)
    mov ecx, dword ptr [esi + field_4]           # 0051a181
    {load} cmp ecx, ebx                          # 0051a184
    jne.d8 L_0051a1ad                            # 0051a186
    # block 0x0051a188: entered by fall-through of jne at 0x0051a186, 11 instruction(s), calls FUN_0051dc43, FUN_0050f920, falls into the block at 0x0051a1a5
    {load} mov ebx, edi                          # 0051a188
    shl ebx, 0x2                                 # 0051a18a
    push ebx                                     # 0051a18d
    call FUN_0051dc43                            # 0051a18e
    push ebx                                     # 0051a193
    push 0x0                                     # 0051a194
    push eax                                     # 0051a196
    mov dword ptr [esi + field_4], eax           # 0051a197
    call FUN_0050f920                            # 0051a19a
    add esp, 0x10                                # 0051a19f
    mov dword ptr [esi + field_c], edi           # 0051a1a2
L_0051a1a5:
    # block 0x0051a1a5: entered by jle at 0x0051a1b9; jmp at 0x0051a1d7, 2 instruction(s), ends with forward jump to 0x0051a260
    mov dword ptr [esi + field_8], edi           # 0051a1a5
    jmp.d32 L_0051a260                           # 0051a1a8
L_0051a1ad:
    # block 0x0051a1ad: entered by jne at 0x0051a186, 3 instruction(s), ends with jg to 0x0051a1d9 (forward)
    mov ebx, dword ptr [esi + field_c]           # 0051a1ad
    {load} cmp edi, ebx                          # 0051a1b0
    jg.d8 L_0051a1d9                             # 0051a1b2
    # block 0x0051a1b4: entered by fall-through of jg at 0x0051a1b2, 3 instruction(s), ends with jle to 0x0051a1a5 (backward)
    mov eax, dword ptr [esi + field_8]           # 0051a1b4
    {load} cmp edi, eax                          # 0051a1b7
    jle.d8 L_0051a1a5                            # 0051a1b9
    # block 0x0051a1bb: entered by fall-through of jle at 0x0051a1b9, 11 instruction(s), calls FUN_0050f920, ends with backward jump to 0x0051a1a5
    {load} mov edx, eax                          # 0051a1bb
    lea eax, [ecx + 4*eax]                       # 0051a1bd
    imul edx, edx, 0x3fffffff                    # 0051a1c0
    {load} add edx, edi                          # 0051a1c6
    shl edx, 0x2                                 # 0051a1c8
    push edx                                     # 0051a1cb
    push 0x0                                     # 0051a1cc
    push eax                                     # 0051a1ce
    call FUN_0050f920                            # 0051a1cf
    add esp, 0xc                                 # 0051a1d4
    jmp.d8 L_0051a1a5                            # 0051a1d7
L_0051a1d9:
    # block 0x0051a1d9: entered by jg at 0x0051a1b2, 3 instruction(s), ends with jne to 0x0051a203 (forward)
    mov eax, dword ptr [esi + field_10]          # 0051a1d9
    test eax, eax                                # 0051a1dc
    jne.d8 L_0051a203                            # 0051a1de
    # block 0x0051a1e0: entered by fall-through of jne at 0x0051a1de, 7 instruction(s), ends with jl to 0x0051a200 (forward)
    mov eax, dword ptr [esi + field_8]           # 0051a1e0
    push 0x8                                     # 0051a1e3
    cdq                                          # 0051a1e5
    pop ecx                                      # 0051a1e6
    idiv ecx                                     # 0051a1e7
    cmp eax, 0x4                                 # 0051a1e9
    jl.d8 L_0051a200                             # 0051a1ec
    # block 0x0051a1ee: entered by fall-through of jl at 0x0051a1ec, 3 instruction(s), ends with jle to 0x0051a1fb (forward)
    mov ecx, 0x400                               # 0051a1ee
    {load} cmp eax, ecx                          # 0051a1f3
    jle.d8 L_0051a1fb                            # 0051a1f5
    # block 0x0051a1f7: entered by fall-through of jle at 0x0051a1f5, 2 instruction(s), ends with forward jump to 0x0051a203
    {load} mov eax, ecx                          # 0051a1f7
    jmp.d8 L_0051a203                            # 0051a1f9
L_0051a1fb:
    # block 0x0051a1fb: entered by jle at 0x0051a1f5, 2 instruction(s), ends with jge to 0x0051a203 (forward)
    cmp eax, 0x4                                 # 0051a1fb
    jge.d8 L_0051a203                            # 0051a1fe
L_0051a200:
    # block 0x0051a200: entered by jl at 0x0051a1ec; fall-through of jge at 0x0051a1fe, 2 instruction(s), falls into the block at 0x0051a203
    push 0x4                                     # 0051a200
    pop eax                                      # 0051a202
L_0051a203:
    # block 0x0051a203: entered by jne at 0x0051a1de; jmp at 0x0051a1f9; jge at 0x0051a1fe, 4 instruction(s), ends with jl to 0x0051a20f (forward)
    {load} add eax, ebx                          # 0051a203
    {load} cmp edi, eax                          # 0051a205
    mov dword ptr [ebp + arg_c], eax             # 0051a207
    jl.d8 L_0051a20f                             # 0051a20a
    # block 0x0051a20c: entered by fall-through of jl at 0x0051a20a, 1 instruction(s), falls into the block at 0x0051a20f
    mov dword ptr [ebp + arg_c], edi             # 0051a20c
L_0051a20f:
    # block 0x0051a20f: entered by jl at 0x0051a20a, 28 instruction(s), calls FUN_0051dc43, FUN_0050fa90, FUN_0050f920, FUN_0051dc6c, falls into the block at 0x0051a260
    mov eax, dword ptr [ebp + arg_c]             # 0051a20f
    shl eax, 0x2                                 # 0051a212
    push eax                                     # 0051a215
    call FUN_0051dc43                            # 0051a216
    {load} mov ebx, eax                          # 0051a21b
    mov eax, dword ptr [esi + field_8]           # 0051a21d
    shl eax, 0x2                                 # 0051a220
    push eax                                     # 0051a223
    push dword ptr [esi + field_4]               # 0051a224
    push ebx                                     # 0051a227
    call FUN_0050fa90                            # 0051a228
    mov eax, dword ptr [esi + field_8]           # 0051a22d
    {load} mov ecx, eax                          # 0051a230
    imul ecx, ecx, 0x3fffffff                    # 0051a232
    {load} add ecx, edi                          # 0051a238
    lea eax, [ebx + 4*eax]                       # 0051a23a
    shl ecx, 0x2                                 # 0051a23d
    push ecx                                     # 0051a240
    push 0x0                                     # 0051a241
    push eax                                     # 0051a243
    call FUN_0050f920                            # 0051a244
    push dword ptr [esi + field_4]               # 0051a249
    call FUN_0051dc6c                            # 0051a24c
    mov eax, dword ptr [ebp + arg_c]             # 0051a251
    add esp, 0x20                                # 0051a254
    mov dword ptr [esi + field_4], ebx           # 0051a257
    mov dword ptr [esi + field_8], edi           # 0051a25a
    mov dword ptr [esi + field_c], eax           # 0051a25d
L_0051a260:
    # block 0x0051a260: entered by jmp at 0x0051a17c; jmp at 0x0051a1a8, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 0051a260
    pop esi                                      # 0051a261
    pop ebx                                      # 0051a262
    pop ebp                                      # 0051a263
    ret 0x8                                      # 0051a264

