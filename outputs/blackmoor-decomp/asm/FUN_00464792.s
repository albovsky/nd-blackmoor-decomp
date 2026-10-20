# FUN_00464792
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464792
# extent:       0x00464792-0x00464ab5 (803 code bytes)
# span:         0x00464792-0x00464ab5 (code 803, tables 0, padding 0)
# sha256:       d84503892c7653d362233b4ca75e3cc9367d36fc8b946d6177e16a99cb9976db
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m464792_hit_test
# naming:       native port src/original_methods_fl25a.c:m464792_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m464792_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25a-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_21, field_36, field_3d, field_4d, field_61, field_65, field_69, field_6d and 4 more; [ecx + n] field_26, field_2d, field_35, field_36, field_39, field_45, field_49, field_61, field_65, field_69, field_6d, field_8c and 2 more; [edx + n] field_25, field_29, field_2a, field_31, field_36, field_41, field_8a, field_c2, field_c6, field_ca, field_ce, field_43b
# callees:      calls FUN_0046465d, FUN_00464ab5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m464792_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 230 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_29, 0x29  # offset +0x29
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_69, 0x69  # offset +0x69
.equ field_6d, 0x6d  # offset +0x6d
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_94, 0x94  # offset +0x94
.equ field_b8, 0xb8  # offset +0xb8
.equ field_c2, 0xc2  # offset +0xc2
.equ field_c6, 0xc6  # offset +0xc6
.equ field_ca, 0xca  # offset +0xca
.equ field_ce, 0xce  # offset +0xce
.equ field_42f, 0x42f  # offset +0x42f
.equ field_433, 0x433  # offset +0x433
.equ field_437, 0x437  # offset +0x437
.equ field_43b, 0x43b  # offset +0x43b

# --- external targets -----------------------------------------------
.set FUN_0046465d, .text + (0x0046465d - 0x401000)
.set FUN_00464ab5, .text + (0x00464ab5 - 0x401000)

.org 0x00464792 - 0x401000
.globl FUN_00464792
FUN_00464792:
    # block 0x00464792: entry, 12 instruction(s), ends with je to 0x00464aad (forward)
    push ebp                                     # 00464792
    {load} mov ebp, esp                          # 00464793
    sub esp, 0xc                                 # 00464795
    mov dword ptr [ebp - local_c], ecx           # 00464798
    mov eax, dword ptr [ebp - local_c]           # 0046479b
    movsx ecx, word ptr [eax + field_1e]         # 0046479e
    imul ecx, ecx, 0x8d                          # 004647a2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004647a8
    mov dword ptr [ebp - local_8], edx           # 004647ae
    mov eax, dword ptr [ebp - local_c]           # 004647b1
    cmp dword ptr [eax + field_b8], 0x0          # 004647b4
    je.d32 L_00464aad                            # 004647bb
    # block 0x004647c1: entered by fall-through of je at 0x004647bb, 21 instruction(s), ends with je to 0x004648ac (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004647c1
    mov dword ptr [ecx + field_26], 0x1          # 004647c4
    mov edx, dword ptr [ebp - local_c]           # 004647cb
    mov eax, dword ptr [ebp + arg_10]            # 004647ce
    mov ecx, dword ptr [eax + field_4]           # 004647d1
    mov dword ptr [edx + field_c6], ecx          # 004647d4
    mov edx, dword ptr [ebp - local_c]           # 004647da
    mov eax, dword ptr [ebp + arg_10]            # 004647dd
    mov ecx, dword ptr [eax + field_c]           # 004647e0
    mov dword ptr [edx + field_ce], ecx          # 004647e3
    mov edx, dword ptr [ebp - local_c]           # 004647e9
    mov eax, dword ptr [ebp + arg_10]            # 004647ec
    mov ecx, dword ptr [eax]                     # 004647ef
    mov dword ptr [edx + field_c2], ecx          # 004647f1
    mov edx, dword ptr [ebp - local_c]           # 004647f7
    mov eax, dword ptr [ebp + arg_10]            # 004647fa
    mov ecx, dword ptr [eax + field_8]           # 004647fd
    mov dword ptr [edx + field_ca], ecx          # 00464800
    mov edx, dword ptr [ebp - local_c]           # 00464806
    cmp dword ptr [edx + field_2a], 0x0          # 00464809
    je.d32 L_004648ac                            # 0046480d
    # block 0x00464813: entered by fall-through of je at 0x0046480d, 6 instruction(s), calls FUN_0046465d, ends with jne to 0x00464834 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00464813
    call FUN_0046465d                            # 00464816
    mov eax, dword ptr [ebp - local_c]           # 0046481b
    movsx ecx, word ptr [eax + field_36]         # 0046481e
    test ecx, ecx                                # 00464822
    jne.d8 L_00464834                            # 00464824
    # block 0x00464826: entered by fall-through of jne at 0x00464824, 4 instruction(s), ends with je to 0x00464858 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00464826
    movsx eax, word ptr [edx + field_8a]         # 00464829
    test eax, eax                                # 00464830
    je.d8 L_00464858                             # 00464832
