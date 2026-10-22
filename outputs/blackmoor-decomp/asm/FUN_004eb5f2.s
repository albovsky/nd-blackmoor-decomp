# FUN_004eb5f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb5f2
# extent:       0x004eb5f2-0x004eb70f (285 code bytes)
# span:         0x004eb5f2-0x004eb70f (code 285, tables 0, padding 0)
# sha256:       7884369d3edbec9444c08ae9879e15a745b78dc3a7be42092dc77cf1a8df6ba1
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eb5f2_lifted
# naming:       native port src/original_methods_fl39d.c:m4eb5f2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (213 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7011
# callees:      calls FUN_0052139c, FUN_004e9e84, FUN_004e0559
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4eb5f2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 61 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7011, 0x7011  # offset +0x7011

# --- external targets -----------------------------------------------
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004eb5f2 - 0x401000
.globl FUN_004eb5f2
FUN_004eb5f2:
    # block 0x004eb5f2: entry, 7 instruction(s), ends with jne to 0x004eb629 (forward)
    push ebp                                     # 004eb5f2
    {load} mov ebp, esp                          # 004eb5f3
    push ecx                                     # 004eb5f5
    mov dword ptr [ebp - local_4], ecx           # 004eb5f6
    movsx eax, word ptr [0x5c3a1b]               # 004eb5f9
    cmp eax, 0x270f                              # 004eb600
    jne.d8 L_004eb629                            # 004eb605
    # block 0x004eb607: entered by fall-through of jne at 0x004eb605, 3 instruction(s), ends with je to 0x004eb620 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004eb607
    test ecx, ecx                                # 004eb60e
    je.d8 L_004eb620                             # 004eb610
    # block 0x004eb612: entered by fall-through of je at 0x004eb610, 4 instruction(s), calls FUN_0052139c, falls into the block at 0x004eb620
    push 0x0                                     # 004eb612
    push 0x0                                     # 004eb614
    push 0x55cbc8                                # 004eb616
    call FUN_0052139c                            # 004eb61b
L_004eb620:
    # block 0x004eb620: entered by je at 0x004eb610, 1 instruction(s), falls into the block at 0x004eb629
    mov word ptr [0x5c3a1b], 0x0                 # 004eb620
L_004eb629:
    # block 0x004eb629: entered by jne at 0x004eb605, 18 instruction(s), ends with jne to 0x004eb6a1 (forward)
    movsx edx, word ptr [0x5c3a1d]               # 004eb629
    mov dword ptr [0x5bb57b], edx                # 004eb630
    movsx eax, word ptr [0x5c3a1d]               # 004eb636
    mov dword ptr [0x5bb57f], eax                # 004eb63d
    mov cx, word ptr [0x5c3a1f]                  # 004eb642
    mov word ptr [0x5bb599], cx                  # 004eb649
    mov dx, word ptr [0x5c3a21]                  # 004eb650
    mov word ptr [0x5bb595], dx                  # 004eb657
    mov eax, dword ptr [0x5c3a25]                # 004eb65e
    mov dword ptr [0x5bb59b], eax                # 004eb663
    mov ecx, dword ptr [0x5c3a29]                # 004eb668
    mov dword ptr [0x5bb59f], ecx                # 004eb66e
    mov edx, dword ptr [0x5c3a2d]                # 004eb674
    mov dword ptr [0x5bb5a3], edx                # 004eb67a
    mov word ptr [0x5c39ff], 0x1                 # 004eb680
    movsx eax, word ptr [0x5c3a23]               # 004eb689
    cmp eax, 0x1                                 # 004eb690
    jne.d8 L_004eb6a1                            # 004eb693
    # block 0x004eb695: entered by fall-through of jne at 0x004eb693, 2 instruction(s), ends with forward jump to 0x004eb6ab
    mov dword ptr [0x5bb1ca], 0x0                # 004eb695
    jmp.d8 L_004eb6ab                            # 004eb69f
L_004eb6a1:
    # block 0x004eb6a1: entered by jne at 0x004eb693, 1 instruction(s), falls into the block at 0x004eb6ab
    mov dword ptr [0x5bb1ca], 0x1                # 004eb6a1
L_004eb6ab:
    # block 0x004eb6ab: entered by jmp at 0x004eb69f, 3 instruction(s), ends with je to 0x004eb6d9 (forward)
    movsx ecx, word ptr [0x583f1d]               # 004eb6ab
    cmp ecx, -0x1                                # 004eb6b2
    je.d8 L_004eb6d9                             # 004eb6b5
    # block 0x004eb6b7: entered by fall-through of je at 0x004eb6b5, 10 instruction(s), calls FUN_004e9e84, FUN_004e0559, falls into the block at 0x004eb6d9
    push 0x0                                     # 004eb6b7
    mov dx, word ptr [0x583f1d]                  # 004eb6b9
    push edx                                     # 004eb6c0
    mov ecx, dword ptr [ebp - local_4]           # 004eb6c1
    call FUN_004e9e84                            # 004eb6c4
    push 0x0                                     # 004eb6c9
    push 0x0                                     # 004eb6cb
    push 0x1                                     # 004eb6cd
    mov ecx, 0x570508                            # 004eb6cf
    call FUN_004e0559                            # 004eb6d4
L_004eb6d9:
    # block 0x004eb6d9: entered by je at 0x004eb6b5, 8 instruction(s), ends with jne to 0x004eb70b (forward)
    mov dword ptr [0x583999], 0x4                # 004eb6d9
    mov word ptr [0x5c3a1b], 0x270f              # 004eb6e3
    mov word ptr [0x5c3a1d], 0x270f              # 004eb6ec
    mov eax, dword ptr [ebp - local_4]           # 004eb6f5
    {load} xor ecx, ecx                          # 004eb6f8
    mov cl, byte ptr [eax + field_7011]          # 004eb6fa
    test ecx, ecx                                # 004eb700
    jne.d8 L_004eb70b                            # 004eb702
    # block 0x004eb704: entered by fall-through of jne at 0x004eb702, 1 instruction(s), falls into the block at 0x004eb70b
    mov byte ptr [0x583232], 0x1                 # 004eb704
L_004eb70b:
    # block 0x004eb70b: entered by jne at 0x004eb702, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004eb70b
    pop ebp                                      # 004eb70d
    ret                                          # 004eb70e

