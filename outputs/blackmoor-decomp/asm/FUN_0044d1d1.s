# FUN_0044d1d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d1d1
# extent:       0x0044d1d1-0x0044d28c (187 code bytes)
# span:         0x0044d1d1-0x0044d28c (code 187, tables 0, padding 0)
# sha256:       8a93baacf690f58d1a516a469e85fab5451073647002540115040daf8f983af7
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_aa_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_aa_runtime.h:17 says "0x44d1d1 loader (0x40b34a, 0x4107df): copies the 763-byte typed body"
# name-note:    Loader for raw 0xaa rows: copies the 763-byte typed body into a fresh row allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x0044d1d1 - 0x401000
.globl FUN_0044d1d1
FUN_0044d1d1:
    # block 0x0044d1d1: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044d238 (forward)
    push ebp                                     # 0044d1d1
    {load} mov ebp, esp                          # 0044d1d2
    sub esp, 0x8                                 # 0044d1d4
    push esi                                     # 0044d1d7
    push edi                                     # 0044d1d8
    mov dword ptr [ebp - local_8], ecx           # 0044d1d9
    push 0x2fb                                   # 0044d1dc
    call FUN_0051dc43                            # 0044d1e1
    add esp, 0x4                                 # 0044d1e6
    mov dword ptr [ebp - local_4], eax           # 0044d1e9
    mov eax, dword ptr [ebp + arg_8]             # 0044d1ec
    mov ecx, dword ptr [ebp - local_4]           # 0044d1ef
    mov dword ptr [eax], ecx                     # 0044d1f2
    cmp dword ptr [ebp - local_4], 0x0           # 0044d1f4
    jne.d8 L_0044d238                            # 0044d1f8
    # block 0x0044d1fa: entered by fall-through of jne at 0x0044d1f8, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044d238
    movsx edx, word ptr [0x5c39e3]               # 0044d1fa
    push edx                                     # 0044d201
    mov eax, dword ptr [0x5bb57b]                # 0044d202
    push eax                                     # 0044d207
    push 0x549538                                # 0044d208
    push 0x63888b                                # 0044d20d
    call FUN_0050ca3e                            # 0044d212
    add esp, 0x10                                # 0044d217
    push 0x63888b                                # 0044d21a
    push 0x549564                                # 0044d21f
    mov ecx, 0x583979                            # 0044d224
    call FUN_0042639d                            # 0044d229
    mov ecx, 0x5cf659                            # 0044d22e
    call FUN_004c97b4                            # 0044d233
L_0044d238:
    # block 0x0044d238: entered by jne at 0x0044d1f8, 21 instruction(s), ends with je to 0x0044d284 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044d238
    mov esi, dword ptr [ecx]                     # 0044d23b
    mov edx, dword ptr [ebp + arg_8]             # 0044d23d
    mov edi, dword ptr [edx]                     # 0044d240
    mov ecx, 0xbe                                # 0044d242
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044d247
    movsw word ptr es:[edi], word ptr [esi]      # 0044d249
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044d24b
    mov eax, dword ptr [ebp + arg_10]            # 0044d24c
    mov ecx, dword ptr [eax]                     # 0044d24f
    add ecx, 0x2fb                               # 0044d251
    mov edx, dword ptr [ebp + arg_10]            # 0044d257
    mov dword ptr [edx], ecx                     # 0044d25a
    mov eax, dword ptr [ebp + arg_c]             # 0044d25c
    mov ecx, dword ptr [eax]                     # 0044d25f
    add ecx, 0x2fb                               # 0044d261
    mov edx, dword ptr [ebp + arg_c]             # 0044d267
    mov dword ptr [edx], ecx                     # 0044d26a
    movsx eax, word ptr [0x63a4cd]               # 0044d26c
    test eax, eax                                # 0044d273
    je.d8 L_0044d284                             # 0044d275
    # block 0x0044d277: entered by fall-through of je at 0x0044d275, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044d284
    push 0x549580                                # 0044d277
    call FUN_0044a2b7                            # 0044d27c
    add esp, 0x4                                 # 0044d281
L_0044d284:
    # block 0x0044d284: entered by je at 0x0044d275, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044d284
    pop esi                                      # 0044d285
    {load} mov esp, ebp                          # 0044d286
    pop ebp                                      # 0044d288
    ret 0xc                                      # 0044d289

