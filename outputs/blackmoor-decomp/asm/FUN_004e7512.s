# FUN_004e7512
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7512
# extent:       0x004e7512-0x004e75f3 (225 code bytes)
# span:         0x004e7512-0x004e7600 (code 225, tables 0, padding 13)
# sha256:       1b21b5f1881e7974ac1a55e4fbce010f0653c299fc4281c3ace82ba7b040ad73
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7512_lifted
# naming:       native port src/original_methods_fl41.c:m4e7512_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 67/67 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4530, field_5500, field_5521, field_5523; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c, field_5408
# callees:      calls FUN_004e3cd7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e7512_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 67 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_4530, 0x4530  # offset +0x4530
.equ field_5408, 0x5408  # offset +0x5408
.equ field_5500, 0x5500  # offset +0x5500
.equ field_5521, 0x5521  # offset +0x5521
.equ field_5523, 0x5523  # offset +0x5523

# --- external targets -----------------------------------------------
.set FUN_004e3cd7, .text + (0x004e3cd7 - 0x401000)

.org 0x004e7512 - 0x401000
.globl FUN_004e7512
FUN_004e7512:
    # block 0x004e7512: entry, 67 instruction(s), calls FUN_004e3cd7, ends with ret 0x4
    push ebp                                     # 004e7512
    {load} mov ebp, esp                          # 004e7513
    push ecx                                     # 004e7515
    push esi                                     # 004e7516
    push edi                                     # 004e7517
    mov dword ptr [ebp - local_4], ecx           # 004e7518
    mov eax, dword ptr [ebp - local_4]           # 004e751b
    mov dword ptr [eax + field_4530], 0xc        # 004e751e
    mov ecx, dword ptr [ebp - local_4]           # 004e7528
    add ecx, 0x54df                              # 004e752b
    {load} mov edi, ecx                          # 004e7531
    mov edx, dword ptr [ebp - local_4]           # 004e7533
    add edx, 0x54be                              # 004e7536
    or ecx, -0x1                                 # 004e753c
    {load} xor eax, eax                          # 004e753f
    repne scasb al, byte ptr es:[edi]            # 004e7541
    not ecx                                      # 004e7543
    {load} sub edi, ecx                          # 004e7545
    {load} mov esi, edi                          # 004e7547
    {load} mov eax, ecx                          # 004e7549
    {load} mov edi, edx                          # 004e754b
    shr ecx, 0x2                                 # 004e754d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e7550
    {load} mov ecx, eax                          # 004e7552
    and ecx, 0x3                                 # 004e7554
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e7557
    movsx ecx, word ptr [ebp + arg_8]            # 004e7559
    imul ecx, ecx, 0xd7                          # 004e755d
    mov edx, dword ptr [ebp - local_4]           # 004e7563
    mov eax, dword ptr [ebp - local_4]           # 004e7566
    mov cx, word ptr [eax + ecx + field_5521]    # 004e7569
    mov word ptr [edx + field_5408], cx          # 004e7571
    movsx edx, word ptr [ebp + arg_8]            # 004e7578
    imul edx, edx, 0xd7                          # 004e757c
    mov eax, dword ptr [ebp - local_4]           # 004e7582
    lea esi, [eax + edx + field_5523]            # 004e7585
    mov edi, dword ptr [ebp - local_4]           # 004e758c
    add edi, 0x540a                              # 004e758f
    mov ecx, 0x2d                                # 004e7595
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e759a
    mov ecx, dword ptr [ebp - local_4]           # 004e759c
    add ecx, 0x10cd                              # 004e759f
    mov edx, dword ptr [ebp - local_4]           # 004e75a5
    add edx, 0x53d7                              # 004e75a8
    mov eax, dword ptr [ecx]                     # 004e75ae
    mov dword ptr [edx], eax                     # 004e75b0
    mov eax, dword ptr [ecx + field_4]           # 004e75b2
    mov dword ptr [edx + field_4], eax           # 004e75b5
    mov eax, dword ptr [ecx + field_8]           # 004e75b8
    mov dword ptr [edx + field_8], eax           # 004e75bb
    mov ecx, dword ptr [ecx + field_c]           # 004e75be
    mov dword ptr [edx + field_c], ecx           # 004e75c1
    movsx edx, word ptr [ebp + arg_8]            # 004e75c4
    imul edx, edx, 0xd7                          # 004e75c8
    mov eax, dword ptr [ebp - local_4]           # 004e75ce
    lea ecx, [eax + edx + field_5500]            # 004e75d1
    push ecx                                     # 004e75d8
    mov edx, dword ptr [ebp - local_4]           # 004e75d9
    add edx, 0x53d7                              # 004e75dc
    push edx                                     # 004e75e2
    mov ecx, dword ptr [ebp - local_4]           # 004e75e3
    call FUN_004e3cd7                            # 004e75e6
    pop edi                                      # 004e75eb
    pop esi                                      # 004e75ec
    {load} mov esp, ebp                          # 004e75ed
    pop ebp                                      # 004e75ef
    ret 0x4                                      # 004e75f0

# --- data items (not part of the function) -------------------------
.org 0x004e75f3 - 0x401000
PAD_004e75f3:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

