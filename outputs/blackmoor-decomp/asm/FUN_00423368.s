# FUN_00423368
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423368
# extent:       0x00423368-0x00423442 (218 code bytes)
# span:         0x00423368-0x00423450 (code 218, tables 0, padding 14)
# sha256:       9b3ba94cdefc18a6575879c19ebdde3a4aa8ac80a02d0ea02e2c01ad45e335b8
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423368
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cb1b, FUN_0050d6cf
# track-n:      outputs/blackmoor-decomp/src/autotext.c:original_bucket (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 72 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0050d6cf, .text + (0x0050d6cf - 0x401000)

.org 0x00423368 - 0x401000
.globl FUN_00423368
FUN_00423368:
    # block 0x00423368: entry, 22 instruction(s), calls FUN_0050cb1b, ends with jns to 0x004233b4 (forward)
    push ebp                                     # 00423368
    {load} mov ebp, esp                          # 00423369
    sub esp, 0x14                                # 0042336b
    push edi                                     # 0042336e
    mov dword ptr [ebp - local_14], ecx          # 0042336f
    mov word ptr [ebp - local_10], 0x0           # 00423372
    mov word ptr [ebp - local_c], 0x0            # 00423378
    mov edi, dword ptr [ebp + arg_8]             # 0042337e
    or ecx, -0x1                                 # 00423381
    {load} xor eax, eax                          # 00423384
    repne scasb al, byte ptr es:[edi]            # 00423386
    not ecx                                      # 00423388
    add ecx, -0x1                                # 0042338a
    mov word ptr [ebp - local_8], cx             # 0042338d
    mov word ptr [ebp - local_4], 0x0            # 00423391
    mov eax, dword ptr [ebp + arg_8]             # 00423397
    add eax, 0x3                                 # 0042339a
    push eax                                     # 0042339d
    call FUN_0050cb1b                            # 0042339e
    add esp, 0x4                                 # 004233a3
    and eax, 0x800003ff                          # 004233a6
    jns.d8 L_004233b4                            # 004233ab
    # block 0x004233ad: entered by fall-through of jns at 0x004233ab, 3 instruction(s), falls into the block at 0x004233b4
    dec eax                                      # 004233ad
    or eax, 0xfffffc00                           # 004233ae
    inc eax                                      # 004233b3
L_004233b4:
    # block 0x004233b4: entered by jns at 0x004233ab, 4 instruction(s), ends with jne to 0x00423437 (forward)
    mov word ptr [ebp - local_c], ax             # 004233b4
    movsx ecx, word ptr [ebp - local_c]          # 004233b8
    test ecx, ecx                                # 004233bc
    jne.d8 L_00423437                            # 004233be
    # block 0x004233c0: entered by fall-through of jne at 0x004233be, 2 instruction(s), ends with forward jump to 0x004233d4
    mov word ptr [ebp - local_4], 0x0            # 004233c0
    jmp.d8 L_004233d4                            # 004233c6
L_004233c8:
    # block 0x004233c8: entered by jmp at 0x00423422, 3 instruction(s), falls into the block at 0x004233d4
    mov dx, word ptr [ebp - local_4]             # 004233c8
    add dx, 0x1                                  # 004233cc
    mov word ptr [ebp - local_4], dx             # 004233d0
L_004233d4:
    # block 0x004233d4: entered by jmp at 0x004233c6, 4 instruction(s), ends with jge to 0x00423424 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004233d4
    movsx ecx, word ptr [ebp - local_8]          # 004233d8
    {load} cmp eax, ecx                          # 004233dc
    jge.d8 L_00423424                            # 004233de
    # block 0x004233e0: entered by fall-through of jge at 0x004233de, 8 instruction(s), calls FUN_0050d6cf, ends with je to 0x00423422 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004233e0
    mov eax, dword ptr [ebp + arg_8]             # 004233e4
    movsx ecx, byte ptr [eax + edx]              # 004233e7
    push ecx                                     # 004233eb
    call FUN_0050d6cf                            # 004233ec
    add esp, 0x4                                 # 004233f1
    test eax, eax                                # 004233f4
    je.d8 L_00423422                             # 004233f6
    # block 0x004233f8: entered by fall-through of je at 0x004233f6, 8 instruction(s), calls FUN_0050cb1b, ends with jns to 0x00423418 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004233f8
    mov eax, dword ptr [ebp + arg_8]             # 004233fc
    {load} add eax, edx                          # 004233ff
    push eax                                     # 00423401
    call FUN_0050cb1b                            # 00423402
    add esp, 0x4                                 # 00423407
    and eax, 0x800003ff                          # 0042340a
    jns.d8 L_00423418                            # 0042340f
    # block 0x00423411: entered by fall-through of jns at 0x0042340f, 3 instruction(s), falls into the block at 0x00423418
    dec eax                                      # 00423411
    or eax, 0xfffffc00                           # 00423412
    inc eax                                      # 00423417
L_00423418:
    # block 0x00423418: entered by jns at 0x0042340f, 3 instruction(s), ends with forward jump to 0x0042343b
    mov word ptr [ebp - local_c], ax             # 00423418
    movsx eax, word ptr [ebp - local_c]          # 0042341c
    jmp.d8 L_0042343b                            # 00423420
L_00423422:
    # block 0x00423422: entered by je at 0x004233f6, 1 instruction(s), ends with backward jump to 0x004233c8
    jmp.d8 L_004233c8                            # 00423422
L_00423424:
    # block 0x00423424: entered by jge at 0x004233de, 3 instruction(s), ends with jne to 0x00423437 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00423424
    test ecx, ecx                                # 00423428
    jne.d8 L_00423437                            # 0042342a
    # block 0x0042342c: entered by fall-through of jne at 0x0042342a, 3 instruction(s), falls into the block at 0x00423437
    mov edx, dword ptr [ebp + arg_8]             # 0042342c
    movsx ax, byte ptr [edx]                     # 0042342f
    mov word ptr [ebp - local_c], ax             # 00423433
L_00423437:
    # block 0x00423437: entered by jne at 0x004233be; jne at 0x0042342a, 1 instruction(s), falls into the block at 0x0042343b
    movsx eax, word ptr [ebp - local_c]          # 00423437
L_0042343b:
    # block 0x0042343b: entered by jmp at 0x00423420, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0042343b
    {load} mov esp, ebp                          # 0042343c
    pop ebp                                      # 0042343e
    ret 0x4                                      # 0042343f

# --- data items (not part of the function) -------------------------
.org 0x00423442 - 0x401000
PAD_00423442:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

