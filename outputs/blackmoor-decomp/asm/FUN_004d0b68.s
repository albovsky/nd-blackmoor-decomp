# FUN_004d0b68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0b68
# extent:       0x004d0b68-0x004d0c17 (175 code bytes)
# span:         0x004d0b68-0x004d0c17 (code 175, tables 0, padding 0)
# sha256:       1928da1373f96827f9773568b5dd2970c06d13cff4ffa14d71e1008206f2b619
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d0b68
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0b68 - 0x401000
.globl FUN_004d0b68
FUN_004d0b68:
    # block 0x004d0b68: entry, 5 instruction(s), ends with forward jump to 0x004d0b80
    push ebp                                     # 004d0b68
    {load} mov ebp, esp                          # 004d0b69
    push ecx                                     # 004d0b6b
    mov word ptr [ebp - local_4], 0x0            # 004d0b6c
    jmp.d8 L_004d0b80                            # 004d0b72
L_004d0b74:
    # block 0x004d0b74: entered by jmp at 0x004d0c0e, 3 instruction(s), falls into the block at 0x004d0b80
    mov ax, word ptr [ebp - local_4]             # 004d0b74
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0b78
    mov word ptr [ebp - local_4], ax             # 004d0b7c
L_004d0b80:
    # block 0x004d0b80: entered by jmp at 0x004d0b72, 3 instruction(s), ends with jge to 0x004d0c13 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d0b80
    cmp ecx, 0x9                                 # 004d0b84
    jge.d32 L_004d0c13                           # 004d0b87
    # block 0x004d0b8d: entered by fall-through of jge at 0x004d0b87, 4 instruction(s), ends with jne to 0x004d0bd6 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004d0b8d
    movsx eax, word ptr [0x5aff57]               # 004d0b91
    {load} cmp edx, eax                          # 004d0b98
    jne.d8 L_004d0bd6                            # 004d0b9a
    # block 0x004d0b9c: entered by fall-through of jne at 0x004d0b9a, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d0c0e
    push 0x55a098                                # 004d0b9c
    movsx ecx, word ptr [ebp - local_4]          # 004d0ba1
    shl ecx, 0x4                                 # 004d0ba5
    add ecx, 0x5afd05                            # 004d0ba8
    push ecx                                     # 004d0bae
    movsx edx, word ptr [ebp - local_4]          # 004d0baf
    shl edx, 0x4                                 # 004d0bb3
    add edx, 0x5afeb5                            # 004d0bb6
    push edx                                     # 004d0bbc
    mov eax, dword ptr [0x5cf665]                # 004d0bbd
    push eax                                     # 004d0bc2
    mov ecx, dword ptr [0x5d2b47]                # 004d0bc3
    push ecx                                     # 004d0bc9
    mov ecx, 0x5cf659                            # 004d0bca
    call FUN_004c5377                            # 004d0bcf
    jmp.d8 L_004d0c0e                            # 004d0bd4
L_004d0bd6:
    # block 0x004d0bd6: entered by jne at 0x004d0b9a, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004d0c0e
    push 0x55a0bc                                # 004d0bd6
    movsx edx, word ptr [ebp - local_4]          # 004d0bdb
    shl edx, 0x4                                 # 004d0bdf
    add edx, 0x5afd05                            # 004d0be2
    push edx                                     # 004d0be8
    movsx eax, word ptr [ebp - local_4]          # 004d0be9
    shl eax, 0x4                                 # 004d0bed
    add eax, 0x5afd05                            # 004d0bf0
    push eax                                     # 004d0bf5
    mov ecx, dword ptr [0x5cf665]                # 004d0bf6
    push ecx                                     # 004d0bfc
    mov edx, dword ptr [0x5d2a1f]                # 004d0bfd
    push edx                                     # 004d0c03
    mov ecx, 0x5cf659                            # 004d0c04
    call FUN_004c5377                            # 004d0c09
L_004d0c0e:
    # block 0x004d0c0e: entered by jmp at 0x004d0bd4, 1 instruction(s), ends with backward jump to 0x004d0b74
    jmp.d32 L_004d0b74                           # 004d0c0e
L_004d0c13:
    # block 0x004d0c13: entered by jge at 0x004d0b87, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0c13
    pop ebp                                      # 004d0c15
    ret                                          # 004d0c16