L_00464834:
    # block 0x00464834: entered by jne at 0x00464824; fall-through of je at 0x00464832, 3 instruction(s), ends with jne to 0x004648a7 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00464834
    cmp dword ptr [ecx + field_8c], 0x0          # 00464837
    jne.d8 L_004648a7                            # 0046483e
    # block 0x00464840: entered by fall-through of jne at 0x0046483e, 7 instruction(s), ends with jne to 0x004648a7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00464840
    movsx eax, word ptr [edx + field_8a]         # 00464843
    mov ecx, dword ptr [ebp - local_c]           # 0046484a
    movsx edx, word ptr [ecx + field_36]         # 0046484d
    sub edx, 0x1                                 # 00464851
    {load} cmp eax, edx                          # 00464854
    jne.d8 L_004648a7                            # 00464856
L_00464858:
    # block 0x00464858: entered by je at 0x00464832; fall-through of jne at 0x00464856, 4 instruction(s), ends with jl to 0x004648a7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00464858
    mov ecx, dword ptr [ebp - local_8]           # 0046485c
    cmp eax, dword ptr [ecx + field_45]          # 0046485f
    jl.d8 L_004648a7                             # 00464862
    # block 0x00464864: entered by fall-through of jl at 0x00464862, 4 instruction(s), ends with jg to 0x004648a7 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00464864
    mov eax, dword ptr [ebp - local_8]           # 00464868
    cmp edx, dword ptr [eax + field_4d]          # 0046486b
    jg.d8 L_004648a7                             # 0046486e
    # block 0x00464870: entered by fall-through of jg at 0x0046486e, 4 instruction(s), ends with jl to 0x004648a7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00464870
    mov edx, dword ptr [ebp - local_8]           # 00464874
    cmp ecx, dword ptr [edx + field_41]          # 00464877
    jl.d8 L_004648a7                             # 0046487a
    # block 0x0046487c: entered by fall-through of jl at 0x0046487a, 4 instruction(s), ends with jg to 0x004648a7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0046487c
    mov ecx, dword ptr [ebp - local_8]           # 00464880
    cmp eax, dword ptr [ecx + field_49]          # 00464883
    jg.d8 L_004648a7                             # 00464886
    # block 0x00464888: entered by fall-through of jg at 0x00464886, 8 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    mov edx, dword ptr [ebp - local_c]           # 00464888
    mov ax, word ptr [edx + field_36]            # 0046488b
    push eax                                     # 0046488f
    push 0x27cd                                  # 00464890
    mov ecx, dword ptr [ebp - local_c]           # 00464895
    call FUN_00464ab5                            # 00464898
    mov eax, 0x1                                 # 0046489d
    jmp.d32 L_00464aaf                           # 004648a2
L_004648a7:
    # block 0x004648a7: entered by jne at 0x0046483e; jne at 0x00464856; jl at 0x00464862; jg at 0x0046486e; more, 1 instruction(s), ends with forward jump to 0x00464993
    jmp.d32 L_00464993                           # 004648a7
