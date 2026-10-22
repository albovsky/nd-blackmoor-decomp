# FUN_004d0c57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0c57
# extent:       0x004d0c57-0x004d0d06 (175 code bytes)
# span:         0x004d0c57-0x004d0d06 (code 175, tables 0, padding 0)
# sha256:       408c5e2cbc06736f50a93b75f7649ed14483c6187816ad1c2485a2260bee6bd9
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d0c57_log_loop
# naming:       native port src/original_methods_fl39e.c:m4d0c57_log_loop (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Loops i = 0..0 (signed word counter) and for each i calls 0x4c5377 with the first argument set (global [0x5d2d03], strings 0x55a0f8 / i*16 + table 0x5affd2). All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4d0c57_log_loop (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 50 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0c57 - 0x401000
.globl FUN_004d0c57
FUN_004d0c57:
    # block 0x004d0c57: entry, 5 instruction(s), ends with forward jump to 0x004d0c6f
    push ebp                                     # 004d0c57
    {load} mov ebp, esp                          # 004d0c58
    push ecx                                     # 004d0c5a
    mov word ptr [ebp - local_4], 0x0            # 004d0c5b
    jmp.d8 L_004d0c6f                            # 004d0c61
L_004d0c63:
    # block 0x004d0c63: entered by jmp at 0x004d0cfd, 3 instruction(s), falls into the block at 0x004d0c6f
    mov ax, word ptr [ebp - local_4]             # 004d0c63
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0c67
    mov word ptr [ebp - local_4], ax             # 004d0c6b
L_004d0c6f:
    # block 0x004d0c6f: entered by jmp at 0x004d0c61, 3 instruction(s), ends with jge to 0x004d0d02 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d0c6f
    cmp ecx, 0x1                                 # 004d0c73
    jge.d32 L_004d0d02                           # 004d0c76
    # block 0x004d0c7c: entered by fall-through of jge at 0x004d0c76, 4 instruction(s), ends with jne to 0x004d0cc5 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004d0c7c
    movsx eax, word ptr [0x5b0010]               # 004d0c80
    {load} cmp edx, eax                          # 004d0c87
    jne.d8 L_004d0cc5                            # 004d0c89
    # block 0x004d0c8b: entered by fall-through of jne at 0x004d0c89, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d0cfd
    push 0x55a0f8                                # 004d0c8b
    movsx ecx, word ptr [ebp - local_4]          # 004d0c90
    shl ecx, 0x4                                 # 004d0c94
    add ecx, 0x5affd2                            # 004d0c97
    push ecx                                     # 004d0c9d
    movsx edx, word ptr [ebp - local_4]          # 004d0c9e
    shl edx, 0x4                                 # 004d0ca2
    add edx, 0x5afff2                            # 004d0ca5
    push edx                                     # 004d0cab
    mov eax, dword ptr [0x5cf665]                # 004d0cac
    push eax                                     # 004d0cb1
    mov ecx, dword ptr [0x5d2d03]                # 004d0cb2
    push ecx                                     # 004d0cb8
    mov ecx, 0x5cf659                            # 004d0cb9
    call FUN_004c5377                            # 004d0cbe
    jmp.d8 L_004d0cfd                            # 004d0cc3
L_004d0cc5:
    # block 0x004d0cc5: entered by jne at 0x004d0c89, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004d0cfd
    push 0x55a118                                # 004d0cc5
    movsx edx, word ptr [ebp - local_4]          # 004d0cca
    shl edx, 0x4                                 # 004d0cce
    add edx, 0x5affd2                            # 004d0cd1
    push edx                                     # 004d0cd7
    movsx eax, word ptr [ebp - local_4]          # 004d0cd8
    shl eax, 0x4                                 # 004d0cdc
    add eax, 0x5affd2                            # 004d0cdf
    push eax                                     # 004d0ce4
    mov ecx, dword ptr [0x5cf665]                # 004d0ce5
    push ecx                                     # 004d0ceb
    mov edx, dword ptr [0x5d2bdb]                # 004d0cec
    push edx                                     # 004d0cf2
    mov ecx, 0x5cf659                            # 004d0cf3
    call FUN_004c5377                            # 004d0cf8
L_004d0cfd:
    # block 0x004d0cfd: entered by jmp at 0x004d0cc3, 1 instruction(s), ends with backward jump to 0x004d0c63
    jmp.d32 L_004d0c63                           # 004d0cfd
L_004d0d02:
    # block 0x004d0d02: entered by jge at 0x004d0c76, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0d02
    pop ebp                                      # 004d0d04
    ret                                          # 004d0d05

