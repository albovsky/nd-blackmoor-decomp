# FUN_00475964
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475964
# extent:       0x00475964-0x00475a1e (186 code bytes)
# span:         0x00475964-0x00475a1e (code 186, tables 0, padding 0)
# sha256:       ce598de44f833f9f18d7dc26408fc07155d1a5b0133f7db1431132a4730b265f
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_e4_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_e4_runtime.h:18 says "0x475964 loader (0x40b34a, 0x4105f0): copies the 2034-byte typed body"
# name-note:    Loader for raw 0xe4 rows: copies the 2034-byte typed body into a fresh row allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x00475964 - 0x401000
.globl FUN_00475964
FUN_00475964:
    # block 0x00475964: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004759cb (forward)
    push ebp                                     # 00475964
    {load} mov ebp, esp                          # 00475965
    sub esp, 0x8                                 # 00475967
    push esi                                     # 0047596a
    push edi                                     # 0047596b
    mov dword ptr [ebp - local_8], ecx           # 0047596c
    push 0x7f2                                   # 0047596f
    call FUN_0051dc43                            # 00475974
    add esp, 0x4                                 # 00475979
    mov dword ptr [ebp - local_4], eax           # 0047597c
    mov eax, dword ptr [ebp + arg_8]             # 0047597f
    mov ecx, dword ptr [ebp - local_4]           # 00475982
    mov dword ptr [eax], ecx                     # 00475985
    cmp dword ptr [ebp - local_4], 0x0           # 00475987
    jne.d8 L_004759cb                            # 0047598b
    # block 0x0047598d: entered by fall-through of jne at 0x0047598b, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004759cb
    movsx edx, word ptr [0x5c39e3]               # 0047598d
    push edx                                     # 00475994
    mov eax, dword ptr [0x5bb57b]                # 00475995
    push eax                                     # 0047599a
    push 0x54c7cc                                # 0047599b
    push 0x63888b                                # 004759a0
    call FUN_0050ca3e                            # 004759a5
    add esp, 0x10                                # 004759aa
    push 0x63888b                                # 004759ad
    push 0x54c7f8                                # 004759b2
    mov ecx, 0x583979                            # 004759b7
    call FUN_0042639d                            # 004759bc
    mov ecx, 0x5cf659                            # 004759c1
    call FUN_004c97b4                            # 004759c6
L_004759cb:
    # block 0x004759cb: entered by jne at 0x0047598b, 20 instruction(s), ends with je to 0x00475a16 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004759cb
    mov esi, dword ptr [ecx]                     # 004759ce
    mov edx, dword ptr [ebp + arg_8]             # 004759d0
    mov edi, dword ptr [edx]                     # 004759d3
    mov ecx, 0x1fc                               # 004759d5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004759da
    movsw word ptr es:[edi], word ptr [esi]      # 004759dc
    mov eax, dword ptr [ebp + arg_10]            # 004759de
    mov ecx, dword ptr [eax]                     # 004759e1
    add ecx, 0x7f2                               # 004759e3
    mov edx, dword ptr [ebp + arg_10]            # 004759e9
    mov dword ptr [edx], ecx                     # 004759ec
    mov eax, dword ptr [ebp + arg_c]             # 004759ee
    mov ecx, dword ptr [eax]                     # 004759f1
    add ecx, 0x7f2                               # 004759f3
    mov edx, dword ptr [ebp + arg_c]             # 004759f9
    mov dword ptr [edx], ecx                     # 004759fc
    movsx eax, word ptr [0x63a4cd]               # 004759fe
    test eax, eax                                # 00475a05
    je.d8 L_00475a16                             # 00475a07
    # block 0x00475a09: entered by fall-through of je at 0x00475a07, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00475a16
    push 0x54c814                                # 00475a09
    call FUN_0044a2b7                            # 00475a0e
    add esp, 0x4                                 # 00475a13
L_00475a16:
    # block 0x00475a16: entered by je at 0x00475a07, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00475a16
    pop esi                                      # 00475a17
    {load} mov esp, ebp                          # 00475a18
    pop ebp                                      # 00475a1a
    ret 0xc                                      # 00475a1b