L_004648ac:
    # block 0x004648ac: entered by je at 0x0046480d, 4 instruction(s), ends with jl to 0x004648f5 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004648ac
    mov edx, dword ptr [ebp - local_8]           # 004648b0
    cmp ecx, dword ptr [edx + field_25]          # 004648b3
    jl.d8 L_004648f5                             # 004648b6
    # block 0x004648b8: entered by fall-through of jl at 0x004648b6, 4 instruction(s), ends with jg to 0x004648f5 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004648b8
    mov ecx, dword ptr [ebp - local_8]           # 004648bc
    cmp eax, dword ptr [ecx + field_2d]          # 004648bf
    jg.d8 L_004648f5                             # 004648c2
    # block 0x004648c4: entered by fall-through of jg at 0x004648c2, 4 instruction(s), ends with jl to 0x004648f5 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004648c4
    mov eax, dword ptr [ebp - local_8]           # 004648c8
    cmp edx, dword ptr [eax + field_21]          # 004648cb
    jl.d8 L_004648f5                             # 004648ce
    # block 0x004648d0: entered by fall-through of jl at 0x004648ce, 4 instruction(s), ends with jg to 0x004648f5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004648d0
    mov edx, dword ptr [ebp - local_8]           # 004648d4
    cmp ecx, dword ptr [edx + field_29]          # 004648d7
    jg.d8 L_004648f5                             # 004648da
    # block 0x004648dc: entered by fall-through of jg at 0x004648da, 6 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    push 0x0                                     # 004648dc
    push 0x27ca                                  # 004648de
    mov ecx, dword ptr [ebp - local_c]           # 004648e3
    call FUN_00464ab5                            # 004648e6
    mov eax, 0x1                                 # 004648eb
    jmp.d32 L_00464aaf                           # 004648f0
L_004648f5:
    # block 0x004648f5: entered by jl at 0x004648b6; jg at 0x004648c2; jl at 0x004648ce; jg at 0x004648da, 4 instruction(s), ends with jl to 0x0046493e (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004648f5
    mov ecx, dword ptr [ebp - local_8]           # 004648f9
    cmp eax, dword ptr [ecx + field_35]          # 004648fc
    jl.d8 L_0046493e                             # 004648ff
    # block 0x00464901: entered by fall-through of jl at 0x004648ff, 4 instruction(s), ends with jg to 0x0046493e (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00464901
    mov eax, dword ptr [ebp - local_8]           # 00464905
    cmp edx, dword ptr [eax + field_3d]          # 00464908
    jg.d8 L_0046493e                             # 0046490b
    # block 0x0046490d: entered by fall-through of jg at 0x0046490b, 4 instruction(s), ends with jl to 0x0046493e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046490d
    mov edx, dword ptr [ebp - local_8]           # 00464911
    cmp ecx, dword ptr [edx + field_31]          # 00464914
    jl.d8 L_0046493e                             # 00464917
    # block 0x00464919: entered by fall-through of jl at 0x00464917, 4 instruction(s), ends with jg to 0x0046493e (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00464919
    mov ecx, dword ptr [ebp - local_8]           # 0046491d
    cmp eax, dword ptr [ecx + field_39]          # 00464920
    jg.d8 L_0046493e                             # 00464923
    # block 0x00464925: entered by fall-through of jg at 0x00464923, 6 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    push 0x0                                     # 00464925
    push 0x27cb                                  # 00464927
    mov ecx, dword ptr [ebp - local_c]           # 0046492c
    call FUN_00464ab5                            # 0046492f
    mov eax, 0x1                                 # 00464934
    jmp.d32 L_00464aaf                           # 00464939
L_0046493e:
    # block 0x0046493e: entered by jl at 0x004648ff; jg at 0x0046490b; jl at 0x00464917; jg at 0x00464923, 4 instruction(s), ends with jl to 0x00464993 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046493e
    mov eax, dword ptr [ebp - local_8]           # 00464942
    cmp edx, dword ptr [eax + field_433]         # 00464945
    jl.d8 L_00464993                             # 0046494b
    # block 0x0046494d: entered by fall-through of jl at 0x0046494b, 4 instruction(s), ends with jg to 0x00464993 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0046494d
    mov edx, dword ptr [ebp - local_8]           # 00464951
    cmp ecx, dword ptr [edx + field_43b]         # 00464954
    jg.d8 L_00464993                             # 0046495a
    # block 0x0046495c: entered by fall-through of jg at 0x0046495a, 4 instruction(s), ends with jl to 0x00464993 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0046495c
    mov ecx, dword ptr [ebp - local_8]           # 00464960
    cmp eax, dword ptr [ecx + field_42f]         # 00464963
    jl.d8 L_00464993                             # 00464969
    # block 0x0046496b: entered by fall-through of jl at 0x00464969, 4 instruction(s), ends with jg to 0x00464993 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0046496b
    mov eax, dword ptr [ebp - local_8]           # 0046496f
    cmp edx, dword ptr [eax + field_437]         # 00464972
    jg.d8 L_00464993                             # 00464978
    # block 0x0046497a: entered by fall-through of jg at 0x00464978, 6 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    push 0x0                                     # 0046497a
    push 0x27cc                                  # 0046497c
    mov ecx, dword ptr [ebp - local_c]           # 00464981
    call FUN_00464ab5                            # 00464984
    mov eax, 0x1                                 # 00464989
    jmp.d32 L_00464aaf                           # 0046498e
