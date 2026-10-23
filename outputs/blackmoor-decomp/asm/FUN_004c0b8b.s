# FUN_004c0b8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0b8b
# extent:       0x004c0b8b-0x004c0c18 (141 code bytes)
# span:         0x004c0b8b-0x004c0c18 (code 141, tables 0, padding 0)
# sha256:       f1ca361671dbfc5457377bb95f2ebcf503b7e51b122af294439dbb38545d8c78
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c0b8b_lifted
# naming:       native port src/original_methods_fl41.c:m4c0b8b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 38/38 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4c0b8b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004c0b8b - 0x401000
.globl FUN_004c0b8b
FUN_004c0b8b:
    # block 0x004c0b8b: entry, 38 instruction(s), ends with ret
    push ebp                                     # 004c0b8b
    {load} mov ebp, esp                          # 004c0b8c
    push ecx                                     # 004c0b8e
    push esi                                     # 004c0b8f
    push edi                                     # 004c0b90
    mov dword ptr [ebp - local_4], ecx           # 004c0b91
    mov dword ptr [0x5d19e7], 0xb                # 004c0b94
    mov dword ptr [0x5d19eb], 0x4c0d3f           # 004c0b9e
    mov dword ptr [0x5d19ef], 0x0                # 004c0ba8
    mov eax, dword ptr [ebp - local_4]           # 004c0bb2
    add eax, 0x1de                               # 004c0bb5
    mov dword ptr [0x5d19f3], eax                # 004c0bba
    mov ecx, dword ptr [ebp - local_4]           # 004c0bbf
    add ecx, 0x1ee                               # 004c0bc2
    mov dword ptr [0x5d19f7], ecx                # 004c0bc8
    mov dword ptr [0x5d19fb], 0x0                # 004c0bce
    mov dword ptr [0x5d19ff], 0x1                # 004c0bd8
    mov word ptr [0x5d1a03], 0x1                 # 004c0be2
    mov edi, 0x552b70                            # 004c0beb
    mov edx, 0x5d1a09                            # 004c0bf0
    or ecx, -0x1                                 # 004c0bf5
    {load} xor eax, eax                          # 004c0bf8
    repne scasb al, byte ptr es:[edi]            # 004c0bfa
    not ecx                                      # 004c0bfc
    {load} sub edi, ecx                          # 004c0bfe
    {load} mov esi, edi                          # 004c0c00
    {load} mov eax, ecx                          # 004c0c02
    {load} mov edi, edx                          # 004c0c04
    shr ecx, 0x2                                 # 004c0c06
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c0c09
    {load} mov ecx, eax                          # 004c0c0b
    and ecx, 0x3                                 # 004c0c0d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c0c10
    pop edi                                      # 004c0c12
    pop esi                                      # 004c0c13
    {load} mov esp, ebp                          # 004c0c14
    pop ebp                                      # 004c0c16
    ret                                          # 004c0c17

