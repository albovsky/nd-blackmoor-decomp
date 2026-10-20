# FUN_0042e493
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e493
# extent:       0x0042e493-0x0042e560 (205 code bytes)
# span:         0x0042e493-0x0042e560 (code 205, tables 0, padding 0)
# sha256:       ad863a5b6157f199732eb975d2f9f9e99ebf6e539ae56df7868eedb397dd1b69
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42e493_take_pending
# naming:       native port src/original_methods_fl28b.c:m42e493_take_pending (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Takes the pending state: the 0x270f sentinel branch with its two calls, and the latch of nine globals with the sign-extended word compare; every instruction and both directions of every jump executed. See tasks/fl28b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m42e493_take_pending (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042e493 - 0x401000
.globl FUN_0042e493
FUN_0042e493:
    # block 0x0042e493: entry, 5 instruction(s), ends with jne to 0x0042e4c1 (forward)
    push ebp                                     # 0042e493
    {load} mov ebp, esp                          # 0042e494
    movsx eax, word ptr [0x5c3a05]               # 0042e496
    cmp eax, 0x270f                              # 0042e49d
    jne.d8 L_0042e4c1                            # 0042e4a2
    # block 0x0042e4a4: entered by fall-through of jne at 0x0042e4a2, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042e55e
    push 0x0                                     # 0042e4a4
    push 0x0                                     # 0042e4a6
    push 0x5459dc                                # 0042e4a8
    call FUN_0052139c                            # 0042e4ad
    mov ecx, 0x5cf659                            # 0042e4b2
    call FUN_004c97b4                            # 0042e4b7
    jmp.d32 L_0042e55e                           # 0042e4bc
L_0042e4c1:
    # block 0x0042e4c1: entered by jne at 0x0042e4a2, 18 instruction(s), ends with jne to 0x0042e538 (forward)
    movsx ecx, word ptr [0x5c3a07]               # 0042e4c1
    mov dword ptr [0x5bb57b], ecx                # 0042e4c8
    movsx edx, word ptr [0x5c3a07]               # 0042e4ce
    mov dword ptr [0x5bb57f], edx                # 0042e4d5
    mov ax, word ptr [0x5c3a09]                  # 0042e4db
    mov word ptr [0x5bb599], ax                  # 0042e4e1
    mov cx, word ptr [0x5c3a0b]                  # 0042e4e7
    mov word ptr [0x5bb595], cx                  # 0042e4ee
    mov edx, dword ptr [0x5c3a0f]                # 0042e4f5
    mov dword ptr [0x5bb59b], edx                # 0042e4fb
    mov eax, dword ptr [0x5c3a13]                # 0042e501
    mov dword ptr [0x5bb59f], eax                # 0042e506
    mov ecx, dword ptr [0x5c3a17]                # 0042e50b
    mov dword ptr [0x5bb5a3], ecx                # 0042e511
    mov word ptr [0x5c39ff], 0x1                 # 0042e517
    movsx edx, word ptr [0x5c3a0d]               # 0042e520
    cmp edx, 0x1                                 # 0042e527
    jne.d8 L_0042e538                            # 0042e52a
    # block 0x0042e52c: entered by fall-through of jne at 0x0042e52a, 2 instruction(s), ends with forward jump to 0x0042e542
    mov dword ptr [0x5bb1ca], 0x0                # 0042e52c
    jmp.d8 L_0042e542                            # 0042e536
L_0042e538:
    # block 0x0042e538: entered by jne at 0x0042e52a, 1 instruction(s), falls into the block at 0x0042e542
    mov dword ptr [0x5bb1ca], 0x1                # 0042e538
L_0042e542:
    # block 0x0042e542: entered by jmp at 0x0042e536, 3 instruction(s), falls into the block at 0x0042e55e
    mov dword ptr [0x583999], 0x4                # 0042e542
    mov word ptr [0x5c3a05], 0x270f              # 0042e54c
    mov word ptr [0x5c3a07], 0x270f              # 0042e555
L_0042e55e:
    # block 0x0042e55e: entered by jmp at 0x0042e4bc, 2 instruction(s), ends with ret
    pop ebp                                      # 0042e55e
    ret                                          # 0042e55f

