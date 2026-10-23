# FUN_004270de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004270de
# extent:       0x004270de-0x004271cd (239 code bytes)
# span:         0x004270de-0x004271cd (code 239, tables 0, padding 0)
# sha256:       864e0ea946525542113ee4feb79ffe654bef14abdb778a57ff67d3f080988c88
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004270de
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_ca16d, field_ca1d5; [ecx + n] field_ca16d, field_ca1d5; [edx + n] field_ca1d5
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4270de_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 78 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_ca16d, 0xca16d  # offset +0xca16d
.equ field_ca1d5, 0xca1d5  # offset +0xca1d5

# --- external targets -----------------------------------------------

.org 0x004270de - 0x401000
.globl FUN_004270de
FUN_004270de:
    # block 0x004270de: entry, 14 instruction(s), ends with jl to 0x0042711b (forward)
    push ebp                                     # 004270de
    {load} mov ebp, esp                          # 004270df
    sub esp, 0x8                                 # 004270e1
    push esi                                     # 004270e4
    push edi                                     # 004270e5
    mov dword ptr [ebp - local_8], ecx           # 004270e6
    mov eax, dword ptr [ebp - local_8]           # 004270e9
    mov dword ptr [eax + field_ca1d5], 0x0       # 004270ec
    mov ecx, dword ptr [ebp - local_8]           # 004270f6
    mov dword ptr [ecx + field_ca16d], 0x0       # 004270f9
    mov edx, dword ptr [ebp - local_8]           # 00427103
    mov eax, dword ptr [edx + field_ca1d5]       # 00427106
    cmp eax, dword ptr [0x63ca20]                # 0042710c
    jl.d8 L_0042711b                             # 00427112
    # block 0x00427114: entered by fall-through of jl at 0x00427112, 2 instruction(s), ends with forward jump to 0x004271c7
    {load} xor eax, eax                          # 00427114
    jmp.d32 L_004271c7                           # 00427116
L_0042711b:
    # block 0x0042711b: entered by jl at 0x00427112, 9 instruction(s), ends with je to 0x00427145 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0042711b
    mov edx, dword ptr [ecx + field_ca1d5]       # 0042711e
    mov eax, dword ptr [0x63ca24]                # 00427124
    mov ecx, dword ptr [eax + 4*edx]             # 00427129
    mov dword ptr [ebp - local_4], ecx           # 0042712c
    mov edx, dword ptr [ebp - local_4]           # 0042712f
    movsx eax, byte ptr [edx]                    # 00427132
    cmp eax, 0x2d                                # 00427135
    je.d8 L_00427145                             # 00427138
    # block 0x0042713a: entered by fall-through of je at 0x00427138, 4 instruction(s), ends with jne to 0x00427182 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0042713a
    movsx edx, byte ptr [ecx]                    # 0042713d
    cmp edx, 0x2f                                # 00427140
    jne.d8 L_00427182                            # 00427143
L_00427145:
    # block 0x00427145: entered by je at 0x00427138; fall-through of jne at 0x00427143, 21 instruction(s), ends with forward jump to 0x004271ad
    mov eax, dword ptr [ebp - local_8]           # 00427145
    mov dword ptr [eax + field_ca16d], 0x1       # 00427148
    mov ecx, dword ptr [ebp - local_4]           # 00427152
    add ecx, 0x1                                 # 00427155
    {load} mov edi, ecx                          # 00427158
    mov edx, dword ptr [ebp - local_8]           # 0042715a
    add edx, 0xca171                             # 0042715d
    or ecx, -0x1                                 # 00427163
    {load} xor eax, eax                          # 00427166
    repne scasb al, byte ptr es:[edi]            # 00427168
    not ecx                                      # 0042716a
    {load} sub edi, ecx                          # 0042716c
    {load} mov esi, edi                          # 0042716e
    {load} mov eax, ecx                          # 00427170
    {load} mov edi, edx                          # 00427172
    shr ecx, 0x2                                 # 00427174
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00427177
    {load} mov ecx, eax                          # 00427179
    and ecx, 0x3                                 # 0042717b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042717e
    jmp.d8 L_004271ad                            # 00427180
L_00427182:
    # block 0x00427182: entered by jne at 0x00427143, 17 instruction(s), falls into the block at 0x004271ad
    mov edi, dword ptr [ebp - local_4]           # 00427182
    mov ecx, dword ptr [ebp - local_8]           # 00427185
    add ecx, 0xca171                             # 00427188
    {load} mov edx, ecx                          # 0042718e
    or ecx, -0x1                                 # 00427190
    {load} xor eax, eax                          # 00427193
    repne scasb al, byte ptr es:[edi]            # 00427195
    not ecx                                      # 00427197
    {load} sub edi, ecx                          # 00427199
    {load} mov esi, edi                          # 0042719b
    {load} mov eax, ecx                          # 0042719d
    {load} mov edi, edx                          # 0042719f
    shr ecx, 0x2                                 # 004271a1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004271a4
    {load} mov ecx, eax                          # 004271a6
    and ecx, 0x3                                 # 004271a8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004271ab
L_004271ad:
    # block 0x004271ad: entered by jmp at 0x00427180, 6 instruction(s), falls into the block at 0x004271c7
    mov ecx, dword ptr [ebp - local_8]           # 004271ad
    mov edx, dword ptr [ecx + field_ca1d5]       # 004271b0
    add edx, 0x1                                 # 004271b6
    mov eax, dword ptr [ebp - local_8]           # 004271b9
    mov dword ptr [eax + field_ca1d5], edx       # 004271bc
    mov eax, 0x1                                 # 004271c2
L_004271c7:
    # block 0x004271c7: entered by jmp at 0x00427116, 5 instruction(s), ends with ret
    pop edi                                      # 004271c7
    pop esi                                      # 004271c8
    {load} mov esp, ebp                          # 004271c9
    pop ebp                                      # 004271cb
    ret                                          # 004271cc

