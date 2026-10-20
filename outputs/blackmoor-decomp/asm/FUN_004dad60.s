# FUN_004dad60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dad60
# extent:       0x004dad60-0x004dadff (159 code bytes)
# span:         0x004dad60-0x004dadff (code 159, tables 0, padding 0)
# sha256:       9c4ab7e560866ec71f9cb47482b5ae85dc2d93dd7f53221eaa92d88b4f1b175a
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dad60_init_swap_buttons
# naming:       native port src/original_methods_fl24b.c:m4dad60_init_swap_buttons (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4dad60_init_swap_buttons (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 224 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_c, field_14, field_1c, field_20; [ecx + n] field_8, field_10, field_20, field_24; [edx + n] field_14, field_18, field_24
# callees:      calls USER32.dll!GetSystemMetrics
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:partner_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x004dad60 - 0x401000
.globl FUN_004dad60
FUN_004dad60:
    # block 0x004dad60: entry, 23 instruction(s), calls USER32.dll!GetSystemMetrics, ends with je to 0x004dadd3 (forward)
    push ebp                                     # 004dad60
    {load} mov ebp, esp                          # 004dad61
    push ecx                                     # 004dad63
    mov dword ptr [ebp - local_4], ecx           # 004dad64
    mov eax, dword ptr [ebp - local_4]           # 004dad67
    mov dword ptr [eax + field_c], 0x0           # 004dad6a
    mov ecx, dword ptr [ebp - local_4]           # 004dad71
    mov dword ptr [ecx + field_10], 0x0          # 004dad74
    mov edx, dword ptr [ebp - local_4]           # 004dad7b
    mov dword ptr [edx], 0x0                     # 004dad7e
    mov eax, dword ptr [ebp - local_4]           # 004dad84
    mov dword ptr [eax + field_4], 0x0           # 004dad87
    mov ecx, dword ptr [ebp - local_4]           # 004dad8e
    mov dword ptr [ecx + field_8], 0x0           # 004dad91
    mov byte ptr [0x58321d], 0x0                 # 004dad98
    mov byte ptr [0x58321e], 0x0                 # 004dad9f
    push 0x17                                    # 004dada6
    call dword ptr [0x52a498]                    # 004dada8
    mov edx, dword ptr [ebp - local_4]           # 004dadae
    mov dword ptr [edx + field_14], eax          # 004dadb1
    mov eax, dword ptr [ebp - local_4]           # 004dadb4
    cmp dword ptr [eax + field_14], 0x0          # 004dadb7
    je.d8 L_004dadd3                             # 004dadbb
    # block 0x004dadbd: entered by fall-through of je at 0x004dadbb, 5 instruction(s), ends with forward jump to 0x004dade7
    mov ecx, dword ptr [ebp - local_4]           # 004dadbd
    mov dword ptr [ecx + field_20], 0x2          # 004dadc0
    mov edx, dword ptr [ebp - local_4]           # 004dadc7
    mov dword ptr [edx + field_24], 0x1          # 004dadca
    jmp.d8 L_004dade7                            # 004dadd1
L_004dadd3:
    # block 0x004dadd3: entered by je at 0x004dadbb, 4 instruction(s), falls into the block at 0x004dade7
    mov eax, dword ptr [ebp - local_4]           # 004dadd3
    mov dword ptr [eax + field_20], 0x1          # 004dadd6
    mov ecx, dword ptr [ebp - local_4]           # 004daddd
    mov dword ptr [ecx + field_24], 0x2          # 004dade0
L_004dade7:
    # block 0x004dade7: entered by jmp at 0x004dadd1, 7 instruction(s), ends with ret
    mov edx, dword ptr [ebp - local_4]           # 004dade7
    mov dword ptr [edx + field_18], 0x0          # 004dadea
    mov eax, dword ptr [ebp - local_4]           # 004dadf1
    mov dword ptr [eax + field_1c], 0x0          # 004dadf4
    {load} mov esp, ebp                          # 004dadfb
    pop ebp                                      # 004dadfd
    ret                                          # 004dadfe

