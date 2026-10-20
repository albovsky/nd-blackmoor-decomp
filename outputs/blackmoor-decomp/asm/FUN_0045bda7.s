# FUN_0045bda7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045bda7
# extent:       0x0045bda7-0x0045be3f (152 code bytes)
# span:         0x0045bda7-0x0045be3f (code 152, tables 0, padding 0)
# sha256:       002f90b1e09da9cfc5472c85a63b93924d5cf2b1dc7577bd6e9dd480a7f2f58a
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         score_check
# naming:       native port src/action_family_da_runtime.c:score_check (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with score_check (returns 1 on a win with won/state/finish_kind stores, else 0 and no store). Field-model object; count from the body word +0x23; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_23, field_b6, field_162; [ecx + n] field_b8, field_16a; [edx + n] field_23, field_24
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_da_runtime.c:score_check (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_b6, 0xb6  # offset +0xb6
.equ field_b8, 0xb8  # offset +0xb8
.equ field_162, 0x162  # offset +0x162
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------

.org 0x0045bda7 - 0x401000
.globl FUN_0045bda7
FUN_0045bda7:
    # block 0x0045bda7: entry, 15 instruction(s), ends with jne to 0x0045be06 (forward)
    push ebp                                     # 0045bda7
    {load} mov ebp, esp                          # 0045bda8
    sub esp, 0x8                                 # 0045bdaa
    mov dword ptr [ebp - local_8], ecx           # 0045bdad
    mov eax, dword ptr [ebp - local_8]           # 0045bdb0
    movsx ecx, word ptr [eax + field_1e]         # 0045bdb3
    imul ecx, ecx, 0x8d                          # 0045bdb7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045bdbd
    mov dword ptr [ebp - local_4], edx           # 0045bdc3
    mov eax, dword ptr [ebp - local_8]           # 0045bdc6
    movsx ecx, word ptr [eax + field_b6]         # 0045bdc9
    mov edx, dword ptr [ebp - local_4]           # 0045bdd0
    movsx eax, word ptr [edx + field_23]         # 0045bdd3
    {load} cmp ecx, eax                          # 0045bdd7
    jne.d8 L_0045be06                            # 0045bdd9
    # block 0x0045bddb: entered by fall-through of jne at 0x0045bdd9, 8 instruction(s), ends with forward jump to 0x0045be3b
    mov ecx, dword ptr [ebp - local_8]           # 0045bddb
    mov dword ptr [ecx + field_16a], 0x1         # 0045bdde
    mov edx, dword ptr [ebp - local_8]           # 0045bde8
    mov dword ptr [edx + field_24], 0x7          # 0045bdeb
    mov eax, dword ptr [ebp - local_8]           # 0045bdf2
    mov dword ptr [eax + field_162], 0x1         # 0045bdf5
    mov eax, 0x1                                 # 0045bdff
    jmp.d8 L_0045be3b                            # 0045be04
L_0045be06:
    # block 0x0045be06: entered by jne at 0x0045bdd9, 6 instruction(s), ends with jne to 0x0045be39 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045be06
    movsx edx, word ptr [ecx + field_b8]         # 0045be09
    mov eax, dword ptr [ebp - local_4]           # 0045be10
    movsx ecx, word ptr [eax + field_23]         # 0045be13
    {load} cmp edx, ecx                          # 0045be17
    jne.d8 L_0045be39                            # 0045be19
    # block 0x0045be1b: entered by fall-through of jne at 0x0045be19, 6 instruction(s), ends with forward jump to 0x0045be3b
    mov edx, dword ptr [ebp - local_8]           # 0045be1b
    mov dword ptr [edx + field_24], 0x8          # 0045be1e
    mov eax, dword ptr [ebp - local_8]           # 0045be25
    mov dword ptr [eax + field_162], 0x1         # 0045be28
    mov eax, 0x1                                 # 0045be32
    jmp.d8 L_0045be3b                            # 0045be37
L_0045be39:
    # block 0x0045be39: entered by jne at 0x0045be19, 1 instruction(s), falls into the block at 0x0045be3b
    {load} xor eax, eax                          # 0045be39
L_0045be3b:
    # block 0x0045be3b: entered by jmp at 0x0045be04; jmp at 0x0045be37, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045be3b
    pop ebp                                      # 0045be3d
    ret                                          # 0045be3e

