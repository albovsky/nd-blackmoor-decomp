# FUN_00423aae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423aae
# extent:       0x00423aae-0x00423af1 (67 code bytes)
# span:         0x00423aae-0x00423af1 (code 67, tables 0, padding 0)
# sha256:       a84843a2eb2124a83a5d3693b27690db5339bd49929982c7f67978ac57be50b5
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423aae_chain_end
# naming:       native port src/original_methods_fl29b.c:m423aae_chain_end (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Walks the [+4] link and then the [+0x38] chain to its last object, with the null-argument and null-link exits; the oracle executes every instruction and both directions of the three jumps. See tasks/fl29b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_38; [edx + n] field_38
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29b.c:m423aae_chain_end (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x00423aae - 0x401000
.globl FUN_00423aae
FUN_00423aae:
    # block 0x00423aae: entry, 6 instruction(s), ends with jne to 0x00423ac1 (forward)
    push ebp                                     # 00423aae
    {load} mov ebp, esp                          # 00423aaf
    sub esp, 0x8                                 # 00423ab1
    mov dword ptr [ebp - local_8], ecx           # 00423ab4
    cmp dword ptr [ebp + arg_8], 0x0             # 00423ab7
    jne.d8 L_00423ac1                            # 00423abb
    # block 0x00423abd: entered by fall-through of jne at 0x00423abb, 2 instruction(s), ends with forward jump to 0x00423aeb
    {load} xor eax, eax                          # 00423abd
    jmp.d8 L_00423aeb                            # 00423abf
L_00423ac1:
    # block 0x00423ac1: entered by jne at 0x00423abb, 5 instruction(s), ends with jne to 0x00423ad4 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00423ac1
    mov ecx, dword ptr [eax + field_4]           # 00423ac4
    mov dword ptr [ebp - local_4], ecx           # 00423ac7
    cmp dword ptr [ebp - local_4], 0x0           # 00423aca
    jne.d8 L_00423ad4                            # 00423ace
    # block 0x00423ad0: entered by fall-through of jne at 0x00423ace, 2 instruction(s), ends with forward jump to 0x00423aeb
    {load} xor eax, eax                          # 00423ad0
    jmp.d8 L_00423aeb                            # 00423ad2
L_00423ad4:
    # block 0x00423ad4: entered by jne at 0x00423ace; jmp at 0x00423ae6, 3 instruction(s), ends with je to 0x00423ae8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00423ad4
    cmp dword ptr [edx + field_38], 0x0          # 00423ad7
    je.d8 L_00423ae8                             # 00423adb
    # block 0x00423add: entered by fall-through of je at 0x00423adb, 4 instruction(s), ends with backward jump to 0x00423ad4
    mov eax, dword ptr [ebp - local_4]           # 00423add
    mov ecx, dword ptr [eax + field_38]          # 00423ae0
    mov dword ptr [ebp - local_4], ecx           # 00423ae3
    jmp.d8 L_00423ad4                            # 00423ae6
L_00423ae8:
    # block 0x00423ae8: entered by je at 0x00423adb, 1 instruction(s), falls into the block at 0x00423aeb
    mov eax, dword ptr [ebp - local_4]           # 00423ae8
L_00423aeb:
    # block 0x00423aeb: entered by jmp at 0x00423abf; jmp at 0x00423ad2, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00423aeb
    pop ebp                                      # 00423aed
    ret 0x4                                      # 00423aee

