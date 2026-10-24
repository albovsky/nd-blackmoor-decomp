# FUN_004d0afc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0afc
# extent:       0x004d0afc-0x004d0b68 (108 code bytes)
# span:         0x004d0afc-0x004d0b68 (code 108, tables 0, padding 0)
# sha256:       644882c9e15a6ebdf4c1571d6715d0eaa52c0e717178d1b62d0051f0ce26efd9
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d0afc_lifted
# naming:       native port src/original_methods_fl41.c:m4d0afc_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 33/33 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d0afc_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0afc - 0x401000
.globl FUN_004d0afc
FUN_004d0afc:
    # block 0x004d0afc: entry, 5 instruction(s), ends with forward jump to 0x004d0b14
    push ebp                                     # 004d0afc
    {load} mov ebp, esp                          # 004d0afd
    push ecx                                     # 004d0aff
    mov word ptr [ebp - local_4], 0x0            # 004d0b00
    jmp.d8 L_004d0b14                            # 004d0b06
L_004d0b08:
    # block 0x004d0b08: entered by jmp at 0x004d0b62, 3 instruction(s), falls into the block at 0x004d0b14
    mov ax, word ptr [ebp - local_4]             # 004d0b08
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0b0c
    mov word ptr [ebp - local_4], ax             # 004d0b10
L_004d0b14:
    # block 0x004d0b14: entered by jmp at 0x004d0b06, 3 instruction(s), ends with jge to 0x004d0b64 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d0b14
    cmp ecx, 0x9                                 # 004d0b18
    jge.d8 L_004d0b64                            # 004d0b1b
    # block 0x004d0b1d: entered by fall-through of jge at 0x004d0b1b, 3 instruction(s), ends with jne to 0x004d0b62 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004d0b1d
    cmp dword ptr [4*edx + 0x5aff79], 0x1        # 004d0b21
    jne.d8 L_004d0b62                            # 004d0b29
    # block 0x004d0b2b: entered by fall-through of jne at 0x004d0b29, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004d0b62
    push 0x55a070                                # 004d0b2b
    movsx eax, word ptr [ebp - local_4]          # 004d0b30
    shl eax, 0x4                                 # 004d0b34
    add eax, 0x5afd05                            # 004d0b37
    push eax                                     # 004d0b3c
    movsx ecx, word ptr [ebp - local_4]          # 004d0b3d
    shl ecx, 0x4                                 # 004d0b41
    add ecx, 0x5afe25                            # 004d0b44
    push ecx                                     # 004d0b4a
    mov edx, dword ptr [0x5cf665]                # 004d0b4b
    push edx                                     # 004d0b51
    mov eax, dword ptr [0x5d2b91]                # 004d0b52
    push eax                                     # 004d0b57
    mov ecx, 0x5cf659                            # 004d0b58
    call FUN_004c5377                            # 004d0b5d
L_004d0b62:
    # block 0x004d0b62: entered by jne at 0x004d0b29, 1 instruction(s), ends with backward jump to 0x004d0b08
    jmp.d8 L_004d0b08                            # 004d0b62
L_004d0b64:
    # block 0x004d0b64: entered by jge at 0x004d0b1b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0b64
    pop ebp                                      # 004d0b66
    ret                                          # 004d0b67

