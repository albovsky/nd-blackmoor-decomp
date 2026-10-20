# FUN_004ba4f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba4f2
# extent:       0x004ba4f2-0x004ba56a (120 code bytes)
# span:         0x004ba4f2-0x004ba56a (code 120, tables 0, padding 0)
# sha256:       af72397b3c79d1f50f815fa4052421b5c7cb17ba76b3692f7631f45bf46ce6a3
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ba4f2_click_276a
# naming:       native port src/original_methods_fl23b.c:m4ba4f2_click_276a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4ba4f2_click_276a (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_34, field_2d4; [ecx + n] field_6, field_18, field_28, field_2d4; [edx + n] field_24, field_8ec
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m4ba4f2_click_276a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6, 0x6  # offset +0x6
.equ field_18, 0x18  # offset +0x18
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_34, 0x34  # offset +0x34
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_8ec, 0x8ec  # offset +0x8ec

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ba4f2 - 0x401000
.globl FUN_004ba4f2
FUN_004ba4f2:
    # block 0x004ba4f2: entry, 7 instruction(s), ends with je to 0x004ba566 (forward)
    push ebp                                     # 004ba4f2
    {load} mov ebp, esp                          # 004ba4f3
    push ecx                                     # 004ba4f5
    mov dword ptr [ebp - local_4], ecx           # 004ba4f6
    mov eax, dword ptr [ebp - local_4]           # 004ba4f9
    cmp dword ptr [eax + field_34], 0x0          # 004ba4fc
    je.d8 L_004ba566                             # 004ba500
    # block 0x004ba502: entered by fall-through of je at 0x004ba500, 5 instruction(s), ends with jne to 0x004ba566 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba502
    movsx edx, word ptr [ecx + field_6]          # 004ba505
    imul edx, edx, 0x8d                          # 004ba509
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004ba50f
    jne.d8 L_004ba566                            # 004ba516
    # block 0x004ba518: entered by fall-through of jne at 0x004ba516, 2 instruction(s), ends with jne to 0x004ba566 (forward)
    cmp dword ptr [0x5c39e5], 0x276a             # 004ba518
    jne.d8 L_004ba566                            # 004ba522
    # block 0x004ba524: entered by fall-through of jne at 0x004ba522, 15 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004fb2e3, falls into the block at 0x004ba566
    mov eax, dword ptr [ebp - local_4]           # 004ba524
    mov ecx, dword ptr [eax + field_2d4]         # 004ba527
    mov edx, dword ptr [ebp - local_4]           # 004ba52d
    mov dword ptr [edx + 8*ecx + field_24], 0x1  # 004ba530
    call dword ptr [0x52a23c]                    # 004ba538
    mov ecx, dword ptr [ebp - local_4]           # 004ba53e
    mov edx, dword ptr [ecx + field_18]          # 004ba541
    add eax, dword ptr [edx + field_8ec]         # 004ba544
    mov ecx, dword ptr [ebp - local_4]           # 004ba54a
    mov edx, dword ptr [ecx + field_2d4]         # 004ba54d
    mov ecx, dword ptr [ebp - local_4]           # 004ba553
    mov dword ptr [ecx + 8*edx + field_28], eax  # 004ba556
    push 0x17                                    # 004ba55a
    mov ecx, 0x5c3a67                            # 004ba55c
    call FUN_004fb2e3                            # 004ba561
L_004ba566:
    # block 0x004ba566: entered by je at 0x004ba500; jne at 0x004ba516; jne at 0x004ba522, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ba566
    pop ebp                                      # 004ba568
    ret                                          # 004ba569

