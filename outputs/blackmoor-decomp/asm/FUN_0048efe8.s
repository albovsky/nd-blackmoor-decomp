# FUN_0048efe8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048efe8
# extent:       0x0048efe8-0x0048f181 (409 code bytes)
# span:         0x0048efe8-0x0048f181 (code 409, tables 0, padding 0)
# sha256:       b8301c16ee05e57c25f634b2c76e4a934ed75aa43880f3abc818765e51d23ffa
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48efe8_lifted
# naming:       native port src/original_methods_fl41.c:m48efe8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 11 seeds; oracle: 107/107 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_3fe, field_421, field_423, field_429, field_42d; [ecx + n] field_aa, field_ac, field_121, field_162, field_3fe, field_425, field_42f; [edx + n] field_100, field_141, field_421, field_427, field_42d
# callees:      calls FUN_004fb77a, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m48efe8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 107 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ac, 0xac  # offset +0xac
.equ field_100, 0x100  # offset +0x100
.equ field_121, 0x121  # offset +0x121
.equ field_141, 0x141  # offset +0x141
.equ field_162, 0x162  # offset +0x162
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_421, 0x421  # offset +0x421
.equ field_423, 0x423  # offset +0x423
.equ field_425, 0x425  # offset +0x425
.equ field_427, 0x427  # offset +0x427
.equ field_429, 0x429  # offset +0x429
.equ field_42d, 0x42d  # offset +0x42d
.equ field_42f, 0x42f  # offset +0x42f

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x0048efe8 - 0x401000
.globl FUN_0048efe8
FUN_0048efe8:
    # block 0x0048efe8: entry, 13 instruction(s), ends with je to 0x0048f08e (forward)
    push ebp                                     # 0048efe8
    {load} mov ebp, esp                          # 0048efe9
    sub esp, 0x8                                 # 0048efeb
    push esi                                     # 0048efee
    push edi                                     # 0048efef
    mov dword ptr [ebp - local_8], ecx           # 0048eff0
    mov eax, dword ptr [ebp - local_8]           # 0048eff3
    movsx ecx, word ptr [eax + field_1e]         # 0048eff6
    imul ecx, ecx, 0x8d                          # 0048effa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048f000
    mov dword ptr [ebp - local_4], edx           # 0048f006
    cmp dword ptr [ebp + arg_8], 0x0             # 0048f009
    je.d8 L_0048f08e                             # 0048f00d
    # block 0x0048f00f: entered by fall-through of je at 0x0048f00d, 34 instruction(s), ends with forward jump to 0x0048f10b
    mov eax, dword ptr [ebp - local_8]           # 0048f00f
    movsx ecx, word ptr [eax + field_3fe]        # 0048f012
    imul ecx, ecx, 0xd0                          # 0048f019
    mov edx, dword ptr [ebp - local_4]           # 0048f01f
    lea eax, [edx + ecx + field_100]             # 0048f022
    {load} mov edi, eax                          # 0048f029
    mov ecx, dword ptr [ebp - local_8]           # 0048f02b
    add ecx, 0x400                               # 0048f02e
    {load} mov edx, ecx                          # 0048f034
    or ecx, -0x1                                 # 0048f036
    {load} xor eax, eax                          # 0048f039
    repne scasb al, byte ptr es:[edi]            # 0048f03b
    not ecx                                      # 0048f03d
    {load} sub edi, ecx                          # 0048f03f
    {load} mov esi, edi                          # 0048f041
    {load} mov eax, ecx                          # 0048f043
    {load} mov edi, edx                          # 0048f045
    shr ecx, 0x2                                 # 0048f047
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048f04a
    {load} mov ecx, eax                          # 0048f04c
    and ecx, 0x3                                 # 0048f04e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048f051
    mov ecx, dword ptr [ebp - local_8]           # 0048f053
    movsx edx, word ptr [ecx + field_3fe]        # 0048f056
    imul edx, edx, 0xd0                          # 0048f05d
    mov eax, dword ptr [ebp - local_8]           # 0048f063
    mov ecx, dword ptr [ebp - local_4]           # 0048f066
    mov dx, word ptr [ecx + edx + field_121]     # 0048f069
    mov word ptr [eax + field_42d], dx           # 0048f071
    mov eax, dword ptr [ebp - local_8]           # 0048f078
    mov ecx, dword ptr [ebp - local_4]           # 0048f07b
    mov dx, word ptr [ecx + field_aa]            # 0048f07e
    mov word ptr [eax + field_421], dx           # 0048f085
    jmp.d8 L_0048f10b                            # 0048f08c
