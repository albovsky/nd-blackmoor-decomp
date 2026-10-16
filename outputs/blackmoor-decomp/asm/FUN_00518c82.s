# FUN_00518c82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518c82
# extent:       0x00518c82-0x00518caf (45 code bytes)
# span:         0x00518c82-0x00518caf (code 45, tables 0, padding 0)
# sha256:       eb0e58bcb47b85c53447896f31ae1143bab82582ffdb61aba2f6b8d63cf89def
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518c82
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

.org 0x00518c82 - 0x401000
.globl FUN_00518c82
FUN_00518c82:
    # block 0x00518c82: entry, 21 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00518c82
    push esi                                     # 00518c86
    push edi                                     # 00518c87
    mov edx, dword ptr [eax + field_8]           # 00518c88
    mov ecx, dword ptr [eax + field_4]           # 00518c8b
    {load} mov esi, edx                          # 00518c8e
    {load} mov edi, ecx                          # 00518c90
    shl esi, 0x1f                                # 00518c92
    shr ecx                                      # 00518c95
    {load} or ecx, esi                           # 00518c97
    mov dword ptr [eax + field_4], ecx           # 00518c99
    mov ecx, dword ptr [eax]                     # 00518c9c
    shl edi, 0x1f                                # 00518c9e
    shr ecx                                      # 00518ca1
    shr edx                                      # 00518ca3
    {load} or ecx, edi                           # 00518ca5
    pop edi                                      # 00518ca7
    mov dword ptr [eax + field_8], edx           # 00518ca8
    mov dword ptr [eax], ecx                     # 00518cab
    pop esi                                      # 00518cad
    ret                                          # 00518cae

