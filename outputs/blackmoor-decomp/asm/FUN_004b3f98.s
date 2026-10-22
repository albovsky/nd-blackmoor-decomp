# FUN_004b3f98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3f98
# extent:       0x004b3f98-0x004b42d3 (827 code bytes)
# span:         0x004b3f98-0x004b42d3 (code 827, tables 0, padding 0)
# sha256:       d9f7743fc695c8dbaa79e9c15bd522705dbe67bcfa9fa942af8697830b0b1908
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3f98_lifted
# naming:       native port src/original_methods_fl41.c:m4b3f98_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 189/189 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_6dc, field_6e0, field_6e4, field_6e8, field_6fc, field_700, field_704, field_708, field_71e, field_722, field_750, field_752; [ecx + n] field_6e4, field_6e8, field_6fc, field_700, field_704, field_708, field_70c, field_710, field_714, field_718, field_762; [edx + n] field_6dc, field_6e0, field_6e4, field_6e8, field_6ec, field_6f0, field_6f4, field_6f8, field_70c, field_710, field_714, field_718 and 4 more
# callees:      calls FUN_004b3e99
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4b3f98_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 189 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_6dc, 0x6dc  # offset +0x6dc
.equ field_6e0, 0x6e0  # offset +0x6e0
.equ field_6e4, 0x6e4  # offset +0x6e4
.equ field_6e8, 0x6e8  # offset +0x6e8
.equ field_6ec, 0x6ec  # offset +0x6ec
.equ field_6f0, 0x6f0  # offset +0x6f0
.equ field_6f4, 0x6f4  # offset +0x6f4
.equ field_6f8, 0x6f8  # offset +0x6f8
.equ field_6fc, 0x6fc  # offset +0x6fc
.equ field_700, 0x700  # offset +0x700
.equ field_704, 0x704  # offset +0x704
.equ field_708, 0x708  # offset +0x708
.equ field_70c, 0x70c  # offset +0x70c
.equ field_710, 0x710  # offset +0x710
.equ field_714, 0x714  # offset +0x714
.equ field_718, 0x718  # offset +0x718
.equ field_71e, 0x71e  # offset +0x71e
.equ field_720, 0x720  # offset +0x720
.equ field_722, 0x722  # offset +0x722
.equ field_724, 0x724  # offset +0x724
.equ field_750, 0x750  # offset +0x750
.equ field_752, 0x752  # offset +0x752
.equ field_75e, 0x75e  # offset +0x75e
.equ field_762, 0x762  # offset +0x762

# --- external targets -----------------------------------------------
.set FUN_004b3e99, .text + (0x004b3e99 - 0x401000)

.org 0x004b3f98 - 0x401000
.globl FUN_004b3f98
FUN_004b3f98:
    # block 0x004b3f98: entry, 8 instruction(s), ends with jne to 0x004b3fb4 (forward)
    push ebp                                     # 004b3f98
    {load} mov ebp, esp                          # 004b3f99
    sub esp, 0xc                                 # 004b3f9b
    mov dword ptr [ebp - local_c], ecx           # 004b3f9e
    mov eax, dword ptr [ebp - local_c]           # 004b3fa1
    movsx ecx, word ptr [eax + field_750]        # 004b3fa4
    test ecx, ecx                                # 004b3fab
    jne.d8 L_004b3fb4                            # 004b3fad
    # block 0x004b3faf: entered by fall-through of jne at 0x004b3fad, 1 instruction(s), ends with forward jump to 0x004b42cf
    jmp.d32 L_004b42cf                           # 004b3faf
