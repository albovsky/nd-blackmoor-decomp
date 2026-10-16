# FUN_0051e140
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e140
# extent:       0x0051e140-0x0051e239 (249 code bytes)
# span:         0x0051e140-0x0051e239 (code 249, tables 0, padding 0)
# sha256:       c84b2a1f0b394a5a160f5b8ed050d8f71528100280ca808ffe4e21d2db9f08da
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e140
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [ebp + n] field_minus_4, field_minus_10, field_minus_14, field_minus_18, field_minus_1c, field_minus_20; [esi + n] field_1c, field_24, field_40, field_44, field_48
# callees:      calls FUN_0050f978, FUN_00525371, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, KERNEL32.dll!LockResource, tail jump LOC_0051e291, FUN_0051e0c4, FUN_0051b0e3, USER32.dll!IsWindowEnabled, USER32.dll!EnableWindow, FUN_0051b097, FUN_0051abe4, FUN_0051de51, FUN_0051d526, FUN_0051ce72, FUN_0051d5e1 and 1 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)
.set FUN_0051ce72, .text + (0x0051ce72 - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)
.set FUN_0051de51, .text + (0x0051de51 - 0x401000)
.set FUN_0051e0c4, .text + (0x0051e0c4 - 0x401000)
.set FUN_0051e253, .text + (0x0051e253 - 0x401000)
.set LOC_0051e291, .text + (0x0051e291 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e140 - 0x401000
.globl FUN_0051e140
FUN_0051e140:
    # block 0x0051e140: entry, 16 instruction(s), calls FUN_0050f978, FUN_00525371, ends with je to 0x0051e18d (forward)
    mov eax, 0x528d4c                            # 0051e140
    call FUN_0050f978                            # 0051e145
    sub esp, 0x18                                # 0051e14a
    push ebx                                     # 0051e14d
    push esi                                     # 0051e14e
    {load} mov esi, ecx                          # 0051e14f
    push edi                                     # 0051e151
    mov dword ptr [ebp - field_minus_10], esp    # 0051e152
    mov dword ptr [ebp - field_minus_1c], esi    # 0051e155
    mov eax, dword ptr [esi + field_48]          # 0051e158
    mov edi, dword ptr [esi + field_44]          # 0051e15b
    mov dword ptr [ebp - field_minus_18], eax    # 0051e15e
    call FUN_00525371                            # 0051e161
    cmp dword ptr [esi + field_40], 0x0          # 0051e166
    mov ebx, dword ptr [eax + field_c]           # 0051e16a
    je.d8 L_0051e18d                             # 0051e16d
    # block 0x0051e16f: entered by fall-through of je at 0x0051e16d, 10 instruction(s), calls FUN_00525371, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, falls into the block at 0x0051e18d
    call FUN_00525371                            # 0051e16f
    mov ebx, dword ptr [eax + field_c]           # 0051e174
    push 0x5                                     # 0051e177
    push dword ptr [esi + field_40]              # 0051e179
    push ebx                                     # 0051e17c
    call dword ptr [0x52a218]                    # 0051e17d
    push eax                                     # 0051e183
    push ebx                                     # 0051e184
    call dword ptr [0x52a21c]                    # 0051e185
    {load} mov edi, eax                          # 0051e18b
L_0051e18d:
    # block 0x0051e18d: entered by je at 0x0051e16d, 2 instruction(s), ends with je to 0x0051e19b (forward)
    test edi, edi                                # 0051e18d
    je.d8 L_0051e19b                             # 0051e18f
    # block 0x0051e191: entered by fall-through of je at 0x0051e18f, 3 instruction(s), calls KERNEL32.dll!LockResource, falls into the block at 0x0051e19b
    push edi                                     # 0051e191
    call dword ptr [0x52a220]                    # 0051e192
    mov dword ptr [ebp - field_minus_18], eax    # 0051e198
L_0051e19b:
    # block 0x0051e19b: entered by je at 0x0051e18f, 2 instruction(s), ends with jne to 0x0051e1a9 (forward)
    cmp dword ptr [ebp - field_minus_18], 0x0    # 0051e19b
    jne.d8 L_0051e1a9                            # 0051e19f
    # block 0x0051e1a1: entered by fall-through of jne at 0x0051e19f, 2 instruction(s), ends with forward jump to 0x0051e291
    or eax, -0x1                                 # 0051e1a1
    jmp.d32 LOC_0051e291                         # 0051e1a4
L_0051e1a9:
    # block 0x0051e1a9: entered by jne at 0x0051e19f, 8 instruction(s), calls FUN_0051e0c4, FUN_0051b0e3, ends with je to 0x0051e1e0 (forward)
    {load} mov ecx, esi                          # 0051e1a9
    call FUN_0051e0c4                            # 0051e1ab
    mov dword ptr [ebp - field_minus_14], eax    # 0051e1b0
    call FUN_0051b0e3                            # 0051e1b3
    {load} xor edi, edi                          # 0051e1b8
    cmp dword ptr [ebp - field_minus_14], edi    # 0051e1ba
    mov dword ptr [ebp - field_minus_20], edi    # 0051e1bd
    je.d8 L_0051e1e0                             # 0051e1c0
    # block 0x0051e1c2: entered by fall-through of je at 0x0051e1c0, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x0051e1e0 (forward)
    push dword ptr [ebp - field_minus_14]        # 0051e1c2
    call dword ptr [0x52a330]                    # 0051e1c5
    test eax, eax                                # 0051e1cb
    je.d8 L_0051e1e0                             # 0051e1cd
    # block 0x0051e1cf: entered by fall-through of je at 0x0051e1cd, 4 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x0051e1e0
    push edi                                     # 0051e1cf
    push dword ptr [ebp - field_minus_14]        # 0051e1d0
    call dword ptr [0x52a4d0]                    # 0051e1d3
    mov dword ptr [ebp - field_minus_20], 0x1    # 0051e1d9
L_0051e1e0:
    # block 0x0051e1e0: entered by je at 0x0051e1c0; je at 0x0051e1cd, 12 instruction(s), calls FUN_0051b097, FUN_0051abe4, FUN_0051de51, ends with je to 0x0051e253 (forward)
    push esi                                     # 0051e1e0
    mov dword ptr [ebp - field_minus_4], edi     # 0051e1e1
    call FUN_0051b097                            # 0051e1e4
    push dword ptr [ebp - field_minus_14]        # 0051e1e9
    call FUN_0051abe4                            # 0051e1ec
    push ebx                                     # 0051e1f1
    push eax                                     # 0051e1f2
    push dword ptr [ebp - field_minus_18]        # 0051e1f3
    {load} mov ecx, esi                          # 0051e1f6
    call FUN_0051de51                            # 0051e1f8
    {load} cmp eax, edi                          # 0051e1fd
    je.d8 . + (84)  # -> FUN_0051e253            # 0051e1ff
    # block 0x0051e201: entered by fall-through of je at 0x0051e1ff, 2 instruction(s), ends with je to 0x0051e221 (forward)
    test byte ptr [esi + field_24], 0x10         # 0051e201
    je.d8 L_0051e221                             # 0051e205
    # block 0x0051e207: entered by fall-through of je at 0x0051e205, 6 instruction(s), calls FUN_0051d526, ends with je to 0x0051e219 (forward)
    push 0x4                                     # 0051e207
    {load} mov ecx, esi                          # 0051e209
    pop ebx                                      # 0051e20b
    call FUN_0051d526                            # 0051e20c
    test ah, 0x1                                 # 0051e211
    je.d8 L_0051e219                             # 0051e214
    # block 0x0051e216: entered by fall-through of je at 0x0051e214, 2 instruction(s), falls into the block at 0x0051e219
    push 0x5                                     # 0051e216
    pop ebx                                      # 0051e218
L_0051e219:
    # block 0x0051e219: entered by je at 0x0051e214, 3 instruction(s), calls FUN_0051ce72, falls into the block at 0x0051e221
    push ebx                                     # 0051e219
    {load} mov ecx, esi                          # 0051e21a
    call FUN_0051ce72                            # 0051e21c
L_0051e221:
    # block 0x0051e221: entered by je at 0x0051e205, 2 instruction(s), ends with je to 0x0051e253 (forward)
    cmp dword ptr [esi + field_1c], edi          # 0051e221
    je.d8 . + (47)  # -> FUN_0051e253            # 0051e224
    # block 0x0051e226: entered by fall-through of je at 0x0051e224, 9 instruction(s), calls FUN_0051d5e1, ends with forward jump to 0x0051e253
    push 0x97                                    # 0051e226
    push edi                                     # 0051e22b
    push edi                                     # 0051e22c
    push edi                                     # 0051e22d
    push edi                                     # 0051e22e
    push edi                                     # 0051e22f
    {load} mov ecx, esi                          # 0051e230
    call FUN_0051d5e1                            # 0051e232
    jmp.d8 . + (28)  # -> FUN_0051e253           # 0051e237

