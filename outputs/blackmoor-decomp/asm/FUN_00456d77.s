# FUN_00456d77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456d77
# extent:       0x00456d77-0x00456dab (52 code bytes)
# span:         0x00456d77-0x00456dab (code 52, tables 0, padding 0)
# sha256:       19189a111830270801c0d809634d26ddc5d85da6c8bc762fa032eb4bf1ae501f
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456d77
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_3e; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_3e, 0x3e  # offset +0x3e

# --- external targets -----------------------------------------------

.org 0x00456d77 - 0x401000
.globl FUN_00456d77
FUN_00456d77:
    # block 0x00456d77: entry, 7 instruction(s), ends with je to 0x00456da7 (forward)
    push ebp                                     # 00456d77
    {load} mov ebp, esp                          # 00456d78
    push ecx                                     # 00456d7a
    mov dword ptr [ebp - local_4], ecx           # 00456d7b
    mov eax, dword ptr [ebp - local_4]           # 00456d7e
    cmp dword ptr [eax + field_3e], 0x0          # 00456d81
    je.d8 L_00456da7                             # 00456d85
    # block 0x00456d87: entered by fall-through of je at 0x00456d85, 4 instruction(s), ends with je to 0x00456da7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00456d87
    movsx edx, word ptr [ecx + field_1c]         # 00456d8a
    cmp edx, -0x1                                # 00456d8e
    je.d8 L_00456da7                             # 00456d91
    # block 0x00456d93: entered by fall-through of je at 0x00456d91, 4 instruction(s), falls into the block at 0x00456da7
    mov eax, dword ptr [ebp - local_4]           # 00456d93
    movsx ecx, word ptr [eax + field_1c]         # 00456d96
    imul ecx, ecx, 0x4a                          # 00456d9a
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00456d9d
L_00456da7:
    # block 0x00456da7: entered by je at 0x00456d85; je at 0x00456d91, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00456da7
    pop ebp                                      # 00456da9
    ret                                          # 00456daa

