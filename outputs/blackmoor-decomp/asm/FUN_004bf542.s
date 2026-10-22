# FUN_004bf542
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf542
# extent:       0x004bf542-0x004bf5cd (139 code bytes)
# span:         0x004bf542-0x004bf5d0 (code 139, tables 0, padding 3)
# sha256:       07538f064ebd744feac5fdcaf19cca5a2956cc39666d9086ffa9214599bc1a10
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf542_alloc_zero
# naming:       native port src/original_methods_fl39c.c:m4bf542_alloc_zero (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates `size` bytes through 0x51dc43, stores the address at [out]; on 0 runs the diagnostic path (0x50ca3e, 0x4264e8, 0x44a2b7 when the debug word is set. All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4bf542_alloc_zero (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004bf542 - 0x401000
.globl FUN_004bf542
FUN_004bf542:
    # block 0x004bf542: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004bf5ae (forward)
    push ebp                                     # 004bf542
    {load} mov ebp, esp                          # 004bf543
    sub esp, 0x8                                 # 004bf545
    push edi                                     # 004bf548
    mov dword ptr [ebp - local_8], ecx           # 004bf549
    mov eax, dword ptr [ebp + arg_c]             # 004bf54c
    push eax                                     # 004bf54f
    call FUN_0051dc43                            # 004bf550
    add esp, 0x4                                 # 004bf555
    mov dword ptr [ebp - local_4], eax           # 004bf558
    mov ecx, dword ptr [ebp + arg_8]             # 004bf55b
    mov edx, dword ptr [ebp - local_4]           # 004bf55e
    mov dword ptr [ecx], edx                     # 004bf561
    cmp dword ptr [ebp - local_4], 0x0           # 004bf563
    jne.d8 L_004bf5ae                            # 004bf567
    # block 0x004bf569: entered by fall-through of jne at 0x004bf567, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004bf5a2 (forward)
    push 0x5525ac                                # 004bf569
    push 0x63888b                                # 004bf56e
    call FUN_0050ca3e                            # 004bf573
    add esp, 0x8                                 # 004bf578
    push 0x63888b                                # 004bf57b
    mov ecx, 0x583979                            # 004bf580
    call FUN_004264e8                            # 004bf585
    movsx eax, word ptr [0x63a4cd]               # 004bf58a
    test eax, eax                                # 004bf591
    je.d8 L_004bf5a2                             # 004bf593
    # block 0x004bf595: entered by fall-through of je at 0x004bf593, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bf5a2
    push 0x63888b                                # 004bf595
    call FUN_0044a2b7                            # 004bf59a
    add esp, 0x4                                 # 004bf59f
L_004bf5a2:
    # block 0x004bf5a2: entered by je at 0x004bf593, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004bf5c6
    mov ecx, 0x5cf659                            # 004bf5a2
    call FUN_004c97b4                            # 004bf5a7
    jmp.d8 L_004bf5c6                            # 004bf5ac
L_004bf5ae:
    # block 0x004bf5ae: entered by jne at 0x004bf567, 10 instruction(s), falls into the block at 0x004bf5c6
    mov ecx, dword ptr [ebp + arg_c]             # 004bf5ae
    {load} xor eax, eax                          # 004bf5b1
    mov edx, dword ptr [ebp + arg_8]             # 004bf5b3
    mov edi, dword ptr [edx]                     # 004bf5b6
    {load} mov edx, ecx                          # 004bf5b8
    shr ecx, 0x2                                 # 004bf5ba
    rep stosd dword ptr es:[edi], eax            # 004bf5bd
    {load} mov ecx, edx                          # 004bf5bf
    and ecx, 0x3                                 # 004bf5c1
    rep stosb byte ptr es:[edi], al              # 004bf5c4
L_004bf5c6:
    # block 0x004bf5c6: entered by jmp at 0x004bf5ac, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004bf5c6
    {load} mov esp, ebp                          # 004bf5c7
    pop ebp                                      # 004bf5c9
    ret 0x8                                      # 004bf5ca

# --- data items (not part of the function) -------------------------
.org 0x004bf5cd - 0x401000
PAD_004bf5cd:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

