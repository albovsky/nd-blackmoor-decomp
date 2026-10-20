# FUN_004cf1e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf1e4
# extent:       0x004cf1e4-0x004cf276 (146 code bytes)
# span:         0x004cf1e4-0x004cf276 (code 146, tables 0, padding 0)
# sha256:       57fc0c8e764630811d7505589b50b6507a779ee276fd3909722ded614a7be88e
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cf1e4_alloc_clear
# naming:       native port src/original_methods_fl28c.c:m4cf1e4_alloc_clear (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4cf1e4_alloc_clear (alloc and clear, failure report). Oracle: 47/47 instructions of the 146 code bytes, 4/4 jcc directions, 240 scenarios. See tasks/fl28c-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28c.c:m4cd243_read_tables (function ledger class native_oracle_verified; also m4cf1e4_alloc_clear; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004cf1e4 - 0x401000
.globl FUN_004cf1e4
FUN_004cf1e4:
    # block 0x004cf1e4: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004cf252 (forward)
    push ebp                                     # 004cf1e4
    {load} mov ebp, esp                          # 004cf1e5
    sub esp, 0x8                                 # 004cf1e7
    push edi                                     # 004cf1ea
    mov dword ptr [ebp - local_8], ecx           # 004cf1eb
    mov eax, dword ptr [ebp + arg_c]             # 004cf1ee
    push eax                                     # 004cf1f1
    call FUN_0051dc43                            # 004cf1f2
    add esp, 0x4                                 # 004cf1f7
    mov dword ptr [ebp - local_4], eax           # 004cf1fa
    mov ecx, dword ptr [ebp + arg_8]             # 004cf1fd
    mov edx, dword ptr [ebp - local_4]           # 004cf200
    mov dword ptr [ecx], edx                     # 004cf203
    cmp dword ptr [ebp - local_4], 0x0           # 004cf205
    jne.d8 L_004cf252                            # 004cf209
    # block 0x004cf20b: entered by fall-through of jne at 0x004cf209, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cf244 (forward)
    push 0x559b94                                # 004cf20b
    push 0x63888b                                # 004cf210
    call FUN_0050ca3e                            # 004cf215
    add esp, 0x8                                 # 004cf21a
    push 0x63888b                                # 004cf21d
    mov ecx, 0x583979                            # 004cf222
    call FUN_004264e8                            # 004cf227
    movsx eax, word ptr [0x63a4cd]               # 004cf22c
    test eax, eax                                # 004cf233
    je.d8 L_004cf244                             # 004cf235
    # block 0x004cf237: entered by fall-through of je at 0x004cf235, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cf244
    push 0x63888b                                # 004cf237
    call FUN_0044a2b7                            # 004cf23c
    add esp, 0x4                                 # 004cf241
L_004cf244:
    # block 0x004cf244: entered by je at 0x004cf235, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cf26f
    mov ecx, 0x5cf659                            # 004cf244
    call FUN_004c97b4                            # 004cf249
    {load} xor eax, eax                          # 004cf24e
    jmp.d8 L_004cf26f                            # 004cf250
L_004cf252:
    # block 0x004cf252: entered by jne at 0x004cf209, 11 instruction(s), falls into the block at 0x004cf26f
    mov ecx, dword ptr [ebp + arg_c]             # 004cf252
    {load} xor eax, eax                          # 004cf255
    mov edx, dword ptr [ebp + arg_8]             # 004cf257
    mov edi, dword ptr [edx]                     # 004cf25a
    {load} mov edx, ecx                          # 004cf25c
    shr ecx, 0x2                                 # 004cf25e
    rep stosd dword ptr es:[edi], eax            # 004cf261
    {load} mov ecx, edx                          # 004cf263
    and ecx, 0x3                                 # 004cf265
    rep stosb byte ptr es:[edi], al              # 004cf268
    mov eax, 0x1                                 # 004cf26a
L_004cf26f:
    # block 0x004cf26f: entered by jmp at 0x004cf250, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004cf26f
    {load} mov esp, ebp                          # 004cf270
    pop ebp                                      # 004cf272
    ret 0x8                                      # 004cf273

