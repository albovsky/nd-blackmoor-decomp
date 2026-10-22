# FUN_004dd28d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd28d
# extent:       0x004dd28d-0x004dd379 (236 code bytes)
# span:         0x004dd28d-0x004dd380 (code 236, tables 0, padding 7)
# sha256:       a9dbe9ae3a6f93ab28f4867b8be7d9734df3b2cce2886cdc7b68d17141511da3
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dd28d_lifted
# naming:       native port src/original_methods_fl39d.c:m4dd28d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (44 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_b7, field_ee, field_18e, field_1c2; [ecx + n] field_ee, field_18c, field_1c2; [edx + n] field_ee, field_18c, field_18e, field_1c2
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4dd28d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_b7, 0xb7  # offset +0xb7
.equ field_ee, 0xee  # offset +0xee
.equ field_18c, 0x18c  # offset +0x18c
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1c2, 0x1c2  # offset +0x1c2

# --- external targets -----------------------------------------------

.org 0x004dd28d - 0x401000
.globl FUN_004dd28d
FUN_004dd28d:
    # block 0x004dd28d: entry, 8 instruction(s), ends with jne to 0x004dd30d (forward)
    push ebp                                     # 004dd28d
    {load} mov ebp, esp                          # 004dd28e
    push ecx                                     # 004dd290
    mov dword ptr [ebp - local_4], ecx           # 004dd291
    mov eax, dword ptr [ebp - local_4]           # 004dd294
    movsx ecx, word ptr [eax + field_b7]         # 004dd297
    cmp ecx, 0x1                                 # 004dd29e
    jne.d8 L_004dd30d                            # 004dd2a1
    # block 0x004dd2a3: entered by fall-through of jne at 0x004dd2a1, 15 instruction(s), ends with jle to 0x004dd30b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004dd2a3
    mov eax, dword ptr [edx + field_ee]          # 004dd2a6
    mov cx, word ptr [eax + field_1c2]           # 004dd2ac
    add cx, 0x1                                  # 004dd2b3
    mov edx, dword ptr [ebp - local_4]           # 004dd2b7
    mov eax, dword ptr [edx + field_ee]          # 004dd2ba
    mov word ptr [eax + field_1c2], cx           # 004dd2c0
    mov ecx, dword ptr [ebp - local_4]           # 004dd2c7
    mov edx, dword ptr [ecx + field_ee]          # 004dd2ca
    movsx eax, word ptr [edx + field_1c2]        # 004dd2d0
    mov ecx, dword ptr [ebp - local_4]           # 004dd2d7
    mov edx, dword ptr [ecx + field_ee]          # 004dd2da
    movsx ecx, word ptr [edx + field_18e]        # 004dd2e0
    {load} cmp eax, ecx                          # 004dd2e7
    jle.d8 L_004dd30b                            # 004dd2e9
    # block 0x004dd2eb: entered by fall-through of jle at 0x004dd2e9, 6 instruction(s), falls into the block at 0x004dd30b
    mov edx, dword ptr [ebp - local_4]           # 004dd2eb
    mov eax, dword ptr [edx + field_ee]          # 004dd2ee
    mov ecx, dword ptr [ebp - local_4]           # 004dd2f4
    mov edx, dword ptr [ecx + field_ee]          # 004dd2f7
    mov ax, word ptr [eax + field_18e]           # 004dd2fd
    mov word ptr [edx + field_1c2], ax           # 004dd304
L_004dd30b:
    # block 0x004dd30b: entered by jle at 0x004dd2e9, 1 instruction(s), ends with forward jump to 0x004dd375
    jmp.d8 L_004dd375                            # 004dd30b
L_004dd30d:
    # block 0x004dd30d: entered by jne at 0x004dd2a1, 15 instruction(s), ends with jge to 0x004dd375 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004dd30d
    mov edx, dword ptr [ecx + field_ee]          # 004dd310
    mov ax, word ptr [edx + field_1c2]           # 004dd316
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004dd31d
    mov ecx, dword ptr [ebp - local_4]           # 004dd321
    mov edx, dword ptr [ecx + field_ee]          # 004dd324
    mov word ptr [edx + field_1c2], ax           # 004dd32a
    mov eax, dword ptr [ebp - local_4]           # 004dd331
    mov ecx, dword ptr [eax + field_ee]          # 004dd334
    movsx edx, word ptr [ecx + field_1c2]        # 004dd33a
    mov eax, dword ptr [ebp - local_4]           # 004dd341
    mov ecx, dword ptr [eax + field_ee]          # 004dd344
    movsx eax, word ptr [ecx + field_18c]        # 004dd34a
    {load} cmp edx, eax                          # 004dd351
    jge.d8 L_004dd375                            # 004dd353
    # block 0x004dd355: entered by fall-through of jge at 0x004dd353, 6 instruction(s), falls into the block at 0x004dd375
    mov ecx, dword ptr [ebp - local_4]           # 004dd355
    mov edx, dword ptr [ecx + field_ee]          # 004dd358
    mov eax, dword ptr [ebp - local_4]           # 004dd35e
    mov ecx, dword ptr [eax + field_ee]          # 004dd361
    mov dx, word ptr [edx + field_18c]           # 004dd367
    mov word ptr [ecx + field_1c2], dx           # 004dd36e
L_004dd375:
    # block 0x004dd375: entered by jmp at 0x004dd30b; jge at 0x004dd353, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004dd375
    pop ebp                                      # 004dd377
    ret                                          # 004dd378

# --- data items (not part of the function) -------------------------
.org 0x004dd379 - 0x401000
PAD_004dd379:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

