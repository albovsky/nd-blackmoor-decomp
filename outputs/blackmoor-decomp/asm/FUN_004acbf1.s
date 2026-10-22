# FUN_004acbf1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004acbf1
# extent:       0x004acbf1-0x004accab (186 code bytes)
# span:         0x004acbf1-0x004accab (code 186, tables 0, padding 0)
# sha256:       424cfadad5b710d26291c01e5d8c6483b18a095871b454dc2c27bc5e41e62b98
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4acbf1_clone_record
# naming:       native port src/original_methods_fl39b.c:m4acbf1_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x33a bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0x33a bytes (rep movsd, movsw) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m4acbf1_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004acbf1 - 0x401000
.globl FUN_004acbf1
FUN_004acbf1:
    # block 0x004acbf1: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004acc58 (forward)
    push ebp                                     # 004acbf1
    {load} mov ebp, esp                          # 004acbf2
    sub esp, 0x8                                 # 004acbf4
    push esi                                     # 004acbf7
    push edi                                     # 004acbf8
    mov dword ptr [ebp - local_8], ecx           # 004acbf9
    push 0x33a                                   # 004acbfc
    call FUN_0051dc43                            # 004acc01
    add esp, 0x4                                 # 004acc06
    mov dword ptr [ebp - local_4], eax           # 004acc09
    mov eax, dword ptr [ebp + arg_8]             # 004acc0c
    mov ecx, dword ptr [ebp - local_4]           # 004acc0f
    mov dword ptr [eax], ecx                     # 004acc12
    cmp dword ptr [ebp - local_4], 0x0           # 004acc14
    jne.d8 L_004acc58                            # 004acc18
    # block 0x004acc1a: entered by fall-through of jne at 0x004acc18, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004acc58
    movsx edx, word ptr [0x5c39e3]               # 004acc1a
    push edx                                     # 004acc21
    mov eax, dword ptr [0x5bb57b]                # 004acc22
    push eax                                     # 004acc27
    push 0x551158                                # 004acc28
    push 0x63888b                                # 004acc2d
    call FUN_0050ca3e                            # 004acc32
    add esp, 0x10                                # 004acc37
    push 0x63888b                                # 004acc3a
    push 0x551184                                # 004acc3f
    mov ecx, 0x583979                            # 004acc44
    call FUN_0042639d                            # 004acc49
    mov ecx, 0x5cf659                            # 004acc4e
    call FUN_004c97b4                            # 004acc53
L_004acc58:
    # block 0x004acc58: entered by jne at 0x004acc18, 20 instruction(s), ends with je to 0x004acca3 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004acc58
    mov esi, dword ptr [ecx]                     # 004acc5b
    mov edx, dword ptr [ebp + arg_8]             # 004acc5d
    mov edi, dword ptr [edx]                     # 004acc60
    mov ecx, 0xce                                # 004acc62
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004acc67
    movsw word ptr es:[edi], word ptr [esi]      # 004acc69
    mov eax, dword ptr [ebp + arg_10]            # 004acc6b
    mov ecx, dword ptr [eax]                     # 004acc6e
    add ecx, 0x33a                               # 004acc70
    mov edx, dword ptr [ebp + arg_10]            # 004acc76
    mov dword ptr [edx], ecx                     # 004acc79
    mov eax, dword ptr [ebp + arg_c]             # 004acc7b
    mov ecx, dword ptr [eax]                     # 004acc7e
    add ecx, 0x33a                               # 004acc80
    mov edx, dword ptr [ebp + arg_c]             # 004acc86
    mov dword ptr [edx], ecx                     # 004acc89
    movsx eax, word ptr [0x63a4cd]               # 004acc8b
    test eax, eax                                # 004acc92
    je.d8 L_004acca3                             # 004acc94
    # block 0x004acc96: entered by fall-through of je at 0x004acc94, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004acca3
    push 0x5511a0                                # 004acc96
    call FUN_0044a2b7                            # 004acc9b
    add esp, 0x4                                 # 004acca0
L_004acca3:
    # block 0x004acca3: entered by je at 0x004acc94, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004acca3
    pop esi                                      # 004acca4
    {load} mov esp, ebp                          # 004acca5
    pop ebp                                      # 004acca7
    ret 0xc                                      # 004acca8