L_00464993:
    # block 0x00464993: entered by jmp at 0x004648a7; jl at 0x0046494b; jg at 0x0046495a; jl at 0x00464969; jg at 0x00464978, 2 instruction(s), ends with forward jump to 0x004649a5
    mov dword ptr [ebp - local_4], 0x0           # 00464993
    jmp.d8 L_004649a5                            # 0046499a
L_0046499c:
    # block 0x0046499c: entered by jmp at 0x00464aa8, 3 instruction(s), falls into the block at 0x004649a5
    mov ecx, dword ptr [ebp - local_4]           # 0046499c
    add ecx, 0x1                                 # 0046499f
    mov dword ptr [ebp - local_4], ecx           # 004649a2
L_004649a5:
    # block 0x004649a5: entered by jmp at 0x0046499a, 2 instruction(s), ends with jge to 0x00464aad (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004649a5
    jge.d32 L_00464aad                           # 004649a9
    # block 0x004649af: entered by fall-through of jge at 0x004649a9, 4 instruction(s), ends with jne to 0x00464a27 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004649af
    mov eax, dword ptr [ebp - local_c]           # 004649b2
    cmp dword ptr [eax + 4*edx + field_94], 0x0  # 004649b5
    jne.d8 L_00464a27                            # 004649bd
    # block 0x004649bf: entered by fall-through of jne at 0x004649bd, 6 instruction(s), ends with jl to 0x00464a27 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004649bf
    mov edx, dword ptr [ebp - local_4]           # 004649c3
    shl edx, 0x5                                 # 004649c6
    mov eax, dword ptr [ebp - local_8]           # 004649c9
    cmp ecx, dword ptr [eax + edx + field_65]    # 004649cc
    jl.d8 L_00464a27                             # 004649d0
    # block 0x004649d2: entered by fall-through of jl at 0x004649d0, 6 instruction(s), ends with jg to 0x00464a27 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004649d2
    mov edx, dword ptr [ebp - local_4]           # 004649d6
    shl edx, 0x5                                 # 004649d9
    mov eax, dword ptr [ebp - local_8]           # 004649dc
    cmp ecx, dword ptr [eax + edx + field_6d]    # 004649df
    jg.d8 L_00464a27                             # 004649e3
    # block 0x004649e5: entered by fall-through of jg at 0x004649e3, 6 instruction(s), ends with jl to 0x00464a27 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004649e5
    mov edx, dword ptr [ebp - local_4]           # 004649e9
    shl edx, 0x5                                 # 004649ec
    mov eax, dword ptr [ebp - local_8]           # 004649ef
    cmp ecx, dword ptr [eax + edx + field_61]    # 004649f2
    jl.d8 L_00464a27                             # 004649f6
    # block 0x004649f8: entered by fall-through of jl at 0x004649f6, 6 instruction(s), ends with jg to 0x00464a27 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004649f8
    mov edx, dword ptr [ebp - local_4]           # 004649fc
    shl edx, 0x5                                 # 004649ff
    mov eax, dword ptr [ebp - local_8]           # 00464a02
    cmp ecx, dword ptr [eax + edx + field_69]    # 00464a05
    jg.d8 L_00464a27                             # 00464a09
    # block 0x00464a0b: entered by fall-through of jg at 0x00464a09, 7 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    mov cx, word ptr [ebp - local_4]             # 00464a0b
    push ecx                                     # 00464a0f
    push 0x27c9                                  # 00464a10
    mov ecx, dword ptr [ebp - local_c]           # 00464a15
    call FUN_00464ab5                            # 00464a18
    mov eax, 0x1                                 # 00464a1d
    jmp.d32 L_00464aaf                           # 00464a22