L_0048f08e:
    # block 0x0048f08e: entered by je at 0x0048f00d, 33 instruction(s), falls into the block at 0x0048f10b
    mov eax, dword ptr [ebp - local_8]           # 0048f08e
    movsx ecx, word ptr [eax + field_3fe]        # 0048f091
    imul ecx, ecx, 0xd0                          # 0048f098
    mov edx, dword ptr [ebp - local_4]           # 0048f09e
    lea eax, [edx + ecx + field_141]             # 0048f0a1
    {load} mov edi, eax                          # 0048f0a8
    mov ecx, dword ptr [ebp - local_8]           # 0048f0aa
    add ecx, 0x400                               # 0048f0ad
    {load} mov edx, ecx                          # 0048f0b3
    or ecx, -0x1                                 # 0048f0b5
    {load} xor eax, eax                          # 0048f0b8
    repne scasb al, byte ptr es:[edi]            # 0048f0ba
    not ecx                                      # 0048f0bc
    {load} sub edi, ecx                          # 0048f0be
    {load} mov esi, edi                          # 0048f0c0
    {load} mov eax, ecx                          # 0048f0c2
    {load} mov edi, edx                          # 0048f0c4
    shr ecx, 0x2                                 # 0048f0c6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048f0c9
    {load} mov ecx, eax                          # 0048f0cb
    and ecx, 0x3                                 # 0048f0cd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048f0d0
    mov ecx, dword ptr [ebp - local_8]           # 0048f0d2
    movsx edx, word ptr [ecx + field_3fe]        # 0048f0d5
    imul edx, edx, 0xd0                          # 0048f0dc
    mov eax, dword ptr [ebp - local_8]           # 0048f0e2
    mov ecx, dword ptr [ebp - local_4]           # 0048f0e5
    mov dx, word ptr [ecx + edx + field_162]     # 0048f0e8
    mov word ptr [eax + field_42d], dx           # 0048f0f0
    mov eax, dword ptr [ebp - local_8]           # 0048f0f7
    mov ecx, dword ptr [ebp - local_4]           # 0048f0fa
    mov dx, word ptr [ecx + field_ac]            # 0048f0fd
    mov word ptr [eax + field_421], dx           # 0048f104
L_0048f10b:
    # block 0x0048f10b: entered by jmp at 0x0048f08c, 27 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with ret 0x4
    mov eax, dword ptr [ebp - local_8]           # 0048f10b
    mov word ptr [eax + field_423], 0x2          # 0048f10e
    mov ecx, dword ptr [ebp - local_8]           # 0048f117
    mov word ptr [ecx + field_425], 0x1          # 0048f11a
    mov edx, dword ptr [ebp - local_8]           # 0048f123
    mov word ptr [edx + field_427], 0x1          # 0048f126
    mov eax, dword ptr [ebp - local_8]           # 0048f12f
    mov dword ptr [eax + field_429], 0x1         # 0048f132
    mov ecx, dword ptr [ebp - local_8]           # 0048f13c
    mov edx, dword ptr [ebp - local_8]           # 0048f13f
    mov ax, word ptr [edx + field_42d]           # 0048f142
    mov word ptr [ecx + field_42f], ax           # 0048f149
    mov ecx, dword ptr [ebp - local_8]           # 0048f150
    add ecx, 0x400                               # 0048f153
    push ecx                                     # 0048f159
    mov ecx, 0x5c3a67                            # 0048f15a
    call FUN_004fb77a                            # 0048f15f
    mov edx, dword ptr [ebp - local_8]           # 0048f164
    mov ax, word ptr [edx + field_421]           # 0048f167
    push eax                                     # 0048f16e
    mov ecx, 0x5c3a67                            # 0048f16f
    call FUN_004fb2e3                            # 0048f174
    pop edi                                      # 0048f179
    pop esi                                      # 0048f17a
    {load} mov esp, ebp                          # 0048f17b
    pop ebp                                      # 0048f17d
    ret 0x4                                      # 0048f17e

