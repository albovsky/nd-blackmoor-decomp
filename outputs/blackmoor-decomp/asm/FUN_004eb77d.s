# FUN_004eb77d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb77d
# extent:       0x004eb77d-0x004eb832 (181 code bytes)
# span:         0x004eb77d-0x004eb840 (code 181, tables 0, padding 14)
# sha256:       0e615355a0f58cbfdc567b3156ad57f4a42e3a5c10f916150f3ffeb6e2e4afe2
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eb77d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_822e; [ecx + n] field_822e; [edx + n] field_822e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_822e, 0x822e  # offset +0x822e

# --- external targets -----------------------------------------------

.org 0x004eb77d - 0x401000
.globl FUN_004eb77d
FUN_004eb77d:
    # block 0x004eb77d: entry, 9 instruction(s), ends with forward jump to 0x004eb7aa
    push ebp                                     # 004eb77d
    {load} mov ebp, esp                          # 004eb77e
    push ecx                                     # 004eb780
    push esi                                     # 004eb781
    push edi                                     # 004eb782
    mov dword ptr [ebp - local_4], ecx           # 004eb783
    mov eax, dword ptr [ebp - local_4]           # 004eb786
    mov dword ptr [eax + field_822e], 0x0        # 004eb789
    jmp.d8 L_004eb7aa                            # 004eb793
L_004eb795:
    # block 0x004eb795: entered by jmp at 0x004eb827, 5 instruction(s), falls into the block at 0x004eb7aa
    mov ecx, dword ptr [ebp - local_4]           # 004eb795
    mov edx, dword ptr [ecx + field_822e]        # 004eb798
    add edx, 0x1                                 # 004eb79e
    mov eax, dword ptr [ebp - local_4]           # 004eb7a1
    mov dword ptr [eax + field_822e], edx        # 004eb7a4
L_004eb7aa:
    # block 0x004eb7aa: entered by jmp at 0x004eb793, 3 instruction(s), ends with jge to 0x004eb82c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eb7aa
    cmp dword ptr [ecx + field_822e], 0x46       # 004eb7ad
    jge.d8 L_004eb82c                            # 004eb7b4
    # block 0x004eb7b6: entered by fall-through of jge at 0x004eb7b4, 35 instruction(s), ends with backward jump to 0x004eb795
    mov edx, dword ptr [ebp - local_4]           # 004eb7b6
    mov eax, dword ptr [edx + field_822e]        # 004eb7b9
    imul eax, eax, 0x6e                          # 004eb7bf
    mov byte ptr [eax + 0x583f1f], 0x0           # 004eb7c2
    mov ecx, dword ptr [ebp - local_4]           # 004eb7c9
    add ecx, 0x712                               # 004eb7cc
    {load} mov edi, ecx                          # 004eb7d2
    mov edx, dword ptr [ebp - local_4]           # 004eb7d4
    mov eax, dword ptr [edx + field_822e]        # 004eb7d7
    imul eax, eax, 0x6e                          # 004eb7dd
    add eax, 0x583f20                            # 004eb7e0
    {load} mov edx, eax                          # 004eb7e5
    or ecx, -0x1                                 # 004eb7e7
    {load} xor eax, eax                          # 004eb7ea
    repne scasb al, byte ptr es:[edi]            # 004eb7ec
    not ecx                                      # 004eb7ee
    {load} sub edi, ecx                          # 004eb7f0
    {load} mov esi, edi                          # 004eb7f2
    {load} mov eax, ecx                          # 004eb7f4
    {load} mov edi, edx                          # 004eb7f6
    shr ecx, 0x2                                 # 004eb7f8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb7fb
    {load} mov ecx, eax                          # 004eb7fd
    and ecx, 0x3                                 # 004eb7ff
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb802
    mov esi, dword ptr [ebp - local_4]           # 004eb804
    add esi, 0x6e1                               # 004eb807
    mov ecx, dword ptr [ebp - local_4]           # 004eb80d
    mov edi, dword ptr [ecx + field_822e]        # 004eb810
    imul edi, edi, 0x6e                          # 004eb816
    add edi, 0x583f5c                            # 004eb819
    mov ecx, 0xc                                 # 004eb81f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb824
    movsb byte ptr es:[edi], byte ptr [esi]      # 004eb826
    jmp.d32 L_004eb795                           # 004eb827
L_004eb82c:
    # block 0x004eb82c: entered by jge at 0x004eb7b4, 5 instruction(s), ends with ret
    pop edi                                      # 004eb82c
    pop esi                                      # 004eb82d
    {load} mov esp, ebp                          # 004eb82e
    pop ebp                                      # 004eb830
    ret                                          # 004eb831

# --- data items (not part of the function) -------------------------
.org 0x004eb832 - 0x401000
PAD_004eb832:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

