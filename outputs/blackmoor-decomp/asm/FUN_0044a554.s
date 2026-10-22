# FUN_0044a554
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a554
# extent:       0x0044a554-0x0044a5ca (118 code bytes)
# span:         0x0044a554-0x0044a5ca (code 118, tables 0, padding 0)
# sha256:       5183963a746fb7301885b1cc68f880a6797e145e68fef456b5b206aa373522f7
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44a554_lifted
# naming:       native port src/original_methods_fl40.c:m44a554_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 46/46 instructions executed, 10/10 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d8e0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44a554_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)

.org 0x0044a554 - 0x401000
.globl FUN_0044a554
FUN_0044a554:
    # block 0x0044a554: entry, 11 instruction(s), ends with ja to 0x0044a5be (forward)
    push ebp                                     # 0044a554
    {load} mov ebp, esp                          # 0044a555
    push edi                                     # 0044a557
    mov edi, dword ptr [ebp + arg_8]             # 0044a558
    or ecx, -0x1                                 # 0044a55b
    {load} xor eax, eax                          # 0044a55e
    repne scasb al, byte ptr es:[edi]            # 0044a560
    not ecx                                      # 0044a562
    add ecx, -0x1                                # 0044a564
    cmp ecx, 0x3                                 # 0044a567
    ja.d8 L_0044a5be                             # 0044a56a
    # block 0x0044a56c: entered by fall-through of ja at 0x0044a56a, 8 instruction(s), ends with je to 0x0044a5be (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0044a56c
    or ecx, -0x1                                 # 0044a56f
    {load} xor eax, eax                          # 0044a572
    repne scasb al, byte ptr es:[edi]            # 0044a574
    not ecx                                      # 0044a576
    add ecx, -0x1                                # 0044a578
    test ecx, ecx                                # 0044a57b
    je.d8 L_0044a5be                             # 0044a57d
    # block 0x0044a57f: entered by fall-through of je at 0x0044a57d, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a5be (forward)
    push 0x548af4                                # 0044a57f
    mov eax, dword ptr [ebp + arg_8]             # 0044a584
    push eax                                     # 0044a587
    call FUN_0050d8e0                            # 0044a588
    add esp, 0x8                                 # 0044a58d
    test eax, eax                                # 0044a590
    jne.d8 L_0044a5be                            # 0044a592
    # block 0x0044a594: entered by fall-through of jne at 0x0044a592, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a5be (forward)
    push 0x548af8                                # 0044a594
    mov ecx, dword ptr [ebp + arg_8]             # 0044a599
    push ecx                                     # 0044a59c
    call FUN_0050d8e0                            # 0044a59d
    add esp, 0x8                                 # 0044a5a2
    test eax, eax                                # 0044a5a5
    jne.d8 L_0044a5be                            # 0044a5a7
    # block 0x0044a5a9: entered by fall-through of jne at 0x0044a5a7, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0044a5c2 (forward)
    push 0x548afc                                # 0044a5a9
    mov edx, dword ptr [ebp + arg_8]             # 0044a5ae
    push edx                                     # 0044a5b1
    call FUN_0050d8e0                            # 0044a5b2
    add esp, 0x8                                 # 0044a5b7
    test eax, eax                                # 0044a5ba
    je.d8 L_0044a5c2                             # 0044a5bc
L_0044a5be:
    # block 0x0044a5be: entered by ja at 0x0044a56a; je at 0x0044a57d; jne at 0x0044a592; jne at 0x0044a5a7; more, 2 instruction(s), ends with forward jump to 0x0044a5c7
    {load} xor eax, eax                          # 0044a5be
    jmp.d8 L_0044a5c7                            # 0044a5c0
L_0044a5c2:
    # block 0x0044a5c2: entered by je at 0x0044a5bc, 1 instruction(s), falls into the block at 0x0044a5c7
    mov eax, 0x1                                 # 0044a5c2
L_0044a5c7:
    # block 0x0044a5c7: entered by jmp at 0x0044a5c0, 3 instruction(s), ends with ret
    pop edi                                      # 0044a5c7
    pop ebp                                      # 0044a5c8
    ret                                          # 0044a5c9

