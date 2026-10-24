# FUN_0044a412
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a412
# extent:       0x0044a412-0x0044a488 (118 code bytes)
# span:         0x0044a412-0x0044a488 (code 118, tables 0, padding 0)
# sha256:       678231876e5230a719c4fc0ba3331194c30cc19162e62820ef7a2e023e48b5de
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44a412_lifted
# naming:       native port src/original_methods_fl40.c:m44a412_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 8 seeds; oracle 46/46 instructions, 10/10 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d8e0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44a412_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)

.org 0x0044a412 - 0x401000
.globl FUN_0044a412
FUN_0044a412:
    # block 0x0044a412: entry, 11 instruction(s), ends with ja to 0x0044a47c (forward)
    push ebp                                     # 0044a412
    {load} mov ebp, esp                          # 0044a413
    push edi                                     # 0044a415
    mov edi, dword ptr [ebp + arg_8]             # 0044a416
    or ecx, -0x1                                 # 0044a419
    {load} xor eax, eax                          # 0044a41c
    repne scasb al, byte ptr es:[edi]            # 0044a41e
    not ecx                                      # 0044a420
    add ecx, -0x1                                # 0044a422
    cmp ecx, 0x8                                 # 0044a425
    ja.d8 L_0044a47c                             # 0044a428
    # block 0x0044a42a: entered by fall-through of ja at 0x0044a428, 8 instruction(s), ends with je to 0x0044a47c (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0044a42a
    or ecx, -0x1                                 # 0044a42d
    {load} xor eax, eax                          # 0044a430
    repne scasb al, byte ptr es:[edi]            # 0044a432
    not ecx                                      # 0044a434
    add ecx, -0x1                                # 0044a436
    test ecx, ecx                                # 0044a439
    je.d8 L_0044a47c                             # 0044a43b
    # block 0x0044a43d: entered by fall-through of je at 0x0044a43b, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a47c (forward)
    push 0x548adc                                # 0044a43d
    mov eax, dword ptr [ebp + arg_8]             # 0044a442
    push eax                                     # 0044a445
    call FUN_0050d8e0                            # 0044a446
    add esp, 0x8                                 # 0044a44b
    test eax, eax                                # 0044a44e
    jne.d8 L_0044a47c                            # 0044a450
    # block 0x0044a452: entered by fall-through of jne at 0x0044a450, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a47c (forward)
    push 0x548ae0                                # 0044a452
    mov ecx, dword ptr [ebp + arg_8]             # 0044a457
    push ecx                                     # 0044a45a
    call FUN_0050d8e0                            # 0044a45b
    add esp, 0x8                                 # 0044a460
    test eax, eax                                # 0044a463
    jne.d8 L_0044a47c                            # 0044a465
    # block 0x0044a467: entered by fall-through of jne at 0x0044a465, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0044a480 (forward)
    push 0x548ae4                                # 0044a467
    mov edx, dword ptr [ebp + arg_8]             # 0044a46c
    push edx                                     # 0044a46f
    call FUN_0050d8e0                            # 0044a470
    add esp, 0x8                                 # 0044a475
    test eax, eax                                # 0044a478
    je.d8 L_0044a480                             # 0044a47a
L_0044a47c:
    # block 0x0044a47c: entered by ja at 0x0044a428; je at 0x0044a43b; jne at 0x0044a450; jne at 0x0044a465; more, 2 instruction(s), ends with forward jump to 0x0044a485
    {load} xor eax, eax                          # 0044a47c
    jmp.d8 L_0044a485                            # 0044a47e
L_0044a480:
    # block 0x0044a480: entered by je at 0x0044a47a, 1 instruction(s), falls into the block at 0x0044a485
    mov eax, 0x1                                 # 0044a480
L_0044a485:
    # block 0x0044a485: entered by jmp at 0x0044a47e, 3 instruction(s), ends with ret
    pop edi                                      # 0044a485
    pop ebp                                      # 0044a486
    ret                                          # 0044a487

