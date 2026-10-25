# FUN_004afa1e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afa1e
# extent:       0x004afa1e-0x004afc1e (512 code bytes)
# span:         0x004afa1e-0x004afc20 (code 512, tables 0, padding 2)
# sha256:       5ac0f632076da4f2af05b8b01660278299b91c7bba6dd1229622ca1874891af2
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4afa1e_lifted
# naming:       native port src/original_methods_fl41.c:m4afa1e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 15 seeds; oracle: 137/137 instructions, 22/22 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_26, field_2f; [ecx + n] field_26, field_2f, field_33, field_42; [edx + n] field_26, field_33
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4afa1e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 137 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_26, 0x26  # offset +0x26
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_42, 0x42  # offset +0x42

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004afa1e - 0x401000
.globl FUN_004afa1e
FUN_004afa1e:
    # block 0x004afa1e: entry, 5 instruction(s), ends with je to 0x004afa5d (forward)
    push ebp                                     # 004afa1e
    {load} mov ebp, esp                          # 004afa1f
    sub esp, 0x18                                # 004afa21
    cmp dword ptr [0x636a2a], 0x0                # 004afa24
    je.d8 L_004afa5d                             # 004afa2b
    # block 0x004afa2d: entered by fall-through of je at 0x004afa2b, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004afa5d
    mov dword ptr [0x636a2a], 0x0                # 004afa2d
    push 0x5515c8                                # 004afa37
    push 0x636a3e                                # 004afa3c
    push 0x636a2e                                # 004afa41
    mov eax, dword ptr [0x5cf665]                # 004afa46
    push eax                                     # 004afa4b
    mov ecx, dword ptr [0x5d15e3]                # 004afa4c
    push ecx                                     # 004afa52
    mov ecx, 0x5cf659                            # 004afa53
    call FUN_004c5377                            # 004afa58
L_004afa5d:
    # block 0x004afa5d: entered by je at 0x004afa2b, 2 instruction(s), ends with jne to 0x004afa6f (forward)
    cmp dword ptr [0x636a04], 0x0                # 004afa5d
    jne.d8 L_004afa6f                            # 004afa64
    # block 0x004afa66: entered by fall-through of jne at 0x004afa64, 2 instruction(s), ends with je to 0x004afa9f (forward)
    cmp dword ptr [0x636a4e], 0x0                # 004afa66
    je.d8 L_004afa9f                             # 004afa6d
L_004afa6f:
    # block 0x004afa6f: entered by jne at 0x004afa64; fall-through of je at 0x004afa6d, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004afa9f
    push 0x551604                                # 004afa6f
    push 0x636a1a                                # 004afa74
    push 0x636a0a                                # 004afa79
    mov edx, dword ptr [0x5cf665]                # 004afa7e
    push edx                                     # 004afa84
    mov eax, dword ptr [0x5d15e3]                # 004afa85
    push eax                                     # 004afa8a
    mov ecx, 0x5cf659                            # 004afa8b
    call FUN_004c5377                            # 004afa90
    mov dword ptr [0x636a4e], 0x0                # 004afa95
L_004afa9f:
    # block 0x004afa9f: entered by je at 0x004afa6d, 7 instruction(s), ends with je to 0x004afaca (forward)
    mov ecx, dword ptr [0x6375fb]                # 004afa9f
    mov dx, word ptr [ecx + field_42]            # 004afaa5
    mov word ptr [ebp - local_c], dx             # 004afaa9
    mov ax, word ptr [ebp - local_c]             # 004afaad
    mov word ptr [ebp - local_8], ax             # 004afab1
    cmp dword ptr [0x636a04], 0x0                # 004afab5
    je.d8 L_004afaca                             # 004afabc
    # block 0x004afabe: entered by fall-through of je at 0x004afabc, 3 instruction(s), falls into the block at 0x004afaca
    mov cx, word ptr [ebp - local_8]             # 004afabe
    sub cx, 0x1                                  # 004afac2
    mov word ptr [ebp - local_8], cx             # 004afac6
