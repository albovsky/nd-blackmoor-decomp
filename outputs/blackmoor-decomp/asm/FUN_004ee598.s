# FUN_004ee598
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee598
# extent:       0x004ee598-0x004ee5b8 (32 code bytes)
# span:         0x004ee598-0x004ee5b8 (code 32, tables 0, padding 0)
# sha256:       0bdf2fa36aa7ebb5b2e8c1945465e30e409b73ac3844bd3602dcfa96e184b7cf
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee598_lifted
# naming:       native port src/original_methods_fl39d.c:m4ee598_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (26 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4af
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ee598_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4af, 0x4af  # offset +0x4af

# --- external targets -----------------------------------------------

.org 0x004ee598 - 0x401000
.globl FUN_004ee598
FUN_004ee598:
    # block 0x004ee598: entry, 7 instruction(s), ends with je to 0x004ee5b2 (forward)
    push ebp                                     # 004ee598
    {load} mov ebp, esp                          # 004ee599
    push ecx                                     # 004ee59b
    mov dword ptr [ebp - local_4], ecx           # 004ee59c
    mov eax, dword ptr [ebp - local_4]           # 004ee59f
    cmp dword ptr [eax + field_4af], 0x1         # 004ee5a2
    je.d8 L_004ee5b2                             # 004ee5a9
    # block 0x004ee5ab: entered by fall-through of je at 0x004ee5a9, 2 instruction(s), ends with forward jump to 0x004ee5b4
    mov eax, 0x1                                 # 004ee5ab
    jmp.d8 L_004ee5b4                            # 004ee5b0
L_004ee5b2:
    # block 0x004ee5b2: entered by je at 0x004ee5a9, 1 instruction(s), falls into the block at 0x004ee5b4
    {load} xor eax, eax                          # 004ee5b2
L_004ee5b4:
    # block 0x004ee5b4: entered by jmp at 0x004ee5b0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee5b4
    pop ebp                                      # 004ee5b6
    ret                                          # 004ee5b7

