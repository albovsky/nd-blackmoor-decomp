# FUN_005009a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005009a0
# extent:       0x005009a0-0x00500a60 (192 code bytes)
# span:         0x005009a0-0x00500a60 (code 192, tables 0, padding 0)
# sha256:       9e9c0f8c12bc758d0f0b488f3f1606858457fbc93781327809ef0c84dbc709e2
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005009a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_8, field_c, field_10, field_14, field_18; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 73 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x005009a0 - 0x401000
.globl FUN_005009a0
FUN_005009a0:
    # block 0x005009a0: entry, 4 instruction(s), ends with je to 0x00500a5e (forward)
    push edi                                     # 005009a0
    mov edi, dword ptr [esp + stk_8]             # 005009a1
    test edi, edi                                # 005009a5
    je.d32 L_00500a5e                            # 005009a7
    # block 0x005009ad: entered by fall-through of je at 0x005009a7, 3 instruction(s), ends with je to 0x005009bd (forward)
    mov eax, dword ptr [edi + field_10]          # 005009ad
    test eax, eax                                # 005009b0
    je.d8 L_005009bd                             # 005009b2
    # block 0x005009b4: entered by fall-through of je at 0x005009b2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005009bd
    push eax                                     # 005009b4
    call FUN_0050e936                            # 005009b5
    add esp, 0x4                                 # 005009ba
L_005009bd:
    # block 0x005009bd: entered by je at 0x005009b2, 3 instruction(s), ends with je to 0x005009cd (forward)
    mov eax, dword ptr [edi + field_14]          # 005009bd
    test eax, eax                                # 005009c0
    je.d8 L_005009cd                             # 005009c2
    # block 0x005009c4: entered by fall-through of je at 0x005009c2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005009cd
    push eax                                     # 005009c4
    call FUN_0050e936                            # 005009c5
    add esp, 0x4                                 # 005009ca
L_005009cd:
    # block 0x005009cd: entered by je at 0x005009c2, 3 instruction(s), ends with je to 0x005009dd (forward)
    mov eax, dword ptr [edi + field_18]          # 005009cd
    test eax, eax                                # 005009d0
    je.d8 L_005009dd                             # 005009d2
    # block 0x005009d4: entered by fall-through of je at 0x005009d2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005009dd
    push eax                                     # 005009d4
    call FUN_0050e936                            # 005009d5
    add esp, 0x4                                 # 005009da
L_005009dd:
    # block 0x005009dd: entered by je at 0x005009d2, 4 instruction(s), ends with je to 0x00500a28 (forward)
    mov eax, dword ptr [edi + field_8]           # 005009dd
    push esi                                     # 005009e0
    test eax, eax                                # 005009e1
    je.d8 L_00500a28                             # 005009e3
    # block 0x005009e5: entered by fall-through of je at 0x005009e3, 2 instruction(s), falls into the block at 0x005009e8
    push ebx                                     # 005009e5
    {load} xor ebx, ebx                          # 005009e6
L_005009e8:
    # block 0x005009e8: entered by jl at 0x00500a19, 1 instruction(s), falls into the block at 0x005009ea
    {load} xor esi, esi                          # 005009e8
L_005009ea:
    # block 0x005009ea: entered by jl at 0x00500a02, 9 instruction(s), calls FUN_0050e936, ends with jl to 0x005009ea (backward)
    mov eax, dword ptr [edi + field_8]           # 005009ea
    mov ecx, dword ptr [eax + ebx]               # 005009ed
    mov edx, dword ptr [ecx + esi]               # 005009f0
    push edx                                     # 005009f3
    call FUN_0050e936                            # 005009f4
    add esi, 0x4                                 # 005009f9
    add esp, 0x4                                 # 005009fc
    cmp esi, 0x20                                # 005009ff
    jl.d8 L_005009ea                             # 00500a02
    # block 0x00500a04: entered by fall-through of jl at 0x00500a02, 8 instruction(s), calls FUN_0050e936, ends with jl to 0x005009e8 (backward)
    mov eax, dword ptr [edi + field_8]           # 00500a04
    mov ecx, dword ptr [eax + ebx]               # 00500a07
    push ecx                                     # 00500a0a
    call FUN_0050e936                            # 00500a0b
    add ebx, 0x4                                 # 00500a10
    add esp, 0x4                                 # 00500a13
    cmp ebx, 0x44                                # 00500a16
    jl.d8 L_005009e8                             # 00500a19
    # block 0x00500a1b: entered by fall-through of jl at 0x00500a19, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x00500a28
    mov edx, dword ptr [edi + field_8]           # 00500a1b
    push edx                                     # 00500a1e
    call FUN_0050e936                            # 00500a1f
    add esp, 0x4                                 # 00500a24
    pop ebx                                      # 00500a27
L_00500a28:
    # block 0x00500a28: entered by je at 0x005009e3, 3 instruction(s), ends with je to 0x00500a54 (forward)
    mov eax, dword ptr [edi + field_c]           # 00500a28
    test eax, eax                                # 00500a2b
    je.d8 L_00500a54                             # 00500a2d
    # block 0x00500a2f: entered by fall-through of je at 0x00500a2d, 1 instruction(s), falls into the block at 0x00500a31
    {load} xor esi, esi                          # 00500a2f
L_00500a31:
    # block 0x00500a31: entered by jl at 0x00500a46, 8 instruction(s), calls FUN_0050e936, ends with jl to 0x00500a31 (backward)
    mov eax, dword ptr [edi + field_c]           # 00500a31
    mov ecx, dword ptr [eax + esi]               # 00500a34
    push ecx                                     # 00500a37
    call FUN_0050e936                            # 00500a38
    add esi, 0x4                                 # 00500a3d
    add esp, 0x4                                 # 00500a40
    cmp esi, 0xc                                 # 00500a43
    jl.d8 L_00500a31                             # 00500a46
    # block 0x00500a48: entered by fall-through of jl at 0x00500a46, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x00500a54
    mov edx, dword ptr [edi + field_c]           # 00500a48
    push edx                                     # 00500a4b
    call FUN_0050e936                            # 00500a4c
    add esp, 0x4                                 # 00500a51
L_00500a54:
    # block 0x00500a54: entered by je at 0x00500a2d, 4 instruction(s), falls into the block at 0x00500a5e
    mov ecx, 0xc                                 # 00500a54
    {load} xor eax, eax                          # 00500a59
    rep stosd dword ptr es:[edi], eax            # 00500a5b
    pop esi                                      # 00500a5d
L_00500a5e:
    # block 0x00500a5e: entered by je at 0x005009a7, 2 instruction(s), ends with ret
    pop edi                                      # 00500a5e
    ret                                          # 00500a5f

