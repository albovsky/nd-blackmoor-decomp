# FUN_004271cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004271cd
# extent:       0x004271cd-0x004272b2 (229 code bytes)
# span:         0x004271cd-0x004272b2 (code 229, tables 0, padding 0)
# sha256:       4235f524333c391c45a53a503027b6c70c6bd891405fa11db35404b08e98b3ec
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004271cd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_ca16d, field_ca1d5; [ecx + n] field_ca1d5; [edx + n] field_ca16d
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 77 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_ca16d, 0xca16d  # offset +0xca16d
.equ field_ca1d5, 0xca1d5  # offset +0xca1d5

# --- external targets -----------------------------------------------

.org 0x004271cd - 0x401000
.globl FUN_004271cd
FUN_004271cd:
    # block 0x004271cd: entry, 12 instruction(s), ends with jl to 0x004271fd (forward)
    push ebp                                     # 004271cd
    {load} mov ebp, esp                          # 004271ce
    sub esp, 0x8                                 # 004271d0
    push esi                                     # 004271d3
    push edi                                     # 004271d4
    mov dword ptr [ebp - local_8], ecx           # 004271d5
    mov eax, dword ptr [ebp - local_8]           # 004271d8
    mov dword ptr [eax + field_ca16d], 0x0       # 004271db
    mov ecx, dword ptr [ebp - local_8]           # 004271e5
    mov edx, dword ptr [ecx + field_ca1d5]       # 004271e8
    cmp edx, dword ptr [0x63ca20]                # 004271ee
    jl.d8 L_004271fd                             # 004271f4
    # block 0x004271f6: entered by fall-through of jl at 0x004271f4, 2 instruction(s), ends with forward jump to 0x004272ac
    {load} xor eax, eax                          # 004271f6
    jmp.d32 L_004272ac                           # 004271f8
L_004271fd:
    # block 0x004271fd: entered by jl at 0x004271f4, 9 instruction(s), ends with je to 0x00427228 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004271fd
    mov ecx, dword ptr [eax + field_ca1d5]       # 00427200
    mov edx, dword ptr [0x63ca24]                # 00427206
    mov eax, dword ptr [edx + 4*ecx]             # 0042720c
    mov dword ptr [ebp - local_4], eax           # 0042720f
    mov ecx, dword ptr [ebp - local_4]           # 00427212
    movsx edx, byte ptr [ecx]                    # 00427215
    cmp edx, 0x2d                                # 00427218
    je.d8 L_00427228                             # 0042721b
    # block 0x0042721d: entered by fall-through of je at 0x0042721b, 4 instruction(s), ends with jne to 0x00427267 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0042721d
    movsx ecx, byte ptr [eax]                    # 00427220
    cmp ecx, 0x2f                                # 00427223
    jne.d8 L_00427267                            # 00427226
L_00427228:
    # block 0x00427228: entered by je at 0x0042721b; fall-through of jne at 0x00427226, 22 instruction(s), ends with forward jump to 0x00427292
    mov edx, dword ptr [ebp - local_8]           # 00427228
    mov dword ptr [edx + field_ca16d], 0x1       # 0042722b
    mov eax, dword ptr [ebp - local_4]           # 00427235
    add eax, 0x1                                 # 00427238
    {load} mov edi, eax                          # 0042723b
    mov ecx, dword ptr [ebp - local_8]           # 0042723d
    add ecx, 0xca171                             # 00427240
    {load} mov edx, ecx                          # 00427246
    or ecx, -0x1                                 # 00427248
    {load} xor eax, eax                          # 0042724b
    repne scasb al, byte ptr es:[edi]            # 0042724d
    not ecx                                      # 0042724f
    {load} sub edi, ecx                          # 00427251
    {load} mov esi, edi                          # 00427253
    {load} mov eax, ecx                          # 00427255
    {load} mov edi, edx                          # 00427257
    shr ecx, 0x2                                 # 00427259
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042725c
    {load} mov ecx, eax                          # 0042725e
    and ecx, 0x3                                 # 00427260
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00427263
    jmp.d8 L_00427292                            # 00427265
L_00427267:
    # block 0x00427267: entered by jne at 0x00427226, 17 instruction(s), falls into the block at 0x00427292
    mov edi, dword ptr [ebp - local_4]           # 00427267
    mov ecx, dword ptr [ebp - local_8]           # 0042726a
    add ecx, 0xca171                             # 0042726d
    {load} mov edx, ecx                          # 00427273
    or ecx, -0x1                                 # 00427275
    {load} xor eax, eax                          # 00427278
    repne scasb al, byte ptr es:[edi]            # 0042727a
    not ecx                                      # 0042727c
    {load} sub edi, ecx                          # 0042727e
    {load} mov esi, edi                          # 00427280
    {load} mov eax, ecx                          # 00427282
    {load} mov edi, edx                          # 00427284
    shr ecx, 0x2                                 # 00427286
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00427289
    {load} mov ecx, eax                          # 0042728b
    and ecx, 0x3                                 # 0042728d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00427290
L_00427292:
    # block 0x00427292: entered by jmp at 0x00427265, 6 instruction(s), falls into the block at 0x004272ac
    mov ecx, dword ptr [ebp - local_8]           # 00427292
    mov edx, dword ptr [ecx + field_ca1d5]       # 00427295
    add edx, 0x1                                 # 0042729b
    mov eax, dword ptr [ebp - local_8]           # 0042729e
    mov dword ptr [eax + field_ca1d5], edx       # 004272a1
    mov eax, 0x1                                 # 004272a7
L_004272ac:
    # block 0x004272ac: entered by jmp at 0x004271f8, 5 instruction(s), ends with ret
    pop edi                                      # 004272ac
    pop esi                                      # 004272ad
    {load} mov esp, ebp                          # 004272ae
    pop ebp                                      # 004272b0
    ret                                          # 004272b1

