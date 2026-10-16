# FUN_0044727a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044727a
# extent:       0x0044727a-0x004473a9 (303 code bytes)
# span:         0x0044727a-0x004473a9 (code 303, tables 0, padding 0)
# sha256:       6caf49a8c027e1f717eb5dcd68244dbe0cc4ebccd437f6c8163097eacb1a969d
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044727a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_21, field_29, field_4e, field_56, field_5a; [ecx + n] field_1c, field_1d, field_25, field_4e, field_52, field_5a; [edx + n] field_1c, field_52, field_56
# callees:      calls FUN_004473a9, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:prepare_a28_handoff_frames (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004473a9, .text + (0x004473a9 - 0x401000)

.org 0x0044727a - 0x401000
.globl FUN_0044727a
FUN_0044727a:
    # block 0x0044727a: entry, 12 instruction(s), ends with je to 0x004472ad (forward)
    push ebp                                     # 0044727a
    {load} mov ebp, esp                          # 0044727b
    sub esp, 0x8                                 # 0044727d
    push esi                                     # 00447280
    push edi                                     # 00447281
    mov dword ptr [ebp - local_4], ecx           # 00447282
    movsx eax, word ptr [ebp + arg_8]            # 00447285
    imul eax, eax, 0x8d                          # 00447289
    mov ecx, dword ptr [eax + 0x5bb632]          # 0044728f
    mov dword ptr [ebp - local_8], ecx           # 00447295
    cmp dword ptr [ebp - local_8], 0x0           # 00447298
    je.d8 L_004472ad                             # 0044729c
    # block 0x0044729e: entered by fall-through of je at 0x0044729c, 2 instruction(s), ends with je to 0x00447394 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 0044729e
    je.d32 L_00447394                            # 004472a2
    # block 0x004472a8: entered by fall-through of je at 0x004472a2, 1 instruction(s), ends with forward jump to 0x004473a1
    jmp.d32 L_004473a1                           # 004472a8
L_004472ad:
    # block 0x004472ad: entered by je at 0x0044729c, 5 instruction(s), ends with je to 0x004472be (forward)
    mov edx, dword ptr [ebp - local_4]           # 004472ad
    {load} xor eax, eax                          # 004472b0
    mov al, byte ptr [edx + field_1c]            # 004472b2
    test eax, eax                                # 004472b5
    je.d8 L_004472be                             # 004472b7
    # block 0x004472b9: entered by fall-through of je at 0x004472b7, 1 instruction(s), ends with forward jump to 0x004473a1
    jmp.d32 L_004473a1                           # 004472b9
L_004472be:
    # block 0x004472be: entered by je at 0x004472b7, 16 instruction(s), ends with je to 0x00447303 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004472be
    mov byte ptr [ecx + field_1c], 0x1           # 004472c1
    movsx edx, word ptr [ebp + arg_8]            # 004472c5
    imul edx, edx, 0x8d                          # 004472c9
    mov esi, dword ptr [edx + 0x5bb5e5]          # 004472cf
    mov edi, dword ptr [ebp - local_4]           # 004472d5
    add edi, 0x49                                # 004472d8
    mov ecx, 0x5                                 # 004472db
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004472e0
    movsb byte ptr es:[edi], byte ptr [esi]      # 004472e2
    mov eax, dword ptr [ebp - local_4]           # 004472e3
    mov ecx, dword ptr [ebp - local_4]           # 004472e6
    mov edx, dword ptr [eax + field_5a]          # 004472e9
    sub edx, dword ptr [ecx + field_52]          # 004472ec
    test edx, edx                                # 004472ef
    je.d8 L_00447303                             # 004472f1
    # block 0x004472f3: entered by fall-through of je at 0x004472f1, 6 instruction(s), ends with jne to 0x0044732e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004472f3
    mov ecx, dword ptr [ebp - local_4]           # 004472f6
    mov edx, dword ptr [eax + field_56]          # 004472f9
    sub edx, dword ptr [ecx + field_4e]          # 004472fc
    test edx, edx                                # 004472ff
    jne.d8 L_0044732e                            # 00447301
