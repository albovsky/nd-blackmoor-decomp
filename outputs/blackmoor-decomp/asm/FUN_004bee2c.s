# FUN_004bee2c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bee2c
# extent:       0x004bee2c-0x004bee5f (51 code bytes)
# span:         0x004bee2c-0x004bee5f (code 51, tables 0, padding 0)
# sha256:       686c4c9ff3b6a40b1eeb3f2134afc9ca9657f6a4da3f7f4d63f95759f39972df
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bee2c_get_field
# naming:       native port src/original_methods_fl27a.c:m4bee2c_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4bee2c_get_field: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0; [ecx + n] field_c
# callees:      calls FUN_004bf38c
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.c:bink_draw (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bee2c - 0x401000
.globl FUN_004bee2c
FUN_004bee2c:
    # block 0x004bee2c: entry, 8 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bee53 (forward)
    push ebp                                     # 004bee2c
    {load} mov ebp, esp                          # 004bee2d
    push ecx                                     # 004bee2f
    mov dword ptr [ebp - local_4], ecx           # 004bee30
    mov ecx, dword ptr [ebp - local_4]           # 004bee33
    call FUN_004bf38c                            # 004bee36
    cmp dword ptr [ebp + arg_8], 0x0             # 004bee3b
    jne.d8 L_004bee53                            # 004bee3f
    # block 0x004bee41: entered by fall-through of jne at 0x004bee3f, 4 instruction(s), ends with forward jump to 0x004bee59
    mov eax, dword ptr [ebp - local_4]           # 004bee41
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bee44
    or eax, -0x1                                 # 004bee4e
    jmp.d8 L_004bee59                            # 004bee51
L_004bee53:
    # block 0x004bee53: entered by jne at 0x004bee3f, 2 instruction(s), falls into the block at 0x004bee59
    mov ecx, dword ptr [ebp + arg_8]             # 004bee53
    mov eax, dword ptr [ecx + field_c]           # 004bee56
L_004bee59:
    # block 0x004bee59: entered by jmp at 0x004bee51, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004bee59
    pop ebp                                      # 004bee5b
    ret 0x4                                      # 004bee5c