L_004b3fb4:
    # block 0x004b3fb4: entered by jne at 0x004b3fad, 10 instruction(s), ends with je to 0x004b4147 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b3fb4
    mov eax, dword ptr [edx + field_75e]         # 004b3fb7
    mov dword ptr [ebp - local_8], eax           # 004b3fbd
    mov ecx, dword ptr [ebp - local_c]           # 004b3fc0
    mov edx, dword ptr [ecx + field_762]         # 004b3fc3
    mov dword ptr [ebp - local_4], edx           # 004b3fc9
    mov eax, dword ptr [ebp - local_c]           # 004b3fcc
    movsx ecx, word ptr [eax + field_752]        # 004b3fcf
    test ecx, ecx                                # 004b3fd6
    je.d32 L_004b4147                            # 004b3fd8
    # block 0x004b3fde: entered by fall-through of je at 0x004b3fd8, 81 instruction(s), calls FUN_004b3e99, ends with forward jump to 0x004b42cf
    mov edx, dword ptr [ebp - local_c]           # 004b3fde
    mov eax, dword ptr [ebp - local_c]           # 004b3fe1
    mov ecx, dword ptr [eax + field_6e0]         # 004b3fe4
    mov dword ptr [edx + field_6f0], ecx         # 004b3fea
    mov edx, dword ptr [ebp - local_c]           # 004b3ff0
    mov eax, dword ptr [ebp - local_c]           # 004b3ff3
    mov ecx, dword ptr [eax + field_6e8]         # 004b3ff6
    mov dword ptr [edx + field_6f8], ecx         # 004b3ffc
    mov edx, dword ptr [ebp - local_c]           # 004b4002
    mov eax, dword ptr [ebp - local_c]           # 004b4005
    mov ecx, dword ptr [eax + field_6dc]         # 004b4008
    mov dword ptr [edx + field_6ec], ecx         # 004b400e
    mov edx, dword ptr [ebp - local_c]           # 004b4014
    mov eax, dword ptr [ebp - local_c]           # 004b4017
    mov ecx, dword ptr [eax + field_6e4]         # 004b401a
    mov dword ptr [edx + field_6f4], ecx         # 004b4020
    mov edx, dword ptr [ebp - local_c]           # 004b4026
    mov eax, dword ptr [ebp - local_c]           # 004b4029
    mov ecx, dword ptr [eax + field_700]         # 004b402c
    mov dword ptr [edx + field_710], ecx         # 004b4032
    mov edx, dword ptr [ebp - local_c]           # 004b4038
    mov eax, dword ptr [ebp - local_c]           # 004b403b
    mov ecx, dword ptr [eax + field_708]         # 004b403e
    mov dword ptr [edx + field_718], ecx         # 004b4044
    mov edx, dword ptr [ebp - local_c]           # 004b404a
    mov eax, dword ptr [ebp - local_c]           # 004b404d
    mov ecx, dword ptr [eax + field_6fc]         # 004b4050
    mov dword ptr [edx + field_70c], ecx         # 004b4056
    mov edx, dword ptr [ebp - local_c]           # 004b405c
    mov eax, dword ptr [ebp - local_c]           # 004b405f
    mov ecx, dword ptr [eax + field_704]         # 004b4062
    mov dword ptr [edx + field_714], ecx         # 004b4068
    mov edx, dword ptr [ebp - local_c]           # 004b406e
    movsx eax, word ptr [edx + field_724]        # 004b4071
    mov ecx, dword ptr [ebp - local_4]           # 004b4078
    {load} sub ecx, eax                          # 004b407b
    mov edx, dword ptr [ebp - local_c]           # 004b407d
    mov dword ptr [edx + field_6e0], ecx         # 004b4080
    mov eax, dword ptr [ebp - local_c]           # 004b4086
    movsx ecx, word ptr [eax + field_722]        # 004b4089
    mov edx, dword ptr [ebp - local_c]           # 004b4090
    mov eax, dword ptr [edx + field_6e0]         # 004b4093
    {load} add eax, ecx                          # 004b4099
    mov ecx, dword ptr [ebp - local_c]           # 004b409b
    mov dword ptr [ecx + field_6e8], eax         # 004b409e
    mov edx, dword ptr [ebp - local_c]           # 004b40a4
    movsx eax, word ptr [edx + field_720]        # 004b40a7
    mov ecx, dword ptr [ebp - local_8]           # 004b40ae
    {load} sub ecx, eax                          # 004b40b1
    mov edx, dword ptr [ebp - local_c]           # 004b40b3
    mov dword ptr [edx + field_6dc], ecx         # 004b40b6
    mov eax, dword ptr [ebp - local_c]           # 004b40bc
    movsx ecx, word ptr [eax + field_71e]        # 004b40bf
    mov edx, dword ptr [ebp - local_c]           # 004b40c6
    mov eax, dword ptr [edx + field_6dc]         # 004b40c9
    {load} add eax, ecx                          # 004b40cf
    mov ecx, dword ptr [ebp - local_c]           # 004b40d1
    mov dword ptr [ecx + field_6e4], eax         # 004b40d4
    mov ecx, dword ptr [ebp - local_c]           # 004b40da
    call FUN_004b3e99                            # 004b40dd
    mov edx, dword ptr [ebp - local_c]           # 004b40e2
    mov eax, dword ptr [edx + field_6e0]         # 004b40e5
    add eax, dword ptr [0x58318a]                # 004b40eb
    mov ecx, dword ptr [ebp - local_c]           # 004b40f1
    mov dword ptr [ecx + field_700], eax         # 004b40f4
    mov edx, dword ptr [ebp - local_c]           # 004b40fa
    mov eax, dword ptr [edx + field_6e8]         # 004b40fd
    add eax, dword ptr [0x58318a]                # 004b4103
    mov ecx, dword ptr [ebp - local_c]           # 004b4109
    mov dword ptr [ecx + field_708], eax         # 004b410c
    mov edx, dword ptr [ebp - local_c]           # 004b4112
    mov eax, dword ptr [edx + field_6dc]         # 004b4115
    add eax, dword ptr [0x583186]                # 004b411b
    mov ecx, dword ptr [ebp - local_c]           # 004b4121
    mov dword ptr [ecx + field_6fc], eax         # 004b4124
    mov edx, dword ptr [ebp - local_c]           # 004b412a
    mov eax, dword ptr [edx + field_6e4]         # 004b412d
    add eax, dword ptr [0x583186]                # 004b4133
    mov ecx, dword ptr [ebp - local_c]           # 004b4139
    mov dword ptr [ecx + field_704], eax         # 004b413c
    jmp.d32 L_004b42cf                           # 004b4142
