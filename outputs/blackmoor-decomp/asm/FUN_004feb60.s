# FUN_004feb60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004feb60
# extent:       0x004feb60-0x004fedd7 (631 code bytes)
# span:         0x004feb60-0x004fede0 (code 631, tables 0, padding 9)
# sha256:       ae973bba903988d590b0968c5b57369a1df741848fca4c1974aa0293d4cc3a0a
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004feb60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_1c; [ebx + n] field_8, field_c, field_10, field_14, field_18, field_20, field_220, field_420, field_620, field_720; [ecx + n] field_4, field_8; [edi + n] field_minus_100; [edx + n] field_4, field_c; [esp + n] stk_4, stk_14, stk_18
# callees:      calls FUN_0050be60, FUN_0050e97e, FUN_00502e20, FUN_004fe700; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 233 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_100, 0x100  # offset -0x100
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_220, 0x220  # offset +0x220
.equ field_420, 0x420  # offset +0x420
.equ field_620, 0x620  # offset +0x620
.equ field_720, 0x720  # offset +0x720

# --- external targets -----------------------------------------------
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_00502e20, .text + (0x00502e20 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x004feb60 - 0x401000
.globl FUN_004feb60
FUN_004feb60:
    # block 0x004feb60: entry, 8 instruction(s), ends with jne to 0x004feb79 (forward)
    mov eax, dword ptr [esp + stk_4]             # 004feb60
    push ebx                                     # 004feb64
    push ebp                                     # 004feb65
    push esi                                     # 004feb66
    mov ebx, dword ptr [eax + field_1c]          # 004feb67
    push edi                                     # 004feb6a
    test ebx, ebx                                # 004feb6b
    jne.d8 L_004feb79                            # 004feb6d
    # block 0x004feb6f: entered by fall-through of jne at 0x004feb6d, 6 instruction(s), ends with ret
    pop edi                                      # 004feb6f
    pop esi                                      # 004feb70
    pop ebp                                      # 004feb71
    mov eax, 0xffffff7f                          # 004feb72
    pop ebx                                      # 004feb77
    ret                                          # 004feb78
L_004feb79:
    # block 0x004feb79: entered by jne at 0x004feb6d, 10 instruction(s), calls FUN_0050be60, ends with jle to 0x004febc0 (forward)
    mov esi, dword ptr [esp + stk_18]            # 004feb79
    push 0x8                                     # 004feb7d
    push esi                                     # 004feb7f
    call FUN_0050be60                            # 004feb80
    add esp, 0x8                                 # 004feb85
    inc eax                                      # 004feb88
    {load} xor ebp, ebp                          # 004feb89
    mov dword ptr [ebx + field_18], eax          # 004feb8b
    test eax, eax                                # 004feb8e
    jle.d8 L_004febc0                            # 004feb90
    # block 0x004feb92: entered by fall-through of jle at 0x004feb90, 1 instruction(s), falls into the block at 0x004feb98
    lea edi, [ebx + field_720]                   # 004feb92
L_004feb98:
    # block 0x004feb98: entered by jl at 0x004febbe, 10 instruction(s), calls FUN_0050e97e, FUN_00502e20, ends with jne to 0x004fedb9 (forward)
    push 0x34                                    # 004feb98
    push 0x1                                     # 004feb9a
    call FUN_0050e97e                            # 004feb9c
    push eax                                     # 004feba1
    push esi                                     # 004feba2
    mov dword ptr [edi], eax                     # 004feba3
    call FUN_00502e20                            # 004feba5
    add esp, 0x10                                # 004febaa
    test eax, eax                                # 004febad
    jne.d32 L_004fedb9                           # 004febaf
    # block 0x004febb5: entered by fall-through of jne at 0x004febaf, 5 instruction(s), ends with jl to 0x004feb98 (backward)
    mov eax, dword ptr [ebx + field_18]          # 004febb5
    inc ebp                                      # 004febb8
    add edi, 0x4                                 # 004febb9
    {load} cmp ebp, eax                          # 004febbc
    jl.d8 L_004feb98                             # 004febbe
L_004febc0:
    # block 0x004febc0: entered by jle at 0x004feb90; fall-through of jl at 0x004febbe, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x004febf5 (forward)
    push 0x6                                     # 004febc0
    push esi                                     # 004febc2
    call FUN_0050be60                            # 004febc3
    {load} mov edi, eax                          # 004febc8
    add esp, 0x8                                 # 004febca
    inc edi                                      # 004febcd
    {load} xor ebp, ebp                          # 004febce
    test edi, edi                                # 004febd0
    jle.d8 L_004febf5                            # 004febd2
L_004febd4:
    # block 0x004febd4: entered by jl at 0x004febf3; fall-through of jle at 0x004febd2, 6 instruction(s), calls FUN_0050be60, ends with jl to 0x004fedb9 (forward)
    push 0x10                                    # 004febd4
    push esi                                     # 004febd6
    call FUN_0050be60                            # 004febd7
    add esp, 0x8                                 # 004febdc
    test eax, eax                                # 004febdf
    jl.d32 L_004fedb9                            # 004febe1
    # block 0x004febe7: entered by fall-through of jl at 0x004febe1, 2 instruction(s), ends with jge to 0x004fedb9 (forward)
    cmp eax, 0x1                                 # 004febe7
    jge.d32 L_004fedb9                           # 004febea
    # block 0x004febf0: entered by fall-through of jge at 0x004febea, 3 instruction(s), ends with jl to 0x004febd4 (backward)
    inc ebp                                      # 004febf0
    {load} cmp ebp, edi                          # 004febf1
    jl.d8 L_004febd4                             # 004febf3
L_004febf5:
    # block 0x004febf5: entered by jle at 0x004febd2; fall-through of jl at 0x004febf3, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x004fec5a (forward)
    push 0x6                                     # 004febf5
    push esi                                     # 004febf7
    call FUN_0050be60                            # 004febf8
    add esp, 0x8                                 # 004febfd
    inc eax                                      # 004fec00
    {load} xor ebp, ebp                          # 004fec01
    mov dword ptr [ebx + field_10], eax          # 004fec03
    test eax, eax                                # 004fec06
    jle.d8 L_004fec5a                            # 004fec08
    # block 0x004fec0a: entered by fall-through of jle at 0x004fec08, 1 instruction(s), falls into the block at 0x004fec10
    lea edi, [ebx + field_420]                   # 004fec0a
L_004fec10:
    # block 0x004fec10: entered by jl at 0x004fec58, 7 instruction(s), calls FUN_0050be60, ends with jl to 0x004fedb9 (forward)
    push 0x10                                    # 004fec10
    push esi                                     # 004fec12
    call FUN_0050be60                            # 004fec13
    add esp, 0x8                                 # 004fec18
    mov dword ptr [edi - field_minus_100], eax   # 004fec1b
    test eax, eax                                # 004fec21
    jl.d32 L_004fedb9                            # 004fec23
    # block 0x004fec29: entered by fall-through of jl at 0x004fec23, 2 instruction(s), ends with jge to 0x004fedb9 (forward)
    cmp eax, 0x2                                 # 004fec29
    jge.d32 L_004fedb9                           # 004fec2c
    # block 0x004fec32: entered by fall-through of jge at 0x004fec2c, 9 instruction(s), calls indirect dword ptr [ecx + 0x4], ends with je to 0x004fedb9 (forward)
    mov edx, dword ptr [esp + stk_14]            # 004fec32
    mov ecx, dword ptr [4*eax + 0x5669e0]        # 004fec36
    push esi                                     # 004fec3d
    push edx                                     # 004fec3e
    call dword ptr [ecx + field_4]               # 004fec3f
    add esp, 0x8                                 # 004fec42
    mov dword ptr [edi], eax                     # 004fec45
    test eax, eax                                # 004fec47
    je.d32 L_004fedb9                            # 004fec49
    # block 0x004fec4f: entered by fall-through of je at 0x004fec49, 5 instruction(s), ends with jl to 0x004fec10 (backward)
    mov eax, dword ptr [ebx + field_10]          # 004fec4f
    inc ebp                                      # 004fec52
    add edi, 0x4                                 # 004fec53
    {load} cmp ebp, eax                          # 004fec56
    jl.d8 L_004fec10                             # 004fec58
L_004fec5a:
    # block 0x004fec5a: entered by jle at 0x004fec08; fall-through of jl at 0x004fec58, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x004fecbf (forward)
    push 0x6                                     # 004fec5a
    push esi                                     # 004fec5c
    call FUN_0050be60                            # 004fec5d
    add esp, 0x8                                 # 004fec62
    inc eax                                      # 004fec65
    {load} xor ebp, ebp                          # 004fec66
    mov dword ptr [ebx + field_14], eax          # 004fec68
    test eax, eax                                # 004fec6b
    jle.d8 L_004fecbf                            # 004fec6d
    # block 0x004fec6f: entered by fall-through of jle at 0x004fec6d, 1 instruction(s), falls into the block at 0x004fec75
    lea edi, [ebx + field_620]                   # 004fec6f
L_004fec75:
    # block 0x004fec75: entered by jl at 0x004fecbd, 7 instruction(s), calls FUN_0050be60, ends with jl to 0x004fedb9 (forward)
    push 0x10                                    # 004fec75
    push esi                                     # 004fec77
    call FUN_0050be60                            # 004fec78
    add esp, 0x8                                 # 004fec7d
    mov dword ptr [edi - field_minus_100], eax   # 004fec80
    test eax, eax                                # 004fec86
    jl.d32 L_004fedb9                            # 004fec88
    # block 0x004fec8e: entered by fall-through of jl at 0x004fec88, 2 instruction(s), ends with jge to 0x004fedb9 (forward)
    cmp eax, 0x3                                 # 004fec8e
    jge.d32 L_004fedb9                           # 004fec91
    # block 0x004fec97: entered by fall-through of jge at 0x004fec91, 9 instruction(s), calls indirect dword ptr [eax + 0x4], ends with je to 0x004fedb9 (forward)
    mov ecx, dword ptr [esp + stk_14]            # 004fec97
    mov eax, dword ptr [4*eax + 0x5669e8]        # 004fec9b
    push esi                                     # 004feca2
    push ecx                                     # 004feca3
    call dword ptr [eax + field_4]               # 004feca4
    add esp, 0x8                                 # 004feca7
    mov dword ptr [edi], eax                     # 004fecaa
    test eax, eax                                # 004fecac
    je.d32 L_004fedb9                            # 004fecae
    # block 0x004fecb4: entered by fall-through of je at 0x004fecae, 5 instruction(s), ends with jl to 0x004fec75 (backward)
    mov eax, dword ptr [ebx + field_14]          # 004fecb4
    inc ebp                                      # 004fecb7
    add edi, 0x4                                 # 004fecb8
    {load} cmp ebp, eax                          # 004fecbb
    jl.d8 L_004fec75                             # 004fecbd
L_004fecbf:
    # block 0x004fecbf: entered by jle at 0x004fec6d; fall-through of jl at 0x004fecbd, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x004fed24 (forward)
    push 0x6                                     # 004fecbf
    push esi                                     # 004fecc1
    call FUN_0050be60                            # 004fecc2
    add esp, 0x8                                 # 004fecc7
    inc eax                                      # 004fecca
    {load} xor ebp, ebp                          # 004feccb
    mov dword ptr [ebx + field_c], eax           # 004feccd
    test eax, eax                                # 004fecd0
    jle.d8 L_004fed24                            # 004fecd2
    # block 0x004fecd4: entered by fall-through of jle at 0x004fecd2, 1 instruction(s), falls into the block at 0x004fecda
    lea edi, [ebx + field_220]                   # 004fecd4
L_004fecda:
    # block 0x004fecda: entered by jl at 0x004fed22, 7 instruction(s), calls FUN_0050be60, ends with jl to 0x004fedb9 (forward)
    push 0x10                                    # 004fecda
    push esi                                     # 004fecdc
    call FUN_0050be60                            # 004fecdd
    add esp, 0x8                                 # 004fece2
    mov dword ptr [edi - field_minus_100], eax   # 004fece5
    test eax, eax                                # 004feceb
    jl.d32 L_004fedb9                            # 004feced
    # block 0x004fecf3: entered by fall-through of jl at 0x004feced, 2 instruction(s), ends with jge to 0x004fedb9 (forward)
    cmp eax, 0x1                                 # 004fecf3
    jge.d32 L_004fedb9                           # 004fecf6
    # block 0x004fecfc: entered by fall-through of jge at 0x004fecf6, 9 instruction(s), calls indirect dword ptr [edx + 0x4], ends with je to 0x004fedb9 (forward)
    mov edx, dword ptr [4*eax + 0x5669f4]        # 004fecfc
    mov eax, dword ptr [esp + stk_14]            # 004fed03
    push esi                                     # 004fed07
    push eax                                     # 004fed08
    call dword ptr [edx + field_4]               # 004fed09
    add esp, 0x8                                 # 004fed0c
    mov dword ptr [edi], eax                     # 004fed0f
    test eax, eax                                # 004fed11
    je.d32 L_004fedb9                            # 004fed13
    # block 0x004fed19: entered by fall-through of je at 0x004fed13, 5 instruction(s), ends with jl to 0x004fecda (backward)
    mov eax, dword ptr [ebx + field_c]           # 004fed19
    inc ebp                                      # 004fed1c
    add edi, 0x4                                 # 004fed1d
    {load} cmp ebp, eax                          # 004fed20
    jl.d8 L_004fecda                             # 004fed22
L_004fed24:
    # block 0x004fed24: entered by jle at 0x004fecd2; fall-through of jl at 0x004fed22, 9 instruction(s), calls FUN_0050be60, ends with jle to 0x004feda5 (forward)
    push 0x6                                     # 004fed24
    push esi                                     # 004fed26
    call FUN_0050be60                            # 004fed27
    add esp, 0x8                                 # 004fed2c
    inc eax                                      # 004fed2f
    {load} xor ebp, ebp                          # 004fed30
    mov dword ptr [ebx + field_8], eax           # 004fed32
    test eax, eax                                # 004fed35
    jle.d8 L_004feda5                            # 004fed37
    # block 0x004fed39: entered by fall-through of jle at 0x004fed37, 1 instruction(s), falls into the block at 0x004fed3c
    lea edi, [ebx + field_20]                    # 004fed39
L_004fed3c:
    # block 0x004fed3c: entered by jl at 0x004feda1, 29 instruction(s), calls FUN_0050e97e, FUN_0050be60, ends with jge to 0x004fedb9 (forward)
    push 0x10                                    # 004fed3c
    push 0x1                                     # 004fed3e
    call FUN_0050e97e                            # 004fed40
    push 0x1                                     # 004fed45
    push esi                                     # 004fed47
    mov dword ptr [edi], eax                     # 004fed48
    call FUN_0050be60                            # 004fed4a
    mov ecx, dword ptr [edi]                     # 004fed4f
    push 0x10                                    # 004fed51
    push esi                                     # 004fed53
    mov dword ptr [ecx], eax                     # 004fed54
    call FUN_0050be60                            # 004fed56
    mov edx, dword ptr [edi]                     # 004fed5b
    push 0x10                                    # 004fed5d
    push esi                                     # 004fed5f
    mov dword ptr [edx + field_4], eax           # 004fed60
    call FUN_0050be60                            # 004fed63
    mov ecx, dword ptr [edi]                     # 004fed68
    push 0x8                                     # 004fed6a
    push esi                                     # 004fed6c
    mov dword ptr [ecx + field_8], eax           # 004fed6d
    call FUN_0050be60                            # 004fed70
    mov edx, dword ptr [edi]                     # 004fed75
    mov ecx, 0x1                                 # 004fed77
    add esp, 0x28                                # 004fed7c
    mov dword ptr [edx + field_c], eax           # 004fed7f
    mov eax, dword ptr [edi]                     # 004fed82
    cmp dword ptr [eax + field_4], ecx           # 004fed84
    jge.d8 L_004fedb9                            # 004fed87
    # block 0x004fed89: entered by fall-through of jge at 0x004fed87, 2 instruction(s), ends with jge to 0x004fedb9 (forward)
    cmp dword ptr [eax + field_8], ecx           # 004fed89
    jge.d8 L_004fedb9                            # 004fed8c
    # block 0x004fed8e: entered by fall-through of jge at 0x004fed8c, 4 instruction(s), ends with jge to 0x004fedb9 (forward)
    mov eax, dword ptr [eax + field_c]           # 004fed8e
    mov edx, dword ptr [ebx + field_c]           # 004fed91
    {load} cmp eax, edx                          # 004fed94
    jge.d8 L_004fedb9                            # 004fed96
    # block 0x004fed98: entered by fall-through of jge at 0x004fed96, 5 instruction(s), ends with jl to 0x004fed3c (backward)
    mov eax, dword ptr [ebx + field_8]           # 004fed98
    inc ebp                                      # 004fed9b
    add edi, 0x4                                 # 004fed9c
    {load} cmp ebp, eax                          # 004fed9f
    jl.d8 L_004fed3c                             # 004feda1
    # block 0x004feda3: entered by fall-through of jl at 0x004feda1, 1 instruction(s), ends with forward jump to 0x004fedaa
    jmp.d8 L_004fedaa                            # 004feda3
L_004feda5:
    # block 0x004feda5: entered by jle at 0x004fed37, 1 instruction(s), falls into the block at 0x004fedaa
    mov ecx, 0x1                                 # 004feda5
L_004fedaa:
    # block 0x004fedaa: entered by jmp at 0x004feda3, 6 instruction(s), calls FUN_0050be60, ends with je to 0x004fedd0 (forward)
    push ecx                                     # 004fedaa
    push esi                                     # 004fedab
    call FUN_0050be60                            # 004fedac
    add esp, 0x8                                 # 004fedb1
    cmp eax, 0x1                                 # 004fedb4
    je.d8 L_004fedd0                             # 004fedb7
L_004fedb9:
    # block 0x004fedb9: entered by jne at 0x004febaf; jl at 0x004febe1; jge at 0x004febea; jl at 0x004fec23; more, 10 instruction(s), calls FUN_004fe700, ends with ret
    mov ecx, dword ptr [esp + stk_14]            # 004fedb9
    push ecx                                     # 004fedbd
    call FUN_004fe700                            # 004fedbe
    add esp, 0x4                                 # 004fedc3
    mov eax, 0xffffff7b                          # 004fedc6
    pop edi                                      # 004fedcb
    pop esi                                      # 004fedcc
    pop ebp                                      # 004fedcd
    pop ebx                                      # 004fedce
    ret                                          # 004fedcf
L_004fedd0:
    # block 0x004fedd0: entered by je at 0x004fedb7, 6 instruction(s), ends with ret
    pop edi                                      # 004fedd0
    pop esi                                      # 004fedd1
    pop ebp                                      # 004fedd2
    {load} xor eax, eax                          # 004fedd3
    pop ebx                                      # 004fedd5
    ret                                          # 004fedd6

# --- data items (not part of the function) -------------------------
.org 0x004fedd7 - 0x401000
PAD_004fedd7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

