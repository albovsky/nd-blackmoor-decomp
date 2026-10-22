# FUN_004ba2bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba2bd
# extent:       0x004ba2bd-0x004ba377 (186 code bytes)
# span:         0x004ba2bd-0x004ba377 (code 186, tables 0, padding 0)
# sha256:       6cc99c08b3c265f0109e6a1d6f24953ce14f94753df27627398c25db1111ff4f
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ba2bd_clone_record
# naming:       native port src/original_methods_fl39b.c:m4ba2bd_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0xae2 bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0xae2 bytes (rep movsd, movsw) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m4ba2bd_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004ba2bd - 0x401000
.globl FUN_004ba2bd
FUN_004ba2bd:
    # block 0x004ba2bd: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004ba324 (forward)
    push ebp                                     # 004ba2bd
    {load} mov ebp, esp                          # 004ba2be
    sub esp, 0x8                                 # 004ba2c0
    push esi                                     # 004ba2c3
    push edi                                     # 004ba2c4
    mov dword ptr [ebp - local_8], ecx           # 004ba2c5
    push 0xae2                                   # 004ba2c8
    call FUN_0051dc43                            # 004ba2cd
    add esp, 0x4                                 # 004ba2d2
    mov dword ptr [ebp - local_4], eax           # 004ba2d5
    mov eax, dword ptr [ebp + arg_8]             # 004ba2d8
    mov ecx, dword ptr [ebp - local_4]           # 004ba2db
    mov dword ptr [eax], ecx                     # 004ba2de
    cmp dword ptr [ebp - local_4], 0x0           # 004ba2e0
    jne.d8 L_004ba324                            # 004ba2e4
    # block 0x004ba2e6: entered by fall-through of jne at 0x004ba2e4, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004ba324
    movsx edx, word ptr [0x5c39e3]               # 004ba2e6
    push edx                                     # 004ba2ed
    mov eax, dword ptr [0x5bb57b]                # 004ba2ee
    push eax                                     # 004ba2f3
    push 0x551edc                                # 004ba2f4
    push 0x63888b                                # 004ba2f9
    call FUN_0050ca3e                            # 004ba2fe
    add esp, 0x10                                # 004ba303
    push 0x63888b                                # 004ba306
    push 0x551f08                                # 004ba30b
    mov ecx, 0x583979                            # 004ba310
    call FUN_0042639d                            # 004ba315
    mov ecx, 0x5cf659                            # 004ba31a
    call FUN_004c97b4                            # 004ba31f
L_004ba324:
    # block 0x004ba324: entered by jne at 0x004ba2e4, 20 instruction(s), ends with je to 0x004ba36f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004ba324
    mov esi, dword ptr [ecx]                     # 004ba327
    mov edx, dword ptr [ebp + arg_8]             # 004ba329
    mov edi, dword ptr [edx]                     # 004ba32c
    mov ecx, 0x2b8                               # 004ba32e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ba333
    movsw word ptr es:[edi], word ptr [esi]      # 004ba335
    mov eax, dword ptr [ebp + arg_10]            # 004ba337
    mov ecx, dword ptr [eax]                     # 004ba33a
    add ecx, 0xae2                               # 004ba33c
    mov edx, dword ptr [ebp + arg_10]            # 004ba342
    mov dword ptr [edx], ecx                     # 004ba345
    mov eax, dword ptr [ebp + arg_c]             # 004ba347
    mov ecx, dword ptr [eax]                     # 004ba34a
    add ecx, 0xae2                               # 004ba34c
    mov edx, dword ptr [ebp + arg_c]             # 004ba352
    mov dword ptr [edx], ecx                     # 004ba355
    movsx eax, word ptr [0x63a4cd]               # 004ba357
    test eax, eax                                # 004ba35e
    je.d8 L_004ba36f                             # 004ba360
    # block 0x004ba362: entered by fall-through of je at 0x004ba360, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ba36f
    push 0x551f24                                # 004ba362
    call FUN_0044a2b7                            # 004ba367
    add esp, 0x4                                 # 004ba36c
L_004ba36f:
    # block 0x004ba36f: entered by je at 0x004ba360, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004ba36f
    pop esi                                      # 004ba370
    {load} mov esp, ebp                          # 004ba371
    pop ebp                                      # 004ba373
    ret 0xc                                      # 004ba374

