# FUN_004235fd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004235fd
# extent:       0x004235fd-0x00423634 (55 code bytes)
# span:         0x004235fd-0x00423634 (code 55, tables 0, padding 0)
# sha256:       8a6999419fee63910944336417e99db758d3eb9b03c751ce7fb8499bb1e84a1b
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4235fd_pop
# naming:       native port src/original_methods_fl28a.c:m4235fd_pop (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4235fd_pop: the oracle runs every instruction of 0x4235fd..0x423634 and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl26b.c:m424201_walk (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004235fd - 0x401000
.globl FUN_004235fd
FUN_004235fd:
    # block 0x004235fd: entry, 7 instruction(s), ends with jne to 0x00423611 (forward)
    push ebp                                     # 004235fd
    {load} mov ebp, esp                          # 004235fe
    push ecx                                     # 00423600
    mov dword ptr [ebp - local_4], ecx           # 00423601
    mov eax, dword ptr [ebp - local_4]           # 00423604
    cmp dword ptr [eax + field_4], 0x0           # 00423607
    jne.d8 L_00423611                            # 0042360b
    # block 0x0042360d: entered by fall-through of jne at 0x0042360b, 2 instruction(s), ends with forward jump to 0x00423630
    {load} xor eax, eax                          # 0042360d
    jmp.d8 L_00423630                            # 0042360f
L_00423611:
    # block 0x00423611: entered by jne at 0x0042360b, 10 instruction(s), falls into the block at 0x00423630
    mov ecx, dword ptr [ebp - local_4]           # 00423611
    mov edx, dword ptr [ecx + field_4]           # 00423614
    sub edx, 0x1                                 # 00423617
    mov eax, dword ptr [ebp - local_4]           # 0042361a
    mov dword ptr [eax + field_4], edx           # 0042361d
    mov ecx, dword ptr [ebp - local_4]           # 00423620
    mov edx, dword ptr [ecx + field_4]           # 00423623
    imul edx, edx, 0xc                           # 00423626
    mov eax, dword ptr [ebp - local_4]           # 00423629
    lea eax, [eax + edx + field_8]               # 0042362c
L_00423630:
    # block 0x00423630: entered by jmp at 0x0042360f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00423630
    pop ebp                                      # 00423632
    ret                                          # 00423633

