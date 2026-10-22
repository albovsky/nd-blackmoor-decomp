# FUN_004afe09
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afe09
# extent:       0x004afe09-0x004afec1 (184 code bytes)
# span:         0x004afe09-0x004afec1 (code 184, tables 0, padding 0)
# sha256:       fbdd8123acdfc374c3bd7959f2f832a73d8843362fe2d9794522a543d8aaa80d
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4afe09_clone_record
# naming:       native port src/original_methods_fl39b.c:m4afe09_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x37c bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0x37c bytes (rep movsd) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m4afe09_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004afe09 - 0x401000
.globl FUN_004afe09
FUN_004afe09:
    # block 0x004afe09: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004afe70 (forward)
    push ebp                                     # 004afe09
    {load} mov ebp, esp                          # 004afe0a
    sub esp, 0x8                                 # 004afe0c
    push esi                                     # 004afe0f
    push edi                                     # 004afe10
    mov dword ptr [ebp - local_8], ecx           # 004afe11
    push 0x37c                                   # 004afe14
    call FUN_0051dc43                            # 004afe19
    add esp, 0x4                                 # 004afe1e
    mov dword ptr [ebp - local_4], eax           # 004afe21
    mov eax, dword ptr [ebp + arg_8]             # 004afe24
    mov ecx, dword ptr [ebp - local_4]           # 004afe27
    mov dword ptr [eax], ecx                     # 004afe2a
    cmp dword ptr [ebp - local_4], 0x0           # 004afe2c
    jne.d8 L_004afe70                            # 004afe30
    # block 0x004afe32: entered by fall-through of jne at 0x004afe30, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004afe70
    movsx edx, word ptr [0x5c39e3]               # 004afe32
    push edx                                     # 004afe39
    mov eax, dword ptr [0x5bb57b]                # 004afe3a
    push eax                                     # 004afe3f
    push 0x5516e8                                # 004afe40
    push 0x63888b                                # 004afe45
    call FUN_0050ca3e                            # 004afe4a
    add esp, 0x10                                # 004afe4f
    push 0x63888b                                # 004afe52
    push 0x551714                                # 004afe57
    mov ecx, 0x583979                            # 004afe5c
    call FUN_0042639d                            # 004afe61
    mov ecx, 0x5cf659                            # 004afe66
    call FUN_004c97b4                            # 004afe6b
L_004afe70:
    # block 0x004afe70: entered by jne at 0x004afe30, 19 instruction(s), ends with je to 0x004afeb9 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004afe70
    mov esi, dword ptr [ecx]                     # 004afe73
    mov edx, dword ptr [ebp + arg_8]             # 004afe75
    mov edi, dword ptr [edx]                     # 004afe78
    mov ecx, 0xdf                                # 004afe7a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004afe7f
    mov eax, dword ptr [ebp + arg_10]            # 004afe81
    mov ecx, dword ptr [eax]                     # 004afe84
    add ecx, 0x37c                               # 004afe86
    mov edx, dword ptr [ebp + arg_10]            # 004afe8c
    mov dword ptr [edx], ecx                     # 004afe8f
    mov eax, dword ptr [ebp + arg_c]             # 004afe91
    mov ecx, dword ptr [eax]                     # 004afe94
    add ecx, 0x37c                               # 004afe96
    mov edx, dword ptr [ebp + arg_c]             # 004afe9c
    mov dword ptr [edx], ecx                     # 004afe9f
    movsx eax, word ptr [0x63a4cd]               # 004afea1
    test eax, eax                                # 004afea8
    je.d8 L_004afeb9                             # 004afeaa
    # block 0x004afeac: entered by fall-through of je at 0x004afeaa, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004afeb9
    push 0x551730                                # 004afeac
    call FUN_0044a2b7                            # 004afeb1
    add esp, 0x4                                 # 004afeb6
L_004afeb9:
    # block 0x004afeb9: entered by je at 0x004afeaa, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004afeb9
    pop esi                                      # 004afeba
    {load} mov esp, ebp                          # 004afebb
    pop ebp                                      # 004afebd
    ret 0xc                                      # 004afebe

