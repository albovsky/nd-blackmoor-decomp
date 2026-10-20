# FUN_00515d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515d70
# extent:       0x00515d70-0x00515da0 (48 code bytes)
# span:         0x00515d70-0x00515da0 (code 48, tables 0, padding 0)
# sha256:       cc801a9939ad3bb3e8eedd15c6bb6e85bc2c67116117ff95d8a9d4d3340dafb5
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __strrev
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (library_internal_unreached_by_game, function-ledger-overrides.json not_needed_entries)
# name-note:    No caller, no address taken: __strrev: finds NUL, swaps characters in place from both ends, returns the string; ordinary string routine
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00515d70 - 0x401000
.globl FUN_00515d70
FUN_00515d70:
    # block 0x00515d70: entry, 12 instruction(s), ends with je to 0x00515d9a (forward)
    push ebp                                     # 00515d70
    {load} mov ebp, esp                          # 00515d71
    push edi                                     # 00515d73
    push esi                                     # 00515d74
    mov edi, dword ptr [ebp + arg_8]             # 00515d75
    {load} mov edx, edi                          # 00515d78
    {load} mov esi, edi                          # 00515d7a
    {load} xor eax, eax                          # 00515d7c
    or ecx, -0x1                                 # 00515d7e
    repne scasb al, byte ptr es:[edi]            # 00515d81
    cmp ecx, -0x2                                # 00515d83
    je.d8 L_00515d9a                             # 00515d86
    # block 0x00515d88: entered by fall-through of je at 0x00515d86, 2 instruction(s), falls into the block at 0x00515d8a
    dec edi                                      # 00515d88
    dec edi                                      # 00515d89
L_00515d8a:
    # block 0x00515d8a: entered by jmp at 0x00515d98, 2 instruction(s), ends with jae to 0x00515d9a (forward)
    {load} cmp esi, edi                          # 00515d8a
    jae.d8 L_00515d9a                            # 00515d8c
    # block 0x00515d8e: entered by fall-through of jae at 0x00515d8c, 7 instruction(s), ends with backward jump to 0x00515d8a
    mov ah, byte ptr [esi]                       # 00515d8e
    mov al, byte ptr [edi]                       # 00515d90
    mov byte ptr [esi], al                       # 00515d92
    mov byte ptr [edi], ah                       # 00515d94
    inc esi                                      # 00515d96
    dec edi                                      # 00515d97
    jmp.d8 L_00515d8a                            # 00515d98
L_00515d9a:
    # block 0x00515d9a: entered by je at 0x00515d86; jae at 0x00515d8c, 5 instruction(s), ends with ret
    {load} mov eax, edx                          # 00515d9a
    pop esi                                      # 00515d9c
    pop edi                                      # 00515d9d
    leave                                        # 00515d9e
    ret                                          # 00515d9f

