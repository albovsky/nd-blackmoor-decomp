# FUN_004cec6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cec6c
# extent:       0x004cec6c-0x004cecf7 (139 code bytes)
# span:         0x004cec6c-0x004cecf7 (code 139, tables 0, padding 0)
# sha256:       5c0551332384f5bce6d1ff1a9dfe1968838cd4e035c9882992de01d5c1e2f0f1
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cec6c_bump_counter
# naming:       native port src/original_methods_fl28c.c:m4cec6c_bump_counter (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4cec6c_bump_counter (counter bump and clamp). Oracle: 39/39 instructions of the 139 code bytes, 8/8 jcc directions, 225 scenarios. See tasks/fl28c-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_23, field_1ca, field_222, field_246; [ecx + n] field_1ca, field_226; [edx + n] field_1ca, field_226, field_246
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28c.c:m4cec6c_bump_counter (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_23, 0x23  # offset +0x23
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_246, 0x246  # offset +0x246

# --- external targets -----------------------------------------------

.org 0x004cec6c - 0x401000
.globl FUN_004cec6c
FUN_004cec6c:
    # block 0x004cec6c: entry, 7 instruction(s), ends with je to 0x004cec99 (forward)
    push ebp                                     # 004cec6c
    {load} mov ebp, esp                          # 004cec6d
    sub esp, 0x8                                 # 004cec6f
    mov dword ptr [ebp - local_8], ecx           # 004cec72
    mov eax, dword ptr [ebp - local_8]           # 004cec75
    cmp dword ptr [eax + field_222], 0x0         # 004cec78
    je.d8 L_004cec99                             # 004cec7f
    # block 0x004cec81: entered by fall-through of je at 0x004cec7f, 3 instruction(s), ends with je to 0x004cec99 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004cec81
    cmp dword ptr [ecx + field_226], 0x0         # 004cec84
    je.d8 L_004cec99                             # 004cec8b
    # block 0x004cec8d: entered by fall-through of je at 0x004cec8b, 3 instruction(s), ends with jne to 0x004cec9b (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cec8d
    cmp dword ptr [edx + field_246], -0x1        # 004cec90
    jne.d8 L_004cec9b                            # 004cec97
L_004cec99:
    # block 0x004cec99: entered by je at 0x004cec7f; je at 0x004cec8b; fall-through of jne at 0x004cec97, 1 instruction(s), ends with forward jump to 0x004cecf3
    jmp.d8 L_004cecf3                            # 004cec99
L_004cec9b:
    # block 0x004cec9b: entered by jne at 0x004cec97, 18 instruction(s), ends with jle to 0x004cecf3 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cec9b
    mov ecx, dword ptr [eax + field_246]         # 004cec9e
    imul ecx, ecx, 0x35                          # 004ceca4
    mov edx, dword ptr [ebp - local_8]           # 004ceca7
    mov eax, dword ptr [edx + field_226]         # 004cecaa
    {load} add eax, ecx                          # 004cecb0
    mov dword ptr [ebp - local_4], eax           # 004cecb2
    mov ecx, dword ptr [ebp - local_8]           # 004cecb5
    mov dx, word ptr [ecx + field_1ca]           # 004cecb8
    add dx, 0x1                                  # 004cecbf
    mov eax, dword ptr [ebp - local_8]           # 004cecc3
    mov word ptr [eax + field_1ca], dx           # 004cecc6
    mov ecx, dword ptr [ebp - local_8]           # 004ceccd
    movsx edx, word ptr [ecx + field_1ca]        # 004cecd0
    mov eax, dword ptr [ebp - local_4]           # 004cecd7
    movsx ecx, word ptr [eax + field_23]         # 004cecda
    {load} cmp edx, ecx                          # 004cecde
    jle.d8 L_004cecf3                            # 004cece0
    # block 0x004cece2: entered by fall-through of jle at 0x004cece0, 4 instruction(s), falls into the block at 0x004cecf3
    mov edx, dword ptr [ebp - local_8]           # 004cece2
    mov eax, dword ptr [ebp - local_4]           # 004cece5
    mov cx, word ptr [eax + field_23]            # 004cece8
    mov word ptr [edx + field_1ca], cx           # 004cecec
L_004cecf3:
    # block 0x004cecf3: entered by jmp at 0x004cec99; jle at 0x004cece0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cecf3
    pop ebp                                      # 004cecf5
    ret                                          # 004cecf6

