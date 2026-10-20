# FUN_0048c0ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048c0ac
# extent:       0x0048c0ac-0x0048c148 (156 code bytes)
# span:         0x0048c0ac-0x0048c148 (code 156, tables 0, padding 0)
# sha256:       f0383610f91321d60fec4a18f9f1beb4fdf082fc29a7ccbf6c7a4071be3e2666
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48c0ac_accept_piece
# naming:       native port src/original_methods_fl17.c:m48c0ac_accept_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48c0ac_accept_piece. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 156 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_26, field_28, field_47, field_160; [ecx + n] field_1c, field_26; [edx + n] field_26, field_40, field_54
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m48c0ac_accept_piece (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_40, 0x40  # offset +0x40
.equ field_47, 0x47  # offset +0x47
.equ field_54, 0x54  # offset +0x54
.equ field_160, 0x160  # offset +0x160

# --- external targets -----------------------------------------------

.org 0x0048c0ac - 0x401000
.globl FUN_0048c0ac
FUN_0048c0ac:
    # block 0x0048c0ac: entry, 11 instruction(s), ends with jne to 0x0048c0f7 (forward)
    push ebp                                     # 0048c0ac
    {load} mov ebp, esp                          # 0048c0ad
    sub esp, 0x8                                 # 0048c0af
    mov dword ptr [ebp - local_8], ecx           # 0048c0b2
    mov eax, dword ptr [ebp - local_8]           # 0048c0b5
    movsx ecx, word ptr [eax + field_26]         # 0048c0b8
    imul ecx, ecx, 0x8d                          # 0048c0bc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048c0c2
    mov dword ptr [ebp - local_4], edx           # 0048c0c8
    cmp dword ptr [0x5c39e5], 0x27a9             # 0048c0cb
    jne.d8 L_0048c0f7                            # 0048c0d5
    # block 0x0048c0d7: entered by fall-through of jne at 0x0048c0d5, 7 instruction(s), ends with forward jump to 0x0048c136
    mov eax, dword ptr [ebp - local_8]           # 0048c0d7
    mov byte ptr [eax + field_47], 0x1           # 0048c0da
    mov ecx, dword ptr [ebp - local_8]           # 0048c0de
    movsx edx, word ptr [ecx + field_26]         # 0048c0e1
    imul edx, edx, 0x8d                          # 0048c0e5
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048c0eb
    jmp.d8 L_0048c136                            # 0048c0f5
L_0048c0f7:
    # block 0x0048c0f7: entered by jne at 0x0048c0d5, 2 instruction(s), ends with jne to 0x0048c136 (forward)
    cmp dword ptr [0x5c39e5], 0x27a8             # 0048c0f7
    jne.d8 L_0048c136                            # 0048c101
    # block 0x0048c103: entered by fall-through of jne at 0x0048c101, 11 instruction(s), falls into the block at 0x0048c136
    mov eax, dword ptr [ebp - local_8]           # 0048c103
    movsx ecx, word ptr [eax + field_28]         # 0048c106
    imul ecx, ecx, 0x12                          # 0048c10a
    mov edx, dword ptr [ebp - local_8]           # 0048c10d
    mov eax, dword ptr [ebp - local_4]           # 0048c110
    mov cx, word ptr [eax + ecx + field_160]     # 0048c113
    mov word ptr [edx + field_54], cx            # 0048c11b
    mov edx, dword ptr [ebp - local_8]           # 0048c11f
    movsx eax, word ptr [edx + field_26]         # 0048c122
    imul eax, eax, 0x8d                          # 0048c126
    mov dword ptr [eax + 0x5bb632], 0x2          # 0048c12c
L_0048c136:
    # block 0x0048c136: entered by jmp at 0x0048c0f5; jne at 0x0048c101, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 0048c136
    mov byte ptr [ecx + field_1c], -0x1          # 0048c139
    mov edx, dword ptr [ebp - local_8]           # 0048c13d
    mov byte ptr [edx + field_40], 0x0           # 0048c140
    {load} mov esp, ebp                          # 0048c144
    pop ebp                                      # 0048c146
    ret                                          # 0048c147

