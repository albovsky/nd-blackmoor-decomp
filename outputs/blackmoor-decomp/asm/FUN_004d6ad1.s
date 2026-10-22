# FUN_004d6ad1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d6ad1
# extent:       0x004d6ad1-0x004d6b48 (119 code bytes)
# span:         0x004d6ad1-0x004d6b48 (code 119, tables 0, padding 0)
# sha256:       3e3f905ac3adbc5d644ab2d5dd08ece8f03dcaea9951ed8fb6db7812c3f49f56
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d6ad1_start_timer
# naming:       native port src/original_methods_fl39f.c:m4d6ad1_start_timer (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Reads the tick count once (the import slot 0x52a23c is an ordered call-log event), stores now + the sign-extended word [self+0x2cc] at [self+0x465] and the string length of [self+0x96d3]. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_461, field_46d; [ecx + n] field_2cc, field_465, field_46e; [edx + n] field_469, field_472
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4d6ad1_start_timer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2cc, 0x2cc  # offset +0x2cc
.equ field_461, 0x461  # offset +0x461
.equ field_465, 0x465  # offset +0x465
.equ field_469, 0x469  # offset +0x469
.equ field_46d, 0x46d  # offset +0x46d
.equ field_46e, 0x46e  # offset +0x46e
.equ field_472, 0x472  # offset +0x472

# --- external targets -----------------------------------------------

.org 0x004d6ad1 - 0x401000
.globl FUN_004d6ad1
FUN_004d6ad1:
    # block 0x004d6ad1: entry, 32 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret
    push ebp                                     # 004d6ad1
    {load} mov ebp, esp                          # 004d6ad2
    push ecx                                     # 004d6ad4
    push edi                                     # 004d6ad5
    mov dword ptr [ebp - local_4], ecx           # 004d6ad6
    mov eax, dword ptr [ebp - local_4]           # 004d6ad9
    mov dword ptr [eax + field_461], 0x0         # 004d6adc
    call dword ptr [0x52a23c]                    # 004d6ae6
    mov ecx, dword ptr [ebp - local_4]           # 004d6aec
    movsx edx, word ptr [ecx + field_2cc]        # 004d6aef
    {load} add eax, edx                          # 004d6af6
    mov ecx, dword ptr [ebp - local_4]           # 004d6af8
    mov dword ptr [ecx + field_465], eax         # 004d6afb
    mov edi, dword ptr [ebp - local_4]           # 004d6b01
    add edi, 0x96d3                              # 004d6b04
    or ecx, -0x1                                 # 004d6b0a
    {load} xor eax, eax                          # 004d6b0d
    repne scasb al, byte ptr es:[edi]            # 004d6b0f
    not ecx                                      # 004d6b11
    add ecx, -0x1                                # 004d6b13
    mov edx, dword ptr [ebp - local_4]           # 004d6b16
    mov dword ptr [edx + field_469], ecx         # 004d6b19
    mov eax, dword ptr [ebp - local_4]           # 004d6b1f
    mov byte ptr [eax + field_46d], 0x0          # 004d6b22
    mov ecx, dword ptr [ebp - local_4]           # 004d6b29
    mov dword ptr [ecx + field_46e], 0x0         # 004d6b2c
    mov edx, dword ptr [ebp - local_4]           # 004d6b36
    mov dword ptr [edx + field_472], 0x0         # 004d6b39
    pop edi                                      # 004d6b43
    {load} mov esp, ebp                          # 004d6b44
    pop ebp                                      # 004d6b46
    ret                                          # 004d6b47

