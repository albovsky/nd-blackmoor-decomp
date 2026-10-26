# FUN_004be2c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be2c6
# extent:       0x004be2c6-0x004be367 (161 code bytes)
# span:         0x004be2c6-0x004be367 (code 161, tables 0, padding 0)
# sha256:       d354125f2bc88f1781341a0ae0480c74e9bcc91a9eb346687cc72c0066134658
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4be2c6_lifted
# naming:       native port src/original_methods_fl41.c:m4be2c6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 14 seeds; oracle: 45/45 instructions, 10/10 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_38, field_1a4, field_1a8; [ecx + n] field_1a4, field_1a8; [edx + n] field_1a4, field_1a8
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4be2c6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_38, 0x38  # offset +0x38
.equ field_1a4, 0x1a4  # offset +0x1a4
.equ field_1a8, 0x1a8  # offset +0x1a8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004be2c6 - 0x401000
.globl FUN_004be2c6
FUN_004be2c6:
    # block 0x004be2c6: entry, 6 instruction(s), ends with jne to 0x004be2da (forward)
    push ebp                                     # 004be2c6
    {load} mov ebp, esp                          # 004be2c7
    sub esp, 0xc                                 # 004be2c9
    mov dword ptr [ebp - local_8], ecx           # 004be2cc
    cmp dword ptr [ebp + arg_8], 0x0             # 004be2cf
    jne.d8 L_004be2da                            # 004be2d3
    # block 0x004be2d5: entered by fall-through of jne at 0x004be2d3, 1 instruction(s), ends with forward jump to 0x004be361
    jmp.d32 L_004be361                           # 004be2d5
L_004be2da:
    # block 0x004be2da: entered by jne at 0x004be2d3, 5 instruction(s), ends with je to 0x004be2f1 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004be2da
    mov ecx, dword ptr [eax + field_38]          # 004be2dd
    mov dword ptr [ebp - local_c], ecx           # 004be2e0
    cmp dword ptr [ebp - local_c], 0x0           # 004be2e3
    je.d8 L_004be2f1                             # 004be2e7
    # block 0x004be2e9: entered by fall-through of je at 0x004be2e7, 2 instruction(s), ends with je to 0x004be321 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004be2e9
    je.d8 L_004be321                             # 004be2ed
    # block 0x004be2ef: entered by fall-through of je at 0x004be2ed, 1 instruction(s), ends with forward jump to 0x004be34f
    jmp.d8 L_004be34f                            # 004be2ef
L_004be2f1:
    # block 0x004be2f1: entered by je at 0x004be2e7, 8 instruction(s), ends with jge to 0x004be31f (forward)
    mov edx, dword ptr [ebp - local_8]           # 004be2f1
    mov eax, dword ptr [edx + field_1a4]         # 004be2f4
    sub eax, 0x1                                 # 004be2fa
    mov ecx, dword ptr [ebp - local_8]           # 004be2fd
    mov dword ptr [ecx + field_1a4], eax         # 004be300
    mov edx, dword ptr [ebp - local_8]           # 004be306
    cmp dword ptr [edx + field_1a4], 0x0         # 004be309
    jge.d8 L_004be31f                            # 004be310
    # block 0x004be312: entered by fall-through of jge at 0x004be310, 2 instruction(s), falls into the block at 0x004be31f
    mov eax, dword ptr [ebp - local_8]           # 004be312
    mov dword ptr [eax + field_1a4], 0x0         # 004be315
L_004be31f:
    # block 0x004be31f: entered by jge at 0x004be310, 1 instruction(s), ends with forward jump to 0x004be34f
    jmp.d8 L_004be34f                            # 004be31f
L_004be321:
    # block 0x004be321: entered by je at 0x004be2ed, 8 instruction(s), ends with jge to 0x004be34f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004be321
    mov edx, dword ptr [ecx + field_1a8]         # 004be324
    sub edx, 0x1                                 # 004be32a
    mov eax, dword ptr [ebp - local_8]           # 004be32d
    mov dword ptr [eax + field_1a8], edx         # 004be330
    mov ecx, dword ptr [ebp - local_8]           # 004be336
    cmp dword ptr [ecx + field_1a8], 0x0         # 004be339
    jge.d8 L_004be34f                            # 004be340
    # block 0x004be342: entered by fall-through of jge at 0x004be340, 2 instruction(s), falls into the block at 0x004be34f
    mov edx, dword ptr [ebp - local_8]           # 004be342
    mov dword ptr [edx + field_1a8], 0x0         # 004be345
L_004be34f:
    # block 0x004be34f: entered by jmp at 0x004be2ef; jmp at 0x004be31f; jge at 0x004be340, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004be361
    mov eax, dword ptr [ebp + arg_8]             # 004be34f
    mov dword ptr [ebp - local_4], eax           # 004be352
    mov ecx, dword ptr [ebp - local_4]           # 004be355
    push ecx                                     # 004be358
    call FUN_0051dc6c                            # 004be359
    add esp, 0x4                                 # 004be35e
L_004be361:
    # block 0x004be361: entered by jmp at 0x004be2d5, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004be361
    pop ebp                                      # 004be363
    ret 0x4                                      # 004be364

