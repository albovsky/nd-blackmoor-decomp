# FUN_004dd409
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd409
# extent:       0x004dd409-0x004dd471 (104 code bytes)
# span:         0x004dd409-0x004dd471 (code 104, tables 0, padding 0)
# sha256:       7a3bc8e4b0d18c368e676456127f7b103fbe7608031acbf0d8129da345460751
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dd409_lifted
# naming:       native port src/original_methods_fl39d.c:m4dd409_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (27 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      calls FUN_004dd471, FUN_004fb2a6, FUN_004dd8f7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4dd409_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004dd471, .text + (0x004dd471 - 0x401000)
.set FUN_004dd8f7, .text + (0x004dd8f7 - 0x401000)
.set FUN_004fb2a6, .text + (0x004fb2a6 - 0x401000)

.org 0x004dd409 - 0x401000
.globl FUN_004dd409
FUN_004dd409:
    # block 0x004dd409: entry, 9 instruction(s), ends with je to 0x004dd42f (forward)
    push ebp                                     # 004dd409
    {load} mov ebp, esp                          # 004dd40a
    sub esp, 0x8                                 # 004dd40c
    mov dword ptr [ebp - local_4], ecx           # 004dd40f
    mov eax, dword ptr [ebp - local_4]           # 004dd412
    mov ecx, dword ptr [eax + field_4]           # 004dd415
    mov dword ptr [ebp - local_8], ecx           # 004dd418
    cmp dword ptr [ebp - local_8], 0x0           # 004dd41b
    je.d8 L_004dd42f                             # 004dd41f
    # block 0x004dd421: entered by fall-through of je at 0x004dd41f, 2 instruction(s), ends with je to 0x004dd43d (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004dd421
    je.d8 L_004dd43d                             # 004dd425
    # block 0x004dd427: entered by fall-through of je at 0x004dd425, 2 instruction(s), ends with je to 0x004dd45f (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004dd427
    je.d8 L_004dd45f                             # 004dd42b
    # block 0x004dd42d: entered by fall-through of je at 0x004dd42b, 1 instruction(s), ends with forward jump to 0x004dd46b
    jmp.d8 L_004dd46b                            # 004dd42d
L_004dd42f:
    # block 0x004dd42f: entered by je at 0x004dd41f, 5 instruction(s), calls FUN_004dd471, ends with forward jump to 0x004dd46b
    mov edx, dword ptr [ebp + arg_8]             # 004dd42f
    push edx                                     # 004dd432
    mov ecx, dword ptr [ebp - local_4]           # 004dd433
    call FUN_004dd471                            # 004dd436
    jmp.d8 L_004dd46b                            # 004dd43b
L_004dd43d:
    # block 0x004dd43d: entered by je at 0x004dd425, 8 instruction(s), calls FUN_004fb2a6, ends with forward jump to 0x004dd46b
    mov ax, word ptr [0x5b451f]                  # 004dd43d
    push eax                                     # 004dd443
    push 0x5b452d                                # 004dd444
    mov ecx, 0x5c3a67                            # 004dd449
    call FUN_004fb2a6                            # 004dd44e
    mov ecx, dword ptr [ebp - local_4]           # 004dd453
    mov dword ptr [ecx + field_4], 0x2           # 004dd456
    jmp.d8 L_004dd46b                            # 004dd45d
L_004dd45f:
    # block 0x004dd45f: entered by je at 0x004dd42b, 4 instruction(s), calls FUN_004dd8f7, falls into the block at 0x004dd46b
    mov edx, dword ptr [ebp + arg_c]             # 004dd45f
    push edx                                     # 004dd462
    mov ecx, dword ptr [ebp - local_4]           # 004dd463
    call FUN_004dd8f7                            # 004dd466
L_004dd46b:
    # block 0x004dd46b: entered by jmp at 0x004dd42d; jmp at 0x004dd43b; jmp at 0x004dd45d, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004dd46b
    pop ebp                                      # 004dd46d
    ret 0x8                                      # 004dd46e

