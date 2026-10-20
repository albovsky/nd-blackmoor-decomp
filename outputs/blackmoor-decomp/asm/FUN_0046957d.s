# FUN_0046957d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046957d
# extent:       0x0046957d-0x004695f7 (122 code bytes)
# span:         0x0046957d-0x004695f7 (code 122, tables 0, padding 0)
# sha256:       80b7f56dc174e7c01be3ac228f175a926654df090098a76be286918639e9805e
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46957d_click_272e
# naming:       native port src/original_methods_fl23b.c:m46957d_click_272e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m46957d_click_272e (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7e, field_55c; [ecx + n] field_158; [edx + n] field_548, field_54a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m46957d_click_272e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7e, 0x7e  # offset +0x7e
.equ field_158, 0x158  # offset +0x158
.equ field_548, 0x548  # offset +0x548
.equ field_54a, 0x54a  # offset +0x54a
.equ field_55c, 0x55c  # offset +0x55c

# --- external targets -----------------------------------------------

.org 0x0046957d - 0x401000
.globl FUN_0046957d
FUN_0046957d:
    # block 0x0046957d: entry, 7 instruction(s), ends with je to 0x004695f3 (forward)
    push ebp                                     # 0046957d
    {load} mov ebp, esp                          # 0046957e
    push ecx                                     # 00469580
    mov dword ptr [ebp - local_4], ecx           # 00469581
    mov eax, dword ptr [ebp - local_4]           # 00469584
    cmp dword ptr [eax + field_55c], 0x0         # 00469587
    je.d8 L_004695f3                             # 0046958e
    # block 0x00469590: entered by fall-through of je at 0x0046958e, 3 instruction(s), ends with je to 0x004695f3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00469590
    cmp dword ptr [ecx + field_158], 0x0         # 00469593
    je.d8 L_004695f3                             # 0046959a
    # block 0x0046959c: entered by fall-through of je at 0x0046959a, 3 instruction(s), ends with jne to 0x004695f3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046959c
    cmp dword ptr [edx + field_54a], 0x0         # 0046959f
    jne.d8 L_004695f3                            # 004695a6
    # block 0x004695a8: entered by fall-through of jne at 0x004695a6, 5 instruction(s), ends with jne to 0x004695f3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004695a8
    movsx ecx, word ptr [eax + field_7e]         # 004695ab
    imul ecx, ecx, 0x8d                          # 004695af
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004695b5
    jne.d8 L_004695f3                            # 004695bc
    # block 0x004695be: entered by fall-through of jne at 0x004695bc, 2 instruction(s), ends with jne to 0x004695f3 (forward)
    cmp dword ptr [0x5c39e5], 0x272e             # 004695be
    jne.d8 L_004695f3                            # 004695c8
    # block 0x004695ca: entered by fall-through of jne at 0x004695c8, 4 instruction(s), ends with jne to 0x004695f3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004695ca
    movsx eax, word ptr [edx + field_548]        # 004695cd
    cmp eax, 0x64                                # 004695d4
    jne.d8 L_004695f3                            # 004695d7
    # block 0x004695d9: entered by fall-through of jne at 0x004695d7, 4 instruction(s), falls into the block at 0x004695f3
    mov ecx, dword ptr [ebp - local_4]           # 004695d9
    mov dword ptr [ecx + field_158], 0x0         # 004695dc
    mov edx, dword ptr [ebp - local_4]           # 004695e6
    mov dword ptr [edx + field_54a], 0x1         # 004695e9
L_004695f3:
    # block 0x004695f3: entered by je at 0x0046958e; je at 0x0046959a; jne at 0x004695a6; jne at 0x004695bc; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004695f3
    pop ebp                                      # 004695f5
    ret                                          # 004695f6