L_004b4147:
    # block 0x004b4147: entered by je at 0x004b3fd8, 86 instruction(s), calls FUN_004b3e99, falls into the block at 0x004b42cf
    mov edx, dword ptr [ebp - local_c]           # 004b4147
    movsx eax, word ptr [edx + field_724]        # 004b414a
    mov ecx, dword ptr [ebp - local_4]           # 004b4151
    {load} sub ecx, eax                          # 004b4154
    mov edx, dword ptr [ebp - local_c]           # 004b4156
    mov dword ptr [edx + field_6e0], ecx         # 004b4159
    mov eax, dword ptr [ebp - local_c]           # 004b415f
    movsx ecx, word ptr [eax + field_722]        # 004b4162
    mov edx, dword ptr [ebp - local_c]           # 004b4169
    mov eax, dword ptr [edx + field_6e0]         # 004b416c
    {load} add eax, ecx                          # 004b4172
    mov ecx, dword ptr [ebp - local_c]           # 004b4174
    mov dword ptr [ecx + field_6e8], eax         # 004b4177
    mov edx, dword ptr [ebp - local_c]           # 004b417d
    movsx eax, word ptr [edx + field_720]        # 004b4180
    mov ecx, dword ptr [ebp - local_8]           # 004b4187
    {load} sub ecx, eax                          # 004b418a
    mov edx, dword ptr [ebp - local_c]           # 004b418c
    mov dword ptr [edx + field_6dc], ecx         # 004b418f
    mov eax, dword ptr [ebp - local_c]           # 004b4195
    movsx ecx, word ptr [eax + field_71e]        # 004b4198
    mov edx, dword ptr [ebp - local_c]           # 004b419f
    mov eax, dword ptr [edx + field_6dc]         # 004b41a2
    {load} add eax, ecx                          # 004b41a8
    mov ecx, dword ptr [ebp - local_c]           # 004b41aa
    mov dword ptr [ecx + field_6e4], eax         # 004b41ad
    mov ecx, dword ptr [ebp - local_c]           # 004b41b3
    call FUN_004b3e99                            # 004b41b6
    mov edx, dword ptr [ebp - local_c]           # 004b41bb
    mov eax, dword ptr [ebp - local_c]           # 004b41be
    mov ecx, dword ptr [eax + field_6e0]         # 004b41c1
    mov dword ptr [edx + field_6f0], ecx         # 004b41c7
    mov edx, dword ptr [ebp - local_c]           # 004b41cd
    mov eax, dword ptr [ebp - local_c]           # 004b41d0
    mov ecx, dword ptr [eax + field_6e8]         # 004b41d3
    mov dword ptr [edx + field_6f8], ecx         # 004b41d9
    mov edx, dword ptr [ebp - local_c]           # 004b41df
    mov eax, dword ptr [ebp - local_c]           # 004b41e2
    mov ecx, dword ptr [eax + field_6dc]         # 004b41e5
    mov dword ptr [edx + field_6ec], ecx         # 004b41eb
    mov edx, dword ptr [ebp - local_c]           # 004b41f1
    mov eax, dword ptr [ebp - local_c]           # 004b41f4
    mov ecx, dword ptr [eax + field_6e4]         # 004b41f7
    mov dword ptr [edx + field_6f4], ecx         # 004b41fd
    mov edx, dword ptr [ebp - local_c]           # 004b4203
    mov eax, dword ptr [edx + field_6e0]         # 004b4206
    add eax, dword ptr [0x58318a]                # 004b420c
    mov ecx, dword ptr [ebp - local_c]           # 004b4212
    mov dword ptr [ecx + field_700], eax         # 004b4215
    mov edx, dword ptr [ebp - local_c]           # 004b421b
    mov eax, dword ptr [edx + field_6e8]         # 004b421e
    add eax, dword ptr [0x58318a]                # 004b4224
    mov ecx, dword ptr [ebp - local_c]           # 004b422a
    mov dword ptr [ecx + field_708], eax         # 004b422d
    mov edx, dword ptr [ebp - local_c]           # 004b4233
    mov eax, dword ptr [edx + field_6dc]         # 004b4236
    add eax, dword ptr [0x583186]                # 004b423c
    mov ecx, dword ptr [ebp - local_c]           # 004b4242
    mov dword ptr [ecx + field_6fc], eax         # 004b4245
    mov edx, dword ptr [ebp - local_c]           # 004b424b
    mov eax, dword ptr [edx + field_6e4]         # 004b424e
    add eax, dword ptr [0x583186]                # 004b4254
    mov ecx, dword ptr [ebp - local_c]           # 004b425a
    mov dword ptr [ecx + field_704], eax         # 004b425d
    mov edx, dword ptr [ebp - local_c]           # 004b4263
    mov eax, dword ptr [edx + field_6f0]         # 004b4266
    add eax, dword ptr [0x58318a]                # 004b426c
    mov ecx, dword ptr [ebp - local_c]           # 004b4272
    mov dword ptr [ecx + field_710], eax         # 004b4275
    mov edx, dword ptr [ebp - local_c]           # 004b427b
    mov eax, dword ptr [edx + field_6f8]         # 004b427e
    add eax, dword ptr [0x58318a]                # 004b4284
    mov ecx, dword ptr [ebp - local_c]           # 004b428a
    mov dword ptr [ecx + field_718], eax         # 004b428d
    mov edx, dword ptr [ebp - local_c]           # 004b4293
    mov eax, dword ptr [edx + field_6ec]         # 004b4296
    add eax, dword ptr [0x583186]                # 004b429c
    mov ecx, dword ptr [ebp - local_c]           # 004b42a2
    mov dword ptr [ecx + field_70c], eax         # 004b42a5
    mov edx, dword ptr [ebp - local_c]           # 004b42ab
    mov eax, dword ptr [edx + field_6f4]         # 004b42ae
    add eax, dword ptr [0x583186]                # 004b42b4
    mov ecx, dword ptr [ebp - local_c]           # 004b42ba
    mov dword ptr [ecx + field_714], eax         # 004b42bd
    mov edx, dword ptr [ebp - local_c]           # 004b42c3
    mov word ptr [edx + field_752], 0x1          # 004b42c6
L_004b42cf:
    # block 0x004b42cf: entered by jmp at 0x004b3faf; jmp at 0x004b4142, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b42cf
    pop ebp                                      # 004b42d1
    ret                                          # 004b42d2

