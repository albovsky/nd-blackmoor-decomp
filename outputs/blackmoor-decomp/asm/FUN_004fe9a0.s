# FUN_004fe9a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe9a0
# extent:       0x004fe9a0-0x004fea77 (215 code bytes)
# span:         0x004fe9a0-0x004fea80 (code 215, tables 0, padding 9)
# sha256:       8b082819707956a1fcafd246adccd204eb83e7e6d888de8a8c2b4adcdf11b5f4
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe9a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_4; [edi + n] field_4, field_8, field_c, field_10, field_14, field_1c; [esp + n] stk_10, stk_14
# callees:      calls FUN_0050be60, FUN_004fe700
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 89 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x004fe9a0 - 0x401000
.globl FUN_004fe9a0
FUN_004fe9a0:
    # block 0x004fe9a0: entry, 7 instruction(s), ends with jne to 0x004fe9b7 (forward)
    push ebx                                     # 004fe9a0
    push esi                                     # 004fe9a1
    push edi                                     # 004fe9a2
    mov edi, dword ptr [esp + stk_10]            # 004fe9a3
    mov ebx, dword ptr [edi + field_1c]          # 004fe9a7
    test ebx, ebx                                # 004fe9aa
    jne.d8 L_004fe9b7                            # 004fe9ac
    # block 0x004fe9ae: entered by fall-through of jne at 0x004fe9ac, 5 instruction(s), ends with ret
    pop edi                                      # 004fe9ae
    pop esi                                      # 004fe9af
    mov eax, 0xffffff7f                          # 004fe9b0
    pop ebx                                      # 004fe9b5
    ret                                          # 004fe9b6
L_004fe9b7:
    # block 0x004fe9b7: entered by jne at 0x004fe9ac, 8 instruction(s), calls FUN_0050be60, ends with je to 0x004fe9d5 (forward)
    mov esi, dword ptr [esp + stk_14]            # 004fe9b7
    push 0x20                                    # 004fe9bb
    push esi                                     # 004fe9bd
    call FUN_0050be60                            # 004fe9be
    add esp, 0x8                                 # 004fe9c3
    mov dword ptr [edi], eax                     # 004fe9c6
    test eax, eax                                # 004fe9c8
    je.d8 L_004fe9d5                             # 004fe9ca
    # block 0x004fe9cc: entered by fall-through of je at 0x004fe9ca, 5 instruction(s), ends with ret
    pop edi                                      # 004fe9cc
    pop esi                                      # 004fe9cd
    mov eax, 0xffffff7a                          # 004fe9ce
    pop ebx                                      # 004fe9d3
    ret                                          # 004fe9d4
L_004fe9d5:
    # block 0x004fe9d5: entered by je at 0x004fe9ca, 38 instruction(s), calls FUN_0050be60, ends with jl to 0x004fea5f (forward)
    push 0x8                                     # 004fe9d5
    push esi                                     # 004fe9d7
    call FUN_0050be60                            # 004fe9d8
    push 0x20                                    # 004fe9dd
    push esi                                     # 004fe9df
    mov dword ptr [edi + field_4], eax           # 004fe9e0
    call FUN_0050be60                            # 004fe9e3
    push 0x20                                    # 004fe9e8
    push esi                                     # 004fe9ea
    mov dword ptr [edi + field_8], eax           # 004fe9eb
    call FUN_0050be60                            # 004fe9ee
    push 0x20                                    # 004fe9f3
    push esi                                     # 004fe9f5
    mov dword ptr [edi + field_c], eax           # 004fe9f6
    call FUN_0050be60                            # 004fe9f9
    push 0x20                                    # 004fe9fe
    push esi                                     # 004fea00
    mov dword ptr [edi + field_10], eax          # 004fea01
    call FUN_0050be60                            # 004fea04
    push 0x4                                     # 004fea09
    push esi                                     # 004fea0b
    mov dword ptr [edi + field_14], eax          # 004fea0c
    call FUN_0050be60                            # 004fea0f
    mov edx, 0x1                                 # 004fea14
    {load} mov ecx, eax                          # 004fea19
    shl edx, cl                                  # 004fea1b
    push 0x4                                     # 004fea1d
    push esi                                     # 004fea1f
    mov dword ptr [ebx], edx                     # 004fea20
    call FUN_0050be60                            # 004fea22
    mov edx, 0x1                                 # 004fea27
    {load} mov ecx, eax                          # 004fea2c
    shl edx, cl                                  # 004fea2e
    add esp, 0x38                                # 004fea30
    mov dword ptr [ebx + field_4], edx           # 004fea33
    mov eax, dword ptr [edi + field_8]           # 004fea36
    cmp eax, 0x1                                 # 004fea39
    jl.d8 L_004fea5f                             # 004fea3c
    # block 0x004fea3e: entered by fall-through of jl at 0x004fea3c, 2 instruction(s), ends with jl to 0x004fea5f (forward)
    cmp dword ptr [edi + field_4], 0x1           # 004fea3e
    jl.d8 L_004fea5f                             # 004fea42
    # block 0x004fea44: entered by fall-through of jl at 0x004fea42, 3 instruction(s), ends with jl to 0x004fea5f (forward)
    mov ebx, dword ptr [ebx]                     # 004fea44
    cmp ebx, 0x8                                 # 004fea46
    jl.d8 L_004fea5f                             # 004fea49
    # block 0x004fea4b: entered by fall-through of jl at 0x004fea49, 2 instruction(s), ends with jl to 0x004fea5f (forward)
    {load} cmp edx, ebx                          # 004fea4b
    jl.d8 L_004fea5f                             # 004fea4d
    # block 0x004fea4f: entered by fall-through of jl at 0x004fea4d, 6 instruction(s), calls FUN_0050be60, ends with je to 0x004fea71 (forward)
    push 0x1                                     # 004fea4f
    push esi                                     # 004fea51
    call FUN_0050be60                            # 004fea52
    add esp, 0x8                                 # 004fea57
    cmp eax, 0x1                                 # 004fea5a
    je.d8 L_004fea71                             # 004fea5d
L_004fea5f:
    # block 0x004fea5f: entered by jl at 0x004fea3c; jl at 0x004fea42; jl at 0x004fea49; jl at 0x004fea4d; more, 8 instruction(s), calls FUN_004fe700, ends with ret
    push edi                                     # 004fea5f
    call FUN_004fe700                            # 004fea60
    add esp, 0x4                                 # 004fea65
    mov eax, 0xffffff7b                          # 004fea68
    pop edi                                      # 004fea6d
    pop esi                                      # 004fea6e
    pop ebx                                      # 004fea6f
    ret                                          # 004fea70
L_004fea71:
    # block 0x004fea71: entered by je at 0x004fea5d, 5 instruction(s), ends with ret
    pop edi                                      # 004fea71
    pop esi                                      # 004fea72
    {load} xor eax, eax                          # 004fea73
    pop ebx                                      # 004fea75
    ret                                          # 004fea76

# --- data items (not part of the function) -------------------------
.org 0x004fea77 - 0x401000
PAD_004fea77:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

