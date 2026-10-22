# FUN_004a3aec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3aec
# extent:       0x004a3aec-0x004a3beb (255 code bytes)
# span:         0x004a3aec-0x004a3beb (code 255, tables 0, padding 0)
# sha256:       ca5f8833f900e7c938619001cd085e07f3454c4dea679dacde46751f531bb580
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a3aec_clamp_rect
# naming:       native port src/original_methods_fl39c.c:m4a3aec_clamp_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Clamps the signed dwords [self+0x22c]/[self+0x234] against the globals 0x58319a/0x5831a2 (word [self+0x832] keeps the width) and [self+0x228]/[self+0x230] against 0x583196/0x58319e. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_228, field_22c, field_230, field_234; [ecx + n] field_830, field_832; [edx + n] field_228, field_22c, field_230, field_234
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4a3aec_clamp_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_228, 0x228  # offset +0x228
.equ field_22c, 0x22c  # offset +0x22c
.equ field_230, 0x230  # offset +0x230
.equ field_234, 0x234  # offset +0x234
.equ field_830, 0x830  # offset +0x830
.equ field_832, 0x832  # offset +0x832

# --- external targets -----------------------------------------------

.org 0x004a3aec - 0x401000
.globl FUN_004a3aec
FUN_004a3aec:
    # block 0x004a3aec: entry, 8 instruction(s), ends with jge to 0x004a3b30 (forward)
    push ebp                                     # 004a3aec
    {load} mov ebp, esp                          # 004a3aed
    push ecx                                     # 004a3aef
    mov dword ptr [ebp - local_4], ecx           # 004a3af0
    mov eax, dword ptr [ebp - local_4]           # 004a3af3
    mov ecx, dword ptr [eax + field_22c]         # 004a3af6
    cmp ecx, dword ptr [0x58319a]                # 004a3afc
    jge.d8 L_004a3b30                            # 004a3b02
    # block 0x004a3b04: entered by fall-through of jge at 0x004a3b02, 10 instruction(s), falls into the block at 0x004a3b30
    mov edx, dword ptr [ebp - local_4]           # 004a3b04
    mov eax, dword ptr [0x58319a]                # 004a3b07
    mov dword ptr [edx + field_22c], eax         # 004a3b0c
    mov ecx, dword ptr [ebp - local_4]           # 004a3b12
    movsx edx, word ptr [ecx + field_832]        # 004a3b15
    mov eax, dword ptr [ebp - local_4]           # 004a3b1c
    mov ecx, dword ptr [eax + field_22c]         # 004a3b1f
    {load} add ecx, edx                          # 004a3b25
    mov edx, dword ptr [ebp - local_4]           # 004a3b27
    mov dword ptr [edx + field_234], ecx         # 004a3b2a
L_004a3b30:
    # block 0x004a3b30: entered by jge at 0x004a3b02, 4 instruction(s), ends with jle to 0x004a3b6d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a3b30
    mov ecx, dword ptr [eax + field_234]         # 004a3b33
    cmp ecx, dword ptr [0x5831a2]                # 004a3b39
    jle.d8 L_004a3b6d                            # 004a3b3f
    # block 0x004a3b41: entered by fall-through of jle at 0x004a3b3f, 10 instruction(s), falls into the block at 0x004a3b6d
    mov edx, dword ptr [ebp - local_4]           # 004a3b41
    mov eax, dword ptr [0x5831a2]                # 004a3b44
    mov dword ptr [edx + field_234], eax         # 004a3b49
    mov ecx, dword ptr [ebp - local_4]           # 004a3b4f
    movsx edx, word ptr [ecx + field_832]        # 004a3b52
    mov eax, dword ptr [ebp - local_4]           # 004a3b59
    mov ecx, dword ptr [eax + field_234]         # 004a3b5c
    {load} sub ecx, edx                          # 004a3b62
    mov edx, dword ptr [ebp - local_4]           # 004a3b64
    mov dword ptr [edx + field_22c], ecx         # 004a3b67
L_004a3b6d:
    # block 0x004a3b6d: entered by jle at 0x004a3b3f, 4 instruction(s), ends with jge to 0x004a3baa (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a3b6d
    mov ecx, dword ptr [eax + field_228]         # 004a3b70
    cmp ecx, dword ptr [0x583196]                # 004a3b76
    jge.d8 L_004a3baa                            # 004a3b7c
    # block 0x004a3b7e: entered by fall-through of jge at 0x004a3b7c, 10 instruction(s), falls into the block at 0x004a3baa
    mov edx, dword ptr [ebp - local_4]           # 004a3b7e
    mov eax, dword ptr [0x583196]                # 004a3b81
    mov dword ptr [edx + field_228], eax         # 004a3b86
    mov ecx, dword ptr [ebp - local_4]           # 004a3b8c
    movsx edx, word ptr [ecx + field_830]        # 004a3b8f
    mov eax, dword ptr [ebp - local_4]           # 004a3b96
    mov ecx, dword ptr [eax + field_228]         # 004a3b99
    {load} add ecx, edx                          # 004a3b9f
    mov edx, dword ptr [ebp - local_4]           # 004a3ba1
    mov dword ptr [edx + field_230], ecx         # 004a3ba4
L_004a3baa:
    # block 0x004a3baa: entered by jge at 0x004a3b7c, 4 instruction(s), ends with jle to 0x004a3be7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a3baa
    mov ecx, dword ptr [eax + field_230]         # 004a3bad
    cmp ecx, dword ptr [0x58319e]                # 004a3bb3
    jle.d8 L_004a3be7                            # 004a3bb9
    # block 0x004a3bbb: entered by fall-through of jle at 0x004a3bb9, 10 instruction(s), falls into the block at 0x004a3be7
    mov edx, dword ptr [ebp - local_4]           # 004a3bbb
    mov eax, dword ptr [0x58319e]                # 004a3bbe
    mov dword ptr [edx + field_230], eax         # 004a3bc3
    mov ecx, dword ptr [ebp - local_4]           # 004a3bc9
    movsx edx, word ptr [ecx + field_830]        # 004a3bcc
    mov eax, dword ptr [ebp - local_4]           # 004a3bd3
    mov ecx, dword ptr [eax + field_230]         # 004a3bd6
    {load} sub ecx, edx                          # 004a3bdc
    mov edx, dword ptr [ebp - local_4]           # 004a3bde
    mov dword ptr [edx + field_228], ecx         # 004a3be1
L_004a3be7:
    # block 0x004a3be7: entered by jle at 0x004a3bb9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a3be7
    pop ebp                                      # 004a3be9
    ret                                          # 004a3bea

