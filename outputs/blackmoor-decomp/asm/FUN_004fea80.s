# FUN_004fea80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fea80
# extent:       0x004fea80-0x004feb58 (216 code bytes)
# span:         0x004fea80-0x004feb60 (code 216, tables 0, padding 8)
# sha256:       178ef4db5d21a379b8b8ed0c4ea831dc6c5fe496f2563927cfa02f1354b1f039
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fea80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_1; [edi + n] field_1; [esi + n] field_4, field_8, field_c; [esp + n] stk_10, stk_1c
# callees:      calls FUN_0050be60, FUN_0050e97e, FUN_004fe970, FUN_004fe660
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 92 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004fe660, .text + (0x004fe660 - 0x401000)
.set FUN_004fe970, .text + (0x004fe970 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x004fea80 - 0x401000
.globl FUN_004fea80
FUN_004fea80:
    # block 0x004fea80: entry, 13 instruction(s), calls FUN_0050be60, ends with jl to 0x004feb3e (forward)
    push ebx                                     # 004fea80
    push ebp                                     # 004fea81
    mov ebp, dword ptr [esp + stk_10]            # 004fea82
    push esi                                     # 004fea86
    push edi                                     # 004fea87
    push 0x20                                    # 004fea88
    push ebp                                     # 004fea8a
    call FUN_0050be60                            # 004fea8b
    mov esi, dword ptr [esp + stk_1c]            # 004fea90
    {load} mov edi, eax                          # 004fea94
    add esp, 0x8                                 # 004fea96
    test edi, edi                                # 004fea99
    jl.d32 L_004feb3e                            # 004fea9b
    # block 0x004feaa1: entered by fall-through of jl at 0x004fea9b, 16 instruction(s), calls FUN_0050e97e, FUN_004fe970, FUN_0050be60, ends with jl to 0x004feb3e (forward)
    lea eax, [edi + field_1]                     # 004feaa1
    push 0x1                                     # 004feaa4
    push eax                                     # 004feaa6
    call FUN_0050e97e                            # 004feaa7
    push edi                                     # 004feaac
    push eax                                     # 004feaad
    push ebp                                     # 004feaae
    mov dword ptr [esi + field_c], eax           # 004feaaf
    call FUN_004fe970                            # 004feab2
    push 0x20                                    # 004feab7
    push ebp                                     # 004feab9
    call FUN_0050be60                            # 004feaba
    add esp, 0x1c                                # 004feabf
    mov dword ptr [esi + field_8], eax           # 004feac2
    test eax, eax                                # 004feac5
    jl.d8 L_004feb3e                             # 004feac7
    # block 0x004feac9: entered by fall-through of jl at 0x004feac7, 16 instruction(s), calls FUN_0050e97e, ends with jle to 0x004feb2e (forward)
    inc eax                                      # 004feac9
    push 0x4                                     # 004feaca
    push eax                                     # 004feacc
    call FUN_0050e97e                            # 004feacd
    mov ecx, dword ptr [esi + field_8]           # 004fead2
    push 0x4                                     # 004fead5
    inc ecx                                      # 004fead7
    mov dword ptr [esi], eax                     # 004fead8
    push ecx                                     # 004feada
    call FUN_0050e97e                            # 004feadb
    mov dword ptr [esi + field_4], eax           # 004feae0
    mov eax, dword ptr [esi + field_8]           # 004feae3
    add esp, 0x10                                # 004feae6
    {load} xor edi, edi                          # 004feae9
    test eax, eax                                # 004feaeb
    jle.d8 L_004feb2e                            # 004feaed
L_004feaef:
    # block 0x004feaef: entered by jl at 0x004feb2c; fall-through of jle at 0x004feaed, 7 instruction(s), calls FUN_0050be60, ends with jl to 0x004feb3e (forward)
    push 0x20                                    # 004feaef
    push ebp                                     # 004feaf1
    call FUN_0050be60                            # 004feaf2
    {load} mov ebx, eax                          # 004feaf7
    add esp, 0x8                                 # 004feaf9
    test ebx, ebx                                # 004feafc
    jl.d8 L_004feb3e                             # 004feafe
    # block 0x004feb00: entered by fall-through of jl at 0x004feafe, 19 instruction(s), calls FUN_0050e97e, FUN_004fe970, ends with jl to 0x004feaef (backward)
    mov edx, dword ptr [esi + field_4]           # 004feb00
    lea eax, [ebx + field_1]                     # 004feb03
    push 0x1                                     # 004feb06
    push eax                                     # 004feb08
    mov dword ptr [edx + 4*edi], ebx             # 004feb09
    call FUN_0050e97e                            # 004feb0c
    mov ecx, dword ptr [esi]                     # 004feb11
    push ebx                                     # 004feb13
    mov dword ptr [ecx + 4*edi], eax             # 004feb14
    mov edx, dword ptr [esi]                     # 004feb17
    mov eax, dword ptr [edx + 4*edi]             # 004feb19
    push eax                                     # 004feb1c
    push ebp                                     # 004feb1d
    call FUN_004fe970                            # 004feb1e
    mov eax, dword ptr [esi + field_8]           # 004feb23
    add esp, 0x14                                # 004feb26
    inc edi                                      # 004feb29
    {load} cmp edi, eax                          # 004feb2a
    jl.d8 L_004feaef                             # 004feb2c
L_004feb2e:
    # block 0x004feb2e: entered by jle at 0x004feaed; fall-through of jl at 0x004feb2c, 6 instruction(s), calls FUN_0050be60, ends with je to 0x004feb51 (forward)
    push 0x1                                     # 004feb2e
    push ebp                                     # 004feb30
    call FUN_0050be60                            # 004feb31
    add esp, 0x8                                 # 004feb36
    cmp eax, 0x1                                 # 004feb39
    je.d8 L_004feb51                             # 004feb3c
L_004feb3e:
    # block 0x004feb3e: entered by jl at 0x004fea9b; jl at 0x004feac7; jl at 0x004feafe; fall-through of je at 0x004feb3c, 9 instruction(s), calls FUN_004fe660, ends with ret
    push esi                                     # 004feb3e
    call FUN_004fe660                            # 004feb3f
    add esp, 0x4                                 # 004feb44
    mov eax, 0xffffff7b                          # 004feb47
    pop edi                                      # 004feb4c
    pop esi                                      # 004feb4d
    pop ebp                                      # 004feb4e
    pop ebx                                      # 004feb4f
    ret                                          # 004feb50
L_004feb51:
    # block 0x004feb51: entered by je at 0x004feb3c, 6 instruction(s), ends with ret
    pop edi                                      # 004feb51
    pop esi                                      # 004feb52
    pop ebp                                      # 004feb53
    {load} xor eax, eax                          # 004feb54
    pop ebx                                      # 004feb56
    ret                                          # 004feb57

# --- data items (not part of the function) -------------------------
.org 0x004feb58 - 0x401000
PAD_004feb58:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