L_00447303:
    # block 0x00447303: entered by je at 0x004472f1; fall-through of jne at 0x00447301, 11 instruction(s), ends with forward jump to 0x00447376
    mov eax, dword ptr [ebp - local_4]           # 00447303
    add eax, 0x1d                                # 00447306
    mov ecx, dword ptr [0x583186]                # 00447309
    mov dword ptr [eax], ecx                     # 0044730f
    mov edx, dword ptr [0x58318a]                # 00447311
    mov dword ptr [eax + field_4], edx           # 00447317
    mov ecx, dword ptr [0x58318e]                # 0044731a
    mov dword ptr [eax + field_8], ecx           # 00447320
    mov edx, dword ptr [0x583192]                # 00447323
    mov dword ptr [eax + field_c], edx           # 00447329
    jmp.d8 L_00447376                            # 0044732c
L_0044732e:
    # block 0x0044732e: entered by jne at 0x00447301, 22 instruction(s), falls into the block at 0x00447376
    mov eax, dword ptr [ebp - local_4]           # 0044732e
    mov ecx, dword ptr [eax + field_21]          # 00447331
    mov edx, dword ptr [ebp - local_4]           # 00447334
    add ecx, dword ptr [edx + field_52]          # 00447337
    mov eax, dword ptr [ebp - local_4]           # 0044733a
    mov dword ptr [eax + field_21], ecx          # 0044733d
    mov ecx, dword ptr [ebp - local_4]           # 00447340
    mov edx, dword ptr [ecx + field_5a]          # 00447343
    add edx, dword ptr [0x58318a]                # 00447346
    mov eax, dword ptr [ebp - local_4]           # 0044734c
    mov dword ptr [eax + field_29], edx          # 0044734f
    mov ecx, dword ptr [ebp - local_4]           # 00447352
    mov edx, dword ptr [ecx + field_1d]          # 00447355
    mov eax, dword ptr [ebp - local_4]           # 00447358
    add edx, dword ptr [eax + field_4e]          # 0044735b
    mov ecx, dword ptr [ebp - local_4]           # 0044735e
    mov dword ptr [ecx + field_1d], edx          # 00447361
    mov edx, dword ptr [ebp - local_4]           # 00447364
    mov eax, dword ptr [edx + field_56]          # 00447367
    add eax, dword ptr [0x583186]                # 0044736a
    mov ecx, dword ptr [ebp - local_4]           # 00447370
    mov dword ptr [ecx + field_25], eax          # 00447373
L_00447376:
    # block 0x00447376: entered by jmp at 0x0044732c, 6 instruction(s), calls FUN_004473a9, ends with forward jump to 0x004473a1
    mov ecx, dword ptr [ebp - local_4]           # 00447376
    call FUN_004473a9                            # 00447379
    movsx edx, word ptr [ebp + arg_8]            # 0044737e
    imul edx, edx, 0x8d                          # 00447382
    mov dword ptr [edx + 0x5bb632], 0x2          # 00447388
    jmp.d8 L_004473a1                            # 00447392
L_00447394:
    # block 0x00447394: entered by je at 0x004472a2, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004473a1
    mov ax, word ptr [ebp + arg_8]               # 00447394
    push eax                                     # 00447398
    call FUN_0042ba3a                            # 00447399
    add esp, 0x4                                 # 0044739e
L_004473a1:
    # block 0x004473a1: entered by jmp at 0x004472a8; jmp at 0x004472b9; jmp at 0x00447392, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004473a1
    pop esi                                      # 004473a2
    {load} mov esp, ebp                          # 004473a3
    pop ebp                                      # 004473a5
    ret 0x4                                      # 004473a6

