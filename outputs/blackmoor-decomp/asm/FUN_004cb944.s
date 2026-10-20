# FUN_004cb944
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb944
# extent:       0x004cb944-0x004cb9d1 (141 code bytes)
# span:         0x004cb944-0x004cb9d1 (code 141, tables 0, padding 0)
# sha256:       c7c697d90d471e234f475b8f4279143d00c8fbbe5c0528349d3067ba2278e589
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         find_entry
# naming:       native port src/action_family_1c_runtime.c:find_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with find_entry (no file: NULL; else +0x136 reset and counted per miss; sign-extended id, first match). Returns a C1cEntry pointer; oracle does not compare +0x136.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1a, field_21; [ecx + n] field_25, field_136; [edx + n] field_1a, field_136
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_1c_runtime.c:find_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_136, 0x136  # offset +0x136

# --- external targets -----------------------------------------------

.org 0x004cb944 - 0x401000
.globl FUN_004cb944
FUN_004cb944:
    # block 0x004cb944: entry, 7 instruction(s), ends with jne to 0x004cb958 (forward)
    push ebp                                     # 004cb944
    {load} mov ebp, esp                          # 004cb945
    push ecx                                     # 004cb947
    mov dword ptr [ebp - local_4], ecx           # 004cb948
    mov eax, dword ptr [ebp - local_4]           # 004cb94b
    cmp dword ptr [eax + field_1a], 0x0          # 004cb94e
    jne.d8 L_004cb958                            # 004cb952
    # block 0x004cb954: entered by fall-through of jne at 0x004cb952, 2 instruction(s), ends with forward jump to 0x004cb9cb
    {load} xor eax, eax                          # 004cb954
    jmp.d8 L_004cb9cb                            # 004cb956
L_004cb958:
    # block 0x004cb958: entered by jne at 0x004cb952, 3 instruction(s), ends with forward jump to 0x004cb97c
    mov ecx, dword ptr [ebp - local_4]           # 004cb958
    mov dword ptr [ecx + field_136], 0x0         # 004cb95b
    jmp.d8 L_004cb97c                            # 004cb965
L_004cb967:
    # block 0x004cb967: entered by jmp at 0x004cb9c7, 5 instruction(s), falls into the block at 0x004cb97c
    mov edx, dword ptr [ebp - local_4]           # 004cb967
    mov eax, dword ptr [edx + field_136]         # 004cb96a
    add eax, 0x1                                 # 004cb970
    mov ecx, dword ptr [ebp - local_4]           # 004cb973
    mov dword ptr [ecx + field_136], eax         # 004cb976
L_004cb97c:
    # block 0x004cb97c: entered by jmp at 0x004cb965, 6 instruction(s), ends with jge to 0x004cb9c9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb97c
    mov eax, dword ptr [edx + field_1a]          # 004cb97f
    mov ecx, dword ptr [ebp - local_4]           # 004cb982
    mov edx, dword ptr [ecx + field_136]         # 004cb985
    cmp edx, dword ptr [eax + field_21]          # 004cb98b
    jge.d8 L_004cb9c9                            # 004cb98e
    # block 0x004cb990: entered by fall-through of jge at 0x004cb98e, 9 instruction(s), ends with jne to 0x004cb9c7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb990
    mov ecx, dword ptr [eax + field_1a]          # 004cb993
    mov edx, dword ptr [ebp - local_4]           # 004cb996
    mov eax, dword ptr [edx + field_136]         # 004cb999
    imul eax, eax, 0xd                           # 004cb99f
    mov ecx, dword ptr [ecx + field_25]          # 004cb9a2
    movsx edx, word ptr [ecx + eax]              # 004cb9a5
    cmp edx, dword ptr [ebp + arg_8]             # 004cb9a9
    jne.d8 L_004cb9c7                            # 004cb9ac
    # block 0x004cb9ae: entered by fall-through of jne at 0x004cb9ac, 8 instruction(s), ends with forward jump to 0x004cb9cb
    mov eax, dword ptr [ebp - local_4]           # 004cb9ae
    mov ecx, dword ptr [eax + field_1a]          # 004cb9b1
    mov edx, dword ptr [ebp - local_4]           # 004cb9b4
    mov eax, dword ptr [edx + field_136]         # 004cb9b7
    imul eax, eax, 0xd                           # 004cb9bd
    mov ecx, dword ptr [ecx + field_25]          # 004cb9c0
    {load} add eax, ecx                          # 004cb9c3
    jmp.d8 L_004cb9cb                            # 004cb9c5
L_004cb9c7:
    # block 0x004cb9c7: entered by jne at 0x004cb9ac, 1 instruction(s), ends with backward jump to 0x004cb967
    jmp.d8 L_004cb967                            # 004cb9c7
L_004cb9c9:
    # block 0x004cb9c9: entered by jge at 0x004cb98e, 1 instruction(s), falls into the block at 0x004cb9cb
    {load} xor eax, eax                          # 004cb9c9
L_004cb9cb:
    # block 0x004cb9cb: entered by jmp at 0x004cb956; jmp at 0x004cb9c5, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004cb9cb
    pop ebp                                      # 004cb9cd
    ret 0x4                                      # 004cb9ce

