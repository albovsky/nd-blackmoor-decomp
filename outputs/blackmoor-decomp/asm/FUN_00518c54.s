# FUN_00518c54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518c54
# extent:       0x00518c54-0x00518c82 (46 code bytes)
# span:         0x00518c54-0x00518c82 (code 46, tables 0, padding 0)
# sha256:       d75dd5dc934739040457d9738cf88c712bce93e2fbebf603a2fbd47780c6e691
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518c54
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00518c54 - 0x401000
.globl FUN_00518c54
FUN_00518c54:
    # block 0x00518c54: entry, 21 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00518c54
    push esi                                     # 00518c58
    push edi                                     # 00518c59
    mov esi, dword ptr [eax]                     # 00518c5a
    mov edi, dword ptr [eax + field_4]           # 00518c5c
    {load} mov ecx, esi                          # 00518c5f
    {load} add esi, esi                          # 00518c61
    mov dword ptr [eax], esi                     # 00518c63
    lea esi, [edi + edi]                         # 00518c65
    shr ecx, 0x1f                                # 00518c68
    {load} or esi, ecx                           # 00518c6b
    mov ecx, dword ptr [eax + field_8]           # 00518c6d
    {load} mov edx, edi                          # 00518c70
    mov dword ptr [eax + field_4], esi           # 00518c72
    shr edx, 0x1f                                # 00518c75
    shl ecx                                      # 00518c78
    {load} or ecx, edx                           # 00518c7a
    pop edi                                      # 00518c7c
    mov dword ptr [eax + field_8], ecx           # 00518c7d
    pop esi                                      # 00518c80
    ret                                          # 00518c81

