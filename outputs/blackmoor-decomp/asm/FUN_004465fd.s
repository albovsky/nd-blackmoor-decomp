# FUN_004465fd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004465fd
# extent:       0x004465fd-0x00446688 (139 code bytes)
# span:         0x004465fd-0x00446688 (code 139, tables 0, padding 0)
# sha256:       844a1a1166c091d313d1b0ae2a3add07dfaabd55c50bd865211777e85f158c37
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4465fd_new_zeroed
# naming:       native port src/original_methods_fl38c.c:m4465fd_new_zeroed (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(size) stored at *out; p == 0: report with fmt 0x54824c, 0x4264e8, debug 0x44a2b7, 0x4c97b4 (returns); else size bytes zeroed. 45/45 instructions, 4/4 jump ways.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m4465fd_new_zeroed (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004465fd - 0x401000
.globl FUN_004465fd
FUN_004465fd:
    # block 0x004465fd: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00446669 (forward)
    push ebp                                     # 004465fd
    {load} mov ebp, esp                          # 004465fe
    sub esp, 0x8                                 # 00446600
    push edi                                     # 00446603
    mov dword ptr [ebp - local_8], ecx           # 00446604
    mov eax, dword ptr [ebp + arg_c]             # 00446607
    push eax                                     # 0044660a
    call FUN_0051dc43                            # 0044660b
    add esp, 0x4                                 # 00446610
    mov dword ptr [ebp - local_4], eax           # 00446613
    mov ecx, dword ptr [ebp + arg_8]             # 00446616
    mov edx, dword ptr [ebp - local_4]           # 00446619
    mov dword ptr [ecx], edx                     # 0044661c
    cmp dword ptr [ebp - local_4], 0x0           # 0044661e
    jne.d8 L_00446669                            # 00446622
    # block 0x00446624: entered by fall-through of jne at 0x00446622, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0044665d (forward)
    push 0x54824c                                # 00446624
    push 0x63888b                                # 00446629
    call FUN_0050ca3e                            # 0044662e
    add esp, 0x8                                 # 00446633
    push 0x63888b                                # 00446636
    mov ecx, 0x583979                            # 0044663b
    call FUN_004264e8                            # 00446640
    movsx eax, word ptr [0x63a4cd]               # 00446645
    test eax, eax                                # 0044664c
    je.d8 L_0044665d                             # 0044664e
    # block 0x00446650: entered by fall-through of je at 0x0044664e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044665d
    push 0x63888b                                # 00446650
    call FUN_0044a2b7                            # 00446655
    add esp, 0x4                                 # 0044665a
L_0044665d:
    # block 0x0044665d: entered by je at 0x0044664e, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00446681
    mov ecx, 0x5cf659                            # 0044665d
    call FUN_004c97b4                            # 00446662
    jmp.d8 L_00446681                            # 00446667
L_00446669:
    # block 0x00446669: entered by jne at 0x00446622, 10 instruction(s), falls into the block at 0x00446681
    mov ecx, dword ptr [ebp + arg_c]             # 00446669
    {load} xor eax, eax                          # 0044666c
    mov edx, dword ptr [ebp + arg_8]             # 0044666e
    mov edi, dword ptr [edx]                     # 00446671
    {load} mov edx, ecx                          # 00446673
    shr ecx, 0x2                                 # 00446675
    rep stosd dword ptr es:[edi], eax            # 00446678
    {load} mov ecx, edx                          # 0044667a
    and ecx, 0x3                                 # 0044667c
    rep stosb byte ptr es:[edi], al              # 0044667f
L_00446681:
    # block 0x00446681: entered by jmp at 0x00446667, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 00446681
    {load} mov esp, ebp                          # 00446682
    pop ebp                                      # 00446684
    ret 0x8                                      # 00446685

