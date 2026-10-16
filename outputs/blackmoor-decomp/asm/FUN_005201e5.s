# FUN_005201e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005201e5
# extent:       0x005201e5-0x00520256 (113 code bytes)
# span:         0x005201e5-0x00520256 (code 113, tables 0, padding 0)
# sha256:       58633c98e62b215211fe63a5c7b8946785546580406eba13727d8048014b57a8
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005201e5
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_104
# fields:       [ecx + n] field_minus_4; [esi + n] field_4, field_8
# callees:      calls FUN_005206f4, FUN_0052088a, FUN_0051e8a7, FUN_0051e8f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_104, 0x104  # offset -0x104
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e8a7, .text + (0x0051e8a7 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_005206f4, .text + (0x005206f4 - 0x401000)
.set FUN_0052088a, .text + (0x0052088a - 0x401000)

.org 0x005201e5 - 0x401000
.globl FUN_005201e5
FUN_005201e5:
    # block 0x005201e5: entry, 15 instruction(s), calls FUN_005206f4, ends with jle to 0x00520241 (forward)
    push ebp                                     # 005201e5
    {load} mov ebp, esp                          # 005201e6
    sub esp, 0x104                               # 005201e8
    push esi                                     # 005201ee
    push edi                                     # 005201ef
    push dword ptr [ebp + arg_8]                 # 005201f0
    lea eax, [ebp - local_104]                   # 005201f3
    {load} mov esi, ecx                          # 005201f9
    push eax                                     # 005201fb
    call FUN_005206f4                            # 005201fc
    mov eax, dword ptr [esi + field_4]           # 00520201
    {load} xor edi, edi                          # 00520204
    dec eax                                      # 00520206
    test eax, eax                                # 00520207
    jle.d8 L_00520241                            # 00520209
L_0052020b:
    # block 0x0052020b: entered by jl at 0x00520229; fall-through of jle at 0x00520209, 8 instruction(s), calls FUN_0052088a, ends with jne to 0x0052022b (forward)
    mov eax, dword ptr [esi + field_8]           # 0052020b
    lea ecx, [ebp - local_104]                   # 0052020e
    push ecx                                     # 00520214
    mov eax, dword ptr [eax + 4*edi]             # 00520215
    push eax                                     # 00520218
    call FUN_0052088a                            # 00520219
    test eax, eax                                # 0052021e
    jne.d8 L_0052022b                            # 00520220
    # block 0x00520222: entered by fall-through of jne at 0x00520220, 5 instruction(s), ends with jl to 0x0052020b (backward)
    mov eax, dword ptr [esi + field_4]           # 00520222
    inc edi                                      # 00520225
    dec eax                                      # 00520226
    {load} cmp edi, eax                          # 00520227
    jl.d8 L_0052020b                             # 00520229
L_0052022b:
    # block 0x0052022b: entered by jne at 0x00520220; jmp at 0x0052023f; fall-through of jl at 0x00520229, 2 instruction(s), ends with jle to 0x00520241 (forward)
    test edi, edi                                # 0052022b
    jle.d8 L_00520241                            # 0052022d
    # block 0x0052022f: entered by fall-through of jle at 0x0052022d, 7 instruction(s), calls FUN_0051e8a7, ends with backward jump to 0x0052022b
    mov eax, dword ptr [esi + field_8]           # 0052022f
    lea ecx, [eax + 4*edi]                       # 00520232
    lea eax, [ecx - field_minus_4]               # 00520235
    push eax                                     # 00520238
    call FUN_0051e8a7                            # 00520239
    dec edi                                      # 0052023e
    jmp.d8 L_0052022b                            # 0052023f
L_00520241:
    # block 0x00520241: entered by jle at 0x00520209; jle at 0x0052022d, 8 instruction(s), calls FUN_0051e8f7, ends with ret 0x4
    mov ecx, dword ptr [esi + field_8]           # 00520241
    lea eax, [ebp - local_104]                   # 00520244
    push eax                                     # 0052024a
    call FUN_0051e8f7                            # 0052024b
    pop edi                                      # 00520250
    pop esi                                      # 00520251
    leave                                        # 00520252
    ret 0x4                                      # 00520253

