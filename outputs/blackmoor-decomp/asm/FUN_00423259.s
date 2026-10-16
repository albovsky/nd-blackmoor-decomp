# FUN_00423259
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423259
# extent:       0x00423259-0x00423368 (271 code bytes)
# span:         0x00423259-0x00423368 (code 271, tables 0, padding 0)
# sha256:       05577fdc25bbcff3f5b8e48c31cedc4836a90d77f41d1f59886594953693f7e3
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423259
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_28, local_4c, local_50, local_54, local_58, local_5c, local_5d, local_5e, local_64, local_68
# fields:       [ecx + n] field_1; [edx + n] field_1, field_25
# callees:      calls FUN_00423368, FUN_0050d0bc
# track-n:      outputs/blackmoor-decomp/src/action_family_3e.h:action_family_3e_construct (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 101 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_28, 0x28  # offset -0x28
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_5d, 0x5d  # offset -0x5d
.equ local_5e, 0x5e  # offset -0x5e
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------
.set FUN_00423368, .text + (0x00423368 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)

.org 0x00423259 - 0x401000
.globl FUN_00423259
FUN_00423259:
    # block 0x00423259: entry, 15 instruction(s), calls FUN_00423368, falls into the block at 0x0042327f
    push ebp                                     # 00423259
    {load} mov ebp, esp                          # 0042325a
    sub esp, 0x68                                # 0042325c
    push esi                                     # 0042325f
    push edi                                     # 00423260
    mov dword ptr [ebp - local_54], ecx          # 00423261
    mov eax, dword ptr [ebp + arg_8]             # 00423264
    push eax                                     # 00423267
    mov ecx, dword ptr [ebp - local_54]          # 00423268
    call FUN_00423368                            # 0042326b
    mov dword ptr [ebp - local_4], eax           # 00423270
    mov ecx, dword ptr [ebp - local_4]           # 00423273
    mov edx, dword ptr [ebp - local_54]          # 00423276
    mov eax, dword ptr [edx + 4*ecx]             # 00423279
    mov dword ptr [ebp - local_50], eax          # 0042327c
L_0042327f:
    # block 0x0042327f: entered by jmp at 0x00423359, 2 instruction(s), ends with je to 0x0042335e (forward)
    cmp dword ptr [ebp - local_50], 0x0          # 0042327f
    je.d32 L_0042335e                            # 00423283
    # block 0x00423289: entered by fall-through of je at 0x00423283, 44 instruction(s), calls FUN_0050d0bc, falls into the block at 0x004232f8
    mov edi, dword ptr [ebp + arg_8]             # 00423289
    lea edx, [ebp - local_28]                    # 0042328c
    or ecx, -0x1                                 # 0042328f
    {load} xor eax, eax                          # 00423292
    repne scasb al, byte ptr es:[edi]            # 00423294
    not ecx                                      # 00423296
    {load} sub edi, ecx                          # 00423298
    {load} mov esi, edi                          # 0042329a
    {load} mov eax, ecx                          # 0042329c
    {load} mov edi, edx                          # 0042329e
    shr ecx, 0x2                                 # 004232a0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004232a3
    {load} mov ecx, eax                          # 004232a5
    and ecx, 0x3                                 # 004232a7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004232aa
    mov ecx, dword ptr [ebp - local_50]          # 004232ac
    add ecx, 0x4                                 # 004232af
    {load} mov edi, ecx                          # 004232b2
    lea edx, [ebp - local_4c]                    # 004232b4
    or ecx, -0x1                                 # 004232b7
    {load} xor eax, eax                          # 004232ba
    repne scasb al, byte ptr es:[edi]            # 004232bc
    not ecx                                      # 004232be
    {load} sub edi, ecx                          # 004232c0
    {load} mov esi, edi                          # 004232c2
    {load} mov eax, ecx                          # 004232c4
    {load} mov edi, edx                          # 004232c6
    shr ecx, 0x2                                 # 004232c8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004232cb
    {load} mov ecx, eax                          # 004232cd
    and ecx, 0x3                                 # 004232cf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004232d2
    lea ecx, [ebp - local_28]                    # 004232d4
    push ecx                                     # 004232d7
    call FUN_0050d0bc                            # 004232d8
    add esp, 0x4                                 # 004232dd
    lea edx, [ebp - local_4c]                    # 004232e0
    push edx                                     # 004232e3
    call FUN_0050d0bc                            # 004232e4
    add esp, 0x4                                 # 004232e9
    lea eax, [ebp - local_4c]                    # 004232ec
    mov dword ptr [ebp - local_58], eax          # 004232ef
    lea ecx, [ebp - local_28]                    # 004232f2
    mov dword ptr [ebp - local_5c], ecx          # 004232f5
