# FUN_0045ddd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ddd0
# extent:       0x0045ddd0-0x0045de8a (186 code bytes)
# span:         0x0045ddd0-0x0045de8a (code 186, tables 0, padding 0)
# sha256:       f94571a2f85d749d5a34e28bc17837b4eb13db7f9795438d17169a51559c6424
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45ddd0_clone_record
# naming:       native port src/original_methods_fl38b.c:m45ddd0_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x1346) stored at *out; copies 0x1346 bytes (movsw) from *in2 and advances *adv and *in2 by it; p == 0 ends in 0x4c97b4 (returns; post-call null copy not modelled). 57/57 instructions, both jne/je ways.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38b.c:m45ddd0_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0045ddd0 - 0x401000
.globl FUN_0045ddd0
FUN_0045ddd0:
    # block 0x0045ddd0: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0045de37 (forward)
    push ebp                                     # 0045ddd0
    {load} mov ebp, esp                          # 0045ddd1
    sub esp, 0x8                                 # 0045ddd3
    push esi                                     # 0045ddd6
    push edi                                     # 0045ddd7
    mov dword ptr [ebp - local_8], ecx           # 0045ddd8
    push 0x1346                                  # 0045dddb
    call FUN_0051dc43                            # 0045dde0
    add esp, 0x4                                 # 0045dde5
    mov dword ptr [ebp - local_4], eax           # 0045dde8
    mov eax, dword ptr [ebp + arg_8]             # 0045ddeb
    mov ecx, dword ptr [ebp - local_4]           # 0045ddee
    mov dword ptr [eax], ecx                     # 0045ddf1
    cmp dword ptr [ebp - local_4], 0x0           # 0045ddf3
    jne.d8 L_0045de37                            # 0045ddf7
    # block 0x0045ddf9: entered by fall-through of jne at 0x0045ddf7, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0045de37
    movsx edx, word ptr [0x5c39e3]               # 0045ddf9
    push edx                                     # 0045de00
    mov eax, dword ptr [0x5bb57b]                # 0045de01
    push eax                                     # 0045de06
    push 0x54aeb8                                # 0045de07
    push 0x63888b                                # 0045de0c
    call FUN_0050ca3e                            # 0045de11
    add esp, 0x10                                # 0045de16
    push 0x63888b                                # 0045de19
    push 0x54aee4                                # 0045de1e
    mov ecx, 0x583979                            # 0045de23
    call FUN_0042639d                            # 0045de28
    mov ecx, 0x5cf659                            # 0045de2d
    call FUN_004c97b4                            # 0045de32
L_0045de37:
    # block 0x0045de37: entered by jne at 0x0045ddf7, 20 instruction(s), ends with je to 0x0045de82 (forward)
    mov ecx, 0x4d1                               # 0045de37
    mov edx, dword ptr [ebp + arg_c]             # 0045de3c
    mov esi, dword ptr [edx]                     # 0045de3f
    mov eax, dword ptr [ebp + arg_8]             # 0045de41
    mov edi, dword ptr [eax]                     # 0045de44
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045de46
    movsw word ptr es:[edi], word ptr [esi]      # 0045de48
    mov ecx, dword ptr [ebp + arg_10]            # 0045de4a
    mov edx, dword ptr [ecx]                     # 0045de4d
    add edx, 0x1346                              # 0045de4f
    mov eax, dword ptr [ebp + arg_10]            # 0045de55
    mov dword ptr [eax], edx                     # 0045de58
    mov ecx, dword ptr [ebp + arg_c]             # 0045de5a
    mov edx, dword ptr [ecx]                     # 0045de5d
    add edx, 0x1346                              # 0045de5f
    mov eax, dword ptr [ebp + arg_c]             # 0045de65
    mov dword ptr [eax], edx                     # 0045de68
    movsx ecx, word ptr [0x63a4cd]               # 0045de6a
    test ecx, ecx                                # 0045de71
    je.d8 L_0045de82                             # 0045de73
    # block 0x0045de75: entered by fall-through of je at 0x0045de73, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045de82
    push 0x54af00                                # 0045de75
    call FUN_0044a2b7                            # 0045de7a
    add esp, 0x4                                 # 0045de7f
L_0045de82:
    # block 0x0045de82: entered by je at 0x0045de73, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0045de82
    pop esi                                      # 0045de83
    {load} mov esp, ebp                          # 0045de84
    pop ebp                                      # 0045de86
    ret 0xc                                      # 0045de87

