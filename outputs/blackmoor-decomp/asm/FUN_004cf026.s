# FUN_004cf026
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf026
# extent:       0x004cf026-0x004cf0a9 (131 code bytes)
# span:         0x004cf026-0x004cf0a9 (code 131, tables 0, padding 0)
# sha256:       653b928813ebf80a73c13a45d6ff97a25d178043dbfb68b176d2b57ac70c4432
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cf026_find_record
# naming:       native port src/original_methods_fl28c.c:m4cf026_find_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4cf026_find_record (record index search). Oracle: 42/42 instructions of the 131 code bytes, 8/8 jcc directions, 84 scenarios. See tasks/fl28c-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_222; [ecx + n] field_23, field_226
# callees:      calls FUN_00516530
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28c.c:m4cf026_find_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_23, 0x23  # offset +0x23
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226

# --- external targets -----------------------------------------------
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x004cf026 - 0x401000
.globl FUN_004cf026
FUN_004cf026:
    # block 0x004cf026: entry, 8 instruction(s), ends with je to 0x004cf04e (forward)
    push ebp                                     # 004cf026
    {load} mov ebp, esp                          # 004cf027
    sub esp, 0xc                                 # 004cf029
    mov dword ptr [ebp - local_c], ecx           # 004cf02c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004cf02f
    mov eax, dword ptr [ebp - local_c]           # 004cf036
    cmp dword ptr [eax + field_222], 0x0         # 004cf039
    je.d8 L_004cf04e                             # 004cf040
    # block 0x004cf042: entered by fall-through of je at 0x004cf040, 3 instruction(s), ends with jne to 0x004cf053 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004cf042
    cmp dword ptr [ecx + field_226], 0x0         # 004cf045
    jne.d8 L_004cf053                            # 004cf04c
L_004cf04e:
    # block 0x004cf04e: entered by je at 0x004cf040; fall-through of jne at 0x004cf04c, 2 instruction(s), ends with forward jump to 0x004cf0a3
    mov eax, dword ptr [ebp - local_4]           # 004cf04e
    jmp.d8 L_004cf0a3                            # 004cf051
L_004cf053:
    # block 0x004cf053: entered by jne at 0x004cf04c, 2 instruction(s), ends with forward jump to 0x004cf065
    mov dword ptr [ebp - local_8], 0x0           # 004cf053
    jmp.d8 L_004cf065                            # 004cf05a
L_004cf05c:
    # block 0x004cf05c: entered by jmp at 0x004cf09e, 3 instruction(s), falls into the block at 0x004cf065
    mov edx, dword ptr [ebp - local_8]           # 004cf05c
    add edx, 0x1                                 # 004cf05f
    mov dword ptr [ebp - local_8], edx           # 004cf062
L_004cf065:
    # block 0x004cf065: entered by jmp at 0x004cf05a, 5 instruction(s), ends with jge to 0x004cf0a0 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004cf065
    mov ecx, dword ptr [eax + field_222]         # 004cf068
    movsx edx, word ptr [ecx + field_23]         # 004cf06e
    cmp dword ptr [ebp - local_8], edx           # 004cf072
    jge.d8 L_004cf0a0                            # 004cf075
    # block 0x004cf077: entered by fall-through of jge at 0x004cf075, 12 instruction(s), calls FUN_00516530, ends with jne to 0x004cf09e (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cf077
    imul eax, eax, 0x35                          # 004cf07a
    mov ecx, dword ptr [ebp - local_c]           # 004cf07d
    mov edx, dword ptr [ecx + field_226]         # 004cf080
    {load} add edx, eax                          # 004cf086
    push edx                                     # 004cf088
    mov eax, dword ptr [ebp + arg_8]             # 004cf089
    push eax                                     # 004cf08c
    call FUN_00516530                            # 004cf08d
    add esp, 0x8                                 # 004cf092
    test eax, eax                                # 004cf095
    jne.d8 L_004cf09e                            # 004cf097
    # block 0x004cf099: entered by fall-through of jne at 0x004cf097, 2 instruction(s), ends with forward jump to 0x004cf0a3
    mov eax, dword ptr [ebp - local_8]           # 004cf099
    jmp.d8 L_004cf0a3                            # 004cf09c
L_004cf09e:
    # block 0x004cf09e: entered by jne at 0x004cf097, 1 instruction(s), ends with backward jump to 0x004cf05c
    jmp.d8 L_004cf05c                            # 004cf09e
L_004cf0a0:
    # block 0x004cf0a0: entered by jge at 0x004cf075, 1 instruction(s), falls into the block at 0x004cf0a3
    mov eax, dword ptr [ebp - local_4]           # 004cf0a0
L_004cf0a3:
    # block 0x004cf0a3: entered by jmp at 0x004cf051; jmp at 0x004cf09c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004cf0a3
    pop ebp                                      # 004cf0a5
    ret 0x4                                      # 004cf0a6

