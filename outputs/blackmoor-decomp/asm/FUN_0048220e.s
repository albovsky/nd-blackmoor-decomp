# FUN_0048220e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048220e
# extent:       0x0048220e-0x00482248 (58 code bytes)
# span:         0x0048220e-0x00482248 (code 58, tables 0, padding 0)
# sha256:       376ceb8173f80b850ab02ad9c018605a4a9da78b9dc18716e029cc719eef3e20
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48220e_mark_entry
# naming:       native port src/original_methods_fl39a.c:m48220e_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when byte [self+0xa8] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_a8; [ecx + n] field_1c; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m48220e_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x0048220e - 0x401000
.globl FUN_0048220e
FUN_0048220e:
    # block 0x0048220e: entry, 9 instruction(s), ends with je to 0x00482244 (forward)
    push ebp                                     # 0048220e
    {load} mov ebp, esp                          # 0048220f
    push ecx                                     # 00482211
    mov dword ptr [ebp - local_4], ecx           # 00482212
    mov eax, dword ptr [ebp - local_4]           # 00482215
    {load} xor ecx, ecx                          # 00482218
    mov cl, byte ptr [eax + field_a8]            # 0048221a
    test ecx, ecx                                # 00482220
    je.d8 L_00482244                             # 00482222
    # block 0x00482224: entered by fall-through of je at 0x00482222, 4 instruction(s), ends with je to 0x00482244 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00482224
    movsx eax, word ptr [edx + field_1c]         # 00482227
    cmp eax, -0x1                                # 0048222b
    je.d8 L_00482244                             # 0048222e
    # block 0x00482230: entered by fall-through of je at 0x0048222e, 4 instruction(s), falls into the block at 0x00482244
    mov ecx, dword ptr [ebp - local_4]           # 00482230
    movsx edx, word ptr [ecx + field_1c]         # 00482233
    imul edx, edx, 0x4a                          # 00482237
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0048223a
L_00482244:
    # block 0x00482244: entered by je at 0x00482222; je at 0x0048222e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00482244
    pop ebp                                      # 00482246
    ret                                          # 00482247

