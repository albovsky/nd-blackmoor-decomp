# FUN_00456fb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456fb6
# extent:       0x00456fb6-0x00457071 (187 code bytes)
# span:         0x00456fb6-0x00457071 (code 187, tables 0, padding 0)
# sha256:       17aac774aaa642f1ded5720731df1b055db62102fef7adb66af6b6108212725d
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m456fb6_clone_record
# naming:       native port src/original_methods_fl38b.c:m456fb6_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x27b) stored at *out; copies 0x27b bytes (movsw+movsb) from *in2 and advances *adv and *in2 by it; p == 0 ends in 0x4c97b4 (returns; post-call null copy not modelled). 58/58 instructions, both jne/je ways.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38b.c:m456fb6_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x00456fb6 - 0x401000
.globl FUN_00456fb6
FUN_00456fb6:
    # block 0x00456fb6: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0045701d (forward)
    push ebp                                     # 00456fb6
    {load} mov ebp, esp                          # 00456fb7
    sub esp, 0x8                                 # 00456fb9
    push esi                                     # 00456fbc
    push edi                                     # 00456fbd
    mov dword ptr [ebp - local_8], ecx           # 00456fbe
    push 0x27b                                   # 00456fc1
    call FUN_0051dc43                            # 00456fc6
    add esp, 0x4                                 # 00456fcb
    mov dword ptr [ebp - local_4], eax           # 00456fce
    mov eax, dword ptr [ebp + arg_8]             # 00456fd1
    mov ecx, dword ptr [ebp - local_4]           # 00456fd4
    mov dword ptr [eax], ecx                     # 00456fd7
    cmp dword ptr [ebp - local_4], 0x0           # 00456fd9
    jne.d8 L_0045701d                            # 00456fdd
    # block 0x00456fdf: entered by fall-through of jne at 0x00456fdd, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0045701d
    movsx edx, word ptr [0x5c39e3]               # 00456fdf
    push edx                                     # 00456fe6
    mov eax, dword ptr [0x5bb57b]                # 00456fe7
    push eax                                     # 00456fec
    push 0x54a330                                # 00456fed
    push 0x63888b                                # 00456ff2
    call FUN_0050ca3e                            # 00456ff7
    add esp, 0x10                                # 00456ffc
    push 0x63888b                                # 00456fff
    push 0x54a35c                                # 00457004
    mov ecx, 0x583979                            # 00457009
    call FUN_0042639d                            # 0045700e
    mov ecx, 0x5cf659                            # 00457013
    call FUN_004c97b4                            # 00457018
L_0045701d:
    # block 0x0045701d: entered by jne at 0x00456fdd, 21 instruction(s), ends with je to 0x00457069 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0045701d
    mov esi, dword ptr [ecx]                     # 00457020
    mov edx, dword ptr [ebp + arg_8]             # 00457022
    mov edi, dword ptr [edx]                     # 00457025
    mov ecx, 0x9e                                # 00457027
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045702c
    movsw word ptr es:[edi], word ptr [esi]      # 0045702e
    movsb byte ptr es:[edi], byte ptr [esi]      # 00457030
    mov eax, dword ptr [ebp + arg_10]            # 00457031
    mov ecx, dword ptr [eax]                     # 00457034
    add ecx, 0x27b                               # 00457036
    mov edx, dword ptr [ebp + arg_10]            # 0045703c
    mov dword ptr [edx], ecx                     # 0045703f
    mov eax, dword ptr [ebp + arg_c]             # 00457041
    mov ecx, dword ptr [eax]                     # 00457044
    add ecx, 0x27b                               # 00457046
    mov edx, dword ptr [ebp + arg_c]             # 0045704c
    mov dword ptr [edx], ecx                     # 0045704f
    movsx eax, word ptr [0x63a4cd]               # 00457051
    test eax, eax                                # 00457058
    je.d8 L_00457069                             # 0045705a
    # block 0x0045705c: entered by fall-through of je at 0x0045705a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00457069
    push 0x54a378                                # 0045705c
    call FUN_0044a2b7                            # 00457061
    add esp, 0x4                                 # 00457066
L_00457069:
    # block 0x00457069: entered by je at 0x0045705a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00457069
    pop esi                                      # 0045706a
    {load} mov esp, ebp                          # 0045706b
    pop ebp                                      # 0045706d
    ret 0xc                                      # 0045706e

