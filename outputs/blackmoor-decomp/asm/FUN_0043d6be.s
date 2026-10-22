# FUN_0043d6be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043d6be
# extent:       0x0043d6be-0x0043d7c4 (262 code bytes)
# span:         0x0043d6be-0x0043d7c4 (code 262, tables 0, padding 0)
# sha256:       56d46fec94a08eb09e15cc08286cb3e0b901521381b361c1eaf78c77d03b6f68
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43d6be_lifted
# naming:       native port src/original_methods_fl40.c:m43d6be_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 52/52 instructions executed, 8/8 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0043d7c4, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43d6be_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0043d7c4, .text + (0x0043d7c4 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0043d6be - 0x401000
.globl FUN_0043d6be
FUN_0043d6be:
    # block 0x0043d6be: entry, 4 instruction(s), ends with jne to 0x0043d6cf (forward)
    push ebp                                     # 0043d6be
    {load} mov ebp, esp                          # 0043d6bf
    cmp dword ptr [0x63a4d9], 0x0                # 0043d6c1
    jne.d8 L_0043d6cf                            # 0043d6c8
    # block 0x0043d6ca: entered by fall-through of jne at 0x0043d6c8, 1 instruction(s), ends with forward jump to 0x0043d7c2
    jmp.d32 L_0043d7c2                           # 0043d6ca
L_0043d6cf:
    # block 0x0043d6cf: entered by jne at 0x0043d6c8, 6 instruction(s), ends with jge to 0x0043d6f7 (forward)
    mov eax, dword ptr [0x63a4e9]                # 0043d6cf
    add eax, 0x1                                 # 0043d6d4
    mov dword ptr [0x63a4e9], eax                # 0043d6d7
    mov ecx, dword ptr [0x63a4e9]                # 0043d6dc
    cmp ecx, dword ptr [0x63a4e5]                # 0043d6e2
    jge.d8 L_0043d6f7                            # 0043d6e8
    # block 0x0043d6ea: entered by fall-through of jge at 0x0043d6e8, 2 instruction(s), ends with je to 0x0043d7c2 (forward)
    cmp dword ptr [0x583999], 0x3                # 0043d6ea
    je.d32 L_0043d7c2                            # 0043d6f1
L_0043d6f7:
    # block 0x0043d6f7: entered by jge at 0x0043d6e8; fall-through of je at 0x0043d6f1, 17 instruction(s), calls FUN_0050ca3e, FUN_0043d7c4, ends with jle to 0x0043d775 (forward)
    mov edx, dword ptr [0x63a4e9]                # 0043d6f7
    push edx                                     # 0043d6fd
    mov eax, dword ptr [0x63a4ed]                # 0043d6fe
    push eax                                     # 0043d703
    push 0x5475e0                                # 0043d704
    push 0x63888b                                # 0043d709
    call FUN_0050ca3e                            # 0043d70e
    add esp, 0x10                                # 0043d713
    push 0x63888b                                # 0043d716
    call FUN_0043d7c4                            # 0043d71b
    add esp, 0x4                                 # 0043d720
    mov ecx, dword ptr [0x63a4ed]                # 0043d723
    add ecx, 0x1                                 # 0043d729
    mov dword ptr [0x63a4ed], ecx                # 0043d72c
    mov edx, dword ptr [0x63a4ed]                # 0043d732
    cmp edx, dword ptr [0x63a4e1]                # 0043d738
    jle.d8 L_0043d775                            # 0043d73e
    # block 0x0043d740: entered by fall-through of jle at 0x0043d73e, 11 instruction(s), calls FUN_0050ca3e, FUN_0043d7c4, FUN_004c97b4, ends with forward jump to 0x0043d7c2
    push 0x547608                                # 0043d740
    push 0x63888b                                # 0043d745
    call FUN_0050ca3e                            # 0043d74a
    add esp, 0x8                                 # 0043d74f
    push 0x63888b                                # 0043d752
    call FUN_0043d7c4                            # 0043d757
    add esp, 0x4                                 # 0043d75c
    mov dword ptr [0x5bb20c], 0x1                # 0043d75f
    mov ecx, 0x5cf659                            # 0043d769
    call FUN_004c97b4                            # 0043d76e
    jmp.d8 L_0043d7c2                            # 0043d773
L_0043d775:
    # block 0x0043d775: entered by jle at 0x0043d73e, 9 instruction(s), falls into the block at 0x0043d7c2
    mov eax, dword ptr [0x63a4ed]                # 0043d775
    mov dword ptr [0x5bb57b], eax                # 0043d77a
    mov word ptr [0x5bb599], 0x0                 # 0043d77f
    mov word ptr [0x5bb595], 0x0                 # 0043d788
    mov word ptr [0x5c39ff], 0x0                 # 0043d791
    mov dword ptr [0x5bb59b], 0x0                # 0043d79a
    mov dword ptr [0x5bb59f], 0x0                # 0043d7a4
    mov dword ptr [0x5bb5a3], 0x1                # 0043d7ae
    mov dword ptr [0x583999], 0x4                # 0043d7b8
L_0043d7c2:
    # block 0x0043d7c2: entered by jmp at 0x0043d6ca; je at 0x0043d6f1; jmp at 0x0043d773, 2 instruction(s), ends with ret
    pop ebp                                      # 0043d7c2
    ret                                          # 0043d7c3