L_004232f8:
    # block 0x004232f8: entered by jne at 0x0042332a, 6 instruction(s), ends with jne to 0x00423335 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004232f8
    mov al, byte ptr [edx]                       # 004232fb
    mov byte ptr [ebp - local_5d], al            # 004232fd
    mov ecx, dword ptr [ebp - local_58]          # 00423300
    cmp al, byte ptr [ecx]                       # 00423303
    jne.d8 L_00423335                            # 00423305
    # block 0x00423307: entered by fall-through of jne at 0x00423305, 2 instruction(s), ends with je to 0x0042332c (forward)
    cmp byte ptr [ebp - local_5d], 0x0           # 00423307
    je.d8 L_0042332c                             # 0042330b
    # block 0x0042330d: entered by fall-through of je at 0x0042330b, 6 instruction(s), ends with jne to 0x00423335 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0042330d
    mov al, byte ptr [edx + field_1]             # 00423310
    mov byte ptr [ebp - local_5e], al            # 00423313
    mov ecx, dword ptr [ebp - local_58]          # 00423316
    cmp al, byte ptr [ecx + field_1]             # 00423319
    jne.d8 L_00423335                            # 0042331c
    # block 0x0042331e: entered by fall-through of jne at 0x0042331c, 4 instruction(s), ends with jne to 0x004232f8 (backward)
    add dword ptr [ebp - local_5c], 0x2          # 0042331e
    add dword ptr [ebp - local_58], 0x2          # 00423322
    cmp byte ptr [ebp - local_5e], 0x0           # 00423326
    jne.d8 L_004232f8                            # 0042332a
L_0042332c:
    # block 0x0042332c: entered by je at 0x0042330b; fall-through of jne at 0x0042332a, 2 instruction(s), ends with forward jump to 0x0042333d
    mov dword ptr [ebp - local_64], 0x0          # 0042332c
    jmp.d8 L_0042333d                            # 00423333
L_00423335:
    # block 0x00423335: entered by jne at 0x00423305; jne at 0x0042331c, 3 instruction(s), falls into the block at 0x0042333d
    {load} sbb edx, edx                          # 00423335
    sbb edx, -0x1                                # 00423337
    mov dword ptr [ebp - local_64], edx          # 0042333a
L_0042333d:
    # block 0x0042333d: entered by jmp at 0x00423333, 4 instruction(s), ends with jne to 0x00423350 (forward)
    mov eax, dword ptr [ebp - local_64]          # 0042333d
    mov dword ptr [ebp - local_68], eax          # 00423340
    cmp dword ptr [ebp - local_68], 0x0          # 00423343
    jne.d8 L_00423350                            # 00423347
    # block 0x00423349: entered by fall-through of jne at 0x00423347, 3 instruction(s), ends with forward jump to 0x00423360
    mov ecx, dword ptr [ebp - local_50]          # 00423349
    mov eax, dword ptr [ecx]                     # 0042334c
    jmp.d8 L_00423360                            # 0042334e
L_00423350:
    # block 0x00423350: entered by jne at 0x00423347, 4 instruction(s), ends with backward jump to 0x0042327f
    mov edx, dword ptr [ebp - local_50]          # 00423350
    mov eax, dword ptr [edx + field_25]          # 00423353
    mov dword ptr [ebp - local_50], eax          # 00423356
    jmp.d32 L_0042327f                           # 00423359
L_0042335e:
    # block 0x0042335e: entered by je at 0x00423283, 1 instruction(s), falls into the block at 0x00423360
    {load} xor eax, eax                          # 0042335e
L_00423360:
    # block 0x00423360: entered by jmp at 0x0042334e, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00423360
    pop esi                                      # 00423361
    {load} mov esp, ebp                          # 00423362
    pop ebp                                      # 00423364
    ret 0x4                                      # 00423365