L_004afaca:
    # block 0x004afaca: entered by je at 0x004afabc, 3 instruction(s), ends with forward jump to 0x004afae4
    mov word ptr [ebp - local_4], 0x0            # 004afaca
    mov word ptr [ebp - local_10], 0x0           # 004afad0
    jmp.d8 L_004afae4                            # 004afad6
L_004afad8:
    # block 0x004afad8: entered by jmp at 0x004afbb5, 3 instruction(s), falls into the block at 0x004afae4
    mov dx, word ptr [ebp - local_4]             # 004afad8
    add dx, 0x1                                  # 004afadc
    mov word ptr [ebp - local_4], dx             # 004afae0
L_004afae4:
    # block 0x004afae4: entered by jmp at 0x004afad6, 4 instruction(s), ends with je to 0x004afbba (forward)
    movsx eax, word ptr [ebp - local_10]         # 004afae4
    movsx ecx, word ptr [ebp - local_8]          # 004afae8
    {load} cmp eax, ecx                          # 004afaec
    je.d32 L_004afbba                            # 004afaee
    # block 0x004afaf4: entered by fall-through of je at 0x004afaee, 2 instruction(s), ends with forward jump to 0x004afb08
    mov word ptr [ebp - local_14], 0x0           # 004afaf4
    jmp.d8 L_004afb08                            # 004afafa
L_004afafc:
    # block 0x004afafc: entered by jmp at 0x004afb30; jmp at 0x004afbb0, 3 instruction(s), falls into the block at 0x004afb08
    mov dx, word ptr [ebp - local_14]            # 004afafc
    add dx, 0x1                                  # 004afb00
    mov word ptr [ebp - local_14], dx            # 004afb04
L_004afb08:
    # block 0x004afb08: entered by jmp at 0x004afafa, 4 instruction(s), ends with jge to 0x004afbb5 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004afb08
    movsx ecx, word ptr [ebp - local_c]          # 004afb0c
    {load} cmp eax, ecx                          # 004afb10
    jge.d32 L_004afbb5                           # 004afb12
    # block 0x004afb18: entered by fall-through of jge at 0x004afb12, 2 instruction(s), ends with je to 0x004afb32 (forward)
    cmp dword ptr [0x636a04], 0x0                # 004afb18
    je.d8 L_004afb32                             # 004afb1f
    # block 0x004afb21: entered by fall-through of je at 0x004afb1f, 4 instruction(s), ends with jne to 0x004afb32 (forward)
    movsx edx, word ptr [0x636a08]               # 004afb21
    movsx eax, word ptr [ebp - local_14]         # 004afb28
    {load} cmp edx, eax                          # 004afb2c
    jne.d8 L_004afb32                            # 004afb2e
    # block 0x004afb30: entered by fall-through of jne at 0x004afb2e, 1 instruction(s), ends with backward jump to 0x004afafc
    jmp.d8 L_004afafc                            # 004afb30
