# FUN_0048bca6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bca6
# extent:       0x0048bca6-0x0048bd91 (235 code bytes)
# span:         0x0048bca6-0x0048bd91 (code 235, tables 0, padding 0)
# sha256:       0aabdb0ff0d6af8b480b2416b53e960b280f4ce762cd813f5d3da548908fb39d
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48bca6_lifted
# naming:       native port src/original_methods_fl41.c:m48bca6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 9 seeds; oracle: 75/75 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_15e
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m48bca6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_15e, 0x15e  # offset +0x15e

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048bca6 - 0x401000
.globl FUN_0048bca6
FUN_0048bca6:
    # block 0x0048bca6: entry, 27 instruction(s), calls FUN_0051dc43, ends with jne to 0x0048bd35 (forward)
    push ebp                                     # 0048bca6
    {load} mov ebp, esp                          # 0048bca7
    sub esp, 0x10                                # 0048bca9
    push esi                                     # 0048bcac
    push edi                                     # 0048bcad
    mov dword ptr [ebp - local_10], ecx          # 0048bcae
    mov eax, dword ptr [ebp + arg_c]             # 0048bcb1
    mov ecx, dword ptr [eax]                     # 0048bcb4
    mov dword ptr [ebp - local_4], ecx           # 0048bcb6
    mov edx, dword ptr [ebp - local_4]           # 0048bcb9
    movsx eax, word ptr [edx + field_15e]        # 0048bcbc
    mov ecx, 0x64                                # 0048bcc3
    {load} sub ecx, eax                          # 0048bcc8
    imul ecx, ecx, 0x12                          # 0048bcca
    mov edx, 0x868                               # 0048bccd
    {load} sub edx, ecx                          # 0048bcd2
    mov word ptr [ebp - local_8], dx             # 0048bcd4
    movsx eax, word ptr [ebp - local_8]          # 0048bcd8
    push eax                                     # 0048bcdc
    call FUN_0051dc43                            # 0048bcdd
    add esp, 0x4                                 # 0048bce2
    mov dword ptr [ebp - local_c], eax           # 0048bce5
    mov ecx, dword ptr [ebp + arg_8]             # 0048bce8
    mov edx, dword ptr [ebp - local_c]           # 0048bceb
    mov dword ptr [ecx], edx                     # 0048bcee
    cmp dword ptr [ebp - local_c], 0x0           # 0048bcf0
    jne.d8 L_0048bd35                            # 0048bcf4
    # block 0x0048bcf6: entered by fall-through of jne at 0x0048bcf4, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0048bd35
    movsx eax, word ptr [0x5c39e3]               # 0048bcf6
    push eax                                     # 0048bcfd
    mov ecx, dword ptr [0x5bb57b]                # 0048bcfe
    push ecx                                     # 0048bd04
    push 0x54e5c4                                # 0048bd05
    push 0x63888b                                # 0048bd0a
    call FUN_0050ca3e                            # 0048bd0f
    add esp, 0x10                                # 0048bd14
    push 0x63888b                                # 0048bd17
    push 0x54e5f0                                # 0048bd1c
    mov ecx, 0x583979                            # 0048bd21
    call FUN_0042639d                            # 0048bd26
    mov ecx, 0x5cf659                            # 0048bd2b
    call FUN_004c97b4                            # 0048bd30
L_0048bd35:
    # block 0x0048bd35: entered by jne at 0x0048bcf4, 26 instruction(s), ends with je to 0x0048bd89 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0048bd35
    mov edx, dword ptr [ebp + arg_c]             # 0048bd39
    mov esi, dword ptr [edx]                     # 0048bd3c
    mov eax, dword ptr [ebp + arg_8]             # 0048bd3e
    mov edi, dword ptr [eax]                     # 0048bd41
    {load} mov edx, ecx                          # 0048bd43
    shr ecx, 0x2                                 # 0048bd45
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048bd48
    {load} mov ecx, edx                          # 0048bd4a
    and ecx, 0x3                                 # 0048bd4c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048bd4f
    movsx eax, word ptr [ebp - local_8]          # 0048bd51
    mov ecx, dword ptr [ebp + arg_10]            # 0048bd55
    mov edx, dword ptr [ecx]                     # 0048bd58
    {load} add edx, eax                          # 0048bd5a
    mov eax, dword ptr [ebp + arg_10]            # 0048bd5c
    mov dword ptr [eax], edx                     # 0048bd5f
    movsx ecx, word ptr [ebp - local_8]          # 0048bd61
    mov edx, dword ptr [ebp + arg_c]             # 0048bd65
    mov eax, dword ptr [edx]                     # 0048bd68
    {load} add eax, ecx                          # 0048bd6a
    mov ecx, dword ptr [ebp + arg_c]             # 0048bd6c
    mov dword ptr [ecx], eax                     # 0048bd6f
    movsx edx, word ptr [0x63a4cd]               # 0048bd71
    test edx, edx                                # 0048bd78
    je.d8 L_0048bd89                             # 0048bd7a
    # block 0x0048bd7c: entered by fall-through of je at 0x0048bd7a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0048bd89
    push 0x54e60c                                # 0048bd7c
    call FUN_0044a2b7                            # 0048bd81
    add esp, 0x4                                 # 0048bd86
L_0048bd89:
    # block 0x0048bd89: entered by je at 0x0048bd7a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0048bd89
    pop esi                                      # 0048bd8a
    {load} mov esp, ebp                          # 0048bd8b
    pop ebp                                      # 0048bd8d
    ret 0xc                                      # 0048bd8e

