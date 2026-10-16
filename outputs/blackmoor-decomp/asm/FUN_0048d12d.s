# FUN_0048d12d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d12d
# extent:       0x0048d12d-0x0048d1e8 (187 code bytes)
# span:         0x0048d12d-0x0048d1e8 (code 187, tables 0, padding 0)
# sha256:       6de6c0335c559c0e4536c6eb1ceb6f1d3590e2e2e872e2cffafd20d0291862c2
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048d12d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0048d12d - 0x401000
.globl FUN_0048d12d
FUN_0048d12d:
    # block 0x0048d12d: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0048d194 (forward)
    push ebp                                     # 0048d12d
    {load} mov ebp, esp                          # 0048d12e
    sub esp, 0x8                                 # 0048d130
    push esi                                     # 0048d133
    push edi                                     # 0048d134
    mov dword ptr [ebp - local_8], ecx           # 0048d135
    push 0x7bb                                   # 0048d138
    call FUN_0051dc43                            # 0048d13d
    add esp, 0x4                                 # 0048d142
    mov dword ptr [ebp - local_4], eax           # 0048d145
    mov eax, dword ptr [ebp + arg_8]             # 0048d148
    mov ecx, dword ptr [ebp - local_4]           # 0048d14b
    mov dword ptr [eax], ecx                     # 0048d14e
    cmp dword ptr [ebp - local_4], 0x0           # 0048d150
    jne.d8 L_0048d194                            # 0048d154
    # block 0x0048d156: entered by fall-through of jne at 0x0048d154, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0048d194
    movsx edx, word ptr [0x5c39e3]               # 0048d156
    push edx                                     # 0048d15d
    mov eax, dword ptr [0x5bb57b]                # 0048d15e
    push eax                                     # 0048d163
    push 0x54e814                                # 0048d164
    push 0x63888b                                # 0048d169
    call FUN_0050ca3e                            # 0048d16e
    add esp, 0x10                                # 0048d173
    push 0x63888b                                # 0048d176
    push 0x54e840                                # 0048d17b
    mov ecx, 0x583979                            # 0048d180
    call FUN_0042639d                            # 0048d185
    mov ecx, 0x5cf659                            # 0048d18a
    call FUN_004c97b4                            # 0048d18f
L_0048d194:
    # block 0x0048d194: entered by jne at 0x0048d154, 21 instruction(s), ends with je to 0x0048d1e0 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0048d194
    mov esi, dword ptr [ecx]                     # 0048d197
    mov edx, dword ptr [ebp + arg_8]             # 0048d199
    mov edi, dword ptr [edx]                     # 0048d19c
    mov ecx, 0x1ee                               # 0048d19e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048d1a3
    movsw word ptr es:[edi], word ptr [esi]      # 0048d1a5
    movsb byte ptr es:[edi], byte ptr [esi]      # 0048d1a7
    mov eax, dword ptr [ebp + arg_10]            # 0048d1a8
    mov ecx, dword ptr [eax]                     # 0048d1ab
    add ecx, 0x7bb                               # 0048d1ad
    mov edx, dword ptr [ebp + arg_10]            # 0048d1b3
    mov dword ptr [edx], ecx                     # 0048d1b6
    mov eax, dword ptr [ebp + arg_c]             # 0048d1b8
    mov ecx, dword ptr [eax]                     # 0048d1bb
    add ecx, 0x7bb                               # 0048d1bd
    mov edx, dword ptr [ebp + arg_c]             # 0048d1c3
    mov dword ptr [edx], ecx                     # 0048d1c6
    movsx eax, word ptr [0x63a4cd]               # 0048d1c8
    test eax, eax                                # 0048d1cf
    je.d8 L_0048d1e0                             # 0048d1d1
    # block 0x0048d1d3: entered by fall-through of je at 0x0048d1d1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0048d1e0
    push 0x54e85c                                # 0048d1d3
    call FUN_0044a2b7                            # 0048d1d8
    add esp, 0x4                                 # 0048d1dd
L_0048d1e0:
    # block 0x0048d1e0: entered by je at 0x0048d1d1, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0048d1e0
    pop esi                                      # 0048d1e1
    {load} mov esp, ebp                          # 0048d1e2
    pop ebp                                      # 0048d1e4
    ret 0xc                                      # 0048d1e5

