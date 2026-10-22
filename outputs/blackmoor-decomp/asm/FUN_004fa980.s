# FUN_004fa980
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa980
# extent:       0x004fa980-0x004fa9e7 (103 code bytes)
# span:         0x004fa980-0x004fa9e7 (code 103, tables 0, padding 0)
# sha256:       c957dd5c3d5070304fa6e7e97e5355cdb7aecfbe88588a2bdd2fb3ba461418f9
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fa980_construct_record
# naming:       native port src/original_methods_fl39f.c:m4fa980_construct_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: dword [this+0x0] = 0x52e518, then word [this+0xb774] = 0x0, then dword [this+0xb776] = 0x0, then dword [this+0xb77a] = 0x0. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_b77a; [ecx + n] field_b774, field_b77e; [edx + n] field_b776, field_b782
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4fa980_construct_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_b774, 0xb774  # offset +0xb774
.equ field_b776, 0xb776  # offset +0xb776
.equ field_b77a, 0xb77a  # offset +0xb77a
.equ field_b77e, 0xb77e  # offset +0xb77e
.equ field_b782, 0xb782  # offset +0xb782

# --- external targets -----------------------------------------------

.org 0x004fa980 - 0x401000
.globl FUN_004fa980
FUN_004fa980:
    # block 0x004fa980: entry, 27 instruction(s), ends with ret
    push ebp                                     # 004fa980
    {load} mov ebp, esp                          # 004fa981
    push ecx                                     # 004fa983
    push edi                                     # 004fa984
    mov dword ptr [ebp - local_4], ecx           # 004fa985
    mov eax, dword ptr [ebp - local_4]           # 004fa988
    mov dword ptr [eax], 0x52e518                # 004fa98b
    mov ecx, dword ptr [ebp - local_4]           # 004fa991
    mov word ptr [ecx + field_b774], 0x0         # 004fa994
    mov edx, dword ptr [ebp - local_4]           # 004fa99d
    mov dword ptr [edx + field_b776], 0x0        # 004fa9a0
    mov eax, dword ptr [ebp - local_4]           # 004fa9aa
    mov dword ptr [eax + field_b77a], 0x0        # 004fa9ad
    mov ecx, dword ptr [ebp - local_4]           # 004fa9b7
    mov dword ptr [ecx + field_b77e], 0x0        # 004fa9ba
    mov edx, dword ptr [ebp - local_4]           # 004fa9c4
    mov word ptr [edx + field_b782], 0x0         # 004fa9c7
    mov ecx, 0x2dd8                              # 004fa9d0
    {load} xor eax, eax                          # 004fa9d5
    mov edi, dword ptr [ebp - local_4]           # 004fa9d7
    add edi, 0x4                                 # 004fa9da
    rep stosd dword ptr es:[edi], eax            # 004fa9dd
    mov eax, dword ptr [ebp - local_4]           # 004fa9df
    pop edi                                      # 004fa9e2
    {load} mov esp, ebp                          # 004fa9e3
    pop ebp                                      # 004fa9e5
    ret                                          # 004fa9e6

