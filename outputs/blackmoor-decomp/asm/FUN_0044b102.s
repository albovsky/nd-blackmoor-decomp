# FUN_0044b102
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b102
# extent:       0x0044b102-0x0044b1b4 (178 code bytes)
# span:         0x0044b102-0x0044b1b4 (code 178, tables 0, padding 0)
# sha256:       8f284db00b7529f3a9ad8dbd661c76bb6333fbe1aa86501ca59eb3cf3f797a7a
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44b102_lifted
# naming:       native port src/original_methods_fl40.c:m44b102_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 7 seeds; oracle 58/58 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44b102_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x0044b102 - 0x401000
.globl FUN_0044b102
FUN_0044b102:
    # block 0x0044b102: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044b166 (forward)
    push ebp                                     # 0044b102
    {load} mov ebp, esp                          # 0044b103
    sub esp, 0x8                                 # 0044b105
    push esi                                     # 0044b108
    push edi                                     # 0044b109
    mov dword ptr [ebp - local_8], ecx           # 0044b10a
    push 0x1f                                    # 0044b10d
    call FUN_0051dc43                            # 0044b10f
    add esp, 0x4                                 # 0044b114
    mov dword ptr [ebp - local_4], eax           # 0044b117
    mov eax, dword ptr [ebp + arg_8]             # 0044b11a
    mov ecx, dword ptr [ebp - local_4]           # 0044b11d
    mov dword ptr [eax], ecx                     # 0044b120
    cmp dword ptr [ebp - local_4], 0x0           # 0044b122
    jne.d8 L_0044b166                            # 0044b126
    # block 0x0044b128: entered by fall-through of jne at 0x0044b126, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044b166
    movsx edx, word ptr [0x5c39e3]               # 0044b128
    push edx                                     # 0044b12f
    mov eax, dword ptr [0x5bb57b]                # 0044b130
    push eax                                     # 0044b135
    push 0x548f34                                # 0044b136
    push 0x63888b                                # 0044b13b
    call FUN_0050ca3e                            # 0044b140
    add esp, 0x10                                # 0044b145
    push 0x63888b                                # 0044b148
    push 0x548f60                                # 0044b14d
    mov ecx, 0x583979                            # 0044b152
    call FUN_0042639d                            # 0044b157
    mov ecx, 0x5cf659                            # 0044b15c
    call FUN_004c97b4                            # 0044b161
L_0044b166:
    # block 0x0044b166: entered by jne at 0x0044b126, 21 instruction(s), ends with je to 0x0044b1ac (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044b166
    mov esi, dword ptr [ecx]                     # 0044b169
    mov edx, dword ptr [ebp + arg_8]             # 0044b16b
    mov edi, dword ptr [edx]                     # 0044b16e
    mov ecx, 0x7                                 # 0044b170
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044b175
    movsw word ptr es:[edi], word ptr [esi]      # 0044b177
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044b179
    mov eax, dword ptr [ebp + arg_10]            # 0044b17a
    mov ecx, dword ptr [eax]                     # 0044b17d
    add ecx, 0x1f                                # 0044b17f
    mov edx, dword ptr [ebp + arg_10]            # 0044b182
    mov dword ptr [edx], ecx                     # 0044b185
    mov eax, dword ptr [ebp + arg_c]             # 0044b187
    mov ecx, dword ptr [eax]                     # 0044b18a
    add ecx, 0x1f                                # 0044b18c
    mov edx, dword ptr [ebp + arg_c]             # 0044b18f
    mov dword ptr [edx], ecx                     # 0044b192
    movsx eax, word ptr [0x63a4cd]               # 0044b194
    test eax, eax                                # 0044b19b
    je.d8 L_0044b1ac                             # 0044b19d
    # block 0x0044b19f: entered by fall-through of je at 0x0044b19d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044b1ac
    push 0x548f7c                                # 0044b19f
    call FUN_0044a2b7                            # 0044b1a4
    add esp, 0x4                                 # 0044b1a9
L_0044b1ac:
    # block 0x0044b1ac: entered by je at 0x0044b19d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044b1ac
    pop esi                                      # 0044b1ad
    {load} mov esp, ebp                          # 0044b1ae
    pop ebp                                      # 0044b1b0
    ret 0xc                                      # 0044b1b1

