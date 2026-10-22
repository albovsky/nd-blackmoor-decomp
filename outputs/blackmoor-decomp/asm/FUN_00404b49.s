# FUN_00404b49
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404b49
# extent:       0x00404b49-0x00404be1 (152 code bytes)
# span:         0x00404b49-0x00404be1 (code 152, tables 0, padding 0)
# sha256:       2dd866d3a0e3fb57b48a68a750aa2e9a47deb9c9f34ef672b7e8370ea63f3bbc
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404b49
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_8c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404b49_lifted (function ledger class candidate_port; also m405b72_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------

.org 0x00404b49 - 0x401000
.globl FUN_00404b49
FUN_00404b49:
    # block 0x00404b49: entry, 25 instruction(s), ends with forward jump to 0x00404b92
    push ebp                                     # 00404b49
    {load} mov ebp, esp                          # 00404b4a
    sub esp, 0x8                                 # 00404b4c
    push esi                                     # 00404b4f
    push edi                                     # 00404b50
    mov dword ptr [ebp - local_8], ecx           # 00404b51
    mov edi, 0x53e92c                            # 00404b54
    mov eax, dword ptr [ebp - local_8]           # 00404b59
    add eax, 0x8c                                # 00404b5c
    {load} mov edx, eax                          # 00404b61
    or ecx, -0x1                                 # 00404b63
    {load} xor eax, eax                          # 00404b66
    repne scasb al, byte ptr es:[edi]            # 00404b68
    not ecx                                      # 00404b6a
    {load} sub edi, ecx                          # 00404b6c
    {load} mov esi, edi                          # 00404b6e
    {load} mov eax, ecx                          # 00404b70
    {load} mov edi, edx                          # 00404b72
    shr ecx, 0x2                                 # 00404b74
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00404b77
    {load} mov ecx, eax                          # 00404b79
    and ecx, 0x3                                 # 00404b7b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00404b7e
    mov dword ptr [ebp - local_4], 0x0           # 00404b80
    jmp.d8 L_00404b92                            # 00404b87
L_00404b89:
    # block 0x00404b89: entered by jmp at 0x00404bd9, 3 instruction(s), falls into the block at 0x00404b92
    mov ecx, dword ptr [ebp - local_4]           # 00404b89
    add ecx, 0x1                                 # 00404b8c
    mov dword ptr [ebp - local_4], ecx           # 00404b8f
L_00404b92:
    # block 0x00404b92: entered by jmp at 0x00404b87, 2 instruction(s), ends with jge to 0x00404bdb (forward)
    cmp dword ptr [ebp - local_4], 0x46          # 00404b92
    jge.d8 L_00404bdb                            # 00404b96
    # block 0x00404b98: entered by fall-through of jge at 0x00404b96, 23 instruction(s), ends with backward jump to 0x00404b89
    mov edx, dword ptr [ebp - local_4]           # 00404b98
    imul edx, edx, 0x16d                         # 00404b9b
    add edx, 0x571b90                            # 00404ba1
    {load} mov edi, edx                          # 00404ba7
    mov eax, dword ptr [ebp - local_4]           # 00404ba9
    add eax, 0x1                                 # 00404bac
    imul eax, eax, 0x30                          # 00404baf
    mov ecx, dword ptr [ebp - local_8]           # 00404bb2
    lea edx, [ecx + eax + field_8c]              # 00404bb5
    or ecx, -0x1                                 # 00404bbc
    {load} xor eax, eax                          # 00404bbf
    repne scasb al, byte ptr es:[edi]            # 00404bc1
    not ecx                                      # 00404bc3
    {load} sub edi, ecx                          # 00404bc5
    {load} mov esi, edi                          # 00404bc7
    {load} mov eax, ecx                          # 00404bc9
    {load} mov edi, edx                          # 00404bcb
    shr ecx, 0x2                                 # 00404bcd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00404bd0
    {load} mov ecx, eax                          # 00404bd2
    and ecx, 0x3                                 # 00404bd4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00404bd7
    jmp.d8 L_00404b89                            # 00404bd9
L_00404bdb:
    # block 0x00404bdb: entered by jge at 0x00404b96, 5 instruction(s), ends with ret
    pop edi                                      # 00404bdb
    pop esi                                      # 00404bdc
    {load} mov esp, ebp                          # 00404bdd
    pop ebp                                      # 00404bdf
    ret                                          # 00404be0