L_00464a27:
    # block 0x00464a27: entered by jne at 0x004649bd; jl at 0x004649d0; jg at 0x004649e3; jl at 0x004649f6; jg at 0x00464a09, 3 instruction(s), ends with je to 0x00464aa8 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00464a27
    cmp dword ptr [edx + field_2a], 0x0          # 00464a2a
    je.d8 L_00464aa8                             # 00464a2e
    # block 0x00464a30: entered by fall-through of je at 0x00464a2e, 4 instruction(s), ends with je to 0x00464aa8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00464a30
    mov ecx, dword ptr [ebp - local_c]           # 00464a33
    cmp dword ptr [ecx + 4*eax + field_94], 0x0  # 00464a36
    je.d8 L_00464aa8                             # 00464a3e
    # block 0x00464a40: entered by fall-through of je at 0x00464a3e, 6 instruction(s), ends with jl to 0x00464aa8 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00464a40
    mov eax, dword ptr [ebp - local_4]           # 00464a44
    shl eax, 0x5                                 # 00464a47
    mov ecx, dword ptr [ebp - local_8]           # 00464a4a
    cmp edx, dword ptr [ecx + eax + field_65]    # 00464a4d
    jl.d8 L_00464aa8                             # 00464a51
    # block 0x00464a53: entered by fall-through of jl at 0x00464a51, 6 instruction(s), ends with jg to 0x00464aa8 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00464a53
    mov eax, dword ptr [ebp - local_4]           # 00464a57
    shl eax, 0x5                                 # 00464a5a
    mov ecx, dword ptr [ebp - local_8]           # 00464a5d
    cmp edx, dword ptr [ecx + eax + field_6d]    # 00464a60
    jg.d8 L_00464aa8                             # 00464a64
    # block 0x00464a66: entered by fall-through of jg at 0x00464a64, 6 instruction(s), ends with jl to 0x00464aa8 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00464a66
    mov eax, dword ptr [ebp - local_4]           # 00464a6a
    shl eax, 0x5                                 # 00464a6d
    mov ecx, dword ptr [ebp - local_8]           # 00464a70
    cmp edx, dword ptr [ecx + eax + field_61]    # 00464a73
    jl.d8 L_00464aa8                             # 00464a77
    # block 0x00464a79: entered by fall-through of jl at 0x00464a77, 6 instruction(s), ends with jg to 0x00464aa8 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00464a79
    mov eax, dword ptr [ebp - local_4]           # 00464a7d
    shl eax, 0x5                                 # 00464a80
    mov ecx, dword ptr [ebp - local_8]           # 00464a83
    cmp edx, dword ptr [ecx + eax + field_69]    # 00464a86
    jg.d8 L_00464aa8                             # 00464a8a
    # block 0x00464a8c: entered by fall-through of jg at 0x00464a8a, 8 instruction(s), calls FUN_00464ab5, ends with forward jump to 0x00464aaf
    mov edx, dword ptr [ebp - local_c]           # 00464a8c
    mov ax, word ptr [edx + field_36]            # 00464a8f
    push eax                                     # 00464a93
    push 0x27c9                                  # 00464a94
    mov ecx, dword ptr [ebp - local_c]           # 00464a99
    call FUN_00464ab5                            # 00464a9c
    mov eax, 0x1                                 # 00464aa1
    jmp.d8 L_00464aaf                            # 00464aa6
L_00464aa8:
    # block 0x00464aa8: entered by je at 0x00464a2e; je at 0x00464a3e; jl at 0x00464a51; jg at 0x00464a64; more, 1 instruction(s), ends with backward jump to 0x0046499c
    jmp.d32 L_0046499c                           # 00464aa8
L_00464aad:
    # block 0x00464aad: entered by je at 0x004647bb; jge at 0x004649a9, 1 instruction(s), falls into the block at 0x00464aaf
    {load} xor eax, eax                          # 00464aad
L_00464aaf:
    # block 0x00464aaf: entered by jmp at 0x004648a2; jmp at 0x004648f0; jmp at 0x00464939; jmp at 0x0046498e; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00464aaf
    pop ebp                                      # 00464ab1
    ret 0xc                                      # 00464ab2

