# FUN_004789d6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004789d6
# extent:       0x004789d6-0x00478a2c (86 code bytes)
# span:         0x004789d6-0x00478a2c (code 86, tables 0, padding 0)
# sha256:       f98cd94eb4b1aa9df18a0293a46fcfc5ed0dd89c1b913aa8aafa76c1c797d63e
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4789d6_lifted
# naming:       native port src/original_methods_fl40.c:m4789d6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 12 seeds; oracle 27/27 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_29, field_158e; [ecx + n] field_27; [edx + n] field_1590
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4789d6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590

# --- external targets -----------------------------------------------

.org 0x004789d6 - 0x401000
.globl FUN_004789d6
FUN_004789d6:
    # block 0x004789d6: entry, 15 instruction(s), ends with jne to 0x00478a26 (forward)
    push ebp                                     # 004789d6
    {load} mov ebp, esp                          # 004789d7
    sub esp, 0x8                                 # 004789d9
    mov dword ptr [ebp - local_8], ecx           # 004789dc
    mov eax, dword ptr [ebp - local_8]           # 004789df
    movsx ecx, word ptr [eax + field_1e]         # 004789e2
    imul ecx, ecx, 0x8d                          # 004789e6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004789ec
    mov dword ptr [ebp - local_4], edx           # 004789f2
    mov eax, dword ptr [ebp - local_4]           # 004789f5
    movsx ecx, word ptr [eax + field_29]         # 004789f8
    mov edx, dword ptr [ebp - local_8]           # 004789fc
    movsx eax, word ptr [edx + field_1590]       # 004789ff
    {load} cmp ecx, eax                          # 00478a06
    jne.d8 L_00478a26                            # 00478a08
    # block 0x00478a0a: entered by fall-through of jne at 0x00478a08, 6 instruction(s), ends with jne to 0x00478a26 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00478a0a
    movsx edx, word ptr [ecx + field_27]         # 00478a0d
    mov eax, dword ptr [ebp - local_8]           # 00478a11
    movsx ecx, word ptr [eax + field_158e]       # 00478a14
    {load} cmp edx, ecx                          # 00478a1b
    jne.d8 L_00478a26                            # 00478a1d
    # block 0x00478a1f: entered by fall-through of jne at 0x00478a1d, 2 instruction(s), ends with forward jump to 0x00478a28
    mov eax, 0x1                                 # 00478a1f
    jmp.d8 L_00478a28                            # 00478a24
L_00478a26:
    # block 0x00478a26: entered by jne at 0x00478a08; jne at 0x00478a1d, 1 instruction(s), falls into the block at 0x00478a28
    {load} xor eax, eax                          # 00478a26
L_00478a28:
    # block 0x00478a28: entered by jmp at 0x00478a24, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00478a28
    pop ebp                                      # 00478a2a
    ret                                          # 00478a2b

