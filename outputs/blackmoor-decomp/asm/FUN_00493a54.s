# FUN_00493a54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493a54
# extent:       0x00493a54-0x00493ad8 (132 code bytes)
# span:         0x00493a54-0x00493ad8 (code 132, tables 0, padding 0)
# sha256:       bf271bda3d6452a29b90cba7b2659bf0448568c347ec5c06cb4a13a482539bbb
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493a54_lifted
# naming:       native port src/original_methods_fl39d.c:m493a54_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (24 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1f77, field_200b, field_47a5; [ecx + n] field_200b, field_479d, field_47a1; [edx + n] field_4799
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m493a54_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1f77, 0x1f77  # offset +0x1f77
.equ field_200b, 0x200b  # offset +0x200b
.equ field_4799, 0x4799  # offset +0x4799
.equ field_479d, 0x479d  # offset +0x479d
.equ field_47a1, 0x47a1  # offset +0x47a1
.equ field_47a5, 0x47a5  # offset +0x47a5

# --- external targets -----------------------------------------------

.org 0x00493a54 - 0x401000
.globl FUN_00493a54
FUN_00493a54:
    # block 0x00493a54: entry, 7 instruction(s), ends with jne to 0x00493a6e (forward)
    push ebp                                     # 00493a54
    {load} mov ebp, esp                          # 00493a55
    push ecx                                     # 00493a57
    mov dword ptr [ebp - local_4], ecx           # 00493a58
    mov eax, dword ptr [ebp - local_4]           # 00493a5b
    cmp dword ptr [eax + field_1f77], 0x0        # 00493a5e
    jne.d8 L_00493a6e                            # 00493a65
    # block 0x00493a67: entered by fall-through of jne at 0x00493a65, 2 instruction(s), ends with forward jump to 0x00493ad4
    mov eax, 0x1                                 # 00493a67
    jmp.d8 L_00493ad4                            # 00493a6c
L_00493a6e:
    # block 0x00493a6e: entered by jne at 0x00493a65, 4 instruction(s), ends with jl to 0x00493ac2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00493a6e
    mov edx, dword ptr [0x583106]                # 00493a71
    cmp edx, dword ptr [ecx + field_479d]        # 00493a77
    jl.d8 L_00493ac2                             # 00493a7d
    # block 0x00493a7f: entered by fall-through of jl at 0x00493a7d, 4 instruction(s), ends with jg to 0x00493ac2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00493a7f
    mov ecx, dword ptr [0x58310e]                # 00493a82
    cmp ecx, dword ptr [eax + field_47a5]        # 00493a88
    jg.d8 L_00493ac2                             # 00493a8e
    # block 0x00493a90: entered by fall-through of jg at 0x00493a8e, 4 instruction(s), ends with jl to 0x00493ac2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00493a90
    mov eax, dword ptr [0x583102]                # 00493a93
    cmp eax, dword ptr [edx + field_4799]        # 00493a98
    jl.d8 L_00493ac2                             # 00493a9e
    # block 0x00493aa0: entered by fall-through of jl at 0x00493a9e, 4 instruction(s), ends with jg to 0x00493ac2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00493aa0
    mov edx, dword ptr [0x58310a]                # 00493aa3
    cmp edx, dword ptr [ecx + field_47a1]        # 00493aa9
    jg.d8 L_00493ac2                             # 00493aaf
    # block 0x00493ab1: entered by fall-through of jg at 0x00493aaf, 4 instruction(s), ends with forward jump to 0x00493ad4
    mov eax, dword ptr [ebp - local_4]           # 00493ab1
    mov dword ptr [eax + field_200b], 0x1        # 00493ab4
    {load} xor eax, eax                          # 00493abe
    jmp.d8 L_00493ad4                            # 00493ac0
L_00493ac2:
    # block 0x00493ac2: entered by jl at 0x00493a7d; jg at 0x00493a8e; jl at 0x00493a9e; jg at 0x00493aaf, 3 instruction(s), falls into the block at 0x00493ad4
    mov ecx, dword ptr [ebp - local_4]           # 00493ac2
    mov dword ptr [ecx + field_200b], 0x0        # 00493ac5
    mov eax, 0x1                                 # 00493acf
L_00493ad4:
    # block 0x00493ad4: entered by jmp at 0x00493a6c; jmp at 0x00493ac0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00493ad4
    pop ebp                                      # 00493ad6
    ret                                          # 00493ad7