L_004afb32:
    # block 0x004afb32: entered by je at 0x004afb1f; jne at 0x004afb2e, 9 instruction(s), ends with jne to 0x004afbb0 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004afb32
    imul ecx, ecx, 0xc7                          # 004afb36
    add ecx, 0x636a52                            # 004afb3c
    mov dword ptr [ebp - local_18], ecx          # 004afb42
    mov edx, dword ptr [ebp - local_18]          # 004afb45
    movsx eax, word ptr [edx]                    # 004afb48
    movsx ecx, word ptr [ebp - local_4]          # 004afb4b
    {load} cmp eax, ecx                          # 004afb4f
    jne.d8 L_004afbb0                            # 004afb51
    # block 0x004afb53: entered by fall-through of jne at 0x004afb51, 29 instruction(s), calls FUN_004c5d4b, ends with jne to 0x004afbb0 (forward)
    push 0x551638                                # 004afb53
    mov edx, dword ptr [ebp - local_18]          # 004afb58
    add edx, 0x12                                # 004afb5b
    push edx                                     # 004afb5e
    mov eax, dword ptr [ebp - local_18]          # 004afb5f
    {load} xor ecx, ecx                          # 004afb62
    mov cl, byte ptr [eax + field_26]            # 004afb64
    imul ecx, ecx, 0x28                          # 004afb67
    mov edx, dword ptr [ebp - local_18]          # 004afb6a
    lea eax, [edx + ecx + field_33]              # 004afb6d
    push eax                                     # 004afb71
    mov ecx, dword ptr [0x5cf665]                # 004afb72
    push ecx                                     # 004afb78
    mov edx, dword ptr [ebp - local_18]          # 004afb79
    {load} xor eax, eax                          # 004afb7c
    mov al, byte ptr [edx + field_26]            # 004afb7e
    imul eax, eax, 0x28                          # 004afb81
    mov ecx, dword ptr [ebp - local_18]          # 004afb84
    mov edx, dword ptr [ecx + eax + field_2f]    # 004afb87
    push edx                                     # 004afb8b
    mov ecx, 0x5cf659                            # 004afb8c
    call FUN_004c5d4b                            # 004afb91
    mov ax, word ptr [ebp - local_10]            # 004afb96
    .insn 0x66, 0x05, 0x0001{:u16}               # 004afb9a
    mov word ptr [ebp - local_10], ax            # 004afb9e
    movsx ecx, word ptr [ebp - local_10]         # 004afba2
    movsx edx, word ptr [ebp - local_8]          # 004afba6
    {load} cmp ecx, edx                          # 004afbaa
    jne.d8 L_004afbb0                            # 004afbac
    # block 0x004afbae: entered by fall-through of jne at 0x004afbac, 1 instruction(s), ends with forward jump to 0x004afbb5
    jmp.d8 L_004afbb5                            # 004afbae
L_004afbb0:
    # block 0x004afbb0: entered by jne at 0x004afb51; jne at 0x004afbac, 1 instruction(s), ends with backward jump to 0x004afafc
    jmp.d32 L_004afafc                           # 004afbb0
L_004afbb5:
    # block 0x004afbb5: entered by jge at 0x004afb12; jmp at 0x004afbae, 1 instruction(s), ends with backward jump to 0x004afad8
    jmp.d32 L_004afad8                           # 004afbb5
L_004afbba:
    # block 0x004afbba: entered by je at 0x004afaee, 2 instruction(s), ends with je to 0x004afc1a (forward)
    cmp dword ptr [0x636a04], 0x0                # 004afbba
    je.d8 L_004afc1a                             # 004afbc1
    # block 0x004afbc3: entered by fall-through of je at 0x004afbc1, 26 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004afc1a
    movsx eax, word ptr [0x636a08]               # 004afbc3
    imul eax, eax, 0xc7                          # 004afbca
    add eax, 0x636a52                            # 004afbd0
    mov dword ptr [ebp - local_18], eax          # 004afbd5
    push 0x551654                                # 004afbd8
    mov ecx, dword ptr [ebp - local_18]          # 004afbdd
    add ecx, 0x12                                # 004afbe0
    push ecx                                     # 004afbe3
    mov edx, dword ptr [ebp - local_18]          # 004afbe4
    {load} xor eax, eax                          # 004afbe7
    mov al, byte ptr [edx + field_26]            # 004afbe9
    imul eax, eax, 0x28                          # 004afbec
    mov ecx, dword ptr [ebp - local_18]          # 004afbef
    lea edx, [ecx + eax + field_33]              # 004afbf2
    push edx                                     # 004afbf6
    mov eax, dword ptr [0x5cf665]                # 004afbf7
    push eax                                     # 004afbfc
    mov ecx, dword ptr [ebp - local_18]          # 004afbfd
    {load} xor edx, edx                          # 004afc00
    mov dl, byte ptr [ecx + field_26]            # 004afc02
    imul edx, edx, 0x28                          # 004afc05
    mov eax, dword ptr [ebp - local_18]          # 004afc08
    mov ecx, dword ptr [eax + edx + field_2f]    # 004afc0b
    push ecx                                     # 004afc0f
    mov ecx, 0x5cf659                            # 004afc10
    call FUN_004c5d4b                            # 004afc15
L_004afc1a:
    # block 0x004afc1a: entered by je at 0x004afbc1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004afc1a
    pop ebp                                      # 004afc1c
    ret                                          # 004afc1d

# --- data items (not part of the function) -------------------------
.org 0x004afc1e - 0x401000
PAD_004afc1e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

